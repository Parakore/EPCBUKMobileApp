import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../model/document_model.dart';
import '../../../providers/providers.dart';

class DMSView extends ConsumerWidget {
  const DMSView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dmsState = ref.watch(dmsViewModelProvider('all'));

    return dmsState.when(
      data: (docs) => RefreshIndicator(
        onRefresh: () =>
            ref.read(dmsViewModelProvider('all').notifier).refresh(),
        child: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryTabs(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  return _DocumentCard(doc: doc);
                },
              ),
            ),
          ],
        ),
      ),
      loading: () => const AppLoader(),
      error: (err, stack) => AppErrorWidget(
        message: err.toString(),
        onRetry: () => ref.read(dmsViewModelProvider('all').notifier).refresh(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: Colors.white,
      child: const AppTextField(
        hintText: 'Search documents...',
        prefixIcon: Icon(Icons.search),
        labelText: 'Search',
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      'All Docs',
      'ID Proof',
      'Layouts',
      'Clearances',
      'Survey'
    ];
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isFirst = index == 0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: FilterChip(
              label: Text(categories[index]),
              selected: isFirst,
              onSelected: (val) {},
              backgroundColor: Colors.grey.shade100,
              selectedColor: AppTheme.greenMid.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: isFirst ? AppTheme.greenMid : AppTheme.textMid,
                fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isFirst ? AppTheme.greenMid : Colors.transparent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final AppDocument doc;

  const _DocumentCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.greenPale,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppTheme.greenMid,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${doc.category} • ${doc.size}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Uploaded: ${doc.date}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppBadge(
                label: doc.status,
                type: _getStatusType(doc.status),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.download_for_offline_outlined,
                        size: 20),
                    visualDensity: VisualDensity.compact,
                    color: AppTheme.blueGov,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, size: 20),
                    visualDensity: VisualDensity.compact,
                    color: AppTheme.textLight,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  BadgeType _getStatusType(String status) {
    switch (status) {
      case 'Verified':
        return BadgeType.success;
      case 'Progress':
        return BadgeType.warning;
      default:
        return BadgeType.info;
    }
  }
}
