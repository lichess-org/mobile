import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class BoardChoiceScreen extends StatelessWidget {
  const BoardChoiceScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const BoardChoiceScreen(), title: context.l10n.board);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(appBarTitle: Text(context.l10n.board), body: const _Body());
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardTheme = ref.watch(boardPreferencesProvider.select((p) => p.boardTheme));

    final hasSystemColors = getCorePalette() != null;

    final choices =
        BoardTheme.values.where((t) => t != BoardTheme.system || hasSystemColors).toList();

    void onChanged(BoardTheme? value) =>
        ref.read(boardPreferencesProvider.notifier).setBoardTheme(value ?? BoardTheme.brown);

    final checkedIcon =
        Theme.of(context).platform == TargetPlatform.android
            ? const Icon(Icons.check)
            : Icon(
              CupertinoIcons.check_mark_circled_solid,
              color: CupertinoTheme.of(context).primaryColor,
            );

    return SafeArea(
      child: ListView.separated(
        itemBuilder: (context, index) {
          final t = choices[index];
          return PlatformListTile(
            selected: t == boardTheme,
            trailing: t == boardTheme ? checkedIcon : null,
            title: Text(t.label),
            subtitle: Align(alignment: Alignment.topLeft, child: t.thumbnail),
            onTap: () => onChanged(t),
          );
        },
        separatorBuilder:
            (_, _) => PlatformDivider(
              height: 1,
              // on iOS: 14 (default indent) + 16 (padding)
              indent: Theme.of(context).platform == TargetPlatform.iOS ? 14 + 16 : null,
              color: Theme.of(context).platform == TargetPlatform.iOS ? null : Colors.transparent,
            ),
        itemCount: choices.length,
      ),
    );
  }
}
