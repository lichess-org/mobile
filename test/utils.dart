import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Matcher sameRequest(http.BaseRequest request) => _SameRequest(request);

Future<http.Response> mockResponse(String body, int code) async =>
    Future<void>.delayed(const Duration(milliseconds: 20))
        .then((_) => http.Response(body, code));

Future<http.StreamedResponse> mockHttpStreamFromIterable(
    Iterable<String> events) async {
  await Future<void>.delayed(const Duration(milliseconds: 20));
  return http.StreamedResponse(
      _streamFromFutures(events.map((e) => _withDelay(utf8.encode(e)))), 200);
}

Future<http.StreamedResponse> mockHttpStream(Stream<String> stream) async =>
    Future<void>.delayed(const Duration(milliseconds: 20))
        .then((_) => http.StreamedResponse(stream.map(utf8.encode), 200));

// --

class _SameRequest extends Matcher {
  const _SameRequest(this._expected);

  final http.BaseRequest _expected;

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is http.BaseRequest &&
      item.method == _expected.method &&
      item.url == _expected.url;
  @override
  Description describe(Description description) =>
      description.add('same Request as ').addDescriptionOf(_expected);
}

Stream<T> _streamFromFutures<T>(Iterable<Future<T>> futures) async* {
  for (final future in futures) {
    final result = await future;
    yield result;
  }
}

Future<T> _withDelay<T>(T value,
        {Duration delay = const Duration(milliseconds: 10)}) =>
    Future<void>.delayed(delay).then((_) => value);
