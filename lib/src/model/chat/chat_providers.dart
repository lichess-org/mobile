import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/chat/chat_mixin.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_controller.dart';
import 'package:lichess_mobile/src/model/tv/tv_game_controller.dart';

/// A provider that gets the current chat state
final chatProvider = FutureProvider.autoDispose.family<ChatState?, ChatOptions>(
  (ref, options) => ref.watch(
    switch (options) {
      GameChatOptions(:final id) => gameControllerProvider(id),
      TournamentChatOptions(:final id) => tournamentControllerProvider(id),
      StudyChatOptions(:final options) => studyControllerProvider(options),
      TvChatOptions(:final params) => tvGameControllerProvider(params),
    }.selectAsync((state) => state.chatState),
  ),
  name: 'ChatProvider',
);

/// A provider that gets the [ChatMixin] notifier for the given chat.
final chatNotifierProvider = Provider.autoDispose.family<ChatMixin, ChatOptions>(
  (ref, options) => ref.read(switch (options) {
    GameChatOptions(:final id) => gameControllerProvider(id).notifier,
    TournamentChatOptions(:final id) => tournamentControllerProvider(id).notifier,
    StudyChatOptions(:final options) => studyControllerProvider(options).notifier,
    TvChatOptions(:final params) => tvGameControllerProvider(params).notifier,
  }),
  name: 'ChatNotifierProvider',
);

/// A provider that gets the chat unread messages
final chatUnreadProvider = FutureProvider.autoDispose.family<int, ChatOptions>((
  Ref ref,
  ChatOptions options,
) async {
  return (await ref.watch(chatProvider(options).future))?.unreadMessages ?? 0;
}, name: 'ChatUnreadProvider');
