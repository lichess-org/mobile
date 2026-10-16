import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/coach/coach_filter.dart';
import 'package:lichess_mobile/src/model/coach/coach_list_controller.dart';
import 'package:lichess_mobile/src/model/coach/coach_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/coach/coach_list_tile.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

class const CoachListScreen({super.key}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const CoachListScreen());
  }

  @override
  ConsumerState<CoachListScreen> createState() => _CoachListScreenState();
}

class _CoachListScreenState() extends ConsumerState<CoachListScreen> {
  String language = kAllCoachesFilter;
  String country = kAllCoachesFilter;
  CoachOrder order = CoachOrder.login;

  final _scrollController = ScrollController();
  bool requestedNextPage = false;

  CoachFilters get _filters => (language: language, country: country, order: order);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!requestedNextPage &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final page = ref.read(coachListControllerProvider(_filters));

      if (!page.isLoading) {
        setState(() {
          requestedNextPage = true;
        });

        ref.read(coachListControllerProvider(_filters).notifier).next();
      }
    }
  }

  void _openFilterSheet(CoachListPage? page) {
    var newLanguage = language;
    var newCountry = country;
    var newOrder = order;

    final languages = [kAllCoachesFilter, ...?page?.languages];
    final countries = [
      CoachFilterOption(code: kAllCoachesFilter, name: context.l10n.coachAllCountries),
      ...?page?.countries,
    ];

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => BottomSheetScrollableContainer(
          padding: const EdgeInsets.all(16.0),
          children: [
            Filter<CoachOrder>(
              filterName: context.l10n.mobileSortBy,
              filterType: FilterType.singleChoice,
              choices: CoachOrder.values,
              choiceSelected: (choice) => newOrder == choice,
              choiceLabel: (choice) => Text(choice.l10n(context.l10n)),
              onSelected: (value, selected) {
                if (selected) {
                  setSheetState(() => newOrder = value);
                }
              },
            ),
            const SizedBox(height: 16.0),
            Text(context.l10n.language, style: const TextStyle(fontSize: 18)),
            RadioGroup<String>(
              groupValue: newLanguage,
              onChanged: (value) {
                if (value != null) {
                  setSheetState(() => newLanguage = value);
                }
              },
              child: Column(
                children: [
                  for (final code in languages)
                    RadioListTile<String>(
                      title: Text(
                        code == kAllCoachesFilter ? context.l10n.allLanguages : languageName(code),
                      ),
                      value: code,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Text(context.l10n.countryRegion, style: const TextStyle(fontSize: 18)),
            RadioGroup<String>(
              groupValue: newCountry,
              onChanged: (value) {
                if (value != null) {
                  setSheetState(() => newCountry = value);
                }
              },
              child: Column(
                children: [
                  for (final option in countries)
                    RadioListTile<String>(title: Text(option.name), value: option.code),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            FilledButton(
              onPressed: () {
                setState(() {
                  language = newLanguage;
                  country = newCountry;
                  order = newOrder;
                });
                Navigator.of(context).pop();
              },
              child: Text(context.l10n.done),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(coachListControllerProvider(_filters), (prev, next) {
      if (prev?.value?.nextPage != next.value?.nextPage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              requestedNextPage = false;
            });
          }
        });
      }
    });

    final page = ref.watch(coachListControllerProvider(_filters));

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.coachLichessCoaches),
        actions: [
          SemanticIconButton(
            icon: const Icon(Icons.filter_list),
            semanticsLabel: context.l10n.mobileFilters,
            onPressed: () => _openFilterSheet(page.value),
          ),
        ],
      ),
      body: switch (page) {
        AsyncData(:final value) =>
          value.coaches.isEmpty
              ? Center(child: Text(context.l10n.mobileNoSearchResults))
              : HapticRefreshIndicator(
                  onRefresh: () =>
                      ref.refresh(coachListControllerProvider(_filters).future).then((_) {}),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: value.coaches.length,
                    itemBuilder: (context, index) => CoachListTile(coach: value.coaches[index]),
                  ),
                ),
        AsyncError() => _CoachErrorView(
          onRetry: () => ref.invalidate(coachListControllerProvider(_filters)),
        ),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

class const _CoachErrorView({required final VoidCallback onRetry}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.l10n.mobileSomethingWentWrong, style: Styles.sectionTitle),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh, color: ColorScheme.of(context).primary),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}

Locale _localeFromLanguageCode(String code) {
  final parts = code.split(RegExp('[-_]'));
  return parts.length > 1 ? Locale(parts.first, parts[1]) : Locale(parts.first);
}

String languageName(String code) => localeToLocalizedName(_localeFromLanguageCode(code));
