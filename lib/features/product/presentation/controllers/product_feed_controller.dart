import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/pagination/paginated_response.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_providers.dart';

class ProductFeedState {
  const ProductFeedState({
    required this.products,
    required this.nextSkip,
    required this.hasReachedEnd,
    required this.isLoadingMore,
    this.errorMessage,
  });

  final List<ProductEntity> products;
  final int nextSkip;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final String? errorMessage;

  ProductFeedState copyWith({
    List<ProductEntity>? products,
    int? nextSkip,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return ProductFeedState(
      products: products ?? this.products,
      nextSkip: nextSkip ?? this.nextSkip,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }
}

final productFeedControllerProvider =
    AsyncNotifierProvider<ProductFeedController, ProductFeedState>(
      ProductFeedController.new,
    );

class ProductFeedController extends AsyncNotifier<ProductFeedState> {
  @override
  Future<ProductFeedState> build() async {
    final page = await _fetchPage(skip: 0);
    final products = page.items;
    return ProductFeedState(
      products: products,
      nextSkip: page.skip + page.items.length,
      hasReachedEnd: !page.hasMore,
      isLoadingMore: false,
    );
  }

  Future<void> loadMore() async {
    final currentState = state.asData?.value;
    if (currentState == null ||
        currentState.isLoadingMore ||
        currentState.hasReachedEnd) {
      return;
    }

    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      final page = await _fetchPage(skip: currentState.nextSkip);
      final products = page.items;
      final mergedProducts = <ProductEntity>[
        ...currentState.products,
        ...products,
      ];

      state = AsyncData(
        currentState.copyWith(
          products: mergedProducts,
          nextSkip: page.skip + page.items.length,
          hasReachedEnd: !page.hasMore,
          isLoadingMore: false,
          errorMessage: null,
        ),
      );
    } catch (error) {
      state = AsyncData(
        currentState.copyWith(
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> refreshFeed() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<PaginatedResponse<ProductEntity>> _fetchPage({required int skip}) {
    return ref
        .read(getProductsUseCaseProvider)
        .call(limit: ApiConstants.defaultProductsLimit, skip: skip);
  }
}
