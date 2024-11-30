import 'package:flutter/material.dart';
//import 'package:path_drawing/path_drawing.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

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
  final String letterPath = "M1.51188 6.03204C1.02121 6.03204 0.775879 5.71204 0.775879 5.07204C0.775879 4.56004 0.967879 4.00538 1.35188 3.40804C2.24788 2.06404 3.21855 1.15738 4.26388 0.688042C4.71188 0.474709 5.14921 0.368042 5.57588 0.368042C5.78921 0.368042 6.02388 0.432042 6.27988 0.560042C6.53588 0.666709 6.66388 0.826709 6.66388 1.04004C6.66388 1.14671 6.58921 1.21071 6.43988 1.23204C6.35455 1.25338 6.29055 1.27471 6.24788 1.29604C6.22655 1.31738 6.20521 1.33871 6.18388 1.36004C5.69321 2.27738 5.44788 3.13071 5.44788 3.92004C5.44788 4.92271 5.84255 5.42404 6.63188 5.42404C7.46388 5.42404 8.49855 4.77338 9.73588 3.47204C9.84255 3.34404 9.92788 3.28004 9.99188 3.28004C10.0559 3.28004 10.0879 3.32271 10.0879 3.40804C10.0879 3.49338 10.0559 3.58938 9.99188 3.69604C8.56255 5.23204 7.31455 6.00004 6.24788 6.00004C5.73588 6.00004 5.31988 5.77604 4.99988 5.32804C4.65855 4.85871 4.47721 4.29338 4.45588 3.63204C3.92255 4.33604 3.38921 4.92271 2.85588 5.39204C2.30121 5.81871 1.85321 6.03204 1.51188 6.03204ZM2.18388 5.07204C2.41855 5.07204 2.72788 4.91204 3.11188 4.59204C3.45321 4.29338 3.74121 4.00538 3.97588 3.72804C4.21055 3.42938 4.38121 3.13071 4.48788 2.83204C4.53055 2.46938 4.59455 2.14938 4.67988 1.87204C4.78655 1.57338 4.89321 1.30671 4.99988 1.07204C3.89055 1.05071 2.94121 1.81871 2.15188 3.37604C1.91721 3.80271 1.79988 4.18671 1.79988 4.52804C1.79988 4.89071 1.92788 5.07204 2.18388 5.07204Z";
  
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