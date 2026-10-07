import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/node.dart';

void main() {
  test('removes a Lichess author annotation from the displayed comment', () {
    final comment = withoutLichessAuthorAnnotations('[%anno "Bobby", bobby] The London System');

    expect(comment, 'The London System');
  });

  test('removes author annotations without dropping surrounding comment text', () {
    final comment = withoutLichessAuthorAnnotations('Before [%anno "Mary", mary] after');

    expect(comment, 'Before after');
  });

  test('keeps supported PGN annotations', () {
    final comment = withoutLichessAuthorAnnotations(
      '[%anno "Bobby", bobby] [%clk 1:02:03] [%eval 0.4] note',
    );

    expect(comment, '[%clk 1:02:03] [%eval 0.4] note');
  });

  test('keeps ordinary bracketed text', () {
    final comment = withoutLichessAuthorAnnotations('See [book 3] and [%custom value]');

    expect(comment, 'See [book 3] and [%custom value]');
  });

  test('does not alter the PGN comment stored for export', () {
    final comment = PgnComment.fromPgn('[%anno "Mary", mary] contributor note');

    expect(comment.makeComment(), contains('[%anno "Mary", mary]'));
  });
}
