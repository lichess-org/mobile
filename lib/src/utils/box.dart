/// Utility for nullable fields in copyWith methods
class Box<T> {
  const Box(this.value);
  final T value;
}
