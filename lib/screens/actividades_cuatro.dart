import 'package:flutter/material.dart';
import '../widgets/cuadro_cuatro.dart';
import 'actividad_uno_pantalla.dart';
import 'actividad_dos_pantalla.dart';

class ActividadesCuatroPantalla extends StatelessWidget {
  const ActividadesCuatroPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades 4 años'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(2.0), // Reducir el padding
        mainAxisSpacing: 20.0, // Espacio entre filas
        crossAxisSpacing: 10.0, // Espacio entre columnas
        childAspectRatio: 1.5,
        children: <Widget>[
          Cuadro(
            texto: 'Relacionar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActividadUnoPantalla()),
              );
            },
            image: const AssetImage('assets/images/unir.jpeg'),
          ),
          Cuadro(
            texto: 'Repetir Vocal',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActividadDosPantalla()),
              );
            },
            image: const AssetImage('assets/images/repetir_vocal.jpg'),
          ),
        ],
      ),
    );
  }
}
