import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/chat/chat_providers.dart';
import 'package:lichess_mobile/src/service/app_links_service.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/chat/chat_context_menu.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/message_input.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/rich_link_text.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:material_ui/material_ui.dart';

class const ChatBottomBarButton({
  required final ChatOptions options,
  final bool showLabel = false,
  super.key,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatUnread = ref.watch(chatUnreadProvider(options));

    return BottomBarButton(
      label: context.l10n.chatRoom,
      showLabel: showLabel,
      onTap: () => Navigator.of(context).push(ChatScreen.buildRoute(options: options)),
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

class const ChatScreen({required final ChatOptions options}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute({required ChatOptions options}) {
    return buildScreenRoute(screen: ChatScreen(options: options));
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState() extends ConsumerState<ChatScreen> with RouteAware {
  RouteObserver<PageRoute<void>>? _pageRouteObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      _pageRouteObserver = pageRouteObserverOf(context)..subscribe(this, route);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifierProvider(widget.options)).onFocusRegained();
    });
  }

  @override
  void dispose() {
    _pageRouteObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    ref.read(chatNotifierProvider(widget.options)).markMessagesAsRead();
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authControllerProvider);
    final chatState = ref.watch(chatProvider(widget.options));
    return FocusDetector(
      onFocusRegained: () {
        if (context.mounted) {
          ref.read(chatNotifierProvider(widget.options)).onFocusRegained();
        }
      },
      onForegroundLost: () {
        if (context.mounted) {
          ref.read(chatNotifierProvider(widget.options)).onForegroundLost();
        }
      },
      child: switch (chatState) {
        AsyncValue(:final value?, hasValue: true) => PlatformScaffold(
          appBar: PlatformAppBar(
            title: widget.options is TvChatOptions
                ? Text(context.l10n.spectatorRoom)
                : widget.options.isPublic
                ? Text(context.l10n.chatRoom)
                : widget.options.opponent == null
                ? Text(context.l10n.chatRoom)
                : UserFullNameWidget(user: widget.options.opponent),
            centerTitle: true,
          ),
          // The context of the body, whose padding includes the glass app bar on iOS.
          body: Builder(
            builder: (context) {
              return MessageInputLayout(
                input: widget.options.writeable ? _ChatBottomBar(options: widget.options) : null,
                // The context of the messages, whose bottom padding is the input bar on iOS.
                messages: Builder(
                  builder: (context) {
                    final padding = MediaQuery.paddingOf(context);
                    return Column(
                      children: [
                        // Display error if there is one, but still show the messages if they are
                        // available
                        if (chatState.hasError)
                          Padding(
                            padding: EdgeInsets.only(top: padding.top),
                            child: Material(
                              color: Theme.of(context).colorScheme.errorContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  chatState.error.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onErrorContainer,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            // the top padding is taken by the error, if any
                            child: ListView.builder(
                              padding: padding.copyWith(top: chatState.hasError ? 0 : padding.top),
                              reverse: true,
                              itemCount: value.messages.length,
                              itemBuilder: (context, index) {
                                final message = value.messages[value.messages.length - index - 1];
                                return (message.username == 'lichess')
                                    ? _MessageAction(message: message.message)
                                    : (message.username == authUser?.user.name)
                                    ? _MessageBubble(
                                        options: widget.options,
                                        you: true,
                                        message: message,
                                      )
                                    : _MessageBubble(
                                        options: widget.options,
                                        you: false,
                                        message: message,
                                        showUsername: widget.options.isPublic,
                                      );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
        AsyncValue(:final error?) => PlatformScaffold(
          appBar: PlatformAppBar(title: Text(context.l10n.chatRoom)),
          body: Center(child: Text(error.toString())),
        ),
        _ => PlatformScaffold(
          appBar: PlatformAppBar(title: Text(context.l10n.chatRoom)),
          body: const Center(child: CircularProgressIndicator.adaptive()),
        ),
      },
    );
  }
}

class const _MessageBubble({
  required final ChatOptions options,
  required final bool you,
  required final ChatMessage message,
  final bool showUsername = false,
}) extends ConsumerWidget {
  Color _bubbleColor(BuildContext context) => you
      ? ColorScheme.of(context).secondary
      : Theme.of(context).cardTheme.color ?? ColorScheme.of(context).surfaceContainerHigh;

  Color _textColor(BuildContext context) =>
      you ? ColorScheme.of(context).onSecondary : ColorScheme.of(context).onSurface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ChatBubbleContextMenu(
      message: message.message,
      actions: [
        if (you == false && message.user != null)
          ContextMenuAction(
            icon: Icons.report_problem_outlined,
            label: 'Report',
            onPressed: () async {
              final result = await showAdaptiveDialog<bool>(
                context: context,
                builder: (context) => YesNoDialog(
                  content: Text(context.l10n.reportXToModerators('"${message.message}"')),
                  onYes: () {
                    return Navigator.of(context).pop(true);
                  },
                  onNo: () => Navigator.of(context).pop(false),
                ),
              );
              if (result == true) {
                ref.read(chatNotifierProvider(options)).reportMessage(message);
              }
            },
          ),
      ],
      child: FractionallySizedBox(
        alignment: you ? Alignment.centerRight : Alignment.centerLeft,
        widthFactor: 0.9,
        child: Align(
          alignment: you ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: _bubbleColor(context),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showUsername && message.user != null)
                  UserFullNameWidget(
                    user: message.user,
                    style: TextStyle(fontWeight: FontWeight.bold, color: _textColor(context)),
                    onTap: () =>
                        Navigator.of(context).push(UserOrProfileScreen.buildRoute(message.user!)),
                  ),
                RichLinkText(
                  onOpen: (link) async =>
                      await ref.read(appLinksServiceProvider).onLinkifyOpen(context, link),
                  linkifiers: AppLinksService.kLichessLinkifiers,
                  text: message.message,
                  style: TextStyle(color: _textColor(context)),
                  linkStyle: Styles.linkStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class const _MessageAction({required final String message}) extends StatelessWidget {
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

class const _ChatBottomBar({required final ChatOptions options}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatBottomBarState();
}

class _ChatBottomBarState() extends ConsumerState<_ChatBottomBar> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = ref.read(chatNotifierProvider(widget.options)).chatInputDraft;
    _textController.addListener(() {
      ref.read(chatNotifierProvider(widget.options)).chatInputDraft = _textController.text;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authControllerProvider);
    final sendButton = ValueListenableBuilder<TextEditingValue>(
      valueListenable: _textController,
      builder: (context, value, child) => SemanticIconButton(
        onPressed: authUser != null && value.text.isNotEmpty
            ? () {
                ref.read(chatNotifierProvider(widget.options)).postMessage(_textController.text);
                _textController.clear();
              }
            : null,
        icon: const Icon(Icons.send),
        padding: EdgeInsets.zero,
        semanticsLabel: context.l10n.send,
      ),
    );
    final placeholder = authUser != null ? context.l10n.talkInChat : context.l10n.loginToChat;
    return MessageInputBar(
      fallbackVerticalPadding: 8.0,
      field: TextField(
        decoration: messageInputDecoration(context, suffixIcon: sendButton, hintText: placeholder),
        controller: _textController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        minLines: 1,
        maxLines: 4,
        enableSuggestions: true,
        readOnly: authUser == null,
      ),
    );
  }
}
