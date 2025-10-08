import 'package:flutter/material.dart';

class Detalle extends StatelessWidget {
  const Detalle({
    super.key,
    required this.id,
    required this.iconUrl,
    required this.value,
  });
  final String id;
  final String iconUrl;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del chiste')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconUrl.isNotEmpty)
              Center(
                child: Image.network(iconUrl, height: 240, fit: BoxFit.contain),
              ),
            const SizedBox(height: 20),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text('ID: $id', style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
