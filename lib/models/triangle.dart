/// enum für die verschiedenen Maßeinheiten die für die berechnung benutzt werden
enum MeasurementSystem {
  ///eintrag millimeter
  mm(1),
  ///eintrag zentimeter mit umrechung in millimeter
  cm(10),
  ///eintrag dezimeter mit umrechung in millimeter
  dm(100),
  ///eintrag meter mit umrechung in millimeter
  m(1000),
  ///eintrag inch mit umrechung in millimeter
  inch(25.4),
  ///eintrag feet mit umrechung in millimeter
  feet(304.8);

  const MeasurementSystem(this.millimetersPerUnit);
///konstruktor für die enum der den mm wert entgegenimmt und in der variable millimetersPerUnit speichert
  final double millimetersPerUnit;
}
///klasse triangle mit den eigenschaften width und height die in mm gespeichert werden
class Triangle {
  double _widthInMillimeters;
  double _heightInMillimeters;

  Triangle._fromMillimeters({
    required double width,
    required double height,
  })  : _widthInMillimeters = width,
        _heightInMillimeters = height;
/// zu OOP 2 der konstruktor für die klasse Triangle der die Breite und Höhe in einer bestimmten maßeinheit entgegennimmtvvvvv 
  factory Triangle({
    required double width,
    required double height,
    required MeasurementSystem system,
  }) =>
      Triangle._fromMillimeters(
        width: width * system.millimetersPerUnit,
        height: height * system.millimetersPerUnit,
      );
/// zu OOP 2: die factory konstruktoren für die verschiedenen maßeinheiten die den wert in mm umrechnen und an den privaten konstruktor weitergeben
  factory Triangle.inMillimeters({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.mm,
      );
/// OOP 2factory-Konstruktoren für die verschiedenen maßeinheiten die die Werte in mm umrechnen und an den privaten Konstruktor weitergeben
  factory Triangle.inCentimeters({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.cm,
      );
/// OOP 2factory-Konstruktoren für die verschiedenen maßeinheiten die die Werte in mm umrechnen und an den privaten Konstruktor weitergeben
  factory Triangle.inDecimeters({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.dm,
      );
/// OOP 2factory-Konstruktoren für die verschiedenen maßeinheiten die die Werte in mm umrechnen und an den privaten Konstruktor weitergeben
  factory Triangle.inMeters({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.m,
      );
/// OOP 2factory-Konstruktoren für die verschiedenen maßeinheiten die die Werte in mm umrechnen und an den privaten Konstruktor weitergeben
  factory Triangle.inInches({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.inch,
      );
/// OOP 2factory-Konstruktoren für die verschiedenen maßeinheiten die die Werte in mm umrechnen und an den privaten Konstruktor weitergeben
  factory Triangle.inFeet({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.feet,
      );

  /// OOP 3: Getter für die gekapselten Werte.
  ///  getter geben die breite und höhe in mm zurück
  double get widthInMillimeters => _widthInMillimeters;
  double get heightInMillimeters => _heightInMillimeters;

  double get widthInMeters =>
      _widthInMillimeters / MeasurementSystem.m.millimetersPerUnit;

  double get heightInMeters =>
      _heightInMillimeters / MeasurementSystem.m.millimetersPerUnit;

  double get widthInCentimeters =>
      _widthInMillimeters / MeasurementSystem.cm.millimetersPerUnit;

  double get heightInCentimeters =>
      _heightInMillimeters / MeasurementSystem.cm.millimetersPerUnit;

  double get widthInFeet =>
      _widthInMillimeters / MeasurementSystem.feet.millimetersPerUnit;

  double get heightInFeet =>
      _heightInMillimeters / MeasurementSystem.feet.millimetersPerUnit;

  double get widthInInches =>
      _widthInMillimeters / MeasurementSystem.inch.millimetersPerUnit;

  double get heightInInches =>
      _heightInMillimeters / MeasurementSystem.inch.millimetersPerUnit;

  double get widthInDecimeters =>
      _widthInMillimeters / MeasurementSystem.dm.millimetersPerUnit;

  double get heightInDecimeters =>
      _heightInMillimeters / MeasurementSystem.dm.millimetersPerUnit;
/// OOP 3 setter für die gekapselten Werte
  set widthInMillimeters(double value) => _widthInMillimeters = value;
  set heightInMillimeters(double value) => _heightInMillimeters = value;

  set widthInMeters(double value) =>
      _widthInMillimeters = value * MeasurementSystem.m.millimetersPerUnit;

  set heightInMeters(double value) =>
      _heightInMillimeters = value * MeasurementSystem.m.millimetersPerUnit;

  set widthInCentimeters(double value) =>
      _widthInMillimeters = value * MeasurementSystem.cm.millimetersPerUnit;

  set heightInCentimeters(double value) =>
      _heightInMillimeters = value * MeasurementSystem.cm.millimetersPerUnit;

  set widthInFeet(double value) =>
      _widthInMillimeters = value * MeasurementSystem.feet.millimetersPerUnit;

  set heightInFeet(double value) =>
      _heightInMillimeters = value * MeasurementSystem.feet.millimetersPerUnit;

  set widthInInches(double value) =>
      _widthInMillimeters = value * MeasurementSystem.inch.millimetersPerUnit;

  set heightInInches(double value) =>
      _heightInMillimeters = value * MeasurementSystem.inch.millimetersPerUnit;

  /// OOP 5:
  /// Gibt die Höhe in mm zurück.
  double getHeight(MeasurementSystem ms) {
    return _heightInMillimeters / ms.millimetersPerUnit;
  }

  /// OOP 5:
  /// setter höhe und in mm umrechnen
  void setHeight(MeasurementSystem ms, int value) {
    _heightInMillimeters = value * ms.millimetersPerUnit;
  }

  /// inerne methode für die flächen-Getter.
  double _areaIn(MeasurementSystem ms) {
    final width = _widthInMillimeters / ms.millimetersPerUnit;
    final height = _heightInMillimeters / ms.millimetersPerUnit;

    return width * height;
  }

  /// OOP 5: Fläche in quadrat maßeinheiten
  double get areaInSquareMillimeters => _areaIn(MeasurementSystem.mm);
  double get areaInSquareCentimeters => _areaIn(MeasurementSystem.cm);
  double get areaInSquareDecimeters => _areaIn(MeasurementSystem.dm);
  double get areaInSquareMeters => _areaIn(MeasurementSystem.m);
  double get areaInSquareInches => _areaIn(MeasurementSystem.inch);
  double get areaInSquareFeet => _areaIn(MeasurementSystem.feet);
}
