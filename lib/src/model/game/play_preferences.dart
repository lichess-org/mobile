import 'package:lichess_mobile/src/common/shared_preferences.dart';

import 'computer_opponent.dart';
import 'time_control.dart';

final computerOpponentPrefProvider = createPrefProvider(
  prefKey: 'play.computerOpponent',
  defaultValue: ComputerOpponent.maia,
  mapFrom: (v) => ComputerOpponent.values.firstWhere(
    (e) => e.toString() == v,
    orElse: () => ComputerOpponent.maia,
  ),
  mapTo: (v) => v.toString(),
);

final stockfishLevelProvider = createPrefProvider(
  prefKey: 'play.stockfishLevel',
  defaultValue: 1,
);

final maiaStrengthProvider = createPrefProvider(
  prefKey: 'play.maiaStrength',
  defaultValue: MaiaStrength.maia1,
  mapFrom: (v) => MaiaStrength.values
      .firstWhere((e) => e.toString() == v, orElse: () => MaiaStrength.maia1),
  mapTo: (v) => v.toString(),
);

final timeControlPrefProvider = createPrefProvider(
  prefKey: 'play.timeControl',
  defaultValue: TimeControl.blitz4,
  mapFrom: (v) => TimeControl.values.firstWhere(
    (e) => v != null && e.value == TimeInc.fromString(v),
    orElse: () => TimeControl.blitz4,
  ),
  mapTo: (v) => v.value.toString(),
);
