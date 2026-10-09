import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Unveränderlicher Zustand (State) für die vier Counter.
///
/// Riverpod empfiehlt immutable State: Statt einzelne Felder zu verändern,
/// wird mit [copyWith] ein neues CounterState-Objekt erzeugt.
class CounterState {
  final int topLeft;
  final int topRight;
  final int bottomLeft;
  final int bottomRight;

  const CounterState({
    this.topLeft = 7,
    this.topRight = 4,
    this.bottomLeft = 8,
    this.bottomRight = 25,
  });

  int get total => topLeft + topRight + bottomLeft + bottomRight;

  /// Erstellt einen neuen Zustand. Nicht angegebene Werte bleiben erhalten.
  CounterState copyWith({
    int? topLeft,
    int? topRight,
    int? bottomLeft,
    int? bottomRight,
  }) {
    return CounterState(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }

  // Equality: Zwei Zustände gelten als gleich, wenn alle Counter gleich sind.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterState &&
          topLeft == other.topLeft &&
          topRight == other.topRight &&
          bottomLeft == other.bottomLeft &&
          bottomRight == other.bottomRight;

  // Muss zu == passen, damit z. B. Sets und Maps korrekt funktionieren.
  @override
  int get hashCode => Object.hash(topLeft, topRight, bottomLeft, bottomRight);
}

/// Notifier: enthält die Aktionen, mit denen sich der Zustand ändern darf.
/// Der Notifier setzt jeweils einen neuen immutable CounterState.
class CounterNotifier extends Notifier<CounterState> {
  @override
  CounterState build() => const CounterState();

  /// quadrant bezeichnet den Counter, der geändert werden soll:
  /// 0 = oben links, 1 = oben rechts, 2 = unten links, 3 = unten rechts.
  void increment(int quadrant) => _change(quadrant, 1);
  void decrement(int quadrant) => _change(quadrant, -1);

  void _change(int quadrant, int inOrDec) {
    switch (quadrant) {
      case 0:
        state = state.copyWith(topLeft: state.topLeft + inOrDec);
        break;
      case 1:
        state = state.copyWith(topRight: state.topRight + inOrDec);
        break;
      case 2:
        state = state.copyWith(bottomLeft: state.bottomLeft + inOrDec);
        break;
      case 3:
        state = state.copyWith(bottomRight: state.bottomRight + inOrDec);
        break;
      default:
        throw RangeError.index(quadrant, [0, 1, 2, 3], 'quadrant');
    }
  }
}

/// Provider als globaler Zugriffspunkt auf den Zustand und seinen Notifier.
/// Widgets lesen den Zustand mit ref.watch und rufen Aktionen mit
/// ref.read(counterProvider.notifier) auf.
final counterProvider = NotifierProvider<CounterNotifier, CounterState>(
  CounterNotifier.new,
);
