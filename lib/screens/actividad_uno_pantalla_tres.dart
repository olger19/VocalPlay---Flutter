import 'package:flutter/material.dart';

// Pantalla para "Actividad 1"
class ActividadUnoPantallaTres extends StatefulWidget {
  const ActividadUnoPantallaTres({super.key});

  @override
  ActividadUnoPantallaState createState() => ActividadUnoPantallaState();
}

class ActividadUnoPantallaState extends State<ActividadUnoPantallaTres> {
  // Lista de trazos, donde cada trazo es una lista de puntos y un color
  final List<Trazo> _trazos = [];

  // Color del pincel
  Color _brushColor = Colors.red;

  // Controlador de la imagen
  late Image _image;
  late ImageInfo _imageInfo;

  @override
  void initState() {
    super.initState();
    _image = Image.asset('assets/images/sun.jpg'); // Cargar la imagen
    _loadImage(); // Cargar la imagen de forma eficiente
  }

  void _loadImage() {
    final imageStream = _image.image.resolve(const ImageConfiguration());
    imageStream.addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) {
        setState(() {
          _imageInfo = info; // Guardar la imagen cargada
        });
      }),
    );
  }

  // Lista de colores importantes para mostrar
  List<Color> colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colorea'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services), //Cambiar icono aqui
            onPressed: () {
              setState(() {
                _trazos.clear(); // Limpiar trazos
              });
            },
            tooltip: 'Borrar trazos', // Agregar un tooltip para mayor claridad
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  // Agregar puntos donde el usuario toca para pintar
                  if (_trazos.isEmpty || _trazos.last.color != _brushColor) {
                    _trazos.add(Trazo(_brushColor, [details.localPosition]));
                  } else {
                    _trazos.last.points.add(
                        details.localPosition); // Añadir puntos al último trazo
                  }
                });
              },
              onPanEnd: (details) {
                _trazos.add(Trazo(_brushColor,
                    [])); // Añadir un nuevo trazo al finalizar el dibujo
              },
              child: CustomPaint(
                painter: DibujoPainter(_trazos, _imageInfo),
                size: Size.infinite,
              ),
            ),
          ),
          // Panel de colores en el lado derecho con desplazamiento
          Container(
            width: 60,
            color: Colors.grey[200],
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: colorOptions
                    .map(
                      (color) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _brushColor = color; // Cambiar el color del pincel
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Trazo {
  Color color;
  List<Offset> points;

  Trazo(this.color, this.points);
}

class DibujoPainter extends CustomPainter {
  final List<Trazo> trazos;
  final ImageInfo? imageInfo;

  DibujoPainter(this.trazos, this.imageInfo);

  @override
  void paint(Canvas canvas, Size size) {
    if (imageInfo != null) {
      // Dibujar la imagen solo si ya está cargada
      final paint = Paint();

      // Ajustamos el tamaño de la imagen
      double imageWidth = size.width * 0.6; // Ajustar el ancho de la imagen
      double imageHeight = 250;

      // Rectángulo de origen (toda la imagen original)
      final srcRect = Rect.fromLTWH(0, 0, imageInfo!.image.width.toDouble(),
          imageInfo!.image.height.toDouble());

      // Rectángulo de destino (tamaño y posición en el lienzo)
      final dstRect = Rect.fromLTWH(
        (size.width - imageWidth) / 2, // Centrado horizontal
        (size.height - imageHeight) / 2, // Centrado vertical
        imageWidth, // Ancho ajustado
        imageHeight, // Alto ajustado
      );

      // Dibujar la imagen redimensionada y centrada
      canvas.drawImageRect(imageInfo!.image, srcRect, dstRect, paint);
    }

    // Dibujar los trazos del usuario
    for (Trazo trazo in trazos) {
      final paint = Paint()
        ..color = trazo.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0;

      for (int i = 0; i < trazo.points.length - 1; i++) {
        canvas.drawLine(trazo.points[i], trazo.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
