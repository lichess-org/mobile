import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

final messageSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final messageSearchResultsProvider = FutureProvider.autoDispose<SearchResult>((ref) async {
  final repo = ref.read(messageRepositoryProvider);
  final query = ref.watch(messageSearchQueryProvider);
  if (query.length < 3) {
    return _emptySearchResult;
  }
  return await repo.search(query);
});

const _emptySearchResult = SearchResult(
  contacts: IListConst([]),
  friends: IListConst([]),
  users: IListConst([]),
);

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const ContactsScreen());
  }
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final onChangedDebouncer = Debouncer(const Duration(milliseconds: 300));
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    onChangedDebouncer.cancel();
    super.dispose();
  }

  Future<void> pushConversationScreen(LightUser user) async {
    await Navigator.push(context, ConversationScreen.buildRoute(context, user: user));
    ref.invalidate(contactsProvider);
    ref.read(messageSearchQueryProvider.notifier).state = '';
    controller.clear();
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(messageSearchQueryProvider);
    final searchResultsAsync = ref.watch(messageSearchResultsProvider);
    final me = ref.watch(authSessionProvider)?.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.inbox),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            Theme.of(context).platform == TargetPlatform.iOS ? 52.0 : kToolbarHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: PlatformSearchBar(
              controller: controller,
              focusNode: focusNode,
              hintText: context.l10n.searchOrStartNewDiscussion,
              onChanged: (value) {
                onChangedDebouncer.call(() {
                  ref.read(messageSearchQueryProvider.notifier).state = value;
                });
              },
            ),
          ),
        ),
      ),
      body: searchQuery.isNotEmpty && me != null
          ? searchResultsAsync.when(
              data: (result) => ListView(
                children: [
                  if (result.contacts.isNotEmpty) _SearchCategoryTitle(context.l10n.discussions),
                  ...result.contacts.map(
                    (contact) => ContactTile(contact, me, openConvo: pushConversationScreen),
                  ),
                  if (result.friends.isNotEmpty) _SearchCategoryTitle(context.l10n.friends),
                  ...result.friends.map(
                    (user) => UserTile(user, openConvo: pushConversationScreen),
                  ),
                  if (result.users.isNotEmpty) _SearchCategoryTitle(context.l10n.players),
                  ...result.users.map((user) => UserTile(user, openConvo: pushConversationScreen)),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            )
          : HapticRefreshIndicator(
              onRefresh: () => ref.refresh(contactsProvider.future),
              child: ContactsListView(openConvo: pushConversationScreen),
            ),
    );
  }
}

class _SearchCategoryTitle extends StatelessWidget {
  const _SearchCategoryTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}

class ContactsListView extends ConsumerWidget {
  const ContactsListView({required this.openConvo, super.key});

  final void Function(LightUser user) openConvo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsProvider);

    switch (contactsAsync) {
      case AsyncData(:final value):
        final contacts = value.contacts;
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ContactTile(contact, value.me, openConvo: openConvo);
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

class ContactTile extends ConsumerWidget {
  const ContactTile(this.contact, this.me, {required this.openConvo, super.key});

  final Contact contact;
  final LightUser me;
  final void Function(LightUser user) openConvo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadStyle = TextStyle(
      color: ColorScheme.of(context).primary,
      fontWeight: FontWeight.bold,
    );

    final isRead = contact.lastMessage.read || contact.lastMessage.userId == me.id;
    return ListTile(
      leading: ConnectedIcon(isConnected: contact.user.isOnline == true),
      title: UserFullNameWidget(user: contact.user, showFlair: true, showPatron: true),
      subtitle: Text(contact.lastMessage.text, style: isRead ? null : unreadStyle),
      trailing: Text(
        relativeDate(context.l10n, contact.lastMessage.date),
        style: isRead ? null : unreadStyle,
      ),
      onTap: () {
        openConvo(contact.user);
      },
    );
  }
}

class UserTile extends ConsumerWidget {
  const UserTile(this.user, {required this.openConvo, super.key});

  final LightUser user;
  final void Function(LightUser user) openConvo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: user.isOnline == true
          ? const Icon(Icons.cloud, color: Colors.green)
          : const Icon(Icons.cloud_off, color: Colors.grey),
      title: UserFullNameWidget(user: user, showFlair: true, showPatron: true),
      onTap: () {
        openConvo(user);
      },
    );
  }
}
