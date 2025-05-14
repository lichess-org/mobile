import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart' show AppLocalizations;
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/network/http.dart';

part 'game.freezed.dart';
part 'game.g.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

/// Common interface for playable and exported games.
abstract mixin class BaseGame {
  GameId get id;

  GameMeta get meta;

  /// Game steps, cannot be empty.
  IList<GameStep> get steps;

  IList<ExternalEval>? get evals;
  IList<Duration>? get clocks;

  String? get initialFen;

  GameStatus get status;

  /// Whether the game is properly finished (not aborted).
  bool get finished => status.value >= GameStatus.mate.value;
  bool get aborted => status == GameStatus.aborted;

  /// Whether the game is still playable (not finished or aborted and not imported).
  bool get playable => status.value < GameStatus.aborted.value;

  /// This field is null if the game is being watched as a spectator, and
  /// represents the side that the current player is playing as otherwise.
  Side? get youAre;

  Side? get winner;

  bool? get isThreefoldRepetition;

  Player get white;
  Player get black;

  /// Player of the playing point of view. Null if spectating.
  Player? get me =>
      youAre == null
          ? null
          : youAre == Side.white
          ? white
          : black;

  /// Opponent from the playing point of view. Null if spectating.
  Player? get opponent =>
      youAre == null
          ? null
          : youAre == Side.white
          ? black
          : white;

  Position get lastPosition;

  String shareTitle(AppLocalizations l10n) =>
      '${meta.perf.title} • ${l10n.resVsX(white.fullName(l10n), black.fullName(l10n))}';

  Side? playerSideOf(UserId id) {
    if (white.user?.id == id) {
      return Side.white;
    } else if (black.user?.id == id) {
      return Side.black;
    } else {
      return null;
    }
  }

  Player playerOf(Side side) {
    return side == Side.white ? white : black;
  }

  ({PlayerAnalysis white, PlayerAnalysis black})? get serverAnalysis =>
      white.analysis != null && black.analysis != null
          ? (white: white.analysis!, black: black.analysis!)
          : null;

  /// Converts the game to a tree representation
  Root makeTree() {
    final initial = steps.first;
    final root = Root(position: initial.position);
    Node current = root;
    final clockIncrement = meta.clock?.increment ?? Duration.zero;
    Duration? whiteClock;
    Duration? blackClock;
    for (var i = 1; i < steps.length; i++) {
      final step = steps[i];
      final eval = evals?.elementAtOrNull(i - 1);
      final pgnEval =
          eval?.cp != null
              ? PgnEvaluation.pawns(pawns: cpToPawns(eval!.cp!), depth: eval.depth)
              : eval?.mate != null
              ? PgnEvaluation.mate(mate: eval!.mate, depth: eval.depth)
              : null;
      final clock = clocks?.elementAtOrNull(i - 1);
      Duration? emt;
      if (clock != null) {
        if (step.position.turn == Side.white) {
          if (whiteClock != null) {
            emt = whiteClock + clockIncrement - clock;
          }

          whiteClock = clock;
        } else {
          if (blackClock != null) {
            emt = blackClock + clockIncrement - clock;
          }
          blackClock = clock;
        }
      }

      final comment =
          eval != null || clock != null
              ? PgnComment(text: eval?.judgment?.comment, clock: clock, emt: emt, eval: pgnEval)
              : null;
      final nag = eval?.judgment != null ? _judgmentNameToNag(eval!.judgment!.name) : null;
      final nextNode = Branch(
        sanMove: step.sanMove!,
        position: step.position,
        lichessAnalysisComments: comment != null ? [comment] : null,
        nags: nag != null ? [nag] : null,
      );
      current.addChild(nextNode);

      // add analysis variation if any
      final variation = eval?.variation;
      if (variation != null) {
        Node variationNode = current;
        Position position = current.position;
        final moves = variation.split(' ');
        for (final san in moves) {
          final move = position.parseSan(san);
          position = position.playUnchecked(move!);
          final child = Branch(sanMove: SanMove(san, move), position: position);
          variationNode.addChild(child);
          variationNode = child;
        }
      }

      current = nextNode;
    }
    return root;
  }

  int? _judgmentNameToNag(String name) => switch (name) {
    'Inaccuracy' => 6,
    'Mistake' => 2,
    'Blunder' => 4,
    String() => null,
  };

  String makePgn() {
    final node = makeTree();
    final pgn = node.makePgn(
      IMap({
        'Event': '${meta.rated ? 'Rated' : ''} ${meta.perf.title} game',
        'Site': lichessUri('/$id').toString(),
        'Date': _dateFormat.format(meta.createdAt),
        'White':
            white.user?.name ??
            white.name ??
            (white.aiLevel != null ? 'Stockfish level ${white.aiLevel}' : 'Anonymous'),
        'Black':
            black.user?.name ??
            black.name ??
            (black.aiLevel != null ? 'Stockfish level ${black.aiLevel}' : 'Anonymous'),
        'Result':
            status.value >= GameStatus.mate.value
                ? winner == null
                    ? '½-½'
                    : winner == Side.white
                    ? '1-0'
                    : '0-1'
                : '*',
        if (white.rating != null) 'WhiteElo': white.rating!.toString(),
        if (black.rating != null) 'BlackElo': black.rating!.toString(),
        if (white.ratingDiff != null)
          'WhiteRatingDiff': '${white.ratingDiff! > 0 ? '+' : ''}${white.ratingDiff!}',
        if (black.ratingDiff != null)
          'BlackRatingDiff': '${black.ratingDiff! > 0 ? '+' : ''}${black.ratingDiff!}',
        'Variant': meta.variant.label,
        if (meta.clock != null)
          'TimeControl': '${meta.clock!.initial.inSeconds}+${meta.clock!.increment.inSeconds}',
        if (initialFen != null) 'FEN': initialFen!,
        if (meta.opening != null) 'ECO': meta.opening!.eco,
        if (meta.opening != null) 'Opening': meta.opening!.name,
      }),
    );
    return pgn;
  }
}

