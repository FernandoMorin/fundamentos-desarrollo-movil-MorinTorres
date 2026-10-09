import 'package:flutter/material.dart';
import 'package:p2_examen/datos/mis_lugares.dart';
import 'package:p2_examen/datos/supabase.dart';
import 'package:p2_examen/pantallas/login.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    try {
      await supabase.auth.signOut();
    } catch (_) {}
    misLugares.limpiar();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final correo = supabase.auth.currentUser?.email ?? '';
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: colores.primaryContainer,
          child: Icon(
            Icons.person,
            size: 56,
            color: colores.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          correo,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: () => _cerrarSesion(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: colores.error,
            padding: const EdgeInsets.all(16),
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
        ),
      ],
    );
  }
}
