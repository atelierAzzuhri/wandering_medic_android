import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:medics_patient/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login patient flow test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Enter email
    await tester.enterText(find.byKey(Key('email')), 'testuser@example.com');

    // Enter password
    await tester.enterText(find.byKey(Key('password')), 'secure123');

    // Tap login
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pumpAndSettle();
  });
}
