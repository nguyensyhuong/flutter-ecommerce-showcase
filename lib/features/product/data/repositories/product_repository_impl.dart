import '../../../../core/pagination/paginated_response.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../../../../core/network/api_result.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<PaginatedResponse<ProductEntity>> getProducts({
    int limit = 10,
    int skip = 0,
  }) async {
    final result = await _remoteDataSource.getProducts(
      limit: limit,
      skip: skip,
    );

    return result.when(
      success: (page) => PaginatedResponse<ProductEntity>(
        items: page.items,
        skip: page.skip,
        limit: page.limit,
        total: page.total,
      ),
      failure: (failure) {
        throw Exception(failure.message);
      },
    );
  }

  @override
  Future<ProductEntity> getProductById(int id) {
    return _remoteDataSource.getProductById(id);
  }
}
