import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket.freezed.dart';

enum SocketEventType {
  /// Sent by the server to check the connection is still alive.
  pong,

  /// Versioned socket will send this to notify the client of the current version.
  version,

  /// Sent when a game pairing has been made.
  redirect,

  /// Sent just after switching to the game route with full game data.
  gameFull,

  /// Sent when the game needs to be resynced (event gap).
  resync,

  /// Sent to acknowledge a route switch.
  switchRoute,

  /// Unknown event type.
  unknown;

  static SocketEventType fromWSEventType(String type) {
    switch (type) {
      case 'n':
        return SocketEventType.pong;
      case 'redirect':
        return SocketEventType.redirect;
      case 'full':
        return SocketEventType.gameFull;
      case 'resync':
        return SocketEventType.resync;
      case 'switch':
        return SocketEventType.switchRoute;
      default:
        return SocketEventType.unknown;
    }
  }
}

@freezed
class SocketEvent with _$SocketEvent {
  const SocketEvent._();

  const factory SocketEvent({
    required SocketEventType type,
    dynamic data,
    int? version,
  }) = _SocketEvent;

  static const pong = SocketEvent(type: SocketEventType.pong);

  factory SocketEvent.fromJson(Map<String, dynamic> json) {
    if (json['t'] == null) {
      if (json['v'] != null) {
        return SocketEvent(
          type: SocketEventType.version,
          version: json['v'] as int,
        );
      } else {
        assert(false, 'Unsupported socket event json: $json');
        return pong;
      }
    }
    final type = json['t'] as String;
    return SocketEvent(
      type: SocketEventType.fromWSEventType(type),
      data: json['d'],
      version: json['v'] as int?,
    );
  }
}
