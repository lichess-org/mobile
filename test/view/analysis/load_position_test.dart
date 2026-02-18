import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/view/more/load_position_screen.dart';

import '../../test_provider_scope.dart';

void main() {
  testWidgets('Open Analysis Board with PGN Headers', (tester) async {
    const pgn = '''
[Event "Test Game"]
[White "Magnus Carlsen"]
[WhiteTitle "GM"]
[WhiteElo "2850"]
[Black "Hikaru Nakamura"]
[BlackTitle "GM"]
[BlackElo "2800"]
[Result "1-0"]

1. e4 e5 2. Nf3 Nc6 3. Bb5''';

    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock Clipboard for widget test
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (methodCall) async {
        if (methodCall.method == 'Clipboard.getData') {
          return {'text': pgn};
        }
        return null;
      },
    );

    final app = await makeTestProviderScopeApp(
      tester,
      home: const LoadPositionScreen(),
      defaultPreferences: {
        PrefCategory.engineEvaluation.storageKey: jsonEncode(
          EngineEvaluationPrefState.defaults.copyWith(isEnabled: false).toJson(),
        ),
      },
    );

    await tester.pumpWidget(app);

    // Paste button triggers Clipboard.getData
    await tester.tap(find.byIcon(Icons.paste));
    await tester.pumpAndSettle();

    // Verify PGN is in the text field
    expect(find.text(pgn), findsOneWidget);

    expect(find.text('Analysis board'), findsOneWidget);
    await tester.tap(find.text('Analysis board'));
    await tester.pumpAndSettle();

    expect(find.text('Magnus Carlsen'), findsOneWidget);
    expect(find.text('Hikaru Nakamura'), findsOneWidget);
    expect(find.text('GM'), findsNWidgets(2));
    expect(find.text('2850'), findsOneWidget);
    expect(find.text('2800'), findsOneWidget);
    expect(find.textContaining('e5'), findsOneWidget);

    // Clean up
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  testWidgets('Open Board Editor with FEN', (tester) async {
    const fen = '''r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 3''';

    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock Clipboard for widget test
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (methodCall) async {
        if (methodCall.method == 'Clipboard.getData') {
          return {'text': fen};
        }
        return null;
      },
    );

    final app = await makeTestProviderScopeApp(
      tester,
      home: const LoadPositionScreen(),
      defaultPreferences: {
        PrefCategory.engineEvaluation.storageKey: jsonEncode(
          EngineEvaluationPrefState.defaults.copyWith(isEnabled: false).toJson(),
        ),
      },
    );

    await tester.pumpWidget(app);

    // Paste button triggers Clipboard.getData
    await tester.tap(find.byIcon(Icons.paste));
    await tester.pumpAndSettle();

    // Verify FEN is in the text field
    expect(find.text(fen), findsOneWidget);

    expect(find.text('Board editor'), findsOneWidget);
    await tester.tap(find.text('Board editor'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('d1-whitequeen')), findsOneWidget);
    expect(find.byKey(const ValueKey('f1-whitebishop')), findsNothing);
    expect(find.byKey(const ValueKey('c4-whitebishop')), findsOneWidget);
    // Clean up
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });
}
