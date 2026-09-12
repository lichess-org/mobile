import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/network/http.dart';

class const FakeHttpClientFactory(final http.Client Function() _factory)
    implements HttpClientFactory {
  @override
  http.Client Function(http.Client client)? get wrapper => throw UnimplementedError();

  @override
  http.Client call() {
    return _factory();
  }
}
