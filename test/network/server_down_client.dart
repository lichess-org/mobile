import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A mock client simulating a lichess server outage.
///
/// Requests to the lichess main server are answered with [statusCode] (502 when
/// the backend is unreachable, 503 during planned maintenance), while requests
/// to any other host (connectivity checks, CDN, opening explorer, …) still
/// succeed, so that the device itself is still considered online.
MockClient serverDownClient({int statusCode = 503}) => serverDownClientWithStatus(() => statusCode);

/// Like [serverDownClient], but reads the status code on every request, so that
/// a test can bring the server back up in the middle of a run.
MockClient serverDownClientWithStatus(int Function() statusCode) => MockClient((request) async {
  return http.Response('', request.url.host == lichessUri('/').host ? statusCode() : 200);
});
