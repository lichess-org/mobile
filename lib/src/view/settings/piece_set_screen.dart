import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class PieceSetScreen extends StatelessWidget {
  const PieceSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.pieceSet)),
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
    final boardPrefs = ref.watch(boardPreferencesProvider);

    List<AssetImage> getPieceImages(PieceSet set) {
      return [
        set.assets[kWhiteKingKind]!,
        set.assets[kBlackQueenKind]!,
        set.assets[kWhiteRookKind]!,
        set.assets[kBlackBishopKind]!,
        set.assets[kWhiteKnightKind]!,
        set.assets[kBlackPawnKind]!,
      ];
    }

    void onChanged(PieceSet? value) => ref
        .read(boardPreferencesProvider.notifier)
        .setPieceSet(value ?? PieceSet.cburnett);

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            notchedTile: true,
            tileContentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            choices: PieceSet.values,
            selectedItem: boardPrefs.pieceSet,
            titleBuilder: (t) => Text(t.label),
            subtitleBuilder: (t) => ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 192,
              ),
              child: Stack(
                children: [
                  boardPrefs.boardTheme.thumbnail,
                  Row(
                    children: getPieceImages(t)
                        .map(
                          (img) => Image(
                            image: img,
                            height: 32,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            onSelectedItemChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
