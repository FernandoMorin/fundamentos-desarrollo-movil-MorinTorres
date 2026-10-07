import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:p2_actividad3/colores.dart';
import 'package:p2_actividad3/estado.dart';
import 'package:p2_actividad3/pantallas/login.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final _nombre = TextEditingController(text: usuarioActual!['nombre']);
  final _telefono = TextEditingController(text: usuarioActual!['telefono']);
  bool _guardando = false;

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    try {
      await supabase.rpc(
        'actualizar_perfil',
        params: {
          'p_usuario_id': usuarioActual!['id'],
          'p_nombre': _nombre.text.trim(),
          'p_telefono': _telefono.text.trim(),
        },
      );
      usuarioActual!['nombre'] = _nombre.text.trim();
      usuarioActual!['telefono'] = _telefono.text.trim();
      _mensaje('Datos guardados');
    } on PostgrestException catch (e) {
      _mensaje(e.message);
    } catch (e) {
      _mensaje('No se pudo guardar: $e');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _cerrarSesion() {
    usuarioActual = null;
    carrito.vaciar();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  void _mensaje(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: azul,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Foto de perfil
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: azul, size: 60),
              ),
              const SizedBox(height: 12),
              Text(
                '@${usuarioActual!['usuario']}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _telefono,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: azul,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: _guardando ? null : _guardar,
                child: Text(_guardando ? 'Guardando...' : 'Guardar cambios'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: _cerrarSesion,
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
