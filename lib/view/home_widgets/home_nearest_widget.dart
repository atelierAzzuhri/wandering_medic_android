import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/controller/chat_controller.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/mocks/chat_mocks.dart';

import '../../viewmodel/chat_view_model.dart';
import '../chat_view.dart';
import '../../store/session_store.dart';

class Consultant {
  final String id;
  final String username;
  final String email;
  final String hospital;
  final String avatarUrl;

  Consultant({
    required this.id,
    required this.username,
    required this.email,
    required this.hospital,
    required this.avatarUrl,
  });
}

// Simulated store data
final fakeConsultantsProvider = Provider<List<Consultant>>((ref) {
  return [
    Consultant(
      id: 'c1',
      username: 'Dr. Aisha Rahman',
      email: 'aisha@medicare.com',
      hospital: 'Medicare Hospital',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
    ),
    Consultant(
      id: 'c2',
      username: 'Dr. Budi Santoso',
      email: 'budi@healthplus.id',
      hospital: 'HealthPlus Clinic',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
    ),
    Consultant(
      id: 'c3',
      username: 'Dr. Clara Wijaya',
      email: 'clara@rumahsakit.com',
      hospital: 'Rumah Sakit Sehat',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
  ];
});

class HomeNearestWidget extends ConsumerStatefulWidget {
  const HomeNearestWidget({super.key});

  @override
  ConsumerState<HomeNearestWidget> createState() => _HomeNearestWidgetState();
}

class _HomeNearestWidgetState extends ConsumerState<HomeNearestWidget> {
  void _showConsultantDetails(
    BuildContext context,
    Consultant consultant,
    WidgetRef ref,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF212529),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  consultant.username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  consultant.email,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              Center(
                child: Text(
                  'Hospital: ${consultant.hospital}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD7ED72),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  logger.i('start consultation button is pressed');
                  final chatViewModel = ref.read(chatViewModelProvider.notifier);
                  chatViewModel.startConsultation(
                    context: context,
                    medicId: consultant.id
                  );
                },
                child: const Text(
                  'Start Consultation',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final consultants = ref.watch(fakeConsultantsProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Nearest from your location',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: consultants.length,
            itemBuilder: (context, index) {
              final consultant = consultants[index];
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF272C30), // 👈 Custom background color
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // 👈 Soft shadow
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      consultant.username,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      consultant.hospital,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () => _showConsultantDetails(context, consultant, ref),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
