import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:p2_examen/datos/supabase.dart';
import 'package:p2_examen/pantallas/inicio.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  bool _registrando = false;
  bool _cargando = false;
  bool _oculta = true;
  String? _error;

  Future<void> _enviar() async {
    final correo = _correo.text.trim();
    final contrasena = _contrasena.text;
    if (correo.isEmpty || contrasena.isEmpty) {
      setState(() => _error = 'Escribe tu correo y contraseña');
      return;
    }
    if (_registrando && contrasena.length < 6) {
      setState(() => _error = 'La contraseña debe tener al menos 6 caracteres');
      return;
    }
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      if (_registrando) {
        final respuesta = await supabase.auth.signUp(
          email: correo,
          password: contrasena,
        );
        if (respuesta.session == null) {
          throw const AuthException(
            'Revisa tu correo para confirmar la cuenta',
          );
        }
      } else {
        await supabase.auth.signInWithPassword(
          email: correo,
          password: contrasena,
        );
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Inicio()),
      );
    } on AuthRetryableFetchException {
      setState(() => _error = 'Sin conexión a internet');
    } on AuthException catch (e) {
      setState(() => _error = _traducir(e.message));
    } catch (_) {
      setState(() => _error = 'Sin conexión a internet');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  String _traducir(String mensaje) {
    if (mensaje.contains('Invalid login credentials')) {
      return 'Correo o contraseña incorrectos';
    }
    if (mensaje.contains('already registered')) {
      return 'Ese correo ya está registrado';
    }
    if (mensaje.contains('Password should be')) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    if (mensaje.contains('invalid')) return 'Correo no válido';
    return mensaje;
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.place, size: 72, color: colores.primary),
                const SizedBox(height: 8),
                Text(
                  'Mis Lugares Favoritos',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _registrando ? 'Crea tu cuenta' : 'Inicia sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colores.onSurfaceVariant),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _correo,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contrasena,
                  obscureText: _oculta,
                  onSubmitted: (_) => _enviar(),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _oculta = !_oculta),
                      icon: Icon(
                        _oculta ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colores.error),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _cargando ? null : _enviar,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(
                    _cargando
                        ? 'Un momento...'
                        : _registrando
                        ? 'Crear cuenta'
                        : 'Entrar',
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() {
                    _registrando = !_registrando;
                    _error = null;
                  }),
                  child: Text(
                    _registrando
                        ? 'Ya tengo cuenta'
                        : '¿No tienes cuenta? Regístrate',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
