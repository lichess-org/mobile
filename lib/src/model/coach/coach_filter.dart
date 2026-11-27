import 'package:lichess_mobile/l10n/l10n.dart';

enum CoachOrder(final String key) {
  login('login'),
  rating('rating'),
  alphabetical('alphabetical');

  static CoachOrder fromKey(String key) =>
      CoachOrder.values.firstWhere((order) => order.key == key, orElse: () => CoachOrder.login);

  String l10n(AppLocalizations l10n) => switch (this) {
    CoachOrder.login => l10n.coachLastLogin,
    CoachOrder.rating => l10n.coachLichessRating,
    CoachOrder.alphabetical => l10n.studyAlphabetical,
  };
}

typedef CoachFilters = ({String language, String country, CoachOrder order});

const kAllCoachesFilter = 'all';

const defaultCoachFilters = (
  language: kAllCoachesFilter,
  country: kAllCoachesFilter,
  order: CoachOrder.login,
);

class const CoachFilterOption({required final String code, required final String name}) {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoachFilterOption && other.code == code && other.name == name;

  @override
  int get hashCode => Object.hash(code, name);
}
