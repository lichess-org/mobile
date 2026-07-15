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
/// (`onFocusRegained`, ...) and to read/write the in-memory [chatInputDraft]. Since
/// we drive the [chatProvider] state directly in these tests, the notifier's
/// methods are made no-ops so the (unmounted) instance never touches
/// `ref`/`state`. The [chatInputDraft] field is a plain field and is safe to use on
/// an unmounted instance, so it is deliberately *not* overridden — this is what
/// backs the draft-persistence tests below.
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

  // Builds the chat screen. [notifier] backs `chatNotifierProvider`; pass a
  // shared instance across two builds to simulate the same game controller
  // surviving the chat window being closed and reopened.
  Future<Widget> buildTestApp(WidgetTester tester, {_FakeChatNotifier? notifier}) {
    final chatNotifier = notifier ?? _FakeChatNotifier();
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
        ).overrideWith((ref) => chatNotifier),
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

  testWidgets('persists an unsent draft when the chat is closed and reopened on the same game', (
    tester,
  ) async {
    // The same notifier instance backs both chat-screen mounts, standing in for
    // the game controller that outlives the chat window in production.
    final notifier = _FakeChatNotifier();

    await tester.pumpWidget(await buildTestApp(tester, notifier: notifier));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'wait, let me offer a draw');
    await tester.pump();
    expect(notifier.chatInputDraft, 'wait, let me offer a draw');

    // Close the chat window: replacing the whole tree disposes the ChatScreen.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    // Reopen the chat on the same game (same notifier instance).
    await tester.pumpWidget(await buildTestApp(tester, notifier: notifier));
    await tester.pumpAndSettle();

    // The draft is restored into the input field.
    expect(find.text('wait, let me offer a draw'), findsOneWidget);
  });

  testWidgets('persists an unsent draft when the app goes to the background', (tester) async {
    final notifier = _FakeChatNotifier();

    await tester.pumpWidget(await buildTestApp(tester, notifier: notifier));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'brb, phone call');
    await tester.pump();

    // Send the app to the background (lifecycle must move through the
    // intermediate states to satisfy the framework's transition assertions).
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();

    // The draft is kept in memory on the notifier, not lost with the app going
    // to the background.
    expect(notifier.chatInputDraft, 'brb, phone call');

    // On resume the input field still shows the draft.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.text('brb, phone call'), findsOneWidget);
  });
}
