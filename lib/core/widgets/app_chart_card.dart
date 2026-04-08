import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppChartCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final List<Widget>? actions;
  final EdgeInsets padding;

  const AppChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.actions,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.forestGreen,
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
          Padding(
            padding: padding,
            child: chart,
          ),
        ],
      ),
    );
  }
}
