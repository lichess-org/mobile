import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_preferences.freezed.dart';
part 'opening_explorer_preferences.g.dart';

@Riverpod(keepAlive: true)
class OpeningExplorerPreferences extends _$OpeningExplorerPreferences
    with SessionPreferencesStorage<OpeningExplorerPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.openingExplorer;

  @override
  OpeningExplorerPrefs defaults({LightUser? user}) => OpeningExplorerPrefs.defaults(user: user);

  @override
  OpeningExplorerPrefs fromJson(Map<String, dynamic> json) => OpeningExplorerPrefs.fromJson(json);

  @override
  OpeningExplorerPrefs build() {
    return fetch();
  }

  Future<void> setDatabase(OpeningDatabase db) => save(state.copyWith(db: db));

  Future<void> setMasterDbSince(int year) =>
      save(state.copyWith(masterDb: state.masterDb.copyWith(sinceYear: year)));

  Future<void> toggleLichessDbSpeed(Speed speed) => save(
    state.copyWith(
      lichessDb: state.lichessDb.copyWith(
        speeds:
            state.lichessDb.speeds.contains(speed)
                ? state.lichessDb.speeds.remove(speed)
                : state.lichessDb.speeds.add(speed),
      ),
    ),
  );

  Future<void> toggleLichessDbRating(int rating) => save(
    state.copyWith(
      lichessDb: state.lichessDb.copyWith(
        ratings:
            state.lichessDb.ratings.contains(rating)
                ? state.lichessDb.ratings.remove(rating)
                : state.lichessDb.ratings.add(rating),
      ),
    ),
  );

  Future<void> setLichessDbSince(DateTime since) =>
      save(state.copyWith(lichessDb: state.lichessDb.copyWith(since: since)));

  Future<void> setPlayerDbUsernameOrId(String username) =>
      save(state.copyWith(playerDb: state.playerDb.copyWith(username: username)));

  Future<void> setPlayerDbSide(Side side) =>
      save(state.copyWith(playerDb: state.playerDb.copyWith(side: side)));

  Future<void> togglePlayerDbSpeed(Speed speed) => save(
    state.copyWith(
      playerDb: state.playerDb.copyWith(
        speeds:
            state.playerDb.speeds.contains(speed)
                ? state.playerDb.speeds.remove(speed)
                : state.playerDb.speeds.add(speed),
      ),
    ),
  );

  Future<void> togglePlayerDbGameMode(GameMode gameMode) => save(
    state.copyWith(
      playerDb: state.playerDb.copyWith(
        gameModes:
            state.playerDb.gameModes.contains(gameMode)
                ? state.playerDb.gameModes.remove(gameMode)
                : state.playerDb.gameModes.add(gameMode),
      ),
    ),
  );

  Future<void> setPlayerDbSince(DateTime since) =>
      save(state.copyWith(playerDb: state.playerDb.copyWith(since: since)));
}

@Freezed(fromJson: true, toJson: true)
sealed class OpeningExplorerPrefs with _$OpeningExplorerPrefs implements Serializable {
  const OpeningExplorerPrefs._();

  const factory OpeningExplorerPrefs({
    required OpeningDatabase db,
    required MasterDb masterDb,
    required LichessDb lichessDb,
    required PlayerDb playerDb,
  }) = _OpeningExplorerPrefs;

  factory OpeningExplorerPrefs.defaults({LightUser? user}) => OpeningExplorerPrefs(
    db: OpeningDatabase.master,
    masterDb: MasterDb.defaults,
    lichessDb: LichessDb.defaults,
    playerDb: PlayerDb.defaults(user: user),
  );

  factory OpeningExplorerPrefs.fromJson(Map<String, dynamic> json) {
    return _$OpeningExplorerPrefsFromJson(json);
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class MasterDb with _$MasterDb {
  const MasterDb._();

  const factory MasterDb({required int sinceYear}) = _MasterDb;

  static const kEarliestYear = 1952;
  static final now = DateTime.now();
  static final datesMap = {
    'Last 3 years': now.year - 3,
    'Last 10 years': now.year - 10,
    'Last 20 years': now.year - 20,
    'All time': kEarliestYear,
  };
  static const defaults = MasterDb(sinceYear: kEarliestYear);

  factory MasterDb.fromJson(Map<String, dynamic> json) {
    return _$MasterDbFromJson(json);
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class LichessDb with _$LichessDb {
  const LichessDb._();

  const factory LichessDb({
    required ISet<Speed> speeds,
    required ISet<int> ratings,
    required DateTime since,
  }) = _LichessDb;

  static const kAvailableSpeeds = ISetConst({
    Speed.ultraBullet,
    Speed.bullet,
    Speed.blitz,
    Speed.rapid,
    Speed.classical,
    Speed.correspondence,
  });
  static const kAvailableRatings = ISetConst({400, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2500});
  static final earliestDate = DateTime.utc(2012, 12);
  static final now = DateTime.now();
  static const kDaysInAYear = 365;
  static final datesMap = {
    'Last year': now.subtract(const Duration(days: kDaysInAYear)),
    'Last 5 years': now.subtract(const Duration(days: kDaysInAYear * 5)),
    'All time': earliestDate,
  };
  static final defaults = LichessDb(
    speeds: kAvailableSpeeds.remove(Speed.ultraBullet),
    ratings: kAvailableRatings.remove(400),
    since: earliestDate,
  );

  factory LichessDb.fromJson(Map<String, dynamic> json) {
    return _$LichessDbFromJson(json);
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class PlayerDb with _$PlayerDb {
  const PlayerDb._();

  const factory PlayerDb({
    String? username,
    required Side side,
    required ISet<Speed> speeds,
    required ISet<GameMode> gameModes,
    required DateTime since,
  }) = _PlayerDb;

  static const kAvailableSpeeds = ISetConst({
    Speed.ultraBullet,
    Speed.bullet,
    Speed.blitz,
    Speed.rapid,
    Speed.classical,
    Speed.correspondence,
  });
  static final earliestDate = DateTime.utc(2012, 12);
  static final now = DateTime.now();
  static final datesMap = {
    'This month': now,
    'Last month': now.subtract(const Duration(days: 32)),
    'Last 6 months': now.subtract(const Duration(days: 183)),
    'Last year': now.subtract(const Duration(days: 365)),
    'All time': earliestDate,
  };
  factory PlayerDb.defaults({LightUser? user}) => PlayerDb(
    username: user?.name,
    side: Side.white,
    speeds: kAvailableSpeeds,
    gameModes: GameMode.values.toISet(),
    since: earliestDate,
  );

  factory PlayerDb.fromJson(Map<String, dynamic> json) {
    return _$PlayerDbFromJson(json);
  }
}
