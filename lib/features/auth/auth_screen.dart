import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/features/auth/auth_model.dart';
import 'package:medics_patient/features/auth/auth_provider.dart';
import 'package:medics_patient/shared/auth_title.dart';

import '../../shared/shared_snackbar.dart';

enum AuthPage { login, register }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  AuthPage currentPage = AuthPage.login;
  final _formKey = GlobalKey<FormState>();

// 📝 Registration Controllers (All of them)
  final _regEmailController = TextEditingController();
  final _regUsernameController = TextEditingController();
  final _regPhoneController = TextEditingController();
  final _regPasswordController = TextEditingController();

// 🔑 Login Controllers (Only email/username and password)
  final _logEmailController = TextEditingController();
  final _logPasswordController = TextEditingController();

  void _clearLoginControllers() {
    _logEmailController.clear();
    _logPasswordController.clear();
  }
  void _clearRegistrationControllers() {
    _regUsernameController.clear();
    _regEmailController.clear();
    _regPhoneController.clear();
    _regPasswordController.clear();
  }

  @override
  void dispose() {
// 🔑 Dispose Login Controllers
    _logEmailController.dispose();
    _logPasswordController.dispose();

    // 📝 Dispose Registration Controllers
    _regEmailController.dispose();
    _regUsernameController.dispose();
    _regPhoneController.dispose();
    _regPasswordController.dispose();

    super.dispose();
  }

  Future handleLogin() async {
    final request = LoginRequest(
      email: _logEmailController.text,
      password: _logPasswordController.text,
    );

    final response = await ref.read(authProvider.notifier).login(request);

    if(!mounted) {
      return;
    }

    if (response.status != 'success') {
      SharedSnackBar.failed(
        context,
        response.message,
      );
    }
    return;
  }
  Future handleRegister() async {

    final request = RegisterRequest(
      username: _regUsernameController.text,
      email: _regEmailController.text,
      phone: _regPhoneController.text,
      password: _regPasswordController.text,
    );

    final response = await ref.read(authProvider.notifier).register(request);

    if(!mounted) {
      return;
    }

    if (response.status != 'success') {
      SharedSnackBar.failed(
        context,
          "Account registration failed!"
      );
    } else {
      SharedSnackBar.success(
        context,
        "Account registration success",
      );
    }
  }

  Widget _buildCurrentPage() {
    switch (currentPage) {
      case AuthPage.login:
        return _loginForm();
      case AuthPage.register:
        return _registerForm();
    }
  }
  Widget _loginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthPageTitle('Login'),
        AuthPageTitle('Using Account'),
        // FORM
        Form(
          key: _formKey,
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
                    controller: _logEmailController,
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
                    controller: _logPasswordController,
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
                      child: ElevatedButton(
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
                          if (_formKey.currentState!.validate()) {
                            handleLogin();
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
                ],
              ),
            ),
          ),
        ),
        // REDIRECT
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton(
            onPressed: () {
              _clearLoginControllers();
              setState(() => currentPage = AuthPage.register);
            },
            child: Text(
              'Don’t have an account? Register',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
  Widget _registerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthPageTitle('Register'),
        AuthPageTitle('Your Account'),
        // FORM
        Form(
          key: _formKey,
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
                  Text(
                    'Username',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _regUsernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF212529),
                      // background color
                      hintText: 'Enter your username',
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
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  Text('Email', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _regEmailController,
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
                  Text('Phone', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _regPhoneController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF212529),
                      // background color
                      hintText: 'Enter your phone',
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
                        return 'Please enter your phone';
                      }
                      return null;
                    },
                  ),
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _regPasswordController,
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
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          handleRegister();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF212529),
                        // Dark background
                        foregroundColor: const Color(0xFF57CC99),
                        // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded corners
                        ),
                      ),
                      child: const Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // REDIRECT
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextButton(
            onPressed: () {
              _clearRegistrationControllers();
              setState(() => currentPage = AuthPage.login);
            },
            child: Text(
              'have an account? login',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _buildCurrentPage(),
          ),
        ),
      ),
    );
  }
}
