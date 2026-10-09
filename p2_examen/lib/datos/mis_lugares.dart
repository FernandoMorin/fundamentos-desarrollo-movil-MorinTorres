import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:p2_examen/datos/lugar.dart';
import 'package:p2_examen/datos/supabase.dart';

class MisLugares extends ChangeNotifier {
  List<Lugar> lista = [];
  bool cargando = false;
  String? error;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      final filas = await supabase
          .from('lugares')
          .select()
          .order('created_at', ascending: false);
      lista = filas.map(Lugar.fromMap).toList();
    } catch (_) {
      error = 'No se pudieron cargar tus lugares. Revisa tu conexión.';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> guardar(
    Lugar lugar, {
    Uint8List? foto,
    String extension = 'jpg',
  }) async {
    final fotoAnterior = lugar.fotoPath;
    var fotoPath = fotoAnterior;
    if (foto != null) {
      fotoPath =
          '${supabase.auth.currentUser!.id}/${DateTime.now().millisecondsSinceEpoch}.$extension';
      await supabase.storage
          .from('fotos')
          .uploadBinary(
            fotoPath,
            foto,
            fileOptions: FileOptions(
              contentType: 'image/${extension == 'jpg' ? 'jpeg' : extension}',
            ),
          );
    }
    final datos = {...lugar.toMap(), 'foto_path': fotoPath};
    try {
      if (lugar.id == null) {
        await supabase.from('lugares').insert(datos);
      } else {
        await supabase.from('lugares').update(datos).eq('id', lugar.id!);
      }
    } catch (_) {
      if (foto != null) await _borrarFoto(fotoPath!);
      rethrow;
    }
    if (foto != null && fotoAnterior != null) await _borrarFoto(fotoAnterior);
    await cargar();
  }

  Future<void> eliminar(Lugar lugar) async {
    await supabase.from('lugares').delete().eq('id', lugar.id!);
    if (lugar.fotoPath != null) await _borrarFoto(lugar.fotoPath!);
    lista.removeWhere((otro) => otro.id == lugar.id);
    notifyListeners();
  }

  Future<void> _borrarFoto(String path) async {
    try {
      await supabase.storage.from('fotos').remove([path]);
    } catch (_) {}
  }

  void limpiar() {
    lista = [];
    error = null;
    notifyListeners();
  }
}

final misLugares = MisLugares();
