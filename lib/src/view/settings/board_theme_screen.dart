import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/android.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BoardThemeScreen extends StatelessWidget {
  const BoardThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.boardTheme)),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardTheme =
        ref.watch(boardPreferencesProvider.select((p) => p.boardTheme));

    final androidVersion = ref.watch(androidVersionProvider).whenOrNull(
          data: (v) => v,
        );

    final choices = BoardTheme.values
        .where(
          (t) =>
              t != BoardTheme.system ||
              (androidVersion != null && androidVersion.sdkInt >= 31),
        )
        .toList();

    void onChanged(BoardTheme? value) => ref
        .read(boardPreferencesProvider.notifier)
        .setBoardTheme(value ?? BoardTheme.brown);

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            notchedTile: true,
            tileContentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            choices: choices,
            selectedItem: boardTheme,
            titleBuilder: (t) => Text(t.label),
            subtitleBuilder: (t) => Align(
              alignment: Alignment.topLeft,
              child: t == BoardTheme.system
                  ? SizedBox(
                      height: 32,
                      width: 32 * 6,
                      child: Row(
                        children: [
                          for (final c in [1, 2, 3, 4, 5, 6])
                            Container(
                              width: 32,
                              color: c.isEven
                                  ? BoardTheme.systemColors.darkSquare
                                  : BoardTheme.systemColors.lightSquare,
                            ),
                        ],
                      ),
                    )
                  : Image.asset(
                      'assets/board-thumbnails/${t.name}.jpg',
                      height: 32,
                      errorBuilder: (context, o, st) => const SizedBox.shrink(),
                    ),
            ),
            onSelectedItemChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
