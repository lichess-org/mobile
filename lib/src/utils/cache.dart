import 'package:clock/clock.dart';

// Code adapted from: https://github.com/gokberkbar/memory_cache/blob/main/lib/src/cache.dart

/// A simple and fast in-memory cache with expiration support.
class MemoryCache<K, V> {
  /// Creates a new instance of [MemoryCache].
  ///
  /// [defaultExpiry] is the default expiry duration for cache items.
  MemoryCache({required this.defaultExpiry});

  /// The default expiry duration for cache items.
  final Duration defaultExpiry;

  final Map<K, CacheItem<V>> _cache = {};

  /// Checks if cache is empty.
  bool get isEmpty {
    _cache.removeWhere((key, value) => _isExpired(value));
    return _cache.isEmpty;
  }

  /// Checks if cache is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The keys of the cache.
  Iterable<K> get keys => _cache.keys.where((key) => !_isExpired(_cache[key]!));

  /// If cache contains a value for the [key], returns the value.
  V? read(K key) {
    if (_expiryAwareContains(key)) {
      final item = _cache[key]!;
      return item.value;
    }
    return null;
  }

  V? operator [](K key) => read(key);

  /// Sets the [value] to the cache.
  ///
  /// If cache contains a value for the [key], overrides the value in the cache.
  void add(K key, V value, {Duration? expiry}) {
    _cache[key] = CacheItem<V>.create(value, expiry: _setExpiry(expiry));
  }

  void operator []=(K key, V value) {
    add(key, value);
  }

  /// Look up the value of [key], or add a new entry if it isn't there.
  ///
  /// Returns the value associated to [key], if there is one. Otherwise calls [ifAbsent] to compute the value, adds it to the cache, and returns it.
  V putIfAbsent(K key, V Function() ifAbsent, {Duration? expiry}) {
    if (_expiryAwareContains(key)) {
      final item = _cache[key]!;
      return item.value;
    } else {
      final value = ifAbsent();
      add(key, value, expiry: expiry);
      return value;
    }
  }

  /// Removes value from cache.
  void remove(K key) {
    _cache.remove(key);
  }

  /// Invalidates all cached values.
  void invalidate() {
    _cache.clear();
  }

  /// Returns true if cached value exists.
  bool contains(K key) {
    return _expiryAwareContains(key);
  }

  DateTime? _setExpiry(Duration? expiry) =>
      expiry != null ? clock.now().add(expiry) : clock.now().add(defaultExpiry);

  /// Checks if [item] is expired.
  bool _isExpired(CacheItem<V> item) {
    if (item.expiry != null && item.expiry!.isBefore(clock.now())) {
      return true;
    }
    return false;
  }

  /// Returns true if cached value exists but not expired.
  ///
  /// If cached value expired removes from cache.
  bool _expiryAwareContains(K key) {
    final item = _cache[key];
    if (item == null) {
      return false;
    } else if (_isExpired(item)) {
      remove(key);
      return false;
    }
    return true;
  }
}

class CacheItem<T> {
  final DateTime createdAt;
  final DateTime? expiry;
  final T value;

  const CacheItem({required this.createdAt, this.expiry, required this.value});

  factory CacheItem.create(T value, {DateTime? expiry}) =>
      CacheItem(createdAt: clock.now(), expiry: expiry, value: value);

  CacheItem<T> copyWith({DateTime? createdAt, DateTime? expiry, T? value}) {
    return CacheItem<T>(
      createdAt: createdAt ?? this.createdAt,
      expiry: expiry ?? this.expiry,
      value: value ?? this.value,
    );
  }
}
