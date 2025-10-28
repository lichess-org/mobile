import 'dart:math' show Random;

import 'package:lichess_mobile/src/constants.dart';

final _random = Random();
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
String _generateRandomString(int len) {
  return List.generate(len, (index) => _chars[_random.nextInt(_chars.length)]).join();
}

final String _assetHash = '_${_generateRandomString(6)}';

String lichessAssetUrl(String path) {
  return '$kLichessCDNHost/assets/$_assetHash/$path';
}

String lichessFlagSrc(String country) {
  return '$kLichessCDNHost/assets/flags/$country.png';
}

String lichessFlairSrc(String flair) {
  return '$kLichessCDNHost/assets/flair/img/$flair.webp';
}
