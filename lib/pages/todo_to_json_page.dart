import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../providers/todo_app_state_provider.dart';
//ConsumerWidhget kann Riverpod Zustand beobachten und Aktiuonen auslösen
class TodoToJsonPage extends ConsumerWidget {
  const TodoToJsonPage({super.key});

 
// Eingabedialog wird geöfnnen und liefert zext zurück
//initial ist null beim bearbeiten der vohandenen texte 
Future<String?> _askText(
  BuildContext context, {
  String? initial,
}) {
  return showDialog<String>(
    context: context,
    //dialog wird nur über seine schaltfläche geschlossen 
    barrierDismissible: false,
    builder: (dialogContext) {
      return _TodoTextDialog(initial: initial);
    },
  );
}



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch für aktualisierung der Oberfläche bei statusänderung
    final appState = ref.watch(todoAppStateProvider);
    //read holt Notifier für Aktionen ohne hier auf Änderungen zu hören 
    final actions = ref.read(todoAppStateProvider.notifier);

    return Scaffold(
      //AsyncValue kann laden, einen Fehler enthalten oder daten bereitstellen
      //Loading () --> error() --> data() 
      body: appState.when(
        //Ladeanzeige während die lokale Json Datei gelesen wird 
        loading: () => const Center(
          
          child: CircularProgressIndicator(),
        ),
        //Error fehlermeldung 
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Todo-Daten konnten nicht geladen werden: $error',
            ),
          ),
        ),
        data: (data) {
          //bereitstellung der daten 
          final todos = data.todos;

          if (todos.isEmpty) {
            //leerer Zustand mit Hinweis statt liste 
            return const Center(
              child: Text(
                'Noch keine Aufgaben. Tippe auf +.',
              ),
            );
          }

          return Column(
            children: [
              Padding(
                //Kopfzeile mit Fortschritt und aktionen zum Löschen erledigter aufgaben
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      //Zählt erledigte Aufgaben und zeigt sie im Verhältnis an 
                      child: Text(
                        '${todos.where((todo) => todo.isDone).length}'
                        ' von ${todos.length} erledigt',
                      ),
                    ),
                    //Deaktiviert wenn nichts zu erledigen 
                    TextButton.icon(
                      onPressed: todos.any((todo) => todo.isDone)
                          ? () => actions.removeCompleted()
                          : null,
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Erledigte löschen'),
                    ),
                  ],
                ),
              ),
              Expanded(
                //Expandet für nötigen Raum in Column Layout
                child: ListView.builder(
                  itemCount: todos.length,
                  //erstellt Listeneinträge bei bedarf
                  itemBuilder: (context, index) {
                    final Todo todo = todos[index];

                    return ListTile(
                      //Eindeutiger Key zum korrekten zuordnen
                      key: ValueKey(todo.id),
                      leading: Checkbox(
                        //Checkbox für Eledigt Status
                        value: todo.isDone,
                        onChanged: (_) {
                          actions.toggleTodoDone(todo.id);
                        },
                      ),
                      //Erledigte aufgaben sind durchgestrichen 
                      title: Text(
                        todo.text,
                        style: TextStyle(
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      onTap: () async {
                        //Tippen zum bearbeiten (namen ändern)
                        final text = await _askText(
                          context,
                          initial: todo.text,
                        );
// Abbruch und leerer Text verändert Aufgabe nicht 
                        if (text != null && text.isNotEmpty) {
                          await actions.editTodo(todo.id, text);
                        }
                      },
                      trailing: IconButton(
                        tooltip: 'Löschen',
                        //löscht ausgewählten eintrag 
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          actions.removeTodo(todo.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      //Buutton für neue Aufgabe 
      floatingActionButton: FloatingActionButton(
        tooltip: 'Aufgabe hinzufügen',
        onPressed: () async {
          final text = await _askText(context);
// Fehlerabfang für provider 
          if (text != null && text.isNotEmpty) {
            await actions.addTodo(text);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
// Neues Statefull Widget für den dialog, damit dieser für den Controller
//Sichtbar bleibt, es gab ein Problem bei direkter implementierung oberhalb
//dort wurde dann nur geschrieben und es stürtzte ab 
//so funktioniert es 
class _TodoTextDialog extends StatefulWidget {
  const _TodoTextDialog({this.initial});
//Optionaler Starttext, NULL --> heißt neue Aufgabe 
  final String? initial;

  @override
  State<_TodoTextDialog> createState() =>
      _TodoTextDialogState();
}

class _TodoTextDialogState extends State<_TodoTextDialog> {
  //Contoller liest und verwaltet text des Eingabefeldes
  late final TextEditingController _controller;

  @override
  //initialisert den Controller 
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initial ?? '',
    );
  }
//Gibt den Contoller Frei wenn der Flutter den Dialog-State entfernt
//Dadurch wurde Fehler "used after being disposed" vermieden wie oben beschrieben
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
//schließt dialog und gibt bereinigten Text zurück
  void _submit() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //Titel ist flexibel und passt sich an 
      title: Text(
        widget.initial == null
            ? 'Neue Aufgabe'
            : 'Aufgabe bearbeiten',
      ),
      content: TextField(
        controller: _controller,
        //Focus attribut für Eingabeld
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Aufgabe eingeben',
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
