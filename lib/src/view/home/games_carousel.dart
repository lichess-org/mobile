import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

const kGameCarouselFlexWeights = [6, 2];
const kGameCarouselPadding = EdgeInsets.symmetric(horizontal: 8.0);

/// A widget that displays a carousel of games.
class GamesCarousel<T> extends StatefulWidget {
  const GamesCarousel({
    required this.list,
    required this.builder,
    required this.onTap,
    required this.moreScreenRouteBuilder,
    required this.maxGamesToShow,
  });
  final IList<T> list;
  final Widget Function(T data) builder;
  final void Function(int index)? onTap;
  final Route<dynamic> Function(BuildContext) moreScreenRouteBuilder;
  final int maxGamesToShow;

  @override
  State<GamesCarousel<T>> createState() => _GamesCarouselState<T>();
}

class _GamesCarouselState<T> extends State<GamesCarousel<T>> {
  final _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    homeTabInteraction.addListener(_onTabInteraction);
  }

  @override
  void dispose() {
    homeTabInteraction.removeListener(_onTabInteraction);
    super.dispose();
  }

  void _onTabInteraction() {
    if (_controller.hasClients) {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.verticalBodyPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Styles.horizontalBodyPadding,
            child: ListSectionHeader(
              title: Text(context.l10n.nbGamesInPlay(widget.list.length)),
              onTap: widget.list.length > 2
                  ? () {
                      Navigator.of(context).push(widget.moreScreenRouteBuilder(context));
                    }
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: CarouselView.weighted(
                controller: _controller,
                padding: kGameCarouselPadding,
                shape: const RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius),
                elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0 : 1,
                flexWeights: kGameCarouselFlexWeights,
                itemSnapping: true,
                onTap: (index) {
                  widget.onTap?.call(index);
                },
                children: [for (final game in widget.list) widget.builder(game)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget that displays an ongoing game carousel item.
///
/// Typically used in a [GamesCarousel].
class OngoingGameCarouselItem extends StatelessWidget {
  const OngoingGameCarouselItem({required this.game});

  final OngoingGame game;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: game.isRealTime || game.isMyTurn ? 1.0 : 0.8,
      child: _BoardCarouselItem(
        isRealTimeGame: game.isRealTime,
        fen: game.fen,
        orientation: game.orientation,
        lastMove: game.lastMove,
        description: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (game.isMyTurn) ...const [
                      Icon(Icons.timer, size: 16.0, color: Colors.white),
                      SizedBox(width: 4.0),
                    ],
                    Text(
                      game.secondsLeft != null && game.isMyTurn
                          ? relativeDate(
                              context.l10n,
                              DateTime.now().add(Duration(seconds: game.secondsLeft!)),
                            )
                          : game.isMyTurn
                          ? context.l10n.yourTurn
                          : context.l10n.waitingForOpponent,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: game.isMyTurn ? 1.0 : 0.7),
                        fontSize: TextTheme.of(context).labelMedium?.fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                UserFullNameWidget.player(
                  user: game.opponent,
                  rating: game.opponentRating,
                  aiLevel: game.opponentAiLevel,
                  style: Styles.boardPreviewTitle.copyWith(
                    color: Colors.white.withValues(alpha: game.isMyTurn ? 1.0 : 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardCarouselItem extends ConsumerWidget {
  const _BoardCarouselItem({
    required this.orientation,
    required this.fen,
    required this.description,
    this.lastMove,
    this.isRealTimeGame = false,
  });

  /// Side by which the board is oriented.
  final Side orientation;

  /// FEN string describing the position of the board.
  final String fen;

  /// Last move played, used to highlight corresponding squares.
  final Move? lastMove;

  final Widget description;

  /// Whether the game is a real-time game, so it will be highlighted differently.
  final bool isRealTimeGame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final brightness = ColorScheme.of(context).brightness;

    final backgroundColor = lighten(
      isRealTimeGame ? context.lichessColors.brag : boardPrefs.boardTheme.colors.darkSquare,
      brightness == Brightness.light ? 0.25 : 0.0,
    );

    // apply hue settings to background color
    final hsl = HSLColor.fromColor(backgroundColor);
    final hue = (hsl.hue + boardPrefs.hue) % 360;

    final backgroundColorWithHueFilter = HSLColor.fromAHSL(
      1.0,
      hue,
      hsl.saturation,
      hsl.lightness,
    ).toColor();

    final screenWidth = MediaQuery.sizeOf(context).width;
    final totalFlex = kGameCarouselFlexWeights.reduce((a, b) => a + b);
    final double width = screenWidth - 16.0;
    final boardSize =
        width * kGameCarouselFlexWeights[0] / totalFlex - kGameCarouselPadding.horizontal;

    return ColoredBox(
      color: backgroundColorWithHueFilter,
      child: OverflowBox(
        maxWidth: boardSize,
        minWidth: boardSize,
        child: Stack(
          children: [
            ShaderMask(
              blendMode: BlendMode.dstOut,
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColorWithHueFilter.withValues(alpha: 0.25),
                    backgroundColorWithHueFilter.withValues(alpha: 1.0),
                  ],
                  stops: const [0.3, 1.00],
                  tileMode: TileMode.clamp,
                ).createShader(bounds);
              },
              child: SizedBox(
                height: boardSize,
                child: StaticChessboard(
                  hue: boardPrefs.hue,
                  brightness: boardPrefs.brightness,
                  size: boardSize,
                  fen: fen,
                  orientation: orientation,
                  lastMove: lastMove,
                  enableCoordinates: false,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  pieceAssets: boardPrefs.pieceSet.assets,
                  colorScheme: isRealTimeGame
                      ? realTimeColors(context)
                      : boardPrefs.boardTheme.colors,
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 8,
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.white),
                child: description,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ChessboardColorScheme realTimeColors(BuildContext context) {
    final brag = context.lichessColors.brag;
    final lightSquare = lighten(brag, 0.55);
    final darkSquare = brag;
    return ChessboardColorScheme(
      lightSquare: lightSquare,
      darkSquare: darkSquare,
      background: SolidColorChessboardBackground(lightSquare: lightSquare, darkSquare: darkSquare),
      whiteCoordBackground: SolidColorChessboardBackground(
        lightSquare: lightSquare,
        darkSquare: darkSquare,
        coordinates: true,
      ),
      blackCoordBackground: SolidColorChessboardBackground(
        lightSquare: lightSquare,
        darkSquare: darkSquare,
        coordinates: true,
        orientation: Side.black,
      ),
      lastMove: const HighlightDetails(solidColor: Color(0x809cc700)),
      selected: const HighlightDetails(solidColor: Color(0x6014551e)),
      validMoves: const Color(0x4014551e),
      validPremoves: const Color(0x40203085),
    );
  }
}
