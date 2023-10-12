import 'dart:io';
import 'dart:math' as math;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:lichess_mobile/src/utils/device_info.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';

part 'auth_socket.g.dart';

const kSRIStorageKey = 'socket_random_identifier';
const kDefaultSocketRoute = '/socket/v5';

const _kDefaultConnectTimeout = Duration(seconds: 10);

/// The delay between the next ping after receiving a pong.
const _kPingDelay = Duration(milliseconds: 2500);

/// The maximum lag before considering the connection as lost.
const _kPingMaxLag = Duration(seconds: 9);
const _kAutoReconnectDelay = Duration(milliseconds: 3500);

/// The delay before closing the socket if idle (no subscription).
///
/// This is a short delay to allow for reconnections when changing screen.
const _kIdleTimeout = Duration(seconds: 5);

/// The delay before closing the socket if the app is in background and the socket
/// is still connected (this is the case when playing a game).
const _kDisconnectOnBackgroundTimeout = Duration(minutes: 20);

typedef CurrentConnection = ({
  Uri route,
  IOWebSocketChannel channel,
  StreamController<SocketEvent> streamController,
});

/// Lichess websocket client.
///
/// Handles authentication:
///  - automatically generate a new SRI for each connection.
///  - adds the following headers on connect:
///   - Authorization header when a token has been stored,
///   - User-Agent header
///
/// Handles low-level ping/pong protocol, message acks, and automatic reconnections.
///
/// This class can only create one single connection, because we never want to
/// have more than one connection open at a time.
/// Calling several times [connect] will return the same [Stream].
///
/// A single [StreamController] is responsible to broadcast events that are
/// then filtered if they don't match the called route. This helps detecting when a
/// subscription is not cancelled properly and targeting a no longer active route.
///
/// The caller cannot close the connection.
/// This is the responsibility of the caller to cancel the subscription(s) when
/// the route changes, or when the socket is no longer needed.
/// The socket will close itself after a short delay when there are no more
/// subscriptions.
class AuthSocket {
  AuthSocket(this._ref, this._log) {
    _appLifecycleListener = AppLifecycleListener(
      onHide: () {
        _closeInBackgroundTimer?.cancel();
        _closeInBackgroundTimer = Timer(
          _kDisconnectOnBackgroundTimeout,
          () {
            _log.info(
              'App is in background for ${_kDisconnectOnBackgroundTimeout.inMinutes}m, closing socket.',
            );
            _close();
          },
        );
      },
      onShow: () {
        _closeInBackgroundTimer?.cancel();
      },
    );
  }

  late final AppLifecycleListener _appLifecycleListener;

  final Logger _log;
  final AuthSocketRef _ref;

  Timer? _pingTimer;
  Timer? _reconnectTimer;
  Timer? _ackResendTimer;
  Timer? _closeTimer;
  Timer? _closeInBackgroundTimer;
  int _pongCount = 0;
  DateTime _lastPing = DateTime.now();

  StreamSubscription<SocketEvent>? _socketStreamSubscription;

  /// The list of acknowledgeable messages.
  List<(DateTime, int, Map<String, dynamic>)> _acks = [];

  /// The current ack id. Incremented for each ack.
  int _ackId = 1;

  /// The current connection.
  CurrentConnection? _connection;

  /// Gets the current WebSocket sink
  WebSocketSink? get _sink => _connection?.channel.sink;

  /// The current socket route if connected.
  Uri? get route => _connection?.route;

  /// Returns the socket event broadcast stream filtered on the given route if connected.
  Stream<SocketEvent>? getStreamOnRoute(Uri route) =>
      _connection?.streamController.stream
          .where((_) => route == _connection?.route);

  /// The Socket Random Identifier.
  String get sri => _ref.read(sriProvider);

