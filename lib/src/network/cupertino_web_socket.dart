// Adapted from `package:cupertino_http`'s `CupertinoWebSocket`:
// Copyright (c) 2024, the Dart project authors. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file of that package.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:objective_c/objective_c.dart' as objc;
import 'package:web_socket/web_socket.dart';

/// The `NSURLErrorDomain` codes that mean the network was not there to try: the request never got
/// an answer from the server.
///
/// See https://developer.apple.com/documentation/foundation/1508628-url_loading_system_error_codes
const _transportUnavailableCodes = {
  -1001, // NSURLErrorTimedOut
  -1003, // NSURLErrorCannotFindHost
  -1004, // NSURLErrorCannotConnectToHost
  -1005, // NSURLErrorNetworkConnectionLost
  -1006, // NSURLErrorDNSLookupFailed
  -1009, // NSURLErrorNotConnectedToInternet
  -1018, // NSURLErrorInternationalRoamingOff
  -1019, // NSURLErrorCallIsActive
  -1020, // NSURLErrorDataNotAllowed
};

/// A WebSocket connection that failed, with the `NSError` that `NSURLSession` gave for it.
class CupertinoWebSocketException(super.message, objc.NSError error) extends WebSocketException {
  final String domain = error.domain.toDartString();
  final int code = error.code;
  final String description = error.localizedDescription.toDartString();

  /// Whether the connection could not even be attempted, as on a device with no network.
  bool get isTransportUnavailable =>
      domain == 'NSURLErrorDomain' && _transportUnavailableCodes.contains(code);

  @override
  String toString() => 'CupertinoWebSocketException: $message [$domain $code: $description]';
}

