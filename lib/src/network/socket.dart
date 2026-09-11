import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:clock/clock.dart' as clock_package;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const kDefaultSocketRoute = '/socket/v5';

const _kDefaultConnectTimeout = Duration(seconds: 10);
const _kPingDelay = Duration(milliseconds: 2500);
const _kPingMaxLag = Duration(seconds: 9);
const _kAutoReconnectDelay = Duration(milliseconds: 3500);

/// The ceiling of the exponential backoff between failed connection attempts.
const _kMaxAutoReconnectDelay = Duration(seconds: 60);

/// How long the socket keeps retrying at full speed before the backoff sets in.
const _kReconnectGracePeriod = Duration(seconds: 60);

const _kResendAckDelay = Duration(milliseconds: 1500);
const _kVersionGapRetryDelay = Duration(milliseconds: 200);
const _kIdleTimeout = Duration(seconds: 2);

/// The duration to wait in background before disconnecting the socket.
///
/// On iOS the connection will be closed by the OS after 30s anyway. On Android, it varies.
/// This timeout is a fail-safe to avoid keeping the connection open for too long and draining
/// the battery.
const _kDisconnectOnBackgroundTimeout = Duration(minutes: 1);

final _logger = Logger('Socket');

/// Set of topics that are allowed to be broadcasted to the global stream.
const _globalSocketStreamAllowedTopics = {'n', 'message', 'challenges', 'announce'};

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
    kLichessWSHost.startsWith('localhost') ||
        kLichessWSHost.startsWith('10.') ||
        kLichessWSHost.startsWith('192.168.')
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
/// Handles low-level ping/pong protocol, message acks, and automatic reconnections, event versioning.
class SocketClient {
  SocketClient(
    this.route, {
    this.version,
    required this.channelFactory,
    required this.getSession,
    required this.packageInfo,
    required this.deviceInfo,
    required this.sri,
    this.onStreamListen,
    this.onStreamCancel,
    this.onEventGapFailure,
    this.pingDelay = _kPingDelay,
    this.pingMaxLag = _kPingMaxLag,
    this.autoReconnectDelay = _kAutoReconnectDelay,
    this.reconnectGracePeriod = _kReconnectGracePeriod,
    this.resendAckDelay = _kResendAckDelay,
  }) : assert(route.path.isNotEmpty, 'Route path must not be empty'),
       assert(pingDelay > Duration.zero, 'Ping delay must be greater than 0'),
       assert(pingMaxLag > Duration.zero, 'Ping max lag must be greater than 0'),
       assert(autoReconnectDelay > Duration.zero, 'Auto reconnect delay must be greater than 0'),
       assert(
         reconnectGracePeriod > Duration.zero,
         'Reconnect grace period must be greater than 0',
       ),
       assert(resendAckDelay > Duration.zero, 'Resend ack delay must be greater than 0');

  final WebSocketChannelFactory channelFactory;

  final AuthUser? Function() getSession;

  final PackageInfo packageInfo;

  final BaseDeviceInfo deviceInfo;

  /// The Socket Random Identifier.
  final String sri;

  /// The route to connect to.
  final Uri route;

  /// The current event version if this socket is versioned.
  int? version;

  /// The delay between the next ping after receiving a pong.
  final Duration pingDelay;

  /// The maximum lag before considering the connection as lost.
  final Duration pingMaxLag;

  /// The delay before reconnecting after a connection failure.
  final Duration autoReconnectDelay;

  /// How long connection failures keep being retried at [autoReconnectDelay], before the delay
  /// starts doubling.
  final Duration reconnectGracePeriod;

  /// The delay before resending an ack.
  final Duration resendAckDelay;

  /// Called when the first listener is added to the socket stream.
  final VoidCallback? onStreamListen;

  /// Called when the last listener is removed from the socket stream.
  final VoidCallback? onStreamCancel;

  /// Called when a versioned socket event gap failed to resolve after 10 retries.
  final VoidCallback? onEventGapFailure;

  late final StreamController<SocketEvent> _streamController =
      StreamController<SocketEvent>.broadcast(onListen: onStreamListen, onCancel: onStreamCancel);

  late final StreamController<void> _socketOpenController = StreamController<void>.broadcast();

