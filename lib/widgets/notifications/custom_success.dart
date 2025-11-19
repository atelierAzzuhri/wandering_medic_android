import 'package:flutter/material.dart';

class CustomSuccessBox extends StatelessWidget {
  final String details;
  final VoidCallback? onProceed;

  const CustomSuccessBox({
    super.key,
    required this.details,
    this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1F22),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.check_circle, color: Color(0xFF57CC99)),
                  SizedBox(width: 8),
                  Text(
                    'Success',
                    style: TextStyle(
                      color: Color(0xFF57CC99),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                details,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF1C1F22),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                      style: TextStyle(color: Color(0xFF57CC99)),
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