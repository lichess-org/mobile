import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      onGenerateTitle: (BuildContext context) => 'lichess.org',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('lichess.org')),
        body: const Center(
          child: Text('coucou'),
        ),
      ),
    );
  }
}
