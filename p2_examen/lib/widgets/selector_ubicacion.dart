import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:p2_examen/datos/ubicacion.dart';
import 'package:p2_examen/widgets/mapa_comun.dart';

class SelectorUbicacion extends StatefulWidget {
  const SelectorUbicacion({
    super.key,
    required this.inicial,
    required this.buscarMiUbicacion,
    required this.alCambiar,
  });

  final LatLng inicial;
  final bool buscarMiUbicacion;
  final ValueChanged<LatLng> alCambiar;

  @override
  State<SelectorUbicacion> createState() => _SelectorUbicacionState();
}

class _SelectorUbicacionState extends State<SelectorUbicacion> {
  final _mapa = MapController();
  late LatLng _punto = widget.inicial;
  LatLng? _yo;
  bool _mapaListo = false;
  bool _buscando = false;
  String? _aviso;

  @override
  void initState() {
    super.initState();
    _ubicarme(moverPin: widget.buscarMiUbicacion);
  }

  Future<void> _ubicarme({bool moverPin = true}) async {
    setState(() {
      _buscando = true;
      _aviso = null;
    });
    try {
      final yo = await miUbicacion();
      if (!mounted) return;
      setState(() {
        _yo = yo;
        if (moverPin) _punto = yo;
      });
      if (moverPin) {
        widget.alCambiar(yo);
        if (_mapaListo) _mapa.move(yo, 16);
      }
    } catch (e) {
      if (mounted) setState(() => _aviso = '$e. Toca el mapa para elegir.');
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  void _elegir(LatLng punto) {
    setState(() => _punto = punto);
    widget.alCambiar(punto);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
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
              onTap: (_, punto) => _elegir(punto),
            ),
            children: [
              capaOpenStreetMap(),
              MarkerLayer(
                markers: [
                  if (_yo != null) marcadorMiUbicacion(_yo!),
                  Marker(
                    point: _punto,
                    width: 44,
                    height: 44,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 44,
                    ),
                  ),
                ],
              ),
              creditosOpenStreetMap,
            ],
          ),
          if (_buscando || _aviso != null)
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _buscando ? 'Buscando tu ubicación...' : _aviso!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 8,
            bottom: 24,
            child: IconButton.filled(
              tooltip: 'Usar mi ubicación',
              onPressed: _buscando ? null : _ubicarme,
              icon: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
