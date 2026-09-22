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
import 'package:material_ui/material_ui.dart';

class const PickPlayerScreen({
  required final void Function(LightUser) onUserTap,
  required final Widget title,
  super.key,
}) extends ConsumerWidget {
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

class const _Body({required final void Function(LightUser) onUserTap}) extends ConsumerWidget {
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

class const _PlayersList({
  required final void Function(LightUser) onUserTap,
  required final List<Widget> children,
}) extends StatefulWidget {
  @override
  State<_PlayersList> createState() => _PlayersListState();
}

class _PlayersListState() extends State<_PlayersList> {
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

class _AlwaysDisabledFocusNode() extends FocusNode {
  @override
  bool get hasFocus => false;
}

class const _FriendTile({
  required final LightUser friend,
  required final void Function(LightUser) onUserTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: UserFullNameWidget(user: friend),
      onTap: () => onUserTap(friend),
    );
  }
}