  /// Creates a new WebSocket channel.
  ///
  /// If a connection already exists it will keep the current connection.
  ///
  /// An optional `forceReconnect` boolean can be provided to force a reconnection.
  ///
  /// Returns a tuple of:
  ///  - the socket event broadcast [Stream]
  ///  - a [Future] that completes when the socket is ready. The future might never
  /// complete if the socket fails to connect because it tries to reconnect automatically.
  (Stream<SocketEvent>, Future<void>) connect(
    Uri route, {
    bool? forceReconnect = false,
  }) {
    if (forceReconnect == false &&
        _connection != null &&
        _connection!.channel.closeCode == null &&
        route == _connection!.route) {
      return (
        _connection!.streamController.stream,
        _connection!.channel.ready,
      );
    }

    _closeTimer?.cancel();
    _acks = [];
    _ackId = 1;

    final connection = _doConnect(route);

    return (
      connection.streamController.stream.where((_) {
        if (route != _connection?.route) {
          _log.warning(
            'Received event for route $route on active route ${_connection?.route}. Have you forgotten to cancel a subscription?',
          );
          return false;
        }
        return true;
      }),
      connection.channel.ready,
    );
  }

  /// Sends a message to the websocket.
  void send(
    String topic,
    Object? data, {
    bool? ackable,
    bool? withLag,
  }) {
    Map<String, Object> message;

    if (ackable == true) {
      final ackId = _ackId++;
      message = {
        't': topic,
        'd': {
          if (data != null && data is Map<String, Object>) ...data,
          'a': ackId,
          if (withLag == true)
            'l': _ref.read(averageLagProvider).inMilliseconds,
        },
      };
      _acks.add((DateTime.now(), ackId, message));
    } else {
      message = {
        't': topic,
        if (data != null && data is Map<String, Object>)
          'd': {
            ...data,
            if (withLag == true)
              'l': _ref.read(averageLagProvider).inMilliseconds,
          }
        else if (data != null)
          'd': data,
      };
    }

    _sink?.add(jsonEncode(message));
  }

  void dispose() {
    _close();
    _appLifecycleListener.dispose();
  }

  /// Closes the WebSocket connection.
  ///
  /// If a delay is provided, the connection will be closed after the delay.
  /// If a new connection is created before the delay, the close will be cancelled.
  void _close({Duration? delay}) {
    _log.fine(
      'Closing WebSocket connection ${delay == null ? 'now' : 'in ${delay.inSeconds}s'}.',
    );
    _closeTimer?.cancel();
    _closeTimer = Timer(
      delay ?? Duration.zero,
      () => _closeCurrent(() {
        if (_connection == null) {
          return;
        }
        _connection?.streamController.close().then((_) {
          _log.fine('WebSocket stream controller properly closed.');
        });
        _log.info('WebSocket connection closed.');
        _connection = null;
      }),
    );
  }

  /// Connect or reconnect the WebSocket.
  CurrentConnection _doConnect(Uri route) {
    _closeCurrent();
    _pongCount = 0;
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    _ackResendTimer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (_) => _resendAcks(),
    );

    final session = _ref.read(authSessionProvider);
    final pInfo = _ref.read(packageInfoProvider);
    final deviceInfo = _ref.read(deviceInfoProvider);
    final uri = Uri.parse('$kLichessWSHost$route');
    final Map<String, String> headers = session != null
        ? {
            'Authorization': 'Bearer ${signBearerToken(session.token)}',
          }
        : {};
    WebSocket.userAgent = userAgent(pInfo, deviceInfo, sri, session?.user);

    _log.info('Creating WebSocket connection to $uri');

    final channel = IOWebSocketChannel.connect(
      uri,
      connectTimeout: _kDefaultConnectTimeout,
      headers: headers,
    );

    _socketStreamSubscription?.cancel();
    _socketStreamSubscription = channel.stream.map((raw) {
      if (raw == '0') {
        return SocketEvent.pong;
      }
      return SocketEvent.fromJson(
        jsonDecode(raw as String) as Map<String, dynamic>,
      );
    }).listen(_handleEvent);

    _connection = (
      route: route,
      channel: channel,
      streamController: _connection?.streamController ??
          StreamController<SocketEvent>.broadcast(
            onListen: _onStreamListen,
            onCancel: _onStreamCancel,
          ),
    );

