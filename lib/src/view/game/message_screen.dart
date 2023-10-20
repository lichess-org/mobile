import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/view/game/message.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final GameControllerProvider ctrlProvider;
  final void Function(String message) onMessage;
  const MessageScreen({
    required this.ctrlProvider,
    required this.onMessage,
  });

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
    ref.read(widget.ctrlProvider.notifier).resetUnreadMessages();
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(widget.ctrlProvider).requireValue;

    return PlatformWidget(
      androidBuilder: (context) =>
          _androidBuilder(context: context, gameState: gameState),
      iosBuilder: (context) => _iosBuilder(),
    );
  }

  Widget _androidBuilder({
    required BuildContext context,
    required GameState gameState,
  }) {
    final IList<Message> messages = gameState.messages;
    final Player opponent = gameState.game.opponent!;
    final title = opponent.user?.title != null
        ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: opponent.user!.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LichessColors.brag,
                  ),
                ),
                const TextSpan(text: " "),
                TextSpan(text: opponent.displayName(context)),
              ],
            ),
          )
        : Text(opponent.displayName(context));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: title,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - index - 1];
                return switch (message.sender) {
                  Sender.server => _MessageAction(message: message.message),
                  Sender.player => _MessageBubble(
                      you: true,
                      message: message.message,
                    ),
                  Sender.opponent => _MessageBubble(
                      you: false,
                      message: message.message,
                    )
                };
              },
            ),
          ),
          _GameBottomBar(onMessage: widget.onMessage),
        ],
      ),
    );
  }

  Widget _iosBuilder() {
    return const SizedBox.shrink();
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

class _GameBottomBar extends StatefulWidget {
  final void Function(String message) onMessage;

  const _GameBottomBar({required this.onMessage});

  @override
  State<StatefulWidget> createState() => _GameBottomBarState();
}

class _GameBottomBarState extends State<_GameBottomBar> {
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
                              widget.onMessage(_textController.text);
                              _textController.clear();
                            }
                          : null,
                      icon: Icons.send,
                      semanticsLabel: 'Send',
                    ),
                  ),
                  border: InputBorder.none,
                  hintText: "Be nice in the chat",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
