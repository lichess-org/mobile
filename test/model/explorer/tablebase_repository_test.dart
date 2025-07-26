import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  group('TablebaseRepository.getTablebase', () {
    test('parse json', () async {
      const response = '''
{
    "checkmate": false,
    "stalemate": false,
    "variant_win": false,
    "variant_loss": false,
    "insufficient_material": false,
    "dtz": 63,
    "precise_dtz": 63,
    "dtm": null,
    "dtw": null,
    "dtc": null,
    "category": "win",
    "moves": [{
        "uci": "h3h4",
        "san": "Kh4",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": -62,
        "precise_dtz": -62,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "loss"
    }, {
        "uci": "h3g4",
        "san": "Kg4",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": -68,
        "precise_dtz": -68,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "loss"
    }, {
        "uci": "h3g2",
        "san": "Kg2",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": 0,
        "precise_dtz": 0,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "draw"
    }, {
        "uci": "h3h2",
        "san": "Kh2",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": 0,
        "precise_dtz": 0,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "draw"
    }, {
        "uci": "g3f1",
        "san": "Nf1",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": 1,
        "precise_dtz": 1,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "win"
    }, {
        "uci": "g3h1",
        "san": "Nh1",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": 1,
        "precise_dtz": 1,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "win"
    }, {
        "uci": "g3e2",
        "san": "Ne2",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": 1,
        "precise_dtz": 1,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "win"
    }, {
        "uci": "g3e4",
        "san": "Ne4",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": 1,
        "precise_dtz": 1,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "win"
    }, {
        "uci": "g3h5",
        "san": "Nh5",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": 1,
        "precise_dtz": 1,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "win"
    }]
}
      ''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/standard') {
          return mockResponse(response, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);

      final repo = TablebaseRepository(client);

      final result = await repo.getTablebaseEntry('4k3/8/4q3/4PR2/5P2/6NK/8/8 w - - 3 131');
      expect(result, isA<TablebaseEntry>());
      expect(result.moves.length, 9);
      expect(result.checkmate, false);
      expect(result.stalemate, false);
      expect(result.category, TablebaseCategory.win);
      expect(result.dtz, 63);
      expect(result.dtm, null);

      final firstMove = result.moves[0];
      expect(firstMove.uci, 'h3h4');
      expect(firstMove.san, 'Kh4');
      expect(firstMove.category, TablebaseCategory.loss);
      expect(firstMove.dtz, -62);
      expect(firstMove.checkmate, false);
      expect(firstMove.stalemate, false);
      expect(firstMove.zeroing, false);

      final drawMove = result.moves[2];
      expect(drawMove.uci, 'h3g2');
      expect(drawMove.san, 'Kg2');
      expect(drawMove.category, TablebaseCategory.draw);
      expect(drawMove.dtz, 0);

      final winMove = result.moves[4];
      expect(winMove.uci, 'g3f1');
      expect(winMove.san, 'Nf1');
      expect(winMove.category, TablebaseCategory.win);
      expect(winMove.dtz, 1);
    });
  });
}