/// A mixin that provides methods to access game data at a specific step.
mixin IndexableSteps on BaseGame {
  String get sanMoves => steps.where((e) => e.sanMove != null).map((e) => e.sanMove!.san).join(' ');

  MaterialDiffSide? materialDiffAt(int cursor, Side side) => steps[cursor].diff?.bySide(side);

  GameStep stepAt(int cursor) => steps[cursor];

  String fenAt(int cursor) => steps[cursor].position.fen;

  Move? moveAt(int cursor) {
    return steps[cursor].sanMove?.move;
  }

  Position positionAt(int cursor) => steps[cursor].position;

  Duration? archivedWhiteClockAt(int cursor) => steps[cursor].archivedWhiteClock;

  Duration? archivedBlackClockAt(int cursor) => steps[cursor].archivedBlackClock;

  Move? get lastMove {
    return steps.last.sanMove?.move;
  }

  Position get initialPosition => steps.first.position;
  int get initialPly => steps.first.position.ply;

  @override
  Position get lastPosition => steps.last.position;

  int get lastPly => steps.last.position.ply;

  MaterialDiffSide? lastMaterialDiffAt(Side side) => steps.last.diff?.bySide(side);
}

enum GameSource {
  lobby,
  friend,
  ai,
  api,
  arena,
  position,
  import,
  importLive,
  simul,
  relay,
  pool,
  swiss,
  unknown;

  static final nameMap = IMap(GameSource.values.asNameMap());
}

enum GameRule {
  noAbort,
  noRematch,
  noClaimWin,
  unknown;

  static final nameMap = IMap(GameRule.values.asNameMap());
}

@freezed
sealed class ServerGamePrefs with _$ServerGamePrefs {
  const ServerGamePrefs._();

