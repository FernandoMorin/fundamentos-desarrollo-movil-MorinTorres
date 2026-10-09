import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:p2_examen/pantallas/splash.dart';
import 'package:p2_examen/tema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cozwnajrymvgzcesorix.supabase.co',
    publishableKey: 'sb_publishable_brpgYlL2Bqz9LFqLi4A2AQ_981LX3wK',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Lugares Favoritos',
      debugShowCheckedModeBanner: false,
      theme: tema(Brightness.light),
      darkTheme: tema(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const Splash(),
    );
  }
}