  Completer<void> _firstConnection = Completer<void>();

  Timer? _pingTimer;
  Timer? _pongTimeoutTimer;
  Timer? _reconnectTimer;
  Timer? _ackResendTimer;
  Timer? _versionGapRetryTimer;
  int _pongCount = 0;
  DateTime _lastPing = clock_package.clock.now();

  final _averageLag = ValueNotifier(Duration.zero);

  /// When the current run of failures started, null while the socket is healthy.
  ///
  /// A run starts at the first attempt that goes wrong — a connection that could not be made, or a
  /// ping that went unanswered — and ends only once a pong proves the socket usable again. The
  /// handshake alone does not end it: a channel that opens and then answers nothing would reset
  /// the backoff on every attempt, and never look failing to anyone watching.
  ///
  /// Only the backoff needs the instant it started; [_isFailing] is what the outside sees.
  DateTime? _failingSince;

  final _isFailing = ValueNotifier(false);

  StreamSubscription<SocketEvent>? _socketStreamSubscription;

  /// The list of acknowledgeable messages.
  final List<(DateTime, int, Map<String, dynamic>)> _acks = [];

  /// Messages that were sent while the socket was not connected.
  ///
  /// Each entry is the ack id (null for non-ackable messages) and the encoded
  /// message. They are flushed when the connection (re)opens, which prevents
  /// losing messages. Ackable messages are queued here too (as the web client
  /// does) so they are resent immediately on reconnect rather than waiting for
  /// [_resendAcks]; they also stay in [_acks] as the retry-until-acked fallback.
  final List<(int?, String)> _resendWhenOpen = [];

  /// The current number of connections attempted.
  int nbConnectionAttempts = 0;

  /// The current number of successful connections.
  int nbConnectionSuccess = 0;

  /// The current ack id. Incremented for each ack.
  int _ackId = 1;

  /// The current WebSocket channel.
  WebSocketChannel? _channel;

  /// Identifies the current connection attempt.
  ///
  /// Incremented by [_disconnect] (and thus by [connect], [close] and [dispose]), so that a
  /// connection attempt still awaiting the channel creation can tell it has been superseded: opening
  /// a channel is not cancellable and can take up to [_kDefaultConnectTimeout], during which the
  /// client may have been closed or reconnected.
  int _connectionEpoch = 0;

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

  /// Whether the socket is failing, and waiting out its backoff before trying again.
  ///
  /// Turns true when a run of failures starts, and false again when the socket answers a ping or
  /// is closed, so that a listener hears about a socket that cannot connect, not about each of its
  /// attempts.
  ValueListenable<bool> get isFailing => _isFailing;

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

    unawaited(_disconnect());

    final epoch = _connectionEpoch;
    _pongCount = 0;
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    _ackResendTimer = Timer.periodic(resendAckDelay, (_) => _resendAcks());

    final authUser = getSession();

    final queryParameters = Map<String, String>.from(route.queryParameters);
    if (version != null) {
      queryParameters['v'] = version.toString();
    }
    final uri = lichessWSUri(route.path, queryParameters.isNotEmpty ? queryParameters : null);

    final Map<String, String> headers = authUser != null
        ? {'Authorization': 'Bearer ${signBearerToken(authUser.token)}'}
        : {};
    WebSocket.userAgent = makeUserAgent(packageInfo, deviceInfo, sri, authUser?.user);

    _logger.info('Creating WebSocket connection to $route');

    nbConnectionAttempts++;

