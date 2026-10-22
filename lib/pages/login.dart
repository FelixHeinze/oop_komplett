// Die Seite sammelt E-Mail und Passwort, prüft einfache Eingabeformate und
// sendet die Daten über ShopApi an den PHP-Endpunkt "login".
// Die eigentliche Passwortprüfung findet serverseitig in PHP statt. Dort wird
// der gespeicherte Passwort-Hash mit password_verify geprüft; Flutter darf
// niemals das Passwort selbst mit der Datenbank vergleichen.
// Nach erfolgreicher Anmeldung speichert ShopApi das Sitzungstoken im Speicher
// und die Seite navigiert zum Benutzerkonto.
// TextEditingController müssen in dispose() freigegeben werden, damit sie nach
// dem Entfernen des Widgets keine Ressourcen behalten.

import 'package:flutter/material.dart';
import '../services/shop_api.dart';
import 'userOverwiev.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // FormState ermöglicht, alle Validatoren vor dem Absenden auszuführen.
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Erst validieren, dann API aufrufen. _busy sperrt den Button währenddessen.
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ShopApi.instance.login(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const UserOverwievPage()));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      // mounted verhindert setState, wenn die Seite inzwischen geschlossen wurde.
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Anmelden')),
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.account_circle, size: 72),
          const SizedBox(height: 16),
          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'E-Mail', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()),
            validator: (v) => v == null || !v.contains('@') ? 'Bitte gültige E-Mail eingeben.' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _password, obscureText: _hidePassword,
            decoration: InputDecoration(labelText: 'Passwort', prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(), suffixIcon: IconButton(
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
                icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off))),
            validator: (v) => v == null || v.isEmpty ? 'Bitte Passwort eingeben.' : null,
            onFieldSubmitted: (_) => _login()),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: _busy ? null : _login,
            child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Anmelden'))),
        ]),
      )),
    )),
  );
}
