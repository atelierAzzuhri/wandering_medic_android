import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/widgets/notifications/custom_alert.dart';
import '../logger.dart';
import '../store/navbar_store.dart';
import '../store/session_store.dart';

class CustomNavigationBar extends ConsumerWidget {
  const CustomNavigationBar({super.key});

  void _handleTap(
    BuildContext context,
    WidgetRef ref,
    int index,
    dynamic session,
  ) {
    ref.read(navbarIndexProvider.notifier).setIndex(index);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        logger.i('Session check: ${session?.toJson()}');
        if (session != null) {
          Navigator.pushNamed(context, '/chat');
        } else {
          showDialog(
            context: context,
            builder: (context) =>
                CustomAlert(alertText: 'Alert', details: 'no ongoing session'),
          );
        }
        break;
      case 2:
        Navigator.pushNamed(context, '/account');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navbarIndexProvider);
    final session = ref.watch(sessionProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1C1F22),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavigationItem(
            icon: Icons.home,
            label: 'Homie',
            isSelected: selectedIndex == 0,
            onTap: () => _handleTap(context, ref, 0, session),
          ),
          _NavigationItem(
            icon: Icons.chat,
            label: 'Chat',
            isSelected: selectedIndex == 1,
            onTap: () => _handleTap(context, ref, 1, session),
          ),
          _NavigationItem(
            icon: Icons.person,
            label: 'Account',
            isSelected: selectedIndex == 2,
            onTap: () => _handleTap(context, ref, 2, session),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Theme.of(context).primaryIconTheme.color
        : Theme.of(context).iconTheme.color;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
