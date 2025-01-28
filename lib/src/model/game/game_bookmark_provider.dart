import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_bookmark_provider.g.dart';

/// A provider to store the bookmark value of a game when it was changed by the user.
@Riverpod(keepAlive: true)
class GameBookmark extends _$GameBookmark {
  @override
  bool? build(GameId id) => null;

  @override
  set state(bool? newState) => super.state = newState;
}
