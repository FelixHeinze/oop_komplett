//Riverpod Notifier und Änderungsmethoden

import 'package:riverpod/riverpod.dart';

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