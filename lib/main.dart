import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/canvas_view.dart';
import 'package:medics_patient/features/auth/auth_screen.dart';
import 'package:medics_patient/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');

    final route = (authData != null && authData.isNotEmpty) ? '/canvas' : '/auth';
    logger.i('isLoggedIn: token=${authData ?? "null"}, redirecting to $route');

    return route;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final initialRoute = snapshot.data;

        return MaterialApp(
          title: 'Medics_patient',
          theme: ThemeData(
            // SCAFFOLD BG
            scaffoldBackgroundColor: const Color(0xFF212529),

            primaryIconTheme: IconThemeData(color: Color(0xFFD7ED72)),
            iconTheme: IconThemeData(color: Color(0xFF868E96)),
            // TEXT
            textTheme: TextTheme(
              titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              bodyLarge: TextStyle(fontSize: 18, color:  Color(0xFFF8F9FA)),
              bodyMedium: TextStyle(fontSize: 14, color:  Color(0xFFF8F9FA)),
              bodySmall: TextStyle(fontSize: 12, color:  Color(0xFFF8F9FA)),
            ),
          ),
          initialRoute: initialRoute,
          routes: {
            '/auth': (context) => AuthScreen(),
            '/canvas': (context) => CanvasView(),
          },
        );
      },
    );
  }
}
