import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/relation/following_user.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:lichess_mobile/src/view/relation/friend_screen.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

final followingCarouselProvider = FutureProvider.autoDispose<IList<FollowingUser>>((ref) {
  return ref.watch(relationRepositoryProvider).getRecentFollowing();
}, name: 'FollowingCarouselProvider');

/// A carousel widget that displays a list of users that the current user is following.
class FollowingCarousel extends ConsumerStatefulWidget {
  const FollowingCarousel(this.followingAsync, {super.key});

  final AsyncValue<IList<FollowingUser>> followingAsync;

  @override
  ConsumerState<FollowingCarousel> createState() => _FollowingWidgetState();
}

class _FollowingWidgetState extends ConsumerState<FollowingCarousel> {
  @override
  Widget build(BuildContext context) {
    return widget.followingAsync.when(
      loading: () => _buildLoadingSkeleton(context),
      error: (e, s) => const SizedBox.shrink(),
      data: (users) {
        if (users.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: Styles.verticalBodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: Styles.horizontalBodyPadding,
                child: ListSectionHeader(
                  title: Text(context.l10n.friends),
                  onTap: () {
                    Navigator.of(context).push(FriendScreen.buildRoute());
                  },
                ),
              ),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
                  itemCount: users.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final friend = users[index];

                    return SizedBox(
                      width: 160,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                          onTap: () {
                            Navigator.of(context).push(UserOrProfileScreen.buildRoute(friend.user));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: .start,
                              mainAxisAlignment: .center,
                              children: [
                                UserFullNameWidget(
                                  user: friend.user,
                                  style: const TextStyle(fontWeight: .w500, fontSize: 16),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    friend.playing == true
                                        ? context.l10n.playingRightNow
                                        : friend.user.isOnline == true
                                        ? context.l10n.online.capitalize()
                                        : friend.seenAt != null
                                        ? context.l10n.lastSeenActive(
                                            relativeDate(context.l10n, friend.seenAt!),
                                          )
                                        : context.l10n.offline.capitalize(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textShade(context, Styles.subtitleOpacity),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Center(child: _buildActionButtons(context, ref, friend)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildActionButtons(BuildContext context, WidgetRef ref, FollowingUser friend) {
  final compactStyle = IconButton.styleFrom(
    visualDensity: VisualDensity.compact,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  const iconSize = 20.0;

  return Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      if (friend.playing == true)
        IconButton.filledTonal(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(TvScreen.buildRoute(user: friend.user));
          },
          icon: const Icon(Icons.live_tv_outlined),
          iconSize: iconSize,
          tooltip: context.l10n.watchGames,
          style: compactStyle,
        ),
      const Spacer(),
      ContextMenuIconButton(
        consumeOutsideTap: true,
        isCompact: true,
        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        icon: const Icon(Icons.more_horiz),
        semanticsLabel: context.l10n.more,
        actions: [
          ContextMenuAction(
            icon: Icons.chat_bubble_outline,
            label: context.l10n.message,
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).push(ConversationScreen.buildRoute(user: friend.user));
            },
          ),
          ContextMenuAction(
            icon: LichessIcons.crossed_swords,
            label: context.l10n.challengeChallengeToPlay,
            onPressed: () {
              UserScreen.challengeUser(friend.user, context: context, ref: ref);
            },
          ),
        ],
      ),
    ],
  );
}

Widget _buildLoadingSkeleton(BuildContext context) {
  return Padding(
    padding: Styles.verticalBodyPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: ListSectionHeader(
            title: Text(context.l10n.friends),
            onTap: () {
              Navigator.of(context).push(FriendScreen.buildRoute());
            },
          ),
        ),
        Shimmer(
          child: ShimmerLoading(
            isLoading: true,
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(height: 16, width: 100, color: Theme.of(context).cardColor),
                            const Spacer(),
                            Container(height: 12, width: 60, color: Theme.of(context).cardColor),
                            const SizedBox(height: 8),
                            Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
