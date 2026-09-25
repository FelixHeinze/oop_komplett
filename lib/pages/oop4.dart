import 'dart:math';
import 'package:flutter/material.dart';
import '../models/teilnehmer.dart';

class Zutrittsberechtigung {
  final int code;
  Zutrittsberechtigung() : code = 1000000000 + Random().nextInt(900000000);
}
// automatische zufallszahl erzeugen für code 
class Oop4Teilnehmer extends Teilnehmer {
  final Zutrittsberechtigung zutrittsberechtigung;
// oop4 teilnehmer erweitert klasse teilnehmer um zutritsberechtigung erbt aber alle andere vorher 
//definierten sachen ( name usw )
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
class Kurs {
  final String name;
  final List<Oop4Teilnehmer> teilnehmer;

  Kurs({required this.name, List<Oop4Teilnehmer>? teilnehmer})
      : teilnehmer = teilnehmer ?? [];

  void addTeilnehmer(Oop4Teilnehmer person) => teilnehmer.add(person);
}

class Cdemy {
  final String name;
  final List<Kurs> kurse;

  Cdemy({this.name = 'cdemy', List<Kurs>? kurse})
      : kurse = kurse ?? [];

  void addKurs(Kurs kurs) => kurse.add(kurs);
}
/* cdemy entählt kurse : besitzt eine liste von kursen, ein kurs wiederum eine liste von 
teilnehmern --> verschahtelte objektbeziehung entsteht */

class Oop4Page extends StatefulWidget {
  const Oop4Page({super.key});

  @override
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
