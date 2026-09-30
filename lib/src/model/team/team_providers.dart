import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/team/team.dart';
import 'package:lichess_mobile/src/model/team/team_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

const _kTeamUpdatesCacheDuration = Duration(minutes: 1);

/// A provider that fetches team updates (channels overview)
final teamUpdatesProvider = FutureProvider.autoDispose<TeamUpdates>((ref) {
  return ref.withClientCacheFor(
    (client) => ref.read(teamRepositoryProvider).getTeamUpdates(),
    _kTeamUpdatesCacheDuration,
  );
}, name: 'TeamUpdatesProvider');

/// A provider that fetches channel-specific updates page
final teamUpdatesOfTeamProvider = FutureProvider.autoDispose
    .family<TeamUpdatesOfTeam, (TeamId, int)>((ref, params) {
      return ref.withClientCacheFor(
        (client) =>
            ref.read(teamRepositoryProvider).getTeamUpdatesOfTeam(params.$1, page: params.$2),
        _kTeamUpdatesCacheDuration,
      );
    }, name: 'TeamUpdatesOfTeamProvider');

final unreadTeamUpdatesCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final authUser = ref.watch(authControllerProvider);
  if (authUser == null) {
    return 0;
  }
  try {
    final updates = await ref.watch(teamUpdatesProvider.future);
    return updates.byTeam.fold<int>(0, (sum, team) => sum + team.unread);
  } catch (_) {
    return 0;
  }
}, name: 'UnreadTeamUpdatesCountProvider');

final teamChannelPaginatorProvider = AsyncNotifierProvider.autoDispose
    .family<TeamChannelPaginatorNotifier, TeamChannelState, TeamId>(
      TeamChannelPaginatorNotifier.new,
      name: 'TeamChannelPaginatorProvider',
    );

class TeamChannelPaginatorNotifier(final TeamId teamId) extends AsyncNotifier<TeamChannelState> {
  @override
  Future<TeamChannelState> build() {
    return _loadPage(1);
  }

  Future<void> next() async {
    final currentState = state.value;
    if (currentState == null) return;
    final nextPage = currentState.nextPage;
    if (nextPage == null) return;

    final newPageState = await _loadPage(nextPage);
    if (!ref.mounted) return;

    state = AsyncData(
      currentState.copyWith(
        updates: currentState.updates.addAll(newPageState.updates),
        nextPage: newPageState.nextPage,
        hasMore: newPageState.hasMore,
        isSubscribed: newPageState.isSubscribed,
      ),
    );
  }

  Future<void> toggleSubscription() async {
    final currentState = state.value;
    if (currentState == null) return;
    final newSubscribed = !currentState.isSubscribed;

    final repo = ref.read(teamRepositoryProvider);
    await repo.toggleSubscribe(teamId, subscribe: newSubscribed);

    if (!ref.mounted) return;
    state = AsyncData(currentState.copyWith(isSubscribed: newSubscribed));
    ref.invalidate(teamUpdatesOfTeamProvider((teamId, 1)));
  }

  Future<TeamChannelState> _loadPage(int page) async {
    final data = await ref.read(teamUpdatesOfTeamProvider((teamId, page)).future);
    return TeamChannelState(
      updates: data.updates.currentPageResults,
      currentTeam: data.team,
      isSubscribed: data.subscribed,
      nextPage: data.updates.nextPage,
      hasMore: data.updates.nextPage != null,
    );
  }
}
