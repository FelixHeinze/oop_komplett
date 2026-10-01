///enum für Geschlechter
enum Geschlecht {
  ///eintrag weiblich
  weiblich,
  ///eintrag männlich
  maennlich,
  ///eintrag divers
  divers,
}
///Klasse Teilnehmer mit Eigenschaften wie Nachname, Vorname, Geschlecht, Geburtstag und Abschlussnote
class Teilnehmer {
  /// Nachnahme muss angegeben werden
  final String nachname;
  /// Vorname muss angegeben werden
  final String vorname;
  /// Geschlecht muss angegeben werden, da es vordefiniert ist
  final Geschlecht geschlecht; // nimmt vordefeniertes geshclecht 
  ///Geburtstag darf null sein, da nicht jeder Teilnehmer ein Geburtstag angegeben hat
  final DateTime? geburtstag;
  ///Abschlussnote darf null sein, da nicht jeder Teilnehmer eine Abschlussnote angegeben hat
  final double? abschlussnote;

/// Konstruktor für die Klasse Teilnehmer, der die erforderlichen Eigenschaften initialisiert und optionale Eigenschaften zulässt.
  Teilnehmer({
    required this.nachname,
    required this.vorname,
    required this.geschlecht,
    this.geburtstag,
    this.abschlussnote,
  });
}
/* teilnehmer ist die klasse , mit teilnehmer() wird konkretes objekt
erzeugt und heißt person mit werten ( bspw felix heinze 1.7 abschlussnote 

Teilnehmer ist Klasse, person objekt davon
Datetime darf nullabe sein 
*/