import 'package:lichess_mobile/src/model/common/service/sound_service.dart';

class FakeSoundService implements SoundService {
  @override
  void playCapture() {}

  @override
  void playDong() {}

  @override
  void playMove() {}

  @override
  void play(Sound sound) {}
}
