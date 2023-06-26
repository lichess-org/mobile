import 'package:flutter_test/flutter_test.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/game/game_status.dart';

void main() {
  test('can decode status name', () {
    final gameStatus = Pick('mate').asGameStatusOrThrow();
    expect(gameStatus, GameStatus.mate);
  });

  test('can decode status object', () {
    final gameStatus = Pick({'id': 30, 'name': 'mate'}).asGameStatusOrThrow();
    expect(gameStatus, GameStatus.mate);
  });
}
