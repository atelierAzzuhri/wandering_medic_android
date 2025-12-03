import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../logger.dart';

// Renamed from AddLocationDetail to AddAddressDetail
class AddAddressDetail extends ConsumerStatefulWidget {
  const AddAddressDetail({super.key});

  @override
  // Creating the associated state class
  ConsumerState<AddAddressDetail> createState() => _AddAddressDetailState();
}

// Renamed from _AddLocationDetailState to _AddAddressDetailState
class _AddAddressDetailState extends ConsumerState<AddAddressDetail> {
  // State variables for the form
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController addressNameController = TextEditingController();

  // Clean up controllers when the widget is disposed
  @override
  void dispose() {
    addressController.dispose();
    addressNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    const double requiredHeight = 500;

    return SingleChildScrollView(
      // Padding to ensure content moves up when keyboard appears
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        // The sheet background color and shape were set in AddressPage,
        // so we only provide padding here.
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // Use minimum space required by children
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Text(
                'Address Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'complete address would assist us better in serving you',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 24),

              // ADDRESS NAME INPUT
              Text(
                'Address Name',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              _buildTextFormField(
                controller: addressNameController,
                hintText: 'Enter a name (e.g., Home, Office)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'address name is required';
                  }
                  return null;
                },
              ),

              // ADDRESS LINE INPUT
              const SizedBox(height: 24),
              Text(
                'Address Line',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              _buildTextFormField(
                controller: addressController,
                hintText: 'Enter your address line',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'address line is required';
                  }
                  return null;
                },
              ),

              // SUBMIT BUTTON
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD7ED72),
                    // Green
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Handle valid submission
                      logger.i(
                        'Address Saved: ${addressNameController.text}, ${addressController.text}',
                      );

                      // Close the bottom sheet after submission
                      Navigator.of(context).pop();

                      // TODO: Add logic to save data using Riverpod/Firestore
                    }
                  },
                  child: Text(
                    'SAVE ADDRESS',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    const Color greenColor = Color(0xFFD7ED72);

    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: greenColor,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        // Subtle background for field
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        // Define all borders for consistent look
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Default non-error border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.white24,
            width: 1,
          ), // Subtle border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: greenColor,
            width: 2,
          ), // Active focus border
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
