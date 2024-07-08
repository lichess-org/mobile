import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

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
  String get activityActivity => 'Активност';

  @override
  String get activityHostedALiveStream => 'Одржали пренос уживо';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Рангиран #$param1 у $param2';
  }

  @override
  String get activitySignedUp => 'Пријавили се на lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Подржали lichess.org на $count месеци као $param2',
      few: 'Подржали lichess.org на $count месеца као $param2',
      one: 'Подржали lichess.org на $count месец као $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вежбали $count позиција на $param2',
      few: 'Вежбали $count позиције на $param2',
      one: 'Вежбали $count позицију на $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Решили $count тактичких проблема',
      few: 'Решили $count тактичка проблема',
      one: 'Решили $count тактички проблем',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Одиграли $count $param2 партија',
      few: 'Одиграли $count $param2 партије',
      one: 'Одиграли $count $param2 партију',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Поставили $count порука у $param2',
      few: 'Поставили $count поруке у $param2',
      one: 'Поставили $count поруку у $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Одиграли $count потеза',
      few: 'Одиграли $count потеза',
      one: 'Одиграли $count потез',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'у $count дописних партија',
      few: 'у $count дописне партије',
      one: 'у $count дописној партији',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завршили $count дописних партија',
      few: 'Завршили $count дописне партије',
      one: 'Завршили $count дописну партију',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Почели пратити $count играча',
      few: 'Почели пратити $count играча',
      one: 'Почели пратити $count играча',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Стекли $count нових пратилаца',
      few: 'Стекли $count нова пратилаца',
      one: 'Стекли $count новог пратиоца',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Одржали $count симултанки',
      few: 'Одржали $count симултанке',
      one: 'Одржали $count симултанку',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Учествовали у $count симултанки',
      few: 'Учествовали у $count симултанке',
      one: 'Учествовали у $count симултанки',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Направили $count нових студија',
      few: 'Направили $count нове студије',
      one: 'Направили $count нову студију',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Учествовали у $count турнира',
      few: 'Учествовали у $count турнира',
      one: 'Учествовали у $count турниру',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Рангиран #$count (првих $param2%) са $param3 партија у $param4',
      few: 'Рангиран #$count (првих $param2%) са $param3 партије у $param4',
      one: 'Рангиран #$count (првих $param2%) са $param3 партијом у $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Competed in $count Swiss tournaments',
      one: 'Competed in $count Swiss tournament',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ушли у $count тимова',
      few: 'Ушли у $count тима',
      one: 'Ушли у $count тим',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Емитовања';

  @override
  String get broadcastLiveBroadcasts => 'Уживо емитовање турнира';

  @override
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Изазови на партију';

  @override
  String get challengeChallengeDeclined => 'Изазов одбијен';

  @override
  String get challengeChallengeAccepted => 'Изазов прихваћен!';

  @override
  String get challengeChallengeCanceled => 'Изазов отказан.';

  @override
  String get challengeRegisterToSendChallenges => 'Молимо Вас да се региструјете како би послали изазове.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Не можете изазвати $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param не прихвата изазове.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Ваш $param1 рејтинг је предалек од $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Немогуће изазвати због привременог $param рејтинга.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param само прихвата изазове од пријатеља.';
  }

  @override
  String get challengeDeclineGeneric => 'Тренутно не прихватам изазове.';

  @override
  String get challengeDeclineLater => 'Изазов ми тренутно не одговара, молим Вас питајте опет касније.';

  @override
  String get challengeDeclineTooFast => 'Ова временска контрола је пребрза за мене, молим Вас изазовите опет на спорију партију.';

  @override
  String get challengeDeclineTooSlow => 'Ова временска контрола је преспора за мене, молим Вас изазовите опет на бржу партију.';

  @override
  String get challengeDeclineTimeControl => 'Не прихватам изазове са овом временском контролом.';

  @override
  String get challengeDeclineRated => 'Уместо овог, молим Вас да ми пошаљете рангиран изазов.';

  @override
  String get challengeDeclineCasual => 'Уместо овог, молим Вас да ми пошаљете неформалан изазов.';

  @override
  String get challengeDeclineStandard => 'Тренутно не прихватам изазове у варијантама.';

  @override
  String get challengeDeclineVariant => 'Тренутно не желим да играм ову варијанту.';

  @override
  String get challengeDeclineNoBot => 'Не прихватам изазове од ботова.';

  @override
  String get challengeDeclineOnlyBot => 'Прихватам само изазове од ботова.';

  @override
  String get challengeInviteLichessUser => 'Or invite a Lichess user:';

  @override
  String get contactContact => 'Контакт';

  @override
  String get contactContactLichess => 'Контактирајте Личес';

  @override
  String get patronDonate => 'Донирај';

  @override
  String get patronLichessPatron => 'Личес Патрон';

  @override
  String perfStatPerfStats(String param) {
    return '$param статистика';
  }

  @override
  String get perfStatViewTheGames => 'Погледај партије';

  @override
  String get perfStatProvisional => 'привремени';

  @override
  String get perfStatNotEnoughRatedGames => 'Није одиграно довољно рангираних игара како би се оствари поуздан рејтинг.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Напредак кроз задњих $param партија:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Девијација рејтинга: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Мања вредност значи да је рејтинг стабилнији. Преко $param1, рејтинг се рачуна као привремени. Да би се урачунала у рејтингу, ова вредност би требала бити испод $param2 (стандардни шах) или $param3 (варијанте).';
  }

  @override
  String get perfStatTotalGames => 'Укупно партија';

  @override
  String get perfStatRatedGames => 'Рангиране партије';

  @override
  String get perfStatTournamentGames => 'Турнирске партије';

  @override
  String get perfStatBerserkedGames => 'Berserked games';

  @override
  String get perfStatTimeSpentPlaying => 'Време проведено у игри';

  @override
  String get perfStatAverageOpponent => 'Просечан противник';

  @override
  String get perfStatVictories => 'Победе';

  @override
  String get perfStatDefeats => 'Пораза';

  @override
  String get perfStatDisconnections => 'Прекидања веза';

  @override
  String get perfStatNotEnoughGames => 'Није одиграно довољно партија';

  @override
  String perfStatHighestRating(String param) {
    return 'Највиши рејтинг: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Најнижи рејтинг: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'од $param1 до $param2';
  }

  @override
  String get perfStatWinningStreak => 'Низ победа';

  @override
  String get perfStatLosingStreak => 'Низ пораза';

  @override
  String perfStatLongestStreak(String param) {
    return 'Најдужи низ: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Тренутни низ: $param';
  }

  @override
  String get perfStatBestRated => 'Најбоље рангиране победе';

  @override
  String get perfStatGamesInARow => 'Узастопно одиграних партија';

  @override
  String get perfStatLessThanOneHour => 'Мање од један сат између партија';

  @override
  String get perfStatMaxTimePlaying => 'Највише времена проведено у игри';

  @override
  String get perfStatNow => 'сада';

  @override
  String get preferencesPreferences => 'Преференсе';

  @override
  String get preferencesDisplay => 'Display';

  @override
  String get preferencesPrivacy => 'Privacy';

  @override
  String get preferencesNotifications => 'Notifications';

  @override
  String get preferencesPieceAnimation => 'Aнимација фигура';

  @override
  String get preferencesMaterialDifference => 'Разлика у материјалу';

  @override
  String get preferencesBoardHighlights => 'Осветли последњи потез и шах';

  @override
  String get preferencesPieceDestinations => 'Bажећи потези (важећи помаци и претпотези)';

  @override
  String get preferencesBoardCoordinates => 'Прикажи координате табле (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Листа потеза током партије';

  @override
  String get preferencesPgnPieceNotation => 'Нотација';

  @override
  String get preferencesChessPieceSymbol => 'симболи фигура';

  @override
  String get preferencesPgnLetter => 'Cлова (К, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'зен стање';

  @override
  String get preferencesShowPlayerRatings => 'Show player ratings';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'This hides all ratings from Lichess, to help focus on the chess. Rated games still impact your rating, this is only about what you get to see.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Прикажи ручицу за мењање величине табле';

  @override
  String get preferencesOnlyOnInitialPosition => 'Само на почетку партије';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Шаховски сат';

  @override
  String get preferencesTenthsOfSeconds => 'Десетинке';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Када имате < 10 секунди';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Хоризонтални зелени индикатор';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Звук када преостане мало времена';

  @override
  String get preferencesGiveMoreTime => 'Додај још времена';

  @override
  String get preferencesGameBehavior => 'Понашање игре';

  @override
  String get preferencesHowDoYouMovePieces => 'Како померате фигуре?';

  @override
  String get preferencesClickTwoSquares => '\"кликни\" два поља';

  @override
  String get preferencesDragPiece => 'вуци фигуру';

  @override
  String get preferencesBothClicksAndDrag => 'на оба начина';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Претпотез (игра се током противниковог потеза)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Враћања потеза (са пристанком противника)';

  @override
  String get preferencesInCasualGamesOnly => 'Само у неформалним партијама';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Промовишите у Даму аутоматски';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'Током претпотеза';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'аутоматски реми после три понављања позиције';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Када преостане < 30 секунди';

  @override
  String get preferencesMoveConfirmation => 'Потврди потез';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'У дописним играма';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Dopisno i neograniceno';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Потврда за предавање и предлагање ремија';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Метода прављења рокаде';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Помери краља за два поља';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Помери краља на топа';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Уноеси потезе са тастатуром';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Snap arrows to valid moves';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Кажи \"Добра партија, добро одиграно\" након пораза или нерешеног';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Ваше преференце су сачуване.';

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
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Device';

  @override
  String get preferencesBellNotificationSound => 'Bell notification sound';

  @override
  String get puzzlePuzzles => 'Проблеми';

  @override
  String get puzzlePuzzleThemes => 'Теме проблема';

  @override
  String get puzzleRecommended => 'Препоручене';

  @override
  String get puzzlePhases => 'Фазе';

  @override
  String get puzzleMotifs => 'Motifs';

  @override
  String get puzzleAdvanced => 'Напредно';

  @override
  String get puzzleLengths => 'Дужина';

  @override
  String get puzzleMates => 'Матови';

  @override
  String get puzzleGoals => 'Циљеви';

  @override
  String get puzzleOrigin => 'Порекло';

  @override
  String get puzzleSpecialMoves => 'Специјални потези';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Да ли вам се свиђа овај проблем?';

  @override
  String get puzzleVoteToLoadNextOne => 'Оцените да би учитали следећу!';

  @override
  String get puzzleUpVote => 'Up vote puzzle';

  @override
  String get puzzleDownVote => 'Down vote puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Your puzzle rating will not change. Note that puzzles are not a competition. Your rating helps selecting the best puzzles for your current skill.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Нађи најбољи потез за белог.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Нађи најбољи потез за црног.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Да би добили персонализоване проблеме:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Проблем $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Проблем дана';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Кликните да би решили';

  @override
  String get puzzleGoodMove => 'Добар потез';

  @override
  String get puzzleBestMove => 'Најбољи потез!';

  @override
  String get puzzleKeepGoing => 'Наставите…';

  @override
  String get puzzlePuzzleSuccess => 'Успех!';

  @override
  String get puzzlePuzzleComplete => 'Готов проблем!';

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
  String get puzzleNotTheMove => 'То није потез!';

  @override
  String get puzzleTrySomethingElse => 'Покушајте нешто друго.';

  @override
  String puzzleRatingX(String param) {
    return 'Рејтинг: $param';
  }

  @override
  String get puzzleHidden => 'сакривено';

  @override
  String puzzleFromGameLink(String param) {
    return 'Из партије $param';
  }

  @override
  String get puzzleContinueTraining => 'Наставите тренинг';

  @override
  String get puzzleDifficultyLevel => 'Ниво тежине';

  @override
  String get puzzleNormal => 'Нормалан';

  @override
  String get puzzleEasier => 'Лакши';

  @override
  String get puzzleEasiest => 'Најлакши';

  @override
  String get puzzleHarder => 'Тежи';

  @override
  String get puzzleHardest => 'Најтежи';

  @override
  String get puzzleExample => 'Пример';

  @override
  String get puzzleAddAnotherTheme => 'Додај другу тему';

  @override
  String get puzzleNextPuzzle => 'Next puzzle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Пређи на следећи проблем одмах';

  @override
  String get puzzlePuzzleDashboard => 'Табла проблема';

  @override
  String get puzzleImprovementAreas => 'Improvement areas';

  @override
  String get puzzleStrengths => 'Снага';

  @override
  String get puzzleHistory => 'Puzzle history';

  @override
  String get puzzleSolved => 'решено';

  @override
  String get puzzleFailed => 'неуспело';

  @override
  String get puzzleStreakDescription => 'Solve progressively harder puzzles and build a win streak. There is no clock, so take your time. One wrong move, and it\'s game over! But you can skip one move per session.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Your streak: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Skip this move to preserve your streak! Only works once per run.';

  @override
  String get puzzleContinueTheStreak => 'Continue the streak';

  @override
  String get puzzleNewStreak => 'New streak';

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
      other: 'Играно $count пута',
      few: 'Играно $count пута',
      one: 'Играно $count пут',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points below your puzzle rating',
      one: 'One point below your puzzle rating',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points above your puzzle rating',
      one: 'One point above your puzzle rating',
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
  String get puzzleThemeAdvancedPawn => 'Пешак пред промоцијом';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Један од Ваших пешака је дубоко у противничкој позицији, можда прети да промовише.';

  @override
  String get puzzleThemeAdvantage => 'Предност';

  @override
  String get puzzleThemeAdvantageDescription => 'Искористите шансу да стекнете одлучујућу предност. (200cp ≤ евалуација ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Анастазијин мат';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Скакач и топ или краљица се удружују како би заробили противничког краља између ивице табле и пријатељске фигуре.';

  @override
  String get puzzleThemeArabianMate => 'Арапски мат';

  @override
  String get puzzleThemeArabianMateDescription => 'Скакач и топ се удружују како би заробили противничког краља на ћошку табле.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Нападање f2 или f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Напад фокусиран на f2 или f7 пешака, као у фегатело отварању.';

  @override
  String get puzzleThemeAttraction => 'Привлачење';

  @override
  String get puzzleThemeAttractionDescription => 'Размена или жртва која подстиче или форсира противничку фигуру на поље које омогућава пратећу тактику.';

  @override
  String get puzzleThemeBackRankMate => 'Мат на последњем реду';

  @override
  String get puzzleThemeBackRankMateDescription => 'Матирајте краља на његовом почетном реду, када је тамо заробљен својим фигурама.';

  @override
  String get puzzleThemeBishopEndgame => 'Ловачка завршница';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Завршница са само ловцима и пешацима.';

  @override
  String get puzzleThemeBodenMate => 'Боденов мат';

  @override
  String get puzzleThemeBodenMateDescription => 'Два нападајућа ловца на унакрсним дијагоналама матирају краља препреченог пријатељским фигурама.';

  @override
  String get puzzleThemeCastling => 'Рокада';

  @override
  String get puzzleThemeCastlingDescription => 'Доведите краља на сигурно и развијте топа за напад.';

  @override
  String get puzzleThemeCapturingDefender => 'Однесите браниоца';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Уклањање фигуре која је критична за одбрану друге фигуре, што омогућава да сада небрањена фигура буде однета на следећем потезу.';

  @override
  String get puzzleThemeCrushing => 'Уништавање';

  @override
  String get puzzleThemeCrushingDescription => 'Уочите противничку грубу грешку како бисте стекли огромну предност. (евалуација ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Мат ловачким паром';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Два нападајућа ловца на суседним дијагоналама матирају краља препреченог пријатељским фигурама.';

  @override
  String get puzzleThemeDovetailMate => 'Коциов мат';

  @override
  String get puzzleThemeDovetailMateDescription => 'Дама матира суседног краља, чија су једина два излазна поља препречена његовим фигурама.';

  @override
  String get puzzleThemeEquality => 'Изједначење';

  @override
  String get puzzleThemeEqualityDescription => 'Вратите се из губитне позиције и осигурајте реми или изједначену позицију. (евалуација ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Напад на краљевој страни';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Напад на противничког краља, након што су се рокадирали на краљевој страни.';

  @override
  String get puzzleThemeClearance => 'Рашчишћавање';

  @override
  String get puzzleThemeClearanceDescription => 'Потез, често са темпом, који рашчишћава поље, колону или дијагоналу за пратећу тактичку идеју.';

  @override
  String get puzzleThemeDefensiveMove => 'Одбрамбени потез';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Прецизан потез или низ потеза који је потребан да се избегне губитак материјала или нека друга предност.';

  @override
  String get puzzleThemeDeflection => 'Одвлачење';

  @override
  String get puzzleThemeDeflectionDescription => 'Потез који одвлачи противничку фигуру од обављања друге дужности, као што је чување кључног поља. Некада се такође зове \"преоптерећење\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Откривени напад';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Померање фигуре (као што је скакач), која је претходно блокирала напад далекометне фигуре (као што је топ), са пута те фигуре.';

  @override
  String get puzzleThemeDoubleCheck => 'Двоструки шах';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Шахирање са две фигуре од једном, као резултат откривеног напада где и фигура која се помера и откривена фигура нападју противничког краља.';

  @override
  String get puzzleThemeEndgame => 'Завршница';

  @override
  String get puzzleThemeEndgameDescription => 'Тактика у току последње фазе партије.';

  @override
  String get puzzleThemeEnPassantDescription => 'Тактика која укључује ан пасан правило, где пешак може однети противничког пешака који га је заобишао користећи његов иницијални потез од два поља.';

  @override
  String get puzzleThemeExposedKing => 'Изложен краљ';

  @override
  String get puzzleThemeExposedKingDescription => 'Тактика која укључује краља са малим бројем бранилаца око њега, често доводи до мата.';

  @override
  String get puzzleThemeFork => 'Виљушка';

  @override
  String get puzzleThemeForkDescription => 'Потез где померена фигура напада две противничке фигуре од једном.';

  @override
  String get puzzleThemeHangingPiece => 'Висећа фигура';

  @override
  String get puzzleThemeHangingPieceDescription => 'Тактика где је противникова фигура небрањена или недовољно брањена и могуће ју је узети.';

  @override
  String get puzzleThemeHookMate => 'Кука-мат';

  @override
  String get puzzleThemeHookMateDescription => 'Мат топом, коњем и пешаком, при чему један противнички пешак онемогућава бег противничком краљу.';

  @override
  String get puzzleThemeInterference => 'Сметња';

  @override
  String get puzzleThemeInterferenceDescription => 'Постављање фигуре између две противничке фигуре, тако да су једна или обе од нјих небрањене, као што је на пример скакач на брањеном пољу између два топа.';

  @override
  String get puzzleThemeIntermezzo => 'Интермецо';

  @override
  String get puzzleThemeIntermezzoDescription => 'Уместо играња очекиваног потеза, прво убаци потез који је непосредна претња на коју противник мора да одговори. Такође знано као \"Zwischenzug\" или \"међупотез\".';

  @override
  String get puzzleThemeKnightEndgame => 'Скакачка завршница';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Завршница са само скакачима и пешацима.';

  @override
  String get puzzleThemeLong => 'Дугачак проблем';

  @override
  String get puzzleThemeLongDescription => 'Три потеза до добитка.';

  @override
  String get puzzleThemeMaster => 'Партије мајстора';

  @override
  String get puzzleThemeMasterDescription => 'Проблеми из партија играних између два играча са титулама.';

  @override
  String get puzzleThemeMasterVsMaster => 'Партије Мајстор против Мајстора';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Проблеми из партија између два играча са титулама.';

  @override
  String get puzzleThemeMate => 'Мат';

  @override
  String get puzzleThemeMateDescription => 'Добијте партију са стилом.';

  @override
  String get puzzleThemeMateIn1 => 'Мат у 1';

  @override
  String get puzzleThemeMateIn1Description => 'Матирајте у једном потезу.';

  @override
  String get puzzleThemeMateIn2 => 'Мат у 2';

  @override
  String get puzzleThemeMateIn2Description => 'Матирајте у два потеза.';

  @override
  String get puzzleThemeMateIn3 => 'Мат у 3';

  @override
  String get puzzleThemeMateIn3Description => 'Матирајте у три потеза.';

  @override
  String get puzzleThemeMateIn4 => 'Мат у 4';

  @override
  String get puzzleThemeMateIn4Description => 'Матирајте у четири потеза.';

  @override
  String get puzzleThemeMateIn5 => 'Мат у 5 или више';

  @override
  String get puzzleThemeMateIn5Description => 'Пронађи дугу матну комбинацију.';

  @override
  String get puzzleThemeMiddlegame => 'Средишњица';

  @override
  String get puzzleThemeMiddlegameDescription => 'Тактика у току друге фазе партије.';

  @override
  String get puzzleThemeOneMove => 'Једнопотезни проблем';

  @override
  String get puzzleThemeOneMoveDescription => 'Проблем који је сачињен од само једног потеза.';

  @override
  String get puzzleThemeOpening => 'Отварање';

  @override
  String get puzzleThemeOpeningDescription => 'Тактика у току прве фазе партије.';

  @override
  String get puzzleThemePawnEndgame => 'Пешачка завршница';

  @override
  String get puzzleThemePawnEndgameDescription => 'Завршница са само пешацима.';

  @override
  String get puzzleThemePin => 'Везивање';

  @override
  String get puzzleThemePinDescription => 'Тактика која садржи везивања, где се фигура не може померити без откривања напада на вреднију фигуру.';

  @override
  String get puzzleThemePromotion => 'Промоција';

  @override
  String get puzzleThemePromotionDescription => 'Промовишите једног од Ваших пешака у даму или лаку фигуру.';

  @override
  String get puzzleThemeQueenEndgame => 'Дамска завршница';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Завршница са само краљицама и пешацима.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Краљица и Топ';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Завршница са само краљицама, топовима и пешацима.';

  @override
  String get puzzleThemeQueensideAttack => 'Напад на даминој страни';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Напад на противничког краља, након што су се рокадирали на краљичиној страни.';

  @override
  String get puzzleThemeQuietMove => 'Тихи потез';

  @override
  String get puzzleThemeQuietMoveDescription => 'Потез који којим се нити даје шах, нити узима фигура, а није ни непосреднја претња узимања фигуре, али којим се припрема скривена претња каснијег узимања фигуре.';

  @override
  String get puzzleThemeRookEndgame => 'Топовска завршница';

  @override
  String get puzzleThemeRookEndgameDescription => 'Завршница са само топовима и пешацима.';

  @override
  String get puzzleThemeSacrifice => 'Жртва';

  @override
  String get puzzleThemeSacrificeDescription => 'Тактика која укључује привремено жртвовање материјала, како би се после форсираног низа потеза поново стекла предност.';

  @override
  String get puzzleThemeShort => 'Кратак проблем';

  @override
  String get puzzleThemeShortDescription => 'Два потеза до добитка.';

  @override
  String get puzzleThemeSkewer => 'Линијски напад';

  @override
  String get puzzleThemeSkewerDescription => 'Мотив који укључује напад на фигуру веће вредности, а када се она помери, омогућује се узимање фигуре мање вредности која је била иза ње или напад на ту фигуру; обрнуто од везивања.';

  @override
  String get puzzleThemeSmotheredMate => 'Угушени мат';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Мат скакачем, при чему матирани краљ није у стању да се помери зато што је окружен (или угушен) својим фигурама.';

  @override
  String get puzzleThemeSuperGM => 'Проблеми из партија које су одиграли најбољи светски велемајстори';

  @override
  String get puzzleThemeSuperGMDescription => 'Проблем из партија које су одиграли најбољи играчи на свету.';

  @override
  String get puzzleThemeTrappedPiece => 'Заробљена фигура';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Фигура не може да избегне да буде узета, зато што јој је ограничено кретање.';

  @override
  String get puzzleThemeUnderPromotion => 'Слаба промоција';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Промоција на коња, ловца или топа.';

  @override
  String get puzzleThemeVeryLong => 'Врло дугачак проблем';

  @override
  String get puzzleThemeVeryLongDescription => 'Четири или више потеза за победу.';

  @override
  String get puzzleThemeXRayAttack => 'Икс Реј напад';

  @override
  String get puzzleThemeXRayAttackDescription => 'Фигура напада или брани поље, захваљујући противничкој фигури.';

  @override
  String get puzzleThemeZugzwang => 'Цугцванг';

  @override
  String get puzzleThemeZugzwangDescription => 'Противник има ограничен избор потеза и сваким потезом погоршава своју позицију.';

  @override
  String get puzzleThemeHealthyMix => 'Здрава мешавина';

  @override
  String get puzzleThemeHealthyMixDescription => 'Свега по мало. Не знаш шта да очекујеш, па остајеш спреман за све! Баш као у правим партијама.';

  @override
  String get puzzleThemePlayerGames => 'Играчеве партије';

  @override
  String get puzzleThemePlayerGamesDescription => 'Потражи проблеме створене на основу твојих партија или партија других грача.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Ови проблеми су у јавном власништву и могуће их је презузети са $param.';
  }

  @override
  String get searchSearch => 'Претрага';

  @override
  String get settingsSettings => 'Подешавања';

  @override
  String get settingsCloseAccount => 'Затворите налог';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Your account is managed, and cannot be closed.';

  @override
  String get settingsClosingIsDefinitive => 'Затварање је коначно. Нема повратка. Да ли сте сигурни?';

  @override
  String get settingsCantOpenSimilarAccount => 'Неће Вам бити допуштено да отворите нови налог са истим именом, чак и ако капитализација слова буде другачија.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Предомислио/ла сам се, немојте затворити мој налог';

  @override
  String get settingsCloseAccountExplanation => 'Да ли сте сигурни да желите затворити Ваш налог? Затварање Вашег налога је трајна одлука. Више се НИКАДА нећете моћи пријавити.';

  @override
  String get settingsThisAccountIsClosed => 'Овај налог је затворен.';

  @override
  String get playWithAFriend => 'Играјте са пријатељем';

  @override
  String get playWithTheMachine => 'Играјте са рачунаром';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Да позовете неког да игра, дајте овaј линк';

  @override
  String get gameOver => 'Партија Завршена';

  @override
  String get waitingForOpponent => 'Чека се противник';

  @override
  String get orLetYourOpponentScanQrCode => 'Или допусти свом противнику да копира овај QR код';

  @override
  String get waiting => 'Чека се';

  @override
  String get yourTurn => 'Ваш потез';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 ниво $param2';
  }

  @override
  String get level => 'Ниво';

  @override
  String get strength => 'Јачина';

  @override
  String get toggleTheChat => 'Укључи/искључи ћаскање';

  @override
  String get chat => 'Ћаскање';

  @override
  String get resign => 'Предај';

  @override
  String get checkmate => 'Шах-мат';

  @override
  String get stalemate => 'Пат';

  @override
  String get white => 'Бели';

  @override
  String get black => 'Црни';

  @override
  String get asWhite => 'као бели';

  @override
  String get asBlack => 'као црни';

  @override
  String get randomColor => 'Насумична боја';

  @override
  String get createAGame => 'Започни нову партију';

  @override
  String get whiteIsVictorious => 'Бели је победник';

  @override
  String get blackIsVictorious => 'Црни је победник';

  @override
  String get youPlayTheWhitePieces => 'Играте са белим фигурама';

  @override
  String get youPlayTheBlackPieces => 'Играте са црним фигурама';

  @override
  String get itsYourTurn => 'Ти си на потезу!';

  @override
  String get cheatDetected => 'Детектована превара';

  @override
  String get kingInTheCenter => 'Краљ је у центру';

  @override
  String get threeChecks => 'Три шаха';

  @override
  String get raceFinished => 'Трка је завршена';

  @override
  String get variantEnding => 'Крај варијацијом';

  @override
  String get newOpponent => 'Нови противник';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Твој противник жели да игра нову партију са тобом';

  @override
  String get joinTheGame => 'Придружи се партији';

  @override
  String get whitePlays => 'Бели је на потезу';

  @override
  String get blackPlays => 'Црни је на потезу';

  @override
  String get opponentLeftChoices => 'Противник је напустио партију. Можеш да се прогласиш победником, да прогласиш партију ремијем или да га сачекаш.';

  @override
  String get forceResignation => 'Прогласи се победником';

  @override
  String get forceDraw => 'Приморај на реми';

  @override
  String get talkInChat => 'Буди љубазан у ћаскању!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Прва особа која кликне на овај линк ће играти са тобом.';

  @override
  String get whiteResigned => 'Бели је предао';

  @override
  String get blackResigned => 'Црни је предао';

  @override
  String get whiteLeftTheGame => 'Бели је напустио партију';

  @override
  String get blackLeftTheGame => 'Црни је напустио партију';

  @override
  String get whiteDidntMove => 'Бели се није померијо';

  @override
  String get blackDidntMove => 'Црни се није померијо';

  @override
  String get requestAComputerAnalysis => 'Тражи рачунарску анализу';

  @override
  String get computerAnalysis => 'Компјутерска анализа';

  @override
  String get computerAnalysisAvailable => 'Рачунарска анализа је доступна';

  @override
  String get computerAnalysisDisabled => 'Онемогућена компјутерска анализа';

  @override
  String get analysis => 'Табла за анализирање';

  @override
  String depthX(String param) {
    return 'Дубина $param';
  }

  @override
  String get usingServerAnalysis => 'Анализа помоћу сервера';

  @override
  String get loadingEngine => 'Рачунар се учитава...';

  @override
  String get calculatingMoves => 'Израчунавам потезе...';

  @override
  String get engineFailed => 'Грешка при учитавању машине';

  @override
  String get cloudAnalysis => 'Анализа у облаку';

  @override
  String get goDeeper => 'Иди дубље';

  @override
  String get showThreat => 'Прикажи претњу';

  @override
  String get inLocalBrowser => 'у локалном прегледачу';

  @override
  String get toggleLocalEvaluation => 'Укључи/искључи локалну процену';

  @override
  String get promoteVariation => 'Промовишите варијацију';

  @override
  String get makeMainLine => 'Направи као главну линију';

  @override
  String get deleteFromHere => 'Избриши одавде';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Промакни варијацију';

  @override
  String get copyVariationPgn => 'Ископирај ПГН варијације';

  @override
  String get move => 'Потез';

  @override
  String get variantLoss => 'Губитак из варијанте';

  @override
  String get variantWin => 'Победа из варијанте';

  @override
  String get insufficientMaterial => 'Недовољно материјала';

  @override
  String get pawnMove => 'Потез пешаком';

  @override
  String get capture => 'Једење';

  @override
  String get close => 'Затворите';

  @override
  String get winning => 'Добија';

  @override
  String get losing => 'Губи';

  @override
  String get drawn => 'Реми';

  @override
  String get unknown => 'Не зна се';

  @override
  String get database => 'База података';

  @override
  String get whiteDrawBlack => 'Бели / Реми / Црни';

  @override
  String averageRatingX(String param) {
    return 'Просечан рејтинг: $param';
  }

  @override
  String get recentGames => 'Недавне партије';

  @override
  String get topGames => 'Најбоље партије';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Два милиона партија на табли $param1+ ФИДЕ рангираних играча од $param2. до $param3.';
  }

  @override
  String get dtzWithRounding => 'Заокружен DTZ50, на основу броја полупотеза до следећег узимања фигуре или потеза пешаком';

  @override
  String get noGameFound => 'Партија није нађена';

  @override
  String get maxDepthReached => 'Достигнут максимални број потеза!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Можда укључите више партија у менију за подешавања?';

  @override
  String get openings => 'Отваранја';

  @override
  String get openingExplorer => 'Претраживач отварања';

  @override
  String get openingEndgameExplorer => 'Претраживач отварања/завршница';

  @override
  String xOpeningExplorer(String param) {
    return '$param претаживач отварања';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Одиграј први потез који сугерише претраживач отварања/завршница';

  @override
  String get winPreventedBy50MoveRule => 'Добитак спречен правилом о 50 потеза';

  @override
  String get lossSavedBy50MoveRule => 'Пораз спречен правилом о 50 потеза';

  @override
  String get winOr50MovesByPriorMistake => 'Победа или 50 потеза на основу претходне грешке';

  @override
  String get lossOr50MovesByPriorMistake => 'Пораз или 50 потеза на основу претходне грешке';

  @override
  String get unknownDueToRounding => 'Победа/пораз су гарантовани једино ако се после последњег узимања фигуре или потеза пешаком следи препоручена основна табела и то због могућег заокруживања DTZ вредности у Syzygy osnovnim tabelama.';

  @override
  String get allSet => 'Све је спремно!';

  @override
  String get importPgn => 'Унеси PGN';

  @override
  String get delete => 'Обриши';

  @override
  String get deleteThisImportedGame => 'Обриши ову увезену партију?';

  @override
  String get replayMode => 'Понављање партије';

  @override
  String get realtimeReplay => 'Као уживо';

  @override
  String get byCPL => 'По рачунару';

  @override
  String get openStudy => 'Отвори проуку';

  @override
  String get enable => 'Укључи';

  @override
  String get bestMoveArrow => 'Стрелица за најбољи потез';

  @override
  String get showVariationArrows => 'Прикажи стрелице за варијацију';

  @override
  String get evaluationGauge => 'Линија за процену';

  @override
  String get multipleLines => 'Више стрелица';

  @override
  String get cpus => 'Процесори';

  @override
  String get memory => 'Меморија';

  @override
  String get infiniteAnalysis => 'Бесконачна анализа';

  @override
  String get removesTheDepthLimit => 'Уклања ограничење дубине и греје рачунар';

  @override
  String get engineManager => 'Менаџер машине';

  @override
  String get blunder => 'Груба грешка';

  @override
  String get mistake => 'Грешка';

  @override
  String get inaccuracy => 'Непрецизност';

  @override
  String get moveTimes => 'Време померања фигура';

  @override
  String get flipBoard => 'Обрни таблу';

  @override
  String get threefoldRepetition => 'Троструко понављање';

  @override
  String get claimADraw => 'Затражи реми';

  @override
  String get offerDraw => 'Понуди реми';

  @override
  String get draw => 'Реми';

  @override
  String get drawByMutualAgreement => 'Нерешено по договору';

  @override
  String get fiftyMovesWithoutProgress => 'Педесет потеза без прогреса';

  @override
  String get currentGames => 'Партије које се управо играју';

  @override
  String get viewInFullSize => 'Погледај у пуној величини';

  @override
  String get logOut => 'Одјави се';

  @override
  String get signIn => 'Пријави се';

  @override
  String get rememberMe => 'Остани пријављен';

  @override
  String get youNeedAnAccountToDoThat => 'Треба вам налог да бисте то урадили';

  @override
  String get signUp => 'Региструјте се';

  @override
  String get computersAreNotAllowedToPlay => 'Игра уз асистенцију рачунара није дозвољена. Молимо Вас да не користите шаховске програме, базе података, и помоћ других играча. Отварање вишеструких налога такође није пожељно док ће прекомерно отварање налога резултирати бановањем.';

  @override
  String get games => 'Партије';

  @override
  String get forum => 'Форум';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 је написао/ла коментар на теми $param2';
  }

  @override
  String get latestForumPosts => 'Последње објаве на форуму';

  @override
  String get players => 'Шахисти';

  @override
  String get friends => 'Пријатељи';

  @override
  String get discussions => 'Разговори';

  @override
  String get today => 'Данас';

  @override
  String get yesterday => 'Јуче';

  @override
  String get minutesPerSide => 'Минута по страни';

  @override
  String get variant => 'Варијанта';

  @override
  String get variants => 'Варијанте';

  @override
  String get timeControl => 'Временско ограничење';

  @override
  String get realTime => 'Игра на време';

  @override
  String get correspondence => 'Дописни шах';

  @override
  String get daysPerTurn => 'Дана по потезу';

  @override
  String get oneDay => 'Један дан';

  @override
  String get time => 'Време';

  @override
  String get rating => 'Рејтинг';

  @override
  String get ratingStats => 'Статистика рејтинга';

  @override
  String get username => 'Корисничко име';

  @override
  String get usernameOrEmail => 'Корисничко име или е-пошта';

  @override
  String get changeUsername => 'Промените корисничко име';

  @override
  String get changeUsernameNotSame => 'Само се величина слова може променити. На пример \"johndoe\" у \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'Промените ваше корисничко име. Можете променити ваше корисничко име само једном и то само величину слова.';

  @override
  String get signupUsernameHint => 'Постарај се да одабереш пристојно корисничко име. Касније га нећеш моћи променити, а налози са непристојним корисничким именима биће затворени!';

  @override
  String get signupEmailHint => 'Биће коришћено само аз ресетовање лозинке.';

  @override
  String get password => 'Лозинка';

  @override
  String get changePassword => 'Промените лозинку';

  @override
  String get changeEmail => 'Промени е-пошту';

  @override
  String get email => 'Е-пошта';

  @override
  String get passwordReset => 'Мењање лозинке';

  @override
  String get forgotPassword => 'Заборавили сте лозинку?';

  @override
  String get error_weakPassword => 'Ова лозинка је изузетно честа и сувише лака да се погоди.';

  @override
  String get error_namePassword => 'Не користите своје корисничко име као шифру.';

  @override
  String get blankedPassword => 'Користио си исту лозинку на другом сајту и тај сајт је био хакован. Да бисмо обезбедили сигурност твог Lichess налога, неопходно је да поставимо нову лозинку. Хвала на разумевању.';

  @override
  String get youAreLeavingLichess => 'Напуштате Личесс';

  @override
  String get neverTypeYourPassword => 'Никада немој користити своју Lichess лозинку на неком другом сајту!';

  @override
  String proceedToX(String param) {
    return 'Настаби до $param';
  }

  @override
  String get passwordSuggestion => 'Немој користити лозинку коју ти је предложио неко други. Он ће је искористити да преузме твој налог.';

  @override
  String get emailSuggestion => 'Немој користити мејл адресу коју ти је предложио неко други. Он ће је искористити да преузме твој налог.';

  @override
  String get emailConfirmHelp => 'Помоћ око потврђивања мејл адресе';

  @override
  String get emailConfirmNotReceived => 'Ниси примио потврду на мејл пошто си се регистровао?';

  @override
  String get whatSignupUsername => 'Које корисничко име си користио приликом регистрације?';

  @override
  String usernameNotFound(String param) {
    return 'Не можемо да пронађемо ниједног корисника са тим именом: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Можеш користи то корисничко име за отварање новог налога';

  @override
  String emailSent(String param) {
    return 'Послали смо мејл на $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Треба мало времена док не стигне.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Сачекај 5 минута и освежи своје поштанско сандуче.';

  @override
  String get checkSpamFolder => 'Такође провери фасциклу са спам порукама, можда је тамо. Ако је ту, обележи поруку тако да није спам.';

  @override
  String get emailForSignupHelp => 'Ако ништа од овога не помаже, онда нам пошаљи овај мејл:';

  @override
  String copyTextToEmail(String param) {
    return 'Ископирај горњи текст и пошаљи га на $param';
  }

  @override
  String get waitForSignupHelp => 'Ускоро ћемо те контактирати како бисмо ти помогли да завршиш своју регистрацију.';

  @override
  String accountConfirmed(String param) {
    return 'Корисник $param је потврђен.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Можеш се сада пријавити као $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Није ти потребан мејл потврде.';

  @override
  String accountClosed(String param) {
    return 'Налог $param је затворен.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Налог $param је регистрован без Е-поште.';
  }

  @override
  String get rank => 'Ранг';

  @override
  String rankX(String param) {
    return 'Ранг: $param';
  }

  @override
  String get gamesPlayed => 'Број одиграних партија';

  @override
  String get cancel => 'Откажи';

  @override
  String get whiteTimeOut => 'Време истекло белом';

  @override
  String get blackTimeOut => 'Време истекло црном';

  @override
  String get drawOfferSent => 'Захтев за реми је послат';

  @override
  String get drawOfferAccepted => 'Предлог за реми је прихваћен';

  @override
  String get drawOfferCanceled => 'Предлог за реми је повучен';

  @override
  String get whiteOffersDraw => 'Бели нуди реми';

  @override
  String get blackOffersDraw => 'Црни нуди реми';

  @override
  String get whiteDeclinesDraw => 'Бели одбија реми';

  @override
  String get blackDeclinesDraw => 'Црни одбија реми';

  @override
  String get yourOpponentOffersADraw => 'Противник нуди реми';

  @override
  String get accept => 'Прихвати';

  @override
  String get decline => 'Одбиј';

  @override
  String get playingRightNow => 'Управо игра';

  @override
  String get eventInProgress => 'Управо игра';

  @override
  String get finished => 'Завршен';

  @override
  String get abortGame => 'Прекините партију';

  @override
  String get gameAborted => 'Партија прекинута';

  @override
  String get standard => 'Стандардно';

  @override
  String get customPosition => 'Произвољна позиција';

  @override
  String get unlimited => 'Неограничено';

  @override
  String get mode => 'Начин';

  @override
  String get casual => 'Неформална';

  @override
  String get rated => 'Рангирана';

  @override
  String get casualTournament => 'Неформално';

  @override
  String get ratedTournament => 'Рангирано';

  @override
  String get thisGameIsRated => 'Ова партија се рангира';

  @override
  String get rematch => 'Реванш';

  @override
  String get rematchOfferSent => 'Понуда за реванш је послата';

  @override
  String get rematchOfferAccepted => 'Понуда за реванш је прихваћена';

  @override
  String get rematchOfferCanceled => 'Понуда за реванш је отказана';

  @override
  String get rematchOfferDeclined => 'Понуда за реванш је одбијена';

  @override
  String get cancelRematchOffer => 'Откажи понуду за реванш';

  @override
  String get viewRematch => 'Погледајте реванш';

  @override
  String get confirmMove => 'Потврди потез';

  @override
  String get play => 'Играј';

  @override
  String get inbox => 'Пријемно сандуче';

  @override
  String get chatRoom => 'Соба за ћаскање';

  @override
  String get loginToChat => 'Улогуј се за ћаскање';

  @override
  String get youHaveBeenTimedOut => 'Стављени сте на тајм-аут.';

  @override
  String get spectatorRoom => 'Соба за посматраче';

  @override
  String get composeMessage => 'Напиши поруку';

  @override
  String get subject => 'Тема';

  @override
  String get send => 'Пошаљи';

  @override
  String get incrementInSeconds => 'Додавање у секундама';

  @override
  String get freeOnlineChess => 'Бесплатан интернет шах';

  @override
  String get exportGames => 'Извоз партија';

  @override
  String get ratingRange => 'Опсег рејтинга';

  @override
  String get thisAccountViolatedTos => 'Овај налог није поштовао Lichess услове коришћења';

  @override
  String get openingExplorerAndTablebase => 'Претраживач отварања & база података';

  @override
  String get takeback => 'Повлачење потеза';

  @override
  String get proposeATakeback => 'Предложи повлачење потеза';

  @override
  String get takebackPropositionSent => 'Предлог повлачења потеза је послат';

  @override
  String get takebackPropositionDeclined => 'Предлог повлачења потеза је одбијен';

  @override
  String get takebackPropositionAccepted => 'Предлог повлачења потеза је прихваћен';

  @override
  String get takebackPropositionCanceled => 'Предлог повлачења потеза је отказан';

  @override
  String get yourOpponentProposesATakeback => 'Противник предлаже повлачење потеза';

  @override
  String get bookmarkThisGame => 'Забележите ову партију';

  @override
  String get tournament => 'Tурнир';

  @override
  String get tournaments => 'Турнири';

  @override
  String get tournamentPoints => 'Поени на турнирима';

  @override
  String get viewTournament => 'Погледај турнир';

  @override
  String get backToTournament => 'Повратак у турнир';

  @override
  String get noDrawBeforeSwissLimit => 'Не можеш ремизирати пре 30. потеза на турниру играном према швајцарском систему.';

  @override
  String get thematic => 'Тематски';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Ваш $param рејтинг је привремен';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ваш $param1 рејтинг ($param2) је превисок';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ваш највиши недељни $param1 рејтинг ($param2) је превисок';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Ваш $param1 рејтинг ($param2) је пренизак';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Рејтинг ≥ $param1 у $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Рејтинг ≤ $param1 у $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Морате бити у тиму $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Ви нисте члан тима $param';
  }

  @override
  String get backToGame => 'Повратак у игру';

  @override
  String get siteDescription => 'Бесплатни интернет шах. Играј сада у чистом окружењу. Без регистрације, реклама, захтеваних података. Играј шах ротив рачунара, пријатеља или насумичних противника.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 придружио/ла се тиму $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 креирао/ла тим $param2';
  }

  @override
  String get startedStreaming => 'стриминг започет';

  @override
  String xStartedStreaming(String param) {
    return '$param је почео са приказивањем';
  }

  @override
  String get averageElo => 'Просечан рејтинг';

  @override
  String get location => 'Локација';

  @override
  String get filterGames => 'Филтрирај партије';

  @override
  String get reset => 'Ресетуј';

  @override
  String get apply => 'Примени';

  @override
  String get save => 'Сачувај';

  @override
  String get leaderboard => 'Табела';

  @override
  String get screenshotCurrentPosition => 'Сними тренутну позицију';

  @override
  String get gameAsGIF => 'Партију као ГИФ';

  @override
  String get pasteTheFenStringHere => 'Убаци FEN текст овде';

  @override
  String get pasteThePgnStringHere => 'Убаци PGN текст овде';

  @override
  String get orUploadPgnFile => 'Или учитај PGN фајл';

  @override
  String get fromPosition => 'Од позиције';

  @override
  String get continueFromHere => 'Настави одавде';

  @override
  String get toStudy => 'Проучи';

  @override
  String get importGame => 'Увези игру';

  @override
  String get importGameExplanation => 'Кад прекопирате партију у PGN-у, отвори се табла за поновно проигравање,\nрачунарска анализа, прозор за ћаскање и адреса странице коју можете поделити.';

  @override
  String get importGameCaveat => 'Варијације ће бити избрисане. Ако желиш да их сачуваш, увези PGN путем студије.';

  @override
  String get importGameDataPrivacyWarning => 'Овај PGN је јавно доступан. Ако желиш да партију увезеш као приватну, користи студију.';

  @override
  String get thisIsAChessCaptcha => 'Ово је шаховска CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Кликни на таблу и направи потез да би доказао да си човек.';

  @override
  String get captcha_fail => 'Решите CAPTCHA шаховски проблем.';

  @override
  String get notACheckmate => 'Није шахмат';

  @override
  String get whiteCheckmatesInOneMove => 'Бели матирау једном потезу';

  @override
  String get blackCheckmatesInOneMove => 'Црни матирау једном потезу';

  @override
  String get retry => 'Покушај поново';

  @override
  String get reconnecting => 'Поновно повезивање';

  @override
  String get noNetwork => 'Ван мреже';

  @override
  String get favoriteOpponents => 'Омиљени противници';

  @override
  String get follow => 'Прати';

  @override
  String get following => 'Праћен';

  @override
  String get unfollow => 'Не прати';

  @override
  String followX(String param) {
    return 'Прати $param';
  }

  @override
  String unfollowX(String param) {
    return 'Престани да пратиш $param';
  }

  @override
  String get block => 'Блокирај';

  @override
  String get blocked => 'Блокиран';

  @override
  String get unblock => 'Одблокирај';

  @override
  String get followsYou => 'Прате тебе';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 је почео/ла пратити $param2';
  }

  @override
  String get more => 'Више';

  @override
  String get memberSince => 'Члан од';

  @override
  String lastSeenActive(String param) {
    return 'Последња посета $param';
  }

  @override
  String get player => 'Играч';

  @override
  String get list => 'Списак';

  @override
  String get graph => 'Графикон';

  @override
  String get required => 'Обавезно.';

  @override
  String get openTournaments => 'Отворени турнири';

  @override
  String get duration => 'Трајање';

  @override
  String get winner => 'Победник';

  @override
  String get standing => 'Позиција';

  @override
  String get createANewTournament => 'Направите нови турнир';

  @override
  String get tournamentCalendar => 'Календар турнира';

  @override
  String get conditionOfEntry => 'Услови за улаз:';

  @override
  String get advancedSettings => 'Напредна подешавања';

  @override
  String get safeTournamentName => 'Изаберите веома сигурно име за турнир.';

  @override
  String get inappropriateNameWarning => 'Било које име које је бар мало неприкладно може да вам затвори налог.';

  @override
  String get emptyTournamentName => 'Оставите празно како би назвали турнир по насумично изабраном Велемајстору.';

  @override
  String get makePrivateTournament => 'Учини турнир приватним и ограничи приступ са шифром';

  @override
  String get join => 'Придружи се';

  @override
  String get withdraw => 'Повуци се';

  @override
  String get points => 'Поена';

  @override
  String get wins => 'Победа';

  @override
  String get losses => 'Пораза';

  @override
  String get createdBy => 'Направио/ла:';

  @override
  String get tournamentIsStarting => 'Турнир почиње';

  @override
  String get tournamentPairingsAreNowClosed => 'Упаривање за турнир је заустављено.';

  @override
  String standByX(String param) {
    return 'Стрпи се $param, упарујемо играче, будите спремни!';
  }

  @override
  String get pause => 'Заустави';

  @override
  String get resume => 'Настаби';

  @override
  String get youArePlaying => 'Играш на турниру!';

  @override
  String get winRate => 'Проценат победа';

  @override
  String get berserkRate => 'Проценат лудила';

  @override
  String get performance => 'Перформанса';

  @override
  String get tournamentComplete => 'Турнир завршен';

  @override
  String get movesPlayed => 'Одиграно потеза';

  @override
  String get whiteWins => 'Победе као бели';

  @override
  String get blackWins => 'Победе као црни';

  @override
  String get drawRate => 'Проценат ремија';

  @override
  String get draws => 'Ремија';

  @override
  String nextXTournament(String param) {
    return 'Следећи $param турнир:';
  }

  @override
  String get averageOpponent => 'Просечан противник';

  @override
  String get boardEditor => 'Уређивач табле';

  @override
  String get setTheBoard => 'Постави таблу';

  @override
  String get popularOpenings => 'Популарна отварања';

  @override
  String get endgamePositions => 'Позиције у завршници';

  @override
  String chess960StartPosition(String param) {
    return 'Почетна позиција за шах960: $param';
  }

  @override
  String get startPosition => 'Почетна позиција';

  @override
  String get clearBoard => 'Уклони фигуре';

  @override
  String get loadPosition => 'Учитај позицију';

  @override
  String get isPrivate => 'Приватно';

  @override
  String reportXToModerators(String param) {
    return 'Пријави $param модераторима';
  }

  @override
  String profileCompletion(String param) {
    return 'Комплетност профила: $param';
  }

  @override
  String xRating(String param) {
    return '$param рејтинг';
  }

  @override
  String get ifNoneLeaveEmpty => 'Ако немате рејтинг, оставите празно';

  @override
  String get profile => 'Профил';

  @override
  String get editProfile => 'Уредите профил';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Постави своју значку';

  @override
  String get flair => 'Значка';

  @override
  String get youCanHideFlair => 'Постоји подешавање којим се сакривају све корисникове значке на читавом сајту.';

  @override
  String get biography => 'Биографија';

  @override
  String get countryRegion => 'Земља или регион';

  @override
  String get thankYou => 'Хвала!';

  @override
  String get socialMediaLinks => 'Линкови за социјалне медије';

  @override
  String get oneUrlPerLine => 'Један УРЛ по линији.';

  @override
  String get inlineNotation => 'Нотација у реду';

  @override
  String get makeAStudy => 'Како би сачувао и делио, размисли о томе да направиш студију.';

  @override
  String get clearSavedMoves => 'Уклони потезе';

  @override
  String get previouslyOnLichessTV => 'Претходно на Личес ТВ';

  @override
  String get onlinePlayers => 'Играчи на мрежи';

  @override
  String get activePlayers => 'Активни играчи';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Пажња, партија је рангирана али се не игра на време!';

  @override
  String get success => 'Успешно';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Аутоматско пребацивање у следећу партију после потеза';

  @override
  String get autoSwitch => 'Аутоматско пребацивање';

  @override
  String get puzzles => 'Проблеми';

  @override
  String get onlineBots => 'Онлајн ботови';

  @override
  String get name => 'Назив';

  @override
  String get description => 'Опис';

  @override
  String get descPrivate => 'Приватни опис';

  @override
  String get descPrivateHelp => 'Текст који ће само чланови тима видети. Ако је подешено, мења јавни опис за чланове тима.';

  @override
  String get no => 'Не';

  @override
  String get yes => 'Да';

  @override
  String get help => 'Помоћ';

  @override
  String get createANewTopic => 'Направиte нову тему';

  @override
  String get topics => 'Теме';

  @override
  String get posts => 'Објавe';

  @override
  String get lastPost => 'Последња објава';

  @override
  String get views => 'Прегледa';

  @override
  String get replies => 'Одговори';

  @override
  String get replyToThisTopic => 'Одговори на ову тему';

  @override
  String get reply => 'Одговор';

  @override
  String get message => 'Порука';

  @override
  String get createTheTopic => 'Cтвори тему';

  @override
  String get reportAUser => 'Пријавиte корисника';

  @override
  String get user => 'Корисник';

  @override
  String get reason => 'Разлог';

  @override
  String get whatIsIheMatter => 'Y чему је проблем?';

  @override
  String get cheat => 'Варање';

  @override
  String get troll => 'Трол';

  @override
  String get other => 'Остало';

  @override
  String get reportDescriptionHelp => 'Залијепите везу до игре и објасните шта није у реду са понашањем корисника. Немојте само рећи \"варао\", али реците како сте дошли до тог закључка. Ваша пријава ће бити обрађена брже ако је напишете на енглеском језику.';

  @override
  String get error_provideOneCheatedGameLink => 'Наведите барем једну везу игре у којој је играч варао.';

  @override
  String by(String param) {
    return 'од $param';
  }

  @override
  String importedByX(String param) {
    return 'Увезао $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Ова тема је сада затворена';

  @override
  String get blog => 'Блог';

  @override
  String get notes => 'Белешке';

  @override
  String get typePrivateNotesHere => 'Овде напишите приватне белешке';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Направи приватну белешку о овом кориснику';

  @override
  String get noNoteYet => 'Још нема никаквих белешки';

  @override
  String get invalidUsernameOrPassword => 'Неисправно корисничко име или лозинка';

  @override
  String get incorrectPassword => 'погрешна лозинка';

  @override
  String get invalidAuthenticationCode => 'Неважећи аутентикациони код';

  @override
  String get emailMeALink => 'Пошаљи ми емаил';

  @override
  String get currentPassword => 'Тренутна лозинка';

  @override
  String get newPassword => 'Нова лозинка';

  @override
  String get newPasswordAgain => 'Понови нову лозинку';

  @override
  String get newPasswordsDontMatch => 'Нове лозинке се не подударају';

  @override
  String get newPasswordStrength => 'Јачина лозинке';

  @override
  String get clockInitialTime => 'Почетно време на сату';

  @override
  String get clockIncrement => 'Повећање времена';

  @override
  String get privacy => 'Приватност';

  @override
  String get privacyPolicy => 'Политика приватности';

  @override
  String get letOtherPlayersFollowYou => 'Допустите да вас други играчи прате';

  @override
  String get letOtherPlayersChallengeYou => 'Допустите да вас други играчи изазову';

  @override
  String get letOtherPlayersInviteYouToStudy => 'дозволи другим играчима да те позову на проблем';

  @override
  String get sound => 'Звук';

  @override
  String get none => 'Нема';

  @override
  String get fast => 'Брзо';

  @override
  String get normal => 'Нормално';

  @override
  String get slow => 'Споро';

  @override
  String get insideTheBoard => 'Унутар табле';

  @override
  String get outsideTheBoard => 'Ван табле';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'У споријим партијама';

  @override
  String get always => 'Увек';

  @override
  String get never => 'Никада';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 се такмичи у $param2';
  }

  @override
  String get victory => 'Победа';

  @override
  String get defeat => 'Пораз';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 против $param2 у $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 против $param2 у $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 против $param2 у $param3';
  }

  @override
  String get timeline => 'Временска линија';

  @override
  String get starting => 'Почиње:';

  @override
  String get allInformationIsPublicAndOptional => 'Све информације су јавне и по избору';

  @override
  String get biographyDescription => 'Кажи нешто о себи, зашто волиш шах, која су ти омиљена отварања, партије, играчи…';

  @override
  String get listBlockedPlayers => 'Списак играча које сте блокирали';

  @override
  String get human => 'Човек';

  @override
  String get computer => 'Рачунар';

  @override
  String get side => 'Страна';

  @override
  String get clock => 'Сат';

  @override
  String get opponent => 'Противник';

  @override
  String get learnMenu => 'учи';

  @override
  String get studyMenu => 'Проучи';

  @override
  String get practice => 'Вежбање';

  @override
  String get community => 'Заједница';

  @override
  String get tools => 'Алати';

  @override
  String get increment => 'додатак';

  @override
  String get error_unknown => 'Неправилна вредност';

  @override
  String get error_required => 'Ово поље морате попунити';

  @override
  String get error_email => 'Ова Е-пошта адреса је погрешна';

  @override
  String get error_email_acceptable => 'Ова мејл адреса је неодговарајућа. Молим те провери и пробај поново.';

  @override
  String get error_email_unique => 'Мејл адреса је погрешна или већ заузета';

  @override
  String get error_email_different => 'Ово је већ твоја мејл адреса';

  @override
  String error_minLength(String param) {
    return 'Мора имати барем $param знакова';
  }

  @override
  String error_maxLength(String param) {
    return 'Мора имати највише $param знакова';
  }

  @override
  String error_min(String param) {
    return 'Мора бити најманје $param';
  }

  @override
  String error_max(String param) {
    return 'Мора бити манје или једнако $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Ако je рејтинг ± $param';
  }

  @override
  String get ifRegistered => 'Само регистровани';

  @override
  String get onlyExistingConversations => 'Само постојећи разговори';

  @override
  String get onlyFriends => 'Само пријатељи';

  @override
  String get menu => 'Опције';

  @override
  String get castling => 'Рокада';

  @override
  String get whiteCastlingKingside => 'Бели O-O';

  @override
  String get blackCastlingKingside => 'Црни O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Време проведено: $param';
  }

  @override
  String get watchGames => 'Посматрај партије';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Време на TV: $param';
  }

  @override
  String get watch => 'Посматрај';

  @override
  String get videoLibrary => 'Видео библиотека';

  @override
  String get streamersMenu => 'Стримери';

  @override
  String get mobileApp => 'Апликација за телефон';

  @override
  String get webmasters => 'Вебмастери';

  @override
  String get about => 'О нама';

  @override
  String aboutX(String param) {
    return 'О $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 је бесплатан ($param2), слободан, без реклама, шаховски сервер са отвореним изворним кодом.';
  }

  @override
  String get really => 'стварно';

  @override
  String get contribute => 'Допринос';

  @override
  String get termsOfService => 'Услови коришћења услуге';

  @override
  String get sourceCode => 'Изворни код';

  @override
  String get simultaneousExhibitions => 'Симултанке';

  @override
  String get host => 'Домаћин';

  @override
  String hostColorX(String param) {
    return 'Боја приређивача: $param';
  }

  @override
  String get yourPendingSimuls => 'Незавршене симултанке';

  @override
  String get createdSimuls => 'Недавно креиране симултанке';

  @override
  String get hostANewSimul => 'Покрени нову симултанку';

  @override
  String get signUpToHostOrJoinASimul => 'Пријави се да би организовао или учествовао у симултанци';

  @override
  String get noSimulFound => 'Симултанка није пронађена';

  @override
  String get noSimulExplanation => 'Симултанка не постоји';

  @override
  String get returnToSimulHomepage => 'Врати се на почетну страну';

  @override
  String get aboutSimul => 'Cимултанке укључује једног играча који игра против више противника одједном.';

  @override
  String get aboutSimulImage => 'ОД 50 противника, Фишер је победио 47, ремизирао са 2, а изгубио од једног';

  @override
  String get aboutSimulRealLife => 'Идеја је преузета из стварног живота. У стварном животу, ово укључује домаћин симултанке који иде од табле до табле да би се одиграо појединачни потез.';

  @override
  String get aboutSimulRules => 'Када симултанка започне, сваки играч започиње партију против домаћина, који добија беле фигуре. Cимултанка завршава када су и све партије завршене.';

  @override
  String get aboutSimulSettings => 'Симултанке су увек неформалне, враћање потеза и додавање времена је онемогућено.';

  @override
  String get create => 'Креирај';

  @override
  String get whenCreateSimul => 'Када креираш симултанку, играш против више играча истовремено.';

  @override
  String get simulVariantsHint => 'Ако изабереш неколико варијанти, сваки играч је у могућности да изабере коју ће играти.';

  @override
  String get simulClockHint => 'Фишерово подешавање сата. Што више играча примиш, више времена ће ти бити потребно.';

  @override
  String get simulAddExtraTime => 'Можеш додати додатно време на свој сат да ти помогне савладати симултанку.';

  @override
  String get simulHostExtraTime => 'Додатно време домаћина';

  @override
  String get simulAddExtraTimePerPlayer => 'Додај почетно време на свом сату за сваког играча који учествује у симултанци.';

  @override
  String get simulHostExtraTimePerPlayer => 'Додатно време домаћину за сваког играча против којег игра';

  @override
  String get lichessTournaments => 'Личес турнири';

  @override
  String get tournamentFAQ => 'Најчешће постављена питања за арена турнире';

  @override
  String get timeBeforeTournamentStarts => 'Време пре него турнир започне.';

  @override
  String get averageCentipawnLoss => 'Просечни губитак у стотим деловима пешака';

  @override
  String get accuracy => 'Прецизност';

  @override
  String get keyboardShortcuts => 'Скраћенице на тастатури';

  @override
  String get keyMoveBackwardOrForward => 'иди назад/напред';

  @override
  String get keyGoToStartOrEnd => 'иди на почетак/крај';

  @override
  String get keyCycleSelectedVariation => 'Излистај одабрану варијанту';

  @override
  String get keyShowOrHideComments => 'покажи/сакриј коментаре';

  @override
  String get keyEnterOrExitVariation => 'отвори/затвори варијанту';

  @override
  String get keyRequestComputerAnalysis => 'Затражите компјутерску анализу, научите из својих грешака';

  @override
  String get keyNextLearnFromYourMistakes => 'Даље (Учите из својих грешака)';

  @override
  String get keyNextBlunder => 'Следећа тешка грешка';

  @override
  String get keyNextMistake => 'Следећа грешка';

  @override
  String get keyNextInaccuracy => 'Следећа непрецизност';

  @override
  String get keyPreviousBranch => 'Претходна грана';

  @override
  String get keyNextBranch => 'Следећа грана';

  @override
  String get toggleVariationArrows => 'Приказивање стрелица за варијације';

  @override
  String get cyclePreviousOrNextVariation => 'Тренутна/претходна варијација';

  @override
  String get toggleGlyphAnnotations => 'Анотација потеза';

  @override
  String get togglePositionAnnotations => 'Анотација позиције';

  @override
  String get variationArrowsInfo => 'Стрелице за варијације вам омогућавају да се крећете без коришћења листе за померање.';

  @override
  String get playSelectedMove => 'игра изабрани потез';

  @override
  String get newTournament => 'Нови турнир';

  @override
  String get tournamentHomeTitle => 'Шаховски турнир који комбинује различита временска ограничења и варијанте';

  @override
  String get tournamentHomeDescription => 'Играјте брзи турнир у шаху! Придружите се званичном организованом турниру или направите свој. Буллет, Блитз, Цлассицал, Цхесс960, Кинг оф тхе Хилл, Тхреецхецк и друге опције су доступне за неограничену шаховску забаву.';

  @override
  String get tournamentNotFound => 'Турнир није пронађен';

  @override
  String get tournamentDoesNotExist => 'Овај турнир не постоји.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Можда је отказан зато што су играчи напустили турнир пре његовог почетка';

  @override
  String get returnToTournamentsHomepage => 'Вратите се на почетну страницу \"турнири\"';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Месечна $param дитрибуција рејтинга';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'твоје $param1 рејтинг је $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'ви сте бољи од $param1 од $param2 играча.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 је бољи од $param2 играча $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Боље од $param1 од $param2 играча';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Немате утврђен $param рејтинг.';
  }

  @override
  String get yourRating => 'Ваш рејтинг';

  @override
  String get cumulative => 'Кумулативно';

  @override
  String get glicko2Rating => 'Glicko-2 рејтинг';

  @override
  String get checkYourEmail => 'Проверите е-пошту.';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Послали смо вам е-маил. Кликните на линк да бисте активирали вашу рачун.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ако не видите е-пошту у пријемном сандучету, проверите је у другим местима (датотекама): Јунк, Социал.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Послали смо Вам е-поруку на $param. Кликните на дати линк да промените Вашу лозинку.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Registracijom prihvatate ograničenja predviđe našim $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Прочитајте о нашем $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Мрежно кашњење између вас и Лицхесса';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Време потребно за процесирање на Лицхесс серверу';

  @override
  String get downloadAnnotated => 'Преузимање белешки.';

  @override
  String get downloadRaw => 'Преузмите игру ПГН без ноте за Лицхесс';

  @override
  String get downloadImported => 'Увезено преузимање';

  @override
  String get crosstable => 'Упоредни преглед';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Можете скроловати преко табле ради повлачења потеза у партији.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scroll over computer variations to preview them.';

  @override
  String get analysisShapesHowTo => 'Pитисните shif-click или десни клик за цртање кругова и стрелица на плочи.';

  @override
  String get letOtherPlayersMessageYou => 'Дозволите другим играчима да вам пошаљу поруку';

  @override
  String get receiveForumNotifications => 'Receive notifications when mentioned in the forum';

  @override
  String get shareYourInsightsData => 'Поделите своје личне податке';

  @override
  String get withNobody => 'Нисаким';

  @override
  String get withFriends => 'Са пријатељима';

  @override
  String get withEverybody => 'Са свима';

  @override
  String get kidMode => 'Дечји начин';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Ово је око сигурности. У дечијем моду, све комуникације на сајту су искључене. Укључите ово за вашу децу и ђаке, да их заштитите од других корисника интернета.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'У дечијем моду, логотип личеса добија $param икону, да би знали да су ваша деца сигурна.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'Омогућите Дечији режим рада';

  @override
  String get disableKidMode => 'Онемогућите Дечији режим рада';

  @override
  String get security => 'Сигурност';

  @override
  String get sessions => 'Сесије';

  @override
  String get revokeAllSessions => 'опозвати све сесије';

  @override
  String get playChessEverywhere => 'Играј шах свуда';

  @override
  String get asFreeAsLichess => 'Бесплатно као лицхесс';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Од љубави до шаха, а не од новца';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Сви добијају све функције бесплатно';

  @override
  String get zeroAdvertisement => 'Без огласа';

  @override
  String get fullFeatured => 'Потпуно опремљен';

  @override
  String get phoneAndTablet => 'Телефон или таблет';

  @override
  String get bulletBlitzClassical => 'Булит, Блиц, Класична';

  @override
  String get correspondenceChess => 'Дописни шах';

  @override
  String get onlineAndOfflinePlay => 'Играјте онлине и оффлине';

  @override
  String get viewTheSolution => 'Погледај решење';

  @override
  String get followAndChallengeFriends => 'Прати и изазови пријатеља';

  @override
  String get gameAnalysis => 'Анализа партије';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 домаћини $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 учествује у $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 каже да му се свиђа $param2';
  }

  @override
  String get quickPairing => 'Брзо упаривање';

  @override
  String get lobby => 'Лоби';

  @override
  String get anonymous => 'Непознати играч';

  @override
  String yourScore(String param) {
    return 'Ваш резултат: $param';
  }

  @override
  String get language => 'Језик';

  @override
  String get background => 'Позадина';

  @override
  String get light => 'Светла';

  @override
  String get dark => 'Тамна';

  @override
  String get transparent => 'Прозирна';

  @override
  String get deviceTheme => 'Device theme';

  @override
  String get backgroundImageUrl => 'УРЛ слике позадине:';

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
  String get pieceSet => 'Скуп фигура';

  @override
  String get embedInYourWebsite => 'Угради у свој сајт';

  @override
  String get usernameAlreadyUsed => 'Ово корисничко име је у употреби, изаберите неко друго.';

  @override
  String get usernamePrefixInvalid => 'Корисничко име мора да почне са словом.';

  @override
  String get usernameSuffixInvalid => 'Корисничко име мора да заврши са словом или бројем.';

  @override
  String get usernameCharsInvalid => 'Корисничко име може само да садржи слова, бројеве, доње црте и цртице.';

  @override
  String get usernameUnacceptable => 'Ово корисничко име није прихватљиво.';

  @override
  String get playChessInStyle => 'Играјте шах у стилу';

  @override
  String get chessBasics => 'Основе шаха';

  @override
  String get coaches => 'Тренери';

  @override
  String get invalidPgn => 'Неважећи PGN';

  @override
  String get invalidFen => 'Неважећи FEN';

  @override
  String get custom => 'Прилагођено';

  @override
  String get notifications => 'Обавештења';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Рејтинг: $param';
  }

  @override
  String get practiceWithComputer => 'Тренирај са компјутером';

  @override
  String anotherWasX(String param) {
    return 'Још једно је $param';
  }

  @override
  String bestWasX(String param) {
    return 'Најбољи је $param';
  }

  @override
  String get youBrowsedAway => 'Отишли сте са овог екрана';

  @override
  String get resumePractice => 'Настави тренинг';

  @override
  String get drawByFiftyMoves => 'The game has been drawn by the fifty move rule.';

  @override
  String get theGameIsADraw => 'Партија је нерешена.';

  @override
  String get computerThinking => 'Компјутер мисли ...';

  @override
  String get seeBestMove => 'Погледајте најбољи потез';

  @override
  String get hideBestMove => 'Сакријте најбољи потез';

  @override
  String get getAHint => 'Добиј те помоћ';

  @override
  String get evaluatingYourMove => 'Процењивање вашег потеза ...';

  @override
  String get whiteWinsGame => 'Бели је победио';

  @override
  String get blackWinsGame => 'Црни је победио';

  @override
  String get learnFromYourMistakes => 'Научите из грешака';

  @override
  String get learnFromThisMistake => 'Научите из ове грешке';

  @override
  String get skipThisMove => 'Прескочите овај потез';

  @override
  String get next => 'Следеће';

  @override
  String xWasPlayed(String param) {
    return '$param је одиграно';
  }

  @override
  String get findBetterMoveForWhite => 'Нађите бољи потез за белог';

  @override
  String get findBetterMoveForBlack => 'Нађите бољи потез за црног';

  @override
  String get resumeLearning => 'Наставите са учењем';

  @override
  String get youCanDoBetter => 'Можете то боље';

  @override
  String get tryAnotherMoveForWhite => 'Покушајте други потез за белог';

  @override
  String get tryAnotherMoveForBlack => 'Покушајте други потез за црног';

  @override
  String get solution => 'Решење';

  @override
  String get waitingForAnalysis => 'Чекање на анализу';

  @override
  String get noMistakesFoundForWhite => 'Нема грешке нађене за белог';

  @override
  String get noMistakesFoundForBlack => 'Нема грешке нађене за црног';

  @override
  String get doneReviewingWhiteMistakes => 'Завршено прегледање белих грешака';

  @override
  String get doneReviewingBlackMistakes => 'Завршено прегледање црних грешака';

  @override
  String get doItAgain => 'Урадите поново';

  @override
  String get reviewWhiteMistakes => 'Пронађите грешке белог';

  @override
  String get reviewBlackMistakes => 'Пронађите грешке црног';

  @override
  String get advantage => 'Предност';

  @override
  String get opening => 'Отварање';

  @override
  String get middlegame => 'Средишњица';

  @override
  String get endgame => 'Завршница';

  @override
  String get conditionalPremoves => 'Условни пре-потези';

  @override
  String get addCurrentVariation => 'Додајте тренутну варијацију';

  @override
  String get playVariationToCreateConditionalPremoves => 'Играјте варијацију да направите условне пре-потезе';

  @override
  String get noConditionalPremoves => 'Нема условних пре-потеза';

  @override
  String playX(String param) {
    return 'Играј $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Извините :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Морали смо Вас привремено избацити.';

  @override
  String get why => 'Зашто?';

  @override
  String get pleasantChessExperience => 'Желимо да свима обезбедимо пријатно искуство у шаху.';

  @override
  String get goodPractice => 'Баш због тога, ми се морамо потрудити да се сви играчи држе добре праксе.';

  @override
  String get potentialProblem => 'Када је потенцијални проблем детектован, ми прикажемо ову поруку.';

  @override
  String get howToAvoidThis => 'Како ово избећи?';

  @override
  String get playEveryGame => 'Одиграј сваку партију коју започнеш.';

  @override
  String get tryToWin => 'Пробај да победиш (или барем изједначиш) сваку партију коју одиграш.';

  @override
  String get resignLostGames => 'Предај изгубљене игре (немој пуштати да време истекне).';

  @override
  String get temporaryInconvenience => 'Извињавамо се на привременој нелагодности,';

  @override
  String get wishYouGreatGames => 'и желимо вам одличне партије на lichess.org.';

  @override
  String get thankYouForReading => 'Хвала на читању!';

  @override
  String get lifetimeScore => 'Животни скор';

  @override
  String get currentMatchScore => 'Скор тренутног меча';

  @override
  String get agreementAssistance => 'Слажем се да никада нећу добијати помоћ током својих игара (од стране шаховског рачунара, књиге, базе података или неке друге особе).';

  @override
  String get agreementNice => 'Слажем се да ћу увек бити пун поштовања према другим играчима.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'I agree that I will not create multiple accounts (except for the reasons stated in the $param).';
  }

  @override
  String get agreementPolicy => 'Слажем се да ћу поштовати све Личес полисе.';

  @override
  String get searchOrStartNewDiscussion => 'Претражи или започни нови разговор';

  @override
  String get edit => 'Промени';

  @override
  String get bullet => 'Муњевити';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Брзопотез';

  @override
  String get classical => 'Класична';

  @override
  String get ultraBulletDesc => 'Лудо брзе партије: испод 30 секунди';

  @override
  String get bulletDesc => 'Веома брзе партије: испод 3 минута';

  @override
  String get blitzDesc => 'Брзе партије: 3 до 8 минута';

  @override
  String get rapidDesc => 'Убрзане партије: 8 до 25 минута';

  @override
  String get classicalDesc => 'Класичне партије: 25 минута и више';

  @override
  String get correspondenceDesc => 'Дописна парија: један или више дана по потезу';

  @override
  String get puzzleDesc => 'Шаховски тренер тактике';

  @override
  String get important => 'Важно';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Ваше питање можда већ има одговор $param1';
  }

  @override
  String get inTheFAQ => 'у често постављеним питањима (F.A.Q.)';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Да бисте пријавили корисника због варања или лошег понашања, $param1';
  }

  @override
  String get useTheReportForm => 'користите образац за пријаву';

  @override
  String toRequestSupport(String param1) {
    return 'Да бисте затражили подршку, $param1';
  }

  @override
  String get tryTheContactPage => 'пробајте страницу за контакт';

  @override
  String makeSureToRead(String param1) {
    return 'Make sure to read $param1';
  }

  @override
  String get theForumEtiquette => 'the forum etiquette';

  @override
  String get thisTopicIsArchived => 'Ова тема је архивирана и не може се више одговорити на њу.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Придружите се $param1, да бисте могли писати поруке у овоме форуму';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 тим';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Још увек не можете писати поруке на овај форум. Играјте још коју партију!';

  @override
  String get subscribe => 'Претплати се';

  @override
  String get unsubscribe => 'Одјавите претплату';

  @override
  String mentionedYouInX(String param1) {
    return 'mentioned you in \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 mentioned you in \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'invited you to \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 invited you to \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Сада си део тима.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'You have joined \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Someone you reported was banned';

  @override
  String get congratsYouWon => 'Честитамо на победи!';

  @override
  String gameVsX(String param1) {
    return 'Партија против $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 против $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'You lost rating points to someone who violated the Lichess TOS';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Враћено: $param1 $param2 рејтингових поена.';
  }

  @override
  String get timeAlmostUp => 'Време ускоро изтиче!';

  @override
  String get clickToRevealEmailAddress => '[Click to reveal email address]';

  @override
  String get download => 'Преузми';

  @override
  String get coachManager => 'Coach manager';

  @override
  String get streamerManager => 'Streamer manager';

  @override
  String get cancelTournament => 'Cancel the tournament';

  @override
  String get tournDescription => 'Tournament description';

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
  String get simulHostcolor => 'Које фигуре има домаћин за сваку партију';

  @override
  String get estimatedStart => 'Очекивано време почетка';

  @override
  String simulFeatured(String param) {
    return 'Прикажи на $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Покажи своју симултанку свима на $param. Онемогући за приватне симултанке.';
  }

  @override
  String get simulDescription => 'Опис симултанке';

  @override
  String get simulDescriptionHelp => 'Желиш ли нешто да саопштиш учесницима?';

  @override
  String markdownAvailable(String param) {
    return '$param је на располагању за напреднију синтаксу.';
  }

  @override
  String get embedsAvailable => 'Убаци URL партије или поглавља студије.';

  @override
  String get inYourLocalTimezone => 'Према твојој локалној временској зони';

  @override
  String get tournChat => 'Чет на турниру';

  @override
  String get noChat => 'Нема чета';

  @override
  String get onlyTeamLeaders => 'Само за вође тимова';

  @override
  String get onlyTeamMembers => 'Само за чланове тимова';

  @override
  String get navigateMoveTree => 'Кретање кроз листу потеза';

  @override
  String get mouseTricks => 'Покрети мишем';

  @override
  String get toggleLocalAnalysis => 'Одабери анализу на свом компјутеру';

  @override
  String get toggleAllAnalysis => 'Одабери анализу на свом компјутеру и на Lichess серверима';

  @override
  String get playComputerMove => 'Одиграј најбољи потез који сугерише компјутер';

  @override
  String get analysisOptions => 'Опције при анализи';

  @override
  String get focusChat => 'Пређи на чет';

  @override
  String get showHelpDialog => 'Прикажи овај прозор за помоћ';

  @override
  String get reopenYourAccount => 'Поново отвори свој налог';

  @override
  String get closedAccountChangedMind => 'Ако си затворио налог, али си се после предомислио, имаш једну прилику да повратиш свој налог.';

  @override
  String get onlyWorksOnce => 'Ово ће радити само једном.';

  @override
  String get cantDoThisTwice => 'Ако си затворио налог по други пут, не постоји начин да га повратиш.';

  @override
  String get emailAssociatedToaccount => 'Мејл адреса повезана са налогом';

  @override
  String get sentEmailWithLink => 'Послали смо ти мејл са линком.';

  @override
  String get tournamentEntryCode => 'Код за приступ турниру';

  @override
  String get hangOn => 'Сачекај!';

  @override
  String gameInProgress(String param) {
    return 'Твоја партија са $param је у току.';
  }

  @override
  String get abortTheGame => 'Прекину партију';

  @override
  String get resignTheGame => 'Предај партију';

  @override
  String get youCantStartNewGame => 'Не можеш започети нову партију све док ову не завршиш.';

  @override
  String get since => 'Од';

  @override
  String get until => 'До';

  @override
  String get lichessDbExplanation => 'Бодоване партије одигране на Lichess';

  @override
  String get switchSides => 'Промени страну';

  @override
  String get closingAccountWithdrawAppeal => 'Ако затвриш налог, твоја жалба ће бити поништена';

  @override
  String get ourEventTips => 'Наши савети за организовање догађаја';

  @override
  String get instructions => 'Инструкције';

  @override
  String get showMeEverything => 'Прикажи све';

  @override
  String get lichessPatronInfo => 'Lichess is a charity and entirely free/libre open source software.\nAll operating costs, development, and content are funded solely by user donations.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ваш противник је напустио игру. Победа ће Вам бити приписана за $count секунди.',
      few: 'Ваш противник је напустио игру. Победа ће Вам бити приписана за $count секунди.',
      one: 'Ваш противник је напустио игру. Победа ће Вам бити приписана за $count секунди.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мат у $count полу-потеза',
      few: 'Мат у $count полу-потеза',
      one: 'Мат у $count полу-потезу',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blunders',
      one: '$count blunder',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mistakes',
      one: '$count mistake',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count inaccuracies',
      one: '$count inaccuracy',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играча на вези',
      few: '$count играча на вези',
      one: '$count играч на вези',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count партије',
      few: '$count партије',
      one: '$count партија',
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
      other: '$count обележених игара',
      few: '$count обележених игара',
      one: '$count обележена игра',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дана',
      few: '$count дана',
      one: '$count дан',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сати',
      few: '$count сати',
      one: '$count сат',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минута',
      few: '$count минута',
      one: '$count минут',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ранг се ажурира сваких $count минута',
      few: 'Ранг се ажурира сваке $count минуте',
      one: 'Ранг се ажурира сваки минут',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тактика',
      few: '$count тактике',
      one: '$count тактика',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игара са вама',
      few: '$count игара са вама',
      one: '$count игра са вама',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рангираних',
      few: '$count рангиране',
      one: '$count рангирана',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count победа',
      few: '$count победе',
      one: '$count победа',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пораза',
      few: '$count пораза',
      one: '$count пораз',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ремија',
      few: '$count ремија',
      one: '$count реми',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играју',
      few: '$count играју',
      one: '$count игра',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Додај $count секунди',
      few: 'Додај $count секунде',
      one: 'Додај $count секунд',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поена на турнирима',
      few: '$count поена на турнирима',
      one: '$count поен на турнирима',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count студија',
      few: '$count студије',
      one: '$count студија',
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
      other: '≥ $count рангираних игара',
      few: '≥ $count рангиране игре',
      one: '≥ $count рангирана игра',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 рангираних игара',
      few: '≥ $count $param2 рангиране игре',
      one: '≥ $count $param2 рангирана игра',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Морате одиграти још $count $param2 рангираних игара',
      few: 'Морате одиграти још $count $param2 рангиране игре',
      one: 'Морате одиграти још $count $param2 рангирану игру',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Морате одиграти још $count рангираних игара',
      few: 'Морате одиграти још $count рангиране игре',
      one: 'Морате одиграти још $count рангирану игру',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count увезених игара',
      few: '$count увезене игре',
      one: '$count увезена игра',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пријатеља на мрежи',
      few: '$count пријатеља на мрежи',
      one: '$count пријатељ на мрежи',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пратиоца',
      few: '$count пратиоца',
      one: '$count пратиоц',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'прати $count',
      few: 'прати $count',
      one: 'прати $count',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мање од $count минута',
      few: 'Мање од $count минута',
      one: 'Мање од $count минут',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count партија се игра',
      few: '$count партије се играју',
      one: '$count партија се игра',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Највише: $count карактера',
      few: 'Највише: $count карактера',
      one: 'Највише: $count карактер',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count блокираних',
      few: '$count блокиранa',
      one: '$count блокиран',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count коментара на форуму',
      few: '$count коментара на форуму',
      one: '$count коментар на форуму',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 играча ове недеље.',
      few: '$count $param2 играча ове недеље.',
      one: '$count $param2 играч ове недеље.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Доступно у $count језика!',
      few: 'Доступно у $count језика!',
      one: 'Доступно у $count језику!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунди да одиграте први потез',
      few: '$count секунде да одиграте први потез',
      one: '$count секунд да одиграте први потез',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунди',
      few: '$count секунде',
      one: '$count секунд',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'и сачувај $count пре-потезних линија',
      few: 'и сачувај $count пре-потезне линије',
      one: 'и сачувај $count пре-потезну линију',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Направи потез да почнеш';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'You play the white pieces in all puzzles';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'You play the black pieces in all puzzles';

  @override
  String get stormPuzzlesSolved => 'проблема решено';

  @override
  String get stormNewDailyHighscore => 'Нови дневни рекорд!';

  @override
  String get stormNewWeeklyHighscore => 'Нови седмични рекорд!';

  @override
  String get stormNewMonthlyHighscore => 'Нови месечни рекорд!';

  @override
  String get stormNewAllTimeHighscore => 'Нови рекорд свих времена!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Претходни рекорд је био $param';
  }

  @override
  String get stormPlayAgain => 'Играј опет';

  @override
  String stormHighscoreX(String param) {
    return 'Рекорд: $param';
  }

  @override
  String get stormScore => 'Резултат';

  @override
  String get stormMoves => 'Потеза';

  @override
  String get stormAccuracy => 'Прецизност';

  @override
  String get stormCombo => 'Комбо';

  @override
  String get stormTime => 'Време';

  @override
  String get stormTimePerMove => 'Време по потезу';

  @override
  String get stormHighestSolved => 'Највиши решен';

  @override
  String get stormPuzzlesPlayed => 'Одиграни проблеми';

  @override
  String get stormNewRun => 'Нова рунда (тастер: Спејс)';

  @override
  String get stormEndRun => 'Заврши рунду (тастер: Ентер)';

  @override
  String get stormHighscores => 'Рекорди';

  @override
  String get stormViewBestRuns => 'Погледајте најбоље рунде';

  @override
  String get stormBestRunOfDay => 'Најбоља рунда дана';

  @override
  String get stormRuns => 'Рунде';

  @override
  String get stormGetReady => 'Get ready!';

  @override
  String get stormWaitingForMorePlayers => 'Waiting for more players to join...';

  @override
  String get stormRaceComplete => 'Race complete!';

  @override
  String get stormSpectating => 'Spectating';

  @override
  String get stormJoinTheRace => 'Join the race!';

  @override
  String get stormStartTheRace => 'Start the race';

  @override
  String stormYourRankX(String param) {
    return 'Your rank: $param';
  }

  @override
  String get stormWaitForRematch => 'Wait for rematch';

  @override
  String get stormNextRace => 'Next race';

  @override
  String get stormJoinRematch => 'Join rematch';

  @override
  String get stormWaitingToStart => 'Waiting to start';

  @override
  String get stormCreateNewGame => 'Create a new game';

  @override
  String get stormJoinPublicRace => 'Join a public race';

  @override
  String get stormRaceYourFriends => 'Race your friends';

  @override
  String get stormSkip => 'skip';

  @override
  String get stormSkipHelp => 'You can skip one move per race:';

  @override
  String get stormSkipExplanation => 'Skip this move to preserve your combo! Only works once per race.';

  @override
  String get stormFailedPuzzles => 'Failed puzzles';

  @override
  String get stormSlowPuzzles => 'Slow puzzles';

  @override
  String get stormSkippedPuzzle => 'Skipped puzzle';

  @override
  String get stormThisWeek => 'This week';

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
      other: '$count рунди',
      few: '$count рунде',
      one: '1 рунда',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Одиграли $count рунди $param2-а',
      few: 'Одиграли $count рунде $param2-а',
      one: 'Одиграли једну рунду $param2-а',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Личес стримери';

  @override
  String get studyShareAndExport => 'Подели и извези';

  @override
  String get studyStart => 'Започни';
}
