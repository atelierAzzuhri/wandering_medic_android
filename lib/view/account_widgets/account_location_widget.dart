import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountLocationsWidget extends ConsumerStatefulWidget {
  const AccountLocationsWidget({super.key});

  @override
  ConsumerState<AccountLocationsWidget> createState() =>
      _AccountLocationsWidgetState();
}

class _AccountLocationsWidgetState
    extends ConsumerState<AccountLocationsWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
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
                  // TODO: Add method logic
                  Navigator.pushNamed(context, '/map');
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
      ),
    );
  }
}

Future AddPayment(context) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // HEADER
            Row(
              children: [
                // TITLE
                Text(
                  'Register Payment',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // SUBTITLE
                Text(
                  'register a new payment option for your account',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            // PAYMENT TYPE SELECTOR
            // TITLE
            Text(
              'select your payment type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // SELECTOR
            Row(children: [

            ]),
          ],
        ),
      );
    },
  );
}
