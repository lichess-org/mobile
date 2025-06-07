import 'package:lichess_mobile/l10n/l10n.dart';

enum StudyCategory {
  all,
  mine,
  member,
  public,
  private,
  likes;

  String l10n(AppLocalizations l10n) => switch (this) {
    StudyCategory.all => l10n.studyAllStudies,
    StudyCategory.mine => l10n.studyMyStudies,
    StudyCategory.member => l10n.studyStudiesIContributeTo,
    StudyCategory.public => l10n.studyMyPublicStudies,
    StudyCategory.private => l10n.studyMyPrivateStudies,
    StudyCategory.likes => l10n.studyMyFavoriteStudies,
  };
}

enum StudyListOrder {
  hot,
  popular,
  newest,
  oldest,
  updated;

  String l10n(AppLocalizations l10n) => switch (this) {
    StudyListOrder.hot => l10n.studyHot,
    StudyListOrder.newest => l10n.studyDateAddedNewest,
    StudyListOrder.oldest => l10n.studyDateAddedOldest,
    StudyListOrder.updated => l10n.studyRecentlyUpdated,
    StudyListOrder.popular => l10n.studyMostPopular,
  };
}
