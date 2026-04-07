import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../providers/providers.dart';
import '../model/valuation_result_model.dart';

class ValuationDetailScreen extends ConsumerWidget {
  final String applicationId;

  const ValuationDetailScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valuationState = ref.watch(valuationViewModelProvider(applicationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compensation Valuation'),
      ),
      body: valuationState.when(
        data: (result) => _buildContent(context, ref, result),
        loading: () => const AppLoader(message: 'Calculating compensation via Forest Dept. engine...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.read(valuationViewModelProvider(applicationId).notifier).recalculate(),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ValuationResultModel result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryHeader(result),
          const SizedBox(height: 32),
          const Text('Detailed Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _breakdownItem('Land Valuation', result.landValue, Icons.landscape),
          _breakdownItem('Tree Asset Value', result.treeValue, Icons.park),
          _breakdownItem('Structure Compensation', result.structureValue, Icons.home),
          _breakdownItem('Solatium (100% of above)', result.solatium, Icons.add_moderator),
          const Divider(height: 40),
          _breakdownItem('Total Compensation', result.totalCompensation, Icons.payments, isTotal: true),
          const SizedBox(height: 48),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(ValuationResultModel result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.forestGreen, AppTheme.primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'TOTAL COMPONENT',
            style: TextStyle(color: Colors.white70, letterSpacing: 1.2, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            '₹ ${result.totalCompensation.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 14),
                const SizedBox(width: 8),
                Text(
                  'Verified by Valuation Engine',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownItem(String label, double value, IconData icon, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isTotal ? AppTheme.primaryGreen.withValues(alpha: 0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isTotal ? AppTheme.primaryGreen : Colors.grey[600], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                fontSize: isTotal ? 16 : 14,
              ),
            ),
          ),
          Text(
            '₹ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? AppTheme.primaryGreen : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Generate Valuation Report (PDF)'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Back to Applications'),
          ),
        ),
      ],
    );
  }
}
