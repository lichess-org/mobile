import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/features/user/data/user_repository.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

final perfStatsProvider = FutureProvider.autoDispose
    .family<UserPerfStats, UserPerfStatsParameters>((ref, perfParams) async {
      final userRepo = ref.watch(userRepositoryProvider);
      final either = await userRepo.getUserPerfStatsTask(
        perfParams.username,
        perfParams.perf,
      ).run();

      return either.match((error) => throw error, (data)  {
        ref.keepAlive();
        return data;
      });      
    });

class PerfStatsScreen extends ConsumerWidget {
  const PerfStatsScreen({
    required this.username,
    required this.perf,
    super.key});

  final String username;
  final Perf perf;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder);
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(perf.name),
      ),
      body: _buildBody(context, ref)
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildBody(context, ref)
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final perfStats = ref.watch(perfStatsProvider(
      UserPerfStatsParameters(username: username, perf: perf)
    ));

    return perfStats.when(
      data: (data) {
        return Text(data.rank.toString());
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [PerfStatsScreen] could not load user games; ${error.toString()}\n$stackTrace');
          return const Text('Could not load user performance stats.');
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
