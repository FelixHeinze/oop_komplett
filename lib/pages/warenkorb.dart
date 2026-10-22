
import 'package:flutter/material.dart';
import '../services/shop_api.dart';
import 'login.dart';

class WarenkorbPage extends StatefulWidget {
  const WarenkorbPage({super.key});
  @override
  State<WarenkorbPage> createState() => _WarenkorbPageState();
}

class _WarenkorbPageState extends State<WarenkorbPage> {
  final api = ShopApi.instance;
  late Future<List<Map<String, dynamic>>> _cart;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _cart = api.cart();
  }

  void _reload() => setState(() => _cart = api.cart());

  // quantity <= 0 bedeutet hier: Position löschen. Sonst Menge aktualisieren.
  Future<void> _change(Map<String, dynamic> item, int quantity) async {
    setState(() => _busy = true);
    try {
      final id = int.parse(item['cart_item_id'].toString());
      if (quantity <= 0) {
        await api.removeCartItem(id);
      } else {
        await api.updateCartItem(id, quantity);
      }
      _reload();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // Die eigentliche Bestellung wird in einer serverseitigen DB-Transaktion erstellt.
  Future<void> _checkout() async {
    setState(() => _busy = true);
    try {
      final result = await api.checkout();
      if (!mounted) return;
      await showDialog<void>(context: context, builder: (context) => AlertDialog(
        title: const Text('Bestellung abgeschlossen'),
        content: Text('Deine Bestellnummer lautet ${result['order_id']}.'),
        actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ));
      _reload();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (api.token == null) {
      return Scaffold(appBar: AppBar(title: const Text('Warenkorb')), body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.lock_outline, size: 48),
          const Text('Bitte anmelden, um deinen Warenkorb zu sehen.'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
              // Nach erfolgreichem Login den Warenkorb mit dem neuen Token laden.
              if (mounted && api.token != null) _reload();
            },
            child: const Text('Anmelden'),
          ),
        ]),
      ));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Mein Warenkorb'), actions: [IconButton(onPressed: _reload, icon: const Icon(Icons.refresh))]),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Fehler: ${snapshot.error}'));
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const Center(child: Text('Dein Warenkorb ist leer.'));
          // fold addiert für jede Position Preis * Menge zur angezeigten Summe.
          // Der Server berechnet den endgültigen Betrag beim Checkout unabhängig neu.
          final total = items.fold<double>(0, (sum, item) =>
            sum + (double.tryParse(item['Preis'].toString()) ?? 0) * (int.tryParse(item['quantity'].toString()) ?? 0));
          return Column(children: [
            Expanded(child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final item = items[index];
                final qty = int.tryParse(item['quantity'].toString()) ?? 1;
                final price = double.tryParse(item['Preis'].toString()) ?? 0;
                return ListTile(
                  title: Text(item['P_Bez'].toString()),
                  subtitle: Text('${price.toStringAsFixed(2)} € pro Stück · ${(price * qty).toStringAsFixed(2)} €'),
                  leading: IconButton(onPressed: _busy ? null : () => _change(item, qty - 1), icon: const Icon(Icons.remove_circle_outline)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('$qty'),
                    IconButton(onPressed: _busy ? null : () => _change(item, qty + 1), icon: const Icon(Icons.add_circle_outline)),
                    IconButton(tooltip: 'Entfernen', onPressed: _busy ? null : () => _change(item, 0), icon: const Icon(Icons.delete_outline)),
                  ]),
                );
              },
            )),
            SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              Expanded(child: Text('Gesamt: ${total.toStringAsFixed(2)} €', style: Theme.of(context).textTheme.titleLarge)),
              FilledButton(onPressed: _busy ? null : _checkout, child: Text(_busy ? 'Bitte warten…' : 'Jetzt bestellen')),
            ]))),
          ]);
        },
      ),
    );
  }
}
