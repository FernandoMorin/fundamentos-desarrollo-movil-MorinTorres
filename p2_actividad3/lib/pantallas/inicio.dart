import 'package:flutter/material.dart';
import 'package:p2_actividad3/colores.dart';
import 'package:p2_actividad3/estado.dart';
import 'package:p2_actividad3/pantallas/carrito.dart';
import 'package:p2_actividad3/pantallas/pedidos.dart';
import 'package:p2_actividad3/pantallas/perfil.dart';
import 'package:p2_actividad3/pantallas/pizzas.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _seccion = 0;
  int _visitasPedidos = 0;

  void _ir(int seccion) {
    setState(() {
      if (seccion == 2) _visitasPedidos++;
      _seccion = seccion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _encabezado(),
            Expanded(
              child: IndexedStack(
                index: _seccion,
                children: [
                  const Pizzas(),
                  CarritoPantalla(alPedir: () => _ir(2)),
                  Pedidos(key: ValueKey(_visitasPedidos)),
                  const Perfil(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _barra(),
    );
  }

  Widget _encabezado() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: grisClaro,
              shape: BoxShape.circle,
              border: Border.all(color: azul, width: 2),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'PIZZERÍA',
            style: TextStyle(color: azul, fontSize: 24, letterSpacing: 4),
          ),
        ],
      ),
    );
  }

  Widget _barra() {
    return Container(
      color: azul,
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _boton(0, Icons.home, 'Pizzas'),
          _boton(1, Icons.shopping_cart, 'Carrito', conContador: true),
          _boton(2, Icons.receipt_long, 'Pedidos'),
          _boton(3, Icons.person, 'Mi perfil'),
        ],
      ),
    );
  }

  Widget _boton(
    int indice,
    IconData icono,
    String texto, {
    bool conContador = false,
  }) {
    final activo = _seccion == indice;
    Widget dibujo = Icon(icono, color: azul, size: activo ? 32 : 24);
    if (conContador) {
      dibujo = ListenableBuilder(
        listenable: carrito,
        builder: (context, _) => Badge(
          isLabelVisible: carrito.cantidad > 0,
          label: Text('${carrito.cantidad}'),
          child: Icon(icono, color: azul, size: activo ? 32 : 24),
        ),
      );
    }
    return GestureDetector(
      onTap: () => _ir(indice),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: activo ? 64 : 48,
            height: activo ? 64 : 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(child: dibujo),
          ),
          const SizedBox(height: 4),
          Text(
            texto,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: activo ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
