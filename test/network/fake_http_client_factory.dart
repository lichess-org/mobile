import 'dart:io' show Directory;

import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/network/http.dart';

class const FakeHttpClientFactory(final http.Client Function() _factory)
    implements HttpClientFactory {
  @override
  http.Client Function(http.Client client, {required bool diskCache})? get wrapper =>
      throw UnimplementedError();

  @override
  http.Client call({Directory? diskCacheDirectory}) {
    return _factory();
  }
}
