import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/relation/following_user.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/view/home/following_carousel.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

import '../../test_provider_scope.dart';

FollowingUser makeFollowingUser(
  String name, {
  bool online = false,
  bool playing = false,
  bool bot = false,
  DateTime? seenAt,
}) {
  return FollowingUser(
    user: LightUser(
      id: UserId(name.toLowerCase()),
      name: name,
      title: bot ? 'BOT' : null,
      isOnline: online,
    ),
    playing: playing,
    seenAt: seenAt,
  );
}

List<String> sortedNames(IList<FollowingUser> users) =>
    sortFollowingUsers(users).map((u) => u.user.name).toList();

void main() {
  group('sortFollowingUsers', () {
    test('bots are pushed to the end of the playing/online sublist', () {
      final users = IList([
        makeFollowingUser('OnlineBot', online: true, bot: true),
        makeFollowingUser('PlayingHuman', playing: true),
        makeFollowingUser('PlayingBot', playing: true, bot: true),
        makeFollowingUser('OnlineHuman', online: true),
        makeFollowingUser('OfflineHuman', seenAt: DateTime(2024)),
      ]);

      expect(sortedNames(users), [
        'PlayingHuman', // non-bot playing
        'OnlineHuman', // non-bot online
        'PlayingBot', // bots at the end of the playing/online sublist
        'OnlineBot',
        'OfflineHuman', // offline last
      ]);
    });

    test('online bot is still sorted before offline (non-online) humans', () {
      final users = IList([
        makeFollowingUser('OfflineHuman', seenAt: DateTime(2024, 6)),
        makeFollowingUser('OnlineBot', online: true, bot: true),
      ]);

      expect(sortedNames(users), ['OnlineBot', 'OfflineHuman']);
    });

    test('a playing bot is sorted after an online human', () {
      final users = IList([
        makeFollowingUser('PlayingBot', playing: true, bot: true),
        makeFollowingUser('OnlineHuman', online: true),
      ]);

      expect(sortedNames(users), ['OnlineHuman', 'PlayingBot']);
    });

    test('offline users are sorted by most recently seen', () {
      final users = IList([
        makeFollowingUser('Older', seenAt: DateTime(2024, 1)),
        makeFollowingUser('Newest', seenAt: DateTime(2024, 12)),
        makeFollowingUser('Middle', seenAt: DateTime(2024, 6)),
        makeFollowingUser('NeverSeen'),
      ]);

      expect(sortedNames(users), ['Newest', 'Middle', 'Older', 'NeverSeen']);
    });

    test('offline bots are sorted among offline users by last seen', () {
      final users = IList([
        makeFollowingUser('OfflineBotOld', seenAt: DateTime(2024, 1), bot: true),
        makeFollowingUser('OnlineHuman', online: true),
        makeFollowingUser('OfflineHumanNew', seenAt: DateTime(2024, 6)),
      ]);

      expect(sortedNames(users), ['OnlineHuman', 'OfflineHumanNew', 'OfflineBotOld']);
    });
  });

  group('FollowingCarousel widget', () {
    testWidgets('displays users in sorted order with bots at the end of the online sublist', (
      tester,
    ) async {
      final users = IList([
        makeFollowingUser('OnlineBot', online: true, bot: true),
        makeFollowingUser('PlayingHuman', playing: true),
        makeFollowingUser('OnlineHuman', online: true),
        makeFollowingUser('OfflineHuman', seenAt: DateTime(2024)),
      ]);

      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(body: FollowingCarousel(AsyncValue.data(users))),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // The online sublist is visible in the first viewport: the bot is pushed
      // to the end of it, after the playing and online humans.
      final visibleNames =
          tester
              .widgetList<UserFullNameWidget>(find.byType(UserFullNameWidget))
              .map((w) => (name: w.user!.name, x: tester.getTopLeft(find.byWidget(w)).dx))
              .toList()
            ..sort((a, b) => a.x.compareTo(b.x));
      expect(visibleNames.map((e) => e.name).toList(), [
        'PlayingHuman',
        'OnlineHuman',
        'OnlineBot',
      ]);

      // The offline user is sorted last, so it is off-screen and only reachable
      // by scrolling forward through the horizontal list.
      final offlineFinder = find.byWidgetPredicate(
        (w) => w is UserFullNameWidget && w.user?.name == 'OfflineHuman',
      );
      expect(offlineFinder, findsNothing);

      await tester.scrollUntilVisible(offlineFinder, 300, scrollable: find.byType(Scrollable).last);
      expect(offlineFinder, findsOneWidget);
    });
  });
}
