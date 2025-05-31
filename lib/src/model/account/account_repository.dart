import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_repository.g.dart';

@riverpod
Future<User?> account(Ref ref) async {
  final session = ref.watch(authSessionProvider);
  if (session == null) return null;

  return ref.withClient((client) => AccountRepository(client).getProfile());
}

@riverpod
Future<LightUser?> accountUser(Ref ref) async {
  return ref.watch(accountProvider.selectAsync((user) => user?.lightUser));
}

@riverpod
Future<bool> kidMode(Ref ref) async {
  return ref.watch(accountProvider.selectAsync((user) => user?.kid ?? false));
}

/// A provider that fetches the ongoing games for the current user.
@riverpod
class OngoingGames extends _$OngoingGames {
  @override
  Future<IList<OngoingGame>> build() {
    final session = ref.watch(authSessionProvider);
    if (session == null) return Future.value(IList());

    return ref.withClientCacheFor(
      (client) => AccountRepository(client).getOngoingGames(nb: 50),
      // cache is useful to reduce the number of requests to the server because this is used by
      // both the correspondence service to sync games and the home screen to display ongoing games
      const Duration(minutes: 10),
    );
  }

  /// Update the game with the given `id` with the new `game` data.
  ///
  /// If the game is not playable anymore, it will be removed from the list.
  void updateGame(GameFullId id, PlayableGame game) {
    if (!state.hasValue) return;
    final index = state.requireValue.indexWhere((e) => e.fullId == id);
    if (index == -1) return;
    if (!game.playable) {
      state = AsyncData(state.requireValue.removeAt(index));
      return;
    }

    final me = game.youAre ?? Side.white;
    final newGame = OngoingGame(
      id: game.id,
      fullId: id,
      orientation: me,
      fen: game.lastPosition.fen,
      perf: game.meta.perf,
      speed: game.meta.speed,
      variant: game.meta.variant,
      opponent: game.opponent?.user,
      isMyTurn: game.isMyTurn,
      opponentRating: game.opponent?.rating,
      opponentAiLevel: game.opponent?.aiLevel,
      lastMove: game.lastMove,
      secondsLeft:
          game.clock?.forSide(me).inSeconds ?? game.correspondenceClock?.forSide(me).inSeconds,
    );
    state = AsyncData(
      state.requireValue.replace(index, newGame).sort((a, b) {
        if (a.isMyTurn && !b.isMyTurn) return -1;
        if (!a.isMyTurn && b.isMyTurn) return 1;
        return a.secondsLeft?.compareTo(b.secondsLeft ?? 0) ?? 0;
      }),
    );
  }
}

class AccountRepository {
  AccountRepository(this.client);

  final LichessClient client;
  final Logger _log = Logger('AccountRepository');

  Future<User> getProfile() {
    return client.readJson(
      Uri(path: '/api/account', queryParameters: {'playban': '1'}),
      mapper: User.fromServerJson,
    );
  }

  Future<void> saveProfile(Map<String, String> profile) async {
    final uri = Uri(path: '/account/profile');
    final response = await client.post(uri, headers: {'Accept': 'application/json'}, body: profile);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to post save profile: ${response.statusCode}', uri);
    }
  }

  Future<IList<OngoingGame>> getOngoingGames({int? nb}) {
    return client.readJson(
      Uri(path: '/api/account/playing', queryParameters: nb != null ? {'nb': nb.toString()} : null),
      mapper: (Map<String, dynamic> json) {
        final list = json['nowPlaying'];
        if (list is! List<dynamic>) {
          _log.severe('Could not read json object as {nowPlaying: []}: expected a list.');
          throw Exception('Could not read json object as {nowPlaying: []}');
        }
        return list
            .map((e) => _ongoingGameFromJson(e as Map<String, dynamic>))
            .where((e) => e.variant.isPlaySupported)
            .toIList();
      },
    );
  }

  Future<AccountPrefState> getPreferences() {
    return client.readJson(
      Uri(path: '/api/account/preferences'),
      mapper: (Map<String, dynamic> json) {
        return _accountPreferencesFromPick(pick(json, 'prefs').required());
      },
    );
  }

  Future<void> setPreference<T>(String prefKey, AccountPref<T> pref) async {
    final uri = Uri(path: '/api/account/preferences/$prefKey');

    final response = await client.post(uri, body: {prefKey: pref.toFormData});

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to set preference: ${response.statusCode}', uri);
    }
  }

  /// Bookmark the game for the given `id` if `bookmark` is true else unbookmark it
  Future<void> bookmark(GameId id, {required bool bookmark}) async {
    final uri = Uri(path: '/bookmark/$id', queryParameters: {'v': bookmark ? '1' : '0'});
    final response = await client.post(uri);
    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to bookmark game: ${response.statusCode}', uri);
    }
  }
}

AccountPrefState _accountPreferencesFromPick(RequiredPick pick) {
  return (
    zenMode: Zen.fromInt(pick('zen').asIntOrThrow()),
    pieceNotation: PieceNotation.fromInt(pick('pieceNotation').asIntOrThrow()),
    showRatings: ShowRatings.fromInt(pick('ratings').asIntOrThrow()),
    premove: BooleanPref(pick('premove').asBoolOrThrow()),
    autoQueen: AutoQueen.fromInt(pick('autoQueen').asIntOrThrow()),
    autoThreefold: AutoThreefold.fromInt(pick('autoThreefold').asIntOrThrow()),
    takeback: Takeback.fromInt(pick('takeback').asIntOrThrow()),
    moretime: Moretime.fromInt(pick('moretime').asIntOrThrow()),
    clockSound: BooleanPref(pick('clockSound').asBoolOrThrow()),
    confirmResign: BooleanPref.fromInt(pick('confirmResign').asIntOrThrow()),
    submitMove: SubmitMove.fromInt(pick('submitMove').asIntOrThrow()),
    follow: BooleanPref(pick('follow').asBoolOrThrow()),
    challenge: Challenge.fromInt(pick('challenge').asIntOrThrow()),
  );
}

OngoingGame _ongoingGameFromJson(Map<String, dynamic> json) {
  return _ongoingGameFromPick(pick(json).required());
}

OngoingGame _ongoingGameFromPick(RequiredPick pick) {
  return OngoingGame(
    id: GameId(pick('gameId').asStringOrThrow()),
    fullId: GameFullId(pick('fullId').asStringOrThrow()),
    orientation: pick('color').asSideOrThrow(),
    fen: pick('fen').asStringOrThrow(),
    lastMove: pick('lastMove').asUciMoveOrNull(),
    perf: pick('perf').asPerfOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    opponent: pick('opponent').asLightUserOrNull(),
    opponentRating: pick('opponent', 'rating').asIntOrNull(),
    opponentAiLevel: pick('opponent', 'aiLevel').asIntOrNull(),
    secondsLeft: pick('secondsLeft').asIntOrNull(),
    isMyTurn: pick('isMyTurn').asBoolOrThrow(),
  );
}
