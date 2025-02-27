import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'patron.freezed.dart';

@freezed
class PatronCurrency with _$PatronCurrency {
  const factory PatronCurrency({
    required String code,
    required int minAmount,
    required int maxAmount,
    required int lifetimePatronAmount,
    required int defaultAmount,
    required IList<int> suggestedAmounts,
  }) = _PatronCurrency;
}
