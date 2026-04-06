import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../providers/providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardViewModelProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: 'Executive Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(dashboardViewModelProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
          ),
        ],
      ),
      body: dashboardState.when(
        data: (metrics) => RefreshIndicator(
          onRefresh: () =>
              ref.read(dashboardViewModelProvider.notifier).refresh(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(context, ref),
                const SizedBox(height: 24),
                _buildMetricsGrid(context, metrics),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Recent Activity'),
                const SizedBox(height: 16),
                _buildActivityList(context),
              ],
            ),
          ),
        ),
        loading: () => const AppLoader(message: 'Loading metrics...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () =>
              ref.read(dashboardViewModelProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider).user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          user?.name ?? 'Distinguished User',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(BuildContext context, metrics) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildMetricCard(
          context,
          'Applications',
          metrics.totalApplications.toString(),
          Icons.description_outlined,
          Colors.blue,
        ),
        _buildMetricCard(
          context,
          'Trees Count',
          metrics.treesPlanted.toString(),
          Icons.park_outlined,
          Colors.green,
        ),
        _buildMetricCard(
          context,
          'Compensation',
          '₹${metrics.compensationPaid.toStringAsFixed(0)}',
          Icons.payments_outlined,
          Colors.orange,
        ),
        _buildMetricCard(
          context,
          'Pending',
          metrics.pendingApprovals.toString(),
          Icons.pending_actions_outlined,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    return Column(
      children: List.generate(3, (index) {
        return AppCard(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.add, color: Colors.white),
            ),
            title: Text('New application received #APP-${1000 + index}'),
            subtitle: Text('2 hours ago • Dehradun Division'),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      }),
    );
  }
}
