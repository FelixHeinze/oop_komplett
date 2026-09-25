import 'package:flutter/material.dart';
import '../models/triangle.dart';

class Oop2Page extends StatelessWidget {
  const Oop2Page({super.key});

  @override
  Widget build(BuildContext context) {
    final triangles = [
      Triangle.inMillimeters(width: 50, height: 20),
      Triangle.inCentimeters(width: 10, height: 5),
      Triangle.inMeters(width: 0.5, height: 0.2),
      Triangle.inInches(width: 4, height: 2),
      Triangle.inFeet(width: 2, height: 1),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoCard(
          title: 'OOP 2',
          subtitle: 'Benannte Konstruktoren und Enums',
          text: 'Triangle kann in mm, cm, dm, m, inch und feet erzeugt werdenund intern werden alle Werte in Millimetern gespeichert.',
        ),
        const SizedBox(height: 12),
        ...triangles.map((t) => Card(
          child: ListTile(
            leading: const Icon(Icons.change_history),
            title: Text('Breite: ${t.widthInMillimeters.toStringAsFixed(2)} mm'),
            subtitle: Text('Höhe: ${t.heightInMillimeters.toStringAsFixed(2)} mm'),
          ),
        )),
        const SizedBox(height: 12),
        _CodeCard(code: '''Triangle.inCentimeters(
  width: 10,
  height: 5,
);

Triangle.inFeet(
  width: 2,
  height: 1,
);'''),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'MeasurementSystem',
          subtitle: 'Enum mit Umrechnungsfaktor',
          text: 'Jeder Enum-Wert kennt seinen Faktor zu Millimetern. Damit steht die Information über die Umrechnung nur an einer Stelle.',
        ),
      ],
    );
  }
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
        Text(subtitle),
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
