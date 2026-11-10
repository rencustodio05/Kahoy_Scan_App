import 'package:flutter_test/flutter_test.dart';

import 'package:kahoy_scan/main.dart';

void main() {
  testWidgets('Home screen shows brand, scan action, and recent scans', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KahoyScanApp());
    await tester.pumpAndSettle();

    expect(find.text('Kahoy Scan'), findsOneWidget);
    expect(find.text('Scan Bark'), findsOneWidget);
    expect(find.text('Species\nCatalog'), findsOneWidget);
    expect(find.text('Scan History'), findsOneWidget);
    expect(find.text('Recent Scans'), findsOneWidget);
    expect(find.text('Narra'), findsOneWidget);
    expect(find.text('Mahogany'), findsOneWidget);
    expect(find.text('Acacia'), findsOneWidget);
  });

  testWidgets('Scan Bark opens the capture screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KahoyScanApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scan Bark'));
    await tester.pumpAndSettle();

    expect(find.text('Fill the frame with bark'), findsOneWidget);
    expect(find.textContaining('Use good lighting'), findsOneWidget);
  });
}
