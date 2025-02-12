import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_body.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/game/game_settings.dart';
import 'package:lichess_mobile/src/view/game/ping_rating.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

/// Screen to play a game, or to show a challenge or to show current user's past games.
///
/// The screen can be created in three ways:
/// - From the lobby, to play a game with a random opponent: using a [GameSeek] as [seek].
/// - From a challenge, to accept or decline a challenge: using a [ChallengeRequest] as [challenge].
/// - From a game id, to show a game that is already in progress: using a [GameFullId] as [initialGameId].
///
/// The screen will show a loading board while the game is being created.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({
    this.seek,
    this.initialGameId,
    this.challenge,
    this.loadingFen,
    this.loadingLastMove,
    this.loadingOrientation,
    this.lastMoveAt,
    this.gameListContext,
    super.key,
  }) : assert(
         initialGameId != null || seek != null || challenge != null,
         'Either a seek, a challenge or an initial game id must be provided.',
       );

  final GameSeek? seek;
  final GameFullId? initialGameId;
  final ChallengeRequest? challenge;

  final String? loadingFen;
  final Move? loadingLastMove;
  final Side? loadingOrientation;

  /// The date of the last move played in the game. If null, the game is in progress.
  final DateTime? lastMoveAt;

  /// The context of the game list that opened this screen, if available.
  final (UserId?, GameFilterState)? gameListContext;

  _GameSource get source {
    if (initialGameId != null) {
      return _GameSource.game;
    } else if (challenge != null) {
      return _GameSource.challenge;
    } else {
      return _GameSource.lobby;
    }
  }

  static Route<dynamic> buildRoute(
    BuildContext context, {
    GameSeek? seek,
    GameFullId? initialGameId,
    ChallengeRequest? challenge,
    String? loadingFen,
    Move? loadingLastMove,
    Side? loadingOrientation,
    DateTime? lastMoveAt,
    (UserId?, GameFilterState)? gameListContext,
  }) {
    return buildScreenRoute(
      context,
      screen: GameScreen(
        seek: seek,
        initialGameId: initialGameId,
        challenge: challenge,
        loadingFen: loadingFen,
        loadingLastMove: loadingLastMove,
        loadingOrientation: loadingOrientation,
        lastMoveAt: lastMoveAt,
        gameListContext: gameListContext,
      ),
    );
  }

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

enum _GameSource { lobby, challenge, game }

class _GameScreenState extends ConsumerState<GameScreen> with RouteAware {
  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnGameScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnGameScreen');
  final _boardKey = GlobalKey(debugLabel: 'boardOnGameScreen');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      rootNavPageRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    rootNavPageRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    if (mounted && (widget.source == _GameSource.lobby || widget.source == _GameSource.challenge)) {
      ref.invalidate(myRecentGamesProvider);
      ref.invalidate(accountProvider);
    }
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = currentGameProvider(widget.seek, widget.challenge, widget.initialGameId);

