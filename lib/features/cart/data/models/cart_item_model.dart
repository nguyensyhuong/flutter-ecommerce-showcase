import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.title,
    required super.price,
    required super.quantity,
    required super.total,
    required super.discountPercentage,
    required super.discountedTotal,
    required super.thumbnail,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      price: json['price'] as num? ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      total: json['total'] as num? ?? 0,
      discountPercentage: json['discountPercentage'] as num? ?? 0,
      discountedTotal: json['discountedTotal'] as num? ?? 0,
      thumbnail: (json['thumbnail'] as String?) ?? '',
    );
  }
}
