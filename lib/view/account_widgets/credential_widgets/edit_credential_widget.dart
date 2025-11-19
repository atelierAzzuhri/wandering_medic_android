import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/store/account_store.dart';
import '../../../store/credential_store.dart';

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
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: borderColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Personal Information',
                style: textStyle?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _username,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: textStyle,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => _username = value,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _email,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: textStyle,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => _email = value,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _phone,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: textStyle,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => _phone = value,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: textStyle),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: borderColor,
                        foregroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateCredential();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Save', style: textStyle?.copyWith(color: backgroundColor)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
