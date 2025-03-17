import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/openings_database.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'opening_service.g.dart';

const kOpeningAllowedVariants = ISetConst({
  Variant.standard,
  Variant.kingOfTheHill,
  Variant.threeCheck,
  Variant.crazyhouse,
});

@Riverpod(keepAlive: true)
OpeningService openingService(Ref ref) {
  return OpeningService(ref);
}

class OpeningService {
  OpeningService(this._ref);

  final Ref _ref;

  Future<Database> get _db => _ref.read(openingsDatabaseProvider.future);

  Future<FullOpening?> fetchFromFen(String fen) async {
    final db = await _db;
    final epd = '${fen.split(' - ')[0]} -';
    final list = await db.query('openings', where: 'epd = ?', whereArgs: [epd], limit: 1);
    final first = list.firstOrNull;

    if (first != null) {
      return FullOpening(
        eco: first['eco']! as String,
        name: first['name']! as String,
        fen: first['epd']! as String,
        pgnMoves: first['pgn']! as String,
        uciMoves: first['uci']! as String,
      );
    } else {
      return null;
    }
  }
}
