import 'package:lichess_mobile/l10n/l10n.dart';

enum FriendListSort() {
  alphabetical,
  ratingDesc,
  ratingAsc,
  lastSeen;

  String l10n(AppLocalizations l10n) {
    switch (this) {
      case FriendListSort.alphabetical:
        return l10n.studyAlphabetical;
      case ratingDesc:
        return 'Rating Descending';
      case FriendListSort.ratingAsc:
        return 'Rating Ascending';
      case FriendListSort.lastSeen:
        return 'Last Seen';
    }
  }
}
