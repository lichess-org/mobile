import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/play/create_challenge_bottom_sheet.dart';

import '../../mock_server_responses.dart';
import '../../model/auth/fake_auth_storage.dart';
import '../../network/fake_http_client_factory.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _testDestUser = LightUser(id: UserId('targetuser'), name: 'TargetUser');
const _correspondenceChallengeId = 'corrId123456';
const _clockChallengeId = 'clockId12345';

void main() {
  group('CreateChallengeBottomSheet', () {
    group('clock (real-time) challenge', () {
      testWidgets('tapping challenge button closes the sheet and pushes GameScreen', (
        tester,
      ) async {
        final app = await makeTestProviderScopeApp(
          tester,
          home: const _TestBottomSheetOpener(_testDestUser),
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
              (ref) => FakeHttpClientFactory(() => _makeClockMockClient()),
            ),
          },
          authUser: fakeAuthUser,
        );

        await tester.pumpWidget(app);
        // let account provider load
        await tester.pump(const Duration(milliseconds: 50));

        // open the bottom sheet
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(CreateChallengeBottomSheet), findsOneWidget);

        // default time control is clock, so the challenge button should be enabled
        await tester.tap(find.text('Challenge'));
        await tester.pumpAndSettle();

        // the bottom sheet should be gone
        expect(find.byType(CreateChallengeBottomSheet), findsNothing);

        // GameScreen should be pushed (loading state is fine)
        expect(find.byType(GameScreen), findsOneWidget);
      }, variant: kPlatformVariant);
    });

    group('correspondence/unlimited challenge', () {
      testWidgets(
        'creates correspondence challenge, closes the sheet, and shows snackbar',
        (tester) async {
          final app = await makeTestProviderScopeApp(
            tester,
            home: const _TestBottomSheetOpener(_testDestUser),
            overrides: {
              httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
                (ref) => FakeHttpClientFactory(() => _makeCorrespondenceMockClient()),
              ),
            },
            authUser: fakeAuthUser,
            defaultPreferences: {
              '${PrefCategory.challenge.storageKey}.${fakeAuthUser.user.id}': jsonEncode(
                ChallengePrefs.defaults
                    .copyWith(timeControl: ChallengeTimeControlType.correspondence, rated: false)
                    .toJson(),
              ),
            },
          );

          await tester.pumpWidget(app);
          await tester.pump(const Duration(milliseconds: 50));

          // open the bottom sheet
          await tester.tap(find.text('Open'));
          await tester.pumpAndSettle();

          expect(find.byType(CreateChallengeBottomSheet), findsOneWidget);

          // tap challenge button
          await tester.tap(find.text('Challenge'));
          await tester.pump(); // start the async challenge creation

          // let the HTTP request for challenge creation complete
          await tester.pump(const Duration(milliseconds: 50));

          // let the socket connect
          await tester.pump(kFakeWebSocketConnectionLag);

          // let the 1-second delay in newCorrespondenceChallenge fire
          await tester.pump(const Duration(seconds: 1));
          await tester.pumpAndSettle();

          // the bottom sheet should be closed
          expect(find.byType(CreateChallengeBottomSheet), findsNothing);

          // snackbar should confirm the challenge was created
          expect(find.textContaining('Challenge created'), findsOneWidget);
        },
        variant: kPlatformVariant,
      );

      testWidgets('shows decline reason when challenge is immediately declined', (tester) async {
        final app = await makeTestProviderScopeApp(
          tester,
          home: const _TestBottomSheetOpener(_testDestUser),
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
              (ref) => FakeHttpClientFactory(() => _makeCorrespondenceDeclinedMockClient()),
            ),
          },
          authUser: fakeAuthUser,
          defaultPreferences: {
            '${PrefCategory.challenge.storageKey}.${fakeAuthUser.user.id}': jsonEncode(
              ChallengePrefs.defaults
                  .copyWith(timeControl: ChallengeTimeControlType.correspondence, rated: false)
                  .toJson(),
            ),
          },
        );

        await tester.pumpWidget(app);
        await tester.pump(const Duration(milliseconds: 50));

        // open the bottom sheet
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(CreateChallengeBottomSheet), findsOneWidget);

        // tap challenge button
        await tester.tap(find.text('Challenge'));
        await tester.pump();

        // let the HTTP request for challenge creation complete
        await tester.pump(const Duration(milliseconds: 50));

        // let the socket connect
        await tester.pump(kFakeWebSocketConnectionLag);

        // simulate a server reload event indicating the challenge was declined
        sendServerSocketMessages(Uri(path: '/challenge/$_correspondenceChallengeId/socket/v5'), [
          '{"t": "reload", "v": 1}',
        ]);

        // let the reload event be processed and the show request complete
        await tester.pump(const Duration(milliseconds: 50));

        // let the 1-second delay in newCorrespondenceChallenge expire
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        // the bottom sheet should be closed
        expect(find.byType(CreateChallengeBottomSheet), findsNothing);

        // snackbar should show the challenge declined message
        expect(find.text('Challenge declined.'), findsOneWidget);
      }, variant: kPlatformVariant);
    });
  });
}

