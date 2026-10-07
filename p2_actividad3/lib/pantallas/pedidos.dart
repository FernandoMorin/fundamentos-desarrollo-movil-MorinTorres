import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:p2_actividad3/colores.dart';
import 'package:p2_actividad3/estado.dart';

const coloresEstado = {
  'pendiente': Colors.amber,
  'preparando': Colors.orange,
  'en camino': Colors.blue,
  'entregado': Colors.green,
  'cancelado': Colors.grey,
};

class Pedidos extends StatefulWidget {
  const Pedidos({super.key});

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  late Future<List<Map<String, dynamic>>> _pedidos = _cargar();

  Future<List<Map<String, dynamic>>> _cargar() {
    return supabase
        .from('pedidos')
        .select(
          '*, pedido_detalle(tamano, cantidad, precio_unitario, pizzas(nombre))',
        )
        .eq('usuario_id', usuarioActual!['id'])
        .order('created_at', ascending: false);
  }

  Future<void> _recargar() async {
    setState(() => _pedidos = _cargar());
    await _pedidos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _pedidos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final pedidos = snapshot.data ?? [];
        return RefreshIndicator(
          onRefresh: _recargar,
          child: pedidos.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text('Aún no tienes pedidos.')),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) => _tarjeta(pedidos[index]),
                ),
        );
      },
    );
  }

  Widget _tarjeta(Map<String, dynamic> pedido) {
    final fecha = DateTime.parse(pedido['created_at']).toLocal();
    final punto = LatLng(
      (pedido['latitud'] as num).toDouble(),
      (pedido['longitud'] as num).toDouble(),
    );
    final direccion = '${pedido['direccion'] ?? ''}'.trim();
    return Card(
      color: grisClaro,
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: azul,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Pedido #${pedido['id']} · ${_fecha(fecha)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(pedido['estado']),
                  backgroundColor: coloresEstado[pedido['estado']],
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final detalle in pedido['pedido_detalle'])
                  Text(
                    '${detalle['cantidad']} × ${detalle['pizzas']['nombre']} '
                    '(${nombresTamano[detalle['tamano']]}) · '
                    '${precio(detalle['precio_unitario'] * detalle['cantidad'])}',
                  ),
                const SizedBox(height: 8),
                Text(
                  'Total: ${precio(pedido['total'])}',
                  style: const TextStyle(
                    color: azul,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (direccion.isNotEmpty) Text('Entregar en: $direccion'),
              ],
            ),
          ),
          // Mapa de entrega
          SizedBox(
            height: 140,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: punto,
                initialZoom: 15,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.p2_actividad3',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: punto,
                      width: 36,
                      height: 36,
                      alignment: Alignment.topCenter,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fecha(DateTime f) {
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(f.day)}/${dos(f.month)}/${f.year} ${dos(f.hour)}:${dos(f.minute)}';
  }
}
