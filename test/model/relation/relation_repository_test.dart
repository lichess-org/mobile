import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  group('RelationRepository.getFollowing', () {
    test('json read, minimal example', () async {
      const testRelationResponseMinimal = '''
{"id":"georges","username":"Georges","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}
{"id":"georges","username":"Georges","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}
''';
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/rel/following') {
          return mockResponse(testRelationResponseMinimal, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);
      final repo = RelationRepository(client);
      final result = await repo.getFollowing();

      expect(result, isA<IList<User>>());
    });

    test('json read, full example', () async {
      const testRelationResponse = '''
{"id":"georges","username":"Georges","createdAt":1290415680000,"seenAt":1290415680000,"title":"GM","patron":true,"perfs":{"chess960":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"atomic":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"racingKings":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"ultraBullet":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"blitz":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"kingOfTheHill":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"bullet":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"correspondence":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"horde":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"puzzle":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"classical":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"rapid":{"games":2945,"rating":1609,"rd":60,"prog":-22,"prov":true},"storm":{"runs":44,"score":61},"racer":{"runs":44,"score":61},"streak":{"runs":44,"score":61}},"profile":{"country":"France","location":"Lille","bio":"test bio","firstName":"John","lastName":"Doe","fideRating":1800,"links":"http://test.com"}}
''';
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/rel/following') {
          return mockResponse(testRelationResponse, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);
      final repo = RelationRepository(client);
      final result = await repo.getFollowing();

      expect(result, isA<IList<User>>());
    });
  });
}
