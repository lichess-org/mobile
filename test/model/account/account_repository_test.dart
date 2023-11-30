import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthClient extends Mock implements AuthClient {}

class MockLogger extends Mock implements Logger {}

void main() {
  final mockLogger = MockLogger();
  final mockAuthClient = MockAuthClient();
  final repo = AccountRepository(apiClient: mockAuthClient, logger: mockLogger);

  setUpAll(() {
    reset(mockAuthClient);
  });

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
    "ratings": 1,
    "moveEvent": 2,
    "rookCastle": 1
  },
  "language": "en-GB"
}
''';

      when(
        () => mockAuthClient
            .get(Uri.parse('$kLichessHost/api/account/preferences')),
      ).thenAnswer(
        (_) async => Result.value(http.Response(response, 200)),
      );

      final result = await repo.getPreferences();

      expect(result.isValue, true);

      expect(result.asValue!.value.autoQueen, AutoQueen.premove);
    });
  });
}
