import 'package:flutter/material.dart';
import 'package:vocalplay/utils/svg_paths.dart';
//import 'package:vocalplay/screens/cuadro_pantalla.dart';
import 'actividades_cuatro.dart';
import 'tracing.dart'; // Importa la nueva pantalla de trazo
import 'actividades_tres.dart';

class SiguientePantalla extends StatelessWidget {
  const SiguientePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siguiente Pantalla'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Cuadro(
            texto: '3 años',
            onTap: () {
              // Navegar a la pantalla de actividad al seleccionar Cuadro 1
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActividadesTresPantalla()),
              );
            },
            image: const AssetImage('assets/images/fondo3anos.jpg'), // Imagen de fondo
          ),
          Cuadro(
            texto: '4 años',
            onTap: () {
              // Navegar a la pantalla de trazo al seleccionar Cuadro 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActividadesCuatroPantalla()),
              );
            },
            image: const AssetImage('assets/images/fondo4anos.jpg'), // Imagen de fondo
          ),
          Cuadro(
            texto: '5 años',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TracingLetterView(
                  traceColor: Colors.blue,
                  strokeColor: const Color.fromARGB(255, 248, 14, 65),
                  letterPath: SvgPaths.letterA, 
                  toleranceColor: const Color.fromARGB(255, 19, 2, 2),
                )),
              );
            },
            image: const AssetImage('assets/images/fondo5anos.jpg'), // Imagen de fondo
          ),
        ],
      ),
    );
  }
}
// Definición del widget Cuadro
class Cuadro extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;
  final ImageProvider image;

  const Cuadro({super.key, required this.texto, required this.onTap, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Llama a onTap cuando se presiona el cuadro
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image, // Imagen de fondo
            fit: BoxFit.cover, // Asegura que la imagen cubra todo el contenedor
          ),
          borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          border: Border.all(
            color: const Color.fromARGB(255, 161, 4, 4), // Color del borde
            width: 7.0, // Ancho del borde
          ),
        ),
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(
              color: Colors.white, // Color del texto
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}