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
    return buildScreenRoute(context, screen: const BoardChoiceScreen());
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

    const checkedIcon = Icon(Icons.check);

    return SafeArea(
      child: ListView.separated(
        itemBuilder: (context, index) {
          final t = choices[index];
          return ListTile(
            selected: t == boardTheme,
            trailing: t == boardTheme ? checkedIcon : null,
            title: Text(t.label),
            subtitle: Align(alignment: Alignment.topLeft, child: t.thumbnail),
            onTap: () => onChanged(t),
          );
        },
        separatorBuilder:
            (_, _) =>
                Theme.of(context).platform == TargetPlatform.iOS
                    ? const PlatformDivider()
                    : const SizedBox.shrink(),
        itemCount: choices.length,
      ),
    );
  }
}
