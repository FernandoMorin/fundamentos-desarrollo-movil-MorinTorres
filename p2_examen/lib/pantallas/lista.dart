import 'package:flutter/material.dart';
import 'package:p2_examen/datos/lugar.dart';
import 'package:p2_examen/datos/mis_lugares.dart';
import 'package:p2_examen/pantallas/formulario.dart';
import 'package:p2_examen/widgets/confirmar_eliminar.dart';
import 'package:p2_examen/widgets/foto_lugar.dart';

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  String _busqueda = '';
  String? _categoria;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: misLugares,
      builder: (context, _) {
        if (misLugares.lista.isEmpty) {
          if (misLugares.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (misLugares.error != null) return _error();
        }
        final filtrados = misLugares.lista.where((lugar) {
          final coincideNombre = lugar.nombre.toLowerCase().contains(
            _busqueda.toLowerCase(),
          );
          final coincideCategoria =
              _categoria == null || lugar.categoria == _categoria;
          return coincideNombre && coincideCategoria;
        }).toList();
        return Column(
          children: [
            // Buscador
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar por nombre',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (texto) => setState(() => _busqueda = texto.trim()),
              ),
            ),
            // Filtro por categoría
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _chip(null, 'Todas', Icons.apps),
                  for (final entrada in categorias.entries)
                    _chip(
                      entrada.key,
                      entrada.value.nombre,
                      entrada.value.icono,
                    ),
                ],
              ),
            ),
            // Contador
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  filtrados.length == misLugares.lista.length
                      ? '${misLugares.lista.length} lugares'
                      : '${filtrados.length} de ${misLugares.lista.length} lugares',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: misLugares.cargar,
                child: filtrados.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Text(
                              misLugares.lista.isEmpty
                                  ? 'Aún no tienes lugares.\nToca "Agregar" para guardar el primero.'
                                  : 'Ningún lugar coincide.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                        itemCount: filtrados.length,
                        itemBuilder: (context, index) =>
                            _tarjeta(filtrados[index]),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _chip(String? clave, String texto, IconData icono) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Icon(icono, size: 18),
        label: Text(texto),
        selected: _categoria == clave,
        onSelected: (_) => setState(() => _categoria = clave),
      ),
    );
  }

  Widget _tarjeta(Lugar lugar) {
    final colores = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Formulario(lugar: lugar)),
        ),
        child: Row(
          children: [
            SizedBox(width: 96, height: 96, child: FotoLugar(lugar: lugar)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lugar.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        lugar.infoCategoria.icono,
                        size: 16,
                        color: colores.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        lugar.infoCategoria.nombre,
                        style: TextStyle(color: colores.primary),
                      ),
                    ],
                  ),
                  if (lugar.descripcion != null)
                    Text(
                      lugar.descripcion!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colores.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Eliminar',
              onPressed: () => confirmarEliminar(context, lugar),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _error() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 48),
          const SizedBox(height: 8),
          Text(misLugares.error!),
          TextButton(
            onPressed: misLugares.cargar,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
