import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/view/more/load_position_screen.dart';

import '../../test_provider_scope.dart';

class _MockFilePicker extends FilePicker {
  _MockFilePicker(this._result);

  final FilePickerResult? _result;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    dynamic Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async => _result;
}

void main() {
  tearDown(() {
    // Clean up clipboard mock after each test
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

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
  });

  testWidgets('Open Board Editor with FEN', (tester) async {
    const fen = '''r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 3''';

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
  });
  testWidgets('Open Analysis Board with PGN file upload (single game)', (tester) async {
    const pgn =
        '[Event "Test Game"]\n'
        '[White "Magnus Carlsen"]\n'
        '[Black "Hikaru Nakamura"]\n'
        '[Result "1-0"]\n'
        '\n'
        '1. e4 e5 2. Nf3 Nc6 3. Bb5 *';

    final pgnBytes = utf8.encode(pgn);

    FilePicker.platform = _MockFilePicker(
      FilePickerResult([PlatformFile(name: 'games.pgn', size: pgnBytes.length, bytes: pgnBytes)]),
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

    await tester.tap(find.byIcon(Icons.upload_file));
    await tester.pumpAndSettle();

    expect(find.text('Analysis board'), findsOneWidget);
    await tester.tap(find.text('Analysis board'));
    await tester.pumpAndSettle();

    expect(find.textContaining('e5'), findsOneWidget);
    expect(find.text('Magnus Carlsen'), findsOneWidget);
    expect(find.text('Hikaru Nakamura'), findsOneWidget);
  });
  testWidgets('Open PGN game list with multi-game PGN file upload', (tester) async {
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

    FilePicker.platform = _MockFilePicker(
      FilePickerResult([PlatformFile(name: 'games.pgn', size: pgnBytes.length, bytes: pgnBytes)]),
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

    await tester.tap(find.byIcon(Icons.upload_file));
    await tester.pumpAndSettle();

    // Multi-game PGN navigates directly to the games list screen
    expect(find.textContaining('games.pgn'), findsOneWidget);
    expect(find.textContaining('Zuferi, Enis'), findsOneWidget);
    expect(find.textContaining('BWL2025/26 Heilbronn-Deizisau II'), findsNWidgets(2));

    await tester.tap(find.textContaining('Zuferi, Enis'));
    await tester.pumpAndSettle();

    expect(find.textContaining('e5'), findsOneWidget);
    expect(find.text('Zuferi, Enis'), findsOneWidget);
  });
}
