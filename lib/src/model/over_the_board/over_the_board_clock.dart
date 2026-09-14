import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/local_game_clock.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_preferences.dart';

final overTheBoardClockProvider =
    NotifierProvider.autoDispose<OverTheBoardClock, LocalGameClockState>(
      OverTheBoardClock.new,
      name: 'OverTheBoardClockProvider',
    );

class OverTheBoardClock() extends LocalGameClock {
  @override
  TimeIncrement get defaultTimeIncrement => OverTheBoardPrefs.defaults.timeIncrement;
}
