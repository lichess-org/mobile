import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';

class GifExportScreen extends StatelessWidget {
  const GifExportScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const GifExportScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export GIF')),
      body: const Center(child: Text('Options here')),
    );
  }
}
