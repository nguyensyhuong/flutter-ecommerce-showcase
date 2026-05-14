class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.skip,
    required this.limit,
    required this.total,
  });

  final List<T> items;
  final int skip;
  final int limit;
  final int total;

  bool get hasMore => skip + items.length < total;
}
