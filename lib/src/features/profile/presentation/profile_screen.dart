import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beamer/beamer.dart';

import './profile_screen_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      ref.read(profileScreenControllerProvider.notifier).signOut();
                      Navigator.of(context).pop();
                    },
              child: const Text('Sign out'),
            ),
            ElevatedButton(
              onPressed: () {
                Beamer.of(context, root: true).beamToNamed('/profile/inside');
              },
              child: const Text('Test push route'),
            ),
          ],
        ),
      ),
    );
  }
}

class InsideProfile extends StatelessWidget {
  const InsideProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inside profile'),
      ),
      body: const Center(child: Text('TODO')),
    );
  }
}
