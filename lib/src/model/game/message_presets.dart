import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';

enum PresetMessageGroup {
  start,
  end;

  static PresetMessageGroup? fromGame(PlayableGame game) {
    if (game.status.value <= GameStatus.mate.value && game.steps.length < 4) {
      return start;
    } else if (game.status.value >= GameStatus.mate.value) {
      return end;
    } else {
      return null;
    }
  }
}

typedef PresetMessage = ({String label, String value});
