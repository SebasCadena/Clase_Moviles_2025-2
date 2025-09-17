import 'package:go_router/go_router.dart';
import 'package:talleres/views/home/home.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(title: 'Hola, Flutter'),
    ),
  ],
);