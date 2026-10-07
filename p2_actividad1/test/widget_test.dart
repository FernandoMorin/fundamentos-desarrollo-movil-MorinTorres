import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:p2_actividad1/main.dart';

void main() {
  testWidgets('Muestra el título y carga las partidas', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Partidas Pro Dota 2'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
