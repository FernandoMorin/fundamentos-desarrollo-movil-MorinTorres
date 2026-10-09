import 'package:flutter/material.dart';
import 'package:p2_examen/datos/lugar.dart';
import 'package:p2_examen/datos/mis_lugares.dart';

Future<bool> confirmarEliminar(BuildContext context, Lugar lugar) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      icon: const Icon(Icons.delete_outline),
      title: Text('¿Eliminar "${lugar.nombre}"?'),
      content: const Text('También se borrará su foto. No se puede deshacer.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(contexto, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(contexto).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(contexto, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
  if (confirmado != true) return false;
  try {
    await misLugares.eliminar(lugar);
    if (context.mounted) _avisar(context, 'Lugar eliminado');
    return true;
  } catch (_) {
    if (context.mounted) {
      _avisar(context, 'No se pudo eliminar. Revisa tu conexión.');
    }
    return false;
  }
}

void _avisar(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
}
