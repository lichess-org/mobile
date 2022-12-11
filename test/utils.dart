import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.StreamedResponse> mockHttpStreamFromIterable(
    Iterable<String> events) async {
  await Future<void>.delayed(const Duration(milliseconds: 20));
  return http.StreamedResponse(
      _streamFromFutures(events.map((e) => _withDelay(utf8.encode(e)))), 200);
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
