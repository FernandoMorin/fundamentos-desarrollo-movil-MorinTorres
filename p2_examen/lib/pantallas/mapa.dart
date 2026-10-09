import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:p2_examen/datos/lugar.dart';
import 'package:p2_examen/datos/mis_lugares.dart';
import 'package:p2_examen/datos/ubicacion.dart';
import 'package:p2_examen/pantallas/formulario.dart';
import 'package:p2_examen/widgets/confirmar_eliminar.dart';
import 'package:p2_examen/widgets/foto_lugar.dart';
import 'package:p2_examen/widgets/mapa_comun.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  final _mapa = MapController();
  LatLng? _yo;
  bool _mapaListo = false;
  bool _ajustado = false;
  bool _buscando = false;

  @override
  void initState() {
    super.initState();
    misLugares.addListener(_ajustarAlCargar);
    _ubicarme(centrar: false);
  }

  @override
  void dispose() {
    misLugares.removeListener(_ajustarAlCargar);
    super.dispose();
  }

  void _ajustarAlCargar() {
    if (!_ajustado && _mapaListo && misLugares.lista.isNotEmpty) {
      _ajustado = true;
      _verTodos();
    }
  }

  Future<void> _ubicarme({bool centrar = true}) async {
    setState(() => _buscando = true);
    try {
      final yo = await miUbicacion();
      if (!mounted) return;
      setState(() => _yo = yo);
      if (centrar && _mapaListo) _mapa.move(yo, 16);
    } catch (e) {
      if (centrar && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  void _verTodos() {
    final puntos = [for (final lugar in misLugares.lista) lugar.punto, ?_yo];
    if (puntos.isEmpty) return;
    _mapa.fitCamera(
      CameraFit.coordinates(
        coordinates: puntos,
        padding: const EdgeInsets.all(60),
        maxZoom: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListenableBuilder(
          listenable: misLugares,
          builder: (context, _) => FlutterMap(
            mapController: _mapa,
            options: MapOptions(
              initialCenter: puntoInicial,
              initialZoom: 13,
              onMapReady: () {
                _mapaListo = true;
                _ajustarAlCargar();
              },
            ),
            children: [
              capaOpenStreetMap(),
              MarkerLayer(
                markers: [
                  if (_yo != null) marcadorMiUbicacion(_yo!),
                  for (final lugar in misLugares.lista) _pin(lugar),
                ],
              ),
              creditosOpenStreetMap,
            ],
          ),
        ),
        // Controles
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            children: [
              IconButton.filled(
                tooltip: 'Mi ubicación',
                onPressed: _buscando ? null : _ubicarme,
                icon: const Icon(Icons.my_location),
              ),
              const SizedBox(height: 8),
              IconButton.filled(
                tooltip: 'Ver todos mis lugares',
                onPressed: _verTodos,
                icon: const Icon(Icons.zoom_out_map),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Marker _pin(Lugar lugar) {
    final colores = Theme.of(context).colorScheme;
    return Marker(
      point: lugar.punto,
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: () => _detalle(lugar),
        child: Container(
          decoration: BoxDecoration(
            color: colores.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black38)],
          ),
          child: Icon(lugar.infoCategoria.icono, color: colores.onPrimary),
        ),
      ),
    );
  }

  // Ficha del lugar
  void _detalle(Lugar lugar) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (contexto) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(height: 180, child: FotoLugar(lugar: lugar)),
            ),
            const SizedBox(height: 12),
            Text(lugar.nombre, style: Theme.of(contexto).textTheme.titleLarge),
            Row(
              children: [
                Icon(lugar.infoCategoria.icono, size: 18),
                const SizedBox(width: 4),
                Text(lugar.infoCategoria.nombre),
              ],
            ),
            if (lugar.descripcion != null) ...[
              const SizedBox(height: 8),
              Text(lugar.descripcion!),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(contexto);
                      await confirmarEliminar(context, lugar);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Eliminar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(contexto);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Formulario(lugar: lugar),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
