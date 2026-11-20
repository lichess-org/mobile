import 'package:flutter_test/flutter_test.dart';

import 'fake_notification_display.dart';

void main() {
  test('records a cancel for a notification the app never showed', () async {
    final display = FakeNotificationDisplay();

    await display.cancel(id: 42);

    expect(display.cancelCalls, [42]);
    expect(await display.getActiveNotifications(), isEmpty);
  });
}
