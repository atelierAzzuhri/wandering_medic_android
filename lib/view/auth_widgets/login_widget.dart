import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/models/account_model.dart';
import '../../viewmodel/auth_view_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    super.key,
    required this.registerSwitch,
    required this.medicLoginSwitch,
  });

  final VoidCallback registerSwitch;
  final VoidCallback medicLoginSwitch;

  @override
  State<LoginWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginWidget> {
  VoidCallback get registerSwitch => widget.registerSwitch;

  VoidCallback get medicLoginSwitch => widget.medicLoginSwitch;

  final accountFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin(WidgetRef ref) async {
    logger.i('login_form handle login');
    final data = AccountLoginRequestModel(
      email: emailController.text,
      password: passwordController.text,
    );

    final response = await ref.read(authViewModelProvider.notifier).login(data);

    if (response == 'success') {
      Navigator.pushNamed(context, '/');
    } else {
      logger.i('login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 32),
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFEE440),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 32),
            child: Text(
              'Using Account',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Form(
            key: accountFormKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF1C1F22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF212529),
                        // background color
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, // no border
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF212529),
                        // background color
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, // no border
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 156,
                        child: Consumer(
                          builder: (context, ref, _) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF212529),
                              // same as field background
                              foregroundColor: const Color(0xFFD7ED72),
                              // text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (accountFormKey.currentState!.validate()) {
                                handleLogin(ref);
                              }
                            },
                            child: Text(
                              'Login',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: const Color(0xFFD7ED72),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: registerSwitch,
              child: Text(
                'Don’t have an account? Register',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: medicLoginSwitch,
              child: Text(
                'login as a medic',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
