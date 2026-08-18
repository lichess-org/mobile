import 'package:fast_immutable_collections/fast_immutable_collections.dart';

enum PuzzleOpeningSort { popular, alphabetical }

typedef PuzzleOpeningFamily = ({
  String key,
  String name,
  int count,
  IList<PuzzleOpeningData> openings,
});

typedef PuzzleOpeningData = ({String key, String name, int count});
