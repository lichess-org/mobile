import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/common/models.dart';

import 'computer_opponent.dart';

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
  defaultValue: DefaultGameClock.blitz5_3,
  mapFrom: (v) => DefaultGameClock.values.firstWhere(
    (e) => v != null && e.value == TimeIncrement.fromString(v),
    orElse: () => DefaultGameClock.blitz5_3,
  ),
  mapTo: (v) => v.value.toString(),
);
