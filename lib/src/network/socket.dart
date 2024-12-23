import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'socket.g.dart';

const kDefaultSocketRoute = '/socket/v5';

const _kDefaultConnectTimeout = Duration(seconds: 10);
const _kPingDelay = Duration(milliseconds: 2500);
const _kPingMaxLag = Duration(seconds: 9);
const _kAutoReconnectDelay = Duration(milliseconds: 3500);
const _kResendAckDelay = Duration(milliseconds: 1500);
const _kIdleTimeout = Duration(seconds: 2);
const _kDisconnectOnBackgroundTimeout = Duration(minutes: 5);

final _logger = Logger('Socket');

/// Set of topics that are allowed to be broadcasted to the global stream.
const _globalSocketStreamAllowedTopics = {'n', 'message', 'challenges'};

final _globalStreamController = StreamController<SocketEvent>.broadcast();

/// The global socket broadcast stream.
///
/// Only a subset of topics are allowed to be broadcasted to the global stream:
/// - 'n' (number of players and games currently on the server)
/// - 'message'
/// - 'challenges'
final socketGlobalStream = _globalStreamController.stream;

/// Creates a WebSocket URI for the lichess server.
Uri lichessWSUri(String unencodedPath, [Map<String, String>? queryParameters]) =>
    kLichessWSHost.startsWith('localhost')
        ? Uri(
          scheme: 'ws',
          host: kLichessWSHost.split(':')[0],
          port: int.parse(kLichessWSHost.split(':')[1]),
          path: unencodedPath,
          queryParameters: queryParameters,
        )
        : Uri(
          scheme: 'wss',
          host: kLichessWSHost,
          path: unencodedPath,
          queryParameters: queryParameters,
        );

/// A lichess WebSocket client.
///
/// Handles authentication:
///  - adds the following headers on connect:
///   - Authorization header when a token has been stored,
///   - User-Agent header
///
/// Handles low-level ping/pong protocol, message acks, and automatic reconnections.
class SocketClient {
  SocketClient(
    this.route, {
    required this.channelFactory,
    required this.getSession,
    required this.packageInfo,
    required this.deviceInfo,
    required this.sri,
    this.onStreamListen,
    this.onStreamCancel,
    this.pingDelay = _kPingDelay,
    this.pingMaxLag = _kPingMaxLag,
    this.autoReconnectDelay = _kAutoReconnectDelay,
    this.resendAckDelay = _kResendAckDelay,
  });

  final WebSocketChannelFactory channelFactory;

  final AuthSessionState? Function() getSession;

  final PackageInfo packageInfo;

  final BaseDeviceInfo deviceInfo;

  /// The Socket Random Identifier.
  final String sri;

  /// The route to connect to.
  final Uri route;

  /// The delay between the next ping after receiving a pong.
  final Duration pingDelay;

  /// The maximum lag before considering the connection as lost.
  final Duration pingMaxLag;

  /// The delay before reconnecting after a connection failure.
  final Duration autoReconnectDelay;

  /// The delay before resending an ack.
  final Duration resendAckDelay;

  /// Called when the first listener is added to the socket stream.
  final VoidCallback? onStreamListen;

  /// Called when the last listener is removed from the socket stream.
  final VoidCallback? onStreamCancel;

  late final StreamController<SocketEvent> _streamController =
      StreamController<SocketEvent>.broadcast(onListen: onStreamListen, onCancel: onStreamCancel);

  late final StreamController<void> _socketOpenController = StreamController<void>.broadcast();

  Completer<void> _firstConnection = Completer<void>();

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
  int nbConnectionAttempts = 0;

  /// The current number of successful connections.
  int nbConnectionSuccess = 0;

  /// The current ack id. Incremented for each ack.
  int _ackId = 1;

  /// The current WebSocket channel.
  WebSocketChannel? _channel;

  /// Gets the current WebSocket sink
  WebSocketSink? get _sink => _channel?.sink;

  /// The socket events broadcast stream.
  Stream<SocketEvent> get stream => _streamController.stream;

  /// The stream that emits each time the socket is (re)connected.
  Stream<void> get connectedStream => _socketOpenController.stream;

  /// The average lag computed from ping/pong protocol.
  ///
  /// A duration of zero means the socket is not connected.
  ValueListenable<Duration> get averageLag => _averageLag;

  /// Whether the socket is actively trying to connect or is connected.
  bool get isActive => nbConnectionAttempts > 0;

  /// Whether the socket is connected.
  bool get isConnected => averageLag.value != Duration.zero;

  /// Whether the client is disposed. If true the client cannot be reconnected, or
  /// be listened to.
  bool isDisposed = false;

  /// A [Future] that completes when the first connection is established.
  Future<void> get firstConnection => _firstConnection.future;

