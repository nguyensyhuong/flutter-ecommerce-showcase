import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/cart_remote_data_source.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';

final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>(
  (ref) => CartRemoteDataSource(dio: DioClient.instance),
);

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartRepositoryImpl(ref.watch(cartRemoteDataSourceProvider)),
);

final cartByUserProvider = FutureProvider.family<CartEntity?, int>(
  (ref, userId) {
    return ref.watch(cartRepositoryProvider).getCartByUserId(userId);
  },
);
