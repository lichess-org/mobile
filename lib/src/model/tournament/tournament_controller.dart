import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/chat/chat_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/model/tv/tv_socket_events.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_controller.freezed.dart';
part 'tournament_controller.g.dart';

final _logger = Logger('TournamentController');

@riverpod
class TournamentController extends _$TournamentController {
  StreamSubscription<SocketEvent>? _socketSubscription;

  SocketClient? _socketClient;

  // If we join/leave too often, the server blocks us from joining, see [TournamentMe.pauseDelay].
  // However, there's no "reload" event from the socket once we're able to join again,
  // so we manually have to set this timer to schedule a reload once we can join again.
  Timer? _pauseDelayTimer;

  Timer? _reloadTimer;

  static Uri socketUri(TournamentId id) => Uri(path: '/tournament/$id/socket/v6');

  SocketPool get _socketPool => ref.read(socketPoolProvider);

  @override
  Future<TournamentState> build(TournamentId id) async {
    ref.onDispose(() {
      _socketSubscription?.cancel();
      _pauseDelayTimer?.cancel();
      _reloadTimer?.cancel();
    });

    final tournament = await ref.read(tournamentRepositoryProvider).getTournament(id);

    _socketClient = _socketPool.open(socketUri(id), version: tournament.socketVersion);
    _socketSubscription?.cancel();
    _socketSubscription = _socketClient!.stream.listen(_handleSocketEvent);

    final countdown = tournament.timeToStart ?? tournament.timeToFinish;
    if (countdown != null && countdown.$1 > Duration.zero) {
      _reloadTimer?.cancel();
      _reloadTimer = Timer(countdown.$1, () {
        if (state.hasValue) {
          ref.invalidateSelf();
        }
      });
    }

    _watchFeaturedGameIfChanged(previous: null, current: tournament.featuredGame?.id);

    return TournamentState(tournament: tournament, standingsPage: 1);
  }

  void onFocusRegained() {
    final currentClient = ref.read(socketPoolProvider).currentClient;
    if (currentClient.route != _socketClient?.route) {
      ref.invalidateSelf();
    }
  }

  void _watchFeaturedGameIfChanged({required GameId? previous, required GameId? current}) {
    if (current != null && previous != current) {
      _socketClient?.send('startWatching', current.value);
    }
  }

  void loadNextStandingsPage() {
    if (state.hasValue) {
      _reload(standingsPage: state.requireValue.standingsPage + 1);
    }
  }

  void loadPreviousStandingsPage() {
    if (state.hasValue) {
      _reload(standingsPage: state.requireValue.standingsPage - 1);
    }
  }

  void loadFirstStandingsPage() {
    _reload(standingsPage: 1);
  }

  int _pageOf(int page) => page ~/ kStandingsPageSize + 1;

  void loadLastStandingsPage() {
    if (state.hasValue) {
      _reload(standingsPage: _pageOf(state.requireValue.tournament.nbPlayers));
    }
  }

  void jumpToMyPage() {
    if (state.valueOrNull?.tournament.me != null) {
      _reload(standingsPage: _pageOf(state.requireValue.tournament.me!.rank));
    }
  }

  Future<void> _reload({required int standingsPage}) async {
    _logger.fine('Refreshing tournament standings page $standingsPage');

    if (!state.hasValue) {
      return;
    }

    final tournament = await ref
        .read(tournamentRepositoryProvider)
        .reload(state.requireValue.tournament, standingsPage: standingsPage);

    if (tournament.me?.pauseDelay != null) {
      _pauseDelayTimer?.cancel();
      _pauseDelayTimer = Timer(tournament.me!.pauseDelay!, () {
        _reload(standingsPage: standingsPage);
      });
    }

    _watchFeaturedGameIfChanged(
      previous: state.requireValue.featuredGame?.id,
      current: tournament.featuredGame?.id,
    );

    state = AsyncValue.data(
      state.requireValue.copyWith(tournament: tournament, standingsPage: standingsPage),
    );
  }

  void _handleSocketEvent(SocketEvent event) {
    _logger.fine('Received socket event: $event');

    if (!state.hasValue) {
      return;
    }

    switch (event.topic) {
      case 'reload':
        _reload(standingsPage: state.requireValue.standingsPage);

      case 'fen':
        final json = event.data as Map<String, dynamic>;
        final fenEvent = FenSocketEvent.fromJson(json);

        final oldState = state.requireValue;

        if (fenEvent.id == oldState.featuredGame?.id) {
          state = AsyncValue.data(
            oldState.copyWith(
              tournament: oldState.tournament.copyWith(
                featuredGame: oldState.featuredGame!.copyWith(
                  fen: fenEvent.fen,
                  lastMove: fenEvent.lastMove,
                  clocks: (white: fenEvent.whiteClock, black: fenEvent.blackClock),
                ),
              ),
            ),
          );
        }

      case 'finish':
        final json = event.data as Map<String, dynamic>;
        final finishEvent = FinishSocketEvent.fromJson(json);

        final oldState = state.requireValue;
        if (finishEvent.id == oldState.featuredGame?.id) {
          state = AsyncValue.data(
            oldState.copyWith(
              tournament: oldState.tournament.copyWith(
                featuredGame: oldState.featuredGame!.copyWith(
                  clocks: null,
                  winner: finishEvent.winner,
                ),
              ),
            ),
          );
        }
    }
  }

  void joinOrPause() {
    final state = this.state.valueOrNull;
    if (state == null) {
      return;
    }

    if (state.joined) {
      ref.read(tournamentRepositoryProvider).withdraw(state.id);
    } else {
      ref.read(tournamentRepositoryProvider).join(state.id);
    }
  }
}

@freezed
sealed class TournamentState with _$TournamentState {
  const TournamentState._();

  const factory TournamentState({required Tournament tournament, required int standingsPage}) =
      _TournamentState;

  String get name => tournament.meta.fullName;
  TournamentId get id => tournament.id;

  GameFullId? get currentGame => tournament.me?.gameId;

  FeaturedGame? get featuredGame => tournament.featuredGame;

  bool get canJoin =>
      tournament.me?.pauseDelay == null &&
      tournament.verdicts.accepted &&
      tournament.isFinished != true;

  int get firstRankOfPage => (standingsPage - 1) * kStandingsPageSize + 1;
  bool get hasPreviousPage => standingsPage > 1;
  bool get hasNextPage => tournament.nbPlayers > standingsPage * kStandingsPageSize;

  /// True if the user has joined the tournament.
  bool get hasJoined => tournament.me != null;

  /// True if the user has joined the tournament and is not withdrawn.
  bool get joined => tournament.me != null && tournament.me!.withdraw != true;

  ChatOptions? get chatOptions =>
      tournament.chat != null
          ? TournamentChatOptions(id: tournament.id, writeable: tournament.chat!.writeable)
          : null;
}
