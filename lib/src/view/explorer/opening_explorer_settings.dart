import 'dart:math';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:material_ui/material_ui.dart';

class const OpeningExplorerSettings() extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(openingExplorerPreferencesProvider);

    final List<Widget> masterDbSettings = [
      _DateRangeInputs(
        key: const ValueKey(OpeningDatabase.master),
        yearOnly: true,
        earliest: MasterDb.earliestDate,
        since: prefs.masterDb.since,
        until: prefs.masterDb.until,
        onChanged: (since, until) => ref
            .read(openingExplorerPreferencesProvider.notifier)
            .setMasterDbDates(since: since, until: until),
      ),
    ];

    final List<Widget> lichessDbSettings = [
      ListTile(
        title: Text(context.l10n.timeControl),
        subtitle: Wrap(
          spacing: 5,
          children: LichessDb.kAvailableSpeeds
              .map(
                (speed) => FilterChip(
                  label: Text(
                    String.fromCharCode(speed.icon.codePoint),
                    style: TextStyle(fontFamily: speed.icon.fontFamily, fontSize: 18.0),
                  ),
                  tooltip: Perf.fromVariantAndSpeed(Variant.standard, speed).label(context.l10n),
                  selected: prefs.lichessDb.speeds.contains(speed),
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .toggleLichessDbSpeed(speed),
                ),
              )
              .toList(growable: false),
        ),
      ),
      ListTile(
        title: Text(context.l10n.rating),
        subtitle: Wrap(
          spacing: 5,
          children: LichessDb.kAvailableRatings
              .map(
                (rating) => FilterChip(
                  label: Text(rating.toString()),
                  tooltip: rating == 400
                      ? '400-1000'
                      : rating == 2500
                      ? '2500+'
                      : '$rating-${rating + 200}',
                  selected: prefs.lichessDb.ratings.contains(rating),
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .toggleLichessDbRating(rating),
                ),
              )
              .toList(growable: false),
        ),
      ),
      _DateRangeInputs(
        key: const ValueKey(OpeningDatabase.lichess),
        earliest: LichessDb.earliestDate,
        since: prefs.lichessDb.since,
        until: prefs.lichessDb.until,
        onChanged: (since, until) => ref
            .read(openingExplorerPreferencesProvider.notifier)
            .setLichessDbDates(since: since, until: until),
      ),
    ];
    final List<Widget> playerDbSettings = [
      ListTile(
        title: Text.rich(
          TextSpan(
            text: '${context.l10n.player}: ',
            style: const TextStyle(fontWeight: FontWeight.normal),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.of(context).push(
                    SearchScreen.buildRoute(
                      onUserTap: (user) {
                        ref
                            .read(openingExplorerPreferencesProvider.notifier)
                            .setPlayerDbUsernameOrId(user.name);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
                text: prefs.playerDb.username ?? 'Select a Lichess player',
              ),
            ],
          ),
        ),
      ),
      ListTile(
        title: Text(context.l10n.side),
        subtitle: Wrap(
          spacing: 5,
          children: Side.values
              .map(
                (side) => ChoiceChip(
                  label: switch (side) {
                    Side.white => Text(context.l10n.white),
                    Side.black => Text(context.l10n.black),
                  },
                  selected: prefs.playerDb.side == side,
                  onSelected: (_) =>
                      ref.read(openingExplorerPreferencesProvider.notifier).setPlayerDbSide(side),
                ),
              )
              .toList(growable: false),
        ),
      ),
      ListTile(
        title: Text(context.l10n.timeControl),
        subtitle: Wrap(
          spacing: 5,
          children: PlayerDb.kAvailableSpeeds
              .map(
                (speed) => FilterChip(
                  label: Text(
                    String.fromCharCode(speed.icon.codePoint),
                    style: TextStyle(fontFamily: speed.icon.fontFamily, fontSize: 18.0),
                  ),
                  tooltip: Perf.fromVariantAndSpeed(Variant.standard, speed).label(context.l10n),
                  selected: prefs.playerDb.speeds.contains(speed),
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .togglePlayerDbSpeed(speed),
                ),
              )
              .toList(growable: false),
        ),
      ),
      ListTile(
        title: Text(context.l10n.mode),
        subtitle: Wrap(
          spacing: 5,
          children: GameMode.values
              .map(
                (gameMode) => FilterChip(
                  label: Text(switch (gameMode) {
                    GameMode.casual => context.l10n.casual,
                    GameMode.rated => context.l10n.rated,
                  }),
                  selected: prefs.playerDb.gameModes.contains(gameMode),
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .togglePlayerDbGameMode(gameMode),
                ),
              )
              .toList(growable: false),
        ),
      ),
      _DateRangeInputs(
        key: const ValueKey(OpeningDatabase.player),
        earliest: PlayerDb.earliestDate,
        since: prefs.playerDb.since,
        until: prefs.playerDb.until,
        onChanged: (since, until) => ref
            .read(openingExplorerPreferencesProvider.notifier)
            .setPlayerDbDates(since: since, until: until),
      ),
    ];

    return BottomSheetScrollableContainer(
      children: [
        ListTile(
          title: Text(context.l10n.database),
          subtitle: Wrap(
            spacing: 5,
            children: [
              ChoiceChip(
                label: const Text('Masters'),
                selected: prefs.db == OpeningDatabase.master,
                onSelected: (_) => ref
                    .read(openingExplorerPreferencesProvider.notifier)
                    .setDatabase(OpeningDatabase.master),
              ),
              ChoiceChip(
                label: const Text('Lichess'),
                selected: prefs.db == OpeningDatabase.lichess,
                onSelected: (_) => ref
                    .read(openingExplorerPreferencesProvider.notifier)
                    .setDatabase(OpeningDatabase.lichess),
              ),
              ChoiceChip(
                label: Text(context.l10n.player),
                selected: prefs.db == OpeningDatabase.player,
                onSelected: (_) => ref
                    .read(openingExplorerPreferencesProvider.notifier)
                    .setDatabase(OpeningDatabase.player),
              ),
            ],
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
///
/// Each input opens a picker of months, or of years when [yearOnly] is true. The pickers are bounded
/// by [earliest], the current date and the other input, so the range is always valid. Clearing an
/// input removes that bound.
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

  /// Shows a picker of the months (or years) between [first] and [last], [last] defaulting to the
  /// current one.
  ///
  /// The picker starts at [selected] if set, or else at the last month (or year). Returns the first
  /// day of the picked month (or year) in UTC, or null if the picker was dismissed.
  Future<DateTime?> _pickDate(
    BuildContext context, {
    required String title,
    required DateTime? selected,
    required DateTime first,
    DateTime? last,
  }) async {
    // The pickers work with local dates, bounded by the first day of the first month (or year) and
    // the last day of the last one, but never after today.
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
///
/// Unlike [showDatePicker], only the [selected] date is highlighted, and no day has to be picked.
/// Returns the first day of the picked month (or year), or null if the dialog was dismissed.
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
  /// The year whose months are shown, or null while the years are shown.
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
