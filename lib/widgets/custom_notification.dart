import 'package:flutter/material.dart';

class CustomNotification extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;

  const CustomNotification({
    super.key,
    required this.title,
    required this.message,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) onConfirm!();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}