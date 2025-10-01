import 'package:go_router/go_router.dart';
import 'package:talleres/views/about/aboutme.dart';
import 'package:talleres/views/home/home.dart';
import 'package:talleres/views/login/login.dart';
import 'package:talleres/views/TabBar/bar.dart';
import 'package:talleres/views/usuarios/usuarios.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(title: 'Hola, Flutter'),
      routes: [
        GoRoute(
          path: 'aboutme/:parametro/:metodo',
          builder: (context, state) {
            final parametro = state.pathParameters['parametro']!;
            final metodo = state.pathParameters['metodo']!;
            return Aboutme(parametro: parametro, metodoNavegacion: metodo);
          },
        ),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => const Login()),
    GoRoute(path: '/tabbar', builder: (context, state) => const Bar()),
    GoRoute(
      path: '/usuarios',
      name: 'usuarios',
      builder: (context, state) => const Usuarios(),
    ),
  ],
);
