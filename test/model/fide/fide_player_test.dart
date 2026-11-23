import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/fide/fide_player.dart';

void main() {
  FidePlayer player(int id) => FidePlayer(
    id: FideId(id),
    name: 'Doe, John',
    federation: null,
    birthYear: null,
    title: null,
    ratings: const IMapConst({}),
    photo: null,
    following: false,
  );

  FidePlayerPage page(List<int> ids) => (players: ids.map(player).toIList(), nextPage: null);

  group('FidePlayerPage.idMatch', () {
    test('is the player alone on the page with the queried FIDE ID', () {
      expect(page([1503014]).idMatch('1503014')?.id, const FideId(1503014));
      expect(page([1503014]).idMatch(' 1503014 ')?.id, const FideId(1503014));
    });

    test('is null for a name search', () {
      expect(page([1503014]).idMatch('carlsen'), null);
    });

    test('is null if the only player has another ID', () {
      expect(page([1503014]).idMatch('42'), null);
    });

    test('is null for several players or none', () {
      expect(page([1503014, 1503015]).idMatch('1503014'), null);
      expect(page([]).idMatch('1503014'), null);
    });
  });
}
