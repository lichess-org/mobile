import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/eval.dart';

final currentEvaluationProvider = StateProvider.autoDispose<ClientEval?>((ref) {
  return null;
});
