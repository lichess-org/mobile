import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_links.g.dart';

final _logger = Logger('App Links');

WidgetBuilder? resolveAppLinkUri(Uri appLinkUri) {
  if (appLinkUri.pathSegments.length < 2 || appLinkUri.pathSegments[1].isEmpty) {
    return null;
  }

  final id = appLinkUri.pathSegments[1];

  switch (appLinkUri.pathSegments[0]) {
    case 'study':
      return (context) => StudyScreen(id: StudyId(id));
    case 'training':
      return (context) => PuzzleScreen(angle: PuzzleAngle.fromKey('mix'), puzzleId: PuzzleId(id));
    case _:
      {
        final gameId = GameId(appLinkUri.pathSegments[0]);
        final orientation = appLinkUri.pathSegments.getOrNull(2);
        if (gameId.isValid) {
          return (context) => ArchivedGameScreen(
            gameId: gameId,
            orientation: orientation == 'black' ? Side.black : Side.white,
          );
        } else {
          // TODO if it's not a game, it's a challenge.
          // So we should show a accept/decline screen here.
          return null;
        }
      }
  }
}

/// Receives incoming app links from the operating system (iOS or Android).
///
/// There are two ways a new app link can be received:
/// 1) The app is not running, the user presses a supported link which then opens the app.
/// 2) Like 1), but the app is already running in the background.
///
/// Use [resolveAppLinkUri] to get the a builder for the screen that should be displayed
/// for the given app link URI.
@Riverpod(keepAlive: true)
class AppLinks extends _$AppLinks {
  static const _channel = MethodChannel('mobile.lichess.org/app_links');

  @override
  Future<Uri?> build() async {
    final initialLink = await _channel.invokeMethod<String?>('getAppLink');
    _logger.info('Initial app link: $initialLink');

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'newAppLink') {
        final uri = Uri.parse(call.arguments as String);
        _logger.info('Received new app link: $uri');
        state = AsyncValue.data(uri);
      }
    });

    return initialLink != null ? Uri.parse(initialLink) : null;
  }
}
