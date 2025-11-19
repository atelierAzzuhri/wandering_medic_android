import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/view/home_widgets/home_finder_widget.dart';
import 'package:medics_patient/view/home_widgets/home_nearest_widget.dart';
import 'package:medics_patient/store/credential_store.dart';
import 'package:medics_patient/store/location_store.dart';
import 'package:medics_patient/view/home_widgets/home_services_widget.dart';
import 'package:medics_patient/viewmodel/account_view_model.dart';
import 'package:medics_patient/widgets/costom_navigation_bar.dart';
import 'package:medics_patient/widgets/custom_notification.dart';
import 'package:medics_patient/widgets/header_text.dart';

import '../store/default_payment_store.dart';
import 'home_widgets/home_header_widget.dart';
import 'home_widgets/home_recent_widget.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> providers = [
    {
      'name': 'Dr. Alman Dean',
      'rating': '4.3',
      'price': 'RS. 250',
      'distance': '2km, 5 minutes away',
    },
    {
      'name': 'Dr. Sarah Malik',
      'rating': '4.7',
      'price': 'RS. 300',
      'distance': '1.5km, 3 minutes away',
    },
    {
      'name': 'Dr. Sarah Malik',
      'rating': '4.7',
      'price': 'RS. 300',
      'distance': '1.5km, 3 minutes away',
    },
    {
      'name': 'Dr. Alman Dean',
      'rating': '4.3',
      'price': 'RS. 250',
      'distance': '2km, 5 minutes away',
    },
    {
      'name': 'Dr. Sarah Malik',
      'rating': '4.7',
      'price': 'RS. 300',
      'distance': '1.5km, 3 minutes away',
    },
  ];

  final String username = 'username123';
  final String email = 'email@gmail.com';

  handleConsultationAccess() {
    final defaultPaymentId = ref.watch(defaultPaymentProvider);
    final location = ref.watch(locationProvider);

    final hasPayment = defaultPaymentId != null;
    final hasLocation = location?.id != null;

    if (!hasPayment || !hasLocation) {
      showDialog(
        context: context,
        builder: (context) => CustomNotification(
          title: 'Missing Information',
          message: !hasPayment && !hasLocation
              ? 'Please add a payment method and location before proceeding.'
              : !hasPayment
              ? 'Please add a payment method before proceeding.'
              : 'Please add a location before proceeding.',
        ),
      );
      return;
    }

    // ✅ Both are present — navigate to consultation page
    Navigator.pushNamed(context, '/consultation');
  }

  @override
  Widget build(BuildContext context) {
    final credentials = ref.watch(credentialProvider);

    if (credentials == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              HomeHeaderWidget(),

              // RECENT
              HomeRecentWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12,),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1,
                      children: const [
                        _ServiceIcon(icon: Icons.elderly, label: 'Elder Care'),
                        _ServiceIcon(icon: Icons.healing, label: 'Post-Surgery'),
                        _ServiceIcon(icon: Icons.child_care, label: 'Child Care'),
                        _ServiceIcon(icon: Icons.local_hospital, label: 'Nursing'),
                        _ServiceIcon(icon: Icons.accessibility_new, label: 'Disability'),
                        _ServiceIcon(icon: Icons.home_repair_service, label: 'Therapy'),
                      ],
                    ),
                  ],
                ),
              ),
              HomeNearestWidget(),
              HomeFinderWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ServiceIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

// class NearbyProvidersCard extends StatelessWidget {
//   final String name;
//   final String rating;
//   final String price;
//   final String distance;
//   final String hospital;
//
//   const NearbyProvidersCard({
//     required this.name,
//     required this.rating,
//     required this.price,
//     required this.distance,
//     required this.hospital,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => _showMedicDetails(context),
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 2,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               const CircleAvatar(radius: 24, child: Icon(Icons.person)),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(name, style: Theme.of(context).textTheme.titleMedium),
//                     Text(
//                       'Rating: $rating',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                     Text(
//                       'Price: $price',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                     Text(
//                       'Distance: $distance',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showMedicDetails(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(8)), // Less rounded
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 👤 Profile Row
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CircleAvatar(radius: 32, child: Icon(Icons.person, size: 32)),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(name, style: Theme.of(context).textTheme.titleMedium),
//                         Text(hospital, style: Theme.of(context).textTheme.bodySmall),
//                         const SizedBox(height: 8),
//                         Text('Consultation Fee: $price', style: Theme.of(context).textTheme.bodyMedium),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               // 🟦 Button aligned to bottom right
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.chat),
//                     label: const Text('Start Consulting'),
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4), // Less rounded
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _showConfirmationDialog(context);
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Consultation'),
//         content: Text('Start consultation with $name?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // close dialog
//               // TODO: trigger session start logic here
//             },
//             child: const Text('Yes, Start'),
//           ),
//         ],
//       ),
//     );
//   }
// }
