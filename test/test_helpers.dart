import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:material_ui/material_ui.dart';

const double _kTestScreenWidth = 390.0;
const double _kTestScreenHeight = 844.0;

const kTestSurfaces = [
  // https://www.browserstack.com/guide/common-screen-resolutions
  // phones
  Size(360, 800),
  Size(390, 844),
  Size(393, 873),
  Size(412, 915),
  Size(414, 896),
  Size(360, 780),
  // tablets
  Size(600, 1024),
  Size(810, 1080),
  Size(820, 1180),
  Size(1280, 800),
  Size(800, 1280),
  Size(601, 962),
  // folded motorola
  Size(564.7, 482.6),
  // pixel fold unfolded
  Size(701.0, 841.1),
  Size(841.1, 701.0),
];

/// iPhone 14 screen size.
const kTestSurfaceSize = Size(_kTestScreenWidth, _kTestScreenHeight);

const kPlatformVariant = TargetPlatformVariant({TargetPlatform.android, TargetPlatform.iOS});

/// Mocks a surface with a given size.
class TestSurface extends StatelessWidget {
  const TestSurface({required this.child, required this.size, super.key});

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromView(View.of(context)).copyWith(size: size),
      child: SizedBox(width: size.width, height: size.height, child: child),
    );
  }
}

/// Mocks an http response
Future<http.Response> mockResponse(
  String body,
  int code, {
  Map<String, String> headers = const {},
}) => Future.value(http.Response(body, code, headers: headers));

Future<void> meetsTapTargetGuideline(WidgetTester tester) async {
  if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  } else {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  }
}

/// Finds either an interactive [Chessboard] or a [StaticChessboard].
Finder _anyBoard() => find.byWidgetPredicate((w) => w is Chessboard || w is StaticChessboard);

/// Checks that controls fit in the safe area, avoid the board, and enabled buttons receive taps.
void expectGameControlsVisible(WidgetTester tester, Finder controls) {
  final view = tester.view;
  final ratio = view.devicePixelRatio;
  final safeArea = Rect.fromLTRB(
    view.viewPadding.left / ratio,
    view.viewPadding.top / ratio,
    (view.physicalSize.width - view.viewPadding.right) / ratio,
    (view.physicalSize.height - view.viewPadding.bottom) / ratio,
  );
  final boardRect = tester.getRect(_anyBoard());
  expect(controls, findsWidgets);
  for (var index = 0; index < controls.evaluate().length; index++) {
    final control = controls.at(index);
    final rect = tester.getRect(control);
    final reason = '${control.describeMatch(Plurality.one)}: $rect should fit in $safeArea';
    expect(rect.width, greaterThan(0), reason: reason);
    expect(rect.height, greaterThan(0), reason: reason);
    expect(rect.left, greaterThanOrEqualTo(safeArea.left), reason: reason);
    expect(rect.top, greaterThanOrEqualTo(safeArea.top), reason: reason);
    expect(rect.right, lessThanOrEqualTo(safeArea.right), reason: reason);
    expect(rect.bottom, lessThanOrEqualTo(safeArea.bottom), reason: reason);
    expect(rect.overlaps(boardRect), isFalse, reason: '$control overlaps the board');
    final widget = tester.widget(control);
    if (widget is BottomBarButton && widget.enabled) {
      expect(control.hitTestable(), findsOneWidget, reason: '$control should receive taps');
    }
  }
}

/// Returns the pieces of the first [Chessboard] or [StaticChessboard] found in the widget tree.
///
/// Throws a [StateError] if no [PiecesPainter] is found.
Map<Square, Piece> getBoardPieces(WidgetTester tester) {
  for (final element
      in find.descendant(of: _anyBoard(), matching: find.byType(CustomPaint)).evaluate()) {
    final widget = element.widget as CustomPaint;
    if (widget.painter is PiecesPainter) {
      return (widget.painter! as PiecesPainter).pieces;
    }
  }
  throw StateError('PiecesPainter not found');
}

