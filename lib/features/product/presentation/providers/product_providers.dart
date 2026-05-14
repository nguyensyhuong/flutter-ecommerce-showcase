import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/pagination/paginated_response.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>(
  (ref) => ProductRemoteDataSource(dio: DioClient.instance),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider)),
);

final getProductsUseCaseProvider = Provider<GetProductsUseCase>(
  (ref) => GetProductsUseCase(ref.watch(productRepositoryProvider)),
);

final productsProvider = FutureProvider<List<ProductEntity>>((ref) async {
  final page = await ref
      .watch(getProductsUseCaseProvider)
      .call(
        limit: ApiConstants.defaultProductsLimit,
        skip: ApiConstants.defaultProductsSkip,
      );
  return page.items;
});

final productsPageProvider = FutureProvider<PaginatedResponse<ProductEntity>>((
  ref,
) async {
  return ref
      .watch(getProductsUseCaseProvider)
      .call(
        limit: ApiConstants.defaultProductsLimit,
        skip: ApiConstants.defaultProductsSkip,
      );
});

final productDetailProvider = FutureProvider.family<ProductEntity, int>((
  ref,
  productId,
) {
  return ref.watch(productRepositoryProvider).getProductById(productId);
});
