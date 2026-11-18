import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';

void main() {
  testWidgets('LiquidGlassShowcaseApp builds smoke test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LiquidGlassShowcaseApp());
    await tester.pump();

    expect(find.textContaining('5.2.0'), findsOneWidget);
  });
}