  /// Connect or reconnect the WebSocket.
  Future<void> connect() async {
    if (isDisposed) {
      throw StateError('SocketClient is disposed, cannot connect.');
    }

    _disconnect();
    _pongCount = 0;
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    _ackResendTimer = Timer.periodic(resendAckDelay, (_) => _resendAcks());

    final session = getSession();
    final uri = lichessWSUri(route.path);
    final Map<String, String> headers =
        session != null ? {'Authorization': 'Bearer ${signBearerToken(session.token)}'} : {};
    WebSocket.userAgent = makeUserAgent(packageInfo, deviceInfo, sri, session?.user);

    _logger.info('Creating WebSocket connection to $route');

    nbConnectionAttempts++;

    try {
      final channel = await channelFactory.create(
        uri.toString(),
        headers: headers,
        timeout: _kDefaultConnectTimeout,
      );

      _channel = channel;

      _socketStreamSubscription?.cancel();
      _socketStreamSubscription = channel.stream
          .map((raw) {
            if (raw == '0') {
              return SocketEvent.pong;
            }
            return SocketEvent.fromJson(jsonDecode(raw as String) as Map<String, dynamic>);
          })
          .listen(_handleEvent);

      _logger.fine('WebSocket connection to $route established.');

      nbConnectionSuccess++;

      if (nbConnectionSuccess == 1) {
        _firstConnection.complete();
      }

      _averageLag.value = Duration.zero;
      _sendPing();
      _schedulePing(pingDelay);

      if (_socketOpenController.hasListener) {
        _socketOpenController.add(null);
      }
      _resendAcks();
    } catch (error) {
      _logger.severe('WebSocket connection failed: $error', error);
      _averageLag.value = Duration.zero;
      _scheduleReconnect(autoReconnectDelay);
    }
  }

