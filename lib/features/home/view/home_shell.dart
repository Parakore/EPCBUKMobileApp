import 'package:epcbuk_mobile_app/core/widgets/app_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/providers.dart';
import '../../../routes/app_router.dart';

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
    final notificationState = ref.watch(notificationViewModelProvider);

    // Determine the title based on the current route
    String title = 'UTCMS';
    if (location.contains(AppRoutes.dashboard.split('/').last))
      title = 'Executive Dashboard';
    else if (location.contains(AppRoutes.myApplications.split('/').last))
      title = 'Application Management';
    else if (location.contains(AppRoutes.commandCenter.split('/').last))
      title = 'Command Center';
    else if (location.contains(AppRoutes.newApplication.split('/').last))
      title = 'New Application';
    else if (location.contains(AppRoutes.workflow.split('/').last))
      title = 'Workflow Management';
    else if (location.contains(AppRoutes.compensationCalc.split('/').last))
      title = 'Tree Valuation Engine';
    else if (location.contains(AppRoutes.paymentStatus.split('/').last))
      title = 'Payment & Treasury';
    else if (location.contains(AppRoutes.audit.split('/').last))
      title = 'Audit Trail';
    else if (location.contains(AppRoutes.verificationQueue.split('/').last))
      title = 'Valuation Approval Queue';
    else if (location.contains(AppRoutes.documents.split('/').last))
      title = 'Docs Management System';
    else if (location.contains(AppRoutes.compliance.split('/').last))
      title = 'Compliance Monitoring';
    else if (location.contains(AppRoutes.grievance.split('/').last))
      title = 'Grievance Portal';
    else if (location.contains(AppRoutes.gisMap.split('/').last))
      title = 'GIS Exploration';
    else if (location.contains(AppRoutes.reports.split('/').last))
      title = 'Reports & Analytics';
    else if (location.contains(AppRoutes.aiInsights.split('/').last))
      title = 'AI Insights';
    else if (location.contains(AppRoutes.profile.split('/').last))
      title = 'My Profile';
    else if (location.contains(AppRoutes.userMgmt.split('/').last))
      title = 'User Management';
    else if (location.contains(AppRoutes.notifications.split('/').last))
      title = 'Notifications';
    else if (location.contains(AppRoutes.settings.split('/').last)) title = 'System Settings';

    return Scaffold(
        drawer: AppDrawer(currentRoute: location),
        appBar: AppAppBar(
          title: title,
          actions: [
            IconButton(
              icon: const Badge(
                label: Text('7'),
                child: Icon(Icons.notifications_outlined),
              ),
              onPressed: () => context.go(AppRoutes.notifications),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () => context.go(AppRoutes.profile),
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
                    onPressed: () => context.go(AppRoutes.geoTagging),
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
                        onPressed: () => context.push(AppRoutes.newApplication),
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
