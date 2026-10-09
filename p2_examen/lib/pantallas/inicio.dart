import 'package:flutter/material.dart';
import 'package:p2_examen/datos/mis_lugares.dart';
import 'package:p2_examen/pantallas/formulario.dart';
import 'package:p2_examen/pantallas/lista.dart';
import 'package:p2_examen/pantallas/mapa.dart';
import 'package:p2_examen/pantallas/perfil.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _seccion = 0;

  static const _titulos = ['Mis lugares', 'Mapa', 'Mi perfil'];

  @override
  void initState() {
    super.initState();
    misLugares.cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_seccion])),
      body: IndexedStack(
        index: _seccion,
        children: const [Lista(), Mapa(), Perfil()],
      ),
      floatingActionButton: _seccion == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Formulario()),
              ),
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Agregar'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (indice) => setState(() => _seccion = indice),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Lugares',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
