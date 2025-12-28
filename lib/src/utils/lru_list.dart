import 'dart:collection';

/// A simple LRU (Least Recently Used) list implementation
///
/// The items are ordered by their insertion time, with the most recently added item at the end.
/// If the list exceeds its capacity when extended via [put], the least recently added item is removed.
class LRUList<T> {
  final int capacity;
  final LinkedList<_LRUListEntry<T>> _list = LinkedList<_LRUListEntry<T>>();

  LRUList({required this.capacity});

  /// Add the [value] to the end of the list. If the list exceeds its capacity, the least recently used item is removed.
  void put(T value) {
    if (_list.length >= capacity) {
      _list.first.unlink();
    }
    _list.add(_LRUListEntry<T>(value));
  }

  void clear() {
    _list.clear();
  }

  /// The values in the list, ordered from least recently used to most recently used.
  Iterable<T> get values => _list.map((entry) => entry.value);
}

final class _LRUListEntry<T> extends LinkedListEntry<_LRUListEntry<T>> {
  final T value;

  _LRUListEntry(this.value);
}
