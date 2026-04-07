import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/models/user_role.dart';
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
    final role = authState.role;
    
    // Determine the title based on the current route
    String title = 'UTCMS';
    if (location.contains('dashboard')) title = 'Dashboard';
    else if (location.contains('my_applications')) title = 'Applications';
    else if (location.contains('new_application')) title = 'New Application';
    else if (location.contains('verification_queue')) title = 'Verification Queue';
    else if (location.contains('gis_map')) title = 'GIS Exploration';
    else if (location.contains('reports')) title = 'Reports & Analytics';
    else if (location.contains('ai_insights')) title = 'AI Insights';
    else if (location.contains('profile')) title = 'My Profile';
    else if (location.contains('settings')) title = 'Settings';

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
            if (role != null)
              Text(
                role.displayName,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.lightGreen.withAlpha(200),
                  fontWeight: FontWeight.w500,
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
    );
  }
}
