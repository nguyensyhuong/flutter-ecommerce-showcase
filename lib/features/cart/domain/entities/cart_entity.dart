import 'cart_item_entity.dart';

class CartEntity {
  const CartEntity({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
  });

  final int id;
  final List<CartItemEntity> products;
  final num total;
  final num discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;
}
