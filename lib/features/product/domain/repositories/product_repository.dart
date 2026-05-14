import '../entities/product_entity.dart';
import '../../../../core/pagination/paginated_response.dart';

abstract class ProductRepository {
  Future<PaginatedResponse<ProductEntity>> getProducts({
    int limit = 10,
    int skip = 0,
  });

  Future<ProductEntity> getProductById(int id);
}
