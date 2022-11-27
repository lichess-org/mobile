import 'package:flutter/material.dart';

class TimeControlModal extends StatelessWidget {
  const TimeControlModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time control')),
      body: const Center(child: Text('Todo')),
    );
  }
}
