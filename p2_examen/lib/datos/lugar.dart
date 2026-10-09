import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:p2_examen/datos/supabase.dart';

class Categoria {
  const Categoria(this.nombre, this.icono);

  final String nombre;
  final IconData icono;
}

const categorias = {
  'comida': Categoria('Comida', Icons.restaurant),
  'estudio': Categoria('Estudio', Icons.school),
  'diversion': Categoria('Diversión', Icons.celebration),
  'deporte': Categoria('Deporte', Icons.sports_soccer),
  'casa': Categoria('Casa', Icons.home),
  'otro': Categoria('Otro', Icons.place),
};

class Lugar {
  Lugar({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.categoria,
    required this.latitud,
    required this.longitud,
    this.fotoPath,
  });

  factory Lugar.fromMap(Map<String, dynamic> fila) {
    return Lugar(
      id: fila['id'],
      nombre: fila['nombre'],
      descripcion: fila['descripcion'],
      categoria: fila['categoria'],
      latitud: (fila['latitud'] as num).toDouble(),
      longitud: (fila['longitud'] as num).toDouble(),
      fotoPath: fila['foto_path'],
    );
  }

  final int? id;
  final String nombre;
  final String? descripcion;
  final String categoria;
  final double latitud;
  final double longitud;
  final String? fotoPath;

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'descripcion': descripcion,
    'categoria': categoria,
    'latitud': latitud,
    'longitud': longitud,
    'foto_path': fotoPath,
  };

  LatLng get punto => LatLng(latitud, longitud);

  Categoria get infoCategoria => categorias[categoria] ?? categorias['otro']!;

  String? get fotoUrl => fotoPath == null
      ? null
      : supabase.storage.from('fotos').getPublicUrl(fotoPath!);
}
