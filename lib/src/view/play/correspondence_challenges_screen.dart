import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/play/challenge_list_item.dart';
import 'package:lichess_mobile/src/view/play/create_correspondence_game_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class CorrespondenceChallengesScreen extends ConsumerStatefulWidget {
  const CorrespondenceChallengesScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const CorrespondenceChallengesScreen());
  }

  @override
  ConsumerState<CorrespondenceChallengesScreen> createState() => _ChallengesBodyState();
}

class _ChallengesBodyState extends ConsumerState<CorrespondenceChallengesScreen> {
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
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(GameScreen.buildRoute(context, source: ExistingGameSource(gameFullId)));
          }

        case 'reload_seeks':
          if (mounted) {
            ref.invalidate(correspondenceSeeksProvider);
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

    switch (challengesAsync) {
      case AsyncError():
        return const Scaffold(body: Center(child: Text('Could not load correspondence seeks')));
      case AsyncData(value: final seeks):
        final supportedSeeks = seeks.where((seek) => seek.variant.isPlaySupported).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.correspondence),
            actions: [
              if (authUser != null)
                IconButton(
                  icon: const Icon(Icons.add_circle_outlined),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return const CreateCorrespondenceGameBottomSheet();
                      },
                    ).then((_) {
                      ref.invalidate(correspondenceSeeksProvider);
                    });
                  },
                ),
            ],
          ),
          body: HapticRefreshIndicator(
            key: _refreshKey,
            onRefresh: () => ref.refresh(correspondenceSeeksProvider.future),
            child: ListView.separated(
              itemCount: supportedSeeks.length,
              separatorBuilder: (context, index) => Theme.of(context).platform == TargetPlatform.iOS
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
            ),
          ),
        );
      case _:
        return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
    }
  }
}
