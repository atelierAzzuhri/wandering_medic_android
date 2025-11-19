import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:medics_patient/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full registration flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('dont have an account? Register here'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('usernameField')), 'muhammad');
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'muhammad@example.com',
    );
    await tester.enterText(find.byKey(const Key('phoneField')), '08123456789');
    await tester.enterText(
      find.byKey(const Key('passwordField')),
      'securePass123',
    );

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    print('✅ Account form submitted, moving to address form');

    await tester.enterText(find.byKey(const Key('stateField')), 'yogyakarta');
    await tester.enterText(
      find.byKey(const Key('cityField')),
      'yogyakarta city',
    );
    await tester.enterText(
      find.byKey(const Key('streetField')),
      'JL Ring Road Utara',
    );

    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
  });
}
