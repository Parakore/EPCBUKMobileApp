import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_card.dart';
import '../../../providers/providers.dart';
import '../model/verification_model.dart';

class VerificationQueueScreen extends ConsumerWidget {
  const VerificationQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(verificationViewModelProvider);

    return Scaffold(
      body: queueState.when(
        data: (items) => _buildQueue(context, ref, items),
        loading: () => const AppLoader(message: 'Loading pending cases...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () =>
              ref.read(verificationViewModelProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildQueue(
      BuildContext context, WidgetRef ref, List<VerificationModel> items) {
    if (items.isEmpty) {
      return const Center(
          child: Text('All caught up! No pending applications.'));
    }

    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Application Approval Queue',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.greenDark.withValues(alpha: 0.8),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    ref.read(verificationViewModelProvider.notifier).refresh(),
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _VerificationCard(item: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _VerificationCard extends ConsumerWidget {
  final VerificationModel item;

  const _VerificationCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.id,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
              ),
              _statusBadge(item.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.applicantName,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(item.projectType,
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(item.location ?? 'Uttarakhand',
                  style: const TextStyle(fontSize: 12)),
              const Spacer(),
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${item.submittedAt.day}/${item.submittedAt.month}/${item.submittedAt.year}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleAction(context, ref, false),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleAction(context, ref, true),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(VerificationStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'PENDING',
        style: TextStyle(
            color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, bool approved) {
    ref
        .read(verificationViewModelProvider.notifier)
        .performVerification(item.id, approved);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Application ${item.id} ${approved ? 'approved' : 'rejected'}')),
    );
  }
}
