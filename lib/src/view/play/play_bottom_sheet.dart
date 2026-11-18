import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/play_menu.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class const FloatingPlayButton({super.key}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformFloatingActionButton(
      onPressed: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (_) => PlayBottomSheet(navigator: Navigator.of(context)),
        );
      },
      tooltip: context.l10n.play,
      icon: const Icon(Symbols.chess_pawn_rounded),
      label: context.l10n.play,
    );
  }
}

/// The play menu in a sheet presented on the root navigator, to cover the tab bar.
class const PlayBottomSheet({
  /// The navigator of the screen that presents the sheet, where its screens are pushed (see
  /// [PlayMenu.navigator]).
  required final NavigatorState navigator,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [PlayMenu(navigator: navigator)],
    );
  }
}
