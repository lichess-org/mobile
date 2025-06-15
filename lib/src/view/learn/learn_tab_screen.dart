import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/account_drawer.dart';
import 'package:lichess_mobile/src/view/coordinate_training/coordinate_training_screen.dart';
import 'package:lichess_mobile/src/view/study/study_list_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_symbols_icons/symbols.dart';

final _hotStudiesProvider = FutureProvider.autoDispose<IList<StudyPageItem>>((Ref ref) {
  return ref.withClientCacheFor(
    (client) => StudyRepository(ref, client)
        .getStudies(category: StudyCategory.all, order: StudyListOrder.hot)
        .then((value) => value.studies),
    const Duration(hours: 6),
  );
});

final _myStudiesLengthProvider = FutureProvider.autoDispose<int>((Ref ref) {
  final session = ref.watch(authSessionProvider);
  if (session == null) return Future.value(0);

  return ref.withClientCacheFor(
    (client) => StudyRepository(ref, client)
        .getStudies(category: StudyCategory.mine, order: StudyListOrder.updated)
        .then((value) => value.studies.length),
    const Duration(hours: 6),
  );
});

final _myFavoriteStudiesLengthProvider = FutureProvider.autoDispose<int>((Ref ref) {
  final session = ref.watch(authSessionProvider);
  if (session == null) return Future.value(0);

  return ref.withClientCacheFor(
    (client) => StudyRepository(ref, client)
        .getStudies(category: StudyCategory.likes, order: StudyListOrder.updated)
        .then((value) => value.studies.length),
    const Duration(hours: 6),
  );
});

class LearnTabScreen extends ConsumerWidget {
  const LearnTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;
        }
      },
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          leading: const AccountDrawerIconButton(),
          title: Text(context.l10n.learnMenu),
        ),
        drawer: const AccountDrawer(),
        body: const _Body(),
      ),
    );
  }
}

class _ToolsButton extends StatelessWidget {
  const _ToolsButton({required this.leading, required this.title, required this.onTap});

  final Widget leading;

  final Widget title;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1.0,
      child: ListTile(
        leading: IconTheme.merge(
          data: IconThemeData(color: ColorScheme.of(context).primary),
          child: leading,
        ),
        title: title,
        trailing: Theme.of(context).platform == TargetPlatform.iOS
            ? const Icon(Symbols.chevron_right)
            : null,
        onTap: onTap,
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;
    final session = ref.watch(authSessionProvider);
    final haveIStudies =
        session != null && (ref.watch(_myStudiesLengthProvider).valueOrNull ?? 0) > 0;
    final haveIFavoriteStudies =
        session != null && (ref.watch(_myFavoriteStudiesLengthProvider).valueOrNull ?? 0) > 0;

    return ListView(
      controller: learnScrollController,
      children: [
        ListSection(
          hasLeading: true,
          children: [
            _ToolsButton(
              leading: const Icon(Symbols.where_to_vote),
              title: Text(context.l10n.coordinatesCoordinateTraining, style: Styles.callout),
              onTap: () => Navigator.of(
                context,
                rootNavigator: true,
              ).push(CoordinateTrainingScreen.buildRoute(context)),
            ),
          ],
        ),
        if (isOnline) ...[
          ListSection(
            header: Text(context.l10n.studyMenu),
            onHeaderTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).push(StudyListScreen.buildRoute(context)),
            hasLeading: true,
            children: [
              ...(switch (ref.watch(_hotStudiesProvider)) {
                AsyncData(:final value) =>
                  value
                      .take(5)
                      .map((study) => StudyListItem(study: study, titleMaxLines: 1))
                      .toList(growable: false),
                _ => [],
              }),
            ],
          ),
          if (haveIStudies || haveIFavoriteStudies)
            ListSection(
              hasLeading: true,
              margin: Styles.horizontalBodyPadding.add(Styles.sectionBottomPadding),
              children: [
                if (haveIStudies)
                  _ToolsButton(
                    leading: const Icon(Symbols.local_library),
                    title: Text(context.l10n.studyMyStudies),
                    onTap: isOnline
                        ? () => Navigator.of(context).push(
                            StudyListScreen.buildRoute(
                              context,
                              initialCategory: StudyCategory.mine,
                            ),
                          )
                        : null,
                  ),
                if (haveIFavoriteStudies)
                  _ToolsButton(
                    leading: const Icon(Symbols.favorite),
                    title: Text(context.l10n.studyMyFavoriteStudies),
                    onTap: isOnline
                        ? () => Navigator.of(context).push(
                            StudyListScreen.buildRoute(
                              context,
                              initialCategory: StudyCategory.likes,
                            ),
                          )
                        : null,
                  ),
              ],
            ),
        ],
      ],
    );
  }
}
