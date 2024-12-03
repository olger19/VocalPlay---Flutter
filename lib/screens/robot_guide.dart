import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RobotGuide extends StatelessWidget {
  final String message; // Mensaje personalizado del robot
  final String animationPath; // Ruta de la animación Lottie

  const RobotGuide({Key? key, required this.message, required this.animationPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft, // Posiciona el mensaje sobre el robot
      children: [
        // Robot (imagen o animación)
        Positioned(
          bottom: 0,
          left: 20,
          child: Lottie.asset(
            animationPath, // Ruta de la imagen del robot
            height: 150,
          ),
        ),
        // Burbuja de diálogo
        Positioned(
          bottom: 120, // Ajusta según el tamaño del robot
          left: 70,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              message,
              textWidthBasis: TextWidthBasis.longestLine,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              softWrap: true, // Permite que el texto se divida en varias líneas
            ),
          ),
        ),
      ],
    );
  }
}
