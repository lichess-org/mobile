import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PreferencesStorage');

abstract class Serializable {
  Map<String, dynamic> toJson();
}

/// A preference category with its storage key
enum PrefCategory {
  general('preferences.general'),
  home('preferences.home'),
  board('preferences.board'),
  analysis('preferences.analysis'),
  study('preferences.study'),
  overTheBoard('preferences.overTheBoard'),
  challenge('preferences.challenge'),
  gameSetup('preferences.gameSetup'),
  game('preferences.game'),
  coordinateTraining('preferences.coordinateTraining'),
  openingExplorer('preferences.opening_explorer'),
  gameHistory('preferences.gameHistory'),
  puzzle('preferences.puzzle'),
  broadcast('preferences.broadcast');

  const PrefCategory(this.storageKey);

  final String storageKey;
}

/// A [Notifier] mixin to provide a way to store and retrieve preferences.
mixin PreferencesStorage<T extends Serializable> on Notifier<T> {
  T fromJson(Map<String, dynamic> json);
  T get defaults;

  PrefCategory get prefCategory;

  Future<void> save(T value) async {
    await LichessBinding.instance.sharedPreferences.setString(
      prefCategory.storageKey,
      jsonEncode(value.toJson()),
    );

    state = value;
  }

  T fetch() {
    final stored = LichessBinding.instance.sharedPreferences.getString(prefCategory.storageKey);
    if (stored == null) {
      return defaults;
    }
    try {
      return fromJson(jsonDecode(stored) as Map<String, dynamic>);
    } catch (e) {
      _logger.warning('Failed to decode $prefCategory preferences: $e');
      return defaults;
    }
  }
}

/// A [Notifier] mixin to provide a way to store and retrieve preferences per session.
mixin SessionPreferencesStorage<T extends Serializable> on Notifier<T> {
  T fromJson(Map<String, dynamic> json);
  T defaults({LightUser? user});

  PrefCategory get prefCategory;

  Future<void> save(T value) async {
    final session = ref.read(authSessionProvider);
    await LichessBinding.instance.sharedPreferences.setString(
      key(prefCategory.storageKey, session),
      jsonEncode(value.toJson()),
    );

    state = value;
  }

  T fetch() {
    final session = ref.watch(authSessionProvider);
    final stored = LichessBinding.instance.sharedPreferences.getString(
      key(prefCategory.storageKey, session),
    );
    if (stored == null) {
      return defaults(user: session?.user);
    }
    try {
      return fromJson(jsonDecode(stored) as Map<String, dynamic>);
    } catch (e) {
      _logger.warning('Failed to decode $prefCategory preferences: $e');
      return defaults(user: session?.user);
    }
  }

  static String key(String key, AuthSessionState? session) =>
      '$key.${session?.user.id ?? '**anon**'}';
}
