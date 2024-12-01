import 'package:flutter/material.dart';

import 'package:vocalplay/utils/path_transformer.dart';
import 'package:vocalplay/utils/path_validator.dart';
import 'package:vocalplay/utils/svg_paths.dart';

class TracingLetterView extends StatefulWidget {
  final Color strokeColor;
  final Color traceColor;
  final Path letterPath;
  final Color toleranceColor;

  const TracingLetterView(
      {super.key,
      required this.strokeColor,
      required this.traceColor,
      required this.letterPath,
      required this.toleranceColor});

  @override
  TracingLetterViewState createState() => TracingLetterViewState();
}

class TracingLetterViewState extends State<TracingLetterView> {
  final List<Offset> _points = [];
  bool _isTracing = false;
  bool _isValid = false;

  // SVG path data for the letter "a"
  final Path letterPath = SvgPaths.letterA;

  Path getLetterPath(Size size) {
    //final Path originalPath = parseSvgPath(letterPath);
    //return PathTransformer.scaleAndCenter(originalPath, size, scaleFactor: 0.5);

    //Path dinamico como parametro
    return PathTransformer.scaleAndCenter(widget.letterPath, size,
        scaleFactor: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trazo de vocal')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final Size size = Size(constraints.maxWidth, constraints.maxHeight);
          final letterPath = getLetterPath(size);

          return GestureDetector(
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
                _isValid = PathValidator.validateTracing(_points, letterPath);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(_isValid ? 'Trazo válido!' : 'Trazo incorrecto')),
              );
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
          );
        },
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
    //Area de tolerancia
    final Paint tolerancePaint = Paint()
      ..color = toleranceColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50.0;

    canvas.drawPath(letterPath, tolerancePaint);

    final Path tolerancePath = Path();
    for (final metric in letterPath.computeMetrics()) {
      final extractedPath = metric.extractPath(0, metric.length);
      tolerancePath.addPath(extractedPath, Offset.zero);
    }
    canvas.drawPath(tolerancePath, tolerancePaint);

    //Path original Dibuja la letra
    final Paint letterPaint = Paint()
      ..color = strokeColor.withOpacity(1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0; //Trazo

    canvas.drawPath(letterPath, letterPaint);

    //Trazo del usuario
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
