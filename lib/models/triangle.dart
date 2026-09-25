enum MeasurementSystem {
  mm(1),
  cm(10),
  dm(100),
  m(1000),
  inch(25.4),
  feet(304.8);
/* measurementsystem ist enum, jeder enum wert hat zusätzlich 
einen faktir der sagt wie viele milimeter eine einheit besitzt
ein cm faktor 10 ... 
----> zentralisierung der umrechnung 
enum ist eine feste menge möglicher werte */
  const MeasurementSystem(this.millimetersPerUnit); // milimetersperunit liefert umrechnugnsfaktor 
  final double millimetersPerUnit;
}

class Triangle {
  double _widthInMillimeters;
  double _heightInMillimeters; // private interne werte oop3 
  // eigentliche gespeicherte werte heißen   double _widthInMillimeters;
  //double _heightInMillimeters unterstrich zeigt kapselung an also privat hier
  //verfügbar nur 

  Triangle._fromMillimeters({
    required double width,
    required double height,
  })  : _widthInMillimeters = width,
        _heightInMillimeters = height; 


/* der aufrufer lifert breite höhe und das ma0ssystem der code
nimmt den faktor des systemes und multipliziert damit
--> werte werden in mm umgerechnet und intern gespeichert */ 
  factory Triangle({
    required double width,
    required double height,
    required MeasurementSystem system,
  }) =>
      Triangle._fromMillimeters(
        width: width * system.millimetersPerUnit,
        height: height * system.millimetersPerUnit,
      ); 


/*bennante constructoren um beim aufruf nicht zusätzlich umrechnen zu müssen bzw erklären 
constructor ruft trianlge konstruktion auf
bswp final triangle1 = Triangle.inCentimeters(width:10, heightÄ:5) */ 
  factory Triangle.inMillimeters({required double width, required double height}) =>
      Triangle(width: width, height: height, system: MeasurementSystem.mm);

  factory Triangle.inCentimeters({required double width, required double height}) =>
      Triangle(width: width, height: height, system: MeasurementSystem.cm);

  factory Triangle.inDecimeters({required double width, required double height}) =>
      Triangle(width: width, height: height, system: MeasurementSystem.dm);

  factory Triangle.inMeters({required double width, required double height}) =>
      Triangle(width: width, height: height, system: MeasurementSystem.m);

  factory Triangle.inInches({required double width, required double height}) =>
      Triangle(width: width, height: height, system: MeasurementSystem.inch);

  factory Triangle.inFeet({required double width, required double height}) =>
      Triangle(width: width, height: height, system: MeasurementSystem.feet);
// fälle der verschiedenen werte mm cm .... 
/*  getter im projekt ( oop3 ) getter liest internen wert und kann bei bedarf umrechnen
*/
  double get widthInMillimeters => _widthInMillimeters;
  double get heightInMillimeters => _heightInMillimeters;
  double get widthInMeters => _widthInMillimeters / MeasurementSystem.m.millimetersPerUnit;
  double get heightInMeters => _heightInMillimeters / MeasurementSystem.m.millimetersPerUnit;
  double get widthInCentimeters => _widthInMillimeters / MeasurementSystem.cm.millimetersPerUnit;
  double get heightInCentimeters => _heightInMillimeters / MeasurementSystem.cm.millimetersPerUnit;
  double get widthInFeet => _widthInMillimeters / MeasurementSystem.feet.millimetersPerUnit;
  double get heightInFeet => _heightInMillimeters / MeasurementSystem.feet.millimetersPerUnit;
  double get widthInInches => _widthInMillimeters / MeasurementSystem.inch.millimetersPerUnit;
  double get heightInInches => _heightInMillimeters / MeasurementSystem.inch.millimetersPerUnit;
  double get widthInDecimeters => _widthInMillimeters / MeasurementSystem.dm.millimetersPerUnit;
  double get heightInDecimeters => _heightInMillimeters / MeasurementSystem.dm.millimetersPerUnit;

  set widthInMillimeters(double value) => _widthInMillimeters = value;
  set heightInMillimeters(double value) => _heightInMillimeters = value;
  set widthInMeters(double value) => _widthInMillimeters = value * MeasurementSystem.m.millimetersPerUnit;
  set heightInMeters(double value) => _heightInMillimeters = value * MeasurementSystem.m.millimetersPerUnit;
  set widthInCentimeters(double value) => _widthInMillimeters = value * MeasurementSystem.cm.millimetersPerUnit;
  set heightInCentimeters(double value) => _heightInMillimeters = value * MeasurementSystem.cm.millimetersPerUnit;
  set widthInFeet(double value) => _widthInMillimeters = value * MeasurementSystem.feet.millimetersPerUnit;
  set heightInFeet(double value) => _heightInMillimeters = value * MeasurementSystem.feet.millimetersPerUnit;
  set widthInInches(double value) => _widthInMillimeters = value * MeasurementSystem.inch.millimetersPerUnit;
  set heightInInches(double value) => _heightInMillimeters = value * MeasurementSystem.inch.millimetersPerUnit;
}
/* setter mit umrechnung in andere richtung der benutzer gibt bspw cm an gespeoichert wird
mm  setter übernimmt also die umrechnung aus enum werten */