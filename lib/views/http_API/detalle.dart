import 'package:flutter/material.dart';
import 'package:talleres/models/joke_model.dart';
import 'package:talleres/services/joke_service.dart';

class Detalle extends StatefulWidget {
  const Detalle({super.key, required this.id});
  final String id;

  @override
  State<Detalle> createState() => _DetalleState();
}

class _DetalleState extends State<Detalle> {
  final JokeService _jokeService = JokeService();
  // Se declara una variable de tipo Future que contendrá el detalle del Pokémon
  late Future<JOKE> _futureJokes;

  @override
  void initState() {
    super.initState();
    // Se llama al método getPokemonByName de la clase PokemonService
    //_futureJokes = _jokeService.getJokes();//widget.name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("data"));
  }
}
