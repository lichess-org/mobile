import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/sound_service.dart';
import 'package:lichess_mobile/src/model/account/account_providers.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';

part 'app_dependencies.freezed.dart';
part 'app_dependencies.g.dart';

@Riverpod(keepAlive: true)
Future<AppDependencies> appDependencies(
  AppDependenciesRef ref,
) async {
  final sessionStorage = ref.watch(sessionStorageProvider);
  final pInfo = await PackageInfo.fromPlatform();
  final prefs = await SharedPreferences.getInstance();
  final pool = Soundpool.fromOptions();
  final sounds = await loadSounds(pool);

  ref.onDispose(pool.release);

  final accountRepository = ref.watch(accountRepositoryProvider);
  final storedSession = await sessionStorage.read();
  if (storedSession != null) {
    await accountRepository.getProfile().match(
      onError: (err, _) {
        if (err is UnauthorizedException) {
          sessionStorage.delete();
        }
      },
    );
  }

  return AppDependencies(
    packageInfo: pInfo,
    sharedPreferences: prefs,
    soundPool: pool,
    sounds: sounds,
    userSession: await sessionStorage.read(),
  );
}

@freezed
class AppDependencies with _$AppDependencies {
  const factory AppDependencies({
    required PackageInfo packageInfo,
    required SharedPreferences sharedPreferences,
    required Soundpool soundPool,
    required IMap<Sound, int> sounds,
    required UserSession? userSession,
  }) = _AppDependencies;
}
