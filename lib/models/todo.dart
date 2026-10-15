//Annotationen helfen Json Konvertierungscode zu generieren
import 'package:json_annotation/json_annotation.dart';
//Buildrunner generiert code dieser Datei
part 'todo.g.dart';
//Datenmodell für einzelne Aufgabe
@JsonSerializable()
class Todo {
  //Attribute
  final String id;
  final String text;
  final bool isDone;

  const Todo({
    required this.id,
    required this.text,
    this.isDone = false,
    //neue aufgaben sind nicht erledigt 
  });
//ERstellt Kopie mit ausgewählten Änderungen
//Nicht angegeben WErte bleiben unverändert
//Das Modell wird nicht nachträglich verändert (immutable)
  Todo copyWith({
    String? text,
    bool? isDone,
  }) {
    return Todo(
      id: id, // id bleibt gleich 
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
    );
  }
//Erstellt TodoObjekt aus einer Jsno Map
//Feldzuordnung steht im generierten todo.g.dart
  factory Todo.fromJson(Map<String, dynamic> json) =>
      _$TodoFromJson(json);
//Wandelt dieses TodoObjekt in Json kompatible Map um
//code ebenfalls geneirert, lohnt bei großen klassen/aufgaben 
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}