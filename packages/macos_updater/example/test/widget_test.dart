import 'package:flutter_test/flutter_test.dart';
import 'package:macos_updater_example/main.dart';

void main() {
  testWidgets('shows the updater status and check button', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Status: Idle'), findsOneWidget);
    expect(find.text('Check for Updates'), findsOneWidget);
  });
}
