import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/authentication/data/auth_repository.dart';
import 'features/authentication/presentation/auth_widget.dart';

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
        appBar: AppBar(title: const Text('lichess.org'), actions: const [
          AuthWidget(),
        ]),
        body: Center(child: Consumer(builder: (_, WidgetRef ref, __) {
          final authState = ref.watch(authStateChangesProvider);
          return authState.maybeWhen(
            data: (account) =>
                account != null ? Text('Hello, ${account.username}') : const Text('Hello'),
            orElse: () => const CircularProgressIndicator(),
          );
        })),
      ),
    );
  }
}
