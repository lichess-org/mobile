import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_live_activity.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

const _sampleMoves = [
  'e2e4',
  'e7e5',
  'g1f3',
  'b8c6',
  'f1b5',
  'a7a6',
  'b5a4',
  'g8f6',
  'e1g1',
  'f8e7',
];

/// Debug-only screen to drive the game Live Activity with a fake rapid game.
class const LiveActivityDebugScreen({super.key}) extends StatefulWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const LiveActivityDebugScreen());
  }

  @override
  State<LiveActivityDebugScreen> createState() => _LiveActivityDebugScreenState();
}

class _LiveActivityDebugScreenState() extends State<LiveActivityDebugScreen> {
  final _channel = GameLiveActivityChannel.instance;

  String? _activityId;
  String _log = '';
  Position _position = Chess.initial;
  int _ply = 0;
  String? _lastMove;
  String? _lastSan;
  Duration _whiteClock = const Duration(minutes: 10);
  Duration _blackClock = const Duration(minutes: 10);
  GameLiveActivityOffer? _offer;

  @override
  void initState() {
    super.initState();
    _channel.stateChanges.listen((change) {
      if (mounted) setState(() => _log = 'Activity ${change.id}: ${change.state.name}');
    });
  }

  GameLiveActivityState _state() => GameLiveActivityState(
    fen: GameLiveActivityState.boardFen(_position),
    lastMove: _lastMove,
    lastSan: _lastSan,
    turn: _position.turn,
    whiteClock: _whiteClock,
    blackClock: _blackClock,
    clockAt: DateTime.now(),
    clockRunning: _ply >= 2,
    offer: _offer,
    claimable: _ply >= 2,
  );

  Future<void> _start() async {
    final supported = await _channel.isSupported();
    if (!supported) {
      setState(() => _log = 'Live Activities not supported or disabled');
      return;
    }
    final id = await _channel.start(
      const GameLiveActivityAttributes(
        gameFullId: GameFullId('abcdefgh1234'),
        myColor: Side.white,
        white: GameLiveActivityPlayer(name: 'veloce', rating: 1850),
        black: GameLiveActivityPlayer(name: 'Magnus', title: 'GM', rating: 2850),
      ),
      _state(),
    );
    setState(() => _log = id == null ? 'Could not start' : 'Started $id');
    _activityId = id;
  }

  Future<void> _playNextMove() async {
    final id = _activityId;
    if (id == null) return;
    final move = Move.parse(_sampleMoves[_ply % _sampleMoves.length]);
    if (move == null || !_position.isLegal(move)) {
      setState(() => _log = 'Sample game over, restart the activity');
      return;
    }
    final mover = _position.turn;
    final (position, san) = _position.makeSan(move);
    setState(() {
      if (_ply >= 2) {
        if (mover == Side.white) {
          _whiteClock -= const Duration(seconds: 17);
        } else {
          _blackClock -= const Duration(seconds: 23);
        }
      }
      _position = position;
      _lastMove = move.uci;
      _lastSan = san;
      _ply++;
      _offer = null;
    });
    await _channel.update(id, _state());
  }

  Future<void> _toggleOffer(GameLiveActivityOffer offer) async {
    final id = _activityId;
    if (id == null) return;
    setState(() => _offer = _offer == offer ? null : offer);
    await _channel.update(id, _state());
  }

  Future<void> _end() async {
    final id = _activityId;
    if (id == null) return;
    await _channel.end(id, dismissAfter: Duration.zero);
    setState(() {
      _activityId = null;
      _position = Chess.initial;
      _ply = 0;
      _lastMove = null;
      _lastSan = null;
      _whiteClock = const Duration(minutes: 10);
      _blackClock = const Duration(minutes: 10);
      _offer = null;
      _log = 'Ended $id';
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasActivity = _activityId != null;
    return PlatformScaffold(
      appBar: const PlatformAppBar(title: Text('Live Activity (debug)')),
      body: ListView(
        children: [
          ListSection(
            children: [
              ListTile(title: const Text('Start'), enabled: !hasActivity, onTap: _start),
              ListTile(
                title: const Text('Play next move'),
                subtitle: Text('Ply $_ply, ${_position.turn.name} to move'),
                enabled: hasActivity,
                onTap: _playNextMove,
              ),
              ListTile(
                title: const Text('Toggle draw offer'),
                enabled: hasActivity,
                onTap: () => _toggleOffer(GameLiveActivityOffer.draw),
              ),
              ListTile(
                title: const Text('Toggle takeback offer'),
                enabled: hasActivity,
                onTap: () => _toggleOffer(GameLiveActivityOffer.takeback),
              ),
              ListTile(title: const Text('End (1-0)'), enabled: hasActivity, onTap: _end),
              ListTile(
                title: const Text('End all'),
                onTap: () async {
                  await _channel.endAll();
                  setState(() {
                    _activityId = null;
                    _log = 'Ended all';
                  });
                },
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.all(16), child: Text(_log)),
        ],
      ),
    );
  }
}
