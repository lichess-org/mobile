import 'package:chessground/chessground.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class PieceShiftMethodSettingsScreen extends StatelessWidget {
  const PieceShiftMethodSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.preferencesHowDoYouMovePieces)),
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

String pieceShiftMethodl10n(
  BuildContext context,
  PieceShiftMethod pieceShiftMethod,
) =>
    switch (pieceShiftMethod) {
      // This is called 'Either' in the Web UI, but in the app we might display this string
      // without having the other values as context, so we need to be more explicit.
      // TODO add this to mobile translations
      PieceShiftMethod.either => 'Click or drag pieces',
      PieceShiftMethod.drag => context.l10n.preferencesDragPiece,
      // TODO This string uses 'click', we might want to use 'tap' instead in a mobile-specific translation
      PieceShiftMethod.tapTwoSquares => context.l10n.preferencesClickTwoSquares,
    };

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceShiftMethod = ref.watch(
      boardPreferencesProvider.select(
        (state) => state.pieceShiftMethod,
      ),
    );

    void onChanged(PieceShiftMethod? value) {
      ref
          .read(boardPreferencesProvider.notifier)
          .setPieceShiftMethod(value ?? PieceShiftMethod.either);
    }

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            notchedTile: true,
            choices: PieceShiftMethod.values,
            selectedItem: pieceShiftMethod,
            titleBuilder: (t) => Text(pieceShiftMethodl10n(context, t)),
            onSelectedItemChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
