import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/game/chat_controller.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
      children: [
        Expanded(
          child: ListView.builder(
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
        _ChatBottomBar(),
      ],
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  final bool you;
  final String message;

  const _MessageBubble({required this.you, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(currentBrightnessProvider);

    return FractionallySizedBox(
      alignment: you ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 0.9,
      child: Align(
        alignment: you ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: you
                ? Theme.of(context).colorScheme.surfaceVariant
                : brightness == Brightness.light
                    ? lighten(LichessColors.grey)
                    : darken(LichessColors.grey, 0.5),
          ),
          child: Text(
            message,
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
          margin: const EdgeInsets.all(10.0),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(40.0),
        color: Theme.of(context).bottomAppBarTheme.color,
      ),
      margin: const EdgeInsets.all(10.0),
      padding: Styles.horizontalBodyPadding,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyLarge,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
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
                      semanticsLabel: context.l10n.send,
                    ),
                  ),
                  border: InputBorder.none,
                  hintText: context.l10n.talkInChat,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
