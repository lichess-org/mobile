import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
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
  gameSeeks('preferences.gameSeeks'),
  game('preferences.game'),
  coordinateTraining('preferences.coordinateTraining'),
  openingExplorer('preferences.opening_explorer'),
  gameHistory('preferences.gameHistory'),
  puzzle('preferences.puzzle'),
  broadcast('preferences.broadcast'),
  engineEvaluation('preferences.engineEvaluation');

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

/// A [Notifier] mixin to provide a way to store and retrieve preferences per authUser.
mixin SessionPreferencesStorage<T extends Serializable> on Notifier<T> {
  T fromJson(Map<String, dynamic> json);
  T defaults({LightUser? user});

  PrefCategory get prefCategory;

  Future<void> save(T value) async {
    final authUser = ref.read(authControllerProvider);
    await LichessBinding.instance.sharedPreferences.setString(
      key(prefCategory.storageKey, authUser),
      jsonEncode(value.toJson()),
    );

    state = value;
  }

  T fetch() {
    final authUser = ref.watch(authControllerProvider);
    final stored = LichessBinding.instance.sharedPreferences.getString(
      key(prefCategory.storageKey, authUser),
    );
    if (stored == null) {
      return defaults(user: authUser?.user);
    }
    try {
      return fromJson(jsonDecode(stored) as Map<String, dynamic>);
    } catch (e) {
      _logger.warning('Failed to decode $prefCategory preferences: $e');
      return defaults(user: authUser?.user);
    }
  }

  static String key(String key, AuthUser? authUser) => '$key.${authUser?.user.id ?? '**anon**'}';
}
