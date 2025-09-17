import 'package:go_router/go_router.dart';
import 'package:talleres/views/about/aboutme.dart';
import 'package:talleres/views/home/home.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(title: 'Hola, Flutter'),
      routes: [
        GoRoute(
          path:
              'aboutme/:parametro/:metodo', //la ruta recibe dos parametros los " : " indican que son parametros
          builder: (context, state) {
            //*se capturan los parametros recibidos
            // declarando las variables parametro y metodo
            // es final porque no se van a modificar
            final parametro = state.pathParameters['parametro']!;
            final metodo = state.pathParameters['metodo']!;
            return Aboutme(parametro: parametro, metodoNavegacion: metodo);
          },
        ),
      ],
    ),
  ],
);
