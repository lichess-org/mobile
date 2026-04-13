import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game_board_params.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_numbers.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/game/game_body.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/user/pick_player_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class LobbyScreenLoadingContent extends StatefulWidget {
  const LobbyScreenLoadingContent(this.seek, this.cancelGameCreation);

  final GameSeek seek;
  final Future<void> Function() cancelGameCreation;

  @override
  State<LobbyScreenLoadingContent> createState() => _LobbyScreenLoadingContentState();
}

class _LobbyScreenLoadingContentState extends State<LobbyScreenLoadingContent> {
  Future<void>? _cancelGameCreationFuture;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GameLayout(
        orientation: Side.white,
        boardParams: GameBoardParams.emptyBoard,
        moves: const [],
        boardOverlay: _BoardOverlayCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.mobileWaitingForOpponentToJoin),
              const SizedBox(height: 26.0),
              _GameParamsDisplay.seek(widget.seek),
              //Do not show rating range if the default values (-500, +500) are used
              if (widget.seek.ratingRange != null &&
                  !(widget.seek.ratingRange!.$1 + 1000 == widget.seek.ratingRange!.$2)) ...[
                const SizedBox(height: 8.0),
                RatingPrefAware(
                  child: Text(
                    '${widget.seek.ratingRange!.$1}-${widget.seek.ratingRange!.$2}',
                    style: TextTheme.of(context).titleMedium,
                  ),
                ),
              ],
              const SizedBox(height: 16.0),
              _LobbyNumbers(),
            ],
          ),
        ),
        userActionsBar: BottomBar(
          children: [
            FutureBuilder(
              future: _cancelGameCreationFuture,
              builder: (context, snapshot) {
                return BottomBarButton(
                  onTap: snapshot.connectionState == ConnectionState.waiting
                      ? null
                      : () async {
                          setState(() {
                            _cancelGameCreationFuture = widget.cancelGameCreation();
                          });
                          try {
                            await _cancelGameCreationFuture;
                          } catch (_) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                'Error cancelling game creation',
                                type: SnackBarType.error,
                              );
                            }
                          }
                          if (context.mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                  label: context.l10n.cancel,
                  showLabel: true,
                  icon: CupertinoIcons.xmark,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserChallengeLoadingContent extends StatefulWidget {
  const UserChallengeLoadingContent(this.challenge, this.cancelChallenge);

  final ChallengeRequest challenge;
  final Future<void> Function() cancelChallenge;

  @override
  State<UserChallengeLoadingContent> createState() => _UserChallengeLoadingContentState();
}

class _UserChallengeLoadingContentState extends State<UserChallengeLoadingContent> {
  Future<void>? _cancelChallengeFuture;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GameLayout(
        orientation: Side.white,
        boardParams: GameBoardParams.emptyBoard,
        moves: const [],
        boardOverlay: _BoardOverlayCard(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.waitingForOpponent),
              const SizedBox(height: 16.0),
              UserFullNameWidget(
                user: widget.challenge.destUser,
                style: TextTheme.of(context).titleLarge,
              ),
              const SizedBox(height: 16.0),
              _GameParamsDisplay.challengeRequest(widget.challenge),
            ],
          ),
        ),
        userActionsBar: BottomBar(
          children: [
            FutureBuilder(
              future: _cancelChallengeFuture,
              builder: (context, snapshot) {
                return BottomBarButton(
                  onTap: snapshot.connectionState == ConnectionState.waiting
                      ? null
                      : () async {
                          setState(() {
                            _cancelChallengeFuture = widget.cancelChallenge();
                          });
                          try {
                            await _cancelChallengeFuture;
                          } catch (_) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                'Error cancelling challenge',
                                type: SnackBarType.error,
                              );
                            }
                          }
                          if (context.mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                  label: context.l10n.cancel,
                  showLabel: true,
                  icon: CupertinoIcons.xmark,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OpenChallengeLoadingContent extends ConsumerStatefulWidget {
  const OpenChallengeLoadingContent({
    required this.id,
    required this.challengeRequest,
    required this.cancelChallenge,
  });

  final ChallengeId id;
  final ChallengeRequest challengeRequest;
  final Future<void> Function() cancelChallenge;

  @override
  ConsumerState<OpenChallengeLoadingContent> createState() => _OpenChallengeLoadingContentState();
}

class _OpenChallengeLoadingContentState extends ConsumerState<OpenChallengeLoadingContent> {
  Future<void>? _cancelChallengeFuture;

  @override
  Widget build(BuildContext context) {
    final challengeLink = 'https://$kLichessHost/${widget.id}';
    final authUser = ref.watch(authControllerProvider);

    final qrColor = ref.watch(currentBrightnessProvider) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            child: GameLayout(
              orientation: Side.white,
              boardParams: GameBoardParams.emptyBoard,
              moves: const [],
              boardOverlay: _BoardOverlayCard(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20.0,
                  children: [
                    _GameParamsDisplay.challengeRequest(widget.challengeRequest),
                    Text(context.l10n.toInviteSomeoneToPlayGiveThisUrl),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: challengeLink));
                          if (!context.mounted) return;
                          showSnackBar(context, 'Copied.'); // TODO l10n
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(Icons.copy),
                              ),
                              TextSpan(text: ' $challengeLink'),
                            ],
                          ),
                          style: TextTheme.of(context).bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),

                    Text(context.l10n.theFirstPersonToComeOnThisUrlWillPlayWithYou),

                    if (authUser != null)
                      FilledButton.tonalIcon(
                        onPressed: () => Navigator.of(context).push(
                          PickPlayerScreen.buildRoute(
                            context,
                            title: Text(context.l10n.challengeAFriend),
                            onUserTap: (user) async {
                              // Capture everything that needs BuildContext before the async gap.
                              final rootNav = Navigator.of(context, rootNavigator: true);
                              final directedChallengeReq = widget.challengeRequest.copyWith(
                                destUser: user,
                              );
                              final directedChallengeRoute =
                                  widget.challengeRequest.timeControl ==
                                      ChallengeTimeControlType.clock
                                  ? GameScreen.buildRoute(
                                      context,
                                      source: UserChallengeSource(directedChallengeReq),
                                    )
                                  : null;

                              try {
                                await widget.cancelChallenge();
                              } catch (e) {
                                debugPrint('Error cancelling open challenge: $e');
                              }

                              if (!context.mounted) return;

                              if (directedChallengeRoute != null) {
                                // Invalidate the provider so the new GameScreen creates a
                                // fresh challenge even if the same UserChallengeSource was
                                // used in a previous game (Freezed equality shares providers).
                                ref.invalidate(
                                  gameScreenLoaderProvider(
                                    UserChallengeSource(directedChallengeReq),
                                  ),
                                );
                                // Use pushAndRemoveUntil to clear any old GameScreen from
                                // the stack without removing unrelated routes.
                                rootNav.pushAndRemoveUntil(
                                  directedChallengeRoute,
                                  (route) => route is! ScreenRoute || route.screen is! GameScreen,
                                );
                              } else {
                                await ref
                                    .read(challengeRepositoryProvider)
                                    .create(directedChallengeReq);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.l10n.mobileChallengeCreated.replaceAll('\\n', '\n'),
                                    ),
                                  ),
                                );
                                // Back to home screen
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              }
                            },
                          ),
                        ),
                        label: Text(context.l10n.challengeInviteLichessUser.replaceAll(':', '')),
                        icon: const Icon(Icons.person_search),
                      ),

                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: QrImageView(
                        data: challengeLink,
                        eyeStyle: QrEyeStyle(color: qrColor, eyeShape: QrEyeShape.square),
                        dataModuleStyle: QrDataModuleStyle(
                          color: qrColor,
                          dataModuleShape: QrDataModuleShape.square,
                        ),
                        version: QrVersions.auto,
                        size: 120.0,
                        padding: const EdgeInsets.all(12.0),
                      ),
                    ),

                    Text(context.l10n.orLetYourOpponentScanQrCode),
                  ],
                ),
              ),
            ),
          ),
        ),
        BottomBar(
          children: [
            BottomBarButton(
              label: 'Share challenge URL', // TODO l10n
              onTap: () => launchShareDialog(context, ShareParams(text: challengeLink)),
              showLabel: true,
              icon: Icons.share,
            ),
            FutureBuilder(
              future: _cancelChallengeFuture,
              builder: (context, snapshot) {
                return BottomBarButton(
                  onTap: snapshot.connectionState == ConnectionState.waiting
                      ? null
                      : () async {
                          setState(() {
                            _cancelChallengeFuture = widget.cancelChallenge();
                          });
                          try {
                            await _cancelChallengeFuture;
                          } catch (_) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                'Error cancelling challenge',
                                type: SnackBarType.error,
                              );
                            }
                          }
                          if (context.mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                  label: context.l10n.cancel,
                  showLabel: true,
                  icon: CupertinoIcons.xmark,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _GameParamsDisplay extends StatelessWidget {
  const _GameParamsDisplay({required this.perf, required this.timeIncrement, required this.days});

  _GameParamsDisplay.seek(GameSeek seek)
    : perf = seek.perf,
      timeIncrement = seek.timeIncrement,
      days = seek.days;

  _GameParamsDisplay.challengeRequest(ChallengeRequest challenge)
    : perf = challenge.perf,
      timeIncrement = challenge.timeIncrement,
      days = challenge.days;

  final Perf perf;
  final TimeIncrement? timeIncrement;
  final int? days;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(perf.icon, color: DefaultTextStyle.of(context).style.color),
        const SizedBox(width: 8.0),
        Text(
          timeIncrement?.display ??
              (days != null ? '${context.l10n.daysPerTurn}: $days' : context.l10n.unlimited),
          style: TextTheme.of(context).titleLarge,
        ),
      ],
    );
  }
}

class StandaloneGameLoadingContent extends StatelessWidget {
  const StandaloneGameLoadingContent({this.position, this.userActionsBar, super.key});

  final LoadingPosition? position;
  final Widget? userActionsBar;

  @override
  Widget build(BuildContext context) {
    final lastMove = position?.lastMove;
    return Shimmer(
      child: SafeArea(
        child: GameLayout(
          orientation: position?.orientation ?? Side.white,
          boardParams: GameBoardParams.readonly(
            fen: position?.fen ?? kEmptyFEN,
            variant: Variant.standard,
            pockets: null,
          ),
          lastMove: switch (lastMove) {
            // In crazyhouse games, the "ongoing games" endpoint does not return the correct UCI for crazyhouse games,
            // e.g. instead of P@c4 the UCI will be c4c4.
            // This leads to a "duplicate key" error, since chessground would try to highlight the same square twice.
            // The dropped role does not matter, since we just use it for the square highlight.
            NormalMove(:final from, :final to) when from == to => DropMove(to: to, role: Role.pawn),
            _ => lastMove,
          },
          topTable: const LoadingPlayerWidget(),
          bottomTable: const LoadingPlayerWidget(),
          moves: const [],
          userActionsBar: userActionsBar,
        ),
      ),
    );
  }
}

/// A widget that shows a loading indicator for a player.
///
/// Must be wrapped in a [Shimmer] widget.
class LoadingPlayerWidget extends StatelessWidget {
  const LoadingPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 6,
            child: SizedBox(
              height: 24.0,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const Spacer(),
          Flexible(
            flex: 2,
            child: SizedBox(
              height: 38.0,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadGameError extends StatelessWidget {
  const LoadGameError(this.errorMessage, {this.showBottomBar = true});

  final String errorMessage;
  final bool showBottomBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            child: GameLayout(
              orientation: Side.white,
              boardParams: GameBoardParams.emptyBoard,
              moves: const [],
              errorMessage: errorMessage,
            ),
          ),
        ),
        BottomBar(
          children: [
            if (showBottomBar)
              BottomBarButton(
                onTap: () => Navigator.of(context).pop(),
                label: context.l10n.cancel,
                icon: CupertinoIcons.xmark,
                showLabel: true,
              ),
          ],
        ),
      ],
    );
  }
}

