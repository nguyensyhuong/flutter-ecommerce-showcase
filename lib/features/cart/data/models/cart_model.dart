import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.products,
    required super.total,
    required super.discountedTotal,
    required super.userId,
    required super.totalProducts,
    required super.totalQuantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final products = (json['products'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>()
        .map(CartItemModel.fromJson)
        .toList(growable: false);

    return CartModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      products: products,
      total: json['total'] as num? ?? 0,
      discountedTotal: json['discountedTotal'] as num? ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      totalProducts: (json['totalProducts'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['totalQuantity'] as num?)?.toInt() ?? 0,
    );
  }
}
