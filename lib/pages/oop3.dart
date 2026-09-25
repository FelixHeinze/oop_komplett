import 'package:flutter/material.dart';
import '../models/triangle.dart';

class Oop3Page extends StatefulWidget {
  const Oop3Page({super.key});

  @override
  State<Oop3Page> createState() => _Oop3PageState();
}

class _Oop3PageState extends State<Oop3Page> {
  final Triangle triangle = Triangle.inCentimeters(width: 10, height: 5);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoCard(
          title: 'OOP 3',
          subtitle: 'Getter und Setter',
          text: 'Width und height sind gekapselt. getter liefern Werte in verschiedenen MeasurementSystemsund setter erlauben das Ändern derselben Werte.',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Aktuelles Triangle', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _row('Breite in mm', triangle.widthInMillimeters),
              _row('Breite in cm', triangle.widthInCentimeters),
              _row('Breite in m', triangle.widthInMeters),
              _row('Breite in inch', triangle.widthInInches),
              _row('Breite in feet', triangle.widthInFeet),
              const Divider(),
              /* seite greift nicht auf _widthInMillimeters zu sie verwendet öffentliche getter
               dadurch kann widthInCentimeters .... lesen ohne zu wissen wie der wert in Triangle intern gespeichert wird
               */
              _row('Höhe in mm', triangle.heightInMillimeters),
              _row('Höhe in cm', triangle.heightInCentimeters),
              _row('Höhe in m', triangle.heightInMeters),
              _row('Höhe in inch', triangle.heightInInches),
              _row('Höhe in feet', triangle.heightInFeet),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () {
            setState(() {
              triangle.widthInCentimeters += 1;
              triangle.heightInCentimeters += 1;
            }); // bspw erhöhung um 1 cm muss man nicht selbst ausrechnen setter übernimmt das
          },
          icon: const Icon(Icons.add),
          label: const Text('Breite und Höhe um 1 cm erhöhen'),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Kapselung',
          subtitle: 'Private interne Werte',
          text: 'Die Werte _widthInMillimeters und _heightInMillimeters sind privat. Zugriff erfolgt kontrolliert über gGetter und setter.',
        ),
      ],
    );
  }

  Widget _row(String label, double value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label),
      Text(value.toStringAsFixed(2)),
    ]),
  );
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
/* Kapselung bedeutet hier interne darstellung wird verborgen, außenstehende klassen 
greifen über getter und setter auf diese interne darstellung zu 
die umrechnung und speicherung bleibt also in triangle*/