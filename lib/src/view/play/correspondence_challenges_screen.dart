import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/play/challenge_list_item.dart';
import 'package:lichess_mobile/src/view/play/create_correspondence_game_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

class const CorrespondenceChallengesScreen({super.key}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const CorrespondenceChallengesScreen());
  }

  @override
  ConsumerState<CorrespondenceChallengesScreen> createState() => _ChallengesBodyState();
}

class _ChallengesBodyState() extends ConsumerState<CorrespondenceChallengesScreen> {
  StreamSubscription<SocketEvent>? _socketSubscription;

  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  late SocketClient socketClient;

  @override
  void initState() {
    super.initState();

    socketClient = ref.read(socketPoolProvider).open(Uri(path: '/lobby/socket/v5'));

    _socketSubscription = socketClient.stream.listen((event) {
      switch (event.topic) {
        // redirect after accepting a correpondence seek
        case 'redirect':
          final data = event.data as Map<String, dynamic>;
          final gameFullId = pick(data['id']).asGameFullIdOrThrow();
          if (mounted) {
            Navigator.of(context)
                .pushHidingTabBar(GameScreen.buildRoute(source: ExistingGameSource(gameFullId)));
          }

        case 'reload_seeks':
          if (mounted) {
            ref.read(correspondenceSeeksProvider.notifier).reload();
          }
      }
    });
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challengesAsync = ref.watch(correspondenceSeeksProvider);
    final authUser = ref.watch(authControllerProvider);
    final supportedSeeks = challengesAsync.value
        ?.where((seek) => seek.variant.isPlaySupported)
        .toList();

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.correspondence)),
      floatingActionButton: PlatformFloatingActionButton(
        onPressed: () {
          if (authUser == null) {
            showSnackBar(context, context.l10n.youNeedAnAccountToDoThat);
            return;
          }
          showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return const CreateCorrespondenceGameBottomSheet();
            },
          ).then((_) {
            if (mounted) {
              ref.read(correspondenceSeeksProvider.notifier).reload();
            }
          });
        },
        label: context.l10n.createAGame,
        icon: const Icon(Icons.add_circle_outline),
      ),
      body: HapticRefreshIndicator(
        key: _refreshKey,
        onRefresh: () => ref.read(correspondenceSeeksProvider.notifier).reload(),
        child: supportedSeeks != null
            ? ListView.separated(
                itemCount: supportedSeeks.length,
                separatorBuilder: (context, index) =>
                    Theme.of(context).platform == TargetPlatform.iOS
                    ? const PlatformDivider(height: 1, cupertinoHasLeading: true)
                    : const SizedBox.shrink(),
                itemBuilder: (context, index) {
                  final seek = supportedSeeks[index];
                  final isMySeek = UserId.fromUserName(seek.username) == authUser?.user.id;

                  return CorrespondenceChallengeListItem(
                    seek: seek,
                    challengerUser: LightUser(
                      id: UserId.fromUserName(seek.username),
                      name: seek.username,
                      title: seek.title,
                    ),
                    onPressed: isMySeek
                        ? null
                        : authUser == null
                        ? () {
                            showSnackBar(context, context.l10n.youNeedAnAccountToDoThat);
                          }
                        : () {
                            showConfirmDialog<void>(
                              context,
                              title: Text(context.l10n.accept),
                              isDestructiveAction: true,
                              onConfirm: () {
                                socketClient.send('joinSeek', seek.id.toString());
                              },
                            );
                          },
                    onCancel: isMySeek
                        ? () {
                            socketClient.send('cancelSeek', seek.id.toString());
                          }
                        : null,
                  );
                },
              )
            : challengesAsync is AsyncError
            // scrollable, so that the error can be retried with a pull to refresh
            ? LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: const Center(child: Text('Could not load correspondence seeks')),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
