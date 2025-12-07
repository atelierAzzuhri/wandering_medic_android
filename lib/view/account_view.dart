import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/store/credential_store.dart';
import 'package:medics_patient/store/location_store.dart';
import 'package:medics_patient/view/account_widgets/account_location_widget.dart';
import 'package:medics_patient/view/account_widgets/account_payments_widget.dart';
import 'package:medics_patient/widgets/costom_navigation_bar.dart';
import 'package:medics_patient/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/notifications/custom_danger.dart';
import 'account_widgets/account_credential_widget.dart';
import 'account_widgets/credential_widgets/edit_password_widget.dart';

class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> {
  bool isExpanded = false;
  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(credentialProvider);
    final location = ref.watch(locationProvider);
    return Scaffold(
      appBar: CustomAppBar(title: 'Account'),
      body: SafeArea(
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CredentialWidget(),
                    AccountPaymentsWidget(),
                    AccountLocationsWidget(),
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width *
                          0.25, // 25% of screen width
                      child: const Divider(thickness: 1, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    _buildActions(),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
  Widget _buildActions() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.lock),
            label: const Text('Reset Password'),
            onPressed: () async {
              await showDialog<String>(
                context: context,
                builder: (context) => EditPasswordWidget(
                  currentPassword:
                      'your_current_password_here', // Inject from provider
                ),
              );
            },
          ),

          // 🔴 Logout Button (Red)
          TextButton.icon(
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Logout', style: TextStyle(color: Colors.red)),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => CustomDanger(
                  details:
                      'Are you sure you want to logout?',
                  onProceed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear(); // 🔥 Purge all stored data

                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/auth',
                        (route) => false, // ⛔ Remove all previous routes
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