  /// Sends a message to the websocket.
  void send(String topic, Object? data, {bool? ackable, bool? withLag}) {
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
          'd': {...data, if (withLag == true) 'l': _averageLag.value.inMilliseconds}
        else if (data != null)
          'd': data,
      };
    }

    _sink?.add(jsonEncode(message));
  }

  /// Closes the WebSocket connection and disposes the client.
  ///
  /// The [SocketPool] will call this method when the client is no longer needed.
  void _dispose() {
    _socketStreamSubscription?.cancel();
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    _streamController.close();
    _averageLag.dispose();
    isDisposed = true;
    _disconnect();
  }

  /// Closes the WebSocket connection when temporarily not needed (by default
  /// this is when we open another one).
  ///
  /// The connection can be reopend later by calling [connect]. This will reset
  /// the [firstConnection] future and the [nbConnectionAttempts] and [nbConnectionSuccess] counters.
  Future<void> close() {
    nbConnectionAttempts = 0;
    nbConnectionSuccess = 0;
    _firstConnection = Completer<void>();
    return _disconnect();
  }

  /// Disconnects websocket connection.
  ///
  /// Returns a [Future] that completes when the connection is closed.
  Future<void> _disconnect() {
    final future =
        _sink
            ?.close()
            .then((_) {
              _logger.fine('WebSocket connection to $route was properly closed.');
              if (isDisposed) {
                return;
              }
              _averageLag.value = Duration.zero;
            })
            .catchError((Object? error) {
              _logger.warning('WebSocket connection to $route could not be closed: $error', error);
              if (isDisposed) {
                return;
              }
              _averageLag.value = Duration.zero;
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
      if (_globalStreamController.hasListener &&
          _globalSocketStreamAllowedTopics.contains(event.topic)) {
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
          ? jsonEncode({'t': 'p', 'l': (_averageLag.value.inMilliseconds * 0.1).round()})
          : 'p',
    );
    _lastPing = DateTime.now();
    _scheduleReconnect(pingMaxLag);
  }

  void _handlePong(Duration pingDelay) {
    _reconnectTimer?.cancel();
    if (_pongCount == 0) {
      _logger.fine('Ping/pong protocol for $route established.');
    }
    _schedulePing(pingDelay);
    _pongCount++;
    final currentLag = Duration(
      milliseconds: math.min(DateTime.now().difference(_lastPing).inMilliseconds, 10000),
    );

    // Average first 4 pings, then switch to decaying average.
    final mix = _pongCount > 4 ? 0.1 : 1 / _pongCount;
    _averageLag.value += (currentLag - _averageLag.value) * mix;
  }

  void _scheduleReconnect(Duration delay) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (!isDisposed) {
        _logger.fine('Reconnecting WebSocket.');
        _averageLag.value = Duration.zero;
        connect();
      } else {
        _logger.warning('Scheduled reconnect after $delay failed since client is disposed.');
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
    final resendCutoff = DateTime.now().subtract(const Duration(milliseconds: 2500));
    for (final (at, _, ack) in _acks) {
      if (at.isBefore(resendCutoff)) {
        _sink?.add(jsonEncode(ack));
      }
    }
  }
}

/// Service that manages a pool of socket clients.
///
/// The pool is used to manage multiple socket connections to different routes.
/// It ensures that only one connection is active at a time, and that a client
/// created for a route other than the lichess default socket route is disposed
/// when it becomes idle.
///
/// A client for the default route is created upon initialization and is never
/// disposed.
/// The pool is responsible for creating and disposing other clients and that
/// there is always an active client.
/// When a requested client is disposed, the pool will automatically reconnect
/// the default client.
class SocketPool {
  SocketPool(this._ref, {this.idleTimeout = _kIdleTimeout}) {
    // Create a default socket client. This one is never disposed.
    final client = SocketClient(
      _currentRoute,
      sri: _ref.read(preloadedDataProvider).requireValue.sri,
      channelFactory: _ref.read(webSocketChannelFactoryProvider),
      getSession: () => _ref.read(authSessionProvider),
      packageInfo: _ref.read(preloadedDataProvider).requireValue.packageInfo,
      deviceInfo: _ref.read(preloadedDataProvider).requireValue.deviceInfo,
      pingDelay: const Duration(seconds: 25),
    );

    client.averageLag.addListener(() {
      if (_currentRoute == client.route) {
        _averageLag.value = client.averageLag.value;
      }
    });

    _pool[_currentRoute] = client;
  }

  final Ref _ref;

  /// The delay before closing the socket if idle (no subscription).
  final Duration idleTimeout;

  final _averageLag = ValueNotifier(Duration.zero);

  /// The average lag computed from ping/pong protocol of the current active route.
  ///
  /// A duration of zero means the socket is not connected.
  ValueListenable<Duration> get averageLag => _averageLag;

  /// The current socket route.
  Uri _currentRoute = Uri(path: kDefaultSocketRoute);

  /// The current socket client.
  SocketClient get currentClient => _pool[_currentRoute]!;

  /// The socket clients pool.
  final Map<Uri, SocketClient> _pool = {};
  final Map<Uri, Timer?> _disposeTimers = {};

  /// Opens a socket connection to the given [route].
  ///
  /// It will use an existing connection if it is already active, unless
  /// [forceReconnect] is set to true.
  /// Any other active connection will be closed.
  SocketClient open(Uri route, {bool? forceReconnect}) {
    _currentRoute = route;

    if (_pool[route] == null) {
      _pool[route] = SocketClient(
        route,
        channelFactory: _ref.read(webSocketChannelFactoryProvider),
        getSession: () => _ref.read(authSessionProvider),
        packageInfo: _ref.read(preloadedDataProvider).requireValue.packageInfo,
        deviceInfo: _ref.read(preloadedDataProvider).requireValue.deviceInfo,
        sri: _ref.read(preloadedDataProvider).requireValue.sri,
        onStreamListen: () {
          _disposeTimers[route]?.cancel();
        },
        onStreamCancel: () {
          // Schedule the socket to be closed if idle, after a short delay to
          // avoid unnecessary reconnections.
          _disposeTimers[route]?.cancel();
          _disposeTimers[route] = Timer(idleTimeout, () {
            _logger.fine('Disposing idle socket on $route.');
            _pool[route]?._dispose();
            _pool.remove(route);
            // if during the idle time no new socket is requested, we reconnect
            // the default socket
            if (route == _currentRoute) {
              _currentRoute = Uri(path: kDefaultSocketRoute);
              if (!currentClient.isActive) {
                currentClient.connect();
              }
            }
          });
        },
      );
    }

    final client = _pool[route]!;

    client.averageLag.addListener(() {
      if (_currentRoute == client.route) {
        _averageLag.value = client.averageLag.value;
      }
    });

    // ensure there is only one active connection
    _pool.forEach((k, c) {
      if (k != route) {
        c.close();
      }
    });

    if (forceReconnect == true || !client.isActive) {
      client.connect();
    }

    return client;
  }

  /// Disposes the pool and all its clients and resources.
  void dispose() {
    _averageLag.dispose();
    _disposeTimers.forEach((_, t) => t?.cancel());
    _pool.forEach((_, c) => c._dispose());
  }
}

@Riverpod(keepAlive: true)
SocketPool socketPool(Ref ref) {
  final pool = SocketPool(ref);
  Timer? closeInBackgroundTimer;

  final appLifecycleListener = AppLifecycleListener(
    onHide: () {
      closeInBackgroundTimer?.cancel();
      closeInBackgroundTimer = Timer(_kDisconnectOnBackgroundTimeout, () {
        _logger.info(
          'App is in background for ${_kDisconnectOnBackgroundTimeout.inMinutes}m, closing socket.',
        );
        pool.currentClient.close();
      });
    },
    onShow: () {
      closeInBackgroundTimer?.cancel();
      if (!pool.currentClient.isActive) {
        pool.currentClient.connect();
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
WebSocketChannelFactory webSocketChannelFactory(Ref ref) {
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
    final socket = await WebSocket.connect(url, headers: headers).timeout(timeout);

    return IOWebSocketChannel(socket);
  }
}