    channel.ready.then(
      (_) {
        _log.info('WebSocket connection established.');
        _ref.read(averageLagProvider.notifier).reset();
        _sendPing();
        _resendAcks();
        _schedulePing(_kPingDelay);
      },
      onError: (Object e) {
        _log.severe('WebSocket connection failed.', e);
        _ref.read(averageLagProvider.notifier).reset();
        if (_connection != null) {
          _scheduleReconnect(_kAutoReconnectDelay, _connection!.route);
        }
      },
    );

    return _connection!;
  }

  /// Called when the first listener is added to the socket stream.
  void _onStreamListen() {
    _log.fine('WebSocket connection subscribed.');
    _closeTimer?.cancel();
  }

  /// Called when the last listener is removed from the socket stream.
  void _onStreamCancel() {
    _log.fine('WebSocket connection idle, closing.');
    _close(delay: _kIdleTimeout);
  }

  void _handleEvent(SocketEvent event) {
    switch (event.topic) {
      case '_pong':
      case 'n':
        _handlePong(_kPingDelay);
      case 'ack':
        _onServerAck(event);
    }

    if (event != SocketEvent.pong) {
      _connection?.streamController.add(event);
    }
  }

  void _schedulePing(Duration delay) {
    _pingTimer?.cancel();
    _pingTimer = Timer(delay, _sendPing);
  }

  /// Sends a ping to the server.
  void _sendPing() {
    _sink?.add(
      _pongCount % 10 == 2
          ? jsonEncode({
              't': 'p',
              'l': (_ref.read(averageLagProvider).inMilliseconds * 0.1).round(),
            })
          : 'p',
    );
    _lastPing = DateTime.now();
    if (_connection != null) {
      _scheduleReconnect(_kPingMaxLag, _connection!.route);
    }
  }

  void _handlePong(Duration pingDelay) {
    _reconnectTimer?.cancel();
    if (_pongCount == 0) {
      _log.info('Ping/pong protocol established.');
    }
    _schedulePing(pingDelay);
    _pongCount++;
    final currentLag = Duration(
      milliseconds:
          math.min(DateTime.now().difference(_lastPing).inMilliseconds, 10000),
    );

    // Average first 4 pings, then switch to decaying average.
    final mix = _pongCount > 4 ? 0.1 : 1 / _pongCount;
    _ref.read(averageLagProvider.notifier).add(currentLag, mix);
  }

  void _scheduleReconnect(Duration delay, Uri route) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_connection != null) {
        _ref.read(averageLagProvider.notifier).reset();
        _log.info('Reconnecting WebSocket.');
        _doConnect(route);
      }
    });
  }

  void _onServerAck(SocketEvent event) {
    if (event.data is! int) {
      return;
    }
    _acks.removeWhere((rec) => rec.$2 == event.data);
  }

  void _resendAcks() {
    final resendCutoff =
        DateTime.now().subtract(const Duration(milliseconds: 2500));
    for (final (at, _, ack) in _acks) {
      if (at.isBefore(resendCutoff)) {
        _sink?.add(jsonEncode(ack));
      }
    }
  }

  /// Closes current connection, but keep the streamController open to allow for reconnections
  void _closeCurrent([void Function()? afterClose]) {
    _sink?.close();
    _socketStreamSubscription?.cancel();
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    afterClose?.call();
  }
}

@Riverpod(keepAlive: true)
AuthSocket authSocket(AuthSocketRef ref) {
  final authSocket = AuthSocket(ref, Logger('AuthSocket'));
  ref.onDispose(() {
    authSocket.dispose();
  });
  return authSocket;
}

/// Socket Random Identifier.
@Riverpod(keepAlive: true)
String sri(SriRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  return ref.read(appDependenciesProvider).requireValue.sri;
}

/// Average lag computed from WebSocket ping/pong protocol.
@riverpod
class AverageLag extends _$AverageLag {
  @override
  Duration build() => Duration.zero;

  void reset() {
    state = Duration.zero;
  }

  void add(Duration currentLag, double mix) {
    state += (currentLag - state) * mix;
  }
}
