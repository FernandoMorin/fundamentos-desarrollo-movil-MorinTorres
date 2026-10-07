import 'package:flutter/material.dart';
import 'package:p2_actividad1/partidas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Partidas Pro Dota 2',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: rojoDota)),
      home: const Partidas(),
    );
  }
}
