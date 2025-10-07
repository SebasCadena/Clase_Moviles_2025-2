import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talleres/models/joke_model.dart';
import 'package:talleres/services/joke_service.dart';

class Jokes extends StatefulWidget {
  const Jokes({super.key});

  @override
  State<Jokes> createState() => _JokesState();
}

class _JokesState extends State<Jokes> {
  final JokeService _jokeService = JokeService();
  //* Se declara una variable de tipo Future que contendrá la lista de chistes
  late Future<List<JOKE>> _futureJokes;

  @override
  void initState() {
    super.initState();
    _futureJokes = _jokeService.getJokes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jokes')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<JOKE>>(
              future: _futureJokes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
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
                          context.push('/joke/${j.id}');
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _futureJokes = _jokeService.getJokes();
          });
        },
        tooltip: 'Nuevo chiste',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
