import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/utils/device_info.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'socket.freezed.dart';
part 'socket.g.dart';

const kSRIStorageKey = 'socket_random_identifier';
const kDefaultSocketRoute = '/socket/v5';

const _kDefaultConnectTimeout = Duration(seconds: 10);
const _kPingDelay = Duration(milliseconds: 2500);
const _kPingMaxLag = Duration(seconds: 9);
const _kAutoReconnectDelay = Duration(milliseconds: 3500);
const _kResendAckDelay = Duration(milliseconds: 1500);
const _kIdleTimeout = Duration(seconds: 2);
const _kDisconnectOnBackgroundTimeout = Duration(minutes: 10);

final _logger = Logger('Socket');

class SocketClient {
  SocketClient(
    this._ref,
    this._log, {
    required this.route,
    this.onOpen,
    this.onStreamListen,
    this.onStreamCancel,
    this.pingDelay = _kPingDelay,
    this.pingMaxLag = _kPingMaxLag,
    this.autoReconnectDelay = _kAutoReconnectDelay,
    this.resendAckDelay = _kResendAckDelay,
  });

  /// The route to connect to.
  final Uri route;

  /// A callback to be called whenever the socket is (re)opened.
  final VoidCallback? onOpen;

  /// The delay between the next ping after receiving a pong.
  final Duration pingDelay;

  /// The maximum lag before considering the connection as lost.
  final Duration pingMaxLag;

  /// The delay before reconnecting after a connection failure.
  final Duration autoReconnectDelay;

  /// The delay before resending an ack.
  final Duration resendAckDelay;

  Completer<void> _firstConnection = Completer<void>();

  /// Called when the first listener is added to the socket stream.
  final VoidCallback? onStreamListen;

  /// Called when the last listener is removed from the socket stream.
  final VoidCallback? onStreamCancel;

  late final StreamController<SocketEvent> _streamController =
      StreamController<SocketEvent>.broadcast(
    onListen: onStreamListen,
    onCancel: onStreamCancel,
  );

  final Logger _log;
  final SocketPoolRef _ref;

  Timer? _pingTimer;
  Timer? _reconnectTimer;
  Timer? _ackResendTimer;
  int _pongCount = 0;
  DateTime _lastPing = DateTime.now();

  final _averageLag = ValueNotifier(Duration.zero);

  StreamSubscription<SocketEvent>? _socketStreamSubscription;

  /// The list of acknowledgeable messages.
  final List<(DateTime, int, Map<String, dynamic>)> _acks = [];

  /// The current number of connections attempted.
  int nbConnections = 0;

  /// The current ack id. Incremented for each ack.
  int _ackId = 1;

  /// The current WebSocket channel.
  WebSocketChannel? _channel;

  /// Gets the current WebSocket sink
  WebSocketSink? get _sink => _channel?.sink;

  /// The socket events broadcast stream.
  Stream<SocketEvent> get stream => _streamController.stream;

  /// The Socket Random Identifier.
  String get sri => _ref.read(sriProvider);

  /// The average lag computed from ping/pong protocol.
  ///
  /// A duration of zero means the socket is not connected.
  ValueListenable<Duration> get averageLag => _averageLag;

  /// Whether the socket is connected.
  bool get isConnected => averageLag.value != Duration.zero;

  /// Whether the client is disposed. If true the client cannot be reconnected, or
  /// be listened to.
  bool get isDisposed => _streamController.isClosed;

  /// A [Future] that completes when the first connection is established.
  Future<void> get firstConnection => _firstConnection.future;

