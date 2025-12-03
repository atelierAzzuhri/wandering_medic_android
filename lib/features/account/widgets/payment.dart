import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/notifications/custom_danger.dart';

class PaymentWidget extends ConsumerStatefulWidget {
  final String methodName;
  final String details;
  final String status;

  const PaymentWidget({
    super.key,
    required this.methodName,
    required this.details,
    this.status = "Active", // Default status if none provided
  });

  @override
  ConsumerState<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends ConsumerState<PaymentWidget> {
  static const Color _blackColor = Color(0xFF1C1F22);
  // static const Color _yellowColor = Color(0xFFFEE440); // Removed/Unused
  static const Color _dangerColor = Color(0xFFFB5959); // Danger Color (FB5959)
  static const Color _textColor = Color(0xFFF8F9FA);

  // Define the function to show the CustomDanger dialog/sheet
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        // The CustomDanger widget is centered by default,
        // but showDialog handles the proper background fade and central placement.
        return CustomDanger(
          details: 'Are you sure you want to remove ${widget.methodName}? This action cannot be undone.',
          onProceed: () {
            print('Deleting payment method: ${widget.methodName}');
            // Add your actual state update/API call here
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: _blackColor,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.methodName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.details,
                  style: TextStyle(
                    color: _textColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // --- MODIFIED BUTTON ---
            SizedBox(
              height: 32,
              child: OutlinedButton(
                onPressed: () {
                  // Call the function to display the confirmation widget
                  _showDeleteConfirmation(context);
                },
                style: OutlinedButton.styleFrom(
                  // Use the danger color for the border
                  side: const BorderSide(color: _dangerColor, width: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    // Use the Delete icon
                    Icon(
                      Icons.delete,
                      color: _dangerColor,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    // Change the text label to 'Delete'
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: _dangerColor, // Use the danger color for text
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ------------------------
          ],
        ),
      ),
    );
  }
}