    try {
      final channel = await channelFactory.create(
        uri.toString(),
        headers: headers,
        timeout: _kDefaultConnectTimeout,
      );

      // The client was disposed, closed or reconnected while we were waiting for the channel:
      // discard it, so it doesn't stay open and doesn't schedule a reconnect below.
      if (isDisposed || epoch != _connectionEpoch) {
        _logger.fine('Discarding stale WebSocket connection to $route.');
        if (!identical(channel, _channel)) {
          unawaited(channel.sink.close());
        }
        return;
      }

      _channel = channel;

      _socketStreamSubscription?.cancel();
      _socketStreamSubscription = channel.stream
          .map((raw) {
            if (raw == '0') {
              return SocketEvent.pong;
            }
            final event = SocketEvent.fromJson(jsonDecode(raw as String) as Map<String, dynamic>);
            return event;
          })
          .listen(
            _handleEvent,
            onError: (Object error, StackTrace stackTrace) =>
                _onChannelGone(epoch, error, stackTrace),
            onDone: () => _onChannelGone(epoch),
          );

      _logger.fine('WebSocket connection to $route established.');

      nbConnectionSuccess++;

      if (nbConnectionSuccess == 1) {
        _firstConnection.complete();
      }

      _averageLag.value = Duration.zero;
      // The next ping is scheduled by the pong that answers this one: a second ping sent before
      // then would push the pong timeout further out, and let a socket that answers nothing live
      // [pingDelay] longer than it should.
      _sendPing();

      if (_socketOpenController.hasListener) {
        _socketOpenController.add(null);
      }

      // Flush messages that were queued while the socket was not connected.
      // This runs *before* [_resendAcks] and bumps each flushed ackable
      // message's timestamp so that [_resendAcks] does not immediately send it a
      // second time (the periodic resend-until-acked behavior is preserved).
      //
      // Each message leaves the queue only once the sink has taken it, so that a write throwing
      // partway through — a peer that hangs up mid-flush — leaves the rest of them queued for the
      // connection that replaces this one, instead of dropping the lot.
      final now = clock_package.clock.now();
      while (_resendWhenOpen.isNotEmpty) {
        final (ackId, message) = _resendWhenOpen.first;
        channel.sink.add(message);
        _resendWhenOpen.removeAt(0);
        if (ackId != null) {
          final index = _acks.indexWhere((rec) => rec.$2 == ackId);
          if (index != -1) {
            _acks[index] = (now, _acks[index].$2, _acks[index].$3);
          }
        }
      }

      _resendAcks();
    } catch (e, s) {
      // Don't revive a client that was closed or reconnected while the failed attempt was in
      // flight, otherwise it would keep reconnecting in the background forever.
      if (isDisposed || epoch != _connectionEpoch) {
        _logger.fine('Stale WebSocket connection to $route failed:', e, s);
        return;
      }
      // The attempt may have got as far as a channel before it went wrong — a peer that hangs up
      // between the handshake and the first ping, say. Drop it here as the pong timeout and the
      // stream error do, so that [send] queues for the next connection rather than writing to a
      // sink that is already gone. This cancels the timers of the failed attempt along with it.
      unawaited(_disconnect());
      _startFailing();

      final delay = _reconnectDelay;
      final message =
          'WebSocket connection to $route failed (for ${_failingFor.inSeconds}s now), retrying in '
          '${delay.inMilliseconds}ms: $e';

      if (_isTransportUnavailable(e)) {
        // A connection that could not even be attempted says nothing on its own: it is what a
        // device with no network looks like, and that is not worth a line in the logs.
        _logger.fine(message);
      } else if (e is Exception) {
        // The server answered, but not with a websocket it accepted: a refused or malformed
        // upgrade, a certificate that cannot be trusted. Retrying may well get past it, but this
        // is the only sign a regression on the server or in the TLS chain gives from production.
        _logger.warning(message, e, s);
      } else {
        // An [Error] comes from the setup above rather than from the network, and retrying will
        // not fix it.
        _logger.severe(message, e, s);
      }

      _scheduleReconnect(delay);
    }
  }

  /// Sends a message to the websocket.
  ///
  /// [noRetry] drops the message when there is no connection to write it to, instead of queueing
  /// it for the next one. It says nothing about [ackable] messages, which are retried until acked
  /// whatever happens.
  void send(String topic, Object? data, {bool? ackable, bool? withLag, bool noRetry = false}) {
    Map<String, Object> message;
    int? ackId;

    if (ackable == true) {
      ackId = _ackId++;
      message = {
        't': topic,
        'd': {
          if (data != null && data is Map<String, Object>) ...data,
          'a': ackId,
          if (withLag == true) 'l': _averageLag.value.inMilliseconds,
        },
      };
      _acks.add((clock_package.clock.now(), ackId, message));
    } else {
      message = {
        't': topic,
        if (data != null && data is Map<String, Object>)
          'd': {...data, if (withLag == true) 'l': _averageLag.value.inMilliseconds}
        else
          'd': ?data,
      };
    }

    final encoded = jsonEncode(message);
    final sink = _sink;
    if (sink != null) {
      sink.add(encoded);
    } else if (!noRetry) {
      // Not connected: queue the message so it is sent once the connection
      // (re)opens, instead of being silently dropped.
      _resendWhenOpen.add((ackId, encoded));
    }
  }

  /// Closes the WebSocket connection and disposes the client.
  ///
  /// After calling this method, the client cannot be reused or reconnected. This can only be called
  /// once.
  ///
  /// The [SocketPool] will call this method when the client is no longer needed.
  void dispose() {
    _socketStreamSubscription?.cancel();
    _pingTimer?.cancel();
    _pongTimeoutTimer?.cancel();
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    _versionGapRetryTimer?.cancel();
    _streamController.close();
    _averageLag.dispose();
    _isFailing.dispose();
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
    _stopFailing();
    _firstConnection = Completer<void>();
    return _disconnect();
  }

  /// Disconnects websocket connection.
  ///
  /// Returns a [Future] that completes when the connection is closed.
  Future<void> _disconnect() {
    _connectionEpoch++;
    _socketStreamSubscription?.cancel();
    _pingTimer?.cancel();
    _pongTimeoutTimer?.cancel();
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();

    // Now, rather than when the close completes: closing a sink can take as long as it likes, and
    // by the time it does the client may well be connected again — a lag blanked then would be the
    // old channel marking the new connection as down, until the next pong put it right.
    if (!isDisposed) {
      _averageLag.value = Duration.zero;
    }

    final sink = _sink;
    _channel = null;
    if (sink == null) return Future.value();

    return sink
        .close()
        .then((_) {
          _logger.fine('WebSocket connection to $route was properly closed.');
        })
        .catchError((Object? error) {
          _logger.warning('WebSocket connection to $route could not be closed:', error);
        });
  }

  void _handleEvent(SocketEvent event, [int retries = 10]) {
    if (event.version != null && version != null) {
      if (event.version! <= version!) {
        _logger.fine('Already has event ${event.version}');
        return;
      }
      if (event.version! > version! + 1) {
        if (retries > 0) {
          _logger.warning(
            'Version gap, retrying... event: ${event.version}, socket: $version, retries: $retries',
          );
          _versionGapRetryTimer?.cancel();
          _versionGapRetryTimer = Timer(
            _kVersionGapRetryDelay,
            () => _handleEvent(event, retries - 1),
          );
        } else {
          onEventGapFailure?.call();
          _logger.severe(
            'Cannot solve event gap: version incoming ${event.version} vs current $version',
          );
          LichessBinding.instance.firebaseCrashlytics.recordError(
            'Cannot solve event gap: version incoming ${event.version} vs current $version',
            null,
            information: ['socket.route: $route', 'event.topic: ${event.topic}'],
          );
        }
        return;
      }
      version = event.version;
    }

    switch (event.topic) {
      case '_pong':
        _handlePong(pingDelay);
      case 'n':
        _handlePong(pingDelay);
        continue addToStream;
      case 'ack':
        _onServerAck(event);
      case 'batch':
        _handleBatch(event);
      addToStream:
      case _:
        if (_streamController.hasListener) {
          _streamController.add(event);
        }
        if (_globalStreamController.hasListener &&
            _globalSocketStreamAllowedTopics.contains(event.topic)) {
          _globalStreamController.add(event);
        }
    }
  }

  /// Called when the channel is gone: the peer closed it, or the stream errored out.
  ///
  /// A device losing its network under an open socket ends here rather than at a ping going
  /// unanswered, and that is worth acting on right away: waiting out [pingMaxLag] for a socket
  /// already known to be dead only delays the reconnect, and everything watching the lag.
  ///
  /// [epoch] is the connection this subscription belonged to, so that a channel closing after the
  /// client has moved on to another one is ignored.
  void _onChannelGone(int epoch, [Object? error, StackTrace? stackTrace]) {
    if (isDisposed || epoch != _connectionEpoch) return;

    // The peer is gone, but the channel is still there to be closed, and its timers to be
    // cancelled — as for a pong timeout, [send] must queue rather than write to a dead sink.
    unawaited(_disconnect());

    _averageLag.value = Duration.zero;
    _startFailing();

    final delay = _reconnectDelay;
    final message =
        'WebSocket connection to $route was closed (failing for ${_failingFor.inSeconds}s now), '
        'reconnecting in ${delay.inMilliseconds}ms.';

    if (error == null || _isTransportUnavailable(error)) {
      // A peer that hangs up, or a network that goes away under the socket: both are ordinary, and
      // the reconnect below is the whole answer to them.
      _logger.fine(message, error, stackTrace);
    } else {
      _logger.warning(message, error, stackTrace);
    }

    _scheduleReconnect(delay);
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
    _lastPing = clock_package.clock.now();
    _schedulePongTimeout();
  }

  /// Gives the server [pingMaxLag] to answer the ping that was just sent.
  void _schedulePongTimeout() {
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = Timer(pingMaxLag, _onPongTimeout);
  }

  /// Called when a ping has gone unanswered for [pingMaxLag]: the socket is of no use any more.
  void _onPongTimeout() {
    if (isDisposed) return;

    // Drop the channel now rather than at the end of the backoff, which can be a minute long: a
    // sink nothing answers on is not somewhere to write, and [send] queues for the next connection
    // as soon as there is none. This cancels the ping and ack timers along with it.
    unawaited(_disconnect());

    // The socket is not answering: it is no longer proof of anything to whoever watches the lag.
    _averageLag.value = Duration.zero;

    final delay = _startFailing() ? Duration.zero : _reconnectDelay;
    _logger.fine(
      'No pong from $route in ${pingMaxLag.inMilliseconds}ms (failing for '
      '${_failingFor.inSeconds}s now), reconnecting in ${delay.inMilliseconds}ms.',
    );
    _scheduleReconnect(delay);
  }

  void _handlePong(Duration pingDelay) {
    if (isDisposed) return;

    _pongTimeoutTimer?.cancel();
    // The socket is not merely open, it answers: this, and not the handshake before it, is what
    // ends a run of failures — and it makes any reconnect waiting out the backoff moot.
    _reconnectTimer?.cancel();
    _stopFailing();
    if (_pongCount == 0) {
      _logger.fine('Ping/pong protocol for $route established.');
    }
    _schedulePing(pingDelay);
    _pongCount++;
    final currentLag = Duration(
      milliseconds: math.min(clock_package.clock.now().difference(_lastPing).inMilliseconds, 10000),
    );

    // Average first 4 pings, then switch to decaying average.
    final mix = _pongCount > 4 ? 0.1 : 1 / _pongCount;
    _averageLag.value += (currentLag - _averageLag.value) * mix;
  }

  /// Starts a run of failures, if one is not already going on.
  ///
  /// Returns whether this is the failure that started it.
  bool _startFailing() {
    final startsRun = _failingSince == null;
    _failingSince ??= clock_package.clock.now();
    _isFailing.value = true;
    return startsRun;
  }

  /// Ends the current run of failures.
  void _stopFailing() {
    _failingSince = null;
    _isFailing.value = false;
  }

  /// How long this run of failures has been going on.
  Duration get _failingFor {
    final since = _failingSince;
    return since == null ? Duration.zero : clock_package.clock.now().difference(since);
  }

  /// How long to wait before the next attempt.
  ///
  /// Stays at [autoReconnectDelay] for the first [reconnectGracePeriod], so that a transient
  /// failure is retried at full speed, then doubles for every further grace period spent failing,
  /// up to [_kMaxAutoReconnectDelay]. A device left with no network thus settles into a slow poll
  /// instead of a tight loop, without ever making a blip cost more than a few seconds.
  Duration get _reconnectDelay {
    final failingFor = _failingFor;
    if (failingFor <= reconnectGracePeriod) return autoReconnectDelay;

    final doublings = failingFor.inMicroseconds ~/ reconnectGracePeriod.inMicroseconds;
    final delay = autoReconnectDelay * (1 << math.min(doublings, 8));
    return delay < _kMaxAutoReconnectDelay ? delay : _kMaxAutoReconnectDelay;
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
    final resendCutoff = clock_package.clock.now().subtract(const Duration(milliseconds: 2500));
    for (final (at, _, ack) in _acks) {
      if (at.isBefore(resendCutoff)) {
        _sink?.add(jsonEncode(ack));
      }
    }
  }

  void _handleBatch(SocketEvent batchEvent) {
    final jsonEventList = batchEvent.data as List<dynamic>;

    for (final jsonEvent in jsonEventList) {
      final event = SocketEvent.fromJson(jsonEvent as Map<String, dynamic>);

      _streamController.add(event);
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
      getSession: () => _ref.read(authControllerProvider),
      packageInfo: _ref.read(preloadedDataProvider).requireValue.packageInfo,
      deviceInfo: _ref.read(preloadedDataProvider).requireValue.deviceInfo,
      pingDelay: const Duration(seconds: 25),
    );

    _mirrorCurrentClientState(client);
    _pool[_currentRoute] = client;

    // [isDeviceOnlineIn] rather than the raw value: a check that failed reads as offline there,
    // and coming back from one is an edge the socket has to hear about like any other.
    _ref.listen(connectivityChangesProvider, (prev, next) {
      if (prev == null) return;
      final wasOnline = isDeviceOnlineIn(prev);
      final isOnline = isDeviceOnlineIn(next);
      if (wasOnline && !isOnline) {
        _socketAnsweredSinceOffline = false;
      } else if (!wasOnline && isOnline) {
        onDeviceBackOnline();
      }
    });
  }

  final Ref _ref;

  /// The delay before closing the socket if idle (no subscription).
  final Duration idleTimeout;

  final _averageLag = ValueNotifier(Duration.zero);

  /// Whether a socket has answered a ping since the device was last found offline.
  ///
  /// One that did has already made the connection the online edge would ask for: its own retry got
  /// to the network before the check noticed it was back. One that did not says nothing: it may
  /// well be holding a connection to a network that is gone.
  ///
  /// It says nothing about *which* socket answered, so it is only ever read together with the
  /// current client's own state — the pool may have switched route since.
  bool _socketAnsweredSinceOffline = false;

  Timer? _closeInBackgroundTimer;

  bool _isAppInBackground = false;

  /// The average lag computed from ping/pong protocol of the current active route.
  ///
  /// A duration of zero means the socket is not connected.
  ValueListenable<Duration> get averageLag => _averageLag;

  /// Whether the pool is disposed.
  ///
  /// If true, the clients cannot be reconnected. And the clients `onStreamListen` and `onStreamCancel` callbacks are no-ops.
  bool _isDisposed = false;

  /// The current socket route.
  Uri _currentRoute = Uri(path: kDefaultSocketRoute);

  /// The current socket client.
  SocketClient get currentClient => _pool[_currentRoute]!;

  /// The socket clients pool.
  final Map<Uri, SocketClient> _pool = {};
  final Map<Uri, Timer?> _disposeTimers = {};

  /// Call when the app goes to the background.
  ///
  /// The socket is kept for a while, as the user may well come right back, then closed to spare
  /// the battery.
  @visibleForTesting
  void onAppHidden() {
    _isAppInBackground = true;
    _closeInBackgroundTimer?.cancel();
    _closeInBackgroundTimer = Timer(_kDisconnectOnBackgroundTimeout, () {
      _logger.info(
        'App is in background for ${_kDisconnectOnBackgroundTimeout.inMinutes}m, closing socket.',
      );
      currentClient.close();
    });
  }

  /// Call when the app comes back to the foreground.
  @visibleForTesting
  void onAppShown() {
    _isAppInBackground = false;
    _closeInBackgroundTimer?.cancel();
    _connectIfNeeded();
  }

  /// Call when the device comes back online, after having been offline.
  ///
  /// A socket that went down with the network keeps retrying on an exponential backoff, so it may
  /// be up to a minute before it notices on its own that the network is back. Connectivity knows
  /// first, so it is worth an attempt right away.
  @visibleForTesting
  void onDeviceBackOnline() {
    if (_isAppInBackground) return;

    // The current socket answered a ping while the device was held offline, so it is already on
    // the network this edge is announcing: reconnecting it here would cost an event gap and a
    // handshake to end up exactly where it is.
    //
    // The flag alone would not do: it is not reset when the pool switches route, so it may well be
    // the socket of the route before this one that answered, while the current one is failing and
    // has everything to gain from an attempt now.
    if (_socketAnsweredSinceOffline && currentClient.isConnected) {
      return;
    }

    // Unconditionally, unlike [_connectIfNeeded]: a socket that lost its network without noticing
    // yet — no ping due, nothing that tore the channel down — still looks perfectly healthy, and
    // the connection it holds belongs to a network that is gone. Waiting for it to find out on its
    // own costs up to [SocketClient.pingMaxLag], and the handshake it costs to be sure is cheap
    // next to a socket that is up but deaf.
    currentClient.connect();
  }

  /// Call when the session changes: the socket carries the token, so it has to be reopened.
  ///
  /// A socket closed in the background stays closed; it will carry the new session whenever it is
  /// opened again.
  @visibleForTesting
  void onAuthChanged() {
    if (currentClient.isActive) {
      currentClient.connect();
    }
  }

  /// Reflects [client]'s connection state in the pool's own, for as long as it is the current one.
  void _mirrorCurrentClientState(SocketClient client) {
    client.averageLag.addListener(() {
      if (_currentRoute == client.route) {
        _averageLag.value = client.averageLag.value;
        // Read from the client, not from the pool's lag: the assignment above can be a no-op — the
        // same lag as the client before it — and still be a socket answering.
        if (client.isConnected) {
          _socketAnsweredSinceOffline = true;
        }
      }
    });
  }

  /// Connects the current client, unless it is already connected or on its way to being.
  ///
  /// A client waiting out its reconnect backoff does need connecting: the wait is there to spare a
  /// device that cannot connect at all, and is only ever cut short by something — the app coming
  /// back to the foreground, the network coming back — saying that this time it might work.
  void _connectIfNeeded() {
    if (!currentClient.isActive || currentClient.isFailing.value) {
      currentClient.connect();
    }
  }

  /// Opens a socket connection to the given [route].
  ///
  /// It will use an existing connection if it is already active, unless [forceReconnect] is set to
  /// true.
  /// Any other active connection will be closed.
  ///
  /// This is the one way to a connection that the app being in the background does not stop:
  /// a caller asking for a socket by route is asking for it now, and every one of them is a screen
  /// or a controller the user is looking at.
  SocketClient open(
    Uri route, {
    int? version,
    bool? forceReconnect,
    VoidCallback? onEventGapFailure,
  }) {
    if (_isDisposed) {
      throw StateError('SocketPool is disposed, cannot open new socket.');
    }

    _currentRoute = route;

    if (_pool[route] == null) {
      final newClient = SocketClient(
        route,
        version: version,
        channelFactory: _ref.read(webSocketChannelFactoryProvider),
        getSession: () => _ref.read(authControllerProvider),
        packageInfo: _ref.read(preloadedDataProvider).requireValue.packageInfo,
        deviceInfo: _ref.read(preloadedDataProvider).requireValue.deviceInfo,
        sri: _ref.read(preloadedDataProvider).requireValue.sri,
        onStreamListen: () {
          if (_isDisposed) return;
          _disposeTimers[route]?.cancel();
        },
        onStreamCancel: () {
          if (_isDisposed) return;
          // Schedule the socket to be closed if idle, after a short delay to
          // avoid unnecessary reconnections.
          _disposeTimers[route]?.cancel();
          _disposeTimers[route] = Timer(idleTimeout, () {
            _logger.fine('Disposing idle socket on $route.');
            _pool[route]?.dispose();
            _pool.remove(route);
            // if during the idle time no new socket is requested, we reconnect
            // the default socket
            // Not while the app is in the background: the socket is closed there to spare the
            // battery, and nothing is watching what the default one would bring in anyway.
            if (route == _currentRoute) {
              _currentRoute = Uri(path: kDefaultSocketRoute);
              if (!_isAppInBackground && !currentClient.isActive) {
                currentClient.connect();
              }
            }
          });
        },
        onEventGapFailure: onEventGapFailure,
      );
      _mirrorCurrentClientState(newClient);
      _pool[route] = newClient;
    }

    // ensure there is only one active connection
    _pool.forEach((k, c) {
      if (k != route) {
        c.close();
      }
    });

    final client = _pool[route]!;

    if (forceReconnect == true || !client.isActive) {
      client.connect();
    }

    return client;
  }

  /// Disposes the pool and all its clients and resources.
  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    _averageLag.dispose();
    _closeInBackgroundTimer?.cancel();
    _disposeTimers.forEach((_, t) => t?.cancel());
    _pool.forEach((_, c) => c.dispose());
  }
}