  /// Connect or reconnect the WebSocket.
  Future<void> connect() async {
    if (isDisposed) {
      throw StateError('SocketClient is disposed.');
    }
    _disconnect();
    _pongCount = 0;
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    _ackResendTimer = Timer.periodic(resendAckDelay, (_) => _resendAcks());

    final session = _ref.read(authSessionProvider);
    final pInfo = _ref.read(packageInfoProvider);
    final deviceInfo = _ref.read(deviceInfoProvider);
    final uri = Uri.parse('$kLichessWSHost$route');
    final Map<String, String> headers = session != null
        ? {
            'Authorization': 'Bearer ${signBearerToken(session.token)}',
          }
        : {};
    WebSocket.userAgent = makeUserAgent(pInfo, deviceInfo, sri, session?.user);

    _log.info('Creating WebSocket connection to $uri');

    nbConnections++;

    try {
      final channel = await _ref.read(webSocketChannelFactoryProvider).create(
            uri.toString(),
            headers: headers,
            timeout: _kDefaultConnectTimeout,
          );

      _channel = channel;

      _socketStreamSubscription?.cancel();
      _socketStreamSubscription = channel.stream.map((raw) {
        if (raw == '0') {
          return SocketEvent.pong;
        }
        return SocketEvent.fromJson(
          jsonDecode(raw as String) as Map<String, dynamic>,
        );
      }).listen(_handleEvent);

      _log.fine('WebSocket connection established.');

      if (nbConnections == 1) {
        _firstConnection.complete();
      }

      _averageLag.value = Duration.zero;
      _sendPing();
      _schedulePing(pingDelay);

      onOpen?.call();
      _resendAcks();
    } catch (error) {
      _log.severe('WebSocket connection failed.', error);
      _averageLag.value = Duration.zero;
      _scheduleReconnect(autoReconnectDelay);
    }
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
          if (withLag == true) 'l': _averageLag.value.inMilliseconds,
        },
      };
      _acks.add((DateTime.now(), ackId, message));
    } else {
      message = {
        't': topic,
        if (data != null && data is Map<String, Object>)
          'd': {
            ...data,
            if (withLag == true) 'l': _averageLag.value.inMilliseconds,
          }
        else if (data != null)
          'd': data,
      };
    }

    _sink?.add(jsonEncode(message));
  }

  /// Closes the WebSocket connection and disposes the client.
  ///
  /// This should be called only when the client is no longer needed.
  /// This method is private because it should not be called directly by the
  /// class user, rather by the [SocketPool] managing the clients.
  /// The [SocketPool] will call this method when the client is no longer needed.
  /// Widgets and riverpod controllers should only subscribe and unsubscribe to
  /// the client [stream].
  void _dispose() {
    _disconnect();
    _averageLag.dispose();
    _streamController.close();
  }

  /// Closes the WebSocket connection when temporarily not needed (by default
  /// this is when we open another one).
  ///
  /// The connection can be reopend later by calling [connect]. This will reset
  /// the [firstConnection] future and the [nbConnections] counter.
  Future<void> close() {
    nbConnections = 0;
    _firstConnection = Completer<void>();
    return _disconnect();
  }

  /// Disconnects websocket connection.
  ///
  /// Returns a [Future] that completes when the connection is closed.
  Future<void> _disconnect() {
    final future = _sink?.close().then((_) {
          _log.fine('WebSocket connection was properly closed.');
          _averageLag.value = Duration.zero;
        }).catchError((Object? error) {
          _averageLag.value = Duration.zero;
          _log.warning('WebSocket connection could not be closed.', error);
        }) ??
        Future.value();
    _channel = null;
    _socketStreamSubscription?.cancel();
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();

    return future;
  }

  void _handleEvent(SocketEvent event) {
    switch (event.topic) {
      case '_pong':
      case 'n':
        _handlePong(pingDelay);
      case 'ack':
        _onServerAck(event);
    }

    if (event != SocketEvent.pong && event.topic != 'ack') {
      if (_streamController.hasListener) {
        _streamController.add(event);
      }
      if (_globalStreamController.hasListener) {
        _globalStreamController.add(event);
      }
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
              'l': (_averageLag.value.inMilliseconds * 0.1).round(),
            })
          : 'p',
    );
    _lastPing = DateTime.now();
    _scheduleReconnect(pingMaxLag);
  }

  void _handlePong(Duration pingDelay) {
    _reconnectTimer?.cancel();
    if (_pongCount == 0) {
      _log.fine('Ping/pong protocol established.');
    }
    _schedulePing(pingDelay);
    _pongCount++;
    final currentLag = Duration(
      milliseconds:
          math.min(DateTime.now().difference(_lastPing).inMilliseconds, 10000),
    );

    // Average first 4 pings, then switch to decaying average.
    final mix = _pongCount > 4 ? 0.1 : 1 / _pongCount;
    _averageLag.value += (currentLag - _averageLag.value) * mix;
  }

  void _scheduleReconnect(Duration delay) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      _averageLag.value = Duration.zero;
      _log.fine('Reconnecting WebSocket.');
      connect();
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
}

