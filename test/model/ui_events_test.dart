import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/ui_events.dart';

void main() {
  group('UiEventBus', () {
    test('emit drops the event and returns false with no listener', () {
      final bus = UiEventBus();
      addTearDown(bus.close);

      expect(bus.hasListeners, isFalse);
      expect(bus.emit(const ShowErrorEvent('x')), isFalse);
    });

    test('emit delivers the event and returns true with a listener', () async {
      final bus = UiEventBus();
      addTearDown(bus.close);

      final received = bus.stream.first;
      expect(bus.hasListeners, isTrue);
      expect(bus.emit(const ShowErrorEvent('x')), isTrue);
      expect(await received, isA<ShowErrorEvent>());
    });

    test('emit returns false after close', () {
      final bus = UiEventBus()..close();

      expect(bus.emit(const ShowErrorEvent('x')), isFalse);
    });
  });
}
