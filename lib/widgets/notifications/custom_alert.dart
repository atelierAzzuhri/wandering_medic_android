import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final String alertText;
  final String details;
  final VoidCallback? onProceed;

  const CustomAlert({
    super.key,
    required this.alertText,
    required this.details,
    this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16), // Outer padding
      child: Center(
        child: Container(
          width: 320, // Fixed width
          padding: const EdgeInsets.all(16), // Inner padding
          decoration: BoxDecoration(
            color: const Color(0xFF1C1F22),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Left-align content
            children: [
              Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.yellow),
                  SizedBox(width: 8),
                  Text(
                    'Alert',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                details,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Right-align buttons
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onProceed != null) onProceed!();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF1C1F22),
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(color: Colors.yellow),
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
