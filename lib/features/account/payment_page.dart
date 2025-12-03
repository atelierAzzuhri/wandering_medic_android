import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/features/account/widgets/add_payment.dart';
import 'package:medics_patient/features/account/widgets/payment.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  // Specs Colors
  static const Color _greenColor = Color(0xFFD7ED72);
  static const Color _darkBg = Color(0xFF1C1F22);
  static const Color _dividerColor = Color(0xFF272C30);

  void _addPayment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF212529),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return IntrinsicHeight(child: AddPayment());
      },
    );
  }

  // Fake Data Generator
  final List<Map<String, String>> fakePayments = [
    {
      "id": "cjld2cjxh0000qzrmn831i7rn", // CUID format example
      "name": "Mobile Money",
      "details": "+233 54 123 4567",
      "status": "Default",
    },
    {
      "id": "cjld2cjxh0001qzrm1945i7rn",
      "name": "Visa Card",
      "details": "**** **** **** 4242",
      "status": "Active",
    },
    {
      "id": "cjld2cjxh0002qzrm2856i7rn",
      "name": "Vodafone Cash",
      "details": "+233 20 987 6543",
      "status": "Verified",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212529), // Main background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: _darkBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: _greenColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Moved padding here
          child: Column(
            children: [
              // 1. Add Payment Button (Fixed at top)
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _greenColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0, // Set to 0 because Container has shadow
                    ),
                    onPressed: () {
                      // Handle Add Payment
                      _addPayment();
                    },
                    child: const Text(
                      'Add New Payment',
                      style: TextStyle(
                        color: _darkBg,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. Centered Divider (Fixed)
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: const Divider(thickness: 2, color: _dividerColor),
                ),
              ),

              const SizedBox(height: 24),

              // 3. Render Fake Data (Takes remaining space and scrolls)
              Expanded(
                child: ListView(
                  // Removed SingleChildScrollView + Column combo for cleaner ListView
                  children: fakePayments.map((payment) {
                    return PaymentWidget(
                      methodName: payment['name']!,
                      details: payment['details']!,
                      status: payment['status']!,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
