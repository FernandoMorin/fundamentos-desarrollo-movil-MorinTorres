import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

const puntoInicial = LatLng(22.1565, -100.9855);

Future<LatLng> miUbicacion() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    throw 'La ubicación del dispositivo está apagada';
  }
  var permiso = await Geolocator.checkPermission();
  if (permiso == LocationPermission.denied) {
    permiso = await Geolocator.requestPermission();
  }
  if (permiso == LocationPermission.denied ||
      permiso == LocationPermission.deniedForever) {
    throw 'No diste permiso de ubicación';
  }
  try {
    final posicion = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return LatLng(posicion.latitude, posicion.longitude);
  } catch (_) {
    throw 'No se pudo obtener tu ubicación';
  }
}
