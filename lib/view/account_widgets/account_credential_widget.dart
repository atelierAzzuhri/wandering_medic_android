import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/store/account_store.dart';
import '../../logger.dart';

class CredentialWidget extends ConsumerStatefulWidget {
  const CredentialWidget({super.key});

  @override
  ConsumerState<CredentialWidget> createState() => _CredentialWidgetState();
}

class _CredentialWidgetState extends ConsumerState<CredentialWidget> {

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF212529),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return IntrinsicHeight(child: EditCredentialWidget());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);

    return Container(
      margin: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showSheet(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow('Username', account!.username),
            _infoRow('Email', account.email),
            _infoRow('Phone', account.phone),
            _infoRow('Password', account.password),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class EditCredentialWidget extends ConsumerStatefulWidget {
  const EditCredentialWidget({super.key});

  @override
  ConsumerState<EditCredentialWidget> createState() => _EditAccountFormState();
}

class _EditAccountFormState extends ConsumerState<EditCredentialWidget> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _email;
  late String _phone;

  @override
  void initState() {
    super.initState();
    final account = ref.read(accountProvider);
    if (account != null) {
      _username = account.username;
      _email = account.email;
      _phone = account.phone;
    }
  }

  void updateCredential() {
    logger.i('updating account');
    // Add your update logic here
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color(0xFFD7ED72);
    final backgroundColor = const Color(0xFF212529);
    final buttonTextStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black);
    final fieldTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: borderColor);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF212529),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Text(
            'Update Account',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'update your account with this form below',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 32),
          // FORM
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Username',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                TextFormField(
                  initialValue: _username,
                  style: fieldTextStyle,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                  onChanged: (value) => _username = value,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                Text(
                  'Email',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                TextFormField(
                  initialValue: _email,
                  style: fieldTextStyle,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                  onChanged: (value) => _email = value,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                Text(
                  'Phone',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                TextFormField(
                  initialValue: _phone,
                  style: fieldTextStyle,
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                  onChanged: (value) => _phone = value,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          // BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: borderColor,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updateCredential();
                  Navigator.pop(context);
                }
              },
              child: Text('Save Changes', style: buttonTextStyle),
            ),
          ),
        ],
      ),
    );
  }
}
