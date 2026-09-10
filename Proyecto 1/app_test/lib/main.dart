import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Preferencias',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Registro de Preferencias'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  //ESTADO: que genero esta elegido (solo uno a la vez)
  String _genero = 'Masculino';

  //ESTADO: que intereses estan marcados (cada uno va por su cuenta)
  bool _deporte = false;
  bool _musica = false;
  bool _cine = false;
  bool _lectura = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [

            //=================== SECCION 1 ===================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE4F2FD), //BACKGROUND
                border: Border.all(
                  color: const Color(0xFFA5C4D9), //BORDER
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF447391),
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sección 1: Información General',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF447391), //TEXT COLOR
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Completa los siguientes datos personales básicos',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            //=================== SECCION 2 ===================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6E9), //BACKGROUND
                border: Border.all(
                  color: const Color(0xFFB5CDB7), //BORDER
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Color(0xFF3C8D41),
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sección 2: Datos Personales',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3C8D41), //TEXT COLOR
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  //CAMPO NOMBRE
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                      hintText: 'Nombre completo',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  //CAMPO EDAD
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                      hintText: 'Edad',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //=================== SECCION 3 ===================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF3E3), //BACKGROUND
                border: Border.all(
                  color: const Color(0xFFEFD3A3), //BORDER
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.table_rows,
                        color: Color(0xFFC97B29),
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sección 3: Distribución en Filas',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC97B29), //TEXT COLOR
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  //FILA 1
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9D6D2), //BACKGROUND
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        _Punto(color: Color(0xFFE74C3C)),
                        SizedBox(width: 12),
                        Text(
                          'Fila 1 - Color Rojo',
                          style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  //FILA 2
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCF3CF), //BACKGROUND
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        _Punto(color: Color(0xFFF4D03F)),
                        SizedBox(width: 12),
                        Text(
                          'Fila 2 - Color Amarillo',
                          style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  //FILA 3
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6EAF8), //BACKGROUND
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        _Punto(color: Color(0xFF3498DB)),
                        SizedBox(width: 12),
                        Text(
                          'Fila 3 - Color Azul',
                          style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //=================== SECCION 4 ===================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7EAF9), //BACKGROUND
                border: Border.all(
                  color: const Color(0xFFD7B8E0), //BORDER
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.grid_view,
                        color: Color(0xFF8E44AD),
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sección 4: Cuatro Hijos en Colores',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8E44AD), //TEXT COLOR
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  //HIJOS
                  const Row(
                    children: [
                      _Hijo(
                        texto: 'Hijo 1',
                        fondo: Color(0xFFF9D5DC),
                        textoColor: Color(0xFFC2185B),
                      ),
                      SizedBox(width: 10),
                      _Hijo(
                        texto: 'Hijo 2',
                        fondo: Color(0xFFFCE4B6),
                        textoColor: Color(0xFFE67E22),
                      ),
                      SizedBox(width: 10),
                      _Hijo(
                        texto: 'Hijo 3',
                        fondo: Color(0xFFCDEBD0),
                        textoColor: Color(0xFF388E3C),
                      ),
                      SizedBox(width: 10),
                      _Hijo(
                        texto: 'Hijo 4',
                        fondo: Color(0xFFDCD0F0),
                        textoColor: Color(0xFF7B1FA2),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //=================== SECCION 5 ===================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA), //BACKGROUND
                border: Border.all(
                  color: const Color(0xFFE0E0E0), //BORDER
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFF424242),
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sección 5: Controles UI',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF424242), //TEXT COLOR
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  //GENERO
                  const Text(
                    'Género:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  RadioGroup<String>(
                    groupValue: _genero,
                    onChanged: (valor) {
                      setState(() {
                        _genero = valor ?? _genero;
                      });
                    },
                    child: const Column(
                      crossAxisAlignment: .start,
                      mainAxisSize: .min,
                      children: [
                        _OpcionRadio(valor: 'Masculino'),
                        _OpcionRadio(valor: 'Femenino'),
                        _OpcionRadio(valor: 'Otro'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  //INTERESES (CHECKBOXES)
                  const Text(
                    'Intereses:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  _OpcionCheck(
                    texto: 'Deporte',
                    marcado: _deporte,
                    onChanged: (valor) {
                      setState(() {
                        _deporte = valor ?? false;
                      });
                    },
                  ),
                  _OpcionCheck(
                    texto: 'Música',
                    marcado: _musica,
                    onChanged: (valor) {
                      setState(() {
                        _musica = valor ?? false;
                      });
                    },
                  ),
                  _OpcionCheck(
                    texto: 'Cine',
                    marcado: _cine,
                    onChanged: (valor) {
                      setState(() {
                        _cine = valor ?? false;
                      });
                    },
                  ),
                  _OpcionCheck(
                    texto: 'Lectura',
                    marcado: _lectura,
                    onChanged: (valor) {
                      setState(() {
                        _lectura = valor ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),

            //=================== BOTONES ===================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text('Mostrar Preferencias'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check_circle, size: 18),
                      label: const Text('Guardar Registro'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
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



class _Punto extends StatelessWidget {
  const _Punto({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _Hijo extends StatelessWidget {
  const _Hijo({
    required this.texto,
    required this.fondo,
    required this.textoColor,
  });

  final String texto;
  final Color fondo;
  final Color textoColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textoColor,
          ),
        ),
      ),
    );
  }
}

class _OpcionRadio extends StatelessWidget {
  const _OpcionRadio({required this.valor});

  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(value: valor),
        const SizedBox(width: 4),
        Text(valor, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _OpcionCheck extends StatelessWidget {
  const _OpcionCheck({
    required this.texto,
    required this.marcado,
    required this.onChanged,
  });

  final String texto;
  final bool marcado;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: marcado, onChanged: onChanged),
        const SizedBox(width: 4),
        Text(texto, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
