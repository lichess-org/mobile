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

    return Scaffold(
      appBar: AppBar(title: AppBarTitleText(context.l10n.broadcastBroadcastCalendar)),
      body: Column(
        children: [
          _MonthPicker(
            year: year,
            month: month,
            onYearChanged: (value) => setState(() => year = value),
            onMonthChanged: (value) => setState(() => month = value),
            onPrevious: goToPreviousMonth,
            onNext: goToNextMonth,
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
                          slivers: [
                            for (final day in value)
                              SliverMainAxisGroup(
                                slivers: [
                                  SliverAppBar(
                                    centerTitle: false,
                                    automaticallyImplyLeading: false,
                                    primary: false,
                                    pinned: true,
                                    title: AppBarTitleText(
                                      DateFormat.yMMMMd().format(
                                        DateTime(day.date.year, day.date.month, day.date.day),
                                      ),
                                    ),
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
                            const Text('Cannot load broadcast calendar'),
                            TextButton(
                              onPressed: () =>
                                  ref.refresh(broadcastCalendarProvider(params).future),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                _ => const Center(child: CircularProgressIndicator.adaptive()),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class const _MonthPicker({
  required final int year,
  required final int month,
  required final ValueChanged<int> onYearChanged,
  required final ValueChanged<int> onMonthChanged,
  required final VoidCallback onPrevious,
  required final VoidCallback onNext,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final maxYear = DateTime.now().year + 1;
    final years = [for (int y = 2020; y <= maxYear; y++) y];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
            tooltip: 'Previous month',
          ),
          Expanded(
            child: DropdownButton<int>(
              value: years.contains(year) ? year : null,
              isExpanded: true,
              items: [for (final y in years) DropdownMenuItem(value: y, child: Text(y.toString()))],
              onChanged: (value) {
                if (value != null) onYearChanged(value);
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
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
                if (value != null) onMonthChanged(value);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
            tooltip: 'Next month',
          ),
        ],
      ),
    );
  }
}
