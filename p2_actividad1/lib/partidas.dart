import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const rojoDota = Color(0xFFA72714);
const verdeGanador = Color(0xFF2E7D32);
const grisPerdedor = Color(0xFF424242);

class Partidas extends StatefulWidget {
  const Partidas({super.key});

  @override
  State<Partidas> createState() => _PartidasState();
}

class _PartidasState extends State<Partidas> {
  final List<dynamic> _todas = [];
  bool _cargando = false;
  bool _fin = false;
  String? _error;
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    _cargarMas();
  }

  Future<void> _cargarMas() async {
    if (_cargando || _fin) return;
    _cargando = true;
    var url = 'https://api.opendota.com/api/proMatches';
    if (_todas.isNotEmpty) {
      url += '?less_than_match_id=${_todas.last['match_id']}';
    }
    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode != 200) {
        throw 'No se pudieron cargar las partidas (${respuesta.statusCode})';
      }
      final nuevas = jsonDecode(respuesta.body) as List<dynamic>;
      if (!mounted) return;
      setState(() {
        _todas.addAll(nuevas);
        _fin = nuevas.isEmpty;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      _cargando = false;
    }
  }

  void _reintentar() {
    setState(() => _error = null);
    _cargarMas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Partidas Pro Dota 2'),
        backgroundColor: rojoDota,
        foregroundColor: Colors.white,
      ),
      body: _cuerpo(),
    );
  }

  Widget _cuerpo() {
    if (_todas.isEmpty) {
      if (_error == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $_error'),
            TextButton(onPressed: _reintentar, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    final partidas = _todas.where((partida) {
      final equipos = '${partida['radiant_name']} ${partida['dire_name']}';
      return equipos.toLowerCase().contains(_busqueda.toLowerCase());
    }).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar equipo',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (texto) => setState(() => _busqueda = texto.trim()),
          ),
        ),
        Expanded(child: _lista(partidas)),
      ],
    );
  }

  Widget _final() {
    final Widget contenido;
    if (_fin) {
      contenido = const Text('No hay más partidas.');
    } else if (_error != null) {
      contenido = Column(
        children: [
          Text('Error: $_error'),
          TextButton(onPressed: _reintentar, child: const Text('Reintentar')),
        ],
      );
    } else if (_busqueda.isNotEmpty) {
      contenido = OutlinedButton(
        onPressed: _cargando
            ? null
            : () {
                _cargarMas();
                setState(() {});
              },
        child: const Text('Ver anteriores'),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _cargarMas());
      contenido = const CircularProgressIndicator();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(child: contenido),
    );
  }

  Widget _lista(List<dynamic> partidas) {
    return ListView.builder(
      itemCount: partidas.length + 1,
      itemBuilder: (context, index) {
        if (index == partidas.length) return _final();
        final partida = partidas[index];
        final radiant = partida['radiant_name'] ?? 'Radiant';
        final dire = partida['dire_name'] ?? 'Dire';
        final ganoRadiant = partida['radiant_win'] == true;
        final duracion = partida['duration'] ?? 0;
        final minutos = duracion ~/ 60;
        final segundos = (duracion % 60).toString().padLeft(2, '0');
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: rojoDota,
                child: Text(
                  '$radiant vs $dire',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _dato('Evento', partida['league_name'] ?? 'Desconocido'),
                    _dato('Duración', '$minutos:$segundos min'),
                  ],
                ),
              ),
              Row(
                children: [
                  _equipo('$radiant  ${partida['radiant_score']}', ganoRadiant),
                  _equipo('${partida['dire_score']}  $dire', !ganoRadiant),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dato(String etiqueta, String valor) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$etiqueta: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: valor),
        ],
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _equipo(String texto, bool gano) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: gano ? verdeGanador : grisPerdedor,
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
