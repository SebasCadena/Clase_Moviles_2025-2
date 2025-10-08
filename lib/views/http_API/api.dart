import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:talleres/models/joke_model.dart';
import 'package:talleres/services/joke_service.dart';
import 'package:talleres/views/http_API/detalle.dart';

class Jokes extends StatefulWidget {
  const Jokes({super.key});

  @override
  State<Jokes> createState() => _JokesState();
}

class _JokesState extends State<Jokes> {
  final JokeService _jokeService = JokeService();
  //* Se declara una variable de tipo Future que contendrá la lista de chistes
  late Future<List<JOKE>> _futureJokes;
  String category = 'Todas';

  @override
  void initState() {
    super.initState();
    if (kDebugMode) print('Jokes.initState -> solicitando lista inicial');
    _futureJokes = _jokeService.getJokes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jokes')),
      body: Column(
        children: [
          Text(
            'Lista de Chistes - $category',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Expanded(
            child: FutureBuilder<List<JOKE>>(
              future: _futureJokes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  if (kDebugMode)
                    print('Jokes FutureBuilder error: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final jokes = snapshot.data;
                if (jokes == null || jokes.isEmpty) {
                  return const Center(
                    child: Text('No hay chistes disponibles'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  itemCount: jokes.length,
                  itemBuilder: (context, index) {
                    final j = jokes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Image.network(j.icon_url),
                        title: Text(
                          j.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${j.id} • ${j.created_at}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => Detalle(
                                id: j.id,
                                iconUrl: j.icon_url,
                                value: j.value,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'jokes_food',
            onPressed: () {
              setState(() {
                if (kDebugMode) print('Jokes FAB -> pedir categoría food');
                // getRandom devuelve Future<JOKE>, lo normalizamos a Future<List<JOKE>>
                _futureJokes = _jokeService
                    .getRandom(category: 'food')
                    .then((j) => [j]);
                category = 'Comida';
              });
            },
            tooltip: 'Nuevo chiste',
            child: const Icon(Icons.restaurant),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'jokes_animal',
            onPressed: () {
              setState(() {
                if (kDebugMode) print('Jokes FAB -> pedir categoría animal');
                // getRandom devuelve Future<JOKE>, lo normalizamos a Future<List<JOKE>>
                _futureJokes = _jokeService
                    .getRandom(category: 'animal')
                    .then((j) => [j]);
                category = 'Animal';
              });
            },
            tooltip: 'Nuevo chiste',
            child: const Icon(Icons.pets),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'jokes_money',
            onPressed: () {
              setState(() {
                if (kDebugMode) print('Jokes FAB -> pedir categoría money');
                // getRandom devuelve Future<JOKE>, lo normalizamos a Future<List<JOKE>>
                _futureJokes = _jokeService
                    .getRandom(category: 'money')
                    .then((j) => [j]);
                category = 'Dinero';
              });
            },
            tooltip: 'Nuevo chiste',
            child: const Icon(Icons.money),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (kDebugMode) print('Jokes FAB -> pedir categoría movie');
                // getRandom devuelve Future<JOKE>, lo normalizamos a Future<List<JOKE>>
                _futureJokes = _jokeService
                    .getRandom(category: 'movie')
                    .then((j) => [j]);
                category = 'Pelis';
              });
            },
            tooltip: 'Nuevo chiste',
            child: const Icon(Icons.movie),
          ),
        ],
      ),
    );
  }
}
