import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

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

Matcher sameRequest(http.BaseRequest request) => _SameRequest(request);
Matcher sameHeaders(Map<String, String> headers) => _SameHeaders(headers);

/// Mocks a surface with a given size.
class TestSurface extends StatelessWidget {
  const TestSurface({required this.child, required this.size, super.key});

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(size: size),
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

Future<http.StreamedResponse> mockStreamedResponse(String body, int code) =>
    Future.value(http.StreamedResponse(Stream.value(body).map(utf8.encode), code));

Future<http.StreamedResponse> mockHttpStreamFromIterable(Iterable<String> events) async {
  return http.StreamedResponse(
    _streamFromFutures(events.map((e) => Future.value(utf8.encode(e)))),
    200,
  );
}

Future<http.StreamedResponse> mockHttpStream(Stream<String> stream) =>
    Future.value(http.StreamedResponse(stream.map(utf8.encode), 200));

Future<void> meetsTapTargetGuideline(WidgetTester tester) async {
  if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  } else {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  }
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
  final fromOffset = tester.getCenter(find.byKey(ValueKey('pocket-${side.name}${role.name}')));
  await tester.dragFrom(
    fromOffset,
    squareOffset(Square.fromName(to), rect, orientation: orientation) - fromOffset,
  );
  await tester.pumpAndSettle();
}

// --

class _SameRequest extends Matcher {
  const _SameRequest(this._expected);

  final http.BaseRequest _expected;

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is http.BaseRequest &&
      item.method == _expected.method &&
      item.url == _expected.url &&
      mapEquals(item.headers, _expected.headers);

  @override
  Description describe(Description description) =>
      description.add('same Request as ').addDescriptionOf(_expected);
}

class _SameHeaders extends Matcher {
  const _SameHeaders(this._expected);

  final Map<String, String> _expected;

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is Map<String, String> && mapEquals(item, _expected);
  @override
  Description describe(Description description) =>
      description.add('same headers as ').addDescriptionOf(_expected);
}

Stream<T> _streamFromFutures<T>(Iterable<Future<T>> futures) async* {
  for (final future in futures) {
    final result = await future;
    yield result;
  }
}
