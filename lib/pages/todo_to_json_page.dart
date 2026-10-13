//landing page

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_app_state_provider.dart';

// aufbau als scrollbare liste, die die todos anzeigt und eine schaltfläche zum hinzufügen neuer todos enthält
// die todos werden aus dem provider geladen und beim hinzufügen eines neuen todos wird der provider aktualisiert
class TodoToJsonPage extends ConsumerWidget { 
  
  const TodoToJsonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoAppState = ref.watch(todoAppStateProvider);
    final todos = todoAppState.todos;
// vorüberlegung: die todos werden aus dem provider geladen und beim hinzufügen eines neuen todos wird der provider aktualisiert
// todos sollen bearbeitbar werden, dazu muss die todo klasse angepasst werden, sodass sie eine methode zum bearbeiten des textes enthält
// die methode zum bearbeiten des textes soll den text der todo instanz ändern und den provider aktualisieren
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // hier könnte man die todos in eine json datei speichern
              //testweise konsolenausgabe der datei 
              final json = todos.map((todo) => todo.toJson()).toList();
              print(json);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.text),
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (value) {
                ref.read(todoAppStateProvider.notifier).toggleTodoDone(todo.id);
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(todoAppStateProvider.notifier).removeTodo(todo.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newTodo = Todo(
            id: DateTime.now().millisecondsSinceEpoch,
            text: 'Neue Aufgabe ${todos.length + 1}',
          );
          ref.read(todoAppStateProvider.notifier).addTodo(newTodo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}