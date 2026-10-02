import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../modules/modules.dart';
import '../system.dart';

void lichessTest(
  String description,
  Future<void> Function(PatrolIntegrationTester, Modules, System) callback, {
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
  PatrolTesterConfig config = const PatrolTesterConfig(printLogs: true),
  PlatformAutomatorConfig? platformAutomatorConfig,
  LiveTestWidgetsFlutterBindingFramePolicy framePolicy =
      LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
}) {
  patrolTest(
    description,
    ($) async {
      final modules = Modules($);
      final system = System(
        config: platformAutomatorConfig ?? PlatformAutomatorConfig.defaultConfig(),
      );
      await callback($, modules, system);
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
    config: config,
    framePolicy: framePolicy,
  );
}
