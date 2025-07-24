import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/message/conversation_controller.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

sealed class DisplayItem {}

class DateItem extends DisplayItem {
  final DateTime date;
  DateItem(this.date);
}

class MessageItem extends DisplayItem {
  final Message message;
  final bool isMe;
  MessageItem(this.message, this.isMe);
}

class GetMoreItem extends DisplayItem {}

class ContactTypingItem extends DisplayItem {}

class ConversationScreen extends StatelessWidget {
  final LightUser user;

  const ConversationScreen({super.key, required this.user});

  static Route<dynamic> buildRoute(BuildContext context, {required LightUser user}) {
    return buildScreenRoute(context, screen: ConversationScreen(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UserFullNameWidget(
          user: user,
          showFlair: true,
          showPatron: true,
          shouldShowOnline: true,
        ),
      ),
      body: _Body(user: user),
    );
  }
}

class _Body extends ConsumerWidget {
  final LightUser user;

  const _Body({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageStateAsync = ref.watch(conversationControllerProvider(user.id));

    switch (messageStateAsync) {
      case AsyncData(:final value):
        final items = buildDisplayItems(value);
        return Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView.builder(
                  // remove the automatic bottom padding of the ListView which is here taken care
                  // of by the _MessageInput
                  padding: MediaQuery.paddingOf(context).copyWith(bottom: 0),
                  reverse: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    switch (item) {
                      case DateItem(:final date):
                        return _DateBubble(date: date);
                      case MessageItem(:final message, :final isMe):
                        return _MessageBubble(message: message, isMe: isMe);
                      case GetMoreItem():
                        return Center(
                          child: TextButton(
                            onPressed: () => ref
                                .read(conversationControllerProvider(user.id).notifier)
                                .getMore(),
                            child: const Text('Load more'),
                          ),
                        );
                      case ContactTypingItem():
                        return _ContactTyping(user: user);
                    }
                  },
                ),
              ),
            ),
            _MessageInput(user: user, state: value),
          ],
        );
      case AsyncError(error: final e, stackTrace: final st):
        debugPrint('Error loading messages for ${user.id}: $e\n$st');
        return Center(child: Text('Error: $e'));
      case _:
        return const Center(child: CircularProgressIndicator());
    }
  }

  List<DisplayItem> buildDisplayItems(ConversationState state) {
    final messages = state.convo.messages;
    final items = <DisplayItem>[];
    DateTime? currentDate;
    final List<Message> dayMessages = [];

    items.add(ContactTypingItem());

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final messageDate = DateTime(message.date.year, message.date.month, message.date.day);
      final isNewDay = currentDate == null || currentDate != messageDate;
      final isLast = i == messages.length - 1;

      if (isNewDay && dayMessages.isNotEmpty) {
        for (final m in dayMessages) {
          items.add(MessageItem(m, m.userId == state.me.id));
        }
        items.add(DateItem(currentDate!));
        dayMessages.clear();
      }

      currentDate = messageDate;
      dayMessages.add(message);

      if (isLast) {
        for (final m in dayMessages) {
          items.add(MessageItem(m, m.userId == state.me.id));
        }
        items.add(DateItem(currentDate));
      }
    }

    if (state.canGetMoreSince != null) {
      items.add(GetMoreItem());
    }

    return items;
  }
}

class _ContactTyping extends ConsumerWidget {
  final LightUser user;

  const _ContactTyping({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTyping = ref.watch(
      conversationControllerProvider(
        user.id,
      ).select((state) => state.valueOrNull?.contactTyping == true),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: isTyping
          ? Text(
              '${user.name} is typing...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
              ),
            )
          : Text(
              '', // Empty text to maintain layout when not typing
              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
            ),
    );
  }
}

class _DateBubble extends StatelessWidget {
  final DateTime date;
  const _DateBubble({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final aDate = DateTime(date.year, date.month, date.day);
    final formatted = DateFormat.yMMMd().format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            aDate.isAtSameMomentAs(today)
                ? context.l10n.today
                : aDate.isAtSameMomentAs(yesterday)
                ? context.l10n.yesterday
                : formatted,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer.withValues(alpha: 0.8),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  Color _bubbleColor(BuildContext context) {
    return isMe
        ? ColorScheme.of(context).secondaryContainer
        : ColorScheme.of(context).surfaceContainerHighest;
  }

  Color _textColor(BuildContext context) {
    return isMe ? ColorScheme.of(context).onSecondaryContainer : ColorScheme.of(context).onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm().format(message.date);

    return FractionallySizedBox(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 0.85,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: _bubbleColor(context),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.text, style: TextStyle(color: _textColor(context))),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(fontSize: 11, color: _textColor(context).withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends ConsumerStatefulWidget {
  const _MessageInput({required this.user, required this.state});

  final LightUser user;
  final ConversationState state;

  @override
  ConsumerState<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends ConsumerState<_MessageInput> {
  final controller = TextEditingController();

  bool get isBlocked =>
      widget.state.convo.relations.inward == false || widget.state.convo.relations.outward == false;

  bool get isBot => widget.state.isBot;

  bool get canPost => widget.state.convo.postable;

  bool get readOnly => isBlocked || isBot || !canPost;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.text.isNotEmpty) {
        ref.read(conversationControllerProvider(widget.user.id).notifier).setTyping(widget.user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sendButton = IconButton(
      icon: Icon(readOnly ? Icons.block : Icons.send),
      onPressed: () {
        final text = controller.text.trim();
        if (text.isNotEmpty) {
          ref
              .read(conversationControllerProvider(widget.user.id).notifier)
              .sendMessage(widget.user.id, text);
          controller.clear();
        }
      },
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            suffixIcon: sendButton,
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            hintText: isBlocked
                ? 'This conversation is blocked.'
                : isBot
                ? 'Bot accounts cannot send nor receive messages.'
                : !canPost
                ? "${widget.user.name} doesn't accept new messages."
                : null,
          ),
          controller: controller,
          keyboardType: TextInputType.text,
          minLines: 1,
          maxLines: 4,
          enableSuggestions: true,
          readOnly: readOnly,
        ),
      ),
    );
  }
}
