import 'package:flutter/material.dart';

class AppLegend extends StatelessWidget {
  final List<AppLegendItem> items;
  final MainAxisAlignment alignment;

  const AppLegend({
    super.key,
    required this.items,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) => _buildItem(item)).toList(),
    );
  }

  Widget _buildItem(AppLegendItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(item.isSquare ? 2 : 6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class AppLegendItem {
  final String label;
  final Color color;
  final bool isSquare;

  const AppLegendItem({
    required this.label,
    required this.color,
    this.isSquare = true,
  });
}
