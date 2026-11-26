import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/model/coach/coach.dart';
import 'package:lichess_mobile/src/view/coach/coach_picture.dart';
import 'package:lichess_mobile/src/view/coach/coach_profile_screen.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

class const CoachListTile({required final CoachPreview coach, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details.isNotEmpty)
            Text(
              details,
              maxLines: hourlyRate != null && hourlyRate.isNotEmpty ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (hourlyRate != null && hourlyRate.isNotEmpty)
            Text(hourlyRate, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      trailing: Theme.of(context).platform == TargetPlatform.iOS
          ? const CupertinoListTileChevron()
          : null,
      onTap: () => Navigator.of(
        context,
        rootNavigator: true,
      ).push(CoachProfileScreen.buildRoute(coach.user.name)),
    );
  }
}
