import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/team/team_providers.dart';
import 'package:lichess_mobile/src/model/team/team_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  group('TeamRepository', () {
    const allUpdatesJson = '''
    {
      "byTeam": [
        { "last": 1785681992878, "team": { "id": "lichess-chess960", "name": "Lichess Chess960" }, "unread": 2 },
        { "last": 1785594732863, "team": { "flair": "objects.hammer-and-wrench", "id": "coders", "name": "Coders" }, "unread": 6 }
      ],
      "updates": {
        "currentPage": 1,
        "maxPerPage": 6,
        "nbPages": 8,
        "nbResults": 46,
        "nextPage": 2,
        "previousPage": null,
        "currentPageResults": [
          {
            "msg": {
              "id": "3gJtsRcB",
              "date": 1785681992878,
              "sender": {
                "id": "thibault",
                "name": "thibault",
                "flair": "nature.seedling",
                "patron": true,
                "patronColor": 10
              },
              "team": { "id": "lichess-chess960", "name": "Lichess Chess960" },
              "text": "New regulations for the 2022 FIDE World Fischer Random Chess Championship"
            },
            "seen": true
          },
          {
            "msg": {
              "id": "CjLyCrW9",
              "date": 1785594732863,
              "sender": {
                "id": "thibault",
                "name": "thibault",
                "flair": "nature.seedling",
                "patron": true,
                "patronColor": 10
              },
              "team": { "flair": "objects.hammer-and-wrench", "id": "coders", "name": "Coders" },
              "text": "Some fascinating update about the coders team"
            },
            "seen": false
          }
        ]
      }
    }
    ''';

    const teamUpdatesOfTeamJson = '''
    {
      "team": { "id": "lichess-chess960", "name": "Lichess Chess960" },
      "subscribed": true,
      "byTeam": [
        { "last": 1785681992878, "team": { "id": "lichess-chess960", "name": "Lichess Chess960" }, "unread": 0 }
      ],
      "updates": {
        "currentPage": 1,
        "maxPerPage": 6,
        "nbPages": 1,
        "nbResults": 1,
        "nextPage": null,
        "previousPage": null,
        "currentPageResults": [
          {
            "msg": {
              "id": "3gJtsRcB",
              "date": 1785681992878,
              "sender": {
                "id": "thibault",
                "name": "thibault",
                "flair": "nature.seedling",
                "patron": true,
                "patronColor": 10
              },
              "team": { "id": "lichess-chess960", "name": "Lichess Chess960" },
              "text": "New regulations for the 2022 FIDE World Fischer Random Chess Championship"
            },
            "seen": true
          }
        ]
      }
    }
    ''';

    test('getTeamUpdates parses /team/updates JSON correctly', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/team/updates') {
          return mockResponse(allUpdatesJson, 200);
        }
        return mockResponse('Not found', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(teamRepositoryProvider);

      final data = await repo.getTeamUpdates();
      expect(data.byTeam.length, 2);
      expect(data.byTeam.first.team.id, const TeamId('lichess-chess960'));
      expect(data.byTeam.first.team.name, 'Lichess Chess960');
      expect(data.byTeam.first.unread, 2);
      expect(data.byTeam[1].team.id, const TeamId('coders'));
      expect(data.byTeam[1].team.flair, 'objects.hammer-and-wrench');
      expect(data.byTeam[1].unread, 6);
    });

    test('getTeamUpdatesOfTeam parses /team/updates/{teamId} JSON correctly', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/team/updates/lichess-chess960') {
          return mockResponse(teamUpdatesOfTeamJson, 200);
        }
        return mockResponse('Not found', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(teamRepositoryProvider);

      final data = await repo.getTeamUpdatesOfTeam(const TeamId('lichess-chess960'));
      expect(data.team.id, const TeamId('lichess-chess960'));
      expect(data.team.name, 'Lichess Chess960');
      expect(data.subscribed, isTrue);
      expect(data.updates.currentPageResults.length, 1);
      expect(data.updates.currentPageResults.first.msg.id, '3gJtsRcB');
    });

    test('toggleSubscribe posts to /team/{teamId}/subscribe', () async {
      var posted = false;
      final mockClient = MockClient((request) {
        if (request.url.path == '/team/coders/subscribe' && request.method == 'POST') {
          posted = true;
          return mockResponse('{"ok": true}', 200);
        }
        return mockResponse('Not found', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(teamRepositoryProvider);

      await repo.toggleSubscribe(const TeamId('coders'), subscribe: true);
      expect(posted, isTrue);
    });

    test('unreadTeamUpdatesCountProvider calculates unread total', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/team/updates') {
          return mockResponse(allUpdatesJson, 200);
        }
        return mockResponse('Not found', 404);
      });

      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
        authUser: const AuthUser(
          user: LightUser(id: UserId('test'), name: 'test'),
          token: 'token',
        ),
      );

      final count = await container.read(unreadTeamUpdatesCountProvider.future);
      expect(count, 8); // 2 + 6
    });

    test('teamChannelPaginatorProvider loads initial page and next page', () async {
      const page1Json = '''
      {
        "team": { "id": "lichess-chess960", "name": "Lichess Chess960" },
        "subscribed": true,
        "byTeam": [],
        "updates": {
          "currentPage": 1,
          "maxPerPage": 6,
          "nbPages": 2,
          "nbResults": 2,
          "nextPage": 2,
          "previousPage": null,
          "currentPageResults": [
            {
              "msg": {
                "id": "page1msg",
                "date": 1785600000000,
                "sender": {
                  "id": "thibault",
                  "name": "thibault"
                },
                "team": { "id": "lichess-chess960", "name": "Lichess Chess960" },
                "text": "Page 1 update"
              },
              "seen": true
            }
          ]
        }
      }
      ''';

      const page2Json = '''
      {
        "team": { "id": "lichess-chess960", "name": "Lichess Chess960" },
        "subscribed": true,
        "byTeam": [],
        "updates": {
          "currentPage": 2,
          "maxPerPage": 6,
          "nbPages": 2,
          "nbResults": 2,
          "nextPage": null,
          "previousPage": 1,
          "currentPageResults": [
            {
              "msg": {
                "id": "page2msg",
                "date": 1785500000000,
                "sender": {
                  "id": "thibault",
                  "name": "thibault"
                },
                "team": { "id": "lichess-chess960", "name": "Lichess Chess960" },
                "text": "Page 2 update"
              },
              "seen": true
            }
          ]
        }
      }
      ''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/team/updates/lichess-chess960') {
          if (request.url.queryParameters['page'] == '2') {
            return mockResponse(page2Json, 200);
          }
          return mockResponse(page1Json, 200);
        }
        return mockResponse('Not found', 404);
      });

      final container = await lichessClientContainer(mockClient);

      final initial = await container.read(
        teamChannelPaginatorProvider(const TeamId('lichess-chess960')).future,
      );
      expect(initial.updates.length, 1);
      expect(initial.hasMore, isTrue);
      expect(initial.nextPage, 2);
      expect(initial.isSubscribed, isTrue);

      await container
          .read(teamChannelPaginatorProvider(const TeamId('lichess-chess960')).notifier)
          .next();
      final updated = container
          .read(teamChannelPaginatorProvider(const TeamId('lichess-chess960')))
          .value!;
      expect(updated.updates.length, 2);
      expect(updated.updates.last.msg.id, 'page2msg');
      expect(updated.nextPage, isNull);
      expect(updated.hasMore, isFalse);
    });

    test('teamUpdatesProvider caches request and does not repeat HTTP calls', () async {
      int requestCount = 0;
      final mockClient = MockClient((request) {
        if (request.url.path == '/team/updates') {
          requestCount++;
          return mockResponse(allUpdatesJson, 200);
        }
        return mockResponse('Not found', 404);
      });

      final container = await lichessClientContainer(mockClient);

      final res1 = await container.read(teamUpdatesProvider.future);
      final res2 = await container.read(teamUpdatesProvider.future);

      expect(res1.byTeam.length, 2);
      expect(res2.byTeam.length, 2);
      expect(requestCount, 1);
    });

    test('teamUpdatesOfTeamProvider caches channel request', () async {
      int requestCount = 0;
      final mockClient = MockClient((request) {
        if (request.url.path == '/team/updates/lichess-chess960') {
          requestCount++;
          return mockResponse(teamUpdatesOfTeamJson, 200);
        }
        return mockResponse('Not found', 404);
      });

      final container = await lichessClientContainer(mockClient);

      final res1 = await container.read(
        teamUpdatesOfTeamProvider((const TeamId('lichess-chess960'), 1)).future,
      );
      final res2 = await container.read(
        teamUpdatesOfTeamProvider((const TeamId('lichess-chess960'), 1)).future,
      );

      expect(res1.team.id, const TeamId('lichess-chess960'));
      expect(res2.team.id, const TeamId('lichess-chess960'));
      expect(requestCount, 1);
    });
  });
}
