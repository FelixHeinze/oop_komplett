import 'package:flutter/material.dart';
import '../models/teilnehmer.dart';

class Oop1Page extends StatelessWidget {
  const Oop1Page({super.key});
// klasse bauen und objekte erzeugen für oop1 
  @override
  Widget build(BuildContext context) {
    final people = [
      Teilnehmer(
        nachname: 'Felix',
        vorname: 'Heinze',
        geschlecht: Geschlecht.maennlich,
        geburtstag: DateTime(1993, 9, 12),
        abschlussnote: 1.7,
      ),
      Teilnehmer(
        nachname: 'Nachname',
        vorname: 'Anna',
        geschlecht: Geschlecht.weiblich,
      ),
      Teilnehmer(
        nachname: 'Test',
        vorname: 'Alex',
        geschlecht: Geschlecht.divers,
        abschlussnote: 2.3,
      ),
    ];
 // beispielmenschen 
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoCard(
          title: 'OOP 1',
          subtitle: 'Klassen, Konstruktoren und Konstruktion',
          text: 'Die Aufgabe fordert eine Teilnehmer-Klasse. Anschließend werden mehrere teilnehmer o bjekte erstellt und ihre eigenschaften ausgegeben.',
        ),
        const SizedBox(height: 12),
        ...people.map((p) => Card( // kurze beschreibung oberhalb der aufgabe um bei bedarf immer wieder reinzuschauen 
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text('${p.vorname} ${p.nachname}'),
            subtitle: Text(
              'Geschlecht: ${p.geschlecht.name}'
              '${p.geburtstag != null ? '\nGeburtstag: ${_date(p.geburtstag!)}' : ''}'
              '${p.abschlussnote != null ? '\nAbschlussnote: ${p.abschlussnote}' : ''}',
            ),
          ),
        )),
        const SizedBox(height: 12),
        _CodeCard(code: '''final person = Teilnehmer(
  nachname: 'Muster',
  vorname: 'Max',
  geschlecht: Geschlecht.maennlich,
  geburtstag: DateTime(2000, 5, 12),
  abschlussnote: 1.7,
);'''),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'OOP-Konzept',
          subtitle: 'Klasse und Objekt',
          text: 'Teilnehmer ist die Klasse. Felix, Anna und Alex sind konkrete Objekte dieser Klasse. nullable Attribute können bewusst nicht gesetzt werden.',
        ),
      ],
    );
  }

  static String _date(DateTime d) => '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}

class _InfoCard extends StatelessWidget {
  final String title, subtitle, text;
  const _InfoCard({required this.title, required this.subtitle, required this.text});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        Text(text),
      ]),
    ),
  );
}

class _CodeCard extends StatelessWidget {
  final String code;
  const _CodeCard({required this.code});

  @override
  Widget build(BuildContext context) => Card(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Text(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
    ),
  );
}
