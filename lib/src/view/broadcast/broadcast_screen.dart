import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_boards_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_overview_tab.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class BroadcastScreen extends StatelessWidget {
  final Broadcast broadcast;

  const BroadcastScreen({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _CupertinoBody(broadcast: broadcast),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return _AndroidBody(broadcast: broadcast);
  }
}

class _AndroidBody extends StatefulWidget {
  final Broadcast broadcast;

  const _AndroidBody({required this.broadcast});

  @override
  State<_AndroidBody> createState() => _AndroidBodyState();
}

class _AndroidBodyState extends State<_AndroidBody>
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
          tabs: const <Widget>[
            Tab(text: 'Overview'),
            Tab(text: 'Boards'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          BroadcastOverviewTab(tournamentId: _selectedTournamentId),
          BroadcastBoardsTab(roundId: _selectedRoundId),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TournamentAndRoundDropdowns(
          tournamentId: _selectedTournamentId,
          setTournamentId: setTournamentId,
          setRoundId: setRoundId,
        ),
      ),
    );
  }
}

class _CupertinoBody extends StatefulWidget {
  final Broadcast broadcast;

  const _CupertinoBody({required this.broadcast});

  @override
  _CupertinoBodyState createState() => _CupertinoBodyState();
}

enum _ViewMode { overview, boards }

class _CupertinoBodyState extends State<_CupertinoBody> {
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
    return SafeArea(
      child: Padding(
        padding: Styles.bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CupertinoSlidingSegmentedControl<_ViewMode>(
              groupValue: _selectedSegment,
              children: const {
                _ViewMode.overview: Text('Overview'),
                _ViewMode.boards: Text('Boards'),
              },
              onValueChanged: (_ViewMode? view) {
                if (view != null) {
                  setState(() {
                    _selectedSegment = view;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TournamentAndRoundDropdowns(
              tournamentId: _selectedTournamentId,
              setTournamentId: setTournamentId,
              setRoundId: setRoundId,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedSegment == _ViewMode.overview
                  ? BroadcastOverviewTab(tournamentId: _selectedTournamentId)
                  : BroadcastBoardsTab(roundId: _selectedRoundId),
            ),
          ],
        ),
      ),
    );
  }
}

class TournamentAndRoundDropdowns extends ConsumerWidget {
  final BroadcastTournamentId tournamentId;
  final void Function(BroadcastTournamentId) setTournamentId;
  final void Function(BroadcastRoundId) setRoundId;

  const TournamentAndRoundDropdowns({
    super.key,
    required this.tournamentId,
    required this.setTournamentId,
    required this.setRoundId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournament = ref.watch(broadcastTournamentProvider(tournamentId));

    return tournament.when(
      data: (tournament) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (tournament.group != null)
              Flexible(
                child: DropdownMenu<BroadcastTournamentId>(
                  label: const Text('Tournament'),
                  initialSelection: tournament.data.id,
                  dropdownMenuEntries: tournament.group!
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
                initialSelection: tournament.defaultRoundId,
                dropdownMenuEntries: tournament.rounds
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
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}
