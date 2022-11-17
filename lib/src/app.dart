import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:beamer/beamer.dart';

import 'constants.dart';
import 'routing.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routerDelegate = BeamerDelegate(
    initialPath: '/tab/puzzles',
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        TabsLocation(),
        ProfileLocation(),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: 'app',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      onGenerateTitle: (BuildContext context) => 'lichess.org',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: routerDelegate,
      ),
    );
  }
}
