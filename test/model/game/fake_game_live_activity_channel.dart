import 'dart:async';

import 'package:lichess_mobile/src/model/game/game_live_activity.dart';

/// A call made to [FakeGameLiveActivityChannel].
typedef LiveActivityCall = ({
  String method,
  String? id,
  GameLiveActivityAttributes? attributes,
  GameLiveActivityState? state,
  Duration? dismissAfter,
});

/// Records the calls instead of driving a real Live Activity.
class FakeGameLiveActivityChannel({final bool supported = true})
    implements GameLiveActivityChannel {
  final calls = <LiveActivityCall>[];

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
    calls.add((method: 'start', id: id, attributes: attributes, state: state, dismissAfter: null));
    return id;
  }

  @override
  Future<void> update(String id, GameLiveActivityState state) async {
    calls.add((method: 'update', id: id, attributes: null, state: state, dismissAfter: null));
  }

  @override
  Future<void> end(String id, {GameLiveActivityState? state, Duration? dismissAfter}) async {
    calls.add((method: 'end', id: id, attributes: null, state: state, dismissAfter: dismissAfter));
  }

  @override
  Future<void> endAll() async {
    calls.add((method: 'endAll', id: null, attributes: null, state: null, dismissAfter: null));
  }
}
