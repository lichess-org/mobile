import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required void Function(LightUser) onUserTap,
    required Widget title,
  }) {
    return buildScreenRoute(
      context,
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
    switch (ref.watch(onlineAndFollowingProvider)) {
      case AsyncData(value: (final online, final following)):
        return _PlayersList(
          onUserTap: onUserTap,
          children: [
            if (online.isNotEmpty)
              ListSection(
                header: Text(context.l10n.nbFriendsOnline(online.length)),
                children: [
                  for (final friend in online)
                    _FriendTile(friend: friend.user, onUserTap: onUserTap),
                ],
              ),
            if (following.isNotEmpty)
              ListSection(
                header: Text(context.l10n.following),
                children: [
                  for (final user in following)
                    _FriendTile(friend: user.lightUser, onUserTap: onUserTap),
                ],
              ),
          ],
        );
      case AsyncError(:final error, :final stackTrace):
        debugPrint(
          'SEVERE: [PickPlayerScreen] could not load following users; $error\n$stackTrace',
        );
        return FullScreenRetryRequest(onRetry: () => ref.invalidate(onlineAndFollowingProvider));
      case _:
        return _PlayersList(
          onUserTap: onUserTap,
          children: [
            Shimmer(
              child: ShimmerLoading(isLoading: true, child: ListSection.loading(itemsNumber: 5)),
            ),
            Shimmer(
              child: ShimmerLoading(isLoading: true, child: ListSection.loading(itemsNumber: 5)),
            ),
          ],
        );
    }
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
                context,
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
