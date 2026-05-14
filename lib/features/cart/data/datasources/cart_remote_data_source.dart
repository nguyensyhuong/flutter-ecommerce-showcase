import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/cart_model.dart';

class CartRemoteDataSource {
  CartRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  Future<CartModel?> getCartByUserId(int userId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/carts/user/$userId',
    );

    final carts = (response.data?['carts'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();

    if (carts.isEmpty) {
      return null;
    }

    return CartModel.fromJson(carts.first);
  }
}
