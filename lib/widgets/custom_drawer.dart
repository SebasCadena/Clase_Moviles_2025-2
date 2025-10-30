import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary, // Usa el color primario del tema
            ),
            child: const Text(
              'Menú',
              style: TextStyle(
                color: Colors.white, // Texto blanco para contrastar con el color primario
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Inicio',
              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              context.go('/'); // Navega a la ruta principal
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Configuración'), onTap: () {}),
          ListTile(leading: const Icon(Icons.person), title: const Text('Perfil'), onTap: () {}),
          //!PASO DE PARAMETROS
          ListTile(leading: const Icon(Icons.input), title: const Text('Visita la página'), onTap: () => {}),
          ListTile(leading: const Icon(Icons.loop), title: const Text('Sincronización'), onTap: () => {}),
           ListTile( 
            leading: const Icon(Icons.cloud), 
            title: const Text('Categorías Firebase'), 
            onTap: () => context.pushNamed('categoriasFirebase'), 
          ),
        ],
      ),
    );
  }
}
