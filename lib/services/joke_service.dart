import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:talleres/models/joke_model.dart';

class JokeService {
  String apiUrl = dotenv.env['BASEURL']!;

  Future<List<JOKE>> getJokes() async {
    try {
      final response = await http.get(Uri.parse('${apiUrl}'));

      if (response.statusCode == 200) {
        // Decodificar la respuesta y aceptar tanto Map (objeto único)
        // como List (varios elementos). Normalizamos a List<JOKE>.
        final dynamic decoded = json.decode(response.body);

        if (decoded is List) {
          return decoded.map((item) => JOKE.fromJson(item)).toList();
        } else if (decoded is Map<String, dynamic>) {
          return [JOKE.fromJson(decoded)];
        } else {
          throw Exception(
            'Formato inesperado desde la API: ${decoded.runtimeType}',
          );
        }
      } else {
        throw Exception(
          'Error al obtener la lista de chistes. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getJokes: $e');
      }
      throw Exception('Error al conectar con la API de chistes: $e');
    }
  }
}
