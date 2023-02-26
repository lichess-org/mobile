import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/api_client.dart';

import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import '../../test_utils.dart';

class MockClient extends Mock implements http.Client {}

class MockLogger extends Mock implements Logger {}

void main() {
  final mockLogger = MockLogger();
  final mockClient = MockClient();
  final repo = PuzzleRepository(
    mockLogger,
    apiClient: ApiClient(mockLogger, mockClient),
  );

  setUp(() {
    reset(mockClient);
  });

  test('PuzzleRepository.selectBatch', () async {
    const batchResponse = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}},{"game":{"id":"0lwkiJbZ","perf":{"key":"classical","name":"Classical"},"rated":true,"players":[{"userId":"nirdosh","name":"nirdosh (2035)","color":"white"},{"userId":"burn_it_down","name":"burn_it_down (2139)","color":"black"}],"pgn":"d4 Nf6 Nf3 c5 e3 g6 Bd3 Bg7 c3 Qc7 O-O O-O Nbd2 d6 Qe2 Nbd7 e4 cxd4 cxd4 e5 dxe5 dxe5 b3 Nc5 Bb2 Nh5 g3 Bh3 Rfc1 Qd6 Bc4 Rac8 Bd5 Qb8 Ng5 Bd7 Ba3 b6 Rc2 h6 Ngf3 Rfe8 Rac1 Ne6 Nc4 Bb5 Qe3 Bxc4 Bxc4 Nd4 Nxd4 exd4 Qd3 Rcd8 f4 Nf6 e5 Ng4 Qxg6 Ne3 Bxf7+ Kh8 Rc7 Qa8 Qxg7+ Kxg7 Bd5+ Kg6 Bxa8 Rxa8 Rd7 Rad8 Rc6+ Kf5 Rcd6 Rxd7 Rxd7 Ke4 Bb2 Nc2 Kf2 d3 Bc1 Nd4 h3","clock":"15+15"},"puzzle":{"id":"7H5EV","rating":1852,"plays":410,"initialPly":84,"solution":["e8c8","d7d4","e4d4"],"themes":["endgame","short","advantage"]}},{"game":{"id":"eWGRX5AI","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"sacalot","name":"sacalot (2151)","color":"white"},{"userId":"landitirana","name":"landitirana (1809)","color":"black"}],"pgn":"e4 e5 Nf3 Nc6 d4 exd4 Bc4 Nf6 O-O Nxe4 Re1 d5 Bxd5 Qxd5 Nc3 Qd8 Rxe4+ Be6 Nxd4 Nxd4 Rxd4 Qf6 Ne4 Qe5 f4 Qf5 Ng3 Qa5 Bd2 Qb6 Be3 Bc5 f5 Bd5 Rxd5 Bxe3+ Kh1 O-O Rd3 Rfe8 Qf3 Qxb2 Rf1 Bd4 Nh5 Bf6 Rb3 Qd4 Rxb7 Re3 Nxf6+ gxf6 Qf2 Rae8 Rxc7 Qe5 Rc4 Re1 Rf4 Qa1 h3","clock":"10+0"},"puzzle":{"id":"1qUth","rating":1556,"plays":2661,"initialPly":60,"solution":["e1f1","f2f1","e8e1","f1e1","a1e1"],"themes":["endgame","master","advantage","fork","long","pin"]}}]}
''';
    when(
      () => mockClient.get(
        Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=30'),
      ),
    ).thenAnswer((_) => mockResponse(batchResponse, 200));

    final result = await repo.selectBatch();

    expect(result.isValue, true);
  });
}
