import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_list_tile.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:material_ui/material_ui.dart';

class const BroadcastCalendarScreen({
  super.key,
  required final int initialYear,
  required final int initialMonth,
}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute({int? year, int? month}) {
    final now = DateTime.now();
    return buildScreenRoute(
      screen: BroadcastCalendarScreen(
        initialYear: year ?? now.year,
        initialMonth: month ?? now.month,
      ),
    );
  }

  @override
  ConsumerState<BroadcastCalendarScreen> createState() => _BroadcastCalendarScreenState();
}

class _BroadcastCalendarScreenState() extends ConsumerState<BroadcastCalendarScreen> {
  late int year;
  late int month;

  @override
  void initState() {
    super.initState();
    year = widget.initialYear.clamp(2020, DateTime.now().year + 1);
    month = widget.initialMonth.clamp(1, 12);
  }

  void goToPreviousMonth() {
    if (month == 1) {
      if (year <= 2020) return;
      setState(() {
        year -= 1;
        month = 12;
      });
    } else {
      setState(() => month -= 1);
    }
  }

  void goToNextMonth() {
    final maxYear = DateTime.now().year + 1;
    if (month == 12) {
      if (year >= maxYear) return;
      setState(() {
        year += 1;
        month = 1;
      });
    } else {
      setState(() => month += 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = (year: year, month: month);
    final calendar = ref.watch(broadcastCalendarProvider(params));
    final maxYear = DateTime.now().year + 1;
    final years = [for (int y = 2020; y <= maxYear; y++) y];

    return Scaffold(
      appBar: AppBar(title: AppBarTitleText(context.l10n.broadcastBroadcastCalendar)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: goToPreviousMonth,
                  tooltip: 'Previous month',
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: years.contains(year) ? year : null,
                              isExpanded: true,
                              items: [
                                for (final y in years)
                                  DropdownMenuItem(value: y, child: Text(y.toString())),
                              ],
                              onChanged: (value) {
                                if (value != null) setState(() => year = value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: 1.0,
                            height: 20.0,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: month,
                              isExpanded: true,
                              items: [
                                for (int m = 1; m <= 12; m++)
                                  DropdownMenuItem(
                                    value: m,
                                    child: Text(DateFormat.MMMM().format(DateTime(2000, m))),
                                  ),
                              ],
                              onChanged: (value) {
                                if (value != null) setState(() => month = value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: goToNextMonth,
                  tooltip: 'Next month',
                ),
              ],
            ),
          ),
          Expanded(
            child: HapticRefreshIndicator(
              onRefresh: () => ref.refresh(broadcastCalendarProvider(params).future),
              child: switch (calendar) {
                AsyncData(:final value) =>
                  value.isEmpty
                      ? const CustomScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(child: Text('No broadcasts this month')),
                            ),
                          ],
                        )
                      : CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            for (final day in value)
                              SliverMainAxisGroup(
                                slivers: [
                                  SliverAppBar(
                                    centerTitle: false,
                                    automaticallyImplyLeading: false,
                                    primary: false,
                                    pinned: true,
                                    title: switch (day.date) {
                                      null => const AppBarTitleText('To be announced'),
                                      final date => AppBarTitleText(
                                        DateFormat.yMMMMd().format(date.toUtc()),
                                      ),
                                    },
                                  ),
                                  SliverList.separated(
                                    separatorBuilder: (context, index) => PlatformDivider(
                                      height: 1,
                                      indent:
                                          BroadcastListTile.thumbnailSize(context) + 16.0 + 10.0,
                                    ),
                                    itemCount: day.broadcasts.length,
                                    itemBuilder: (context, index) =>
                                        BroadcastListTile(broadcast: day.broadcasts[index]),
                                  ),
                                ],
                              ),
                          ],
                        ),
                AsyncError() => CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 32),
                            const SizedBox(height: 16),
                            const Text('Cannot load broadcast calendar'),
                            TextButton.icon(
                              onPressed: () =>
                                  ref.refresh(broadcastCalendarProvider(params).future),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                _ => const CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator.adaptive()),
                    ),
                  ],
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
