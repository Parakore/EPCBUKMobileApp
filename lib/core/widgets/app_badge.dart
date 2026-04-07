import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BadgeType { info, success, warning, danger, gold, purple }

class AppBadge extends StatelessWidget {
  final String label;
  final BadgeType type;

  const AppBadge({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case BadgeType.info:
        bgColor = AppTheme.blueGov.withValues(alpha: 0.1);
        textColor = AppTheme.blueGov;
        break;
      case BadgeType.success:
        bgColor = AppTheme.greenLight.withValues(alpha: 0.1);
        textColor = AppTheme.greenMid;
        break;
      case BadgeType.warning:
        bgColor = AppTheme.saffron.withValues(alpha: 0.1);
        textColor = AppTheme.saffron;
        break;
      case BadgeType.danger:
        bgColor = AppTheme.redAlert.withValues(alpha: 0.1);
        textColor = AppTheme.redAlert;
        break;
      case BadgeType.gold:
        bgColor = AppTheme.gold.withValues(alpha: 0.1);
        textColor = AppTheme.gold;
        break;
      case BadgeType.purple:
        bgColor = AppTheme.purpleAI.withValues(alpha: 0.1);
        textColor = AppTheme.purpleAI;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
