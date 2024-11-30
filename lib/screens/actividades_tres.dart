import 'package:flutter/material.dart';
import 'actividad_uno_pantalla_tres.dart';
import 'actividad_dos_pantalla_tres.dart';
import 'package:vocalplay/widgets/cuadro_tres.dart';

// Pantalla de actividades para "3 años"
class ActividadesTresPantalla extends StatelessWidget {
  const ActividadesTresPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades 3 años'),
        
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(2.0), // Reducir el padding
        mainAxisSpacing: 20.0, // Espacio entre filas
        crossAxisSpacing: 10.0, // Espacio entre columnas
        childAspectRatio: 1.5, // Cambiar la relación de aspecto para hacer los cuadros más pequeños
        children: <Widget>[
          Cuadro(
            texto: 'Colorea',
            onTap: () {
              // Navegar a la pantalla de actividad 1
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActividadUnoPantallaTres()),
              );
            }, 
            image: const AssetImage('assets/images/colorear.png'),
          ),
          Cuadro(
            texto: 'Une',
            onTap: () {
              // Navegar a la pantalla de actividad 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActividadDosPantallaTres()),
              );
            },
            image: const AssetImage('assets/images/unir.jpeg'),
          ),
        ],
      ),
    );
  }
}