    return ref
        .watch(provider)
        .when(
          data: (data) {
            final (gameFullId: gameId, challenge: challenge, declineReason: declineReason) = data;
            final body =
                gameId != null
                    ? GameBody(
                      id: gameId,
                      loadingBoardWidget: StandaloneGameLoadingBoard(
                        fen: widget.loadingFen,
                        lastMove: widget.loadingLastMove,
                        orientation: widget.loadingOrientation,
                      ),
                      whiteClockKey: _whiteClockKey,
                      blackClockKey: _blackClockKey,
                      boardKey: _boardKey,
                      onLoadGameCallback: (id) {
                        ref.read(provider.notifier).loadGame(id);
                      },
                      onNewOpponentCallback: (game) {
                        if (widget.source == _GameSource.lobby) {
                          ref.read(provider.notifier).newOpponent();
                        } else {
                          final savedSetup = ref.read(gameSetupPreferencesProvider);
                          Navigator.of(context, rootNavigator: true).pushReplacement(
                            GameScreen.buildRoute(
                              context,
                              seek: GameSeek.newOpponentFromGame(game, savedSetup),
                            ),
                          );
                        }
                      },
                    )
                    : widget.challenge != null && challenge != null
                    ? ChallengeDeclinedBoard(
                      challenge: challenge,
                      declineReason:
                          declineReason != null
                              ? declineReason.label(context.l10n)
                              : ChallengeDeclineReason.generic.label(context.l10n),
                    )
                    : const LoadGameError('Could not create the game.');
            return PlatformScaffold(
              resizeToAvoidBottomInset: false,
              appBar: _GameAppBar(
                id: gameId,
                lastMoveAt: widget.lastMoveAt,
                gameListContext: widget.gameListContext,
              ),
              body: body,
            );
          },
          loading: () {
            final loadingBoard =
                widget.seek != null
                    ? LobbyScreenLoadingContent(
                      widget.seek!,
                      () => ref.read(createGameServiceProvider).cancelSeek(),
                    )
                    : widget.challenge != null
                    ? ChallengeLoadingContent(
                      widget.challenge!,
                      () => ref.read(createGameServiceProvider).cancelChallenge(),
                    )
                    : const StandaloneGameLoadingBoard();

            return PlatformScaffold(
              resizeToAvoidBottomInset: false,
              appBar: _GameAppBar(
                seek: widget.seek,
                challenge: widget.challenge,
                lastMoveAt: widget.lastMoveAt,
                gameListContext: widget.gameListContext,
              ),
              body: PopScope(canPop: false, child: loadingBoard),
            );
          },
          error: (e, s) {
            debugPrint('SEVERE: [GameScreen] could not create game; $e\n$s');

            // lichess sends a 400 response if user has disallowed challenges
            final message =
                e is ServerException && e.statusCode == 400
                    ? LoadGameError(
                      'Could not create the game: ${e.jsonError?['error'] as String?}',
                    )
                    : const LoadGameError(
                      'Sorry, we could not create the game. Please try again later.',
                    );

            final body = PopScope(child: message);

            return PlatformScaffold(
              appBar: _GameAppBar(
                seek: widget.seek,
                lastMoveAt: widget.lastMoveAt,
                gameListContext: widget.gameListContext,
              ),
              body: body,
            );
          },
        );
  }
}

class _GameAppBar extends ConsumerWidget {
  const _GameAppBar({
    this.id,
    this.seek,
    this.challenge,
    this.lastMoveAt,
    required this.gameListContext,
  });

  final GameSeek? seek;
  final ChallengeRequest? challenge;
  final GameFullId? id;

  /// The date of the last move played in the game. If null, the game is in progress.
  final DateTime? lastMoveAt;

  /// The context of the game list that opened this screen, if available.
  final (UserId?, GameFilterState)? gameListContext;

  static const pingRating = Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
    child: SocketPingRating(size: 24.0),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldPreventGoingBackAsync =
        id != null ? ref.watch(shouldPreventGoingBackProvider(id!)) : const AsyncValue.data(true);
    final isBookmarkedAsync =
        id != null ? ref.watch(isGameBookmarkedProvider(id!)) : const AsyncValue.data(false);

