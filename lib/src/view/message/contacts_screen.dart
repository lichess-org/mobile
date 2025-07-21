import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

final _contactsProvider = FutureProvider.autoDispose<IList<Contact>>((ref) async {
  final repo = ref.watch(messageRepositoryProvider);
  return await repo.loadContacts();
});

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inbox)),
      body: const ContactsListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle new message action
        },
        child: const Icon(Icons.message),
      ),
    );
  }

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const ContactsScreen());
  }
}

class ContactsListView extends ConsumerWidget {
  const ContactsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(_contactsProvider);

    final unreadStyle = TextStyle(
      color: ColorScheme.of(context).primary,
      fontWeight: FontWeight.bold,
    );

    switch (contactsAsync) {
      case AsyncData(:final value):
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final contact = value[index];
            return ListTile(
              leading: contact.user.isOnline == true
                  ? const Icon(Icons.cloud, color: Colors.green)
                  : const Icon(Icons.cloud_off, color: Colors.grey),
              title: UserFullNameWidget(user: contact.user, showFlair: true, showPatron: true),
              subtitle: Text(
                contact.lastMessage.text,
                style: contact.lastMessage.read ? null : unreadStyle,
              ),
              trailing: Text(
                relativeDate(context.l10n, contact.lastMessage.date),
                style: contact.lastMessage.read ? null : unreadStyle,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  ConversationScreen.buildRoute(context, user: contact.user),
                ).then(
                  (value) => ref.refresh(_contactsProvider), // Refresh contacts after returning
                );
              },
            );
          },
        );
      case AsyncError(:final error, :final stackTrace):
        debugPrint('Error loading contacts: $error, $stackTrace');
        return Center(child: Text('Could not load contacts: $error'));
      case _:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
