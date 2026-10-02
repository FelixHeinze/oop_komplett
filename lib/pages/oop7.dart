import 'package:flutter/material.dart';

import '../models/coinstack.dart';

/// OOP 7 – Operatoren mit CoinStack.
class Oop7Page extends StatelessWidget {
  /// Konstruktor für Oop7Page
  const Oop7Page({super.key});

  @override
  Widget build(BuildContext context) {
    final stackA = CoinStack([1, 2, 2, 5]);
    final stackB = CoinStack([2, 5]);
    final stackC = CoinStack([10, 10]);
    final added = stackA + stackB;
    final subtracted = stackA - stackB;

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
                  'OOP 7',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Operatoren – CoinStack',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'CoinStack speichert eine Liste von Münzwerten. '
                  'Die Operatoren vergleichen die Gesamtwerte oder erzeugen '
                  'einen neuen CoinStack.',
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
                  'CoinStacks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _stackRow('Stack A', stackA),
                _stackRow('Stack B', stackB),
                _stackRow('Stack C', stackC),
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
                  'Vergleichsoperatoren',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _resultRow('stackA > stackB', stackA > stackB),
                _resultRow('stackA < stackB', stackA < stackB),
                _resultRow('stackA >= stackB', stackA >= stackB),
                _resultRow('stackA <= stackB', stackA <= stackB),
                _resultRow('stackA == stackB', stackA == stackB),
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
                  'Plus-Operator +',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('stackA + stackB = ${_formatStack(added)}'),
                Text('Gesamtwert: ${added.totalValue}'),
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
                  'Minus-Operator -',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'stackA - stackB = '
                  '${subtracted == null ? 'null' : _formatStack(subtracted)}',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Beim Minus-Operator werden die Münzen aus dem zweiten '
                  'Stack einzeln aus dem ersten entfernt. Fehlt eine Münze, '
                  'ist das Ergebnis null.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _InfoCard(
          title: 'Was bedeutet Operator Overloading?',
          text:
              'Dart erlaubt es, Operatoren wie +, -, > oder == für eigene '
              'Klassen zu definieren. Dadurch kann sich ein CoinStack wie ein '
              'Werttyp verwenden lassen, obwohl er ein eigenes Objekt ist.',
        ),
        const SizedBox(height: 12),
        const _CodeCard(
          code: '''final stackA = CoinStack([1, 2, 2, 5]);
final stackB = CoinStack([2, 5]);

print(stackA > stackB);
final sum = stackA + stackB;
final difference = stackA - stackB;''',
        ),
      ],
    );
  }

  Widget _stackRow(String label, CoinStack stack) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${_formatStack(stack)} = ${stack.totalValue}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(String expression, bool result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(expression),
          Text(
            result.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static String _formatStack(CoinStack stack) {
    return '[${stack.coins.join(', ')}]';
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
