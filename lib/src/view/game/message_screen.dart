import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/chat_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final GameFullId id;
  final Widget title;
  final LightUser? me;

  const MessageScreen({required this.id, required this.title, this.me});

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required GameFullId id,
    required Widget title,
    LightUser? me,
  }) {
    return buildScreenRoute(context, screen: MessageScreen(id: id, title: title, me: me));
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      rootNavPageRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    rootNavPageRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    ref.read(chatControllerProvider(widget.id).notifier).markMessagesAsRead();
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.title, centerTitle: true),
      body: _Body(me: widget.me, id: widget.id),
    );
  }
}

class _Body extends ConsumerWidget {
  final GameFullId id;
  final LightUser? me;

  const _Body({required this.id, required this.me});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStateAsync = ref.watch(chatControllerProvider(id));

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: chatStateAsync.when(
              data: (chatState) {
                final selectedMessages =
                    chatState.messages.where((m) => !m.troll && !m.deleted && !isSpam(m)).toList();
                final messagesCount = selectedMessages.length;
                return ListView.builder(
                  // remove the automatic bottom padding of the ListView, which on iOS
                  // corresponds to the safe area insets
                  // and which is here taken care of by the _ChatBottomBar
                  padding: MediaQuery.of(context).padding.copyWith(bottom: 0),
                  reverse: true,
                  itemCount: messagesCount,
                  itemBuilder: (context, index) {
                    final message = selectedMessages[messagesCount - index - 1];
                    return (message.username == 'lichess')
                        ? _MessageAction(message: message.message)
                        : (message.username == me?.name)
                        ? _MessageBubble(you: true, message: message.message)
                        : _MessageBubble(you: false, message: message.message);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              error: (error, _) => Center(child: Text(error.toString())),
            ),
          ),
        ),
        _ChatBottomBar(id: id),
      ],
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  final bool you;
  final String message;

  const _MessageBubble({required this.you, required this.message});

  Color _bubbleColor(BuildContext context, Brightness brightness) =>
      you ? ColorScheme.of(context).secondary : ColorScheme.of(context).surfaceContainerLow;

  Color _textColor(BuildContext context, Brightness brightness) =>
      you ? ColorScheme.of(context).onSecondary : ColorScheme.of(context).onSurface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;

    return FractionallySizedBox(
      alignment: you ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 0.9,
      child: Align(
        alignment: you ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: _bubbleColor(context, brightness),
          ),
          child: Text(message, style: TextStyle(color: _textColor(context, brightness))),
        ),
      ),
    );
  }
}

class _MessageAction extends StatelessWidget {
  final String message;

  const _MessageAction({required this.message});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}

class _ChatBottomBar extends ConsumerStatefulWidget {
  final GameFullId id;
  const _ChatBottomBar({required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends ConsumerState<_ChatBottomBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    final sendButton = ValueListenableBuilder<TextEditingValue>(
      valueListenable: _textController,
      builder:
          (context, value, child) => SemanticIconButton(
            onPressed:
                session != null && value.text.isNotEmpty
                    ? () {
                      ref
                          .read(chatControllerProvider(widget.id).notifier)
                          .sendMessage(_textController.text);
                      _textController.clear();
                    }
                    : null,
            icon: const Icon(Icons.send),
            padding: EdgeInsets.zero,
            semanticsLabel: context.l10n.send,
          ),
    );
    final placeholder = session != null ? context.l10n.talkInChat : context.l10n.loginToChat;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            suffixIcon: sendButton,
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            hintText: placeholder,
          ),
          controller: _textController,
          keyboardType: TextInputType.text,
          minLines: 1,
          maxLines: 4,
          enableSuggestions: true,
          readOnly: session == null,
        ),
      ),
    );
  }
}
