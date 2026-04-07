import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/nav_item.dart';
import '../models/user_role.dart';
import '../constants/role_menus.dart';
import '../theme/app_theme.dart';
import '../../providers/providers.dart';

class AppDrawer extends ConsumerWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final role = authState.role ?? UserRole.applicant;
    final menuItems = RoleMenus.menus[UserRole.admin]!;

    return Drawer(
      backgroundColor: const Color(0xFF0F2417),
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────
            _DrawerHeader(role: role, authState: authState),
            const Divider(color: Colors.white12, height: 1),

            // ── Navigation Items ─────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  if (item.isSection) {
                    return _SectionLabel(label: item.sectionTitle!);
                  }
                  return _NavTile(
                    item: item,
                    isActive: currentRoute == item.route,
                    onTap: () {
                      Navigator.of(context).pop(); // close drawer
                      if (item.route != null && item.route != currentRoute) {
                        context.go(item.route!);
                      }
                    },
                  );
                },
              ),
            ),

            const Divider(color: Colors.white12, height: 1),

            // ── Footer ────────────────────────────────────────
            _DrawerFooter(role: role),
          ],
        ),
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────
class _DrawerHeader extends StatelessWidget {
  final UserRole role;
  final dynamic authState;

  const _DrawerHeader({required this.role, required this.authState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo + Brand
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppTheme.lightGreen.withValues(alpha: 0.4)),
                ),
                child: const Icon(Icons.park,
                    color: AppTheme.lightGreen, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UTCMS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                  Text('v2.5.1',
                      style: TextStyle(
                        color: AppTheme.lightGreen.withValues(alpha: 0.6),
                        fontSize: 11,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined,
                    color: AppTheme.lightGreen, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        role.label,
                        style: TextStyle(
                          color: AppTheme.lightGreen.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: AppTheme.lightGreen.withValues(alpha: 0.5),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Nav Tile ─────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.forestGreen.withValues(alpha: 0.35)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isActive
                  ? Border.all(
                      color: AppTheme.lightGreen.withValues(alpha: 0.3))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isActive ? AppTheme.lightGreen : Colors.white54,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label ?? '',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white70,
                      fontSize: 13.5,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.isAlertBadge
                          ? Colors.red.shade700
                          : AppTheme.forestGreen.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Footer ───────────────────────────────────────────────
class _DrawerFooter extends ConsumerWidget {
  final UserRole role;
  const _DrawerFooter({required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _FooterAction(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/home/profile');
                },
              ),
              const SizedBox(width: 8),
              _FooterAction(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/home/settings');
                },
              ),
              const SizedBox(width: 8),
              _FooterAction(
                icon: Icons.logout,
                label: 'Logout',
                isDestructive: true,
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(authViewModelProvider.notifier).logout();
                  context.go('/login');
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Uttarakhand Forest Dept.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.25),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _FooterAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red.shade400 : Colors.white54;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(height: 3),
              Text(label, style: TextStyle(color: color, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
