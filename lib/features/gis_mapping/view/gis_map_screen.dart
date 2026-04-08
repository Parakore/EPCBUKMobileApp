import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../providers/providers.dart';
import '../model/tree_location_model.dart';

class GISMapScreen extends ConsumerWidget {
  const GISMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(gisMapViewModelProvider);

    return mapState.when(
      data: (state) => Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: state.currentCenter,
              initialZoom: state.currentZoom,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture && position.center != null) {
                  ref
                      .read(gisMapViewModelProvider.notifier)
                      .updateCenter(position.center!);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.epcbuk.mobile_app',
              ),
              MarkerLayer(
                markers: state.cachedTrees
                    .map((tree) => _buildMarker(context, tree))
                    .toList(),
              ),
            ],
          ),
          _buildLegend(),
          _buildFloatingStats(state.cachedTrees.length),
        ],
      ),
      loading: () => const AppLoader(message: 'Loading spatial data...'),
      error: (err, stack) => AppErrorWidget(
        message: err.toString(),
        onRetry: () => ref.read(gisMapViewModelProvider.notifier).refresh(),
      ),
    );
  }

  Marker _buildMarker(BuildContext context, TreeLocationModel tree) {
    return Marker(
      point: tree.position,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _showTreeDetails(context, tree),
        child: Container(
          decoration: BoxDecoration(
            color: tree.isFlagged ? Colors.red : AppTheme.primaryGreen,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.park, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  void _showTreeDetails(BuildContext context, TreeLocationModel tree) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Asset ID: ${tree.id}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                if (tree.isFlagged)
                  const Chip(
                    label: Text('FLAGGED',
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                    backgroundColor: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow(Icons.eco, 'Species', tree.species),
            _detailRow(Icons.location_on, 'Coordinates',
                '${tree.position.latitude.toStringAsFixed(4)}, ${tree.position.longitude.toStringAsFixed(4)}'),
            _detailRow(Icons.calendar_today, 'Tagged On',
                tree.capturedAt.toString().split('.')[0]),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen),
                    child: const Text('View Full Record'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return PositionAt(
      right: 16,
      top: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Legend',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            _legendItem(AppTheme.primaryGreen, 'Healthy Asset'),
            _legendItem(Colors.red, 'Flagged / Risk'),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildFloatingStats(int count) {
    return PositionAt(
      left: 16,
      top: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.forestGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$count Trees Mapped',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}

// Helper widget for absolute positioning in Stack
class PositionAt extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Widget child;

  const PositionAt(
      {super.key,
      this.top,
      this.bottom,
      this.left,
      this.right,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: child,
    );
  }
}
