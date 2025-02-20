import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';

class FakeSoundService implements SoundService {
  @override
  Future<void> play(Sound sound) async {}

  @override
  Future<void> changeTheme(SoundTheme theme, {bool playSound = false}) async {}

  @override
  Future<void> release() async {}
}