final _globalStreamController = StreamController<SocketEvent>.broadcast();

/// The global socket events broadcast stream.
final socketGlobalStream = _globalStreamController.stream;

class SocketPool {
  SocketPool(
    this._ref, {
    this.idleTimeout = _kIdleTimeout,
  }) {
    // Create a default socket client. This one is never disposed.
    final client = SocketClient(
      _ref,
      _log,
      route: _activeRoute,
    )..connect();

    client.averageLag.addListener(() {
      if (_activeRoute == client.route) {
        _averageLag.value = client.averageLag.value;
      }
    });

    _pool[_activeRoute] = client;
  }

  final SocketPoolRef _ref;

  final Logger _log = Logger('SocketService');

  /// The delay before closing the socket if idle (no subscription).
  final Duration idleTimeout;

  final _averageLag = ValueNotifier(Duration.zero);

  /// The average lag computed from ping/pong protocol of the current active route.
  ///
  /// A duration of zero means the socket is not connected.
  ValueListenable<Duration> get averageLag => _averageLag;

  /// The active socket route.
  Uri _activeRoute = Uri(path: kDefaultSocketRoute);

  /// The active socket client.
  SocketClient get activeClient => _pool[_activeRoute]!;

  /// The socket clients pool.
  final Map<Uri, SocketClient> _pool = {};
  final Map<Uri, Timer?> _disposeTimers = {};

  /// Creates a new WebSocket connection to the given [route].
  SocketClient connect(
    Uri route, {
    VoidCallback? onOpen,
    bool? forceReconnect,
  }) {
    _activeRoute = route;

    if (_pool[route] == null) {
      _pool[route] = SocketClient(
        _ref,
        _log,
        route: route,
        onOpen: onOpen,
        onStreamListen: () {
          _disposeTimers[route]?.cancel();
        },
        onStreamCancel: () {
          // Schedule the socket to be closed if idle, after a short delay to
          // avoid unnecessary reconnections.
          _disposeTimers[route]?.cancel();
          _disposeTimers[route] = Timer(idleTimeout, () {
            _log.fine('Closing idle socket.');
            _pool[route]?._dispose();
            _pool.remove(route);
            if (route == _activeRoute) {
              _activeRoute = Uri(path: kDefaultSocketRoute);
              activeClient.connect();
            }
          });
        },
      );
    }

    // ensure there is only one active connection
    _pool.forEach((k, c) {
      if (k != route) {
        c.close();
      }
    });

    final client = _pool[route]!;

    if (forceReconnect == true || client.nbConnections == 0) {
      client.connect();
    }

    client.averageLag.addListener(() {
      if (_activeRoute == client.route) {
        _averageLag.value = client.averageLag.value;
      }
    });

    return client;
  }

  void dispose() {
    _averageLag.dispose();
    _pool.forEach((_, c) => c._dispose());
  }

  void send(
    String topic,
    Object? data, {
    bool? ackable,
    bool? withLag,
  }) {
    activeClient.send(topic, data, ackable: ackable, withLag: withLag);
  }
}

@Riverpod(keepAlive: true)
SocketPool socketPool(SocketPoolRef ref) {
  final pool = SocketPool(ref);
  Timer? closeInBackgroundTimer;

  final appLifecycleListener = AppLifecycleListener(
    onHide: () {
      closeInBackgroundTimer?.cancel();
      closeInBackgroundTimer = Timer(
        _kDisconnectOnBackgroundTimeout,
        () {
          _logger.info(
            'App is in background for ${_kDisconnectOnBackgroundTimeout.inMinutes}m, terminating socket.',
          );
          pool.activeClient.close();
        },
      );
    },
    onShow: () {
      closeInBackgroundTimer?.cancel();
      if (pool.activeClient.nbConnections == 0) {
        pool.activeClient.connect();
      }
    },
  );

  ref.onDispose(() {
    pool.dispose();
    closeInBackgroundTimer?.cancel();
    appLifecycleListener.dispose();
  });
  return pool;
}

