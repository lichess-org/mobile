import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_calendar_tile.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_search_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
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
    final canGoToPreviousMonth = year > 2020 || month > 1;
    final canGoToNextMonth = year < maxYear || month < 12;
    final years = [for (int y = 2020; y <= maxYear; y++) y];
    final isIOS = Theme.of(context).platform == .iOS;

    final previousMonthButton = IconButton(
      icon: const Icon(Icons.chevron_left),
      visualDensity: isIOS ? .compact : null,
      onPressed: canGoToPreviousMonth ? goToPreviousMonth : null,
      tooltip: 'Previous month',
    );
    final nextMonthButton = IconButton(
      icon: const Icon(Icons.chevron_right),
      visualDensity: isIOS ? .compact : null,
      onPressed: canGoToNextMonth ? goToNextMonth : null,
      tooltip: 'Next month',
    );
    final yearPicker = isIOS
        ? TextButton(
            onPressed: () => showChoicePicker<int>(
              context,
              choices: years,
              selectedItem: year,
              forceWheelPicker: true, // Like the month picker next to it.
              labelBuilder: (value) => Text(value.toString()),
              onSelectedItemChanged: (value) {
                if (mounted) setState(() => year = value);
              },
            ),
            child: Text(year.toString()),
          )
        : DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: year,
              isExpanded: true,
              items: [for (final y in years) DropdownMenuItem(value: y, child: Text(y.toString()))],
              onChanged: (value) {
                if (value != null) setState(() => year = value);
              },
            ),
          );
    final monthPicker = isIOS
        ? TextButton(
            onPressed: () => showChoicePicker<int>(
              context,
              choices: [for (int m = 1; m <= 12; m++) m],
              selectedItem: month,
              labelBuilder: (value) => Text(DateFormat.MMMM().format(DateTime(2000, value))),
              onSelectedItemChanged: (value) {
                if (mounted) setState(() => month = value);
              },
            ),
            child: Text(DateFormat.MMMM().format(DateTime(2000, month))),
          )
        : DropdownButtonHideUnderline(
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
          );
    final pickerDivider = Padding(
      padding: const .symmetric(horizontal: 8.0),
      child: Container(width: 1.0, height: 20.0, color: Theme.of(context).dividerColor),
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.broadcastBroadcastCalendar),
        actions: [
          SearchHeroButton(
            heroTag: BroadcastSearchScreen.heroTag,
            onPressed: () {
              Navigator.of(context).push(BroadcastSearchScreen.buildRoute());
            },
          ),
        ],
        largeTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            isIOS
                ? kGlassAppBarBottomControlHeight + kGlassAppBarBottomPadding.vertical
                : kToolbarHeight,
          ),
          child: isIOS
              ? Padding(
                  padding: kGlassAppBarBottomPadding,
                  child: GlassControlBackground(
                    glass: true,
                    height: kGlassAppBarBottomControlHeight,
                    child: Row(
                      children: [
                        previousMonthButton,
                        Expanded(child: yearPicker),
                        pickerDivider,
                        Expanded(child: monthPicker),
                        nextMonthButton,
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const .symmetric(horizontal: 4.0, vertical: 4.0),
                  child: Row(
                    children: [
                      previousMonthButton,
                      Expanded(
                        child: Container(
                          padding: const .symmetric(horizontal: 12.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor),
                            borderRadius: .circular(28.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: yearPicker),
                              pickerDivider,
                              Expanded(child: monthPicker),
                            ],
                          ),
                        ),
                      ),
                      nextMonthButton,
                    ],
                  ),
                ),
        ),
      ),
      body: HapticRefreshIndicator(
        onRefresh: () => ref.refresh(broadcastCalendarProvider(params).future),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverSafeArea(
              sliver: switch (calendar) {
                AsyncData(:final value) when value.isNotEmpty => SliverList.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final day = value[index];
                    return ListSection(
                      header: switch (day.date) {
                        null => Text(context.l10n.mobileToBeAnnounced),
                        final date => Text(DateFormat.yMMMMd().format(date.toUtc())),
                      },
                      hasLeading: true,
                      children: [
                        for (final broadcast in day.broadcasts)
                          BroadcastCalendarTile(broadcast: broadcast),
                      ],
                    );
                  },
                ),
                AsyncData() => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No broadcasts this month')),
                ),
                AsyncError() => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        const Icon(Icons.error_outline, size: 32),
                        const SizedBox(height: 16),
                        const Text('Cannot load broadcast calendar'),
                        TextButton.icon(
                          onPressed: () => ref.refresh(broadcastCalendarProvider(params).future),
                          icon: const Icon(Icons.refresh),
                          label: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  ),
                ),
                _ => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
