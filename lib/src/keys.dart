import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';

class const _TabScaffoldKey(String value) extends ValueKey<String> {
  this : super('tabScaffold_$value');
}

class TabScaffoldKeys() {
  _TabScaffoldKey tabIcon(BottomTab tab) => _TabScaffoldKey('tabIcon_${tab.name}');
}
