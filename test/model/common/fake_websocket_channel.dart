import 'dart:async';

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

class FakeWebSocketChannel implements WebSocketChannel {
  static bool isPing(dynamic data) =>
      data is String && data == 'p' ||
      data is Map<String, dynamic> && data['t'] == 'p';

  final _readyFuture = Future<void>.delayed(const Duration(milliseconds: 20));

  final _incomingController = StreamController<dynamic>.broadcast();
  final _outcomingController = StreamController<dynamic>.broadcast();

  Future<int> get sentMessagesCount => _outcomingController.stream.length;
  Stream<dynamic> get sentMessages => _outcomingController.stream;

  /// Simulates incoming messages from the server.
  Future<void> addIncomingMessages(Iterable<dynamic> messages) async {
    await Future<void>.delayed(const Duration(milliseconds: 10), () {
      _incomingController.addStream(Stream<dynamic>.fromIterable(messages));
    });
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
  void pipe(StreamChannel<dynamic> other) {
    // TODO: implement pipe
  }

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

    // Simulates pong response
    if (FakeWebSocketChannel.isPing(data)) {
      Future<void>.delayed(const Duration(milliseconds: 5), () {
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
  Future<void> close([int? closeCode, String? closeReason]) async {
    await Future.delayed(const Duration(milliseconds: 10), () {
      _channel._incomingController.close();
      _channel._outcomingController.close();
    });
  }

  @override
  Future<dynamic> get done => _channel._incomingController.done;
}
