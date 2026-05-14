import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<CartEntity?> getCartByUserId(int userId);
}