/// A [WebSocket] implemented with the
/// [NSURLSessionWebSocketTask API](https://developer.apple.com/documentation/foundation/nsurlsessionwebsockettask).
///
/// Unlike `dart:io`, which opens BSD sockets, this goes through the system networking stack, so the
/// connection honours the system proxy settings, VPN On Demand rules, and Wi-Fi Assist.
///
/// Unlike `package:cupertino_http`'s `CupertinoWebSocket`, every connection is made from one shared
/// `NSURLSession` with its headers set on the request: a session that has run a WebSocket task is
/// never released, so one session per connection (as passing headers through a
/// [URLSessionConfiguration] requires) would leak a session at each reconnection.
class CupertinoWebSocket._(final URLSessionWebSocketTask _task, final String _protocol)
    implements WebSocket {
  this {
    _scheduleReceive();
  }

  static final URLSession _session = objc.autoReleasePool(
    () => URLSession.sessionWithConfiguration(
      URLSessionConfiguration.ephemeralSessionConfiguration(),
    ),
  );

  /// Opens a WebSocket connection to [url], sending [headers] with the handshake request.
  ///
  /// Throws a [TimeoutException] if the connection is not open after [timeout], and a
  /// [CupertinoWebSocketException] if it fails.
  static Future<CupertinoWebSocket> connect(
    Uri url, {
    Map<String, String> headers = const {},
    Duration timeout = const Duration(seconds: 10),
  }) {
    if (!url.isScheme('ws') && !url.isScheme('wss')) {
      throw ArgumentError.value(url, 'url', 'only ws: and wss: schemes are supported');
    }

    final readyCompleter = Completer<CupertinoWebSocket>();
    CupertinoWebSocket? webSocket;
    late URLSessionWebSocketTask task;
    Timer? timeoutTimer;

    objc.autoReleasePool(() {
      final request = MutableURLRequest.fromUrl(url);
      // The parameters of `setValueForHttpHeaderField` are named `(value, field)`, but it takes the
      // header name first: it is how `CupertinoClient` calls it, with `headers.forEach`.
      headers.forEach(request.setValueForHttpHeaderField);

      task = _session.webSocketTaskWithRequest(request)
        ..taskDelegate = URLSessionTask.delegate(
          // In a successful flow, the callbacks are made in this order:
          // onWebSocketTaskOpened(...)        // Good connect.
          // <receive/send messages to the peer>
          // onWebSocketTaskClosed(...)        // Optional: peer sent Close frame.
          // onComplete(..., error=null)       // Disconnected.
          //
          // A failure to connect to the peer only calls onComplete(..., error=error), which can
          // also be called at any point if the peer is disconnected without Close frames.
          onWebSocketTaskOpened: (session, task, protocol) {
            if (readyCompleter.isCompleted) return;
            timeoutTimer?.cancel();
            final openSocket = CupertinoWebSocket._(task, protocol ?? '');
            webSocket = openSocket;
            readyCompleter.complete(openSocket);
          },
          onWebSocketTaskClosed: (session, task, closeCode, reason) {
            webSocket?._connectionClosed(closeCode, reason);
          },
          onComplete: (session, task, error) {
            timeoutTimer?.cancel();
            if (!readyCompleter.isCompleted) {
              readyCompleter.completeError(
                error == null
                    ? StateError('expected an error or "onWebSocketTaskOpened" to be called first')
                    : CupertinoWebSocketException('connection failed', error),
              );
            } else {
              // Either the peer sent a close frame or we closed the socket, and then this is a
              // no-op, or the network failed and this tells the listener.
              webSocket?._connectionClosed(1006, 'abnormal close'.codeUnits.toNSData());
            }
          },
        )
        ..resume();
    });

    // A Dart side timeout rather than the request's own `timeoutInterval`, which on a WebSocket
    // task can also apply to the reads after the handshake. Cancelling the task makes sure a
    // connection that opens late does not stay open with nobody listening.
    timeoutTimer = Timer(timeout, () {
      if (readyCompleter.isCompleted) return;
      readyCompleter.completeError(
        TimeoutException('WebSocket connection to $url timed out', timeout),
      );
      task.cancel();
    });

    return readyCompleter.future;
  }

  final _events = StreamController<WebSocketEvent>();

  /// Handles an incoming message from the peer and schedules receiving the next one.
  void _handleMessage(URLSessionWebSocketMessage value) {
    if (_events.isClosed) return;

    _events.add(switch (value.type) {
      .NSURLSessionWebSocketMessageTypeString => TextDataReceived(value.string!),
      .NSURLSessionWebSocketMessageTypeData => BinaryDataReceived(value.data!.toList()),
    });
    _scheduleReceive();
  }

  void _scheduleReceive() {
    unawaited(_task.receiveMessage().then(_handleMessage, onError: _closeConnectionWithError));
  }

  /// Closes the WebSocket connection due to an error and sends the [CloseReceived] event.
  void _closeConnectionWithError(Object e) {
    if (e is! objc.NSError) {
      throw StateError('unexpected error: $e');
    }
    final domain = e.domain.toDartString();
    if (domain == 'NSPOSIXErrorDomain' && e.code == 57) {
      // Socket is not connected: onWebSocketTaskClosed/onComplete will be invoked and may give a
      // close code.
      return;
    }
    final code = domain == 'NSPOSIXErrorDomain' && e.code == 100 ? 1002 : 1006;
    _task.cancel();
    _connectionClosed(code, e.localizedDescription.toDartString().codeUnits.toNSData());
  }

  void _connectionClosed(int? closeCode, objc.NSData? reason) {
    if (_events.isClosed) return;
    var code = closeCode;
    var closeReason = '';
    if (reason != null) {
      try {
        closeReason = utf8.decode(reason.toList());
      } on FormatException {
        code = 1006;
      }
    }
    _events
      ..add(CloseReceived(code, closeReason))
      ..close();
  }

  void _send(URLSessionWebSocketMessage message) {
    if (_events.isClosed) {
      throw WebSocketConnectionClosed();
    }
    _task.sendMessage(message).then((_) {}, onError: _closeConnectionWithError);
  }

  @override
  void sendBytes(Uint8List b) => _send(URLSessionWebSocketMessage.fromData(b.toNSData()));

  @override
  void sendText(String s) => _send(URLSessionWebSocketMessage.fromString(s));

  /// Closes the connection, with a normal closure (1000) close frame when [code] is not given.
  @override
  Future<void> close([int? code, String? reason]) async {
    if (_events.isClosed) {
      throw WebSocketConnectionClosed();
    }
    if (code != null && code != 1000 && !(code >= 3000 && code <= 4999)) {
      throw ArgumentError('Invalid argument: $code, close code must be 1000 or in 3000-4999');
    }
    final reasonBytes = utf8.encode(reason ?? '');
    if (reasonBytes.length > 123) {
      throw ArgumentError.value(reason, 'reason', 'must be <= 123 bytes when encoded as UTF-8');
    }

    unawaited(_events.close());
    _task.cancelWithCloseCode(code ?? 1000, reasonBytes.toNSData());
  }

  @override
  Stream<WebSocketEvent> get events => _events.stream;

  @override
  String get protocol => _protocol;
}
