import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/settings/user_screen_preferences.dart';

class PerfReorderable extends ConsumerStatefulWidget {
  const PerfReorderable({super.key, required this.onChange});
  final void Function(List<Perf>) onChange;

  @override
  ConsumerState<PerfReorderable> createState() => _PerfReorderableState();
}

class _PerfReorderableState extends ConsumerState<PerfReorderable> {
  final List<Perf> newList = [];

  @override
  Widget build(BuildContext context) {
    if (newList.isEmpty) {
      newList.addAll(ref.watch(userScreenPreferencesProvider).perfOrder);
    }

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        for (int i = 0; i < newList.length; i++)
          ListTile(
            key: Key('$i'),
            leading: Icon(newList[i].icon),
            title: Text(newList[i].title),
            trailing: const Icon(Icons.drag_indicator),
          )
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex--;
          }
          final Perf item = newList.removeAt(oldIndex);
          newList.insert(newIndex, item);

          widget.onChange(newList);
        });
      },
    );
  }
}
