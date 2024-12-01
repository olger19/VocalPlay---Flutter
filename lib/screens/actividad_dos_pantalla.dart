import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; //API
import 'package:permission_handler/permission_handler.dart'; // Importa permission_handler

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

  // Solicitar permiso de grabación de audio
  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      _startListening(); // Si el permiso es concedido, empezar a escuchar
    } else {
      // Si no se concede el permiso, mostrar un mensaje o realizar alguna acción
      if (!mounted) return; // Verificamos si el widget sigue montado antes de usar el contexto
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
        //print("Texto reconocido: $_text"); // Imprimir para debug

        if (_text.isNotEmpty && _text[0] == expectedVocal) {
          // Si el texto coincide con la vocal esperada
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('¡Correcto!'),
                content:
                    const Text('¡Bien hecho, has dicho la vocal correcta!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repetir Vocal'),
      ),
      body: Center(
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
                  : _requestPermission, // Solicita el permiso cuando se presiona el botón
              child: Text(_isListening ? 'Detener' : 'Escuchar'),
            ),
          ],
        ),
      ),
    );
  }
}
