import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/glass_card.dart';
import '../viewmodel/user_viewmodel.dart';
import '../model/user_mgmt_model.dart';

class UserMgmtScreen extends ConsumerWidget {
  const UserMgmtScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userViewModelProvider);
    final viewModel = ref.read(userViewModelProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                Text(
                  'User Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.greenDark.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppTextField(
              labelText: 'Search Users',
              hintText: 'Search by name, role or district...',
              prefixIcon: const Icon(Icons.search),
              onChanged: viewModel.setSearchQuery,
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const AppLoader()
                : state.error != null
                    ? AppErrorWidget(
                        message: state.error!,
                        onRetry: () => viewModel.loadUsers(),
                      )
                    : state.filteredUsers.isEmpty
                        ? const Center(child: Text('No users found'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.filteredUsers.length,
                            itemBuilder: (context, index) {
                              final userMgmt = state.filteredUsers[index];
                              return _UserCard(userMgmt: userMgmt);
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserMgmtModel userMgmt;

  const _UserCard({required this.userMgmt});

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
                Expanded(
                  child: Text(
                    userMgmt.user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                AppBadge(
                  label: userMgmt.status,
                  type: userMgmt.status == 'Active'
                      ? BadgeType.success
                      : BadgeType.warning,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              userMgmt.user.email,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoTile(label: 'Role', value: userMgmt.user.role),
                _InfoTile(label: 'District', value: userMgmt.district),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Login: ${userMgmt.lastLogin}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text('Edit', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryGreen,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
