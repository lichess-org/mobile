import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/external_engine.dart';

import 'fake_external_engines.dart';

void main() {
  test('fromJson reads a registration as the API returns it', () {
    const json = '''
{"id":"eei_aTKImBJOnv6j","name":"External Stockfish","userId":"thibault","maxThreads":8,"maxHash":2048,"variants":["chess"],"providerData":null,"clientSecret":"ees_mdF2hK0hlKGSPeC6"}
''';

    final engine = ExternalEngine.fromJson(jsonDecode(json) as Map<String, dynamic>);

    expect(engine, testExternalEngine);
  });

  test('an engine registered for chess supports standard, chess960 and from position', () {
    expect(testExternalEngine.supports(Variant.standard), isTrue);
    expect(testExternalEngine.supports(Variant.chess960), isTrue);
    expect(testExternalEngine.supports(Variant.fromPosition), isTrue);
    expect(testExternalEngine.supports(Variant.atomic), isFalse);
  });

  test('shortName is the whole name when it has up to 9 characters', () {
    final engine = testExternalEngine.copyWith(name: 'Stockfish');

    expect(engine.shortName, 'Stockfish');
  });

  test('shortName ends a longer name with an ellipsis after 8 characters', () {
    final engine = testExternalEngine.copyWith(name: 'Stockfish 17.1');

    expect(engine.shortName, 'Stockfis…');
  });

  test('shortName leaves no space before the ellipsis', () {
    final engine = testExternalEngine.copyWith(name: 'Desktop Stockfish');

    expect(engine.shortName, 'Desktop…');
  });

  test('shortName counts an emoji as one character', () {
    final engine = testExternalEngine.copyWith(name: 'Rocket 🚀🚀🚀🚀');

    expect(engine.shortName, 'Rocket 🚀…');
  });
}
