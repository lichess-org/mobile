import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get mobileHomeTab => 'בית';

  @override
  String get mobilePuzzlesTab => 'חידות';

  @override
  String get mobileToolsTab => 'כלים';

  @override
  String get mobileWatchTab => 'צפייה';

  @override
  String get mobileSettingsTab => 'הגדרות';

  @override
  String get mobileMustBeLoggedIn => 'You must be logged in to view this page.';

  @override
  String get mobileSystemColors => 'System colors';

  @override
  String get mobileFeedbackButton => 'Feedback';

  @override
  String get mobileOkButton => 'OK';

  @override
  String get mobileSettingsHapticFeedback => 'Haptic feedback';

  @override
  String get mobileSettingsImmersiveMode => 'Immersive mode';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and Puzzle Storm screens.';

  @override
  String get mobileNotFollowingAnyUser => 'You are not following any user.';

  @override
  String get mobileAllGames => 'All games';

  @override
  String get mobileRecentSearches => 'Recent searches';

  @override
  String get mobileClearButton => 'Clear';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Players with \"$param\"';
  }

  @override
  String get mobileNoSearchResults => 'No results';

  @override
  String get mobileAreYouSure => 'Are you sure?';

  @override
  String get mobilePuzzleStreakAbortWarning => 'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleStormNothingToShow => 'Nothing to show. Play some runs of storm';

  @override
  String get mobileSharePuzzle => 'Share this puzzle';

  @override
  String get mobileShareGameURL => 'Share game URL';

  @override
  String get mobileShareGamePGN => 'Share PGN';

  @override
  String get mobileSharePositionAsFEN => 'Share position as FEN';

  @override
  String get mobileShowVariations => 'Show variations';

  @override
  String get mobileHideVariation => 'Hide variation';

  @override
  String get mobileShowComments => 'Show comments';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Do you want to end this run?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Nothing to show, please change the filters';

  @override
  String get mobileCancelTakebackOffer => 'Cancel takeback offer';

  @override
  String get mobileCancelDrawOffer => 'Cancel draw offer';

  @override
  String get mobileWaitingForOpponentToJoin => 'Waiting for opponent to join...';

  @override
  String get mobileBlindfoldMode => 'Blindfold';

  @override
  String get mobileLiveStreamers => 'Live streamers';

  @override
  String get mobileCustomGameJoinAGame => 'Join a game';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Clear saved move';

  @override
  String get mobileSomethingWentWrong => 'Something went wrong.';

  @override
  String get activityActivity => 'פעילות';

  @override
  String get activityHostedALiveStream => 'עלה (או עלתה) לשידור חי';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'סיים/ה במקום $param1 ב־$param2';
  }

  @override
  String get activitySignedUp => 'נרשם/ה לlichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'תמכ/ה בליצ\'ס במשך $count חודשים כ$param2',
      many: 'תמכ/ה בליצ\'ס במשך $count חודשים כ$param2',
      two: 'תמכ/ה בליצ\'ס במשך $count חודשים כ$param2',
      one: 'תמכ/ה בליצ\'ס במשך חודש $count כ$param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'התאמן/ה על $count עמדות ב$param2',
      many: 'התאמן/ה על $count עמדות ב$param2',
      two: 'התאמן/ה על $count עמדות ב$param2',
      one: 'התאמן/ה על עמדה $count ב$param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'פתר/ה $count פאזלים טקטיים',
      many: 'פתר/ה $count פאזלים טקטיים',
      two: 'פתר/ה $count פאזלים טקטיים',
      one: 'פתר/ה פאזל טקטי $count',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'שיחק/ה $count משחקי $param2',
      many: 'שיחק/ה $count משחקי $param2',
      two: 'שיחק/ה $count משחקי $param2',
      one: 'שיחק/ה משחק $param2 $count',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'פרסם/ה $count הודעות ב$param2',
      many: 'פרסם/ה $count הודעות ב$param2',
      two: 'פרסם/ה $count הודעות ב$param2',
      one: 'פרסם/ה הודעה $count ב$param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'שיחק/ה $count מהלכים',
      many: 'שיחק/ה $count מהלכים',
      two: 'שיחק/ה $count מהלכים',
      one: 'שיחק/ה מהלך $count',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ב$count משחקים בהתכתבות',
      many: 'ב$count משחקים בהתכתבות',
      two: 'ב$count משחקים בהתכתבות',
      one: 'במשחק $count בהתכתבות',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'השלים/ה $count משחקי התכתבות',
      many: 'השלים/ה $count משחקי התכתבות',
      two: 'השלים/ה $count משחקי התכתבות',
      one: 'השלים/ה משחק התכתבות $count',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'התחיל/ה לעקוב אחר $count שחקנים',
      many: 'התחיל/ה לעקוב אחר $count שחקנים',
      two: 'התחיל/ה לעקוב אחר $count שחקנים',
      one: 'התחיל/ה לעקוב אחר שחקן $count',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'השיג/ה $count עוקבים חדשים',
      many: 'השיג/ה $count עוקבים חדשים',
      two: 'השיג/ה $count עוקבים חדשים',
      one: 'השיג/ה עוקב/ת $count חדש/ה',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'אירח/ה $count משחקים סימולטניים',
      many: 'אירח/ה $count משחקים סימולטניים',
      two: 'אירח/ה $count משחקים סימולטניים',
      one: 'אירח/ה משחק סימולטני $count',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'השתתף/ה ב־$count משחקים סימולטניים',
      many: 'השתתף/ה ב־$count משחקים סימולטניים',
      two: 'השתתף/ה ב־$count משחקים סימולטניים',
      one: 'השתתף/ה במשחק סימולטני $count',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'יצר/ה $count לוחות למידה חדשים',
      many: 'יצר/ה $count לוחות למידה חדשים',
      two: 'יצר/ה $count לוחות למידה חדשים',
      one: 'יצר/ה לוח למידה $count חדש',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'השתתף/ה ב־$count טורנירי זירה',
      many: 'השתתף/ה ב־$count טורנירי זירה',
      two: 'השתתף/ה ב־$count טורנירי זירה',
      one: 'השתתף/ה בטורניר זירה $count',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'סיים/ה במקום #$count (אחוזון %$param2) עם $param3 משחקים ב$param4',
      many: 'סיים/ה במקום #$count (אחוזון %$param2) עם $param3 משחקים ב$param4',
      two: 'סיים/ה במקום #$count (אחוזון %$param2) עם $param3 משחקים ב$param4',
      one: 'סיים/ה במקום #$count (אחוזון %$param2) עם משחק $param3 ב־$param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'השתתף/ה ב־$count טורנירים שוויצריים',
      many: 'השתתף/ה ב־$count טורנירים שוויצריים',
      two: 'השתתף/ה ב־$count טורנירים שוויצריים',
      one: 'השתתף/ה בטורניר שוויצרי $count',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'הצטרף/ה ל־$count קבוצות',
      many: 'הצטרף/ה ל־$count קבוצות',
      two: 'הצטרף/ה ל־$count קבוצות',
      one: 'הצטרף/ה לקבוצה $count',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'הקרנות';

  @override
  String get broadcastLiveBroadcasts => 'צפייה ישירה בטורנירים';

  @override
  String challengeChallengesX(String param1) {
    return 'הזמנות למשחק: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'הזמינו למשחק';

  @override
  String get challengeChallengeDeclined => 'ההזמנה למשחק נדחתה';

  @override
  String get challengeChallengeAccepted => 'ההזמנה למשחק התקבלה!';

  @override
  String get challengeChallengeCanceled => 'ההזמנה למשחק התבטלה.';

  @override
  String get challengeRegisterToSendChallenges => 'אנא הירשמו כדי לשלוח הזמנות למשחקים.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'לא ניתן להזמין את $param למשחק.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param לא מקבל/ת הזמנות למשחקים.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'הדירוג שלך ב$param1 רחוק מדי מהדירוג של $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'אין אפשרות להזמין למשחק בגלל שדירוגך ב־$param זמני.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param מאשר/ת רק אתגרים מחברים.';
  }

  @override
  String get challengeDeclineGeneric => 'אני לא מקבל/ת הזמנות עכשיו.';

  @override
  String get challengeDeclineLater => 'זה לא הזמן המתאים עבורי, אנא שאל שוב מאוחר יותר.';

  @override
  String get challengeDeclineTooFast => 'קטגוריית הזמן הזו מהירה מדי בשבילי, בבקשה הזמן אותי שוב למשחק יותר איטי.';

  @override
  String get challengeDeclineTooSlow => 'קטגוריית הזמן הזו איטית מדי בשבילי, בבקשה הזמן אותי שוב למשחק יותר מהיר.';

  @override
  String get challengeDeclineTimeControl => 'אני לא מאשר/ת אתגרים בקטגוריית הזמן הזו.';

  @override
  String get challengeDeclineRated => 'בבקשה שלח/י לי הזמנה למשחק מדורג במקום.';

  @override
  String get challengeDeclineCasual => 'בבקשה שלח לי הזמנה למשחק לא מדורג במקום.';

  @override
  String get challengeDeclineStandard => 'אני לא מקבל/ת עכשיו הזמנות למשחקי שחמט לא סטנדרטי.';

  @override
  String get challengeDeclineVariant => 'אני לא מעוניין לשחק את סוג השחמט הזה עכשיו.';

  @override
  String get challengeDeclineNoBot => 'אני לא מאשר/ת הזמנות מבוטים.';

  @override
  String get challengeDeclineOnlyBot => 'מאשר/ת הזמנות למשחק רק מבוטים.';

  @override
  String get challengeInviteLichessUser => 'ניתן גם לשלוח הזמנה למשתמש/ת Lichess:';

  @override
  String get contactContact => 'צרו קשר';

  @override
  String get contactContactLichess => 'צרו קשר עם ליצ\'ס';

  @override
  String get patronDonate => 'תרמו';

  @override
  String get patronLichessPatron => 'תומך/ת ליצ\'ס';

  @override
  String perfStatPerfStats(String param) {
    return 'מדדי $param';
  }

  @override
  String get perfStatViewTheGames => 'צפו במשחקים';

  @override
  String get perfStatProvisional => 'זמני';

  @override
  String get perfStatNotEnoughRatedGames => 'לא ניתן לקבוע דירוג אמין, מפני שלא שוחקו מספיק משחקים מדורגים.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'התקדמות לאורך $param המשחקים האחרונים:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'סטיית תקן בדירוג: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'ערך נמוך יותר אומר שהדירוג יציב יותר. מעל $param1 הדירוג נחשב זמני. כדי להיכלל במדרג השחקנים, ערך זה צריך להיות מתחת ל־$param2 (שחמט רגיל) או $param3 (וריאנטים).';
  }

  @override
  String get perfStatTotalGames => 'סך כל המשחקים';

  @override
  String get perfStatRatedGames => 'משחקים מדורגים';

  @override
  String get perfStatTournamentGames => 'משחקי טורניר';

  @override
  String get perfStatBerserkedGames => 'משחקי \'אטרף\'';

  @override
  String get perfStatTimeSpentPlaying => 'זמן במשחק';

  @override
  String get perfStatAverageOpponent => 'יריב ממוצע';

  @override
  String get perfStatVictories => 'נצחונות';

  @override
  String get perfStatDefeats => 'הפסדים';

  @override
  String get perfStatDisconnections => 'ניתוקים';

  @override
  String get perfStatNotEnoughGames => 'אין מספיק משחקים';

  @override
  String perfStatHighestRating(String param) {
    return 'דירוג שיא: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'דירוג שפל: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'מ - $param1 עד $param2';
  }

  @override
  String get perfStatWinningStreak => 'רצף ניצחונות';

  @override
  String get perfStatLosingStreak => 'רצף הפסדים';

  @override
  String perfStatLongestStreak(String param) {
    return 'הרצף הארוך ביותר: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'רצף נוכחי: $param';
  }

  @override
  String get perfStatBestRated => 'ניצחונות בדירוג הגבוה ביותר';

  @override
  String get perfStatGamesInARow => 'משחקים ששוחקו ברצף';

  @override
  String get perfStatLessThanOneHour => 'פחות משעה בין משחקים';

  @override
  String get perfStatMaxTimePlaying => 'הכי הרבה זמן במשחק';

  @override
  String get perfStatNow => 'עכשיו';

  @override
  String get preferencesPreferences => 'העדפות';

  @override
  String get preferencesDisplay => 'תצוגה';

  @override
  String get preferencesPrivacy => 'פרטיות';

  @override
  String get preferencesNotifications => 'התראות';

  @override
  String get preferencesPieceAnimation => 'אנימציית הכלים';

  @override
  String get preferencesMaterialDifference => 'הבדל בחומר';

  @override
  String get preferencesBoardHighlights => 'הדגשת המשבצות בלוח: המהלך האחרון ושח';

  @override
  String get preferencesPieceDestinations => 'יעדי הכלים: מהלכים וקדם-מהלכים מותרים';

  @override
  String get preferencesBoardCoordinates => 'קואורדינטות לוח (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'רשימת מהלכים במהלך המשחק';

  @override
  String get preferencesPgnPieceNotation => 'רישום המהלכים';

  @override
  String get preferencesChessPieceSymbol => 'סימן הכלי';

  @override
  String get preferencesPgnLetter => 'אות (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'מצב זן';

  @override
  String get preferencesShowPlayerRatings => 'הצג דירוג שחקנים';

  @override
  String get preferencesShowFlairs => 'הצגת הסמלילים של השחקנים';

  @override
  String get preferencesExplainShowPlayerRatings => 'אם תבחר/י להסתיר את הדירוג, הדירוג של השחקן היריב לא יופיע כדי לאפשר לך להתרכז בשח, אך המשחק יהיה מדורג.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'הצג סמן להגדלת הלוח';

  @override
  String get preferencesOnlyOnInitialPosition => 'רק בעמדה ההתחלתית';

  @override
  String get preferencesInGameOnly => 'רק במהלך המשחק';

  @override
  String get preferencesChessClock => 'שעון השחמט';

  @override
  String get preferencesTenthsOfSeconds => 'הצג עשיריות שניה';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'כאשר הזמן שנותר קטן מעשר שניות';

  @override
  String get preferencesHorizontalGreenProgressBars => 'מדי התקדמות ירוקים אופקיים';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'השמע צליל כאשר הזמן נהיה קריטי';

  @override
  String get preferencesGiveMoreTime => 'תן עוד זמן';

  @override
  String get preferencesGameBehavior => 'התנהגות המשחק';

  @override
  String get preferencesHowDoYouMovePieces => 'איך מזיזים את הכלים?';

  @override
  String get preferencesClickTwoSquares => 'לחץ על שני ריבועים';

  @override
  String get preferencesDragPiece => 'הזז את הכלי';

  @override
  String get preferencesBothClicksAndDrag => 'שניהם';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'קדם-מהלכים: ביצוע מהלכים במהלך תורו של היריב';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'החזרת המהלך האחרון: מותנה בהסכמת היריב';

  @override
  String get preferencesInCasualGamesOnly => 'במשחקים ללא דירוג בלבד';

  @override
  String get preferencesPromoteToQueenAutomatically => 'הכתרה אוטומטית למלכה';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'לחצו על מקש <ctrl> בזמן הקידום כדי להשבית זמנית את ההכתרה האוטומטית';

  @override
  String get preferencesWhenPremoving => 'כאשר מבצעים קדם-מהלך';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'הכרז על תיקו בחזרה משולשת באופן אוטומטי';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'כשהזמן הנותר קטן מ־30 שניות';

  @override
  String get preferencesMoveConfirmation => 'אישור המהלכים';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'ניתן לביטול במהלך המשחק באמצעות תפריט הלוח';

  @override
  String get preferencesInCorrespondenceGames => 'במשחקים בהתכתבות';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'התכתבות וללא הגבלה';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'אשרו כניעה והצעות תיקו';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'שיטת הצרחה';

  @override
  String get preferencesCastleByMovingTwoSquares => 'הזז את המלך שני משבצות';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'הזז את המלך על הצריח';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'הקלידו מהלכים באמצעות המקלדת';

  @override
  String get preferencesInputMovesWithVoice => 'ביצוע מהלכים באמצעות דיבור';

  @override
  String get preferencesSnapArrowsToValidMoves => 'התאמת החצים למסעים חוקיים';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'כתבו ״Good game, well played\" בצ׳אט לאחר הפסד או תיקו (בתרגום חופשי: משחק יפה, שיחקת טוב)';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'העדפותיך נשמרו.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'גלול על גבי הלוח כדי להראות מהלכים קודמים';

  @override
  String get preferencesCorrespondenceEmailNotification => 'הודעת מייל יומית עם רשימת המשחקים שלך בהתכתבות';

  @override
  String get preferencesNotifyStreamStart => 'משדר עולה לשידור חי';

  @override
  String get preferencesNotifyInboxMsg => 'הודעה חדשה בתיבת הדואר';

  @override
  String get preferencesNotifyForumMention => 'מזכירים אותך בתגובה בפורום';

  @override
  String get preferencesNotifyInvitedStudy => 'הזמנה ללוח למידה';

  @override
  String get preferencesNotifyGameEvent => 'עדכונים לגבי משחקים בהתכתבות';

  @override
  String get preferencesNotifyChallenge => 'הזמנות למשחקים';

  @override
  String get preferencesNotifyTournamentSoon => 'טורניר מתחיל בקרוב';

  @override
  String get preferencesNotifyTimeAlarm => 'אוזל הזמן במשחק התכתבות';

  @override
  String get preferencesNotifyBell => 'התראות פעמון ב־Lichess';

  @override
  String get preferencesNotifyPush => 'התראה למכשיר גם כשאינך מחובר/ת ל־Lichess';

  @override
  String get preferencesNotifyWeb => 'דפדפן';

  @override
  String get preferencesNotifyDevice => 'מכשיר';

  @override
  String get preferencesBellNotificationSound => 'השמע צליל עבור התראות פעמון';

  @override
  String get puzzlePuzzles => 'פאזלים';

  @override
  String get puzzlePuzzleThemes => 'חידות נושאיות';

  @override
  String get puzzleRecommended => 'מומלץ';

  @override
  String get puzzlePhases => 'שלבים';

  @override
  String get puzzleMotifs => 'מוטיבים';

  @override
  String get puzzleAdvanced => 'מתקדם';

  @override
  String get puzzleLengths => 'אורך';

  @override
  String get puzzleMates => 'מט';

  @override
  String get puzzleGoals => 'יעדים';

  @override
  String get puzzleOrigin => 'מקור';

  @override
  String get puzzleSpecialMoves => 'צעדים מיוחדים';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'האם אהבת את החידה הזאת?';

  @override
  String get puzzleVoteToLoadNextOne => 'דרגו כדי לקבל את הפאזל הבא!';

  @override
  String get puzzleUpVote => 'אהבתם את החידה? הצביעו הצבעה עילית';

  @override
  String get puzzleDownVote => 'לא אהבתם? הצביעו הצבעה תחתית';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'דירוג החידות שלך לא ישתנה. שימו לב כי פתירת חידות אינה תחרות. הדירוג נועד לאפשר בחירה של חידות המתאימות לרמה הנוכחית שלך.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'מצא/י את המהלך הטוב ביותר ללבן.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'מצא/י את המהלך הטוב ביותר לשחור.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'לקבלת חידות מותאמות אישית:';

  @override
  String puzzlePuzzleId(String param) {
    return 'חידה $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'החידה היומית';

  @override
  String get puzzleDailyPuzzle => 'החידה היומית';

  @override
  String get puzzleClickToSolve => 'לחץ/י כדי לפתור';

  @override
  String get puzzleGoodMove => 'מהלך טוב';

  @override
  String get puzzleBestMove => 'המהלך הטוב ביותר!';

  @override
  String get puzzleKeepGoing => 'המשיכו…';

  @override
  String get puzzlePuzzleSuccess => 'כל הכבוד!';

  @override
  String get puzzlePuzzleComplete => 'החידה הושלמה!';

  @override
  String get puzzleByOpenings => 'לפי פתיחות';

  @override
  String get puzzlePuzzlesByOpenings => 'חידות לפי פתיחות';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'הפתיחות הנפוצות שלך במשחקים מדורגים';

  @override
  String get puzzleUseFindInPage => 'השתמשו ב״חיפוש בעמוד״ בדפדפן כדי למצוא את הפתיחה המועדפת עליכם!';

  @override
  String get puzzleUseCtrlF => 'השתמשו ב־ctrl+F כדי למצוא את הפתיחה המועדפת עליכם!';

  @override
  String get puzzleNotTheMove => 'זה לא המהלך!';

  @override
  String get puzzleTrySomethingElse => 'נסו משהו אחר.';

  @override
  String puzzleRatingX(String param) {
    return 'דירוג: $param';
  }

  @override
  String get puzzleHidden => 'מוסתר';

  @override
  String puzzleFromGameLink(String param) {
    return 'מתוך משחק $param';
  }

  @override
  String get puzzleContinueTraining => 'המשיכו להתאמן';

  @override
  String get puzzleDifficultyLevel => 'רמת קושי';

  @override
  String get puzzleNormal => 'רגיל';

  @override
  String get puzzleEasier => 'קל יותר';

  @override
  String get puzzleEasiest => 'מאוד קל';

  @override
  String get puzzleHarder => 'קשה יותר';

  @override
  String get puzzleHardest => 'מאוד קשה';

  @override
  String get puzzleExample => 'דוגמה';

  @override
  String get puzzleAddAnotherTheme => 'הוסיפו נושא חדש';

  @override
  String get puzzleNextPuzzle => 'הפאזל הבא';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'המשיכו ישר לחידה הבאה';

  @override
  String get puzzlePuzzleDashboard => 'תמונת מצב';

  @override
  String get puzzleImprovementAreas => 'תחומים לשיפור';

  @override
  String get puzzleStrengths => 'חוזקות';

  @override
  String get puzzleHistory => 'חידות קודמות';

  @override
  String get puzzleSolved => 'פתרת';

  @override
  String get puzzleFailed => 'שגית';

  @override
  String get puzzleStreakDescription => 'פתרו חידות ברמת קושי עולה וצברו רצף של ניצחונות. אין שעון, אז קחו את הזמן. מהלך שגוי אחד, והמשחק נגמר! אבל את/ה יכול/ה לדלג על מהלך אחד בכל הפעלה.';

  @override
  String puzzleYourStreakX(String param) {
    return 'הרצף שלך: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'דלג/י על מהלך זה כדי לשמור על הרצף שלך! ניתן לדלג רק פעם אחת בכל הפעלה.';

  @override
  String get puzzleContinueTheStreak => 'המשך הרצף';

  @override
  String get puzzleNewStreak => 'רצף חדש';

  @override
  String get puzzleFromMyGames => 'מהמשחקים שלי';

  @override
  String get puzzleLookupOfPlayer => 'חפש פאזלים ממשחקים של אחד השחקנים';

  @override
  String puzzleFromXGames(String param) {
    return 'חידות מתוך המשחקים של $param';
  }

  @override
  String get puzzleSearchPuzzles => 'חיפוש פאזלים';

  @override
  String get puzzleFromMyGamesNone => 'אין פאזלים מהמשחקים שלך במאגר, אך אנחנו עדיין אוהבים אותך!\nשחק/י משחקי Rapid ו־Classical כדי להגדיל את הסבירות שיתווסף פאזל משלך!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'נמצאו $param1 חידות במשחקים של $param2';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'אימון וניתוח יובילו לשיפור';

  @override
  String puzzlePercentSolved(String param) {
    return '$param נפתרו';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'אין מה להראות, לכו לפתור כמה חידות קודם!';

  @override
  String get puzzleImprovementAreasDescription => 'התאמנו על אלה כדי לשפר את ההתקדמות שלכם!';

  @override
  String get puzzleStrengthDescription => 'את/ה מתפקד/ת הכי טוב בנושאים הבאים';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'שוחק $count פעמים',
      many: 'שוחק $count פעמים',
      two: 'שוחק $count פעמים',
      one: 'שוחק פעם $count',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count נקודות מתחת לדירוג החידות שלך',
      many: '$count נקודות מתחת לדירוג החידות שלך',
      two: '$count נקודות מתחת לדירוג החידות שלך',
      one: 'נקודה $count מתחת לדירוג החידות שלך',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count נקודות מעל לדירוג החידות שלך',
      many: '$count נקודות מעל לדירוג החידות שלך',
      two: 'נקודה 1 מתחת לדירוג הפזלים שלך',
      one: 'נקודה $count מעל לדירוג החידות שלך',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שוחקו',
      many: '$count שוחקו',
      two: '$count שוחקו',
      one: '$count שוּחק',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שכדאי לפתור שוב',
      many: '$count שכדאי לפתור שוב',
      two: '$count שכדאי לפתור שוב',
      one: '$count שכדאי לפתור שוב',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'רגלי מתקדם';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'אחד מהחיילים שלך עמוק בקווי היריב, אולי מאיים להיות מוכתר.';

  @override
  String get puzzleThemeAdvantage => 'יתרון';

  @override
  String get puzzleThemeAdvantageDescription => 'נצל/י את ההזדמנות כדי להשיג יתרון מכריע. (הערכת יתרון בין 2.0 ל־6.0)';

  @override
  String get puzzleThemeAnastasiaMate => 'המט של אנסטסיה';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'פרש, יחד עם צריח או מלכה, לוכדים את המלך היריב בין דופן הלוח לבין כלי מכוחותיו.';

  @override
  String get puzzleThemeArabianMate => 'מט ערבי';

  @override
  String get puzzleThemeArabianMateDescription => 'פרש וצריח לוכדים יחד את המלך היריב בפינת הלוח.';

  @override
  String get puzzleThemeAttackingF2F7 => 'תקיפה של ו2 או ו7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'מיקוד איומים על הרגלי ב־ו2 או ו7, כמו למשל בפתיחת \"Fried Liver\".';

  @override
  String get puzzleThemeAttraction => 'משיכה';

  @override
  String get puzzleThemeAttractionDescription => 'החלפת כלים או הקרבה שמעודדות או מכריחות כלי יריב לנדוד למשבצת שמאפשרת טקטיקת המשך.';

  @override
  String get puzzleThemeBackRankMate => 'מט שורה אחורית (״מתחת למים״)';

  @override
  String get puzzleThemeBackRankMateDescription => 'בצעו מט למלך בשורת הפתיחה שלו, בה הוא כלוא על ידי כלים מכוחותיו.';

  @override
  String get puzzleThemeBishopEndgame => 'סיום רצים';

  @override
  String get puzzleThemeBishopEndgameDescription => 'סיום עם רצים ורגלים בלבד.';

  @override
  String get puzzleThemeBodenMate => 'המט של בודן';

  @override
  String get puzzleThemeBodenMateDescription => 'שני רצים התוקפים באלכסונים חוצים מבצעים מט למלך החסום בין כלים מכוחותיו.';

  @override
  String get puzzleThemeCastling => 'הצרחה';

  @override
  String get puzzleThemeCastlingDescription => 'הביאו את המלך למקום מבטחים, והכינו את הצריח להתקפה.';

  @override
  String get puzzleThemeCapturingDefender => 'הכה את המגן';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'הסרת כלי קריטי להגנה על כלי אחר, המאפשרת להכות את הכלי החשוף כעת במסע הבא.';

  @override
  String get puzzleThemeCrushing => 'ריסוק';

  @override
  String get puzzleThemeCrushingDescription => 'זהו את השגיאה החמורה של היריב כדי להשיג יתרון מוחץ. (הערכת יתרון מעל 6.0)';

  @override
  String get puzzleThemeDoubleBishopMate => 'מט שני רצים';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'שני רצים תוקפים באלכסונים סמוכים מבצעים מט למלך החסום על ידי כלים מכוחותיו.';

  @override
  String get puzzleThemeDovetailMate => 'מט קוזיו';

  @override
  String get puzzleThemeDovetailMateDescription => 'מלכה מבצעת מט למלך סמוך, ששתי משבצות הבריחה שלו חסומות על ידי כלים מכוחותיו.';

  @override
  String get puzzleThemeEquality => 'שוויון';

  @override
  String get puzzleThemeEqualityDescription => 'חזרו למשחק מעמדת הפסד, והבטיחו תיקו או עמדה מאוזנת. (הערכת יתרון קטנה מ־2.0)';

  @override
  String get puzzleThemeKingsideAttack => 'תקיפת צד המלך';

  @override
  String get puzzleThemeKingsideAttackDescription => 'תקיפת המלך של היריב, לאחר שהצריח לצד המלך.';

  @override
  String get puzzleThemeClearance => 'פינוי';

  @override
  String get puzzleThemeClearanceDescription => 'מסע, בדרך כלל עם טמפו, שמפנה משבצת, שורה או עמודה לביצוע טקטיקת המשך.';

  @override
  String get puzzleThemeDefensiveMove => 'מסע הגנתי';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'מסע מדויק או סדרת מסעים מדויקת הנחוצה למניעת איבוד חומר או יתרון אחר.';

  @override
  String get puzzleThemeDeflection => 'הרחקה';

  @override
  String get puzzleThemeDeflectionDescription => 'מסע שמסיח כלי יריב ממטלה אחרת שעליו לבצע, כמו למשל הגנה על משבצת מפתח. לעיתים נקרא גם \"העמסה\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'התקפה נגלית';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'הזזת כלי (למשל פרש), שחסם איום של כלי רחוק טווח (למשל צריח), מחוץ לדרכו של כלי זה.';

  @override
  String get puzzleThemeDoubleCheck => 'שח כפול';

  @override
  String get puzzleThemeDoubleCheckDescription => 'שח עם שני כלים במקביל, כתוצאה מהתקפה נגלית בה הכלי הזז והכלי הנחשף מאיימים על המלך היריב.';

  @override
  String get puzzleThemeEndgame => 'סיום';

  @override
  String get puzzleThemeEndgameDescription => 'טקטיקה במהלך השלב האחרון של המשחק.';

  @override
  String get puzzleThemeEnPassantDescription => 'טקטיקה המשלבת את חוק ״הכאה דרך הילוכו\", בו רגלי יכול להכות רגלי יריב שעבר אותו בתנועתו על ידי מסע של שתי משבצות לפנים מהמשבצת ההתחלתית.';

  @override
  String get puzzleThemeExposedKing => 'מלך חשוף';

  @override
  String get puzzleThemeExposedKingDescription => 'טקטיקה המשלבת מלך עם מעט מגנים סביבו, שלרוב מובילה למט.';

  @override
  String get puzzleThemeFork => 'מזלג';

  @override
  String get puzzleThemeForkDescription => 'מסע בו הכלי הנע מאיים על שני כלי יריב במקביל.';

  @override
  String get puzzleThemeHangingPiece => 'כלי תלוי ללא חיפוי';

  @override
  String get puzzleThemeHangingPieceDescription => 'טקטיקה המשלבת כלי יריב לא מוגן או מוגן לא כהלכה וזמין להכאה.';

  @override
  String get puzzleThemeHookMate => 'מט קרס';

  @override
  String get puzzleThemeHookMateDescription => 'מט עם צריח, פרש ורגלי יחד עם רגלי יריב המגבילים את בריחת המלך היריב.';

  @override
  String get puzzleThemeInterference => 'קטיעת קו הגנה';

  @override
  String get puzzleThemeInterferenceDescription => 'הזזת כלי בין שני כלים יריבים על מנת להותיר אותם לא מוגנים, למשל פרש על משבצת מוגנת בין שני צריחים.';

  @override
  String get puzzleThemeIntermezzo => 'אינטרמצו';

  @override
  String get puzzleThemeIntermezzoDescription => 'טקטיקה בה במקום לבצע את המהלך הצפוי, מבצעים מהלך ביניים המציב איום הדורש תגובה מיידית מהיריב. נקראת גם \"מסע ביניים\" או מגרמנית \"זווישנזוג\".';

  @override
  String get puzzleThemeKnightEndgame => 'סיום פרשים';

  @override
  String get puzzleThemeKnightEndgameDescription => 'סיום עם פרשים ורגלים בלבד.';

  @override
  String get puzzleThemeLong => 'פאזל ארוך';

  @override
  String get puzzleThemeLongDescription => 'שלושה מסעים לניצחון.';

  @override
  String get puzzleThemeMaster => 'משחקי אמנים';

  @override
  String get puzzleThemeMasterDescription => 'פאזלים ממשחקים של אמני שחמט.';

  @override
  String get puzzleThemeMasterVsMaster => 'משחקי אמן נגד אמן';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'פאזלים ממשחקים בין שני אמנים.';

  @override
  String get puzzleThemeMate => 'מט';

  @override
  String get puzzleThemeMateDescription => 'נצחו את המשחק בסטייל.';

  @override
  String get puzzleThemeMateIn1 => 'מט ב1';

  @override
  String get puzzleThemeMateIn1Description => 'בצע/י מט במסע אחד.';

  @override
  String get puzzleThemeMateIn2 => 'מט ב2';

  @override
  String get puzzleThemeMateIn2Description => 'בצע/י מט בשני מסעים.';

  @override
  String get puzzleThemeMateIn3 => 'מט ב3';

  @override
  String get puzzleThemeMateIn3Description => 'בצע/י מט בשלושה מסעים.';

  @override
  String get puzzleThemeMateIn4 => 'מט ב4';

  @override
  String get puzzleThemeMateIn4Description => 'בצע/י מט בארבעה מסעים.';

  @override
  String get puzzleThemeMateIn5 => 'מט ב5 או יותר';

  @override
  String get puzzleThemeMateIn5Description => 'מצא/י רצף מסעים ארוך עד למט.';

  @override
  String get puzzleThemeMiddlegame => 'מציעה';

  @override
  String get puzzleThemeMiddlegameDescription => 'טקטיקה במהלך השלב השני של המשחק.';

  @override
  String get puzzleThemeOneMove => 'פאזל מסע יחיד';

  @override
  String get puzzleThemeOneMoveDescription => 'פאזל המכיל מסע אחד בלבד.';

  @override
  String get puzzleThemeOpening => 'פתיחה';

  @override
  String get puzzleThemeOpeningDescription => 'טקטיקה במהלך השלב הראשון של המשחק.';

  @override
  String get puzzleThemePawnEndgame => 'סיום רגלים';

  @override
  String get puzzleThemePawnEndgameDescription => 'סיום עם רגלים בלבד.';

  @override
  String get puzzleThemePin => 'ריתוק';

  @override
  String get puzzleThemePinDescription => 'טקטיקה המשלבת ריתוק, בו כלי מנוע מלזוז מבלי לחשוף איום על כלי חשוב יותר.';

  @override
  String get puzzleThemePromotion => 'הכתרה';

  @override
  String get puzzleThemePromotionDescription => 'הכתרת אחד מהרגלים למלכה או לכלי משני.';

  @override
  String get puzzleThemeQueenEndgame => 'סיום מלכות';

  @override
  String get puzzleThemeQueenEndgameDescription => 'סיום עם מלכות ורגלים בלבד.';

  @override
  String get puzzleThemeQueenRookEndgame => 'מלכה וצריח';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'סיום עם מלכות, צריחים ורגלים בלבד.';

  @override
  String get puzzleThemeQueensideAttack => 'תקיפה בצד המלכה';

  @override
  String get puzzleThemeQueensideAttackDescription => 'תקיפת המלך של היריב, לאחר שהצריח לצד המלכה.';

  @override
  String get puzzleThemeQuietMove => 'מסע שקט';

  @override
  String get puzzleThemeQuietMoveDescription => 'מסע שלא מבצע שח או מכה כלי, אך מכין איום בלתי נמנע במסע מאוחר יותר.';

  @override
  String get puzzleThemeRookEndgame => 'סיום צריחים';

  @override
  String get puzzleThemeRookEndgameDescription => 'סיום עם צריחים ורגלים בלבד.';

  @override
  String get puzzleThemeSacrifice => 'הקרבה';

  @override
  String get puzzleThemeSacrificeDescription => 'טקטיקה המשלבת ויתור על חומר בטווח הקצר, כדי להשיג את היתרון שוב לאחר סדרת מסעים כפויה.';

  @override
  String get puzzleThemeShort => 'פאזל קצר';

  @override
  String get puzzleThemeShortDescription => 'שני מסעים לניצחון.';

  @override
  String get puzzleThemeSkewer => 'שיפוד';

  @override
  String get puzzleThemeSkewerDescription => 'מוטיב המשלב כלי חשוב מאוים, זז ומאפשר איום או הכאה של כלי חשוב פחות מאחוריו, ההפך מריתוק.';

  @override
  String get puzzleThemeSmotheredMate => 'מט חנק';

  @override
  String get puzzleThemeSmotheredMateDescription => 'מט על ידי פרש בו המלך היריב לא מסוגל לזוז כי הוא מוקף (או חנוק) על ידי כלים מכוחותיו.';

  @override
  String get puzzleThemeSuperGM => 'משחקי סופר רב־אמנים';

  @override
  String get puzzleThemeSuperGMDescription => 'פאזלים ממשחקים של השחקנים הטובים בעולם.';

  @override
  String get puzzleThemeTrappedPiece => 'כלי לכוד';

  @override
  String get puzzleThemeTrappedPieceDescription => 'כלי לא יכול להימנע מהכאה בגלל צמצום מסעים אפשריים.';

  @override
  String get puzzleThemeUnderPromotion => 'הכתרה נחותה';

  @override
  String get puzzleThemeUnderPromotionDescription => 'הכתרה לפרש, רץ או צריח.';

  @override
  String get puzzleThemeVeryLong => 'פאזל ארוך מאוד';

  @override
  String get puzzleThemeVeryLongDescription => 'ארבעה מסעים או יותר לניצחון.';

  @override
  String get puzzleThemeXRayAttack => 'התקפת רנטגן';

  @override
  String get puzzleThemeXRayAttackDescription => 'כלי המאיים או מגן על משבצת דרך כלי יריב.';

  @override
  String get puzzleThemeZugzwang => 'כפאי';

  @override
  String get puzzleThemeZugzwangDescription => 'היריב מוגבל במסעים שביכולתו לבצע, וכל אחד מחמיר את מצבו.';

  @override
  String get puzzleThemeHealthyMix => 'שילוב בריא';

  @override
  String get puzzleThemeHealthyMixDescription => 'קצת מהכל. לא תדעו למה לצפות. עליכם להיות מוכנים להכל! בדיוק כמו משחקים אמיתיים.';

  @override
  String get puzzleThemePlayerGames => 'המשחקים שלי';

  @override
  String get puzzleThemePlayerGamesDescription => 'חפשו חידות אשר נוצרו ממשחקים שלכם או של שחקנים אחרים.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'החידות האלו הן נחלת הכלל, וניתן להוריד אותן מ־$param.';
  }

  @override
  String get searchSearch => 'חיפוש';

  @override
  String get settingsSettings => 'הגדרות';

  @override
  String get settingsCloseAccount => 'סגירת החשבון';

  @override
  String get settingsManagedAccountCannotBeClosed => 'חשבונך מנוהל, ולכן לא ניתן לסגור אותו.';

  @override
  String get settingsClosingIsDefinitive => 'הסגירה היא סופית. אין דרך חזרה. האם את/ה בטוח/ה?';

  @override
  String get settingsCantOpenSimilarAccount => 'לא תוכל/י לפתוח חשבון חדש עם אותו השם, אפילו בשינוי אותיות קטנות לגדולות ולהיפך.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'שיניתי את דעתי, אל תסגרו את החשבון שלי';

  @override
  String get settingsCloseAccountExplanation => 'האם אכן ברצונך לסגור את חשבונך? סגירת חשבונך היא החלטה סופית. לעולם לא יהיה אפשר להתחבר לחשבון הזה שוב.';

  @override
  String get settingsThisAccountIsClosed => 'החשבון הזה סגור.';

  @override
  String get playWithAFriend => 'שחק/י עם חבר/ה';

  @override
  String get playWithTheMachine => 'שחק/י מול המחשב';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'כדי להזמין מישהו לשחק, שתפו את הכתובת הזאת';

  @override
  String get gameOver => 'המשחק הסתיים';

  @override
  String get waitingForOpponent => 'ממתין ליריב';

  @override
  String get orLetYourOpponentScanQrCode => 'אפשר גם לתת ליריבך לסרוק את קוד ה־QR הזה';

  @override
  String get waiting => 'ממתין';

  @override
  String get yourTurn => 'תורך';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 רמה $param2';
  }

  @override
  String get level => 'רמה';

  @override
  String get strength => 'רמת קושי';

  @override
  String get toggleTheChat => 'הפעלת/כיבוי הצ\'אט';

  @override
  String get chat => 'שלח/י הודעה';

  @override
  String get resign => 'כניעה';

  @override
  String get checkmate => 'מט';

  @override
  String get stalemate => 'פט';

  @override
  String get white => 'לבן';

  @override
  String get black => 'שחור';

  @override
  String get asWhite => 'בתור לבן';

  @override
  String get asBlack => 'בתור שחור';

  @override
  String get randomColor => 'צבע אקראי';

  @override
  String get createAGame => 'יצירת משחק';

  @override
  String get whiteIsVictorious => 'הלבן ניצח';

  @override
  String get blackIsVictorious => 'השחור ניצח';

  @override
  String get youPlayTheWhitePieces => 'את/ה משחק/ת כלבן';

  @override
  String get youPlayTheBlackPieces => 'את/ה משחק/ת כשחור';

  @override
  String get itsYourTurn => 'תורך!';

  @override
  String get cheatDetected => 'זוהתה רמאות';

  @override
  String get kingInTheCenter => 'המלך במרכז';

  @override
  String get threeChecks => 'שח משולש';

  @override
  String get raceFinished => 'המירוץ נגמר';

  @override
  String get variantEnding => 'סיום הוריאנט';

  @override
  String get newOpponent => 'יריב/ה חדש/ה';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'יריבך רוצה לשחק איתך שוב';

  @override
  String get joinTheGame => 'הצטרף/י למשחק';

  @override
  String get whitePlays => 'תור הלבן';

  @override
  String get blackPlays => 'תור השחור';

  @override
  String get opponentLeftChoices => 'יריבך עזב את המשחק. באפשרותך להכריז על ניצחון, על תיקו או להמתין.';

  @override
  String get forceResignation => 'הכריזו על ניצחון';

  @override
  String get forceDraw => 'הכריזו על תיקו';

  @override
  String get talkInChat => 'היו אדיבים ודברו בצ׳אט בצורה נאותה!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'האדם הראשון שייכנס לכתובת הזאת ישחק איתך.';

  @override
  String get whiteResigned => 'הלבן נכנע';

  @override
  String get blackResigned => 'השחור נכנע';

  @override
  String get whiteLeftTheGame => 'הלבן עזב את המשחק';

  @override
  String get blackLeftTheGame => 'השחור עזב את המשחק';

  @override
  String get whiteDidntMove => 'לבן לא ביצע מסע';

  @override
  String get blackDidntMove => 'שחור לא ביצע מסע';

  @override
  String get requestAComputerAnalysis => 'בקש/י ניתוח ממוחשב';

  @override
  String get computerAnalysis => 'ניתוח ע\"י המחשב';

  @override
  String get computerAnalysisAvailable => 'ניתוח ממוחשב זמין';

  @override
  String get computerAnalysisDisabled => 'ניתוח ממוחשב מושבת';

  @override
  String get analysis => 'לוח ניתוחים';

  @override
  String depthX(String param) {
    return 'בעומק של $param מהלכים';
  }

  @override
  String get usingServerAnalysis => 'באמצעות ניתוח שרת';

  @override
  String get loadingEngine => 'טוען מנוע...';

  @override
  String get calculatingMoves => 'מחשב מהלכים...';

  @override
  String get engineFailed => 'שגיאה בטעינת המנוע';

  @override
  String get cloudAnalysis => 'ניתוח ענן';

  @override
  String get goDeeper => 'עמוק יותר';

  @override
  String get showThreat => 'הצגת איום';

  @override
  String get inLocalBrowser => 'בדפדפן המקומי';

  @override
  String get toggleLocalEvaluation => 'הפעלת ניתוח מקומי';

  @override
  String get promoteVariation => 'העדפת וריאנט';

  @override
  String get makeMainLine => 'קביעה כוריאנט הראשי';

  @override
  String get deleteFromHere => 'מחיקה מכאן והלאה';

  @override
  String get collapseVariations => 'הסתרת מהלכים חלופיים';

  @override
  String get expandVariations => 'הצגת מהלכים חלופיים';

  @override
  String get forceVariation => 'וריאנט יחיד';

  @override
  String get copyVariationPgn => 'העתקת ה־PGN של הוריאנט';

  @override
  String get move => 'מסע';

  @override
  String get variantLoss => 'הפסד וריאנט';

  @override
  String get variantWin => 'ניצחון וריאנט';

  @override
  String get insufficientMaterial => 'היעדר חומר מספיק';

  @override
  String get pawnMove => 'מסע רגלי';

  @override
  String get capture => 'הכאה';

  @override
  String get close => 'סגירה';

  @override
  String get winning => 'זוכה';

  @override
  String get losing => 'מפסיד';

  @override
  String get drawn => 'תיקו';

  @override
  String get unknown => 'לא ידוע';

  @override
  String get database => 'מסד הנתונים';

  @override
  String get whiteDrawBlack => 'שחור / תיקו / לבן';

  @override
  String averageRatingX(String param) {
    return 'דירוג ממוצע: $param';
  }

  @override
  String get recentGames => 'משחקים אחרונים';

  @override
  String get topGames => 'המשחקים המובילים';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'משחקים על־גבי לוח של שחקנים עם דירוג פיד״ה של $param1+ מ־$param2 עד $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' עם עיגול, בהתבסס על מספר חצאי-המסעים עד ההכאה הבאה או מסע עם חייל';

  @override
  String get noGameFound => 'אין משחק זמין';

  @override
  String get maxDepthReached => 'הגעתם לעומק המירבי!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'להוסיף עוד משחקים מתפריט ההגדרות?';

  @override
  String get openings => 'פתיחות';

  @override
  String get openingExplorer => 'סייר הפתיחות';

  @override
  String get openingEndgameExplorer => 'סייר פתיחות/סיומים';

  @override
  String xOpeningExplorer(String param) {
    return 'חוקר פתיחות $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'שחקו את המהלך הראשון על פי סייר הפתיחות והסיומים';

  @override
  String get winPreventedBy50MoveRule => 'ניצחון נמנע מפאת כלל 50 המהלכים';

  @override
  String get lossSavedBy50MoveRule => 'הפסד נמנע מפאת כלל 50 המהלכים';

  @override
  String get winOr50MovesByPriorMistake => 'ניצחון או כלל 50 המסעים בגלל טעות קודמת';

  @override
  String get lossOr50MovesByPriorMistake => 'הפסד או כלל 50 המסעים בגלל טעות קודמת';

  @override
  String get unknownDueToRounding => 'ניצחון/הפסד מובטח רק אם שוחק ההמשך המומלץ של טבלת הסיומים מאז האכילה או מהלך הרגלי האחרון, עקב עיגול אפשרי של ערכי DTZ בטבלת הסיומים של Syzygy.';

  @override
  String get allSet => 'הכול מוכן!';

  @override
  String get importPgn => 'ייבוא PGN';

  @override
  String get delete => 'מחיקה';

  @override
  String get deleteThisImportedGame => 'מחק את המשחק המיובא הזה?';

  @override
  String get replayMode => 'מצב הרצת המסעים';

  @override
  String get realtimeReplay => 'זמן אמת';

  @override
  String get byCPL => 'עפ\"י CPL';

  @override
  String get openStudy => 'פתח לוח למידה';

  @override
  String get enable => 'הפעלה';

  @override
  String get bestMoveArrow => 'חץ המהלך הטוב ביותר';

  @override
  String get showVariationArrows => 'הצגת חצי ההמשכים האלטרנטיביים';

  @override
  String get evaluationGauge => 'מד הערכה';

  @override
  String get multipleLines => 'המשכים מקבילים';

  @override
  String get cpus => 'מעבדים';

  @override
  String get memory => 'זיכרון';

  @override
  String get infiniteAnalysis => 'ניתוח אינסופי';

  @override
  String get removesTheDepthLimit => 'מסיר את מגבלת העומק ו\"מחמם\" את המחשב';

  @override
  String get engineManager => 'מנהל המנועים';

  @override
  String get blunder => 'טעות גסה';

  @override
  String get mistake => 'שגיאה';

  @override
  String get inaccuracy => 'אי־דיוק';

  @override
  String get moveTimes => 'זמני המהלכים';

  @override
  String get flipBoard => 'סיבוב הלוח';

  @override
  String get threefoldRepetition => 'חזרה משולשת';

  @override
  String get claimADraw => 'דרוש תיקו';

  @override
  String get offerDraw => 'הצע תיקו';

  @override
  String get draw => 'תיקו';

  @override
  String get drawByMutualAgreement => 'תיקו על ידי הסכמה הדדית';

  @override
  String get fiftyMovesWithoutProgress => '50 מסעים בלי התקדמות';

  @override
  String get currentGames => 'המשחקים הנוכחיים';

  @override
  String get viewInFullSize => 'צפייה בגודל מלא';

  @override
  String get logOut => 'התנתק/י';

  @override
  String get signIn => 'התחבר/י';

  @override
  String get rememberMe => 'זכור אותי';

  @override
  String get youNeedAnAccountToDoThat => 'את/ה צריך/ה חשבון כדי לעשות פעולה זו';

  @override
  String get signUp => 'הירשם/י';

  @override
  String get computersAreNotAllowedToPlay => 'מחשבים ושחקנים הנעזרים במחשב במשחקיהם אינם מורשים לשחק. אנא הימנעו מהיעזרות במנועי שחמט, מאגרי מידע או שחקנים אחרים במהלך המשחק. בנוסף, מומלץ להימנע מיצירת משתמשים מרובים, שכן יצירת כמות מוגזמת של משתמשים תביא לסילוק מהאתר.';

  @override
  String get games => 'משחקים';

  @override
  String get forum => 'פורום';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 כתב/ה בנושא $param2';
  }

  @override
  String get latestForumPosts => 'פרסומים אחרונים בפורום';

  @override
  String get players => 'שחקנים';

  @override
  String get friends => 'חברים';

  @override
  String get discussions => 'דיונים';

  @override
  String get today => 'היום';

  @override
  String get yesterday => 'אתמול';

  @override
  String get minutesPerSide => 'דקות עבור כל צד';

  @override
  String get variant => 'גרסה';

  @override
  String get variants => 'גרסאות';

  @override
  String get timeControl => 'קטגוריית זמן';

  @override
  String get realTime => 'זמן אמת';

  @override
  String get correspondence => 'התכתבות';

  @override
  String get daysPerTurn => 'ימים למהלך';

  @override
  String get oneDay => 'יום אחד';

  @override
  String get time => 'זמן';

  @override
  String get rating => 'דירוג';

  @override
  String get ratingStats => 'סטטיסטיקות דירוג';

  @override
  String get username => 'שם משתמש';

  @override
  String get usernameOrEmail => 'שם משתמש או דוא״ל';

  @override
  String get changeUsername => 'שינוי שם המשתמש';

  @override
  String get changeUsernameNotSame => 'באותיות לועזיות ניתן להחליף אותיות קטנות בגדולות, למשל מ־\"johndoe\" ל־\"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'שינוי שם המשתמש. ניתן לעשותו פעם אחת בלבד, ורק על ידי החלפת אותיות גדולות בקטנות ולהיפך.';

  @override
  String get signupUsernameHint => 'ודאו ששם המשתמש שלכם מתאים גם לילדים. לא תוכלו לשנות אותו מאוחר יותר וחשבונות עם שמות משתמש לא הולמים יסגרו!';

  @override
  String get signupEmailHint => 'רק לצורך איפוס הסיסמה.';

  @override
  String get password => 'סיסמה';

  @override
  String get changePassword => 'שינוי סיסמה';

  @override
  String get changeEmail => 'שינוי דוא״ל';

  @override
  String get email => 'דוא״ל';

  @override
  String get passwordReset => 'איפוס סיסמה';

  @override
  String get forgotPassword => 'שכחת סיסמה?';

  @override
  String get error_weakPassword => 'הסיסמה הזו נפוצה ביותר וקלה מדי לניחוש.';

  @override
  String get error_namePassword => 'נא לא להשתמש בשם המשתמש בתור הסיסמה.';

  @override
  String get blankedPassword => 'השתמשת בסיסמה שלך באתר אחר, ויתכן שהיא מועדת לפריצה. כדי להגן על חשבונך ב־Lichess, עליך להגדיר סיסמה חדשה. תודה על ההבנה.';

  @override
  String get youAreLeavingLichess => 'את/ה עוזב/ת את Lichess';

  @override
  String get neverTypeYourPassword => 'לעולם אל תקלידו את סיסמתכם ב־Lichessבאף אתר אחר!';

  @override
  String proceedToX(String param) {
    return 'מעבר ל־$param';
  }

  @override
  String get passwordSuggestion => 'אל תשתמשו בסיסמה שהציע לכם אדם אחר. הוא ישתמש בה כדי לגנוב את חשבונכם!';

  @override
  String get emailSuggestion => 'אל תשמשו בכתובת מייל שהציע אדם אחר. הוא ישתמש בה כדי לגנוב את חשבונכם.';

  @override
  String get emailConfirmHelp => 'עזרה עם אימייל האישור';

  @override
  String get emailConfirmNotReceived => 'לא קיבלת מייל אישור לאחר שנרשמת?';

  @override
  String get whatSignupUsername => 'עם איזה שם משתמש נרשמת?';

  @override
  String usernameNotFound(String param) {
    return 'לא מצאנו את שם המשתמש: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'תוכל/י ליצור חשבון חדש עם שם המשתמש הזה';

  @override
  String emailSent(String param) {
    return 'שלחנו מייל ל־$param.';
  }

  @override
  String get emailCanTakeSomeTime => 'יתכן שלהודעה יקח זמן־מה להגיע.';

  @override
  String get refreshInboxAfterFiveMinutes => 'חכו 5 דקות ולאחר מכן בצעו ריענון לתיבת המייל.';

  @override
  String get checkSpamFolder => 'בדקו גם את תיבת דואר הזבל (״ספאם״). יתכן שההודעה הגיעה לשם בטעות. אם זה מה שקרה, סמנו אותה כלא־ספאם.';

  @override
  String get emailForSignupHelp => 'אם עדיין לא הצלחתם לפתור את הבעיה, שלחו לנו את המייל הבא:';

  @override
  String copyTextToEmail(String param) {
    return 'הדביקו את הטקסט הנ״ל ושלחו אותו ל־$param';
  }

  @override
  String get waitForSignupHelp => 'אנו נחזור אליכם בהקדם כדי לסייע לכם להשלים את ההרשמה.';

  @override
  String accountConfirmed(String param) {
    return 'המשתמש $param אושר בהצלחה.';
  }

  @override
  String accountCanLogin(String param) {
    return 'כעת תוכל/י להתחבר כ־$param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'אין צורך במייל אישור.';

  @override
  String accountClosed(String param) {
    return 'החשבון $param סגור.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'החשבון $param נפתח ללא כתובת מייל.';
  }

  @override
  String get rank => 'מיקום';

  @override
  String rankX(String param) {
    return 'מיקום: $param';
  }

  @override
  String get gamesPlayed => 'משחקים בטורניר';

  @override
  String get cancel => 'ביטול';

  @override
  String get whiteTimeOut => 'נגמר הזמן ללבן';

  @override
  String get blackTimeOut => 'נגמר הזמן לשחור';

  @override
  String get drawOfferSent => 'הצעת תיקו נשלחה';

  @override
  String get drawOfferAccepted => 'הצעת התיקו התקבלה';

  @override
  String get drawOfferCanceled => 'הצעת התיקו בוטלה';

  @override
  String get whiteOffersDraw => 'לבן מציע תיקו';

  @override
  String get blackOffersDraw => 'שחור מציע תיקו';

  @override
  String get whiteDeclinesDraw => 'לבן מסרב לתיקו';

  @override
  String get blackDeclinesDraw => 'שחור מסרב לתיקו';

  @override
  String get yourOpponentOffersADraw => 'יריבך מציע תיקו';

  @override
  String get accept => 'הסכמה';

  @override
  String get decline => 'סירוב';

  @override
  String get playingRightNow => 'מתקיים עכשיו';

  @override
  String get eventInProgress => 'מתקיים עכשיו';

  @override
  String get finished => 'הסתיים';

  @override
  String get abortGame => 'ביטול המשחק';

  @override
  String get gameAborted => 'המשחק בוטל';

  @override
  String get standard => 'רגיל';

  @override
  String get customPosition => 'עמדה מותאמת אישית';

  @override
  String get unlimited => 'בלתי מוגבל';

  @override
  String get mode => 'מצב';

  @override
  String get casual => 'לא מדורג';

  @override
  String get rated => 'מדורג';

  @override
  String get casualTournament => 'לא מדורג';

  @override
  String get ratedTournament => 'מדורג';

  @override
  String get thisGameIsRated => 'משחק זה מדורג';

  @override
  String get rematch => 'משחק חוזר';

  @override
  String get rematchOfferSent => 'הצעה למשחק חוזר נשלחה';

  @override
  String get rematchOfferAccepted => 'הצעה למשחק חוזר התקבלה';

  @override
  String get rematchOfferCanceled => 'בקשה למשחק חוזר בוטלה';

  @override
  String get rematchOfferDeclined => 'בקשה למשחק חוזר נדחתה';

  @override
  String get cancelRematchOffer => 'ביטול ההצעה למשחק חוזר';

  @override
  String get viewRematch => 'צפייה במשחק החוזר';

  @override
  String get confirmMove => 'אישור המהלך';

  @override
  String get play => 'שחקו';

  @override
  String get inbox => 'תיבת דואר';

  @override
  String get chatRoom => 'חדר צ\'אט';

  @override
  String get loginToChat => 'התחבר/י כדי לדבר בצ\'אט';

  @override
  String get youHaveBeenTimedOut => 'הושעית משיחה בצ׳אט.';

  @override
  String get spectatorRoom => 'חדר צופים';

  @override
  String get composeMessage => 'כתיבת הודעה';

  @override
  String get subject => 'נושא';

  @override
  String get send => 'שליחה';

  @override
  String get incrementInSeconds => 'תוספת בשניות';

  @override
  String get freeOnlineChess => 'שחמט חינמי ברשת';

  @override
  String get exportGames => 'ייצוא משחקים';

  @override
  String get ratingRange => 'טווח דירוג';

  @override
  String get thisAccountViolatedTos => 'החשבון הזה הפר את תנאי השימוש של ליצ\'ס';

  @override
  String get openingExplorerAndTablebase => 'סייר הפתיחות וטבלאות סיומים';

  @override
  String get takeback => 'החזרת מהלך';

  @override
  String get proposeATakeback => 'הצע החזרת המהלך האחרון';

  @override
  String get takebackPropositionSent => 'הצעה להחזרת המהלך האחרון נשלחה';

  @override
  String get takebackPropositionDeclined => 'הצעה להחזרת המהלך האחרון נדחתה';

  @override
  String get takebackPropositionAccepted => 'הצעה להחזרת המהלך האחרון התקבלה';

  @override
  String get takebackPropositionCanceled => 'הצעה להחזרת המהלך האחרון בוטלה';

  @override
  String get yourOpponentProposesATakeback => 'יריבך מציע/ה להחזיר את המהלך האחרון';

  @override
  String get bookmarkThisGame => 'הוסף משחק זה למועדפים';

  @override
  String get tournament => 'טורניר';

  @override
  String get tournaments => 'טורנירים';

  @override
  String get tournamentPoints => 'נקודות טורניר';

  @override
  String get viewTournament => 'צפייה בטורניר';

  @override
  String get backToTournament => 'חזרה לטורניר';

  @override
  String get noDrawBeforeSwissLimit => 'אין אפשרות לסיים את המשחק בתיקו בטורניר שוויצרי לפני ששוחקו 30 מהלכים.';

  @override
  String get thematic => 'נושאי';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'דירוג ה־$param שלך זמני';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'דירוגך ב$param1 גבוה מדי ($param2)';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'דירוגך השבועי ב$param1 גבוה מדי ($param2)';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'דירוגך ב$param1 נמוך מדי ($param2)';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'מדורג/ת ≥ $param1 ב$param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'מדורג/ת ≤ $param1 ב$param2 בשבוע האחרון';
  }

  @override
  String mustBeInTeam(String param) {
    return 'חובה להיות בקבוצה $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'את/ה לא נמצא/ת בקבוצה $param';
  }

  @override
  String get backToGame => 'חזור למשחק';

  @override
  String get siteDescription => 'שרת שחמט מקוון חינמי. שחקו שחמט כעת בממשק נקי. בלי הרשמה, בלי פרסומות, בלי להתקין שום דבר. שחקו שחמט עם המחשב, עם חברים או עם יריבים אקראיים.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 הצטרף/ה לקבוצה $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 יצר/ה את הקבוצה $param2';
  }

  @override
  String get startedStreaming => 'התחיל/ה לשדר';

  @override
  String xStartedStreaming(String param) {
    return '$param התחיל/ה לשדר';
  }

  @override
  String get averageElo => 'דירוג ממוצע';

  @override
  String get location => 'מיקום';

  @override
  String get filterGames => 'סנן משחקים';

  @override
  String get reset => 'אתחל';

  @override
  String get apply => 'שמירה';

  @override
  String get save => 'שמירה';

  @override
  String get leaderboard => 'טבלת השחקנים המובילים';

  @override
  String get screenshotCurrentPosition => 'צילום העמדה הנוכחית';

  @override
  String get gameAsGIF => 'המשחק בתור GIF';

  @override
  String get pasteTheFenStringHere => 'הדביקו מחרוזת FEN כאן';

  @override
  String get pasteThePgnStringHere => 'הדביקו מחרוזת PGN כאן';

  @override
  String get orUploadPgnFile => 'או העלו קובץ PGN';

  @override
  String get fromPosition => 'מעמדה מסוימת';

  @override
  String get continueFromHere => 'המשיכו מכאן';

  @override
  String get toStudy => 'לוח למידה';

  @override
  String get importGame => 'ייבוא משחק';

  @override
  String get importGameExplanation => 'כשמדביקים משחק בפורמט PGN מקבלים אפשרות לצפות במשחק ולדפדף בו, ניתוח ממוחשב, צ׳אט וקישור לשיתוף.';

  @override
  String get importGameCaveat => 'וריאציות — כלומר רצפי מהלכים שאינם המסעים הראשיים (mainline) — יימחקו. כדי לשמור אותן, ייבאו את ה־PGN כלוח למידה.';

  @override
  String get importGameDataPrivacyWarning => 'ה־PGN הזה זמין לציבור. כדי לייצא את המשחק באופן פרטי, השתמשו בלוח למידה.';

  @override
  String get thisIsAChessCaptcha => 'זה CAPTCHA של שחמט.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'לחץ/י על הלוח כדי לעשות מהלך, כדי להוכיח שאת/ה בן אנוש.';

  @override
  String get captcha_fail => 'אנא בצע/י את המהלך הנכון בלוח ה־Captcha.';

  @override
  String get notACheckmate => 'לא מט';

  @override
  String get whiteCheckmatesInOneMove => 'מט ב־1 ללבן';

  @override
  String get blackCheckmatesInOneMove => 'מט ב־1 לשחור';

  @override
  String get retry => 'נסו שוב';

  @override
  String get reconnecting => 'מתחבר מחדש';

  @override
  String get noNetwork => 'לא מחובר';

  @override
  String get favoriteOpponents => 'יריבים מועדפים';

  @override
  String get follow => 'עקבו';

  @override
  String get following => 'ברשימת המעקב';

  @override
  String get unfollow => 'הפסיקו מעקב';

  @override
  String followX(String param) {
    return 'עקבו אחר $param';
  }

  @override
  String unfollowX(String param) {
    return 'הפסיקו לעקוב אחר $param';
  }

  @override
  String get block => 'חסמו';

  @override
  String get blocked => 'חסום';

  @override
  String get unblock => 'בטל חסימה';

  @override
  String get followsYou => 'עוקב/ת אחריך';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 התחיל/ה לעקוב אחרי $param2';
  }

  @override
  String get more => 'עוד';

  @override
  String get memberSince => 'רשום/ה מ';

  @override
  String lastSeenActive(String param) {
    return 'נכנס/ה לאחרונה $param';
  }

  @override
  String get player => 'שחקן/ית';

  @override
  String get list => 'רשימה';

  @override
  String get graph => 'גרף';

  @override
  String get required => 'נדרש.';

  @override
  String get openTournaments => 'הטורנירים הפתוחים';

  @override
  String get duration => 'משך';

  @override
  String get winner => 'מנצח';

  @override
  String get standing => 'מקום';

  @override
  String get createANewTournament => 'יצירת טורניר חדש';

  @override
  String get tournamentCalendar => 'לו\"ז טורנירים';

  @override
  String get conditionOfEntry => 'תנאי הכניסה:';

  @override
  String get advancedSettings => 'הגדרות מתקדמות';

  @override
  String get safeTournamentName => 'בחר/י שם בטוח מאוד לטורניר.';

  @override
  String get inappropriateNameWarning => 'כל דבר לא הולם ולו במעט עלול לגרום לסגירת חשבונך.';

  @override
  String get emptyTournamentName => 'השאירו ריק כדי לקרוא לטורניר על שם שחקן/ית שח דגול/ה.';

  @override
  String get makePrivateTournament => 'הפכו את הטורניר לפרטי, והגבילו את הכניסה עם סיסמה';

  @override
  String get join => 'הצטרף/י';

  @override
  String get withdraw => 'צא/י';

  @override
  String get points => 'נקודות';

  @override
  String get wins => 'ניצחונות';

  @override
  String get losses => 'הפסדים';

  @override
  String get createdBy => 'נוצר ע\"י';

  @override
  String get tournamentIsStarting => 'הטורניר מתחיל';

  @override
  String get tournamentPairingsAreNowClosed => 'השיבוץ לזוגות בטורניר הסתיים.';

  @override
  String standByX(String param) {
    return '$param, נא להמתין, משבצים לזוגות, היו מוכנים!';
  }

  @override
  String get pause => 'השהה';

  @override
  String get resume => 'המשך';

  @override
  String get youArePlaying => 'את/ה משחק/ת!';

  @override
  String get winRate => 'שיעור זכייה';

  @override
  String get berserkRate => 'אחוז המשחקים באטרף';

  @override
  String get performance => 'דירוג הביצוע';

  @override
  String get tournamentComplete => 'הטורניר הושלם';

  @override
  String get movesPlayed => 'מהלכים ששוחקו';

  @override
  String get whiteWins => 'ניצחונות כלבן';

  @override
  String get blackWins => 'ניצחונות כשחור';

  @override
  String get drawRate => 'שיעור תוצאות התיקו';

  @override
  String get draws => 'תוצאות תיקו';

  @override
  String nextXTournament(String param) {
    return 'טורניר ה$param הבא:';
  }

  @override
  String get averageOpponent => 'יריב ממוצע';

  @override
  String get boardEditor => 'עריכת לוח';

  @override
  String get setTheBoard => 'עריכת הלוח';

  @override
  String get popularOpenings => 'פתיחות פופולריות';

  @override
  String get endgamePositions => 'עמדות סיום';

  @override
  String chess960StartPosition(String param) {
    return 'עמדת הפתיחה: $param';
  }

  @override
  String get startPosition => 'עמדת הפתיחה';

  @override
  String get clearBoard => 'ניקוי הלוח';

  @override
  String get loadPosition => 'טעינת עמדה';

  @override
  String get isPrivate => 'פרטי';

  @override
  String reportXToModerators(String param) {
    return 'דווח/י על $param למנהלים';
  }

  @override
  String profileCompletion(String param) {
    return 'השלמת הפרופיל: $param';
  }

  @override
  String xRating(String param) {
    return 'דירוג $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'אם אין, השאירו ריק';

  @override
  String get profile => 'פרופיל';

  @override
  String get editProfile => 'עריכת פרופיל';

  @override
  String get realName => 'שם אמיתי';

  @override
  String get setFlair => 'הגדירו את הסמליל שלכם';

  @override
  String get flair => 'סמליל';

  @override
  String get youCanHideFlair => 'ישנה הגדרה שמאפשרת להסתיר את כל הסמלילים באתר.';

  @override
  String get biography => 'ביוגרפיה';

  @override
  String get countryRegion => 'מדינה או אזור';

  @override
  String get thankYou => 'תודות מקרב לב';

  @override
  String get socialMediaLinks => 'קישורים לרשתות חברתיות';

  @override
  String get oneUrlPerLine => 'שורה עבור כל כתובת.';

  @override
  String get inlineNotation => 'תיאור מהלכים בשורה';

  @override
  String get makeAStudy => 'כדי לשמור ולשתף, תוכל/י ליצור לוח למידה.';

  @override
  String get clearSavedMoves => 'הסרת המהלכים';

  @override
  String get previouslyOnLichessTV => 'לאחרונה בטלוויזיה של ליצ\'ס';

  @override
  String get onlinePlayers => 'שחקנים מחוברים';

  @override
  String get activePlayers => 'הכי פעילים';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'שימו לב! המשחק מדורג אך אין שעון.';

  @override
  String get success => 'הפעולה הושלמה';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'המשיכו אוטומטית למשחק הבא אחרי שביצעתם מהלך';

  @override
  String get autoSwitch => 'החלפה אוטומטית';

  @override
  String get puzzles => 'חידות';

  @override
  String get onlineBots => 'בוטים מחוברים';

  @override
  String get name => 'שם';

  @override
  String get description => 'תיאור';

  @override
  String get descPrivate => 'תיאור פרטי';

  @override
  String get descPrivateHelp => 'טקסט שרק חברי הקבוצה יראו. אם נכתב, יחליף את התיאור הפומבי עבור חברי הקבוצה.';

  @override
  String get no => 'לא';

  @override
  String get yes => 'כן';

  @override
  String get help => 'עזרה:';

  @override
  String get createANewTopic => 'צרו נושא חדש';

  @override
  String get topics => 'נושאים';

  @override
  String get posts => 'פוסטים';

  @override
  String get lastPost => 'הפוסט האחרון';

  @override
  String get views => 'צפיות';

  @override
  String get replies => 'תגובות';

  @override
  String get replyToThisTopic => 'הגיבו לפוסט הזה';

  @override
  String get reply => 'תגובה';

  @override
  String get message => 'הודעה';

  @override
  String get createTheTopic => 'צור אשכול';

  @override
  String get reportAUser => 'דווח/י על משתמש/ת';

  @override
  String get user => 'משתמש/ת';

  @override
  String get reason => 'סיבה';

  @override
  String get whatIsIheMatter => 'מה הבעיה?';

  @override
  String get cheat => 'רמאות';

  @override
  String get troll => 'הטרלה';

  @override
  String get other => 'אחר';

  @override
  String get reportDescriptionHelp => 'הדביקו את הקישור למשחק(ים) והסבירו מה לא בסדר בהתנהגות המשתמש. אל תכתבו סתם ״השחקן/ית מרמה״, הסבירו לנו כיצד הגעתם למסקנה הזו. הדיווח יטופל מהר יותר אם ייכתב באנגלית.';

  @override
  String get error_provideOneCheatedGameLink => 'בבקשה לספק לפחות קישור אחד למשחק עם רמאות.';

  @override
  String by(String param) {
    return 'על־ידי $param';
  }

  @override
  String importedByX(String param) {
    return 'יובא ע\"י $param';
  }

  @override
  String get thisTopicIsNowClosed => 'הנושא לא מקבל יותר תגובות.';

  @override
  String get blog => 'בלוג';

  @override
  String get notes => 'הערות';

  @override
  String get typePrivateNotesHere => 'הקלידו הערות פרטיות כאן';

  @override
  String get writeAPrivateNoteAboutThisUser => 'כתבו הערה פרטית בנוגע למשתמש הזה';

  @override
  String get noNoteYet => 'אין עדיין הערות';

  @override
  String get invalidUsernameOrPassword => 'שגיאה בשם המשתמש או בסיסמה';

  @override
  String get incorrectPassword => 'סיסמה שגויה';

  @override
  String get invalidAuthenticationCode => 'קוד אימות לא תקין';

  @override
  String get emailMeALink => 'שלחו לי קישור בדוא״ל';

  @override
  String get currentPassword => 'הסיסמה הנוכחית';

  @override
  String get newPassword => 'סיסמה חדשה';

  @override
  String get newPasswordAgain => 'סיסמא חדשה (בשנית)';

  @override
  String get newPasswordsDontMatch => 'הסיסמאות החדשות אינן תואמות';

  @override
  String get newPasswordStrength => 'חוזק הסיסמה';

  @override
  String get clockInitialTime => 'זמן התחלתי בשעון';

  @override
  String get clockIncrement => 'תוספת זמן';

  @override
  String get privacy => 'פרטיות';

  @override
  String get privacyPolicy => 'מדיניות הפרטיות';

  @override
  String get letOtherPlayersFollowYou => 'אפשרו לשחקנים אחרים לעקוב אחריכם';

  @override
  String get letOtherPlayersChallengeYou => 'אפשרו לשחקנים אחרים להזמינכם למשחק';

  @override
  String get letOtherPlayersInviteYouToStudy => 'אפשרו לשחקנים אחרים להזמין אתכם ללוחות למידה';

  @override
  String get sound => 'צלילים';

  @override
  String get none => 'ללא';

  @override
  String get fast => 'מהיר';

  @override
  String get normal => 'רגיל';

  @override
  String get slow => 'איטי';

  @override
  String get insideTheBoard => 'בתוך הלוח';

  @override
  String get outsideTheBoard => 'מחוץ ללוח';

  @override
  String get allSquaresOfTheBoard => 'כל משבצות הלוח';

  @override
  String get onSlowGames => 'במשחקים איטיים';

  @override
  String get always => 'תמיד';

  @override
  String get never => 'אף פעם';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 מתחרה ב־$param2';
  }

  @override
  String get victory => 'ניצחון';

  @override
  String get defeat => 'הפסד';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 נגד $param2 ב$param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 נגד $param2 ב$param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 נגד $param2 ב$param3';
  }

  @override
  String get timeline => 'ציר הזמן';

  @override
  String get starting => 'התחלה:';

  @override
  String get allInformationIsPublicAndOptional => 'כל המידע הוא פומבי ואופציונלי.';

  @override
  String get biographyDescription => 'ספר/י על עצמך, מה את/ה אוהב/ת בשחמט, הפתיחה המועדפת עליך, משחקים, שחקנים...';

  @override
  String get listBlockedPlayers => 'רשימת שחקנים שחסמת';

  @override
  String get human => 'בן אנוש';

  @override
  String get computer => 'מחשב';

  @override
  String get side => 'צד';

  @override
  String get clock => 'שעון';

  @override
  String get opponent => 'יריב';

  @override
  String get learnMenu => 'למד/י';

  @override
  String get studyMenu => 'לוחות למידה';

  @override
  String get practice => 'תרגול';

  @override
  String get community => 'קהילה';

  @override
  String get tools => 'כלים';

  @override
  String get increment => 'שניות למהלך';

  @override
  String get error_unknown => 'ערך לא תקין';

  @override
  String get error_required => 'שדה חובה';

  @override
  String get error_email => 'כתובת דוא״ל זו אינה תקינה';

  @override
  String get error_email_acceptable => 'כתובת דוא״ל זו אינה קבילה. אנא בדקו אותה בשנית ונסו שוב.';

  @override
  String get error_email_unique => 'כתובת דוא״ל לא חוקית או תפוסה כבר';

  @override
  String get error_email_different => 'זאת כתובת הדוא״ל שלך כבר';

  @override
  String error_minLength(String param) {
    return 'לפחות $param תווים';
  }

  @override
  String error_maxLength(String param) {
    return 'עד $param תווים';
  }

  @override
  String error_min(String param) {
    return 'לפחות $param';
  }

  @override
  String error_max(String param) {
    return '$param או פחות';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'אם הדירוג ± $param';
  }

  @override
  String get ifRegistered => 'רק משתמשים רשומים';

  @override
  String get onlyExistingConversations => 'שיחה קיימת בלבד';

  @override
  String get onlyFriends => 'חברים בלבד';

  @override
  String get menu => 'תפריט';

  @override
  String get castling => 'הצרחה';

  @override
  String get whiteCastlingKingside => 'O-O ללבן';

  @override
  String get blackCastlingKingside => 'O-O לשחור';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'זמן במשחק: $param';
  }

  @override
  String get watchGames => 'צפייה במשחקים';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'זמן בטלוויזיה: $param';
  }

  @override
  String get watch => 'צפו';

  @override
  String get videoLibrary => 'ספריית וידאו';

  @override
  String get streamersMenu => 'משדרים';

  @override
  String get mobileApp => 'אפליקציה לטלפון';

  @override
  String get webmasters => 'עבור מתכנתים';

  @override
  String get about => 'על אודות';

  @override
  String aboutX(String param) {
    return 'על אודות $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 הוא שרת שחמט חינמי ($param2), חופשי, עם קוד פחוח וללא פרסומות.';
  }

  @override
  String get really => 'באמת';

  @override
  String get contribute => 'תרומה ומעורבות';

  @override
  String get termsOfService => 'תנאים לשימוש באתר';

  @override
  String get sourceCode => 'קוד המקור';

  @override
  String get simultaneousExhibitions => 'משחקים סימולטניים';

  @override
  String get host => 'מארח/ת';

  @override
  String hostColorX(String param) {
    return 'צבע המארח/ת: $param';
  }

  @override
  String get yourPendingSimuls => 'המשחקים הסימולטניים העתידיים שלך';

  @override
  String get createdSimuls => 'משחקים סימולטניים חדשים';

  @override
  String get hostANewSimul => 'ארח/י משחק סימולטני חדש';

  @override
  String get signUpToHostOrJoinASimul => 'הירשמו כדי לארח משחקים סימולטניים או להשתתף בהם';

  @override
  String get noSimulFound => 'המשחק הסימולטני לא נמצא';

  @override
  String get noSimulExplanation => 'המשחק הסימולטני אינו קיים.';

  @override
  String get returnToSimulHomepage => 'חזרה לדף הבית של המשחקים הסימולטניים';

  @override
  String get aboutSimul => 'משחק סימולטני מערב שחקן יחיד אשר משחק נגד שחקנים רבים בו זמנית.';

  @override
  String get aboutSimulImage => 'מתוך 50 משחקים בו־זמנית, פישר ניצח ב־47 משחקים, השיג 2 תוצאות תיקו והפסיד במשחק אחד.';

  @override
  String get aboutSimulRealLife => 'המושג נלקח מאירועים בעולם האמיתי. בחיים האמיתיים, המארח/ת עובר/ת משולחן לשולחן ומשחק/ת מהלך אחד בכל פעם.';

  @override
  String get aboutSimulRules => 'כאשר המשחק הסימולטני מתחיל, כל שחקן מתחיל את המשחק עם המארח, אשר משחק בתור הלבן. המשחק הסימולטני מסתיים כאשר כל המשחקים מסתיימים.';

  @override
  String get aboutSimulSettings => 'המשחקים הסימולטניים הם תמיד לא מדורגים. האפשרויות של: \"נסה שוב\", ״החזר מהלך״ ו\"הוסף זמן\" מבוטלות.';

  @override
  String get create => 'צור';

  @override
  String get whenCreateSimul => 'כאשר את/ה יוצר/ת משחק סימולטני, את/ה זוכה לשחק עם שחקנים רבים בו זמנית.';

  @override
  String get simulVariantsHint => 'אם תבחר/י מספר גרסאות, כל שחקן יריב יזכה לבחור גרסה למשחק.';

  @override
  String get simulClockHint => 'התקנת שעון של פישר. ככל שתשחק/י נגד יותר שחקנים, כך תזדקק/י ליותר זמן.';

  @override
  String get simulAddExtraTime => 'באפשרותך להוסיף זמן לשעון שלך כדי לעזור לך להתמודד עם המשחק הסימולטני.';

  @override
  String get simulHostExtraTime => 'זמן נוסף למארח/ת';

  @override
  String get simulAddExtraTimePerPlayer => 'הוספת זמן לשעון שלך בכל פעם שמצטרף/ת שחקן/ית למשחק הסימולטני.';

  @override
  String get simulHostExtraTimePerPlayer => 'זמן נוסף למארח/ת עבור כל שחקן/ית שמצטרף/ת';

  @override
  String get lichessTournaments => 'טורנירים של ליצ\'ס';

  @override
  String get tournamentFAQ => 'שאלות נפוצות לגבי טורנירי הזירה';

  @override
  String get timeBeforeTournamentStarts => 'זמן לתחילת הטורניר';

  @override
  String get averageCentipawnLoss => 'אובדן מאית־חייל ממוצע';

  @override
  String get accuracy => 'דיוק';

  @override
  String get keyboardShortcuts => 'קיצורי מקלדת';

  @override
  String get keyMoveBackwardOrForward => 'גלול אחורה/קדימה';

  @override
  String get keyGoToStartOrEnd => 'מעבר להתחלה/לסיום';

  @override
  String get keyCycleSelectedVariation => 'מחזור הוריאציה שנבחרה ';

  @override
  String get keyShowOrHideComments => 'הצג/הסתר הערות';

  @override
  String get keyEnterOrExitVariation => 'כנס לגרסה או צא ממנה';

  @override
  String get keyRequestComputerAnalysis => 'בקשו ניתוח ממוחשב, למדו מטעויותיכם';

  @override
  String get keyNextLearnFromYourMistakes => 'הבא (למדו מטעויותיכם)';

  @override
  String get keyNextBlunder => 'הטעות הגסה הבאה';

  @override
  String get keyNextMistake => 'הטעות הבאה';

  @override
  String get keyNextInaccuracy => 'אי־הדיוק הבא';

  @override
  String get keyPreviousBranch => 'הענף הקודם';

  @override
  String get keyNextBranch => 'הענף הבא';

  @override
  String get toggleVariationArrows => 'הפעלת חצי הווריאנטים';

  @override
  String get cyclePreviousOrNextVariation => 'מחזור הוריאנט הקודם/הבא';

  @override
  String get toggleGlyphAnnotations => 'הפעלת סמלי ההערות';

  @override
  String get togglePositionAnnotations => 'הפעלת הערות עמדתיות';

  @override
  String get variationArrowsInfo => 'חצי הווריאנטים מאפשרים ניווט קל ללא צורך ברשימת המסעים.';

  @override
  String get playSelectedMove => 'שחקו את המהלך שנבחר';

  @override
  String get newTournament => 'טורניר חדש';

  @override
  String get tournamentHomeTitle => 'טורנירי שחמט הכוללים משחקים עם מגבלות זמן וסוגי שחמט מגוונים';

  @override
  String get tournamentHomeDescription => 'שחק בטורנירי שחמט מהירים! הצטרף לטורניר רשמי ומתוכנן, או צור אחד משלך. Bullet, Blitz, Threecheck, Chess960, King of the Hill, Classical, ואפשרויות נוספות של משחקי שחמט מהנים.';

  @override
  String get tournamentNotFound => 'הטורניר לא נמצא';

  @override
  String get tournamentDoesNotExist => 'הטורניר הזה אינו קיים.';

  @override
  String get tournamentMayHaveBeenCanceled => 'קיימת אפשרות שהטורניר בוטל, במקרה שכל השחקנים יצאו ממנו לפני התחלתו.';

  @override
  String get returnToTournamentsHomepage => 'חזרה לדף הבית של הטורנירים';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'התפלגות שבועית של דירוגי $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'דירוגך במשחקי $param1 הוא $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'דירוגך גבוה יותר מ־$param1 משחקני $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 טוב יותר מ־$param2 משחקני ה$param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'יותר טוב מ־$param1 משחקני ה־$param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'טרם נקבע לך דירוג במשחקי $param.';
  }

  @override
  String get yourRating => 'הדירוג שלך';

  @override
  String get cumulative => 'מצטבר';

  @override
  String get glicko2Rating => 'דירוג Glicko-2';

  @override
  String get checkYourEmail => 'נא לבדוק את הדוא״ל שלך';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'שלחנו לך אימייל. לחץ על הלינק במייל כדי להפעיל את חשבונך.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'אם את/ה לא מוצא/ת את המייל, חפש/י במקומות אחרים, כגון דואר זבל, ספאם או תיקיות אחרות.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'שלחנו אימייל ל$param. לחץ על הלינק באימייל כדי לאפס את הסיסמה.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'על ידי הרשמה, את/ה מסכים/ה ל$param.';
  }

  @override
  String readAboutOur(String param) {
    return 'קראו את $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'עיכוב הרשת בינך לבין ליצ\'ס';

  @override
  String get timeToProcessAMoveOnLichessServer => 'זמן לעיבוד מהלך בשרת ליצ\'ס';

  @override
  String get downloadAnnotated => 'הורדה עם הערות';

  @override
  String get downloadRaw => 'הורדה ללא הערות';

  @override
  String get downloadImported => 'הורד משחק מיובא';

  @override
  String get crosstable => 'חשבון הנקודות';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'ניתן גם לגלול כדי להתקדם במשחק.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'רחפו מעל וריאציות המחשב עם העכבר בשביל לראות תצוגה מקדימה שלהן.';

  @override
  String get analysisShapesHowTo => 'הקש \"Shift\" + מקש עכבר שמאלי או ימני כדי לצייר חצים ועיגולים על הלוח.';

  @override
  String get letOtherPlayersMessageYou => 'אפשר/י לשחקנים אחרים לשלוח לך הודעות';

  @override
  String get receiveForumNotifications => 'קבל/י התראות כשאת/ה מתויג/ת בפורום';

  @override
  String get shareYourInsightsData => 'שתף/י את תובנות השחמט שלך';

  @override
  String get withNobody => 'עם אף אחד';

  @override
  String get withFriends => 'עם חברים';

  @override
  String get withEverybody => 'עם כולם';

  @override
  String get kidMode => 'מצב ילדים';

  @override
  String get kidModeIsEnabled => 'מצב ילדים מופעל.';

  @override
  String get kidModeExplanation => 'בשביל הבטיחות. במצב ילדים, כל אמצעי התקשורת באתר מבוטלים. הפעילו אופציה זו עבור ילדיכם ועבור תלמידי בית ספר. זאת כדי להגן עליהם מפני משתמשים אחרים.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'במצב ילדים הסמל של ליצ\'ס מקבל אייקון $param, כדי שתדעו שילדיכם מוגנים.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'החשבון שלך מנוהל. תוכל/י לבקש מהמורה שלך לשחמט להסיר את מצב הילדים.';

  @override
  String get enableKidMode => 'הפעילו מצב ילדים';

  @override
  String get disableKidMode => 'בטל מצב ילדים';

  @override
  String get security => 'אבטחה';

  @override
  String get sessions => 'מכשירים מחוברים';

  @override
  String get revokeAllSessions => 'נתק את כל המכשירים';

  @override
  String get playChessEverywhere => 'שחקו שחמט בכל מקום';

  @override
  String get asFreeAsLichess => 'חינמי לחלוטין, ממש כמו האתר!';

  @override
  String get builtForTheLoveOfChessNotMoney => 'נבנה בגלל אהבה למשחק, לא כדי להרוויח כסף';

  @override
  String get everybodyGetsAllFeaturesForFree => 'כולם מקבלים את כל התוכן בחינם';

  @override
  String get zeroAdvertisement => 'אפס פרסומות';

  @override
  String get fullFeatured => 'מאפיינים';

  @override
  String get phoneAndTablet => 'טלפון וטאבלט';

  @override
  String get bulletBlitzClassical => 'קליע, בזק, קלאסי';

  @override
  String get correspondenceChess => 'שחמט בהתכתבות';

  @override
  String get onlineAndOfflinePlay => 'שחקו עם או בלי חיבור לאינטרנט';

  @override
  String get viewTheSolution => 'הראה פתרון';

  @override
  String get followAndChallengeFriends => 'עקבו אחר חברים והזמינו אותם למשחק';

  @override
  String get gameAnalysis => 'ניתוח המשחק';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 מארח/ת $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 מצטרף/ת ל־$param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 אוהב/ת את $param2';
  }

  @override
  String get quickPairing => 'הצטרפות מהירה';

  @override
  String get lobby => 'לובי';

  @override
  String get anonymous => 'אנונימי';

  @override
  String yourScore(String param) {
    return 'התוצאה שלך: $param';
  }

  @override
  String get language => 'שפה';

  @override
  String get background => 'רקע';

  @override
  String get light => 'בהיר';

  @override
  String get dark => 'כהה';

  @override
  String get transparent => 'שקוף';

  @override
  String get deviceTheme => 'לפי הגדרות המכשיר';

  @override
  String get backgroundImageUrl => 'כתובת תמונת רקע (URL):';

  @override
  String get board => 'לוח';

  @override
  String get size => 'גודל';

  @override
  String get opacity => 'אטימות';

  @override
  String get brightness => 'בהירות';

  @override
  String get hue => 'גוון';

  @override
  String get boardReset => 'חזרה לצבעי ברירת המחדל';

  @override
  String get pieceSet => 'סט הכלים';

  @override
  String get embedInYourWebsite => 'הטמעה באתרך';

  @override
  String get usernameAlreadyUsed => 'שם המשתמש הזה כבר קיים, אנא נסו שם משתמש אחר.';

  @override
  String get usernamePrefixInvalid => 'שם המשתמש חייב להתחיל באות.';

  @override
  String get usernameSuffixInvalid => 'שם המשתמש חייב להסתיים באות או מספר.';

  @override
  String get usernameCharsInvalid => 'שם המשתמש חייב להכיל רק אותיות, מספרים, מקפים תחתונים ומקפים. רצף מקפים אינו אפשרי.';

  @override
  String get usernameUnacceptable => 'שם המשתמש הזה לא מקובל.';

  @override
  String get playChessInStyle => 'שחק/י שחמט בסגנון';

  @override
  String get chessBasics => 'יסודות השחמט';

  @override
  String get coaches => 'מאמנים';

  @override
  String get invalidPgn => 'PGN לא חוקי';

  @override
  String get invalidFen => 'FEN לא חוקי';

  @override
  String get custom => 'התאמה אישית';

  @override
  String get notifications => 'התראות';

  @override
  String notificationsX(String param1) {
    return 'התראות: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'דירוג: $param';
  }

  @override
  String get practiceWithComputer => 'התאמן/י עם המחשב';

  @override
  String anotherWasX(String param) {
    return 'מהלך טוב נוסף היה $param';
  }

  @override
  String bestWasX(String param) {
    return 'המהלך הטוב ביותר היה $param';
  }

  @override
  String get youBrowsedAway => 'גלשתם למחוזות אחרים';

  @override
  String get resumePractice => 'המשיכו להתאמן';

  @override
  String get drawByFiftyMoves => 'המשחק הסתיים בתיקו בשל חוק 50 המסעים.';

  @override
  String get theGameIsADraw => 'המשחק הסתיים בתיקו.';

  @override
  String get computerThinking => 'המחשב חושב ...';

  @override
  String get seeBestMove => 'הראה את המהלך הטוב היותר';

  @override
  String get hideBestMove => 'הסתר את המהלך הטוב ביותר';

  @override
  String get getAHint => 'קבל/י רמז';

  @override
  String get evaluatingYourMove => 'מעריך את המסע שלך ...';

  @override
  String get whiteWinsGame => 'הלבן מנצח';

  @override
  String get blackWinsGame => 'השחור מנצח';

  @override
  String get learnFromYourMistakes => 'למד/י מהטעויות שלך';

  @override
  String get learnFromThisMistake => 'למד/י מהטעות הזאת';

  @override
  String get skipThisMove => 'דלג/י על מהלך זה';

  @override
  String get next => 'הבא';

  @override
  String xWasPlayed(String param) {
    return '$param שוחק';
  }

  @override
  String get findBetterMoveForWhite => 'מצא/י מהלך טוב יותר ללבן';

  @override
  String get findBetterMoveForBlack => 'מצא/י מהלך טוב יותר לשחור';

  @override
  String get resumeLearning => 'המשיכו ללמוד';

  @override
  String get youCanDoBetter => 'יש מהלך טוב יותר:)';

  @override
  String get tryAnotherMoveForWhite => 'נסו למצוא מהלך טוב יותר ללבן';

  @override
  String get tryAnotherMoveForBlack => 'נסו למצוא מהלך טוב יותר לשחור';

  @override
  String get solution => 'פתרון';

  @override
  String get waitingForAnalysis => 'מחכים לניתוח המשחק';

  @override
  String get noMistakesFoundForWhite => 'אף טעות לא נמצאה עבור הלבן';

  @override
  String get noMistakesFoundForBlack => 'אף טעות לא נמצאה עבור השחור';

  @override
  String get doneReviewingWhiteMistakes => 'בדיקת טעויות ללבן הסתיימה';

  @override
  String get doneReviewingBlackMistakes => 'בדיקת טעויות לשחור הסתיימה';

  @override
  String get doItAgain => 'עשה זאת שוב';

  @override
  String get reviewWhiteMistakes => 'בדיקת טעויות ללבן';

  @override
  String get reviewBlackMistakes => 'בדיקת טעויות לשחור';

  @override
  String get advantage => 'יתרון';

  @override
  String get opening => 'פתיחה';

  @override
  String get middlegame => 'מציעה';

  @override
  String get endgame => 'סיום';

  @override
  String get conditionalPremoves => 'מסעים מותנים מראש';

  @override
  String get addCurrentVariation => 'הוספת הווריאציה הנוכחית';

  @override
  String get playVariationToCreateConditionalPremoves => 'צרו וריאציה כדי להגדיר מסעים מותנים מראש';

  @override
  String get noConditionalPremoves => 'אין מהלכים מותנים מראש';

  @override
  String playX(String param) {
    return 'שחקו $param';
  }

  @override
  String get showUnreadLichessMessage => 'קיבלתם הודעה פרטית מ־Lichess.';

  @override
  String get clickHereToReadIt => 'לחצו כאן כדי לקרוא אותה';

  @override
  String get sorry => 'מצטערים :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'נאלצנו להשעות אותך לזמן מה.';

  @override
  String get why => 'למה?';

  @override
  String get pleasantChessExperience => 'אנחנו מנסים לספק חווית שח נעימה לכולם.';

  @override
  String get goodPractice => 'בעקבות זאת, אנחנו חייבים לוודא שכל השחקנים ינהגו בכבוד.';

  @override
  String get potentialProblem => 'כאשר בעיה מסויימת מתגלה, אנו מציגים הודעה זו.';

  @override
  String get howToAvoidThis => 'איך להימנע מכך?';

  @override
  String get playEveryGame => 'יש לסיים כל משחק שהתחלת.';

  @override
  String get tryToWin => 'יש לנסות לנצח (או לפחות לסיים בתיקו) כל משחק שהתחלת.';

  @override
  String get resignLostGames => 'יש לפרוש במצבי הפסד (אין לתת לשעון לרוץ).';

  @override
  String get temporaryInconvenience => 'אנו מצטערים על אי הנעימות הזמנית,';

  @override
  String get wishYouGreatGames => 'ומאחלים לך חוויה נעימה ב־lichess.org.';

  @override
  String get thankYouForReading => 'תודה רבה על הקריאה!';

  @override
  String get lifetimeScore => 'תוצאה כוללת';

  @override
  String get currentMatchScore => 'תוצאה במשחק הנוכחי';

  @override
  String get agreementAssistance => 'אני מסכימ/ה שאף פעם לא אקבל עזרה תוך כדי משחק (ממנוע שח ממוחשב, ספר, מסד־נתונים, או אדם אחר).';

  @override
  String get agreementNice => 'אני מסכימ/ה שתמיד אהיה אדיב/ה כלפי השחקנים האחרים.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'אני מסכימ/ה לא ליצור חשבונות מרובים (אלא אם כן יש הצדקה לכך כמצוין ב$param).';
  }

  @override
  String get agreementPolicy => 'אני מסכימ/ה לציית לכל מדיניות של Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'חפשו את התחילו שיחה חדשה';

  @override
  String get edit => 'עריכה';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Classical';

  @override
  String get ultraBulletDesc => 'משחקים מהירים בטירוף: פחות מ־30 שניות על השעון';

  @override
  String get bulletDesc => 'משחקים מהירים מאוד: פחות מ3 דקות על השעון';

  @override
  String get blitzDesc => 'משחקים מהירים: בין 3 ל8 דקות';

  @override
  String get rapidDesc => 'משחקים זריזים: בין 8 ל25 דקות';

  @override
  String get classicalDesc => 'משחקים קלאסיים: 25 דקות או יותר';

  @override
  String get correspondenceDesc => 'משחקים בהתכתבות: יותר מיום עבור כל תור';

  @override
  String get puzzleDesc => 'מאמן טקטיקות שחמט';

  @override
  String get important => 'חשוב';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'יתכן שלשאלה שלך כבר יש תשובה $param1';
  }

  @override
  String get inTheFAQ => 'בשאלות הנפוצות';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'כדי לדווח על רמאות או על התנהגות עוינת, $param1';
  }

  @override
  String get useTheReportForm => 'השתמשו בטופס הדיווח';

  @override
  String toRequestSupport(String param1) {
    return 'לבקשת תמיכה, $param1';
  }

  @override
  String get tryTheContactPage => 'נסו את העמוד ״צרו קשר״';

  @override
  String makeSureToRead(String param1) {
    return 'קראו את $param1';
  }

  @override
  String get theForumEtiquette => 'כללי ההשתתפות בפורומים';

  @override
  String get thisTopicIsArchived => 'נושא זה עבר לארכיון ולא ניתן עוד להשיב עליו.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'הצטרף ל $param1 כדי לפרסם בפורום הזה';
  }

  @override
  String teamNamedX(String param1) {
    return 'הקבוצה $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'אתה עדיין לא יכול לפרסם בפורום זה. שחק כמה משחקים!';

  @override
  String get subscribe => 'עקוב';

  @override
  String get unsubscribe => 'בטל את המעקב';

  @override
  String mentionedYouInX(String param1) {
    return 'תייג/ה אותך ב־ $param1.';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 הזכיר/ה אותך בהודעה ב־\"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'הזמין אותך ל־\"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 הזמין/ה אותך ללוח הלמידה \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'את/ה כעת חבר/ה בקבוצה.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'הצטרפת אל \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'מישהו שדיווחת עליו נחסם';

  @override
  String get congratsYouWon => 'כל הכבוד, ניצחתם!';

  @override
  String gameVsX(String param1) {
    return 'המשחק נגד $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 נגד $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'הפסדת לאדם שהפר את תנאי השימוש בליצ\'ס';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'זיכוי: $param1 נקודות דירוג ב$param2.';
  }

  @override
  String get timeAlmostUp => 'הזמן הולך ואוזל!';

  @override
  String get clickToRevealEmailAddress => 'לחץ/י כדי לחשוף את כתובת הדוא\"ל';

  @override
  String get download => 'הורדה';

  @override
  String get coachManager => 'הגדרות עבור מאמנים';

  @override
  String get streamerManager => 'אזור ניהול משדר';

  @override
  String get cancelTournament => 'ביטול הטורניר';

  @override
  String get tournDescription => 'תיאור הטורניר';

  @override
  String get tournDescriptionHelp => 'יש לך משהו להגיד למשתתפים? עדיף בקיצור. קישורים אינטראקטיביים של Markdown זמינים.\n[name](https://url)';

  @override
  String get ratedFormHelp => 'המשחקים מדורגים \nומשפיעים על דירוגם של השחקנים';

  @override
  String get onlyMembersOfTeam => 'רק חברי הקבוצה';

  @override
  String get noRestriction => 'ללא הגבלה';

  @override
  String get minimumRatedGames => 'מספר משחקים מדורגים מינימלי';

  @override
  String get minimumRating => 'דירוג מינימלי';

  @override
  String get maximumWeeklyRating => 'דירוג שבועי מקסימלי';

  @override
  String positionInputHelp(String param) {
    return 'הדביקו FEN חוקי כדי להתחיל כל משחק מעמדה נתונה.\nשדה זה עובד רק עבור משחקים סטנדרטיים, לא עבור וריאנטים.\nאת/ה יכול/ה להשתמש ב$param כדי ליצור עמדת FEN, ואז להדביק אותה כאן.\nהשאירו את השדה הזה ריק כדי להתחיל משחקים מהעמדה ההתחלתית הרגילה.';
  }

  @override
  String get cancelSimul => 'ביטול המשחק הסימולטני';

  @override
  String get simulHostcolor => 'צבע מנחה המשחק';

  @override
  String get estimatedStart => 'זמן התחלה משוער';

  @override
  String simulFeatured(String param) {
    return 'הצג ב$param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'גרום למשחק להיות פומבי ב־$param. בטל בשביל משחק סימולטני פרטי.';
  }

  @override
  String get simulDescription => 'תיאור המשחק הסימולטני';

  @override
  String get simulDescriptionHelp => 'משהו שאת/ה רוצה להגיד למשתתפים?';

  @override
  String markdownAvailable(String param) {
    return '$param זמין לתחביר מתקדם יותר.';
  }

  @override
  String get embedsAvailable => 'הדביקו כתובת משחק (URL) או כתובת של פרק לוח למידה כדי להטמיע אותם.';

  @override
  String get inYourLocalTimezone => 'באזור הזמן שלך';

  @override
  String get tournChat => 'שליחת הודעה';

  @override
  String get noChat => 'ביטול אפשרות הצ\'אט';

  @override
  String get onlyTeamLeaders => 'רק ראשי קבוצות';

  @override
  String get onlyTeamMembers => 'רק חברי קבוצות';

  @override
  String get navigateMoveTree => 'נווט ברשימת המהלכים';

  @override
  String get mouseTricks => 'קיצורי עכבר';

  @override
  String get toggleLocalAnalysis => 'הפעילו/כבו ניתוח מחשב מקומי';

  @override
  String get toggleAllAnalysis => 'הפעילו/כבו כל ניתוח מחשב';

  @override
  String get playComputerMove => 'שחק את מהלך המחשב הטוב ביותר';

  @override
  String get analysisOptions => 'אפשרויות ניתוח';

  @override
  String get focusChat => 'הגדלת הצ\'אט';

  @override
  String get showHelpDialog => 'הצגת מסך עזרה זה';

  @override
  String get reopenYourAccount => 'פתח/י את חשבונך מחדש';

  @override
  String get closedAccountChangedMind => 'אם סגרת את חשבונך אך התחרטת, יש לך הזדמנות אחת לפתוח אותו.';

  @override
  String get onlyWorksOnce => 'פעולה זו היא חד פעמית.';

  @override
  String get cantDoThisTwice => 'עם סגירת החשבון בשנית לא תתאפשר עוד פתיחתו לעולם.';

  @override
  String get emailAssociatedToaccount => 'כתובת האימייל שמקושרת למשתמש';

  @override
  String get sentEmailWithLink => 'שלחנו לך דוא״ל עם קישור.';

  @override
  String get tournamentEntryCode => 'קוד כניסה לטורניר';

  @override
  String get hangOn => 'רגע!';

  @override
  String gameInProgress(String param) {
    return 'את/ה באמצע משחק עם $param.';
  }

  @override
  String get abortTheGame => 'בטל/י את המשחק';

  @override
  String get resignTheGame => 'כניעה';

  @override
  String get youCantStartNewGame => 'לא תוכל/י להתחיל משחק חדש עד גמר הנוכחי.';

  @override
  String get since => 'מאז';

  @override
  String get until => 'עד';

  @override
  String get lichessDbExplanation => 'משחקים מדורגים אשר נדגמו מכלל שחקני Lichess';

  @override
  String get switchSides => 'הפוך צד';

  @override
  String get closingAccountWithdrawAppeal => 'סגירת החשבון תבטל את פנייתך';

  @override
  String get ourEventTips => 'הטיפים שלנו לארגון אירועים';

  @override
  String get instructions => 'הוראות';

  @override
  String get showMeEverything => 'הראו לי הכל';

  @override
  String get lichessPatronInfo => 'ליצ\'ס הוא ארגון לטובת הכלל ותוכנת קוד פתוח חינמית.\nכל עלויות התפעול, הפיתוח והתוכן ממומנות אך ורק על ידי תרומות משתמשים.';

  @override
  String get nothingToSeeHere => 'אין כלום להצגה כאן, בינתיים.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'יריבך עזב את המשחק. תוכל/י לדרוש ניצחון בעוד $count שניות.',
      many: 'יריבך עזב את המשחק. תוכל/י לדרוש ניצחון בעוד $count שניות.',
      two: 'יריבך עזב את המשחק. תוכל/י להכריז על ניצחון בעוד $count שניות.',
      one: 'יריבך עזב את המשחק. תוכל/י להכריז על נצחון בעוד שנייה $count.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'מט בעוד $count חצאי מהלכים',
      many: 'מט בעוד $count חצאי מהלכים',
      two: 'מט בעוד $count חצאי מהלכים',
      one: 'מט בעוד חצי מהלך $count',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count טעויות גסות',
      many: '$count טעויות גסות',
      two: '$count טעויות גסות',
      one: '$count טעות גסה',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שגיאות',
      many: '$count שגיאות',
      two: '$count שגיאות',
      one: '$count שגיאה',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count אי־דיוקים',
      many: '$count אי־דיוקים',
      two: '$count אי־דיוקים',
      one: '$count אי־דיוק',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שחקנים',
      many: '$count שחקנים',
      two: '$count שחקנים',
      one: '$count שחקנים',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count משחקים',
      many: '$count משחקים',
      two: '$count משחקים',
      one: 'משחק $count',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'דירוג של $count לאורך $param2 משחקים',
      many: 'דירוג של $count לאורך $param2 משחקים',
      two: 'דירוג של $count לאורך $param2 משחקים',
      one: 'דירוג של $count לאורך משחק $param2',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count מועדפים',
      many: '$count מועדפים',
      two: '$count מועדפים',
      one: '$count מועדפים',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ימים',
      many: '$count ימים',
      two: '$count ימים',
      one: 'יום $count',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שעות',
      many: '$count שעות',
      two: '$count שעות',
      one: 'שעה $count',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count דקות',
      many: '$count דקות',
      two: '$count דקות',
      one: '$count דקות',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'המיקום מתעדכן כל $count דקות',
      many: 'המיקום מתעדכן כל $count דקות',
      two: 'המיקום מתעדכן כל $count דקות',
      one: 'המיקום מתעדכן כל דקה',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count חידות',
      many: '$count חידות',
      two: '$count חידות',
      one: 'חידה $count',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count משחקים איתך',
      many: '$count משחקים איתך',
      two: '$count משחקים איתך',
      one: 'משחק $count איתך',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count מדורגים',
      many: '$count מדורגים',
      two: '$count מדורגים',
      one: '$count מדורג',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ניצחונות',
      many: '$count ניצחונות',
      two: '$count ניצחונות',
      one: '$count ניצחון',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count הפסדים',
      many: '$count הפסדים',
      two: '$count הפסדים',
      one: '$count הפסד',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count תוצאות תיקו',
      many: '$count תוצאות תיקו',
      two: '$count תוצאות תיקו',
      one: '$count תוצאת תיקו',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count נוכחיים',
      many: '$count נוכחיים',
      two: '$count נוכחיים',
      one: '$count נוכחי',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'תן $count שניות',
      many: 'תן $count שניות',
      two: 'תן $count שניות',
      one: 'תן שנייה $count',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count נקודות טורניר',
      many: '$count נקודות טורניר',
      two: '$count נקודות טורניר',
      one: 'נקודת טורניר $count',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count לוחות למידה',
      many: '$count לוחות למידה',
      two: '$count לוחות למידה',
      one: 'לוח למידה $count',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count משחקים סימולטניים',
      many: '$count משחקים סימולטניים',
      two: '$count משחקים סימולטניים',
      one: 'משחק סימולטני $count',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count משחקים מדורגים ≥',
      many: '$count משחקים מדורגים ≥',
      two: '$count משחקים מדורגים ≥',
      one: 'משחק מדורג $count ≥',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count משחקי $param2 מדורגים',
      many: '≥ $count משחקי $param2 מדורגים',
      two: '≥ $count משחקי $param2 מדורגים',
      one: '≥ משחק $param2 מדורג $count',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'יש לשחק עוד $count משחקים מדורגים של $param2',
      many: 'יש לשחק עוד $count משחקים מדורגים של $param2',
      two: 'יש לשחק עוד $count משחקים מדורגים של $param2',
      one: 'יש לשחק עוד משחק מדורג $count של $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'עליך לשחק עוד $count משחקים מדורגים',
      many: 'עליך לשחק עוד $count משחקים מדורגים',
      two: 'עליך לשחק עוד $count משחקים מדורגים',
      one: 'עליך לשחק עוד משחק מדורג $count',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count משחקים מיובאים',
      many: '$count משחקים מיובאים',
      two: '$count משחקים מיובאים',
      one: 'משחק מיובא $count',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count חברים מחוברים',
      many: '$count חברים מחוברים',
      two: '$count חברים מחוברים',
      one: 'חבר $count מחובר',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count עוקבים',
      many: '$count עוקבים',
      two: '$count עוקבים',
      one: 'עוקב $count',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ברשימת המעקב',
      many: '$count ברשימת המעקב',
      two: '$count ברשימת המעקב',
      one: '$count ברשימת המעקב',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'פחות מ$count דקות',
      many: 'פחות מ$count דקות',
      two: 'פחות מ־ $count דקות',
      one: 'פחות מדקה $count',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count משחקים בתהליך',
      many: '$count משחקים בתהליך',
      two: '$count משחקים בתהליך',
      one: 'משחק $count בתהליך',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'מספר תווים מירבי: $count.',
      many: 'מספר תווים מירבי: $count.',
      two: 'מספר תווים מירבי: $count.',
      one: 'מספר תווים מירבי: $count.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count חסומים',
      many: '$count חסומים',
      two: '$count חסומים',
      one: '$count חסום',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count פוסטים בפורום',
      many: '$count פוסטים בפורום',
      two: '$count פוסטים בפורום',
      one: 'פוסט $count בפורום',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שחקני $param2 השבוע.',
      many: '$count שחקני $param2 השבוע.',
      two: '$count שחקני $param2 השבוע.',
      one: '$count שחקני $param2 השבוע.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'זמין ב$count שפות!',
      many: 'זמין ב$count שפות!',
      two: 'זמין ב$count שפות!',
      one: 'זמין בשפה $count!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שניות כדי לשחק את המסע הראשון',
      many: '$count שניות כדי לשחק את המסע הראשון',
      two: '$count שניות כדי לשחק את המסע הראשון',
      one: 'שנייה $count לשחק את המסע הראשון',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שניות',
      many: '$count שניות',
      two: '$count שניות',
      one: '$count שניה',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ושמרו $count המשכים מוגדרים מראש',
      many: 'ושמרו $count המשכים מוגדרים מראש',
      two: 'ושמרו $count המשכים מוגדרים מראש',
      one: 'ושמרו המשך מוגדר מראש $count',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'בצע/י מהלך כדי להתחיל';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'את/ה משחק/ת בלבן בכל החידות';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'את/ה משחק/ת בשחור בכל החידות';

  @override
  String get stormPuzzlesSolved => 'חידות נפתרו';

  @override
  String get stormNewDailyHighscore => 'שיא יומי חדש!';

  @override
  String get stormNewWeeklyHighscore => 'שיא שבועי חדש!';

  @override
  String get stormNewMonthlyHighscore => 'שיא חודשי חדש!';

  @override
  String get stormNewAllTimeHighscore => 'שיא חדש בכל הזמנים!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'השיא הקודם היה $param';
  }

  @override
  String get stormPlayAgain => 'שחק/י שוב';

  @override
  String stormHighscoreX(String param) {
    return 'הניקוד הגבוה ביותר: $param';
  }

  @override
  String get stormScore => 'ניקוד';

  @override
  String get stormMoves => 'מהלכים';

  @override
  String get stormAccuracy => 'דיוק';

  @override
  String get stormCombo => 'רצף';

  @override
  String get stormTime => 'זמן';

  @override
  String get stormTimePerMove => 'זמן לכל מהלך';

  @override
  String get stormHighestSolved => 'הפאזל הכי קשה שנפתר';

  @override
  String get stormPuzzlesPlayed => 'פאזלים ששוחקו';

  @override
  String get stormNewRun => 'סיבוב חדש';

  @override
  String get stormEndRun => 'סיים ריצה';

  @override
  String get stormHighscores => 'שיאים';

  @override
  String get stormViewBestRuns => 'צפו בריצות הכי טובות';

  @override
  String get stormBestRunOfDay => 'הריצה הטובה ביותר היום';

  @override
  String get stormRuns => 'ריצות';

  @override
  String get stormGetReady => 'התכונן!';

  @override
  String get stormWaitingForMorePlayers => 'מחכים שעוד שחקנים יצטרפו...';

  @override
  String get stormRaceComplete => 'המירוץ הושלם!';

  @override
  String get stormSpectating => 'צופה';

  @override
  String get stormJoinTheRace => 'הצטרפו למירוץ!';

  @override
  String get stormStartTheRace => 'התחילו את המירוץ';

  @override
  String stormYourRankX(String param) {
    return 'המיקום שלך: $param';
  }

  @override
  String get stormWaitForRematch => 'המתינו למשחק חוזר';

  @override
  String get stormNextRace => 'המירוץ הבא';

  @override
  String get stormJoinRematch => 'הצטרף/י למשחק חוזר';

  @override
  String get stormWaitingToStart => 'ממתינים... נתחיל בקרוב';

  @override
  String get stormCreateNewGame => 'צרו משחק חדש';

  @override
  String get stormJoinPublicRace => 'הצטרפו למירוץ פומבי';

  @override
  String get stormRaceYourFriends => 'התחרה/י עם חבריך';

  @override
  String get stormSkip => 'דלג/י';

  @override
  String get stormSkipHelp => 'את/ה יכול/ה לדלג על מסע פעם אחת בכל מרוץ:';

  @override
  String get stormSkipExplanation => 'דלג/י על מהלך זה כדי לשמור על הרצף שלך! ניתן לדלג רק פעם אחת בכל מירוץ.';

  @override
  String get stormFailedPuzzles => 'פאזלים שנכשלת בפתרונם';

  @override
  String get stormSlowPuzzles => 'פאזלים שהתעכבת בפתרונם';

  @override
  String get stormSkippedPuzzle => 'החידה שדילגת עליה';

  @override
  String get stormThisWeek => 'השבוע';

  @override
  String get stormThisMonth => 'החודש';

  @override
  String get stormAllTime => 'אי פעם';

  @override
  String get stormClickToReload => 'לחץ/י כדי לטעון מחדש';

  @override
  String get stormThisRunHasExpired => 'המרוץ הסתיים!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'המרוץ הזה נפתח בחלון אחר!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count נסיונות',
      many: '$count ניסיונות',
      two: '$count ניסיונות',
      one: 'ניסיון אחד',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'שוחקו $count ריצות של $param2',
      many: 'שוחקו $count ריצות של $param2',
      two: 'שוחקו $count ריצות של $param2',
      one: 'שוחקה ריצה אחת של $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'שדרני Lichess';

  @override
  String get studyShareAndExport => 'שיתוף & ייצוא';

  @override
  String get studyStart => 'שמירה';
}
