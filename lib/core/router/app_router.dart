import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          const _SimpleScreen(title: 'Login', subtitle: '/login'),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) =>
          const _SimpleScreen(title: 'Home', subtitle: '/home'),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => _SimpleScreen(
        title: 'Product detail',
        subtitle: '/product/${state.pathParameters['id']}',
      ),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) =>
          const _SimpleScreen(title: 'Cart', subtitle: '/cart'),
    ),
  ],
);

class _SimpleScreen extends StatelessWidget {
  const _SimpleScreen({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}
