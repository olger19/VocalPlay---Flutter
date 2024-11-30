import 'package:flutter/material.dart';

class ActividadUnoPantalla extends StatefulWidget {
  const ActividadUnoPantalla({super.key});

  @override
  State<ActividadUnoPantalla> createState() => _ActividadUnoPantallaState();
}

class _ActividadUnoPantallaState extends State<ActividadUnoPantalla> {
  // Lista de elementos: frutas y sus números correctos
  final Map<String, String> items = {
    'assets/images/naranja.png': '1',
    'assets/images/sandia.png': '3',
    'assets/images/manzana.png': '2',
  };

  // Respuestas del usuario
  final Map<String, String> userAnswers = {};

  // Verifica si la validación debe realizarse
  bool isValidationComplete() {
    return userAnswers.length == items.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relacionar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Zona de frutas para arrastrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.keys.map((imagePath) {
              return Draggable<String>(
                data: imagePath,
                feedback: _buildImageWidget(imagePath),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildImageWidget(imagePath),
                ),
                child: _buildImageWidget(imagePath),
              );
            }).toList(),
          ),
          // Zona de números para soltar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.values.map((number) {
              return DragTarget<String>(
                onAcceptWithDetails: (details) {
                  setState(() {
                    userAnswers[details.data] = number;
                  });

                  // Verifica si todas las relaciones están completadas
                  if (isValidationComplete()) {
                    _validarRespuestas();
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: userAnswers.containsValue(number)
                          ? Colors.green[100]
                          : Colors.grey[200],
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      number,
                      style: const TextStyle(fontSize: 24),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar las imágenes
  Widget _buildImageWidget(String imagePath) {
    return Image.asset(
      imagePath,
      width: 50,
      height: 50,
    );
  }

  // Validar respuestas y mostrar resultado
  void _validarRespuestas() {
    bool esCorrecto = true;
    items.forEach((imagePath, correctNumber) {
      if (userAnswers[imagePath] != correctNumber) {
        esCorrecto = false;
      }
    });

    // Mostrar pop-up con el resultado
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(esCorrecto ? '¡Correcto!' : 'Incorrecto'),
          content: Text(esCorrecto
              ? '¡Felicidades, todas las relaciones son correctas!'
              : 'Algunas relaciones son incorrectas. Intenta de nuevo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
