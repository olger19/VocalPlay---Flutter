import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart'; // Importa Provider

import 'package:vocalplay/screens/robot_guide.dart';
import 'progress_provider.dart'; // Importa el ProgressProvider
import 'package:vocalplay/utils/path_transformer.dart';
import 'package:vocalplay/utils/path_validator.dart';

class TracingLetterView extends StatefulWidget {
  final Color strokeColor;
  final Color traceColor;
  final Path letterPath;
  final Color toleranceColor;

  const TracingLetterView({
    super.key,
    required this.strokeColor,
    required this.traceColor,
    required this.letterPath,
    required this.toleranceColor,
  });

  @override
  TracingLetterViewState createState() => TracingLetterViewState();
}

class TracingLetterViewState extends State<TracingLetterView> {
  final List<Offset> _points = [];
  bool _isTracing = false;
  bool _isValid = false;
  bool _showSuccessAnimation = false;
  bool _showErrorAnimation = false;

  bool _showRobotGuide = true; // Nuevo estado para controlar la visibilidad del robot

  Path getLetterPath(Size size) {
    return PathTransformer.scaleAndCenter(widget.letterPath, size,
        scaleFactor: 0.5);
  }

  void _updateProgress(BuildContext context) {
    Provider.of<ProgressProvider>(context, listen: false)
        .updateProgress(1.0); // Completa la barra
  }

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<ProgressProvider>(context).progress;

    return Scaffold(
      appBar: AppBar(title: const Text('Trazo de vocal')),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showRobotGuide = false; // Ocultar el robot al tocar en cualquier parte de la pantalla
          });
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final Size size = Size(constraints.maxWidth, constraints.maxHeight);
            final letterPath = getLetterPath(size);

            return Stack(
              children: [
                GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _isTracing = true;
                      _points.clear();
                    });
                  },
                  onPanUpdate: (details) {
                    if (_isTracing) {
                      setState(() {
                        _points.add(details.localPosition);
                      });
                    }
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _isTracing = false;
                      _isValid =
                          PathValidator.validateTracing(_points, letterPath);

                      if (_isValid) {
                        _showSuccessAnimation = true;
                        _showErrorAnimation = false;
                        _updateProgress(context); // Actualiza la barra global
                      } else {
                        _showErrorAnimation = true;
                        _showSuccessAnimation = false;
                      }

                      // Ocultar las animaciones después de 2 segundos
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          _showSuccessAnimation = false;
                          _showErrorAnimation = false;
                        });
                      });
                    });
                  },
                  child: CustomPaint(
                    painter: _LetterPainter(
                      letterPath: letterPath,
                      points: _points,
                      strokeColor: widget.strokeColor,
                      traceColor: widget.traceColor,
                      toleranceColor: widget.toleranceColor,
                    ),
                    size: Size.infinite,
                  ),
                ),
                if (_showSuccessAnimation)
                  Center(
                    child: Lottie.asset(
                      'assets/animations/applause.json',
                      width: 200,
                      height: 200,
                    ),
                  ),
                if (_showErrorAnimation)
                  Center(
                    child: Lottie.asset(
                      'assets/animations/error.json',
                      width: 200,
                      height: 200,
                    ),
                  ),
                // Barra de progreso
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: LinearPercentIndicator(
                    lineHeight: 20.0,
                    percent: progress,
                    backgroundColor: Colors.grey[300]!,
                    progressColor: Colors.green,
                    center: Text(
                      "${(progress * 100).toInt()}%",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // Mostrar el RobotGuide solo si _showRobotGuide es true
                if (_showRobotGuide)
                  Align(
                    alignment: Alignment
                        .bottomLeft, // Ubicación fija en la esquina inferior izquierda
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        height: 150,
                        child: RobotGuide(
                          message:
                              "¡Hola! Aqui tienes que trazar la vocal siguiendo la forma de la vocal.",
                          animationPath:
                              'assets/animations/dino.json', // Ruta de la animación Lottie
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LetterPainter extends CustomPainter {
  final Path letterPath;
  final List<Offset> points;
  final Color strokeColor;
  final Color traceColor;
  final Color toleranceColor;

  _LetterPainter({
    required this.letterPath,
    required this.points,
    required this.strokeColor,
    required this.traceColor,
    required this.toleranceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint tolerancePaint = Paint()
      ..color = toleranceColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50.0;

    canvas.drawPath(letterPath, tolerancePaint);

    final Paint letterPaint = Paint()
      ..color = strokeColor.withOpacity(1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;

    canvas.drawPath(letterPath, letterPaint);

    if (points.isNotEmpty) {
      final Paint tracePaint = Paint()
        ..color = traceColor
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final Path tracePath = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        tracePath.lineTo(points[i].dx, points[i].dy);
      }

      canvas.drawPath(tracePath, tracePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LetterPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.letterPath != letterPath;
  }
}
