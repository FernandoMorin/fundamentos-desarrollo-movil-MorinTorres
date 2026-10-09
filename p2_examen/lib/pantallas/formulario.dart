import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:p2_examen/datos/lugar.dart';
import 'package:p2_examen/datos/mis_lugares.dart';
import 'package:p2_examen/datos/ubicacion.dart';
import 'package:p2_examen/widgets/confirmar_eliminar.dart';
import 'package:p2_examen/widgets/foto_lugar.dart';
import 'package:p2_examen/widgets/selector_ubicacion.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key, this.lugar});

  final Lugar? lugar;

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  late final _nombre = TextEditingController(text: widget.lugar?.nombre);
  late final _descripcion = TextEditingController(
    text: widget.lugar?.descripcion,
  );
  late String _categoria = widget.lugar?.categoria ?? 'otro';
  late LatLng _punto = widget.lugar?.punto ?? puntoInicial;
  Uint8List? _foto;
  String _extension = 'jpg';
  bool _guardando = false;

  bool get _editando => widget.lugar != null;

  bool get _hayCamara =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> _elegirFoto(ImageSource fuente) async {
    try {
      final archivo = await ImagePicker().pickImage(
        source: fuente,
        maxWidth: 1280,
        imageQuality: 80,
      );
      if (archivo == null) return;
      final bytes = await archivo.readAsBytes();
      final extension = archivo.name.split('.').last.toLowerCase();
      setState(() {
        _foto = bytes;
        _extension = switch (extension) {
          'png' || 'webp' => extension,
          _ => 'jpg',
        };
      });
    } catch (_) {
      _mensaje('No se pudo abrir la foto');
    }
  }

  Future<void> _guardar() async {
    if (_nombre.text.trim().isEmpty) {
      _mensaje('Escribe el nombre del lugar');
      return;
    }
    if (!_editando && _foto == null) {
      _mensaje('Agrega una foto del lugar');
      return;
    }
    setState(() => _guardando = true);
    try {
      final descripcion = _descripcion.text.trim();
      await misLugares.guardar(
        Lugar(
          id: widget.lugar?.id,
          nombre: _nombre.text.trim(),
          descripcion: descripcion.isEmpty ? null : descripcion,
          categoria: _categoria,
          latitud: _punto.latitude,
          longitud: _punto.longitude,
          fotoPath: widget.lugar?.fotoPath,
        ),
        foto: _foto,
        extension: _extension,
      );
      if (!mounted) return;
      _mensaje(_editando ? 'Cambios guardados' : 'Lugar agregado');
      Navigator.pop(context);
    } catch (_) {
      _mensaje('No se pudo guardar. Revisa tu conexión.');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _eliminar() async {
    if (await confirmarEliminar(context, widget.lugar!) && mounted) {
      Navigator.pop(context);
    }
  }

  void _mensaje(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar lugar' : 'Nuevo lugar'),
        actions: [
          if (_editando)
            IconButton(
              tooltip: 'Eliminar',
              onPressed: _guardando ? null : _eliminar,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Foto
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(aspectRatio: 16 / 9, child: _vistaFoto()),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () => _elegirFoto(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Galería'),
              ),
              if (_hayCamara)
                TextButton.icon(
                  onPressed: () => _elegirFoto(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Cámara'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Datos
          TextField(
            controller: _nombre,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              prefixIcon: Icon(Icons.edit),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _categoria,
            decoration: const InputDecoration(labelText: 'Categoría'),
            items: [
              for (final entrada in categorias.entries)
                DropdownMenuItem(
                  value: entrada.key,
                  child: Row(
                    children: [
                      Icon(entrada.value.icono, size: 20),
                      const SizedBox(width: 12),
                      Text(entrada.value.nombre),
                    ],
                  ),
                ),
            ],
            onChanged: (valor) => setState(() => _categoria = valor!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descripcion,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Nota (opcional)',
              prefixIcon: Icon(Icons.notes),
            ),
          ),
          const SizedBox(height: 16),
          // Ubicación
          Text(
            'Ubicación · toca el mapa para mover el pin',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 260,
            child: SelectorUbicacion(
              inicial: _punto,
              buscarMiUbicacion: !_editando,
              alCambiar: (punto) => _punto = punto,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _guardando ? null : _guardar,
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            icon: const Icon(Icons.save),
            label: Text(_guardando ? 'Guardando...' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _vistaFoto() {
    if (_foto != null) return Image.memory(_foto!, fit: BoxFit.cover);
    if (_editando) return FotoLugar(lugar: widget.lugar!);
    final colores = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => _elegirFoto(ImageSource.gallery),
      child: Container(
        color: colores.surfaceContainerHighest,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 40, color: colores.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              'Agrega una foto',
              style: TextStyle(color: colores.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
