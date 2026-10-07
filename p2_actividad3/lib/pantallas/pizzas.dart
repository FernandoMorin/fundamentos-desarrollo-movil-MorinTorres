import 'package:flutter/material.dart';
import 'package:p2_actividad3/colores.dart';
import 'package:p2_actividad3/estado.dart';
import 'package:p2_actividad3/foto_pizza.dart';

class Pizzas extends StatefulWidget {
  const Pizzas({super.key});

  @override
  State<Pizzas> createState() => _PizzasState();
}

class _PizzasState extends State<Pizzas> {
  final _pizzas = supabase
      .from('pizzas')
      .select()
      .eq('disponible', true)
      .order('id');
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Buscador
        Container(
          color: azul,
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar pizza',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (texto) => setState(() => _busqueda = texto.trim()),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _pizzas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final pizzas = (snapshot.data ?? []).where((pizza) {
                final nombre = '${pizza['nombre']}'.toLowerCase();
                return nombre.contains(_busqueda.toLowerCase());
              }).toList();
              if (pizzas.isEmpty) {
                return const Center(child: Text('No se encontraron pizzas.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: pizzas.length,
                itemBuilder: (context, index) => _tarjeta(pizzas[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _tarjeta(Map<String, dynamic> pizza) {
    return GestureDetector(
      onTap: () => _elegirTamano(pizza),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: grisClaro,
          border: Border.all(color: azul, width: 1.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 80,
                height: 80,
                child: FotoPizza(pizza: pizza),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                pizza['nombre'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Desde\n${precio(pizza['precio_chica'])}',
              textAlign: TextAlign.right,
              style: const TextStyle(color: azul, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Elegir tamaño y cantidad
  void _elegirTamano(Map<String, dynamic> pizza) {
    var tamano = 'mediana';
    var cantidad = 1;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, actualizar) {
          final total = (pizza['precio_$tamano'] as num) * cantidad;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  pizza['nombre'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: azul,
                  ),
                ),
                if (pizza['descripcion'] != null) Text(pizza['descripcion']),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final opcion in nombresTamano.keys)
                      ChoiceChip(
                        label: Text(
                          '${nombresTamano[opcion]} · ${precio(pizza['precio_$opcion'])}',
                        ),
                        selected: tamano == opcion,
                        onSelected: (_) => actualizar(() => tamano = opcion),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      onPressed: cantidad > 1
                          ? () => actualizar(() => cantidad--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '$cantidad',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    IconButton.outlined(
                      onPressed: () => actualizar(() => cantidad++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: azul,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    carrito.agregar(pizza, tamano, cantidad);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${pizza['nombre']} agregada al carrito'),
                      ),
                    );
                  },
                  child: Text('Agregar al carrito · ${precio(total)}'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
