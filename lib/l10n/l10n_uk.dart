import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

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
  String get activityActivity => 'Активність';

  @override
  String get activityHostedALiveStream => 'Проведено пряму трансляцію';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Зайняв #$param1 місце в $param2';
  }

  @override
  String get activitySignedUp => 'Зареєструвався на lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Підтримує lichess.org протягом $count місяців як $param2',
      many: 'Підтримує lichess.org протягом $count місяців як $param2',
      few: 'Підтримує lichess.org протягом $count місяців як $param2',
      one: 'Підтримує lichess.org протягом $count місяця як $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Виконано $count вправ в $param2',
      many: 'Виконано $count вправ в $param2',
      few: 'Виконано $count вправи в $param2',
      one: 'Виконано $count вправу в $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вирішено $count тактичних задач',
      many: 'Вирішено $count тактичних задач',
      few: 'Вирішено $count тактичні задачі',
      one: 'Вирішено $count тактичну задачу',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зіграно $count ігор в $param2',
      many: 'Зіграно $count ігор в $param2',
      few: 'Зіграно $count гри в $param2',
      one: 'Зіграно $count гру в $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Опубліковано $count повідомлень в $param2',
      many: 'Опубліковано $count повідомлень в $param2',
      few: 'Опубліковано $count повідомлення в $param2',
      one: 'Опубліковано $count повідомлення в $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зроблено $count ходів',
      many: 'Зроблено $count ходів',
      few: 'Зроблено $count ходи',
      one: 'Зроблено $count хід',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'у $count заочних ігор',
      many: 'у $count заочних іграх',
      few: 'у $count заочних іграх',
      one: 'у $count заочній грі',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зіграно $count заочних ігор',
      many: 'Зіграно $count заочних ігор',
      few: 'Зіграно $count заочні гри',
      one: 'Зіграно $count заочну гру',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Почав спостерігати за $count гравцями',
      many: 'Почав спостерігати за $count гравцями',
      few: 'Почав спостерігати за $count гравцями',
      one: 'Підписався на $count гравця',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Отримав $count нових підписників',
      many: 'Отримав $count нових підписників',
      few: 'Отримав $count нових підписників',
      one: 'Отримав $count нового підписника',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Провів $count сеансів одночасної гри',
      many: 'Провів $count сеансів одночасної гри',
      few: 'Провів $count сеанси одночасної гри',
      one: 'Провів $count сеанс одночасної гри',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Брав участь в $count сеансів одночасної гри',
      many: 'Брав участь в $count сеансах одночасної гри',
      few: 'Брав участь в $count сеансах одночасної гри',
      one: 'Брав участь у $count сеансі одночасної гри',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Створено $count нових досліджень',
      many: 'Створено $count нових досліджень',
      few: 'Створено $count нові дослідження',
      one: 'Створено $count нове дослідження',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Змагався в $count турнірів',
      many: 'Змагався в $count турнірах',
      few: 'Змагався в $count турнірах',
      one: 'Змагався в $count турнірі',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Досяг #$count місця (кращі $param2%), зіграно $param3 ігор, турнір: $param4',
      many: 'Досяг #$count місця (кращі $param2%), зіграно $param3 ігор, турнір: $param4',
      few: 'Досяг #$count місця (кращі $param2%), зіграно $param3 гри, турнір: $param4',
      one: 'Досяг #$count місця (кращі $param2%), зіграна $param3 гра, в турнірі: $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завершив $count турніри за швейцарською системою',
      many: 'Завершив $count турнірів за швейцарською системою',
      few: 'Завершив $count турніри за швейцарською системою',
      one: 'Завершив $count турнір за швейцарською системою',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Приєднався до $count команд',
      many: 'Приєднався до $count команд',
      few: 'Приєднався до $count команд',
      one: 'Приєднався до $count команди',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Трансляції';

  @override
  String get broadcastLiveBroadcasts => 'Онлайн трансляції турнірів';

  @override
  String challengeChallengesX(String param1) {
    return 'Виклики: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Виклик на гру';

  @override
  String get challengeChallengeDeclined => 'Виклик відхилено';

  @override
  String get challengeChallengeAccepted => 'Виклик прийнято!';

  @override
  String get challengeChallengeCanceled => 'Виклик скасовано.';

  @override
  String get challengeRegisterToSendChallenges => 'Зареєструйтесь, щоб викликати суперників на гру.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Ви не можете викликати на гру $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param не приймає викликів.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Ваш рейтинг $param1 занадто далекий від $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Неможливо через умовність рейтингу $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param приймає виклики лише від друзів.';
  }

  @override
  String get challengeDeclineGeneric => 'Зараз я не приймаю викликів.';

  @override
  String get challengeDeclineLater => 'Зараз не найкращий час для мене, будь ласка, напишіть пізніше.';

  @override
  String get challengeDeclineTooFast => 'Цей контроль часу занадто швидкий для мене, будь ласка, киньте виклик з більш повільною грою.';

  @override
  String get challengeDeclineTooSlow => 'Цей контроль часу занадто повільний для мене, будь ласка, киньте виклик з більш швидкою грою.';

  @override
  String get challengeDeclineTimeControl => 'Я не приймаю виклики з таким контролем часу.';

  @override
  String get challengeDeclineRated => 'Будь ласка, замість цього відправте мені рейтинговий виклик.';

  @override
  String get challengeDeclineCasual => 'Будь ласка, замість цього відправте мені товариський виклик.';

  @override
  String get challengeDeclineStandard => 'Я не приймаю виклики на шахові варіанти прямо зараз.';

  @override
  String get challengeDeclineVariant => 'Я не бажаю наразі грати цей варіант.';

  @override
  String get challengeDeclineNoBot => 'Я не приймаю виклики від ботів.';

  @override
  String get challengeDeclineOnlyBot => 'Я приймаю виклики лише від ботів.';

  @override
  String get challengeInviteLichessUser => 'Або запросіть користувача Lichess:';

  @override
  String get contactContact => 'Контакти';

  @override
  String get contactContactLichess => 'Зв\'язатися з Lichess';

  @override
  String get patronDonate => 'Зробити внесок';

  @override
  String get patronLichessPatron => 'Покровитель Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Статистика $param';
  }

  @override
  String get perfStatViewTheGames => 'Переглянути ігри';

  @override
  String get perfStatProvisional => 'умовний';

  @override
  String get perfStatNotEnoughRatedGames => 'Зіграно недостатньо рейтингових ігор для встановлення точного рейтингу.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Прогрес за останні $param ігор:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Відхилення рейтингу: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Чим менше значення, тим стабільніше рейтинг. Вище $param1, рейтинг вважається умовним. Для включення до рейтингу це значення має бути нижче $param2 (стандартні шахи) або $param3 (варіанти).';
  }

  @override
  String get perfStatTotalGames => 'Всього ігор';

  @override
  String get perfStatRatedGames => 'Рейтингові ігри';

  @override
  String get perfStatTournamentGames => 'Турнірні ігри';

  @override
  String get perfStatBerserkedGames => 'Партії з берсерком';

  @override
  String get perfStatTimeSpentPlaying => 'Проведено часу у грі';

  @override
  String get perfStatAverageOpponent => 'Середній рейтинг суперників';

  @override
  String get perfStatVictories => 'Перемог';

  @override
  String get perfStatDefeats => 'Поразок';

  @override
  String get perfStatDisconnections => 'Відключень';

  @override
  String get perfStatNotEnoughGames => 'Недостатньо зіграних ігор';

  @override
  String perfStatHighestRating(String param) {
    return 'Найвищий рейтинг: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Найнижчий рейтинг: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'від $param1 до $param2';
  }

  @override
  String get perfStatWinningStreak => 'Серія перемог';

  @override
  String get perfStatLosingStreak => 'Серія поразок';

  @override
  String perfStatLongestStreak(String param) {
    return 'Найдовша серія: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Поточна серія: $param';
  }

  @override
  String get perfStatBestRated => 'Найкращі перемоги в рейтингових іграх';

  @override
  String get perfStatGamesInARow => 'Зіграно ігор поспіль';

  @override
  String get perfStatLessThanOneHour => 'Менше години між іграми';

  @override
  String get perfStatMaxTimePlaying => 'Максимальний час, проведений у грі';

  @override
  String get perfStatNow => 'зараз';

  @override
  String get preferencesPreferences => 'Налаштування';

  @override
  String get preferencesDisplay => 'Відображення';

  @override
  String get preferencesPrivacy => 'Конфіденційність';

  @override
  String get preferencesNotifications => 'Сповіщення';

  @override
  String get preferencesPieceAnimation => 'Анімація ходів';

  @override
  String get preferencesMaterialDifference => 'Співвідношення матеріалу';

  @override
  String get preferencesBoardHighlights => 'Підсвітлення кольором (останнього ходу та шаху)';

  @override
  String get preferencesPieceDestinations => 'Поля для ходів (можливі ходи та ходи на випередження)';

  @override
  String get preferencesBoardCoordinates => 'Координати (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Список ходів під час гри';

  @override
  String get preferencesPgnPieceNotation => 'Нотація ходів';

  @override
  String get preferencesChessPieceSymbol => 'Символ шахової фігури';

  @override
  String get preferencesPgnLetter => 'Літера (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Режим Дзен';

  @override
  String get preferencesShowPlayerRatings => 'Показувати рейтинги гравців';

  @override
  String get preferencesShowFlairs => 'Показувати символи гравців';

  @override
  String get preferencesExplainShowPlayerRatings => 'Дає змогу приховувати всі рейтинги з сайту, щоб допомогти зосередитись на шахах. Ігри все ще рейтингові, це лише для відображення.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Показати інструмент для зміни розміру дошки';

  @override
  String get preferencesOnlyOnInitialPosition => 'Лише в початковій позиції';

  @override
  String get preferencesInGameOnly => 'Лише під час гри';

  @override
  String get preferencesChessClock => 'Шаховий годинник';

  @override
  String get preferencesTenthsOfSeconds => 'Десяті частки секунди';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Коли часу залишається < 10 секунд';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Горизонтальна зелена смуга';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Звук, коли часу стає зовсім обмаль';

  @override
  String get preferencesGiveMoreTime => 'Додати часу';

  @override
  String get preferencesGameBehavior => 'Хід гри';

  @override
  String get preferencesHowDoYouMovePieces => 'Як Ви пересуваєте фігури?';

  @override
  String get preferencesClickTwoSquares => 'Натискання на дві клітинки';

  @override
  String get preferencesDragPiece => 'Перетягування фігури';

  @override
  String get preferencesBothClicksAndDrag => 'Будь-яким способом';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Ходи на випередження (коли хід суперника)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Можливість переходити (за згоди суперника)';

  @override
  String get preferencesInCasualGamesOnly => 'Тільки у товариських іграх';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Перетворення пішака завжди на ферзя';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Утримуйте клавішу <ctrl> під час перетворення, щоб тимчасово вимкнути автоматичне перетворення';

  @override
  String get preferencesWhenPremoving => 'Для ходів на випередження';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Автоматично оголошувати нічию при троєкратному повторенні ходів';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Коли часу залишається < 30 секунд';

  @override
  String get preferencesMoveConfirmation => 'Підтвердження ходу';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Можна вимкнути під час гри в меню дошки';

  @override
  String get preferencesInCorrespondenceGames => 'У заочних партіях';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'За листуванням та необмежені';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Підтверджувати повернення ходу та пропозиції нічий';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Спосіб рокіровки';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Перемістити короля на два поля';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Перемістити короля на поле, що межує з турою';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Вводити ходи за допомогою клавіатури';

  @override
  String get preferencesInputMovesWithVoice => 'Введення ходів за допомогою голосу';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Стрілки лише для можливих ходів';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Писати в чат \"Хороша гра, добре зіграно\" після поразки або нічиєї';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Ваші налаштування збережено.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Прокрутіть колесом миші на дошці, для того щоб відтворити ходи';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Щоденне сповіщення на електронну пошту зі списком ваших заочних ігор';

  @override
  String get preferencesNotifyStreamStart => 'Стример почав трансляцію';

  @override
  String get preferencesNotifyInboxMsg => 'Нове вхідне повідомлення';

  @override
  String get preferencesNotifyForumMention => 'Вас згадали у коментарі на форумі';

  @override
  String get preferencesNotifyInvitedStudy => 'Запрошення до студії';

  @override
  String get preferencesNotifyGameEvent => 'Оновлення заочних партій';

  @override
  String get preferencesNotifyChallenge => 'Виклики';

  @override
  String get preferencesNotifyTournamentSoon => 'Турнір скоро почнеться';

  @override
  String get preferencesNotifyTimeAlarm => 'Час на відповідь закінчується';

  @override
  String get preferencesNotifyBell => 'Звукове сповіщення в Lichess';

  @override
  String get preferencesNotifyPush => 'Сповіщення на пристрої, коли ви не на Lichess';

  @override
  String get preferencesNotifyWeb => 'Браузер';

  @override
  String get preferencesNotifyDevice => 'Пристрій';

  @override
  String get preferencesBellNotificationSound => 'Звук сповіщення';

  @override
  String get puzzlePuzzles => 'Задачі';

  @override
  String get puzzlePuzzleThemes => 'Теми задач';

  @override
  String get puzzleRecommended => 'Рекомендовані';

  @override
  String get puzzlePhases => 'Стадії';

  @override
  String get puzzleMotifs => 'Мотиви';

  @override
  String get puzzleAdvanced => 'Просунутий';

  @override
  String get puzzleLengths => 'Довжина';

  @override
  String get puzzleMates => 'Мати';

  @override
  String get puzzleGoals => 'Цілі';

  @override
  String get puzzleOrigin => 'Джерело';

  @override
  String get puzzleSpecialMoves => 'Спеціальні ходи';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Вам сподобалась ця задача?';

  @override
  String get puzzleVoteToLoadNextOne => 'Голосуйте, щоб перейти далі!';

  @override
  String get puzzleUpVote => 'Вподобати задачу';

  @override
  String get puzzleDownVote => 'Не вподобати задачу';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Ваш рейтинг у задачах не зміниться. Зверніть увагу, що задачі - це не змагання. Ваш рейтинг допомагає підбирати задачі за вашими вміннями.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Знайдіть найкращий хід за білих.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Знайдіть найкращий хід за чорних.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Для отримання персоналізованих задач:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Задача $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Задача дня';

  @override
  String get puzzleDailyPuzzle => 'Щоденна задача';

  @override
  String get puzzleClickToSolve => 'Натисніть, щоб вирішити';

  @override
  String get puzzleGoodMove => 'Хороший хід';

  @override
  String get puzzleBestMove => 'Найкращий хід!';

  @override
  String get puzzleKeepGoing => 'Продовжуйте...';

  @override
  String get puzzlePuzzleSuccess => 'Успіх!';

  @override
  String get puzzlePuzzleComplete => 'Задачу вирішено!';

  @override
  String get puzzleByOpenings => 'За дебютами';

  @override
  String get puzzlePuzzlesByOpenings => 'Задачі за дебютами';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Дебюти, які ви грали найбільше в рейтингових іграх';

  @override
  String get puzzleUseFindInPage => 'Використайте \"Знайти на сторінці\" в меню браузера, щоб знайти свій улюблений дебют!';

  @override
  String get puzzleUseCtrlF => 'Використайте Ctrl+F, щоб знайти свій улюблений дебют!';

  @override
  String get puzzleNotTheMove => 'Поганий хід!';

  @override
  String get puzzleTrySomethingElse => 'Спробуйте щось інше.';

  @override
  String puzzleRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get puzzleHidden => 'прихований';

  @override
  String puzzleFromGameLink(String param) {
    return 'З партії $param';
  }

  @override
  String get puzzleContinueTraining => 'Продовжити тренування';

  @override
  String get puzzleDifficultyLevel => 'Рівень складності';

  @override
  String get puzzleNormal => 'Нормальний';

  @override
  String get puzzleEasier => 'Легший';

  @override
  String get puzzleEasiest => 'Найлегший';

  @override
  String get puzzleHarder => 'Складніше';

  @override
  String get puzzleHardest => 'Найскладніший';

  @override
  String get puzzleExample => 'Приклад';

  @override
  String get puzzleAddAnotherTheme => 'Додати іншу тему';

  @override
  String get puzzleNextPuzzle => 'Наступна задача';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Одразу перейти до наступної задачі';

  @override
  String get puzzlePuzzleDashboard => 'Панель задач';

  @override
  String get puzzleImprovementAreas => 'Слабкі сторони';

  @override
  String get puzzleStrengths => 'Сильні сторони';

  @override
  String get puzzleHistory => 'Історія задач';

  @override
  String get puzzleSolved => 'вирішено';

  @override
  String get puzzleFailed => 'невирішено';

  @override
  String get puzzleStreakDescription => 'Вирішуйте щораз важчі задачі та створюйте серію перемог. Обмеження часу немає, тому не поспішайте. Один хибний хід, і гра закінчена! Але ви можете пропустити один хід за сесію.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Ваша серія: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Пропустіть цей хід, щоб зберегти Вашу серію! Але лише один раз за сесію.';

  @override
  String get puzzleContinueTheStreak => 'Продовжити серію';

  @override
  String get puzzleNewStreak => 'Нова серія';

  @override
  String get puzzleFromMyGames => 'З моїх ігор';

  @override
  String get puzzleLookupOfPlayer => 'Знайти задачі з ігр користувача';

  @override
  String puzzleFromXGames(String param) {
    return 'Задачі з ігор $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Шукати задачі';

  @override
  String get puzzleFromMyGamesNone => 'Ваших задач немає в базі даних, проте Lichess все одно дуже сильно вас любить.\nГрайте ігри в рапід або з класичною системою контролю часу, для того щоб збільшити можливість додання вашої задачі!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 задач знайдено в $param2 іграх';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Тренуйтеся, аналізуйте, вдосконалюйтесь';

  @override
  String puzzlePercentSolved(String param) {
    return '$param вирішено';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Немає що показати, спочатку вирішіть кілька задач!';

  @override
  String get puzzleImprovementAreasDescription => 'Тренуйтеся, щоб покращити ваш прогрес!';

  @override
  String get puzzleStrengthDescription => 'Ви показуєте найкращий результат в наступних темах';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зіграно $count разів',
      many: 'Зіграно $count раз',
      few: 'Зіграно $count рази',
      one: 'Зіграно $count раз',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'На $count балів нижче за ваш рейтинг у задачах',
      many: '$count балів нижче вашого рейтингу в задачах',
      few: '$count бали нижче вашого рейтингу в задачах',
      one: 'На один бал нижче вашого рейтингу в задачах',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count балів вище вашого рейтингу в задачах',
      many: '$count балів вище вашого рейтингу в задачах',
      few: '$count бали вище вашого рейтингу в задачах',
      one: 'Один бал вище вашого рейтингу в задачах',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зіграно',
      many: '$count зіграно',
      few: '$count зіграно',
      one: '$count зіграно',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count повторити',
      many: '$count повторити',
      few: '$count повторити',
      one: '$count повторити',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Просунутий пішак';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Один з Ваших пішаків просунувся по позиціях суперника, ймовірна загроза перетворення.';

  @override
  String get puzzleThemeAdvantage => 'Перевага';

  @override
  String get puzzleThemeAdvantageDescription => 'Скористайтесь шансом отримати вирішальну перевагу. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Мат Анастасії';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Кінь з турою або ферзем ловлять короля між краєм дошки та власною фігурою.';

  @override
  String get puzzleThemeArabianMate => 'Арабський мат';

  @override
  String get puzzleThemeArabianMateDescription => 'Кінь та тура разом ловлять короля у кутку дошки.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Атака f2 або f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Атака, спрямована на f2 або f7, наприклад, як у дебюті смаженої печінки.';

  @override
  String get puzzleThemeAttraction => 'Заманювання';

  @override
  String get puzzleThemeAttractionDescription => 'Обмін або жертва, що заманює або примушує суперника зробити хід, що дозволяє проводити подальшу тактику.';

  @override
  String get puzzleThemeBackRankMate => 'Мат по останній горизонталі';

  @override
  String get puzzleThemeBackRankMateDescription => 'Мат королю в домашньому ряду, коли він у пастці між власними фігурами.';

  @override
  String get puzzleThemeBishopEndgame => 'Слоновий ендшпіль';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Ендшпіль лише зі слонами та пішаками.';

  @override
  String get puzzleThemeBodenMate => 'Мат Бодена';

  @override
  String get puzzleThemeBodenMateDescription => 'Два слони на перехресних діагоналях ставлять мат королю, який оточений власними фігурами.';

  @override
  String get puzzleThemeCastling => 'Рокіровка';

  @override
  String get puzzleThemeCastlingDescription => 'Захистіть свого короля й виведіть у бій туру.';

  @override
  String get puzzleThemeCapturingDefender => 'Захоплення захисника';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Захоплення фігури, що захищає іншу фігуру, дозволяє захопити незахищену фігуру наступним ходом.';

  @override
  String get puzzleThemeCrushing => 'Руйнування';

  @override
  String get puzzleThemeCrushingDescription => 'Знайдіть грубу помилку суперника, щоб отримати нищівну перевагу. (eval ≥ 600 cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Мат двома слонами';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Два слони на сусідніх діагоналях ставлять мат королю, який оточений власними фігурами.';

  @override
  String get puzzleThemeDovetailMate => 'Мат \"ластів\'ячий хвіст\"';

  @override
  String get puzzleThemeDovetailMateDescription => 'Королева ставить мат королю поруч, єдині два поля для відступу якого зайняті його власними фігурами.';

  @override
  String get puzzleThemeEquality => 'Рівність';

  @override
  String get puzzleThemeEqualityDescription => 'Повернення з програшної позиції, забезпечення нічиєї або отримання збалансованої позиції. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Атака на королівський фланг';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Атака короля суперника, після його короткого рокірування.';

  @override
  String get puzzleThemeClearance => 'Очищення';

  @override
  String get puzzleThemeClearanceDescription => 'Хід, зазвичай з темпом, що звільнює поле, вертикаль чи діагональ з подальшою тактичною ідеєю.';

  @override
  String get puzzleThemeDefensiveMove => 'Захисний хід';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Точний хід або послідовність ходів, що необхідні для уникнення втрати матеріалу чи іншої переваги.';

  @override
  String get puzzleThemeDeflection => 'Відволікання';

  @override
  String get puzzleThemeDeflectionDescription => 'Хід, що відволікає фігуру суперника від іншої виконуваної задачі, наприклад, захисту ключового поля. Деколи ще звуть \"перевантаженням\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Відкритий напад';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Хід фігурою (наприклад, конем), яка до цього блокувала атаку далекобійної фігури (наприклад, тури), геть з лінії цієї фігури.';

  @override
  String get puzzleThemeDoubleCheck => 'Подвійний шах';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Шах двома фігурами одночасно, як наслідок відкриття атаки на короля, коли обидві фігури неможливо захопити.';

  @override
  String get puzzleThemeEndgame => 'Ендшпіль';

  @override
  String get puzzleThemeEndgameDescription => 'Тактика на останній фазі гри.';

  @override
  String get puzzleThemeEnPassantDescription => 'Тактика із застосуванням правила \"взяття на проході\", коли пішак може взяти пішака суперника, що зробив початковий хід на два поля, внаслідок якого перетинаюче поле під боєм пішака.';

  @override
  String get puzzleThemeExposedKing => 'Незахищений король';

  @override
  String get puzzleThemeExposedKingDescription => 'Король з малою кількістю захисників, що часто призводить до мату.';

  @override
  String get puzzleThemeFork => 'Вилка';

  @override
  String get puzzleThemeForkDescription => 'Хід, коли фігура атакує дві фігури одночасно.';

  @override
  String get puzzleThemeHangingPiece => 'Незахищена фігура';

  @override
  String get puzzleThemeHangingPieceDescription => 'Незахищена або недостатньо захищена фігура, що може бути атакована.';

  @override
  String get puzzleThemeHookMate => 'Хук-мат';

  @override
  String get puzzleThemeHookMateDescription => 'Мат турою, конем і пішаком разом з одним ворожим пішаком, щоб обмежити втечу ворожого короля.';

  @override
  String get puzzleThemeInterference => 'Перешкода';

  @override
  String get puzzleThemeInterferenceDescription => 'Хід фігурою між двома фігурами суперника, що перешкоджає одній або двом фігурам суперника і робить їх незахищеними, наприклад, кінь на захищеному полі між двома турами.';

  @override
  String get puzzleThemeIntermezzo => 'Проміжний хід';

  @override
  String get puzzleThemeIntermezzoDescription => 'Замість очікуваного ходу, спочатку робиться інший хід з безпосередньою атакою, на яку суперник має відповісти. Також відомий як \"Zwischenzug\" або \"In between\".';

  @override
  String get puzzleThemeKnightEndgame => 'Коньовий ендшпіль';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Ендшпіль лише з конями та пішаками.';

  @override
  String get puzzleThemeLong => 'Багатоходова задача';

  @override
  String get puzzleThemeLongDescription => 'Перемога за три ходи.';

  @override
  String get puzzleThemeMaster => 'Партії майстрів';

  @override
  String get puzzleThemeMasterDescription => 'Задачі з ігор титулованих гравців.';

  @override
  String get puzzleThemeMasterVsMaster => 'Ігри двох майстрів';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Задачі з ігор, які були зіграні двома титулованими гравцями.';

  @override
  String get puzzleThemeMate => 'Мат';

  @override
  String get puzzleThemeMateDescription => 'Виграйте гру красиво.';

  @override
  String get puzzleThemeMateIn1 => 'Мат в 1 хід';

  @override
  String get puzzleThemeMateIn1Description => 'Поставте мат в один хід.';

  @override
  String get puzzleThemeMateIn2 => 'Мат в 2 ходи';

  @override
  String get puzzleThemeMateIn2Description => 'Поставте мат в два ходи.';

  @override
  String get puzzleThemeMateIn3 => 'Мат в 3 ходи';

  @override
  String get puzzleThemeMateIn3Description => 'Поставте мат в три ходи.';

  @override
  String get puzzleThemeMateIn4 => 'Мат в 4 ходи';

  @override
  String get puzzleThemeMateIn4Description => 'Поставте мат в чотири ходи.';

  @override
  String get puzzleThemeMateIn5 => 'Мат в 5 або більше';

  @override
  String get puzzleThemeMateIn5Description => 'Знайдіть послідовність ходів, що призводить до мату.';

  @override
  String get puzzleThemeMiddlegame => 'Мітельшпіль';

  @override
  String get puzzleThemeMiddlegameDescription => 'Тактика на другому етапі гри.';

  @override
  String get puzzleThemeOneMove => 'Задача в один хід';

  @override
  String get puzzleThemeOneMoveDescription => 'Задача, що складається лише з одного ходу.';

  @override
  String get puzzleThemeOpening => 'Дебют';

  @override
  String get puzzleThemeOpeningDescription => 'Тактика на першому етапі гри.';

  @override
  String get puzzleThemePawnEndgame => 'Пішаковий ендшпіль';

  @override
  String get puzzleThemePawnEndgameDescription => 'Ендшпіль лише з пішаками.';

  @override
  String get puzzleThemePin => 'Зв\'язування';

  @override
  String get puzzleThemePinDescription => 'Тактика, коли фігура не може зробити хід, тому що буде втрачена цінніша фігура.';

  @override
  String get puzzleThemePromotion => 'Перетворення';

  @override
  String get puzzleThemePromotionDescription => 'Перетворення пішака або загроза перетворення є ключовою тактикою.';

  @override
  String get puzzleThemeQueenEndgame => 'Ферзевий ендшпіль';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Ендшпіль лише з ферзем та пішаками.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Ферзевий та туровий ендшпіль';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Ендшпіль лише з ферзями, турами та пішаками.';

  @override
  String get puzzleThemeQueensideAttack => 'Атака на ферзевому фланзі';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Атака на короля суперника, після того як він зробив рокіровку на ферзевому фланзі.';

  @override
  String get puzzleThemeQuietMove => 'Тихий хід';

  @override
  String get puzzleThemeQuietMoveDescription => 'Хід, який не робить шах чи захоплення, але готує неминучу загрозу для подальшого ходу.';

  @override
  String get puzzleThemeRookEndgame => 'Туровий ендшпіль';

  @override
  String get puzzleThemeRookEndgameDescription => 'Ендшпіль лише з турами та пішаками.';

  @override
  String get puzzleThemeSacrifice => 'Жертва';

  @override
  String get puzzleThemeSacrificeDescription => 'Тактика, що полягає в жертві матеріалу з подальшим отриманням переваги після послідовності вимушених ходів.';

  @override
  String get puzzleThemeShort => 'Коротка задача';

  @override
  String get puzzleThemeShortDescription => 'Два ходи до перемоги.';

  @override
  String get puzzleThemeSkewer => 'Лінійний удар';

  @override
  String get puzzleThemeSkewerDescription => 'Мотив, що включає атаку цінної фігури менш цінною, протилежність зв\'язування.';

  @override
  String get puzzleThemeSmotheredMate => 'Спертий мат';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Мат конем, коли король не може вийти з-під атаки, тому що оточений (спертий) власними фігурами.';

  @override
  String get puzzleThemeSuperGM => 'Ігри супергросмейстерів';

  @override
  String get puzzleThemeSuperGMDescription => 'Задачі з ігор, які були зіграні найкращими гравцями світу.';

  @override
  String get puzzleThemeTrappedPiece => 'Фігура у пастці';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Фігура не може уникнути захоплення, тому що не має ходів для відступу.';

  @override
  String get puzzleThemeUnderPromotion => 'Перетворення на слабку фігуру';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Перетворення пішака на коня, слона чи туру.';

  @override
  String get puzzleThemeVeryLong => 'Дуже довга задача';

  @override
  String get puzzleThemeVeryLongDescription => 'Чотири чи більше ходи до перемоги.';

  @override
  String get puzzleThemeXRayAttack => 'Рентген';

  @override
  String get puzzleThemeXRayAttackDescription => 'Фігура, що атакує чи захищає поле, що знаходиться за фігурою суперника.';

  @override
  String get puzzleThemeZugzwang => 'Цугцванг';

  @override
  String get puzzleThemeZugzwangDescription => 'Суперник обмежений в своїх ходах, а кожен хід погіршує його позицію.';

  @override
  String get puzzleThemeHealthyMix => 'Здорова суміш';

  @override
  String get puzzleThemeHealthyMixDescription => 'Всього потроху. Ви не знаєте, чого очікувати, тому готуйтесь до всього! Як у справжніх партіях.';

  @override
  String get puzzleThemePlayerGames => 'Ігри гравця';

  @override
  String get puzzleThemePlayerGamesDescription => 'Пошук задач, згенерованих з ваших ігор або з ігор інших гравців.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Ці задачі є у публічному доступі та можуть бути завантажені з $param.';
  }

  @override
  String get searchSearch => 'Пошук';

  @override
  String get settingsSettings => 'Налаштування';

  @override
  String get settingsCloseAccount => 'Закрити обліковий запис';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Ваш обліковий запис керований і не може бути закритим.';

  @override
  String get settingsClosingIsDefinitive => 'Видалення облікового запису остаточне. Цей процес незворотній. Ви впевнені?';

  @override
  String get settingsCantOpenSimilarAccount => 'Ви не зможете створити новий обліковий запис з такою ж назвою, навіть зі зміною регістру.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Я передумав, не закривайте мій обліковий запис';

  @override
  String get settingsCloseAccountExplanation => 'Ви впевнені, що хочете закрити свій обліковий запис? Закриття вашого облікового запису є незмінним рішенням. Ви НІКОЛИ не зможете знову увійти в цей обліковий запис.';

  @override
  String get settingsThisAccountIsClosed => 'Цей обліковий запис видалено.';

  @override
  String get playWithAFriend => 'Грати з другом';

  @override
  String get playWithTheMachine => 'Грати з комп’ютером';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Щоб запросити когось до гри, дайте це посилання';

  @override
  String get gameOver => 'Гру завершено';

  @override
  String get waitingForOpponent => 'Очікування на суперника';

  @override
  String get orLetYourOpponentScanQrCode => 'Або дайте вашому супернику просканувати цей QR-код';

  @override
  String get waiting => 'Очікування';

  @override
  String get yourTurn => 'Ваш хід';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1, рівень $param2';
  }

  @override
  String get level => 'Рівень';

  @override
  String get strength => 'Сила';

  @override
  String get toggleTheChat => 'Вимк./увімк. чат';

  @override
  String get chat => 'Чат';

  @override
  String get resign => 'Здатися';

  @override
  String get checkmate => 'Мат';

  @override
  String get stalemate => 'Пат';

  @override
  String get white => 'Білі';

  @override
  String get black => 'Чорні';

  @override
  String get asWhite => 'за бiлих';

  @override
  String get asBlack => 'за чорних';

  @override
  String get randomColor => 'Випадковий колір';

  @override
  String get createAGame => 'Створити гру';

  @override
  String get whiteIsVictorious => 'Білі перемогли';

  @override
  String get blackIsVictorious => 'Чорні перемогли';

  @override
  String get youPlayTheWhitePieces => 'Ви граєте білими фігурами';

  @override
  String get youPlayTheBlackPieces => 'Ви граєте чорними фігурами';

  @override
  String get itsYourTurn => 'Ваш хід!';

  @override
  String get cheatDetected => 'Виявлено нечесну гру';

  @override
  String get kingInTheCenter => 'Король у центрі';

  @override
  String get threeChecks => 'Три шахи';

  @override
  String get raceFinished => 'Перегони завершено';

  @override
  String get variantEnding => 'Гру завершено';

  @override
  String get newOpponent => 'Новий суперник';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Ваш суперник хоче зіграти знову';

  @override
  String get joinTheGame => 'Приєднатися до гри';

  @override
  String get whitePlays => 'Хід білих';

  @override
  String get blackPlays => 'Хід чорних';

  @override
  String get opponentLeftChoices => 'Ваш суперник залишив гру. Ви можете оголосити перемогу, нічию, або зачекати.';

  @override
  String get forceResignation => 'Оголосити перемогу';

  @override
  String get forceDraw => 'Оголосити нічию';

  @override
  String get talkInChat => 'Будь ласка, будьте ввічливими!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Перша людина, яка перейде за цим посиланням, гратиме з вами.';

  @override
  String get whiteResigned => 'Білі здалися';

  @override
  String get blackResigned => 'Чорні здалися';

  @override
  String get whiteLeftTheGame => 'Білі залишили гру';

  @override
  String get blackLeftTheGame => 'Чорні залишили гру';

  @override
  String get whiteDidntMove => 'Білі не зробили хід';

  @override
  String get blackDidntMove => 'Чорні не зробили хід';

  @override
  String get requestAComputerAnalysis => 'Зробити запит на комп’ютерний аналіз';

  @override
  String get computerAnalysis => 'Комп’ютерний аналіз';

  @override
  String get computerAnalysisAvailable => 'Комп\'ютерний аналіз доступний';

  @override
  String get computerAnalysisDisabled => 'Комп\'ютерний аналіз вимкнено';

  @override
  String get analysis => 'Аналіз';

  @override
  String depthX(String param) {
    return 'Глибина $param';
  }

  @override
  String get usingServerAnalysis => 'Використовуючи комп\'ютерний аналіз';

  @override
  String get loadingEngine => 'Завантаження рушія...';

  @override
  String get calculatingMoves => 'Розрахунок ходів...';

  @override
  String get engineFailed => 'Помилка завантаження рушія';

  @override
  String get cloudAnalysis => 'Хмарний аналіз';

  @override
  String get goDeeper => 'Ще глибше';

  @override
  String get showThreat => 'Показати загрозу';

  @override
  String get inLocalBrowser => 'у браузері';

  @override
  String get toggleLocalEvaluation => 'Включити локальний аналіз';

  @override
  String get promoteVariation => 'Підвищити пріоритет варіанта';

  @override
  String get makeMainLine => 'Зробити варіант основним';

  @override
  String get deleteFromHere => 'Видалити з цього місця';

  @override
  String get collapseVariations => 'Згорнути варіанти';

  @override
  String get expandVariations => 'Розгорнути варіанти';

  @override
  String get forceVariation => 'Зробити варіантом';

  @override
  String get copyVariationPgn => 'Скопіювати PGN варіанту';

  @override
  String get move => 'Хід';

  @override
  String get variantLoss => 'Шанс програшу';

  @override
  String get variantWin => 'Хід, що виграє';

  @override
  String get insufficientMaterial => 'Недостатньо матеріалу';

  @override
  String get pawnMove => 'Хід пішака';

  @override
  String get capture => 'Взяття';

  @override
  String get close => 'Закрити';

  @override
  String get winning => 'Виграш';

  @override
  String get losing => 'Програш';

  @override
  String get drawn => 'Нічия';

  @override
  String get unknown => 'Невідомо';

  @override
  String get database => 'База даних';

  @override
  String get whiteDrawBlack => 'Білі / Нічия / Чорні';

  @override
  String averageRatingX(String param) {
    return 'Середній рейтинг: $param';
  }

  @override
  String get recentGames => 'Останні ігри';

  @override
  String get topGames => 'Найкращі ігри';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'ігор за дошкою гравців FIDE з рейтингом $param1+ з $param2 по $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' з округленням на основі кількості півходів до наступного взяття чи ходу пішака';

  @override
  String get noGameFound => 'Ігор не знайдено';

  @override
  String get maxDepthReached => 'Максимальна глибина досягнута!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Може, варто включити більше ігор з меню налаштувань?';

  @override
  String get openings => 'Дебюти';

  @override
  String get openingExplorer => 'Дослідження дебютів';

  @override
  String get openingEndgameExplorer => 'Дослідження дебютів/ендпшілів';

  @override
  String xOpeningExplorer(String param) {
    return 'Дослідження дебютів $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Зіграти перший хід з дослідження дебютів/ендшпілів';

  @override
  String get winPreventedBy50MoveRule => 'Перемогу попереджено правилом 50-го ходу';

  @override
  String get lossSavedBy50MoveRule => 'Поразку попереджено правилом 50-го ходу';

  @override
  String get winOr50MovesByPriorMistake => 'Перемога або правило 50 ходів через попередню помилку';

  @override
  String get lossOr50MovesByPriorMistake => 'Поразка або правило 50 ходів через попередню помилку';

  @override
  String get unknownDueToRounding => 'Перемога/поразка гарантовані лише в тому випадку, якщо з моменту останнього взяття або ходу пішака відстежується рекомендована базова лінія, через можливе заокруглення значень DTZ в систематичних табличних базах.';

  @override
  String get allSet => 'Все готово!';

  @override
  String get importPgn => 'Імпорт PGN';

  @override
  String get delete => 'Видалити';

  @override
  String get deleteThisImportedGame => 'Видалити цю імпортовану гру?';

  @override
  String get replayMode => 'Режим повтору';

  @override
  String get realtimeReplay => 'У реальному часі';

  @override
  String get byCPL => 'Цікаве';

  @override
  String get openStudy => 'Почати дослідження';

  @override
  String get enable => 'Увімкнути';

  @override
  String get bestMoveArrow => 'Стрілка «Найкращий хід»';

  @override
  String get showVariationArrows => 'Показати стрілки для варіантів';

  @override
  String get evaluationGauge => 'Шкала оцінки';

  @override
  String get multipleLines => 'Кількість стрілок';

  @override
  String get cpus => 'Потоки';

  @override
  String get memory => 'Пам\'ять';

  @override
  String get infiniteAnalysis => 'Нескінченний аналіз';

  @override
  String get removesTheDepthLimit => 'Знімає обмеження на глибину аналізу - ваш комп’ютер стане теплішим';

  @override
  String get engineManager => 'Менеджер рушія';

  @override
  String get blunder => 'Груба помилка';

  @override
  String get mistake => 'Помилка';

  @override
  String get inaccuracy => 'Неточність';

  @override
  String get moveTimes => 'Час на хід';

  @override
  String get flipBoard => 'Перевернути дошку';

  @override
  String get threefoldRepetition => 'Триразове повторення';

  @override
  String get claimADraw => 'Оголосити нічию';

  @override
  String get offerDraw => 'Запропонувати нічию';

  @override
  String get draw => 'Нічия';

  @override
  String get drawByMutualAgreement => 'Нічия за спільною згодою';

  @override
  String get fiftyMovesWithoutProgress => 'П\'ятдесят ходів без прогресу';

  @override
  String get currentGames => 'Поточні партії';

  @override
  String get viewInFullSize => 'Дивитися в повний розмір';

  @override
  String get logOut => 'Вийти';

  @override
  String get signIn => 'Увійти';

  @override
  String get rememberMe => 'Запам\'ятати мене';

  @override
  String get youNeedAnAccountToDoThat => 'Для цього вам потрібен обліковий запис';

  @override
  String get signUp => 'Зареєструватися';

  @override
  String get computersAreNotAllowedToPlay => 'Заборонено грати, користуючись підказками шахових програм та безпосередньо програмами. Будь ласка, не послуговуйтеся під час гри допомогою програм (\"рушіїв\"), баз даних або інших гравців. Також зверніть увагу, що створення декількох облікових записів не заохочується і використання надмірної кількості облікових записів призведе до блокування.';

  @override
  String get games => 'Партії';

  @override
  String get forum => 'Форум';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 опублікував на форумі «$param2»';
  }

  @override
  String get latestForumPosts => 'Останні дописи форуму';

  @override
  String get players => 'Гравці';

  @override
  String get friends => 'Друзі';

  @override
  String get discussions => 'Обговорення';

  @override
  String get today => 'Сьогодні';

  @override
  String get yesterday => 'Вчора';

  @override
  String get minutesPerSide => 'Хвилин на кожного';

  @override
  String get variant => 'Варіант';

  @override
  String get variants => 'Варіанти';

  @override
  String get timeControl => 'Контроль часу';

  @override
  String get realTime => 'Наживо';

  @override
  String get correspondence => 'Заочні';

  @override
  String get daysPerTurn => 'Днів на хід';

  @override
  String get oneDay => 'Один день';

  @override
  String get time => 'Час';

  @override
  String get rating => 'Рейтинг';

  @override
  String get ratingStats => 'Розподіл за рейтингом';

  @override
  String get username => 'Ім\'я користувача';

  @override
  String get usernameOrEmail => 'Ім’я користувача або електронна пошта';

  @override
  String get changeUsername => 'Змінити ім\'я користувача';

  @override
  String get changeUsernameNotSame => 'Можна змінити лише регістр літер. Наприклад, \"johndoe\" до \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'Змініть своє ім\'я користувача. Це може бути зроблено лише один раз і вам дозволено лише змінити регістр літер вашого імені користувача.';

  @override
  String get signupUsernameHint => 'Переконайтесь, що ви вибрали хороше ім\'я. Ви не можете змінити його потім, а профілі з непристойними іменами будуть заблоковані!';

  @override
  String get signupEmailHint => 'Ми використаємо її лише для скидання пароля.';

  @override
  String get password => 'Пароль';

  @override
  String get changePassword => 'Змінити пароль';

  @override
  String get changeEmail => 'Змінити адресу електронної пошти';

  @override
  String get email => 'Електронна пошта';

  @override
  String get passwordReset => 'Скинути пароль';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get error_weakPassword => 'Цей пароль дуже поширений, і його легко відгадати.';

  @override
  String get error_namePassword => 'Будь ласка, не використовуйте своє ім\'я користувача як пароль.';

  @override
  String get blankedPassword => 'Ви використали той самий пароль на іншому сайті, безпека якого є під загрозою. Для забезпечення безпеки вашого профілю Lichess вам потрібно встановити новий пароль. Дякуємо за розуміння.';

  @override
  String get youAreLeavingLichess => 'Ви залишаєте Lichess';

  @override
  String get neverTypeYourPassword => 'Ніколи не вводьте свій пароль Lichess на іншому сайті!';

  @override
  String proceedToX(String param) {
    return 'Перейти до $param';
  }

  @override
  String get passwordSuggestion => 'Не встановлюйте пароль, запропонований кимось. Він може використати його для крадіжки вашого облікового запису.';

  @override
  String get emailSuggestion => 'Не встановлюйте поштову адресу, запропоновану кимось. Він може використати його для крадіжки вашого облікового запису.';

  @override
  String get emailConfirmHelp => 'Допомога з підтвердженням електронної пошти';

  @override
  String get emailConfirmNotReceived => 'Не отримали лист з підтвердженням після реєстрації?';

  @override
  String get whatSignupUsername => 'Яке ім\'я користувача ви використовували для реєстрації?';

  @override
  String usernameNotFound(String param) {
    return 'Ми не змогли знайти жодного користувача з таким іменем: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Ви можете використати це ім\'я користувача, щоб створити новий обліковий запис';

  @override
  String emailSent(String param) {
    return 'Ми надіслали лист на $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Отримання повідомлення може зайняти деякий час.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Зачекайте 5 хвилин і оновіть поштову скриньку.';

  @override
  String get checkSpamFolder => 'Також перевірте папку \"Спам\", лист міг потрапити туди. Якщо так, то позначте його як не спам.';

  @override
  String get emailForSignupHelp => 'Якщо все інше не спрацювало, то надішліть нам цей електронний лист:';

  @override
  String copyTextToEmail(String param) {
    return 'Скопіюйте та вставте текст зверху й відправте на $param';
  }

  @override
  String get waitForSignupHelp => 'Незабаром ми повернемося до вас, щоб допомогти вам завершити реєстрацію.';

  @override
  String accountConfirmed(String param) {
    return 'Користувач $param успішно підтверджений.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Тепер ви можете ввійти як $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Вам не потрібне підтвердження за електронною поштою.';

  @override
  String accountClosed(String param) {
    return 'Обліковий запис $param закрито.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Обліковий запис $param зареєстровано без електронної пошти.';
  }

  @override
  String get rank => 'Місце';

  @override
  String rankX(String param) {
    return 'Місце: $param';
  }

  @override
  String get gamesPlayed => 'Ігор зіграно';

  @override
  String get cancel => 'Скасувати';

  @override
  String get whiteTimeOut => 'Час білих вийшов';

  @override
  String get blackTimeOut => 'Час чорних вийшов';

  @override
  String get drawOfferSent => 'Пропозицію нічиєї надіслано';

  @override
  String get drawOfferAccepted => 'Пропозицію нічиєї прийнято';

  @override
  String get drawOfferCanceled => 'Пропозицію нічиєї скасовано';

  @override
  String get whiteOffersDraw => 'Білі пропонують нічию';

  @override
  String get blackOffersDraw => 'Чорні пропонують нічию';

  @override
  String get whiteDeclinesDraw => 'Білі відхилили нічию';

  @override
  String get blackDeclinesDraw => 'Чорні відхилили нічию';

  @override
  String get yourOpponentOffersADraw => 'Ваш суперник пропонує нічию';

  @override
  String get accept => 'Прийняти';

  @override
  String get decline => 'Відхилити';

  @override
  String get playingRightNow => 'Грається зараз';

  @override
  String get eventInProgress => 'Грається просто зараз';

  @override
  String get finished => 'Завершено';

  @override
  String get abortGame => 'Скасувати гру';

  @override
  String get gameAborted => 'Гру скасовано';

  @override
  String get standard => 'Стандартний';

  @override
  String get customPosition => 'Користувацька позиція';

  @override
  String get unlimited => 'Необмежений';

  @override
  String get mode => 'Режим';

  @override
  String get casual => 'Дружня гра';

  @override
  String get rated => 'Рейтингова';

  @override
  String get casualTournament => 'Дружня гра';

  @override
  String get ratedTournament => 'Рейтингова';

  @override
  String get thisGameIsRated => 'Гра на рейтинг';

  @override
  String get rematch => 'Реванш';

  @override
  String get rematchOfferSent => 'Запит на повторну гру надіслано';

  @override
  String get rematchOfferAccepted => 'Запит на повторну гру прийнято';

  @override
  String get rematchOfferCanceled => 'Запит на повторну гру відхилено';

  @override
  String get rematchOfferDeclined => 'Запит на повторну гру відхилено';

  @override
  String get cancelRematchOffer => 'Скасувати запит на повторну гру';

  @override
  String get viewRematch => 'Дивитися повторну гру';

  @override
  String get confirmMove => 'Підтвердити хід';

  @override
  String get play => 'Грати';

  @override
  String get inbox => 'Вхідні';

  @override
  String get chatRoom => 'Чат';

  @override
  String get loginToChat => 'Увійдіть, щоб використовувати чат';

  @override
  String get youHaveBeenTimedOut => 'Ви були відключені.';

  @override
  String get spectatorRoom => 'Чат глядачів';

  @override
  String get composeMessage => 'Написати повідомлення';

  @override
  String get subject => 'Тема';

  @override
  String get send => 'Надіслати';

  @override
  String get incrementInSeconds => 'Приріст на хід у секундах';

  @override
  String get freeOnlineChess => 'Безкоштовні Інтернет-шахи';

  @override
  String get exportGames => 'Експортувати ігри';

  @override
  String get ratingRange => 'Діапазон рейтингу';

  @override
  String get thisAccountViolatedTos => 'Цей обліковий запис порушив умови використання Lichess';

  @override
  String get openingExplorerAndTablebase => 'Дослідження дебютів та ендшпілів';

  @override
  String get takeback => 'Повернення ходу';

  @override
  String get proposeATakeback => 'Запропонувати повернути хід';

  @override
  String get takebackPropositionSent => 'Пропозицію повернути хід відправлено';

  @override
  String get takebackPropositionDeclined => 'Пропозицію повернути хід відхилено';

  @override
  String get takebackPropositionAccepted => 'Пропозицію повернути хід прийнято';

  @override
  String get takebackPropositionCanceled => 'Пропозицію повернути хід скасовано';

  @override
  String get yourOpponentProposesATakeback => 'Ваш суперник пропонує повернути хід';

  @override
  String get bookmarkThisGame => 'Додати гру в закладки';

  @override
  String get tournament => 'Турнір';

  @override
  String get tournaments => 'Турніри';

  @override
  String get tournamentPoints => 'Турнірні очки';

  @override
  String get viewTournament => 'Переглянути турнір';

  @override
  String get backToTournament => 'Повернутися до турніру';

  @override
  String get noDrawBeforeSwissLimit => 'Нічия не можлива до 30 ходу гри у турнірі за швейцарською системою.';

  @override
  String get thematic => 'Тематичний';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Ваш рейтинг $param є умовним';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ваш рейтинг у $param1 ($param2) занадто високий';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ваш щотижневий рейтинг $param1 ($param2) занадто високий';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Ваш рейтинг у $param1 ($param2) занадто низький';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Рейтинг ≥ $param1 в $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Рейтинг ≤ $param1 в $param2 за останній тиждень';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Потрібно бути в команді $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Ви не в команді $param';
  }

  @override
  String get backToGame => 'Повернутися до гри';

  @override
  String get siteDescription => 'Безкоштовні Інтернет-шахи. Грайте в шахи зараз із чистим інтерфейсом. Без реєстрації, без реклами, без додаткових програм. Грайте в шахи з комп\'ютером, друзями або випадковими суперниками.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 приєднався до команди $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 створив команду $param2';
  }

  @override
  String get startedStreaming => 'почав трансляцію';

  @override
  String xStartedStreaming(String param) {
    return '$param почав трансляцію';
  }

  @override
  String get averageElo => 'Середній рейтинг';

  @override
  String get location => 'Місцезнаходження';

  @override
  String get filterGames => 'Фільтр ігор';

  @override
  String get reset => 'Скинути';

  @override
  String get apply => 'Застосувати';

  @override
  String get save => 'Зберегти';

  @override
  String get leaderboard => 'Дошка лідерів';

  @override
  String get screenshotCurrentPosition => 'Скріншот поточної позиції';

  @override
  String get gameAsGIF => 'Зберегти як GIF';

  @override
  String get pasteTheFenStringHere => 'Вставте рядок FEN тут';

  @override
  String get pasteThePgnStringHere => 'Вставте рядок PGN тут';

  @override
  String get orUploadPgnFile => 'Або завантажте файл PGN';

  @override
  String get fromPosition => 'З позиції';

  @override
  String get continueFromHere => 'Продовжити звідси';

  @override
  String get toStudy => 'Дослідження';

  @override
  String get importGame => 'Імпортувати гру';

  @override
  String get importGameExplanation => 'Вставте PGN гри щоб отримати повтор в браузері, комп\'ютерний аналіз, ігровий чат та посилання, яким можна поділитися.';

  @override
  String get importGameCaveat => 'Варіації будуть видалені. Для збереження імпортуйте PGN через дослідження.';

  @override
  String get importGameDataPrivacyWarning => 'Цей PGN може бути у вільному доступі. Для імпорту гри в приватному режимі використовуйте студії.';

  @override
  String get thisIsAChessCaptcha => 'Це — шахова капча.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Натисніть на дошці, щоб зробити хід і довести, що ви людина.';

  @override
  String get captcha_fail => 'Будь ласка, вирішіть шахову капчу.';

  @override
  String get notACheckmate => 'Це не мат';

  @override
  String get whiteCheckmatesInOneMove => 'Білі ставлять мат в один хід';

  @override
  String get blackCheckmatesInOneMove => 'Чорні ставлять мат в один хід';

  @override
  String get retry => 'Спробуйте ще';

  @override
  String get reconnecting => 'Повторне підключення';

  @override
  String get noNetwork => 'Не в мережі';

  @override
  String get favoriteOpponents => 'Улюблені суперники';

  @override
  String get follow => 'Спостерігати';

  @override
  String get following => 'Спостерігають';

  @override
  String get unfollow => 'Не спостерігати';

  @override
  String followX(String param) {
    return 'Спостерігати за $param';
  }

  @override
  String unfollowX(String param) {
    return 'Не стежити за $param';
  }

  @override
  String get block => 'Заблокувати';

  @override
  String get blocked => 'Заблоковано';

  @override
  String get unblock => 'Розблокувати';

  @override
  String get followsYou => 'Спостерігає за вами';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 починає спостерігати за $param2';
  }

  @override
  String get more => 'Більше';

  @override
  String get memberSince => 'Зареєстрований з';

  @override
  String lastSeenActive(String param) {
    return 'Востаннє заходив $param';
  }

  @override
  String get player => 'Гравець';

  @override
  String get list => 'Список';

  @override
  String get graph => 'Діаграма';

  @override
  String get required => 'Обов\'язково.';

  @override
  String get openTournaments => 'Відкриті турніри';

  @override
  String get duration => 'Тривалість';

  @override
  String get winner => 'Переможець';

  @override
  String get standing => 'Турнірна таблиця';

  @override
  String get createANewTournament => 'Створити новий турнір';

  @override
  String get tournamentCalendar => 'Турнірний календар';

  @override
  String get conditionOfEntry => 'Умови участі:';

  @override
  String get advancedSettings => 'Додаткові налаштування';

  @override
  String get safeTournamentName => 'Оберіть пристойну назву для турніру.';

  @override
  String get inappropriateNameWarning => 'Все, що навіть трохи виявиться недоречним, може призвести до блокування.';

  @override
  String get emptyTournamentName => 'Залиште пустим, щоб назвати турнір на честь випадкового гросмейстера.';

  @override
  String get makePrivateTournament => 'Зробити турнір приватним та обмежити доступ паролем';

  @override
  String get join => 'Приєднатись';

  @override
  String get withdraw => 'Відступити';

  @override
  String get points => 'Очки';

  @override
  String get wins => 'Перемоги';

  @override
  String get losses => 'Поразки';

  @override
  String get createdBy => 'Створив';

  @override
  String get tournamentIsStarting => 'Турнір починається';

  @override
  String get tournamentPairingsAreNowClosed => 'Жеребкування турніру завершено.';

  @override
  String standByX(String param) {
    return 'Очікуйте, $param, йде жеребкування, будьте готові!';
  }

  @override
  String get pause => 'Пауза';

  @override
  String get resume => 'Відновити';

  @override
  String get youArePlaying => 'Ви граєте!';

  @override
  String get winRate => 'Відсоток перемог';

  @override
  String get berserkRate => 'Ігор з берсерком';

  @override
  String get performance => 'Ефективність';

  @override
  String get tournamentComplete => 'Турнір завершено';

  @override
  String get movesPlayed => 'Ходів зіграно';

  @override
  String get whiteWins => 'Перемог білими';

  @override
  String get blackWins => 'Перемог чорними';

  @override
  String get drawRate => 'Шанс нічиєї';

  @override
  String get draws => 'Нічиїх';

  @override
  String nextXTournament(String param) {
    return 'Наступний турнір з $param:';
  }

  @override
  String get averageOpponent => 'Середній рейтинг суперника';

  @override
  String get boardEditor => 'Редактор дошки';

  @override
  String get setTheBoard => 'Встановити позицію';

  @override
  String get popularOpenings => 'Популярні дебюти';

  @override
  String get endgamePositions => 'Позиції ендшпілю';

  @override
  String chess960StartPosition(String param) {
    return 'Початкова позиція Chess960: $param';
  }

  @override
  String get startPosition => 'Початкова позиція';

  @override
  String get clearBoard => 'Очистити дошку';

  @override
  String get loadPosition => 'Завантажити позицію';

  @override
  String get isPrivate => 'Приватний';

  @override
  String reportXToModerators(String param) {
    return 'Повідомити модераторів про $param';
  }

  @override
  String profileCompletion(String param) {
    return 'Заповненість профілю: $param';
  }

  @override
  String xRating(String param) {
    return '$param рейтинг';
  }

  @override
  String get ifNoneLeaveEmpty => 'Якщо немає, то залиште порожнім';

  @override
  String get profile => 'Профіль';

  @override
  String get editProfile => 'Редагувати профіль';

  @override
  String get realName => 'Справжнє ім\'я';

  @override
  String get setFlair => 'Оберіть свій символ';

  @override
  String get flair => 'Символ';

  @override
  String get youCanHideFlair => 'Це налаштування вимикає символи всіх користувачів сайту.';

  @override
  String get biography => 'Біографія';

  @override
  String get countryRegion => 'Країна чи область';

  @override
  String get thankYou => 'Дякуємо!';

  @override
  String get socialMediaLinks => 'Посилання на соціальні мережі';

  @override
  String get oneUrlPerLine => 'Одне посилання на рядок.';

  @override
  String get inlineNotation => 'Вбудована нотація';

  @override
  String get makeAStudy => 'Щоб зберегти та поділитися, подумайте про проведення дослідження.';

  @override
  String get clearSavedMoves => 'Очистити ходи';

  @override
  String get previouslyOnLichessTV => 'Раніше на Lichess TV';

  @override
  String get onlinePlayers => 'Гравці онлайн';

  @override
  String get activePlayers => 'Активні гравці';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Зверніть увагу на те, що гра є рейтинговою, але облік часу не ведеться!';

  @override
  String get success => 'Успіх';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Автоматично перейти до наступної гри після ходу';

  @override
  String get autoSwitch => 'Автоперехід';

  @override
  String get puzzles => 'Задачі';

  @override
  String get onlineBots => 'Онлайн-боти';

  @override
  String get name => 'Назва';

  @override
  String get description => 'Опис';

  @override
  String get descPrivate => 'Приватний опис';

  @override
  String get descPrivateHelp => 'Текст, який побачать лише учасники команди. Якщо встановити, замінить публічний опис для учасників команди.';

  @override
  String get no => 'Ні';

  @override
  String get yes => 'Так';

  @override
  String get help => 'Допомога:';

  @override
  String get createANewTopic => 'Створити нову тему';

  @override
  String get topics => 'Теми';

  @override
  String get posts => 'Дописи';

  @override
  String get lastPost => 'Останній допис';

  @override
  String get views => 'Переглядів';

  @override
  String get replies => 'Відповідей';

  @override
  String get replyToThisTopic => 'Відповісти на цю тему';

  @override
  String get reply => 'Відповісти';

  @override
  String get message => 'Повідомлення';

  @override
  String get createTheTopic => 'Створити тему';

  @override
  String get reportAUser => 'Поскаржитись на користувача';

  @override
  String get user => 'Користувач';

  @override
  String get reason => 'Причина';

  @override
  String get whatIsIheMatter => 'Що трапилося?';

  @override
  String get cheat => 'Нечесна гра';

  @override
  String get troll => 'Тролінг';

  @override
  String get other => 'Інше';

  @override
  String get reportDescriptionHelp => 'Вставте посилання на гру (ігри) та поясніть, що не так із поведінкою цього користувача. Не пишіть просто \"він шахраює\", а розкажіть, як ви дійшли до такого висновку. Вашу скаргу розглянуть швидше, якщо ви напишете її англійською.';

  @override
  String get error_provideOneCheatedGameLink => 'Будь ласка, додайте посилання на хоча б одну нечесну гру.';

  @override
  String by(String param) {
    return 'від $param';
  }

  @override
  String importedByX(String param) {
    return 'Завантажено гравцем - $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Обговорення закрито.';

  @override
  String get blog => 'Блог';

  @override
  String get notes => 'Нотатки';

  @override
  String get typePrivateNotesHere => 'Залишайте приватні нотатки тут';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Напишіть приватну нотатку про цього користувача';

  @override
  String get noNoteYet => 'Нотаток поки нема';

  @override
  String get invalidUsernameOrPassword => 'Недійсне ім\'я користувача або пароль';

  @override
  String get incorrectPassword => 'Невірний пароль';

  @override
  String get invalidAuthenticationCode => 'Недійсний код автентифікації';

  @override
  String get emailMeALink => 'Надішліть мені посилання';

  @override
  String get currentPassword => 'Поточний пароль';

  @override
  String get newPassword => 'Новий пароль';

  @override
  String get newPasswordAgain => 'Новий пароль (ще раз)';

  @override
  String get newPasswordsDontMatch => 'Нові паролі не збігаються';

  @override
  String get newPasswordStrength => 'Надійність пароля';

  @override
  String get clockInitialTime => 'Початковий час годинника';

  @override
  String get clockIncrement => 'Приріст часу';

  @override
  String get privacy => 'Конфіденційність';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get letOtherPlayersFollowYou => 'Дозволити іншим спостерігати за вами';

  @override
  String get letOtherPlayersChallengeYou => 'Дозволити іншим кидати вам виклик';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Дозволити іншим гравцям запрошувати Вас на навчання';

  @override
  String get sound => 'Звук';

  @override
  String get none => 'Немає';

  @override
  String get fast => 'Швидка';

  @override
  String get normal => 'Помірна';

  @override
  String get slow => 'Повільна';

  @override
  String get insideTheBoard => 'Усередині шахівниці';

  @override
  String get outsideTheBoard => 'Поза шахівницею';

  @override
  String get allSquaresOfTheBoard => 'Усі поля дошки';

  @override
  String get onSlowGames => 'У повільних іграх';

  @override
  String get always => 'Завжди';

  @override
  String get never => 'Ніколи';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 бере участь у $param2';
  }

  @override
  String get victory => 'Перемога';

  @override
  String get defeat => 'Поразка';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 проти $param2 в $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 проти $param2 в $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 проти $param2 в $param3';
  }

  @override
  String get timeline => 'Хронологія';

  @override
  String get starting => 'Початок:';

  @override
  String get allInformationIsPublicAndOptional => 'Уся інформація публічна та необов\'язкова.';

  @override
  String get biographyDescription => 'Розкажіть про себе: що вам подобається в шахах, які ваші улюблені дебюти, ігри, гравці…';

  @override
  String get listBlockedPlayers => 'Список заблокованих гравців';

  @override
  String get human => 'Людина';

  @override
  String get computer => 'Комп\'ютер';

  @override
  String get side => 'Сторона';

  @override
  String get clock => 'Годинник';

  @override
  String get opponent => 'Суперник';

  @override
  String get learnMenu => 'Навчання';

  @override
  String get studyMenu => 'Дослідження';

  @override
  String get practice => 'Практика';

  @override
  String get community => 'Спільнота';

  @override
  String get tools => 'Інструменти';

  @override
  String get increment => 'Приріст';

  @override
  String get error_unknown => 'Неприпустиме значення';

  @override
  String get error_required => 'Це поле обов\'язкове';

  @override
  String get error_email => 'Ця адреса електронної пошти є недійсна';

  @override
  String get error_email_acceptable => 'Ця адреса електронної пошти неприйнятна. Будь ласка, перевірте її та спробуйте знову.';

  @override
  String get error_email_unique => 'Електронна адреса недійсна або вже використана';

  @override
  String get error_email_different => 'Це ваша діюча електронна адреса';

  @override
  String error_minLength(String param) {
    return 'Має бути принаймні $param символів';
  }

  @override
  String error_maxLength(String param) {
    return 'Повинно бути не більше $param символів';
  }

  @override
  String error_min(String param) {
    return 'Має бути принаймні $param';
  }

  @override
  String error_max(String param) {
    return 'Має бути щонайбільше $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Якщо рейтинг ± $param';
  }

  @override
  String get ifRegistered => 'Якщо зареєстровані';

  @override
  String get onlyExistingConversations => 'Тільки існуючі бесіди';

  @override
  String get onlyFriends => 'Лише друзям';

  @override
  String get menu => 'Меню';

  @override
  String get castling => 'Рокіровка';

  @override
  String get whiteCastlingKingside => 'Білі O-O';

  @override
  String get blackCastlingKingside => 'Чорні O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Проведено часу в грі: $param';
  }

  @override
  String get watchGames => 'Дивитись ігри';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Час на TV: $param';
  }

  @override
  String get watch => 'Перегляд';

  @override
  String get videoLibrary => 'Відеотека';

  @override
  String get streamersMenu => 'Стрімери';

  @override
  String get mobileApp => 'Мобільний застосунок';

  @override
  String get webmasters => 'Розробникам';

  @override
  String get about => 'Про сайт';

  @override
  String aboutX(String param) {
    return 'Про $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 є безкоштовним ($param2) шаховим сервером без реклами та з відкритим кодом.';
  }

  @override
  String get really => 'дійсно';

  @override
  String get contribute => 'Сприяти розвитку';

  @override
  String get termsOfService => 'Умови користування';

  @override
  String get sourceCode => 'Вихідний код';

  @override
  String get simultaneousExhibitions => 'Сеанси одночасної гри';

  @override
  String get host => 'Організатор';

  @override
  String hostColorX(String param) {
    return 'Колір організатора: $param';
  }

  @override
  String get yourPendingSimuls => 'Ваші сеанси одночасної гри, що в режимі очікування';

  @override
  String get createdSimuls => 'Нещодавно створені сеанси';

  @override
  String get hostANewSimul => 'Організувати новий сеанс';

  @override
  String get signUpToHostOrJoinASimul => 'Зареєструйтеся, щоб створити чи приєднатися до сеансу одночасної гри';

  @override
  String get noSimulFound => 'Сеанс не знайдено';

  @override
  String get noSimulExplanation => 'Цього сеансу одночасної гри не існує.';

  @override
  String get returnToSimulHomepage => 'Повернутися до сторінки \"Сеанси\"';

  @override
  String get aboutSimul => 'Сеанс залучає одного гравця, що змагається з кількома гравцями одночасно.';

  @override
  String get aboutSimulImage => 'У партіях з 50 суперниками Фішер переміг 47, 2 зіграв внічию та 1 програв.';

  @override
  String get aboutSimulRealLife => 'Концепцію взято з сеансів у реальному світі, коли організатор ходить від дошки до дошки, роблячи один хід.';

  @override
  String get aboutSimulRules => 'Коли сеанс розпочато, кожен гравець починає гру з організатором, який грає білими фігурами. Сеанс добігає кінця, коли завершуються всі партії.';

  @override
  String get aboutSimulSettings => 'Сеанси завжди нерейтингові. Опції реваншу, повернення ходу і додавання часу вимкнені.';

  @override
  String get create => 'Створити';

  @override
  String get whenCreateSimul => 'Коли Ви створите сеанс, Вам треба буде грати проти кількох суперників одночасно.';

  @override
  String get simulVariantsHint => 'Якщо Ви обираєте кілька шахових варіантів, кожен гравець буде визначатися, який із них обрати.';

  @override
  String get simulClockHint => 'Налаштування годинника Фішера. Чим більше учасників, тим більше часу Вам знадобиться.';

  @override
  String get simulAddExtraTime => 'Ви можете додати собі час, щоб упоратися з сеансом.';

  @override
  String get simulHostExtraTime => 'Додатковий час організатора';

  @override
  String get simulAddExtraTimePerPlayer => 'Додавайте початковий час до вашого годинника для кожного гравця, що приєднується до сеансу.';

  @override
  String get simulHostExtraTimePerPlayer => 'Додатковий час для організатора за гравця';

  @override
  String get lichessTournaments => 'Турніри Lichess';

  @override
  String get tournamentFAQ => 'ЧаПи про турнір Арена';

  @override
  String get timeBeforeTournamentStarts => 'Час до початку турніру';

  @override
  String get averageCentipawnLoss => 'Середня втрата сотих пішаків';

  @override
  String get accuracy => 'Точність';

  @override
  String get keyboardShortcuts => 'Комбінації клавіш';

  @override
  String get keyMoveBackwardOrForward => 'хід назад/вперед';

  @override
  String get keyGoToStartOrEnd => 'перейти до початку/кінця';

  @override
  String get keyCycleSelectedVariation => 'Прокрутити вибраний варіант';

  @override
  String get keyShowOrHideComments => 'показати/приховати коментарі';

  @override
  String get keyEnterOrExitVariation => 'зайти/вийти з варіанту';

  @override
  String get keyRequestComputerAnalysis => 'Зробити запит на комп\'ютерний аналіз, Учіться на своїх помилках';

  @override
  String get keyNextLearnFromYourMistakes => 'Далі (Вивчити свої помилки)';

  @override
  String get keyNextBlunder => 'Наступна груба помилка';

  @override
  String get keyNextMistake => 'Наступна помилка';

  @override
  String get keyNextInaccuracy => 'Наступна неточність';

  @override
  String get keyPreviousBranch => 'Попередній варіант';

  @override
  String get keyNextBranch => 'Наступний варіант';

  @override
  String get toggleVariationArrows => 'Показати стрілки варіантів';

  @override
  String get cyclePreviousOrNextVariation => 'Прокрутити попередній/наступний варіант';

  @override
  String get toggleGlyphAnnotations => 'Перемкнути анотації ходів';

  @override
  String get togglePositionAnnotations => 'Перемкнути анотації позицій';

  @override
  String get variationArrowsInfo => 'Стрілки варіантів дозволяють переміщуватись без використання списку ходів.';

  @override
  String get playSelectedMove => 'зіграти обраний хід';

  @override
  String get newTournament => 'Новий турнір';

  @override
  String get tournamentHomeTitle => 'Шаховий турнір із різними контролем часу та варіантами';

  @override
  String get tournamentHomeDescription => 'Грайте у швидкі шахи на турнірі! Приєднуйтеся до запланованих офіційних турнірів або створіть власний. Куля, бліц, класичні шахи, шахи Фішера, \"Цар гори\", \"Три шахи\" та інші варіанти забезпечать нескінченне задоволення.';

  @override
  String get tournamentNotFound => 'Турнір не знайдено';

  @override
  String get tournamentDoesNotExist => 'Цей турнір не існує.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Турнір міг бути скасований, якщо всі гравці залишили його до початку.';

  @override
  String get returnToTournamentsHomepage => 'Повернутися до домашньої сторінки турніру';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Щотижневий розподіл за рейтингом $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Ваш $param1 рейтинг становить $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Ви сильніше $param1 гравців у $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 сильніше $param2 гравців у $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Кращі за $param1 з $param2 гравців';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Ваш рейтинг $param ще не визначений.';
  }

  @override
  String get yourRating => 'Ваш рейтинг';

  @override
  String get cumulative => 'Сукупний';

  @override
  String get glicko2Rating => 'Рейтинг Glicko-2';

  @override
  String get checkYourEmail => 'Перевірте електронну пошту';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Ми надіслали вам лист. Перейдіть за посиланням у листі для активації облікового запису.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Якщо Ви не бачите листа, перевірте інші місця, де б він міг бути, наприклад, корзину, спам та інші папки.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Ми надіслали повідомлення на адресу $param. Перейдіть за посиланням у повідомленні для скидання паролю.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Реєструючись, Ви даєте згоду дотримуватись наших $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Читайте про наш $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Мережева затримка між вами та Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Час обробки ходу на сервері Lichess';

  @override
  String get downloadAnnotated => 'Завантажити з коментарями';

  @override
  String get downloadRaw => 'Завантажити без коментарів';

  @override
  String get downloadImported => 'Завантажити імпортоване';

  @override
  String get crosstable => 'Рахунок';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Прокручуйте коліщатко миші над шахівницею для перегляду ходів у грі.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Прокрутіть коліщатком миші по комп\'ютерних варіаціях для їх попереднього перегляду.';

  @override
  String get analysisShapesHowTo => 'Натисніть shift+ЛКМ або ПКМ, щоби намалювати кола та стрілки на шахівниці.';

  @override
  String get letOtherPlayersMessageYou => 'Дозволити іншим гравцям надсилати Вам повідомлення';

  @override
  String get receiveForumNotifications => 'Отримувати сповіщення при згадці на форумі';

  @override
  String get shareYourInsightsData => 'Надавати доступ до вашої шахової аналітики';

  @override
  String get withNobody => 'Нікому';

  @override
  String get withFriends => 'Друзям';

  @override
  String get withEverybody => 'Будь-кому';

  @override
  String get kidMode => 'Дитячий режим';

  @override
  String get kidModeIsEnabled => 'Дитячий режим активовано.';

  @override
  String get kidModeExplanation => 'Це заради безпеки. У дитячому режимі усе спілкування на сайті вимкнено. Увімкніть цю функцію для ваших дітей та учнів, щоб захистити їх від інших користувачів Інтернету.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'В дитячому режимі логотип Lichess замінюється на $param, щоб ви знали, що ваші діти в безпеці.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Ваш обліковий запис керується. Попросіть вашого вчителя шахів вимкнути дитячий режим.';

  @override
  String get enableKidMode => 'Увімкнути дитячий режим';

  @override
  String get disableKidMode => 'Вимкнути дитячий режим';

  @override
  String get security => 'Безпека';

  @override
  String get sessions => 'Сесії';

  @override
  String get revokeAllSessions => 'завершити усі сеанси';

  @override
  String get playChessEverywhere => 'Грайте в шахи будь-де';

  @override
  String get asFreeAsLichess => 'Безкоштовний, як і Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Створений з любов\'ю до шахів, не до грошей';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Усі можливості безкоштовні для всіх';

  @override
  String get zeroAdvertisement => 'Без реклами';

  @override
  String get fullFeatured => 'Повнофункціональний';

  @override
  String get phoneAndTablet => 'Для смартфонів та планшетів';

  @override
  String get bulletBlitzClassical => 'Куля, бліц, класичні шахи';

  @override
  String get correspondenceChess => 'Заочні';

  @override
  String get onlineAndOfflinePlay => 'Гра онлайн та оффлайн';

  @override
  String get viewTheSolution => 'Дивитись рішення';

  @override
  String get followAndChallengeFriends => 'Спостерігайте і кидайте виклик друзям';

  @override
  String get gameAnalysis => 'Аналіз гри';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 створив $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 приєднався до $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 сподобалось $param2';
  }

  @override
  String get quickPairing => 'Швидкий старт';

  @override
  String get lobby => 'Лобі';

  @override
  String get anonymous => 'Анонім';

  @override
  String yourScore(String param) {
    return 'Ваш рахунок: $param';
  }

  @override
  String get language => 'Мова';

  @override
  String get background => 'Фон';

  @override
  String get light => 'Світлий';

  @override
  String get dark => 'Темний';

  @override
  String get transparent => 'Прозорий';

  @override
  String get deviceTheme => 'Тема пристрою';

  @override
  String get backgroundImageUrl => 'Посилання фонового зображення:';

  @override
  String get board => 'Дошка';

  @override
  String get size => 'Розмір';

  @override
  String get opacity => 'Прозорість';

  @override
  String get brightness => 'Яскравість';

  @override
  String get hue => 'Відтінок';

  @override
  String get boardReset => 'Застосувати кольори за замовчуванням';

  @override
  String get pieceSet => 'Набір фігур';

  @override
  String get embedInYourWebsite => 'Вставити на свій сайт';

  @override
  String get usernameAlreadyUsed => 'Таке ім\'я користувача вже використовується, будь ласка, спробуйте інше.';

  @override
  String get usernamePrefixInvalid => 'Ім\'я користувача має починатися з літери.';

  @override
  String get usernameSuffixInvalid => 'Ім\'я користувача має закінчуватися літерою або цифрою.';

  @override
  String get usernameCharsInvalid => 'Ім\'я користувача має містити лише літери, цифри, символи підкреслення і тире.';

  @override
  String get usernameUnacceptable => 'Неприпустиме ім\'я користувача.';

  @override
  String get playChessInStyle => 'Грайте в шахи стильно';

  @override
  String get chessBasics => 'Шахові основи';

  @override
  String get coaches => 'Тренери';

  @override
  String get invalidPgn => 'Неприпустимий PGN';

  @override
  String get invalidFen => 'Неприпустимий FEN';

  @override
  String get custom => 'Своя гра';

  @override
  String get notifications => 'Сповіщення';

  @override
  String notificationsX(String param1) {
    return 'Сповіщення: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get practiceWithComputer => 'Тренування з комп\'ютером';

  @override
  String anotherWasX(String param) {
    return 'Можна було: $param';
  }

  @override
  String bestWasX(String param) {
    return 'Найкращим був: $param';
  }

  @override
  String get youBrowsedAway => 'Ви вийшли з перегляду';

  @override
  String get resumePractice => 'Продовжити тренування';

  @override
  String get drawByFiftyMoves => 'Партія завершилась нічиєю за правилом п\'ятдесяти ходів.';

  @override
  String get theGameIsADraw => 'Гра закінчилася внічию.';

  @override
  String get computerThinking => 'Комп\'ютер думає...';

  @override
  String get seeBestMove => 'Показати найкращий хід';

  @override
  String get hideBestMove => 'Приховати найкращий хід';

  @override
  String get getAHint => 'Отримати підказку';

  @override
  String get evaluatingYourMove => 'Оцінка вашого ходу...';

  @override
  String get whiteWinsGame => 'Білі виграли';

  @override
  String get blackWinsGame => 'Чорні виграли';

  @override
  String get learnFromYourMistakes => 'Робота над помилками';

  @override
  String get learnFromThisMistake => 'Розібрати цю помилку';

  @override
  String get skipThisMove => 'Пропустити цей хід';

  @override
  String get next => 'Далі';

  @override
  String xWasPlayed(String param) {
    return 'Було зіграно $param';
  }

  @override
  String get findBetterMoveForWhite => 'Знайдіть кращий хід за білих';

  @override
  String get findBetterMoveForBlack => 'Знайдіть кращий хід за чорних';

  @override
  String get resumeLearning => 'Продовжити навчання';

  @override
  String get youCanDoBetter => 'Є сильніший хід';

  @override
  String get tryAnotherMoveForWhite => 'Спробуйте інший хід за білих';

  @override
  String get tryAnotherMoveForBlack => 'Спробуйте інший хід за чорних';

  @override
  String get solution => 'Рішення';

  @override
  String get waitingForAnalysis => 'Очікування аналізу';

  @override
  String get noMistakesFoundForWhite => 'Помилок білих не знайдено';

  @override
  String get noMistakesFoundForBlack => 'Помилок чорних не знайдено';

  @override
  String get doneReviewingWhiteMistakes => 'Помилки білих розібрані';

  @override
  String get doneReviewingBlackMistakes => 'Помилки чорних розібрані';

  @override
  String get doItAgain => 'Ще раз';

  @override
  String get reviewWhiteMistakes => 'Розібрати помилки білих';

  @override
  String get reviewBlackMistakes => 'Розібрати помилки чорних';

  @override
  String get advantage => 'Перевага';

  @override
  String get opening => 'Дебют';

  @override
  String get middlegame => 'Мітельшпіль';

  @override
  String get endgame => 'Ендшпіль';

  @override
  String get conditionalPremoves => 'Умовні ходи на випередження';

  @override
  String get addCurrentVariation => 'Додати поточний варіант';

  @override
  String get playVariationToCreateConditionalPremoves => 'Виконайте ходи на шахівниці, щоб встановити умовні ходи на випередження';

  @override
  String get noConditionalPremoves => 'Безумовні ходи на випередження';

  @override
  String playX(String param) {
    return 'Зіграти $param';
  }

  @override
  String get showUnreadLichessMessage => 'Ви отримали особисте повідомлення від Lichess.';

  @override
  String get clickHereToReadIt => 'Натисніть тут, щоб прочитати';

  @override
  String get sorry => 'Вибачте :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Нам довелося забанити вас на певний час.';

  @override
  String get why => 'Чому?';

  @override
  String get pleasantChessExperience => 'Ми хочемо, щоб усім було приємно грати у нас в шахи.';

  @override
  String get goodPractice => 'Щоб домігтися цього ефекту, ми повинні впевнитися, що всі гравці добре поводяться.';

  @override
  String get potentialProblem => 'Ми відображаємо це повідомлення при виявленні можливої проблеми.';

  @override
  String get howToAvoidThis => 'Як цього уникнути?';

  @override
  String get playEveryGame => 'Якщо почали грати, догравайте до кінця.';

  @override
  String get tryToWin => 'Грайте завжди на перемогу (чи принаймні на нічию).';

  @override
  String get resignLostGames => 'Здавайтеся в програних іграх (не чекайте кінця таймера).';

  @override
  String get temporaryInconvenience => 'Вибачте за тимчасові незручності,';

  @override
  String get wishYouGreatGames => 'і бажаємо чудових ігор на lichess.org.';

  @override
  String get thankYouForReading => 'Дякуємо, що прочитали!';

  @override
  String get lifetimeScore => 'Рахунок за весь час';

  @override
  String get currentMatchScore => 'Поточний рахунок матчу';

  @override
  String get agreementAssistance => 'Я погоджуюся, що не буду отримувати допомогу під час моїх ігор (від шахового комп\'ютера, книги, бази даних або іншої особи).';

  @override
  String get agreementNice => 'Я погоджуюся, що я завжди буду ставитись чемно до інших гравців.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Я погоджуюсь с тим, що не буду створювати декілька облікових записів (крім причин, описаних у $param).';
  }

  @override
  String get agreementPolicy => 'Я погоджуюся, що я буду слідувати усім правилам Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Шукати або розпочати бесіду';

  @override
  String get edit => 'Змінити';

  @override
  String get bullet => 'Куля';

  @override
  String get blitz => 'Бліц';

  @override
  String get rapid => 'Швидкі';

  @override
  String get classical => 'Класичні';

  @override
  String get ultraBulletDesc => 'Шалено швидкі ігри: менше 30 секунд';

  @override
  String get bulletDesc => 'Дуже швидкі ігри: менш ніж 3 хвилини';

  @override
  String get blitzDesc => 'Швидкі ігри: від 3 до 8 хвилин';

  @override
  String get rapidDesc => 'Нетривалі ігри: від 8 до 25 хвилин';

  @override
  String get classicalDesc => 'Класичні ігри: 25 хвилин і більше';

  @override
  String get correspondenceDesc => 'Заочні шахи: один чи декілька днів на хід';

  @override
  String get puzzleDesc => 'Тренажер шахової тактики';

  @override
  String get important => 'Важливо';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Ваше запитання може мати відповідь $param1';
  }

  @override
  String get inTheFAQ => 'в ЧаПах.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Щоб повідомити про нечесну гру чи погану поведінку, $param1';
  }

  @override
  String get useTheReportForm => 'використовуйте форму звіту';

  @override
  String toRequestSupport(String param1) {
    return 'Для запиту підтримки $param1';
  }

  @override
  String get tryTheContactPage => 'спробуйте сторінку контактів';

  @override
  String makeSureToRead(String param1) {
    return 'Варто прочитати $param1';
  }

  @override
  String get theForumEtiquette => 'етикет форуму';

  @override
  String get thisTopicIsArchived => 'Ця тема була заархівована і додати відповідь більше не можна.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Приєднайтесь до $param1, щоб писати у цьому форумі';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 команда';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Ви не можете писати нові повідомлення у форумах. Зіграйте кілька ігор!';

  @override
  String get subscribe => 'Підписатись';

  @override
  String get unsubscribe => 'Відписатись';

  @override
  String mentionedYouInX(String param1) {
    return 'згадав вас у \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 згадав вас у \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'запросив вас до \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 запросив вас до \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Ви тепер частина команди.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Ви приєдналися до \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Хтось на кого ви поскаржились був забанений';

  @override
  String get congratsYouWon => 'Вітання, ви виграли!';

  @override
  String gameVsX(String param1) {
    return 'Гра проти $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Ви програли комусь хто порушував Lichess TOS';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Повернення: $param1 $param2 рангових очок.';
  }

  @override
  String get timeAlmostUp => 'Час майже скінчився!';

  @override
  String get clickToRevealEmailAddress => '[Натисніть щоб побачити електронну адресу]';

  @override
  String get download => 'Завантаження';

  @override
  String get coachManager => 'Тренерські налаштування';

  @override
  String get streamerManager => 'Стрімерські налаштування';

  @override
  String get cancelTournament => 'Скасувати турнір';

  @override
  String get tournDescription => 'Опис турніру';

  @override
  String get tournDescriptionHelp => 'Є щось особливе, що ви хочете сказати учасникам? Спробуйте написати це коротко. Для посилань доступна розмітка Markdown: [name](https://url)';

  @override
  String get ratedFormHelp => 'Ігри обраховуються за рейтинговою системою і впливатимуть на рейтинг гравців';

  @override
  String get onlyMembersOfTeam => 'Лише члени команди';

  @override
  String get noRestriction => 'Без обмежень';

  @override
  String get minimumRatedGames => 'Мінімум рейтингових ігор';

  @override
  String get minimumRating => 'Мінімальний рейтинг';

  @override
  String get maximumWeeklyRating => 'Максимальний тижневий рейтинг';

  @override
  String positionInputHelp(String param) {
    return 'Вставте правильний FEN для початку кожної гри з даної позиції.\nВін працює тільки з стандартними іграми, а не з варіантами.\nДля генерації позиції FEN ви можете використати $param щоб вставити його тут.\nЗалиште пустим, щоб почати гру з початкової позиції.';
  }

  @override
  String get cancelSimul => 'Відмінити сеанс';

  @override
  String get simulHostcolor => 'Колір сеансера для кожної гри';

  @override
  String get estimatedStart => 'Приблизний час початку';

  @override
  String simulFeatured(String param) {
    return 'Показувати на $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Показати ваш сеанс для всіх на $param. Вимикати для приватних сеансів.';
  }

  @override
  String get simulDescription => 'Опис сеансу';

  @override
  String get simulDescriptionHelp => 'Чи хочете ви щось повідомити учасникам?';

  @override
  String markdownAvailable(String param) {
    return '$param доступний для більш детального форматування.';
  }

  @override
  String get embedsAvailable => 'Вставте посилання на гру чи розділ дослідження, щоб вставити його.';

  @override
  String get inYourLocalTimezone => 'У вашому місцевому часовому поясі';

  @override
  String get tournChat => 'Турнірний чат';

  @override
  String get noChat => 'Без чату';

  @override
  String get onlyTeamLeaders => 'Лише лідери команд';

  @override
  String get onlyTeamMembers => 'Лише члени команди';

  @override
  String get navigateMoveTree => 'Навігація по нотації';

  @override
  String get mouseTricks => 'Можливості миші';

  @override
  String get toggleLocalAnalysis => 'Ввімкнути локальний комп’ютерний аналіз';

  @override
  String get toggleAllAnalysis => 'Ввімкнути весь комп’ютерний аналіз';

  @override
  String get playComputerMove => 'Зіграти найкращий комп\'ютерний хід';

  @override
  String get analysisOptions => 'Можливості аналізу';

  @override
  String get focusChat => 'Обрати вікно чату';

  @override
  String get showHelpDialog => 'Показати це діалогове вікно довідки';

  @override
  String get reopenYourAccount => 'Відновити ваш обліковий запис';

  @override
  String get closedAccountChangedMind => 'Якщо ви закрили свій обліковий запис та змінили свою думку, у вас є один шанс відновити свій профіль.';

  @override
  String get onlyWorksOnce => 'Це можна зробити лише один раз.';

  @override
  String get cantDoThisTwice => 'Якщо ви закриєте обліковий запис в другий раз, відновити його буде вже неможливо.';

  @override
  String get emailAssociatedToaccount => 'Адреса електронної пошти, пов\'язана з обліковим записом';

  @override
  String get sentEmailWithLink => 'Ми надіслали вам електронний лист із посиланням.';

  @override
  String get tournamentEntryCode => 'Код входу до турніру';

  @override
  String get hangOn => 'Зачекайте!';

  @override
  String gameInProgress(String param) {
    return 'У вас є активна гра з $param.';
  }

  @override
  String get abortTheGame => 'Скасувати гру';

  @override
  String get resignTheGame => 'Здатися';

  @override
  String get youCantStartNewGame => 'Ви не можете розпочати нову гру поки не закінчите активну гру.';

  @override
  String get since => 'Від';

  @override
  String get until => 'До';

  @override
  String get lichessDbExplanation => 'Рейтингові партії всіх гравців Lichess';

  @override
  String get switchSides => 'Змінити сторону';

  @override
  String get closingAccountWithdrawAppeal => 'Закриття облікового запису призведе до скасування вашої апеляції';

  @override
  String get ourEventTips => 'Наші поради щодо організації подій';

  @override
  String get instructions => 'Інструкція';

  @override
  String get showMeEverything => 'Показати все';

  @override
  String get lichessPatronInfo => 'Lichess — це благодійне й абсолютно безкоштовне програмне забезпечення з відкритим кодом.\nУсі витрати на обслуговування, розробку й контент фінансуються виключно пожертвуваннями користувачів.';

  @override
  String get nothingToSeeHere => 'Поки тут нічого немає.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ваш суперник покинув гру. Ви можете оголосити перемогу за $count секунд.',
      many: 'Ваш суперник покинув гру. Ви можете оголосити перемогу за $count секунд.',
      few: 'Ваш суперник покинув гру. Ви можете оголосити перемогу за $count секунди.',
      one: 'Ваш суперник покинув гру. Ви можете оголосити перемогу за $count секунд.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мат у $count напівходів',
      many: 'Мат в $count напівходів',
      few: 'Мат в $count напівходи',
      one: 'Мат в $count напівхід',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count грубих помилок',
      many: '$count грубих помилок',
      few: '$count грубі помилки',
      one: '$count груба помилка',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count помилок',
      many: '$count помилок',
      few: '$count помилки',
      one: '$count помилка',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count неточностей',
      many: '$count неточностей',
      few: '$count неточності',
      one: '$count неточність',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гравців',
      many: '$count гравців',
      few: '$count гравці',
      one: '$count гравець',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ігор',
      many: '$count ігор',
      few: '$count гри',
      one: '$count гра',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Рейтинг $count за $param2 партій',
      many: 'Рейтинг $count за $param2 партій',
      few: 'Рейтинг $count за $param2 партії',
      one: 'Рейтинг $count за $param2 партію',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count закладок',
      many: '$count закладок',
      few: '$count закладки',
      one: '$count закладка',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count днів',
      many: '$count днів',
      few: '$count дні',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count годин',
      many: '$count годин',
      few: '$count години',
      one: '$count година',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хвилин',
      many: '$count хвилин',
      few: '$count хвилини',
      one: '$count хвилина',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Місце в рейтингу оновлюється кожні $count хвилини',
      many: 'Місце в рейтингу оновлюється кожні $count хвилин',
      few: 'Місце в рейтингу оновлюється кожні $count хвилини',
      one: 'Місце в рейтингу оновлюється щохвилини',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задач',
      many: '$count задач',
      few: '$count задачі',
      one: '$count задача',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count партій з вами',
      many: '$count партій з вами',
      few: '$count партії з вами',
      one: '$count партія з вами',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рейтингових',
      many: '$count рейтингових',
      few: '$count рейтингові',
      one: '$count рейтингова',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count перемог',
      many: '$count перемог',
      few: '$count перемоги',
      one: '$count перемога',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поразок',
      many: '$count поразок',
      few: '$count поразки',
      one: '$count поразка',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нічиїх',
      many: '$count нічиїх',
      few: '$count нічиї',
      one: '$count нічия',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count грають',
      many: '$count грають',
      few: '$count грають',
      one: '$count грає',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Додати $count секунд',
      many: 'Додати $count секунд',
      few: 'Додати $count секунди',
      one: 'Додати $count секунду',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count турнірних очок',
      many: '$count турнірних очок',
      few: '$count турнірних очки',
      one: '$count турнірне очко',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count досліджень',
      many: '$count досліджень',
      few: '$count дослідження',
      one: '$count дослідження',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сеансів',
      many: '$count сеансів',
      few: '$count сеанса',
      one: '$count сеанс',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count рейтингових ігор',
      many: '≥ $count рейтингових ігор',
      few: '≥ $count рейтингові гри',
      one: '≥ $count рейтингова гра',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 рейтингових ігор',
      many: '≥ $count $param2 рейтингових ігор',
      few: '≥ $count $param2 рейтингові ігри',
      one: '≥ $count $param2 рейтингова гра',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ви маєте зіграти ще $count рейтингових ігор в $param2',
      many: 'Ви маєте зіграти ще $count рейтингових ігор в $param2',
      few: 'Вам потрібно зіграти ще $count рейтингових ігор $param2',
      one: 'Ви маєте зіграти ще $count рейтингову гру в $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ви повинні зіграти ще $count рейтингових ігор',
      many: 'Ви повинні зіграти ще $count рейтингових ігор',
      few: 'Вам потрібно зіграти ще $count рейтингові гри',
      one: 'Ви повинні зіграти ще $count рейтингову гру',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count імпортованих ігор',
      many: '$count імпортованих ігор',
      few: '$count імпортовані гри',
      one: '$count імпортована гра',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count друзів у мережі',
      many: '$count друзів у мережі',
      few: '$count друга у мережі',
      one: '$count друг у мережі',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count спостерігачів',
      many: '$count спостерігачів',
      few: '$count спостерігачі',
      one: '$count спостерігач',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count спостерігають',
      many: '$count спостерігають',
      few: '$count спостерігають',
      one: '$count спостерігає',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Менше $count хвилин',
      many: 'Менше $count хвилин',
      few: 'Менше $count хвилин',
      one: 'Менше $count хвилини',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ігор триває',
      many: '$count ігор триває',
      few: '$count гри триває',
      one: '$count гра триває',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Максимум: $count символів.',
      many: 'Максимум: $count символів.',
      few: 'Максимум: $count символа.',
      one: 'Максимум: $count символів.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count заблоковано',
      many: '$count заблоковано',
      few: '$count заблоковано',
      one: '$count заблоковано',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дописів на форумі',
      many: '$count дописів на форумі',
      few: '$count дописи на форумі',
      one: '$count допис на форумі',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гравців грали в $param2 цього тижня.',
      many: '$count гравців грали у $param2 цього тижня.',
      few: '$count гравців грали у $param2 цього тижня.',
      one: '$count гравець грав у $param2 цього тижня.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Доступно $count мовами!',
      many: 'Доступно $count мовами!',
      few: 'Доступно $count мовами!',
      one: 'Доступно $count мовою!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунд на перший хід',
      many: '$count секунд на перший хід',
      few: '$count секунди на перший хід',
      one: '$count секунда на перший хід',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунд',
      many: '$count секунд',
      few: '$count секунди',
      one: '$count секунда',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'і зберегти $count послідовностей',
      many: 'і зберегти $count послідовностей',
      few: 'і зберегти $count послідовності',
      one: 'і зберегти $count послідовність',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Зробіть хід, щоб почати';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Ви граєте білими фігурами у всіх задачах';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Ви граєте чорними фігурами у всіх задачах';

  @override
  String get stormPuzzlesSolved => 'задач вирішено';

  @override
  String get stormNewDailyHighscore => 'Новий денний рекорд!';

  @override
  String get stormNewWeeklyHighscore => 'Новий тижневий рекорд!';

  @override
  String get stormNewMonthlyHighscore => 'Новий місячний рекорд!';

  @override
  String get stormNewAllTimeHighscore => 'Новий рекорд за весь час!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Попередній рекорд був $param';
  }

  @override
  String get stormPlayAgain => 'Грати знову';

  @override
  String stormHighscoreX(String param) {
    return 'Рекорд: $param';
  }

  @override
  String get stormScore => 'Рахунок';

  @override
  String get stormMoves => 'Ходів';

  @override
  String get stormAccuracy => 'Точність';

  @override
  String get stormCombo => 'Комбо';

  @override
  String get stormTime => 'Час';

  @override
  String get stormTimePerMove => 'Часу на хід';

  @override
  String get stormHighestSolved => 'Найскладніша з розв\'язаних';

  @override
  String get stormPuzzlesPlayed => 'Зіграні задачі';

  @override
  String get stormNewRun => 'Нова серія (гаряча клавіша: Пробіл)';

  @override
  String get stormEndRun => 'Завершити серію (гаряча клавіша: Enter)';

  @override
  String get stormHighscores => 'Рекорди';

  @override
  String get stormViewBestRuns => 'Переглянути найкращі серії';

  @override
  String get stormBestRunOfDay => 'Найкраща серія за день';

  @override
  String get stormRuns => 'Серії';

  @override
  String get stormGetReady => 'Приготуйтеся!';

  @override
  String get stormWaitingForMorePlayers => 'Очікуємо інших гравців...';

  @override
  String get stormRaceComplete => 'Гонка завершена!';

  @override
  String get stormSpectating => 'Спостереження';

  @override
  String get stormJoinTheRace => 'Приєднатися до гонки!';

  @override
  String get stormStartTheRace => 'Розпочати гонку';

  @override
  String stormYourRankX(String param) {
    return 'Ваше місце: $param';
  }

  @override
  String get stormWaitForRematch => 'Очікування реваншу';

  @override
  String get stormNextRace => 'Наступна гонка';

  @override
  String get stormJoinRematch => 'Приєднатися до реваншу';

  @override
  String get stormWaitingToStart => 'Очікування початку';

  @override
  String get stormCreateNewGame => 'Створити нову гру';

  @override
  String get stormJoinPublicRace => 'Приєднатися до публічної гонки';

  @override
  String get stormRaceYourFriends => 'Гонка з друзями';

  @override
  String get stormSkip => 'пропустити';

  @override
  String get stormSkipHelp => 'Ви можете пропустити один хід за гонку:';

  @override
  String get stormSkipExplanation => 'Пропустіть цей хід, щоб зберегти комбо! Можна використати лише один раз.';

  @override
  String get stormFailedPuzzles => 'Невирішені задачі';

  @override
  String get stormSlowPuzzles => 'Повільні задачі';

  @override
  String get stormSkippedPuzzle => 'Пропущена задача';

  @override
  String get stormThisWeek => 'Цього тижня';

  @override
  String get stormThisMonth => 'Цього місяця';

  @override
  String get stormAllTime => 'За весь час';

  @override
  String get stormClickToReload => 'Натисніть для перезавантаження';

  @override
  String get stormThisRunHasExpired => 'Час цієї серії минув!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Ця серія була відкрита у іншій вкладці!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count серій',
      many: '$count серій',
      few: '$count серії',
      one: '1 серія',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зіграно $count серій в $param2',
      many: 'Зіграно $count серій в $param2',
      few: 'Зіграно $count серії в $param2',
      one: 'Зіграна одна серія в $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Стримери Lichess';

  @override
  String get studyShareAndExport => 'Надсилання та експорт';

  @override
  String get studyStart => 'Почати';
}
