import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/coach/coach.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/view/coach/coach_picture.dart';
import 'package:lichess_mobile/src/view/coach/coach_profile_screen.dart';
import 'package:lichess_mobile/src/view/user/countries.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

class const CoachListTile({
  required final CoachPreview coach,
  final bool detailed = false,
  super.key,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void openProfile() => Navigator.of(
      context,
      rootNavigator: true,
    ).push(CoachProfileScreen.buildRoute(coach.user.name));

    if (!detailed) {
      final headline = coach.headline?.trim();
      final hourlyRate = coach.hourlyRate?.trim();
      final details = [
        if (headline != null && headline.isNotEmpty) headline,
        if (coach.languages.isNotEmpty) coach.languages.join(', '),
      ].join(' • ');

      return ListTile(
        isThreeLine: true,
        leading: CoachPicture(url: coach.picture, size: 56.0),
        title: UserFullNameWidget(user: coach.user, rating: coach.rating, showFlair: false),
        subtitle: Column(
          crossAxisAlignment: .start,
          children: [
            if (details.isNotEmpty)
              Text(
                details,
                maxLines: hourlyRate != null && hourlyRate.isNotEmpty ? 1 : 2,
                overflow: .ellipsis,
              ),
            if (hourlyRate != null && hourlyRate.isNotEmpty)
              Text(hourlyRate, maxLines: 1, overflow: .ellipsis),
          ],
        ),
        trailing: Theme.of(context).platform == TargetPlatform.iOS
            ? const CupertinoListTileChevron()
            : null,
        onTap: openProfile,
      );
    }

    final userInfo = ref.watch(userProvider(coach.user.id)).value?.profile;
    final hourlyRate = coach.hourlyRate?.trim();
    final countryName = userInfo?.country != null ? countries[userInfo!.country] : null;

    return SizedBox(
      height: 100.0,
      child: ClipRect(
        child: InkWell(
          onTap: openProfile,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: .center,
              children: [
                CoachPicture(url: coach.picture, size: 84.0),
                const SizedBox(width: 16.0),
                Expanded(
                  child: SizedBox(
                    height: 84.0,
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        UserFullNameWidget(
                          user: coach.user,
                          rating: coach.rating,
                          showFlair: false,
                          style: Styles.sectionTitle,
                        ),
                        if (userInfo case final info?
                            when info.location != null || info.country != null)
                          _DetailRow(
                            label: context.l10n.coachLocation,
                            child: Row(
                              children: [
                                if (info.location?.trim() case final location?
                                    when location.isNotEmpty)
                                  Flexible(child: Text(location, maxLines: 1, overflow: .ellipsis)),
                                if (info.country case final country?)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: HttpNetworkImageWidget(
                                      lichessFlagSrc(country),
                                      width: 18.0,
                                      height: 12.0,
                                      fit: .cover,
                                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                                    ),
                                  ),
                                if (countryName case final name?)
                                  Flexible(child: Text(name, maxLines: 1, overflow: .ellipsis)),
                              ],
                            ),
                          ),
                        if (coach.languages.isNotEmpty)
                          _DetailRow(
                            label: context.l10n.coachLanguages,
                            child: Text(
                              coach.languages.join(', '),
                              maxLines: 1,
                              overflow: .ellipsis,
                            ),
                          ),
                        if (hourlyRate != null && hourlyRate.isNotEmpty)
                          _DetailRow(
                            label: context.l10n.coachHourlyRate,
                            child: Text(hourlyRate, maxLines: 1, overflow: .ellipsis),
                          ),
                      ],
                    ),
                  ),
                ),
                if (Theme.of(context).platform == TargetPlatform.iOS)
                  const CupertinoListTileChevron(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class const _DetailRow({required final String label, required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .center,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
        Expanded(child: child),
      ],
    );
  }
}
