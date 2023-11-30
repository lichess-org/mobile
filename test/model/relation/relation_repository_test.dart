import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthClient extends Mock implements AuthClient {}

class MockLogger extends Mock implements Logger {}

void main() {
  final mockLogger = MockLogger();
  final mockAuthClient = MockAuthClient();
  final repo =
      RelationRepository(apiClient: mockAuthClient, logger: mockLogger);

  setUpAll(() {
    reset(mockAuthClient);
  });

  group('RelationRepository.getFollowing', () {
    test('json read, minimal example', () async {
      const testRelationResponseMinimal = '''
{"id":"georges","username":"Georges","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}
{"id":"georges","username":"Georges","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}
''';
      when(
        () => mockAuthClient.get(
          Uri.parse('$kLichessHost/api/rel/following'),
          headers: {'Accept': 'application/x-ndjson'},
        ),
      ).thenAnswer(
        (_) async =>
            Result.value(http.Response(testRelationResponseMinimal, 200)),
      );

      final result = await repo.getFollowing();

      expect(result.isValue, true);
    });

    test('json read, full example', () async {
      const testRelationResponse = '''
{"id":"georges","username":"Georges","createdAt":1290415680000,"seenAt":1290415680000,"title":"GM","patron":true,"perfs":{"chess960":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"atomic":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"racingKings":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"ultraBullet":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"blitz":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"kingOfTheHill":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"bullet":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"correspondence":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"horde":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"puzzle":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"classical":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"rapid":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"storm":{"runs":44,"score":61},"racer":{"runs":44,"score":61},"streak":{"runs":44,"score":61}},"profile":{"country":"France","location":"Lille","bio":"test bio","firstName":"John","lastName":"Doe","fideRating":1800,"links":"http://test.com"}}
''';
      when(
        () => mockAuthClient.get(
          Uri.parse('$kLichessHost/api/rel/following'),
          headers: {'Accept': 'application/x-ndjson'},
        ),
      ).thenAnswer(
        (_) async => Result.value(http.Response(testRelationResponse, 200)),
      );

      final result = await repo.getFollowing();

      expect(result.isValue, true);
    });
  });
}
