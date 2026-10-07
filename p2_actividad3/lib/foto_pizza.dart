import 'package:flutter/material.dart';
import 'package:p2_actividad3/estado.dart';

class FotoPizza extends StatelessWidget {
  const FotoPizza({super.key, required this.pizza});

  final Map<String, dynamic> pizza;

  @override
  Widget build(BuildContext context) {
    final archivo = '${pizza['imagen_url'] ?? ''}'.trim();
    if (archivo.isEmpty) return Container(color: Colors.white);
    final url = archivo.startsWith('http')
        ? archivo
        : supabase.storage.from('pizzas').getPublicUrl(archivo);
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => Container(color: Colors.white),
    );
  }
}
