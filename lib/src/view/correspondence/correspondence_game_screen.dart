import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/view/game/game_body.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/game_settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class CorrespondenceGameScreen extends ConsumerStatefulWidget {
  const CorrespondenceGameScreen({
    required this.initialId,
    this.initialFen,
    this.lastMove,
    super.key,
  });

  final GameFullId initialId;
  final String? initialFen;
  final Move? lastMove;

  @override
  ConsumerState<CorrespondenceGameScreen> createState() =>
      _CorrespondenceGameScreenState();
}

class _CorrespondenceGameScreenState
    extends ConsumerState<CorrespondenceGameScreen> {
  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnGameScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnGameScreen');

  @override
  Widget build(BuildContext context) {
    final gameId = ref.watch(standaloneGameProvider(widget.initialId));
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context,
        gameId: gameId,
      ),
      iosBuilder: (context) => _iosBuilder(
        context,
        gameId: gameId,
      ),
    );
  }

  Widget _androidBuilder(
    BuildContext context, {
    required GameFullId gameId,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: StandaloneGameTitle(id: gameId),
        actions: [
          SettingsButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => GameSettings(id: gameId),
            ),
          ),
        ],
      ),
      body: GameBody(
        initialStandAloneId: widget.initialId,
        id: gameId,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
      ),
    );
  }

  Widget _iosBuilder(
    BuildContext context, {
    required GameFullId gameId,
  }) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: Styles.cupertinoAppBarTrailingWidgetPadding,
        middle: StandaloneGameTitle(id: gameId),
        trailing: SettingsButton(
          onPressed: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => GameSettings(id: gameId),
          ),
        ),
      ),
      child: GameBody(
        initialStandAloneId: widget.initialId,
        id: gameId,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
      ),
    );
  }
}
