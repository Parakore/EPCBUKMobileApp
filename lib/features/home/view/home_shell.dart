import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/providers.dart';

class HomeShell extends ConsumerWidget {
  final Widget child;
  final String location;

  const HomeShell({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final notificationState = ref.watch(notificationViewModelProvider);

    final role = authState.role;

    // Determine the title based on the current route
    String title = 'UTCMS';
    if (location.contains('dashboard'))
      title = 'Executive Dashboard';
    else if (location.contains('my_applications'))
      title = 'Application Management';
    else if (location.contains('command_center'))
      title = 'Command Center';
    else if (location.contains('new_application'))
      title = 'New Application';
    else if (location.contains('workflow'))
      title = 'Workflow Management';
    else if (location.contains('compensation_calc'))
      title = 'Tree Valuation Engine';
    else if (location.contains('payment_status'))
      title = 'Payment & Treasury';
    else if (location.contains('audit'))
      title = 'Audit Trail';
    else if (location.contains('verification_queue'))
      title = 'Valuation Approval Queue';
    else if (location.contains('documents'))
      title = 'Docs Management System';
    else if (location.contains('compliance'))
      title = 'Compliance Monitoring';
    else if (location.contains('grievance'))
      title = 'Grievance Portal';
    else if (location.contains('gis_map'))
      title = 'GIS Exploration';
    else if (location.contains('reports'))
      title = 'Reports & Analytics';
    else if (location.contains('ai_insights'))
      title = 'AI Insights';
    else if (location.contains('profile'))
      title = 'My Profile';
    else if (location.contains('user_mgmt'))
      title = 'User Management';
    else if (location.contains('notifications'))
      title = 'Notifications';
    else if (location.contains('settings')) title = 'System Settings';

    return Scaffold(
        drawer: AppDrawer(currentRoute: location),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Badge(
                label: Text('7'),
                child: Icon(Icons.notifications_outlined),
              ),
              onPressed: () => context.go('/home/notifications'),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () => context.go('/home/profile'),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.forestGreen,
                  child: Icon(Icons.person, size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: child,
        floatingActionButton: location.contains('gis_map')
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                      onPressed: () =>
                          ref.read(gisMapViewModelProvider.notifier).refresh(),
                      label: const Text('Refresh'),
                      icon: const Icon(Icons.refresh)),
                  const SizedBox(height: 12),
                  FloatingActionButton.extended(
                    onPressed: () => context.go('/home/geo_tagging'),
                    label: const Text('Tag New Tree',
                        style: TextStyle(color: Colors.white)),
                    icon:
                        const Icon(Icons.add_location_alt, color: Colors.white),
                    backgroundColor: AppTheme.saffron,
                  ),
                ],
              )
            : location.contains('my_applications')
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () => {},
                        backgroundColor: AppTheme.greenLight,
                        label: const Text('Download PDF',
                            style: TextStyle(color: Colors.white)),
                        icon: const Icon(Icons.download, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton.extended(
                        onPressed: () => context.push('/home/new_application'),
                        backgroundColor: AppTheme.saffron,
                        label: const Text('New Application',
                            style: TextStyle(color: Colors.white)),
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  )
                : location.contains('documents')
                    ? FloatingActionButton.extended(
                        onPressed: () {},
                        backgroundColor: AppTheme.saffron,
                        foregroundColor: Colors.white,
                        icon: const Icon(Icons.cloud_upload_outlined),
                        label: const Text('Upload Document'),
                      )
                    : location.contains('grievance')
                        ? FloatingActionButton.extended(
                            onPressed: () {},
                            backgroundColor: AppTheme.saffron,
                            foregroundColor: Colors.white,
                            icon: const Icon(Icons.add_comment_outlined),
                            label: const Text('File New Grievance'),
                          )
                        : location.contains('user_mgmt')
                            ? FloatingActionButton.extended(
                                onPressed: () {},
                                label: const Text('Add User',
                                    style: TextStyle(color: Colors.white)),
                                icon: const Icon(Icons.person_add,
                                    color: Colors.white),
                                backgroundColor: AppTheme.saffron,
                              )
                            : location.contains('notifications')
                                ? notificationState.maybeWhen(
                                    data: (notifications) => notifications
                                            .any((n) => !n.isRead)
                                        ? FloatingActionButton.extended(
                                            onPressed: () => ref
                                                .read(
                                                    notificationViewModelProvider
                                                        .notifier)
                                                .markAllAsRead(),
                                            label: const Text(
                                                'Mark all as read',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            icon: const Icon(Icons.done_all,
                                                color: Colors.white),
                                            backgroundColor: AppTheme.saffron,
                                          ).animate().scale()
                                        : null,
                                    orElse: () => null,
                                  )
                                : null);
  }
}
