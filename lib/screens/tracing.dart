import 'package:flutter/material.dart';
//import 'package:path_drawing/path_drawing.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:vocalplay/utils/svg_paths.dart';

class TracingLetterView extends StatefulWidget {
  final Color strokeColor;
  final Color traceColor;

  const TracingLetterView({
    super.key,
    required this.strokeColor,
    required this.traceColor,
  });

  @override
  TracingLetterViewState createState() => TracingLetterViewState();
}

class TracingLetterViewState extends State<TracingLetterView> {
  final List<Offset> _points = [];
  bool _isTracing = false;
  bool _isValid = false;

  // SVG path data for the letter "a"
  final String letterPath = SvgPaths.letterA;
  
  Path getLetterPath(Size size) {
  final Path originalPath = parseSvgPath(letterPath);
  final Rect bounds = originalPath.getBounds();

  // Calcular la escala para ajustarlo al tamaño del canvas
  final double scale = (size.width * 0.5) / bounds.width; // Ajustar al 80% del ancho disponible
  final double scaledHeight = bounds.height * scale;
  
  // Trasladar el Path para centrarlo horizontal y verticalmente
  final double dx = (size.width - bounds.width * scale) / 2;
  final double dy = (size.height - scaledHeight) / 2;

  final Matrix4 matrix = Matrix4.identity()
    ..scale(scale, scale)
    ..translate(dx / scale - bounds.left, dy / scale - bounds.top);

  return originalPath.transform(matrix.storage);
}

  bool validateTracing(List<Offset> userPoints, Path letterPath) {
    const tolerance = 20.0;
    int validPoints = 0;

    for (final point in userPoints) {
      if (letterPath.contains(point) || 
          isPointNearPath(point, letterPath, tolerance)) {
        validPoints++;
      }
    }

    return validPoints >= userPoints.length * 0.9;
  }

  bool isPointNearPath(Offset point, Path path, double tolerance) {
    for (final metric in path.computeMetrics()) {
      for (double distance = 0; distance <= metric.length; distance += 1) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null && (tangent.position - point).distance <= tolerance) {
          return true;
        }
      }
    }
    return false;
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
                _isValid = validateTracing(_points, letterPath);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_isValid ? 'Trazo válido!' : 'Trazo incorrecto')),
              );
            },
            child: CustomPaint(
              painter: _LetterPainter(
                letterPath: letterPath,
                points: _points,
                strokeColor: widget.strokeColor,
                traceColor: widget.traceColor,
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

  _LetterPainter({
    required this.letterPath,
    required this.points,
    required this.strokeColor,
    required this.traceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint letterPaint = Paint()
      ..color = strokeColor
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}