/// The global socket pool provider.
final socketPoolProvider = Provider<SocketPool>((Ref ref) {
  final pool = SocketPool(ref);

  pool.currentClient.connect();

  // force reconnect to the current socket with the new token
  final subscription = authEventsStream.listen((_) => pool.onAuthChanged());

  // Observing the app lifecycle here rather than in [SocketPool], because an
  // [AppLifecycleListener] needs a [WidgetsBinding], which the pool must not require of the tests
  // that build one.
  final appLifecycleListener = AppLifecycleListener(
    onHide: pool.onAppHidden,
    onShow: pool.onAppShown,
  );

  ref.onDispose(() {
    subscription.cancel();
    appLifecycleListener.dispose();
    pool.dispose();
  });

  return pool;
}, name: 'SocketPoolProvider');

typedef SocketPingState = ({Duration averageLag, int rating, bool isActive});

/// A provider that exposes the average lag and ping rating for a given socket route.
final socketPingProvider = NotifierProvider.autoDispose
    .family<SocketPingNotifier, SocketPingState, Uri?>(
      SocketPingNotifier.new,
      name: 'SocketPingProvider',
    );

/// Average lag and ping rating computed from WebSocket ping/pong protocol.
///
/// If [route] is provided, it will return the average lag for that route only, and if any other route
/// is active, it will return [Duration.zero], meaning the socket is not connected.
/// If no route is provided, it will return the average lag for the current active route.
class SocketPingNotifier extends Notifier<SocketPingState> {
  SocketPingNotifier(this.route);
  final Uri? route;

