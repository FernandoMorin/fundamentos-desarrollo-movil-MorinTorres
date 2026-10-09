import 'package:flutter/material.dart';

const colorPrincipal = Colors.teal;

ThemeData tema(Brightness brillo) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: colorPrincipal,
      brightness: brillo,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
