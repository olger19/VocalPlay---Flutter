import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:vocalplay/screens/configuracion_pantalla.dart'; 

import 'package:vocalplay/screens/screen_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VocalPlay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Inicio(),
    );
  }
}

// Page Home
class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VocalPlay'),
        backgroundColor: const Color.fromARGB(255, 71, 166, 243),// Sin sombra en el AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Acción del botón Configuración
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConfiguracionPantalla()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo con la imagen cielo.png (debe ir primero para quedar debajo)
          Positioned.fill(
            child: Opacity(
              opacity:
                  1.0, // Mantén la opacidad al 100% para que la imagen sea completamente visible
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/cielo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Imagen vocales3.png encima de la imagen cielo.png
          Positioned(
            top: -140, // Ajusta este valor para mover la imagen más arriba
            left: 0,
            right: 0,
            bottom: 0, // Mantiene la imagen con el mismo tamaño en altura
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/vocales3.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Contenido encima de las imágenes de fondo
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 150), // Ajusta el valor según sea necesario
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(0.5),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SiguientePantalla()),
                  );
                },
                child: const Icon(
                  Icons.play_arrow,
                  size: 90,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// Todo: agrega más pantallas según tus necesidades.





