import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/viewmodel/auth_view_model.dart';
import 'package:medics_patient/models/auth_model.dart';

import 'auth_widgets/login_widget.dart';
import 'auth_widgets/register_widget.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  int viewState = 0;

  void switchToPatientLogin() => setState(() => viewState = 0);

  void switchToRegister() => setState(() => viewState = 1);

  void switchToMedicLogin() => setState(() => viewState = 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            switch (viewState) {
              case 0:
                return LoginWidget(
                  registerSwitch: switchToRegister,
                  medicLoginSwitch: switchToMedicLogin,
                );
              case 1:
                return RegisterWidget(onSwitch: switchToPatientLogin);
              case 2:
                return MedicLoginForm(patientLoginSwitch: switchToPatientLogin);
              default:
                return Center(child: Text('Unknown view state: $viewState'));
            }
          },
        ),
      ),
    );
  }
}

class MedicLoginForm extends StatefulWidget {
  const MedicLoginForm({super.key, required this.patientLoginSwitch});

  final VoidCallback patientLoginSwitch;

  @override
  State<MedicLoginForm> createState() => _MedicLoginFormState();
}

class _MedicLoginFormState extends State<MedicLoginForm> {
  VoidCallback get patientLoginSwitch => widget.patientLoginSwitch;

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

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: accountFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Login View', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 32),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: double.infinity,
                    child: Consumer(
                      builder: (context, ref, _) => ElevatedButton(
                        onPressed: () {
                          if (accountFormKey.currentState!.validate()) {
                            handleLogin(ref);
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: patientLoginSwitch,
                    child: const Text('login as patient'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
