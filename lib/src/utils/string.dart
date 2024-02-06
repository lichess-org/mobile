import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

final _random = Random.secure();

String genRandomString(int len) {
  final values = List<int>.generate(len, (i) => _random.nextInt(256));
  return base64UrlEncode(values);
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension NumberLocalizationExtension on String {
  String localizeNumbers() {
    return replaceAllMapped(
      RegExp(r'\d+(\.\d+)?'),
      (m) => NumberFormat().format(double.parse(m.group(0)!)),
    );
  }
}
