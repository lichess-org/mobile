import 'dart:io' show File;

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A provider for [TournamentRepository].
final tournamentRepositoryProvider = Provider<TournamentRepository>((Ref ref) {
  return TournamentRepository(ref.watch(lichessClientProvider), ref.watch(aggregatorProvider), ref);
}, name: 'TournamentRepositoryProvider');

class TournamentRepository {
  TournamentRepository(this.client, this.aggregator, Ref ref) : _ref = ref;

  final Ref _ref;
  final http.Client client;
  final Aggregator aggregator;

  Future<IList<LightTournament>> featured() {
    return aggregator.readJson(
      Uri(path: '/tournament/featured'),
      headers: {'Accept': 'application/json'},
      atomicMapper: (Map<String, dynamic> json) => pick(json, 'featured').asTournamentListOrThrow(),
    );
  }

  Future<TournamentLists> getTournaments() {
    return client.readJson(
      Uri(path: '/api/tournament'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) {
        return (
          started: pick(json, 'started').asTournamentListOrThrow(),
          created: pick(json, 'created').asTournamentListOrThrow(),
          finished: pick(json, 'finished').asTournamentListOrThrow(),
        );
      },
    );
  }

  Future<Tournament> getTournament(TournamentId id) {
    return client.readJson(
      Uri(path: '/api/tournament/$id', queryParameters: {'chat': '1', 'socketVersion': '1'}),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => Tournament.fromServerJson(json),
    );
  }

  Future<TournamentPlayer> getTournamentPlayer(TournamentId tournamentId, UserId userId) {
    return client.readJson(
      Uri(path: '/tournament/$tournamentId/player/$userId'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => TournamentPlayer.fromServerJson(json),
    );
  }

  Future<TournamentTeam> getTournamentTeam(TournamentId tournamentId, TeamId teamId) {
    return client.readJson(
      Uri(path: '/tournament/$tournamentId/team/$teamId'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => TournamentTeam.fromServerJson(json),
    );
  }

  Future<IList<TeamStanding>> getAllTeamStandings(TournamentId id) {
    return client.readJson(
      Uri(path: '/api/tournament/$id/teams'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => pick(json, 'teams').asTeamStandingListOrThrow(),
    );
  }

  Future<bool> downloadTournamentGames(TournamentId id, File file, {UserId? userId}) {
    final client = _ref.read(defaultClientProvider);
    return downloadFile(
      client,
      lichessUri('/api/tournament/$id/games', userId != null ? {'player': userId.value} : null),
      file,
    );
  }

  Future<Tournament> reload(Tournament tournament) {
    return client.readJson(
      Uri(
        path: tournament.reloadEndpoint ?? '/api/tournament/${tournament.id}',
        queryParameters: {
          if (tournament.standing != null) 'page': tournament.standing!.page.toString(),
          'partial': 'true',
        },
      ),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => tournament.updateFromPartialServerJson(json),
    );
  }

  Future<Tournament> loadPage(Tournament tournament, int page) {
    return client.readJson(
      Uri(path: '/tournament/${tournament.id}/standing/$page'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => tournament.updateStandingsFromServerJson(json),
    );
  }

  Future<void> join(TournamentId id, {TeamId? teamId, String? password}) async {
    await client.postRead(
      Uri(path: '/api/tournament/$id/join'),
      body: {if (teamId != null) 'team': teamId.value, if (password != null) 'password': password},
    );
  }

  Future<void> withdraw(TournamentId id) async {
    final uri = Uri(path: '/api/tournament/$id/withdraw');
    await client.postRead(uri);
  }
}
