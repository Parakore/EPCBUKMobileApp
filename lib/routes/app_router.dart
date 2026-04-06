import 'package:go_router/go_router.dart';
import '../features/auth/view/login_screen.dart';
import '../features/dashboard/view/dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
