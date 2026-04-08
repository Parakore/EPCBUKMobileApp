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
import '../features/notifications/view/notification_screen.dart';
import '../features/audit/view/audit_screen.dart';
import '../features/applications/view/new_application_screen.dart';
import '../features/compliance/view/compliance_view.dart';
import '../features/dms/view/dms_view.dart';
import '../features/grievance/view/grievance_view.dart';
import '../features/reports/view/reports_screen.dart';
import '../features/user_mgmt/view/user_mgmt_screen.dart';
import '../features/settings/view/settings_screen.dart';

class AppRoutes {
  static const String root = '/';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String dashboard = '/home/dashboard';
  static const String newApplication = '/home/new_application';
  static const String myApplications = '/home/my_applications';
  static const String paymentStatus = '/home/payment_status';
  static const String documents = '/home/documents';
  static const String grievance = '/home/grievance';
  static const String compliance = '/home/compliance';
  static const String notifications = '/home/notifications';
  static const String geoTagging = '/home/geo_tagging';
  static const String treeEnumeration = '/home/tree_enumeration';
  static const String gisMap = '/home/gis_map';
  static const String verificationQueue = '/home/verification_queue';
  static const String compensationCalc = '/home/compensation_calc';
  static const String aiInsights = '/home/ai_insights';
  static const String workflow = '/home/workflow';
  static const String commandCenter = '/home/command_center';
  static const String userMgmt = '/home/user_mgmt';
  static const String profile = '/home/profile';
  static const String settings = '/home/settings';
  static const String audit = '/home/audit';
  static const String reports = '/home/reports';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.root,
  routes: [
    GoRoute(
      path: AppRoutes.root,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
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
          path: AppRoutes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.newApplication,
          builder: (context, state) => const NewApplicationScreen(),
        ),
        GoRoute(
          path: AppRoutes.myApplications,
          builder: (context, state) => const ApplicationsScreen(),
        ),
        GoRoute(
          path: AppRoutes.paymentStatus,
          builder: (context, state) => const PaymentStatusScreen(),
        ),
        GoRoute(
          path: AppRoutes.documents,
          builder: (context, state) => const DMSView(),
        ),
        GoRoute(
          path: AppRoutes.grievance,
          builder: (context, state) => const GrievanceView(),
        ),
        GoRoute(
          path: AppRoutes.compliance,
          builder: (context, state) => const ComplianceView(),
        ),
        GoRoute(
          path: AppRoutes.notifications,
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: AppRoutes.geoTagging,
          builder: (context, state) => const GeoTaggingScreen(),
        ),
        GoRoute(
          path: AppRoutes.treeEnumeration,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Tree Enumeration Module'),
        ),
        GoRoute(
          path: AppRoutes.gisMap,
          builder: (context, state) => const GISMapScreen(),
        ),
        GoRoute(
          path: AppRoutes.verificationQueue,
          builder: (context, state) => const VerificationQueueScreen(),
        ),
        GoRoute(
          path: AppRoutes.compensationCalc,
          builder: (context, state) => const ValuationScreen(),
        ),
        GoRoute(
          path: AppRoutes.aiInsights,
          builder: (context, state) => const AIInsightsScreen(),
        ),
        GoRoute(
          path: AppRoutes.workflow,
          builder: (context, state) =>
              const WorkflowScreen(applicationId: 'TCA-2025-0862'),
        ),
        GoRoute(
          path: AppRoutes.commandCenter,
          builder: (context, state) => const CommandCenterScreen(),
        ),
        GoRoute(
          path: AppRoutes.userMgmt,
          builder: (context, state) => const UserMgmtScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'User Profile Settings'),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: AppRoutes.audit,
          builder: (context, state) => const AuditScreen(),
        ),
        GoRoute(
          path: AppRoutes.reports,
          builder: (context, state) => const ReportsScreen(),
        ),
      ],
    ),
  ],
);
