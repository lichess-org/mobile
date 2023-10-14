import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class MessageScreen extends StatelessWidget {
  final String? name;
  const MessageScreen({this.name});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(context: context),
      iosBuilder: (context) => _iosBuilder(),
    );
  }

  Widget _androidBuilder({required BuildContext context}) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(name ?? "Chat room"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: 30,
              itemBuilder: (context, index) {
                // generate random messages
                final r = Random();
                final message = String.fromCharCodes(
                  List.generate(
                    r.nextInt(100) + 5,
                    (index) => r.nextInt(33) + 89,
                  ),
                );
                return _MessageBubble(
                  you: index.remainder(2) == 0,
                  message: message,
                );
              },
            ),
          ),
          _GameBottomBar(),
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

class _GameBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).bottomAppBarTheme.color,
      ),
      padding: Styles.horizontalBodyPadding,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyLarge,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  suffixIcon: PlatformIconButton(
                    onTap: () {},
                    icon: Icons.send,
                    semanticsLabel: 'Send',
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
