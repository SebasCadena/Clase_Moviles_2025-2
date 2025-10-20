import 'package:go_router/go_router.dart';
import 'package:talleres/views/SegundoPlano/cronometro.dart';
import 'package:talleres/views/SegundoPlano/tarea_pesada.dart';
import 'package:talleres/views/about/aboutme.dart';
import 'package:talleres/views/home/home.dart';
import 'package:talleres/views/http_API/api.dart';
import 'package:talleres/views/http_API/detalle.dart';
import 'package:talleres/views/login/login.dart';
import 'package:talleres/views/TabBar/bar.dart';
import 'package:talleres/views/SegundoPlano/usuarios.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(title: 'ClaseMoviles'),
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
    GoRoute(
      path: '/cronometro',
      builder: (context, state) => const Cronometro(),
    ),
    GoRoute(
      path: '/tarea_pesada',
      builder: (context, state) => const TareaPesada(),
    ),
    GoRoute(path: '/jokes', builder: (context, state) => const Jokes()),
    GoRoute(
      path: '/detalle/:id/:iconUrl/:value',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final iconUrl = Uri.decodeComponent(state.pathParameters['iconUrl']!);
        final value = Uri.decodeComponent(state.pathParameters['value']!);
        return Detalle(id: id, iconUrl: iconUrl, value: value);
      },
    ),
  ],
);
