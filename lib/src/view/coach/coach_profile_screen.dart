import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/coach/coach.dart';
import 'package:lichess_mobile/src/model/coach/coach_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/coach/coach_list_screen.dart';
import 'package:lichess_mobile/src/view/coach/coach_picture.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/view/user/user_profile.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _coachProfileProvider = FutureProvider.autoDispose.family<CoachProfile, String>((
  ref,
  username,
) {
  return ref.withClientCacheFor(
    (client) => CoachRepository(client).getCoach(username),
    const Duration(minutes: 10),
  );
}, name: 'CoachProfileProvider');

class const CoachProfileScreen({required final String username, super.key}) extends ConsumerWidget {
  static Route<dynamic> buildRoute(String username) {
    return buildScreenRoute(screen: CoachProfileScreen(username: username));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(_coachProfileProvider(username));

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(username)),
      body: switch (profile) {
        AsyncData(:final value) => _Body(profile: value),
        AsyncError() => FullScreenRetryRequest(
          onRetry: () => ref.invalidate(_coachProfileProvider(username)),
        ),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

class const _Body({required final CoachProfile profile}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider(profile.user.id));
    final userInfo = user.value?.profile;
    final perfRatings = <String>[
      for (final perf in const [Perf.bullet, Perf.blitz, Perf.rapid, Perf.classical])
        if (user.value?.perfs[perf] case final perfRating?)
          if (perfRating.provisional != true) '${perf.label(context.l10n)} ${perfRating.rating}',
    ];

    return ListView(
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding.add(Styles.sectionBottomPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoachPicture(url: profile.picture, size: 120.0),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (profile.headline case final headline?)
                      Text(
                        headline,
                        style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListSection(
          hasLeading: true,
          children: [
            if (userInfo case final info? when info.location != null || info.country != null)
              _InfoRow(
                label: context.l10n.coachLocation,
                value: Location(profile: info),
              ),
            if (profile.languages.isNotEmpty)
              _InfoRow(
                label: context.l10n.coachLanguages,
                value: Text(profile.languages.map(languageName).join(', ')),
              ),
            if (userInfo?.fideRating != null || perfRatings.isNotEmpty)
              _InfoRow(
                label: context.l10n.coachRating,
                value: Wrap(
                  spacing: 12.0,
                  runSpacing: 4.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (userInfo?.fideRating case final fideRating?) Text('FIDE: $fideRating'),
                    for (final perfRating in perfRatings) Text(perfRating),
                  ],
                ),
              ),
            if (profile.hourlyRate case final rate?)
              _InfoRow(label: context.l10n.coachHourlyRate, value: Text(rate)),
            _InfoRow(
              label: context.l10n.coachAvailability,
              value: Text(
                profile.available ? context.l10n.coachAccepting : context.l10n.coachNotAccepting,
              ),
            ),
            if (user.value?.seenAt case final seenAt?)
              _InfoRow(
                value: Text(context.l10n.lastSeenActive(relativeDate(context.l10n, seenAt))),
              ),
          ],
        ),
        if (profile.description case final description?)
          _TextSection(title: context.l10n.coachAboutMe, body: description),
        if (profile.playingExperience case final experience?)
          _TextSection(title: context.l10n.coachPlayingExperience, body: experience),
        if (profile.teachingExperience case final experience?)
          _TextSection(title: context.l10n.coachTeachingExperience, body: experience),
        if (profile.otherExperience case final experience?)
          _TextSection(title: context.l10n.coachOtherExperiences, body: experience),
        if (profile.skills case final skills?)
          _TextSection(title: context.l10n.coachBestSkills, body: skills),
        if (profile.methodology case final methodology?)
          _TextSection(title: context.l10n.coachTeachingMethod, body: methodology),
        if (profile.youtubeChannel != null || profile.youtubeVideos.isNotEmpty)
          ListSection(
            header: Text(context.l10n.coachYoutubeVideos),
            hasLeading: true,
            children: [
              if (profile.youtubeChannel case final channel?)
                ListTile(
                  leading: const Icon(Icons.play_arrow),
                  title: Text(channel, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => launchUrlString(channel),
                ),
              for (final video in profile.youtubeVideos)
                ListTile(
                  leading: const Icon(Icons.play_arrow),
                  title: Text(video, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => launchUrlString(video),
                ),
            ],
          ),
        if (profile.studies.isNotEmpty)
          ListSection(
            header: Text(context.l10n.coachPublicStudies),
            hasLeading: true,
            children: [
              for (final studyId in profile.studies)
                ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(studyId, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(StudyScreen.buildRoute((id: StudyId(studyId), initialChapter: null))),
                ),
            ],
          ),
      ],
    );
  }
}

class const _InfoRow({required final Widget value, final String? label}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subtitle = label;
    return ListTile(title: value, subtitle: subtitle != null ? Text(subtitle) : null);
  }
}

class const _TextSection({required final String title, required final String body})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListSection(
      header: Text(title),
      hasLeading: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(body),
        ),
      ],
    );
  }
}
