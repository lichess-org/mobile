import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/create_game_options.dart';
import 'package:lichess_mobile/src/view/play/playban.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';

class FloatingPlayButton extends StatelessWidget {
  const FloatingPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (context) => const PlayBottomSheet(),
        );
      },
      tooltip: context.l10n.play,
      child: const Icon(Symbols.chess_pawn_rounded),
    );
  }
}

class PlayBottomSheet extends ConsumerWidget {
  const PlayBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playban = ref.watch(accountProvider).valueOrNull?.playban;

    return BottomSheetScrollableContainer(
      children: [
        if (playban != null)
          Padding(padding: Styles.bodySectionPadding, child: PlaybanMessage(playban: playban)),
        const CreateGameOptions(),
      ],
    );
  }
}
