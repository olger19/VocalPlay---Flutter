import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';

class ActividadDosPantalla extends StatefulWidget {
  const ActividadDosPantalla({super.key});

  @override
  ActividadDosPantallaState createState() => ActividadDosPantallaState();
}

class ActividadDosPantallaState extends State<ActividadDosPantalla> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _text = '';
  bool _isListening = false;
  String expectedVocal = 'a'; // Vocal esperada para la validación

  // Animaciones
  bool _showAnimation = false;
  String _animationPath = '';

  // Solicitar permiso de grabación de audio
  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      _startListening();
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Permiso Denegado'),
            content: const Text(
                'La aplicación necesita acceso al micrófono para funcionar correctamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available && mounted) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        if (!mounted) return;
        setState(() {
          _text = result.recognizedWords
              .trim()
              .toLowerCase(); // Limpiar el texto y convertirlo a minúsculas
        });

        if (_text.isNotEmpty) {
          if (_text[0] == expectedVocal) {
            _triggerAnimation('assets/animations/applause.json'); // Animación correcta
          } else {
            _triggerAnimation('assets/animations/error.json'); // Animación incorrecta
          }
        }
      });
    } else {
      if (!mounted) return;
      setState(() {
        _isListening = false;
      });
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  // Mostrar animación
  void _triggerAnimation(String animationPath) {
    setState(() {
      _animationPath = animationPath;
      _showAnimation = true;
    });

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
        title: const Text('Repetir Vocal'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pronuncia la vocal: $expectedVocal',
                  style: const TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 20),
                Text(
                  'Resultado: $_text',
                  style: const TextStyle(fontSize: 20.0, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isListening
                      ? _stopListening
                      : _requestPermission,
                  child: Text(_isListening ? 'Detener' : 'Escuchar'),
                ),
              ],
            ),
          ),
          // Animación superpuesta
          if (_showAnimation)
            Center(
              child: Lottie.asset(
                _animationPath,
                width: 200,
                height: 200,
              ),
            ),
        ],
      ),
    );
  }
}
