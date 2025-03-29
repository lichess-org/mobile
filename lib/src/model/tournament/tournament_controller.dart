import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_controller.freezed.dart';
part 'tournament_controller.g.dart';

final _logger = Logger('TournamentController');

@riverpod
class TournamentController extends _$TournamentController {
  StreamSubscription<SocketEvent>? _socketSubscription;

  late SocketClient _socketClient;

  // If we join/leave too often, the server blocks us from joining, see [TournamentMe.pauseDelay].
  // However, there's no "reload" event from the socket once we're able to join again,
  // so we manually have to set this timer to schedule a reload once we can join again.
  Timer? _pauseDelayTimer;

  @override
  Future<TournamentState> build(TournamentId id) async {
    ref.onDispose(() {
      _socketSubscription?.cancel();
      _pauseDelayTimer?.cancel();
    });

    final state = await _loadTournament(id, standingsPage: 1);

    final socketPool = ref.watch(socketPoolProvider);
    _socketClient = socketPool.open(Uri(path: '/tournament/$id/socket/v6'));

    _socketSubscription?.cancel();
    _socketSubscription = _socketClient.stream.listen(_handleSocketEvent);

    return state;
  }

  Future<TournamentState> _loadTournament(TournamentId id, {required int standingsPage}) async {
    final tournament = await ref
        .read(tournamentRepositoryProvider)
        .getTournament(id, standingsPage: standingsPage);
    return TournamentState(tournament: tournament, standingsPage: standingsPage);
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

    state = AsyncValue.data(
      state.requireValue.copyWith(tournament: tournament, standingsPage: standingsPage),
    );
  }

  void _handleSocketEvent(SocketEvent event) {
    _logger.fine('Received socket event: $event');
    if (!state.hasValue) {
      assert(false, 'received a game SocketEvent while TournamentState is null');
      return;
    }

    switch (event.topic) {
      case 'reload':
        _reload(standingsPage: state.requireValue.standingsPage);
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
class TournamentState with _$TournamentState {
  const TournamentState._();

  const factory TournamentState({required Tournament tournament, required int standingsPage}) =
      _TournamentState;

  String get name => tournament.fullName;
  TournamentId get id => tournament.id;

  GameFullId? get currentGame => tournament.me?.gameId;

  bool get canJoin => tournament.me?.pauseDelay == null;

  int get firstRankOfPage => (standingsPage - 1) * kStandingsPageSize + 1;
  bool get hasPreviousPage => standingsPage > 1;
  bool get hasNextPage => tournament.nbPlayers > standingsPage * kStandingsPageSize;

  bool get joined => tournament.me != null && tournament.me!.withdraw != true;
}
