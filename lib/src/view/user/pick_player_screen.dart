import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/relation/friend_screen.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

class PickPlayerScreen extends ConsumerWidget {
  const PickPlayerScreen({required this.onUserTap, required this.title, super.key});

  final void Function(LightUser) onUserTap;
  final Widget title;

  static Route<dynamic> buildRoute({
    required void Function(LightUser) onUserTap,
    required Widget title,
  }) {
    return buildScreenRoute(
      screen: PickPlayerScreen(onUserTap: onUserTap, title: title),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: title),
      body: _Body(onUserTap: onUserTap),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.onUserTap});

  final void Function(LightUser) onUserTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(onlineFriendsProvider);
    final following = ref.watch(followingProvider);

    if (following case AsyncError(:final error, :final stackTrace)) {
      debugPrint('SEVERE: [PickPlayerScreen] could not load following users; $error\n$stackTrace');
      return FullScreenRetryRequest(onRetry: () => ref.invalidate(followingProvider));
    }

    return _PlayersList(
      onUserTap: onUserTap,
      children: [
        switch (online) {
          AsyncData(:final value) when value.isNotEmpty => ListSection(
            header: Text(context.l10n.nbFriendsOnline(value.length)),
            children: [
              for (final friend in value) _FriendTile(friend: friend.user, onUserTap: onUserTap),
            ],
          ),
          _ => const SizedBox.shrink(),
        },
        switch (following) {
          AsyncData(:final value) when value.isNotEmpty => ListSection(
            header: Text(context.l10n.following),
            children: [
              for (final user in value) _FriendTile(friend: user.lightUser, onUserTap: onUserTap),
            ],
          ),
          AsyncData() => const SizedBox.shrink(),
          _ => Shimmer(
            child: ShimmerLoading(isLoading: true, child: ListSection.loading(itemsNumber: 5)),
          ),
        },
      ],
    );
  }
}

class _PlayersList extends StatefulWidget {
  const _PlayersList({required this.onUserTap, required this.children});

  final void Function(LightUser) onUserTap;
  final List<Widget> children;

  @override
  State<_PlayersList> createState() => _PlayersListState();
}

class _PlayersListState extends State<_PlayersList> {
  final _searchFocusNode = _AlwaysDisabledFocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: PlatformSearchBar(
            hintText: context.l10n.searchSearch,
            focusNode: _searchFocusNode,
            onTap: () => Navigator.of(context).push(
              SearchScreen.buildRoute(
                onUserTap: (user) {
                  Navigator.of(context).pop();
                  widget.onUserTap(user);
                },
              ),
            ),
          ),
        ),
        ...widget.children,
      ],
    );
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({required this.friend, required this.onUserTap});

  final LightUser friend;
  final void Function(LightUser) onUserTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: UserFullNameWidget(user: friend),
      onTap: () => onUserTap(friend),
    );
  }
}
