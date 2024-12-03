import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vocalplay/screens/robot_guide.dart';

class ActividadDosPantallaTres extends StatefulWidget {
  const ActividadDosPantallaTres({super.key});

  @override
  State<ActividadDosPantallaTres> createState() =>
      _ActividadDosPantallaTresState();
}

class _ActividadDosPantallaTresState extends State<ActividadDosPantallaTres> {
  final Map<String, String> _matches = {};

  final List<Map<String, String>> _pairs = [
    {'vocal': 'a', 'imagen': 'assets/images/ajedrez.jpeg'},
    {'vocal': 'e', 'imagen': 'assets/images/estrella.png'},
    {'vocal': 'u', 'imagen': 'assets/images/uva.png'},
  ];

  bool _showAnimation = false; // Estado para mostrar animación
  String _animationPath = ''; // Ruta de la animación a mostrar
  // Variable para controlar la visibilidad del robot
  bool _showRobotGuide = true;
  bool _isCompleted() {
    for (var pair in _pairs) {
      if (_matches[pair['vocal']!] != pair['imagen']) {
        return false;
      }
    }
    return true;
  }

  void _triggerAnimation(String animationPath) {
    setState(() {
      _animationPath = animationPath;
      _showAnimation = true;
    });

    // Ocultar animación después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Une las vocales'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _pairs.map((pair) {
                    return Draggable<String>(
                      data: pair['imagen'],
                      feedback:
                          _buildVocalBox(pair['vocal']!, isDragging: true),
                      childWhenDragging:
                          _buildVocalBox(pair['vocal']!, isDragging: true),
                      child: _buildVocalBox(pair['vocal']!),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _pairs.map((pair) {
                    return DragTarget<String>(
                      builder: (context, candidateData, rejectedData) {
                        return _buildImageBox(
                          pair['imagen']!,
                          _matches[pair['vocal']] == pair['imagen'],
                        );
                      },
                      onAcceptWithDetails: (details) {
                        setState(() {
                          _matches[pair['vocal']!] = details.data;

                          // Verificar si todos los emparejamientos están completos
                          if (_isCompleted()) {
                            _triggerAnimation(
                                'assets/animations/applause.json');
                          } else if (!_matches.values
                              .contains(pair['imagen'])) {
                            _triggerAnimation('assets/animations/error.json');
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          // Mostrar animación en pantalla
          if (_showAnimation)
            Center(
              child: Lottie.asset(
                _animationPath,
                width: 200,
                height: 200,
              ),
            ),
          if (_showRobotGuide)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showRobotGuide =
                          false; // Cambiar a false para ocultar el robot
                    });
                  },
                  child: SizedBox(
                    height: 150,
                    child: RobotGuide(
                      message:
                          "¡Diviértete uniendo! Arrastra la vocal hacia la imagen correspondiente.",
                      animationPath: 'assets/animations/dino.json',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVocalBox(String vocal, {bool isDragging = false}) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDragging ? Colors.grey : Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        vocal,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImageBox(String imagePath, bool isMatched) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isMatched ? Colors.green : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}
