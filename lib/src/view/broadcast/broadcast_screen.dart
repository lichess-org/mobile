import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_boards_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_overview_tab.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BroadcastScreen extends StatelessWidget {
  final Broadcast broadcast;

  const BroadcastScreen({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildAndroid(BuildContext context) =>
      _AndroidScreen(broadcast: broadcast);

  Widget _buildIos(BuildContext context) =>
      _CupertinoScreen(broadcast: broadcast);
}

class _AndroidScreen extends StatefulWidget {
  final Broadcast broadcast;

  const _AndroidScreen({required this.broadcast});

  @override
  State<_AndroidScreen> createState() => _AndroidScreenState();
}

class _AndroidScreenState extends State<_AndroidScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late BroadcastTournamentId _selectedTournamentId;
  late BroadcastRoundId _selectedRoundId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
    _selectedTournamentId = widget.broadcast.tour.id;
    _selectedRoundId = widget.broadcast.roundToLinkId;
  }

  void setTournamentId(BroadcastTournamentId tournamentId) {
    setState(() {
      _selectedTournamentId = tournamentId;
    });
  }

  void setRoundId(BroadcastRoundId roundId) {
    setState(() {
      _selectedRoundId = roundId;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.broadcast.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: context.l10n.broadcastOverview),
            Tab(text: context.l10n.broadcastBoards),
          ],
        ),
        // TODO uncomment when eval bar is ready
        // actions: [_BroadcastSettingsButton()],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          BroadcastOverviewTab(tournamentId: _selectedTournamentId),
          BroadcastBoardsTab(
            roundId: _selectedRoundId,
            title: widget.broadcast.title,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: _AndroidTournamentAndRoundSelector(
          tournamentId: _selectedTournamentId,
          setTournamentId: setTournamentId,
          setRoundId: setRoundId,
        ),
      ),
    );
  }
}

class _CupertinoScreen extends StatefulWidget {
  final Broadcast broadcast;

  const _CupertinoScreen({required this.broadcast});

  @override
  _CupertinoScreenState createState() => _CupertinoScreenState();
}

enum _ViewMode { overview, boards }

class _CupertinoScreenState extends State<_CupertinoScreen> {
  _ViewMode _selectedSegment = _ViewMode.boards;
  late BroadcastTournamentId _selectedTournamentId;
  late BroadcastRoundId _selectedRoundId;

  @override
  void initState() {
    super.initState();
    _selectedTournamentId = widget.broadcast.tour.id;
    _selectedRoundId = widget.broadcast.roundToLinkId;
  }

  void setViewMode(_ViewMode mode) {
    setState(() {
      _selectedSegment = mode;
    });
  }

  void setTournamentId(BroadcastTournamentId tournamentId) {
    setState(() {
      _selectedTournamentId = tournamentId;
    });
  }

  void setRoundId(BroadcastRoundId roundId) {
    setState(() {
      _selectedRoundId = roundId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CupertinoSlidingSegmentedControl<_ViewMode>(
          groupValue: _selectedSegment,
          children: {
            _ViewMode.overview: Text(context.l10n.broadcastOverview),
            _ViewMode.boards: Text(context.l10n.broadcastBoards),
          },
          onValueChanged: (_ViewMode? view) {
            if (view != null) {
              setState(() {
                _selectedSegment = view;
              });
            }
          },
        ),
        trailing: _BroadcastSettingsButton(),
      ),
      child: Column(
        children: [
          Expanded(
            child: _selectedSegment == _ViewMode.overview
                ? BroadcastOverviewTab(tournamentId: _selectedTournamentId)
                : BroadcastBoardsTab(
                    roundId: _selectedRoundId,
                    title: widget.broadcast.title,
                  ),
          ),
          _IOSTournamentAndRoundSelector(
            tournamentId: _selectedTournamentId,
            roundId: _selectedRoundId,
            setTournamentId: setTournamentId,
            setRoundId: setRoundId,
          ),
        ],
      ),
    );
  }
}

class _AndroidTournamentAndRoundSelector extends ConsumerWidget {
  final BroadcastTournamentId tournamentId;
  final void Function(BroadcastTournamentId) setTournamentId;
  final void Function(BroadcastRoundId) setRoundId;

  const _AndroidTournamentAndRoundSelector({
    required this.tournamentId,
    required this.setTournamentId,
    required this.setRoundId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournament = ref.watch(broadcastTournamentProvider(tournamentId));

    return switch (tournament) {
      AsyncData(:final value) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (value.group != null)
              Flexible(
                child: DropdownMenu<BroadcastTournamentId>(
                  label: const Text('Tournament'),
                  initialSelection: value.data.id,
                  dropdownMenuEntries: value.group!
                      .map(
                        (tournament) =>
                            DropdownMenuEntry<BroadcastTournamentId>(
                          value: tournament.id,
                          label: tournament.name,
                        ),
                      )
                      .toList(),
                  onSelected: (BroadcastTournamentId? value) async {
                    setTournamentId(value!);
                    final newTournament = await ref.read(
                      broadcastTournamentProvider(value).future,
                    );
                    setRoundId(newTournament.defaultRoundId);
                  },
                ),
              ),
            Flexible(
              child: DropdownMenu<BroadcastRoundId>(
                label: const Text('Round'),
                initialSelection: value.defaultRoundId,
                dropdownMenuEntries: value.rounds
                    .map(
                      (BroadcastRound round) =>
                          DropdownMenuEntry<BroadcastRoundId>(
                        value: round.id,
                        label: round.name,
                      ),
                    )
                    .toList(),
                onSelected: (BroadcastRoundId? value) {
                  setRoundId(value!);
                },
              ),
            ),
          ],
        ),
      AsyncError(:final error) => Center(child: Text(error.toString())),
      _ => const SizedBox.shrink(),
    };
  }
}

