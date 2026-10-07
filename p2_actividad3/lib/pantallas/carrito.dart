import 'package:flutter/material.dart';
import 'package:p2_actividad3/colores.dart';
import 'package:p2_actividad3/estado.dart';
import 'package:p2_actividad3/foto_pizza.dart';
import 'package:p2_actividad3/pantallas/ubicacion.dart';

class CarritoPantalla extends StatelessWidget {
  const CarritoPantalla({super.key, required this.alPedir});

  final VoidCallback alPedir;

  Future<void> _elegirUbicacion(BuildContext context) async {
    final pedidoId = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => const Ubicacion()),
    );
    if (pedidoId == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('¡Pedido #$pedidoId realizado!')));
    alPedir();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: azulNoche,
      child: ListenableBuilder(
        listenable: carrito,
        builder: (context, _) {
          if (carrito.items.isEmpty) {
            return const Center(
              child: Text(
                'Tu carrito está vacío.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [for (final item in carrito.items) _renglon(item)],
                ),
              ),
              _resumen(context),
            ],
          );
        },
      ),
    );
  }

  Widget _renglon(ItemCarrito item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: azul,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => carrito.quitar(item),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          ClipOval(
            child: SizedBox(
              width: 64,
              height: 64,
              child: FotoPizza(pizza: item.pizza),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.pizza['nombre'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${nombresTamano[item.tamano]} × ${item.cantidad}'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '\$${item.subtotal.toStringAsFixed(2)}\nMXN',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumen(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Total: ${precio(carrito.total)}',
              style: const TextStyle(
                color: azul,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: azul),
            onPressed: () => _elegirUbicacion(context),
            icon: const Icon(Icons.location_on),
            label: const Text('Elegir entrega'),
          ),
        ],
      ),
    );
  }
}
