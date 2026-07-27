import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_opening.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';

final _openingsSortProvider = StateProvider.autoDispose<PuzzleOpeningSort>(
  (ref) => PuzzleOpeningSort.popular,
);

final _openingsProvider = FutureProvider.autoDispose
    .family<(bool, ISet<String>, IList<PuzzleOpeningFamily>?), PuzzleOpeningSort>((
      ref,
      sort,
    ) async {
      final connectivityStatus = await ref.watch(connectivityChangesProvider.future);
      final savedOpenings = await ref.watch(savedOpeningBatchesProvider.future);
      IList<PuzzleOpeningFamily>? onlineOpenings;
      try {
        onlineOpenings = await ref.watch(puzzleOpeningsProvider(sort).future);
      } catch (e) {
        onlineOpenings = null;
      }
      return (connectivityStatus.isOnline, savedOpenings, onlineOpenings);
    });

class OpeningThemeScreen extends ConsumerWidget {
  const OpeningThemeScreen({super.key});

  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const OpeningThemeScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(_openingsSortProvider);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.puzzlePuzzlesByOpenings),
        actions: [
          ContextMenuIconButton(
            consumeOutsideTap: true,
            icon: const Icon(Icons.sort_outlined),
            semanticsLabel: 'Sort openings',
            actions: [
              ContextMenuAction(
                icon: sort == PuzzleOpeningSort.popular ? Icons.check : null,
                label: context.l10n.popularOpenings,
                onPressed: () {
                  ref.read(_openingsSortProvider.notifier).state = PuzzleOpeningSort.popular;
                },
              ),
              ContextMenuAction(
                icon: sort == PuzzleOpeningSort.alphabetical ? Icons.check : null,
                label: 'Alphabetical',
                onPressed: () {
                  ref.read(_openingsSortProvider.notifier).state = PuzzleOpeningSort.alphabetical;
                },
              ),
            ],
          ),
        ],
      ),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(_openingsSortProvider);
    final openings = ref.watch(_openingsProvider(sort));
    return openings.when(
      data: (data) {
        final (isOnline, savedOpenings, onlineOpenings) = data;
        if (isOnline && onlineOpenings != null) {
          return ListView(
            children: [
              for (final openingFamily in onlineOpenings)
                _OpeningFamily(openingFamily: openingFamily, titleStyle: null),
            ],
          );
        } else {
          // A user can have hundreds of saved openings, so this list is built lazily and each tile
          // counts its own puzzles: only the visible ones are read from the database.
          final savedKeys = savedOpenings.toList()..sort();
          return ListView.separated(
            padding: Styles.bodySectionPadding,
            itemCount: savedKeys.length,
            separatorBuilder: (context, index) => Theme.of(context).platform == TargetPlatform.iOS
                ? const PlatformDivider(height: 0)
                : const SizedBox.shrink(),
            itemBuilder: (context, index) => _SavedOpeningTile(openingKey: savedKeys[index]),
          );
        }
      },
      error: (error, stack) {
        return const Center(child: Text('Could not load openings.'));
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _OpeningFamily extends ConsumerWidget {
  const _OpeningFamily({required this.openingFamily, required this.titleStyle});

  final PuzzleOpeningFamily openingFamily;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: openingFamily.openings.isNotEmpty
          ? ExpansionTile(
              title: Text(openingFamily.name, overflow: TextOverflow.ellipsis, style: titleStyle),
              subtitle: Text(
                '${openingFamily.count}',
                style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
              ),
              children: [
                ListSection(
                  children: [
                    _OpeningTile(
                      name: openingFamily.name,
                      openingKey: openingFamily.key,
                      count: openingFamily.count,
                      titleStyle: titleStyle,
                    ),
                    ...openingFamily.openings.map(
                      (opening) => _OpeningTile(
                        name: opening.name,
                        openingKey: opening.key,
                        count: opening.count,
                        titleStyle: titleStyle,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : ListTile(
              title: Text(openingFamily.name, overflow: TextOverflow.ellipsis, style: titleStyle),
              subtitle: Text(
                '${openingFamily.count}',
                style: TextStyle(color: textShade(context, 0.5)),
              ),
              onTap: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(PuzzleScreen.buildRoute(angle: PuzzleOpening(openingFamily.key)));
              },
            ),
    );
  }
}

/// An opening tile that reads the number of saved puzzles of that opening from the database.
class _SavedOpeningTile extends ConsumerWidget {
  const _SavedOpeningTile({required this.openingKey});

  final String openingKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _OpeningTile(
      name: openingKey.replaceAll('_', ' '),
      openingKey: openingKey,
      count: ref.watch(savedBatchNbUnsolvedProvider(PuzzleOpening(openingKey))).value,
      titleStyle: null,
    );
  }
}

class _OpeningTile extends StatelessWidget {
  const _OpeningTile({
    required this.name,
    required this.openingKey,
    required this.count,
    this.titleStyle,
  });

  final String name;
  final String openingKey;

  /// The number of puzzles of that opening, or `null` while it is still unknown.
  final int? count;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name, overflow: TextOverflow.ellipsis, style: titleStyle),
      trailing: count != null
          ? Text('$count', style: TextStyle(color: textShade(context, Styles.subtitleOpacity)))
          : null,
      onTap: () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(PuzzleScreen.buildRoute(angle: PuzzleOpening(openingKey)));
      },
    );
  }
}
