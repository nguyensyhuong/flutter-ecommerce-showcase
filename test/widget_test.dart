import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ecommerce_showcase/main.dart';

void main() {
  testWidgets('starts on login route', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    expect(find.text('/login'), findsOneWidget);
  });
}
