import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';

import 'puzzle_screen.dart';

class PuzzleThemesScreen extends StatelessWidget {
  const PuzzleThemesScreen({super.key});

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
        title: Text(context.l10n.puzzleThemes),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzleThemes),
      ),
      child: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(puzzleThemeCategoriesProvider);

    return SafeArea(
      child: ListView(
        padding: Styles.bodyPadding,
        children: [
          for (final category in list) _Category(category: category),
        ],
      ),
    );
  }
}

class _Category extends ConsumerWidget {
  const _Category({required this.category});

  final PuzzleThemeCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: Styles.sectionBottomPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.item1, style: Styles.sectionTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final theme in category.item2)
                ListTile(
                  title: Text(puzzleThemeL10n(context, theme).name),
                  subtitle: Text(puzzleThemeL10n(context, theme).description),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push<void>(
                      MaterialPageRoute(
                        builder: (context) => PuzzlesScreen(theme: theme),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
