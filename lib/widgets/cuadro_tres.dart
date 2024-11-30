import 'package:flutter/material.dart';

// Definición del widget Cuadro
class Cuadro extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;
final ImageProvider image;

  const Cuadro({super.key, required this.texto, required this.onTap, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
