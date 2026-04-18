import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/view/more/import_pgn_screen.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';

import '../../test_provider_scope.dart';

void _mockClipboard(String text) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (methodCall) async {
      if (methodCall.method == 'Clipboard.getData') {
        return {'text': text};
      }
      return null;
    },
  );
}

Future<Widget> _makeApp(WidgetTester tester, {FilePickerResult? pickResult}) =>
    makeTestProviderScopeApp(
      tester,
      home: const ImportPgnScreen(),
      overrides: pickResult != null
          ? {pickPgnFileProvider: pickPgnFileProvider.overrideWithValue(() async => pickResult)}
          : null,
      defaultPreferences: {
        PrefCategory.engineEvaluation.storageKey: jsonEncode(
          EngineEvaluationPrefState.defaults.copyWith(isEnabled: false).toJson(),
        ),
      },
    );

void main() {
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  group('Clipboard paste', () {
    testWidgets('Valid single-game PGN navigates to analysis screen immediately', (tester) async {
      const pgn = '[White "A"]\n[Black "B"]\n\n1. e4 e5 *';
      _mockClipboard(pgn);

      final app = await _makeApp(tester);
      await tester.pumpWidget(app);

      await tester.tap(find.byIcon(Icons.paste));
      await tester.pumpAndSettle();

      // Text field is not populated — we navigated away
      expect(find.text(pgn), findsNothing);
      expect(find.byType(ImportPgnScreen), findsNothing);
    });

    testWidgets('Tapping the text field also pastes and navigates for valid PGN', (tester) async {
      const pgn = '1. e4 e5 *';
      _mockClipboard(pgn);

      final app = await _makeApp(tester);
      await tester.pumpWidget(app);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(find.byType(ImportPgnScreen), findsNothing);
    });

    testWidgets('Multi-game PGN from clipboard navigates to the game list screen', (tester) async {
      const pgn =
          '[Event "Test Event"]\n'
          '[White "Player A"]\n'
          '[Black "Player B"]\n'
          '[Result "1-0"]\n'
          '\n'
          '1. e4 e5 1-0\n'
          '\n'
          '[Event "Test Event"]\n'
          '[White "Player C"]\n'
          '[Black "Player D"]\n'
          '[Result "0-1"]\n'
          '\n'
          '1. d4 d5 0-1\n';

      _mockClipboard(pgn);

      final app = await _makeApp(tester);
      await tester.pumpWidget(app);

      await tester.tap(find.byIcon(Icons.paste));
      await tester.pumpAndSettle();

      // Navigates to game list — text field is not populated
      expect(find.text(pgn), findsNothing);
      expect(find.text('2 games'), findsOneWidget);
      expect(find.textContaining('Player A'), findsOneWidget);
      expect(find.textContaining('Player C'), findsOneWidget);
    });

    testWidgets('Multi-game clipboard: selecting a game opens analysis', (tester) async {
      const pgn =
          '[Event "Test Event"]\n'
          '[White "Player A"]\n'
          '[Black "Player B"]\n'
          '[Result "1-0"]\n'
          '\n'
          '1. e4 e5 1-0\n'
          '\n'
          '[Event "Test Event"]\n'
          '[White "Player C"]\n'
          '[Black "Player D"]\n'
          '[Result "0-1"]\n'
          '\n'
          '1. d4 d5 0-1\n';

      _mockClipboard(pgn);

      final app = await _makeApp(tester);
      await tester.pumpWidget(app);

      await tester.tap(find.byIcon(Icons.paste));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Player A'));
      await tester.pumpAndSettle();

      expect(find.text('Player A'), findsOneWidget);
      expect(find.textContaining('e5'), findsOneWidget);
    });

    testWidgets('Single-game PGN with headers navigates to analysis with correct content', (
      tester,
    ) async {
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

      _mockClipboard(pgn);

      final app = await _makeApp(tester);
      await tester.pumpWidget(app);

      await tester.tap(find.byIcon(Icons.paste));
      await tester.pumpAndSettle();

      expect(find.text('Magnus Carlsen'), findsOneWidget);
      expect(find.text('Hikaru Nakamura'), findsOneWidget);
      expect(find.text('GM'), findsNWidgets(2));
      expect(find.text('2850'), findsOneWidget);
      expect(find.text('2800'), findsOneWidget);
      expect(find.textContaining('e5'), findsOneWidget);
    });
  });

  group('PGN file import', () {
    testWidgets('Single-game PGN file navigates to analysis screen', (tester) async {
      const pgn =
          '[Event "Test Game"]\n'
          '[White "Magnus Carlsen"]\n'
          '[Black "Hikaru Nakamura"]\n'
          '[Result "1-0"]\n'
          '\n'
          '1. e4 e5 2. Nf3 Nc6 3. Bb5 *';

      final pgnBytes = utf8.encode(pgn);
      final app = await _makeApp(
        tester,
        pickResult: FilePickerResult([
          PlatformFile(name: 'game.pgn', size: pgnBytes.length, bytes: pgnBytes),
        ]),
      );
      await tester.pumpWidget(app);

      await tester.tap(find.widgetWithText(FilledButton, 'Or import a PGN file'));
      await tester.pumpAndSettle();

      expect(find.textContaining('e5'), findsOneWidget);
      expect(find.text('Magnus Carlsen'), findsOneWidget);
      expect(find.text('Hikaru Nakamura'), findsOneWidget);
    });

    testWidgets('Multi-game PGN file navigates to the game list screen', (tester) async {
      const pgn =
          '[Event "BWL2025/26 Heilbronn-Deizisau II"]\n'
          '[White "Zuferi, Enis"]\n'
          '[Black "Klek, Hanna Marie"]\n'
          '[Result "1-0"]\n'
          '[WhiteElo "2317"]\n'
          '[BlackElo "2338"]\n'
          '\n'
          '1. c4 e5 2. Nc3 Bb4 3. Nd5 a5 1-0\n'
          '\n'
          '[Event "BWL2025/26 Heilbronn-Deizisau II"]\n'
          '[White "Dabo-Peranic, Robert"]\n'
          '[Black "Neukirchner, Pascal"]\n'
          '[Result "0-1"]\n'
          '[WhiteElo "2324"]\n'
          '[BlackElo "2325"]\n'
          '\n'
          '1. Nf3 c5 2. e3 Nf6 3. b3 g6 0-1\n';

      final pgnBytes = utf8.encode(pgn);
      final app = await _makeApp(
        tester,
        pickResult: FilePickerResult([
          PlatformFile(name: 'games.pgn', size: pgnBytes.length, bytes: pgnBytes),
        ]),
      );
      await tester.pumpWidget(app);

      await tester.tap(find.widgetWithText(FilledButton, 'Or import a PGN file'));
      await tester.pumpAndSettle();

      expect(find.text('2 games'), findsOneWidget);
      expect(find.textContaining('Zuferi, Enis'), findsOneWidget);
      expect(find.textContaining('BWL2025/26 Heilbronn-Deizisau II'), findsNWidgets(2));

      await tester.tap(find.textContaining('Zuferi, Enis'));
      await tester.pumpAndSettle();

      expect(find.textContaining('e5'), findsOneWidget);
      expect(find.text('Zuferi, Enis'), findsOneWidget);
    });
    testWidgets('Search bar shows if there are more than 5 games and filters correctly', (
      tester,
    ) async {
      const pgn =
          '[Event "BWL2025/26 Heilbronn-Deizisau II"]\n'
          '[White "Zuferi, Enis"]\n'
          '[Black "Klek, Hanna Marie"]\n'
          '[Result "1-0"]\n'
          '[WhiteElo "2317"]\n'
          '[BlackElo "2338"]\n'
          '\n'
          '1. c4 e5 2. Nc3 Bb4 3. Nd5 a5 1-0\n'
          '\n'
          '[Event "BWL2025/26 Heilbronn-Deizisau II"]\n'
          '[White "Dabo-Peranic, Robert"]\n'
          '[Black "Neukirchner, Pascal"]\n'
          '[Result "0-1"]\n'
          '[WhiteElo "2324"]\n'
          '[BlackElo "2325"]\n'
          '\n'
          '1. Nf3 c5 2. e3 Nf6 3. b3 g6 0-1\n'
          '\n'
          '[Event "World Teams"]\n'
          '[White "Magnus Carlsen"]\n'
          '[Black "Fabiano Caruana"]\n'
          '[Result "1-0"]\n'
          '[WhiteElo "2860"]\n'
          '[BlackElo "2815"]\n'
          '\n'
          '1. Nf3 c5 2. e3 Nf6 3. b3 g6 0-1\n'
          '\n'
          '[Event "World Championship"]\n'
          '[White "Ding, Liren"]\n'
          '[Black "Gukesh, D"]\n'
          '[Result "0-1"]\n'
          '[WhiteElo "2781"]\n'
          '[BlackElo "2761"]\n'
          '\n'
          '1. Nf3 c5 2. e3 Nf6 3. b3 g6 0-1\n'
          '\n'
          '[Event "Grand Swiss"]\n'
          '[White "Keymer, Vincent"]\n'
          '[Black "Esipenko, Andrey"]\n'
          '[Result "0-1"]\n'
          '[WhiteElo "2786"]\n'
          '[BlackElo "2685"]\n'
          '\n'
          '1. Nf3 c5 2. e3 Nf6 3. b3 g6 0-1\n'
          '\n'
          '[Event "Grand Swiss"]\n'
          '[White "Svidler, Peter"]\n'
          '[Black "Gustaffson, Jan"]\n'
          '[Result "0.5-0.5"]\n'
          '[WhiteElo "2701"]\n'
          '[BlackElo "2599"]\n'
          '\n'
          '1. Nf3 c5 2. e3 Nf6 3. b3 g6 0-1\n';

      final pgnBytes = utf8.encode(pgn);
      final app = await _makeApp(
        tester,
        pickResult: FilePickerResult([
          PlatformFile(name: 'games.pgn', size: pgnBytes.length, bytes: pgnBytes),
        ]),
      );
      await tester.pumpWidget(app);

      await tester.tap(find.widgetWithText(FilledButton, 'Or import a PGN file'));
      await tester.pumpAndSettle();

      // 6 games, search bar is visible
      expect(find.text('6 games'), findsOneWidget);
      expect(find.byType(PlatformSearchBar), findsOneWidget);
      // All games are shown before searching
      expect(find.textContaining('Zuferi, Enis'), findsOneWidget);
      expect(find.textContaining('Magnus'), findsOneWidget);
      // Entering search query filters the list
      await tester.tap(find.byType(PlatformSearchBar));
      await tester.enterText(find.byType(PlatformSearchBar), 'Carlsen');
      await tester.pump();
      // Only Carlsen's game is shown
      expect(find.textContaining('Magnus'), findsOneWidget);
      expect(find.textContaining('Zuferi, Enis'), findsNothing);
      // Tapping the game navigates to analysis with correct game
      await tester.tap(find.textContaining('Magnus'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Carlsen'), findsOneWidget);
    });
  });
}
