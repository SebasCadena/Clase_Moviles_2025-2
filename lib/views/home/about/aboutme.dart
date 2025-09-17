import 'package:flutter/material.dart';

class Aboutme extends StatelessWidget {
  const Aboutme({
    super.key,
    required this.parametro,
    required this.metodoNavegacion,
  });

  final String parametro;
  final String metodoNavegacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(parametro)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text("Metodo de Navegacion: $metodoNavegacion")],
      ),
    );
  }
}
