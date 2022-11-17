import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import 'constants.dart';
import 'routing.dart';

/// App main widget that shows the BottomNavigationBar and performs navigation between tabs
class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<AppScaffold> {
  late int _currentIndex;

  final _routerDelegates = [
    BeamerDelegate(
      initialPath: '/puzzles',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('puzzles')) {
          return PuzzlesLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/watch',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('watch')) {
          return WatchLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uriString = Beamer.of(context).configuration.location!;
    _currentIndex = uriString.contains('puzzles') ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Beamer(
            routerDelegate: _routerDelegates[0],
          ),
          Beamer(
            routerDelegate: _routerDelegates[1],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: kOrange,
        items: const [
          BottomNavigationBarItem(label: 'Puzzles', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Watch', icon: Icon(Icons.live_tv)),
        ],
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
            _routerDelegates[_currentIndex].update(rebuild: false);
          }
        },
      ),
    );
  }
}
