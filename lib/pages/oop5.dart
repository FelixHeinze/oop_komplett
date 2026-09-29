import 'package:flutter/material.dart';

import '../models/triangle.dart';

class Oop5Page extends StatefulWidget {
  const Oop5Page({super.key});

  @override
  State<Oop5Page> createState() => _Oop5PageState();
}

class _Oop5PageState extends State<Oop5Page> {
  final Triangle triangle = Triangle.inCentimeters(
    width: 10,
    height: 5,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OOP 5',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Methoden',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Diese Aufgabe erweitert die Triangle-Klasse um '
                  'Methoden für Höhe und Fläche.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aktuelles Triangle',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _row(
                  'Breite',
                  '${triangle.widthInCentimeters.toStringAsFixed(2)} cm',
                ),
                _row(
                  'Höhe',
                  '${triangle.getHeight(MeasurementSystem.cm).toStringAsFixed(2)} cm',
                ),
                const Divider(),
                _row(
                  'Fläche',
                  '${triangle.areaInSquareCentimeters.toStringAsFixed(2)} cm²',
                ),
                _row(
                  'Fläche',
                  '${triangle.areaInSquareMeters.toStringAsFixed(4)} m²',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () {
            setState(() {
              triangle.setHeight(MeasurementSystem.cm, 8);
            });
          },
          icon: const Icon(Icons.height),
          label: const Text('Höhe auf 8 cm setzen'),
        ),
        const SizedBox(height: 12),
        const _InfoCard(
          title: 'getHeight(MeasurementSystem ms)',
          text:
              'Die Methode liest die intern in Millimetern gespeicherte '
              'Höhe aus und rechnet sie in das gewünschte Maßsystem um.',
        ),
        const SizedBox(height: 12),
        const _InfoCard(
          title: 'setHeight(MeasurementSystem ms, int value)',
          text:
              'Die Methode nimmt einen Wert und sein Maßsystem entgegen. '
              'Intern wird der Wert wieder in Millimeter gespeichert.',
        ),
        const SizedBox(height: 12),
        const _InfoCard(
          title: 'Area-Getter',
          text:
              'Die Fläche wird über einen gemeinsamen internen Rechenweg '
              'in Quadratmillimeter, Quadratzentimeter, Quadratmeter usw. '
              'ausgegeben.',
        ),
        const SizedBox(height: 12),
        const _CodeCard(
          code: '''triangle.setHeight(
  MeasurementSystem.cm,
  8,
);

print(triangle.getHeight(
  MeasurementSystem.m,
));

print(
  triangle.areaInSquareCentimeters,
);''',
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String text;

  const _InfoCard({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  final String code;

  const _CodeCard({
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: Text(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
