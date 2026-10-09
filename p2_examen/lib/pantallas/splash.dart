import 'package:flutter/material.dart';
import 'package:p2_examen/datos/supabase.dart';
import 'package:p2_examen/pantallas/inicio.dart';
import 'package:p2_examen/pantallas/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late final _animacion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), _continuar);
  }

  void _continuar() {
    if (!mounted) return;
    final destino = supabase.auth.currentSession == null
        ? const Login()
        : const Inicio();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destino),
    );
  }

  @override
  void dispose() {
    _animacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colores.primary,
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: _animacion, curve: Curves.elasticOut),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.place, size: 96, color: colores.onPrimary),
              const SizedBox(height: 16),
              Text(
                'Mis Lugares Favoritos',
                style: TextStyle(
                  color: colores.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
