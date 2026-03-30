import 'dart:async';

import 'package:lichess_mobile/src/home_widget_service.dart';

class FakeHomeWidgetClient implements HomeWidgetClient {
  final StreamController<Uri?> _widgetClickedController = StreamController<Uri?>.broadcast();
  final Map<String, Object?> savedData = {};
  Uri? initialLaunchUri;
  int updateWidgetCalls = 0;
  ({String? name, String? androidName, String? iOSName, String? qualifiedAndroidName})?
  lastUpdateWidgetCall;

  @override
  Stream<Uri?> get widgetClicked => _widgetClickedController.stream;

  @override
  Future<Uri?> initiallyLaunchedFromHomeWidget() async {
    return initialLaunchUri;
  }

  @override
  Future<bool?> saveWidgetData(String id, Object? data) async {
    savedData[id] = data;
    return true;
  }

  @override
  Future<bool?> updateWidget({
    String? name,
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  }) async {
    updateWidgetCalls++;
    lastUpdateWidgetCall = (
      name: name,
      androidName: androidName,
      iOSName: iOSName,
      qualifiedAndroidName: qualifiedAndroidName,
    );
    return true;
  }

  void emitClick(Uri? uri) {
    _widgetClickedController.add(uri);
  }

  Future<void> dispose() async {
    await _widgetClickedController.close();
  }
}
