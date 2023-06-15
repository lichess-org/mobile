import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:lichess_mobile/src/constants.dart';

final hmacSha1 = Hmac(sha1, utf8.encode(kLichessWSSecret));

/// Sign a bearer token with the lichess secret.
String signBearerToken(String token) {
  final digest = hmacSha1.convert(utf8.encode(token));
  return '$token:$digest';
}
