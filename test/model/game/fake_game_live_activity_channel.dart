import 'dart:async';

import 'package:lichess_mobile/src/model/game/game_live_activity.dart';

/// A call made to [FakeGameLiveActivityChannel].
typedef LiveActivityCall = ({
  String method,
  String? id,
  GameLiveActivityAttributes? attributes,
  GameLiveActivityState? state,
});

/// Records the calls instead of driving a real Live Activity.
class FakeGameLiveActivityChannel({final bool supported = true})
    implements GameLiveActivityChannel {
  final calls = <LiveActivityCall>[];

  /// The values passed to [setConnected], in order.
  final connectedCalls = <bool>[];

  final _stateChanges = StreamController<({String id, LiveActivityState state})>.broadcast();

  int _nextId = 0;

  /// Simulates ActivityKit reporting a state change, e.g. the user dismissing the activity.
  void emitState(String id, LiveActivityState state) => _stateChanges.add((id: id, state: state));

  @override
  Stream<({String id, LiveActivityState state})> get stateChanges => _stateChanges.stream;

  @override
  Future<bool> isSupported() async => supported;

  @override
  Future<String?> start(GameLiveActivityAttributes attributes, GameLiveActivityState state) async {
    final id = 'activity-${_nextId++}';
    calls.add((method: 'start', id: id, attributes: attributes, state: state));
    return id;
  }

  @override
  Future<void> update(String id, GameLiveActivityState state) async {
    calls.add((method: 'update', id: id, attributes: null, state: state));
  }

  @override
  Future<void> end(String id) async {
    calls.add((method: 'end', id: id, attributes: null, state: null));
  }

  @override
  Future<void> setConnected(bool connected) async {
    connectedCalls.add(connected);
  }

  @override
  Future<void> endAll() async {
    calls.add((method: 'endAll', id: null, attributes: null, state: null));
  }
}
