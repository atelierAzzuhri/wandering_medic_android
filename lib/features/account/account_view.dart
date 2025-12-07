import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/features/account/models/account_model.dart';
import 'package:medics_patient/features/account/providers/account_provider.dart';
import 'package:medics_patient/view/account_widgets/credential_widgets/edit_password_widget.dart';
import 'package:medics_patient/widgets/notifications/custom_danger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> {
  bool isExpanded = false;
  int selectedIndex = 2;

  Future handleUpdateUserInformation() async {}

  Widget _userInformation(account, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1C1F22),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _infoRow('Username', account.username),
                  const SizedBox(height: 16),
                  _infoRow('Email', account.email),
                  const SizedBox(height: 16),
                  _infoRow('Phone', account.phone),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Color(0xFF57CC99),
                ),
                onPressed: () {
                  // showEditAccountSheet();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _payment(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F22),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Methods',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No payment method available',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF212529),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // _showSheet(context);
                Navigator.pushNamed(context, '/payment');
              },
              child: Text(
                'Add Method',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF57CC99),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _address(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F22),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location Settings',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'no location available',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF212529),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/address');
              },
              child: Text(
                'Add Location',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF57CC99),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(
      // Align children (Label and Value) to the start (left)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label styling: size 12 and bold (w600), now white
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        // Vertical distance between label and value: 6
        const SizedBox(height: 6),
        // Value styling: size 10 and normal font weight, now white
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buttonGroup() {
    // Define the custom colors
    const Color yellowColor = Color(0xFFFEE440);
    const Color redColor = Color(0xFFFB5959);

    // Define the common text style
    const TextStyle buttonTextStyleYellow = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: yellowColor,
    );

    const TextStyle buttonTextStyleRed = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: redColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ❌ Divider is deleted as requested
        // const SizedBox(height: 6), // Keeping a slight vertical space if desired

        // 🟡 Reset Password Button (Yellow: FEE440)
        TextButton.icon(
          icon: const Icon(Icons.lock, color: yellowColor),
          label: const Text('Reset Password', style: buttonTextStyleYellow),
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

        // 🔴 Logout Button (Red: FB5959)
        TextButton.icon(
          icon: const Icon(Icons.logout, color: redColor),
          label: const Text('Logout', style: buttonTextStyleRed),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CustomDanger(
                details: 'Are you sure you want to logout?',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    final AccountModel? accountModel = account.value;

    const SizedBox verticalSpacer = SizedBox(height: 16);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userInformation(accountModel!, context),
            verticalSpacer, // <-- Added 16px space
            _payment(context),
            verticalSpacer, // <-- Added 16px space
            _address(context),
            verticalSpacer, // <-- Added 16px space
            _buttonGroup(),
          ],
        ),
      ),
    );
  }
}
