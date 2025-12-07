import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/features/account/models/account_model.dart';
import 'package:medics_patient/features/account/providers/account_provider.dart';
import 'package:medics_patient/features/auth/auth_model.dart';
import 'package:medics_patient/features/auth/auth_provider.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/store/transaction_store.dart';
import 'package:medics_patient/view/home_widgets/home_finder_widget.dart';
import 'package:medics_patient/view/home_widgets/home_nearest_widget.dart';
import 'package:medics_patient/store/location_store.dart';
import 'package:medics_patient/widgets/costom_navigation_bar.dart';
import 'package:medics_patient/widgets/custom_notification.dart';

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

  @override
  void initState() {
    super.initState();
  }

  handleConsultationAccess() {
    final defaultPaymentId = ref.watch(defaultPaymentProvider);
    final location = ref.watch(locationProvider);

    final hasPayment = defaultPaymentId != null;
    final hasLocation = location?.id != null;

    if (!hasPayment || !hasLocation) {
      showDialog(
        context: context,
        builder: (context) =>
            CustomNotification(
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

  Widget _homeHeaderWidget(account, BuildContext context) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.username,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                        Text(
                          account.email,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                      ],
                    )
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  // 👈 Controls spacing around the icon
                  decoration: const BoxDecoration(
                    color: Colors.white, // 👈 Background color
                    shape: BoxShape.circle, // 👈 Makes it fully rounded
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.black, // 👈 Optional: icon color for contrast
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7, // 👈 Half width
              child: Text(
                'How are you feeling today?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold, // 👈 Make it bold
                ),
                maxLines: 2,
                // 👈 Allow up to 2 lines
                overflow: TextOverflow.visible,
                // 👈 Optional: show full text if wrapping
                softWrap: true, // 👈 Ensure wrapping is enabled
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _homeRecentWidget(transactions) {
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
  // Widget _services() {}
  // Widget _homeNearestWidget() {}
  // Widget _homeFinderWidget() {}
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthModel?>>(authProvider, (previous, next) {
      next.when(
        data: (authModel) {
          logger.i('Auth State: DATA (Ready)');

          if (authModel != null) {
            logger.i('Token detected: ${authModel.token}');
            logger.i('Triggering Account Fetch...');
            ref.read(accountProvider.notifier).getAccount(authModel.token);
          } else {
            logger.w(
              'Auth Data is null (User is not logged in / Token missing)',
            );
          }
        },
        error: (error, stackTrace) {
          logger.e('Auth State: ERROR', error: error, stackTrace: stackTrace);
        },
        loading: () {
          logger.i('Auth State: LOADING (Waiting for storage...)');
        },
      );
    });

    final account = ref.watch(accountProvider);
    final transactions = ref.watch(transactionsProvider).take(3).toList();

    final AccountModel? accountModel = account.value;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            _homeHeaderWidget(accountModel!, context),
            // RECENT
            _homeRecentWidget(transactions),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
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
                      _ServiceIcon(
                        icon: Icons.local_hospital,
                        label: 'Nursing',
                      ),
                      _ServiceIcon(
                        icon: Icons.accessibility_new,
                        label: 'Disability',
                      ),
                      _ServiceIcon(
                        icon: Icons.home_repair_service,
                        label: 'Therapy',
                      ),
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
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium,
        ),
      ],
    );
  }
}
