import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_provider.g.dart';

@riverpod
class BookmarkNotifier extends _$BookmarkNotifier {
  @override
  bool? build(GameId id) => null;

  @override
  set state(bool? newState) => super.state = newState;
}
