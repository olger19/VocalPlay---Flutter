import 'package:flutter/material.dart';

class CuadroPantalla extends StatelessWidget {
  final String texto;

  const CuadroPantalla({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(texto),
      ),
      body: Center(
        child: Text(
          'Has presionado el cuadro: $texto',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}