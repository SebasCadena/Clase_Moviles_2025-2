import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talleres/widgets/custom_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _counter = 0;
  bool _indicador = false;
  String _titulo = 'ClaseMoviles V1.0.1';
  late AnimationController
  _animationController; // Controller que necesita ser liberado
  late Animation<double> _rotationAnimation;

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (kDebugMode) {
        print("🟠 setState() -> Estado actualizado : $_counter");
      }
    });
  }

  void _reducirCounter() {
    setState(() {
      _counter--;
      if (kDebugMode) {
        print("🟠 setState() -> Estado actualizado : $_counter");
      }
    });
  }

  void _cambiarTitulo() {
    setState(() {
      _indicador = !_indicador;
      _counter = 0;
      _setTitulo();
    });
    _animationController.forward().then((_) {
      _animationController.reset();
    });
  }

  void _setTitulo() {
    setState(() {
      if (_indicador) {
        _titulo = 'ClaseMoviles 2025-2'; // Cambiar orden
      } else {
        _titulo = 'ClaseMoviles'; // Cambiar orden
      }
      if (kDebugMode) {
        print("🟠 setState() -> Estado actualizado -> Título: $_titulo");
      }
    });
  }

  void goToAboutme(String metodo) {
    final tituloEncode = Uri.encodeComponent(_titulo);
    context.push('/aboutme/$tituloEncode/$metodo');
  }

  void goToLogin() {
    context.go('/login');
  }

  void goToTabBar() {
    context.replace('/tabbar');
  }

  void goToUsuarios() {
    context.push('/usuarios');
  }

  void goToJokes() {
    context.push('/jokes');
  }

  void mostrarSnackbar() {
    final snackBar = SnackBar(
      content: Text('Título Actualizado: $_titulo'),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _titulo = widget.title;

    // Inicializar AnimationController para demostrar dispose()
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this, // Requiere TickerProviderStateMixin
    );

    // Crear una animación de rotación
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    if (kDebugMode) {
      print(
        '🟢 initState() -> Inicializando widget Home. Se ejecuta UNA VEZ al crear el widget',
      );
      print('Home - initState - Título: $_titulo');
    }
  }

  @override
  void dispose() {
    // El dispose() se usa para liberar recursos que consumen memoria de forma activa:
    // - Controllers (mantienen listeners internos)
    // - Streams (mantienen conexiones abiertas)
    // - Timers (mantienen callbacks programados)
    // Los tipos primitivos (String, int, bool) no necesitan dispose()
    _animationController.dispose(); // Liberamos la memoria del controlador
    if (kDebugMode) {
      print(
        "🔴 dispose() -> Liberando recursos del widget Home. Se ejecuta al destruir el widget",
      );
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (kDebugMode) {
      print("didChangeDependencies() -> Tema actual");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("🔵 build() -> Construyendo la pantalla");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_titulo),

        actions: [
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle:
                    _rotationAnimation.value * 2 * 3.14159, // Rotación completa
                child: ElevatedButton(
                  onPressed: () {
                    _cambiarTitulo();
                    mostrarSnackbar();
                  },
                  child: const Icon(Icons.refresh),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    goToJokes();
                  },
                  icon: Icon(Icons.accessible, color: Colors.amber),
                  label: Text('Jokes - Taller HTTP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    goToUsuarios();
                  },
                  icon: Icon(Icons.supervised_user_circle, color: Colors.amber),
                  label: Text('Usuarios - Taller Segundo Plano'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    goToAboutme('push');
                  },
                  icon: Icon(Icons.description, color: Colors.amber),
                  label: Text('AboutMe - Push'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    goToTabBar();
                  },
                  icon: Icon(Icons.tab, color: Colors.amber),
                  label: Text('TabBar - Replace'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    goToLogin();
                  },
                  icon: Icon(Icons.person, color: Colors.amber),
                  label: Text('Login - Go'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            Text(
              "Juan Sebastian Cadena Varela",
              style: TextStyle(fontSize: 25),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(
                  Theme.of(context).colorScheme.inversePrimary.value,
                ),
                border: Border.all(
                  width: 2.0,
                  color: Color(Theme.of(context).colorScheme.primary.value),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('You have pushed the button this many times:'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  'https://www.uceva.edu.co/wp-content/uploads/2020/07/Uceva-Vertical-png.png',
                  width: 150,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset('assets/images/Perfil.jpg', width: 150),
                    Container(
                      width: 150,
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        'Juan S. Cadena',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      // añadir un botón para incrementar el contador y otro para resetearlo
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              onPressed: _reducirCounter,
              heroTag: "decrement",
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            heroTag: "increment",
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
