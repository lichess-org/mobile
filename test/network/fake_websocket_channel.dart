import 'dart:async';
import 'dart:convert';

import 'package:async/src/stream_sink_transformer.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Default lag for the fake WebSocket connection.
const kFakeWebSocketConnectionLag = Duration(milliseconds: 5);

/// A [WebSocketChannelFactory] with default connection lag and no server handlers.
const defaultFakeWebSocketChannelFactory = FakeWebSocketChannelFactory(
  createDefaultFakeWebSocketChannel,
);

/// Creates a fake WebSocket channel with default connection lag with the given [socketRoute].
FakeWebSocketChannel createDefaultFakeWebSocketChannel(Uri socketRoute) {
  return FakeWebSocketChannel(socketRoute, connectionLag: kFakeWebSocketConnectionLag);
}

/// A [WebSocketChannelFactory] that creates fake WebSocket channels and exposes a stream of outgoing messages (except ping).
class ListenableFakeWebSocketChannelFactory implements WebSocketChannelFactory {
  ListenableFakeWebSocketChannelFactory(this.createFunction);

  final FakeWebSocketChannel Function(Uri socketRoute) createFunction;

  Stream<dynamic> outgoingMessages(Uri socketRoute) {
    return _outcomingController.stream
        .where((message) => message.$1 == socketRoute)
        .map((message) => message.$2);
  }

  final Map<Uri, StreamSubscription<dynamic>> _subscriptions = {};
  final _outcomingController = StreamController<(Uri, dynamic)>.broadcast();

  void dispose() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    _outcomingController.close();
  }

  @override
  Future<WebSocketChannel> create(
    String url, {
    Map<String, dynamic>? headers,
    Duration timeout = const Duration(seconds: 1),
  }) {
    final route = Uri(path: Uri.parse(url).path);
    final channel = createFunction(route);

    _subscriptions[route]?.cancel();
    _subscriptions[route] = channel.sentMessagesExceptPing.listen((message) {
      _outcomingController.add((route, message));
    });

    return Future.value(channel);
  }
}

/// A [WebSocketChannelFactory] that creates fake WebSocket channels.
class FakeWebSocketChannelFactory implements WebSocketChannelFactory {
  const FakeWebSocketChannelFactory(this.createFunction);

  final FakeWebSocketChannel Function(Uri socketRoute) createFunction;

  @override
  Future<WebSocketChannel> create(
    String url, {
    Map<String, dynamic>? headers,
    Duration timeout = const Duration(seconds: 1),
  }) {
    return Future.value(createFunction(Uri(path: Uri.parse(url).path)));
  }
}

/// The controller for incoming (from server) messages.
final _incomingController = StreamController<(Uri, dynamic)>.broadcast();

/// Simulates incoming messages from the server.
void sendServerSocketMessages(Uri socketRoute, Iterable<dynamic> messages) {
  for (final message in messages) {
    _incomingController.add((socketRoute, message));
  }
}

/// Fake handlers to simulate server socket responses from client requests.
typedef FakeSocketServerHandlers =
    Map<String, Map<String, dynamic> Function(Map<String, dynamic> request)>;

/// A fake implementation of [WebSocketChannel]
///
/// This implementation allows to simulate incoming messages from the server
/// with the global [sendServerSocketMessages] function.
///
/// It also allows to simulate server responses to client requests by setting the
/// [serverHandlers] property.
///
/// By default the server sends a pong response to a ping request, but this
/// behavior can be changed by setting [shouldSendPong] to false.
///
/// It also allows to increase the lag of the connection by setting the
/// [connectionLag] property.
///
/// The [sentMessages] and [sentMessagesExceptPing] streams can be used to
/// verify that the client sends the expected messages.
class FakeWebSocketChannel implements WebSocketChannel {
  FakeWebSocketChannel(
    this.route, {
    this.connectionLag = kFakeWebSocketConnectionLag,
    this.serverHandlers = const {},
  }) : assert(route.path.isNotEmpty, 'Route path must not be empty'),
       assert(connectionLag > Duration.zero, 'Connection lag must be greater than 0') {
    _sink = _FakeWebSocketSink(this, serverHandlers);
  }

  final Uri route;

  final FakeSocketServerHandlers serverHandlers;

  late final _FakeWebSocketSink _sink;

  Future<void> _close() {
    return _outcomingController.close();
  }

  int _pongCount = 0;

