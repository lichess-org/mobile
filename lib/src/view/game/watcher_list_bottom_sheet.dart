import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:material_ui/material_ui.dart';

class const WatcherListBottomSheet({
  required final int nbWatchers,
  required final IList<String> watcherNames,

  /// The scroll controller of the sheet, which expands when the list is scrolled.
  required final ScrollController scrollController,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final anonymousCount = nbWatchers - watcherNames.length;
    final shownNames = watcherNames.take(10).toList();
    final hiddenCount = watcherNames.length - shownNames.length;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Spectators ($nbWatchers)', style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        for (final name in shownNames)
          ListTile(
            dense: true,
            leading: const Icon(Icons.person_outline, size: 20),
            title: Text(name),
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).push(
                UserOrProfileScreen.buildRoute(
                  LightUser(id: UserId(name.toLowerCase()), name: name),
                ),
              );
            },
          ),
        if (hiddenCount > 0)
          ListTile(
            dense: true,
            title: Text(
              'and $hiddenCount more...',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
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
      ],
    );
  }
}
