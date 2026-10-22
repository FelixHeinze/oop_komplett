// Nicht angemeldete Besucher können hier ein Benutzerkonto anlegen.
// Die Formularvalidierung prüft zuerst einfache Regeln in der App. Die API
// muss dieselben Regeln serverseitig ebenfalls prüfen, weil Client-Prüfungen
// umgangen werden können.
// Das Passwort wird als Klartext nur über die lokale HTTP-Anfrage übertragen;
// PHP speichert es als Hash, nicht als Klartext. 
// Controller werden in dispose() freigegeben. _busy verhindert, dass durch
// mehrfaches Klicken parallel mehrere Registrierungsanfragen gesendet werden.


import 'package:flutter/material.dart';
import '../services/shop_api.dart';

class RegPage extends StatefulWidget {
  const RegPage({super.key});
  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  bool _hide = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  // Registrierung nur starten, wenn alle Formularregeln erfüllt sind.
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ShopApi.instance.register(name: _name.text.trim(), email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konto erstellt. Du kannst dich jetzt anmelden.')));
      Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Konto registrieren')),
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(
        key: _formKey,
        child: Column(children: [
          const Icon(Icons.person_add_alt_1, size: 64),
          const SizedBox(height: 16),
          TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            validator: (v) => v == null || v.trim().length < 2 ? 'Bitte mindestens 2 Zeichen eingeben.' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'E-Mail', border: OutlineInputBorder()),
            validator: (v) => v == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim()) ? 'Bitte gültige E-Mail eingeben.' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _password, obscureText: _hide,
            decoration: InputDecoration(labelText: 'Passwort (mind. 8 Zeichen)', border: const OutlineInputBorder(),
              suffixIcon: IconButton(onPressed: () => setState(() => _hide = !_hide), icon: Icon(_hide ? Icons.visibility : Icons.visibility_off))),
            validator: (v) => v == null || v.length < 8 ? 'Das Passwort muss mindestens 8 Zeichen haben.' : null),
          const SizedBox(height: 12),
          // Zweite Passworteingabe verhindert Tippfehler bei der Registrierung.
          TextFormField(controller: _confirm, obscureText: true,
            decoration: const InputDecoration(labelText: 'Passwort wiederholen', border: OutlineInputBorder()),
            validator: (v) => v != _password.text ? 'Die Passwörter stimmen nicht überein.' : null),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: _busy ? null : _register,
            child: _busy ? const CircularProgressIndicator() : const Text('Registrieren'))),
        ]),
      )),
    )),
  );
}
