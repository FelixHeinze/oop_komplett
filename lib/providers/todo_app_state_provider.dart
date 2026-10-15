// Future und Aysnc bibo 
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// UUID für eindeutige IDs der Todos 
import 'package:uuid/uuid.dart';

import '../models/todo.dart';
import '../models/todo_app_state.dart';
import '../services/todo_storage_service.dart';

// Global erreichbarer Provider für asynchron geladene TodoAppState.
final todoAppStateProvider =
    AsyncNotifierProvider<TodoAppStateProvider, TodoAppState>(
  TodoAppStateProvider.new,
);
// Enthält Aktionen mit denen der App Zustand geändert werrden kann
class TodoAppStateProvider extends AsyncNotifier<TodoAppState> {
  //zuständig für das lesen/schreiben der lokalen JSON datei
  final TodoStorageService _storage = TodoStorageService();
  //ID für Todo erzeugen
  final Uuid _uuid = const Uuid();
// Speichert Schreibvorgänge nacheinander damit diese abgearbeitet werden können und sich nicht überholen
  Future<void> _writeQueue = Future<void>.value();
// Provider wird initialisiert und lädt gespeicherte Daten
  @override
  Future<TodoAppState> build() {
    return _storage.loadState();
  }

  /// Führt Änderungen nacheinander aus und speichert den neuen Zustand.
  Future<void> _update(
    TodoAppState Function(TodoAppState) change,
  ) async {
    //Wartet auf initial geladenen Zustand
    final current = await future;
    //Die übergebene Funktion berechnet den nächsten Zustand
    final next = change(current);
//Aktualisiert die Oberfläche sofort mit dem neuen Zustand
    state = AsyncData(next);
 // Hängt das Speichern an die Warteschlange an.
    // Ein vorheriger Schreibfehler soll spätere Speicherungen nicht blockieren.
   
    _writeQueue = _writeQueue
        .catchError((Object _) {})
        .then((_) => _storage.saveState(next));
//Wartet bis geschrieben wurde 
    await _writeQueue;
  }
//Fügt eine Aufgabe hinzu, leere Eingaben werden ignoriert
  Future<void> addTodo(String text) async {
    final trimmed = text.trim();

    if (trimmed.isEmpty) return;

    await _update(
      (current) => current.copyWith(
        //Spread-Operator kopiert bestehende aufgabe in eine neue Liste 
        todos: [
          ...current.todos,
          Todo(
            id: _uuid.v4(),
            text: trimmed,
          ),
        ],
      ),
    );
  }
// Entfert das Todo mit der angegebenen ID aus der Liste 
  Future<void> removeTodo(String id) async {
    await _update(
      (current) => current.copyWith(
        todos: current.todos
        //Where behält alle Aufgaben ausser die mit der angegebenen ID
            .where((todo) => todo.id != id)
            .toList(),
      ),
    );
  }
//entfernt alle Aufgaben die erledigt angehakt sind 
  Future<void> removeCompleted() async {
    await _update(
      (current) => current.copyWith(
        todos: current.todos
            .where((todo) => !todo.isDone)
            .toList(),
      ),
    );
  }
//WEchselt den Erledigt Status eines TOdos 
  Future<void> toggleTodoDone(String id) async {
    await _update(
      (current) => current.copyWith(
        //Map erstellt eine neue liste und ersetzt nur das passende TOdo
        todos: current.todos.map((todo) {
          if (todo.id == id) {
            return todo.copyWith(
              isDone: !todo.isDone,
            );
          }

          return todo;
        }).toList(),
      ),
    );
  }
//Ändert den Text einer Aufgabe , leere werden ignoriert 
  Future<void> editTodo(String id, String text) async {
    final trimmed = text.trim();

    if (trimmed.isEmpty) return;

    await _update(
      (current) => current.copyWith(
        todos: current.todos.map((todo) {
          if (todo.id == id) {
            return todo.copyWith(text: trimmed);
          }

          return todo;
        }).toList(),
      ),
    );
  }
// Ändert Theme Wert, main dart reagiert darauf und wechselt 
  Future<void> setDarkMode(bool value) async {
    await _update(
      (current) => current.copyWith(darkMode: value),
    );
  }
}