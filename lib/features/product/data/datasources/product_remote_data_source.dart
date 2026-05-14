import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  Future<List<ProductModel>> getProducts({int limit = 10, int skip = 0}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.productsPath,
      queryParameters: <String, dynamic>{'limit': limit, 'skip': skip},
    );

    final products = (response.data?['products'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();

    return products.map(ProductModel.fromJson).toList(growable: false);
  }

  Future<ProductEntity> getProductById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.productsPath}/$id',
    );

    return ProductModel.fromJson(response.data ?? <String, dynamic>{});
  }
}
