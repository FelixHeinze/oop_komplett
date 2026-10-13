//unveränderlicher Gesamtzustand samt Json Konvertierung

import 'package:oop_komplett/models/todo.dart';

class TodoAppState {
  final List<Todo> todos;

  TodoAppState({this.todos = const []});

  TodoAppState copyWith({List<Todo>? todos}) {
    return TodoAppState(
      todos: todos ?? this.todos,
    );
  }

  factory TodoAppState.fromJson(Map<String, dynamic> json) {
    return TodoAppState(
      todos: (json['todos'] as List<dynamic>)
          .map((todoJson) => Todo.fromJson(todoJson))
          .toList(),
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((todo) => todo.toJson()).toList(),
    };
  }
}