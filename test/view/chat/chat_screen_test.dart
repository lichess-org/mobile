import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/chat/chat_mixin.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/view/chat/chat_screen.dart';

import '../../test_provider_scope.dart';

// A minimal [ChatMixinState] for the fake notifier below.
class _FakeChatState with ChatMixinState {
  const _FakeChatState();

  @override
  ChatState? get chatState => const ChatState(messages: IList.empty(), unreadMessages: 0);

  @override
  bool get chatEnabled => true;
}

/// A no-op [ChatMixin] used to stand in for the real controller-backed notifier.
///
/// The [ChatScreen] only *reads* this notifier to call side-effecting methods
/// (`onFocusRegained`, `setInputText`, ...). Since we drive the [chatProvider]
/// state directly in these tests, the notifier's methods are made no-ops so the
/// (unmounted) instance never touches `ref`/`state`.
class _FakeChatNotifier extends AsyncNotifier<_FakeChatState> with ChatMixin<_FakeChatState> {
  @override
  StringId get chatId => const StringId('test-chat');

  @override
  String get chatReportResource => 'test/resource';

  @override
  bool get chatIsPublic => true;

  @override
  Future<_FakeChatState> build() async => const _FakeChatState();

  @override
  void updateChatState(ChatState newState) {}

  @override
  void onFocusRegained() {}

  @override
  void onForegroundLost() {}

  @override
  void setInputText(String text) {}
}

class HangNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void hang() => state = true;
}

void main() {
  const options = GameChatOptions(id: GameFullId('testGame1234'), opponent: null);

  const authUser = AuthUser(
    token: 'testToken',
    user: LightUser(id: UserId('me'), name: 'Me'),
  );

  ChatMessage msg(String text, {String? username}) =>
      ChatMessage(message: text, username: username, troll: false, deleted: false);

  // When `true`, the overridden [chatProvider] never resolves, which forces it
  // into an `AsyncLoading` state while retaining its previous value — exactly
  // the transition that happens when a keystroke updates the underlying
  // controller (see issue #3368 / PR #3417).
  final hangProvider = NotifierProvider<HangNotifier, bool>(HangNotifier.new);

  Future<Widget> buildTestApp(WidgetTester tester) {
    return makeTestProviderScopeApp(
      tester,
      home: const ChatScreen(options: options),
      authUser: authUser,
      overrides: {
        chatProvider(options): chatProvider(options).overrideWith((ref) async {
          if (ref.watch(hangProvider)) {
            // Simulate the provider recomputing: it stays in `AsyncLoading` but
            // keeps its previous value (`hasValue == true`).
            await Completer<ChatState?>().future;
          }
          return ChatState(
            messages: IList([msg('hello world', username: 'opponent')]),
            unreadMessages: 0,
          );
        }),
        chatNotifierProvider(options): chatNotifierProvider(
          options,
        ).overrideWith((ref) => _FakeChatNotifier()),
      },
    );
  }

  testWidgets('keeps the keyboard open while the chat provider is reloading (#3368)', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(tester));
    await tester.pumpAndSettle();

    // Chat content is displayed with its input field.
    expect(find.text('hello world'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Focus the input field: this opens the (fake) software keyboard.
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);

    // Force the chat provider into an `AsyncLoading` state that keeps its
    // previous value, mimicking what happens on every keystroke.
    final container = ProviderScope.containerOf(tester.element(find.byType(ChatScreen)));
    container.read(hangProvider.notifier).hang();
    await tester.pump();

    // Regression: the whole screen must NOT be replaced by a loading spinner.
    // The input field must survive so the keyboard stays open.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('hello world'), findsOneWidget);
    expect(tester.testTextInput.isVisible, isTrue);
  });
}
