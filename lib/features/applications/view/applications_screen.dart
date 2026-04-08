import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/app_filter_chip.dart';
import '../../../core/widgets/app_detail_row.dart';
import '../viewmodel/applications_viewmodel.dart';
import '../model/application_model.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationsViewModelProvider);
    final viewModel = ref.read(applicationsViewModelProvider.notifier);

    return Column(
      children: [
        // Search & Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.greenDark.withValues(alpha: 0.05),
          child: Column(
            children: [
              AppSearchBar(
                hintText: 'Search by ID / Name',
                onChanged: viewModel.updateSearch,
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AppFilterChip(label: 'All Districts', selected: true, onSelected: (val) {}),
                    AppFilterChip(label: 'Dehradun', onSelected: (val) {}),
                    AppFilterChip(label: 'Haridwar', onSelected: (val) {}),
                    AppFilterChip(label: 'Tehri', onSelected: (val) {}),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Application List
        Expanded(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.error != null
                  ? Center(child: Text('Error: ${state.error}'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: viewModel.filteredApplications.length,
                      itemBuilder: (context, index) {
                        final app = viewModel.filteredApplications[index];
                        return _ApplicationCard(app: app);
                      },
                    ),
        ),
      ],
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final ApplicationModel app;

  const _ApplicationCard({required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  app.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.greenMid,
                    fontSize: 16,
                  ),
                ),
                AppBadge(label: app.sla, type: app.slaClass),
              ],
            ),
            const Divider(height: 24),
            AppDetailRow(
              icon: Icons.person_outline,
              label: 'Applicant',
              value: app.applicant,
            ),
            AppDetailRow(
              icon: Icons.location_on_outlined,
              label: 'District',
              value: app.district,
            ),
            AppDetailRow(
              icon: Icons.park_outlined,
              label: 'Tree Count',
              value: '${app.treeCount} Trees',
            ),
            AppDetailRow(
              icon: Icons.payments_outlined,
              label: 'Compensation',
              value: app.compensation,
              isBold: true,
              valueColor: AppTheme.greenMid,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Stage',
                        style: TextStyle(fontSize: 10, color: AppTheme.textLight)),
                    const SizedBox(height: 4),
                    AppBadge(label: app.stage, type: app.stageClass),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.greenMid,
                    minimumSize: const Size(100, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('View Details', style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
