import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../viewmodel/applications_viewmodel.dart';
import '../model/application_model.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationsViewModelProvider);
    final viewModel = ref.read(applicationsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.greenDark.withValues(alpha: 0.05),
            child: Column(
              children: [
                TextField(
                  onChanged: viewModel.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search by ID / Name',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.greenMid),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(label: 'All Districts', selected: true),
                      _FilterChip(label: 'Dehradun'),
                      _FilterChip(label: 'Haridwar'),
                      _FilterChip(label: 'Tehri'),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.greenMid,
        label: const Text('New Application'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (val) {},
        backgroundColor: Colors.white,
        selectedColor: AppTheme.greenMid.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: selected ? AppTheme.greenDark : AppTheme.textMid,
          fontSize: 12,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.greenMid,
                    fontSize: 16,
                  ),
                ),
                AppBadge(label: app.sla, type: app.slaClass),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(icon: Icons.person_outline, label: 'Applicant', value: app.applicant),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.location_on_outlined, label: 'District', value: app.district),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.park_outlined, label: 'Tree Count', value: '${app.treeCount} Trees'),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.payments_outlined, label: 'Compensation', value: app.compensation, isBold: true, valueColor: AppTheme.greenMid),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Stage', style: TextStyle(fontSize: 10, color: AppTheme.textLight)),
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
                  child: const Text('View Details', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textLight),
        const SizedBox(width: 8),
        Text('$label:', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}
