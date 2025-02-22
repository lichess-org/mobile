import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/network/http.dart';

class FakeHttpClientFactory implements HttpClientFactory {
  const FakeHttpClientFactory(this._factory);

  final http.Client Function() _factory;

  @override
  http.Client Function(http.Client client)? get onCreate => throw UnimplementedError();

  @override
  http.Client call() {
    return _factory();
  }
}