const Color _kDefaultToolBarBorderColor = Color(0x4D000000);

const Border _kDefaultToolBarBorder = Border(
  top: BorderSide(
    color: _kDefaultToolBarBorderColor,
    width: 0.0, // 0.0 means one physical pixel
  ),
);

// Code taken from the Cupertino navigation bar widget
Widget _wrapWithBackground({
  Border? border,
  required Color backgroundColor,
  Brightness? brightness,
  required Widget child,
  bool updateSystemUiOverlay = true,
}) {
  Widget result = child;
  if (updateSystemUiOverlay) {
    final bool isDark = backgroundColor.computeLuminance() < 0.179;
    final Brightness newBrightness =
        brightness ?? (isDark ? Brightness.dark : Brightness.light);
    final SystemUiOverlayStyle overlayStyle = switch (newBrightness) {
      Brightness.dark => SystemUiOverlayStyle.light,
      Brightness.light => SystemUiOverlayStyle.dark,
    };
    result = AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: overlayStyle.statusBarColor,
        statusBarBrightness: overlayStyle.statusBarBrightness,
        statusBarIconBrightness: overlayStyle.statusBarIconBrightness,
        systemStatusBarContrastEnforced:
            overlayStyle.systemStatusBarContrastEnforced,
      ),
      child: result,
    );
  }
  final DecoratedBox childWithBackground = DecoratedBox(
    decoration: BoxDecoration(
      border: border,
      color: backgroundColor,
    ),
    child: result,
  );

  if (backgroundColor.a == 0xFF) {
    return childWithBackground;
  }

  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: childWithBackground,
    ),
  );
}

class _IOSTournamentAndRoundSelector extends ConsumerWidget {
  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final void Function(BroadcastTournamentId) setTournamentId;
  final void Function(BroadcastRoundId) setRoundId;

  const _IOSTournamentAndRoundSelector({
    required this.tournamentId,
    required this.roundId,
    required this.setTournamentId,
    required this.setRoundId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    final tournament = ref.watch(broadcastTournamentProvider(tournamentId));

    return switch (tournament) {
      AsyncData(:final value) =>

        /// It should be replaced with a Flutter toolbar widget once it is implemented.
        /// See https://github.com/flutter/flutter/issues/134454

        _wrapWithBackground(
          backgroundColor: backgroundColor,
          border: _kDefaultToolBarBorder,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                spacing: 16.0,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (value.group != null)
                    Flexible(
                      child: CupertinoButton.tinted(
                        child: Text(
                          value.group!
                              .firstWhere(
                                (tournament) => tournament.id == tournamentId,
                              )
                              .name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          showChoicePicker<BroadcastTournamentId>(
                            context,
                            choices: value.group!
                                .map((tournament) => tournament.id)
                                .toList(),
                            labelBuilder: (tournamentId) => Text(
                              value.group!
                                  .firstWhere(
                                    (tournament) =>
                                        tournament.id == tournamentId,
                                  )
                                  .name,
                            ),
                            selectedItem: tournamentId,
                            onSelectedItemChanged: (tournamentId) async {
                              setTournamentId(tournamentId);
                              final newTournament = await ref.read(
                                broadcastTournamentProvider(tournamentId)
                                    .future,
                              );
                              setRoundId(newTournament.defaultRoundId);
                            },
                          );
                        },
                      ),
                    ),
                  Flexible(
                    child: CupertinoButton.tinted(
                      child: Text(
                        value.rounds
                            .firstWhere(
                              (round) => round.id == roundId,
                            )
                            .name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        showChoicePicker<BroadcastRoundId>(
                          context,
                          choices: value.rounds
                              .map(
                                (round) => round.id,
                              )
                              .toList(),
                          labelBuilder: (roundId) => Text(
                            value.rounds
                                .firstWhere((round) => round.id == roundId)
                                .name,
                          ),
                          selectedItem: roundId,
                          onSelectedItemChanged: (roundId) {
                            setRoundId(roundId);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      AsyncError(:final error) => Center(child: Text(error.toString())),
      _ => const SizedBox.shrink(),
    };
  }
}

class _BroadcastSettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppBarIconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => showAdaptiveBottomSheet<void>(
          context: context,
          isDismissible: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => const _BroadcastSettingsBottomSheet(),
        ),
        semanticsLabel: context.l10n.settingsSettings,
      );
}

class _BroadcastSettingsBottomSheet extends ConsumerWidget {
  const _BroadcastSettingsBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastPreferences = ref.watch(broadcastPreferencesProvider);

    return DraggableScrollableSheet(
      initialChildSize: .6,
      expand: false,
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        children: [
          PlatformListTile(
            title:
                Text(context.l10n.settingsSettings, style: Styles.sectionTitle),
            subtitle: const SizedBox.shrink(),
          ),
          const SizedBox(height: 8.0),
          SwitchSettingTile(
            title: const Text('Evaluation bar'),
            value: broadcastPreferences.showEvaluationBar,
            onChanged: (value) {
              ref
                  .read(broadcastPreferencesProvider.notifier)
                  .toggleEvaluationBar();
            },
          ),
        ],
      ),
    );
  }
}
