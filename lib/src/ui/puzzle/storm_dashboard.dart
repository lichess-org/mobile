import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';

class StormDashboardModal extends StatelessWidget {
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
        final dateFormat = DateFormat("MMMM d, yyyy");
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: Styles.sectionTopPadding,
                child: StatCardRow(
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
              ),
              Padding(
                padding: Styles.sectionTopPadding,
                child: StatCardRow(
                  [
                    StatCard(
                      context.l10n.stormThisWeek,
                      value: data.highScore.week.toString(),
                    ),
                    StatCard(
                      context.l10n.today,
                      value: data.highScore.day.toString(),
                    ),
                  ],
                ),
              ),
              if (data.dayHighscores.isNotEmpty) ...[
                Padding(
                  padding: Styles.bodySectionPadding,
                  child: Text(
                    context.l10n.stormBestRunOfDay,
                    style: Styles.sectionTitle,
                  ),
                ),
                Padding(
                  padding: Styles.horizontalBodyPadding,
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            context.l10n.stormScore,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            context.l10n.stormTime,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            context.l10n.stormHighestSolved,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            context.l10n.stormRuns,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: data.dayHighscores.length * 2,
                    itemBuilder: (context, index) {
                      if (index.isEven) {
                        // Date row
                        final entryIndex = index ~/ 2;
                        return ColoredBox(
                          color: LichessColors.grey.withOpacity(0.23),
                          child: Padding(
                            padding: Styles.horizontalBodyPadding,
                            child: Text(
                              dateFormat
                                  .format(data.dayHighscores[entryIndex].day),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      } else {
                        // Data row
                        final entryIndex = (index - 1) ~/ 2;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    data.dayHighscores[entryIndex].score
                                        .toString(),
                                    style: const TextStyle(
                                      color: LichessColors.brag,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    '${data.dayHighscores[entryIndex].time}s',
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    data.dayHighscores[entryIndex].highest
                                        .toString(),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    data.dayHighscores[entryIndex].runs
                                        .toString(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ] else
                const Center(
                  child: Text('Nothing to show. Play some runs of storm'),
                )
            ],
          ),
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [StormDashboardModel] could not load storm dashboard; $e\n$s',
        );
        return const SafeArea(child: Text('Could not load dashboard'));
      },
      loading: () => _Loading(),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final containerHeigth = MediaQuery.of(context).size.width / 2 * 0.8;
    return SafeArea(
      child: Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: Padding(
            padding: Styles.bodySectionPadding,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ignore: avoid-wrapping-in-padding
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: containerHeigth,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // ignore: avoid-wrapping-in-padding
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: containerHeigth,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ignore: avoid-wrapping-in-padding
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: containerHeigth,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // ignore: avoid-wrapping-in-padding
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: containerHeigth,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
                ListSection.loading(itemsNumber: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
