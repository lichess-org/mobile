import 'dart:math';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:material_ui/material_ui.dart';

/// The padding of each group of settings, also used by [_DateRangeInputs].
const _kGroupPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

class const OpeningExplorerSettings() extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(openingExplorerPreferencesProvider);
    final notifier = ref.read(openingExplorerPreferencesProvider.notifier);

    Widget speedLabel(Speed speed) => Text(
      String.fromCharCode(speed.icon.codePoint),
      style: TextStyle(fontFamily: speed.icon.fontFamily, fontSize: 18.0),
    );
    String speedTooltip(Speed speed) =>
        Perf.fromVariantAndSpeed(Variant.standard, speed).label(context.l10n);

    final List<Widget> masterDbSettings = [
      _DateRangeInputs(
        key: const ValueKey(OpeningDatabase.master),
        yearOnly: true,
        earliest: MasterDb.earliestDate,
        since: prefs.masterDb.since,
        until: prefs.masterDb.until,
        onChanged: (since, until) => notifier.setMasterDbDates(since: since, until: until),
      ),
    ];

    final List<Widget> lichessDbSettings = [
      Padding(
        padding: _kGroupPadding,
        child: Filter<Speed>(
          filterName: context.l10n.timeControl,
          filterType: FilterType.multipleChoice,
          choices: LichessDb.kAvailableSpeeds,
          choiceLabel: speedLabel,
          choiceTooltip: speedTooltip,
          choiceSelected: (speed) => prefs.lichessDb.speeds.contains(speed),
          onSelected: (speed, _) => notifier.toggleLichessDbSpeed(speed),
        ),
      ),
      Padding(
        padding: _kGroupPadding,
        child: Filter<int>(
          filterName: context.l10n.rating,
          filterType: FilterType.multipleChoice,
          choices: LichessDb.kAvailableRatings,
          choiceLabel: (rating) => Text(rating.toString()),
          choiceTooltip: (rating) => rating == 400
              ? '400-1000'
              : rating == 2500
              ? '2500+'
              : '$rating-${rating + 200}',
          choiceSelected: (rating) => prefs.lichessDb.ratings.contains(rating),
          onSelected: (rating, _) => notifier.toggleLichessDbRating(rating),
        ),
      ),
      _DateRangeInputs(
        key: const ValueKey(OpeningDatabase.lichess),
        earliest: LichessDb.earliestDate,
        since: prefs.lichessDb.since,
        until: prefs.lichessDb.until,
        onChanged: (since, until) => notifier.setLichessDbDates(since: since, until: until),
      ),
    ];
    final List<Widget> playerDbSettings = [
      Padding(
        padding: _kGroupPadding,
        child: Text.rich(
          TextSpan(
            text: '${context.l10n.player}: ',
            style: const TextStyle(fontSize: 18),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.of(context).push(
                    SearchScreen.buildRoute(
                      onUserTap: (user) {
                        notifier.setPlayerDbUsernameOrId(user.name);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                text: prefs.playerDb.username ?? 'Select a Lichess player',
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: _kGroupPadding,
        child: Filter<Side>(
          filterName: context.l10n.side,
          filterType: FilterType.singleChoice,
          choices: Side.values,
          choiceLabel: (side) => Text(switch (side) {
            Side.white => context.l10n.white,
            Side.black => context.l10n.black,
          }),
          choiceSelected: (side) => prefs.playerDb.side == side,
          onSelected: (side, _) => notifier.setPlayerDbSide(side),
        ),
      ),
      Padding(
        padding: _kGroupPadding,
        child: Filter<Speed>(
          filterName: context.l10n.timeControl,
          filterType: FilterType.multipleChoice,
          choices: PlayerDb.kAvailableSpeeds,
          choiceLabel: speedLabel,
          choiceTooltip: speedTooltip,
          choiceSelected: (speed) => prefs.playerDb.speeds.contains(speed),
          onSelected: (speed, _) => notifier.togglePlayerDbSpeed(speed),
        ),
      ),
      Padding(
        padding: _kGroupPadding,
        child: Filter<GameMode>(
          filterName: context.l10n.mode,
          filterType: FilterType.multipleChoice,
          choices: GameMode.values,
          choiceLabel: (gameMode) => Text(switch (gameMode) {
            GameMode.casual => context.l10n.casual,
            GameMode.rated => context.l10n.rated,
          }),
          choiceSelected: (gameMode) => prefs.playerDb.gameModes.contains(gameMode),
          onSelected: (gameMode, _) => notifier.togglePlayerDbGameMode(gameMode),
        ),
      ),
      _DateRangeInputs(
        key: const ValueKey(OpeningDatabase.player),
        earliest: PlayerDb.earliestDate,
        since: prefs.playerDb.since,
        until: prefs.playerDb.until,
        onChanged: (since, until) => notifier.setPlayerDbDates(since: since, until: until),
      ),
    ];

    return BottomSheetScrollableContainer(
      // With the groups' own padding, 16 around the content and between the groups.
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: [
        Padding(
          padding: _kGroupPadding,
          child: Filter<OpeningDatabase>(
            filterName: context.l10n.database,
            filterType: FilterType.singleChoice,
            choices: OpeningDatabase.values,
            choiceLabel: (db) => Text(switch (db) {
              OpeningDatabase.master => 'Masters',
              OpeningDatabase.lichess => 'Lichess',
              OpeningDatabase.player => context.l10n.player,
            }),
            choiceSelected: (db) => prefs.db == db,
            onSelected: (db, _) => notifier.setDatabase(db),
          ),
        ),
        ...switch (prefs.db) {
          OpeningDatabase.master => masterDbSettings,
          OpeningDatabase.lichess => lichessDbSettings,
          OpeningDatabase.player => playerDbSettings,
        },
      ],
    );
  }
}

/// Since and until inputs bounding the date range of the explorer games.
class const _DateRangeInputs({
  required final DateTime? since,
  required final DateTime? until,
  required final DateTime earliest,
  required final void Function(DateTime? since, DateTime? until) onChanged,
  final bool yearOnly = false,
  super.key,
}) extends StatelessWidget {
  String _format(DateTime date) =>
      yearOnly ? '${date.year}' : '${date.year}-${date.month.toString().padLeft(2, '0')}';

  Future<void> _pickSince(BuildContext context) async {
    final date = await _pickDate(
      context,
      title: context.l10n.since,
      selected: since,
      first: earliest,
      last: until,
    );
    if (date != null) onChanged(date, until);
  }

  Future<void> _pickUntil(BuildContext context) async {
    final date = await _pickDate(
      context,
      title: context.l10n.until,
      selected: until,
      first: since ?? earliest,
    );
    if (date != null) onChanged(since, date);
  }

  Future<DateTime?> _pickDate(
    BuildContext context, {
    required String title,
    required DateTime? selected,
    required DateTime first,
    DateTime? last,
  }) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final firstDate = DateTime(first.year, yearOnly ? 1 : first.month);
    final lastDayOfLast = last != null
        ? DateTime(last.year, yearOnly ? 13 : last.month + 1, 0)
        : today;
    final lastDate = lastDayOfLast.isAfter(today) ? today : lastDayOfLast;
    final initial = selected ?? lastDate;
    final initialMonth = DateTime(initial.year, initial.month);
    final initialDate = initialMonth.isBefore(firstDate)
        ? firstDate
        : initialMonth.isAfter(lastDate)
        ? lastDate
        : initialMonth;

    final DateTime? picked;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      picked = await _showCupertinoPicker(
        context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    } else {
      picked = await showDialog<DateTime>(
        context: context,
        builder: (_) => _MonthYearPickerDialog(
          title: title,
          selected: selected != null ? initialDate : null,
          firstDate: firstDate,
          lastDate: lastDate,
          yearOnly: yearOnly,
        ),
      );
    }
    if (picked == null) return null;
    return yearOnly ? DateTime.utc(picked.year) : DateTime.utc(picked.year, picked.month);
  }

  Future<DateTime?> _showCupertinoPicker(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    var selected = initialDate;
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => Container(
        height: 260,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.l10n.cancel),
                  ),
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(selected),
                    child: Text(MaterialLocalizations.of(context).okButtonLabel),
                  ),
                ],
              ),
              Expanded(
                child: yearOnly
                    ? CupertinoPicker(
                        itemExtent: 32.0,
                        scrollController: FixedExtentScrollController(
                          initialItem: initialDate.year - firstDate.year,
                        ),
                        onSelectedItemChanged: (index) =>
                            selected = DateTime(firstDate.year + index),
                        children: [
                          for (var year = firstDate.year; year <= lastDate.year; year++)
                            Center(child: Text('$year')),
                        ],
                      )
                    : CupertinoDatePicker(
                        mode: .monthYear,
                        initialDateTime: initialDate,
                        minimumDate: firstDate,
                        maximumDate: lastDate,
                        onDateTimeChanged: (date) => selected = date,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _kGroupPadding,
      child: Row(
        children: [
          Expanded(
            child: _DateField(
              label: context.l10n.since,
              value: since != null ? _format(since!) : null,
              onTap: () => _pickSince(context),
              onClear: () => onChanged(null, until),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: _DateField(
              label: context.l10n.until,
              value: until != null ? _format(until!) : null,
              onTap: () => _pickUntil(context),
              onClear: () => onChanged(since, null),
            ),
          ),
        ],
      ),
    );
  }
}

