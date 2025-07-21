import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/message/message_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class ConversationScreen extends ConsumerWidget {
  final LightUser user;

  const ConversationScreen({super.key, required this.user});

  static Route<dynamic> buildRoute(BuildContext context, {required LightUser user}) {
    return buildScreenRoute(context, screen: ConversationScreen(user: user));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageStateAsync = ref.watch(messageControllerProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: UserFullNameWidget(user: user, showFlair: true, showPatron: true)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messageStateAsync.when(
                data: (state) {
                  final convo = state.convo;
                  final messages = convo.messages;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.userId == state.me.id;
                      return FractionallySizedBox(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        widthFactor: 0.85,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                            color: isMe
                                ? ColorScheme.of(context).secondary
                                : ColorScheme.of(context).surfaceContainerHigh,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                              bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: isMe
                                  ? ColorScheme.of(context).onSecondary
                                  : ColorScheme.of(context).onSurface,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
            _MessageInput(userId: user.id),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends ConsumerStatefulWidget {
  final UserId userId;
  const _MessageInput({required this.userId});

  @override
  ConsumerState<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends ConsumerState<_MessageInput> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(child: TextField(controller: controller)),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref
                    .read(messageControllerProvider(widget.userId).notifier)
                    .sendMessage(widget.userId, text);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
