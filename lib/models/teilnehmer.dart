enum Geschlecht {
  weiblich,
  maennlich,
  divers,
}
// enum als geschlecht 
class Teilnehmer {
  final String nachname;
  final String vorname;
  final Geschlecht geschlecht; // nimmt vordefeniertes geshclecht 
  final DateTime? geburtstag;
  final double? abschlussnote;
//erstellt bauplan f+r teilnehmerobjekte mit eigenschaften 
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