import 'package:flutter/material.dart';

// OOP 6 – Vererbung

abstract class Animal {
  String get name;

  void move();

  void makeSound();
}

// Fähigkeit: ein lebewesen kann fliegen.
abstract class CanFly {
  void fly();
}

// Fähigkeit: ein lebewesen kann laufen.
abstract class CanWalk {
  void walk();
}

// Fähigkeit: ein lebewesen kann unter wasser atmen.
abstract class CanBreatheUnderWater {
  void breatheUnderWater();
}

// erste ebene unter anmimal
// alle fische können schwimmen + unter wasser atmen
abstract class Fish extends Animal implements CanBreatheUnderWater {
  //abstrakte klasse fisch leitet sich von animal ab und implementiert canbreatheunderwater
  @override
  void move() {
    print('$name schwimmt.');
  }

  @override // override überschreibt breatheunderwather
  void breatheUnderWater() {
    print('$name atmet unter Wasser.');
  }

  @override
  void makeSound() {
    print('$name macht ein Fischgeräusch.');
  }
}

// konkrete tierklasse.
class Goldfish extends Fish {
  @override
  String get name => 'Goldfisch';

  @override
  void makeSound() {
    print('$name macht: blubb blubb.');
  }
}


// animal -> bird -> eagle
abstract class Bird extends Animal implements CanWalk {
  @override
  void walk() {
    print('$name läuft.');
  }

  @override
  void move() {
    walk();
  }

  @override
  void makeSound() {
    print('$name macht ein Vogelgeräusch.');
  }
}

class Eagle extends Bird implements CanFly {
  @override
  String get name => 'Adler';

  @override
  void fly() {
    print('$name fliegt.');
  }

  @override
  void move() {
    fly();
  }

  @override
  void makeSound() {
    print('$name ruft.');
  }
}

// vogel der nicht fliegt pinguin
// damit wird sichtbar, warum globalFly prüfen muss.
class Penguin extends Bird {
  @override
  String get name => 'Pinguin';

  @override
  void makeSound() {
    print('$name macht ein Pinguingeräusch.');
  }
}

// Globaler Mechanismus aus der Aufgabenstellung.
// Es wird bewusst Object? verwendet.
void globalFly(Object? object) {
  if (object is CanFly) {
    object.fly();
  } else {
    print('Dieses Objekt kann nicht fliegen.');
  }
}

class Oop6Page extends StatelessWidget {
  const Oop6Page({super.key});

  @override
  Widget build(BuildContext context) {
    final animals = <Animal>[
      Goldfish(),
      Eagle(),
      Penguin(),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OOP 6',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Vererbung',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Die Aufgabe zeigt eine Dreistufige Tier-Hierarchie '
                  'und zusätzliche Fähigkeiten als abstrakte Klassen.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: animals.map((animal) {
              return ListTile(
                leading: Icon(
                  animal is Eagle
                      ? Icons.flight
                      : animal is Fish
                          ? Icons.water
                          : Icons.pets,
                ),
                title: Text(animal.name),
                subtitle: Text(
                  _descriptionFor(animal),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'globalFly(Object? object)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Die Methode prüft mit "is", ob das übergebene '
                  'Objekt die Fähigkeit CanFly besitzt.',
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    globalFly(Eagle());
                  },
                  icon: const Icon(Icons.flight),
                  label: const Text('globalFly mit Adler'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    globalFly(Goldfish());
                  },
                  icon: const Icon(Icons.water),
                  label: const Text('globalFly mit Goldfisch'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _InfoCard(
          title: 'Tier-Hierarchien',
          text:
              'Animal ist abstrakt. Fish und Bird sind Zwischenklassen. '
              'Goldfish, Eagle und Penguin sind konkrete Klassen.',
        ),
        const SizedBox(height: 12),
        const _InfoCard(
          title: 'Fähigkeiten',
          text:
              'CanFly, CanWalk und CanBreatheUnderWater sind abstrakte '
              'Fähigkeitsklassen. Konkrete Tiere implementieren nur die '
              'Fähigkeiten, die sie tatsächlich besitzen.',
        ),
        const SizedBox(height: 12),
        const _CodeCard(
          code: '''abstract class Animal {
  void move();
  void makeSound();
}

abstract class CanFly {
  void fly();
}

void globalFly(Object? object) {
  if (object is CanFly) {
    object.fly();
  }
}''',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Animal\n'
              '├── Fish\n'
              '│   └── Goldfish\n'
              '└── Bird\n'
              '    ├── Eagle\n'
              '    └── Penguin',
              style: const TextStyle(
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _descriptionFor(Animal animal) {
    if (animal is Goldfish) {
      return 'Fish → Goldfish | schwimmt | atmet unter Wasser';
    }

    if (animal is Eagle) {
      return 'Bird → Eagle | läuft | fliegt';
    }

    if (animal is Penguin) {
      return 'Bird → Penguin | läuft | kann nicht fliegen';
    }

    return '';
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String text;

  const _InfoCard({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  final String code;

  const _CodeCard({
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: Text(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
