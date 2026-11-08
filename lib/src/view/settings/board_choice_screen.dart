import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

class const BoardChoiceScreen({super.key}) extends StatelessWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const BoardChoiceScreen());
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.board)),
      body: const _Body(),
    );
  }
}

class const _Body() extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardTheme = ref.watch(boardPreferencesProvider.select((p) => p.boardTheme));

    final hasSystemColors = getSystemCorePalettes() != null;

    final choices2d = BoardTheme.get2dBoards();
    final choices3d = BoardTheme.get3dBoards();

    final choices = BoardTheme.values
        .where((t) => t != BoardTheme.system || hasSystemColors)
        .toList();

    void onChanged(BoardTheme? value, bool toggle3d) {
      if (toggle3d != null) {
	      //TODO HANDLE SWITCHING FROM 2D TO 3D
        ref.read(boardPreferencesProvider.notifier).toggleEnable3dAssets(toggle3d);
      }
      ref.read(boardPreferencesProvider.notifier).setBoardTheme(value ?? BoardTheme.brown);
    }

    const checkedIcon = Icon(Icons.check);

    Widget themeList(List<BoardTheme> themes, bool is3d) {
      return SafeArea(
        child: ListView.separated(
          itemCount: themes.length,
          itemBuilder: (context, index) {
            final t = themes[index];

            return ListTile(
              selected: t == boardTheme,
              trailing: t == boardTheme ? checkedIcon : null,
              title: Text(t.label),
              subtitle: Align(alignment: Alignment.topLeft, child: t.thumbnail),
              onTap: () => onChanged(t, is3d),
            );
          },
          separatorBuilder: (context, index) => Theme.of(context).platform == TargetPlatform.iOS
              ? const PlatformDivider()
              : const SizedBox.shrink(),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: '2D'),
              Tab(text: '3D'),
            ],
          ),
          Expanded(
            child: TabBarView(children: [themeList(choices2d, false), themeList(choices3d, true)]),
          ),
        ],
      ),
    );
  }
}
