import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Macedonian (`mk`).
class AppLocalizationsMk extends AppLocalizations {
  AppLocalizationsMk([String locale = 'mk']) : super(locale);

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
  String get activityHostedALiveStream => 'Емитуваше во живо';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Ранг #$param1 во $param2';
  }

  @override
  String get activitySignedUp => 'Се регистрираше на lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ја поддржуваше lichess.org $count месеци како $param2',
      one: 'Ја поддржуваше lichess.org $count месец како $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вежбаше $count позиции на $param2',
      one: 'Вежбаше $count позиција на $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Реши $count тактички загатки',
      one: 'Реши $count тактичка загатка',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Одигра $count $param2 игри',
      one: 'Одигра $count „$param2“ игра',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Напиша $count пораки во $param2',
      one: 'Напиша $count порака во $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изигра $count потези',
      one: 'Изигра $count потег',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'во $count дописни партии',
      one: 'во $count дописна партија',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изигра $count дописни игри',
      one: 'Изигра $count дописна игра',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Заследи $count играчи',
      one: 'Заследи $count играч',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Стекна $count нови следачи',
      one: 'Стекна $count нов следач',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Организираше $count симултани партии',
      one: 'Организираше $count симултана партија',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Учествуваше во $count симултани партији',
      one: 'Учествуваше во $count симултана партија',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Создаде $count нови студии',
      one: 'Создаде $count нова студија',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Учествуваше во $count турнири',
      one: 'Учествуваше во $count турнир',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Рангиран #$count (топ $param2%) со $param3 игри во $param4',
      one: 'Рангиран #$count (топ $param2%) со $param3 игра во $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Се натпреварувал во $count швајцарски турнири',
      one: 'Се натпреварувал во $count швајцарски турнир',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Се придружи на $count тимови',
      one: 'Се придружи на $count тим',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Емитувања';

  @override
  String get broadcastLiveBroadcasts => 'Пренос на турнири во живо';

  @override
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Предизвикај на Игра';

  @override
  String get challengeChallengeDeclined => 'Предизвикот е одбиен';

  @override
  String get challengeChallengeAccepted => 'Предизвикот е прифатен!';

  @override
  String get challengeChallengeCanceled => 'Предизвикот е откажан.';

  @override
  String get challengeRegisterToSendChallenges => 'Ве молиме регистрирајте се за испраќање предизвици.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Не можете да го предизвикате $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param не прифаќа предизвици.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Вашиот $param1 рејтинг е многу поголем од $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Не можеш да го предизвикаш на игра поради привремениот $param рејтинг.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param прифаќа само предизвици од пријатели.';
  }

  @override
  String get challengeDeclineGeneric => 'Не прифаќам предизвици во моментов.';

  @override
  String get challengeDeclineLater => 'Во моментов не можам да прифатам, ве молам пробајте повторно подоцна.';

  @override
  String get challengeDeclineTooFast => 'Овој временски формат е многу брз за мене, те молам предизвикај ме на побавна игра.';

  @override
  String get challengeDeclineTooSlow => 'Овој временски формат е многу бавен за мене, те молам предизвикај ме на побрза игра.';

  @override
  String get challengeDeclineTimeControl => 'Не прифаќам предизвици со овој временски формат.';

  @override
  String get challengeDeclineRated => 'Ве молам испратете ми покана за рангиран предизвик.';

  @override
  String get challengeDeclineCasual => 'Ве молам испратете ми покана за неформална игра.';

  @override
  String get challengeDeclineStandard => 'Во моментов не прифаќам варијантни предизвици.';

  @override
  String get challengeDeclineVariant => 'Во моментов не сакам да ја играм оваа варијација.';

  @override
  String get challengeDeclineNoBot => 'Не прифаќам предизвици од ботови.';

  @override
  String get challengeDeclineOnlyBot => 'Прифаќам предизвици само од ботови.';

  @override
  String get challengeInviteLichessUser => 'Or invite a Lichess user:';

  @override
  String get contactContact => 'Контакт';

  @override
  String get contactContactLichess => 'Контактирајте ја Lichess';

  @override
  String get patronDonate => 'Донирај';

  @override
  String get patronLichessPatron => 'Lichess подржувач';

  @override
  String perfStatPerfStats(String param) {
    return '$param статистика';
  }

  @override
  String get perfStatViewTheGames => 'Прегледај ги партиите';

  @override
  String get perfStatProvisional => 'привремен';

  @override
  String get perfStatNotEnoughRatedGames => 'Нема одиграно доволно рангирани игри за воспоставување на рејтинг.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Напредок во последните $param партии:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Девијација на рејтингот: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Пониска вредност значи дека рејтингот е постабилен. Над $param1, рејтингот се смета за привремен. За да биде вклучена во рангирањата, оваа вредност треба да биде под $param2 (класичен шах) или $param3 (варијации).';
  }

  @override
  String get perfStatTotalGames => 'Вкупно партии';

  @override
  String get perfStatRatedGames => 'Рангирани партии';

  @override
  String get perfStatTournamentGames => 'Турнирски партии';

  @override
  String get perfStatBerserkedGames => 'Берсерк парии';

  @override
  String get perfStatTimeSpentPlaying => 'Време поминато во играње';

  @override
  String get perfStatAverageOpponent => 'Просечен противник';

  @override
  String get perfStatVictories => 'Победи';

  @override
  String get perfStatDefeats => 'Порази';

  @override
  String get perfStatDisconnections => 'Прекинати партии';

  @override
  String get perfStatNotEnoughGames => 'Недоволно одиграни партии';

  @override
  String perfStatHighestRating(String param) {
    return 'Највисок рејтинг: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Најнизок рејтинг: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'од $param1 до $param2';
  }

  @override
  String get perfStatWinningStreak => 'Победничка низа';

  @override
  String get perfStatLosingStreak => 'Губитничка низа';

  @override
  String perfStatLongestStreak(String param) {
    return 'Најдолга низа: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Сегашна низа: $param';
  }

  @override
  String get perfStatBestRated => 'Најдобро рангирани победи';

  @override
  String get perfStatGamesInARow => 'Број одиграни партии во низа';

  @override
  String get perfStatLessThanOneHour => 'Помалку од еден час меѓу партии';

  @override
  String get perfStatMaxTimePlaying => 'Макс. време поминато во играње';

  @override
  String get perfStatNow => 'сега';

  @override
  String get preferencesPreferences => 'Поставки';

  @override
  String get preferencesDisplay => 'Display';

  @override
  String get preferencesPrivacy => 'Privacy';

  @override
  String get preferencesNotifications => 'Notifications';

  @override
  String get preferencesPieceAnimation => 'Анимација на фигурите';

  @override
  String get preferencesMaterialDifference => 'Материјална разлика';

  @override
  String get preferencesBoardHighlights => 'Нагласени полиња (последен потег и шах)';

  @override
  String get preferencesPieceDestinations => 'Легални потези (важечки потези и претпотези)';

  @override
  String get preferencesBoardCoordinates => 'Координати на таблата (А-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Листа на потези за време на партијата';

  @override
  String get preferencesPgnPieceNotation => 'Запишување на потезите';

  @override
  String get preferencesChessPieceSymbol => 'Симбол на фигурата';

  @override
  String get preferencesPgnLetter => 'Буква (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Зен режим';

  @override
  String get preferencesShowPlayerRatings => 'Покажи го рејтингот на играчите';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Ова овозможува да ги скриете сите рангови од веб страницата, со цел да се фокусирате на шахот. Игрите и понатаму ќе бидат рангирани, со ова само нема да можете да ги видите.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Прикажи ја рачката за промена на големината на таблата';

  @override
  String get preferencesOnlyOnInitialPosition => 'Само на почетокот на партијата';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Шаховски часовник';

  @override
  String get preferencesTenthsOfSeconds => 'Стотинки';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Кога останатото време е < 10 секунди';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Хоризонтална зелена линија за напредок';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Звук кога има преостанато малку време';

  @override
  String get preferencesGiveMoreTime => 'Додај време';

  @override
  String get preferencesGameBehavior => 'Начин на играње';

  @override
  String get preferencesHowDoYouMovePieces => 'Како да ги движите фигурите?';

  @override
  String get preferencesClickTwoSquares => 'Кликни на двете полиња';

  @override
  String get preferencesDragPiece => 'Влечи ја фигурата';

  @override
  String get preferencesBothClicksAndDrag => 'И двете';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Претпотези (играње додека противникот е на ред)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Враќање потези (со дозвола на противникот)';

  @override
  String get preferencesInCasualGamesOnly => 'Само во пријателски партии';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Автоматски унапреди во кралица';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'Кога изигрувам претпотег';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Автоматско прогласување реми по третото повторување на потегот';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Кога останатото време е < 30 секунди';

  @override
  String get preferencesMoveConfirmation => 'Потврда за потегот';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Дописен шах';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Дописен шах и неограничени партии';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Потврди предавање и понуда за реми';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Метод за рокада';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Помести го кралот две полиња';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Помести го кралот врз топот';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Внеси потези со тастатура';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Snap arrows to valid moves';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Say \"Good game, well played\" upon defeat or draw';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Вашите поставки се зачувани.';

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
  String get puzzlePuzzles => 'Загатки';

  @override
  String get puzzlePuzzleThemes => 'Категории на загатки';

  @override
  String get puzzleRecommended => 'Препорачани';

  @override
  String get puzzlePhases => 'Етапи';

  @override
  String get puzzleMotifs => 'Мотиви';

  @override
  String get puzzleAdvanced => 'Напредно';

  @override
  String get puzzleLengths => 'Должина';

  @override
  String get puzzleMates => 'Матови';

  @override
  String get puzzleGoals => 'Цели';

  @override
  String get puzzleOrigin => 'Потекло';

  @override
  String get puzzleSpecialMoves => 'Специјални потези';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Дали Ви се допадна оваа загатка?';

  @override
  String get puzzleVoteToLoadNextOne => 'Гласај и премини на наредната!';

  @override
  String get puzzleUpVote => 'Up vote puzzle';

  @override
  String get puzzleDownVote => 'Down vote puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Вашиот рејтинг нема да се промени. Имајте на ум дека загатките не се натпреварување. Вашиот рејтинг помага во изборот на најсоодветните загатки за вашата моментална вештина.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Најди го најдобриот потег на белиот.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Најди го најдобриот потег на црниот.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Персонализирани загатки:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Загатка $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Загатка на денот';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Кликни за решение';

  @override
  String get puzzleGoodMove => 'Добар потег';

  @override
  String get puzzleBestMove => 'Најдобар потег!';

  @override
  String get puzzleKeepGoing => 'Продолжи…';

  @override
  String get puzzlePuzzleSuccess => 'Успех!';

  @override
  String get puzzlePuzzleComplete => 'Загатката е решена!';

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
  String get puzzleNotTheMove => 'Неточен потег!';

  @override
  String get puzzleTrySomethingElse => 'Пробајте нешто друго.';

  @override
  String puzzleRatingX(String param) {
    return 'Рејтинг: $param';
  }

  @override
  String get puzzleHidden => 'скриен';

  @override
  String puzzleFromGameLink(String param) {
    return 'Од играта $param';
  }

  @override
  String get puzzleContinueTraining => 'Продолжи да вежбаш';

  @override
  String get puzzleDifficultyLevel => 'Ниво на тешкотија';

  @override
  String get puzzleNormal => 'Нормално';

  @override
  String get puzzleEasier => 'Полесно';

  @override
  String get puzzleEasiest => 'Најлесно';

  @override
  String get puzzleHarder => 'Потешко';

  @override
  String get puzzleHardest => 'Најтешко';

  @override
  String get puzzleExample => 'Пример';

  @override
  String get puzzleAddAnotherTheme => 'Додади нова тема';

  @override
  String get puzzleNextPuzzle => 'Next puzzle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Веднаш премини на следната загатка';

  @override
  String get puzzlePuzzleDashboard => 'Панел на загатки';

  @override
  String get puzzleImprovementAreas => 'Области за подобрување';

  @override
  String get puzzleStrengths => 'Предности';

  @override
  String get puzzleHistory => 'Историја на загатки';

  @override
  String get puzzleSolved => 'решено';

  @override
  String get puzzleFailed => 'неуспешно';

  @override
  String get puzzleStreakDescription => 'Решавајте прогресивно потешки загатки и изградете победничка серија. Нема часовник, па не брзајте. Еден погрешен потег и играта е завршена! Но, можете да прескокнете еден потег по сесија.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Вашата серија: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Прескокнете го овој потег за да ја зачувате вашата победничка серија! Дозволено само еднаш во сесија.';

  @override
  String get puzzleContinueTheStreak => 'Продолжете ја серијата';

  @override
  String get puzzleNewStreak => 'Нова серија';

  @override
  String get puzzleFromMyGames => 'Од моите игри';

  @override
  String get puzzleLookupOfPlayer => 'Пребарувај загатки од игрите на други играчи';

  @override
  String puzzleFromXGames(String param) {
    return 'Загатки од игрите на $param\'';
  }

  @override
  String get puzzleSearchPuzzles => 'Пребарувај загатки';

  @override
  String get puzzleFromMyGamesNone => 'Немате загатки во базата на податоци, но Lichess сè уште многу ве сака.\n\nИграјте брзи и класични игри за да ги зголемите шансите ваша загатка да биде додадена!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 загатки пронајдени во $param2 игри';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Вежбај, анализирај, подобри се';

  @override
  String puzzlePercentSolved(String param) {
    return '$param решени';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Нема што да се покаже овде, прво одиграјте неколку загатки!';

  @override
  String get puzzleImprovementAreasDescription => 'Вежбајте ги овие загатки за да го оптимизирате вашиот прогрес!';

  @override
  String get puzzleStrengthDescription => 'Најдобро играте во овие теми';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Одиграно $count пати',
      one: 'Одиграно $count',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поени под вашиот рејтинг',
      one: 'Еден поен под вашиот рејтинг',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поени над вашиот рејтинг',
      one: 'Еден поен над вашиот рејтинг',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count одиграни',
      one: '$count одиграна',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count прегледај',
      one: '$count прегледај',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Advanced pawn';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'One of your pawns is deep into the opponent position, maybe threatening to promote.';

  @override
  String get puzzleThemeAdvantage => 'Предност';

  @override
  String get puzzleThemeAdvantageDescription => 'Искористете ја шансата да добиете одлучувачка предност. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasia\'s mate';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'A knight and rook or queen team up to trap the opposing king between the side of the board and a friendly piece.';

  @override
  String get puzzleThemeArabianMate => 'Arabian mate';

  @override
  String get puzzleThemeArabianMateDescription => 'A knight and a rook team up to trap the opposing king on a corner of the board.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Attacking f2 or f7';

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
  String get puzzleThemeBodenMate => 'Boden\'s mate';

  @override
  String get puzzleThemeBodenMateDescription => 'Two attacking bishops on criss-crossing diagonals deliver mate to a king obstructed by friendly pieces.';

  @override
  String get puzzleThemeCastling => 'Castling';

  @override
  String get puzzleThemeCastlingDescription => 'Bring the king to safety, and deploy the rook for attack.';

  @override
  String get puzzleThemeCapturingDefender => 'Capture the defender';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Removing a piece that is critical to defence of another piece, allowing the now undefended piece to be captured on a following move.';

  @override
  String get puzzleThemeCrushing => 'Crushing';

  @override
  String get puzzleThemeCrushingDescription => 'Spot the opponent blunder to obtain a crushing advantage. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Double bishop mate';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Two attacking bishops on adjacent diagonals deliver mate to a king obstructed by friendly pieces.';

  @override
  String get puzzleThemeDovetailMate => 'Dovetail mate';

  @override
  String get puzzleThemeDovetailMateDescription => 'A queen delivers mate to an adjacent king, whose only two escape squares are obstructed by friendly pieces.';

  @override
  String get puzzleThemeEquality => 'Equality';

  @override
  String get puzzleThemeEqualityDescription => 'Come back from a losing position, and secure a draw or a balanced position. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Kingside attack';

  @override
  String get puzzleThemeKingsideAttackDescription => 'An attack of the opponent\'s king, after they castled on the king side.';

  @override
  String get puzzleThemeClearance => 'Clearance';

  @override
  String get puzzleThemeClearanceDescription => 'A move, often with tempo, that clears a square, file or diagonal for a follow-up tactical idea.';

  @override
  String get puzzleThemeDefensiveMove => 'Defensive move';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'A precise move or sequence of moves that is needed to avoid losing material or another advantage.';

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
  String get puzzleThemeEndgame => 'Endgame';

  @override
  String get puzzleThemeEndgameDescription => 'A tactic during the last phase of the game.';

  @override
  String get puzzleThemeEnPassantDescription => 'A tactic involving the en passant rule, where a pawn can capture an opponent pawn that has bypassed it using its initial two-square move.';

  @override
  String get puzzleThemeExposedKing => 'Exposed king';

  @override
  String get puzzleThemeExposedKingDescription => 'A tactic involving a king with few defenders around it, often leading to checkmate.';

  @override
  String get puzzleThemeFork => 'Fork';

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
  String get puzzleThemeMaster => 'Master games';

  @override
  String get puzzleThemeMasterDescription => 'Puzzles from games played by titled players.';

  @override
  String get puzzleThemeMasterVsMaster => 'Master vs Master games';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Puzzles from games between two titled players.';

  @override
  String get puzzleThemeMate => 'Checkmate';

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
  String get puzzleThemeMiddlegame => 'Middlegame';

  @override
  String get puzzleThemeMiddlegameDescription => 'A tactic during the second phase of the game.';

  @override
  String get puzzleThemeOneMove => 'One-move puzzle';

  @override
  String get puzzleThemeOneMoveDescription => 'A puzzle that is only one move long.';

  @override
  String get puzzleThemeOpening => 'Opening';

  @override
  String get puzzleThemeOpeningDescription => 'A tactic during the first phase of the game.';

  @override
  String get puzzleThemePawnEndgame => 'Pawn endgame';

  @override
  String get puzzleThemePawnEndgameDescription => 'An endgame with only pawns.';

  @override
  String get puzzleThemePin => 'Pin';

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
  String get searchSearch => 'Пребарај';

  @override
  String get settingsSettings => 'Поставки';

  @override
  String get settingsCloseAccount => 'Затвори го профилот';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Your account is managed, and cannot be closed.';

  @override
  String get settingsClosingIsDefinitive => 'Затворањето на сметката е трајно. Неповратно. Сигурни сте?';

  @override
  String get settingsCantOpenSimilarAccount => 'Нема да ви биде дозволено да отворите нова сметка со истото име, дури и со различна големина на буквите.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Се предомислив, не го затварај мојот профил';

  @override
  String get settingsCloseAccountExplanation => 'Сигурни сте дека сакате да ја затворите вашата сметка? Тоа е трајна одлука. НИКОГАШ ПОВЕЌЕ нема да можете да се најавите.';

  @override
  String get settingsThisAccountIsClosed => 'Овој профил е затворен.';

  @override
  String get playWithAFriend => 'Играј со пријател';

  @override
  String get playWithTheMachine => 'Играј со компјутерот';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Да поканиш некој да игра, прати му го овој линк';

  @override
  String get gameOver => 'Крај на играта';

  @override
  String get waitingForOpponent => 'Се чека противникот';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Почекај';

  @override
  String get yourTurn => 'Ти си на ред';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 ниво $param2';
  }

  @override
  String get level => 'Ниво';

  @override
  String get strength => 'Јачина';

  @override
  String get toggleTheChat => 'Вклучи/исклучи го разговорот';

  @override
  String get chat => 'Разговор';

  @override
  String get resign => 'Откажи се';

  @override
  String get checkmate => 'Шах-мат';

  @override
  String get stalemate => 'Пат';

  @override
  String get white => 'Бели';

  @override
  String get black => 'Црни';

  @override
  String get asWhite => 'како бели';

  @override
  String get asBlack => 'како црни';

  @override
  String get randomColor => 'Случајна боја';

  @override
  String get createAGame => 'Создади игра';

  @override
  String get whiteIsVictorious => 'Белите победија';

  @override
  String get blackIsVictorious => 'Црните победија';

  @override
  String get youPlayTheWhitePieces => 'Ти си со белите фигури';

  @override
  String get youPlayTheBlackPieces => 'Ти си со црните фигури';

  @override
  String get itsYourTurn => 'Ти си на ред!';

  @override
  String get cheatDetected => 'Откриена е измама';

  @override
  String get kingInTheCenter => 'Кралот на средина';

  @override
  String get threeChecks => 'Три шаха';

  @override
  String get raceFinished => 'Трката заврши';

  @override
  String get variantEnding => 'Крај на варијантата';

  @override
  String get newOpponent => 'Нов противник';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Противникот сака нова игра со тебе';

  @override
  String get joinTheGame => 'Приклучи се на играта';

  @override
  String get whitePlays => 'Белите се на ред';

  @override
  String get blackPlays => 'Црните се на ред';

  @override
  String get opponentLeftChoices => 'Противникот ја напушти играта. Можеш да одбереш победа, реми, или да го почекаш.';

  @override
  String get forceResignation => 'Прогласи победа';

  @override
  String get forceDraw => 'Прогласи реми';

  @override
  String get talkInChat => 'Започни разговор';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Првата личност која ќе го следи овој линк ќе игра со тебе';

  @override
  String get whiteResigned => 'Белиот се откажа';

  @override
  String get blackResigned => 'Црниот се откажа';

  @override
  String get whiteLeftTheGame => 'Белиот ја напушти играта';

  @override
  String get blackLeftTheGame => 'Црниот ја напушти играта';

  @override
  String get whiteDidntMove => 'Белиот не направи потег';

  @override
  String get blackDidntMove => 'Црниот не направи потег';

  @override
  String get requestAComputerAnalysis => 'Побарајте компјутерска анализа';

  @override
  String get computerAnalysis => 'Компјутерска анализа';

  @override
  String get computerAnalysisAvailable => 'Достапна е компјутерска анализа';

  @override
  String get computerAnalysisDisabled => 'Компјутерска анализа оневозможена';

  @override
  String get analysis => 'Анализа';

  @override
  String depthX(String param) {
    return 'Длабочина $param';
  }

  @override
  String get usingServerAnalysis => 'Користење на анализи од серверот';

  @override
  String get loadingEngine => 'Се вчитува компјутерската програма ...';

  @override
  String get calculatingMoves => 'Пресметување...';

  @override
  String get engineFailed => 'Грешка при вчитување на компјутерот';

  @override
  String get cloudAnalysis => 'Анализа на облакот';

  @override
  String get goDeeper => 'Оди подлабоку';

  @override
  String get showThreat => 'Покажи закана';

  @override
  String get inLocalBrowser => 'на вашиот прелистувач (локално)';

  @override
  String get toggleLocalEvaluation => 'Вклчи локална еваулација';

  @override
  String get promoteVariation => 'Варијација на промовирање';

  @override
  String get makeMainLine => 'Избери главна линија';

  @override
  String get deleteFromHere => 'Избриши одовде';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Прикажи како варијанта';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'Потег';

  @override
  String get variantLoss => 'Губитничка варијанта';

  @override
  String get variantWin => 'Победничка варијанта';

  @override
  String get insufficientMaterial => 'Недоволно фигури';

  @override
  String get pawnMove => 'Потег со пешак';

  @override
  String get capture => 'Земање';

  @override
  String get close => 'Затвори';

  @override
  String get winning => 'Победоносни';

  @override
  String get losing => 'Губитнички';

  @override
  String get drawn => 'Реми';

  @override
  String get unknown => 'Непознати';

  @override
  String get database => 'База на податоци';

  @override
  String get whiteDrawBlack => 'Бели / Реми / Црни';

  @override
  String averageRatingX(String param) {
    return 'Просечен пласман $param';
  }

  @override
  String get recentGames => 'Неодамнешни игри';

  @override
  String get topGames => 'Топ игри';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'База на податоци од игри на $param1+ ФИДЕ рангирани играчи, од $param2 до $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' со заокружување, врз основа на бројот на полу-потези до наредното земање или потег на пионот';

  @override
  String get noGameFound => 'Не е пронајдена таква партија';

  @override
  String get maxDepthReached => 'Максималната длабочина е постигната!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Би можеле да додадете повеќе партии од менито за поставки.';

  @override
  String get openings => 'Отворања';

  @override
  String get openingExplorer => 'Пребарувач на отворања';

  @override
  String get openingEndgameExplorer => 'Истражувач на отворања/затворања';

  @override
  String xOpeningExplorer(String param) {
    return 'Пребарување отворања на: $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Одиграјте го првиот истражувачки потег во отворање/завршница';

  @override
  String get winPreventedBy50MoveRule => 'Спречена е победата поради правилото за 50 потези';

  @override
  String get lossSavedBy50MoveRule => 'Спречен е поразот поради правилото на 50 потези';

  @override
  String get winOr50MovesByPriorMistake => 'Победа или 50 потези поради претходна грешка';

  @override
  String get lossOr50MovesByPriorMistake => 'Пораз или 50 потези поради претходна грешка';

  @override
  String get unknownDueToRounding => 'Победа/пораз гарантирано само доколку се следи препорачаната варијација од последното земање или движење на пионот, заради можно заокружување на DTZ вредности во Syzygy базата со шаховски варијации.';

  @override
  String get allSet => 'Се е спремно!';

  @override
  String get importPgn => 'Внеси PGN';

  @override
  String get delete => 'Избриши';

  @override
  String get deleteThisImportedGame => 'Избриши ја внесената партија?';

  @override
  String get replayMode => 'Режим на реприза';

  @override
  String get realtimeReplay => 'Во реално време';

  @override
  String get byCPL => 'По CPL';

  @override
  String get openStudy => 'Отвори студија';

  @override
  String get enable => 'Овозможи';

  @override
  String get bestMoveArrow => 'Стрелка за најдобар потег';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Мерач за проценка';

  @override
  String get multipleLines => 'Број на варијанти';

  @override
  String get cpus => 'Процесори';

  @override
  String get memory => 'Меморија';

  @override
  String get infiniteAnalysis => 'Бесконечна анализа';

  @override
  String get removesTheDepthLimit => 'Неограничена длабочина на анализа, го загрева вашиот компјутер';

  @override
  String get engineManager => 'Менаџер на компјутерот';

  @override
  String get blunder => 'Глупа грешка';

  @override
  String get mistake => 'Грешка';

  @override
  String get inaccuracy => 'Непрецизност';

  @override
  String get moveTimes => 'Време по потег';

  @override
  String get flipBoard => 'Сврти ја таблата';

  @override
  String get threefoldRepetition => 'Тројно повторување';

  @override
  String get claimADraw => 'Избери реми';

  @override
  String get offerDraw => 'Понуди реми';

  @override
  String get draw => 'Реми';

  @override
  String get drawByMutualAgreement => 'Нерешено од заеднички договор';

  @override
  String get fiftyMovesWithoutProgress => 'Педесет потези без напредок';

  @override
  String get currentGames => 'Игри кои се играат моментално';

  @override
  String get viewInFullSize => 'Гледај во полна големина';

  @override
  String get logOut => 'Одјави се';

  @override
  String get signIn => 'Најави се';

  @override
  String get rememberMe => 'Задржи ме најавен';

  @override
  String get youNeedAnAccountToDoThat => 'Ви треба свој профил за да го направите тоа';

  @override
  String get signUp => 'Регистрирај се';

  @override
  String get computersAreNotAllowedToPlay => 'Не е дозволено да играат компјутери и компјутерски потпомогнати играчи. Додедка играте, Ве молиме да не користите помош од шаховски машини, бази на податоци или од други играчи. Примете на знаење дека сериозно се настојува да не се отвораат повеќе профили. Прекумерното повеќекратно профилирање води кон отстранување.';

  @override
  String get games => 'Игри';

  @override
  String get forum => 'Форум';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 постирале во форумот $param2';
  }

  @override
  String get latestForumPosts => 'најнови мислења од форумот';

  @override
  String get players => 'Играчи';

  @override
  String get friends => 'Пријатели';

  @override
  String get discussions => 'Разговори';

  @override
  String get today => 'Денес';

  @override
  String get yesterday => 'Вчера';

  @override
  String get minutesPerSide => 'Минути по играч';

  @override
  String get variant => 'Варијанта';

  @override
  String get variants => 'Варијанти';

  @override
  String get timeControl => 'Временска контрола';

  @override
  String get realTime => 'Реално време';

  @override
  String get correspondence => 'Дописен шах';

  @override
  String get daysPerTurn => 'Денови по потег';

  @override
  String get oneDay => 'Еден ден';

  @override
  String get time => 'Време';

  @override
  String get rating => 'рејтинг';

  @override
  String get ratingStats => 'Статистика рейтинга';

  @override
  String get username => 'Имя пользователя';

  @override
  String get usernameOrEmail => 'Корисник';

  @override
  String get changeUsername => 'Промени го корисничкото име';

  @override
  String get changeUsernameNotSame => 'Може да се промени само големината на буквите. На пример: \"johndoe\" во \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'Промени го корисничкото име. Ова може да се направи само еднаш и дозволено Ви е само да ја промените големината на буквите.';

  @override
  String get signupUsernameHint => 'Бидете сигурни дека корисничкото име не е навредливо или вулгарно, бидејќи негова промена подоцна е невозможна. Сите профили со несоодветно корисничко име ќе бидат затворени!';

  @override
  String get signupEmailHint => 'Ќе го користиме само за ресетирање на лозинката.';

  @override
  String get password => 'Лозинка';

  @override
  String get changePassword => 'Променете ја шифрата';

  @override
  String get changeEmail => 'Променете ја е-поштата';

  @override
  String get email => 'е-пошта';

  @override
  String get passwordReset => 'Задај нова лозинката';

  @override
  String get forgotPassword => 'Сте ја заборавиле лозинката?';

  @override
  String get error_weakPassword => 'Оваа лозинка е пречеста и прелесна за откривање.';

  @override
  String get error_namePassword => 'Ве молиме не го користете корисничкото име како лозинка.';

  @override
  String get blankedPassword => 'Истата лозинка сте ја користеле на друг сајт кој е компромитиран. За до го обезбедите вашиот Lichess профил, Ве замолуваме да одберете нова лозинка. Ви благодариме на разбирањето.';

  @override
  String get youAreLeavingLichess => 'Го напуштате Lichess';

  @override
  String get neverTypeYourPassword => 'Никогаш не ја користете Вашата Lichess лозинка на друг сајт!';

  @override
  String proceedToX(String param) {
    return 'Продолжете кон $param';
  }

  @override
  String get passwordSuggestion => 'Не користете предлог лозинка од некој друг. Можат да ја искористат да Ви го присвојат профилот.';

  @override
  String get emailSuggestion => 'Не користете предлог емајл од некој друг. Можат да го искористат за да Ви го присвојат профилот.';

  @override
  String get emailConfirmHelp => 'Помош околу потврдата на email-от';

  @override
  String get emailConfirmNotReceived => 'Не го добивте email-от за потврда после пријавувањето?';

  @override
  String get whatSignupUsername => 'Кое корисничко име го користевте за пријава?';

  @override
  String usernameNotFound(String param) {
    return 'Не најдовме корисник со име $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Можете да го користите ова корисничко име за креирање на нов профил';

  @override
  String emailSent(String param) {
    return 'Испративме email на $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Испраќањето може да потрае.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Почекајте 5 минути па превчитајте го email приемното сандаче.';

  @override
  String get checkSpamFolder => 'Исто, проверете да не залутал во spam фолдерот. Во таков случај преместете го од таму.';

  @override
  String get emailForSignupHelp => 'Ако ништо друо не функционира испратете ни го следниов email:';

  @override
  String copyTextToEmail(String param) {
    return 'Копирајте го текстот погоре и испратете го на $param';
  }

  @override
  String get waitForSignupHelp => 'За брзо ќе сме со Вас да Ви помогнеме околу пријавувањето.';

  @override
  String accountConfirmed(String param) {
    return 'Корсникот $param е успешно потврден.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Сега можете да се најавите како $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Не Ви е потребен email за потврда.';

  @override
  String accountClosed(String param) {
    return 'Профилот $param е затворен.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Профилот $param е пријавен без email.';
  }

  @override
  String get rank => 'Ранг';

  @override
  String rankX(String param) {
    return 'Ранк: $param';
  }

  @override
  String get gamesPlayed => 'Одиграни партии';

  @override
  String get cancel => 'Откажи';

  @override
  String get whiteTimeOut => 'Времето на белиот истече';

  @override
  String get blackTimeOut => 'Времето на црниот истече';

  @override
  String get drawOfferSent => 'Понуда за реми е испратена';

  @override
  String get drawOfferAccepted => 'Понудата за реми е прифатена';

  @override
  String get drawOfferCanceled => 'Понудата за реми е откажана';

  @override
  String get whiteOffersDraw => 'Белиот нуди реми';

  @override
  String get blackOffersDraw => 'Црниот нуди реми';

  @override
  String get whiteDeclinesDraw => 'Белиот одби реми';

  @override
  String get blackDeclinesDraw => 'Црниот одби реми';

  @override
  String get yourOpponentOffersADraw => 'Противникот нуди реми';

  @override
  String get accept => 'Прифати';

  @override
  String get decline => 'Одбиј';

  @override
  String get playingRightNow => 'Моментално игра';

  @override
  String get eventInProgress => 'Моментално игра';

  @override
  String get finished => 'Завршено';

  @override
  String get abortGame => 'Откажи ја играта';

  @override
  String get gameAborted => 'Играта е откажана';

  @override
  String get standard => 'Стандарден';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Неограничено';

  @override
  String get mode => 'Начин';

  @override
  String get casual => 'Неформален';

  @override
  String get rated => 'Рангиран';

  @override
  String get casualTournament => 'Неформален';

  @override
  String get ratedTournament => 'Рангиран';

  @override
  String get thisGameIsRated => 'Оваа игра е рангирана';

  @override
  String get rematch => 'Реванш';

  @override
  String get rematchOfferSent => 'Понуда за реванш е испратена';

  @override
  String get rematchOfferAccepted => 'Понудата за реванш е прифатена';

  @override
  String get rematchOfferCanceled => 'Понудата за реванш е откажана';

  @override
  String get rematchOfferDeclined => 'Одбиена е понудата за реванш';

  @override
  String get cancelRematchOffer => 'Откажете ја понудата за реванш';

  @override
  String get viewRematch => 'Погледнете го реваншот';

  @override
  String get confirmMove => 'Потврди го потегот';

  @override
  String get play => 'Играј';

  @override
  String get inbox => 'Сандаче';

  @override
  String get chatRoom => 'Прозор за разговор';

  @override
  String get loginToChat => 'Најави се за да испратиш порака';

  @override
  String get youHaveBeenTimedOut => 'Одземено Ви е правото на разговор.';

  @override
  String get spectatorRoom => 'Соба за набљудувачи';

  @override
  String get composeMessage => 'Креирај порака';

  @override
  String get subject => 'Предмет';

  @override
  String get send => 'Испрати';

  @override
  String get incrementInSeconds => 'Зголемување во секунди';

  @override
  String get freeOnlineChess => 'Бесплатен Онлајн Шах';

  @override
  String get exportGames => 'Извади игри';

  @override
  String get ratingRange => 'Elo опсег';

  @override
  String get thisAccountViolatedTos => 'Оваа корисничка сметка ги прекрши корисничките услови на Lichess';

  @override
  String get openingExplorerAndTablebase => 'Отворање на пребарувач и табела';

  @override
  String get takeback => 'Повлечете го потегот';

  @override
  String get proposeATakeback => 'Предложете повлекување на потегот';

  @override
  String get takebackPropositionSent => 'Предлог за повлекување на потегот е пратен';

  @override
  String get takebackPropositionDeclined => 'Одбиен е предлогот за повлекување на потегот';

  @override
  String get takebackPropositionAccepted => 'Предлогот за повлекување на потегот е прифатен';

  @override
  String get takebackPropositionCanceled => 'Предлогот за повлекување на потегот е откажан';

  @override
  String get yourOpponentProposesATakeback => 'Вашиот противник ви предложува повлекување на потегот';

  @override
  String get bookmarkThisGame => 'Обележете ја оваа игра';

  @override
  String get tournament => 'Турнир';

  @override
  String get tournaments => 'Турнири';

  @override
  String get tournamentPoints => 'Турнирски поени';

  @override
  String get viewTournament => 'Погледнете го турнирот';

  @override
  String get backToTournament => 'Врати се на турнир';

  @override
  String get noDrawBeforeSwissLimit => 'Во турнир со швајцарски систем не можете да ремизирате пред 30-тиот потег.';

  @override
  String get thematic => 'Тематски';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Вашиот $param рејтинг е провизорен';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Вашиот $param1 рејтинг ($param2) е превисок';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Вашиот $param1 рејтинг ($param2) е превисок';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Вашиот $param1 рејтинг ($param2) е пренизок';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Рејтинг ≥ $param1 во $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Рејтинг ≤ $param1 во $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Мора да сте член на тимот $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Не сте член на тимот $param';
  }

  @override
  String get backToGame => 'Назад кон партијата';

  @override
  String get siteDescription => 'Бесплатна онлајн шах игра. Играј шах во чист интерфејс. Без регистрација, без реклами, без додатни plugin-и. Играј шах со компјутер, пријатели или случајни противници.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 се приклучи на тимот $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 го создаде тимот $param2';
  }

  @override
  String get startedStreaming => 'почна да емитува';

  @override
  String xStartedStreaming(String param) {
    return '$param почна да емитува';
  }

  @override
  String get averageElo => 'Просечно Elo';

  @override
  String get location => 'Локација';

  @override
  String get filterGames => 'Филтрирај игри';

  @override
  String get reset => 'Ресетирај';

  @override
  String get apply => 'Аплицирај';

  @override
  String get save => 'Зачувај';

  @override
  String get leaderboard => 'Табела';

  @override
  String get screenshotCurrentPosition => 'Сликајте ја моменталната позиција';

  @override
  String get gameAsGIF => 'Сочувај ја партијата како GIF';

  @override
  String get pasteTheFenStringHere => 'Пастирај го FEN стрингот овде';

  @override
  String get pasteThePgnStringHere => 'Пастирај го PGN стрингот овде';

  @override
  String get orUploadPgnFile => 'Или закачете PGN датотека';

  @override
  String get fromPosition => 'Од позиција';

  @override
  String get continueFromHere => 'Продолжи од овде';

  @override
  String get toStudy => 'Студија';

  @override
  String get importGame => 'Внеси игра';

  @override
  String get importGameExplanation => 'Залепи PGN од игра за да добиеш реприза, \nкомпјутерска анализа, разговор во играта и URL за споделување.';

  @override
  String get importGameCaveat => 'Варијациите ќе бидат избришани. За да ги задржите внесете го PNG преку студија.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Ова е шаховско CAPTCHA';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Кликни на таблата за да го повлечеш својот потег и така докажи дека си човек.';

  @override
  String get captcha_fail => 'Ве молиме решете ја шаховската капча.';

  @override
  String get notACheckmate => 'Не е шахмат.';

  @override
  String get whiteCheckmatesInOneMove => 'Мат со белите во еден потег';

  @override
  String get blackCheckmatesInOneMove => 'Мат со црните во еден потег';

  @override
  String get retry => 'Обиди се повторно';

  @override
  String get reconnecting => 'Повторно конектирање';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Омилени противници';

  @override
  String get follow => 'Следи';

  @override
  String get following => 'Ги следи';

  @override
  String get unfollow => 'Од-следи';

  @override
  String followX(String param) {
    return 'Следи $param';
  }

  @override
  String unfollowX(String param) {
    return 'Одследи $param';
  }

  @override
  String get block => 'Блокирај';

  @override
  String get blocked => 'Блокиран';

  @override
  String get unblock => 'Одблокирај';

  @override
  String get followsYou => 'Те следи';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 почна да го следи $param2';
  }

  @override
  String get more => 'Повеќе';

  @override
  String get memberSince => 'Член од';

  @override
  String lastSeenActive(String param) {
    return 'Последен пат вклучен $param';
  }

  @override
  String get player => 'Играч';

  @override
  String get list => 'Листа';

  @override
  String get graph => 'Графикон';

  @override
  String get required => 'Неопходно.';

  @override
  String get openTournaments => 'Отворени турнири';

  @override
  String get duration => 'Времетраење';

  @override
  String get winner => 'Победник';

  @override
  String get standing => 'Положба';

  @override
  String get createANewTournament => 'Отвори нов турнир';

  @override
  String get tournamentCalendar => 'Календар на турнири';

  @override
  String get conditionOfEntry => 'Услови за влез:';

  @override
  String get advancedSettings => 'Напредни поставки';

  @override
  String get safeTournamentName => 'Одбери многу безбедно име за турнирот.';

  @override
  String get inappropriateNameWarning => 'И најмалку непристојни работи можат да ви ја затворат сметката.';

  @override
  String get emptyTournamentName => 'Остави празно за турнирот да биде крстен по шаховски првак.';

  @override
  String get makePrivateTournament => 'Направи го турнирот приватен и ограничи го пристапот со лозинка';

  @override
  String get join => 'Приклучи се';

  @override
  String get withdraw => 'Предади';

  @override
  String get points => 'Поени';

  @override
  String get wins => 'Победи';

  @override
  String get losses => 'Порази';

  @override
  String get createdBy => 'Создадено од';

  @override
  String get tournamentIsStarting => 'Турнирот започна';

  @override
  String get tournamentPairingsAreNowClosed => 'Спарувањата за турнирот се затворени.';

  @override
  String standByX(String param) {
    return 'Почекај $param, се спаруваат играчите, подготви се!';
  }

  @override
  String get pause => 'Пауза';

  @override
  String get resume => 'Продолжи';

  @override
  String get youArePlaying => 'Играш!';

  @override
  String get winRate => 'Стапка на победи';

  @override
  String get berserkRate => 'Стапка на лудило';

  @override
  String get performance => 'Изведби';

  @override
  String get tournamentComplete => 'Турнирот е завршен';

  @override
  String get movesPlayed => 'Број на потези';

  @override
  String get whiteWins => 'Победа на белите';

  @override
  String get blackWins => 'Победа на црните';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Ремија';

  @override
  String nextXTournament(String param) {
    return 'Следен $param турнир:';
  }

  @override
  String get averageOpponent => 'Просечен противник';

  @override
  String get boardEditor => 'Уредник на таблата';

  @override
  String get setTheBoard => 'Постави ја таблата';

  @override
  String get popularOpenings => 'Популарни отворања';

  @override
  String get endgamePositions => 'Завршни позиции';

  @override
  String chess960StartPosition(String param) {
    return 'Почетна позиција за Chess960: $param';
  }

  @override
  String get startPosition => 'Стартна позиција';

  @override
  String get clearBoard => 'Исчисти ја таблата';

  @override
  String get loadPosition => 'оптоварување позиција';

  @override
  String get isPrivate => 'Приватно';

  @override
  String reportXToModerators(String param) {
    return 'Извести $param ги модераторите';
  }

  @override
  String profileCompletion(String param) {
    return 'Профилот е $param готов';
  }

  @override
  String xRating(String param) {
    return '$param рејтинг';
  }

  @override
  String get ifNoneLeaveEmpty => 'Без рејтинг? Остави го полето празно';

  @override
  String get profile => 'Профил';

  @override
  String get editProfile => 'Уреди го профилот';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Биографија';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Благодарам!';

  @override
  String get socialMediaLinks => 'Врски на друштвени мрежи';

  @override
  String get oneUrlPerLine => 'Еден УРЛ по линија.';

  @override
  String get inlineNotation => 'Подредена нотација';

  @override
  String get makeAStudy => 'Заради сигурност и споделување, креирајте студија.';

  @override
  String get clearSavedMoves => 'Исчисти потези';

  @override
  String get previouslyOnLichessTV => 'Предходно на Личес ТВ';

  @override
  String get onlinePlayers => 'Вклучени играчи (играчи на линија )';

  @override
  String get activePlayers => 'Активни играчи';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Внимавајте, играта е оценета но нема часовник.';

  @override
  String get success => 'Успех';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'По влечењето потег преминете автоматски кон наредната игра';

  @override
  String get autoSwitch => 'Префрли автоматски';

  @override
  String get puzzles => 'Проблеми';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Име';

  @override
  String get description => 'Опис';

  @override
  String get descPrivate => 'Приватен опис';

  @override
  String get descPrivateHelp => 'Текст кој само членовите на тимот ќе го видат. Ако се постави, го заменува јавниот опис за членовите од тимот.';

  @override
  String get no => 'Не';

  @override
  String get yes => 'Да';

  @override
  String get help => 'Помош';

  @override
  String get createANewTopic => 'Создади нова тема';

  @override
  String get topics => 'Теми';

  @override
  String get posts => 'Објави';

  @override
  String get lastPost => 'Последна објава';

  @override
  String get views => 'Прегледи';

  @override
  String get replies => 'Одговори';

  @override
  String get replyToThisTopic => 'Одговори на темата';

  @override
  String get reply => 'Одговори';

  @override
  String get message => 'Порака';

  @override
  String get createTheTopic => 'Отвори тема';

  @override
  String get reportAUser => 'Пријави корисник';

  @override
  String get user => 'Корисник';

  @override
  String get reason => 'Причина';

  @override
  String get whatIsIheMatter => 'Каде е проблемот?';

  @override
  String get cheat => 'Мамење';

  @override
  String get troll => 'Трол';

  @override
  String get other => 'Друго';

  @override
  String get reportDescriptionHelp => 'Внесете линк од играта/игрите и објаснете каде е проблемот во однесувањето на овој корисник. Немојте само да обвините за мамење, туку објаснете како дојдовте до тој заклучок. Вашата пријава ќе биди разгледана побрзо ако е напишана на англиски јазик.';

  @override
  String get error_provideOneCheatedGameLink => 'Ве молиме доставете барем една врска до партија со мамење.';

  @override
  String by(String param) {
    return 'од $param';
  }

  @override
  String importedByX(String param) {
    return 'Внесено од $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Темата е затворена.';

  @override
  String get blog => 'Блог';

  @override
  String get notes => 'Белешки';

  @override
  String get typePrivateNotesHere => 'Напиши приватни белешки';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Напишете приватна белешка за овој корисник';

  @override
  String get noNoteYet => 'Уште нема белешка';

  @override
  String get invalidUsernameOrPassword => 'Невалидно корисничко име или лозинка';

  @override
  String get incorrectPassword => 'Погрешна лозинка';

  @override
  String get invalidAuthenticationCode => 'Неважечки код за автентикација';

  @override
  String get emailMeALink => 'Прати ми линк на емаил';

  @override
  String get currentPassword => 'Тековна лозинка';

  @override
  String get newPassword => 'Нова лозинка';

  @override
  String get newPasswordAgain => 'Нова лозинка (повторно)';

  @override
  String get newPasswordsDontMatch => 'Новите лозинки не се совпаѓаат';

  @override
  String get newPasswordStrength => 'Јачина на лозинка';

  @override
  String get clockInitialTime => 'Почетно време';

  @override
  String get clockIncrement => 'Временски додаток';

  @override
  String get privacy => 'Приватност';

  @override
  String get privacyPolicy => 'Полиса за приватност';

  @override
  String get letOtherPlayersFollowYou => 'Дозволете останатите играчи да ве следат';

  @override
  String get letOtherPlayersChallengeYou => 'Дозволете останатите играчи да ве предизвикуваат';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Дозволете останатите играчи да ве повикаат во студијата';

  @override
  String get sound => 'Звук';

  @override
  String get none => 'Никаква';

  @override
  String get fast => 'Брза';

  @override
  String get normal => 'Нормална';

  @override
  String get slow => 'Спора';

  @override
  String get insideTheBoard => 'Во таблата';

  @override
  String get outsideTheBoard => 'Надвор од таблата';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Во спори партии';

  @override
  String get always => 'Секогаш';

  @override
  String get never => 'Никогаш';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 игра во $param2';
  }

  @override
  String get victory => 'Победа';

  @override
  String get defeat => 'Пораз';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 против $param2 во „$param3“';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 против $param2 во „$param3“';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 против $param2 во „$param3“';
  }

  @override
  String get timeline => 'Хронологија';

  @override
  String get starting => 'Почеток:';

  @override
  String get allInformationIsPublicAndOptional => 'Сите информации се јавни и незадолжителни.';

  @override
  String get biographyDescription => 'Кажи нешто за себе, твоите интереси, зошто сакаш шах, омилените потези, играчи...';

  @override
  String get listBlockedPlayers => 'Листа на блокирани играчи';

  @override
  String get human => 'Човек';

  @override
  String get computer => 'Компјутер';

  @override
  String get side => 'Боја';

  @override
  String get clock => 'Часовник';

  @override
  String get opponent => 'Противник';

  @override
  String get learnMenu => 'Научи';

  @override
  String get studyMenu => 'Научи';

  @override
  String get practice => 'Вежбај';

  @override
  String get community => 'Заедница';

  @override
  String get tools => 'Алатки';

  @override
  String get increment => 'Зголемување на време';

  @override
  String get error_unknown => 'Невалидна вредност';

  @override
  String get error_required => 'Ова поле е задолжително';

  @override
  String get error_email => 'Адресата на е-поштата е невалидна';

  @override
  String get error_email_acceptable => 'Оваа е-мајл адреса е невалидна. Ве молам проверете и пробајте повторно.';

  @override
  String get error_email_unique => 'Адресата на е-поштата е невалидна или веќе постоечка';

  @override
  String get error_email_different => 'Ова веќе е вашата е-мајл адреса';

  @override
  String error_minLength(String param) {
    return 'Минимална должина е знаци $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Максимална должина е знаци $param';
  }

  @override
  String error_min(String param) {
    return 'Мора да биде најмалку $param';
  }

  @override
  String error_max(String param) {
    return 'Мора да биде најмногу $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Ако рејтингот е ± $param';
  }

  @override
  String get ifRegistered => 'Ако се регистрирани';

  @override
  String get onlyExistingConversations => 'Само веќе постоечки разговори';

  @override
  String get onlyFriends => 'Пријатели кои се онлајн';

  @override
  String get menu => 'Мени';

  @override
  String get castling => 'Рокада';

  @override
  String get whiteCastlingKingside => 'Белиот мала рокада';

  @override
  String get blackCastlingKingside => 'Црниот мала рокада';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Време поминато во игра: $param';
  }

  @override
  String get watchGames => 'Гледајте Игри';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Време на TV: $param';
  }

  @override
  String get watch => 'Гледај';

  @override
  String get videoLibrary => 'Видеа';

  @override
  String get streamersMenu => 'Стримери';

  @override
  String get mobileApp => 'Апликација за телефон';

  @override
  String get webmasters => 'ВебМастер';

  @override
  String get about => 'Повеќе за';

  @override
  String aboutX(String param) {
    return 'Повеќе за $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 е слободен ($param2), бесплатен сервер со отворен код и без реклами.';
  }

  @override
  String get really => 'навистина';

  @override
  String get contribute => 'Придонес';

  @override
  String get termsOfService => 'Услови за користење';

  @override
  String get sourceCode => 'Изворен код';

  @override
  String get simultaneousExhibitions => 'Симултанка';

  @override
  String get host => 'Хост';

  @override
  String hostColorX(String param) {
    return 'Боја на домаќинот: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Нови креирани симултанки';

  @override
  String get hostANewSimul => 'Создади нова симултана партија';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Не е најдена симултаната игра';

  @override
  String get noSimulExplanation => 'Симултаната партија не постои.';

  @override
  String get returnToSimulHomepage => 'Врати се на страната со симултани партии';

  @override
  String get aboutSimul => 'Симултаните партии се еден против повеќе играчи наеднаш.';

  @override
  String get aboutSimulImage => 'Од 50 противници, Фишер победи 47 партии, ремизираше 2 и изгуби 1.';

  @override
  String get aboutSimulRealLife => 'Концептот е создаден според вистински настани. Во живо, ова значи дека домаќинот оди од маса на маса да направи потег.';

  @override
  String get aboutSimulRules => 'Кога симултаната партија почнува, секој играч почнува игра со домаќинот, кој игра со белите. Симултаната партија завршува кога сите партии се готови.';

  @override
  String get aboutSimulSettings => 'Симултаните партии се секогаш пријателски. Нема реванши, враќање потези и додавање време.';

  @override
  String get create => 'Создади';

  @override
  String get whenCreateSimul => 'Кога создаваш симултана партија, играш со повеќе противници наеднаш.';

  @override
  String get simulVariantsHint => 'Ако одбереш повеќе видови, секој играч може да одбере како ќе игра.';

  @override
  String get simulClockHint => 'Поставување на Фишерскиот часовник. Што повеќе противници, толку повеќе време ти треба.';

  @override
  String get simulAddExtraTime => 'Можеш да додадеш додатно време на часовникот, за да ти помогне со симултаната партија.';

  @override
  String get simulHostExtraTime => 'Додатно време за домаќинот';

  @override
  String get simulAddExtraTimePerPlayer => 'Додајте почетно време на Вашиот часовник со приклучувањето на секој нов играч во симултанката.';

  @override
  String get simulHostExtraTimePerPlayer => 'Додатно време по играч за домаќинот на симултанката';

  @override
  String get lichessTournaments => 'Lichess турнири';

  @override
  String get tournamentFAQ => 'ЧПП за арена турнирите';

  @override
  String get timeBeforeTournamentStarts => 'Време до почетокот на турнирот';

  @override
  String get averageCentipawnLoss => 'Просечна загуба во центи-пиони';

  @override
  String get accuracy => 'Прецизност';

  @override
  String get keyboardShortcuts => 'Кратенки на тастатурата';

  @override
  String get keyMoveBackwardOrForward => 'оди назад/напред';

  @override
  String get keyGoToStartOrEnd => 'оди на почеток/крај';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'покажи/скриј ги коментарите';

  @override
  String get keyEnterOrExitVariation => 'отвори/затвори ја варијантата';

  @override
  String get keyRequestComputerAnalysis => 'Побарајте компјутерска анализа, Учете од Вашите грешки';

  @override
  String get keyNextLearnFromYourMistakes => 'Следно (учете од Вашите грешки)';

  @override
  String get keyNextBlunder => 'Следен превид';

  @override
  String get keyNextMistake => 'Следна грешка';

  @override
  String get keyNextInaccuracy => 'Следна непрецизност';

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
  String get newTournament => 'Нов турнир';

  @override
  String get tournamentHomeTitle => 'Шаховски турнир со различни временски контроли и варијанти';

  @override
  String get tournamentHomeDescription => 'Играј брзи турнири! Придружи се на официјален турнир, или започни свој. Стрела, Блиц, Класичен, Шах 960, Кралот на средина, Три шаха, и многу други варијанти за бескрајна забава.';

  @override
  String get tournamentNotFound => 'Турнирот не е пронајден';

  @override
  String get tournamentDoesNotExist => 'Овој турнир не постои.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Турнирот може да е откажан ако сите играчи го напуштиле пред да започне.';

  @override
  String get returnToTournamentsHomepage => 'Повраток на почетната страна';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Седмичен распоред на $param рејтинг';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Вашиот рејтинг на „$param1“ е $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Подобар си од $param1 од играчите на „$param2“.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 е подобар од $param2 од играчите на „$param3“.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Немаш установен рејтинг на „$param“.';
  }

  @override
  String get yourRating => 'Твојот рејтинг';

  @override
  String get cumulative => 'Вкупно';

  @override
  String get glicko2Rating => 'Glicko-2 рејтинг';

  @override
  String get checkYourEmail => 'Провери си ја е-поштата';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Ти испративме е-пошта. Отворете ја врската во е-писмото за активација на сметката.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ако не можеш да го најдеш е-писмото, провери во папките како „ѓубре“, „спам“, „социјални“ итн.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Пративме е-пошта на $param. Кликни на врската во пораката за обнова на лозинката.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Со регистрацијата, се согласуваш со нашите $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Прочитај за нашата $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Мрежно задоцнување меѓу Вас и Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Време за процесирање потег на сервер на lichess';

  @override
  String get downloadAnnotated => 'Симни со коментари';

  @override
  String get downloadRaw => 'Превземи без белешки';

  @override
  String get downloadImported => 'Превземи го доставеното';

  @override
  String get crosstable => 'Табела на резултати';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Можеш и да скролаш врз таблата за да одбереш потег.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Скролувајте за да ги прегледате компјутерските варијации.';

  @override
  String get analysisShapesHowTo => 'Притисни shift+click или десен клик за да нацрташ кругови или стрелки на таблата.';

  @override
  String get letOtherPlayersMessageYou => 'Овозможи пораки од другите играчи';

  @override
  String get receiveForumNotifications => 'Добивај известувања кога си споменат на форум';

  @override
  String get shareYourInsightsData => 'Сподели ја твојата аналитика';

  @override
  String get withNobody => 'Со никого';

  @override
  String get withFriends => 'Со пријатели';

  @override
  String get withEverybody => 'Со секого';

  @override
  String get kidMode => 'Детска заштита';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Ова е заради безбедност. Во детска заштита, сите комуникации се оневозможени. Вклучете го овој начин за вашите деца, да ги заштитите од останатите интернет корисници.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Во детскиот режим, на Lichess логото е додадено „$param“, за да знаете дека вашите деца се безбедни.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Вашиот профил е под администратор. Прашајте го Вашиот учител за исклучување на работниот начин за деца.';

  @override
  String get enableKidMode => 'Вклучи го детскиот режим';

  @override
  String get disableKidMode => 'Исклучи го детскиот режим';

  @override
  String get security => 'Безбедност';

  @override
  String get sessions => 'Сесии';

  @override
  String get revokeAllSessions => 'избришете сите сесии';

  @override
  String get playChessEverywhere => 'Играј шах секаде';

  @override
  String get asFreeAsLichess => 'Бесплатно како lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Направено од љубовта кон шахот, а не за пари';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Секој ги добива сите функции бесплатно';

  @override
  String get zeroAdvertisement => 'Без реклами';

  @override
  String get fullFeatured => 'Со сите можности';

  @override
  String get phoneAndTablet => 'Телефон и таблет';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, classical';

  @override
  String get correspondenceChess => 'Дописен шах';

  @override
  String get onlineAndOfflinePlay => 'Online и offline игра';

  @override
  String get viewTheSolution => 'Види го решението';

  @override
  String get followAndChallengeFriends => 'Следи и предизвикај пријатели';

  @override
  String get gameAnalysis => 'Анализи на партијата';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 одржува $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 се придружува на $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return 'на $param1 му се допаѓа $param2';
  }

  @override
  String get quickPairing => 'Брзо спојување';

  @override
  String get lobby => 'Лоби';

  @override
  String get anonymous => 'Анонимен';

  @override
  String yourScore(String param) {
    return 'Вашиот резултат: $param';
  }

  @override
  String get language => 'Јазик';

  @override
  String get background => 'Позадина';

  @override
  String get light => 'Светло';

  @override
  String get dark => 'Темно';

  @override
  String get transparent => 'Проѕирно';

  @override
  String get deviceTheme => 'Тема на уредот';

  @override
  String get backgroundImageUrl => 'URL на заднинската слика:';

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
  String get pieceSet => 'Дизајн на фигурите';

  @override
  String get embedInYourWebsite => 'Вгради во твојот сајт';

  @override
  String get usernameAlreadyUsed => 'Ова корисничко име е во употреба, ве молиме одберете поинакво.';

  @override
  String get usernamePrefixInvalid => 'Корисничкото име мора да започнува со буква.';

  @override
  String get usernameSuffixInvalid => 'Корисничкото име мора да завршува со буква или бројка.';

  @override
  String get usernameCharsInvalid => 'Корисничкото име може да содржи само букви, бројки, долни и средни црти.';

  @override
  String get usernameUnacceptable => 'Корисничкото име е неприфатливо.';

  @override
  String get playChessInStyle => 'Играј шах со стил';

  @override
  String get chessBasics => 'Основи на шахот';

  @override
  String get coaches => 'Тренери';

  @override
  String get invalidPgn => 'Невалиден PGN';

  @override
  String get invalidFen => 'Невалиден FEN';

  @override
  String get custom => 'Персонализирано';

  @override
  String get notifications => 'Известувања';

  @override
  String notificationsX(String param1) {
    return 'Известувања: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Рејтинг: $param';
  }

  @override
  String get practiceWithComputer => 'Вежбај со компјутерот';

  @override
  String anotherWasX(String param) {
    return 'Алтернативен би бил $param';
  }

  @override
  String bestWasX(String param) {
    return 'Најдобриот потег беше $param';
  }

  @override
  String get youBrowsedAway => 'Одсурфавте надвор';

  @override
  String get resumePractice => 'Продолжи со вежбата';

  @override
  String get drawByFiftyMoves => 'Оваа партија е реми по правилото од 50 потези.';

  @override
  String get theGameIsADraw => 'Партијата е реми.';

  @override
  String get computerThinking => 'Компјутерот размислува...';

  @override
  String get seeBestMove => 'Види го најдобриот потег';

  @override
  String get hideBestMove => 'Скриј го најдобриот потег';

  @override
  String get getAHint => 'Добиј совет';

  @override
  String get evaluatingYourMove => 'Проценување на потегот...';

  @override
  String get whiteWinsGame => 'Победа на белите';

  @override
  String get blackWinsGame => 'Победа на црните';

  @override
  String get learnFromYourMistakes => 'Учи од своите грешки';

  @override
  String get learnFromThisMistake => 'Научи од оваа грешка';

  @override
  String get skipThisMove => 'Прескокни го потегов';

  @override
  String get next => 'Следно';

  @override
  String xWasPlayed(String param) {
    return 'Одиграно: $param';
  }

  @override
  String get findBetterMoveForWhite => 'Најди подобар потег за белите';

  @override
  String get findBetterMoveForBlack => 'Најди подобар потег за црните';

  @override
  String get resumeLearning => 'Продолжи со обуката';

  @override
  String get youCanDoBetter => 'Можеш и подобро';

  @override
  String get tryAnotherMoveForWhite => 'Пробај друг потег за белите';

  @override
  String get tryAnotherMoveForBlack => 'Пробај друг потег за црните';

  @override
  String get solution => 'Решение';

  @override
  String get waitingForAnalysis => 'Се чека анализа';

  @override
  String get noMistakesFoundForWhite => 'Нема грешки за белите';

  @override
  String get noMistakesFoundForBlack => 'Нема грешки за црните';

  @override
  String get doneReviewingWhiteMistakes => 'Завршен е прегледот за грешки на белите';

  @override
  String get doneReviewingBlackMistakes => 'Завршен е прегледот за грешки на црните';

  @override
  String get doItAgain => 'Прегледај ги повторно';

  @override
  String get reviewWhiteMistakes => 'Прегледај ги грешките на белите';

  @override
  String get reviewBlackMistakes => 'Прегледај ги грешките на црните';

  @override
  String get advantage => 'Предност';

  @override
  String get opening => 'Отворање';

  @override
  String get middlegame => 'Средишница';

  @override
  String get endgame => 'Завршница';

  @override
  String get conditionalPremoves => 'Условни пред-потези';

  @override
  String get addCurrentVariation => 'Додади ја сегашната варијанта';

  @override
  String get playVariationToCreateConditionalPremoves => 'Одиграј варијанта за да создадеш условен пред-потег';

  @override
  String get noConditionalPremoves => 'Нема условни пред-потези';

  @override
  String playX(String param) {
    return 'Играј $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Извини :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Моравме да те исклучиме на кратко.';

  @override
  String get why => 'Зошто?';

  @override
  String get pleasantChessExperience => 'Се стремиме да пружиме пријатно искуство за сите.';

  @override
  String get goodPractice => 'Поради тоа, мораме да се осигуриме дека сите играчи се чесни.';

  @override
  String get potentialProblem => 'Ако приметиме потенцијален проблем, ја покажуваме оваа порака.';

  @override
  String get howToAvoidThis => 'Како да се избегне ова?';

  @override
  String get playEveryGame => 'Изиграј ја секоја игра што ќе ја започнеш.';

  @override
  String get tryToWin => 'Пробај да победиш (или да изиграш нерешено) во секоја партија.';

  @override
  String get resignLostGames => 'Предади се кога ќе загубиш (не го оставај часовникот да истече).';

  @override
  String get temporaryInconvenience => 'Се извинуваме за привремената непогодност,';

  @override
  String get wishYouGreatGames => 'и ти посакуваме одлични партии на lichess.org.';

  @override
  String get thankYouForReading => 'Ти благодариме за читањето!';

  @override
  String get lifetimeScore => 'Вкупен резултат';

  @override
  String get currentMatchScore => 'Резултат на сегашниот меч';

  @override
  String get agreementAssistance => 'Се согласувам дека никогаш нема да добивам помош за моите игри (од компјутер, игра, база на податоци или личност).';

  @override
  String get agreementNice => 'Се согласувам дека секогаш ќе ги почитувам останатите играчи.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Се согласувам дека нема да креирам повеќе сметки (освен заради причини наведени во $param).';
  }

  @override
  String get agreementPolicy => 'Се согласувам дека ќе ги следам сите правила на Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Пребарај или започни нов разговор';

  @override
  String get edit => 'Уреди';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Рапид';

  @override
  String get classical => 'Класично';

  @override
  String get ultraBulletDesc => 'Неверојатно брзи партии: под 30 секунди';

  @override
  String get bulletDesc => 'Многу брзи партии: под 3 минути';

  @override
  String get blitzDesc => 'Брзи партии: 3 до 8 минути';

  @override
  String get rapidDesc => 'Рапидни партии: 8 до 25 минути';

  @override
  String get classicalDesc => 'Класични партии: над 25 минути';

  @override
  String get correspondenceDesc => 'Дописни партии: еден или повеќе денови по потег';

  @override
  String get puzzleDesc => 'Тренер за шаховски тактики';

  @override
  String get important => 'Важно';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Вашето прашање можеби е веќе одговорено $param1';
  }

  @override
  String get inTheFAQ => 'во ЧПП.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'За да пријавите корисник за мамење или лош однос, $param1';
  }

  @override
  String get useTheReportForm => 'користи го образецот за пријава';

  @override
  String toRequestSupport(String param1) {
    return 'За помош, $param1';
  }

  @override
  String get tryTheContactPage => 'обрати се на страната за контакт';

  @override
  String makeSureToRead(String param1) {
    return 'Обавезно прочитајте $param1';
  }

  @override
  String get theForumEtiquette => 'Форумски бон-тон';

  @override
  String get thisTopicIsArchived => 'Темата е архивирана и не дозволува нови објави.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Придружи се на $param1 за да објавуваш на овој форум';
  }

  @override
  String teamNamedX(String param1) {
    return 'тим $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Сеуште не можеш да објавуваш на форумот. Играј некоја игра!';

  @override
  String get subscribe => 'Заследи';

  @override
  String get unsubscribe => 'Престани да следиш';

  @override
  String mentionedYouInX(String param1) {
    return 'ве спомена во \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 ве спомена во \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'ве покани во \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 ве покани во \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Сега сте дел од тимот.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Се приклучивте на \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Некој што сте го пријавиле е баниран';

  @override
  String get congratsYouWon => 'Честитки, победивте!';

  @override
  String gameVsX(String param1) {
    return 'Игра против $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 против $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Изгубивте против некој кој ги прекршил правилата на Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Враќање: $param1 $param2 рејтинг поени';
  }

  @override
  String get timeAlmostUp => 'Времето е пред истекување!';

  @override
  String get clickToRevealEmailAddress => '[Кликнете за да се прикаже е-мајл адресата]';

  @override
  String get download => 'Преземете';

  @override
  String get coachManager => 'Поставки за тренер';

  @override
  String get streamerManager => 'Поставки за стример менаџер';

  @override
  String get cancelTournament => 'Откажи го турнирот';

  @override
  String get tournDescription => 'Опис на турнирот';

  @override
  String get tournDescriptionHelp => 'Дали сакате да им кажете нешто на натпреварувачите? Пробајте да бидете кратки. Markdown линкови се достапни: [name](https://url)';

  @override
  String get ratedFormHelp => 'Игрите се оценуваат\nи влијаат врз рејтингот на играчите';

  @override
  String get onlyMembersOfTeam => 'Само за членови на тимот';

  @override
  String get noRestriction => 'Без ограничувања';

  @override
  String get minimumRatedGames => 'Минимум рангирани игри';

  @override
  String get minimumRating => 'Минимален рејтинг';

  @override
  String get maximumWeeklyRating => 'Максимум неделен рејтинг';

  @override
  String positionInputHelp(String param) {
    return 'Ставете валиден FEN за да ја започнете секоја игра од одредена позиција.\nРаботи само за стандардни игри, не за варијации.\nМожете да го користите $param за да генерирате FEN позиција, а потоа да ја ставите овде.\nОставете празно за да ја почнете играта од нормална почетна позиција.';
  }

  @override
  String get cancelSimul => 'Откажи ја симултанката';

  @override
  String get simulHostcolor => 'Боја на организаторот во секоја игра';

  @override
  String get estimatedStart => 'Предвидено време на почеток';

  @override
  String simulFeatured(String param) {
    return 'Покажи на $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Покажете ја вашата симултанка на секого на $param. Оневозможи за приватни симултанки.';
  }

  @override
  String get simulDescription => 'Опис на симултанка';

  @override
  String get simulDescriptionHelp => 'Дали сакате нешто да им кажете на натпреварувачите?';

  @override
  String markdownAvailable(String param) {
    return '$param е достапен за понапредна синтакса.';
  }

  @override
  String get embedsAvailable => 'Залепете линк од игра или од поглавјето за проучување за да го вградите.';

  @override
  String get inYourLocalTimezone => 'Во вашата локална часовна зона';

  @override
  String get tournChat => 'Tурнирски разговор';

  @override
  String get noChat => 'Исклучи разговор';

  @override
  String get onlyTeamLeaders => 'Само тим лидери';

  @override
  String get onlyTeamMembers => 'Само членови на тим';

  @override
  String get navigateMoveTree => 'Навигирајте ја листата на движење';

  @override
  String get mouseTricks => 'Трикови со маусот';

  @override
  String get toggleLocalAnalysis => 'Вклучи/исклучи локална компјутерска анализа';

  @override
  String get toggleAllAnalysis => 'Вклучи/исклучи ги сите компјутерски анализи';

  @override
  String get playComputerMove => 'Играј го најдобриот компјутерски потег';

  @override
  String get analysisOptions => 'Опции за анализа';

  @override
  String get focusChat => 'Фокусирај разговор';

  @override
  String get showHelpDialog => 'Покажи прозорец за помош';

  @override
  String get reopenYourAccount => 'Повторно отвори ја твојата сметка';

  @override
  String get closedAccountChangedMind => 'Ако сте ја затвориле вашата сметка, но сте се предомислиле, имате една шанса да си ја вратите сметката.';

  @override
  String get onlyWorksOnce => 'Ова ќе работи само еднаш.';

  @override
  String get cantDoThisTwice => 'Ако во вторпат ја затворите вашата сметка, нема да можете да ја повратите.';

  @override
  String get emailAssociatedToaccount => 'Е-пошта поврзана со сметката';

  @override
  String get sentEmailWithLink => 'Ви испративме е-мајл со линк.';

  @override
  String get tournamentEntryCode => 'Лозинка за влез на турнир';

  @override
  String get hangOn => 'Чекај!';

  @override
  String gameInProgress(String param) {
    return 'Имате игра во прогрес $param.';
  }

  @override
  String get abortTheGame => 'Прекини ја играта';

  @override
  String get resignTheGame => 'Предади ја играта';

  @override
  String get youCantStartNewGame => 'Не можете да започнете нова игра додека моменталната не заврши.';

  @override
  String get since => 'Од';

  @override
  String get until => 'До';

  @override
  String get lichessDbExplanation => 'Одбрани рангирани игри од сите Lichess играчи';

  @override
  String get switchSides => 'Променете страна';

  @override
  String get closingAccountWithdrawAppeal => 'Затворањето на Вашиот профил ќе ја повлече жалбата';

  @override
  String get ourEventTips => 'Наши совети за организирање настани';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess е добротворна организација и целосно бесплатен/слободен софтвер со отворен код.\nСите оперативни трошоци, развој и содржина се финансираат исклучиво од донации на корисници.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Противникот ја напушти играта. Победувате за $count секунди.',
      one: 'Противникот ја напушти играта. Победувате за $count секунда.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мат во $count полупотези',
      one: 'Мат во $count полупотег',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count големи грешки',
      one: '$count голема грешка',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count грешки',
      one: '$count грешка',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count непрецизности',
      one: '$count непрецизност',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count приклучени играчи',
      one: '$count приклучени играчи',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Види ги сите $count игри',
      one: 'Види ги сите $count игри',
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
      other: '$count обележувачи',
      one: '$count обележувачи',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count денови',
      one: '$count денови',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часови',
      one: '$count часови',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минути',
      one: '$count минута',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ранкот се ажурира на секои $count минути',
      one: 'Ранкот се ажурира на секоја минута',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count загатки',
      one: '$count проблем',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игри со тебе',
      one: '$count игри со тебе',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рангирани игри',
      one: '$count рангирани игри',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count победи',
      one: '$count победи',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count порази',
      one: '$count порази',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нерешени',
      one: '$count нерешени',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играат',
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
      one: 'Додај $count секунди',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count турнирски поени',
      one: '$count турнирски поен',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count студии',
      one: '$count студија',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count симултанки',
      one: '$count симултанка',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count рангирани партии',
      one: '≥ $count рангирана партија',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 рангирани партии',
      one: '≥ $count $param2 рангирана партија',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мора да одиграте уште $count рангирани $param2 партии',
      one: 'Мора да одиграте уште $count рангирана $param2 партија',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мора да одиграте уште $count рангирани партии',
      one: 'Мора да одиграте уште $count рангирана партија',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count внесени игри',
      one: '$count внесени игри',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пријатели на линија',
      one: '$count пријател на линија',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count следбеници',
      one: '$count следбеници',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count следи',
      one: '$count следи',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Помалку од $count минути',
      one: 'Помалку од $count минути',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Игри во тек',
      one: '$count Игри во тек',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Максимум: $count знаци.',
      one: 'Максимум: $count знак.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count блокирани',
      one: '$count блокиран',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count објави на форумот',
      one: '$count објава на форумот',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '„$param2“ има $count играчи оваа седмица.',
      one: '„$param2“ има $count играч оваа седмица.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Достапно на $count јазици!',
      one: 'Достапно на $count јазик!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунди за првиот потег',
      one: '$count секунда за првиот потег',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунди',
      one: '$count секунда',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'и заштеди $count пред-потези',
      one: 'и заштеди $count пред-потег',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Move to start';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'You play the white pieces in all puzzles';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'You play the black pieces in all puzzles';

  @override
  String get stormPuzzlesSolved => 'puzzles solved';

  @override
  String get stormNewDailyHighscore => 'New daily highscore!';

  @override
  String get stormNewWeeklyHighscore => 'New weekly highscore!';

  @override
  String get stormNewMonthlyHighscore => 'New monthly highscore!';

  @override
  String get stormNewAllTimeHighscore => 'New all-time highscore!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Previous highscore was $param';
  }

  @override
  String get stormPlayAgain => 'Play again';

  @override
  String stormHighscoreX(String param) {
    return 'Highscore: $param';
  }

  @override
  String get stormScore => 'Score';

  @override
  String get stormMoves => 'Moves';

  @override
  String get stormAccuracy => 'Accuracy';

  @override
  String get stormCombo => 'Combo';

  @override
  String get stormTime => 'Time';

  @override
  String get stormTimePerMove => 'Time per move';

  @override
  String get stormHighestSolved => 'Highest solved';

  @override
  String get stormPuzzlesPlayed => 'Puzzles played';

  @override
  String get stormNewRun => 'New run (hotkey: Space)';

  @override
  String get stormEndRun => 'End run (hotkey: Enter)';

  @override
  String get stormHighscores => 'Highscores';

  @override
  String get stormViewBestRuns => 'View best runs';

  @override
  String get stormBestRunOfDay => 'Best run of day';

  @override
  String get stormRuns => 'Runs';

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
      other: '$count runs',
      one: '1 run',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Played $count runs of $param2',
      one: 'Played one run of $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streamers';

  @override
  String get studyShareAndExport => 'Share & export';

  @override
  String get studyStart => 'Start';
}