/// A simple wrapper widget that shows a button to open [CreateChallengeBottomSheet].
class _TestBottomSheetOpener extends StatelessWidget {
  const _TestBottomSheetOpener(this.user);

  final LightUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: ElevatedButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (_) => CreateChallengeBottomSheet(user),
              ),
              child: const Text('Open'),
            ),
          );
        },
      ),
    );
  }
}

MockClient _makeClockMockClient() => MockClient((request) {
  if (request.url.path == '/api/account') {
    return mockResponse(mockApiAccountResponse(fakeAuthUser.user.name), 200);
  }
  // challenge creation endpoint (called by GameScreen's newRealTimeChallenge)
  if (request.url.path == '/api/challenge/${_testDestUser.id}') {
    return mockResponse(_clockChallengeResponse, 200);
  }
  return mockResponse('', 404);
});

MockClient _makeCorrespondenceMockClient() => MockClient((request) {
  if (request.url.path == '/api/account') {
    return mockResponse(mockApiAccountResponse(fakeAuthUser.user.name), 200);
  }
  if (request.url.path == '/api/challenge/${_testDestUser.id}') {
    return mockResponse(_correspondenceChallengeCreatedResponse, 200);
  }
  return mockResponse('', 404);
});

MockClient _makeCorrespondenceDeclinedMockClient() => MockClient((request) {
  if (request.url.path == '/api/account') {
    return mockResponse(mockApiAccountResponse(fakeAuthUser.user.name), 200);
  }
  if (request.url.path == '/api/challenge/${_testDestUser.id}') {
    return mockResponse(_correspondenceChallengeCreatedResponse, 200);
  }
  if (request.url.path == '/api/challenge/$_correspondenceChallengeId/show') {
    return mockResponse(_correspondenceChallengeDeclinedResponse, 200);
  }
  return mockResponse('', 404);
});

// -- Mock server responses --

const _clockChallengeResponse =
    '''
{
  "socketVersion": 0,
  "id": "$_clockChallengeId",
  "url": "https://lichess.org/$_clockChallengeId",
  "status": "created",
  "challenger": {
    "id": "testuser",
    "name": "testUser",
    "rating": 1500,
    "provisional": false,
    "online": true,
    "lag": 4
  },
  "destUser": {
    "id": "targetuser",
    "name": "TargetUser",
    "rating": 1600,
    "provisional": false,
    "online": true,
    "lag": 4
  },
  "variant": { "key": "standard", "name": "Standard", "short": "Std" },
  "rated": true,
  "speed": "rapid",
  "timeControl": { "type": "clock", "limit": 600, "increment": 0, "show": "10+0" },
  "color": "random",
  "perf": { "icon": "", "name": "Rapid" }
}
''';

const _correspondenceChallengeCreatedResponse =
    '''
{
  "socketVersion": 0,
  "id": "$_correspondenceChallengeId",
  "url": "https://lichess.org/$_correspondenceChallengeId",
  "status": "created",
  "challenger": {
    "id": "testuser",
    "name": "testUser",
    "rating": 1500,
    "provisional": false,
    "online": true,
    "lag": 4
  },
  "destUser": {
    "id": "targetuser",
    "name": "TargetUser",
    "rating": 1600,
    "provisional": false,
    "online": true,
    "lag": 4
  },
  "variant": { "key": "standard", "name": "Standard", "short": "Std" },
  "rated": false,
  "speed": "correspondence",
  "timeControl": { "type": "correspondence", "daysPerTurn": 3 },
  "color": "random",
  "perf": { "icon": "", "name": "Correspondence" }
}
''';

const _correspondenceChallengeDeclinedResponse =
    '''
{
  "socketVersion": 1,
  "id": "$_correspondenceChallengeId",
  "url": "https://lichess.org/$_correspondenceChallengeId",
  "status": "declined",
  "challenger": {
    "id": "testuser",
    "name": "testUser",
    "rating": 1500,
    "provisional": false,
    "online": true,
    "lag": 4
  },
  "destUser": {
    "id": "targetuser",
    "name": "TargetUser",
    "rating": 1600,
    "provisional": false,
    "online": true,
    "lag": 4
  },
  "variant": { "key": "standard", "name": "Standard", "short": "Std" },
  "rated": false,
  "speed": "correspondence",
  "timeControl": { "type": "correspondence", "daysPerTurn": 3 },
  "color": "random",
  "perf": { "icon": "", "name": "Correspondence" },
  "declineReasonKey": "generic"
}
''';
