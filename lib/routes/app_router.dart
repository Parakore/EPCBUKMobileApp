import 'package:epcbuk_mobile_app/features/verification/view/verification_queue_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/view/splash_view.dart';
import '../features/auth/view/login_screen.dart';
import '../features/auth/view/otp_screen.dart';
import '../features/dashboard/view/dashboard_screen.dart';
import '../features/dashboard/view/command_center_screen.dart';
import '../features/home/view/home_shell.dart';
import '../core/widgets/placeholder_screen.dart';
import '../features/ai_insights/view/ai_insights_screen.dart';
import '../features/gis_mapping/view/gis_map_screen.dart';
import '../features/gis_mapping/view/geo_tagging_screen.dart';
import '../features/applications/view/applications_screen.dart';
import '../features/workflow/view/workflow_screen.dart';
import '../features/valuation/view/valuation_screen.dart';
import '../features/payments/view/payment_status_screen.dart';
import '../features/audit/view/audit_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OTPScreen(userId: 'User'),
    ),

    // ── Application Shell ──────────────────────────────────
    ShellRoute(
      builder: (context, state, child) {
        return HomeShell(
          location: state.uri.toString(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/home/new_application',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'New Application Entry'),
        ),
        GoRoute(
          path: '/home/my_applications',
          builder: (context, state) => const ApplicationsScreen(),
        ),
        GoRoute(
          path: '/home/payment_status',
          builder: (context, state) => const PaymentStatusScreen(),
        ),
        GoRoute(
          path: '/home/documents',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Document Management (DMS)'),
        ),
        GoRoute(
          path: '/home/grievance',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Grievance Redressal'),
        ),
        GoRoute(
          path: '/home/notifications',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Notifications Center'),
        ),
        GoRoute(
          path: '/home/geo_tagging',
          builder: (context, state) => const GeoTaggingScreen(),
        ),
        GoRoute(
          path: '/home/tree_enumeration',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Tree Enumeration Module'),
        ),
        GoRoute(
          path: '/home/gis_map',
          builder: (context, state) => const GISMapScreen(),
        ),
        GoRoute(
          path: '/home/verification_queue',
          builder: (context, state) => const VerificationQueueScreen(),
        ),
        GoRoute(
          path: '/home/compensation_calc',
          builder: (context, state) => const ValuationScreen(),
        ),
        GoRoute(
          path: '/home/ai_insights',
          builder: (context, state) => const AIInsightsScreen(),
        ),
        GoRoute(
          path: '/home/workflow',
          builder: (context, state) =>
              const WorkflowScreen(applicationId: 'TCA-2025-0862'),
        ),
        GoRoute(
          path: '/home/command_center',
          builder: (context, state) => const CommandCenterScreen(),
        ),
        GoRoute(
          path: '/home/user_mgmt',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'User & Role Management'),
        ),
        GoRoute(
          path: '/home/profile',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'User Profile Settings'),
        ),
        GoRoute(
          path: '/home/settings',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'System Configuration'),
        ),
        GoRoute(
          path: '/home/audit',
          builder: (context, state) => const AuditScreen(),
        ),
        GoRoute(
          path: '/home/reports',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Reports & Analytics Dashboard'),
        ),
      ],
    ),
  ],
);
