import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_to_json_page.dart';
import '../providers/todo_app_state_provider.dart';
import 'oop1.dart';
import 'oop2.dart';
import 'oop3.dart';
import 'oop4.dart';
import 'oop5.dart';
import 'oop6.dart';
import 'oop7.dart';
import 'ein_problem_vier_loesungen.dart';
import 'dbOverwiev.dart';



class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   // Record-Liste: Jeder Eintrag beschreibt Titel, Untertitel, Icon und Zielseite.
  // So kann die Oberfläche einheitlich aus einer Datenliste aufgebaut werden.

    final entries = <({
      String title,
      String subtitle,
      IconData icon,
      Widget page,
    })>[
      (
        title: 'OOP 1',
        subtitle: 'Klassen und Konstruktoren',
        icon: Icons.looks_one,
        page: const Oop1Page(),
      ),
      (
        title: 'OOP 2',
        subtitle: 'Benannte Konstruktoren und Enums',
        icon: Icons.looks_two,
        page: const Oop2Page(),
      ),
      (
        title: 'OOP 3',
        subtitle: 'Getter und Setter',
        icon: Icons.looks_3,
        page: const Oop3Page(),
      ),
      (
        title: 'OOP 4',
        subtitle: 'Komposition und Aggregation',
        icon: Icons.looks_4,
        page: const Oop4Page(),
      ),
      (
        title: 'OOP 5',
        subtitle: 'Methoden',
        icon: Icons.looks_5,
        page: const Oop5Page(),
      ),
      (
        title: 'OOP 6',
        subtitle: 'Vererbung',
        icon: Icons.looks_6,
        page: const Oop6Page(),
      ),
      (
        title: 'OOP 7',
        subtitle: 'Operatoren und CoinStack',
        icon: Icons.looks_one_outlined,
        page: const Oop7Page(),
      ),
      (
        title: 'Riverpod',
        subtitle: 'Ein Problem, vier Lösungen',
        icon: Icons.account_tree,
        page: const EinProblemVierLoesungenPage(),
      ),
      (
        title: 'Todo toJson',
        subtitle: 'Aufgabenliste mit JSON-Persistenz',
        icon: Icons.checklist,
        page: const TodoToJsonPage(),
      ),
      (
        title: 'Datenbank1',
        subtitle: 'Lösung mit Xampp',
        icon: Icons.date_range,
        page: dbOverwiev(), // test für xampp 
      ),
    ];
//beobachtet den App zustand damit Dark/light mode umgeschaltet werden kann
    final appState = ref.watch(todoAppStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OOP Übungen'),
        actions: [
          IconButton(
            //dark/lightmode symbol wird je nach Zustand angezeigt
            tooltip: 'Darkmode/Lightmode',
            icon: Icon(
              appState.value?.darkMode == true
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            // Während der Zustand noch nicht geladen ist, ist der Schalter deaktiviert.
            //nur aktiviert wenn geladen 
            onPressed: appState.hasValue
                ? () async {
                    final currentDarkMode =
                        appState.value?.darkMode ?? false;
//Provider Zustand umschalten um lokal zu speichern
                    await ref
                        .read(todoAppStateProvider.notifier)
                        .setDarkMode(!currentDarkMode);
                  }
                : null,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Willkommen!',
            //Typografie des aktuellen Themes wird übernommen,
             style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          
          const SizedBox(height: 16),
          //Datensatz für eine Karte wird erzeugt 
          ...entries.map(
            (entry) => Card(
              child: ListTile(
                leading: Icon(entry.icon),
                title: Text(entry.title),
                subtitle: Text(entry.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  //öffnen der übungsseite
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      //Neue Route bekommt Appbar mit Namen der Übung 
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          title: Text(entry.title),
                        ),
                        body: entry.page,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}