import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_preferences.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_preferences.dart';
import 'package:lichess_mobile/src/model/game/game_preferences.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/settings/home_preferences.dart';
import 'package:lichess_mobile/src/model/settings/over_the_board_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

/// A preference category with its storage key and default values.
enum PrefCategory<T extends SerializablePreferences> {
  general('preferences.general', GeneralPrefs.defaults),
  home('preferences.home', HomePrefs.defaults),
  board('preferences.board', BoardPrefs.defaults),
  analysis('preferences.analysis', AnalysisPrefs.defaults),
  overTheBoard('preferences.overTheBoard', OverTheBoardPrefs.defaults),
  challenge('preferences.challenge', ChallengePrefs.defaults),
  gameSetup('preferences.gameSetup', GameSetupPrefs.defaults),
  game('preferences.game', GamePrefs.defaults),
  coordinateTraining(
    'preferences.coordinateTraining',
    CoordinateTrainingPrefs.defaults,
  ),
  openingExplorer(
    'preferences.opening_explorer',
    null as OpeningExplorerPrefs?,
  ),
  puzzle('preferences.puzzle', null as PuzzlePrefs?),
  broadcast('preferences.broadcast', BroadcastPrefs.defaults);


  const PrefCategory(this.storageKey, this._defaults);

  final String storageKey;
  final T? _defaults;

  T defaults({LightUser? user}) => switch (this) {
        PrefCategory.general => _defaults!,
        PrefCategory.home => _defaults!,
        PrefCategory.board => _defaults!,
        PrefCategory.analysis => _defaults!,
        PrefCategory.overTheBoard => _defaults!,
        PrefCategory.challenge => _defaults!,
        PrefCategory.gameSetup => _defaults!,
        PrefCategory.game => _defaults!,
        PrefCategory.coordinateTraining => _defaults!,
        PrefCategory.openingExplorer =>
          OpeningExplorerPrefs.defaults(user: user) as T,
        PrefCategory.puzzle => PuzzlePrefs.defaults(id: user?.id) as T,
        PrefCategory.broadcast => _defaults!
      };
}

/// Interface for serializable preferences.
abstract class SerializablePreferences {
  Map<String, dynamic> toJson();

  static SerializablePreferences fromJson(
    PrefCategory key,
    Map<String, dynamic> json,
  ) {
    switch (key) {
      case PrefCategory.general:
        return GeneralPrefs.fromJson(json);
      case PrefCategory.home:
        return HomePrefs.fromJson(json);
      case PrefCategory.board:
        return BoardPrefs.fromJson(json);
      case PrefCategory.analysis:
        return AnalysisPrefs.fromJson(json);
      case PrefCategory.overTheBoard:
        return OverTheBoardPrefs.fromJson(json);
      case PrefCategory.challenge:
        return ChallengePrefs.fromJson(json);
      case PrefCategory.gameSetup:
        return GameSetupPrefs.fromJson(json);
      case PrefCategory.game:
        return GamePrefs.fromJson(json);
      case PrefCategory.coordinateTraining:
        return CoordinateTrainingPrefs.fromJson(json);
      case PrefCategory.openingExplorer:
        return OpeningExplorerPrefs.fromJson(json);
      case PrefCategory.puzzle:
        return PuzzlePrefs.fromJson(json);
      case PrefCategory.broadcast:
        return BroadcastPrefs.fromJson(json);
    }
  }
}
