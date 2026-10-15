import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// landing page ist startseite der app um alle themen aufzulisten
import 'pages/landingPage.dart';
import 'providers/todo_app_state_provider.dart';

void main() {
  runApp(
    // ProviderScope ist notwendig, um Riverpod zu initialisieren, stellt also Riverpod-Provider im widhetBaum bereit 
    const ProviderScope(
      child: OopApp(),
    ),
  );
}
// consumerWidget darf Riverpod Zustände lesen 
class OopApp extends ConsumerWidget {
  const OopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch baut dieses widget neu auf wenn sich der Zustand des Providers ändert 
    final appState = ref.watch(todoAppStateProvider);
    // Beim Laden oder bei fehlendem Wert/Zustand wird ligthmode als Standardwert festegelegt 
    final darkMode = appState.value?.darkMode ?? false;

    return MaterialApp(
      title: 'OOP Übungen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        //darkmode Theme verwendet dieselben Grundfarben mit dunkler Helligkeit 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ), 
      // Wählt das Theme abhängig vom gespeicherten darkmode Wert 
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const LandingPage(),
    );
  }
}