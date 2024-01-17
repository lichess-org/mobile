import 'dart:async';
import 'dart:convert';

import 'package:async/src/stream_sink_transformer.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FakeWebSocketChannelFactory implements WebSocketChannelFactory {
  final FutureOr<WebSocketChannel> Function() createFunction;

  const FakeWebSocketChannelFactory(this.createFunction);

  @override
  Future<WebSocketChannel> create(
    String url, {
    Map<String, dynamic>? headers,
    Duration timeout = const Duration(seconds: 1),
  }) async =>
      createFunction();
}

/// A fake implementation of [WebSocketChannel] that allows to simulate
/// incoming messages from the server.
class FakeWebSocketChannel implements WebSocketChannel {
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

  final _readyFuture = Future<void>.delayed(const Duration(milliseconds: 20));

  /// The controller for incoming (from server) messages.
  final _incomingController = StreamController<dynamic>.broadcast();

  /// The controller for outgoing (to server) messages.
  final _outcomingController = StreamController<dynamic>.broadcast();

  /// Whether the server should send a pong response to a ping request.
  ///
  /// Can be used to simulate a faulty connection.
  bool shouldSendPong = true;

  /// The stream of all outgoing messages.
  Stream<dynamic> get sentMessages => _outcomingController.stream;

  /// The stream of all outgoing messages except ping requests.
  Stream<dynamic> get sentMessagesExceptPing =>
      _outcomingController.stream.where((message) => !isPing(message));

  /// Simulates incoming messages from the server.
  Future<void> addIncomingMessages(Iterable<dynamic> messages) async {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    return _incomingController
        .addStream(Stream<dynamic>.fromIterable(messages));
  }

  @override
  int? get closeCode => _incomingController.isClosed ? 1000 : null;

  @override
  String? get closeReason => _incomingController.isClosed ? 'OK' : null;

  @override
  String? get protocol => null;

  @override
  Future<void> get ready => _readyFuture;

  @override
  WebSocketSink get sink => FakeWebSocketSink(this);

  @override
  Stream<dynamic> get stream => _incomingController.stream;

  @override
  void pipe(StreamChannel<dynamic> other) {}

  @override
  StreamChannel<S> transform<S>(
    StreamChannelTransformer<S, dynamic> transformer,
  ) {
    // TODO: implement transform
    throw UnimplementedError();
  }

  @override
  StreamChannel<dynamic> transformSink(
    StreamSinkTransformer<dynamic, dynamic> transformer,
  ) {
    // TODO: implement transformSink
    throw UnimplementedError();
  }

  @override
  StreamChannel<dynamic> transformStream(
    StreamTransformer<dynamic, dynamic> transformer,
  ) {
    // TODO: implement transformStream
    throw UnimplementedError();
  }

  @override
  StreamChannel<S> cast<S>() {
    // TODO: implement cast
    throw UnimplementedError();
  }

  @override
  StreamChannel<dynamic> changeSink(
    StreamSink<dynamic> Function(StreamSink<dynamic> p1) change,
  ) {
    // TODO: implement changeSink
    throw UnimplementedError();
  }

  @override
  StreamChannel<dynamic> changeStream(
    Stream<dynamic> Function(Stream<dynamic> p1) change,
  ) {
    // TODO: implement changeStream
    throw UnimplementedError();
  }
}

class FakeWebSocketSink implements WebSocketSink {
  final FakeWebSocketChannel _channel;

  FakeWebSocketSink(this._channel);

  @override
  void add(dynamic data) {
    _channel._outcomingController.add(data);

    // Simulates pong response if connection is not closed
    if (_channel.shouldSendPong && FakeWebSocketChannel.isPing(data)) {
      Future<void>.delayed(const Duration(milliseconds: 5), () {
        if (_channel._incomingController.isClosed) {
          return;
        }
        _channel._incomingController.add('0');
      });
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
    return Future.wait([
      _channel._incomingController.close(),
    ]);
  }

  @override
  Future<dynamic> get done => _channel._incomingController.done;
}
