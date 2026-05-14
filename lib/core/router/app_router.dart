import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          const _SimpleScreen(title: 'Login', subtitle: '/login'),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => ProductDetailScreen(
        productId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
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
