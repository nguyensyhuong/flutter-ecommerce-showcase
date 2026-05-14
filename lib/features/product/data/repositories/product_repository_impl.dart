import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<List<ProductEntity>> getProducts({int limit = 10, int skip = 0}) {
    return _remoteDataSource.getProducts(limit: limit, skip: skip);
  }

  @override
  Future<ProductEntity> getProductById(int id) {
    return _remoteDataSource.getProductById(id);
  }
}
