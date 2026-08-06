import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotiflac_android/l10n/l10n.dart';
import 'package:spotiflac_android/providers/download_queue_provider.dart';
import 'package:spotiflac_android/models/download_item.dart';
import 'package:spotiflac_android/widgets/app_sliver_header.dart';
import 'package:spotiflac_android/services/cover_cache_manager.dart';

class DownloadsTab extends ConsumerWidget {
  const DownloadsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(downloadQueueProvider);
    final items = queueState.items;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Filter to show only active downloads (queued, downloading, finalizing)
    // plus recently completed/failed items
    final activeItems = items.where((item) =>
      item.status == DownloadStatus.queued ||
      item.status == DownloadStatus.downloading ||
      item.status == DownloadStatus.finalizing ||
      item.status == DownloadStatus.failed
    ).toList();

    // Recently completed items (keep last 10)
    final completedItems = items.where((item) =>
      item.status == DownloadStatus.completed
    ).toList();
    // Take last 10 completed
    final recentCompleted = completedItems.length > 10
        ? completedItems.sublist(completedItems.length - 10)
        : completedItems;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppSliverHeader.page(title: 'Downloads'),
          if (activeItems.isEmpty && recentCompleted.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.download_done_rounded,
                      size: 64,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No active downloads',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (activeItems.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Active',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverList.builder(
                itemCount: activeItems.length,
                itemBuilder: (context, index) {
                  final item = activeItems[index];
                  return _DownloadItemTile(
                    item: item,
                    onCancel: () => _confirmCancel(context, ref, item),
                  );
                },
              ),
            ),
          ],
          if (recentCompleted.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Recently Completed',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverList.builder(
                itemCount: recentCompleted.length,
                itemBuilder: (context, index) {
                  final item = recentCompleted[index];
                  return _DownloadItemTile(
                    item: item,
                    onCancel: null,
                  );
                },
              ),
            ),
          ],
          // Bottom padding for mini player
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref, DownloadItem item) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Download?'),
        content: Text('Cancel downloading "${item.track.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(downloadQueueProvider.notifier).removeItem(item.id);
              Navigator.pop(ctx);
            },
            child: Text(
              'Cancel Download',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadItemTile extends StatelessWidget {
  final DownloadItem item;
  final VoidCallback? onCancel;

  const _DownloadItemTile({
    required this.item,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isActive = item.status == DownloadStatus.downloading ||
        item.status == DownloadStatus.queued ||
        item.status == DownloadStatus.finalizing;
    final isCompleted = item.status == DownloadStatus.completed;
    final isFailed = item.status == DownloadStatus.failed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: null,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Cover art
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: item.track.coverUrl != null
                        ? CachedNetworkImage(
                            imageUrl: item.track.coverUrl!,
                            cacheManager: CoverCacheManager.instance,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.music_note,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.music_note,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.music_note,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title + Artist + Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.track.name,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.track.artistName,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isActive) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: item.status == DownloadStatus.queued
                                      ? null
                                      : item.progress.clamp(0.0, 1.0),
                                  minHeight: 4,
                                  backgroundColor: colorScheme.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    item.status == DownloadStatus.finalizing
                                        ? colorScheme.tertiary
                                        : colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            if (item.status == DownloadStatus.downloading &&
                                item.speedMBps > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                '${item.speedMBps.toStringAsFixed(1)} MB/s',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Status icon / Cancel button
                const SizedBox(width: 8),
                if (isCompleted)
                  _CompletedCheckmark()
                else if (isFailed)
                  Icon(
                    Icons.error_outline,
                    color: colorScheme.error,
                    size: 24,
                  )
                else if (onCancel != null)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: onCancel,
                    tooltip: 'Cancel',
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Short-lived animated checkmark that appears when a download completes.
class _CompletedCheckmark extends StatefulWidget {
  @override
  State<_CompletedCheckmark> createState() => _CompletedCheckmarkState();
}

class _CompletedCheckmarkState extends State<_CompletedCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
    );
  }
}