class SocketService {
  SocketService(
    this._ref,
    this._log, {
    this.pingDelay = _kPingDelay,
    this.pingMaxLag = _kPingMaxLag,
    this.autoReconnectDelay = _kAutoReconnectDelay,
    this.resendAckDelay = _kResendAckDelay,
    this.idleTimeout = _kIdleTimeout,
  });

  /// The delay between the next ping after receiving a pong.
  final Duration pingDelay;

  /// The maximum lag before considering the connection as lost.
  final Duration pingMaxLag;

  /// The delay before reconnecting after a connection failure.
  final Duration autoReconnectDelay;

  /// The delay before resending an ack.
  final Duration resendAckDelay;

  /// The delay before closing the socket if idle (no subscription).
  final Duration idleTimeout;

  late final StreamController<SocketEvent> _streamController =
      StreamController<SocketEvent>.broadcast(
    onListen: _onStreamListen,
    onCancel: _onStreamCancel,
  );

  late final StreamController<Uri> _readyStreamController =
      StreamController<Uri>.broadcast();

  final Logger _log;
  final SocketServiceRef _ref;

  Timer? _pingTimer;
  Timer? _reconnectTimer;
  Timer? _ackResendTimer;
  Timer? _closeTimer;
  int _pongCount = 0;
  DateTime _lastPing = DateTime.now();

  final _averageLag = ValueNotifier(Duration.zero);

  StreamSubscription<SocketEvent>? _socketStreamSubscription;

  /// The list of acknowledgeable messages.
  List<(DateTime, int, Map<String, dynamic>)> _acks = [];

  /// The current ack id. Incremented for each ack.
  int _ackId = 1;

  /// The current route the websocket is connected to.
  Uri? _route;

  /// The current WebSocket channel.
  WebSocketChannel? _channel;

  /// Gets the current WebSocket sink
  WebSocketSink? get _sink => _channel?.sink;

  /// The current socket route if a connection is active.
  Uri? get route => _route;

  /// The socket events broadcast stream.
  Stream<SocketEvent> get stream => _streamController.stream;

  /// The socket connection ready broadcast stream.
  ///
  /// This stream emits each time a new websocket is connected.
  Stream<Uri> get readyStream => _readyStreamController.stream;

  /// The Socket Random Identifier.
  String get sri => _ref.read(sriProvider);

  /// The average lag computed from ping/pong protocol.
  ///
  /// A duration of zero means the socket is not connected.
  ValueListenable<Duration> get averageLag => _averageLag;

  /// Whether the socket is connected.
  bool get isConnected => averageLag.value != Duration.zero;

