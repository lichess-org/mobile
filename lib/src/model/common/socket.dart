import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket.freezed.dart';

/// A socket event.
@freezed
class SocketEvent with _$SocketEvent {
  const SocketEvent._();

  const factory SocketEvent({
    required String topic,
    dynamic data,
    Uri? route,

    /// Version of the socket event, only for versioned socket routes.
    int? version,
  }) = _SocketEvent;

  static const pong = SocketEvent(topic: '_pong');

  factory SocketEvent.fromJson(Map<String, dynamic> json, [Uri? route]) {
    if (json['t'] == null) {
      if (json['v'] != null) {
        return SocketEvent(
          topic: '_version',
          version: json['v'] as int,
          route: route,
        );
      } else {
        assert(false, 'Unsupported socket event json: $json');
        return pong;
      }
    }
    final topic = json['t'] as String;
    if (topic == 'n') {
      return SocketEvent(
        topic: topic,
        data: {
          'nbPlayers': json['d'] as int,
          'nbGames': json['r'] as int,
        },
        route: route,
      );
    }
    return SocketEvent(
      topic: topic,
      data: json['d'],
      version: json['v'] as int?,
      route: route,
    );
  }
}
