import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/edit_profile_screen.dart';
import 'package:lichess_mobile/src/view/account/game_bookmarks_screen.dart';
import 'package:lichess_mobile/src/view/user/perf_cards.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/view/user/user_activity.dart';
import 'package:lichess_mobile/src/view/user/user_profile.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const ProfileScreen());
  }

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

final _accountActivityProvider = FutureProvider.autoDispose<IList<UserActivity>>((ref) {
  final session = ref.watch(authSessionProvider);
  if (session == null) return IList();
  return ref.withClient((client) => UserRepository(client).getActivity(session.user.id));
}, name: 'userActivityProvider');

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: account.when(
          data: (user) =>
              user == null ? const SizedBox.shrink() : UserFullNameWidget(user: user.lightUser),
          loading: () => const SizedBox.shrink(),
          error: (error, _) => const SizedBox.shrink(),
        ),
        actions: [
          SemanticIconButton(
            icon: const Icon(Icons.edit),
            semanticsLabel: context.l10n.editProfile,
            onPressed: () => Navigator.of(context).push(EditProfileScreen.buildRoute(context)),
          ),
        ],
      ),
      body: account.when(
        data: (user) {
          if (user == null) {
            return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
          }
          final activity = ref.watch(_accountActivityProvider);
          final recentGames = ref.watch(myRecentGamesProvider);
          final nbOfGames = ref.watch(userNumberOfGamesProvider(null)).valueOrNull ?? 0;
          return RefreshIndicator.adaptive(
            edgeOffset: Theme.of(context).platform == TargetPlatform.iOS
                ? MediaQuery.paddingOf(context).top + kToolbarHeight
                : 0.0,
            key: _refreshIndicatorKey,
            onRefresh: () => Future.wait([
              ref.refresh(accountProvider.future),
              ref.refresh(_accountActivityProvider.future),
              ref.refresh(myRecentGamesProvider.future),
            ]),
            child: ListView(
              children: [
                UserProfileWidget(user: user),
                const AccountPerfCards(),
                if (user.count != null && user.count!.bookmark > 0)
                  ListSection(
                    hasLeading: true,
                    children: [
                      ListTile(
                        title: Text(context.l10n.nbBookmarks(user.count!.bookmark)),
                        leading: const Icon(Icons.bookmarks_outlined),
                        onTap: () {
                          Navigator.of(context).push(
                            GameBookmarksScreen.buildRoute(
                              context,
                              nbBookmarks: user.count!.bookmark,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                UserActivityWidget(activity: activity),
                RecentGamesWidget(recentGames: recentGames, nbOfGames: nbOfGames, user: null),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) {
          return FullScreenRetryRequest(onRetry: () => ref.invalidate(accountProvider));
        },
      ),
    );
  }
}

class AccountPerfCards extends ConsumerWidget {
  const AccountPerfCards({this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    return account.when(
      data: (user) {
        if (user != null) {
          return PerfCards(user: user, isMe: true, padding: padding);
        } else {
          return const SizedBox.shrink();
        }
      },
      loading: () => Shimmer(
        child: Padding(
          padding: padding ?? Styles.bodySectionPadding,
          child: SizedBox(
            height: 106,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) => ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
