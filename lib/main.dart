import 'package:flutter/material.dart';
import 'pages/oop1.dart';
import 'pages/oop2.dart';
import 'pages/oop3.dart';
import 'pages/oop4.dart';

void main() => runApp(const OopApp());

class OopApp extends StatelessWidget {
  const OopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OOP Übungen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OopNavigation(),
    );
  }
}

class OopNavigation extends StatefulWidget {
  const OopNavigation({super.key});

  @override
  State<OopNavigation> createState() => _OopNavigationState();
}

class _OopNavigationState extends State<OopNavigation> {
  int _currentIndex = 0; // index auf 0 setzen oop1 

  final _pages = const [
    Oop1Page(),
    Oop2Page(),
    Oop3Page(),
    Oop4Page(),
  ];

  final _titles = const [
    'OOP 1 – Klassen & Konstruktoren',
    'OOP 2 – Benannte Konstruktoren & Enums', // seiten inkl. beschreibung für nvg bar
    'OOP 3 – Getter & Setter',
    'OOP 4 – Komposition & Aggregation',
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
          setState(() => _currentIndex = index); // änderung der seite
        },
        destinations: const [ // navigation bar die indexe verwaltet ( unten zu sehen am bildschirm) zu oop bereiche mit beispielen
          NavigationDestination(icon: Icon(Icons.looks_one), label: 'OOP 1'),
          NavigationDestination(icon: Icon(Icons.looks_two), label: 'OOP 2'),
          NavigationDestination(icon: Icon(Icons.looks_3), label: 'OOP 3'),
          NavigationDestination(icon: Icon(Icons.looks_4), label: 'OOP 4'),
        ],
      ),
    );
  }
}
