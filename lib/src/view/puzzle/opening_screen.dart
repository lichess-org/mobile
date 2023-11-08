import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_opening.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';

import 'puzzle_screen.dart';

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
          return ListView(
            children: [
              for (final openingFamily in data)
                _OpeningFamily(openingFamily: openingFamily),
            ],
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

    final titleStyle = defaultTargetPlatform == TargetPlatform.iOS
        ? TextStyle(
            color: CupertinoTheme.of(context).textTheme.textStyle.color,
          )
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
                style: titleStyle,
              ),
              subtitle: Text(
                '${openingFamily.count}',
                style: TextStyle(
                  color: textShade(context, Styles.subtitleOpacity),
                ),
              ),
              children: [
                ListSection(
                  children: [
                    PlatformListTile(
                      leading: defaultTargetPlatform == TargetPlatform.iOS
                          ? null
                          : const SizedBox.shrink(),
                      title: Text(
                        openingFamily.name,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle,
                      ),
                      trailing: Text(
                        '${openingFamily.count}',
                        style: TextStyle(
                          color: textShade(context, Styles.subtitleOpacity),
                        ),
                      ),
                      onTap: () {
                        pushPlatformRoute(
                          context,
                          rootNavigator: true,
                          builder: (context) => PuzzleScreen(
                            angle: PuzzleOpening(openingFamily.key),
                          ),
                        );
                      },
                    ),
                    ...openingFamily.openings.map(
                      (opening) => PlatformListTile(
                        leading: defaultTargetPlatform == TargetPlatform.iOS
                            ? null
                            : const SizedBox.shrink(),
                        title: Text(
                          opening.name,
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle,
                        ),
                        trailing: Text(
                          '${opening.count}',
                          style: TextStyle(
                            color: textShade(context, Styles.subtitleOpacity),
                          ),
                        ),
                        onTap: () {
                          pushPlatformRoute(
                            context,
                            rootNavigator: true,
                            builder: (context) => PuzzleScreen(
                              angle: PuzzleOpening(opening.key),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
          : ListTile(
              title: Text(
                openingFamily.name,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              ),
              subtitle: Text(
                '${openingFamily.count}',
                style: TextStyle(
                  color: textShade(context, 0.5),
                ),
              ),
              onTap: () {
                pushPlatformRoute(
                  context,
                  rootNavigator: true,
                  builder: (context) => PuzzleScreen(
                    angle: PuzzleOpening(openingFamily.key),
                  ),
                );
              },
            ),
    );
  }
}
