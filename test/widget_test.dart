import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_ecommerce_showcase/main.dart';
import 'package:flutter_ecommerce_showcase/features/product/domain/entities/product_entity.dart';
import 'package:flutter_ecommerce_showcase/features/product/presentation/providers/product_providers.dart';

void main() {
  testWidgets('starts on product list route', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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

    expect(find.text('Products'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
  });
}
