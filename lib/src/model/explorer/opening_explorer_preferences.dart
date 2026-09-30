import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'opening_explorer_preferences.freezed.dart';
part 'opening_explorer_preferences.g.dart';

final openingExplorerPreferencesProvider =
    NotifierProvider<OpeningExplorerPreferences, OpeningExplorerPrefs>(
      OpeningExplorerPreferences.new,
      name: 'OpeningExplorerPreferencesProvider',
    );

class OpeningExplorerPreferences()
    extends Notifier<OpeningExplorerPrefs>
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

  Future<void> setMasterDbDates({DateTime? since, DateTime? until}) => save(
    state.copyWith(
      masterDb: state.masterDb.copyWith(since: since, until: until),
    ),
  );

  Future<void> toggleLichessDbSpeed(Speed speed) => save(
    state.copyWith(
      lichessDb: state.lichessDb.copyWith(
        speeds: state.lichessDb.speeds.contains(speed)
            ? state.lichessDb.speeds.remove(speed)
            : state.lichessDb.speeds.add(speed),
      ),
    ),
  );

  Future<void> toggleLichessDbRating(int rating) => save(
    state.copyWith(
      lichessDb: state.lichessDb.copyWith(
        ratings: state.lichessDb.ratings.contains(rating)
            ? state.lichessDb.ratings.remove(rating)
            : state.lichessDb.ratings.add(rating),
      ),
    ),
  );

  Future<void> setLichessDbDates({DateTime? since, DateTime? until}) => save(
    state.copyWith(
      lichessDb: state.lichessDb.copyWith(since: since, until: until),
    ),
  );

  Future<void> setPlayerDbUsernameOrId(String username) =>
      save(state.copyWith(playerDb: state.playerDb.copyWith(username: username)));

  Future<void> setPlayerDbSide(Side side) =>
      save(state.copyWith(playerDb: state.playerDb.copyWith(side: side)));

  Future<void> togglePlayerDbSpeed(Speed speed) => save(
    state.copyWith(
      playerDb: state.playerDb.copyWith(
        speeds: state.playerDb.speeds.contains(speed)
            ? state.playerDb.speeds.remove(speed)
            : state.playerDb.speeds.add(speed),
      ),
    ),
  );

  Future<void> togglePlayerDbGameMode(GameMode gameMode) => save(
    state.copyWith(
      playerDb: state.playerDb.copyWith(
        gameModes: state.playerDb.gameModes.contains(gameMode)
            ? state.playerDb.gameModes.remove(gameMode)
            : state.playerDb.gameModes.add(gameMode),
      ),
    ),
  );

  Future<void> setPlayerDbDates({DateTime? since, DateTime? until}) => save(
    state.copyWith(
      playerDb: state.playerDb.copyWith(since: since, until: until),
    ),
  );
}

@Freezed(fromJson: true, toJson: true)
sealed class const OpeningExplorerPrefs._() with _$OpeningExplorerPrefs implements Serializable {
  const factory({
    required OpeningDatabase db,
    required MasterDb masterDb,
    required LichessDb lichessDb,
    required PlayerDb playerDb,
  }) = _OpeningExplorerPrefs;

  factory defaults({LightUser? user}) => OpeningExplorerPrefs(
    db: OpeningDatabase.master,
    masterDb: MasterDb.defaults,
    lichessDb: LichessDb.defaults,
    playerDb: PlayerDb.defaults(user: user),
  );

  factory fromJson(Map<String, dynamic> json) {
    return _$OpeningExplorerPrefsFromJson(json);
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class const MasterDb._() with _$MasterDb {
  /// Year range of the games, both ends inclusive. Only the year of each date is used. A null bound
  /// means unbounded.
  const factory({DateTime? since, DateTime? until}) = _MasterDb;

  static final earliestDate = DateTime.utc(1952);
  static const defaults = MasterDb();

  factory fromJson(Map<String, dynamic> json) {
    return _$MasterDbFromJson(json);
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class const LichessDb._() with _$LichessDb {
  const factory({
    required ISet<Speed> speeds,
    required ISet<int> ratings,

    /// Month range of the games, both ends inclusive. A null bound means unbounded.
    DateTime? since,
    DateTime? until,
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
  static final defaults = LichessDb(
    speeds: kAvailableSpeeds.remove(Speed.ultraBullet),
    ratings: kAvailableRatings.remove(400),
  );

  factory fromJson(Map<String, dynamic> json) {
    return _$LichessDbFromJson(json);
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class const PlayerDb._() with _$PlayerDb {
  const factory({
    String? username,
    required Side side,
    required ISet<Speed> speeds,
    required ISet<GameMode> gameModes,

    /// Month range of the games, both ends inclusive. A null bound means unbounded.
    DateTime? since,
    DateTime? until,
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
  factory defaults({LightUser? user}) => PlayerDb(
    username: user?.name,
    side: Side.white,
    speeds: kAvailableSpeeds,
    gameModes: GameMode.values.toISet(),
  );

  factory fromJson(Map<String, dynamic> json) {
    return _$PlayerDbFromJson(json);
  }
}
