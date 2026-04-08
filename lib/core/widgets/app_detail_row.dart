import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum DetailRowLayout { leftAligned, spaceBetween }

class AppDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isBold;
  final Color? valueColor;
  final DetailRowLayout layout;
  final double fontSize;

  const AppDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.isBold = false,
    this.valueColor,
    this.layout = DetailRowLayout.leftAligned,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    if (layout == DetailRowLayout.spaceBetween) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel(),
            _buildValue(),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 4, color: AppTheme.textLight),
            const SizedBox(width: 8),
          ],
          _buildLabel(),
          const SizedBox(width: 4),
          Expanded(child: _buildValue()),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      '$label${layout == DetailRowLayout.leftAligned ? ":" : ""}',
      style: TextStyle(
        fontSize: fontSize,
        color: AppTheme.textLight,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildValue() {
    return Text(
      value,
      textAlign: layout == DetailRowLayout.spaceBetween ? TextAlign.end : TextAlign.start,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
        color: valueColor ?? AppTheme.textDark,
      ),
    );
  }
}
