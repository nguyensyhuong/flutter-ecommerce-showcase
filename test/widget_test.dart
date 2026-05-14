import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_ecommerce_showcase/features/auth/domain/entities/auth_session_entity.dart';
import 'package:flutter_ecommerce_showcase/features/auth/domain/entities/auth_user_entity.dart';
import 'package:flutter_ecommerce_showcase/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_ecommerce_showcase/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_ecommerce_showcase/features/product/domain/entities/product_entity.dart';
import 'package:flutter_ecommerce_showcase/features/product/presentation/providers/product_providers.dart';
import 'package:flutter_ecommerce_showcase/main.dart';

class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository();

  @override
  Future<AuthSessionEntity> login({
    required String username,
    required String password,
  }) async {
    return const AuthSessionEntity(
      user: AuthUserEntity(
        id: 1,
        username: 'emilys',
        email: 'emily.johnson@x.dummyjson.com',
        firstName: 'Emily',
        lastName: 'Johnson',
        gender: 'female',
        image: 'https://dummyjson.com/icon/emilys/128',
      ),
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
  }

  @override
  Future<AuthUserEntity> getCurrentUser(String accessToken) async {
    return const AuthUserEntity(
      id: 1,
      username: 'emilys',
      email: 'emily.johnson@x.dummyjson.com',
      firstName: 'Emily',
      lastName: 'Johnson',
      gender: 'female',
      image: 'https://dummyjson.com/icon/emilys/128',
    );
  }
}

void main() {
  testWidgets('login navigates into shell home', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(const FakeAuthRepository()),
          productsProvider.overrideWith(
            (ref) async => const [
              ProductEntity(
                id: 1,
                title: 'iPhone 15 Pro',
                description: 'A premium phone',
                price: 999,
                discountPercentage: 0,
                rating: 4.8,
                stock: 12,
                brand: 'Apple',
                category: 'smartphones',
                thumbnail: 'https://example.com/image.png',
                images: ['https://example.com/image.png'],
              ),
            ],
          ),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
  });
}
