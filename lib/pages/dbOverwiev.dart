
import 'package:flutter/material.dart';
import '../services/shop_api.dart';
import 'login.dart';
import 'reg.dart';
import 'warenkorb.dart';
import 'userOverwiev.dart';
import 'datenUebersicht.dart';

/// Shop-Übersicht: lädt Artikel über PHP und zeigt sie als Karten an.
class DbOverwiev extends StatefulWidget {
  const DbOverwiev({super.key});

  @override
  State<DbOverwiev> createState() => _DbOverwievState();
}

class _DbOverwievState extends State<DbOverwiev> {
  final api = ShopApi.instance;
  // Future hält den laufenden Ladeauftrag. FutureBuilder reagiert darauf.
  late Future<List<Map<String, dynamic>>> _products;

  @override
  void initState() {
    super.initState();
    // Einmal beim Öffnen der Seite laden; nicht bei jedem build neu anfragen.
    _products = api.products();
  }

void _reload() {
  setState(() {
    _products = api.products();
  });
}

  // Wird der Warenkorb-Button gedrückt, braucht der Nutzer ein Login.
  // Erst nach der Anmeldung darf die geschützte API-Operation ausgeführt werden.
  Future<void> _add(Map<String, dynamic> product) async {
    if (api.token == null) {
      final goLogin = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Anmeldung erforderlich'),
          content: const Text('Bitte melde dich an, um Artikel in den Warenkorb zu legen.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Später')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Zum Login')),
          ],
        ),
      );
      if (goLogin == true && mounted) {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
        if (mounted) setState(() {});
      }
      return;
    }
    try {
      await api.addToCart(product['P_Nr'].toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product['P_Bez']} wurde zum Warenkorb hinzugefügt.')),
      );
    } catch (e) {
      _showError(e);
    }
  }

  void _showError(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = api.token != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop – Artikelübersicht'),
        actions: [
          IconButton(tooltip: 'Warenkorb', onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const WarenkorbPage())),
            icon: const Icon(Icons.shopping_cart_outlined)),
          if (signedIn)
            IconButton(tooltip: 'Benutzerkonto', onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const UserOverwievPage())),
              icon: const Icon(Icons.account_circle_outlined))
          else
            IconButton(tooltip: 'Login', onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
              if (mounted) setState(() {});
            }, icon: const Icon(Icons.login)),
          IconButton(
            tooltip: 'Weitere Datenbankdaten anzeigen',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DatenUebersichtPage()),
            ),
            icon: const Icon(Icons.table_chart_outlined),
          ),
          IconButton(tooltip: 'Neu laden', onPressed: _reload, icon: const Icon(Icons.refresh)),
        ],
      ),
      // FutureBuilder bildet die drei typischen Zustände ab: Laden, Fehler, Daten.
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.cloud_off, size: 48),
                const SizedBox(height: 12),
                Text('Artikel konnten nicht geladen werden:\n${snapshot.error}', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton.icon(onPressed: _reload, icon: const Icon(Icons.refresh), label: const Text('Erneut versuchen')),
              ]),
            ));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) return const Center(child: Text('Keine Artikel vorhanden.'));
          // LayoutBuilder kennt die Fensterbreite und wählt passend viele Spalten.
          return LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth > 900 ? 3 : constraints.maxWidth > 600 ? 2 : 1;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns, crossAxisSpacing: 12, mainAxisSpacing: 12,
                childAspectRatio: columns == 1 ? 3.3 : 1.8,
              ),
              itemCount: products.length,
              // itemBuilder erzeugt eine Produktkarte für den jeweiligen Index.
              itemBuilder: (context, index) {
                final p = products[index];
                final price = double.tryParse(p['Preis'].toString()) ?? 0;
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p['P_Bez']?.toString() ?? 'Artikel',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Text('Hersteller: ${p['Hersteller'] ?? 'Unbekannt'}',
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Text('${price.toStringAsFixed(2)} €',
                        style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      SizedBox(width: double.infinity, child: FilledButton.icon(
                        onPressed: () => _add(p),
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('In den Warenkorb'),
                      )),
                    ]),
                  ),
                );
              },
            );
          });
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const RegPage())),
            child: const Text('Neues Konto registrieren')),
          if (signedIn)
            TextButton(onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const UserOverwievPage())),
              child: const Text('Mein Konto')),
        ]),
      ),
    );
  }
}
