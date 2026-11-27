import 'package:clock/clock.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:material_ui/material_ui.dart';

/// A player of the FIDE rating list, as listed on lichess.org/fide.
@immutable
class const FidePlayer({
  required final FideId id,

  /// The name as FIDE writes it, "Surname, Given name".
  required final String name,
  required final FederationId? federation,
  required final int? birthYear,
  required final String? title,
  required final StatByFideTC ratings,
  required final FidePlayerPhoto? photo,

  /// Whether the authenticated user follows the player, always false if no user is authenticated.
  required final bool following,
}) {
  /// The age of the player at the end of the current year, as lichess.org shows it.
  int? get age => birthYear != null ? clock.now().year - birthYear! : null;

  /// The URL path segment lichess.org derives from the name, after the FIDE ID in a player URL.
  ///
  /// lichess.org also strips the accents of accented letters, keeping the base letter, where this
  /// drops the letter: it redirects a URL with a wrong slug to the right one.
  String get slug => name.replaceAll(RegExp(r'\s+'), '_').replaceAll(RegExp(r'[^\w\-]+'), '');
}

/// The portrait of a FIDE player, uploaded by lichess.
typedef FidePlayerPhoto = ({String smallUrl, String mediumUrl, String? credit});

/// A FIDE player with what lichess.org shows on the player page.
typedef FidePlayerDetails = ({
  FidePlayer player,

  /// The lichess account the player has publicly linked to their FIDE ID with a title verification.
  LightUser? user,

  /// The monthly rating history of each time control, oldest first.
  IMap<BroadcastFideTC, IList<UserRatingHistoryPoint>> ratingHistory,
});

/// A page of [FidePlayer]s.
typedef FidePlayerPage = ({IList<FidePlayer> players, int? nextPage});

extension FidePlayerPageExtension on FidePlayerPage {
  /// The player found by FIDE ID, if this page is the result of searching for [query] and the
  /// query is the FIDE ID of a player.
  ///
  /// lichess.org looks up a query that is a number as a FIDE ID first, and opens that player's page
  /// instead of listing results. Its JSON lists the player alone, which a name search can't
  /// return, since no name matches the ID.
  FidePlayer? idMatch(String query) {
    final id = int.tryParse(query.trim());
    if (id == null || players.length != 1) return null;
    final player = players.single;
    return player.id.value == id ? player : null;
  }
}

/// How lichess.org sorts the list of FIDE players.
enum FidePlayerOrder() {
  name,
  standard,
  rapid,
  blitz,
  year,

  /// The players the authenticated user follows, sorted by standard rating.
  follow;

  /// The time control whose rating is shown next to each player for this order.
  BroadcastFideTC get fideTC => switch (this) {
    rapid => .rapid,
    blitz => .blitz,
    _ => .standard,
  };
}
