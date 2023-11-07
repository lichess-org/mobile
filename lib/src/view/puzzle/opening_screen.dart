import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class OpeningThemeScreen extends StatelessWidget {
  const OpeningThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.puzzlePuzzlesByOpenings),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzlePuzzlesByOpenings),
      ),
      child: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openings = ref.watch(puzzleOpeningProvider);
    return SafeArea(
      child: openings.when(
        data: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                for (final openingFamily in data)
                  _OpeningFamily(openingFamily: openingFamily),
              ],
            ),
          );
        },
        error: (error, stack) {
          return const Center(child: Text('Could not load openings.'));
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

class _OpeningFamily extends ConsumerWidget {
  const _OpeningFamily({
    required this.openingFamily,
  });

  final PuzzleOpeningFamily openingFamily;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsedIconColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.secondaryLabel.resolveFrom(context)
        : null;
    final tileColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.systemBlue.resolveFrom(context)
        : null;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: openingFamily.openings.isNotEmpty
          ? ExpansionTile(
              iconColor: tileColor,
              collapsedIconColor: collapsedIconColor,
              title: Text(
                openingFamily.name,
                overflow: TextOverflow.ellipsis,
                style: defaultTargetPlatform == TargetPlatform.iOS
                    ? TextStyle(
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color,
                      )
                    : null,
              ),
              subtitle: Text(
                '${openingFamily.count}',
                style: TextStyle(
                  color: textShade(context, 0.5),
                ),
              ),
              children: [
                ListSection(
                  children: openingFamily.openings
                      .map(
                        (opening) => PlatformListTile(
                          leading: const SizedBox.shrink(),
                          title: Text(
                            opening.name,
                            overflow: TextOverflow.ellipsis,
                            style: defaultTargetPlatform == TargetPlatform.iOS
                                ? TextStyle(
                                    color: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .color,
                                  )
                                : null,
                          ),
                          subtitle: Text(
                            '${opening.count}',
                            style: TextStyle(
                              color: textShade(context, 0.5),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            )
          : PlatformListTile(
              title: Text(
                openingFamily.name,
                overflow: TextOverflow.ellipsis,
                style: defaultTargetPlatform == TargetPlatform.iOS
                    ? TextStyle(
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color,
                      )
                    : null,
              ),
              subtitle: Text(
                '${openingFamily.count}',
                style: TextStyle(
                  color: textShade(context, 0.5),
                ),
              ),
            ),
    );
  }
}
