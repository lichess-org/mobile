import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_providers.g.dart';

@riverpod
Future<TournamentLists> tournaments(Ref ref) {
  return ref.withClient((client) => TournamentRepository(client).getTournaments());
}
