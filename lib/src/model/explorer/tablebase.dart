import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tablebase.freezed.dart';

enum TablebaseCategory {
  win,
  unknown,
  syzygyWin,
  maybeWin,
  cursedWin,
  draw,
  blessedLoss,
  maybeLoss,
  syzygyLoss,
  loss,
}

@freezed
sealed class TablebaseEntry with _$TablebaseEntry {
  const TablebaseEntry._();

  const factory TablebaseEntry({
    required int? dtz,
    required int? dtc,
    required int? dtm,
    required bool checkmate,
    required bool stalemate,
    required bool insufficientMaterial,
    required TablebaseCategory category,
    required IList<TablebaseMove> moves,
  }) = _TablebaseEntry;

  factory TablebaseEntry.fromJson(Map<String, Object?> json) =>
      TablebaseEntry.fromPick(pick(json).required());

  factory TablebaseEntry.fromPick(RequiredPick pick) {
    return TablebaseEntry(
      dtz: pick('dtz').asIntOrNull(),
      dtc: pick('dtc').asIntOrNull(),
      dtm: pick('dtm').asIntOrNull(),
      checkmate: pick('checkmate').asBoolOrFalse(),
      stalemate: pick('stalemate').asBoolOrFalse(),
      insufficientMaterial: pick('insufficient_material').asBoolOrFalse(),
      category: pick('category').letOrThrow((p) => _parseTablebaseCategory(p.asStringOrThrow())),
      moves: pick('moves').asListOrEmpty((p) => TablebaseMove.fromPick(p.required())).toIList(),
    );
  }
}

@freezed
sealed class TablebaseMove with _$TablebaseMove {
  const TablebaseMove._();

  const factory TablebaseMove({
    required String uci,
    required String san,
    required int? dtz,
    required int? dtc,
    required int? dtm,
    required bool zeroing,
    required bool conversion,
    required bool checkmate,
    required bool stalemate,
    required bool insufficientMaterial,
    required TablebaseCategory category,
  }) = _TablebaseMove;

  factory TablebaseMove.fromJson(Map<String, Object?> json) =>
      TablebaseMove.fromPick(pick(json).required());

  factory TablebaseMove.fromPick(RequiredPick pick) {
    return TablebaseMove(
      uci: pick('uci').asStringOrThrow(),
      san: pick('san').asStringOrThrow(),
      dtz: pick('dtz').asIntOrNull(),
      dtc: pick('dtc').asIntOrNull(),
      dtm: pick('dtm').asIntOrNull(),
      zeroing: pick('zeroing').asBoolOrFalse(),
      conversion: pick('conversion').asBoolOrFalse(),
      checkmate: pick('checkmate').asBoolOrFalse(),
      stalemate: pick('stalemate').asBoolOrFalse(),
      insufficientMaterial: pick('insufficient_material').asBoolOrFalse(),
      category: pick('category').letOrThrow((p) => _parseTablebaseCategory(p.asStringOrThrow())),
    );
  }
}

TablebaseCategory _parseTablebaseCategory(String value) {
  return switch (value) {
    'win' => TablebaseCategory.win,
    'unknown' => TablebaseCategory.unknown,
    'syzygy-win' => TablebaseCategory.syzygyWin,
    'maybe-win' => TablebaseCategory.maybeWin,
    'cursed-win' => TablebaseCategory.cursedWin,
    'draw' => TablebaseCategory.draw,
    'blessed-loss' => TablebaseCategory.blessedLoss,
    'maybe-loss' => TablebaseCategory.maybeLoss,
    'syzygy-loss' => TablebaseCategory.syzygyLoss,
    'loss' => TablebaseCategory.loss,
    _ => TablebaseCategory.unknown,
  };
}
