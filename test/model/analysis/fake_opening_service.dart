import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

class FakeOpeningService implements OpeningService {
  const FakeOpeningService({this.openings = const {}});

  /// Maps EPD (first 4 fields of FEN) to a [FullOpening].
  final Map<String, FullOpening> openings;

  @override
  Future<FullOpening?> fetchFromFen(String fen) {
    final epd = fen.split(' ').take(4).join(' ');
    return Future.value(openings[epd]);
  }
}
