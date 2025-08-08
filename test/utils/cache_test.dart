import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/utils/cache.dart';

void main() {
  const key = 'key0';
  const value = 'value0';

  final MemoryCache<String, String> memoryCache = MemoryCache(
    defaultExpiry: const Duration(seconds: 1),
  );

  setUp(() {
    memoryCache.invalidate();
    memoryCache.add(key, value);
  });

  test('is item created', () {
    expect(memoryCache.contains(key), true);
  });

  test('read item', () {
    final cachedValue = memoryCache.read(key);
    expect(cachedValue, value);
  });

  test('add if item is absent', () {
    const newValue = 'value1';
    fakeAsync((async) {
      async.elapse(const Duration(milliseconds: 500));
      // doesn't update the expiry time since the item is already present
      memoryCache.putIfAbsent(key, () => newValue);
      expect(memoryCache.read(key), value);
      async.elapse(const Duration(seconds: 500));
      // now the item is expired
      expect(memoryCache.contains(key), false);
    });
  });

  test('delete item', () {
    memoryCache.remove(key);
    expect(memoryCache.contains(key), false);
  });

  test('expire item', () {
    fakeAsync((async) {
      memoryCache.add(key, value);
      expect(memoryCache.contains(key), true);
      async.elapse(const Duration(seconds: 2));
      expect(memoryCache.contains(key), false);
    });
  });

  test('putIfAbsent test on expired item', () {
    fakeAsync((async) {
      memoryCache.add(key, value);
      expect(memoryCache.contains(key), true);
      async.elapse(const Duration(seconds: 2));
      expect(memoryCache.contains(key), false);
      final newValue = memoryCache.putIfAbsent(key, () => 'value1');
      expect(newValue, 'value1');
    });
  });

  test('re-add item with custom new expiry', () {
    const newKey = 'newKey';
    const item = 'item';
    const newItem = 'newItem';

    fakeAsync((async) {
      memoryCache.add(newKey, item);
      expect(memoryCache.contains(newKey), true);
      async.elapse(const Duration(seconds: 2));
      expect(memoryCache.contains(newKey), false);
      memoryCache.add(newKey, newItem, expiry: const Duration(seconds: 5));
      expect(memoryCache.contains(newKey), true);
      async.elapse(const Duration(seconds: 3));
      expect(memoryCache.contains(newKey), true);
      async.elapse(const Duration(seconds: 3));
      expect(memoryCache.contains(newKey), false);
    });
  });

  test('check if cache is empty', () {
    memoryCache.invalidate();
    expect(memoryCache.isEmpty, true);
  });
}
