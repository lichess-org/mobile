import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/sound.dart';

class FakeSoundService implements SoundService {
  @override
  void playCapture() {}

  @override
  void playDong() {}

  @override
  void playMove() {}

  @override
  void play(Sound sound) {}

  @override
  Future<void> changeTheme(SoundTheme theme, {bool playSound = false}) async {}
}
