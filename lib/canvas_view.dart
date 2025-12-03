// The Widget that acts as the wrapper/container
import 'package:flutter/material.dart';
import 'package:medics_patient/features/account/account_view.dart';
import 'package:medics_patient/store/session_store.dart';
import 'package:medics_patient/view/chat_view.dart';
import 'package:medics_patient/view/home_view.dart';
import 'package:medics_patient/widgets/notifications/custom_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CanvasView extends ConsumerStatefulWidget {
  const CanvasView({super.key});

  @override
  ConsumerState<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends ConsumerState<CanvasView> {
  int _currentIndex = 0;

  final List<Widget> pages = const [
    HomeView(),    // Index 0
    ChatView(),
    AccountView(), // Index 2
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      final session = ref.read(sessionProvider);

      if (session == null) {
        showDialog(
          context: context,
          builder: (context) => const CustomAlert(
              alertText: 'Alert',
              details: 'no ongoing session'
          ),
        );
        return; // Stop here, don't change tabs
      }
    }

    // 2. If checks pass, update the view
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We use extendBody: true so the content flows behind the floating navbar
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _buildCustomNavbar(),
    );
  }

  Widget _buildCustomNavbar() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24), // Added bottom margin
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F22),
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
            label: 'Home',
            isSelected: _currentIndex == 0,
            onTap: () => _onItemTapped(0),
          ),
          _NavigationItem(
            icon: Icons.chat,
            label: 'Chat',
            isSelected: _currentIndex == 1,
            onTap: () => _onItemTapped(1),
          ),
          _NavigationItem(
            icon: Icons.person,
            label: 'Account',
            isSelected: _currentIndex == 2,
            onTap: () => _onItemTapped(2),
          ),
        ],
      ),
    );
  }
}

// Kept your _NavigationItem exactly as is, just stripped the 'ref' requirement
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
    // Ensure you have these colors defined in your Theme, or hardcode them if debugging
    final color = isSelected
        ? Theme.of(context).primaryIconTheme.color ?? Colors.white // Fallback
        : Theme.of(context).iconTheme.color ?? Colors.grey;       // Fallback

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