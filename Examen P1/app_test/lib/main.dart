import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Viaje',
      home: const ReservaPage(),
    );
  }
}

class ReservaPage extends StatefulWidget {
  const ReservaPage({super.key});

  @override
  State<ReservaPage> createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  String? _destinoSeleccionado;
  String _transporteSeleccionado = 'Avion';

  bool _hotelIncluido = false;
  bool _tourGuiado = false;
  bool _seguroViaje = false;
  bool _notificaciones = false;

  double _presupuesto = 3000;

  DateTime? _fechaViaje;

  void _limpiarFormulario() {
    setState(() {
      _nombreController.clear();
      _correoController.clear();
      _destinoSeleccionado = null;
      _transporteSeleccionado = 'Avion';
      _hotelIncluido = false;
      _tourGuiado = false;
      _seguroViaje = false;
      _notificaciones = false;
      _presupuesto = 3000;
      _fechaViaje = null;
    });
  }

  Future<void> _elegirFecha() async {
    final DateTime? fechaElegida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (fechaElegida != null) {
      setState(() {
        _fechaViaje = fechaElegida;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fecha seleccionada')),
      );
    }
  }

  void _mostrarResumen() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resumen del Viaje'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${_nombreController.text}'),
              Text('Correo: ${_correoController.text}'),
              Text('Destino: ${_destinoSeleccionado ?? "-"}'),
              Text('Transporte: $_transporteSeleccionado'),
              Text('Extras: ${_listaExtras()}'),
              Text('Notificaciones: ${_notificaciones ? "Activadas" : "Desactivadas"}'),
              Text('Presupuesto: \$${_presupuesto.round()}'),
              Text('Fecha: ${_fechaViaje == null ? "-" : _formatearFecha(_fechaViaje!)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmar();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  String _listaExtras() {
    final List<String> extras = [];
    if (_hotelIncluido) extras.add('Hotel');
    if (_tourGuiado) extras.add('Tour');
    if (_seguroViaje) extras.add('Seguro');
    if (extras.isEmpty) return 'Ninguno';
    return extras.join(', ');
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  void _confirmar() {
    final bool nombreValido = _nombreController.text.trim().isNotEmpty;
    final bool correoValido = _correoController.text.contains('@');
    final bool fechaValida = _fechaViaje != null;

    if (!nombreValido || !correoValido || !fechaValida) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Faltan datos'),
            content: const Text('Completa nombre, correo válido (@) y selecciona la fecha del viaje.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Entendido'),
              ),
            ],
          );
        },
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoletoPage(
          nombre: _nombreController.text,
          correo: _correoController.text,
          destino: _destinoSeleccionado ?? '-',
          transporte: _transporteSeleccionado,
          extras: _listaExtras(),
          notificaciones: _notificaciones,
          presupuesto: _presupuesto,
          fecha: _formatearFecha(_fechaViaje!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Viaje'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _limpiarFormulario,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Seccion 1
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE4F2FD),
                border: Border.all(color: const Color(0xFFA5C4D9), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF447391)),
                      const SizedBox(width: 8),
                      const Text('Sección 1 · Información general'),
                    ],
                  ),
                  const Text('Completa tu reserva paso a paso'),
                  const SizedBox(height: 8),
                  const Text('Llena tus datos, elige destino y confirma tu viaje.'),
                ],
              ),
            ),

            //Seccion 2
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6E9),
                border: Border.all(color: const Color(0xFFB5CDB7), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Color(0xFF3C8D41)),
                      const SizedBox(width: 8),
                      const Text('Sección 2 · Datos del viajero'),
                    ],
                  ),
                  const Text('¿Quién se va de viaje?'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Nombre completo',
                      hintText: 'Ej: Ana Garcia',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Correo electrónico',
                      hintText: 'Ej: ana@correo.com',
                    ),
                  ),
                ],
              ),
            ),

            //Seccion 3
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF3E3),
                border: Border.all(color: const Color(0xFFEFD3A3), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFC97B29)),
                      const SizedBox(width: 8),
                      const Text('Sección 3 · Destino y transporte'),
                    ],
                  ),
                  const Text('Elige tu aventura'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _destinoSeleccionado = 'Playa';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Destino: Playa')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: _destinoSeleccionado == 'Playa' ? Colors.blue : const Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.beach_access, color: Colors.blue),
                                Text('Playa'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _destinoSeleccionado = 'Ciudad';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Destino: Ciudad')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: _destinoSeleccionado == 'Ciudad' ? Colors.orange : const Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.location_city, color: Colors.orange),
                                Text('Ciudad'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _destinoSeleccionado = 'Montaña';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Destino: Montaña')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: _destinoSeleccionado == 'Montaña' ? Colors.green : const Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.landscape, color: Colors.green),
                                Text('Montaña'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Transporte:'),
                  DropdownButtonFormField<String>(
                    initialValue: _transporteSeleccionado,
                    items: const [
                      DropdownMenuItem(value: 'Avion', child: Text('Avión')),
                      DropdownMenuItem(value: 'Autobus', child: Text('Autobús')),
                      DropdownMenuItem(value: 'Tren', child: Text('Tren')),
                      DropdownMenuItem(value: 'Barco', child: Text('Barco')),
                    ],
                    onChanged: (valor) {
                      setState(() {
                        _transporteSeleccionado = valor ?? _transporteSeleccionado;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transporte: $valor')),
                      );
                    },
                  ),
                ],
              ),
            ),

            //Seccion 4
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7EAF9),
                border: Border.all(color: const Color(0xFFD7B8E0), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune, color: Color(0xFF8E44AD)),
                      const SizedBox(width: 8),
                      const Text('Sección 4 · Extras y preferencias'),
                    ],
                  ),
                  const Text('Personaliza tu experiencia'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: _hotelIncluido ? const Color(0xFFD4E9D5) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CheckboxListTile(
                      secondary: const Icon(Icons.hotel),
                      title: const Text('Hotel incluido'),
                      subtitle: const Text('+ \$1200'),
                      value: _hotelIncluido,
                      onChanged: (valor) {
                        setState(() {
                          _hotelIncluido = valor ?? false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hotel incluido actualizado')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _tourGuiado ? const Color(0xFFD4E9D5) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CheckboxListTile(
                      secondary: const Icon(Icons.tour),
                      title: const Text('Tour guiado'),
                      subtitle: const Text('+ \$600'),
                      value: _tourGuiado,
                      onChanged: (valor) {
                        setState(() {
                          _tourGuiado = valor ?? false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tour guiado actualizado')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _seguroViaje ? const Color(0xFFD4E9D5) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CheckboxListTile(
                      secondary: const Icon(Icons.health_and_safety),
                      title: const Text('Seguro de viaje'),
                      subtitle: const Text('+ \$400'),
                      value: _seguroViaje,
                      onChanged: (valor) {
                        setState(() {
                          _seguroViaje = valor ?? false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Seguro de viaje actualizado')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _notificaciones ? const Color(0xFFD9CCE8) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SwitchListTile(
                      title: const Text('Recibir notificaciones'),
                      subtitle: Text(_notificaciones ? 'Activadas' : 'Desactivadas'),
                      value: _notificaciones,
                      onChanged: (valor) {
                        setState(() {
                          _notificaciones = valor;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Notificaciones ${valor ? "activadas" : "desactivadas"}')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE0F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Presupuesto:'),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8E44AD),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '\$${_presupuesto.round()}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          min: 500,
                          max: 10000,
                          divisions: 20,
                          value: _presupuesto,
                          activeColor: const Color(0xFF8E44AD),
                          onChanged: (valor) {
                            setState(() {
                              _presupuesto = valor;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _elegirFecha,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFD7B8E0), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Color(0xFF8E44AD)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Fecha del viaje'),
                                Text(_fechaViaje == null
                                    ? 'Toca para elegir fecha'
                                    : _formatearFecha(_fechaViaje!)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Seccion 5
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00695C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Sección 5 · Confirmar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Text(
                    'Revisa tus datos antes de despegar',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                          ),
                          onPressed: _mostrarResumen,
                          icon: const Icon(Icons.visibility),
                          label: const Text('Ver Resumen'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC107),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: _confirmar,
                          icon: const Icon(Icons.send),
                          label: const Text('Confirmar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class BoletoPage extends StatelessWidget {
  const BoletoPage({
    super.key,
    required this.nombre,
    required this.correo,
    required this.destino,
    required this.transporte,
    required this.extras,
    required this.notificaciones,
    required this.presupuesto,
    required this.fecha,
  });

  final String nombre;
  final String correo;
  final String destino;
  final String transporte;
  final String extras;
  final bool notificaciones;
  final double presupuesto;
  final String fecha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Boleto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¡Buen viaje, $nombre!'),
                  Text(destino.toUpperCase()),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.email),
                      const SizedBox(width: 8),
                      Text('Correo: $correo'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 8),
                      Text('Destino: $destino'),
                      const Spacer(),
                      Text(transporte),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star),
                      const SizedBox(width: 8),
                      Text('Extras: $extras'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.notifications),
                      const SizedBox(width: 8),
                      Text('Notificaciones: ${notificaciones ? "Activadas" : "Desactivadas"}'),
                      const Spacer(),
                      Text('\$${presupuesto.round()}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 8),
                      Text('Fecha: $fecha'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Regresar y editar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
