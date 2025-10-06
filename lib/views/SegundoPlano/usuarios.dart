import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  List<String> _nombres = []; // declarar una lista.
  bool _isLoading = false;
  String? _error;

  Future<List<String>> getUsuarios() async {
    print('🔵 ANTES: Iniciando consulta de usuarios...');

    await Future.delayed(const Duration(seconds: 3));

    print('🟡 DURANTE: Procesando datos de usuarios...');

    // if (true) Ejecuta siempre el error
    if (DateTime.now().millisecond % 5 == 0) {
      throw Exception('Error de conexión simulado');
    }

    return [
      'Juan Sebastian Cadena Varela',
      'Maria Jose Ramirez Cardona',
      'Giseth Tatiana Quintero Sanchez',
      'Andres Felipe Lozano Lozano',
    ];
  }

  Future<void> obtenerDatos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // ✅ AGREGAR try/catch
      print('🟢 INICIO: Consultando usuarios...');

      final datos = await getUsuarios();

      if (!mounted) return;

      setState(() {
        _nombres = datos;
        _isLoading = false;
      });

      print(
        '🟢 DESPUÉS: Datos cargados exitosamente (${datos.length} usuarios)',
      );
    } catch (e) {
      // ✅ MANEJAR errores
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });

      print('🔴 ERROR: $e');
    }
  }

  @override
  // !inicializa el estado
  // *llama a la funcion obtenerDatos() para cargar los datos al iniciar
  void initState() {
    super.initState();
    print('🟣 initState: Inicializando pantalla de usuarios');
    obtenerDatos(); // carga al iniciar
  }

  @override
  void dispose() {
    _nombres.clear(); // limpiar la lista al salir
    print('🟣 dispose: Limpiando recursos de usuarios');
    super.dispose();
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Lista de Usuarios',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            _build(),

            Column(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.timer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.inversePrimary,
                    foregroundColor: Colors.black,
                  ),
                  label: const Text('Cronometro'),
                  onPressed: () {
                    context.push('/cronometro');
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_task_outlined),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.inversePrimary,
                    foregroundColor: Colors.black,
                  ),
                  label: const Text('Tarea Pesada'),
                  onPressed: () {
                    context.push('/tarea_pesada');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _build() {
    if (_isLoading) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando usuarios...'),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      // ✅ ESTADO DE ERROR
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 64),
              SizedBox(height: 16),
              Text('Error al cargar usuarios'),
              SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: obtenerDatos,
                child: Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 300, // Altura fija para que spaceEvenly funcione
      child: ListView.builder(
        itemCount: _nombres.length,
        itemBuilder: (context, index) {
          return Container(
            color: index % 2 == 0
                ? Color(
                    Theme.of(context).colorScheme.inversePrimary.value,
                  ).withOpacity(0.1)
                : Colors.white,
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(_nombres[index]),
            ),
          );
        },
      ),
    );
  }
}
