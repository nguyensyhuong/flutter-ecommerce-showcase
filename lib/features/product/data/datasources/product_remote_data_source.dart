import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/pagination/paginated_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  Future<ApiResult<PaginatedResponse<ProductModel>>> getProducts({
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.productsPath,
        queryParameters: <String, dynamic>{'limit': limit, 'skip': skip},
      );

      final products =
          (response.data?['products'] as List<dynamic>? ?? const [])
              .cast<Map<String, dynamic>>();
      final total =
          (response.data?['total'] as num?)?.toInt() ?? products.length;

      return ApiSuccess(
        PaginatedResponse<ProductModel>(
          items: products.map(ProductModel.fromJson).toList(growable: false),
          skip: skip,
          limit: limit,
          total: total,
        ),
      );
    } on DioException catch (error, stackTrace) {
      return ApiFailure<PaginatedResponse<ProductModel>>(
        message: error.message ?? 'Failed to load products',
        statusCode: error.response?.statusCode,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      return ApiFailure<PaginatedResponse<ProductModel>>(
        message: error.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<ProductEntity> getProductById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.productsPath}/$id',
    );

    return ProductModel.fromJson(response.data ?? <String, dynamic>{});
  }
}
