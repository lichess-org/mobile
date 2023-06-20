import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';

void main() {
  test('decode game from websocket json', () {
    final json = jsonDecode(_gameJson) as Map<String, dynamic>;
    final game = PlayableGame.fromWebSocketJson(json);
    expect(game.data.id, const GameId('nV3DaALy'));
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
  }
}
''';
