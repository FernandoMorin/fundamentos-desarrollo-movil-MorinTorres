import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

TileLayer capaOpenStreetMap() {
  return TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.example.p2_examen',
  );
}

const creditosOpenStreetMap = RichAttributionWidget(
  attributions: [TextSourceAttribution('OpenStreetMap contributors')],
);

Marker marcadorMiUbicacion(LatLng punto) {
  return Marker(
    point: punto,
    width: 22,
    height: 22,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
      ),
    ),
  );
}
