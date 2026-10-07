import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Canciones extends StatefulWidget {
  const Canciones({super.key});

  @override
  State<Canciones> createState() => _CancionesState();
}

class _CancionesState extends State<Canciones> {
  final _supabase = Supabase.instance.client.from('canciones').select();
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Canciones'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _supabase,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final todas = snapshot.data ?? [];
          if (todas.isEmpty) {
            return const Center(child: Text('No hay canciones disponibles.'));
          }
          final canciones = todas.where((cancion) {
            final titulo = '${cancion['titulo'] ?? ''}'.toLowerCase();
            return titulo.contains(_busqueda.toLowerCase());
          }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar canción',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (texto) =>
                      setState(() => _busqueda = texto.trim()),
                ),
              ),
              Expanded(
                child: canciones.isEmpty
                    ? const Center(child: Text('No se encontró la canción.'))
                    : ListView.builder(
                        itemCount: canciones.length,
                        itemBuilder: (context, index) {
                          final cancion = canciones[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.music_note),
                              title: Text(
                                cancion['titulo'] ?? 'Nombre desconocido',
                              ),
                              subtitle: Text(
                                cancion['artista'] ?? 'Artista desconocido',
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
