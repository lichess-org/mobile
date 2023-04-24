import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart';

part 'http_client.g.dart';

@Riverpod(keepAlive: true)
Client httpClient(HttpClientRef ref) {
  final client = Client();
  ref.onDispose(() {
    client.close();
  });
  return client;
}