  /// Creates a new WebSocket channel.
  ///
  /// Calling several times [connect] with the same route will not re-create a new
  /// connection unless `forceReconnect` is set to `true`.
  ///
  /// Returns a tuple of:
  ///  - the socket event [Stream] for the given route.
  ///  - the channel ready [Stream], which emits each time a new websocket is connected.
  ///    Use [Stream.first] to wait for the first connection, or subscribe to this
  ///    stream to be notified of reconnections.
  (Stream<SocketEvent>, Stream<void>) connect(
    Uri route, {
    bool? forceReconnect = false,
  }) {
    final filteredStream = _streamController.stream.where((_) {
      if (route != _route) {
        _log.warning(
          'Received event for route $route on active route $_route. Have you forgotten to cancel a subscription?',
        );
        return false;
      }
      return true;
    });

    final filteredReadyStream = _readyStreamController.stream.where((Uri uri) {
      if (uri != route) {
        _log.warning(
          'Received ready event for route $route on active route $uri. Have you forgotten to cancel a subscription?',
        );
        return false;
      }
      return true;
    });

    if (forceReconnect == false &&
        _channel != null &&
        _channel!.closeCode == null &&
        _averageLag.value != Duration.zero &&
        route == _route) {
      // Already connected to the given route, we still want to notify the caller
      // that the socket is ready.
      _readyStreamController.add(route);
      return (
        filteredStream,
        filteredReadyStream,
      );
    }

    _closeTimer?.cancel();
    _acks = [];
    _ackId = 1;

    _doConnect(route);

    return (
      filteredStream,
      filteredReadyStream,
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
          if (withLag == true) 'l': _averageLag.value.inMilliseconds,
        },
      };
      _acks.add((DateTime.now(), ackId, message));
    } else {
      message = {
        't': topic,
        if (data != null && data is Map<String, Object>)
          'd': {
            ...data,
            if (withLag == true) 'l': _averageLag.value.inMilliseconds,
          }
        else if (data != null)
          'd': data,
      };
    }

    _sink?.add(jsonEncode(message));
  }

  void dispose() {
    closeAndForget();
    _streamController.close();
    _readyStreamController.close();
  }

  /// Disconnects websocket connection but keeps the reference to the current route.
  ///
  /// Returns a [Future] that completes when the connection is closed.
  Future<void> disconnect() {
    final future = _sink?.close().then((_) {
          _log.fine('WebSocket connection was closed by client.');
          _averageLag.value = Duration.zero;
        }).catchError((Object? error) {
          _log.warning('WebSocket connection could not be closed.', error);
        }) ??
        Future.value();
    _channel = null;
    _socketStreamSubscription?.cancel();
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();

    return future;
  }

  /// Closes and forget the WebSocket connection.
  ///
  /// This should be called when the socket is no longer needed.
  ///
  /// If a delay is provided, the connection will be closed after the delay.
  /// If a new connection is created before the delay, the close will be cancelled.
  void closeAndForget({Duration? delay}) {
    _log.fine(
      'Terminating connection ${delay == null ? 'now' : 'in ${delay.inSeconds}s'}.',
    );
    _closeTimer?.cancel();
    _closeTimer = Timer(
      delay ?? Duration.zero,
      () {
        disconnect();
        _averageLag.value = Duration.zero;
        if (_route == null) {
          return;
        }
        _log.info('Connection terminated.');
        _route = null;
      },
    );
  }

  /// Connect or reconnect the WebSocket.
  Future<void> _doConnect(Uri route) async {
    disconnect();
    _pongCount = 0;
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    _ackResendTimer = Timer.periodic(resendAckDelay, (_) => _resendAcks());

    final session = _ref.read(authSessionProvider);
    final pInfo = _ref.read(packageInfoProvider);
    final deviceInfo = _ref.read(deviceInfoProvider);
    final uri = Uri.parse('$kLichessWSHost$route');
    final Map<String, String> headers = session != null
        ? {
            'Authorization': 'Bearer ${signBearerToken(session.token)}',
          }
        : {};
    WebSocket.userAgent = makeUserAgent(pInfo, deviceInfo, sri, session?.user);

    _log.info('Creating WebSocket connection to $uri');
    _route = route;

    try {
      final channel = await _ref.read(webSocketChannelFactoryProvider).create(
            uri.toString(),
            headers: headers,
            timeout: _kDefaultConnectTimeout,
          );

      _channel = channel;

      _socketStreamSubscription?.cancel();
      _socketStreamSubscription = channel.stream.map((raw) {
        if (raw == '0') {
          return SocketEvent.pong;
        }
        return SocketEvent.fromJson(
          jsonDecode(raw as String) as Map<String, dynamic>,
        );
      }).listen(_handleEvent);

      _log.info('WebSocket connection established.');
      _averageLag.value = Duration.zero;
      _sendPing();
      _schedulePing(pingDelay);
      _readyStreamController.add(route);
      _resendAcks();
    } catch (error) {
      _log.severe('WebSocket connection failed.', error);
      _averageLag.value = Duration.zero;
      _scheduleReconnect(autoReconnectDelay);
    }
  }

  /// Called when the first listener is added to the socket stream.
  void _onStreamListen() {
    _log.fine('WebSocket event stream subscribed.');
    _closeTimer?.cancel();
  }

  /// Called when the last listener is removed from the socket stream.
  void _onStreamCancel() {
    _log.fine('WebSocket event stream idle, closing.');
    closeAndForget(delay: idleTimeout);
  }

  void _handleEvent(SocketEvent event) {
    switch (event.topic) {
      case '_pong':
      case 'n':
        _handlePong(pingDelay);
      case 'ack':
        _onServerAck(event);
    }

    if (event != SocketEvent.pong && event.topic != 'ack') {
      _streamController.add(event);
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
              'l': (_averageLag.value.inMilliseconds * 0.1).round(),
            })
          : 'p',
    );
    _lastPing = DateTime.now();
    _scheduleReconnect(pingMaxLag);
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
    _averageLag.value += (currentLag - _averageLag.value) * mix;
  }

  void _scheduleReconnect(Duration delay) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_route != null) {
        _averageLag.value = Duration.zero;
        _log.info('Reconnecting WebSocket.');
        _doConnect(_route!);
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
}

