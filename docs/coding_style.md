# Coding style

## Immutability

Immutability is when all fields of an Object are final or late final. They are set exactly once upon construction.

Immutability is required everywhere in the project, except where it makes no sense to use it, for performance or other practical reason, in that case mutability must be contained to a function scope and the exposed API must be immutable.

To understand why immutability is important, [riverpod has a good documentation about it](https://docs-v2.riverpod.dev/docs/concepts/why_immutability).

Dart supports immutability with some caveats. The main one is that core collections are *not* immutable.

- Use [freezed](https://pub.dev/packages/freezed) to create data classes
- Use [fast_immutable_collections](https://pub.dev/packages/fast_immutable_collections/install)
- Standard dart collections (mutable API) usage is forbidden in public API (no `List`, `Map`, etc. in function signatures) but authorised in local scope

## Strong typing

Strong typing is preferred wherever possible. Prefer using a `Duration` instead of an `int`, etc.

## Functional programming

In this project functional programming is encouraged over the imperative style. This often goes well with immutability and makes the code more readable, especially when writing UI code.

Don't do:
```dart
final List<Widget> widgets = [];
if (check) {
  widgets.add(Text('I\'m here if check is true'));
}
for (el in myStuff) {
  widgets.add(Text(el.name));
}
return widgets;
```

Prefer `collection if` and `collection for`:
```dart
return [
  if (check)
    Text('I\'m here if check is true');
  for (el in myStuff)
    Text(el.name);
];
```

## Writing UI code

Here is a list of practical tips when writing widgets. These are generally coding best practices in flutter, and serve to keep the project consistent.

### Avoid imperative style

Check the [functional programming section](#functional-programming).

### Avoid writing functions to return widgets

Official explanation: https://stackoverflow.com/questions/53234825/what-is-the-difference-between-functions-and-classes-to-create-reusable-widgets

It is OK for private functions that are used only once, and of course for widgets that accepts `builder` as param.

In general it is good to respect these rules:

- don't write a private function (or private class) for a widget that is used only once, just write it directly
- write a `StatelessWidget` for a reusable widget, even if it's scope is limited to a single screen
