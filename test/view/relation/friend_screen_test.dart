import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/relation/friend_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  group('followingStatusesProvider', () {
    test('returns empty lists when following is empty', () async {
      bool getUsersStatusesCalled = false;

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/rel/following') {
          return mockResponse('', 200);
        }
        if (request.url.path == '/api/users/status') {
          getUsersStatusesCalled = true;
          return mockResponse('[]', 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);

      final result = await container.read(followingStatusesProvider.future);

      expect(result.$1, isA<IList<User>>());
      expect(result.$1.isEmpty, true);
      expect(result.$2, isA<IList<UserStatus>>());
      expect(result.$2.isEmpty, true);

      expect(getUsersStatusesCalled, false);
    });

    test('calls getUsersStatuses when following is not empty', () async {
      bool getUsersStatusesCalled = false;

      const String expectedId = 'testuser';
      const bool expectedOnlineStatus = true;

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/rel/following') {
          return mockResponse(
            '{"id":"testuser","username":"TestUser","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}',
            200,
          );
        }
        if (request.url.path == '/api/users/status' && request.url.query.contains('ids=testuser')) {
          getUsersStatusesCalled = true;
          return mockResponse('''
[
  {
    "id": "$expectedId",
    "name": "TestUser",
    "online": $expectedOnlineStatus
  }
]
''', 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);

      final result = await container.read(followingStatusesProvider.future);

      expect(result.$1.length, 1);
      expect(result.$1.first.id.value, expectedId);
      expect(result.$2.length, 1);
      expect(result.$2.first.online, expectedOnlineStatus);

      expect(getUsersStatusesCalled, true);
    });
  });

  group('widget tests', () {
    testWidgets('shows CenterLoadingIndicator before request completes', (
      WidgetTester tester,
    ) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/rel/following') {
          return mockResponse('', 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const FriendScreen(),
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
          onlineFriendsProvider.overrideWith(() => _MockOnlineFriends(const IList.empty())),
        ],
      );

      await tester.pumpWidget(app);

      expect(find.byType(CenterLoadingIndicator), findsOneWidget);

      expect(find.byKey(const Key('online_tab')), findsNothing);
      expect(find.byKey(const Key('following_tab')), findsNothing);
    });

    testWidgets('shows _Online and _Following tabs after request completes with empty list', (
      WidgetTester tester,
    ) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/rel/following') {
          return mockResponse('', 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const FriendScreen(),
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
          onlineFriendsProvider.overrideWith(() => _MockOnlineFriends(const IList.empty())),
        ],
      );

      await tester.pumpWidget(app);

      await tester.pumpAndSettle();

      expect(find.byType(CenterLoadingIndicator), findsNothing);

      expect(find.byKey(const Key('online_tab')), findsOneWidget);
      expect(find.byKey(const Key('following_tab')), findsOneWidget);

      expect(find.text('0 friends online'), findsOneWidget);
      expect(find.text('0 following'), findsOneWidget);
    });

    testWidgets('shows _Online and _Following tabs after request completes with data', (
      WidgetTester tester,
    ) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/rel/following') {
          return mockResponse(
            '{"id":"testuser","username":"TestUser","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}',
            200,
          );
        }
        if (request.url.path == '/api/users/status' && request.url.query.contains('ids=testuser')) {
          return mockResponse('''
[
  {
    "id": "testuser",
    "name": "TestUser",
    "online": true
  }
]
''', 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const FriendScreen(),
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
          onlineFriendsProvider.overrideWith(
            () => _MockOnlineFriends(
              IList(const [
                (user: LightUser(id: UserId('testuser'), name: 'TestUser'), playing: false),
              ]),
            ),
          ),
        ],
      );

      await tester.pumpWidget(app);

      await tester.pumpAndSettle();

      expect(find.byType(CenterLoadingIndicator), findsNothing);

      expect(find.byKey(const Key('online_tab')), findsOneWidget);
      expect(find.byKey(const Key('following_tab')), findsOneWidget);

      expect(find.text('1 friend online'), findsOneWidget);
      expect(find.text('1 following'), findsOneWidget);
    });

    testWidgets(
      'CenterLoadingIndicator is hidden and empty state is shown in _Following when no users',
      (WidgetTester tester) async {
        final mockClient = MockClient((request) {
          if (request.url.path == '/api/rel/following') {
            return mockResponse('', 200);
          }
          return mockResponse('', 404);
        });

        final app = await makeTestProviderScopeApp(
          tester,
          home: const FriendScreen(),
          overrides: [
            httpClientFactoryProvider.overrideWith((ref) {
              return FakeHttpClientFactory(() => mockClient);
            }),
            onlineFriendsProvider.overrideWith(() => _MockOnlineFriends(const IList.empty())),
          ],
        );

        await tester.pumpWidget(app);

        await tester.pumpAndSettle();

        expect(find.byType(CenterLoadingIndicator), findsNothing);

        final followingTab = find.text('0 following');
        expect(followingTab, findsOneWidget);
        await tester.tap(followingTab);
        await tester.pumpAndSettle();

        expect(find.text('You are not following any user.'), findsOneWidget);
      },
    );
  });
}

class _MockOnlineFriends extends OnlineFriends {
  _MockOnlineFriends(this._friends);

  final IList<OnlineFriend> _friends;

  @override
  Future<IList<OnlineFriend>> build() async {
    return _friends;
  }
}
