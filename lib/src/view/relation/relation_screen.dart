import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/relation/relation_ctrl.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class RelationScreen extends ConsumerStatefulWidget {
  const RelationScreen({super.key});
  @override
  ConsumerState<RelationScreen> createState() => _RelationScreenState();
}

class _RelationScreenState extends ConsumerState<RelationScreen>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    ref.read(relationCtrlProvider.notifier).getFollowingOnlines();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.friends),
      ),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(child: _OnlineFriendsWidget());
  }
}

class _OnlineFriendsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = relationCtrlProvider;
    final relationState = ref.watch(ctrlProvider);

    return relationState.when(
      data: (data) {
        return ListSection(
          hasLeading: true,
          header: Text(
            '${data.followingOnlines.length} Online ${context.l10n.friends}', // TODO: we need good translations for this
          ),
          headerTrailing: data.followingOnlines.isEmpty
              ? null
              : NoPaddingTextButton(
                  onPressed: () {},
                  child: Text(
                    context.l10n.more,
                  ),
                ),
          children: [
            if (data.followingOnlines.isEmpty)
              PlatformListTile(
                title: Text(
                  context.l10n.friends,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {},
              ),
            for (final username in data.followingOnlines)
              PlatformListTile(title: Text(username.toString())),
          ],
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text('$error'),
        );
      },
    );
  }
}
