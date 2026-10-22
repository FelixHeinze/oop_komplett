
// Die PHP-API ermittelt den Nutzer anhand des Bearer-Tokens. Flutter sendet
// also nicht einfach eine beliebige Nutzer-ID, die manipuliert werden könnte.
// FutureBuilder zeigt während des Ladens einen Ladeindikator, nach einem Fehler
// eine Fehlermeldung und nach erfolgreichem Laden die Daten.

import 'package:flutter/material.dart';
import '../services/shop_api.dart';
import 'login.dart';
import 'dbOverwiev.dart';

class UserOverwievPage extends StatefulWidget {
  const UserOverwievPage({super.key});
  @override
  State<UserOverwievPage> createState() => _UserOverwievPageState();
}

class _UserOverwievPageState extends State<UserOverwievPage> {
  final api = ShopApi.instance;
  late Future<Map<String, dynamic>> _profile;
  late Future<List<Map<String, dynamic>>> _orders;

  @override
  void initState() {
    super.initState();
    // Profil und Bestellungen werden unabhängig geladen.
    _profile = api.profile();
    _orders = api.orders();
  }

  // Serverseitiges Token löschen, danach zurück zur Shop-Übersicht.
  Future<void> _logout() async {
    await api.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DbOverwiev()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (api.token == null) {
      return Scaffold(appBar: AppBar(title: const Text('Benutzerkonto')), body: Center(
        child: FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
          child: const Text('Bitte anmelden')),
      ));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Mein Benutzerkonto'), actions: [
        IconButton(tooltip: 'Abmelden', onPressed: _logout, icon: const Icon(Icons.logout)),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: FutureBuilder<Map<String, dynamic>>(
          future: _profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const LinearProgressIndicator();
            if (snapshot.hasError) return Text('Profil konnte nicht geladen werden: ${snapshot.error}');
            final p = snapshot.data!;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.account_circle, size: 56),
              const SizedBox(height: 8),
              Text(p['name'].toString(), style: Theme.of(context).textTheme.headlineSmall),
              Text(p['email'].toString()),
              const SizedBox(height: 8),
              const Text('Angemeldetes Benutzerkonto'),
            ]);
          },
        ))),
        const SizedBox(height: 16),
        Text('Meine Bestellungen', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _orders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Text('Bestellungen konnten nicht geladen werden: ${snapshot.error}');
            final orders = snapshot.data ?? [];
            if (orders.isEmpty) return const Card(child: ListTile(
              leading: Icon(Icons.receipt_long), title: Text('Noch keine Bestellungen'),
              subtitle: Text('Deine abgeschlossenen Käufe erscheinen hier.')));
            return Column(children: orders.map((o) => Card(child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text('Bestellung #${o['order_id']}'),
              subtitle: Text('Datum: ${o['order_date']} · Status: ${o['status']}'),
              trailing: Text('${(double.tryParse(o['total'].toString()) ?? 0).toStringAsFixed(2)} €'),
            ))).toList());
          },
        ),
      ]),
    );
  }
}
