import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/relation/following_user.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/relation/friend_screen.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

class FollowingWidget extends ConsumerStatefulWidget {
  const FollowingWidget({super.key});

  @override
  ConsumerState<FollowingWidget> createState() => _FollowingWidgetState();
}

class _FollowingWidgetState extends ConsumerState<FollowingWidget> {
  @override
  Widget build(BuildContext context) {
    final followingAsync = ref.watch(followingCarouselProvider);

    return followingAsync.when(
      loading: () => _buildLoadingSkeleton(context),
      error: (e, s) => const SizedBox.shrink(),
      data: (users) {
        if (users.isEmpty) {
          return const SizedBox.shrink();
        }

        final sortedUsers = users.toList()
          ..sort((a, b) {
            final aOnline = a.user.isOnline == true;
            final bOnline = b.user.isOnline == true;

            if (aOnline && !bOnline) return -1;
            if (!aOnline && bOnline) return 1;

            final aSeen = a.seenAt;
            final bSeen = b.seenAt;

            if (aSeen == null && bSeen == null) return 0;
            if (aSeen == null) return 1;
            if (bSeen == null) return -1;

            return bSeen.compareTo(aSeen);
          });

        return Padding(
          padding: Styles.verticalBodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: Styles.horizontalBodyPadding,
                child: ListSectionHeader(
                  title: const Text('Friends'),
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
                    final friend = sortedUsers[index];

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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UserFullNameWidget(
                                  user: friend.user,
                                  style: const TextStyle(fontWeight: .w500),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    friend.playing == true
                                        ? context.l10n.playingRightNow
                                        : friend.user.isOnline == true
                                        ? context.l10n.online.capitalize()
                                        : context.l10n.lastSeenActive(
                                            relativeDate(context.l10n, friend.seenAt!),
                                          ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                _buildActionButton(context, ref, friend),
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

Widget _buildActionButton(BuildContext context, WidgetRef ref, FollowingUser friend) {
  final compactStyle = FilledButton.styleFrom(
    visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    textStyle: const TextStyle(fontSize: 12),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  if (friend.playing == true) {
    return FilledButton.icon(
      onPressed: () {
        Navigator.of(context).push(TvScreen.buildRoute(user: friend.user));
      },
      icon: const Icon(Icons.live_tv_outlined, size: 14),
      label: Text(context.l10n.watch),
      style: compactStyle,
    );
  } else if (friend.user.isOnline == true) {
    return FilledButton.tonalIcon(
      onPressed: () {
        UserScreen.challengeUser(friend.user, context: context, ref: ref);
      },
      style: compactStyle,
      icon: const Icon(LichessIcons.crossed_swords, size: 14),
      label: Text(context.l10n.challengeChallengeToPlay),
    );
  } else {
    return FilledButton.tonalIcon(
      onPressed: () {
        Navigator.of(context).push(UserOrProfileScreen.buildRoute(friend.user));
      },
      style: compactStyle.copyWith(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
      icon: const Icon(Icons.person, size: 14),
      label: Text(context.l10n.profile),
    );
  }
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
