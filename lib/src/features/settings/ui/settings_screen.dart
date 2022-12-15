import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';

import '../../../constants.dart';
import '../../auth/data/auth_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          authState.maybeWhen(
            data: (account) => account != null
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: account.patron == true
                                  ? const Icon(LichessIcons.patron, size: 40)
                                  : const Icon(Icons.person, size: 40),
                              title: Text(account.username),
                              subtitle: account.profile != null
                                  ? Location(profile: account.profile!)
                                  : kEmptyWidget,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(context.l10n.profile),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            orElse: () => const CircularProgressIndicator.adaptive(),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.brightness_medium),
            title: Text(context.l10n.background),
            onTap: () {
              context.go('/settings/themeMode');
            },
          ),
        ],
      ),
    );
  }
}

class Location extends StatelessWidget {
  const Location({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      profile.country != null
          ? CachedNetworkImage(
              imageUrl: lichessFlagSrc(profile.country!),
              errorWidget: (_, __, ___) => kEmptyWidget,
            )
          : kEmptyWidget,
      const SizedBox(width: 10),
      Text(profile.location ?? ''),
    ]);
  }
}

String lichessFlagSrc(String country) {
  return '$kLichessHost/assets/images/flags/$country.png';
}
