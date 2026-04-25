import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class WatcherListBottomSheet extends StatelessWidget {
  const WatcherListBottomSheet({required this.nbWatchers, required this.watcherNames, super.key});

  final int nbWatchers;
  final IList<String> watcherNames;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final anonymousCount = nbWatchers - watcherNames.length;
    final shownNames = watcherNames.take(10).toList();
    final hiddenCount = watcherNames.length - shownNames.length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Spectators ($nbWatchers)', style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),

            // Named watchers list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shownNames.length + (hiddenCount > 0 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == shownNames.length) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      'and $hiddenCount more...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.person_outline, size: 20),
                  title: Text(shownNames[index]),
                );
              },
            ),

            // Anonymous viewers
            if (anonymousCount > 0)
              ListTile(
                dense: true,
                leading: const Icon(Icons.visibility_outlined, size: 20),
                title: Text(
                  '$anonymousCount anonymous',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
