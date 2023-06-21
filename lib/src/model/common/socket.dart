import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket.freezed.dart';

enum SocketEventType {
  /// Sent by the server to check the connection is still alive.
  pong,

  /// Event which only purpose is to tell the current version of socket.
  version,

  /// All the other events, usually part of a domain protocol (eg. lobby, game, etc.)
  topic;
}

@freezed
class SocketEvent with _$SocketEvent {
  const SocketEvent._();

  const factory SocketEvent({
    required SocketEventType type,
    required String topic,
    dynamic data,
    int? version,
  }) = _SocketEvent;

  static const pong = SocketEvent(type: SocketEventType.pong, topic: 'pong');

  factory SocketEvent.fromJson(Map<String, dynamic> json) {
    if (json['t'] == null) {
      if (json['v'] != null) {
        return SocketEvent(
          type: SocketEventType.version,
          topic: '_version',
          version: json['v'] as int,
        );
      } else {
        assert(false, 'Unsupported socket event json: $json');
        return pong;
      }
    }
    final topic = json['t'] as String;
    return SocketEvent(
      type: SocketEventType.topic,
      topic: topic,
      data: json['d'],
      version: json['v'] as int?,
    );
  }
}
