//bessere Dokumentation 
/// CoinStack repräsentiert einen Stapel von Münzen, wobei jede Münze durch ihren Wert als Ganzzahl dargestellt wird.
class CoinStack {
  final List<int> _coins;

  /// Erstellt einen CoinStack aus einer Liste von Münzwerten.
  CoinStack(List<int> coins) : _coins = List<int>.from(coins);

  /// Gibt die enthaltenen Münzen als nicht veränderbare Liste zurück.
  List<int> get coins => List.unmodifiable(_coins);

  /// Gibt den Gesamtwert dieses CoinStacks zurück.
  int get totalValue => _coins.fold(0, (sum, coin) => sum + coin);

  /// true, wenn dieser CoinStack mehr Wert hat als [other].
  bool operator >(CoinStack other) => totalValue > other.totalValue;

  /// true, wenn dieser CoinStack weniger Wert hat als [other].
  bool operator <(CoinStack other) => totalValue < other.totalValue;

  /// true, wenn dieser CoinStack mindestens so viel Wert hat wie [other].
  bool operator >=(CoinStack other) => totalValue >= other.totalValue;

  /// true, wenn dieser CoinStack höchstens so viel Wert hat wie [other].
  bool operator <=(CoinStack other) => totalValue <= other.totalValue;

  /// Zwei CoinStacks sind gleich, wenn sie denselben Gesamtwert haben.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CoinStack && totalValue == other.totalValue;
  }

  @override
  int get hashCode => totalValue.hashCode;

  /// Verbindet die Münzen beider CoinStacks zu einem neuen CoinStack.
  CoinStack operator +(CoinStack other) {
    return CoinStack([
      ..._coins,
      ...other._coins,
    ]);
  }

  /// Entfernt die Münzen aus [other] aus diesem CoinStack.
  /// Dabei wird jede Münze aus [other] einzeln berücksichtigt.
  /// Wenn nicht alle benötigten Münzen vorhanden sind, wird null zurückgegeben.
  CoinStack? operator -(CoinStack other) {
    final remaining = List<int>.from(_coins);

    for (final coin in other._coins) {
      final index = remaining.indexOf(coin);

      if (index == -1) {
        return null;
      }

      remaining.removeAt(index);
    }

    return CoinStack(remaining);
  }

  @override
  String toString() => 'CoinStack(${_coins.join(', ')})';
}