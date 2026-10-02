import 'package:flutter/material.dart';

import 'pages/oop1.dart';
import 'pages/oop2.dart';
import 'pages/oop3.dart';
import 'pages/oop4.dart';
import 'pages/oop5.dart';
import 'pages/oop6.dart';
import 'pages/oop7.dart';
//angedacht ist alle oop projekte in einer flutter app anzulegen und diese auf verschiedene seiten 
// darzustellen
void main() => runApp(const OopApp());
/// OOP App ist eine Flutter-Anwendung, die verschiedene OOP-Konzepte demonstriert
class OopApp extends StatelessWidget {
  /// Konstruktor für OopApp
  const OopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OOP Übungen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const OopNavigation(),
    );
  }
}
/// OopNavigation ist eine StatefulWidget-Klasse, die die Navigation zwischen den OOP-Seiten ermöglicht
/// spätere erweiterung als menü mit allen oop seiten, da es viele werden
class OopNavigation extends StatefulWidget {
  /// Konstruktor für OopNavigation
  const OopNavigation({super.key});

  @override
  State<OopNavigation> createState() => _OopNavigationState();
}
/// _OopNavigationState ist die State-Klasse für OopNavigation, die die aktuelle Seite und den Index der Navigation verwaltet
class _OopNavigationState extends State<OopNavigation> {
  int _currentIndex = 0;

  final _pages = const [
    Oop1Page(),
    Oop2Page(),
    Oop3Page(),
    Oop4Page(),
    Oop5Page(),
    Oop6Page(),
    Oop7Page(),
  ];
  // nächste asulagerung in extra menü da viele oop seiten anfallen werden 

  final _titles = const [
    'OOP 1 – Klassen & Konstruktoren',
    'OOP 2 – Benannte Konstruktoren & Enums',
    'OOP 3 – Getter & Setter',
    'OOP 4 – Komposition & Aggregation',
    'OOP 5 – Methoden',
    'OOP 6 – Vererbung',
    'OOP 7 – Operatoren',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.looks_one),
            label: 'OOP 1',
          ),
          NavigationDestination(
            icon: Icon(Icons.looks_two),
            label: 'OOP 2',
          ),
          NavigationDestination(
            icon: Icon(Icons.looks_3),
            label: 'OOP 3',
          ),
          NavigationDestination(
            icon: Icon(Icons.looks_4),
            label: 'OOP 4',
          ),
          NavigationDestination(
            icon: Icon(Icons.looks_5),
            label: 'OOP 5',
          ),
          NavigationDestination(
            icon: Icon(Icons.looks_6),
            label: 'OOP 6',
          ),
          NavigationDestination(
            icon: Icon(Icons.seven_k),
            label: 'OOP 7',
          ),
        ],
      ),
    );
  }
}
