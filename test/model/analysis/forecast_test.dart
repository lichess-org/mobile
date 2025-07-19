import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/forecast.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';

void main() {
  final kingsPawn = UciPath.fromUciMoves(['e2e4']);
  final kingsPawnGame = UciPath.fromUciMoves(['e2e4', 'e7e5']);
  final kingsKnight = UciPath.fromUciMoves(['e2e4', 'e7e5', 'g1f3']);
  final queensPawn = UciPath.fromUciMoves(['d2d4']);
  final queensPawnGame = UciPath.fromUciMoves(['d2d4', 'd7d5']);
  final sicilian = UciPath.fromUciMoves(['e2e4', 'c7c5']);
  final centerGame = UciPath.fromUciMoves(['e2e4', 'e7e5', 'd2d4']);

  group('adding a line', () {
    void expectNoCollision(Forecast forecast, UciPath firstPath, UciPath secondPath) => expect(
      forecast.add(firstPath).add(secondPath),
      forecast.copyWith(lines: [secondPath, firstPath].lock),
    );

    void expectCollision(Forecast forecast, UciPath firstPath, UciPath secondPath) => expect(
      forecast.add(firstPath).add(secondPath),
      forecast.copyWith(lines: [secondPath].lock),
    );

    test('extending an existing forecast', () {
      expect(
        Forecast(
          onMyTurn: false,
          lines: [queensPawnGame, kingsPawnGame].lock,
        ).add(UciPath.join(kingsPawnGame, UciPath.fromUciMoves(['g1f3', 'b8c6']))),
        Forecast(
          onMyTurn: false,
          lines: [
            UciPath.join(kingsPawnGame, UciPath.fromUciMoves(['g1f3', 'b8c6'])),
            queensPawnGame,
          ].lock,
        ),
      );
    });

    group("on the current player's turn:", () {
      const forecast = Forecast(onMyTurn: true, lines: IList.empty());
      test('single-ply forecasts cannot collide', () {
        expectNoCollision(forecast, kingsPawn, queensPawn);
        expectNoCollision(forecast, queensPawn, kingsPawn);
      });
      test('forecasts with the first divergence on an even index >= 2 collide', () {
        expectCollision(forecast, centerGame, kingsKnight);
        expectCollision(forecast, kingsKnight, centerGame);
      });
    });

    group("on the other player's turn:", () {
      const forecast = Forecast(onMyTurn: false, lines: IList.empty());
      test('forecasts with the first divergence on an odd index collide', () {
        expectCollision(forecast, kingsPawnGame, sicilian);
      });
      test('forecasts with a divergence on an even ply do not collide', () {
        expectNoCollision(forecast, queensPawnGame, kingsPawnGame);
        expectNoCollision(forecast, kingsPawnGame, queensPawnGame);
      });
    });
  });

  group('isCandidate', () {
    final forecastWithKingsPawnGame = Forecast(onMyTurn: true, lines: [kingsPawnGame].lock);

    test('prefixes of existing lines are not candidates', () {
      expect(forecastWithKingsPawnGame.isCandidate(kingsPawnGame), false);
    });
    test('extensions of existing lines are candidates', () {
      expect(forecastWithKingsPawnGame.isCandidate(kingsKnight), true);
    });
    test('divergent lines are candidates', () {
      expect(forecastWithKingsPawnGame.isCandidate(queensPawnGame), true);
    });
    test('empty lines are not candidates', () {
      expect(forecastWithKingsPawnGame.isCandidate(UciPath.empty), false);
    });
    group("on the current player's turn", () {
      test('single-ply lines are candidates', () {
        expect(forecastWithKingsPawnGame.isCandidate(queensPawn), true);
      });
    });
    group("on the other player's turn", () {
      final forecastNotMyTurn = forecastWithKingsPawnGame.copyWith(onMyTurn: false);
      test('single-ply lines are not candidates', () {
        expect(forecastNotMyTurn.isCandidate(queensPawn), false);
      });
      test('double-ply lines are candidates', () {
        expect(forecastNotMyTurn.isCandidate(queensPawnGame), true);
      });
    });
  });
}
