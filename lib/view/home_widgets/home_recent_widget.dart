import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/store/transaction_store.dart';

import '../../models/transaction_model.dart';

final recentAppointmentProvider = Provider<Map<String, String>>((ref) {
  return {
    'username': 'Dr. John Doe',
    'provider': 'General Hospital',
    'date': '2 March 2025',
    'avatarUrl': 'https://docs.flutter.dev/assets/images/exercise/split-check/Avatar1.jpg',
  };
});

class HomeRecentWidget extends ConsumerStatefulWidget {
  const HomeRecentWidget({super.key});

  @override
  ConsumerState<HomeRecentWidget> createState() => _HomeRecentWidgetState();
}

class _HomeRecentWidgetState extends ConsumerState<HomeRecentWidget> {
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider).take(3).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Recent appointment',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          transactions.isEmpty
              ? const NoRecentAppointmentCard()
              : PageView.builder(
            itemCount: transactions.length.clamp(0, 3),
            controller: PageController(viewportFraction: 0.85),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return RecentAppointmentCard(
                transaction: transaction,
                onPressed: () {
                  debugPrint('Appointment ${index + 1} clicked');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecentAppointmentCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onPressed;

  const RecentAppointmentCard({
    super.key,
    required this.transaction,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF272C30),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                        ),
                        Text(
                          transaction.id,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        transaction.patientId,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPressed,
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoRecentAppointmentCard extends StatelessWidget {
  const NoRecentAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF272C30),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'No recent appointments',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}