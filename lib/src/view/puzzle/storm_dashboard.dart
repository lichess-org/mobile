import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';

class StormDashboardModal extends StatelessWidget {
  const StormDashboardModal({super.key, required this.user});

  final LightUser user;

  static Route<dynamic> buildRoute(BuildContext context, LightUser user) {
    return buildScreenRoute(context, screen: StormDashboardModal(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformThemedScaffold(
      body: _Body(user: user),
      appBar: PlatformAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LichessIcons.storm, size: 20),
            const SizedBox(width: 8.0),
            Text(context.l10n.stormHighscores),
          ],
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.user});

  final LightUser user;

  static const EdgeInsets _statCardPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stormDashboard = ref.watch(stormDashboardProvider(user.id));
    return stormDashboard.when(
      data: (data) {
        if (data == null) {
          return const Center(child: Text('Could not load dashboard.'));
        }
        final dateFormat = DateFormat('MMMM d, yyyy');
        return ListView(
          children: [
            Padding(
              padding: Styles.sectionTopPadding.add(Styles.horizontalBodyPadding),
              child: StatCardRow([
                StatCard(
                  backgroundColor: LichessColors.brag.withValues(alpha: 0.5),
                  context.l10n.stormAllTime,
                  value: data.highScore.allTime.toString(),
                  valueFontSize: 26,
                  contentPadding: _statCardPadding,
                ),
                StatCard(
                  context.l10n.stormThisMonth,
                  value: data.highScore.month.toString(),
                  valueFontSize: 22,
                  contentPadding: _statCardPadding,
                ),
              ]),
            ),
            Padding(
              padding: Styles.horizontalBodyPadding,
              child: StatCardRow([
                StatCard(
                  context.l10n.stormThisWeek,
                  value: data.highScore.week.toString(),
                  valueFontSize: 22,
                  contentPadding: _statCardPadding,
                ),
                StatCard(
                  context.l10n.today,
                  value: data.highScore.day.toString(),
                  valueFontSize: 22,
                  contentPadding: _statCardPadding,
                ),
              ]),
            ),
            if (data.dayHighscores.isNotEmpty) ...[
              Padding(
                padding: Styles.bodySectionPadding,
                child: Text(context.l10n.stormBestRunOfDay, style: Styles.sectionTitle),
              ),
              Padding(
                padding: Styles.horizontalBodyPadding,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        Text(textAlign: TextAlign.center, context.l10n.stormScore),
                        Text(textAlign: TextAlign.center, context.l10n.stormTime),
                        Text(textAlign: TextAlign.center, context.l10n.stormHighestSolved),
                        Text(textAlign: TextAlign.center, context.l10n.stormRuns),
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.dayHighscores.length * 2,
                itemBuilder: (context, index) {
                  if (index.isEven) {
                    // Date row
                    final entryIndex = index ~/ 2;
                    return ColoredBox(
                      color: LichessColors.grey.withValues(alpha: 0.23),
                      child: Padding(
                        padding: Styles.horizontalBodyPadding,
                        child: Text(
                          dateFormat.format(data.dayHighscores[entryIndex].day),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  } else {
                    // Data row
                    final entryIndex = (index - 1) ~/ 2;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                data.dayHighscores[entryIndex].score.toString(),
                                style: TextStyle(
                                  color: context.lichessColors.brag,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                '${data.dayHighscores[entryIndex].time}s',
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                data.dayHighscores[entryIndex].highest.toString(),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                data.dayHighscores[entryIndex].runs.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ] else
              Center(child: Text(context.l10n.mobilePuzzleStormNothingToShow)),
          ],
        );
      },
      error: (e, s) {
        debugPrint('SEVERE: [StormDashboardModel] could not load storm dashboard; $e\n$s');
        return const SafeArea(child: Text('Could not load dashboard'));
      },
      loading: () => _Loading(),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final containerHeight = MediaQuery.sizeOf(context).width / 2 * 0.8;
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
                        width: containerHeight,
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
                        width: containerHeight,
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
                        width: containerHeight,
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
                        width: containerHeight,
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
