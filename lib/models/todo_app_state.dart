//Modell bündelt alleDaten die für die TodoApp gespeichert werden
import 'todo.dart';
//Gesamtzustand der App: Aufgabenliste und Theme einstellungen
//Final da über Copywith neue instanz erstellt wird 
class TodoAppState {
  final List<Todo> todos;
  final bool darkMode;
//Standardzustand keine aufgaben und lightmode
  const TodoAppState({
    this.todos = const [],
    this.darkMode = false,
  });
// Erzeugt einen neuen Zustand und übernimmt nicht geänderte Werte
//Erleichtert unveränderliche State updates mit Riverpod 
  TodoAppState copyWith({
    List<Todo>? todos,
    bool? darkMode,
  }) {
    return TodoAppState(
      todos: todos ?? this.todos,
      darkMode: darkMode ?? this.darkMode,
    );
  }
//Baut App uzustand aus einer Json Map wieder auf 
  factory TodoAppState.fromJson(Map<String, dynamic> json) {
    return TodoAppState(
      //Falls todos fehlt wird eine leere liste verwendet
      //Jeder Eintrag wird von Json map in TodoObjekt umgewandelt 
      todos: (json['todos'] as List<dynamic>? ?? [])
          .map(
            (entry) => Todo.fromJson(
              Map<String, dynamic>.from(entry as Map),
            ),
          )
          .toList(),
          //Falls darkmde fehlt --> start in lightmode 
      darkMode: json['darkMode'] as bool? ?? false,
    );
  }
//Wandelt Gesamtzustand in eine Json kompatible Map um
  Map<String, dynamic> toJson() {
    return {
      //jedes Toto wird selbst in eine map konvertiert, rekursive konvertierung 
      'todos': todos.map((todo) => todo.toJson()).toList(),
      'darkMode': darkMode,
    };
  }
}
