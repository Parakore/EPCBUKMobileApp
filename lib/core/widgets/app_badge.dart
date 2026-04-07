import 'package:flutter/material.dart';

enum AppBadgeVariant { success, warning, danger, info, gold, purple, neutral }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final double fontSize;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.info,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: colors.$2,
        ),
      ),
    );
  }

  (Color, Color) _getColors() {
    switch (variant) {
      case AppBadgeVariant.success:
        return (const Color(0xFFE8F5E9), const Color(0xFF2E7D32));
      case AppBadgeVariant.warning:
        return (const Color(0xFFFFF3E0), const Color(0xFFE65100));
      case AppBadgeVariant.danger:
        return (const Color(0xFFFFEBEE), const Color(0xFFC62828));
      case AppBadgeVariant.info:
        return (const Color(0xFFE3F2FD), const Color(0xFF1565C0));
      case AppBadgeVariant.gold:
        return (const Color(0xFFFFF8E1), const Color(0xFFF57F17));
      case AppBadgeVariant.purple:
        return (const Color(0xFFF3E5F5), const Color(0xFF6A1B9A));
      case AppBadgeVariant.neutral:
        return (const Color(0xFFF5F5F5), const Color(0xFF616161));
    }
  }

  static AppBadgeVariant fromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'resolved':
      case 'verified':
      case 'on time':
      case 'signed':
        return AppBadgeVariant.success;
      case 'at risk':
      case 'pending':
      case 'in progress':
      case 'under review':
        return AppBadgeVariant.warning;
      case 'breach':
      case 'open':
      case 'failed':
        return AppBadgeVariant.danger;
      case 'submitted':
      case 'field survey':
      case 'verification':
        return AppBadgeVariant.info;
      case 'dm approval':
      case 'valuation':
        return AppBadgeVariant.gold;
      case 'treasury':
        return AppBadgeVariant.purple;
      default:
        return AppBadgeVariant.neutral;
    }
  }
}
