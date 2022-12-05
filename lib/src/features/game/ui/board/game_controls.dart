import 'package:flutter_riverpod/flutter_riverpod.dart';

final positionCursorProvider = StateProvider.autoDispose<int>((ref) => 0);

final isBoardTurnedProvider = StateProvider.autoDispose<bool>((ref) => false);
