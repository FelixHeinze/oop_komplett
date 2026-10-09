import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/counter_state_provider.dart';

/// Eigenständige Lernseite zur Aufgabe „Ein Problem, vier Lösungen“.
/// Diese Variante demonstriert Global State mit Riverpod.
class EinProblemVierLoesungenPage extends ConsumerWidget {
  const EinProblemVierLoesungenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch abonniert den State. Bei Änderungen wird dieses Widget neu gebaut.
    final counters = ref.watch(counterProvider);

    // read greift auf den Notifier zu, ohne selbst ein Rebuild-Abonnement
    // für den Notifier anzulegen. Über ihn lösen die Buttons Änderungen aus.
    final actions = ref.read(counterProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ein Problem, vier Lösungen',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text(
                  'Vier Counter liegen in einem 2×2-Raster. Die Buttons '
                  'verändern immer den diagonal gegenüberliegenden Counter. '
                  'Die Titelleiste zeigt die Summe aller vier Werte.',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Riverpod-Beispiel: Der State liegt außerhalb der Widgets '
                  'im Provider. Dadurch können alle Quadranten auf denselben '
                  'Zustand zugreifen, ohne Funktionen und Werte durch jede '
                  'Widget-Ebene weiterreichen zu müssen.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('Gesamtsumme', style: TextStyle(fontWeight: FontWeight.bold))),
                    Chip(label: Text('${counters.total}')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: _Quadrant(
                    title: 'Oben links', value: counters.topLeft,
                    changes: 'Buttons ändern unten rechts',
                    onIncrement: () => actions.increment(3),
                    onDecrement: () => actions.decrement(3),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _Quadrant(
                    title: 'Oben rechts', value: counters.topRight,
                    changes: 'Buttons ändern unten links',
                    onIncrement: () => actions.increment(2),
                    onDecrement: () => actions.decrement(2),
                  )),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: _Quadrant(
                    title: 'Unten links', value: counters.bottomLeft,
                    changes: 'Buttons ändern oben rechts',
                    onIncrement: () => actions.increment(1),
                    onDecrement: () => actions.decrement(1),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _Quadrant(
                    title: 'Unten rechts', value: counters.bottomRight,
                    changes: 'Buttons ändern oben links',
                    onIncrement: () => actions.increment(0),
                    onDecrement: () => actions.decrement(0),
                  )),
                ]),
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
                Text('Was macht Riverpod hier?', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                const Text('• ProviderScope in main.dart stellt Riverpod für die App bereit.'),
                const Text('• counterProvider ist der globale Zugriffspunkt auf den CounterState.'),
                const Text('• CounterState enthält die vier Werte und ist unveränderlich.'),
                const Text('• copyWith erzeugt bei Änderungen einen neuen Zustand.'),
                const Text('• CounterNotifier kapselt die Änderungslogik.'),
                const Text('• ref.watch(counterProvider) liest den State und aktualisiert die UI bei Änderungen.'),
                const Text('• ref.read(counterProvider.notifier) ruft Aktionen auf, z. B. beim Buttonklick.'),
                const SizedBox(height: 8),
                const Text(
                  'Vergleich: Ohne Riverpod muss State oft nach oben verschoben '
                  'und durch Zwischen-Widgets weitergereicht werden. Mit Riverpod '
                  'greifen die Widgets direkt auf den Provider zu. Riverpod-State '
                  'ist standardmäßig global verfügbar.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Wiederverwendbares, zustandsloses Widget für einen Quadranten.
/// Es erhält nur Anzeigewerte und Callback-Funktionen als Parameter.
class _Quadrant extends StatelessWidget {
  const _Quadrant({
    required this.title,
    required this.value,
    required this.changes,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String title;
  final int value;
  final String changes;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text('$value', style: Theme.of(context).textTheme.headlineMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: onIncrement, tooltip: 'Erhöhen', icon: const Icon(Icons.arrow_upward)),
                IconButton(onPressed: onDecrement, tooltip: 'Verringern', icon: const Icon(Icons.arrow_downward)),
              ],
            ),
            Text(changes, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
