import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPaymentDialog extends ConsumerStatefulWidget {
  const AddPaymentDialog({super.key});

  @override
  ConsumerState<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends ConsumerState<AddPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  String? _selectedWallet;

  final BorderRadius _dialogRadius = BorderRadius.circular(16);
  final OutlineInputBorder _roundedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.grey),
  );

  final List<String> _walletOptions = ['OVO', 'GOPAY', 'SHOPEEPAY'];

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: _dialogRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add E-Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedWallet,
                items: _walletOptions.map((wallet) {
                  return DropdownMenuItem(
                    value: wallet,
                    child: Text(wallet),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Wallet',
                  border: _roundedBorder,
                  enabledBorder: _roundedBorder,
                  focusedBorder: _roundedBorder,
                ),
                validator: (value) => value == null ? 'Please select a wallet' : null,
                onChanged: (value) => setState(() => _selectedWallet = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  border: _roundedBorder,
                  enabledBorder: _roundedBorder,
                  focusedBorder: _roundedBorder,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter account number' : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final walletType = _selectedWallet!;
                        final accountNumber = _accountNumberController.text;
                        debugPrint('Registered: $walletType - $accountNumber');
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Register'),
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