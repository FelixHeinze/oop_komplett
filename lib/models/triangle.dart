enum MeasurementSystem {
  mm(1),
  cm(10),
  dm(100),
  m(1000),
  inch(25.4),
  feet(304.8);

  const MeasurementSystem(this.millimetersPerUnit);

  final double millimetersPerUnit;
}

class Triangle {
  double _widthInMillimeters;
  double _heightInMillimeters;

  Triangle._fromMillimeters({
    required double width,
    required double height,
  })  : _widthInMillimeters = width,
        _heightInMillimeters = height;

  factory Triangle({
    required double width,
    required double height,
    required MeasurementSystem system,
  }) =>
      Triangle._fromMillimeters(
        width: width * system.millimetersPerUnit,
        height: height * system.millimetersPerUnit,
      );

  factory Triangle.inMillimeters({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.mm,
      );

  factory Triangle.inCentimeters({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.cm,
      );

  factory Triangle.inDecimeters({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.dm,
      );

  factory Triangle.inMeters({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.m,
      );

  factory Triangle.inInches({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.inch,
      );

  factory Triangle.inFeet({
    required double width,
    required double height,
  }) =>
      Triangle(
        width: width,
        height: height,
        system: MeasurementSystem.feet,
      );

  // OOP 3: Getter für die gekapselten Werte.
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

  // OOP 5:
  // Gibt die Höhe im gewünschten Maßsystem zurück.
  double getHeight(MeasurementSystem ms) {
    return _heightInMillimeters / ms.millimetersPerUnit;
  }

  // OOP 5:
  // Setzt die Höhe. Der übergebene Wert wird in Millimeter umgerechnet.
  void setHeight(MeasurementSystem ms, int value) {
    _heightInMillimeters = value * ms.millimetersPerUnit;
  }

  // Interne Hilfsmethode für die Flächen-Getter.
  double _areaIn(MeasurementSystem ms) {
    final width = _widthInMillimeters / ms.millimetersPerUnit;
    final height = _heightInMillimeters / ms.millimetersPerUnit;

    return width * height;
  }

  // OOP 5: Fläche in Quadrat-Maßeinheiten.
  double get areaInSquareMillimeters => _areaIn(MeasurementSystem.mm);
  double get areaInSquareCentimeters => _areaIn(MeasurementSystem.cm);
  double get areaInSquareDecimeters => _areaIn(MeasurementSystem.dm);
  double get areaInSquareMeters => _areaIn(MeasurementSystem.m);
  double get areaInSquareInches => _areaIn(MeasurementSystem.inch);
  double get areaInSquareFeet => _areaIn(MeasurementSystem.feet);
}