/// A board that shows a message that a challenge has been declined.
class ChallengeDeclinedBoard extends StatelessWidget {
  const ChallengeDeclinedBoard({required this.declineReason, required this.challenge});

  final String declineReason;
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    final textColor = DefaultTextStyle.of(context).style.color;

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            child: GameLayout(
              orientation: Side.white,
              boardParams: GameBoardParams.emptyBoard,
              moves: const [],
              boardOverlay: _BoardOverlayCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.challengeChallengeDeclined,
                      style: TextTheme.of(context).titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Divider(height: 26.0, thickness: 0.0, color: textColor),
                    Text(declineReason, style: const TextStyle(fontStyle: FontStyle.italic)),
                    Divider(height: 26.0, thickness: 0.0, color: textColor),
                    if (challenge.destUser != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(' — '),
                            UserFullNameWidget(user: challenge.destUser?.user),
                            if (challenge.destUser?.lagRating != null) ...[
                              const SizedBox(width: 6.0),
                              LagIndicator(lagRating: challenge.destUser!.lagRating!, size: 13.0),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        BottomBar(
          children: [
            BottomBarButton(
              onTap: () => Navigator.of(context).pop(),
              label: context.l10n.cancel,
              icon: CupertinoIcons.xmark,
              showLabel: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _LobbyNumbers extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobbyNumbers = ref.watch(lobbyNumbersProvider);

    if (lobbyNumbers == null) {
      return Column(
        children: [
          Text(context.l10n.nbPlayers(0).replaceAll('0', '...')),
          const SizedBox(height: 8.0),
          Text(context.l10n.nbGamesInPlay(0).replaceAll('0', '...')),
        ],
      );
    } else {
      final (:nbPlayers, :nbGames) = lobbyNumbers;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.l10n.nbPlayers(nbPlayers).localizeNumbers()),
          const SizedBox(height: 8.0),
          Text(context.l10n.nbGamesInPlay(nbGames).localizeNumbers()),
        ],
      );
    }
  }
}

class _BoardOverlayCard extends StatelessWidget {
  const _BoardOverlayCard({this.padding, required this.child});

  final EdgeInsetsGeometry? padding;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).dialogTheme.backgroundColor,
      elevation: 2.0,
      child: Padding(padding: padding ?? const EdgeInsets.all(30.0), child: child),
    );
  }
}
