//einzelnes todo mit id text und erledigt status
// json methoden mit code generation json_serializable

import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo {
  // mit @JsonKey kann man default values setzen, falls die json Datei keine Werte enthält
  @JsonKey(defaultValue: 0)
  int id;
  // @JsonKey(text: 'inhalt')
  // umbenennung des keys falls in datei anderer name bspw. 
  String text;
  bool isDone;

  Todo({
    required this.id,
    required this.text,
    this.isDone = false,
  });
// JsonSerializable benötigt eine leere Konstruktorfunktion, um die Instanz zu erstellen
// https://pub.dev/packages/json_serializable anleitung
// unter pub.dev auch mit schritt für schritt anleitung für code generation
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
// datei todo.gart wird automatisch generiert, wenn man im terminal folgenden befehl ausführt:
// flutter pub run build_runner build --delete-conflicting-outputs
// dort werden  to und from json methoden 
  // Methode zum Umschalten des Erledigt-Status
  void toggleDone() {
    isDone = !isDone;
  }
}