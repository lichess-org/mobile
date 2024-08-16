import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_boards_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_overview_tab.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class BroadcastScreen extends StatelessWidget {
  final Broadcast broadcast;

  const BroadcastScreen({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _CupertinoBody(broadcast: broadcast),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return _AndroidBody(broadcast: broadcast);
  }
}

class _AndroidBody extends StatefulWidget {
  final Broadcast broadcast;

  const _AndroidBody({required this.broadcast});

  @override
  State<_AndroidBody> createState() => _AndroidBodyState();
}

class _AndroidBodyState extends State<_AndroidBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.broadcast.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Overview'),
            Tab(text: 'Boards'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: Styles.bodyPadding,
              child: BroadcastOverviewTab(widget.broadcast),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: Styles.bodyPadding,
              child: BroadcastBoardsTab(widget.broadcast.roundToLinkId),
            ),
          ),
        ],
      ),
    );
  }
}

class _CupertinoBody extends StatefulWidget {
  final Broadcast broadcast;

  const _CupertinoBody({required this.broadcast});

  @override
  _CupertinoBodyState createState() => _CupertinoBodyState();
}

enum _ViewMode { overview, boards }

class _CupertinoBodyState extends State<_CupertinoBody> {
  _ViewMode _selectedSegment = _ViewMode.boards;

  void setViewMode(_ViewMode mode) {
    setState(() {
      _selectedSegment = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: Styles.bodyPadding,
            child: CupertinoSlidingSegmentedControl<_ViewMode>(
              groupValue: _selectedSegment,
              children: const {
                _ViewMode.overview: Text('Overview'),
                _ViewMode.boards: Text('Boards'),
              },
              onValueChanged: (_ViewMode? view) {
                if (view != null) {
                  setState(() {
                    _selectedSegment = view;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: _selectedSegment == _ViewMode.overview
                ? BroadcastOverviewTab(widget.broadcast)
                : BroadcastBoardsTab(widget.broadcast.roundToLinkId),
          ),
        ],
      ),
    );
  }
}
