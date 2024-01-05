import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/lobby_screen.dart';
import 'package:lichess_mobile/src/view/play/create_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/view/play/create_custom_game_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import './time_control_modal.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen();

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: PlayScreenBody(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.createAGame),
      ),
      body: const PlayScreenBody(),
    );
  }
}

class PlayScreenBody extends ConsumerWidget {
  const PlayScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(playPreferencesProvider);
    final session = ref.watch(authSessionProvider);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _TimeControlButton(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FatButton(
              semanticsLabel: context.l10n.quickPairing,
              onPressed: () {
                ref
                    .read(playPreferencesProvider.notifier)
                    .setSeekMode(SeekMode.fast);

                pushPlatformRoute(
                  context,
                  rootNavigator: true,
                  builder: (_) => LobbyScreen(
                    seek: GameSeek.fastPairingFromPrefs(playPrefs, session),
                  ),
                );
              },
              child: Text(context.l10n.quickPairing),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SecondaryButton(
              semanticsLabel: context.l10n.custom,
              onPressed: () {
                pushPlatformRoute(
                  context,
                  title: context.l10n.custom,
                  builder: (_) => const CreateCustomGameScreen(),
                );
              },
              child: Text(context.l10n.custom),
            ),
          ),
          if (defaultTargetPlatform != TargetPlatform.iOS)
            const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SecondaryButton(
              semanticsLabel: context.l10n.correspondence,
              onPressed: () {
                pushPlatformRoute(
                  context,
                  title: context.l10n.correspondence,
                  builder: (_) => const CreateCorrespondenceGameScreen(),
                );
              },
              child: Text(context.l10n.correspondence),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeControlButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeControlPref = ref
        .watch(playPreferencesProvider.select((prefs) => prefs.timeIncrement));

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(timeControlPref.speed.icon, size: 20),
                const SizedBox(width: 5),
                Text(timeControlPref.display, style: Styles.timeControl),
              ],
            ),
          ),
        ),
        const Icon(Icons.keyboard_arrow_down, size: 28.0),
      ],
    );

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return GestureDetector(
          onTap: () => _onPressed(context),
          child: PlatformCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: content,
            ),
          ),
        );
      case TargetPlatform.android:
        return OutlinedButton(
          onPressed: () => _onPressed(context),
          child: content,
        );
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  void _onPressed(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    showAdaptiveBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxHeight: screenHeight - (screenHeight / 10),
      ),
      builder: (BuildContext context) {
        return const TimeControlModal();
      },
    );
  }
}
