import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booth_app/main.dart';

void main() {
  testWidgets('PhotoboothApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PhotoboothApp(),
      ),
    );

    expect(find.text('PHOTOISM PLATFORM'), findsOneWidget);
  });
}
