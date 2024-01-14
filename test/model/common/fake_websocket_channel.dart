import 'dart:async';

import 'package:async/src/stream_sink_transformer.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FakeWebSocketChannel implements WebSocketChannel {
  final List<dynamic> _sentMessages = <dynamic>[];
  final _readyFuture = Future<void>.delayed(const Duration(milliseconds: 50));

  /// The controller for the stream that this channel provides (incoming messages).
  final StreamController<dynamic> _controller = StreamController<dynamic>();

  FakeWebSocketChannel();

  int get sentMessagesCount => _sentMessages.length;
  List<dynamic> get sentMessages => _sentMessages;

  /// Simulates incoming messages from the server.
  Future<void> addIncomingMessages(Iterable<dynamic> messages) async {
    await Future<void>.delayed(const Duration(milliseconds: 10), () {
      _controller.addStream(Stream<dynamic>.fromIterable(messages));
    });
  }

  @override
  int? get closeCode => _controller.isClosed ? 1000 : null;

  @override
  String? get closeReason => _controller.isClosed ? 'OK' : null;

  @override
  String? get protocol => null;

  @override
  Future<void> get ready => _readyFuture;

  @override
  WebSocketSink get sink => FakeWebSocketSink(this);

  @override
  Stream<dynamic> get stream => _controller.stream;

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
    _channel._sentMessages.add(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<dynamic> addStream(Stream<dynamic> stream) async {
    _channel._sentMessages.addAll(await stream.toList());
  }

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    await Future.delayed(const Duration(milliseconds: 20), () {
      _channel._controller.close();
    });
  }

  @override
  Future<dynamic> get done => _channel._controller.done;
}
