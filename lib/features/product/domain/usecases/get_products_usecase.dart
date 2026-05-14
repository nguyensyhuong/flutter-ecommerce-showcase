import '../../../../core/pagination/paginated_response.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<PaginatedResponse<ProductEntity>> call({
    int limit = 10,
    int skip = 0,
  }) {
    return _repository.getProducts(limit: limit, skip: skip);
  }
}
