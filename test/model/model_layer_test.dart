import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('no file under lib/src/model imports the view layer', () {
    final offenders = <String>[];

    for (final entity in Directory('lib/src/model').listSync(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.dart')) continue;
      if (entity.path.endsWith('.g.dart') || entity.path.endsWith('.freezed.dart')) continue;

      final source = entity.readAsStringSync();
      final importsView =
          source.contains('package:lichess_mobile/src/view/') ||
          source.contains('package:lichess_mobile/src/widgets/');
      if (importsView) offenders.add(entity.path);
    }

    expect(offenders, isEmpty);
  });
}
