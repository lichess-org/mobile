import 'package:dartchess/dartchess.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      // Grow the sheet above the keyboard so that the date inputs stay visible.
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0 + MediaQuery.viewInsetsOf(context).bottom),
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

final _yearRegExp = RegExp(r'^(\d{4})$');
final _monthRegExp = RegExp(r'^(\d{4})[-/](0[1-9]|1[0-2])$');

/// Since and until inputs bounding the date range of the explorer games.
///
/// Dates are typed in the `YYYY` format when [yearOnly] is true, and in the `YYYY-MM` format
/// otherwise, like on the website. A date is saved as soon as it is valid, and clearing an input
/// removes that bound.
class const _DateRangeInputs({
  required final DateTime? since,
  required final DateTime? until,
  required final DateTime earliest,
  required final void Function(DateTime? since, DateTime? until) onChanged,
  final bool yearOnly = false,
  super.key,
}) extends StatefulWidget {
  @override
  State<_DateRangeInputs> createState() => _DateRangeInputsState();
}

class _DateRangeInputsState() extends State<_DateRangeInputs> {
  late final _sinceController = TextEditingController(text: _format(widget.since));
  late final _untilController = TextEditingController(text: _format(widget.until));

  @override
  void dispose() {
    _sinceController.dispose();
    _untilController.dispose();
    super.dispose();
  }

  String _format(DateTime? date) => date == null
      ? ''
      : widget.yearOnly
      ? '${date.year}'
      : '${date.year}-${date.month.toString().padLeft(2, '0')}';

  DateTime? _parse(String text) {
    if (widget.yearOnly) {
      final match = _yearRegExp.firstMatch(text.trim());
      return match != null ? DateTime.utc(int.parse(match[1]!)) : null;
    }
    final match = _monthRegExp.firstMatch(text.trim());
    return match != null ? DateTime.utc(int.parse(match[1]!), int.parse(match[2]!)) : null;
  }

  DateTime get _latest {
    final now = DateTime.now();
    return widget.yearOnly ? DateTime.utc(now.year) : DateTime.utc(now.year, now.month);
  }

  /// Returns an error message for [text], or null if it is empty or a valid date not before
  /// [after].
  String? _validate(String text, {DateTime? after}) {
    if (text.trim().isEmpty) return null;
    final date = _parse(text);
    if (date == null) return widget.yearOnly ? 'Use the YYYY format' : 'Use the YYYY-MM format';
    if (date.isBefore(widget.earliest) || date.isAfter(_latest)) {
      return 'Between ${_format(widget.earliest)} and ${_format(_latest)}';
    }
    if (after != null && date.isBefore(after)) return 'Invalid date range';
    return null;
  }

  /// Saves the valid dates typed in the inputs, keeping the saved date of an invalid input.
  void _onChanged(String _) {
    setState(() {});
    final sinceText = _sinceController.text;
    final untilText = _untilController.text;
    final since = _validate(sinceText) == null ? _parse(sinceText) : widget.since;
    final until = _validate(untilText, after: since) == null ? _parse(untilText) : widget.until;
    if (since != widget.since || until != widget.until) widget.onChanged(since, until);
  }

  @override
  Widget build(BuildContext context) {
    final hintText = widget.yearOnly ? 'YYYY' : 'YYYY-MM';
    final keyboardType = widget.yearOnly ? TextInputType.number : TextInputType.datetime;
    final inputFormatters = [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9\-/]')),
      LengthLimitingTextInputFormatter(hintText.length),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: TextField(
              controller: _sinceController,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                labelText: context.l10n.since,
                hintText: hintText,
                errorText: _validate(_sinceController.text),
                errorMaxLines: 2,
              ),
              onChanged: _onChanged,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: TextField(
              controller: _untilController,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                labelText: context.l10n.until,
                hintText: hintText,
                errorText: _validate(_untilController.text, after: widget.since),
                errorMaxLines: 2,
              ),
              onChanged: _onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
