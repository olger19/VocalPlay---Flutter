import 'package:flutter/material.dart';
import 'package:vocalplay/services/audio_service.dart'; // Asegúrate de importar el archivo del servicio

class ConfiguracionPantalla extends StatefulWidget {
  const ConfiguracionPantalla({super.key});

  @override
  ConfiguracionPantallaState createState() => ConfiguracionPantallaState();
}

class ConfiguracionPantallaState extends State<ConfiguracionPantalla> {
  final AudioService _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Pantalla de configuración'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _audioService.isPlaying
                    ? _audioService.pause()
                    : _audioService.play('audio/1audio.mp3');
              },
              child: Text(_audioService.isPlaying
                  ? 'Detener música'
                  : 'Reproducir música'),
            ),
          ],
        ),
      ),
    );
  }
}
