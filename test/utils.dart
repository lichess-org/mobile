import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chessground/chessground.dart' as cg;

const double _kTestScreenWidth = 390.0;
const double _kTestScreenHeight = 844.0;
const kTestSurfaceSize = Size(_kTestScreenWidth, _kTestScreenHeight);
const kPlatformVariant =
    TargetPlatformVariant({TargetPlatform.android, TargetPlatform.iOS});

Matcher sameRequest(http.BaseRequest request) => _SameRequest(request);
Matcher sameHeaders(Map<String, String> headers) => _SameHeaders(headers);

Future<http.Response> mockResponse(String body, int code) =>
    Future<void>.delayed(const Duration(milliseconds: 20))
        .then((_) => http.Response(body, code));

Future<http.StreamedResponse> mockHttpStreamFromIterable(
  Iterable<String> events,
) async {
  await Future<void>.delayed(const Duration(milliseconds: 20));
  return http.StreamedResponse(
    _streamFromFutures(events.map((e) => _withDelay(utf8.encode(e)))),
    200,
  );
}

Future<http.StreamedResponse> mockHttpStream(Stream<String> stream) =>
    Future<void>.delayed(const Duration(milliseconds: 20))
        .then((_) => http.StreamedResponse(stream.map(utf8.encode), 200));

Future<void> tapBackButton(WidgetTester tester) async {
  if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
    await tester.tap(find.widgetWithIcon(CupertinoButton, CupertinoIcons.back));
  } else {
    await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back));
  }
}

Future<void> meetsTapTargetGuideline(WidgetTester tester) async {
  if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  } else {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  }
}

Offset squareOffset(
  cg.SquareId id,
  Rect boardRect, {
  cg.Side orientation = cg.Side.white,
}) {
  final squareSize = boardRect.width / 8;
  final o = cg.Coord.fromSquareId(id).offset(orientation, squareSize);
  return Offset(
    o.dx + boardRect.left + squareSize / 2,
    o.dy + boardRect.top + squareSize / 2,
  );
}

// simplified version of class [App] in lib/src/app.dart
Future<Widget> buildTestApp(WidgetTester tester, {required Widget home}) async {
  await tester.binding.setSurfaceSize(kTestSurfaceSize);
  return MediaQuery(
    data: const MediaQueryData(size: kTestSurfaceSize),
    child: Center(
      child: SizedBox(
        width: _kTestScreenWidth,
        height: _kTestScreenHeight,
        child: MaterialApp(
          useInheritedMediaQuery: true,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: home,
          builder: (context, child) {
            return CupertinoTheme(
              data: const CupertinoThemeData(),
              child: Material(child: child),
            );
          },
        ),
      ),
    ),
  );
}
// --

class _SameRequest extends Matcher {
  const _SameRequest(this._expected);

  final http.BaseRequest _expected;

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is http.BaseRequest &&
      item.method == _expected.method &&
      item.url == _expected.url;
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

Future<T> _withDelay<T>(
  T value, {
  Duration delay = const Duration(milliseconds: 10),
}) =>
    Future<void>.delayed(delay).then((_) => value);
