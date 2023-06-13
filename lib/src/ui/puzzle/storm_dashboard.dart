import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';

class StormDashboardModel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(context.l10n.stormHighscores),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.close),
              ),
            ),
            child: _Body(),
          )
        : Scaffold(
            body: _Body(),
            appBar: AppBar(
              title: Text(context.l10n.stormHighscores),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
          );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stormDashboard = ref.watch(stormDashboardProvider);
    return stormDashboard.when(
      data: (data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              StatCardRow(
                [
                  StatCard(
                    context.l10n.stormAllTime,
                    value: data.highScore.allTime.toString(),
                  ),
                  StatCard(
                    context.l10n.stormThisMonth,
                    value: data.highScore.month.toString(),
                  )
                ],
              ),
              StatCardRow(
                [
                  StatCard(
                    context.l10n.stormThisWeek,
                    value: data.highScore.week.toString(),
                  ),
                  StatCard(
                    context.l10n.today,
                    value: data.highScore.day.toString(),
                  )
                ],
              ),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      TableCell(child: Text(context.l10n.stormScore)),
                      TableCell(child: Text(context.l10n.stormTime)),
                      TableCell(child: Text(context.l10n.stormHighestSolved)),
                      TableCell(child: Text(context.l10n.stormRuns)),
                    ],
                  ),
                  for (var entry in data.dayHighscores) ...[
                    TableRow(
                      children: [
                        TableCell(
                          child: Text(entry.day.toString()),
                        ),
                        const TableCell(child: SizedBox.shrink()),
                        const TableCell(child: SizedBox.shrink()),
                        const TableCell(child: SizedBox.shrink()),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(child: Text(entry.score.toString())),
                        TableCell(child: Text(entry.time.toString())),
                        TableCell(child: Text(entry.highest.toString())),
                        TableCell(child: Text(entry.runs.toString())),
                      ],
                    ),
                  ]
                ],
              ),
            ],
          ),
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [StormDashboardModel] could not load storm dashboard; $e\n$s',
        );
        return const Text('Could not load dashboard');
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(itemsNumber: 5),
        ),
      ),
    );
  }
}
