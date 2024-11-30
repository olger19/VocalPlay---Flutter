import 'package:flutter/material.dart';

class ActividadDosPantallaTres extends StatefulWidget {
  const ActividadDosPantallaTres({super.key});

  @override
  State<ActividadDosPantallaTres> createState() =>
      _ActividadDosPantallaTresState();
}

class _ActividadDosPantallaTresState extends State<ActividadDosPantallaTres> {
  // Mapa para rastrear qué elementos se han emparejado correctamente
  final Map<String, String> _matches = {};

  // Lista de vocales y sus pares correspondientes
  final List<Map<String, String>> _pairs = [
    {'vocal': 'a', 'imagen': 'assets/images/ajedrez.jpeg'},
    {'vocal': 'e', 'imagen': 'assets/images/estrella.png'},
    {'vocal': 'u', 'imagen': 'assets/images/uva.png'},
  ];

  // Función para verificar si todas las vocales han sido emparejadas correctamente
  bool _isCompleted() {
    for (var pair in _pairs) {
      if (_matches[pair['vocal']!] != pair['imagen']) {
        return false;
      }
    }
    return true;
  }

  void _showResult(BuildContext context) {
    final isCorrect = _isCompleted();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? '¡Correcto!' : 'Inténtalo de nuevo'),
        content: Text(
          isCorrect
              ? '¡Todas las vocales están correctamente emparejadas!'
              : 'Algunos emparejamientos son incorrectos. Por favor, inténtalo nuevamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Une las vocales'),
      ),
      body: SingleChildScrollView(
        // Agregado SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sección de arrastrar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _pairs.map((pair) {
                return Draggable<String>(
                  data: pair['imagen'],
                  feedback: _buildVocalBox(pair['vocal']!, isDragging: true),
                  childWhenDragging:
                      _buildVocalBox(pair['vocal']!, isDragging: true),
                  child: _buildVocalBox(pair['vocal']!),
                );
              }).toList(),
            ),
            const SizedBox(height: 50),
            // Sección de soltar
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
                      // Registrar el emparejamiento
                      _matches[pair['vocal']!] = details.data;

                      // Validar automáticamente si todo está completo
                      if (_isCompleted() && mounted) {
                        _showResult(context); // Llamada directa sin async gap
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 50),
            // Botón para validar
            ElevatedButton(
              onPressed: () {
                // Ya no es necesario validar manualmente si es automático
              },
              child: const Text('Validar'),
            ),
          ],
        ),
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