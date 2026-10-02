import 'dart:math';
import 'package:flutter/material.dart';
import '../models/teilnehmer.dart';
///klasse Zutrittsberechtigung erzeugt einen zufälligen code für jeden teilnehmer
class Zutrittsberechtigung {
  /// code ist eine zufällige 10-stellige zahl, die jedem Teilnehmer zugeordnet wird
  final int code;
  /// Konstruktor für die Klasse Zutrittsberechtigung, der einen zufälligen "code" generiert
  Zutrittsberechtigung() : code = 1000000000 + Random().nextInt(900000000);
}
// automatische zufallszahl erzeugen für code 
/// oop4 teilnehmer erweitert klasse teilnehmer um zutritsberechtigung erbt aber alle andere vorher
class Oop4Teilnehmer extends Teilnehmer {
  /// Zutrittsberechtigung ist eine Instanz der Klasse Zutrittsberechtigung, die jedem Teilnehmer zugeordnet wird
  final Zutrittsberechtigung zutrittsberechtigung;
// oop4 teilnehmer erweitert klasse teilnehmer um zutritsberechtigung erbt aber alle andere vorher 
//definierten sachen ( name usw )
/// Konstruktor für die Klasse Oop4Teilnehmer, der die erforderlichen Eigenschaften an den Konstruktor der Basisklasse Teilnehmer weitergibt und eine neue Zutrittsberechtigung erstellt
  Oop4Teilnehmer({
    required super.nachname,
    required super.vorname,
    required super.geschlecht,
    super.geburtstag,
    super.abschlussnote,
  }) : zutrittsberechtigung = Zutrittsberechtigung();
}
/* ein kurs hat einen namen und eine liste von teilnehmern mit add teilnehmer kann man einen
teilnehmer zur liste hinzufügen*/
/// klasse kurs hat name und liste von teilnehmern
class Kurs {
  /// name ist der Name des Kurses
  final String name;
  /// teilnehmer ist eine Liste von Oop4Teilnehmern, die dem Kurs zugeordnet sind
  final List<Oop4Teilnehmer> teilnehmer;
/// Konstruktor für die Klasse Kurs, der den Namen des Kurses und optional eine Liste von Teilnehmern entgegennimmtw enn keine liste von Teilnehmern angegeben wird, wird eine leere Liste erstellt.
  Kurs({required this.name, List<Oop4Teilnehmer>? teilnehmer})
      : teilnehmer = teilnehmer ?? [];
/// Methode zum Hinzufügen eines Teilnehmers zur Liste der Teilnehmer des Kurses
  void addTeilnehmer(Oop4Teilnehmer person) => teilnehmer.add(person);
}
/// klasse cdemy hat name und liste von kursen, die kurse wiederum haben eine liste von teilnehmern
class Cdemy {
  /// name ist der Name der cdemy
  final String name;
  /// kurse ist eine Liste von Kursen, die der cdemy zugeordnet sind
  final List<Kurs> kurse;
/// Konstruktor für die Klasse Cdemy, der den Namen der cdemy und optional eine Liste von Kursen entgegennimmt. Wenn keine Liste von Kursen angegeben wird, wird eine leere Liste erstellt.
  Cdemy({this.name = 'cdemy', List<Kurs>? kurse})
      : kurse = kurse ?? [];
/// Methode zum Hinzufügen eines Kurses zur Liste der Kurse der cdemy
  void addKurs(Kurs kurs) => kurse.add(kurs);
}
/* cdemy entählt kurse : besitzt eine liste von kursen, ein kurs wiederum eine liste von 
teilnehmern --> verschahtelte objektbeziehung entsteht */
/// Oop4Page ist eine stateful widget klasse, die die cdemy, kurse und teilnehmer anzeigt
class Oop4Page extends StatefulWidget {
  /// Konstruktor für Oop4Page
  const Oop4Page({super.key});

  @override
  ///createState-Methode erstellt den Zustand für Oop4Page
  State<Oop4Page> createState() => _Oop4PageState();
}

class _Oop4PageState extends State<Oop4Page> {
  late final Cdemy cdemy; // spätere erzeugung durch late 

  @override
  void initState() {
    super.initState();

 /* zuerst wird ein kurs erstellt dann füge ich teilnehmer hinzu und danach wird ein zweiter kurs erstellt
 DANACH (late) wird cdemy erstellt und die kurse hinzugefügt*/
    final dart = Kurs(name: 'Dart Grundlagen');
    dart.addTeilnehmer(Oop4Teilnehmer(
      nachname: 'Heinze',
      vorname: 'Felix',
      geschlecht: Geschlecht.maennlich,
    ));
    dart.addTeilnehmer(Oop4Teilnehmer(
      nachname: 'Nachname',
      vorname: 'Anna',
      geschlecht: Geschlecht.weiblich,
    ));

    final flutter = Kurs(name: 'Flutter');
    flutter.addTeilnehmer(Oop4Teilnehmer(
      nachname: 'Test',
      vorname: 'Alex',
      geschlecht: Geschlecht.divers,
    ));

    cdemy = Cdemy();
    cdemy.addKurs(dart);
    cdemy.addKurs(flutter);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('OOP 4', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text('Komposition und Aggregation', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              const Text(
                'Die cdemy hat mehrere Kurse. Jeder Kurs enthält mehrere Teilnehmer. '
                'Jeder Teilnehmer besitzt zusätzlich eine eigene Zutrittsberechtigung mit Zufallswert.',
              ),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        ...cdemy.kurse.map((kurs) => Card(
          child: ExpansionTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(kurs.name),
            subtitle: Text('${kurs.teilnehmer.length} Teilnehmer'),
            children: kurs.teilnehmer.map((p) => ListTile(
              leading: const Icon(Icons.person),
              title: Text('${p.vorname} ${p.nachname}'),
              subtitle: Text(
                'Geschlecht: ${p.geschlecht.name}\n'
                'Zutrittscode: ${p.zutrittsberechtigung.code}',
              ),
            )).toList(),
          ),
        )),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'cdemy\n  └── Kurs\n       └── Teilnehmer\n            └── Zutrittsberechtigung',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ),
      ],
    );
  }
}

/* optische darstellung wieder als übungszeck um auch die gui sauberer zu bauen 

*/ 
