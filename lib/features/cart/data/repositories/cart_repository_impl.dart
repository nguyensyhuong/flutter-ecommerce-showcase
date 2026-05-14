import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._remoteDataSource);

  final CartRemoteDataSource _remoteDataSource;

  @override
  Future<CartEntity?> getCartByUserId(int userId) {
    return _remoteDataSource.getCartByUserId(userId);
  }
}
