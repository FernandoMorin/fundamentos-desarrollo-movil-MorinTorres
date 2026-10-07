import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:p2_actividad3/colores.dart';
import 'package:p2_actividad3/estado.dart';

class Ubicacion extends StatefulWidget {
  const Ubicacion({super.key});

  @override
  State<Ubicacion> createState() => _UbicacionState();
}

class _UbicacionState extends State<Ubicacion> {
  final _mapa = MapController();
  final _direccion = TextEditingController();
  LatLng _punto = const LatLng(19.4326, -99.1332);
  bool _mapaListo = false;
  bool _buscando = false;
  bool _enviando = false;
  String? _aviso;

  @override
  void initState() {
    super.initState();
    _ubicarme();
  }

  Future<void> _ubicarme() async {
    setState(() {
      _buscando = true;
      _aviso = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'La ubicación del dispositivo está apagada';
      }
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        throw 'No diste permiso de ubicación';
      }
      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted) return;
      setState(() => _punto = LatLng(posicion.latitude, posicion.longitude));
      if (_mapaListo) _mapa.move(_punto, 16);
    } catch (e) {
      if (!mounted) return;
      setState(() => _aviso = '$e. Toca el mapa para elegir el punto.');
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  Future<void> _confirmar() async {
    setState(() => _enviando = true);
    try {
      final pedidoId = await supabase.rpc(
        'crear_pedido',
        params: {
          'p_usuario_id': usuarioActual!['id'],
          'p_direccion': _direccion.text.trim(),
          'p_latitud': _punto.latitude,
          'p_longitud': _punto.longitude,
          'p_items': [
            for (final item in carrito.items)
              {
                'pizza_id': item.pizza['id'],
                'tamano': item.tamano,
                'cantidad': item.cantidad,
              },
          ],
        },
      );
      carrito.vaciar();
      if (!mounted) return;
      Navigator.pop(context, pedidoId as int);
    } on PostgrestException catch (e) {
      _error(e.message);
    } catch (e) {
      _error('No se pudo enviar el pedido: $e');
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _error(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación de entrega'),
        backgroundColor: azul,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapa,
                  options: MapOptions(
                    initialCenter: _punto,
                    initialZoom: 15,
                    onMapReady: () {
                      _mapaListo = true;
                      _mapa.move(_punto, 15);
                    },
                    onTap: (_, punto) => setState(() => _punto = punto),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.p2_actividad3',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _punto,
                          width: 50,
                          height: 50,
                          alignment: Alignment.topCenter,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                    const RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution('OpenStreetMap contributors'),
                      ],
                    ),
                  ],
                ),
                if (_buscando || _aviso != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          _buscando ? 'Buscando tu ubicación...' : _aviso!,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: _buscando ? null : _ubicarme,
                    child: const Icon(Icons.my_location, color: azul),
                  ),
                ),
              ],
            ),
          ),
          _panel(),
        ],
      ),
    );
  }

  Widget _panel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _direccion,
              decoration: const InputDecoration(
                labelText: 'Dirección o referencias',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: azul,
                padding: const EdgeInsets.all(16),
              ),
              onPressed: _enviando ? null : _confirmar,
              child: Text(
                _enviando
                    ? 'Enviando...'
                    : 'Confirmar pedido · ${precio(carrito.total)}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
