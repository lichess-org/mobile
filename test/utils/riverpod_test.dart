import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

ServerException serverException(int statusCode) =>
    ServerException(statusCode, 'boom', Uri.parse('https://lichess.org/api/account'), null);

void main() {
  group('lichessProviderRetry', () {
    // A retrying provider stays in AsyncLoading, so retrying a response the server actually sent
    // leaves spinners on screen for the whole back-off. 503 in particular is a planned
    // maintenance, which the app shows an outage screen for.
    for (final statusCode in [500, 502, 503, 429, 404]) {
      test('does not retry a $statusCode response', () {
        expect(lichessProviderRetry(0, serverException(statusCode)), isNull);
      });
    }

    test('retries a connection failure with an increasing back-off', () {
      const error = SocketException('no internet');

      expect(lichessProviderRetry(0, error), const Duration(milliseconds: 500));
      expect(lichessProviderRetry(1, error), const Duration(seconds: 1));
      expect(lichessProviderRetry(2, error), const Duration(seconds: 2));
    });

    test('does not retry an Error, which is a programming mistake rather than a hiccup', () {
      expect(lichessProviderRetry(0, StateError('bad state')), isNull);
      expect(lichessProviderRetry(0, ArgumentError('bad argument')), isNull);
    });

    test('gives up on a connection failure after 6 attempts', () {
      const error = SocketException('no internet');

      expect(lichessProviderRetry(5, error), isNotNull);
      expect(lichessProviderRetry(6, error), isNull);
    });
  });
}
