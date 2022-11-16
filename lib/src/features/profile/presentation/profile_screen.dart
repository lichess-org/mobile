import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './profile_screen_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () {
                  ref.read(profileScreenControllerProvider.notifier).signOut();
                  Navigator.of(context).pop();
                },
          child: const Text('Sign out'),
        ),
      ),
    );
  }
}
