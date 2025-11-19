import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:medics_patient/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final logger = Logger();

  testWidgets('Full patient update flow', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'token': 'test_token',
      'validity': '3h',
      'username': 'test_username',
      'email': 'test_email',
      'phone': 'test_phone'
    });

    logger.i('starting test');
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('test_username'), findsOneWidget);
    expect(find.text('test_email'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((key) {
      logger.i('$key: ${prefs.get(key)}');
    });

    logger.i('pressing accountNavigationButton');
    await tester.tap(find.byKey(Key('accountNavigationButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('accountExpander')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('updateAccountDialogButton')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('updateUsername')), 'update_username');
    await tester.enterText(find.byKey(const Key('updateEmail')), 'update_email');
    await tester.enterText(find.byKey(const Key('updatePhone')), 'update_phone');

    await tester.tap(find.byKey(Key('updateAccountButton')));
    await tester.pumpAndSettle();
  });
}
