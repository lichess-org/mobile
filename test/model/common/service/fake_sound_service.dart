import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/sound_theme.dart';

class FakeSoundService implements SoundService {
  @override
  Future<int?> play(Sound sound) async {
    return null;
  }

  @override
  Future<void> stopCurrent() async {}

  @override
  Future<void> changeTheme(SoundTheme theme, {bool playSound = false}) async {}
}
