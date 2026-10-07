import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// Sesión
Map<String, dynamic>? usuarioActual;

const nombresTamano = {
  'chica': 'Chica',
  'mediana': 'Mediana',
  'grande': 'Grande',
};

String precio(num valor) => '\$${valor.toStringAsFixed(2)} MXN';

class ItemCarrito {
  ItemCarrito(this.pizza, this.tamano, this.cantidad);

  final Map<String, dynamic> pizza;
  final String tamano;
  int cantidad;

  num get precioUnitario => pizza['precio_$tamano'];
  num get subtotal => precioUnitario * cantidad;
}

// Carrito
class Carrito extends ChangeNotifier {
  final List<ItemCarrito> items = [];

  int get cantidad => items.fold(0, (suma, item) => suma + item.cantidad);
  num get total => items.fold(0, (suma, item) => suma + item.subtotal);

  void agregar(Map<String, dynamic> pizza, String tamano, int cantidad) {
    for (final item in items) {
      if (item.pizza['id'] == pizza['id'] && item.tamano == tamano) {
        item.cantidad += cantidad;
        notifyListeners();
        return;
      }
    }
    items.add(ItemCarrito(pizza, tamano, cantidad));
    notifyListeners();
  }

  void quitar(ItemCarrito item) {
    items.remove(item);
    notifyListeners();
  }

  void vaciar() {
    items.clear();
    notifyListeners();
  }
}

final carrito = Carrito();
