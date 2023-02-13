import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';

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
      appBar: AppBar(title: Text(context.l10n.background)),
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
    final pieceSet = ref.watch(pieceSetPrefProvider);
    final boardTheme = ref.watch(boardThemePrefProvider);

    List<AssetImage> getPieceImages() {
      return [
        pieceSet.assets['whiteking']!,
        pieceSet.assets['blackqueen']!,
        pieceSet.assets['whiterook']!,
        pieceSet.assets['blackbishop']!,
        pieceSet.assets['whiteknight']!,
        pieceSet.assets['blackpawn']!,
      ];
    }

    void onChanged(BoardTheme? value) => ref
        .read(boardThemePrefProvider.notifier)
        .set(value ?? BoardTheme.brown);

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            notchedTile: true,
            tileContentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            choices: BoardTheme.values,
            selectedItem: boardTheme,
            leadingBuilder: (t) => ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 192,
              ),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/board-thumbnails/${t.name}.jpg",
                    height: 32,
                    errorBuilder: (context, o, st) => const SizedBox.shrink(),
                  ),
                  Row(
                    children: getPieceImages()
                        .map(
                          (img) => Image(
                            image: img,
                            height: 32,
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
            titleBuilder: (t) => Text(t.label),
            onSelectedItemChanged: onChanged,
          )
        ],
      ),
    );
  }
}
