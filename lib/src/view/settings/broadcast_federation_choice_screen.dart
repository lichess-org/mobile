import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_federation.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:material_ui/material_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    final currentFederation = ref.watch(
      broadcastPreferencesProvider.select((p) => p.broadcastFederationCode),
    );

    final trimmedQuery = _searchQuery.trim().toLowerCase();

    final filteredFederations = trimmedQuery.isEmpty
        ? federationIdToName.entries.toList()
        : federationIdToName.entries.where((entry) {
            return entry.value.toLowerCase().contains(trimmedQuery) ||
                entry.key.toLowerCase().contains(trimmedQuery);
          }).toList();
    const leadingSize = 32.0;
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.broadcastFederation)),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: Styles.bodyPadding,
              child: PlatformSearchBar(
                controller: _searchController,
                hintText: context.l10n.search,
                onChanged: (value) => setState(() => _searchQuery = value),
                onClear: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              ),
            ),
            Expanded(
              child: filteredFederations.isEmpty && trimmedQuery.isNotEmpty
                  ? Center(
                      child: Text(
                        context.l10n.mobileNoSearchResults,
                        style: Styles.noResultTextStyle,
                      ),
                    )
                  : ListView.separated(
                      itemCount: (trimmedQuery.isEmpty ? 1 : 0) + filteredFederations.length,
                      separatorBuilder: (_, _) => Theme.of(context).platform == .iOS
                          ? const PlatformDivider()
                          : const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        if (trimmedQuery.isEmpty && index == 0) {
                          final isSelected = currentFederation == null;
                          return ListTile(
                            leading: const SizedBox.square(
                              dimension: leadingSize,
                              child: Center(child: Icon(Icons.public, size: 28)),
                            ),
                            title: Text(context.l10n.none),
                            selected: isSelected,
                            trailing: isSelected ? const Icon(Icons.check) : null,
                            onTap: () async {
                              await ref
                                  .read(broadcastPreferencesProvider.notifier)
                                  .setBroadcastFederation(null);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          );
                        }

                        final fedIndex = trimmedQuery.isEmpty ? index - 1 : index;
                        final fed = filteredFederations[fedIndex];
                        final fedId = FederationId.fromCode(fed.key);
                        final isSelected = fedId == currentFederation;

                        return ListTile(
                          leading: SizedBox.square(
                            dimension: leadingSize,
                            child: Center(child: Image.asset(fedId.flagAsset, width: 24)),
                          ),
                          title: Text(fed.value),
                          subtitle: Text(fed.key),
                          selected: isSelected,
                          trailing: isSelected ? const Icon(Icons.check) : null,
                          onTap: () async {
                            await ref
                                .read(broadcastPreferencesProvider.notifier)
                                .setBroadcastFederation(fedId);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
