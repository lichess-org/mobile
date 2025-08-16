import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/app_links.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/chat/chat_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBottomBarButton extends ConsumerWidget {
  const ChatBottomBarButton({required this.options, this.showLabel = false, super.key});

  final ChatOptions options;
  final bool showLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatUnread = ref.watch(chatUnreadProvider(options));

    return BottomBarButton(
      label: context.l10n.chatRoom,
      showLabel: showLabel,
      onTap: () {
        Navigator.of(context).push(ChatScreen.buildRoute(context, options: options));
      },
      icon: Icons.chat_bubble_outline,
      badgeLabel: switch (chatUnread) {
        AsyncData(:final value) =>
          value > 0
              ? value < 10
                    ? value.toString()
                    : '9+'
              : null,
        _ => null,
      },
    );
  }
}

class ChatScreen extends ConsumerStatefulWidget {
  final ChatOptions options;

  const ChatScreen({required this.options});

  static Route<dynamic> buildRoute(BuildContext context, {required ChatOptions options}) {
    return buildScreenRoute(context, screen: ChatScreen(options: options));
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with RouteAware {
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
    ref.read(chatControllerProvider(widget.options).notifier).markMessagesAsRead();
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    switch (ref.watch(chatControllerProvider(widget.options))) {
      case AsyncData(:final value):
        return Scaffold(
          appBar: AppBar(
            title: widget.options.isPublic
                ? Text(context.l10n.chatRoom)
                : widget.options.opponent == null
                ? Text(context.l10n.chatRoom)
                : UserFullNameWidget(user: widget.options.opponent),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ListView.builder(
                    // remove the automatic bottom padding of the ListView which is here taken care
                    // of by the _ChatBottomBar
                    padding: MediaQuery.paddingOf(context).copyWith(bottom: 0),
                    reverse: true,
                    itemCount: value.messages.length,
                    itemBuilder: (context, index) {
                      final message = value.messages[value.messages.length - index - 1];
                      return (message.username == 'lichess')
                          ? _MessageAction(message: message.message)
                          : (message.username == session?.user.name)
                          ? _MessageBubble(you: true, message: message)
                          : _MessageBubble(
                              you: false,
                              message: message,
                              showUsername: widget.options.isPublic,
                            );
                    },
                  ),
                ),
              ),
              if (widget.options.writeable) _ChatBottomBar(options: widget.options),
            ],
          ),
        );
      case AsyncError(:final error):
        return Scaffold(body: Center(child: Text(error.toString())));
      case _:
        return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
    }
  }
}

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({required this.you, required this.message, this.showUsername = false});

  final bool you;
  final ChatMessage message;
  final bool showUsername;

  Color _bubbleColor(BuildContext context, Brightness brightness) =>
      you ? ColorScheme.of(context).secondary : ColorScheme.of(context).surfaceContainerHigh;

  Color _textColor(BuildContext context, Brightness brightness) =>
      you ? ColorScheme.of(context).onSecondary : ColorScheme.of(context).onSurface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final brightness = Theme.of(context).brightness;

    return FractionallySizedBox(
      alignment: you ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 0.9,
      child: Align(
        alignment: you ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: _bubbleColor(context, brightness),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showUsername && message.user != null)
                    UserFullNameWidget(
                      user: message.user,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _textColor(context, brightness),
                      ),
                      onTap: () =>
                          Navigator.of(context).push(UserScreen.buildRoute(context, message.user!)),
                    ),
                  Linkify(
                    onOpen: (link) => onLinkifyOpen(context, link),
                    linkifiers: kLichessLinkifiers,
                    text: message.message,
                    style: TextStyle(color: _textColor(context, brightness)),
                    linkStyle: Styles.linkStyle,
                  ),
                ],
              ),
            ),
            if (!you && session != null)
              IconButton(
                icon: const Icon(Icons.report_problem_outlined),
                color: Colors.grey,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  if (message.user != null) {
                    launchUrl(
                      lichessUri('/report', {
                        'username': message.user!.id,
                        'login': session.user.id,
                      }),
                    );
                  }
                },
              ),
          ],
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
  final ChatOptions options;
  const _ChatBottomBar({required this.options});

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
      builder: (context, value, child) => SemanticIconButton(
        onPressed: session != null && value.text.isNotEmpty
            ? () {
                ref
                    .read(chatControllerProvider(widget.options).notifier)
                    .postMessage(_textController.text);
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
