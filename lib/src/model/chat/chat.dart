import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/tv/tv_game_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

export 'chat_message.dart';

part 'chat.freezed.dart';

@immutable
sealed class const ChatOptions() {
  StringId get id;
  LightUser? get opponent;
  bool get isPublic;
  bool get writeable;

  @override
  String toString() =>
      'ChatOptions(id: $id, opponent: $opponent, isPublic: $isPublic, writeable: $writeable)';
}

@freezed
abstract class const GameChatOptions._() extends ChatOptions with _$GameChatOptions {
  const factory({required GameFullId id, required LightUser? opponent}) = _GameChatOptions;

  @override
  bool get isPublic => false;

  @override
  bool get writeable => true;
}

@freezed
abstract class const TvChatOptions._() extends ChatOptions with _$TvChatOptions {
  const factory(TvGameControllerParams params, {required bool writeable}) = _TvChatOptions;

  @override
  GameId get id => params.gameId;

  @override
  LightUser? get opponent => null;

  @override
  bool get isPublic => true;
}

@freezed
abstract class const TournamentChatOptions._() extends ChatOptions with _$TournamentChatOptions {
  const factory({required TournamentId id, required bool writeable}) = _TournamentChatOptions;

  @override
  LightUser? get opponent => null;

  @override
  bool get isPublic => true;
}

@freezed
abstract class const StudyChatOptions._() extends ChatOptions with _$StudyChatOptions {
  const factory({required StudyOptions options, required bool writeable}) = _StudyChatOptions;

  @override
  LightUser? get opponent => null;

  @override
  bool get isPublic => true;

  @override
  StringId get id => options.id;
}
