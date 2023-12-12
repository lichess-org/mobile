import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/game/chat_controller.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final Widget title;
  final LightUser? me;

  const MessageScreen({required this.title, this.me});

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
    ref.read(chatControllerProvider.notifier).resetUnreadMessages();
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final body = _Body(me: widget.me);

    return PlatformWidget(
      androidBuilder: (context) =>
          _androidBuilder(context: context, body: body),
      iosBuilder: (context) => _iosBuilder(context: context, body: body),
    );
  }

  Widget _androidBuilder({
    required BuildContext context,
    required Widget body,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        centerTitle: true,
      ),
      body: body,
    );
  }

  Widget _iosBuilder({
    required BuildContext context,
    required Widget body,
  }) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: widget.title,
      ),
      child: body,
    );
  }
}

class _Body extends ConsumerWidget {
  final LightUser? me;

  const _Body({
    required this.me,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatControllerProvider);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView.builder(
              // remove the automatic bottom padding of the ListView, which on iOS
              // corresponds to the safe area insets
              // and which is here taken care of by the _ChatBottomBar
              padding: MediaQuery.of(context).padding.copyWith(bottom: 0),
              reverse: true,
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final message =
                    chatState.messages[chatState.messages.length - index - 1];
                return (message.username == "lichess")
                    ? _MessageAction(message: message.message)
                    : (message.username == me?.name)
                        ? _MessageBubble(
                            you: true,
                            message: message.message,
                          )
                        : _MessageBubble(
                            you: false,
                            message: message.message,
                          );
              },
            ),
          ),
        ),
        _ChatBottomBar(),
      ],
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  final bool you;
  final String message;

  const _MessageBubble({required this.you, required this.message});

  Color _bubbleColor(BuildContext context, Brightness brightness) =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? you
              ? LichessColors.green
              : CupertinoColors.systemGrey4.resolveFrom(context)
          : you
              ? Theme.of(context).colorScheme.secondaryContainer
              : brightness == Brightness.light
                  ? lighten(LichessColors.grey)
                  : darken(LichessColors.grey, 0.5);

  Color _textColor(BuildContext context, Brightness brightness) =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? you
              ? Colors.white
              : CupertinoColors.label.resolveFrom(context)
          : you
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : brightness == Brightness.light
                  ? Colors.black
                  : Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(currentBrightnessProvider);

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
          child: Text(
            message,
            style: TextStyle(
              color: _textColor(context, brightness),
            ),
          ),
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
    final sendButton = ValueListenableBuilder<TextEditingValue>(
      valueListenable: _textController,
      builder: (context, value, child) => PlatformIconButton(
        onTap: value.text.isNotEmpty
            ? () {
                ref
                    .read(chatControllerProvider.notifier)
                    .onUserMessage(_textController.text);
                _textController.clear();
              }
            : null,
        icon: Icons.send,
        padding: EdgeInsets.zero,
        semanticsLabel: context.l10n.send,
      ),
    );
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: AdaptiveTextField(
          materialDecoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            suffixIcon: sendButton,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            hintText: context.l10n.talkInChat,
          ),
          cupertinoDecoration: BoxDecoration(
            border: Border.all(
              color: CupertinoColors.separator.resolveFrom(context),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          ),
          controller: _textController,
          keyboardType: TextInputType.text,
          minLines: 1,
          maxLines: 4,
          placeholder: context.l10n.talkInChat,
          suffix: sendButton,
          enableSuggestions: true,
        ),
      ),
    );
  }
}
