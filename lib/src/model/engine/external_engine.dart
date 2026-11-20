import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';

part 'external_engine.freezed.dart';
part 'external_engine.g.dart';

/// The length of the longest built-in engine button label, "SF 19 1MB".
const _maxShortNameLength = 9;

/// An engine the user registered on lichess.org, reached through the Lichess engine broker.
@Freezed(fromJson: true)
sealed class const ExternalEngine._() with _$ExternalEngine {
  const factory({
    required String id,
    required String name,
    required int maxThreads,

    /// In MiB.
    required int maxHash,

    /// UCI variant names the engine was registered for.
    required IList<String> variants,
    required String clientSecret,
  }) = _ExternalEngine;

  factory fromJson(Map<String, dynamic> json) => _$ExternalEngineFromJson(json);

  bool supports(Variant variant) => variants.contains(variant.fairy);

  String get shortName {
    if (name.characters.length <= _maxShortNameLength) return name;
    final start = name.characters.take(_maxShortNameLength - 1).toString().trimRight();
    return '$start…';
  }
}
