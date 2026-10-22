
import 'package:flutter/material.dart';
import '../services/shop_api.dart';

class DatenUebersichtPage extends StatefulWidget {
  const DatenUebersichtPage({super.key});

  @override
  State<DatenUebersichtPage> createState() => _DatenUebersichtPageState();
}

class _DatenUebersichtPageState extends State<DatenUebersichtPage> {
  final ShopApi _api = ShopApi.instance;

  // Dropdown-Werte: action ist der API-Endpunkt, label der sichtbare Name.
  static const Map<String, String> _tables = {
    'products': 'Produkte',
    'db_kunden': 'Kunden',
    'db_hersteller': 'Hersteller',
    'db_bestellungen': 'Historische Bestellungen',
    'db_bestellpositionen': 'Bestellpositionen',
  };

  String _selectedTable = 'db_kunden';
  late Future<List<Map<String, dynamic>>> _rows;

  @override
  void initState() {
    super.initState();
    _rows = _api.databaseTable(_selectedTable);
  }

  void _loadTable(String action) {
    setState(() {
      _selectedTable = action;
      _rows = _api.databaseTable(action);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weitere Datenbankdaten'),
        actions: [
          IconButton(
            tooltip: 'Aktuelle Tabelle neu laden',
            onPressed: () => _loadTable(_selectedTable),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tabelle auswählen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedTable,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.table_chart_outlined),
              ),
              items: _tables.entries
                  .map((entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) _loadTable(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _rows,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 40),
                          const SizedBox(height: 8),
                          Text('Daten konnten nicht geladen werden:\n${snapshot.error}',
                              textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          FilledButton.icon(
                            onPressed: () => _loadTable(_selectedTable),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Erneut versuchen'),
                          ),
                        ],
                      ),
                    );
                  }

                  final rows = snapshot.data ?? [];
                  if (rows.isEmpty) {
                    return Center(
                      child: Text('Keine Datensätze in „${_tables[_selectedTable]}“.',
                          textAlign: TextAlign.center),
                    );
                  }

                  // Die Spalten werden aus den Schlüsseln der ersten Datenzeile
                  // abgeleitet, damit dieselbe Ansicht alle Tabellen darstellen kann.
                  final columns = rows.first.keys.toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_tables[_selectedTable]}: ${rows.length} Datensätze',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  columns: columns
                                      .map((key) => DataColumn(
                                            label: Text(key,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold)),
                                          ))
                                      .toList(),
                                  rows: rows
                                      .map((row) => DataRow(
                                            cells: columns
                                                .map((key) => DataCell(
                                                      SelectableText(
                                                        row[key]?.toString() ?? '',
                                                      ),
                                                    ))
                                                .toList(),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
