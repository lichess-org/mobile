import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/play_menu.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';

class FloatingPlayButton extends StatelessWidget {
  const FloatingPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
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
    return const BottomSheetScrollableContainer(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      children: [PlayMenu()],
    );
  }
}
