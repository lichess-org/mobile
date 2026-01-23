import 'package:freezed_annotation/freezed_annotation.dart';

part 'gif_export.freezed.dart';

@freezed
sealed class GifExportOptions with _$GifExportOptions {
  const factory GifExportOptions({
    required bool playerNames,
    required bool showPlayerRatings,
    required bool moveAnnotations,
    required bool chessClock,
    required bool userSubmit,
  }) = _GifExportOptions;
}
