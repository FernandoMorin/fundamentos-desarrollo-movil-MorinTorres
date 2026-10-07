import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:p2_actividad3/colores.dart';
import 'package:p2_actividad3/estado.dart';
import 'package:p2_actividad3/pantallas/inicio.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usuario = TextEditingController();
  final _contrasena = TextEditingController();
  final _nombre = TextEditingController();
  final _telefono = TextEditingController();
  bool _registrando = false;
  bool _cargando = false;
  String? _error;

  Future<void> _enviar() async {
    if (_usuario.text.trim().isEmpty || _contrasena.text.isEmpty) {
      setState(() => _error = 'Escribe tu usuario y contraseña');
      return;
    }
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final datos = _registrando
          ? await supabase.rpc(
              'registrar',
              params: {
                'p_usuario': _usuario.text.trim(),
                'p_contrasena': _contrasena.text,
                'p_nombre': _nombre.text.trim(),
                'p_telefono': _telefono.text.trim(),
              },
            )
          : await supabase.rpc(
              'iniciar_sesion',
              params: {
                'p_usuario': _usuario.text.trim(),
                'p_contrasena': _contrasena.text,
              },
            );
      usuarioActual = Map<String, dynamic>.from(datos);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Inicio()),
      );
    } on PostgrestException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'No se pudo conectar: $e');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulNoche,
      body: LayoutBuilder(
        builder: (context, medidas) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: medidas.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Logo
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(child: _panel()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      decoration: const BoxDecoration(
        color: azul,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Text(
            _registrando ? 'Crear cuenta' : 'Iniciar sesión',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _campo(_usuario, 'Usuario', Icons.person),
          _campo(_contrasena, 'Contraseña', Icons.lock, oculto: true),
          if (_registrando) ...[
            _campo(_nombre, 'Nombre', Icons.badge),
            _campo(
              _telefono,
              'Teléfono',
              Icons.phone,
              teclado: TextInputType.phone,
            ),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.amberAccent),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => setState(() {
                  _registrando = !_registrando;
                  _error = null;
                }),
                child: Text(
                  _registrando
                      ? 'Ya tengo cuenta'
                      : '¿No tienes cuenta? Regístrate',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: _cargando ? null : _enviar,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: _cargando
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : const Icon(Icons.arrow_forward, color: azul, size: 32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _campo(
    TextEditingController controlador,
    String texto,
    IconData icono, {
    bool oculto = false,
    TextInputType? teclado,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                controller: controlador,
                obscureText: oculto,
                keyboardType: teclado,
                decoration: InputDecoration(
                  hintText: texto,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: grisClaro,
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