  static bool isPing(dynamic data) {
    if (data is! String) {
      return false;
    }
    if (data == 'p') {
      return true;
    }
    final json = jsonDecode(data);
    if (json is Map<String, dynamic>) {
      return json['t'] == 'p';
    }
    return false;
  }

  /// The controller for outgoing (to server) messages.
  final _outcomingController = StreamController<dynamic>.broadcast();

  /// The lag of the connection (duration before pong response) in milliseconds.
  Duration connectionLag;

  /// Whether the server should send a pong response to a ping request.
  ///
  /// Can be used to simulate a faulty connection.
  bool shouldSendPong = true;

  /// Number of pong response received
  int get pongCount => _pongCount;

  /// The stream of all outgoing messages.
  Stream<dynamic> get sentMessages => _outcomingController.stream;

  /// The stream of all outgoing messages except ping requests.
  Stream<dynamic> get sentMessagesExceptPing =>
      _outcomingController.stream.where((message) => !isPing(message));

  @override
  int? get closeCode => _outcomingController.isClosed ? 1000 : null;

  @override
  String? get closeReason => _outcomingController.isClosed ? 'OK' : null;

  @override
  String? get protocol => null;

  @override
  Future<void> get ready => Future<void>.value();

  @override
  WebSocketSink get sink => _sink;

  @override
  Stream<dynamic> get stream =>
      _incomingController.stream.where((event) => event.$1 == route).map((event) => event.$2);

  @override
  void pipe(StreamChannel<dynamic> other) {}

  @override
  StreamChannel<S> transform<S>(StreamChannelTransformer<S, dynamic> transformer) {
    // TODO: implement transform
    throw UnimplementedError();
  }

  @override
  StreamChannel<dynamic> transformSink(StreamSinkTransformer<dynamic, dynamic> transformer) {
    // TODO: implement transformSink
    throw UnimplementedError();
  }

  @override
  StreamChannel<dynamic> transformStream(StreamTransformer<dynamic, dynamic> transformer) {
    // TODO: implement transformStream
    throw UnimplementedError();
  }

  @override
  StreamChannel<S> cast<S>() {
    // TODO: implement cast
    throw UnimplementedError();
  }

  @override
  StreamChannel<dynamic> changeSink(StreamSink<dynamic> Function(StreamSink<dynamic> p1) change) {
    // TODO: implement changeSink
    throw UnimplementedError();
  }

  @override
  StreamChannel<dynamic> changeStream(Stream<dynamic> Function(Stream<dynamic> p1) change) {
    // TODO: implement changeStream
    throw UnimplementedError();
  }
}

class _FakeWebSocketSink implements WebSocketSink {
  _FakeWebSocketSink(this._channel, this._serverHandlers);

  final FakeWebSocketChannel _channel;
  final FakeSocketServerHandlers _serverHandlers;

  Timer? _pingTimer;
  final Map<String, Timer?> _serverHandlersTimers = {};

  @override
  void add(dynamic data) {
    _channel._outcomingController.add(data);

    // Simulates pong response if connection is not closed
    if (_channel.shouldSendPong && FakeWebSocketChannel.isPing(data)) {
      _pingTimer?.cancel();
      _pingTimer = Timer(_channel.connectionLag, () {
        _sendPong();
      });
    }

    if (!FakeWebSocketChannel.isPing(data) && data is String) {
      try {
        final json = jsonDecode(data);
        if (json is Map<String, dynamic>) {
          final t = json['t'] as String?;
          final serverHandler = _serverHandlers[t];
          if (t != null && serverHandler != null) {
            final response = serverHandler(json);
            _serverHandlersTimers[t]?.cancel();
            _serverHandlersTimers[t] = Timer(_channel.connectionLag, () {
              _incomingController.add((_channel.route, jsonEncode(response)));
            });
          }
        }
      } catch (e) {
        debugPrint('Fake socket server handler error: $e');
      }
    }
  }

  void _sendPong() {
    if (_incomingController.isClosed) {
      return;
    }
    _channel._pongCount++;
    _incomingController.add((_channel.route, '0'));
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<dynamic> addStream(Stream<dynamic> stream) {
    return stream.forEach(add);
  }

  @override
  Future<void> close([int? closeCode, String? closeReason]) {
    _pingTimer?.cancel();
    _serverHandlersTimers.forEach((_, timer) {
      timer?.cancel();
    });
    return _channel._close();
  }

  @override
  Future<dynamic> get done => _channel._outcomingController.done;
}
