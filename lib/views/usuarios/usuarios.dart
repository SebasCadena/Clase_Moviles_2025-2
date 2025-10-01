import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

List<String> _nombres = []; // declarar una lista.

class _UsuariosState extends State<Usuarios> {
  Future<List<String>> getUsuarios() async {
    print('🔵 ANTES: Iniciando consulta de usuarios...');

    await Future.delayed(const Duration(seconds: 3));

    print('🟡 DURANTE: Procesando datos de usuarios...');

    // Simular error ocasionalmente (20% de probabilidad)

    return [
      'Juan Sebastian Cadena Varela',
      'Maria Jose Ramirez Cardona',
      'Giseth Tatiana Quintero Sanchez',
    ];
  }

  Future<void> obtenerDatos() async {
    final datos = await getUsuarios();

    //!mounted es una propiedad de State que indica si el widget está montado en el árbol de widgets
    //mounted es true si el widget está montado en el árbol de widgets
    //mounted es false si el widget no está montado en el árbol de widgets
    if (!mounted) return;
    setState(() {
      _nombres = datos;
    });
  }

  @override
  // !inicializa el estado
  // *llama a la funcion obtenerDatos() para cargar los datos al iniciar
  void initState() {
    super.initState();
    obtenerDatos(); // carga al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _nombres.clear(); // limpiar la lista
              });
              obtenerDatos(); // recarga los datos
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lista de Usuarios',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 50),

            Expanded(child: _build()),
          ],
        ),
      ),
    );
  }
}

Widget _build() {
  return _nombres.isEmpty
      ? Column(
          children: [
            const Text('Cargando usuarios...'),
            const SizedBox(height: 20),
            const Center(child: CircularProgressIndicator()),
          ],
        )
      : ListView.builder(
          itemCount: _nombres.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text('${index + 1}. ${_nombres[index]}'));
          },
        );
}
