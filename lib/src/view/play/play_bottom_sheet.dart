import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/play_menu.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:popover/popover.dart';

class FloatingPlayButton extends ConsumerStatefulWidget {
  const FloatingPlayButton({super.key});

  @override
  ConsumerState<FloatingPlayButton> createState() => _FloatingPlayButtonState();
}

class _FloatingPlayButtonState extends ConsumerState<FloatingPlayButton> {
  final GlobalKey _buttonKey = GlobalKey(debugLabel: 'play_button');

  @override
  void initState() {
    super.initState();

    showHelp();
  }

  Future<bool> shouldDisplayHelp() async {
    if (LichessBinding.instance.sharedPreferences.getBool('app_welcome_message_shown') == true) {
      return false;
    }

    if (ref.read(authSessionProvider) != null) {
      return false;
    }

    final hasPlayedGames =
        await (await ref.read(gameStorageProvider.future)).count(userId: null) > 0;

    return !hasPlayedGames;
  }

  Future<void> showHelp() async {
    final prefs = LichessBinding.instance.sharedPreferences;
    if (await shouldDisplayHelp()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_buttonKey.currentContext?.mounted != true) return;
        showPopover(
          context: _buttonKey.currentContext!,
          bodyBuilder: (context) => ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.6),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${context.l10n.mobileWelcomeToLichessApp}\n\n',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextSpan(
                      text: context.l10n.mobileTapHereToStartPlayingChess,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onPop: () {
            prefs.setBool('app_welcome_message_shown', true);
          },
          barrierColor: Colors.black12,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          direction: PopoverDirection.top,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      key: _buttonKey,
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (context) => const PlayBottomSheet(),
        );
      },
      tooltip: context.l10n.play,
      icon: const Icon(Symbols.chess_pawn_rounded),
      label: Text(context.l10n.play),
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
