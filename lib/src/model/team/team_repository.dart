import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/team/team.dart';
import 'package:lichess_mobile/src/network/http.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(ref.watch(lichessClientProvider));
}, name: 'TeamRepositoryProvider');

class const TeamRepository(final LichessClient client) {
  Future<TeamUpdates> getTeamUpdates() {
    return client.readJson(
      Uri(path: '/team/updates'),
      headers: {'Accept': 'application/json'},
      mapper: TeamUpdates.fromServerJson,
    );
  }

  Future<TeamUpdatesOfTeam> getTeamUpdatesOfTeam(TeamId teamId, {int page = 1}) {
    return client.readJson(
      Uri(path: '/team/updates/$teamId', queryParameters: {'page': page.toString()}),
      headers: {'Accept': 'application/json'},
      mapper: TeamUpdatesOfTeam.fromServerJson,
    );
  }

  Future<void> toggleSubscribe(TeamId teamId, {required bool subscribe}) async {
    await client.postRead(
      Uri(path: '/team/$teamId/subscribe'),
      body: {'subscribe': subscribe ? 'true' : 'false'},
    );
  }
}
