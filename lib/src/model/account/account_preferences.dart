import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';

import 'account_repository.dart';

part 'account_preferences.g.dart';

typedef AccountPreferences = ({
  AutoQueen autoQueen,
});

/// Get the account preferences for the current user.
///
/// The result is cached for the lifetime of the app.
/// If the server returns an error, default values are returned.
@Riverpod(keepAlive: true)
Future<AccountPreferences?> accountPreferences(
  AccountPreferencesRef ref,
) async {
  final session = ref.watch(authSessionProvider);
  final repo = ref.watch(accountRepositoryProvider);

  if (session == null) {
    return null;
  }

  return repo.getPreferences().fold(
        (value) => value,
        (_, __) => (autoQueen: AutoQueen.premove),
      );
}

enum AutoQueen {
  never,
  premove,
  always;

  String label(BuildContext context) {
    switch (this) {
      case AutoQueen.never:
        return context.l10n.never;
      case AutoQueen.premove:
        return context.l10n.preferencesWhenPremoving;
      case AutoQueen.always:
        return context.l10n.always;
    }
  }

  static AutoQueen fromInt(int value) {
    switch (value) {
      case 1:
        return AutoQueen.never;
      case 2:
        return AutoQueen.premove;
      case 3:
        return AutoQueen.always;
      default:
        throw Exception('Invalid value for AutoQueen');
    }
  }
}
