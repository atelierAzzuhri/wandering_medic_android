import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/store/account_store.dart';

import '../../store/credential_store.dart';

class HomeHeaderWidget extends ConsumerStatefulWidget {
  const HomeHeaderWidget({super.key});

  @override
  ConsumerState<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends ConsumerState<HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    final bool isReady = account != null;

    return Card(
      elevation: 4,
      color: const Color(0xFF1C1F22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16), // ✅ Inner padding
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  child: Icon(Icons.person, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: isReady
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.username,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        account.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8), // 👈 Controls spacing around the icon
                  decoration: const BoxDecoration(
                    color: Colors.white, // 👈 Background color
                    shape: BoxShape.circle, // 👈 Makes it fully rounded
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.black, // 👈 Optional: icon color for contrast
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7, // 👈 Half width
              child: Text(
                'How are you feeling today?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold, // 👈 Make it bold
                ),
                maxLines: 2, // 👈 Allow up to 2 lines
                overflow: TextOverflow.visible, // 👈 Optional: show full text if wrapping
                softWrap: true, // 👈 Ensure wrapping is enabled
              ),
            ),
          ),
        ],
      ),
    );
  }
}