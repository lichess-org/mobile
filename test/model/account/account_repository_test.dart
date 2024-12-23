import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  group('AccountRepository', () {
    test('getPreferences', () async {
      const response = '''
{
  "prefs": {
    "dark": true,
    "transp": false,
    "bgImg": "http://example.com",
    "is3d": false,
    "theme": "blue",
    "pieceSet": "cburnett",
    "theme3d": "Black-White-Aluminium",
    "pieceSet3d": "Basic",
    "soundSet": "silent",
    "blindfold": 0,
    "autoQueen": 2,
    "autoThreefold": 2,
    "takeback": 3,
    "moretime": 3,
    "clockTenths": 1,
    "clockBar": true,
    "clockSound": true,
    "premove": true,
    "animation": 2,
    "captured": true,
    "follow": true,
    "highlight": true,
    "destination": true,
    "coords": 2,
    "replay": 2,
    "challenge": 4,
    "message": 3,
    "coordColor": 2,
    "submitMove": 4,
    "confirmResign": 1,
    "insightShare": 1,
    "keyboardMove": 0,
    "zen": 0,
    "pieceNotation": 0,
    "ratings": 1,
    "moveEvent": 2,
    "rookCastle": 1
  },
  "language": "en-GB"
}
''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/account/preferences') {
          return mockResponse(response, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);
      final repo = AccountRepository(client);
      final result = await repo.getPreferences();

      expect(result, isA<AccountPrefState>());

      expect(result.autoQueen, AutoQueen.premove);
    });
  });
}
