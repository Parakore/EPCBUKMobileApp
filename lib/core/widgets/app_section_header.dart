import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? breadcrumb;
  final IconData? icon;
  final List<Widget>? actions;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.breadcrumb,
    this.icon,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppTheme.forestGreen, size: 22),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryGreen,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
          if (breadcrumb != null) ...[
            const SizedBox(height: 4),
            Text(
              breadcrumb!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
