import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/product_feed_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/product_grid_shimmer.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.extentAfter < 500) {
      ref.read(productFeedControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productFeedControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: productsAsync.when(
          loading: () => const Center(child: ProductGridShimmer()),
          error: (error, stackTrace) => _StateMessage(
            icon: Icons.error_outline,
            title: 'Failed to load products',
            message: error.toString(),
            onRetry: () =>
                ref.read(productFeedControllerProvider.notifier).refreshFeed(),
          ),
          data: (feedState) {
            final products = feedState.products;

            return RefreshIndicator(
              onRefresh: () => ref
                  .read(productFeedControllerProvider.notifier)
                  .refreshFeed(),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.96),
                              colorScheme.secondary.withValues(alpha: 0.88),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Products',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Discover your next favorite product',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Hand-picked items from DummyJSON, tuned for a clean mobile shopping experience.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (products.isEmpty)
                    const SliverToBoxAdapter(
                      child: _StateMessage(
                        icon: Icons.inbox_outlined,
                        title: 'No products found',
                        message: 'Try again later.',
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.60,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context.push('/product/${product.id}'),
                          );
                        }, childCount: products.length),
                      ),
                    ),
                  if (feedState.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  if (feedState.errorMessage != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: _StateMessage(
                          icon: Icons.error_outline,
                          title: 'Could not load more items',
                          message: feedState.errorMessage!,
                          onRetry: () => ref
                              .read(productFeedControllerProvider.notifier)
                              .loadMore(),
                        ),
                      ),
                    ),
                  if (feedState.hasReachedEnd && products.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Text(
                          'You reached the end of the catalog.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
