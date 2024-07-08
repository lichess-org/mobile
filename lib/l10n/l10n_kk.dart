import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get mobileHomeTab => 'Home';

  @override
  String get mobilePuzzlesTab => 'Puzzles';

  @override
  String get mobileToolsTab => 'Tools';

  @override
  String get mobileWatchTab => 'Watch';

  @override
  String get mobileSettingsTab => 'Settings';

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
  String get activityActivity => 'Белсенділігі';

  @override
  String get activityHostedALiveStream => 'Стрим бастады';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '$param2-да $param1-нші орында';
  }

  @override
  String get activitySignedUp => 'Личес-те тіркелді';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Личес-қа $count ай $param2 ретінде қолдау көрсетті',
      one: 'Личес-қа $count ай $param2 ретінде қолдау көрсетті',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2-да $count күйді меңгерді',
      one: '$param2-да $count күйді меңгерді',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тактикалық жұмбақ шешті',
      one: '$count тактикалық жұмбақ шешті',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 ойнады',
      one: '$count $param2 ойнады',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 ішінде $count хабарлама жариялады',
      one: '$param2 ішінде $count хабарлама жариялады',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count жүріс жасады',
      one: '$count жүріс жасады',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хат-хабарлы ойында',
      one: '$count хат-хабарлы ойында',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хат-хабарлы ойынды аяғына жеткізді',
      one: '$count хат-хабарлы ойынды аяғына жеткізді',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ойыншыға серік болып қосылды',
      one: '$count ойыншыға серік болып қосылды',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Жаңа $count серік тапты',
      one: 'Жаңа $count серік тапты',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count қалың ойын бастады',
      one: '$count қалың ойын бастады',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count қалың ойынға қатысты',
      one: '$count қалың ойынға қатысты',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count жаңа зерттеу құрды',
      one: '$count жаңа зерттеу құрды',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count жарысқа қатысты',
      one: '$count жарысқа қатысты',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param4 $param3 ойын нәтижесінде $count-ші орында ($param2% үздік)',
      one: '$param4 $param3 ойын нәтижесінде $count-ші орында ($param2% үздік)',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count швейцарлық жарысқа қатысты',
      one: '$count швейцарлық жарысқа қатысты',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count топқа қосылды',
      one: '$count топқа қосылды',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Көрсетілімдер';

  @override
  String get broadcastLiveBroadcasts => 'Жарыстың тікелей көрсетілімдері';

  @override
  String challengeChallengesX(String param1) {
    return 'Шақырулар: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Ойынға шақыру';

  @override
  String get challengeChallengeDeclined => 'Шақыруды қабылдамады';

  @override
  String get challengeChallengeAccepted => 'Шақыруды қабылдады!';

  @override
  String get challengeChallengeCanceled => 'Шақырудың күші жойылды.';

  @override
  String get challengeRegisterToSendChallenges => 'Ойынға шақыру үшін тіркеліңіз.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Сіз $param шақыра алмайсыз.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param шақыруды қабылдамады.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Сіз $param1 рейтингіңіз $param2-дан тым алшақ.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return '$param рейтингіңіз – болжамалы, сондықтан ойынға шақыра алмайсыз.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param тек достардың шақыруын қабылдайды.';
  }

  @override
  String get challengeDeclineGeneric => 'Мен әзірше шақыруларды қабылдамаймын.';

  @override
  String get challengeDeclineLater => 'Қазір мен үшін ыңғайлы кез емес, кейін сұрап көріңіз.';

  @override
  String get challengeDeclineTooFast => 'Бұл уақыт қалпы мен үшін тым шапшаң, одан баяу ойынға шақыруды жіберіңізші.';

  @override
  String get challengeDeclineTooSlow => 'Бұл уақыт қалпы мен үшін тым баяу, шапшаңдау ойынға шақыруды жіберіңізші.';

  @override
  String get challengeDeclineTimeControl => 'Мен бұндай уақыт қалпындағы ойындарға шақыруды қабылдамаймын.';

  @override
  String get challengeDeclineRated => 'Оның орнына маған бағаланатын шақыруды жіберіңізші.';

  @override
  String get challengeDeclineCasual => 'Оның орнына маған жай шақыруды жіберіңізші.';

  @override
  String get challengeDeclineStandard => 'Мен қазір классикалық емес шақыруларды қабылдамаймын.';

  @override
  String get challengeDeclineVariant => 'Мен қазір осы шахмат түрін ойнағым келмейді.';

  @override
  String get challengeDeclineNoBot => 'Мен роботтардан шақыруларды қабылдамаймын.';

  @override
  String get challengeDeclineOnlyBot => 'Мен тек роботтардан келген шақыруларды қабылдаймын.';

  @override
  String get challengeInviteLichessUser => 'Не Личес ойыншысын шақыру:';

  @override
  String get contactContact => 'Байланыс';

  @override
  String get contactContactLichess => 'Личеспен байланыс';

  @override
  String get patronDonate => 'Демеу жасау';

  @override
  String get patronLichessPatron => 'Личес Қамқоршысы';

  @override
  String perfStatPerfStats(String param) {
    return '$param статистикасы';
  }

  @override
  String get perfStatViewTheGames => 'Ойындарын көру';

  @override
  String get perfStatProvisional => 'болжамалы';

  @override
  String get perfStatNotEnoughRatedGames => 'Тұрақты рейтингке ие болу үшін бағалы ойын саны жеткіліксіз.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Кейінгі $param ойынның қорытындысы:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Рейтинг ауытқуы: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Мөлшері аз болса, рейтингтің тұрақты екенін білдіреді. $param1-дан артық болса – болжамалы. Орынға ие болу үшін бұл шама классикалық шахматта $param2-дан, ал басқа шахмат түрлерінде $param3-дан кем болуы керек.';
  }

  @override
  String get perfStatTotalGames => 'Барлық ойындар';

  @override
  String get perfStatRatedGames => 'Бағалы ойындар';

  @override
  String get perfStatTournamentGames => 'Жарыс ойындары';

  @override
  String get perfStatBerserkedGames => 'Берсерк ойындары';

  @override
  String get perfStatTimeSpentPlaying => 'Ойынмен өткен уақыт';

  @override
  String get perfStatAverageOpponent => 'Орташа қарсылас';

  @override
  String get perfStatVictories => 'Жеңістер';

  @override
  String get perfStatDefeats => 'Жеңілістер';

  @override
  String get perfStatDisconnections => 'Байланыс үзілуі';

  @override
  String get perfStatNotEnoughGames => 'Ойындар саны жеткіліксіз';

  @override
  String perfStatHighestRating(String param) {
    return 'Ең үлкен рейтинг: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Ең төменгі рейтинг: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1 - $param2 аралығында';
  }

  @override
  String get perfStatWinningStreak => 'Жеңістер тізбегі';

  @override
  String get perfStatLosingStreak => 'Жеңілістер тізбегі';

  @override
  String perfStatLongestStreak(String param) {
    return 'Ең ұзақ тізбек: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Қазіргі тізбек: $param';
  }

  @override
  String get perfStatBestRated => 'Ең бағалы жеңістер';

  @override
  String get perfStatGamesInARow => 'Қатарынан ойналған ойындар';

  @override
  String get perfStatLessThanOneHour => 'Ойындар арасы бір сағаттан кем';

  @override
  String get perfStatMaxTimePlaying => 'Ойынмен өткен ең ұзақ уақыт';

  @override
  String get perfStatNow => 'қазір';

  @override
  String get preferencesPreferences => 'Баптаулар';

  @override
  String get preferencesDisplay => 'Көрініс';

  @override
  String get preferencesPrivacy => 'Құпиялық';

  @override
  String get preferencesNotifications => 'Хабарламалар';

  @override
  String get preferencesPieceAnimation => 'Тастар анимациясы';

  @override
  String get preferencesMaterialDifference => 'Тас мөлшерінің айырмашылығы';

  @override
  String get preferencesBoardHighlights => 'Жүріс ізін көрсету (кейінгі жүріс пен шах)';

  @override
  String get preferencesPieceDestinations => 'Тастың бағытын көрсету (заңды, алдын-ала жүрістер)';

  @override
  String get preferencesBoardCoordinates => 'Тақта координаттары (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Ойын кезіндегі жүрістер тізімі';

  @override
  String get preferencesPgnPieceNotation => 'Жүрісті жазу тәртібі';

  @override
  String get preferencesChessPieceSymbol => 'Тас таңбасы';

  @override
  String get preferencesPgnLetter => 'Әріптер (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Оқшау көрініс';

  @override
  String get preferencesShowPlayerRatings => 'Ойыншылардың рейтингін көрсету';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Шахматқа назарды күшейту үшін бұл бүкіл сайттағы рейтингтерді жасырады. Бағалау тәртібіне еш әсері жоқ, жай сыртқы көрінісі басқаша болады.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Тақтаны үлкейту тұтқасын көрсету';

  @override
  String get preferencesOnlyOnInitialPosition => 'Тек бастапқы күйде ғана';

  @override
  String get preferencesInGameOnly => 'Ойында ғана';

  @override
  String get preferencesChessClock => 'Шахмат сағаты';

  @override
  String get preferencesTenthsOfSeconds => 'Секундтың ондық бөлігін көрсету';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => '10 секунд қалғанда';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Уақыт жүрісін көрсететін көлденең жасыл жолақ';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Уақыт аз қалғанда, дыбыс белгі беру';

  @override
  String get preferencesGiveMoreTime => 'Қарсыласқа уақыт беру мүмкіндігі';

  @override
  String get preferencesGameBehavior => 'Ойын тәртібі';

  @override
  String get preferencesHowDoYouMovePieces => 'Тасты қалай жүресіз?';

  @override
  String get preferencesClickTwoSquares => 'Екі шаршыны басып';

  @override
  String get preferencesDragPiece => 'Тасты тартып';

  @override
  String get preferencesBothClicksAndDrag => 'Екі әдіспен де';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Алдын-ала жүру (қарсыластың кезегінде жүру)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Жүрісті қайтару (қарсыластың келісімі қажет)';

  @override
  String get preferencesInCasualGamesOnly => 'Жай ойындарда ғана';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Уәзірге автоматты түрде айналдыру';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Ойын кезінде автоматты айналдыруды уақытша өшіру үшін <ctrl> басып тұрыңыз';

  @override
  String get preferencesWhenPremoving => 'Алдын-ала жүрісте';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Үш реттік қайталану болса, автоматты түрде тепе-теңдік жариялау';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => '30 секунд қалғанда';

  @override
  String get preferencesMoveConfirmation => 'Жүрісті растау';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Ойын кезінде тақта баптаулары арқылы өшіруге болады';

  @override
  String get preferencesInCorrespondenceGames => 'Хат-хабарлы ойындарда';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Хат-хабарлы мен уақыты шексіз';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Берілу мен тепе-теңдік ұсынысын растау';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Бекіну әдісі';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Патшаны екі шаршы жүру';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Патшаны тура тасына қою';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Пернетақта арқылы жүру';

  @override
  String get preferencesInputMovesWithVoice => 'Қадамды дауыспен жасау';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Нұсқағыш тек заңды жүрістерге ғана жабысады';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Жеңіліс не тепе-теңдіктен кейін \"Жақсы ойын, қызық болды\" деп айту';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Баптауыңыз сақталды.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Тақта бетінде тіңтуір айналдырумен жүрістерді қайта көрсету';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Хат-хабарлы ойындарыңыз туралы күнде поштаңызға ескертпе жіберу';

  @override
  String get preferencesNotifyStreamStart => 'Стрим басталды';

  @override
  String get preferencesNotifyInboxMsg => 'Жаңа хабар';

  @override
  String get preferencesNotifyForumMention => 'Форумда сіз туралы айтты';

  @override
  String get preferencesNotifyInvitedStudy => 'Зерттеуге шақырды';

  @override
  String get preferencesNotifyGameEvent => 'Хат-хабарлы ойын барысы';

  @override
  String get preferencesNotifyChallenge => 'Шақырулар';

  @override
  String get preferencesNotifyTournamentSoon => 'Жарыс жақында басталады';

  @override
  String get preferencesNotifyTimeAlarm => 'Хат-хабарлы ойын уақыты бітер алдында';

  @override
  String get preferencesNotifyBell => 'Личестегі қоңыраулы ескерту';

  @override
  String get preferencesNotifyPush => 'Құрылғының ескертуі, Личестен тыс кезіңізде';

  @override
  String get preferencesNotifyWeb => 'Браузер';

  @override
  String get preferencesNotifyDevice => 'Құрылғы';

  @override
  String get preferencesBellNotificationSound => 'Қоңыраулы ескерту';

  @override
  String get puzzlePuzzles => 'Жұмбақтар';

  @override
  String get puzzlePuzzleThemes => 'Жұмбақ тақырыптары';

  @override
  String get puzzleRecommended => 'Ұсыныстар';

  @override
  String get puzzlePhases => 'Кезеңдер';

  @override
  String get puzzleMotifs => 'Жағдайлар';

  @override
  String get puzzleAdvanced => 'Қосымша';

  @override
  String get puzzleLengths => 'Ұзындық';

  @override
  String get puzzleMates => 'Маттар';

  @override
  String get puzzleGoals => 'Мақсаттар';

  @override
  String get puzzleOrigin => 'Түпнұсқа';

  @override
  String get puzzleSpecialMoves => 'Ерекше жүрістер';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Бұл жұмбақ ұнай ма?';

  @override
  String get puzzleVoteToLoadNextOne => 'Келесін ашу үшін дауыс беріңіз!';

  @override
  String get puzzleUpVote => 'Дәрежесін көтеру';

  @override
  String get puzzleDownVote => 'Дәрежесін түсіру';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Сіздің жұмбақ шешу рейтингіңіз өзгермейді. Жұмбақтар жарыс емес екенін ескеріңіз. Мұндағы рейтингтің қызметі – сіздің деңгейіңізге сәйкес жұмбақты табуға көмекші болу.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Аққа ең табысты жүрісті табыңыз.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Қараға ең табысты жүрісті табыңыз.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Жекелендірген жұмбақ алу үшін:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Жұмбақ $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Бүгінгі жұмбақ';

  @override
  String get puzzleDailyPuzzle => 'күнделікті жұмбақтар';

  @override
  String get puzzleClickToSolve => 'Шешу үшін басыңыз';

  @override
  String get puzzleGoodMove => 'Жақсы жүріс';

  @override
  String get puzzleBestMove => 'Үздік жүріс!';

  @override
  String get puzzleKeepGoing => 'Ары қарай…';

  @override
  String get puzzlePuzzleSuccess => 'Бәрі дұрыс!';

  @override
  String get puzzlePuzzleComplete => 'Жұмбақ шешілді!';

  @override
  String get puzzleByOpenings => 'Бастамасына қарай';

  @override
  String get puzzlePuzzlesByOpenings => 'Жұмбақтың бастамасы';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Сіздің бағалы ойындарыңызда ең жиі келетін бастама';

  @override
  String get puzzleUseFindInPage => 'Браузер мәзірінде \"Осы бетте іздеуді\" қолдана қалаулы бастаманы тауып алыңыз!';

  @override
  String get puzzleUseCtrlF => 'Қалаулы бастаманы табу үшін Ctrl+f басыңыз';

  @override
  String get puzzleNotTheMove => 'Ол жүріс емес!';

  @override
  String get puzzleTrySomethingElse => 'Басқаша жүріп көріңіз.';

  @override
  String puzzleRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get puzzleHidden => 'жасырын';

  @override
  String puzzleFromGameLink(String param) {
    return '$param ойнынан';
  }

  @override
  String get puzzleContinueTraining => 'Жаттығуды жалғастыру';

  @override
  String get puzzleDifficultyLevel => 'Күрделілік деңгейі';

  @override
  String get puzzleNormal => 'Қалыпты';

  @override
  String get puzzleEasier => 'Жеңілдеу';

  @override
  String get puzzleEasiest => 'Ең жеңілі';

  @override
  String get puzzleHarder => 'Қиындау';

  @override
  String get puzzleHardest => 'Ең қиыны';

  @override
  String get puzzleExample => 'Мысал';

  @override
  String get puzzleAddAnotherTheme => 'Басқа тақырып қосу';

  @override
  String get puzzleNextPuzzle => 'Келесі жұмбақ';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Келесі жұмбаққа бірден өту';

  @override
  String get puzzlePuzzleDashboard => 'Жетістіктер';

  @override
  String get puzzleImprovementAreas => 'Жетілдіру бағыты';

  @override
  String get puzzleStrengths => 'Күштілігі';

  @override
  String get puzzleHistory => 'Жұмбақ журналы';

  @override
  String get puzzleSolved => 'шешілді';

  @override
  String get puzzleFailed => 'шешілмеді';

  @override
  String get puzzleStreakDescription => 'Қиындай беретін жұмбақтарды шешіп, жеңістер тізбегін құрыңыз. Уақытта шектеу жоқ. Бір бұрыс қадам болса, ойын бітті! Бірақ бір бәйгеде бір жүрісті өткізіп жібере аласыз.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Жеңістер тізбегі: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Тізбегіңіз үзілмес үшін бұл жүрісті өткізіп жіберіңіз. Әр бәйгеде бір рет қана жасауға болады.';

  @override
  String get puzzleContinueTheStreak => 'Тізбекті жалғастыру';

  @override
  String get puzzleNewStreak => 'Жаңа тізбек';

  @override
  String get puzzleFromMyGames => 'Менің ойындарымнан';

  @override
  String get puzzleLookupOfPlayer => 'Бір ойыншының ойындарынан жұмбақ іздеу';

  @override
  String puzzleFromXGames(String param) {
    return '$param ойындарынан жұмбақтар';
  }

  @override
  String get puzzleSearchPuzzles => 'Жұмбақ іздеу';

  @override
  String get puzzleFromMyGamesNone => 'Дерекқорыңызда жұмбақ жоқ (бірақ сізге деген құрметіміз одан азайған емес).\nЖүйрік әрі классикалық ойын ойнап, жұмбақ құрылуына себепші болыңыз!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param2 ойында $param1 жұмбақ табылды';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Жаттығып, талдап, ақыл шыңдаңыз!';

  @override
  String puzzlePercentSolved(String param) {
    return '$param шешілді';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Мәлімет жоқ. Алдымен жұмбақ шешіп көріңіз!';

  @override
  String get puzzleImprovementAreasDescription => 'Жетістігіңізді жақсарту үшін осы жаттығуды көріңіз!';

  @override
  String get puzzleStrengthDescription => 'Осы тақырыпта сізде үздік нәтиже';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рет ойналды',
      one: '$count рет ойналды',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Жұмбақ рейтингіңізден төмен $count ұпай',
      one: 'Жұмбақ рейтингіңізден төмен бір ұпай',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Жұмбақ рейтингіңізден жоғары $count ұпай',
      one: 'Жұмбақ рейтингіңізден жоғары бір ұпай',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ойнадыңыз',
      one: '$count ойнадыңыз',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-н қайта ойнау',
      one: '$count-н қайта ойнау',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Әккі сарбаз';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Айналуға ұмтылған не айналу қаупін төндіретін сарбаз – тактиканың өзегі.';

  @override
  String get puzzleThemeAdvantage => 'Басымдылық';

  @override
  String get puzzleThemeAdvantageDescription => 'Шешуші артықшылық беретін сәтті жіберіп алмаңыз. (200-600 сп)';

  @override
  String get puzzleThemeAnastasiaMate => 'Анастасия маты';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Ат пен тура не уәзірдің бірлесіп, қарсылас патшасын тақта шеті мен өз тасының арасында ұстап алуы.';

  @override
  String get puzzleThemeArabianMate => 'Арабша мат';

  @override
  String get puzzleThemeArabianMateDescription => 'Ат пен тураның бірлесіп қарсылас патшаны тақта бұрышында ұстап алуы.';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2 не f7-ге шабуылдау';

  @override
  String get puzzleThemeAttackingF2F7Description => '\"Қуырылған бүйрек\" бастауындағыдай f2 не f7 сарбазына бағытталған шабуыл.';

  @override
  String get puzzleThemeAttraction => 'Тартымдылық';

  @override
  String get puzzleThemeAttractionDescription => 'Қарсылас тасын белгілі бір шаршыға итермелейтін не күштеп ығыстыратын айырбастау не құрбан ету.';

  @override
  String get puzzleThemeBackRankMate => 'Соңғы сап маты';

  @override
  String get puzzleThemeBackRankMateDescription => 'Өз сабында өз тастарымен қамалған патшаға мат.';

  @override
  String get puzzleThemeBishopEndgame => 'Пiл ойынсоңы';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Пілдер мен сарбаздары ғана бар ойынсоңы.';

  @override
  String get puzzleThemeBodenMate => 'Бодэн маты';

  @override
  String get puzzleThemeBodenMateDescription => 'Қарсылас патшасының бір жағын өз тастары бөгеп тұрғанда, екі піл қиылыса шабуылдайды.';

  @override
  String get puzzleThemeCastling => 'Бекіну';

  @override
  String get puzzleThemeCastlingDescription => 'Патшаны қорғаулы жерге кіргізіп, тураны шабуылға даярлаңыз.';

  @override
  String get puzzleThemeCapturingDefender => 'Қорғаушыны жою';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Бір тасты қорғап тұрған басқа тасты басып алсаңыз, әлгі тас қорғаусыз қалып, оны басып алуға жол ашылады.';

  @override
  String get puzzleThemeCrushing => 'Тас-талқан';

  @override
  String get puzzleThemeCrushingDescription => 'Жойқын артықшылыққа ие болу үшін қарсыластың қателігін анықтаңыз. (≥ 600 сп)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Пілдер маты';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Қарсылас патшасының бір жағын өз тастары бөгеп тұрғанда, екі піл қатарлас шабуылдайды.';

  @override
  String get puzzleThemeDovetailMate => 'Айырқұйрық мат';

  @override
  String get puzzleThemeDovetailMateDescription => 'Қарсылас патшасының екі жағын өз тастары бөгеп тұрғанда, уәзір жақыннан мат қояды.';

  @override
  String get puzzleThemeEquality => 'Теңдік';

  @override
  String get puzzleThemeEqualityDescription => 'Жаман күйден шығып, ойынды тепе-теңдікке не тең күйге жеткізіңіз. (≤ 200 сп)';

  @override
  String get puzzleThemeKingsideAttack => 'Патша жақты шабуыл';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Қарсыластың патшасы өз жағына бекінгеннен кейін оған жасалатын шабуыл.';

  @override
  String get puzzleThemeClearance => 'Тазарту';

  @override
  String get puzzleThemeClearanceDescription => 'Тактиканы асыру мақсатында шаршыны, тік не диагоналды жолды босату үшін әдетте қарқынмен жасалынатын жүріс.';

  @override
  String get puzzleThemeDefensiveMove => 'Қорғану жүрісі';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Тастарды не артықшылықты жоғалтпау мақсатында жасалатын жүріс не жүрістер тізбегі.';

  @override
  String get puzzleThemeDeflection => 'Назарын бұру';

  @override
  String get puzzleThemeDeflectionDescription => 'Қарсылас тасын өз міндетінен (мысалы, бір маңызды шаршыны қорғаудан) үзу үшін жасалынатын алдамшы жүріс.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ашылған шабуыл';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Ұзын жүрісті тастың шабуылын бөгеп тұрған таспен жүру. Мысалы, тура жолында тұрған атпен жүру.';

  @override
  String get puzzleThemeDoubleCheck => 'Қос шах';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Ашылған шабуыл кезінде бірден екі тастың (яғни, шабулды ашқан тас пен шабуылдап жатқан тас) қарсылас патшасына қойған шахтары.';

  @override
  String get puzzleThemeEndgame => 'Ойынсоңы';

  @override
  String get puzzleThemeEndgameDescription => 'Ойынның соңғы кезеңіндегі тактика.';

  @override
  String get puzzleThemeEnPassantDescription => 'Бір сазбаз, қасынан қарсыластың сарбазы өткенде, оны басып алатын жағдайды, яғни жолай басып алуды қамтитын тактика.';

  @override
  String get puzzleThemeExposedKing => 'Жалаңаш патша';

  @override
  String get puzzleThemeExposedKingDescription => 'Қорғанысы нашар патша әдетте маттың иісін сезіп тұрады.';

  @override
  String get puzzleThemeFork => 'Шанышқы';

  @override
  String get puzzleThemeForkDescription => 'Қарсыластың бірден екі тасын ұратын тас жүрісі.';

  @override
  String get puzzleThemeHangingPiece => 'Олжа тас';

  @override
  String get puzzleThemeHangingPieceDescription => 'Қорғанысы нашар не қорғаусыз тұрған қарсылас тасын басып алуды меңзейтін тактика.';

  @override
  String get puzzleThemeHookMate => 'Қармақ мат';

  @override
  String get puzzleThemeHookMateDescription => 'Қарсылас патшасына өз сарбазы бөгет бола тұра, ат, тура мен сарбаз арқылы қойылған мат.';

  @override
  String get puzzleThemeInterference => 'Бөгет';

  @override
  String get puzzleThemeInterferenceDescription => 'Қарсыластың екі байланысқан тастарының арасына бөгет қойып, олардың біреуін не екеуін қорғаусыз ету. Мысалы, екі өзара қорғап тұрған туралардың арасына тұра қалған ат.';

  @override
  String get puzzleThemeIntermezzo => 'Аралық жүріс';

  @override
  String get puzzleThemeIntermezzoDescription => 'Болжамға сай жүрудің орнына алдымен басқаша, қарсыласқа қауіп келтіретін, жауап беруге мәжбүрлейтін жүріс жасау. Басқаша \"Intermezzo\" не \"Zwischenzug\" деп те аталады.';

  @override
  String get puzzleThemeKnightEndgame => 'Ат ойынсоңы';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Аттар мен сарбаздары ғана бар ойынсоңы.';

  @override
  String get puzzleThemeLong => 'Ұзын жұмбақ';

  @override
  String get puzzleThemeLongDescription => 'Жеңіске үш қадам.';

  @override
  String get puzzleThemeMaster => 'Шебер ойындары';

  @override
  String get puzzleThemeMasterDescription => 'Атақты ойыншылардың ойындарынан алынған жұмбақтар.';

  @override
  String get puzzleThemeMasterVsMaster => 'Шеберлердің өзара ойындары';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Екі атақты ойыншылардың ойындарынан алынған жұмбақтар.';

  @override
  String get puzzleThemeMate => 'Мат';

  @override
  String get puzzleThemeMateDescription => 'Ойынды әдемі жеңіп алыңыз.';

  @override
  String get puzzleThemeMateIn1 => '1 жүрісті мат';

  @override
  String get puzzleThemeMateIn1Description => 'Бір жүріспен мат жасаңыз.';

  @override
  String get puzzleThemeMateIn2 => '2 жүрісті мат';

  @override
  String get puzzleThemeMateIn2Description => 'Екі жүріспен мат жасаңыз.';

  @override
  String get puzzleThemeMateIn3 => '3 жүрісті мат';

  @override
  String get puzzleThemeMateIn3Description => 'Үш жүріспен мат жасаңыз.';

  @override
  String get puzzleThemeMateIn4 => '4 жүрісті мат';

  @override
  String get puzzleThemeMateIn4Description => 'Төрт жүріспен мат жасаңыз.';

  @override
  String get puzzleThemeMateIn5 => '≥5 жүрісті мат';

  @override
  String get puzzleThemeMateIn5Description => 'Матқа жеткізетін жүрістер тізбегін табыңыз.';

  @override
  String get puzzleThemeMiddlegame => 'Ойын ортасы';

  @override
  String get puzzleThemeMiddlegameDescription => 'Ойынның екінші кезеңіндегі тактика.';

  @override
  String get puzzleThemeOneMove => 'Бір қадамды жұмбақ';

  @override
  String get puzzleThemeOneMoveDescription => 'Бір жүріспен ғана шешілетін жұмбақ.';

  @override
  String get puzzleThemeOpening => 'Бастау';

  @override
  String get puzzleThemeOpeningDescription => 'Ойынның алғашқы кезеңіндегі тактика.';

  @override
  String get puzzleThemePawnEndgame => 'Сарбаздар ойынсоңы';

  @override
  String get puzzleThemePawnEndgameDescription => 'Сарбаздары ғана бар ойынсоңы.';

  @override
  String get puzzleThemePin => 'Байлау';

  @override
  String get puzzleThemePinDescription => 'Артта тұрған құнды тасты жоғалту қаупі болғандықтан, алдыңғы тас орнынан кете алмайтындай жағдай.';

  @override
  String get puzzleThemePromotion => 'Айналу';

  @override
  String get puzzleThemePromotionDescription => 'Айналуға ұмтылған не айналу қаупін төндіретін сарбаз – тактиканың өзегі.';

  @override
  String get puzzleThemeQueenEndgame => 'Уәзір ойынсоңы';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Уәзірлер мен сарбаздары ғана бар ойынсоңы.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Уәзір мен Тура';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Уәзірлер, туралар мен сарбаздары ғана бар ойынсоңы.';

  @override
  String get puzzleThemeQueensideAttack => 'Уәзір жақты шабуыл';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Қарсылас патшасы уәзір жаққа бекінгеннен кейін оған жасалатын шабуыл.';

  @override
  String get puzzleThemeQuietMove => 'Үнсіз жүріс';

  @override
  String get puzzleThemeQuietMoveDescription => 'Шах етпейтін не басып алмайтын, бірақ болашақ соққыны дайындайтын жүріс.';

  @override
  String get puzzleThemeRookEndgame => 'Тура ойынсоңы';

  @override
  String get puzzleThemeRookEndgameDescription => 'Туралар мен сарбаздары ғана бар ойынсоңы.';

  @override
  String get puzzleThemeSacrifice => 'Құрбан ету';

  @override
  String get puzzleThemeSacrificeDescription => 'Кейін бір артықшылыққа жету мақсатыменен тастан әдейі айырылу.';

  @override
  String get puzzleThemeShort => 'Қысқа жұмбақ';

  @override
  String get puzzleThemeShortDescription => 'Жеңіске екі қадам.';

  @override
  String get puzzleThemeSkewer => 'Найза';

  @override
  String get puzzleThemeSkewerDescription => 'Байлауға қарама-қарсы: құнды тас соққы астында бола, артындағы арзан тасты беріп, қашуға мәжбүр болатындай жағдай.';

  @override
  String get puzzleThemeSmotheredMate => 'Қамаған мат';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Өз тастарымен қамалған патша бірде-бір жүріс жасай алмайтын кезде оған қарсыластың аты жасаған мат.';

  @override
  String get puzzleThemeSuperGM => 'Супер гроссмейстер ойындары';

  @override
  String get puzzleThemeSuperGMDescription => 'Дүние жүзі мықтыларының ойындарынан алынған жұмбақтар.';

  @override
  String get puzzleThemeTrappedPiece => 'Тұзаққа түскен';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Басып алынудан қаша алмайтын, жүрісі шектелген тас.';

  @override
  String get puzzleThemeUnderPromotion => 'Кіші айналу';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Ат, піл не тураға айналу.';

  @override
  String get puzzleThemeVeryLong => 'Ұп-ұзын жұмбақ';

  @override
  String get puzzleThemeVeryLongDescription => 'Жеңіске төрт не одан да көп қадам.';

  @override
  String get puzzleThemeXRayAttack => 'Рентген';

  @override
  String get puzzleThemeXRayAttackDescription => 'Бір тастың қарсылас тасын аттай бір шаршыны қорғауы не шабуылдауы.';

  @override
  String get puzzleThemeZugzwang => 'Цугцванг';

  @override
  String get puzzleThemeZugzwangDescription => 'Жүрісі шектелген тастардың әр жүрісі жалпы жағдайдың нашарлауына әкеп соқтыратын кез.';

  @override
  String get puzzleThemeHealthyMix => 'Аралас дастархан';

  @override
  String get puzzleThemeHealthyMixDescription => 'Барлығынан аз-аздан. Күтпеген жағдайларға бейім болыңыз! Дәл нағыз шахматтағыдай!';

  @override
  String get puzzleThemePlayerGames => 'Ойыншылардан';

  @override
  String get puzzleThemePlayerGamesDescription => 'Сіздің не басқаның ойындарынан құрылған жұмбақтарды табу.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Осы жұмбақтар көпшілікке ашық доменде сақтаулы, оларды осы жерден жүктеп алуға болады: $param';
  }

  @override
  String get searchSearch => 'Іздеу';

  @override
  String get settingsSettings => 'Баптаулар';

  @override
  String get settingsCloseAccount => 'Тіркелгіні жабу';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Сіздің тіркелгіңіз біреудің басқаруында, сондықтан сіз оны жаба алмайсыз.';

  @override
  String get settingsClosingIsDefinitive => 'Жабу - түпкілікті! Кері жол жоқ. Сенімдісіз бе?';

  @override
  String get settingsCantOpenSimilarAccount => 'Кейін дәл сондай атпенен жаңа тіркелгі жасай алмайсыз (әріп үлкендігі басқаша болса да).';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Мен ойымды өзгерттім, тіркелгімді жаппаңызшы';

  @override
  String get settingsCloseAccountExplanation => 'Сіз өз тіркелгіңіздің жабуын растайсыз ба? Тіркелгі жабу - қайтарымсыз әрекет. Тіркелгіге қайтадан ЕШҚАШАН КІРЕ АЛМАЙСЫЗ.';

  @override
  String get settingsThisAccountIsClosed => 'Бұл тіркелгі жабылды.';

  @override
  String get playWithAFriend => 'Доспен ойнау';

  @override
  String get playWithTheMachine => 'Компьютермен ойнау';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Ойынға біреуді шақыру үшін бұл сілтемені жіберіңіз';

  @override
  String get gameOver => 'Ойын аяқталды';

  @override
  String get waitingForOpponent => 'Қарсыласты күтудеміз';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Күтудеміз';

  @override
  String get yourTurn => 'Сіз жүресіз';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 деңгейі: $param2';
  }

  @override
  String get level => 'Деңгей';

  @override
  String get strength => 'Күші';

  @override
  String get toggleTheChat => 'Чат батырмасы';

  @override
  String get chat => 'Чат';

  @override
  String get resign => 'Берілу';

  @override
  String get checkmate => 'Мат';

  @override
  String get stalemate => 'Пат';

  @override
  String get white => 'Ақ';

  @override
  String get black => 'Қара';

  @override
  String get asWhite => 'ақпен';

  @override
  String get asBlack => 'қарамен';

  @override
  String get randomColor => 'Кез-келген түс';

  @override
  String get createAGame => 'Ойын бастау';

  @override
  String get whiteIsVictorious => 'Ақ жеңді';

  @override
  String get blackIsVictorious => 'Қара жеңді';

  @override
  String get youPlayTheWhitePieces => 'Сіз ақ таспен ойнайсыз';

  @override
  String get youPlayTheBlackPieces => 'Сіз қара таспен ойнайсыз';

  @override
  String get itsYourTurn => 'Кезек сізде!';

  @override
  String get cheatDetected => 'Алдау анықталды';

  @override
  String get kingInTheCenter => 'Патша тақтаның ортасында';

  @override
  String get threeChecks => 'Шах үш рет қойылды';

  @override
  String get raceFinished => 'Бәйге аяқталды';

  @override
  String get variantEnding => 'Тармақ аяқталды';

  @override
  String get newOpponent => 'Жаңа қарсылас';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Қарсылас сізбен тағы ойнағысы келеді';

  @override
  String get joinTheGame => 'Ойынға қосылу';

  @override
  String get whitePlays => 'Ақ жүреді';

  @override
  String get blackPlays => 'Қара жүреді';

  @override
  String get opponentLeftChoices => 'Қарсылас ойыннан шықты. Сіз жеңісті не теңдікті талап ете аласыз, немесе күтіңіз.';

  @override
  String get forceResignation => 'Жеңіс болсын';

  @override
  String get forceDraw => 'Теңдік болсын';

  @override
  String get talkInChat => 'Сөйлескенде, әдеп сақтаңыз!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Бұл сілтемеден бірінші келген адам сізбен ойнайды.';

  @override
  String get whiteResigned => 'Ақ берілді';

  @override
  String get blackResigned => 'Қара берілді';

  @override
  String get whiteLeftTheGame => 'Ақ ойыннан шықты';

  @override
  String get blackLeftTheGame => 'Қара ойыннан шықты';

  @override
  String get whiteDidntMove => 'Ақ жүрмей қойды';

  @override
  String get blackDidntMove => 'Қара жүрмей қойды';

  @override
  String get requestAComputerAnalysis => 'Компьютерлік талдауды сұрау';

  @override
  String get computerAnalysis => 'Компьютерлік талдау';

  @override
  String get computerAnalysisAvailable => 'Компьютерлік талдау ашық';

  @override
  String get computerAnalysisDisabled => 'Компьютерлік талдау өшірулі';

  @override
  String get analysis => 'Талдау тақтасы';

  @override
  String depthX(String param) {
    return 'Тереңдігі $param';
  }

  @override
  String get usingServerAnalysis => 'Сервердік талдау жүруде';

  @override
  String get loadingEngine => 'Есептеуіш жүктелуде...';

  @override
  String get calculatingMoves => 'Қадамдарды есептеу...';

  @override
  String get engineFailed => 'Есептеуішті жүктеу үзілді';

  @override
  String get cloudAnalysis => 'Бұлттық талдау';

  @override
  String get goDeeper => 'Терең кету';

  @override
  String get showThreat => 'Қауіпті көрсету';

  @override
  String get inLocalBrowser => 'өз браузер күшімен';

  @override
  String get toggleLocalEvaluation => 'Өз құрылғыңыздың күшімен есептеу';

  @override
  String get promoteVariation => 'Тармақты көтеру';

  @override
  String get makeMainLine => 'Негізгі жол ету';

  @override
  String get deleteFromHere => 'Мына жерден жою';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Тармақты дамыту';

  @override
  String get copyVariationPgn => 'Тармақтың PGN көшіру';

  @override
  String get move => 'Жүріс';

  @override
  String get variantLoss => 'Ұтылу жолы';

  @override
  String get variantWin => 'Жеңу жолы';

  @override
  String get insufficientMaterial => 'Матқа тас мөлшері жеткіліксіз';

  @override
  String get pawnMove => 'Сарбаз жүрісі';

  @override
  String get capture => 'Басып алу';

  @override
  String get close => 'Жабу';

  @override
  String get winning => 'Жеңіс';

  @override
  String get losing => 'Ұтылыс';

  @override
  String get drawn => 'Тең';

  @override
  String get unknown => 'Беймәлім';

  @override
  String get database => 'Дерекқор';

  @override
  String get whiteDrawBlack => 'Ақ / Тең / Қара';

  @override
  String averageRatingX(String param) {
    return 'Орташа рейтинг: $param';
  }

  @override
  String get recentGames => 'Кейінгі ойындар';

  @override
  String get topGames => 'Үздік ойындар';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param2 - $param3 жж FIDE-дәрежесі $param1+ ойыншылар қатысқан 2 миллион шынайы ойын';
  }

  @override
  String get dtzWithRounding => 'Дөңгелектелген DTZ50\'\' келесі басып алғанша не сарбаз жүргенше дейін жартыжүрістердің санына негізделген';

  @override
  String get noGameFound => 'Ешбір ойын табылмады';

  @override
  String get maxDepthReached => 'Іздеу шегіне жетті!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Баптаулар мәзірінен тағы ойындар қосайық па?';

  @override
  String get openings => 'Бастаулар';

  @override
  String get openingExplorer => 'Бастаулар қазынасы';

  @override
  String get openingEndgameExplorer => 'Бастау/ойынсоңы қоры';

  @override
  String xOpeningExplorer(String param) {
    return '$param бастаулар қазынасы';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Бастау/ойынсоңы қорынан бірінші қадам жасау';

  @override
  String get winPreventedBy50MoveRule => '50 жүрістік ережемен жеңіске жеткізбеу';

  @override
  String get lossSavedBy50MoveRule => '50 жүрістік ережемен жеңілістен құтылу';

  @override
  String get winOr50MovesByPriorMistake => 'Жеңіс немесе 50 жүріс ережесі';

  @override
  String get lossOr50MovesByPriorMistake => 'Жеңіліс немесе 50 жүріс ережесі';

  @override
  String get unknownDueToRounding => 'Жеңіс не жеңілістің шарты: басып алудан не сарбаз жүрісінен кейін, Сизигия дерекқорында DTZ шамасын дөңгелектеу кезінде сізге ұсынылаған дерекқор тармағына еру.';

  @override
  String get allSet => 'Барлығы дайын!';

  @override
  String get importPgn => 'PGN жүктеп салу';

  @override
  String get delete => 'Жою';

  @override
  String get deleteThisImportedGame => 'Бұл импортталған ойынды жоясыз ба?';

  @override
  String get replayMode => 'Ойнату тәртібі';

  @override
  String get realtimeReplay => 'Өз қарқыны';

  @override
  String get byCPL => 'CPL сәйкес';

  @override
  String get openStudy => 'Зерттеуді ашу';

  @override
  String get enable => 'Қосу';

  @override
  String get bestMoveArrow => 'Үздік жүрісті нұсқағыш';

  @override
  String get showVariationArrows => 'Тармақта нұсқағышты көрсету';

  @override
  String get evaluationGauge => 'Бағалауышты көрсету';

  @override
  String get multipleLines => 'Бірнеше жол';

  @override
  String get cpus => 'Процессор';

  @override
  String get memory => 'Жад';

  @override
  String get infiniteAnalysis => 'Шектеусіз талдау';

  @override
  String get removesTheDepthLimit => 'Тереңдік шектеулерін жояды, әрі компьютеріңізді қыздырады';

  @override
  String get engineManager => 'Есептеуіш басқарушысы';

  @override
  String get blunder => 'Өрескел қателік';

  @override
  String get mistake => 'Қателік';

  @override
  String get inaccuracy => 'Жеңіл қате';

  @override
  String get moveTimes => 'Жүріс ұзақтығы';

  @override
  String get flipBoard => 'Тақтаны аудару';

  @override
  String get threefoldRepetition => 'Үш реттік қайталану';

  @override
  String get claimADraw => 'Тепе-теңдікті сұрау';

  @override
  String get offerDraw => 'Тепе-теңдік сұрау';

  @override
  String get draw => 'Тепе-теңдік';

  @override
  String get drawByMutualAgreement => 'Келісімді тепе-теңдік';

  @override
  String get fiftyMovesWithoutProgress => 'Жетістігі жоқ елу жүріс';

  @override
  String get currentGames => 'Қазіргі ойындар';

  @override
  String get viewInFullSize => 'Жайып көрсету';

  @override
  String get logOut => 'Шығу';

  @override
  String get signIn => 'Кіру';

  @override
  String get rememberMe => 'Мені жадта сақтау';

  @override
  String get youNeedAnAccountToDoThat => 'Бұны істеу үшін сізге тіркелгі қажет';

  @override
  String get signUp => 'Тіркелу';

  @override
  String get computersAreNotAllowedToPlay => 'Компьютер көмегін пайдалану - тыйым. Ойын кезінде әр түрлі шахмат есептеуіштерін, дерекқорларын не басқа бір ойыншының көмегін қолданбаңыз. Сонымен қатар, бірнеше тіркелгі жасауды құптамаймыз, көп тіркелгі жасау - шектеуге әкеліп соқтырады.';

  @override
  String get games => 'Ойындар';

  @override
  String get forum => 'Форум';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 $param2 тақырыбында сөз жазды';
  }

  @override
  String get latestForumPosts => 'Форумдағы кейінгі жазбалар';

  @override
  String get players => 'Ойыншылар';

  @override
  String get friends => 'Достарыңыз';

  @override
  String get discussions => 'Сұхбаттар';

  @override
  String get today => 'Бүгін';

  @override
  String get yesterday => 'Кеше';

  @override
  String get minutesPerSide => 'Әр түске берілген уақыт';

  @override
  String get variant => 'Түрі';

  @override
  String get variants => 'Түрі';

  @override
  String get timeControl => 'Уақыт қалпы';

  @override
  String get realTime => 'Шын уақытта';

  @override
  String get correspondence => 'Хат-хабарлы';

  @override
  String get daysPerTurn => 'Күн бір жүріске';

  @override
  String get oneDay => 'Бір күн';

  @override
  String get time => 'Уақыт';

  @override
  String get rating => 'Рейтинг';

  @override
  String get ratingStats => 'Рейтинг статистикасы';

  @override
  String get username => 'Пайдаланушы аты';

  @override
  String get usernameOrEmail => 'Атыңыз не поштаңыз';

  @override
  String get changeUsername => 'Атыңызды өзгерту';

  @override
  String get changeUsernameNotSame => 'Тек әріптер үлкендігін өзгерту рұқсат. Мысалы, \"tolebi\" дегенді \"ToleBi\" деп.';

  @override
  String get changeUsernameDescription => 'Пайдаланушы атын өзгертіңіз. Бұны бір мәрте ғана жасауға рұқсат. Тек әріптің үлкендігін ғана өзгерте аласыз.';

  @override
  String get signupUsernameHint => 'Тіркеулі атты таңдағанда, өз үйіңізде айтуға лайықты болатындай болсын. Оны кейін өзгерте алмайсыз. Орынсыз, ұятсыз сөздері болса, тіркелгіңіз толықтай жабылады!';

  @override
  String get signupEmailHint => 'Құпиясөзді қайта орнату үшін ғана керек.';

  @override
  String get password => 'Құпиясөз';

  @override
  String get changePassword => 'Құпиясөзді өзгерту';

  @override
  String get changeEmail => 'Поштаны ауыстыру';

  @override
  String get email => 'Пошта';

  @override
  String get passwordReset => 'Құпиясөзді қайта орнату';

  @override
  String get forgotPassword => 'Құпиясөзді ұмытып қалдыңыз ба?';

  @override
  String get error_weakPassword => 'Осындай құпиясөз қолданыста көп, оны табу оңайға соғады.';

  @override
  String get error_namePassword => 'Құпиясөз ретінде өз тіркеулі атыңызды жазбаңыз.';

  @override
  String get blankedPassword => 'Бұл құпиясөзді сіз басқа сайтта қолданғансыз. Сол сайт құпиясөзді сақтай алмай жария етті. Сондықтан Личес тіркелгіңізді қорғау мақсатында сізден жаңа құпиясөзді орнатуды сұраймыз.';

  @override
  String get youAreLeavingLichess => 'Сіз Личес-тен шыққалы тұрсыз';

  @override
  String get neverTypeYourPassword => 'Личестегі құпиясөзіңізді басқа сайттарда қолданбаңыз!';

  @override
  String proceedToX(String param) {
    return '$param -ға өтіп кету';
  }

  @override
  String get passwordSuggestion => 'Басқа біреу ұсынған құпиясөзді қолданбаңыз. Ол адам тіркелгіңізді ұрлауы мүмкін.';

  @override
  String get emailSuggestion => 'Басқа біреу ұсынған пошта мекенжайын қолданбаңыз. Ол адам тіркелгіңізді ұрлауы мүмкін.';

  @override
  String get emailConfirmHelp => 'Поштаны растау туралы көмек';

  @override
  String get emailConfirmNotReceived => 'Тіркелуден кейін поштаңызға растау хаты келмеді ме?';

  @override
  String get whatSignupUsername => 'Қай атпен тіркелдіңіз?';

  @override
  String usernameNotFound(String param) {
    return '$param – осы аты бар ешбір қолданушыны таба алмадық.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Осы атты жаңа тіркелгі жасау үшін қолдансаңыз болады';

  @override
  String emailSent(String param) {
    return '$param поштасына хат жібердік.';
  }

  @override
  String get emailCanTakeSomeTime => 'Жетуіне біршама уақыт керек.';

  @override
  String get refreshInboxAfterFiveMinutes => '5 минут күтіп, поштаңыздың бетін жаңартып көріңіз.';

  @override
  String get checkSpamFolder => 'Сонымен қатар, Спам қалтасында қарап көріңіз. Хат сонда болса, \"Спам емес\" деп белгілеу жөн болар.';

  @override
  String get emailForSignupHelp => 'Егер де осы амалдардың бәрі жарамаса, бізге осындай хат жіберіңіз:';

  @override
  String copyTextToEmail(String param) {
    return 'Осы мәтінді көшіріп, $param жіберіңіз';
  }

  @override
  String get waitForSignupHelp => 'Тіркелуді аяқтау үшін біз тез арада жауап береміз.';

  @override
  String accountConfirmed(String param) {
    return '$param тіркелгісі расталды.';
  }

  @override
  String accountCanLogin(String param) {
    return '$param атымен дәл қазір тіркелкіге кіре аласыз.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Сізге растау хаты керек емес.';

  @override
  String accountClosed(String param) {
    return '$param деген тіркелгі жабылды.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return '$param тіркелгісі поштасыз тіркелген.';
  }

  @override
  String get rank => 'Орын';

  @override
  String rankX(String param) {
    return 'Орын: $param';
  }

  @override
  String get gamesPlayed => 'Ойындар саны';

  @override
  String get cancel => 'Болдыртпау';

  @override
  String get whiteTimeOut => 'Ақтың уақыты бітті';

  @override
  String get blackTimeOut => 'Қараның уақыты бітті';

  @override
  String get drawOfferSent => 'Тепе-теңдік сұрауда';

  @override
  String get drawOfferAccepted => 'Тепе-теңдікке келісті';

  @override
  String get drawOfferCanceled => 'Тепе-теңдік сұрау тоқтатылды';

  @override
  String get whiteOffersDraw => 'Ақ тепе-теңдік сұрауда';

  @override
  String get blackOffersDraw => 'Қара тепе-теңдік сұрауда';

  @override
  String get whiteDeclinesDraw => 'Ақ тепе-теңдіктен бас тартты';

  @override
  String get blackDeclinesDraw => 'Қара тепе-теңдіктен бас тартты';

  @override
  String get yourOpponentOffersADraw => 'Қарсыласыңыз тепе-теңдік сұрап отыр';

  @override
  String get accept => 'Келісу';

  @override
  String get decline => 'Келіспеу';

  @override
  String get playingRightNow => 'Қазір ойнап отыр';

  @override
  String get eventInProgress => 'Қазір болып жатыр';

  @override
  String get finished => 'Аяқталды';

  @override
  String get abortGame => 'Ойынды тоқтату';

  @override
  String get gameAborted => 'Ойын тоқтатылды';

  @override
  String get standard => 'Классикалық';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Шектеусіз';

  @override
  String get mode => 'Бағалау';

  @override
  String get casual => 'Жай';

  @override
  String get rated => 'Бағалы';

  @override
  String get casualTournament => 'Кәдімгі';

  @override
  String get ratedTournament => 'Бағалы';

  @override
  String get thisGameIsRated => 'Бұл ойын бағалы';

  @override
  String get rematch => 'Қайта ойнау';

  @override
  String get rematchOfferSent => 'Қайта ойнау сұралуда';

  @override
  String get rematchOfferAccepted => 'Қайта ойнауға келісті';

  @override
  String get rematchOfferCanceled => 'Қайта ойнау сұранысы тоқтатылды';

  @override
  String get rematchOfferDeclined => 'Қайта ойнауға келіспеді';

  @override
  String get cancelRematchOffer => 'Қайта ойнау сұранысын тоқтату';

  @override
  String get viewRematch => 'Қайта ойнауды қарау';

  @override
  String get confirmMove => 'Жүрісті растаңыз';

  @override
  String get play => 'Ойнау';

  @override
  String get inbox => 'Хаттар';

  @override
  String get chatRoom => 'Сөйлесу бөлмесі';

  @override
  String get loginToChat => 'Чатқа кіріңіз';

  @override
  String get youHaveBeenTimedOut => 'Сіз шектеуге шалдықтыңыз.';

  @override
  String get spectatorRoom => 'Көрермендер бөлмесі';

  @override
  String get composeMessage => 'Хат жазу';

  @override
  String get subject => 'Тақырып';

  @override
  String get send => 'Жіберу';

  @override
  String get incrementInSeconds => 'Секунд қосылады';

  @override
  String get freeOnlineChess => 'Тегін онлайн шахмат';

  @override
  String get exportGames => 'Ойынды жүктеп алу';

  @override
  String get ratingRange => 'Рейтинг ауқымы';

  @override
  String get thisAccountViolatedTos => 'Бұл тіркелгі Личес-тің Қызмет көрсету шартын бұзды';

  @override
  String get openingExplorerAndTablebase => 'Бастаулар мен ойынсоңдарының қоры';

  @override
  String get takeback => 'Қайтару';

  @override
  String get proposeATakeback => 'Жүріс қайтаруды сұрау';

  @override
  String get takebackPropositionSent => 'Жүрісті қайтару сұралуда';

  @override
  String get takebackPropositionDeclined => 'Жүрісті қайтаруға келіспеді';

  @override
  String get takebackPropositionAccepted => 'Жүрісті қайтаруға келісті';

  @override
  String get takebackPropositionCanceled => 'Жүрісті қайтарудан бас тартты';

  @override
  String get yourOpponentProposesATakeback => 'Қарсылас жүріс қайтаруды сұрап тұр';

  @override
  String get bookmarkThisGame => 'Бұл ойынды бетбелгіге сақтау';

  @override
  String get tournament => 'Жарыс';

  @override
  String get tournaments => 'Жарыстар';

  @override
  String get tournamentPoints => 'Жарыс ұпайы';

  @override
  String get viewTournament => 'Жарысты қарап шығу';

  @override
  String get backToTournament => 'Жарысқа оралу';

  @override
  String get noDrawBeforeSwissLimit => 'Швейцарлық жарыста 30 қадам болмай тепе-теңдік те болмайды.';

  @override
  String get thematic => 'Тақырыптық';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Сіздің $param рейтингіңіз болжамалы';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return '$param1 рейтингіңіз ($param2) тым жоғары';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Үздік апталық $param1 рейтингіңіз ($param2) тым жоғары';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return '$param1 рейтингіңіз тым аз ($param2)';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Бағалы $param2 ≥ $param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Бағалы $param2 кейінгі аптада ≤ $param1';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Сіздің тобыңыз – $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Сіз $param тобының мүшесі емессіз';
  }

  @override
  String get backToGame => 'Ойынға оралу';

  @override
  String get siteDescription => 'Тегін онлайн шахмат алаңы. Кескіні таза сайтта шахмат ойнаңыз. Жарнама жоқ, тіркелу мен қосымша програмды қажет етпейді. Шахматты компьютермен, достарыңызбен не кез-келген қарсыласпен ойнаңыз.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 $param2 тобына қосылды';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 $param2 тобын құрды';
  }

  @override
  String get startedStreaming => 'стрим басталды';

  @override
  String xStartedStreaming(String param) {
    return '$param стрим бастады';
  }

  @override
  String get averageElo => 'Орташа рейтинг';

  @override
  String get location => 'Аймақ';

  @override
  String get filterGames => 'Ойын сүзгі';

  @override
  String get reset => 'Қайтару';

  @override
  String get apply => 'Сақтау';

  @override
  String get save => 'Сақтау';

  @override
  String get leaderboard => 'Мықтылар қатары';

  @override
  String get screenshotCurrentPosition => 'Осы күйді суретке түсіру';

  @override
  String get gameAsGIF => 'GIF етіп сақтау';

  @override
  String get pasteTheFenStringHere => 'FEN мәтінін осы жерге қойыңыз';

  @override
  String get pasteThePgnStringHere => 'PGN мәтінін осы жерге қойыңыз';

  @override
  String get orUploadPgnFile => 'Не PGN файлын жүктеп салыңыз';

  @override
  String get fromPosition => 'Күйден бастап';

  @override
  String get continueFromHere => 'Осы жерден жалғастыру';

  @override
  String get toStudy => 'Зертхана';

  @override
  String get importGame => 'Ойынды жүктеп салу';

  @override
  String get importGameExplanation => 'Ойынның PGN-ын салыңыз.\nБұл ойынды қайта көру, компьютерлік талдау, чат пен бөліспелі URL-ға жол ашады.';

  @override
  String get importGameCaveat => 'Вариациялар жойылады. Оларды сақтау үшін зерттеу арқылы PGN импорттаңыз.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Бұл шахмат түрлі CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Тақтада жүріс жасаумен адам екеніңізді растаңыз.';

  @override
  String get captcha_fail => 'Шахмат түріндегі есепті шешіңіз.';

  @override
  String get notACheckmate => 'Мат емес';

  @override
  String get whiteCheckmatesInOneMove => 'Ақ бір жүріспен мат қояды';

  @override
  String get blackCheckmatesInOneMove => 'Қара бір жүріспен мат қояды';

  @override
  String get retry => 'Қайталау';

  @override
  String get reconnecting => 'Байланыс қайта орнауда';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Қалаулы қарсыластар';

  @override
  String get follow => 'Серік болу';

  @override
  String get following => 'Серіксіз';

  @override
  String get unfollow => 'Серік болмау';

  @override
  String followX(String param) {
    return '$param серік болу';
  }

  @override
  String unfollowX(String param) {
    return '$param серік болмау';
  }

  @override
  String get block => 'Бұғаттау';

  @override
  String get blocked => 'Бұғатталған';

  @override
  String get unblock => 'Бұғаттан шығару';

  @override
  String get followsYou => 'Сізге серік';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 $param2 серігі болды';
  }

  @override
  String get more => 'Жаю';

  @override
  String get memberSince => 'Тіркелген күні';

  @override
  String lastSeenActive(String param) {
    return '$param белсенді болды';
  }

  @override
  String get player => 'Ойыншы';

  @override
  String get list => 'Тiзiм';

  @override
  String get graph => 'Диаграм';

  @override
  String get required => 'Талап қойылады.';

  @override
  String get openTournaments => 'Ашық жарыстар';

  @override
  String get duration => 'Ұзақтығы';

  @override
  String get winner => 'Жеңімпаз';

  @override
  String get standing => 'Орны';

  @override
  String get createANewTournament => 'Жаңа жарыс құру';

  @override
  String get tournamentCalendar => 'Жарыс күнтізбесі';

  @override
  String get conditionOfEntry => 'Кіру талаптары:';

  @override
  String get advancedSettings => 'Қосымша баптаулар';

  @override
  String get safeTournamentName => 'Жарысты түзу, жөнді сөзбен атаңыз.';

  @override
  String get inappropriateNameWarning => 'Кез-келген, тіпті шамалы орынсыз әрекет себебінен тіркелгіңіз жабылуы мүмкін.';

  @override
  String get emptyTournamentName => 'Елеулі бір шахматшының атымен атау үшін бос қалдырыңыз.';

  @override
  String get makePrivateTournament => 'Кіруді құпиясөзбен шектеп, жарысты оңашалаңыз';

  @override
  String get join => 'Қосылыңыз';

  @override
  String get withdraw => 'Жарыстан шығу';

  @override
  String get points => 'Ұпайлар';

  @override
  String get wins => 'Жеңіс';

  @override
  String get losses => 'Ұтылыс';

  @override
  String get createdBy => 'Жасаған';

  @override
  String get tournamentIsStarting => 'Жарыс басталуда';

  @override
  String get tournamentPairingsAreNowClosed => 'Жарысқа жұпталу аяқталды.';

  @override
  String standByX(String param) {
    return '$param күтіңіз, ойыншылар жұпталуда, дайын болыңыз!';
  }

  @override
  String get pause => 'Кідіру';

  @override
  String get resume => 'Жалғастыру';

  @override
  String get youArePlaying => 'Сіз ойындасыз!';

  @override
  String get winRate => 'Жеңіс үлесі';

  @override
  String get berserkRate => 'Берсерк үлесі';

  @override
  String get performance => 'Жетістік';

  @override
  String get tournamentComplete => 'Жарыс қорытындысы';

  @override
  String get movesPlayed => 'Жүрістер саны';

  @override
  String get whiteWins => 'Ақтардың жеңісі';

  @override
  String get blackWins => 'Қаралардың жеңісі';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Тепе-теңдік';

  @override
  String nextXTournament(String param) {
    return 'Келесі $param жарыс:';
  }

  @override
  String get averageOpponent => 'Орташа қарсылас';

  @override
  String get boardEditor => 'Еркін тақта';

  @override
  String get setTheBoard => 'Тақтаны орнатыңыз';

  @override
  String get popularOpenings => 'Танымал бастаулар';

  @override
  String get endgamePositions => 'Ойынсоңы күйлері';

  @override
  String chess960StartPosition(String param) {
    return 'Шахмат960 бастапқы күйі: $param';
  }

  @override
  String get startPosition => 'Бастапқы күй';

  @override
  String get clearBoard => 'Тақтаны жинау';

  @override
  String get loadPosition => 'Күйді жүктеп салу';

  @override
  String get isPrivate => 'Құпиялы';

  @override
  String reportXToModerators(String param) {
    return '$param туралы модераторға шағымдану';
  }

  @override
  String profileCompletion(String param) {
    return 'Куәліктің толуы: $param';
  }

  @override
  String xRating(String param) {
    return '$param рейтингі';
  }

  @override
  String get ifNoneLeaveEmpty => 'Жоқ болса, бос қалдырыңыз';

  @override
  String get profile => 'Куәлік';

  @override
  String get editProfile => 'Куәлікті өзгерту';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Өмірбаян';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Рахмет!';

  @override
  String get socialMediaLinks => 'Әлеуметтік медиа';

  @override
  String get oneUrlPerLine => 'Бір жолға бір URL.';

  @override
  String get inlineNotation => 'Біржолды хаттама';

  @override
  String get makeAStudy => 'Ұзаққа сақтау әрі бөлісу үшін зерттеуді жасаған дұрыс.';

  @override
  String get clearSavedMoves => 'Жүрістерді жою';

  @override
  String get previouslyOnLichessTV => 'Личес ТВ-да көрсетілген';

  @override
  String get onlinePlayers => 'Желідегі ойыншылар';

  @override
  String get activePlayers => 'Белсенділер';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Ескерту - ойын бағаланады, бірақ сағатсыз өтеді!';

  @override
  String get success => 'Бәрі дұрыс!';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Жүрістен кейін келесі ойынға бірден өту';

  @override
  String get autoSwitch => 'Авто қосу';

  @override
  String get puzzles => 'Жұмбақтар';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Атауы';

  @override
  String get description => 'Сипаттама';

  @override
  String get descPrivate => 'Құпия сипаттама';

  @override
  String get descPrivateHelp => 'Тек топ мүшелері көретін мәтін. Жазылған болса, жария сипаттаманы алмастырады.';

  @override
  String get no => 'Жоқ';

  @override
  String get yes => 'Иә';

  @override
  String get help => 'Көмек:';

  @override
  String get createANewTopic => 'Жаңа тақырып құру';

  @override
  String get topics => 'Тақырып';

  @override
  String get posts => 'Жазба';

  @override
  String get lastPost => 'Кейінгі хабар';

  @override
  String get views => 'Қаралған';

  @override
  String get replies => 'Жауаптар';

  @override
  String get replyToThisTopic => 'Осы тақырыпта жауап беру';

  @override
  String get reply => 'Жауап беру';

  @override
  String get message => 'Мәтіні';

  @override
  String get createTheTopic => 'Тақырып құру';

  @override
  String get reportAUser => 'Ойыншы туралы шағым';

  @override
  String get user => 'Ойыншы';

  @override
  String get reason => 'Түйіні';

  @override
  String get whatIsIheMatter => 'Не болды?';

  @override
  String get cheat => 'Чит, алдап ойнау';

  @override
  String get troll => 'Троль, кемсіту';

  @override
  String get other => 'Басқа';

  @override
  String get reportDescriptionHelp => 'Ойынның (-дардың) сілтемесін қойып, осы ойыншының қай әрекеті орынсыз болғанын түсіндіріп беріңіз. Жай ғана \"ол алдап ойнады\" деп жаза салмай, осы ойға қалай келгеніңізді айтып беріңіз. Сіздің шағымыңыз ағылшын тілінде жазылса, тезірек тексеруден өтеді.';

  @override
  String get error_provideOneCheatedGameLink => 'Кемі бір ойынның сілтемесін беруіңізді сұраймыз.';

  @override
  String by(String param) {
    return 'жасаған – $param';
  }

  @override
  String importedByX(String param) {
    return 'Жүктеп салған – $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Бұл тақырып жабылды.';

  @override
  String get blog => 'Блог';

  @override
  String get notes => 'Жазбалар';

  @override
  String get typePrivateNotesHere => 'Жеке жазбаларыңыз үшін';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Бұл ойыншы туралы жеке жазба жазу';

  @override
  String get noNoteYet => 'Жазба жоқ';

  @override
  String get invalidUsernameOrPassword => 'Атыңыз не құпиясөз қате';

  @override
  String get incorrectPassword => 'Құпиясөз қате';

  @override
  String get invalidAuthenticationCode => 'Өкіл-растама құлыпсөзі қате';

  @override
  String get emailMeALink => 'Поштама сілтеме жібер';

  @override
  String get currentPassword => 'Қазіргі құпиясөз';

  @override
  String get newPassword => 'Жаңа кұпиясөз';

  @override
  String get newPasswordAgain => 'Жаңа құпиясөз (қайтадан)';

  @override
  String get newPasswordsDontMatch => 'Жаңа құпиясөздер бірдей емес';

  @override
  String get newPasswordStrength => 'Құпиясөздің беріктігі';

  @override
  String get clockInitialTime => 'Сағаттың бастапқы уақыты';

  @override
  String get clockIncrement => 'Уақыт қосылғышы';

  @override
  String get privacy => 'Жеке мәлімет сақтығы';

  @override
  String get privacyPolicy => 'Жеке мәлімет туралы саясат';

  @override
  String get letOtherPlayersFollowYou => 'Ойыншылар сізге серік бола ала ма?';

  @override
  String get letOtherPlayersChallengeYou => 'Ойыншылар сізді ойынға шақыра ала ма?';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Ойыншылар сізді зерттеуге шақыра ала ма?';

  @override
  String get sound => 'Дыбыстар';

  @override
  String get none => 'Жоқ';

  @override
  String get fast => 'Тез';

  @override
  String get normal => 'Орташа';

  @override
  String get slow => 'Баяу';

  @override
  String get insideTheBoard => 'Тақта бетінде';

  @override
  String get outsideTheBoard => 'Тақта сыртында';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Ұзақ ойындар кезінде';

  @override
  String get always => 'Әрқашан';

  @override
  String get never => 'Ешқашан';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 $param2-та жарысты';
  }

  @override
  String get victory => 'Жеңіс';

  @override
  String get defeat => 'Жеңіліс';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param2-ға қарсы $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param2-ға қарсы $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param2-ға қарсы $param3';
  }

  @override
  String get timeline => 'Уақыт тізбегі';

  @override
  String get starting => 'Басталуы:';

  @override
  String get allInformationIsPublicAndOptional => 'Бүкіл мәлімет – жалпыға ашық, әрі оны көрсету – сіздің өз еркіңіз.';

  @override
  String get biographyDescription => 'Өзіңіз туралы айтып беріңізші: айналысатын істеріңіз, неге шахматпен шұғылданасыз, ұнайтын бастаулар, ойыншылар, ...';

  @override
  String get listBlockedPlayers => 'Бұғатталған ойыншыларды көрсету';

  @override
  String get human => 'Адам';

  @override
  String get computer => 'Компьютер';

  @override
  String get side => 'Жақ';

  @override
  String get clock => 'Сағат-құрал';

  @override
  String get opponent => 'Қарсылас';

  @override
  String get learnMenu => 'Үйрену';

  @override
  String get studyMenu => 'Зерттеу';

  @override
  String get practice => 'Жаттығу';

  @override
  String get community => 'Қауым';

  @override
  String get tools => 'Құралдар';

  @override
  String get increment => 'Қосылғыш';

  @override
  String get error_unknown => 'Қате шама';

  @override
  String get error_required => 'Бұл жолды толтырыңыз';

  @override
  String get error_email => 'Бұл пошта мекенжайы қате';

  @override
  String get error_email_acceptable => 'Бұл пошта мекенжайы қабылданбайды. Оны тексеріп, қайта көріңіз.';

  @override
  String get error_email_unique => 'Пошта мекенжайы қате немесе бос емес';

  @override
  String get error_email_different => 'Бұл сіздің бұрыңғы поштаңыз';

  @override
  String error_minLength(String param) {
    return 'Кемінде $param таңба болу керек';
  }

  @override
  String error_maxLength(String param) {
    return 'Ең көбі $param таңба болу керек';
  }

  @override
  String error_min(String param) {
    return 'Кемінде $param болу керек';
  }

  @override
  String error_max(String param) {
    return 'Ең көбі $param болу керек';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Егер рейтингі ± $param болса';
  }

  @override
  String get ifRegistered => 'Тіркелгендер';

  @override
  String get onlyExistingConversations => 'Тек бар әңгімелесуден';

  @override
  String get onlyFriends => 'Достар ғана';

  @override
  String get menu => 'Мәзір';

  @override
  String get castling => 'Бекіну';

  @override
  String get whiteCastlingKingside => 'Ақтар O-O';

  @override
  String get blackCastlingKingside => 'Қаралар O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Ойынмен өткен уақыт: $param';
  }

  @override
  String get watchGames => 'Ойындарын бақылау';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'TV қараумен өткен уақыт: $param';
  }

  @override
  String get watch => 'Бақылау';

  @override
  String get videoLibrary => 'Видеохана';

  @override
  String get streamersMenu => 'Стримерлер';

  @override
  String get mobileApp => 'Мобильді қолданба';

  @override
  String get webmasters => 'Веб-құрастырушылар';

  @override
  String get about => 'Сипаттама';

  @override
  String aboutX(String param) {
    return '$param туралы';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 тегін ($param2), еркін, жарнамасыз, түбір коды ашық шахмат сервері.';
  }

  @override
  String get really => 'шынымен';

  @override
  String get contribute => 'Үлес қосу';

  @override
  String get termsOfService => 'Қызмет көрсету шарты';

  @override
  String get sourceCode => 'Түбір код';

  @override
  String get simultaneousExhibitions => 'Қалың ойындар';

  @override
  String get host => 'Бас ойыншы';

  @override
  String hostColorX(String param) {
    return 'Бас ойыншының түсі: $param';
  }

  @override
  String get yourPendingSimuls => 'Кідірулі тұрған қалың ойындарыңыз';

  @override
  String get createdSimuls => 'Жаңа құрылған қалың ойындар';

  @override
  String get hostANewSimul => 'Қалың ойынды бастау';

  @override
  String get signUpToHostOrJoinASimul => 'Қалың ойынды бастау не қосылу үшін тіркеліңіз';

  @override
  String get noSimulFound => 'Қалың ойын табылмады';

  @override
  String get noSimulExplanation => 'Бұндай қалың ойын жоқ.';

  @override
  String get returnToSimulHomepage => 'Қалың ойынның бастапқы бетіне оралу';

  @override
  String get aboutSimul => 'Қалың ойында ойыншы бір мезгілде бірнешеуге қарсы ойнайды.';

  @override
  String get aboutSimulImage => 'Фишер 50 қарсыластың 47-сін жеңіп, 2-мен тең ойнап, 1-нен жеңілді.';

  @override
  String get aboutSimulRealLife => 'Бұл түсінік шынайы өмірден алынған: ойында бас ойыншы тақталарды аралап, бір-бірден жүріс жасап отырады.';

  @override
  String get aboutSimulRules => 'Қалың ойын басталысымен әр ойыншы бас ойыншымен бел ұстасады. Барлық ішкі ойындар аяқталғанда, жалпы ойын да аяқталады.';

  @override
  String get aboutSimulSettings => 'Қалың ойын – әрқашанда жай ойын. Қайта ойнау, жүрісті қайтару, уақыт қосу дегендер болмайды.';

  @override
  String get create => 'Құру';

  @override
  String get whenCreateSimul => 'Сіз қалың ойын құрғанда, бір мезгілде бірнеше қарсыласпен ойнайсыз.';

  @override
  String get simulVariantsHint => 'Егер сіз бірнеше шахмат түрін таңдасаңыз, әр ойыншы соның арасынан біреуін таңдайды.';

  @override
  String get simulClockHint => 'Фишер Сағатын баптау. Қарсыластарыңыз көп болса, уақыт та көп қажет.';

  @override
  String get simulAddExtraTime => 'Қалың ойынды жеңілдету үшін өзіңізге қосымша уақыт қоса аласыз.';

  @override
  String get simulHostExtraTime => 'Бас ойыншының қосымша уақыты';

  @override
  String get simulAddExtraTimePerPlayer => 'Жаңа кірген әр ойыншы үшін өзіңіздің бастапқы уақытыңызды көбейту.';

  @override
  String get simulHostExtraTimePerPlayer => 'Әр ойыншы үшін бас ойыншыға берілетін қосымша уақыт';

  @override
  String get lichessTournaments => 'Личес жарыстары';

  @override
  String get tournamentFAQ => 'Алаң жарысы туралы Жұрттан-сұрақ';

  @override
  String get timeBeforeTournamentStarts => 'Жарыс басталуына қалған уақыт';

  @override
  String get averageCentipawnLoss => 'Қателіктердің орташа мәні';

  @override
  String get accuracy => 'Дәлдік';

  @override
  String get keyboardShortcuts => 'Пернетақта пәрмендері';

  @override
  String get keyMoveBackwardOrForward => 'алға/артқа жүру';

  @override
  String get keyGoToStartOrEnd => 'басына/аяғына жүру';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'пікірлерді көрсету/жасыру';

  @override
  String get keyEnterOrExitVariation => 'тармаққа кіру/шығу';

  @override
  String get keyRequestComputerAnalysis => 'Компьютерлік талдауды бастаңыз, Әр қателіктен сабақ алыңыз';

  @override
  String get keyNextLearnFromYourMistakes => 'Келесі (Қателіктен сабақ алыңыз)';

  @override
  String get keyNextBlunder => 'Келесі өрескел қателік';

  @override
  String get keyNextMistake => 'Келесі қателік';

  @override
  String get keyNextInaccuracy => 'Келесі ағаттық';

  @override
  String get keyPreviousBranch => 'Previous branch';

  @override
  String get keyNextBranch => 'Next branch';

  @override
  String get toggleVariationArrows => 'Toggle variation arrows';

  @override
  String get cyclePreviousOrNextVariation => 'Cycle previous/next variation';

  @override
  String get toggleGlyphAnnotations => 'Toggle move annotations';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => 'Variation arrows let you navigate without using the move list.';

  @override
  String get playSelectedMove => 'play selected move';

  @override
  String get newTournament => 'Жаңа жарыс';

  @override
  String get tournamentHomeTitle => 'Шахмат жарыстары әр-түрлі уақыт қалыптары мен шахмат түрлерін қамтиды';

  @override
  String get tournamentHomeDescription => 'Қарқынды шахмат жарыстарына қош келдіңіз! Личестің ресми жарыстарына қатысам десеңіз не жаңадан жарысты құрастыру – таңдау сізде. Буллит, Блиц, Классикалық, Шахмат960, Тау патшасы, Үш шах пен басқа да қызықты шахмат түрлерін ойнаңыз.';

  @override
  String get tournamentNotFound => 'Жарыс табылмады';

  @override
  String get tournamentDoesNotExist => 'Бұл жарыс жоқ.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Егер ойыншылардың барлығы жарыстан шықса, бұл жарыс тоқталуы мүмкін.';

  @override
  String get returnToTournamentsHomepage => 'Жарыстың бастапқы бетіне оралу';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Апталық $param рейтингтер таралымы';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Сіздің $param1 рейтингіңіз – $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Сіз $param2 ойышыларының $param1-ынан күштірексіз.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 $param3 ойышыларының $param2-ынан күштірек.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return '$param1 $param2 ойыншылардан озық';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Сіздің ресми $param рейтингіңіз жоқ.';
  }

  @override
  String get yourRating => 'Рейтингіңіз';

  @override
  String get cumulative => 'Жинақылық';

  @override
  String get glicko2Rating => 'Glicko-2 рейтинг';

  @override
  String get checkYourEmail => 'Поштаңызды қараңыз';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Біз сізге электронды хат жібердік. Хаттағы сілтемеге бассаңыз, тіркелгіңіз расталады.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Егер хат көрінбей тұрса, басқа болжамды жерлерді қарап көріңіз, мысалы – қоржын, спам, әлеуметтік желілер сияқты қалталар.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Біз хатты $param-ға жібердік. Құпиясөзді арылту үшін хаттағы сілтемеге басыңыз.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Сіздің тіркелуіңіз – $param-н мойындайтыныңыздың белгісі.';
  }

  @override
  String readAboutOur(String param) {
    return 'Біздің $param туралы оқыңыз.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Личес пен сіздің араңыздағы кідіріс';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Личес сервердің жүрісті өңдеуге жұмсайтын уақыты';

  @override
  String get downloadAnnotated => 'Өңделген күйде алу';

  @override
  String get downloadRaw => 'Шикі түрде алу';

  @override
  String get downloadImported => 'Жүктеп салынғанды алу';

  @override
  String get crosstable => 'Қос дерек';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Сонымен қатар, тақта үстінен тінтуір доңғалағын айналдырып жүріс жасай аласыз.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Компьютерлік тармақты көру үшін үстіне меңзер апарыңыз.';

  @override
  String get analysisShapesHowTo => 'Тақтада шеңбер мен нұсқағыш сызу үшін тінтуірмен оң шертіңіз немесе shift баса сол шертіңіз.';

  @override
  String get letOtherPlayersMessageYou => 'Ойыншыларға сізге хабар жіберу рұқсат па?';

  @override
  String get receiveForumNotifications => 'Форумда сіз туралы жазса, хабарлама алу';

  @override
  String get shareYourInsightsData => 'Шахмат жайлы ойларыңызды бөлісу';

  @override
  String get withNobody => 'Ешкіммен';

  @override
  String get withFriends => 'Достармен';

  @override
  String get withEverybody => 'Бәрімен';

  @override
  String get kidMode => 'Балалық нұсқа';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Бұл сақтық үшін. Балалық нұсқада бүкіл әңгімелесу жолдары жабылған. Мақсатыңыз – бала мен мектеп оқушыларын басқа интернет қолданушыларынан қорғау болса, осы нұсқаны іске қосыңыз.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Балалық нұсқа кезінде Личес таңбасына $param белгісі қосылады, осылайша балаңызға қауіп жоқ екенін білесіз.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Тіркелгіңізді ұстаз басқарады. Балалық нұсқаны өшіруді одан сұраңыз.';

  @override
  String get enableKidMode => 'Балалық нұсқаны іске қосу';

  @override
  String get disableKidMode => 'Балалық нұсқаны сөндіру';

  @override
  String get security => 'Қорғаныс';

  @override
  String get sessions => 'Қосылулар';

  @override
  String get revokeAllSessions => 'бәрін ажырату';

  @override
  String get playChessEverywhere => 'Шахматты кез-келген жерде ойнаңыз';

  @override
  String get asFreeAsLichess => 'Личес-тей тегін';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Ақша қуып емес, шахматты қызыққаннан жасап отырмыз';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Барлық құралдары бүкіл адам үшін тегін';

  @override
  String get zeroAdvertisement => 'Еш жарнамасыз';

  @override
  String get fullFeatured => 'Толыққанды жабдықталған';

  @override
  String get phoneAndTablet => 'Телепон мен планшет';

  @override
  String get bulletBlitzClassical => 'Буллит, Блиц, Классикалық';

  @override
  String get correspondenceChess => 'Хат-хабарлы шахмат';

  @override
  String get onlineAndOfflinePlay => 'Онлайн мен оффлайн ойнау';

  @override
  String get viewTheSolution => 'Жауабты қарау';

  @override
  String get followAndChallengeFriends => 'Серік болып, достарды ойынға шақыру';

  @override
  String get gameAnalysis => 'Ойынды талдау';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 $param2-ны бастады';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 $param2-ға қосылды';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 $param2-ны ұнатады';
  }

  @override
  String get quickPairing => 'Қалыптар';

  @override
  String get lobby => 'Шақырулар';

  @override
  String get anonymous => 'Аноним';

  @override
  String yourScore(String param) {
    return 'Жетістігіңіз: $param';
  }

  @override
  String get language => 'Тіл';

  @override
  String get background => 'Фон';

  @override
  String get light => 'Жарық';

  @override
  String get dark => 'Қараңғы';

  @override
  String get transparent => 'Мөлдір';

  @override
  String get deviceTheme => 'Құрылғы кейпі';

  @override
  String get backgroundImageUrl => 'Фон суретіне сілтеме:';

  @override
  String get board => 'Board';

  @override
  String get size => 'Size';

  @override
  String get opacity => 'Opacity';

  @override
  String get brightness => 'Brightness';

  @override
  String get hue => 'Hue';

  @override
  String get boardReset => 'Reset colours to default';

  @override
  String get pieceSet => 'Тастар келбеті';

  @override
  String get embedInYourWebsite => 'Өз сайтыңызға енгізу';

  @override
  String get usernameAlreadyUsed => 'Бұл ат қолданыста, басқасын жазып көріңіз.';

  @override
  String get usernamePrefixInvalid => 'Атыңыз әріптен басталуы керек.';

  @override
  String get usernameSuffixInvalid => 'Атыңыз әріп не санмен аяқталуы керек.';

  @override
  String get usernameCharsInvalid => 'Тіркеулі атыңызда тек қана әріп, сан, сызықша мен төменгі сызықша сияқты таңбалар болу керек. Бірнеше сызықша не төменгі сызықшаларды қатарынан жазбаңыз.';

  @override
  String get usernameUnacceptable => 'Бұл атты қолдануға болмайды.';

  @override
  String get playChessInStyle => 'Сәнді бола ойнаңыз';

  @override
  String get chessBasics => 'Шахмат әліппесі';

  @override
  String get coaches => 'Бапкерлер';

  @override
  String get invalidPgn => 'Қате PGN';

  @override
  String get invalidFen => 'Қате FEN';

  @override
  String get custom => 'Басқа';

  @override
  String get notifications => 'Хабарлама';

  @override
  String notificationsX(String param1) {
    return 'Хабарламалар: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get practiceWithComputer => 'Компьютермен жаттығу';

  @override
  String anotherWasX(String param) {
    return 'Тағы $param';
  }

  @override
  String bestWasX(String param) {
    return 'Үздігі $param';
  }

  @override
  String get youBrowsedAway => 'Аяғына жеттіңіз';

  @override
  String get resumePractice => 'Жаттығуды жалғастыру';

  @override
  String get drawByFiftyMoves => '\"50 жүріс\" ережесіне сәйкес ойын тепе-теңдікпен аяқталды.';

  @override
  String get theGameIsADraw => 'Ойын тең аяқталды.';

  @override
  String get computerThinking => 'Компьютер ойлануда ...';

  @override
  String get seeBestMove => 'Үздік жүрісті көру';

  @override
  String get hideBestMove => 'Үздік жүрісті жасыру';

  @override
  String get getAHint => 'Көмек';

  @override
  String get evaluatingYourMove => 'Жүріс өңделіп жатыр ...';

  @override
  String get whiteWinsGame => 'Ақ жеңді';

  @override
  String get blackWinsGame => 'Қара жеңді';

  @override
  String get learnFromYourMistakes => 'Өз қателеріңізден сабақ алыңыз';

  @override
  String get learnFromThisMistake => 'Осы қатеден сабақ алыңыз';

  @override
  String get skipThisMove => 'Осы жүрісті елемеу';

  @override
  String get next => 'Келесі';

  @override
  String xWasPlayed(String param) {
    return '$param ойналды';
  }

  @override
  String get findBetterMoveForWhite => 'Ақ пайдасына ең тиімді жүрісті табыңыз';

  @override
  String get findBetterMoveForBlack => 'Қара пайдасына ең тиімді жүрісті табыңыз';

  @override
  String get resumeLearning => 'Үйренуді қорытындылау';

  @override
  String get youCanDoBetter => 'Тағы талпынып көріңіз';

  @override
  String get tryAnotherMoveForWhite => 'Ақтар пайдасына басқаша жүріп көріңіз';

  @override
  String get tryAnotherMoveForBlack => 'Қаралар пайдасына басқаша жүріп көріңіз';

  @override
  String get solution => 'Шешімі';

  @override
  String get waitingForAnalysis => 'Талдауды күту';

  @override
  String get noMistakesFoundForWhite => 'Ақтар жағының қатесі табылмады';

  @override
  String get noMistakesFoundForBlack => 'Қаралар жағының қатесі табылмады';

  @override
  String get doneReviewingWhiteMistakes => 'Ақтардың қателері қаралды';

  @override
  String get doneReviewingBlackMistakes => 'Қаралардың қателері қаралды';

  @override
  String get doItAgain => 'Қайта жасау';

  @override
  String get reviewWhiteMistakes => 'Ақтардың қателерін қарау';

  @override
  String get reviewBlackMistakes => 'Қаралардың қателерін қарау';

  @override
  String get advantage => 'Басымдылық';

  @override
  String get opening => 'Бастау';

  @override
  String get middlegame => 'Ойын ортасы';

  @override
  String get endgame => 'Ойынсоңы';

  @override
  String get conditionalPremoves => 'Шартты ертелі жүріс';

  @override
  String get addCurrentVariation => 'Қазіргі тармақты қосу';

  @override
  String get playVariationToCreateConditionalPremoves => 'Шартты ертелі жүрістерді құру үшін бір тармақты ойнаңыз';

  @override
  String get noConditionalPremoves => 'Шартты ертелі жүрістер жоқ';

  @override
  String playX(String param) {
    return '$param жүріңіз';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Өкінішті-ақ :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Сізді уақытша шектеуге мәжбүрміз.';

  @override
  String get why => 'Себебі қандай?';

  @override
  String get pleasantChessExperience => 'Біз әрбіреудің ойны жайлы өтуін мақсат етеміз.';

  @override
  String get goodPractice => 'Сол үшін барлық ойыншылардың тәртібін қадағалауға тура келеді.';

  @override
  String get potentialProblem => 'Күдікті жағдай анықталса, осы хабарлама шығады.';

  @override
  String get howToAvoidThis => 'Осындайдан қалай аулақ боламыз?';

  @override
  String get playEveryGame => 'Әр ойынды аяғына дейін ойнаңыз.';

  @override
  String get tryToWin => 'Жеңіске (кемі тепе-теңдікке) жетуге ұмтылыңыз.';

  @override
  String get resignLostGames => 'Ойын нашар жүріп жатса, беріліңіз (уақыттың аяқталуын күтпеңіз).';

  @override
  String get temporaryInconvenience => 'Осы уақытша жайсыздық үшін біз өкінішімізді білдіріп,';

  @override
  String get wishYouGreatGames => 'Личес-та әдемі ойындар болсын деп тілейміз.';

  @override
  String get thankYouForReading => 'Оқығаныңыз үшін рахмет!';

  @override
  String get lifetimeScore => 'Жалпы ұпайлар';

  @override
  String get currentMatchScore => 'Осы жарыстағы нәтижеңіз';

  @override
  String get agreementAssistance => 'Мен ойнап отырғанда, сырттан (басқа адамнан, компьютер, кітап не дерекқорды пайдалана) ешбір көмек алмаймын деп уәде беремін.';

  @override
  String get agreementNice => 'Мен басқа ойыншыларға құрметпен қараймын деп уәде беремін.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Бірден артық тіркелгі жасамауға уәде етемін ($param-нда көрсетілген).';
  }

  @override
  String get agreementPolicy => 'Мен Личестің барлық қағидаларын ұстанамын деп уәде беремін.';

  @override
  String get searchOrStartNewDiscussion => 'Жаңа әңгімелесуді бастау не іздеу';

  @override
  String get edit => 'Өзгерту';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Блиц';

  @override
  String get rapid => 'Рапид';

  @override
  String get classical => 'Классикалық';

  @override
  String get ultraBulletDesc => 'Лезде ойындар: 30 секундтан кем';

  @override
  String get bulletDesc => 'Аса жылдам ойындар: 3 минуттан аз';

  @override
  String get blitzDesc => 'Жылдам ойындар: 3-тен 8 минутке дейін';

  @override
  String get rapidDesc => 'Рапид ойындары: 8-ден 25 минутке дейін';

  @override
  String get classicalDesc => 'Классикалық ойындар: 25 минут әрі одан көп';

  @override
  String get correspondenceDesc => 'Хат-хабарлы ойындар: әр жүріске бір не бірнеше күн';

  @override
  String get puzzleDesc => 'Шахмат тактикасын үйретуші';

  @override
  String get important => 'Ескерту';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Сіздің сұрағыңызға $param1 жауап табылар';
  }

  @override
  String get inTheFAQ => 'Жұрттан-сұрақта';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Дөрекі қылық не алдап ойнау туралы шағымдану үшін $param1';
  }

  @override
  String get useTheReportForm => 'шағым үлгісін қолданыңыз';

  @override
  String toRequestSupport(String param1) {
    return 'Жәрдем іздесеңіз $param1';
  }

  @override
  String get tryTheContactPage => 'байланыс туралы бетке өтіңіз';

  @override
  String makeSureToRead(String param1) {
    return '$param1пен танысып алыңыз';
  }

  @override
  String get theForumEtiquette => 'форумдағы әдеп';

  @override
  String get thisTopicIsArchived => 'Бұл тақырып мұрағатталды, енді жауап жазуға болмайды.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Осы форумда хабар қалдыру үшін $param1 тобына қосылыңыз';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 тобы';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Сіз форумда әлі хабар қалдыра алмайсыз. Ойнаңыз!';

  @override
  String get subscribe => 'Жазылу';

  @override
  String get unsubscribe => 'Жазылымды тоқтату';

  @override
  String mentionedYouInX(String param1) {
    return '$param1 біреу сіз туралы жазды.';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 сіз туралы $param2 жазды.';
  }

  @override
  String invitedYouToX(String param1) {
    return 'сізді $param1 шақырды.';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 сізді $param2 шақырды.';
  }

  @override
  String get youAreNowPartOfTeam => 'Сізді енді топ құрамындасыз.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Сіз $param1 қосылдыңыз.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Сіз шағым жіберегенсіз, ол ойыншы шектелді';

  @override
  String get congratsYouWon => 'Құтты болсын, сіз жеңдіңіз!';

  @override
  String gameVsX(String param1) {
    return '$param1 қарсы ойын';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 қарсы $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Сіз Личестің Ережесін бұзған біреуге жеңілдіңіз';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Қайтару: $param1 $param2 рейтинг ұпайы.';
  }

  @override
  String get timeAlmostUp => 'Уақыт таусылғалы тұр!';

  @override
  String get clickToRevealEmailAddress => '[поштаны көрсету үшін шертіңіз]';

  @override
  String get download => 'Жүктеп алу';

  @override
  String get coachManager => 'Бапкер басқармасы';

  @override
  String get streamerManager => 'Стример басқармасы';

  @override
  String get cancelTournament => 'Жарысты болдырмау';

  @override
  String get tournDescription => 'Жарыс сипаттамасы';

  @override
  String get tournDescriptionHelp => 'Қатысушыларға арнайы сөзіңіз болса, жазыңыз. Қысқа болған жақсы. Сілтемелерді markdown күйінде қосуыңызға болады: [name](https://url)';

  @override
  String get ratedFormHelp => 'Ойындар бағалы\nяғни ойыншылардың рейтингіне әсер етеді';

  @override
  String get onlyMembersOfTeam => 'Тек топ мүшелері';

  @override
  String get noRestriction => 'Шектеусіз';

  @override
  String get minimumRatedGames => 'Бағалы ойындар кемінде';

  @override
  String get minimumRating => 'Рейтинг кемінде';

  @override
  String get maximumWeeklyRating => 'Апталық рейтингтің ең көбі';

  @override
  String positionInputHelp(String param) {
    return 'Әр ойынды нақты бір күйден бастау үшін FEN еңгізіңіз.\nБұл тек классикалық ойындарда ғана жұмыс істейді, басқа шахмат түрлерінде емес.\nКүйдің FEN-ін құру үшін $param қолданыңыз, кейін осында еңгізіңіз.\nОйынды кәдімгі бастапқы күйден бастау үшін бос қалдыра салыңыз.';
  }

  @override
  String get cancelSimul => 'Қалың ойынды болдырмау';

  @override
  String get simulHostcolor => 'Бас ойыншының әр ойындағы тас түсі';

  @override
  String get estimatedStart => 'Басталудың болжаулы уақыты';

  @override
  String simulFeatured(String param) {
    return '$param осында көрсету';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Қалың ойынды $param-те баршаға көрсету. Оңаша ойындарда өшірулі.';
  }

  @override
  String get simulDescription => 'Қалың ойын сипаттамасы';

  @override
  String get simulDescriptionHelp => 'Қатысушыларға тағы айтар сөзіңіз бар ма?';

  @override
  String markdownAvailable(String param) {
    return 'Кеңейтілген синтаксис үшін $param.';
  }

  @override
  String get embedsAvailable => 'Еңгізу үшін ойынның не зерттеу бөлімінің URL-ын қойыңыз.';

  @override
  String get inYourLocalTimezone => 'Жергілікті уақыт белдеуіңізде';

  @override
  String get tournChat => 'Жарыстың сұхбат бөлмесі';

  @override
  String get noChat => 'Сұхбатты өшіру';

  @override
  String get onlyTeamLeaders => 'Тек топ жетекшілері';

  @override
  String get onlyTeamMembers => 'Тек топ мүшелері';

  @override
  String get navigateMoveTree => 'Жүрістер тізімін шолу';

  @override
  String get mouseTricks => 'Тіңтуір әдістері';

  @override
  String get toggleLocalAnalysis => 'Өз компьютеріңізде талдауды қосу';

  @override
  String get toggleAllAnalysis => 'Барлық компьютер талдауларын қосу';

  @override
  String get playComputerMove => 'Компьютердің үздік жүрісін қолдану';

  @override
  String get analysisOptions => 'Талдау баптаулары';

  @override
  String get focusChat => 'Нысаналы сұхбат';

  @override
  String get showHelpDialog => 'Осы көмекші терезені көрсету';

  @override
  String get reopenYourAccount => 'Тіркелгіні қайта ашу';

  @override
  String get closedAccountChangedMind => 'Егер сіз тіркелгіні жапқан соң, ойыңыздан қайтсаңыз, сізде тіркелгіні қайтаруға бір мүмкіндік бар.';

  @override
  String get onlyWorksOnce => 'Бұл амал бір рет қана жарамды.';

  @override
  String get cantDoThisTwice => 'Егер тіркелгіңізді екінші рет жапсаңыз, оны қайтару еш мүмкіндік болмайды.';

  @override
  String get emailAssociatedToaccount => 'Тіркелгіге байлаулы поштаңыз';

  @override
  String get sentEmailWithLink => 'Біз сілтемесі бар хат жібереміз.';

  @override
  String get tournamentEntryCode => 'Жарысқа кіру құпиясөзі';

  @override
  String get hangOn => 'Тоқтаңыз!';

  @override
  String gameInProgress(String param) {
    return '$param сізді қазір ойында күтіп тұр.';
  }

  @override
  String get abortTheGame => 'Ойынды үзу';

  @override
  String get resignTheGame => 'Берілу';

  @override
  String get youCantStartNewGame => 'Бұл ойын аяқталмағанша, сіз жаңа ойын бастай алмайсыз.';

  @override
  String get since => 'Бастап';

  @override
  String get until => 'Дейін';

  @override
  String get lichessDbExplanation => 'Личес-тегі бағалы ойындар';

  @override
  String get switchSides => 'Түсті ауыстыру';

  @override
  String get closingAccountWithdrawAppeal => 'Тіркелгі жабылса, қарсы шағымдарыңыз жойылады';

  @override
  String get ourEventTips => 'Шара ұйымдастыру туралы ақыл-кеңес';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Личес – толығымен тегін/еркін, қайырымдылық негізінде жасалған програм.\nБүкіл жұмыс шығыны, әзірлеу, мазмұны пайдаланушылардың ақшалай демеуінен өтеледі.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Қарсылас ойыннан шықты. Сіз $count секундтан кейін жеңісті талап ете аласыз.',
      one: 'Қарсылас ойыннан шықты. Сіз $count секундтан кейін жеңісті талап ете аласыз.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count жартыжүрісті мат',
      one: '$count жартыжүрісті мат',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count өрескел қателік',
      one: '$count өрескел қателік',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count қателік',
      one: '$count қателік',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ағаттық',
      one: '$count ағаттық',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ойыншы',
      one: '$count ойыншы',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ойын',
      one: '$count ойын',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 $count ойындардың қорытындысы',
      one: '$param2 $count ойынның қорытындысы',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count бетбелгі',
      one: '$count бетбелгі',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count күн',
      one: '$count күн',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сағат',
      one: '$count сағат',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минут',
      one: '$count минут',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Орын әр $count минут сайын жаңартылады',
      one: 'Орын әр минут сайын жаңартылады',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count жұмбақ',
      one: '$count жұмбақ',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сізбен $count ойын',
      one: 'Сізбен $count ойын',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count бағалы',
      one: '$count бағалы',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count жеңіс',
      one: '$count жеңіс',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count жеңіліс',
      one: '$count жеңіліс',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тепе-тең',
      one: '$count тепе-тең',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ойналуда',
      one: '$count ойналуда',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунд беру',
      one: '$count секунд беру',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count жарыс ұпайы',
      one: '$count жарыс ұпайы',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зерттеу',
      one: '$count зерттеу',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count қалың ойын',
      one: '$count қалың ойын',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count бағалы ойын',
      one: '≥ $count бағалы ойын',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count бағалы $param2 ойын',
      one: '≥ $count бағалы $param2 ойын',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сіз тағы $count бағалы $param2 ойнауыңыз керек',
      one: 'Сіз тағы $count бағалы $param2 ойнауыңыз керек',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сіз тағы $count бағалы ойын ойнауыңыз керек',
      one: 'Сіз тағы $count бағалы ойын ойнауыңыз керек',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ойын салынды',
      one: '$count ойын салынды',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дос желіде',
      one: '$count дос желіде',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count серігі бар',
      one: '$count серігі бар',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ойыншыға серік',
      one: '$count ойыншыға серік',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минутқа дейін',
      one: '$count минутқа дейін',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ойын өтуде',
      one: '$count ойын өтуде',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ең көбі: $count таңба.',
      one: 'Ең көбі: $count таңба.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count бұғатталды',
      one: '$count бұғатталды',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count форумдағы жазба',
      one: '$count форумдағы жазба',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осы аптада $count $param2-ойыншы.',
      one: 'Осы аптада $count $param2-ойыншы.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тіліндегі нұсқасы бар!',
      one: '$count тіліндегі нұсқасы бар!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Бірінші жүріске $count секунд бар',
      one: 'Бірінші жүріске $count секунд бар',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунд',
      one: '$count секунд',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'әрі ертелі жүрістердің $count жолын сақтау',
      one: 'әрі ертелі жүрістердің $count жолын сақтау',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Бастау үшін жүріңіз';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Барлық жұмбақтарда сіз ақ түспен ойнайсыз';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Барлық жұмбақтарда сіз қара түспен ойнайсыз';

  @override
  String get stormPuzzlesSolved => 'жұмбақ шешілді';

  @override
  String get stormNewDailyHighscore => 'Жаңа күндік рекорд!';

  @override
  String get stormNewWeeklyHighscore => 'Жаңа апталық рекорд!';

  @override
  String get stormNewMonthlyHighscore => 'Жаңа айлық рекорд!';

  @override
  String get stormNewAllTimeHighscore => 'Жаңа рекорд!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Алдыңғы рекорд $param';
  }

  @override
  String get stormPlayAgain => 'Қайтадан ойнау';

  @override
  String stormHighscoreX(String param) {
    return 'Рекорд: $param';
  }

  @override
  String get stormScore => 'Ұпай';

  @override
  String get stormMoves => 'Жүрістер';

  @override
  String get stormAccuracy => 'Дәлдік';

  @override
  String get stormCombo => 'Комбо';

  @override
  String get stormTime => 'Уақыт';

  @override
  String get stormTimePerMove => 'Бір жүріс уақыты';

  @override
  String get stormHighestSolved => 'Шешілген ең жоғарғы рейтинг';

  @override
  String get stormPuzzlesPlayed => 'Ойналған жұмбақтар';

  @override
  String get stormNewRun => 'Жаңа кезең (жылдам перне: бос орын)';

  @override
  String get stormEndRun => 'Кезеңді аяқтау (жылдам перне: Enter)';

  @override
  String get stormHighscores => 'Рекордтар';

  @override
  String get stormViewBestRuns => 'Үздік кезеңдерді көру';

  @override
  String get stormBestRunOfDay => 'Бір күннің үздік кезеңі';

  @override
  String get stormRuns => 'Кезеңдер';

  @override
  String get stormGetReady => 'Дайынсыз ба!';

  @override
  String get stormWaitingForMorePlayers => 'Көбірек ойыншылардың қосылуын күтеміз...';

  @override
  String get stormRaceComplete => 'Бәйге аяқталды!';

  @override
  String get stormSpectating => 'Көріп отырғандар';

  @override
  String get stormJoinTheRace => 'Бәйгеге қосылу!';

  @override
  String get stormStartTheRace => 'Бәйге бастау';

  @override
  String stormYourRankX(String param) {
    return 'Сіздің орныңыз: $param';
  }

  @override
  String get stormWaitForRematch => 'Қайта ойнауды күту';

  @override
  String get stormNextRace => 'Келесі бәйге';

  @override
  String get stormJoinRematch => 'Қайта ойнаға қосылу';

  @override
  String get stormWaitingToStart => 'Басталуын күтеміз';

  @override
  String get stormCreateNewGame => 'Жаңа ойын құру';

  @override
  String get stormJoinPublicRace => 'Жалпыға ашық бәйгеге қосылу';

  @override
  String get stormRaceYourFriends => 'Достармен бәйгеге түсу';

  @override
  String get stormSkip => 'бас тарту';

  @override
  String get stormSkipHelp => 'Сіз әр бәйгеде бір жүрістен ғана бас тарта аласыз:';

  @override
  String get stormSkipExplanation => 'Өз тізбегіңізді сақтау үшін осы жүрістен бас тарту! Әр бәйгеде бір рет.';

  @override
  String get stormFailedPuzzles => 'Шешілмеген жұмбақтар';

  @override
  String get stormSlowPuzzles => 'Баяу жұмбақтар';

  @override
  String get stormSkippedPuzzle => 'Қараусыз жұмбақ';

  @override
  String get stormThisWeek => 'Осы апта';

  @override
  String get stormThisMonth => 'Осы ай';

  @override
  String get stormAllTime => 'Жалпы';

  @override
  String get stormClickToReload => 'Қайта бастау';

  @override
  String get stormThisRunHasExpired => 'Бұл бәйгенің мерзімі бітті!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Бұл бәйге басқа бетте ашылған!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count кезең',
      one: '1 кезең',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 кезеңнің $count ойналды',
      one: '$param2 кезеңнің бірі ойналды',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Личес стримерлері';

  @override
  String get studyShareAndExport => 'Бөлісу мен Жүктеп алу';

  @override
  String get studyStart => 'Бастау';
}
