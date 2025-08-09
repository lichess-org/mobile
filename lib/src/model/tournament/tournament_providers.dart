import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_providers.g.dart';

@riverpod
Future<IList<LightTournament>> featuredTournaments(Ref ref) {
  final aggregator = ref.read(aggregatorProvider);
  return aggregator.readJson(
    Uri(path: '/tournament/featured'),
    aggregatedMapper: (json) => pick(json).asTournamentListOrThrow(),
    atomicMapper: (Map<String, dynamic> json) => pick(json, 'featured').asTournamentListOrThrow(),
  );
}

@riverpod
Future<TournamentLists> tournaments(Ref ref) {
  return ref.read(tournamentRepositoryProvider).getTournaments();
}
