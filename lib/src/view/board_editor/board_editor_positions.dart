import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/model/board_editor/position.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';

class BoardEditorPositionsScreen extends StatelessWidget {
  const BoardEditorPositionsScreen({required this.onPositionSelected, super.key});

  final void Function(Position position) onPositionSelected;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required void Function(Position position) onPositionSelected,
  }) {
    return buildScreenRoute(
      context,
      screen: BoardEditorPositionsScreen(onPositionSelected: onPositionSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      tabs: [
        Tab(text: context.l10n.openings),
        Tab(text: context.l10n.endgamePositions),
      ],
    );
    final tabBarView = TabBarView(
      children: [
        _OpeningsTab(onPositionSelected: onPositionSelected),
        _EndGamesTab(onPositionSelected: onPositionSelected),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.loadPosition), bottom: tabBar),
        body: tabBarView,
      ),
    );
  }
}

class _OpeningsTab extends StatefulWidget {
  const _OpeningsTab({required this.onPositionSelected});

  final void Function(Position position) onPositionSelected;

  @override
  State<_OpeningsTab> createState() => _OpeningsTabState();
}

class _OpeningsTabState extends State<_OpeningsTab> {
  late final Future<List<Position>>? _openings;

  @override
  void initState() {
    _openings = rootBundle.loadString('assets/positions.json').then((s) {
      final List<Position> result = [];
      for (final opening in (jsonDecode(s) as List<dynamic>).cast<Map<String, dynamic>>()) {
        for (final position
            in (opening['positions'] as List<dynamic>).cast<Map<String, dynamic>>()) {
          result.add(Position.fromJson(position));
        }
      }
      return result;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _openings,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final position = snapshot.data![index];
            return ListTile(
              title: Text(position.name),
              onTap: () => widget.onPositionSelected(position),
            );
          },
        );
      },
    );
  }
}

class _EndGamesTab extends StatefulWidget {
  const _EndGamesTab({required this.onPositionSelected});

  final void Function(Position position) onPositionSelected;

  @override
  State<_EndGamesTab> createState() => _EndGamesTabState();
}

class _EndGamesTabState extends State<_EndGamesTab> {
  late final Future<List<Position>>? _endGames;

  @override
  void initState() {
    _endGames = rootBundle.loadString('assets/endgames.json').then((s) {
      final List<Position> result = [];
      for (final position in (jsonDecode(s) as List<dynamic>).cast<Map<String, dynamic>>()) {
        result.add(Position.fromJson(position));
      }
      return result;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _endGames,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final position = snapshot.data![index];
            return ListTile(
              title: Text(position.name),
              onTap: () => widget.onPositionSelected(position),
            );
          },
        );
      },
    );
  }
}
