//Riverpod Notifier und Änderungsmethoden

import 'package:oop_komplett/models/todo.dart';
import 'package:oop_komplett/models/todo_app_state.dart';
import 'package:riverpod/riverpod.dart';

final todoAppStateProvider = NotifierProvider<TodoAppStateProvider, TodoAppState>(
  () => TodoAppStateProvider(),
);
class TodoAppStateProvider extends Notifier<TodoAppState> {
  @override
  TodoAppState build() {
    return TodoAppState();
  }

  void addTodo(Todo todo) {
    state = state.copyWith(todos: [...state.todos, todo]);
  }

  void removeTodo(int id) {
    state = state.copyWith(todos: state.todos.where((todo) => todo.id != id).toList());
  }

  void toggleTodoDone(int id) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == id) {
        todo.toggleDone();
      }
      return todo;
    }).toList();
    state = state.copyWith(todos: updatedTodos);
  }
}