    return PlatformAppBar(
      leading: shouldPreventGoingBackAsync.maybeWhen<Widget?>(
        data: (prevent) => prevent ? pingRating : null,
        orElse: () => pingRating,
      ),
      title:
          id != null
              ? _StandaloneGameTitle(id: id!, lastMoveAt: lastMoveAt)
              : seek != null
              ? _LobbyGameTitle(seek: seek!)
              : challenge != null
              ? _ChallengeGameTitle(challenge: challenge!)
              : const SizedBox.shrink(),
      actions: [
        // builder is needed to keep the context in the MenuAnchor when [MenuItemButton.closeOnActivate] is true
        Builder(
          builder: (context) {
            // wrap in Consumer to rebuild the MenuAnchor only when opened if game state changes
            return Consumer(
              builder: (context, ref, _) {
                return MenuAnchor(
                  crossAxisUnconstrained: false,
                  style: MenuStyle(
                    maximumSize: WidgetStatePropertyAll(
                      Size(
                        MediaQuery.sizeOf(context).width * 0.6,
                        MediaQuery.sizeOf(context).height * 0.8,
                      ),
                    ),
                  ),
                  builder:
                      (context, controller, _) => AppBarIconButton(
                        icon: const Icon(Icons.more_horiz),
                        semanticsLabel: context.l10n.menu,
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                      ),
                  menuChildren: [
                    if (id != null)
                      MenuItemButton(
                        leadingIcon: const Icon(Icons.settings),
                        semanticsLabel: context.l10n.settingsSettings,
                        child: Text(context.l10n.settingsSettings),
                        onPressed:
                            () => showAdaptiveBottomSheet<void>(
                              context: context,
                              isDismissible: true,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (_) => GameSettings(id: id!),
                            ),
                      ),
                    const ToggleSoundMenuItemButton(),
                    if (id != null)
                      GameBookmarkMenuItemButton(
                        id: id!.gameId,
                        bookmarked: isBookmarkedAsync.valueOrNull ?? false,
                        onToggleBookmark:
                            () => ref.read(gameControllerProvider(id!).notifier).toggleBookmark(),
                        gameListContext: gameListContext,
                      ),
                    if (id != null)
                      ...(switch (ref.watch(gameControllerProvider(id!))) {
                        AsyncData(:final value) => makeGameShareMenuItems(
                          context,
                          ref,
                          game: value.game,
                          orientation: value.game.youAre ?? Side.white,
                          currentGamePosition: value.game.positionAt(value.stepCursor),
                          lastMove: value.game.moveAt(value.stepCursor),
                        ),
                        _ => [],
                      }),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _LobbyGameTitle extends ConsumerWidget {
  const _LobbyGameTitle({required this.seek});

  final GameSeek seek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = seek.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(seek.perf.icon, color: DefaultTextStyle.of(context).style.color),
        const SizedBox(width: 4.0),
        Text('${seek.timeIncrement?.display}$mode'),
      ],
    );
  }
}

class _ChallengeGameTitle extends ConsumerWidget {
  const _ChallengeGameTitle({required this.challenge});

  final ChallengeRequest challenge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = challenge.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(challenge.perf.icon, color: DefaultTextStyle.of(context).style.color),
        const SizedBox(width: 4.0),
        if (challenge.timeIncrement != null)
          Text('${challenge.timeIncrement?.display}$mode')
        else if (challenge.days != null)
          Text('${context.l10n.nbDays(challenge.days!)}$mode'),
      ],
    );
  }
}

class _StandaloneGameTitle extends ConsumerWidget {
  const _StandaloneGameTitle({required this.id, this.lastMoveAt});

  final GameFullId id;

  final DateTime? lastMoveAt;

  static final _gameTitledateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaAsync = ref.watch(gameMetaProvider(id));
    return metaAsync.when(
      data: (meta) {
        final mode = meta.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';

        final info = lastMoveAt != null ? ' • ${_gameTitledateFormat.format(lastMoveAt!)}' : mode;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(meta.perf.icon, color: DefaultTextStyle.of(context).style.color),
            const SizedBox(width: 4.0),
            if (meta.clock != null)
              Flexible(
                child: AutoSizeText(
                  '${TimeIncrement(meta.clock!.initial.inSeconds, meta.clock!.increment.inSeconds).display}$info',
                  maxLines: 1,
                  minFontSize: 14.0,
                ),
              )
            else if (meta.daysPerTurn != null)
              Flexible(
                child: AutoSizeText(
                  '${context.l10n.nbDays(meta.daysPerTurn!)}$info',
                  maxLines: 1,
                  minFontSize: 14.0,
                ),
              )
            else
              Flexible(
                child: AutoSizeText('${meta.perf.title}$info', maxLines: 1, minFontSize: 14.0),
              ),
          ],
        );
      },
      loading:
          () => Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: SizedBox(
                height: 24.0,
                width: 200.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
      error: (error, _) => const SizedBox.shrink(),
    );
  }
}
