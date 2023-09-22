import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/db/openings_database.dart';

part 'opening_service.g.dart';

@Riverpod(keepAlive: true)
OpeningService openingService(OpeningServiceRef ref) {
  return OpeningService(ref);
}

class OpeningService {
  OpeningService(this.ref);

  final OpeningServiceRef ref;

  Future<Database> get _db => ref.read(openingsDatabaseProvider.future);

  Future<Opening?> fetchFromMoves(Iterable<Move> moves) async {
    final db = await _db;
    final movesString = moves.map((move) => move.uci).join(' ');
    final list = await db.query(
      'openings',
      where: 'uci = ?',
      whereArgs: [movesString],
    );

    final first = list.firstOrNull;

    if (first != null) {
      return Opening(
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
