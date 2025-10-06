import 'dart:async';
import 'package:flutter/material.dart';

class Cronometro extends StatefulWidget {
  const Cronometro({super.key});

  @override
  State<Cronometro> createState() => _CronometroState();
}

class _CronometroState extends State<Cronometro> {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  // Formatear tiempo en MM:SS
  String get _timeString {
    int minutes = _seconds ~/ 60;
    int remainingSeconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    print('🟢 Timer INICIADO');
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
      print('⏰ Cronómetro: $_timeString ($_seconds segundos)');
    });
  }

  void _pauseTimer() {
    print('🟡 Timer PAUSADO en: $_timeString');
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
    _timer?.cancel();
  }

  void _resumeTimer() {
    print('🔵 Timer REANUDADO desde: $_timeString');
    _startTimer();
  }

  void _resetTimer() {
    print('🔴 Timer REINICIADO (era: $_timeString)');
    setState(() {
      _seconds = 0;
      _isRunning = false;
      _isPaused = false;
    });
    _timer?.cancel();
  }

  @override
  void dispose() {
    print('🗑️ dispose() - Cancelando timer antes de destruir el widget');
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronómetro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: Text(
                _timeString,
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getStatusText(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón Iniciar/Reanudar
                if (!_isRunning)
                  ElevatedButton.icon(
                    onPressed: _isPaused ? _resumeTimer : _startTimer,
                    icon: Icon(
                      _isPaused ? Icons.play_circle_fill : Icons.play_arrow,
                    ),
                    label: Text(_isPaused ? 'Reanudar' : 'Iniciar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),

                // Botón Pausar
                if (_isRunning)
                  ElevatedButton.icon(
                    onPressed: _pauseTimer,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pausar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),

                // Botón Reiniciar
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reiniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ✅ Información adicional
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Información del Timer',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Segundos totales: $_seconds'),
                    Text('Estado: ${_getStatusText()}'),
                    Text('Timer activo: ${_timer?.isActive ?? false}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (_isRunning) return Colors.green;
    if (_isPaused) return Colors.orange;
    return Colors.grey;
  }

  String _getStatusText() {
    if (_isRunning) return 'EJECUTÁNDOSE';
    if (_isPaused) return 'PAUSADO';
    return 'DETENIDO';
  }
}
