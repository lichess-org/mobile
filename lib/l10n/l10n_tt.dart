import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Tatar (`tt`).
class AppLocalizationsTt extends AppLocalizations {
  AppLocalizationsTt([String locale = 'tt']) : super(locale);

  @override
  String get activityActivity => 'Эшчәнлек';

  @override
  String get activityHostedALiveStream => 'Стрим хуҗасы';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Ранкы #$param1 $param2 өчендә';
  }

  @override
  String get activitySignedUp => 'Lichess.org ка кергән';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'lichess.org сайтына $count айга $param2 буларак ярдәм күрсәтте',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2-да $count күнегү ясады',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тактикалык мәсәлә чиште',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 уенын уйнады',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хәбәрләрне нәшер итте$param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хәрәкәт уйнады',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хат язышу уенында',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Тәмамлады $count хат язышу уеннарын',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count уйнаучы артыннан кушылды',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count яңа артыннан баручылар белән казанган',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Алып барган бер үк вакыттагы күргәзмәләрне',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Иштирак ителгән $count бер үк ватыттагы күргәзмәләр',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Яңа $count өйрәнеш оештырды',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Тәмам колынды $count Мәйдан бәйгеләре',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ранкы #$count (югары$param2%) $param3 уен белән $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Тәмам колындылар $count швецар бәйгесе',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count җәмәга кушылды',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Ишеттәрешләр';

  @override
  String get broadcastStartDate => 'Башлагыз сәнә сезнең үзегезнең вакыт җирендән';

  @override
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Сынаулар уенда';

  @override
  String get challengeChallengeDeclined => 'Сынаулар кире кагылды';

  @override
  String get challengeChallengeAccepted => 'Сынаулар алынды!';

  @override
  String get challengeChallengeCanceled => 'Сынауны кире кактылар.';

  @override
  String get challengeRegisterToSendChallenges => 'Зинһар теркәл сынаулар җибәрер өчен.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Сез сыный алмыйсыз $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param сезнең сынауны кире какты.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Сезнең $param1 рейтингыгыз $param2 дан оглы ара.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Сынау вакытлы $param рейтингыгыз аркасында кыенлыклар тудыра алмый.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param ала сынаулар дустлардан гына.';
  }

  @override
  String get challengeDeclineGeneric => 'Мин алмыйм сынауларны бу вакытта.';

  @override
  String get challengeDeclineLater => 'Бу минем өчен дөрес вакыт түгел, зинһар, соңрак кабат сорагыз.';

  @override
  String get challengeDeclineTooFast => 'Бу вакыт тикшерүе бик тиз минем өчен, зинһар сынагыз яңадан озаграк уен белән.';

  @override
  String get challengeDeclineTooSlow => 'Бу вакыт тикшерүе бик озак минем өчен, зинһар сынагыз яңадан тиз уен белән.';

  @override
  String get challengeDeclineTimeControl => 'Мин алмыйм сынауларны вакыт тикшерүе белән.';

  @override
  String get challengeDeclineRated => 'Зинһар җибәрегез миңа рейтинглы сынау урнына.';

  @override
  String get challengeDeclineCasual => 'Зинһар җибәрегез миңа бәяләүсез сынау урнына.';

  @override
  String get challengeDeclineStandard => 'Мин алмыйм вариантлы сынаулар хәзер.';

  @override
  String get challengeDeclineVariant => 'Мин тәләп куймыйм уйнарга бу вариантка хәзер.';

  @override
  String get challengeDeclineNoBot => 'Мин алмыйм сынаулар боттан.';

  @override
  String get challengeDeclineOnlyBot => 'Мин алам сынаулар боттан гына.';

  @override
  String get challengeInviteLichessUser => 'Or invite a Lichess user:';

  @override
  String get contactContact => 'Контакт';

  @override
  String get contactContactLichess => 'Элемтә Lichess';

  @override
  String get patronDonate => 'Хәйрия колмак';

  @override
  String get patronLichessPatron => 'Lichess иганәче';

  @override
  String perfStatPerfStats(String param) {
    return '$param статистикасы';
  }

  @override
  String get perfStatViewTheGames => 'Карарга уеннарны';

  @override
  String get perfStatProvisional => 'вакытлыча';

  @override
  String get perfStatNotEnoughRatedGames => 'Ышанычлы рейтинг булдыру өчен җитәрлек бәяләнгән уеннар уйнамады.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Соңгы $param уеннарында алга китеш:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Рейтингның тайпылышы:$param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Lower value means the rating is more stable. Above $param1, the rating is considered provisional. To be included in the rankings, this value should be below $param2 (standard chess) or $param3 (variants).';
  }

  @override
  String get perfStatTotalGames => 'Бөтен уеннар';

  @override
  String get perfStatRatedGames => 'Рейтинглы уеннар';

  @override
  String get perfStatTournamentGames => 'Бәйге уеннары';

  @override
  String get perfStatBerserkedGames => 'Яман уеннар';

  @override
  String get perfStatTimeSpentPlaying => 'Уенда уздырылган вакыт';

  @override
  String get perfStatAverageOpponent => 'Уртача ярышучы';

  @override
  String get perfStatVictories => 'Җиңүләр';

  @override
  String get perfStatDefeats => 'Җиңелүләр';

  @override
  String get perfStatDisconnections => 'Өзелгән';

  @override
  String get perfStatNotEnoughGames => 'Җитми уйналган уеннар';

  @override
  String perfStatHighestRating(String param) {
    return 'Иң югары рейтинг $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Иң кече рейтинг $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1 дан $param2 га';
  }

  @override
  String get perfStatWinningStreak => 'Бер-артлы җиңүләр';

  @override
  String get perfStatLosingStreak => 'Бер-артлы җиңүлеләр';

  @override
  String perfStatLongestStreak(String param) {
    return 'Иң озын бер-артлы: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Хәзерге бер-артлы: $param';
  }

  @override
  String get perfStatBestRated => 'Иң яхшы рейтинглы җиңүләр';

  @override
  String get perfStatGamesInARow => 'Уеннар рәттән уйналды';

  @override
  String get perfStatLessThanOneHour => 'Уеннар арасында бер сәгатьтән дә азрак';

  @override
  String get perfStatMaxTimePlaying => 'Бер-артлы уйнаган максималь вакыт';

  @override
  String get perfStatNow => 'хәзер';

  @override
  String get preferencesPreferences => 'Көйләүләр';

  @override
  String get preferencesDisplay => 'Display';

  @override
  String get preferencesPrivacy => 'Хосусыйлык';

  @override
  String get preferencesNotifications => 'Notifications';

  @override
  String get preferencesPieceAnimation => 'Piece animation';

  @override
  String get preferencesMaterialDifference => 'Material difference';

  @override
  String get preferencesBoardHighlights => 'Board highlights (last move and check)';

  @override
  String get preferencesPieceDestinations => 'Piece destinations (valid moves and premoves)';

  @override
  String get preferencesBoardCoordinates => 'Board coordinates (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Move list while playing';

  @override
  String get preferencesPgnPieceNotation => 'Move notation';

  @override
  String get preferencesChessPieceSymbol => 'Chess piece symbol';

  @override
  String get preferencesPgnLetter => 'Хәреф (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Зен режимы';

  @override
  String get preferencesShowPlayerRatings => 'Show player ratings';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'This hides all ratings from Lichess, to help focus on the chess. Rated games still impact your rating, this is only about what you get to see.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Show board resize handle';

  @override
  String get preferencesOnlyOnInitialPosition => 'Only on initial position';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Chess clock';

  @override
  String get preferencesTenthsOfSeconds => 'Tenths of seconds';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'When time remaining < 10 seconds';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horizontal green progress bars';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Sound when time gets critical';

  @override
  String get preferencesGiveMoreTime => 'Give more time';

  @override
  String get preferencesGameBehavior => 'Game behaviour';

  @override
  String get preferencesHowDoYouMovePieces => 'How do you move pieces?';

  @override
  String get preferencesClickTwoSquares => 'Click two squares';

  @override
  String get preferencesDragPiece => 'Drag a piece';

  @override
  String get preferencesBothClicksAndDrag => 'Either';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Premoves (playing during opponent turn)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Takebacks (with opponent approval)';

  @override
  String get preferencesInCasualGamesOnly => 'In casual games only';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promote to Queen automatically';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'When premoving';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Claim draw on threefold repetition automatically';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'When time remaining < 30 seconds';

  @override
  String get preferencesMoveConfirmation => 'Move confirmation';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Correspondence games';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Correspondence and unlimited';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Confirm resignation and draw offers';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Castling method';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Move king two squares';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Move king onto rook';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Input moves with the keyboard';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Snap arrows to valid moves';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Say \"Good game, well played\" upon defeat or draw';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Your preferences have been saved.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Scroll on the board to replay moves';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Daily email listing your correspondence games';

  @override
  String get preferencesNotifyStreamStart => 'Streamer goes live';

  @override
  String get preferencesNotifyInboxMsg => 'New inbox message';

  @override
  String get preferencesNotifyForumMention => 'Forum comment mentions you';

  @override
  String get preferencesNotifyInvitedStudy => 'Study invite';

  @override
  String get preferencesNotifyGameEvent => 'Correspondence game updates';

  @override
  String get preferencesNotifyChallenge => 'Challenges';

  @override
  String get preferencesNotifyTournamentSoon => 'Tournament starting soon';

  @override
  String get preferencesNotifyTimeAlarm => 'Correspondence clock running out';

  @override
  String get preferencesNotifyBell => 'Bell notification within Lichess';

  @override
  String get preferencesNotifyPush => 'Device notification when you\'re not on Lichess';

  @override
  String get preferencesNotifyWeb => 'Браузер';

  @override
  String get preferencesNotifyDevice => 'Җиһаз';

  @override
  String get preferencesBellNotificationSound => 'Bell notification sound';

  @override
  String get puzzlePuzzles => 'Башваткычлар';

  @override
  String get puzzlePuzzleThemes => 'Башваткыч бизәкләре';

  @override
  String get puzzleRecommended => 'Тәкдим ителә';

  @override
  String get puzzlePhases => 'Фазалар';

  @override
  String get puzzleMotifs => 'Зәхәриф';

  @override
  String get puzzleAdvanced => 'Өстәмә';

  @override
  String get puzzleLengths => 'Озынлык';

  @override
  String get puzzleMates => 'Матлар';

  @override
  String get puzzleGoals => 'Морады';

  @override
  String get puzzleOrigin => 'Чыгыш';

  @override
  String get puzzleSpecialMoves => 'Максус хәрәкәтләр';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Сезгә ошадымы башваткыч?';

  @override
  String get puzzleVoteToLoadNextOne => 'Киләсе йөкләү өчен тавыш бирегез!';

  @override
  String get puzzleUpVote => 'Up vote puzzle';

  @override
  String get puzzleDownVote => 'Down vote puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Your puzzle rating will not change. Note that puzzles are not a competition. Your rating helps selecting the best puzzles for your current skill.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Тап якшы хәрәкәт аклар өчен.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Тап якшы хәрәкәт каралар өчен.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Персональләштерелгән башваткычлар алу өчен:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Башваткыч $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Бүгенге башваткыч';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Чишер өчен сук';

  @override
  String get puzzleGoodMove => 'Якшы хәрәкәт';

  @override
  String get puzzleBestMove => 'Иң яхшы хәрәкәт!';

  @override
  String get puzzleKeepGoing => 'Юлга дәвам…';

  @override
  String get puzzlePuzzleSuccess => 'Уңышлы!';

  @override
  String get puzzlePuzzleComplete => 'Башваткыч чишелгән!';

  @override
  String get puzzleByOpenings => 'By openings';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzzles by openings';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Openings you played the most in rated games';

  @override
  String get puzzleUseFindInPage => 'Use \"Find in page\" in the browser menu to find your favourite opening!';

  @override
  String get puzzleUseCtrlF => 'Use Ctrl+f to find your favourite opening!';

  @override
  String get puzzleNotTheMove => 'Бу хәрәкәт түгел!';

  @override
  String get puzzleTrySomethingElse => 'Башка нәрсәне сынап карагыз.';

  @override
  String puzzleRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get puzzleHidden => 'качырылган';

  @override
  String puzzleFromGameLink(String param) {
    return '$param уендан';
  }

  @override
  String get puzzleContinueTraining => 'Күнегүләр дәвамы';

  @override
  String get puzzleDifficultyLevel => 'Авырлык дәрәҗәсе';

  @override
  String get puzzleNormal => 'Нормаль';

  @override
  String get puzzleEasier => 'Җиңелрәк';

  @override
  String get puzzleEasiest => 'Иң җиңелрәге';

  @override
  String get puzzleHarder => 'Авыррак';

  @override
  String get puzzleHardest => 'Иң авыры';

  @override
  String get puzzleExample => 'Мәсәлән';

  @override
  String get puzzleAddAnotherTheme => 'Икенче тһеманы өстәргә';

  @override
  String get puzzleNextPuzzle => 'Next puzzle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Киләсе Башваткычка шунда ук сикерегез';

  @override
  String get puzzlePuzzleDashboard => 'Башваткыч Гөстертактасы';

  @override
  String get puzzleImprovementAreas => 'Яхшырту өлкәләре';

  @override
  String get puzzleStrengths => 'Көчләр яклары';

  @override
  String get puzzleHistory => 'Башваткыч тарихы';

  @override
  String get puzzleSolved => 'чишелгән';

  @override
  String get puzzleFailed => 'уңышсыз';

  @override
  String get puzzleStreakDescription => 'Акрынлап катлаулы башваткычларны чишегез һәм җиңү сызыгы төзегез. Сәгать юк, шуңа күрә вакытыгызны алыгыз. Бер ялгыш хәрәкәт, һәм бу уен бетте! Ләкин сез сессиягә бер хәрәкәтне калдыра аласыз.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Сезнең юл $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Сезнең юлны саклап калу өчен бу хәрәкәтне ташлагыз! Бер тапкыр гына эшли.';

  @override
  String get puzzleContinueTheStreak => 'Сызуны дәвам итегез';

  @override
  String get puzzleNewStreak => 'Яңа сызу';

  @override
  String get puzzleFromMyGames => 'From my games';

  @override
  String get puzzleLookupOfPlayer => 'Lookup puzzles from a player\'s games';

  @override
  String puzzleFromXGames(String param) {
    return 'Puzzles from $param\' games';
  }

  @override
  String get puzzleSearchPuzzles => 'Search puzzles';

  @override
  String get puzzleFromMyGamesNone => 'You have no puzzles in the database, but Lichess still loves you very much.\n\nPlay rapid and classical games to increase your chances of having a puzzle of yours added!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 puzzles found in $param2 games';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Train, analyse, improve';

  @override
  String puzzlePercentSolved(String param) {
    return '$param solved';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nothing to show, go play some puzzles first!';

  @override
  String get puzzleImprovementAreasDescription => 'Train these to optimize your progress!';

  @override
  String get puzzleStrengthDescription => 'You perform the best in these themes';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Уйналган $count вакыт',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сезнең башваткыч рейтингтан бер максад',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Сезнең башваткыч рейтингтан бер максад',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count played',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count to replay',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Алга киткән җирле';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Сезнең җәяүлеләрнең берсе көндәш позициясенә тирән керә, бәлки алга җибәрү белән куркытыр.';

  @override
  String get puzzleThemeAdvantage => 'Өстенлек';

  @override
  String get puzzleThemeAdvantageDescription => 'Хәлиткеч өстенлек алу мөмкинлеген кулланыгыз. (200cp ≤ бәяләү ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Әнәстәсия маты';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Атчы, Тура яки Вәзир командасы каршы шаһны такта ягы белән дуслар арасына тозакка эләктерәләр.';

  @override
  String get puzzleThemeArabianMate => 'Гарәп маты';

  @override
  String get puzzleThemeArabianMateDescription => 'A knight and a rook team up to trap the opposing king on a corner of the board.';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2 яки f7-не һөҗүм итү';

  @override
  String get puzzleThemeAttackingF2F7Description => 'An attack focusing on the f2 or f7 pawn, such as in the fried liver opening.';

  @override
  String get puzzleThemeAttraction => 'Attraction';

  @override
  String get puzzleThemeAttractionDescription => 'An exchange or sacrifice encouraging or forcing an opponent piece to a square that allows a follow-up tactic.';

  @override
  String get puzzleThemeBackRankMate => 'Back rank mate';

  @override
  String get puzzleThemeBackRankMateDescription => 'Checkmate the king on the home rank, when it is trapped there by its own pieces.';

  @override
  String get puzzleThemeBishopEndgame => 'Bishop endgame';

  @override
  String get puzzleThemeBishopEndgameDescription => 'An endgame with only bishops and pawns.';

  @override
  String get puzzleThemeBodenMate => 'Боден маты';

  @override
  String get puzzleThemeBodenMateDescription => 'Ике һөҗүм итүче киселешәләр диагональ буенча һәм рәкыйпнең үз дуст сөякләре кома шаулаган шаһына мат куялар.';

  @override
  String get puzzleThemeCastling => 'Castling';

  @override
  String get puzzleThemeCastlingDescription => 'Bring the king to safety, and deploy the rook for attack.';

  @override
  String get puzzleThemeCapturingDefender => 'Capture the defender';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Removing a piece that is critical to defence of another piece, allowing the now undefended piece to be captured on a following move.';

  @override
  String get puzzleThemeCrushing => 'Изеш';

  @override
  String get puzzleThemeCrushingDescription => 'Spot the opponent blunder to obtain a crushing advantage. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Икеләтә филь маты';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Two attacking bishops on adjacent diagonals deliver mate to a king obstructed by friendly pieces.';

  @override
  String get puzzleThemeDovetailMate => 'Dovetail mate';

  @override
  String get puzzleThemeDovetailMateDescription => 'A queen delivers mate to an adjacent king, whose only two escape squares are obstructed by friendly pieces.';

  @override
  String get puzzleThemeEquality => 'Тигезлек';

  @override
  String get puzzleThemeEqualityDescription => 'Come back from a losing position, and secure a draw or a balanced position. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Шаһ яктагы һөҗүм';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Рәкыйп шаһы һөҗүме, алар шаһ ягына куйганнан соң.';

  @override
  String get puzzleThemeClearance => 'Чистарту';

  @override
  String get puzzleThemeClearanceDescription => 'Киләсе тактик идея өчен квадратны, файлны яки диагональне чистарта торган хәрәкәт.';

  @override
  String get puzzleThemeDefensiveMove => 'Калкала хәрәкәте';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Материалны яисә бүтән өстенлекне югалтмас өчен кирәк булган төгәл хәрәкәт яки хәрәкәт эзлеклелеге.';

  @override
  String get puzzleThemeDeflection => 'Deflection';

  @override
  String get puzzleThemeDeflectionDescription => 'A move that distracts an opponent piece from another duty that it performs, such as guarding a key square. Sometimes also called \"overloading\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Discovered attack';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Moving a piece (such as a knight), that previously blocked an attack by a long range piece (such as a rook), out of the way of that piece.';

  @override
  String get puzzleThemeDoubleCheck => 'Double check';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Checking with two pieces at once, as a result of a discovered attack where both the moving piece and the unveiled piece attack the opponent\'s king.';

  @override
  String get puzzleThemeEndgame => 'Уен азагы';

  @override
  String get puzzleThemeEndgameDescription => 'A tactic during the last phase of the game.';

  @override
  String get puzzleThemeEnPassantDescription => 'A tactic involving the en passant rule, where a pawn can capture an opponent pawn that has bypassed it using its initial two-square move.';

  @override
  String get puzzleThemeExposedKing => 'Exposed king';

  @override
  String get puzzleThemeExposedKingDescription => 'A tactic involving a king with few defenders around it, often leading to checkmate.';

  @override
  String get puzzleThemeFork => 'Сәнәк';

  @override
  String get puzzleThemeForkDescription => 'A move where the moved piece attacks two opponent pieces at once.';

  @override
  String get puzzleThemeHangingPiece => 'Hanging piece';

  @override
  String get puzzleThemeHangingPieceDescription => 'A tactic involving an opponent piece being undefended or insufficiently defended and free to capture.';

  @override
  String get puzzleThemeHookMate => 'Hook mate';

  @override
  String get puzzleThemeHookMateDescription => 'Checkmate with a rook, knight, and pawn along with one enemy pawn to limit the enemy king\'s escape.';

  @override
  String get puzzleThemeInterference => 'Interference';

  @override
  String get puzzleThemeInterferenceDescription => 'Moving a piece between two opponent pieces to leave one or both opponent pieces undefended, such as a knight on a defended square between two rooks.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Instead of playing the expected move, first interpose another move posing an immediate threat that the opponent must answer. Also known as \"Zwischenzug\" or \"In between\".';

  @override
  String get puzzleThemeKnightEndgame => 'Knight endgame';

  @override
  String get puzzleThemeKnightEndgameDescription => 'An endgame with only knights and pawns.';

  @override
  String get puzzleThemeLong => 'Long puzzle';

  @override
  String get puzzleThemeLongDescription => 'Three moves to win.';

  @override
  String get puzzleThemeMaster => 'Осталарның уеннары';

  @override
  String get puzzleThemeMasterDescription => 'Puzzles from games played by titled players.';

  @override
  String get puzzleThemeMasterVsMaster => 'Осталар арасындагы уеннар';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Puzzles from games between two titled players.';

  @override
  String get puzzleThemeMate => 'Мат';

  @override
  String get puzzleThemeMateDescription => 'Win the game with style.';

  @override
  String get puzzleThemeMateIn1 => 'Mate in 1';

  @override
  String get puzzleThemeMateIn1Description => 'Deliver checkmate in one move.';

  @override
  String get puzzleThemeMateIn2 => 'Mate in 2';

  @override
  String get puzzleThemeMateIn2Description => 'Deliver checkmate in two moves.';

  @override
  String get puzzleThemeMateIn3 => 'Mate in 3';

  @override
  String get puzzleThemeMateIn3Description => 'Deliver checkmate in three moves.';

  @override
  String get puzzleThemeMateIn4 => 'Mate in 4';

  @override
  String get puzzleThemeMateIn4Description => 'Deliver checkmate in four moves.';

  @override
  String get puzzleThemeMateIn5 => 'Mate in 5 or more';

  @override
  String get puzzleThemeMateIn5Description => 'Figure out a long mating sequence.';

  @override
  String get puzzleThemeMiddlegame => 'Уен уртасы';

  @override
  String get puzzleThemeMiddlegameDescription => 'A tactic during the second phase of the game.';

  @override
  String get puzzleThemeOneMove => 'One-move puzzle';

  @override
  String get puzzleThemeOneMoveDescription => 'A puzzle that is only one move long.';

  @override
  String get puzzleThemeOpening => 'Дебют';

  @override
  String get puzzleThemeOpeningDescription => 'A tactic during the first phase of the game.';

  @override
  String get puzzleThemePawnEndgame => 'Pawn endgame';

  @override
  String get puzzleThemePawnEndgameDescription => 'An endgame with only pawns.';

  @override
  String get puzzleThemePin => 'Беркетү';

  @override
  String get puzzleThemePinDescription => 'A tactic involving pins, where a piece is unable to move without revealing an attack on a higher value piece.';

  @override
  String get puzzleThemePromotion => 'Promotion';

  @override
  String get puzzleThemePromotionDescription => 'Promote one of your pawn to a queen or minor piece.';

  @override
  String get puzzleThemeQueenEndgame => 'Queen endgame';

  @override
  String get puzzleThemeQueenEndgameDescription => 'An endgame with only queens and pawns.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Queen and Rook';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'An endgame with only queens, rooks and pawns.';

  @override
  String get puzzleThemeQueensideAttack => 'Queenside attack';

  @override
  String get puzzleThemeQueensideAttackDescription => 'An attack of the opponent\'s king, after they castled on the queen side.';

  @override
  String get puzzleThemeQuietMove => 'Quiet move';

  @override
  String get puzzleThemeQuietMoveDescription => 'A move that does neither make a check or capture, nor an immediate threat to capture, but does prepare a more hidden unavoidable threat for a later move.';

  @override
  String get puzzleThemeRookEndgame => 'Rook endgame';

  @override
  String get puzzleThemeRookEndgameDescription => 'An endgame with only rooks and pawns.';

  @override
  String get puzzleThemeSacrifice => 'Sacrifice';

  @override
  String get puzzleThemeSacrificeDescription => 'A tactic involving giving up material in the short-term, to gain an advantage again after a forced sequence of moves.';

  @override
  String get puzzleThemeShort => 'Short puzzle';

  @override
  String get puzzleThemeShortDescription => 'Two moves to win.';

  @override
  String get puzzleThemeSkewer => 'Skewer';

  @override
  String get puzzleThemeSkewerDescription => 'A motif involving a high value piece being attacked, moving out the way, and allowing a lower value piece behind it to be captured or attacked, the inverse of a pin.';

  @override
  String get puzzleThemeSmotheredMate => 'Smothered mate';

  @override
  String get puzzleThemeSmotheredMateDescription => 'A checkmate delivered by a knight in which the mated king is unable to move because it is surrounded (or smothered) by its own pieces.';

  @override
  String get puzzleThemeSuperGM => 'Super GM games';

  @override
  String get puzzleThemeSuperGMDescription => 'Puzzles from games played by the best players in the world.';

  @override
  String get puzzleThemeTrappedPiece => 'Trapped piece';

  @override
  String get puzzleThemeTrappedPieceDescription => 'A piece is unable to escape capture as it has limited moves.';

  @override
  String get puzzleThemeUnderPromotion => 'Underpromotion';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promotion to a knight, bishop, or rook.';

  @override
  String get puzzleThemeVeryLong => 'Very long puzzle';

  @override
  String get puzzleThemeVeryLongDescription => 'Four moves or more to win.';

  @override
  String get puzzleThemeXRayAttack => 'X-Ray attack';

  @override
  String get puzzleThemeXRayAttackDescription => 'A piece attacks or defends a square, through an enemy piece.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'The opponent is limited in the moves they can make, and all moves worsen their position.';

  @override
  String get puzzleThemeHealthyMix => 'Healthy mix';

  @override
  String get puzzleThemeHealthyMixDescription => 'A bit of everything. You don\'t know what to expect, so you remain ready for anything! Just like in real games.';

  @override
  String get puzzleThemePlayerGames => 'Player games';

  @override
  String get puzzleThemePlayerGamesDescription => 'Lookup puzzles generated from your games, or from another player\'s games.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'These puzzles are in the public domain, and can be downloaded from $param.';
  }

  @override
  String get searchSearch => 'Табу';

  @override
  String get settingsSettings => 'Көйләүләр';

  @override
  String get settingsCloseAccount => 'Һисапны ябыш';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Your account is managed, and cannot be closed.';

  @override
  String get settingsClosingIsDefinitive => 'Ябыш анык. Артка кайтыш юк. Ошануыгыз камилме?';

  @override
  String get settingsCantOpenSimilarAccount => 'Һәттә очрак башкача булса һәм сезгә бер хил исемдәге яңа һисап ачырга рөхсәт бирелмиде.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Мин үз фикеремне үзгәртердем, һисапны япмам';

  @override
  String get settingsCloseAccountExplanation => 'Һисапны ябышны хуплайсызмы? Һисабыгызны ябыш даими карар. Сез ҺИЧ КАЙЧАН КЕРЕШЕГЕЗ МӨМКИН.';

  @override
  String get settingsThisAccountIsClosed => 'Ошбу һисап ябылган.';

  @override
  String get playWithAFriend => 'Дустың белән уйнарга';

  @override
  String get playWithTheMachine => 'Компьютер белән уйнарга';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Бу сылтама белән уенга чакыру';

  @override
  String get gameOver => 'Уен бетте';

  @override
  String get waitingForOpponent => 'Ярышучыны көтәбез';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Көтү';

  @override
  String get yourTurn => 'Сез йөрисез';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 дәрәҗәсе $param2';
  }

  @override
  String get level => 'Дәрәҗә';

  @override
  String get strength => 'Ныгыту';

  @override
  String get toggleTheChat => 'Чатны ачу/ябу';

  @override
  String get chat => 'Сүхбәт';

  @override
  String get resign => 'Җиңелү';

  @override
  String get checkmate => 'Мат';

  @override
  String get stalemate => 'Пат';

  @override
  String get white => 'Ак';

  @override
  String get black => 'Кара';

  @override
  String get asWhite => 'as white';

  @override
  String get asBlack => 'as black';

  @override
  String get randomColor => 'Очраклы төс';

  @override
  String get createAGame => 'Уен башларга';

  @override
  String get whiteIsVictorious => 'Ак җиңде';

  @override
  String get blackIsVictorious => 'Кара җиңде';

  @override
  String get youPlayTheWhitePieces => 'Сез ак фигуралар белән уйныйсыз';

  @override
  String get youPlayTheBlackPieces => 'Сез кара фигуралар белән уйныйсыз';

  @override
  String get itsYourTurn => 'Сезнең йөрүегез!';

  @override
  String get cheatDetected => 'Хәйлә аныкланган';

  @override
  String get kingInTheCenter => 'Патша такта уртасында';

  @override
  String get threeChecks => 'Өч шах';

  @override
  String get raceFinished => 'Ярыш бетте';

  @override
  String get variantEnding => 'Уен бетте';

  @override
  String get newOpponent => 'Яңа ярышучы';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Ярушычыгыз сезнең белән яңа уен уйнарга тели';

  @override
  String get joinTheGame => 'Уенга кушылу';

  @override
  String get whitePlays => 'Аклар йөри';

  @override
  String get blackPlays => 'Каралар йөри';

  @override
  String get opponentLeftChoices => 'Ярышучыгыз уеннан чыкты. Сез җиңүегезне я бер-берегезнең тигезлеген белдерә, я аны көтеп тора аласыз.';

  @override
  String get forceResignation => 'Җиңүегезне игълан итү';

  @override
  String get forceDraw => 'Тигезлек игълан итү';

  @override
  String get talkInChat => 'Сөйләшкәндә әдәпле булыгыз!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Сылтамага кергән беренче кеше сезнең белән уйнар.';

  @override
  String get whiteResigned => 'Аклар истифа итте';

  @override
  String get blackResigned => 'Каралар истифа итте';

  @override
  String get whiteLeftTheGame => 'Ак уеннан чыкты';

  @override
  String get blackLeftTheGame => 'Кара уеннан чыкты';

  @override
  String get whiteDidntMove => 'White didn\'t move';

  @override
  String get blackDidntMove => 'Black didn\'t move';

  @override
  String get requestAComputerAnalysis => 'Компьютер тикшеревен итү';

  @override
  String get computerAnalysis => 'Компьютер тикшереве';

  @override
  String get computerAnalysisAvailable => 'Компьютер тикшеревен итә аласыз';

  @override
  String get computerAnalysisDisabled => 'Computer analysis disabled';

  @override
  String get analysis => 'Тикшерү тактасы';

  @override
  String depthX(String param) {
    return 'Тирәнлек $param';
  }

  @override
  String get usingServerAnalysis => 'Сервер анализын куллану';

  @override
  String get loadingEngine => 'Движок йөкләнә...';

  @override
  String get calculatingMoves => 'Calculating moves...';

  @override
  String get engineFailed => 'Error loading engine';

  @override
  String get cloudAnalysis => 'Болыт анализы';

  @override
  String get goDeeper => 'Тирәңрәк';

  @override
  String get showThreat => 'Янауны күрсәтү';

  @override
  String get inLocalBrowser => 'браузерда';

  @override
  String get toggleLocalEvaluation => 'Җирле анализ күчтерү';

  @override
  String get promoteVariation => 'Вариантнын приоритетын күтәрү';

  @override
  String get makeMainLine => 'Төп вариант итеп кую';

  @override
  String get deleteFromHere => 'Бу урыннан бетерү';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Вариантны төп итү';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'Йөрү';

  @override
  String get variantLoss => 'Җиңелү юлы';

  @override
  String get variantWin => 'Җиңү юлы';

  @override
  String get insufficientMaterial => 'Материал җитми';

  @override
  String get pawnMove => 'Пешка йөрүе';

  @override
  String get capture => 'Алу';

  @override
  String get close => 'Ябу';

  @override
  String get winning => 'Җиңү';

  @override
  String get losing => 'Җиңелү';

  @override
  String get drawn => 'Тиңлек';

  @override
  String get unknown => 'Билгесез';

  @override
  String get database => 'Партияләр архивы';

  @override
  String get whiteDrawBlack => 'Аклар / Тиңлек / Каралар';

  @override
  String averageRatingX(String param) {
    return 'Уртача рейтинг $param';
  }

  @override
  String get recentGames => 'Соңгы уеннар';

  @override
  String get topGames => 'Иң яхшы уеннар';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param2нче елдан $param3нче елга кадәр $param1+ FIDE рейтинглы уенчылары тарафыннан такта артында уйналган 2 миллион уен';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' with rounding, based on number of half-moves until next capture or pawn move';

  @override
  String get noGameFound => 'Бер уен да табылмады';

  @override
  String get maxDepthReached => 'Max depth reached!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Бәлки көйләүләрдә күбрәк уеннарны кабызырсыз?';

  @override
  String get openings => 'Openings';

  @override
  String get openingExplorer => 'Дебютлар базасы';

  @override
  String get openingEndgameExplorer => 'Opening/endgame explorer';

  @override
  String xOpeningExplorer(String param) {
    return '$param дебютлар базасы';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => '50 йөрү кайгыйдәсе буенча җиңеп булмый';

  @override
  String get lossSavedBy50MoveRule => '50 йөрү кагыйдәсе буенча җиңелеп булмый';

  @override
  String get winOr50MovesByPriorMistake => 'Win or 50 moves by prior mistake';

  @override
  String get lossOr50MovesByPriorMistake => 'Loss or 50 moves by prior mistake';

  @override
  String get unknownDueToRounding => 'Win/loss only guaranteed if recommended tablebase line has been followed since the last capture or pawn move, due to possible rounding of DTZ values in Syzygy tablebases.';

  @override
  String get allSet => 'Бөтенесе әзер!';

  @override
  String get importPgn => 'PGN импорты';

  @override
  String get delete => 'Бетерү';

  @override
  String get deleteThisImportedGame => 'Бу импортланган уенны ташларгамы?';

  @override
  String get replayMode => 'Кабат карау';

  @override
  String get realtimeReplay => 'Чын вакытта';

  @override
  String get byCPL => 'Хаталар буенча';

  @override
  String get openStudy => 'Өйрәнүне ачу';

  @override
  String get enable => 'Кабызылган';

  @override
  String get bestMoveArrow => 'Иң яхшы йөрүне күрсәтү';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Бәяләу шкаласы';

  @override
  String get multipleLines => 'Берничә вариант';

  @override
  String get cpus => 'Процессорлар';

  @override
  String get memory => 'Хәтер';

  @override
  String get infiniteAnalysis => 'Чиксез анализ';

  @override
  String get removesTheDepthLimit => 'Тикшерү чикләрен бетерә һәм компьютерыгызны җылыта';

  @override
  String get engineManager => 'Engine manager';

  @override
  String get blunder => 'Зур хата';

  @override
  String get mistake => 'Хата';

  @override
  String get inaccuracy => 'Җиңел хата';

  @override
  String get moveTimes => 'Йөреш вакыты';

  @override
  String get flipBoard => 'Тактаны әйләндерү';

  @override
  String get threefoldRepetition => 'Өч тапкыр кабатлау';

  @override
  String get claimADraw => 'Тигез уен белдерү';

  @override
  String get offerDraw => 'Тигезлекне тәкъдим итү';

  @override
  String get draw => 'Тиңлек';

  @override
  String get drawByMutualAgreement => 'Draw by mutual agreement';

  @override
  String get fiftyMovesWithoutProgress => 'Fifty moves without progress';

  @override
  String get currentGames => 'Хәзерге уеннар';

  @override
  String get viewInFullSize => 'Тулысынча күрү';

  @override
  String get logOut => 'Чыгу';

  @override
  String get signIn => 'Керү';

  @override
  String get rememberMe => 'Keep me logged in';

  @override
  String get youNeedAnAccountToDoThat => 'Моның өчен аккаунт кирәк';

  @override
  String get signUp => 'Теркәлү';

  @override
  String get computersAreNotAllowedToPlay => 'Компьютер булышы тыелган. Зинһар, уйнаганда, шахмат программалары, мәглүмәт базалары я башка уенчылар булышы белән файдаланмагыз. Күп аккаунтлар ясау киңәш ителми һәм кирәк булмаган күп аккаунтлар ясау сезне банга китерер.';

  @override
  String get games => 'Уеннар';

  @override
  String get forum => 'Форум';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 $param2 темасына язу җибәрде';
  }

  @override
  String get latestForumPosts => 'Соңгы форум язулары';

  @override
  String get players => 'Уенчылар';

  @override
  String get friends => 'Дуслар';

  @override
  String get discussions => 'Әңгәмәләр';

  @override
  String get today => 'Бүген';

  @override
  String get yesterday => 'Кичә';

  @override
  String get minutesPerSide => 'Һәр якка бирелгән вакыт';

  @override
  String get variant => 'Вариант';

  @override
  String get variants => 'Вариантлар';

  @override
  String get timeControl => 'Вакыт контроле';

  @override
  String get realTime => 'Хәзерге вакытта';

  @override
  String get correspondence => 'Хат алмашып уйнау';

  @override
  String get daysPerTurn => 'Бер йөреш вакыты';

  @override
  String get oneDay => 'Бер көн';

  @override
  String get time => 'Вакыт';

  @override
  String get rating => 'Рейтинг';

  @override
  String get ratingStats => 'Рейтинг статистикасы';

  @override
  String get username => 'Кулланучы исеме';

  @override
  String get usernameOrEmail => 'Кулланычы исеме я эл. почтасы';

  @override
  String get changeUsername => 'Кулланучы исемен үзгәртү';

  @override
  String get changeUsernameNotSame => 'Хәрефләр регистрын гына үзгәртеп була. Мәсәлән, \"johndoe\"ны \"JohnDoe\"га.';

  @override
  String get changeUsernameDescription => 'Кулланучы исемегезне үзгәртегез. Сез моны бер тапкыр гына ясый аласыз һәм хәрефләрнен зурлыгын гына үзгәртә аласыз.';

  @override
  String get signupUsernameHint => 'Make sure to choose a family-friendly username. You cannot change it later and any accounts with inappropriate usernames will get closed!';

  @override
  String get signupEmailHint => 'We will only use it for password reset.';

  @override
  String get password => 'Серсүз';

  @override
  String get changePassword => 'Серсүзне үзгәртү';

  @override
  String get changeEmail => 'Emailны үзгәртү';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Серсүзне алыштыру';

  @override
  String get forgotPassword => 'Серсүзне оныттыгыз?';

  @override
  String get error_weakPassword => 'This password is extremely common, and too easy to guess.';

  @override
  String get error_namePassword => 'Please don\'t use your username as your password.';

  @override
  String get blankedPassword => 'You have used the same password on another site, and that site has been compromised. To ensure the safety of your Lichess account, we need you to set a new password. Thank you for your understanding.';

  @override
  String get youAreLeavingLichess => 'You are leaving Lichess';

  @override
  String get neverTypeYourPassword => 'Never type your Lichess password on another site!';

  @override
  String proceedToX(String param) {
    return 'Proceed to $param';
  }

  @override
  String get passwordSuggestion => 'Do not set a password suggested by someone else. They will use it to steal your account.';

  @override
  String get emailSuggestion => 'Do not set an email address suggested by someone else. They will use it to steal your account.';

  @override
  String get emailConfirmHelp => 'Help with email confirmation';

  @override
  String get emailConfirmNotReceived => 'Didn\'t receive your confirmation email after signing up?';

  @override
  String get whatSignupUsername => 'What username did you use to sign up?';

  @override
  String usernameNotFound(String param) {
    return 'We couldn\'t find any user by this name: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'You can use this username to create a new account';

  @override
  String emailSent(String param) {
    return 'We have sent an email to $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'It can take some time to arrive.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Wait 5 minutes and refresh your email inbox.';

  @override
  String get checkSpamFolder => 'Also check your spam folder, it might end up there. If so, mark it as not spam.';

  @override
  String get emailForSignupHelp => 'If everything else fails, then send us this email:';

  @override
  String copyTextToEmail(String param) {
    return 'Copy and paste the above text and send it to $param';
  }

  @override
  String get waitForSignupHelp => 'We will come back to you shortly to help you complete your signup.';

  @override
  String accountConfirmed(String param) {
    return 'The user $param is successfully confirmed.';
  }

  @override
  String accountCanLogin(String param) {
    return 'You can login right now as $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'You do not need a confirmation email.';

  @override
  String accountClosed(String param) {
    return 'The account $param is closed.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'The account $param was registered without an email.';
  }

  @override
  String get rank => 'Урын';

  @override
  String rankX(String param) {
    return 'Урын: $param';
  }

  @override
  String get gamesPlayed => 'Уеннар саны';

  @override
  String get cancel => 'Булдыртмау';

  @override
  String get whiteTimeOut => 'Акларның вакыты чыкты';

  @override
  String get blackTimeOut => 'Караларның вакыты чыкты';

  @override
  String get drawOfferSent => 'Тиңлек тәкъдиме җибәрелде';

  @override
  String get drawOfferAccepted => 'Тиңлек тәкъдиме кабул ителде';

  @override
  String get drawOfferCanceled => 'Тиңлек тәкъдиме туктатылды';

  @override
  String get whiteOffersDraw => 'Аклар тиңлек тәкъдим итә';

  @override
  String get blackOffersDraw => 'Каралар тиңлек тәкъдим итә';

  @override
  String get whiteDeclinesDraw => 'Аклар тиңлекне кире кага';

  @override
  String get blackDeclinesDraw => 'Каралар тиңлекне кире кага';

  @override
  String get yourOpponentOffersADraw => 'Ярышучыгыз тиңлек тәкъдим итә';

  @override
  String get accept => 'Кабул итү';

  @override
  String get decline => 'Кире кагу';

  @override
  String get playingRightNow => 'Хәзер уйнала';

  @override
  String get eventInProgress => 'Хәзер уйнала';

  @override
  String get finished => 'Тәмамланган';

  @override
  String get abortGame => 'Уенны туктату';

  @override
  String get gameAborted => 'Уен туктатылды';

  @override
  String get standard => 'Стандартлы';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Чиксез';

  @override
  String get mode => 'Режим';

  @override
  String get casual => 'Рейтингсыз';

  @override
  String get rated => 'Рейтинглы';

  @override
  String get casualTournament => 'Рейтингсыз';

  @override
  String get ratedTournament => 'Рейтинглы';

  @override
  String get thisGameIsRated => 'Бу уен рейтинглы';

  @override
  String get rematch => 'Яңадан уйнау';

  @override
  String get rematchOfferSent => 'Яңадан уйнау тәкъдим ителде';

  @override
  String get rematchOfferAccepted => 'Яңадан уйнау кабул ителде';

  @override
  String get rematchOfferCanceled => 'Яңадан уйнау тәкъдиме туктатылды';

  @override
  String get rematchOfferDeclined => 'Яңадан уйнау кабул ителмәде';

  @override
  String get cancelRematchOffer => 'Яңадан уйнау тәкъдимен туктатырга';

  @override
  String get viewRematch => 'Яңадан уйнауны күрү';

  @override
  String get confirmMove => 'Йөрүне раслау';

  @override
  String get play => 'Уйнау';

  @override
  String get inbox => 'Хатлар';

  @override
  String get chatRoom => 'Сөйләшү бүлмәсе';

  @override
  String get loginToChat => 'Чат куллану өчен керегез';

  @override
  String get youHaveBeenTimedOut => 'Чаттан вакытлыча чыгарылдыгыз.';

  @override
  String get spectatorRoom => 'Күзәтү бүлмәсе';

  @override
  String get composeMessage => 'Хат язу';

  @override
  String get subject => 'Хат темасы';

  @override
  String get send => 'Җибәрү';

  @override
  String get incrementInSeconds => 'Секунд кушыла';

  @override
  String get freeOnlineChess => 'Түләүсез Онлайн Шахмат';

  @override
  String get exportGames => 'Уеннарны экспортлау';

  @override
  String get ratingRange => 'Рейтинг аралыгы';

  @override
  String get thisAccountViolatedTos => 'Бу аккаунт Lichessның Куллану Шартларын бозды';

  @override
  String get openingExplorerAndTablebase => 'Дебютлар һәм эндшпилләр базасы';

  @override
  String get takeback => 'Кире алырга';

  @override
  String get proposeATakeback => 'Йөрүне кире алырга сорарга';

  @override
  String get takebackPropositionSent => 'Йөрүне кире алу соралды';

  @override
  String get takebackPropositionDeclined => 'Йөрүне кире алу кире кагылды';

  @override
  String get takebackPropositionAccepted => 'Йөрүне кире алу кабул ителде';

  @override
  String get takebackPropositionCanceled => 'Йөрүне кире алу тәкъдиме туктатылды';

  @override
  String get yourOpponentProposesATakeback => 'Ярышучыгыз йөрүне кире алырга сорый';

  @override
  String get bookmarkThisGame => 'Бу битне кыстыргычларга сакларга';

  @override
  String get tournament => 'Бәйге';

  @override
  String get tournaments => 'Бәйгеләр';

  @override
  String get tournamentPoints => 'Бәйге нокталары';

  @override
  String get viewTournament => 'Бәйгене күрү';

  @override
  String get backToTournament => 'Бәйгегә кайту';

  @override
  String get noDrawBeforeSwissLimit => 'You cannot draw before 30 moves are played in a Swiss tournament.';

  @override
  String get thematic => 'Тематик';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Сезнең $param рейтингыгыз әле фараз';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Сезнең $param1 рейтингыгыз ($param2) артык югары';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Сезнең атналы $param1 рейтингыгыз ($param2) артык югары';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Сезнең $param1 рейтингыгыз ($param2) кирәкледән кечкенәрәк';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 рейтингы ≥ $param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 рейтингы ≤ $param1';
  }

  @override
  String mustBeInTeam(String param) {
    return '$param төркемендә булырга тиеш';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Сез $param төркемендә түгел';
  }

  @override
  String get backToGame => 'Уенга кайту';

  @override
  String get siteDescription => 'Түләүсез онлайн шахмат серверы. Уңайлы интерфейс. Рекламасыз, регистрация һәм программаны йөкләү кирәкми. Компьютер, дусларыгыз я очраклы каршыдаш белән уйнагыз.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 $param2 төркеменә кушылды';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 $param2 төркемен ясады';
  }

  @override
  String get startedStreaming => 'started streaming';

  @override
  String xStartedStreaming(String param) {
    return '$param стрим башлады';
  }

  @override
  String get averageElo => 'Уртача рейтинг';

  @override
  String get location => 'Урын';

  @override
  String get filterGames => 'Уеннар фильтры';

  @override
  String get reset => 'Яңадан';

  @override
  String get apply => 'Саклау';

  @override
  String get save => 'Саклау';

  @override
  String get leaderboard => 'Лидерлар тактасы';

  @override
  String get screenshotCurrentPosition => 'Screenshot current position';

  @override
  String get gameAsGIF => 'GIF итеп саклау';

  @override
  String get pasteTheFenStringHere => 'FEN текстын монда кертегез';

  @override
  String get pasteThePgnStringHere => 'PGN текстын монда кертегез';

  @override
  String get orUploadPgnFile => 'Or upload a PGN file';

  @override
  String get fromPosition => 'Позициядән';

  @override
  String get continueFromHere => 'Бу җирдән дәвам итү';

  @override
  String get toStudy => 'Өйрәнү';

  @override
  String get importGame => 'Уенны импортлау';

  @override
  String get importGameExplanation => 'Уенны яңадан күзәтү, компьютерлап анализлау, уен чатын hәм бүлешерлек URL алу өчен уеннын PGN йөкләгез.';

  @override
  String get importGameCaveat => 'Variations will be erased. To keep them, import the PGN via a study.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Бу шахматлы CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Кеше икәнегезне раслау өчен тактага басып, йөрү ясагыз.';

  @override
  String get captcha_fail => 'Зинhaр, шахматлы капчаны чишегез.';

  @override
  String get notACheckmate => 'Мат түгел';

  @override
  String get whiteCheckmatesInOneMove => 'Аклар бер йөрүдә мат куялар';

  @override
  String get blackCheckmatesInOneMove => 'Каралар бер йөрүдә мат куялар';

  @override
  String get retry => 'Кабатлау';

  @override
  String get reconnecting => 'Яңадан бәйләнешү';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Яраткан ярышучылар';

  @override
  String get follow => 'Язылу';

  @override
  String get following => 'Язылгансыз';

  @override
  String get unfollow => 'Язылынмау';

  @override
  String followX(String param) {
    return 'Follow $param';
  }

  @override
  String unfollowX(String param) {
    return '$param язылынмау';
  }

  @override
  String get block => 'Блоклау';

  @override
  String get blocked => 'Блокланган';

  @override
  String get unblock => 'Блоктан чыгару';

  @override
  String get followsYou => 'Сезгә язылган';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 $param2 исемле уенчыга язылган';
  }

  @override
  String get more => 'Тагын';

  @override
  String get memberSince => 'Регистрация көне';

  @override
  String lastSeenActive(String param) {
    return '$param кергән иде';
  }

  @override
  String get player => 'Уенчы';

  @override
  String get list => 'Тезем';

  @override
  String get graph => 'График';

  @override
  String get required => 'Тәлап ителгән.';

  @override
  String get openTournaments => 'Ачык бәйгеләр';

  @override
  String get duration => 'Озаклыгы';

  @override
  String get winner => 'Җиңүче';

  @override
  String get standing => 'Урыны';

  @override
  String get createANewTournament => 'Яңа бәйге башламак';

  @override
  String get tournamentCalendar => 'Бәйге календаре';

  @override
  String get conditionOfEntry => 'Керу тәлапләре:';

  @override
  String get advancedSettings => 'Кушылма көйләүләр';

  @override
  String get safeTournamentName => 'Бәйге өчен хуп имин исем куегыз.';

  @override
  String get inappropriateNameWarning => 'Әз генә дә килешми торган исем аккаунтыгызның ябылуына китерә ала.';

  @override
  String get emptyTournamentName => 'Бәйгегә берәр атаклы шаһматчының исемен бирү өчен буш калдырыгыз.';

  @override
  String get makePrivateTournament => 'Бәйгегә серсүз буенча гына керү куя аласыз';

  @override
  String get join => 'Катнашу';

  @override
  String get withdraw => 'Уеннан чыгу';

  @override
  String get points => 'Баллар';

  @override
  String get wins => 'Җиңүләр';

  @override
  String get losses => 'Җиңелүләр';

  @override
  String get createdBy => 'Оештыручы';

  @override
  String get tournamentIsStarting => 'Бәйгене башлана';

  @override
  String get tournamentPairingsAreNowClosed => 'Бәйге чиратлаштыруы ябылган.';

  @override
  String standByX(String param) {
    return '$param көтегез, уйнаучылар чиратлаштырыла, әзерләнегез!';
  }

  @override
  String get pause => 'Туктату';

  @override
  String get resume => 'Дәвам итү';

  @override
  String get youArePlaying => 'Сез уйныйсыз!';

  @override
  String get winRate => 'Җиңүләр';

  @override
  String get berserkRate => 'Берсерк';

  @override
  String get performance => 'Перфоманс';

  @override
  String get tournamentComplete => 'Бәйге тәмамланды';

  @override
  String get movesPlayed => 'Йөрешләр саны';

  @override
  String get whiteWins => 'Аклар җиңүләре';

  @override
  String get blackWins => 'Каралар җиңүләре';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Тиңлекләр';

  @override
  String nextXTournament(String param) {
    return 'Киләсе $param бәйгесе:';
  }

  @override
  String get averageOpponent => 'Уртача ярышучы';

  @override
  String get boardEditor => 'Тактаны үзгәртү';

  @override
  String get setTheBoard => 'Тактаны урнаштыру';

  @override
  String get popularOpenings => 'Популяр дебютлар';

  @override
  String get endgamePositions => 'Endgame positions';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 start position: $param';
  }

  @override
  String get startPosition => 'Башлангыч позиция';

  @override
  String get clearBoard => 'Тактаны бушату';

  @override
  String get loadPosition => 'Позицияне йөкләү';

  @override
  String get isPrivate => 'Яшерен';

  @override
  String reportXToModerators(String param) {
    return '$param турында модераторларга белдерү';
  }

  @override
  String profileCompletion(String param) {
    return 'Профиль тәмамлыгы: $param';
  }

  @override
  String xRating(String param) {
    return '$param рейтингы';
  }

  @override
  String get ifNoneLeaveEmpty => 'Булмаса, буш калдырыгыз';

  @override
  String get profile => 'Профиль';

  @override
  String get editProfile => 'Профильны үзгәртү';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Үзең турында';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Рәхмәт!';

  @override
  String get socialMediaLinks => 'Социаль медиа сылтамалары';

  @override
  String get oneUrlPerLine => 'One URL per line.';

  @override
  String get inlineNotation => 'Кертелгән билгеләнеш';

  @override
  String get makeAStudy => 'For safekeeping and sharing, consider making a study.';

  @override
  String get clearSavedMoves => 'Clear moves';

  @override
  String get previouslyOnLichessTV => 'Алданлырак Личес ТВда';

  @override
  String get onlinePlayers => 'Юрдә уйнаучылар';

  @override
  String get activePlayers => 'Актив уйнаучылар';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Сак бул, бу уен рейтинглы, әмма сәгать юк!';

  @override
  String get success => 'Уңышлы';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Тукталмыйча дәвам ит киләсе уенны алгы йөртүдә';

  @override
  String get autoSwitch => 'Үзе күчерә';

  @override
  String get puzzles => 'Башваткычлар';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Исем';

  @override
  String get description => 'Тафсиры';

  @override
  String get descPrivate => 'Шәхси тафсиры';

  @override
  String get descPrivateHelp => 'Язма төркемле уенчыларга гына күренә ала. Әгәр куйсагыз, алыштырсагыз төркем әгъзалары өчен җәмәгать тасвирламасын.';

  @override
  String get no => 'Юк';

  @override
  String get yes => 'Әйе';

  @override
  String get help => 'Булышу:';

  @override
  String get createANewTopic => 'Яңа сәрхаү ачу';

  @override
  String get topics => 'Сәрхәү';

  @override
  String get posts => 'Хәбәрләр';

  @override
  String get lastPost => 'Соңгы хәбәр';

  @override
  String get views => 'Карамаклар';

  @override
  String get replies => 'Җаваплар';

  @override
  String get replyToThisTopic => 'Бу сәрхәүгә җавап';

  @override
  String get reply => 'Җавап';

  @override
  String get message => 'Хәбәр';

  @override
  String get createTheTopic => 'Сәрхәү ачу';

  @override
  String get reportAUser => 'Кулланучыны белделергә';

  @override
  String get user => 'Кулланучы';

  @override
  String get reason => 'Сәбаб';

  @override
  String get whatIsIheMatter => 'Нәрсә булды?';

  @override
  String get cheat => 'Алдамак';

  @override
  String get troll => 'Троль';

  @override
  String get other => 'Бүтән';

  @override
  String get reportDescriptionHelp => 'Уен(нар) сылтамаларын кертегез һәм бу кулланучының тәртибендә дөрес булмаганны аңлатыгыз. \"Алдакчы\" дип кенә әйтмәгез, бу нәтиҗәгә ничек килгәнегезне әйтегез. Сезнең җибәрүегез инглизчә язылган очракта тизрәк эшкәртеләчәк.';

  @override
  String get error_provideOneCheatedGameLink => 'Зинһар, алданган уенга ким дигәндә бер сылтама бирегез.';

  @override
  String by(String param) {
    return '$paramдан';
  }

  @override
  String importedByX(String param) {
    return 'Imported by $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Бу сәрхәү хәзер ябык.';

  @override
  String get blog => 'Шәлкемлек';

  @override
  String get notes => 'Искәрмәләр';

  @override
  String get typePrivateNotesHere => 'Шәхси язма монда калдырыгыз';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Write a private note about this user';

  @override
  String get noNoteYet => 'No note yet';

  @override
  String get invalidUsernameOrPassword => 'Кулланучы исеме яки серсүз яраксыз';

  @override
  String get incorrectPassword => 'Бозык серсүз';

  @override
  String get invalidAuthenticationCode => 'Аутһентикация коды яраксыз';

  @override
  String get emailMeALink => 'Сылтама белән миңа хат';

  @override
  String get currentPassword => 'Хәзерге серсүз';

  @override
  String get newPassword => 'Яңа серсүз';

  @override
  String get newPasswordAgain => 'Яңа серсүз (яңадан)';

  @override
  String get newPasswordsDontMatch => 'Яңа серсүз килешми';

  @override
  String get newPasswordStrength => 'Серсүз ныклыгы';

  @override
  String get clockInitialTime => 'Сәгатьнең баштагы вакыты';

  @override
  String get clockIncrement => 'Сәгатьнең артуы';

  @override
  String get privacy => 'Шәхсилек';

  @override
  String get privacyPolicy => 'Хосуслык сәясәте';

  @override
  String get letOtherPlayersFollowYou => 'Башка уенчылар сезгә иярсәләр';

  @override
  String get letOtherPlayersChallengeYou => 'Башка кулланучылар сезне сынамышка чакырсалар';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Башка кулланучылар укырга чакырсалар';

  @override
  String get sound => 'Тавыш';

  @override
  String get none => 'Юк';

  @override
  String get fast => 'Тиз';

  @override
  String get normal => 'Гадәттәгечә';

  @override
  String get slow => 'Акрын';

  @override
  String get insideTheBoard => 'Тактаның эчендә';

  @override
  String get outsideTheBoard => 'Тактаның тышында';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Тыныч уеннарда';

  @override
  String get always => 'Һәрвакыт';

  @override
  String get never => 'Беркачанда';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 көндәшлек итә $param2';
  }

  @override
  String get victory => 'Җиңү';

  @override
  String get defeat => 'Җиңелде';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param3 монда $param1 каршы $param2';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param3 монда $param1 каршы $param2';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param3 монда $param1 каршы $param2';
  }

  @override
  String get timeline => 'Вакыт узуы';

  @override
  String get starting => 'Башлануы:';

  @override
  String get allInformationIsPublicAndOptional => 'Барлык мәгълүмат җәмәгать һәм өстәмә.';

  @override
  String get biographyDescription => 'Сөйләгез үзегез хакында, сезнең кызыксындырулар турында, Ни сез яратасыз шаһматта, сезнең яраткан ачылышыгыз, кулланучыгыз,...';

  @override
  String get listBlockedPlayers => 'Язмасындагы кулланучыларны сез кисәттегез';

  @override
  String get human => 'Кеше';

  @override
  String get computer => 'Компьютер';

  @override
  String get side => 'Як';

  @override
  String get clock => 'Сәгать';

  @override
  String get opponent => 'Көндәшегез';

  @override
  String get learnMenu => 'Өйрәнү';

  @override
  String get studyMenu => 'Өйрәнү';

  @override
  String get practice => 'Практика';

  @override
  String get community => 'Җәмәгать';

  @override
  String get tools => 'Кораллар';

  @override
  String get increment => 'Артуы';

  @override
  String get error_unknown => 'Invalid value';

  @override
  String get error_required => 'Бу алан кирәкле';

  @override
  String get error_email => 'This email address is invalid';

  @override
  String get error_email_acceptable => 'This email address is not acceptable. Please double-check it, and try again.';

  @override
  String get error_email_unique => 'Email address invalid or already taken';

  @override
  String get error_email_different => 'This is already your email address';

  @override
  String error_minLength(String param) {
    return 'Must be at least $param characters long';
  }

  @override
  String error_maxLength(String param) {
    return 'Must be at most $param characters long';
  }

  @override
  String error_min(String param) {
    return 'Must be at least $param';
  }

  @override
  String error_max(String param) {
    return 'Must be at most $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Әгәр рейтингың ± $param';
  }

  @override
  String get ifRegistered => 'If registered';

  @override
  String get onlyExistingConversations => 'Бары тик сөйләшүләр генә';

  @override
  String get onlyFriends => 'Дустлар гына';

  @override
  String get menu => 'Меню';

  @override
  String get castling => 'Ныгытма';

  @override
  String get whiteCastlingKingside => 'Аклар O-O';

  @override
  String get blackCastlingKingside => 'Каралар O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Уйнау өчен вакыт: $param';
  }

  @override
  String get watchGames => 'Кара уеннарны';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'ТВдан күрсәтелгән вакыт: $param';
  }

  @override
  String get watch => 'Кара';

  @override
  String get videoLibrary => 'Видео җиентыгы';

  @override
  String get streamersMenu => 'Алып баручылар';

  @override
  String get mobileApp => 'Кәрәзле Әсбап';

  @override
  String get webmasters => 'Вебмастерлар';

  @override
  String get about => 'Хакында';

  @override
  String aboutX(String param) {
    return '$param хакында';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 ул азат ($param2), ирекле, комерциясез, ачык чыганаклы шаһмат серверы.';
  }

  @override
  String get really => 'чыннанда';

  @override
  String get contribute => 'Игътибар итегез';

  @override
  String get termsOfService => 'Куллану шартлары';

  @override
  String get sourceCode => 'Кодның чыганагы';

  @override
  String get simultaneousExhibitions => 'Синхрон күргәзмәләр';

  @override
  String get host => 'Хуҗа';

  @override
  String hostColorX(String param) {
    return 'Алып бару төсе $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Яңа гына ачылган симул';

  @override
  String get hostANewSimul => 'Яңа симулның хуҗасы';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Симул табылмады';

  @override
  String get noSimulExplanation => 'Бер үк вакыттагы күргәзмә юк.';

  @override
  String get returnToSimulHomepage => 'Симул ал битенә кайтырга';

  @override
  String get aboutSimul => 'Симуляцияда бер генэ кеше уйныйала, шул вакытта кайберлэр кешелэр белэн уйный аларга ярый.';

  @override
  String get aboutSimulImage => '50 Рәкыйп чыкты, Фишер 47 уенны җиңде, 2се җиңүсез һәм 1 уенда җиңелде.';

  @override
  String get aboutSimulRealLife => 'Концепция хакыкый дөнья вакыйгаларыннан алынган. Хакыкый хаяттә бу бер үк вакытта алып барган хәрәкәтләрне өстәлдән өстәлгә уйнашны үзе хәрәкәт итте.';

  @override
  String get aboutSimulRules => 'Берүк башлаганда һәр бер уенчы алып баручы белән уенны уенны башлады. Берүк барча уеннар тутаганнан соң туктый.';

  @override
  String get aboutSimulSettings => 'Берүк һаманда рәсми түгел. Кайтаргыч уеннар, кайтарып алулар һәм вакыт өстәү мәгакъ.';

  @override
  String get create => 'Ячарга';

  @override
  String get whenCreateSimul => 'Качанда сез Берүк ачканда, сезгә уйнау өчен берничә уенчы тугры киләдер.';

  @override
  String get simulVariantsHint => 'Әгәр сез берничә вариантны сайласагыз, һәр уйнаучы сайлый ала берне уйнау өчен.';

  @override
  String get simulClockHint => 'Фишер Сәгатен үзләштерү. Күбрәк уенчыларны кабул кылсагыз, сезгә кубрәк вакыт кирәк буласы мөмкин.';

  @override
  String get simulAddExtraTime => 'Берүктә җиңәр өчен сезгә сәгатькә кушымча вакыт кушышсагыз мөмкин.';

  @override
  String get simulHostExtraTime => 'Алып барырга өстәмә сәгать вакытын';

  @override
  String get simulAddExtraTimePerPlayer => 'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'Личесс бәйгеләре';

  @override
  String get tournamentFAQ => 'Бәйге мәйданы ЕБС';

  @override
  String get timeBeforeTournamentStarts => 'Бәйге башланыр алдындагы вакыт';

  @override
  String get averageCentipawnLoss => 'Уртача урнашу-матерьялы җиңүлүе';

  @override
  String get accuracy => 'Төгәллек';

  @override
  String get keyboardShortcuts => 'Керткечнең эзмәләре';

  @override
  String get keyMoveBackwardOrForward => 'артка/Алга хәрәкәт';

  @override
  String get keyGoToStartOrEnd => 'башлануга/бетүгә';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'комментларны ачу/качыру';

  @override
  String get keyEnterOrExitVariation => 'керт/чык вариантны';

  @override
  String get keyRequestComputerAnalysis => 'Request computer analysis, Learn from your mistakes';

  @override
  String get keyNextLearnFromYourMistakes => 'Next (Learn from your mistakes)';

  @override
  String get keyNextBlunder => 'Next blunder';

  @override
  String get keyNextMistake => 'Next mistake';

  @override
  String get keyNextInaccuracy => 'Next inaccuracy';

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
  String get newTournament => 'Яңа бәйге';

  @override
  String get tournamentHomeTitle => 'Шаһмат бәйгесе төрле хосусиятләргә вакытны башкару һәм вариантларга ия';

  @override
  String get tournamentHomeDescription => 'Уйна Тизкер шаһмат бәйгесендә! Рәтләштерелгән рәсми бәйгегә шәхсән кушыл яки үзеңнекен ач. Мәрми, Яшен, Хуп, Фишерча, ТауШаһы, ӨчләтәШаһ, һәм тагын имкинлиятлекләр форсаты чиксез шаһмат куанычы өчен.';

  @override
  String get tournamentNotFound => 'Бәйге табылмаган';

  @override
  String get tournamentDoesNotExist => 'Ошбу бәйге мәүҗуд итмәс.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Әгәр барча уенчылар башлангыш алдындан китешкән булса, бәйге бөкер кылынган булуш мөмкин.';

  @override
  String get returnToTournamentsHomepage => 'Бәйгеләр албитенә барырга';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Атналы $param рейтинг таратылышы';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Сезнең $param1 рейтингыгыз $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Сез $param1 уйнаучыдан $param2 әхсәндер.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param3 уйнаучылар арасында $param2 караганда $param1 әхсәндер.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Сездә билгеләнгән $param рейтингы юк.';
  }

  @override
  String get yourRating => 'Сезнең рейтингыгыз';

  @override
  String get cumulative => 'Кумулятив';

  @override
  String get glicko2Rating => 'Glicko-2 рейтингы';

  @override
  String get checkYourEmail => 'Тикшерегез э. почтаны';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Без сезгә электрон почта җибәрдек. Хисап язмагызны активлаштыру өчен электрон почтадагы сылтамага басыгыз.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Электрон почтаны күрмәсәгез, башка урыннарны тикшерегез, сезнең кирәксез, спам, социаль яки бүтән папкалар кебек.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Безнең $param җибәрдек. Серсүзне яңадан урнаштыру өчен электрон почтадагы сылтамага басыгыз.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Теркәлү белән сез $param белән ризалашасыз.';
  }

  @override
  String readAboutOur(String param) {
    return 'Безнең $param турында укыгыз.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Челтәр сезнең белән Lichess арасында артта калды';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Lichess серверында хәрәкәтне эшкәртү вакыты';

  @override
  String get downloadAnnotated => 'Өзешлене йөкләү';

  @override
  String get downloadRaw => 'Чималны иңдер';

  @override
  String get downloadImported => 'Импортны йөкләү';

  @override
  String get crosstable => 'Кросстабель';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Сез шулай ук уенга күчү өчен такта өстенә әйләндерә аласыз.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scroll over computer variations to preview them.';

  @override
  String get analysisShapesHowTo => 'Тактада түгәрәкләр һәм уклар сызу өчен shift + чирттерү яки уң төймәгә+чирттерү.';

  @override
  String get letOtherPlayersMessageYou => 'Башка уенчылар сезгә хәбәр итсеннәр';

  @override
  String get receiveForumNotifications => 'Receive notifications when mentioned in the forum';

  @override
  String get shareYourInsightsData => 'Шаһмат мәгълүматлары белән уртаклашыгыз';

  @override
  String get withNobody => 'Беркем беләндә түгел';

  @override
  String get withFriends => 'Дустлар белән';

  @override
  String get withEverybody => 'Барысы белән';

  @override
  String get kidMode => 'Сабыйлар осулы';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Бу куркынычсызлык турында. Балалар режимында барлык сайт элемтәләре дә сүндерелгән. Моны балаларыгыз һәм мәктәп укучылары өчен рөхсәт итегез, аларны бүтән интернет кулланучылардан саклагыз.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Балалар усулында Lichess тамгасы $param иконасын ала, шуңа күрә сез балаларыгызның куркынычсыз булуын беләсез.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'Балалар осулын куй';

  @override
  String get disableKidMode => 'Сабый осулын кирегә куй';

  @override
  String get security => 'Хәвефсезлек';

  @override
  String get sessions => 'Sessions';

  @override
  String get revokeAllSessions => 'һәр сессиядан чыгу';

  @override
  String get playChessEverywhere => 'Уйна шаһмат бөтен җирдә';

  @override
  String get asFreeAsLichess => 'Личесс кебек азат';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Төздек шаһмат яратучылары өчен, акча түгел';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Һәркайсы алы барлык әйберләрен азат';

  @override
  String get zeroAdvertisement => 'Сәрмая юк';

  @override
  String get fullFeatured => 'Барлык үзенчәлекләр';

  @override
  String get phoneAndTablet => 'Кәрәзле телефон һәм планшет';

  @override
  String get bulletBlitzClassical => 'Мәрми, яшенчә, хуп';

  @override
  String get correspondenceChess => 'Язылу шаһматы';

  @override
  String get onlineAndOfflinePlay => 'Чилтәрдә һәм чилтәрсез уйнамак';

  @override
  String get viewTheSolution => 'Чишелешне карап алу';

  @override
  String get followAndChallengeFriends => 'Иярергә һәм сынарга дутларны';

  @override
  String get gameAnalysis => 'Уенны уйланырга';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 хуҗасы $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 Кушлады $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 ошады $param2';
  }

  @override
  String get quickPairing => 'Тизкер парлаштырыш';

  @override
  String get lobby => 'Көндәшләр';

  @override
  String get anonymous => 'Билгесез';

  @override
  String yourScore(String param) {
    return 'Синен бәяләү $param';
  }

  @override
  String get language => 'Тел';

  @override
  String get background => 'Җирлек';

  @override
  String get light => 'Ачык';

  @override
  String get dark => 'Караңгы';

  @override
  String get transparent => 'Үтә күренмәле';

  @override
  String get deviceTheme => 'Device theme';

  @override
  String get backgroundImageUrl => 'Арткы караныш рәсеме URL:';

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
  String get pieceSet => 'Эйберлэр';

  @override
  String get embedInYourWebsite => 'Веб-сайтыгызга җайлаштырылган';

  @override
  String get usernameAlreadyUsed => 'Ошбу кулланучынәми әлләкайчан ишләтелгән, фадлыйк башкасын сынап карыйк.';

  @override
  String get usernamePrefixInvalid => 'Кулланучынәмә хәрефтән башланырга тиеш.';

  @override
  String get usernameSuffixInvalid => 'Кулланучынәмә хәреф яки сан белән тәмамланырга тиеш.';

  @override
  String get usernameCharsInvalid => 'Кулланучынәма фәкать харефләр, саннар, астсызыклар вә урта сызыклар гыйбәрәт булыш кирәк. Китмә-киткән астсызыклар вә урта сызыкларга юк куймайды.';

  @override
  String get usernameUnacceptable => 'Бу кулланучынәма макбул түгел.';

  @override
  String get playChessInStyle => 'Уйна шаһмат стиль белән';

  @override
  String get chessBasics => 'Шаһмат нигезләре';

  @override
  String get coaches => 'Тренерлар';

  @override
  String get invalidPgn => 'Бозык PGN';

  @override
  String get invalidFen => 'Бозык FEN';

  @override
  String get custom => 'Куелган';

  @override
  String get notifications => 'Хәбәр итүләр';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get practiceWithComputer => 'Компьютер белән практикалаштыру';

  @override
  String anotherWasX(String param) {
    return 'Башкасы $param иде';
  }

  @override
  String bestWasX(String param) {
    return 'Иң якшысы $param';
  }

  @override
  String get youBrowsedAway => 'Сез карадыгыз';

  @override
  String get resumePractice => 'Дәвам итергә практиканы';

  @override
  String get drawByFiftyMoves => 'The game has been drawn by the fifty move rule.';

  @override
  String get theGameIsADraw => 'Бу уен җиңүсез.';

  @override
  String get computerThinking => 'Компьютер саный ...';

  @override
  String get seeBestMove => 'Иң якшы хәрәкәтне кара';

  @override
  String get hideBestMove => 'Иң якшы хәрәкәтне качырырга';

  @override
  String get getAHint => 'Этәргеч алырга';

  @override
  String get evaluatingYourMove => 'Сезнең хәрәкәтне бәяләү ...';

  @override
  String get whiteWinsGame => 'Аклар җиңүләре';

  @override
  String get blackWinsGame => 'Каралар җиңүләре';

  @override
  String get learnFromYourMistakes => 'Хаталардан өйрәнегез';

  @override
  String get learnFromThisMistake => 'Бу хатадан өйрәнегез';

  @override
  String get skipThisMove => 'Төшереп калдыру бу хәрәкәтне';

  @override
  String get next => 'Киләсе';

  @override
  String xWasPlayed(String param) {
    return '$param уйнады';
  }

  @override
  String get findBetterMoveForWhite => 'Эзлә иң якшы хәрәкәтне аклар өчен';

  @override
  String get findBetterMoveForBlack => 'Эзлә иң якшы хәрәкәтне каралар өчен';

  @override
  String get resumeLearning => 'Өйрәнүгә кайту';

  @override
  String get youCanDoBetter => 'Сез яхшырак эшли аласыз';

  @override
  String get tryAnotherMoveForWhite => 'Акларга бүтән хәрәкәтне карагыз';

  @override
  String get tryAnotherMoveForBlack => 'Караларга бүтән хәрәкәтне карагыз';

  @override
  String get solution => 'Чишелеше';

  @override
  String get waitingForAnalysis => 'Көтегез тәхлил өчен';

  @override
  String get noMistakesFoundForWhite => 'Аклар өчен табылмады хата';

  @override
  String get noMistakesFoundForBlack => 'Табылмады караларның хаталары';

  @override
  String get doneReviewingWhiteMistakes => 'Аклар хаталарын карау булды';

  @override
  String get doneReviewingBlackMistakes => 'Каралар хаталарын карау булды';

  @override
  String get doItAgain => 'Кабат ясарга';

  @override
  String get reviewWhiteMistakes => 'Тагын карарга аклар хаталарын';

  @override
  String get reviewBlackMistakes => 'Тагын карарга каралар хаталарын';

  @override
  String get advantage => 'Өстенлек';

  @override
  String get opening => 'Башлагыч';

  @override
  String get middlegame => 'Урта уен';

  @override
  String get endgame => 'Уен азагы';

  @override
  String get conditionalPremoves => 'Шартлы хәрәкәтләр';

  @override
  String get addCurrentVariation => 'Агымдагы үзгәрешне өстәгез';

  @override
  String get playVariationToCreateConditionalPremoves => 'Шартлы хәрәкәтләр ясау өчен вариация уйнагыз';

  @override
  String get noConditionalPremoves => 'Юк шартлы хәрәкәтләр';

  @override
  String playX(String param) {
    return 'Уйнау $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Юаныч :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Без сезне бераз вакытка чыгарырга тиеш идек.';

  @override
  String get why => 'Нигә?';

  @override
  String get pleasantChessExperience => 'Без һәркемгә шаһмат тәҗрибәсен тәкъдим итәбез.';

  @override
  String get goodPractice => 'Моның өчен без барлык уенчыларның да яхшы практиканы үтәргә тиеш.';

  @override
  String get potentialProblem => 'Мөмкин булган мөшәкәт аныкланганда, без ошбу хәбәрне күрсәтербез.';

  @override
  String get howToAvoidThis => 'Моннан ничек сакланырга?';

  @override
  String get playEveryGame => 'Сез башлаган һәр уенны уйнагыз.';

  @override
  String get tryToWin => 'Сез уйнаган һәр уенда җиңәргә (яки ким дигәндә җиңүсезлеккә) тырышыгыз.';

  @override
  String get resignLostGames => 'Истифа ителгән җиңелгән уеннар (сәгать эшләмәсен).';

  @override
  String get temporaryInconvenience => 'Вакытлыча уңайсызлыклар өчен гафу үтенәбез,';

  @override
  String get wishYouGreatGames => 'һәм сезгә lichess.org сайтында зур уеннар телим.';

  @override
  String get thankYouForReading => 'Укыган өчен ташаккур!';

  @override
  String get lifetimeScore => 'Гомер буе исәпләү';

  @override
  String get currentMatchScore => 'Хәзерге матч исәбе';

  @override
  String get agreementAssistance => 'Минем уеннар вакытында теләсә кайсы вакытта ярдәм алуыма ризалашам (шахмат компьютерыннан, китаптан, мәгълүмат базасыннан яки бүтән кешедән).';

  @override
  String get agreementNice => 'Мин башка уенчыларга һәрвакыт хөрмәт күрсәтермен дип килешәм.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'I agree that I will not create multiple accounts (except for the reasons stated in the $param).';
  }

  @override
  String get agreementPolicy => 'Мин барлык Lichess сәясәтен үтәрмен дип килешәм.';

  @override
  String get searchOrStartNewDiscussion => 'Яңа сөйләшүне эзләү яки башлау';

  @override
  String get edit => 'Үзгәртү';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Блиц';

  @override
  String get rapid => 'Тиз';

  @override
  String get classical => 'Классика';

  @override
  String get ultraBulletDesc => 'Гаҗәеп тиз уеннар: 30 секундтан да азрак';

  @override
  String get bulletDesc => 'Бик тиз уеннар: 3 минуттан да азрак';

  @override
  String get blitzDesc => 'Тиз уеннар: 3 - 8 минут';

  @override
  String get rapidDesc => 'Тиз уеннар 8дән 25минутка кадәр';

  @override
  String get classicalDesc => 'Хуп уеннар: 25 минут һәм аннан да күбрәк';

  @override
  String get correspondenceDesc => 'Хат язышу уеннары: хәрәкәткә бер-берничә көн';

  @override
  String get puzzleDesc => 'Шаһмат тактикалар остасы';

  @override
  String get important => 'Мөһим';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Сезнең сорауга $param1 җаваплар булырга мөмкин';
  }

  @override
  String get inTheFAQ => 'Еш Сорый торган Сорауларда.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Алдау яки начар тәртип өчен кулланучыга хәбәр итү өчен, $param1';
  }

  @override
  String get useTheReportForm => 'куллан җибәрү формасын';

  @override
  String toRequestSupport(String param1) {
    return 'Ярдәм сорашу өчен $param1';
  }

  @override
  String get tryTheContactPage => 'контакт битен карагыз';

  @override
  String makeSureToRead(String param1) {
    return 'Make sure to read $param1';
  }

  @override
  String get theForumEtiquette => 'the forum etiquette';

  @override
  String get thisTopicIsArchived => 'Бу тема архивланган һәм аңа җавап биреп булмый.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Бу форумда урнаштыру өчен $param1 кушылыгыз';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 Җәмәга';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Сез әле форумда бәрид урнаштыра алмыйсыз. Берничә уен уйнагыз!';

  @override
  String get subscribe => 'Кушылмак';

  @override
  String get unsubscribe => 'Аерылмак';

  @override
  String mentionedYouInX(String param1) {
    return '\"$param1\" сезне искә алдылар.';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 сезне \"$param2\" да искә алды.';
  }

  @override
  String invitedYouToX(String param1) {
    return '\"$param1\" сезне яште.';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 сезне \"$param2\" чакырды.';
  }

  @override
  String get youAreNowPartOfTeam => 'Сез хәзер җәмәга әгъзасы.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Сез \"$param1\" га кушылдыгыз.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Сез хәбәр иткән кеше тыелган';

  @override
  String get congratsYouWon => 'Тәбриклийбез, сез җиңдегез!';

  @override
  String gameVsX(String param1) {
    return '$param1 каршы уен';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Сез Lichess TOS кагыйдәләрене бозган кешегә оттырдыгыз';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Кире кайтару $param1 $param2 рейтинг накате.';
  }

  @override
  String get timeAlmostUp => 'Вакыт тугады диярлек!';

  @override
  String get clickToRevealEmailAddress => '[Click to reveal email address]';

  @override
  String get download => 'Йөкләп алу';

  @override
  String get coachManager => 'Coach manager';

  @override
  String get streamerManager => 'Streamer manager';

  @override
  String get cancelTournament => 'Cancel the tournament';

  @override
  String get tournDescription => 'Ярыш тасвирламасы';

  @override
  String get tournDescriptionHelp => 'Anything special you want to tell the participants? Try to keep it short. Markdown links are available: [name](https://url)';

  @override
  String get ratedFormHelp => 'Games are rated and impact players ratings';

  @override
  String get onlyMembersOfTeam => 'Only members of team';

  @override
  String get noRestriction => 'No restriction';

  @override
  String get minimumRatedGames => 'Minimum rated games';

  @override
  String get minimumRating => 'Minimum rating';

  @override
  String get maximumWeeklyRating => 'Maximum weekly rating';

  @override
  String positionInputHelp(String param) {
    return 'Paste a valid FEN to start every game from a given position.\nIt only works for standard games, not with variants.\nYou can use the $param to generate a FEN position, then paste it here.\nLeave empty to start games from the normal initial position.';
  }

  @override
  String get cancelSimul => 'Cancel the simul';

  @override
  String get simulHostcolor => 'Host colour for each game';

  @override
  String get estimatedStart => 'Estimated start time';

  @override
  String simulFeatured(String param) {
    return 'Feature on $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Show your simul to everyone on $param. Disable for private simuls.';
  }

  @override
  String get simulDescription => 'Simul description';

  @override
  String get simulDescriptionHelp => 'Anything you want to tell the participants?';

  @override
  String markdownAvailable(String param) {
    return '$param is available for more advanced syntax.';
  }

  @override
  String get embedsAvailable => 'Paste a game URL or a study chapter URL to embed it.';

  @override
  String get inYourLocalTimezone => 'In your own local timezone';

  @override
  String get tournChat => 'Tournament chat';

  @override
  String get noChat => 'No chat';

  @override
  String get onlyTeamLeaders => 'Only team leaders';

  @override
  String get onlyTeamMembers => 'Only team members';

  @override
  String get navigateMoveTree => 'Navigate the move tree';

  @override
  String get mouseTricks => 'Mouse tricks';

  @override
  String get toggleLocalAnalysis => 'Toggle local computer analysis';

  @override
  String get toggleAllAnalysis => 'Toggle all computer analysis';

  @override
  String get playComputerMove => 'Play best computer move';

  @override
  String get analysisOptions => 'Analysis options';

  @override
  String get focusChat => 'Focus chat';

  @override
  String get showHelpDialog => 'Show this help dialog';

  @override
  String get reopenYourAccount => 'Reopen your account';

  @override
  String get closedAccountChangedMind => 'If you closed your account, but have since changed your mind, you get one chance of getting your account back.';

  @override
  String get onlyWorksOnce => 'This will only work once.';

  @override
  String get cantDoThisTwice => 'If you close your account a second time, there will be no way of recovering it.';

  @override
  String get emailAssociatedToaccount => 'Email address associated to the account';

  @override
  String get sentEmailWithLink => 'We\'ve sent you an email with a link.';

  @override
  String get tournamentEntryCode => 'Tournament entry code';

  @override
  String get hangOn => 'Туктагыз!';

  @override
  String gameInProgress(String param) {
    return 'You have a game in progress with $param.';
  }

  @override
  String get abortTheGame => 'Abort the game';

  @override
  String get resignTheGame => 'Resign the game';

  @override
  String get youCantStartNewGame => 'You can\'t start a new game until this one is finished.';

  @override
  String get since => 'Since';

  @override
  String get until => 'Until';

  @override
  String get lichessDbExplanation => 'Rated games played on Lichess';

  @override
  String get switchSides => 'Switch sides';

  @override
  String get closingAccountWithdrawAppeal => 'Closing your account will withdraw your appeal';

  @override
  String get ourEventTips => 'Our tips for organising events';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess is a charity and entirely free/libre open source software.\nAll operating costs, development, and content are funded solely by user donations.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ярышучыгыз уеннан чыкты. Сез җиңүегезне $count секундтан белдерә аласыз.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ярты-йөрүдә мат',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хаталар',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хата',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count төгәлсезлек',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count уенчы',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count уен',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rating over $param2 games',
      one: '$count rating over $param2 game',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count билгеләнгән',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count көн',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сәгатъ',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минут',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Урын hәр $count минут саен яңартыла',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count күнегү',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сезнең белән $count уен',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рейтинглы',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count җиңү',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count җиңелү',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тиңлек',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count уйнала',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунд бирү',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count турнир баллары',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count өйрәнү',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simuls',
      one: '$count simul',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count рейтинглы уен',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count рейтинглы $param2 уен',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сезгә тагын $param2 рейтинглы $count уен уйнарга кирәк',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сезгә тагын $count рейтинглы уен уйнарга кирәк',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count импортланган уен',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дус челтәрдә',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count язылучы',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count язылганнары',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минуттан әзрәк',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count уен уйныйлар',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Азагында $count билге.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count кисетелгән',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count аралашу хәбәры',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 уенчылар бу атнада.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count телдә бар!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунд уйнар өчен беренче хәрәкәтне',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунд',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'һәм $count йөрмәгән линияне',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Башлар өчен хәрәкәт';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Барлык башваткычларда аклар сөякләрне уйныйсыз';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Барлык башваткычларда каралар кисәкләрне уйныйсыз';

  @override
  String get stormPuzzlesSolved => 'табышмаклар чишелде';

  @override
  String get stormNewDailyHighscore => 'Яңа көндәлек югары күрсәткеч!';

  @override
  String get stormNewWeeklyHighscore => 'Яңа атналык югары күрсәткеч!';

  @override
  String get stormNewMonthlyHighscore => 'Яңа айлык югары күрсәткеч!';

  @override
  String get stormNewAllTimeHighscore => 'Яңа гел югары күрсәткеч!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Элеккеге югары күрсәткеч $param иде';
  }

  @override
  String get stormPlayAgain => 'Яңадан уйнау';

  @override
  String stormHighscoreX(String param) {
    return 'Югары күрсәткеч: $param';
  }

  @override
  String get stormScore => 'Күрсәткеч';

  @override
  String get stormMoves => 'Хәрәкәт';

  @override
  String get stormAccuracy => 'Төгәллек';

  @override
  String get stormCombo => 'Комбо';

  @override
  String get stormTime => 'Вакыт';

  @override
  String get stormTimePerMove => 'Бер хәрәкәт вакыты';

  @override
  String get stormHighestSolved => 'Иң югары чишелгән';

  @override
  String get stormPuzzlesPlayed => 'Башваткыч уйналды';

  @override
  String get stormNewRun => 'Яңа йөгерү (уңайлытөймә: Space)';

  @override
  String get stormEndRun => 'Ахыр йөгерү (уңайлытөймә: Enter)';

  @override
  String get stormHighscores => 'Югары күрсәткеч';

  @override
  String get stormViewBestRuns => 'Иң яхшы йөгерүне карау';

  @override
  String get stormBestRunOfDay => 'Көннең иң яхшы йөгереше';

  @override
  String get stormRuns => 'Үтәргә';

  @override
  String get stormGetReady => 'Әзер бул!';

  @override
  String get stormWaitingForMorePlayers => 'Күбрәк уенчыларның кушылуын көтеп...';

  @override
  String get stormRaceComplete => 'Ярыш тәмам!';

  @override
  String get stormSpectating => 'Тамаша';

  @override
  String get stormJoinTheRace => 'Ярышка кушылыгыз!';

  @override
  String get stormStartTheRace => 'Start the race';

  @override
  String stormYourRankX(String param) {
    return 'Сезнең ранк: $param';
  }

  @override
  String get stormWaitForRematch => 'Кайтаргыч уенны көтегез';

  @override
  String get stormNextRace => 'Киләсе Ярыш';

  @override
  String get stormJoinRematch => 'Кайтаргыч уенга кушылыгыз';

  @override
  String get stormWaitingToStart => 'Башлауны көтә';

  @override
  String get stormCreateNewGame => 'Яңа уен ясагыз';

  @override
  String get stormJoinPublicRace => 'Иҗтимагый ярышка кушылыгыз';

  @override
  String get stormRaceYourFriends => 'Сезнең дусларың белән ярыш';

  @override
  String get stormSkip => 'отыш';

  @override
  String get stormSkipHelp => 'Сез бер ярышка бер хәрәкәтне калдыра аласыз:';

  @override
  String get stormSkipExplanation => 'Комбаны саклап калу өчен бу хәрәкәтне ташлагыз! Ярышка бер тапкыр гына эшли.';

  @override
  String get stormFailedPuzzles => 'Failed puzzles';

  @override
  String get stormSlowPuzzles => 'Slow puzzles';

  @override
  String get stormSkippedPuzzle => 'Skipped puzzle';

  @override
  String get stormThisWeek => 'Бу атна';

  @override
  String get stormThisMonth => 'This month';

  @override
  String get stormAllTime => 'All-time';

  @override
  String get stormClickToReload => 'Click to reload';

  @override
  String get stormThisRunHasExpired => 'This run has expired!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'This run was opened in another tab!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count йөгерә',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count уйнаган $param2 йөгерә',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Личесс агымнары';

  @override
  String get studyShareAndExport => 'Юшәрик & яшдүр';

  @override
  String get studyStart => 'Башла';
}
