import 'dart:async';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';

part 'server_analysis_service.g.dart';

@Riverpod(keepAlive: true)
ServerAnalysisService serverAnalysisService(ServerAnalysisServiceRef ref) {
  return ServerAnalysisService(Logger('ServerAnalysisService'), ref: ref);
}

class ServerAnalysisService {
  ServerAnalysisService(this._log, {required this.ref});

  final ServerAnalysisServiceRef ref;
  final Logger _log;

  StreamSubscription<SocketEvent>? _socketSubscription;

  // Future<GameFullId> requestAnalysis(GameSeek seek) async {
  //   final socket = ref.read(authSocketProvider);
  // }

  void dispose() {
    _socketSubscription?.cancel();
    _socketSubscription = null;
  }
}
