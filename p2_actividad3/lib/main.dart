import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:p2_actividad3/colores.dart';
import 'package:p2_actividad3/pantallas/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wofmztvcazqlljwsexxk.supabase.co',
    publishableKey: 'sb_publishable_3DVaZhiZtdQF1VvWR6moWQ_oIBVFvwp',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizzería',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: azul)),
      home: const Login(),
    );
  }
}
