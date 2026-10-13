// landing page/home page für die app 
import 'package:flutter/material.dart';

// einfache erklärung was hier passiert in der app 
// mit möglichkeit für darkmode einstellungen und navigation zu den oop seiten
 class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OOP Übungen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Willkommen zu den OOP Übungen!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/oop1');
              },
              child: const Text('Zu den OOP Übungen'),
            ),
          ],
        ),
      ),
    );
  } }