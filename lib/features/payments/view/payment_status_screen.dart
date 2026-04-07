import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';

class PaymentStatusScreen extends StatelessWidget {
  const PaymentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payments = [
      {
        'id': 'CHL-98441',
        'type': 'Timber Comp',
        'amount': '₹ 52,480',
        'status': 'Paid',
        'date': '02 Apr 2025',
        'badge': BadgeType.success
      },
      {
        'id': 'CHL-98442',
        'type': 'Env & NPV',
        'amount': '₹ 36,500',
        'status': 'Pending',
        'date': 'Pending',
        'badge': BadgeType.warning
      },
      {
        'id': 'CHL-98321',
        'type': 'Afforestation',
        'amount': '₹ 15,744',
        'status': 'Processing',
        'date': '04 Apr 2025',
        'badge': BadgeType.info
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment & Challan Status'),
      ),
      body: Column(
        children: [
          // Summary Header
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.greenDark,
              image: const DecorationImage(
                image: NetworkImage(
                    'https://www.transparenttextures.com/patterns/leaf.png'),
                opacity: 0.1,
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: Column(
              children: [
                const Text('Total Settled Amount',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                const Text('₹ 1,52,480',
                    style: TextStyle(
                        color: AppTheme.goldLight,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rajdhani')),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MiniStat(label: 'Net Pending', value: '₹ 36,500'),
                    const SizedBox(width: 24),
                    _MiniStat(label: 'Challans', value: '03 Generated'),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final p = payments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: (p['badge'] as BadgeType) ==
                                        BadgeType.success
                                    ? AppTheme.greenLight.withValues(alpha: 0.1)
                                    : AppTheme.saffron.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                (p['badge'] as BadgeType) == BadgeType.success
                                    ? Icons.check_circle_outline
                                    : Icons.receipt_long_outlined,
                                color: (p['badge'] as BadgeType) ==
                                        BadgeType.success
                                    ? AppTheme.greenMid
                                    : AppTheme.saffron,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p['id'] as String,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                Text(p['type'] as String,
                                    style: TextStyle(
                                        color: AppTheme.textLight,
                                        fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(p['amount'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.greenDark)),
                            const SizedBox(height: 4),
                            AppBadge(
                                label: p['status'] as String,
                                type: p['badge'] as BadgeType),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 10)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
