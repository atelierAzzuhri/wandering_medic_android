import 'package:flutter/material.dart';
import '../../widgets/header_text.dart';

class HomeServicesWidget extends StatelessWidget {
  const HomeServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_ServiceMenuItem> menuItems = [
      _ServiceMenuItem(icon: Icons.elderly, label: 'Elder Care'),
      _ServiceMenuItem(icon: Icons.healing, label: 'Post-Surgery'),
      _ServiceMenuItem(icon: Icons.child_care, label: 'Child Care'),
      _ServiceMenuItem(icon: Icons.local_hospital, label: 'Nursing'),
      _ServiceMenuItem(icon: Icons.accessibility_new, label: 'Disability Support'),
      _ServiceMenuItem(icon: Icons.home_repair_service, label: 'Home Therapy'),
    ];
    return Padding(
      padding: const EdgeInsets.all(16), // bottom padding added
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderText(text: 'Home Services'),
          const SizedBox(height: 8),
          SizedBox(
            height: 96,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.35),
              itemCount: menuItems.length,
              padEnds: false,
              itemBuilder: (context, index) {
                return _ServiceMenuCard(item: menuItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceMenuItem {
  final IconData icon;
  final String label;

  const _ServiceMenuItem({required this.icon, required this.label});
}

class _ServiceMenuCard extends StatelessWidget {
  final _ServiceMenuItem item;

  const _ServiceMenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.white,
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            // TODO: Handle navigation or filtering
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 96,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(8),
                  child: Icon(item.icon, size: 32, color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}