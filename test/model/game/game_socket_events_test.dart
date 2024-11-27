import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';

void main() {
  test('decode game full event from websocket json', () {
    final json = jsonDecode(_gameJson) as Map<String, dynamic>;
    final fullEvent = GameFullEvent.fromJson(json);
    final game = fullEvent.game;
    expect(game.id, const GameId('nV3DaALy'));
    expect(
      game.clock?.running,
      true,
    );
    expect(
      game.clock?.white,
      const Duration(seconds: 149, milliseconds: 50),
    );

    expect(
      game.clock?.black,
      const Duration(seconds: 775, milliseconds: 940),
    );
    expect(
      game.meta,
      GameMeta(
        createdAt: DateTime.fromMillisecondsSinceEpoch(1685698678928),
        rated: false,
        variant: Variant.standard,
        speed: Speed.classical,
        perf: Perf.classical,
        clock: (
          initial: const Duration(minutes: 10),
          increment: const Duration(seconds: 30),
          emergency: const Duration(seconds: 60),
          moreTime: const Duration(seconds: 15),
        ),
        daysPerTurn: null,
        startedAtTurn: null,
        rules: null,
        opening: null,
      ),
    );
  });
}

const _gameJson = '''
{
  "game": {
    "id": "nV3DaALy",
      "variant": {
        "key": "standard",
        "name": "Standard",
        "short": "Std"
      },
      "speed": "classical",
      "perf": "classical",
      "rated": false,
      "source": "ai",
      "status": {
        "id": 20,
        "name": "started"
      },
      "createdAt": 1685698678928,
      "pgn": "e4 e6 Nf3 f6"
  },
  "white": {
    "user": {
      "name": "thibault",
      "patron": true,
      "id": "thibault"
    },
    "rating": 1806,
    "provisional": true,
    "onGame": true
  },
  "black": {
    "aiLevel": 2,
    "onGame": true
  },
  "socket": 4,
  "clock": {
    "running": true,
    "initial": 600,
    "increment": 30,
    "white": 149.05,
    "black": 775.94,
    "emerg": 60,
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
}
''';
