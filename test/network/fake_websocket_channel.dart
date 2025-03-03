import 'dart:async';
import 'dart:convert';

import 'package:async/src/stream_sink_transformer.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FakeWebSocketChannelFactory implements WebSocketChannelFactory {
  final FutureOr<WebSocketChannel> Function(String url) createFunction;

  const FakeWebSocketChannelFactory(this.createFunction);

  @override
  Future<WebSocketChannel> create(
    String url, {
    Map<String, dynamic>? headers,
    Duration timeout = const Duration(seconds: 1),
  }) async {
    return createFunction(url);
  }
}

/// Fake handlers to simulate server socket responses from client requests.
typedef FakeSocketServerHandlers =
    Map<String, Map<String, dynamic> Function(Map<String, dynamic> request)>;

/// A fake implementation of [WebSocketChannel]
///
/// This implementation allows to simulate incoming messages from the server
/// with the [addIncomingMessages] method.
///
/// It also allows to simulate server responses to client requests by setting the
/// [serverHandlers] property.
///
/// By default the server sends a pong response to a ping request, but this
/// behavior can be changed by setting [shouldSendPong] to false.
///
/// It also allows to increase the lag of the connection by setting the
/// [connectionLag] property. By default [connectionLag] is set to [Duration.zero]
/// to simplify testing.
/// When lag is 0, the pong and [serverHandlers] responses will be sent in the next microtask.
///
/// The [sentMessages] and [sentMessagesExceptPing] streams can be used to
/// verify that the client sends the expected messages.
class FakeWebSocketChannel implements WebSocketChannel {
  FakeWebSocketChannel({this.connectionLag = Duration.zero, this.serverHandlers = const {}});

  final FakeSocketServerHandlers serverHandlers;

  int _pongCount = 0;

  final _connectionCompleter = Completer<void>();

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

  /// The controller for incoming (from server) messages.
  final _incomingController = StreamController<dynamic>.broadcast();

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

  /// A Future that resolves when the first pong message is received
  Future<void> get connectionEstablished => _connectionCompleter.future;

  /// The stream of all outgoing messages.
  Stream<dynamic> get sentMessages => _outcomingController.stream;

  /// The stream of all outgoing messages except ping requests.
  Stream<dynamic> get sentMessagesExceptPing =>
      _outcomingController.stream.where((message) => !isPing(message));

  /// Simulates incoming messages from the server.
  void addIncomingMessages(Iterable<dynamic> messages) {
    for (final message in messages) {
      _incomingController.add(message);
    }
  }

  @override
  int? get closeCode => _incomingController.isClosed ? 1000 : null;

  @override
  String? get closeReason => _incomingController.isClosed ? 'OK' : null;

  @override
  String? get protocol => null;

  @override
  Future<void> get ready => Future<void>.value();

  @override
  WebSocketSink get sink => _FakeWebSocketSink(this, serverHandlers);

  @override
  Stream<dynamic> get stream => _incomingController.stream;

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

  @override
  void add(dynamic data) {
    _channel._outcomingController.add(data);

    // Simulates pong response if connection is not closed
    if (_channel.shouldSendPong && FakeWebSocketChannel.isPing(data)) {
      void sendPong() {
        if (_channel._incomingController.isClosed) {
          return;
        }
        _channel._pongCount++;
        if (_channel._pongCount == 1) {
          _channel._connectionCompleter.complete();
        }
        _channel._incomingController.add('0');
      }

      if (_channel.connectionLag > Duration.zero) {
        Future<void>.delayed(_channel.connectionLag, sendPong);
      } else {
        scheduleMicrotask(sendPong);
      }
    }

    if (!FakeWebSocketChannel.isPing(data) && data is String) {
      try {
        final json = jsonDecode(data);
        if (json is Map<String, dynamic>) {
          final t = json['t'] as String?;
          final serverHandler = _serverHandlers[t];
          if (serverHandler != null) {
            final response = serverHandler(json);
            if (_channel.connectionLag > Duration.zero) {
              Future<void>.delayed(_channel.connectionLag, () {
                _channel._incomingController.add(jsonEncode(response));
              });
            } else {
              scheduleMicrotask(() {
                _channel._incomingController.add(jsonEncode(response));
              });
            }
          }
        }
      } catch (e) {
        debugPrint('Fake socket server handler error: $e');
      }
    }
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<dynamic> addStream(Stream<dynamic> stream) {
    return stream.forEach(add);
  }

  @override
  Future<void> close([int? closeCode, String? closeReason]) {
    return Future.wait([_channel._incomingController.close()]);
  }

  @override
  Future<dynamic> get done => _channel._incomingController.done;
}
