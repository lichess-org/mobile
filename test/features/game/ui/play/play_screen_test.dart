import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/features/game/ui/play/play_screen.dart';
import 'package:lichess_mobile/src/features/game/model/time_control.dart';
import '../../../auth/data/fake_auth_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  final mockApiClient = MockApiClient();

  when(() => mockApiClient.get(Uri.parse('$kLichessHost/api/user/maia1')))
      .thenReturn(
          TaskEither.right(http.Response(maiaResponses['maia1']!, 200)));
  when(() => mockApiClient.get(Uri.parse('$kLichessHost/api/user/maia5')))
      .thenReturn(
          TaskEither.right(http.Response(maiaResponses['maia5']!, 200)));
  when(() => mockApiClient.get(Uri.parse('$kLichessHost/api/user/maia9')))
      .thenReturn(
          TaskEither.right(http.Response(maiaResponses['maia9']!, 200)));
  when(() => mockApiClient.get(
          Uri.parse('$kLichessHost/api/users/status?ids=maia1,maia5,maia9')))
      .thenReturn(TaskEither.right(http.Response(maiaStatusResponses, 200)));

  testWidgets('PlayForm loads card opponent info', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          apiClientProvider.overrideWithValue(mockApiClient),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Consumer(builder: (context, ref, _) {
            return Scaffold(body: PlayForm(account: fakeUser));
          }),
        ),
      ),
    );

    // load maia1 default opponent info in card
    // first frame is a loading state
    expect(find.widgetWithText(Card, 'maia1'), findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(Card),
            matching: find.byType(CircularProgressIndicator)),
        findsOneWidget);

    await tester.pump();

    // loaded maia ratings
    expect(find.widgetWithIcon(Card, LichessIcons.blitz), findsOneWidget);
    expect(find.widgetWithText(Card, '1541'), findsOneWidget);
    expect(find.widgetWithIcon(Card, LichessIcons.rapid), findsOneWidget);
    expect(find.widgetWithText(Card, '1477'), findsOneWidget);
    expect(find.widgetWithIcon(Card, LichessIcons.classical), findsOneWidget);
    expect(find.widgetWithText(Card, '1421'), findsOneWidget);

    // change maia opponent
    await tester.tap(find.widgetWithText(ChoiceChip, 'maia5'));
    await tester.pump();
    expect(find.widgetWithIcon(Card, LichessIcons.blitz), findsOneWidget);
    expect(find.widgetWithText(Card, '1643'), findsOneWidget);
    expect(find.widgetWithIcon(Card, LichessIcons.rapid), findsOneWidget);
    expect(find.widgetWithText(Card, '1577'), findsOneWidget);
    expect(find.widgetWithIcon(Card, LichessIcons.classical), findsOneWidget);
    expect(find.widgetWithText(Card, '1591'), findsOneWidget);

    // choose stockfish opponent
    await tester.tap(find.widgetWithText(ChoiceChip, 'Fairy-Stockfish 14'));
    await tester.pump();
    expect(find.widgetWithIcon(Card, LichessIcons.blitz), findsNothing);
    expect(find.widgetWithIcon(Card, LichessIcons.rapid), findsNothing);
    expect(find.widgetWithIcon(Card, LichessIcons.classical), findsNothing);
    expect(find.widgetWithText(Card, 'Level 1'), findsOneWidget);
  });

  testWidgets('PlayForm changes time control', (tester) async {
    SharedPreferences.setMockInitialValues({
      'play.timeControl': '3 + 2',
    });
    final sharedPreferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          apiClientProvider.overrideWithValue(mockApiClient),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Consumer(builder: (context, ref, _) {
            return Scaffold(body: PlayForm(account: fakeUser));
          }),
        ),
      ),
    );

    await tester.tap(find.text('3 + 2'));
    await tester.pumpAndSettle(); // wait for the animation to finish

    await tester.tap(find.byKey(const ValueKey(TimeControl.rapid1)));
    await tester.pumpAndSettle(); // wait for the animation to finish

    expect(find.widgetWithText(OutlinedButton, '10 + 0'), findsOneWidget);
    expect(find.widgetWithIcon(OutlinedButton, LichessIcons.rapid),
        findsOneWidget);
  });
}

final maiaResponses = {
  'maia1': '''{
    "id": "maia1",
    "username": "maia1",
    "createdAt": 1290415680000,
    "seenAt": 1290415680000,
    "perfs": {
      "blitz": {
        "games": 2340,
        "rating": 1541,
        "rd": 30,
        "prog": 10
      },
      "rapid": {
        "games": 2340,
        "rating": 1477,
        "rd": 30,
        "prog": 10
      },
      "classical": {
        "games": 2340,
        "rating": 1421,
        "rd": 30,
        "prog": 10
      }
    }
  }''',
  'maia5': '''{
    "id": "maia5",
    "username": "maia5",
    "createdAt": 1290415680000,
    "seenAt": 1290415680000,
    "perfs": {
      "blitz": {
        "games": 2340,
        "rating": 1643,
        "rd": 30,
        "prog": 10,
        "prov": false
      },
      "rapid": {
        "games": 2340,
        "rating": 1577,
        "rd": 30,
        "prog": 10
      },
      "classical": {
        "games": 2340,
        "rating": 1591,
        "rd": 30,
        "prog": 10
      }
    }
  }''',
  'maia9': '''{
    "id": "maia9",
    "username": "maia9",
    "createdAt": 1290415680000,
    "seenAt": 1290415680000,
    "perfs": {
      "blitz": {
        "games": 2340,
        "rating": 1681,
        "rd": 30,
        "prog": 10
      },
      "rapid": {
        "games": 2340,
        "rating": 1677,
        "rd": 30,
        "prog": 10
      },
      "classical": {
        "games": 2340,
        "rating": 1618,
        "rd": 30,
        "prog": 10
      }
    }
  }''',
};

const maiaStatusResponses = '''
  [
    {
      "id": "maia1",
      "name": "maia1",
      "online": true
    },
    {
      "id": "maia5",
      "name": "maia5",
      "online": true
    },
    {
      "id": "maia9",
      "name": "maia9",
      "online": true
    }
  ]
''';