@Riverpod(keepAlive: true)
SocketService socketService(SocketServiceRef ref) {
  final logger = Logger('SocketService');
  final client = SocketService(ref, logger);
  Timer? closeInBackgroundTimer;

  final appLifecycleListener = AppLifecycleListener(
    onHide: () {
      closeInBackgroundTimer?.cancel();
      closeInBackgroundTimer = Timer(
        _kDisconnectOnBackgroundTimeout,
        () {
          logger.info(
            'App is in background for ${_kDisconnectOnBackgroundTimeout.inMinutes}m, terminating socket.',
          );
          client.closeAndForget();
        },
      );
    },
    onShow: () {
      closeInBackgroundTimer?.cancel();
    },
  );

  ref.onDispose(() {
    client.dispose();
    closeInBackgroundTimer?.cancel();
    appLifecycleListener.dispose();
  });
  return client;
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
  Duration build() {
    final listenable = ref.watch(socketPoolProvider).averageLag;

    listenable.addListener(_listener);

    ref.onDispose(() {
      listenable.removeListener(_listener);
    });

    return listenable.value;
  }

  void _listener() {
    final newLag = ref.read(socketPoolProvider).averageLag.value;
    if (state != newLag) {
      state = newLag;
    }
  }
}

@Riverpod(keepAlive: true)
WebSocketChannelFactory webSocketChannelFactory(
  WebSocketChannelFactoryRef ref,
) {
  return const WebSocketChannelFactory();
}

/// A factory to create a [WebSocketChannel].
///
/// This is useful to be able to mock the [WebSocketChannel] in tests.
class WebSocketChannelFactory {
  const WebSocketChannelFactory();

  /// Creates a [WebSocketChannel] from the given [url].
  ///
  /// Throws a [TimeoutException] if the connection takes too long.
  /// Throws a [SocketException] if the connection fails.
  Future<WebSocketChannel> create(
    String url, {
    Map<String, dynamic>? headers,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final socket =
        await WebSocket.connect(url, headers: headers).timeout(timeout);

    return IOWebSocketChannel(socket);
  }
}

/// A socket event.
@freezed
class SocketEvent with _$SocketEvent {
  const SocketEvent._();

  const factory SocketEvent({
    required String topic,
    dynamic data,

    /// Version of the socket event, only for versioned socket routes.
    int? version,
  }) = _SocketEvent;

  /// A special internal pong event that should never be accessible to the subscribers.
  static const pong = SocketEvent(topic: '_pong');

  factory SocketEvent.fromJson(Map<String, dynamic> json) {
    if (json['t'] == null) {
      if (json['v'] != null) {
        return SocketEvent(
          topic: '_version',
          version: json['v'] as int,
        );
      } else {
        assert(false, 'Unsupported socket event json: $json');
        return pong;
      }
    }
    final topic = json['t'] as String;
    if (topic == 'n') {
      return SocketEvent(
        topic: topic,
        data: {
          'nbPlayers': json['d'] as int,
          'nbGames': json['r'] as int,
        },
      );
    }
    return SocketEvent(
      topic: topic,
      data: json['d'],
      version: json['v'] as int?,
    );
  }
}
