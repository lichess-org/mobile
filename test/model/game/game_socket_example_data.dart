import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

typedef FullEventTestClock = ({
  bool running,
  Duration initial,
  Duration increment,
  Duration? emerg,
  Duration white,
  Duration black,
});

String makeFullEvent(
  GameId id,
  String pgn, {
  required String whiteUserName,
  required String blackUserName,
  int socketVersion = 0,
  Side? youAre,
  FullEventTestClock clock = const (
    running: false,
    initial: Duration(minutes: 3),
    increment: Duration(seconds: 2),
    emerg: Duration(seconds: 30),
    white: Duration(minutes: 3),
    black: Duration(minutes: 3),
  ),
}) {
  final youAreStr = youAre != null ? '"youAre": "${youAre.name}",' : '';
  return '''
{
  "t": "full",
  "d": {
    "game": {
      "id": "$id",
        "variant": {
          "key": "standard",
          "name": "Standard",
          "short": "Std"
        },
        "speed": "blitz",
        "perf": "blitz",
        "rated": false,
        "source": "lobby",
        "status": {
          "id": 20,
          "name": "started"
        },
        "createdAt": 1685698678928,
        "pgn": "$pgn"
    },
    "white": {
      "user": {
        "name": "$whiteUserName",
        "patron": true,
        "id": "${whiteUserName.toLowerCase()}"
      },
      "rating": 1806,
      "provisional": true,
      "onGame": true
    },
    "black": {
      "user": {
        "name": "$blackUserName",
        "patron": true,
        "id": "${blackUserName.toLowerCase()}"
      },
      "onGame": true
    },
    $youAreStr
    "socket": $socketVersion,
    "clock": {
      "running": ${clock.running},
      "initial": ${clock.initial.inSeconds},
      "increment": ${clock.increment.inSeconds},
      "white": ${(clock.white.inMilliseconds / 1000).toStringAsFixed(2)},
      "black": ${(clock.black.inMilliseconds / 1000).toStringAsFixed(2)},
      "emerg": 30,
      "moretime": 15
    },
    "expiration": {
      "idleMillis": 245,
      "millisToMove": 30000
    },
    "chat": {
      "lines": [
        {
          "u": "Zidrox",
          "t": "Good luck",
          "f": "people.man-singer"
        },
        {
          "u": "lichess",
          "t": "Takeback accepted",
          "f": "activity.lichess"
        }
      ]
    }
  },
  "v": $socketVersion
}
''';
}
