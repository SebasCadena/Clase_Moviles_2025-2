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
  String _titulo = '';

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
        _titulo = 'Bienvenido a Flutter';
      }
    });
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Juan Sebastian Cadena Varela",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text('You have pushed the button this many times:'),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.network(
                'https://www.uceva.edu.co/wp-content/uploads/2020/07/Uceva-Vertical-png.png',
                width: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset('assets/images/Perfil.jpg', width: 150),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ElevatedButton(
                onPressed: _cambiarTitulo,
                child: const Text('Cambiar título'),
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
