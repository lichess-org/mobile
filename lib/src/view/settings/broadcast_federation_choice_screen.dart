import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_federation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:material_ui/material_ui.dart';

/// A screen to choose the favorite federation, whose games are shown first in broadcast rounds.
class const BroadcastFederationChoiceScreen({super.key}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const BroadcastFederationChoiceScreen());
  }

  @override
  ConsumerState<BroadcastFederationChoiceScreen> createState() =>
      _BroadcastFederationChoiceScreenState();
}

class _BroadcastFederationChoiceScreenState()
    extends ConsumerState<BroadcastFederationChoiceScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _choose(FederationId? federation) async {
    try {
      await ref.read(accountPreferencesProvider.notifier).setFavoriteFederation(federation);
    } catch (_) {
      if (mounted) {
        showSnackBar(context, 'Could not save the favorite federation', type: SnackBarType.error);
      }
      return;
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final currentFederation = ref.watch(
      accountPreferencesProvider.select((prefs) => prefs.value?.favoriteFederation),
    );

    final query = _searchQuery.trim().toLowerCase();
    final federations = [
      for (final MapEntry(key: code, value: name) in federationIdToName.entries)
        if (query.isEmpty ||
            name.toLowerCase().contains(query) ||
            code.toLowerCase().contains(query))
          FederationId.fromCode(code),
    ];

    final searchBar = PlatformSearchBar(
      controller: _searchController,
      hintText: context.l10n.search,
      // On iOS, in the app bar, sticking below its buttons.
      inAppBar: isIOS,
      onChanged: (value) => setState(() => _searchQuery = value),
      onClear: () {
        _searchController.clear();
        setState(() => _searchQuery = '');
      },
    );
    const leadingSize = 32.0;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Favorite federation'),
        bottom: isIOS
            ? PreferredSize(
                preferredSize: Size.fromHeight(kGlassAppBarBottomPadding.vertical + 44.0),
                child: Padding(padding: kGlassAppBarBottomPadding, child: searchBar),
              )
            : null,
      ),
      body: ListView(
        children: [
          if (!isIOS)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: searchBar,
            ),
          if (federations.isEmpty)
            Padding(
              padding: Styles.bodyPadding,
              child: Center(
                child: Text(context.l10n.mobileNoSearchResults, style: Styles.noResultTextStyle),
              ),
            )
          else ...[
            if (query.isEmpty)
              ListTile(
                leading: const SizedBox.square(
                  dimension: leadingSize,
                  child: Center(child: Icon(Icons.public, size: 28)),
                ),
                title: Text(context.l10n.none),
                trailing: currentFederation == null ? const Icon(Icons.check) : null,
                onTap: () => _choose(null),
              ),
            for (final federation in federations)
              ListTile(
                leading: SizedBox.square(
                  dimension: leadingSize,
                  child: Center(child: Image.asset(federation.flagAsset, width: 24)),
                ),
                title: Text(federation.name),
                subtitle: Text(federation.value),
                trailing: federation == currentFederation ? const Icon(Icons.check) : null,
                onTap: () => _choose(federation),
              ),
          ],
        ],
      ),
    );
  }
}
