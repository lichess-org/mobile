import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/coach/coach.dart';
import 'package:lichess_mobile/src/model/coach/coach_repository.dart';
import 'package:lichess_mobile/src/model/coach/youtube_channel.dart';
import 'package:lichess_mobile/src/model/coach/youtube_oembed.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/auth/sign_in_options.dart';
import 'package:lichess_mobile/src/view/coach/coach_list_screen.dart';
import 'package:lichess_mobile/src/view/coach/coach_picture.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/view/user/user_profile.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
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
          child: Column(
            children: [
              CoachPicture(url: profile.picture, size: 120.0),
              const SizedBox(height: 8.0),
              if (profile.user.isPatron || profile.user.title != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (profile.user.isPatron) ...[
                      PatronIcon(color: profile.user.patronColor, size: 20.0),
                      const SizedBox(width: 6.0),
                    ],
                    if (profile.user.title case final title?)
                      Text(
                        title,
                        style: TextStyle(
                          color: title == 'BOT'
                              ? context.lichessColors.fancy
                              : context.lichessColors.brag,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                  ],
                ),
              if (profile.headline case final headline?) ...[
                if (profile.user.isPatron || profile.user.title != null)
                  const SizedBox(height: 8.0),
                Text(
                  headline,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: Styles.horizontalBodyPadding.add(Styles.sectionBottomPadding),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(UserOrProfileScreen.buildRoute(profile.user)),
                  icon: const Icon(Icons.person_outlined),
                  label: Text(context.l10n.mobileLichessProfile, overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (!ref.read(isLoggedInProvider)) {
                      showSignInOptions(context, ref);
                      return;
                    }
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).push(ConversationScreen.buildRoute(user: profile.user));
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text(context.l10n.coachSendPM, overflow: TextOverflow.ellipsis),
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
        if (profile.posts.isNotEmpty)
          ListSection(
            header: Text(context.l10n.ublogLatestBlogPosts),
            hasLeading: true,
            children: [
              for (final post in profile.posts)
                ListTile(
                  leading: const Icon(Icons.article),
                  title: Text(post.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () => launchUrl(lichessUri(post.url.toString())),
                ),
            ],
          ),
        if (profile.youtubeVideos.isNotEmpty)
          ListSection(
            header: Text(context.l10n.coachYoutubeVideos),
            hasLeading: true,
            children: [
              if (profile.youtubeChannel case final channel?) _YoutubeChannelTile(url: channel),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  spacing: 8.0,
                  children: [
                    for (final video in profile.youtubeVideos) _YoutubeVideoThumbnail(url: video),
                  ],
                ),
              ),
            ],
          ),
        if (profile.studies.isNotEmpty)
          ListSection(
            header: Text(context.l10n.coachPublicStudies),
            hasLeading: true,
            children: [
              for (final study in profile.studies)
                ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(study.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(StudyScreen.buildRoute((id: study.id, initialChapter: null))),
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

class const _YoutubeVideoThumbnail({required final String url}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(youtubeVideoTitleProvider(url)).value;
    return InkWell(
      onTap: () => launchUrlString(url),
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(
                color: ColorScheme.of(context).surfaceContainerHighest,
                child: HttpNetworkImageWidget(
                  youtubeThumbnailUrl(url),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => HttpNetworkImageWidget(
                    youtubeFallbackThumbnailUrl(url),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.play_circle_outline, size: 40.0, color: Colors.white70),
                  ),
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xB3000000), Colors.transparent],
                      stops: [0.0, 0.4],
                    ),
                  ),
                ),
              ),
              if (title case final title?)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _YoutubeChannelTile({required final String url}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final channelAsync = ref.watch(
      youtubeChannelInfoProvider((url: url, languageCode: languageCode)),
    );
    if (channelAsync.isLoading) {
      return const Shimmer(
        child: ShimmerLoading(isLoading: true, child: _YoutubeChannelTileSkeleton()),
      );
    }
    final channel = channelAsync.value;
    if (channel == null) return const SizedBox.shrink();
    final counts = [?channel.subscriberText, ?channel.videoCountText].join(' • ');
    return ListTile(
      leading: switch (channel.avatarUrl) {
        final avatar? => ClipOval(
          child: SizedBox(
            width: 48.0,
            height: 48.0,
            child: HttpNetworkImageWidget(
              avatar,
              fit: BoxFit.cover,
              cacheWidth: 96,
              errorBuilder: (_, _, _) => const Icon(Icons.subscriptions),
            ),
          ),
        ),
        _ => const CircleAvatar(child: Icon(Icons.subscriptions)),
      },
      title: Text(channel.title ?? url, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: counts.isNotEmpty
          ? Text(counts, maxLines: 1, overflow: TextOverflow.ellipsis)
          : null,
      onTap: () => launchUrlString(url),
    );
  }
}

class const _YoutubeChannelTileSkeleton() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          const CircleAvatar(radius: 24.0, backgroundColor: Colors.black),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20.0,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: 160.0,
                  height: 14.0,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class const _TextSection({required final String title, required final String body})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListSection(
      header: Text(title),
      hasLeading: true,
      children: [ListTile(title: Text(body.trim()))],
    );
  }
}
