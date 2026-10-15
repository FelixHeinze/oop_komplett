// jsonEcnode/Decode 
import 'dart:convert';
// File zugriff für lokale Datein
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/todo_app_state.dart';
//Kapselt das lokale Speichern und Laden des App-Zustands in einer JSON-Datei.
class TodoStorageService {
  // Liefert die Datei in der der Zustand gespeichert wird 
  //getApplicationDocumentsDirectory() liefert den Pfad zum Dokumentenverzeichnis der App 
  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/todos.json');
  }

// lädt den Zustand aus der Json Datei
Future<TodoAppState> loadState() async {
  final file = await _file;

// Beim ersten Start noch keine Datei vorhanden, daher wird ein leerer Zustand zurückgegeben.
  if (!await file.exists()) {
    return const TodoAppState();
  }
// Inhalt als TExt einlesen 
  final contents = await file.readAsString();

  // Eine leere Datei bedeutet: Es gibt noch keinen gespeicherten Zustand.
  if (contents.trim().isEmpty) {
    return const TodoAppState();
  }

  try {
    // wandelt Json text in Dart Daten um  
    final decoded = jsonDecode(contents);
  //Prüft /konvertiert die Map und baut daraus den App Zustand
    return TodoAppState.fromJson(
      Map<String, dynamic>.from(decoded as Map),
    );
  } on FormatException {
    // Bei ungültigem JSON mit einem leeren Zustand starten.
    // Die fehlerhafte Datei wird beim nächsten Speichern ersetzt.
    return const TodoAppState();
  }
}

// speichert den kompletten Zustand in der JSon Datei 
  Future<void> saveState(TodoAppState state) async {
    final file = await _file;
// toJson erstellt Map, Encode Wandelt diese in Json text um 
    final contents = jsonEncode(state.toJson());
// WriteAsString schreibt den Text, flush wartet darauf das Daten an das OS übergeben werden

    await file.writeAsString(
      contents,
      flush: true,
    );
  }
}