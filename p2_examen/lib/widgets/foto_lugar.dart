import 'package:flutter/material.dart';
import 'package:p2_examen/datos/lugar.dart';

class FotoLugar extends StatelessWidget {
  const FotoLugar({super.key, required this.lugar});

  final Lugar lugar;

  @override
  Widget build(BuildContext context) {
    final url = lugar.fotoUrl;
    if (url == null) return _sinFoto(context);
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => _sinFoto(context),
    );
  }

  Widget _sinFoto(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      color: colores.surfaceContainerHighest,
      child: Icon(lugar.infoCategoria.icono, color: colores.onSurfaceVariant),
    );
  }
}
