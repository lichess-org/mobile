import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A provider that fetches the current user's account information.
final accountProvider = FutureProvider.autoDispose<User?>((Ref ref) {
  final session = ref.watch(authSessionProvider);
  if (session == null) return null;
  return ref.read(accountRepositoryProvider).getProfile();
}, name: 'AccountProvider');

/// A provider that fetches the current user's kid mode status.
final kidModeProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(accountProvider.selectAsync((user) => user?.kid ?? false));
}, name: 'KidModeProvider');

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final client = ref.read(lichessClientProvider);
  final aggregator = ref.read(aggregatorProvider);
  return AccountRepository(client, aggregator);
}, name: 'AccountRepositoryProvider');

class AccountRepository {
  AccountRepository(this.client, this.aggregator);

  final LichessClient client;
  final Aggregator aggregator;

  Future<User> getProfile() {
    return aggregator.readJson(
      Uri(path: '/api/account', queryParameters: {'playban': '1'}),
      atomicMapper: User.fromServerJson,
      aggregatedMapper: (json) =>
          User.fromServerJson(json as Map<String, dynamic>),
    );
  }

  Future<void> saveProfile(Map<String, String> profile) async {
    final uri = Uri(path: '/account/profile');
    await client.postRead(
      uri,
      headers: {'Accept': 'application/json'},
      body: profile,
    );
  }

  Future<IList<OngoingGame>> getOngoingGames({int? nb}) {
    return aggregator.readJson(
      Uri(
        path: '/api/account/playing',
        queryParameters: nb != null ? {'nb': nb.toString()} : null,
      ),
      atomicMapper: ongoingGamesFromServerJson,
      aggregatedMapper: (json) {
        if (json is! List<dynamic>) {
          throw Exception('Could not read json object as {nowPlaying: []}');
        }
        return json
            .map((e) => OngoingGame.fromServerJson(e as Map<String, dynamic>))
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

    await client.postRead(uri, body: {prefKey: pref.toFormData});
  }

  /// Bookmark the game for the given `id` if `bookmark` is true else unbookmark it
  Future<void> bookmark(GameId id, {required bool bookmark}) async {
    final uri = Uri(
      path: '/bookmark/$id',
      queryParameters: {'v': bookmark ? '1' : '0'},
    );
    await client.postRead(uri);
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
    message: Message.fromInt(pick('message').asIntOrThrow()),
  );
}
