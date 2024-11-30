import 'package:flutter/material.dart';

class ActividadPantalla extends StatelessWidget {
  const ActividadPantalla({super.key}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividad de Vocales'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selecciona una vocal:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botones para seleccionar las vocales
                _crearBotonVocal(context, 'A'),
                const SizedBox(width: 20),
                _crearBotonVocal(context, 'E'),
                const SizedBox(width: 20),
                _crearBotonVocal(context, 'I'),
                const SizedBox(width: 20),
                _crearBotonVocal(context, 'O'),
                const SizedBox(width: 20),
                _crearBotonVocal(context, 'U'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearBotonVocal(BuildContext context, String vocal) {
    return ElevatedButton(
      onPressed: () {
        // Acción al seleccionar una vocal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Has seleccionado la vocal: $vocal')),
        );
      },
      child: Text(
        vocal,
        style: const TextStyle(fontSize: 30),
      ),
    );
  }
}