  @override
  SocketPingState build({Uri? route}) {
    final pool = ref.watch(socketPoolProvider);

    // A socket only notices a network that went away when a ping goes unanswered, up to
    // [SocketClient.pingMaxLag] later. Connectivity knows first, so the indicator does not have to
    // go on showing a lag measured over a network that is no longer there.
    ref.watch(isDeviceOnlineProvider);

    pool.averageLag.addListener(_listener);

    ref.onDispose(() {
      pool.averageLag.removeListener(_listener);
    });

    return _getPing(_currentRouteLag);
  }

  Duration get _currentRouteLag {
    if (!ref.read(isDeviceOnlineProvider)) return Duration.zero;
    final pool = ref.read(socketPoolProvider);
    return route != null
        ? route == pool.currentClient.route
              ? pool.averageLag.value
              : Duration.zero
        : pool.averageLag.value;
  }

  /// Whether the socket for this route is actively trying to connect or is connected.
  bool get _currentRouteIsActive {
    final pool = ref.read(socketPoolProvider);
    return route != null
        ? route == pool.currentClient.route && pool.currentClient.isActive
        : pool.currentClient.isActive;
  }

  SocketPingState _getPing(Duration lag) => (
    averageLag: lag,
    isActive: _currentRouteIsActive,
    rating: lag.inMicroseconds == 0
        ? 0
        : lag.inMicroseconds < 150000
        ? 4
        : lag.inMicroseconds < 300000
        ? 3
        : lag.inMicroseconds < 500000
        ? 2
        : 1,
  );

  void _listener() {
    final newState = _getPing(_currentRouteLag);
    if (state != newState) {
      state = newState;
    }
  }
}

/// A provider for the [WebSocketChannelFactory].
final webSocketChannelFactoryProvider = Provider<WebSocketChannelFactory>((Ref ref) {
  return const WebSocketChannelFactory();
});

/// Whether [error] is the network simply not being there.
///
/// These are the two [WebSocketChannelFactory.create] documents, and the only two that say nothing
/// beyond that. Anything else means the server answered.
bool _isTransportUnavailable(Object error) => error is SocketException || error is TimeoutException;

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
