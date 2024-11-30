import 'package:flutter/material.dart';

// Pantalla de actividades para "3 años"
class ActividadesCincoPantalla extends StatelessWidget {
  const ActividadesCincoPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades 3 años'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Cuadro(
            texto: 'Colorea',
            onTap: () {
              // Navegar a la pantalla de actividad 1
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActividadUnoPantalla()),
              );
            },
          ),
          Cuadro(
            texto: 'Une',
            onTap: () {
              // Navegar a la pantalla de actividad 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActividadDosPantalla()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Pantalla para "Actividad 1"
class ActividadUnoPantalla extends StatelessWidget {
  const ActividadUnoPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colorea'),
      ),
      body: const Center(
        child: Text(
          'Contenido de la Actividad 1',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

// Pantalla para "Actividad 2"
class ActividadDosPantalla extends StatelessWidget {
  const ActividadDosPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Une'),
      ),
      body: const Center(
        child: Text(
          'Contenido de la Actividad 2',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

// Definición del widget Cuadro
class Cuadro extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;

  const Cuadro({super.key, required this.texto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}