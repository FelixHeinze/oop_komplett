//Speichert und lädt die Json Datei

import 'dart:convert';
import 'dart:io'; 

import 'package:oop_komplett/models/todo.dart';
import 'package:path_provider/path_provider.dart';

class TodoStorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todos.json');
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final file = await _localFile;
    final jsonString = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  Future<List<Todo>> loadTodos() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => Todo.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading todos: $e');
      return [];
    }
  }
}