/// Returns the [HighlightsPainter] of the first [Chessboard] or [StaticChessboard] found in the widget tree.
///
/// Throws a [StateError] if no [HighlightsPainter] is found.
HighlightsPainter findBoardHighlightPainter(WidgetTester tester) {
  for (final element
      in find.descendant(of: _anyBoard(), matching: find.byType(CustomPaint)).evaluate()) {
    final widget = element.widget as CustomPaint;
    if (widget.painter is HighlightsPainter) {
      return widget.painter! as HighlightsPainter;
    }
  }
  throw StateError('HighlightsPainter not found');
}

/// Returns true if the board has [piece] at [square].
bool boardHasPiece(WidgetTester tester, Square square, Piece piece) {
  return getBoardPieces(tester)[square] == piece;
}

/// Returns the valid moves set currently highlighted on the interactive chessboard.
Set<Square> getBoardValidMoves(WidgetTester tester) {
  return findBoardHighlightPainter(tester).interactionNotifier.moveDests;
}

/// Returns the last move currently highlighted on the chessboard, or null if no last move is highlighted.
Move? getBoardLastMove(WidgetTester tester) {
  return findBoardHighlightPainter(tester).interactionNotifier.lastMove;
}

/// Returns true if the board has a premove highlight set for [move].
bool boardHasPremove(WidgetTester tester, Move move) {
  final p = findBoardHighlightPainter(tester);
  return p.interactionNotifier.premove != null &&
      switch (move) {
        NormalMove(:final from, :final to) =>
          p.interactionNotifier.premove!.hasSquare(from) &&
              p.interactionNotifier.premove!.hasSquare(to),
        DropMove(:final to) => p.interactionNotifier.premove!.hasSquare(to),
      };
}

/// Returns the offset of a square on a board defined by [Rect].
Offset squareOffset(Square square, Rect boardRect, {Side orientation = Side.white}) {
  final squareSize = boardRect.width / 8;

  final dx = (orientation == Side.white ? square.file.value : 7 - square.file.value) * squareSize;
  final dy = (orientation == Side.white ? 7 - square.rank.value : square.rank.value) * squareSize;

  return Offset(dx + boardRect.left + squareSize / 2, dy + boardRect.top + squareSize / 2);
}

/// Plays a move on the board.
Future<void> playMove(
  WidgetTester tester,
  String from,
  String to, {
  Rect? boardRect,
  Side orientation = Side.white,
}) async {
  final rect = boardRect ?? tester.getRect(find.byType(Chessboard));
  await tester.tapAt(squareOffset(Square.fromName(from), rect, orientation: orientation));
  await tester.pump();
  await tester.tapAt(squareOffset(Square.fromName(to), rect, orientation: orientation));
  await tester.pump();
}

/// Plays a drop move on the board.
Future<void> playDropMove(
  WidgetTester tester,
  Side side,
  Role role,
  String to, {
  Rect? boardRect,
  Side orientation = Side.white,
}) async {
  final rect = boardRect ?? tester.getRect(find.byType(Chessboard));
  final targetOffset = squareOffset(Square.fromName(to), rect, orientation: orientation);
  final fromOffset = tester.getCenter(find.byKey(ValueKey('pocket-${side.name}${role.name}')));
  await tester.dragFrom(fromOffset, targetOffset - fromOffset);
  await tester.pumpAndSettle();
}

/// The asset names of every [Image] currently rendered.
Iterable<String> imageAssetNames(WidgetTester tester) => tester
    .widgetList<Image>(find.byType(Image))
    .map((image) => image.image)
    .whereType<AssetImage>()
    .map((provider) => provider.assetName);

void mockClipboard(String text) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (methodCall) async {
      if (methodCall.method == 'Clipboard.getData') {
        return {'text': text};
      }
      return null;
    },
  );
}

/// Finds widgets by their tooltip message.
///
/// [CommonFinders.byTooltip] cannot be used, because it only matches the [Tooltip] widget of the
/// Flutter material library, whereas the app renders the one of the `material_ui` package.
Finder findByTooltip(String message, {bool skipOffstage = true}) => find.byWidgetPredicate(
  (widget) => widget is Tooltip && widget.message == message,
  description: 'tooltip "$message"',
  skipOffstage: skipOffstage,
);
