import 'package:flutter/material.dart';

class TrazoVocalPantalla extends StatefulWidget {
  const TrazoVocalPantalla({super.key});

  @override
  TrazoVocalPantallaState createState() => TrazoVocalPantallaState();
}
class TrazoVocalPantallaState extends State<TrazoVocalPantalla> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trazo de Vocal'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(details.globalPosition);
          //print("Posición local: $localPosition"); // Depuración

          setState(() {
            points.add(localPosition);
          });
        },
        onPanEnd: (details) {
          points.add(null);
        },
        child: Container(
          color: Colors.white, // Color de fondo
          width: double.infinity,
          height: double.infinity, // Asegúrate de ocupar todo el espacio
          child: CustomPaint(
            painter: TrazoPainter(points),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            points.clear(); // Limpiar los trazos
            //print("Puntos borrados"); // Depuración
          });
        },
        child: const Icon(Icons.clear),
      ),
    );
  }
}

class TrazoPainter extends CustomPainter {
  final List<Offset?> points;

  TrazoPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue // Color del trazo
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0; // Grosor del trazo

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Siempre repinta
  }
}
