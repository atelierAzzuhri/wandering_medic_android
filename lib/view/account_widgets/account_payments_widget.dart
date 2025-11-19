import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medics_patient/logger.dart';

class AccountPaymentsWidget extends ConsumerStatefulWidget {
  const AccountPaymentsWidget({super.key});

  @override
  ConsumerState<AccountPaymentsWidget> createState() =>
      _AccountPaymentsWidgetState();
}

class _AccountPaymentsWidgetState extends ConsumerState<AccountPaymentsWidget> {
  void _showSheet(BuildContext context) {
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
              'Payment Methods',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No payment method available',
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
                  _showSheet(context);
                },
                child: Text(
                  'Add Method',
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

class AddPayment extends ConsumerStatefulWidget {
  const AddPayment({super.key});

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends ConsumerState<AddPayment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  int activeIndex = 0;
  int? activeBrand;

  final brands = [
    {'label': 'Gopay', 'icon': Icons.account_balance_wallet_rounded},
    {'label': 'ShopeePay', 'icon': Icons.account_balance_wallet_rounded},
    {'label': 'OVO', 'icon': Icons.account_balance_wallet_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Text(
              'Register Payment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'register a new payment option for your account',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            // TYPE
            Text('payment type', style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 4),
            Row(
              children: [
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: const Color(0xFF272C30),
                    end: activeIndex == 0
                        ? const Color(0xFFD7ED72)
                        : const Color(0xFF272C30),
                  ),
                  duration: Duration(milliseconds: 500),
                  builder: (context, bgColor, child) {
                    return FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          activeIndex = 0;
                        });
                      },
                      backgroundColor: bgColor,
                      label: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: Colors.white,
                          end: activeIndex == 0 ? Colors.black : Colors.white,
                        ),
                        duration: Duration(milliseconds: 500),
                        builder: (context, labelColor, child) {
                          return Text(
                            'e-wallet',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: labelColor),
                          );
                        },
                      ),
                      icon: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: Colors.white,
                          end: activeIndex == 0 ? Colors.black : Colors.white,
                        ),
                        duration: Duration(milliseconds: 500),
                        builder: (context, iconColor, child) {
                          return Icon(Icons.wallet_rounded, color: iconColor);
                        },
                      ),
                    );
                  },
                ),
                SizedBox(width: 8),
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: const Color(0xFF272C30),
                    end: activeIndex == 1
                        ? const Color(0xFFD7ED72)
                        : const Color(0xFF272C30),
                  ),
                  duration: Duration(milliseconds: 500),
                  builder: (context, bgColor, child) {
                    return FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          activeIndex = 1;
                        });
                      },
                      backgroundColor: bgColor,
                      label: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: Colors.white,
                          end: activeIndex == 1 ? Colors.black : Colors.white,
                        ),
                        duration: Duration(milliseconds: 500),
                        builder: (context, labelColor, child) {
                          return Text(
                            'cards',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: labelColor),
                          );
                        },
                      ),
                      icon: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: Colors.white,
                          end: activeIndex == 1 ? Colors.black : Colors.white,
                        ),
                        duration: Duration(milliseconds: 500),
                        builder: (context, iconColor, child) {
                          return Icon(
                            Icons.credit_card_rounded,
                            color: iconColor,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            // ISSUER
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  // Add padding so the text isn't against the edge
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Grey background
                    borderRadius: BorderRadius.circular(20), // "Fully rounded"
                  ),
                  child: const Text(
                    'select',
                    style: TextStyle(
                      color: Colors.black87, // Text color for contrast
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8), // As requested
                const Text('e-wallet issuer'),
              ],
            ),
            const SizedBox(height: 8),
            ...brands.asMap().entries.map((entry) {
              final index = entry.key;
              final brand = entry.value;
              final isActive = activeBrand == index;

              return TweenAnimationBuilder<Color?>(
                tween: ColorTween(
                  begin: Colors.transparent,
                  end: isActive ? const Color(0xFF1C1F22) : Colors.transparent,
                ),
                duration: Duration(milliseconds: 300),
                builder: (context, bgColor, child) {
                  return GestureDetector(
                    onTap: () => setState(() => activeBrand = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFFD7ED72)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF272C30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              brand['icon'] as IconData,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              brand['label'] as String,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0,
                              end: isActive ? 1 : 0,
                            ),
                            duration: Duration(milliseconds: 300),
                            builder: (context, opacity, child) {
                              return Opacity(
                                opacity: opacity,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1F22),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Selected',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: const Color(0xFFD7ED72),
                                        ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
            // PHONE NUMBER
            const SizedBox(height: 24),
            Text(
              'Phone Number',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                hintStyle: TextStyle(color: Colors.white54),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD7ED72),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Handle valid submission
                    logger.i('Phone number: ${phoneController.text}');
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
