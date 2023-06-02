import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/sound_theme.dart';

class FakeSoundService implements SoundService {
  @override
  void play(Sound sound) {}

  @override
  Future<void> changeTheme(SoundTheme theme, {bool playSound = false}) async {}
}