  const factory ServerGamePrefs({
    required bool showRatings,
    required bool enablePremove,
    required AutoQueen autoQueen,
    required bool confirmResign,
    required bool submitMove,
    required Zen zenMode,
  }) = _ServerGamePrefs;
}

@Freezed(fromJson: true, toJson: true)
class TournamentMeta with _$TournamentMeta {
  const TournamentMeta._();

  const factory TournamentMeta({
    required TournamentId id,
    required String name,
    required ({Duration timeLeft, DateTime at}) clock,
    required bool berserkable,
    ({int white, int black})? ranks,
  }) = _TournamentMeta;

  factory TournamentMeta.fromJson(Map<String, dynamic> json) => _$TournamentMetaFromJson(json);

  bool get isOngoing => clock.timeLeft > Duration.zero;
  bool get isFinished => clock.timeLeft <= Duration.zero;
}

@Freezed(fromJson: true, toJson: true)
sealed class GameMeta with _$GameMeta {
  const GameMeta._();

  @Assert('!(clock != null && daysPerTurn != null)')
  const factory GameMeta({
    required DateTime createdAt,
    required bool rated,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    ({
      Duration initial,
      Duration increment,

      /// Remaining time threshold to switch the clock to "emergency" mode.
      Duration? emergency,

      /// Time added to the clock by the "add more time" button.
      Duration? moreTime,
    })?
    clock,
    int? daysPerTurn,
    int? startedAtTurn,
    ISet<GameRule>? rules,

    /// Opening of the game, only available once finished
    LightOpening? opening,

    /// Game phases of the game, only avaible once finished
    Division? division,

    /// Only if this game is part of an arena or swiss tournament
    TournamentMeta? tournament,
  }) = _GameMeta;

  factory GameMeta.fromJson(Map<String, dynamic> json) => _$GameMetaFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
sealed class CorrespondenceClockData with _$CorrespondenceClockData {
  const factory CorrespondenceClockData({required Duration white, required Duration black}) =
      _CorrespondenceClockData;

  factory CorrespondenceClockData.fromJson(Map<String, dynamic> json) =>
      _$CorrespondenceClockDataFromJson(json);
}

@freezed
sealed class GameStep with _$GameStep {
  const factory GameStep({
    required Position position,
    SanMove? sanMove,
    MaterialDiff? diff,

    /// The remaining white clock time at this step. Only available when the
    /// game is finished.
    Duration? archivedWhiteClock,

    /// The remaining black clock time at this step. Only available when the
    /// game is finished.
    Duration? archivedBlackClock,
  }) = _GameStep;
}

/// Converts a list of [GameStep]s to a JSON list.
String stepsToJson(IList<GameStep> steps) {
  final objs = steps
      .mapIndexed(
        (i, e) => {
          if (i == 0) 'fen': e.position.fen,
          if (i == 0) 'rule': e.position.rule.name,
          'uci': e.sanMove?.move.uci,
          'san': e.sanMove?.san,
        },
      )
      .toList(growable: false);
  return jsonEncode(objs);
}

/// Converts a JSON list to a list of [GameStep]s.
IList<GameStep> stepsFromJson(String json) {
  final objs = jsonDecode(json) as List<dynamic>;
  final first = objs.first as Map<String, dynamic>;
  final initialFen = first['fen'] as String;
  final rule = Rule.values.byName(first['rule'] as String);
  Position position = Position.setupPosition(rule, Setup.parseFen(initialFen));
  final List<GameStep> steps = [GameStep(position: position)];
  for (final obj in objs.skip(1)) {
    final step = obj as Map<String, dynamic>;
    final uci = step['uci'] as String?;
    final san = step['san'] as String?;
    if (uci == null || san == null) {
      break;
    }
    final move = Move.parse(uci)!;
    position = position.playUnchecked(move);
    steps.add(
      GameStep(
        position: position,
        sanMove: SanMove(san, move),
        diff: MaterialDiff.fromBoard(position.board),
      ),
    );
  }
  return steps.toIList();
}
