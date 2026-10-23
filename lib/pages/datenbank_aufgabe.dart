import 'dart:convert'; // Wandelt die JSON-Antwort der PHP-API in Dart-Objekte um.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Sendet HTTP-GET-Anfragen an XAMPP.


class DatenbankAufgabe extends StatefulWidget {
  const DatenbankAufgabe({super.key});

  @override
  State<DatenbankAufgabe> createState() => _DatenbankAufgabeState();
}

class _DatenbankAufgabeState extends State<DatenbankAufgabe> {
  // Für jede sichtbare Tabellenbezeichnung wird der gleichnamige API-Parameter genutzt.
  static const Map<String, String> _tabellen = {
    'Kunden': 'Kunden',
    'Produkte': 'Produkte',
    'Hersteller': 'Hersteller',
    'Bestellungen': 'Bestellungen',
    'Bestellpositionen': 'Bestellpositionen',
  };

  // Für Flutter unter Windows und XAMPP auf demselben PC ist localhost richtig.
  // Die Datei api.php liegt laut Anleitung direkt in C:\xampp\htdocs.
  static const String _apiBasisUrl = 'http://localhost/api.php';

  String _ausgewaehlteTabelle = 'Produkte';
  late Future<List<Map<String, dynamic>>> _datenFuture;

  @override
  void initState() {
    super.initState();
    // initState lädt die erste Tabelle, sobald die Seite geöffnet wird.
    _datenFuture = _ladeTabelle(_ausgewaehlteTabelle);
  }

  /// Holt die ausgewählte Tabelle über den GET-Parameter "tabelle".
  /// Fehler werden an den FutureBuilder weitergegeben und dort angezeigt.
  Future<List<Map<String, dynamic>>> _ladeTabelle(String tabelle) async {
    final uri = Uri.parse(_apiBasisUrl).replace(
      queryParameters: {'tabelle': tabelle},
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    final dynamic jsonAntwort = jsonDecode(response.body);
    if (jsonAntwort is! List) {
      throw Exception('Die API hat keine Liste zurückgegeben: ${response.body}');
    }

    // Jede Zeile wird als Map gespeichert: Spaltenname -> Wert.
    return jsonAntwort
        .map((zeile) => Map<String, dynamic>.from(zeile as Map))
        .toList();
  }

  /// Wechselt die Tabelle und setzt synchron nur das neue Future.
  /// Das eigentliche Laden läuft asynchron außerhalb von setState.
  void _tabelleAuswaehlen(String? neueTabelle) {
    if (neueTabelle == null) return;
    setState(() {
      _ausgewaehlteTabelle = neueTabelle;
      _datenFuture = _ladeTabelle(neueTabelle);
    });
  }

  /// Aktualisiert dieselbe Tabelle erneut, z. B. über den Refresh-Button.
  void _aktualisieren() {
    setState(() {
      _datenFuture = _ladeTabelle(_ausgewaehlteTabelle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Datenbankübersicht – Aufgabe 5',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
          'Wähle eine Tabelle aus. Die Daten werden über die PHP-API aus MariaDB '
          'geladen und als JSON in dieser Seite dargestellt.',
        ),
        const SizedBox(height: 16),
        // Das Datenbankdiagramm aus der Aufgaben-/Projektdatei wird direkt angezeigt.
        Card(
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            leading: const Icon(Icons.account_tree_outlined),
            title: const Text('Datenbankdiagramm (3NF)'),
            subtitle: const Text('Zum Ein- und Ausklappen anklicken'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'lib/assets/online_shop_datenbank_diagramm.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Diagrammbild fehlt. Bitte Asset-Pfad prüfen.'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _ausgewaehlteTabelle,
          decoration: const InputDecoration(
            labelText: 'Tabelle auswählen',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.table_chart_outlined),
          ),
          items: _tabellen.keys
              .map((name) => DropdownMenuItem(value: name, child: Text(name)))
              .toList(),
          onChanged: _tabelleAuswaehlen,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _aktualisieren,
            icon: const Icon(Icons.refresh),
            label: const Text('Daten aktualisieren'),
          ),
        ),
        const SizedBox(height: 8),
        // FutureBuilder reagiert auf Laden, Erfolg und Fehler, ohne manuelles setState.
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _datenFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Daten konnten nicht geladen werden.\n${snapshot.error}\n\n'
                    'Prüfe, ob Apache und MySQL laufen und '
                    'http://localhost/api.php?tabelle=Produkte im Browser funktioniert.',
                  ),
                ),
              );
            }

            final zeilen = snapshot.data ?? [];
            if (zeilen.isEmpty) return const Text('Diese Tabelle enthält keine Datensätze.');

            // Spaltennamen werden aus der ersten Zeile abgeleitet.
            final spalten = zeilen.first.keys.toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_tabellen[_ausgewaehlteTabelle]}: ${zeilen.length} Datensätze',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                // Horizontal scrollen, weil Tabellen unterschiedlich viele Spalten haben.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: spalten
                        .map((spalte) => DataColumn(label: Text(spalte)))
                        .toList(),
                    rows: zeilen
                        .map((zeile) => DataRow(
                              cells: spalten
                                  .map((spalte) => DataCell(
                                        SelectableText('${zeile[spalte] ?? ''}'),
                                      ))
                                  .toList(),
                            ))
                        .toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
