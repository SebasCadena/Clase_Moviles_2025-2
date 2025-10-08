import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:talleres/models/joke_model.dart';

class JokeService {
  String apiUrl = dotenv.env['BASEURL']!;

  Future<List<JOKE>> getJokes() async {
    try {
      final response = await http.get(Uri.parse('${apiUrl}/search?query=word'));

      if (response.statusCode == 200) {
        // Decodificar la respuesta y aceptar tanto Map (objeto único)
        // como List (varios elementos). Normalizamos a List<JOKE>.
        final dynamic decoded = json.decode(response.body);

        //if (decoded is List) {
        //return decoded.map((item) => JOKE.fromJson(item)).toList();
        if (decoded is List) {
          return decoded
              .whereType<Map<String, dynamic>>()
              .map((item) => JOKE.fromJson(item))
              .toList();
        }

        if (decoded is Map<String, dynamic> &&
            decoded.containsKey('result') &&
            decoded['result'] is Iterable) {
          return (decoded['result'] as Iterable)
              .map((item) => JOKE.fromJson(item as Map<String, dynamic>))
              .toList();
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

  /// Obtener un chiste aleatorio. Si se especifica [category], se añade
  /// como query param: /jokes/random?category={category}
  Future<JOKE> getRandom({String? category}) async {
    try {
      final base = apiUrl.replaceAll(RegExp(r'/$'), '');
      String jokesRoot = base;
      final idx = base.indexOf('/jokes');
      if (idx != -1) {
        jokesRoot = base.substring(0, idx + '/jokes'.length);
      }

      final categoryPart = (category != null && category.isNotEmpty)
          ? '?category=${Uri.encodeQueryComponent(category)}'
          : '';
      final endpoint = '$jokesRoot/random$categoryPart';
      if (kDebugMode) {
        print('JokeService.getRandom -> endpoint: $endpoint');
      }

      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return JOKE.fromJson(decoded);
        }
        throw Exception(
          'Formato inesperado para random: ${decoded.runtimeType}',
        );
      } else {
        throw Exception(
          'Error al obtener chiste aleatorio. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) print('Error en getRandom: $e');
      rethrow;
    }
  }
}
