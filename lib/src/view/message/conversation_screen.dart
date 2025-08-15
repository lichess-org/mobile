import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/app_links.dart';
import 'package:lichess_mobile/src/model/message/conversation_controller.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

sealed class DisplayItem {}

class DateItem extends DisplayItem {
  final DateTime date;
  DateItem(this.date);
}

class MessageItem extends DisplayItem {
  final Message message;
  final bool isMe;
  final int groupLength;
  final int groupIndex;
  MessageItem(
    this.message, {
    required this.isMe,
    required this.groupLength,
    required this.groupIndex,
  });
}

class GetMoreItem extends DisplayItem {}

class ContactTypingItem extends DisplayItem {}

class ConversationScreen extends ConsumerStatefulWidget {
  final LightUser user;

  const ConversationScreen({super.key, required this.user});

  static Route<dynamic> buildRoute(BuildContext context, {required LightUser user}) {
    return buildScreenRoute(context, screen: ConversationScreen(user: user));
  }

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> with RouteAware {
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
    ref.invalidate(unreadMessagesProvider);
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UserFullNameWidget(
          user: widget.user,
          showFlair: true,
          showPatron: true,
          shouldShowOnline: true,
          onTap: () {
            Navigator.push(context, UserScreen.buildRoute(context, widget.user));
          },
        ),
      ),
      body: _Body(user: widget.user),
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
                        return _MessageBubble(
                          message: message,
                          isMe: isMe,
                          groupLength: item.groupLength,
                          groupIndex: item.groupIndex,
                        );
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

  List<List<Message>> _groupContiguousByUser(List<Message> messages) {
    final grouped = <List<Message>>[];
    if (messages.isEmpty) return grouped;

    var currentGroup = <Message>[];
    for (final message in messages) {
      if (currentGroup.isEmpty || currentGroup.last.userId == message.userId) {
        currentGroup.add(message);
      } else {
        grouped.add(currentGroup);
        currentGroup = [message];
      }
    }
    if (currentGroup.isNotEmpty) {
      grouped.add(currentGroup);
    }
    return grouped;
  }

  List<DisplayItem> buildDisplayItems(ConversationState state) {
    final messages = state.convo.messages;
    final items = <DisplayItem>[];
    DateTime? currentDate;
    final List<Message> dayMessages = [];

    items.add(ContactTypingItem());

    void processDayMessages() {
      final byUser = _groupContiguousByUser(dayMessages);
      for (final group in byUser) {
        for (var i = 0; i < group.length; i++) {
          final m = group[i];
          items.add(
            MessageItem(m, isMe: m.userId == state.me.id, groupLength: group.length, groupIndex: i),
          );
        }
      }
    }

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final messageDate = DateTime(message.date.year, message.date.month, message.date.day);
      final isNewDay = currentDate == null || currentDate != messageDate;
      final isLast = i == messages.length - 1;

      if (isNewDay && dayMessages.isNotEmpty) {
        processDayMessages();
        items.add(DateItem(currentDate!));
        dayMessages.clear();
      }

      currentDate = messageDate;
      dayMessages.add(message);

      if (isLast) {
        processDayMessages();
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
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.groupLength,
    required this.groupIndex,
  });

  final Message message;
  final bool isMe;
  final int groupLength;
  final int groupIndex;

  Color _bubbleColor(BuildContext context) {
    return isMe
        ? ColorScheme.of(context).secondaryContainer
        : ColorScheme.of(context).surfaceContainer;
  }

  Color _textColor(BuildContext context) {
    return isMe ? ColorScheme.of(context).onSecondaryContainer : ColorScheme.of(context).onSurface;
  }

  bool get isInGroup => groupLength > 1;
  bool get isFirstInGroup => groupIndex == 0;
  bool get isLastInGroup => groupIndex == groupLength - 1;

  static const _bubbleRadius = Radius.circular(16);
  static const _inGroupRadius = Radius.circular(4);

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm().format(message.date);

    return FractionallySizedBox(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 0.85,
      child: Container(
        margin: EdgeInsets.only(
          bottom: !isInGroup || isFirstInGroup ? 8 : 2,
          top: !isInGroup || isLastInGroup ? 8 : 2,
          left: 8,
          right: 8,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: _bubbleColor(context),
          borderRadius: BorderRadius.only(
            topLeft: isMe
                ? _bubbleRadius
                : isInGroup && !isLastInGroup
                ? _inGroupRadius
                : _bubbleRadius,
            topRight: isMe
                ? isInGroup && !isLastInGroup
                      ? _inGroupRadius
                      : _bubbleRadius
                : _bubbleRadius,
            bottomLeft: isMe
                ? _bubbleRadius
                : isInGroup && !isFirstInGroup
                ? _inGroupRadius
                : _bubbleRadius,
            bottomRight: isMe
                ? isInGroup && !isFirstInGroup
                      ? _inGroupRadius
                      : _bubbleRadius
                : _bubbleRadius,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Linkify(
              onOpen: (link) => onLinkifyOpen(context, link),
              linkifiers: kLichessLinkifiers,
              text: message.text,
              style: TextStyle(color: _textColor(context)),
              linkStyle: Styles.linkStyle,
            ),
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
