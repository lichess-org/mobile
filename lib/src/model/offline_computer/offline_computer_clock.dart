import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/local_game_clock.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_preferences.dart';

final offlineComputerClockProvider =
    NotifierProvider.autoDispose<OfflineComputerClock, LocalGameClockState>(
      OfflineComputerClock.new,
      name: 'OfflineComputerClockProvider',
    );

class OfflineComputerClock extends LocalGameClock {
  @override
  TimeIncrement get defaultTimeIncrement => OfflineComputerGamePrefs.defaults.timeIncrement;
}
