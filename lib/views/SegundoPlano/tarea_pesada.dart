import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TareaPesada extends StatefulWidget {
  const TareaPesada({super.key});

  @override
  State<TareaPesada> createState() => _TareaPesadaState();
}

class _TareaPesadaState extends State<TareaPesada> {
  String resultado1 = "Presiona el botón para ejecutar tarea básica";
  String resultado2 = "Presiona el botón para ejecutar suma pesada";
  bool _ejecutandoTarea = false;

  // Función para verificar si hay alguna tarea ejecutándose
  bool _isAnyTaskRunning() {
    return _ejecutandoTarea;
  }

  //! Función que ejecuta la tarea pesada en un Isolate (EJEMPLO DEL PROFESOR)
  Future<void> tareaBasica() async {
    setState(() {
      _ejecutandoTarea = true;
    });

    final receivePort = ReceivePort(); // Buzón para recibir datos

    // Lanza un nuevo Isolate y le pasa el canal de comunicación principal
    await Isolate.spawn(_simulacionTareaBasica, receivePort.sendPort);

    // Espera a recibir el sendPort del nuevo isolate
    final sendPort = await receivePort.first as SendPort;

    // Crea un canal para recibir la respuesta
    final response = ReceivePort();

    // Envía un mensaje al isolate: datos + cómo responder (replyPort)
    sendPort.send(["Hola desde el hilo principal", response.sendPort]);

    // Espera la respuesta del isolate
    final result = await response.first as String;

    // Actualiza la UI con el resultado
    if (!mounted) return;
    setState(() {
      resultado1 = result;
      _ejecutandoTarea = false;
    });
  }

  //! Función adicional: Suma pesada en Isolate
  Future<void> sumaPesada() async {
    setState(() {
      _ejecutandoTarea = true;
    });

    final receivePort = ReceivePort(); // Buzón para recibir datos

    await Isolate.spawn(_calculoSumaPesada, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final response = ReceivePort();

    sendPort.send([500000000, response.sendPort]); // Sumar hasta 50 millones

    final result = await response.first as String;

    if (!mounted) return;
    setState(() {
      resultado2 = result;
      _ejecutandoTarea = false;
    });
  }

  //! Simulación tarea básica (EJEMPLO DEL PROFESOR)
  static void _simulacionTareaBasica(SendPort sendPort) async {
    final port = ReceivePort(); // Buzón interno del isolate
    sendPort.send(port.sendPort); // Se lo enviamos al hilo principal

    // Espera a recibir mensajes
    await for (final message in port) {
      final data = message[0] as String;
      final puertoReceptor = message[1] as SendPort; // Canal para responder

      int counter = 0;
      for (int i = 1; i <= 10; i++) {
        counter += i;
        if (kDebugMode) {
          print("Isolate contando: $i");
        }
      }

      puertoReceptor.send(
        "Tarea básica completada. Suma: $counter.\nMensaje recibido: '$data'",
      );
      port.close(); // Cierra el puerto
      Isolate.exit(); // Finaliza el Isolate.
    }
  }

  //! Función adicional: Cálculo de suma pesada
  static void _calculoSumaPesada(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final message in port) {
      final limite = message[0] as int;
      final puertoReceptor = message[1] as SendPort;

      int suma = 0;
      for (int i = 1; i <= limite; i++) {
        suma += i;

        // Mostrar progreso cada 100,000 números
        if (i % 100000 == 0) {
          if (kDebugMode) {
            print("Calculando suma: $i / $limite");
          }
        }
      }

      puertoReceptor.send(
        "Suma pesada completada.\nSuma de 1 a $limite = $suma",
      );
      port.close();
      Isolate.exit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tarea Pesada con Isolate")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Resultado de tarea básica
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Tarea Básica (Ejemplo del Profesor)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(resultado1, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _ejecutandoTarea ? null : tareaBasica,
                        child: const Text("Ejecutar tarea básica"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Resultado de suma pesada
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Suma Pesada (Función Adicional)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(resultado2, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _ejecutandoTarea ? null : sumaPesada,
                        icon: const Icon(Icons.calculate),
                        label: const Text("Ejecutar suma pesada"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Indicador de estado
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _isAnyTaskRunning()
                      ? Colors.orange[50]
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isAnyTaskRunning() ? Colors.orange : Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isAnyTaskRunning()
                          ? Icons.hourglass_empty
                          : Icons.check_circle,
                      color: _isAnyTaskRunning() ? Colors.orange : Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isAnyTaskRunning()
                          ? "Ejecutando en Isolate..."
                          : "Listo para ejecutar",
                      style: TextStyle(
                        color: _isAnyTaskRunning()
                            ? Colors.orange[800]
                            : Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
