import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Hola, Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _indicador = false;
  String _titulo = 'Hola, Flutter';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _reducirCounter() {
    setState(() {
      _counter--;
    });
  }

  void _cambiarTitulo() {
    setState(() {
      _indicador = !_indicador;
      _setTitulo();
    });
  }

  void _setTitulo() {
    setState(() {
      if (_indicador) {
        _titulo = 'Hola, Flutter';
      } else {
        _titulo = 'Título Cambiado';
      }
    });
  }

  void mostrarSnackbar() {
    final snackBar = SnackBar(
      content: Text('Título Actualizado: ' + _titulo),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _titulo = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(_titulo),
        actions: [
          ElevatedButton(
            onPressed: () {
              _cambiarTitulo();
              mostrarSnackbar();
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              "Juan Sebastian Cadena Varela",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
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

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('¡Contactame!    +57 3114304487')),
                );
              },
              icon: Icon(Icons.description, color: Colors.yellow),
              label: Text('Información'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
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
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
