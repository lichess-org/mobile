import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class ChallengeOddBotsScreen extends StatelessWidget {
  const ChallengeOddBotsScreen(this.bot);

  final LightUser bot;

  static Route<dynamic> buildRoute(BuildContext context, LightUser bot) {
    return buildScreenRoute(
      context,
      title: context.l10n.challengeChallengesX(bot.name),
      screen: ChallengeOddBotsScreen(bot),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBarTitle: Text(context.l10n.challengeChallengesX(bot.name)),
      body: _ChallengeBody(bot),
    );
  }
}

class _ChallengeBody extends ConsumerStatefulWidget {
  const _ChallengeBody(this.bot);

  final LightUser bot;

  @override
  ConsumerState<_ChallengeBody> createState() => _ChallengeBodyState();
}

class _BotFen {
  final String fen;
  final Side side;

  _BotFen({required this.fen, required this.side});
}

final Map<String, List<_BotFen>> _botFens = {
  'leelaknightodds': [
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKB1R w KQkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R1BQKBNR w KQkq', side: Side.black),
  ],
  'leelaqueenodds': [
    _BotFen(fen: 'rnb1kbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq', side: Side.white),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNB1KBNR w KQkq', side: Side.black),
  ],
  'leelaqueenforknight': [
    _BotFen(fen: 'r1bqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNB1KBNR w KQkq', side: Side.white),
    _BotFen(fen: 'r1bqkbnr/pppppppp/8/8/8/8/8/PPPPPPPP/RNB1KBNR w KQkq', side: Side.black),
  ],
  'leelarookodds': [
    _BotFen(fen: '1nbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk', side: Side.white),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NBQKBNR w Kkq', side: Side.black),
  ],
  'leelapieceodds': [
    _BotFen(fen: 'r1bqkb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq', side: Side.white),
    _BotFen(fen: 'rn1qk1nr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq', side: Side.white),
    _BotFen(fen: '1nbqkb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk', side: Side.white),
    _BotFen(fen: '1nbqkbn1/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQ', side: Side.white),
    _BotFen(fen: 'r2qk1nr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq', side: Side.white),
    _BotFen(fen: '2bqkb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk', side: Side.white),
    _BotFen(fen: '1n1qk1nr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk', side: Side.white),
    _BotFen(fen: 'rnb1kb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq', side: Side.white),
    _BotFen(fen: 'r2qk2r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq', side: Side.white),
    _BotFen(fen: '1nb1kbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk', side: Side.white),
    _BotFen(fen: 'r1b1kb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq', side: Side.white),
    _BotFen(fen: 'rn2k1nr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq', side: Side.white),
    _BotFen(fen: '1nb1kb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk', side: Side.white),
    _BotFen(fen: '1nb1kbn1/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQ', side: Side.white),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R1BQKB1R w KQkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RN1QK1NR w KQkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NBQKB1R w Kkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NBQKBN1 w kq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R2QK1NR w KQkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/2BQKB1R w Kkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1N1QK1NR w Kkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNB1KB1R w KQkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R2QK2R w KQkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NB1KBNR w Kkq - 0 1', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R1B1KB1R w KQkq - 0 1', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RN2K1NR w KQkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NB1KB1R w Kkq', side: Side.black),
    _BotFen(fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NB1KBN1 w kq', side: Side.black),
  ],
};
final oddBots = _botFens.keys;

class _ChallengeBodyState extends ConsumerState<_ChallengeBody> {
  String? fen;
  SideChoice sideChoice = SideChoice.white;

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(challengePreferencesProvider);

    //special bots have a shorter range of time controls, to prevent an error of the slider we need to check if the time stored in the preferences is within the range of the slider
    int seconds =
        (preferences.clock.time.inSeconds < 60 || preferences.clock.time.inSeconds > 15 * 60)
            ? 300
            : preferences.clock.time.inSeconds;
    int incrementSeconds =
        preferences.clock.increment.inSeconds > 10 ? 10 : preferences.clock.increment.inSeconds;

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Builder(
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return PlatformListTile(
                    harmonizeCupertinoTitleStyle: true,
                    title: Text.rich(
                      TextSpan(
                        text: '${context.l10n.minutesPerSide}: ',
                        children: [
                          TextSpan(
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            text: clockLabelInMinutes(seconds),
                          ),
                        ],
                      ),
                    ),
                    subtitle: NonLinearSlider(
                      value: seconds,
                      values: List.generate(15, (i) => (i + 1) * 60),
                      labelBuilder: clockLabelInMinutes,
                      onChange:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? (num value) {
                                setState(() {
                                  seconds = value.toInt();
                                });
                              }
                              : null,
                      onChangeEnd: (num value) {
                        setState(() {
                          seconds = value.toInt();
                        });
                      },
                    ),
                  );
                },
              );
            },
          ),
          Builder(
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return PlatformListTile(
                    harmonizeCupertinoTitleStyle: true,
                    title: Text.rich(
                      TextSpan(
                        text: '${context.l10n.incrementInSeconds}: ',
                        children: [
                          TextSpan(
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            text: incrementSeconds.toString(),
                          ),
                        ],
                      ),
                    ),
                    subtitle: NonLinearSlider(
                      value: incrementSeconds,
                      values: List.generate(11, (i) => i),
                      onChange:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? (num value) {
                                setState(() {
                                  incrementSeconds = value.toInt();
                                });
                              }
                              : null,
                      onChangeEnd: (num value) {
                        setState(() {
                          incrementSeconds = value.toInt();
                        });
                      },
                    ),
                  );
                },
              );
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  constraints.maxWidth > 600
                      ? 4
                      : constraints.maxWidth > 450
                      ? 3
                      : 2;
              const sidePadding = 16.0;
              const double borderWidth = 3.0;
              final boardWidth =
                  (constraints.maxWidth -
                      (sidePadding * (crossAxisCount - 1)) -
                      (2 * sidePadding) -
                      (2 * borderWidth * crossAxisCount)) /
                  crossAxisCount;
              const borderRadius = 4.0 + borderWidth;

              final userBotFens = _botFens[widget.bot.name.toLowerCase()] ?? [];
              final rowCount = (userBotFens.length / crossAxisCount).ceil();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: sidePadding),
                child: LayoutGrid(
                  columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
                  rowSizes: List.generate(rowCount, (_) => auto),
                  rowGap: 16,
                  columnGap: sidePadding,
                  children:
                      userBotFens.map((botFen) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              fen = botFen.fen;
                              sideChoice =
                                  botFen.side == Side.white ? SideChoice.white : SideChoice.black;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    fen == botFen.fen
                                        ? ColorScheme.of(context).primary
                                        : Colors.transparent,
                                width: borderWidth,
                              ),
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: BoardThumbnail(
                              size: boardWidth,
                              orientation: botFen.side,
                              fen: botFen.fen,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FatButton(
              semanticsLabel: context.l10n.challengeChallengeToPlay,
              onPressed:
                  fen != null
                      ? () {
                        Navigator.of(context, rootNavigator: true).push(
                          GameScreen.buildRoute(
                            context,
                            challenge: ChallengeRequest(
                              destUser: widget.bot,
                              variant: Variant.fromPosition,
                              timeControl: ChallengeTimeControlType.clock,
                              clock: (
                                time: Duration(seconds: seconds),
                                increment: Duration(seconds: incrementSeconds),
                              ),
                              rated: false,
                              sideChoice: sideChoice,
                              initialFen: fen,
                            ),
                          ),
                        );
                      }
                      : null,
              child: Text(context.l10n.challengeChallengeToPlay, style: Styles.bold),
            ),
          ),
        ],
      ),
    );
  }
}
