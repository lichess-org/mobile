import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_providers.g.dart';

@riverpod
Future<IList<LightTournament>> featuredTournaments(Ref ref) {
  return ref.read(tournamentRepositoryProvider).featured();
}

@riverpod
Future<TournamentLists> tournaments(Ref ref) {
  return ref.read(tournamentRepositoryProvider).getTournaments();
}