/// A tappable field showing a date [value], with a button to clear it.
class const _DateField({
  required final String label,
  required final String? value,
  required final VoidCallback onTap,
  required final VoidCallback onClear,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        isEmpty: value == null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: value != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                  onPressed: onClear,
                )
              : null,
        ),
        child: Text(value ?? ''),
      ),
    );
  }
}

const _kPickerColumns = 3;
const _kPickerRowHeight = 52.0;

/// A Material dialog picking a year, then a month of that year unless [yearOnly] is true.
class const _MonthYearPickerDialog({
  required final String title,
  required final DateTime? selected,
  required final DateTime firstDate,
  required final DateTime lastDate,
  required final bool yearOnly,
}) extends StatefulWidget {
  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState() extends State<_MonthYearPickerDialog> {
  int? _year;

  // Scrolls the years so that the selected one, or else the last one, is visible.
  late final _scrollController = ScrollController(
    initialScrollOffset:
        max(
          0,
          ((widget.selected ?? widget.lastDate).year - widget.firstDate.year) ~/ _kPickerColumns -
              2,
        ) *
        _kPickerRowHeight,
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final year = _year;
    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: _kPickerColumns,
      mainAxisExtent: _kPickerRowHeight,
    );

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 300,
        height: 300,
        child: year == null
            ? GridView.builder(
                controller: _scrollController,
                gridDelegate: gridDelegate,
                itemCount: widget.lastDate.year - widget.firstDate.year + 1,
                itemBuilder: (context, index) {
                  final year = widget.firstDate.year + index;
                  return _PickerCell(
                    label: '$year',
                    isSelected: year == widget.selected?.year,
                    onPressed: () => widget.yearOnly
                        ? Navigator.of(context).pop(DateTime(year))
                        : setState(() => _year = year),
                  );
                },
              )
            : Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        tooltip: localizations.backButtonTooltip,
                        onPressed: () => setState(() => _year = null),
                      ),
                      Text('$year', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: gridDelegate,
                      itemCount: DateTime.monthsPerYear,
                      itemBuilder: (context, index) {
                        final month = DateTime(year, index + 1);
                        final isEnabled =
                            !month.isBefore(widget.firstDate) && !month.isAfter(widget.lastDate);
                        return _PickerCell(
                          label: DateFormat.MMM().format(month),
                          isSelected:
                              widget.selected?.year == year &&
                              widget.selected?.month == month.month,
                          onPressed: isEnabled ? () => Navigator.of(context).pop(month) : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.cancelButtonLabel),
        ),
      ],
    );
  }
}

/// A year or month of [_MonthYearPickerDialog], filled when [isSelected] and disabled when
/// [onPressed] is null.
class const _PickerCell({
  required final String label,
  required final bool isSelected,
  required final VoidCallback? onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: isSelected
          ? FilledButton(onPressed: onPressed, child: Text(label))
          : TextButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
