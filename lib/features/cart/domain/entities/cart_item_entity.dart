class CartItemEntity {
  const CartItemEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.discountPercentage,
    required this.discountedTotal,
    required this.thumbnail,
  });

  final int id;
  final String title;
  final num price;
  final int quantity;
  final num total;
  final num discountPercentage;
  final num discountedTotal;
  final String thumbnail;
}
