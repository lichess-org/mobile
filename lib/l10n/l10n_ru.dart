import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

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
  String get activityActivity => 'Активность';

  @override
  String get activityHostedALiveStream => 'Проведён стрим';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Занято $param1 место в $param2';
  }

  @override
  String get activitySignedUp => 'Регистрация на lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Поддерживает lichess.org $count месяцев ($param2)',
      many: 'Поддерживает lichess.org $count месяцев ($param2)',
      few: 'Поддерживает lichess.org $count месяца ($param2)',
      one: 'Поддерживает lichess.org $count месяц ($param2)',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выполнено $count упражнений в $param2',
      many: 'Выполнено $count упражнений в $param2',
      few: 'Выполнено $count упражнения в $param2',
      one: 'Выполнено $count упражнение в $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Решены $count тактических задач',
      many: 'Решены $count тактических задач',
      few: 'Решены $count тактические задачи',
      one: 'Решена $count тактическая задача',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сыграны $count игр в $param2',
      many: 'Сыграны $count игр в $param2',
      few: 'Сыграны $count игры в $param2',
      one: 'Сыграна $count игра в $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Опубликованы $count сообщений в теме $param2',
      many: 'Опубликованы $count сообщений в теме $param2',
      few: 'Опубликованы $count сообщения в теме $param2',
      one: 'Опубликовано $count сообщение в теме $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сделано $count ходов',
      many: 'Сделано $count ходов',
      few: 'Сделано $count хода',
      one: 'Сделан $count ход',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'в $count играх по переписке',
      many: 'в $count играх по переписке',
      few: 'в $count играх по переписке',
      one: 'в $count игре по переписке',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завершены $count игр по переписке',
      many: 'Завершены $count игр по переписке',
      few: 'Завершены $count игры по переписке',
      one: 'Завершена $count игра по переписке',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игроков добавлены в подписку',
      many: '$count игроков добавлены в подписку',
      few: '$count игрока добавлены в подписку',
      one: '$count игрок добавлен в подписку',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавились $count новых подписчиков',
      many: 'Добавились $count новых подписчиков',
      few: 'Добавились $count новых подписчика',
      one: 'Добавился $count новый подписчик',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Проведены $count сеансов одновременной игры',
      many: 'Проведены $count сеансов одновременной игры',
      few: 'Проведены $count сеанса одновременной игры',
      one: 'Проведён $count сеанс одновременной игры',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Участие в $count сеансах одновременной игры',
      many: 'Участие в $count сеансах одновременной игры',
      few: 'Участие в $count сеансах одновременной игры',
      one: 'Участие в $count сеансе одновременной игры',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Созданы $count новых студий',
      many: 'Созданы $count новых студий',
      few: 'Созданы $count новые студии',
      one: 'Создана $count новая студия',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завершены $count турниров',
      many: 'Завершены $count турниров',
      few: 'Завершены $count турнира',
      one: 'Завершён $count турнир',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count место ($param2 % лучших), по результатам $param3 игр в турнире $param4',
      many: '$count место ($param2 % лучших), по результатам $param3 игр в турнире $param4',
      few: '$count место ($param2 % лучших), по результатам $param3 игр в турнире $param4',
      one: '$count место ($param2 % лучших), по результатам $param3 игры в турнире $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завершено $count турниров по швейцарской системе',
      many: 'Завершено $count турниров по швейцарской системе',
      few: 'Завершено $count турнира по швейцарской системе',
      one: 'Завершён $count турнир по швейцарской системе',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Принят в $count клубов',
      many: 'Принят в $count клубов',
      few: 'Принят в $count клуба',
      one: 'Принят в $count клуб',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Трансляции';

  @override
  String get broadcastLiveBroadcasts => 'Прямые трансляции турнира';

  @override
  String challengeChallengesX(String param1) {
    return 'Вызовов: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Вызвать на игру';

  @override
  String get challengeChallengeDeclined => 'Вызов отклонён';

  @override
  String get challengeChallengeAccepted => 'Вызов принят!';

  @override
  String get challengeChallengeCanceled => 'Вызов отменён.';

  @override
  String get challengeRegisterToSendChallenges => 'Зарегистрируйтесь, чтобы вызывать соперников на игру.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Вы не можете вызвать на игру $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param не принимает вызовы.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Ваш рейтинг $param1 слишком далёк от $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Невозможно вызвать на игру из-за недостоверности рейтинга $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param принимает вызовы только от друзей.';
  }

  @override
  String get challengeDeclineGeneric => 'Я не принимаю вызовы прямо сейчас.';

  @override
  String get challengeDeclineLater => 'Я не принимаю вызовы прямо сейчас, пожалуйста, вызовите меня позже.';

  @override
  String get challengeDeclineTooFast => 'Такой контроль слишком быстрый для меня, пожалуйста, вызовите меня с контролем времени побольше.';

  @override
  String get challengeDeclineTooSlow => 'Такой контроль слишком медленный для меня, пожалуйста, вызовите меня с контролем времени поменьше.';

  @override
  String get challengeDeclineTimeControl => 'Я не принимаю вызовы с таким контролем времени.';

  @override
  String get challengeDeclineRated => 'Вызовите меня на рейтинговую игру, пожалуйста.';

  @override
  String get challengeDeclineCasual => 'Вызовите меня на товарищескую игру, пожалуйста.';

  @override
  String get challengeDeclineStandard => 'Я не принимаю вызовы на неклассические шахматы прямо сейчас.';

  @override
  String get challengeDeclineVariant => 'Я не хочу играть в этот вариант шахмат сейчас.';

  @override
  String get challengeDeclineNoBot => 'Я не принимаю вызовы от ботов.';

  @override
  String get challengeDeclineOnlyBot => 'Я принимаю вызовы только от ботов.';

  @override
  String get challengeInviteLichessUser => 'Или пригласите пользователя Lichess:';

  @override
  String get contactContact => 'Контакты';

  @override
  String get contactContactLichess => 'Контакты Lichess';

  @override
  String get patronDonate => 'Поддержать проект';

  @override
  String get patronLichessPatron => 'Lichess-спонсор';

  @override
  String perfStatPerfStats(String param) {
    return 'Статистика $param';
  }

  @override
  String get perfStatViewTheGames => 'Посмотреть партии';

  @override
  String get perfStatProvisional => 'предварительный';

  @override
  String get perfStatNotEnoughRatedGames => 'Недостаточно рейтинговых игр, чтобы узнать точный рейтинг.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Прогресс за последние игры ($param):';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Отклонение рейтинга: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Меньшее значение означает, что рейтинг более стабилен. Если этот показатель превышает $param1, то рейтинг считается примерным. Для включения в рейтинг-листы этот показатель должен быть ниже $param2 (стандартные шахматы) и $param3 (варианты).';
  }

  @override
  String get perfStatTotalGames => 'Всего партий';

  @override
  String get perfStatRatedGames => 'Рейтинговые игры';

  @override
  String get perfStatTournamentGames => 'Турнирных партий';

  @override
  String get perfStatBerserkedGames => 'Партий с берсерком';

  @override
  String get perfStatTimeSpentPlaying => 'Времени за игрой';

  @override
  String get perfStatAverageOpponent => 'Средний рейтинг соперников';

  @override
  String get perfStatVictories => 'Побед';

  @override
  String get perfStatDefeats => 'Поражений';

  @override
  String get perfStatDisconnections => 'Отключений';

  @override
  String get perfStatNotEnoughGames => 'Недостаточно сыгранных партий';

  @override
  String perfStatHighestRating(String param) {
    return 'Наивысший рейтинг: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Наименьший рейтинг: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'от $param1 до $param2';
  }

  @override
  String get perfStatWinningStreak => 'Побед подряд';

  @override
  String get perfStatLosingStreak => 'Поражений подряд';

  @override
  String perfStatLongestStreak(String param) {
    return 'Рекордная серия: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Текущая серия: $param';
  }

  @override
  String get perfStatBestRated => 'Победы против лучших по рейтингу';

  @override
  String get perfStatGamesInARow => 'Сыгранные подряд игры';

  @override
  String get perfStatLessThanOneHour => 'Перерыв между играми менее часа';

  @override
  String get perfStatMaxTimePlaying => 'Максимальное время за игрой';

  @override
  String get perfStatNow => 'сейчас';

  @override
  String get preferencesPreferences => 'Настройки';

  @override
  String get preferencesDisplay => 'Отображение';

  @override
  String get preferencesPrivacy => 'Конфиденциальность';

  @override
  String get preferencesNotifications => 'Уведомления';

  @override
  String get preferencesPieceAnimation => 'Анимация фигур';

  @override
  String get preferencesMaterialDifference => 'Показывать разницу в материале';

  @override
  String get preferencesBoardHighlights => 'Подсвечивать последний ход и шах';

  @override
  String get preferencesPieceDestinations => 'Показывать допустимые ходы';

  @override
  String get preferencesBoardCoordinates => 'Координаты доски (A–H, 1–8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Показывать список ходов';

  @override
  String get preferencesPgnPieceNotation => 'Шахматная нотация';

  @override
  String get preferencesChessPieceSymbol => 'Символ шахматной фигуры';

  @override
  String get preferencesPgnLetter => 'Буква фигуры (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Режим Дзен';

  @override
  String get preferencesShowPlayerRatings => 'Показывать рейтинг игрока';

  @override
  String get preferencesShowFlairs => 'Показывать эмодзи игроков';

  @override
  String get preferencesExplainShowPlayerRatings => 'Позволяет скрыть все рейтинги на сайте, чтобы помочь сосредоточиться на игре. Сами партии останутся рейтинговыми, просто вы не будете это видеть.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Показывать ручку изменения размера доски';

  @override
  String get preferencesOnlyOnInitialPosition => 'Только в начальном положении';

  @override
  String get preferencesInGameOnly => 'Только в игре';

  @override
  String get preferencesChessClock => 'Шахматные часы';

  @override
  String get preferencesTenthsOfSeconds => 'Десятые доли секунд';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Когда остаётся меньше 10 секунд';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Убывающий зелёный индикатор';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Звук, когда время подходит к концу';

  @override
  String get preferencesGiveMoreTime => 'Добавить времени';

  @override
  String get preferencesGameBehavior => 'Настройки игры';

  @override
  String get preferencesHowDoYouMovePieces => 'Как вы передвигаете фигуры?';

  @override
  String get preferencesClickTwoSquares => 'Нажатием на две клетки';

  @override
  String get preferencesDragPiece => 'Перетаскиванием фигуры';

  @override
  String get preferencesBothClicksAndDrag => 'Обоими способами';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Предварительный ход (пока ходит противник)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Возвраты (с согласия противника)';

  @override
  String get preferencesInCasualGamesOnly => 'Только в товарищеских играх';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Пешка превращается в ферзя автоматически';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Удерживайте клавишу <ctrl> во время превращения, чтобы временно отключить автопревращение в ферзя';

  @override
  String get preferencesWhenPremoving => 'Когда сделан предварительный ход';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Автоматически запрашивать ничью при трёхкратном повторении хода';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Когда остаётся меньше 30 секунд';

  @override
  String get preferencesMoveConfirmation => 'Подтверждение хода';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Может быть отключено во время игры вместе с меню доски';

  @override
  String get preferencesInCorrespondenceGames => 'В игре по переписке';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'По переписке и без ограничения времени';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Подтверждать признание поражения и предложение ничьей';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Способ рокировки';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Переместить короля на две клетки';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Переместить короля на ладью';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Вводить ходы с помощью клавиатуры';

  @override
  String get preferencesInputMovesWithVoice => 'Вводить ходы голосом';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Показывать стрелками только допустимые ходы';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Писать в чат “Good game, well played” после поражения или ничьей';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Ваши настройки сохранены.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Прокручивайте колесо мыши над доской, чтобы смотреть ходы';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Ежедневно присылать на почту список ваших игр по переписке';

  @override
  String get preferencesNotifyStreamStart => 'Стример начинает трансляцию';

  @override
  String get preferencesNotifyInboxMsg => 'Новое входящее сообщение';

  @override
  String get preferencesNotifyForumMention => 'Вас упомянули в сообщении на форуме';

  @override
  String get preferencesNotifyInvitedStudy => 'Приглашение в Студию';

  @override
  String get preferencesNotifyGameEvent => 'Обновления, касающиеся игры по переписке';

  @override
  String get preferencesNotifyChallenge => 'Вызовы на игру';

  @override
  String get preferencesNotifyTournamentSoon => 'Турнир скоро начнётся';

  @override
  String get preferencesNotifyTimeAlarm => 'В игре по переписке скоро упадёт флажок';

  @override
  String get preferencesNotifyBell => 'Звуковое оповещение на Личесс';

  @override
  String get preferencesNotifyPush => 'Оповещение на устройстве, когда Вы не находитесь на сайте Личесс';

  @override
  String get preferencesNotifyWeb => 'Браузер';

  @override
  String get preferencesNotifyDevice => 'Устройство';

  @override
  String get preferencesBellNotificationSound => 'Звук колокольчика уведомлений';

  @override
  String get puzzlePuzzles => 'Задачи';

  @override
  String get puzzlePuzzleThemes => 'Темы задач';

  @override
  String get puzzleRecommended => 'Рекомендуемые';

  @override
  String get puzzlePhases => 'Стадии игры';

  @override
  String get puzzleMotifs => 'Мотивы';

  @override
  String get puzzleAdvanced => 'Продвинутый';

  @override
  String get puzzleLengths => 'Количество ходов';

  @override
  String get puzzleMates => 'Маты';

  @override
  String get puzzleGoals => 'Цели';

  @override
  String get puzzleOrigin => 'Из партий';

  @override
  String get puzzleSpecialMoves => 'Особые ходы';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Понравилась задача?';

  @override
  String get puzzleVoteToLoadNextOne => 'Проголосуйте и перейдите к следующей!';

  @override
  String get puzzleUpVote => 'Задача понравилась';

  @override
  String get puzzleDownVote => 'Задача не понравилась';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Ваш рейтинг в решении задач не изменится. Решение задач — это не соревнование. Рейтинг помогает лучше подбирать для вас задачи по вашему уровню.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Найдите лучший ход за белых.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Найдите лучший ход за чёрных.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Чтобы получить персонализированные задачи:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Задача № $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Задача дня';

  @override
  String get puzzleDailyPuzzle => 'Задача дня';

  @override
  String get puzzleClickToSolve => 'Нажмите, чтобы начать решать';

  @override
  String get puzzleGoodMove => 'Хороший ход';

  @override
  String get puzzleBestMove => 'Лучший ход!';

  @override
  String get puzzleKeepGoing => 'Продолжайте…';

  @override
  String get puzzlePuzzleSuccess => 'Задача решена!';

  @override
  String get puzzlePuzzleComplete => 'Задача решена!';

  @override
  String get puzzleByOpenings => 'По дебютам';

  @override
  String get puzzlePuzzlesByOpenings => 'Задачи по дебютам';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Дебюты, которые вы играли в большинстве рейтинговых партий';

  @override
  String get puzzleUseFindInPage => 'Используйте «Найти на странице» в меню браузера, чтобы найти ваш любимый дебют!';

  @override
  String get puzzleUseCtrlF => 'Используйте Ctrl+f, чтобы найти ваш любимый дебют!';

  @override
  String get puzzleNotTheMove => 'Плохой ход!';

  @override
  String get puzzleTrySomethingElse => 'Попробуйте иначе.';

  @override
  String puzzleRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get puzzleHidden => 'скрыт';

  @override
  String puzzleFromGameLink(String param) {
    return 'Из партии $param';
  }

  @override
  String get puzzleContinueTraining => 'Продолжить тренировку';

  @override
  String get puzzleDifficultyLevel => 'Уровень сложности';

  @override
  String get puzzleNormal => 'Средний';

  @override
  String get puzzleEasier => 'Лёгкий';

  @override
  String get puzzleEasiest => 'Легчайший';

  @override
  String get puzzleHarder => 'Сложный';

  @override
  String get puzzleHardest => 'Сложнейший';

  @override
  String get puzzleExample => 'Пример';

  @override
  String get puzzleAddAnotherTheme => 'Добавить другой мотив';

  @override
  String get puzzleNextPuzzle => 'Следующая задача';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Сразу переходить к следующей задаче';

  @override
  String get puzzlePuzzleDashboard => 'Панель задач';

  @override
  String get puzzleImprovementAreas => 'Слабые стороны';

  @override
  String get puzzleStrengths => 'Сильные стороны';

  @override
  String get puzzleHistory => 'История задач';

  @override
  String get puzzleSolved => 'решённые';

  @override
  String get puzzleFailed => 'неудачные';

  @override
  String get puzzleStreakDescription => 'Решайте постепенно усложняющиеся задачи и создайте победную серию. Здесь нет часов, так что не торопитесь. Один неправильный ход и игра закончена! Но можно пропустить один ход за сеанс.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Ваша серия: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Пропустить этот ход, чтобы сохранить серию! Можно использовать только один раз.';

  @override
  String get puzzleContinueTheStreak => 'Продолжить серию';

  @override
  String get puzzleNewStreak => 'Новая серия';

  @override
  String get puzzleFromMyGames => 'Из моих партий';

  @override
  String get puzzleLookupOfPlayer => 'Искать задачи из партий игрока';

  @override
  String puzzleFromXGames(String param) {
    return 'Задачи из партий $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Искать задачи';

  @override
  String get puzzleFromMyGamesNone => 'В базе данных нет задач из ваших партий, но Lichess надеется на вас.\nСыграйте больше партий в рапид или с классическим контролем времени, и ваши шансы попасть в список игроков с задачами увеличатся!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Найдено $param1 задач в $param2 играх';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Тренируйтесь, анализируйте, улучшайте';

  @override
  String puzzlePercentSolved(String param) {
    return '$param верно';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Ничего нет, решите для начала несколько задач!';

  @override
  String get puzzleImprovementAreasDescription => 'Потренируйте эти темы, чтобы улучшить свой прогресс!';

  @override
  String get puzzleStrengthDescription => 'Вы показываете лучшие результаты в этих темах';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Решено $count раз',
      many: 'Решено $count раз',
      few: 'Решено $count раза',
      one: 'Решено $count раз',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count баллов ниже вашего рейтинга в задачах',
      many: '$count баллов ниже вашего рейтинга в задачах',
      few: '$count баллов ниже вашего рейтинга в задачах',
      one: 'Один балл ниже вашего рейтинга в задачах',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count баллов выше вашего рейтинга в задачах',
      many: '$count баллов выше вашего рейтинга в задачах',
      few: '$count баллов выше вашего рейтинга в задачах',
      one: 'Один балл выше вашего рейтинга в пазлах',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count решено',
      many: '$count решены',
      few: '$count решены',
      one: '$count решена',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count повторить',
      many: '$count повторить',
      few: '$count повторить',
      one: '$count повторить',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Продвинутая пешка';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Одна из Ваших пешек далеко продвинута, есть шанс превращения.';

  @override
  String get puzzleThemeAdvantage => 'Преимущество';

  @override
  String get puzzleThemeAdvantageDescription => 'Используйте свой шанс получить решающее преимущество. (от 200 до 600 сантипешек)';

  @override
  String get puzzleThemeAnastasiaMate => 'Мат Анастасии';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Конь и ладья (или ферзь) матуют короля противника между краем доски и другой фигурой противника.';

  @override
  String get puzzleThemeArabianMate => 'Арабский мат';

  @override
  String get puzzleThemeArabianMateDescription => 'Конь и ладья матуют вражеского короля в углу доски.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Атака f2 или f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Атака, направленная на пешки f2 или f7, например, в атаке Фегателло.';

  @override
  String get puzzleThemeAttraction => 'Завлечение';

  @override
  String get puzzleThemeAttractionDescription => 'Размен или жертва, вынуждающая или подталкивающая фигуру противника занять поле, после чего становится возможен последующий тактический приём.';

  @override
  String get puzzleThemeBackRankMate => 'Мат на последней горизонтали';

  @override
  String get puzzleThemeBackRankMateDescription => 'Матование короля на его горизонтали, когда он заблокирован своими же фигурами.';

  @override
  String get puzzleThemeBishopEndgame => 'Слоновый эндшпиль';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Эндшпиль, где присутствуют лишь слоны и пешки.';

  @override
  String get puzzleThemeBodenMate => 'Мат Бодена';

  @override
  String get puzzleThemeBodenMateDescription => 'Два слона на скрещённых диагоналях ставят мат вражескому королю, окружённому собственными фигурами.';

  @override
  String get puzzleThemeCastling => 'Рокировка';

  @override
  String get puzzleThemeCastlingDescription => 'Помещение короля в надёжное место и вывод в бой ладьи.';

  @override
  String get puzzleThemeCapturingDefender => 'Уничтожение защитника';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Взятие или размен фигуры, защищающей другую фигуру, с последующим взятием фигуры, оставшейся без защиты.';

  @override
  String get puzzleThemeCrushing => 'Разгром';

  @override
  String get puzzleThemeCrushingDescription => 'Используйте зевок противника для получения сокрушительного преимущества. (600 и более сантипешек)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Мат двумя слонами';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Два слона атакующей стороны ставят мат на смежных диагоналях королю противника, окружённому своими же фигурами.';

  @override
  String get puzzleThemeDovetailMate => 'Мат «ласточкин хвост»';

  @override
  String get puzzleThemeDovetailMateDescription => 'Мат ферзём стоящему рядом королю противника, единственные два поля отхода которого занимают его же фигуры.';

  @override
  String get puzzleThemeEquality => 'Уравнение';

  @override
  String get puzzleThemeEqualityDescription => 'Отыграйтесь из проигранной позиции: сведите партию на ничью или получите позиционное равенство. (менее 200 сантипешек)';

  @override
  String get puzzleThemeKingsideAttack => 'Атака на королевском фланге';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Атака на рокированного в короткую сторону короля противника.';

  @override
  String get puzzleThemeClearance => 'Освобождение линии или поля';

  @override
  String get puzzleThemeClearanceDescription => 'Ход, обычно с темпом, освобождающий поле, линию или диагональ с целью реализации тактической идеи.';

  @override
  String get puzzleThemeDefensiveMove => 'Защитный ход';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Точный ход или последовательность ходов, которые необходимы во избежание потери материала или другого преимущества.';

  @override
  String get puzzleThemeDeflection => 'Отвлечение';

  @override
  String get puzzleThemeDeflectionDescription => 'Ход, отвлекающий фигуру противника от важной задачи, например, от защиты ключевого поля.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Вскрытое нападение';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Ход фигурой, которая закрывает линию атаки дальнобойной фигуры. Например, ход конём, вскрывающий линию для стоящей за ним ладьи.';

  @override
  String get puzzleThemeDoubleCheck => 'Двойной шах';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Шах двумя фигурами одновременно при помощи вскрытого нападения. Нельзя срубить обе атакующие фигуры и нельзя закрыться от них, поэтому король может только уйти от шаха.';

  @override
  String get puzzleThemeEndgame => 'Эндшпиль';

  @override
  String get puzzleThemeEndgameDescription => 'Тактика в последней стадии игры.';

  @override
  String get puzzleThemeEnPassantDescription => 'Тактика с применением правила «взятие на проходе», где своя пешка может взять пешку противника, сходившую на две клетки из своего начального положения, и при этом пропущенное поле было под боем своей пешки.';

  @override
  String get puzzleThemeExposedKing => 'Голый король';

  @override
  String get puzzleThemeExposedKingDescription => 'Незащищённый или слабо защищённый король часто становится жертвой матовой атаки.';

  @override
  String get puzzleThemeFork => 'Вилка';

  @override
  String get puzzleThemeForkDescription => 'Ход, при котором под удар попадают две фигуры противника.';

  @override
  String get puzzleThemeHangingPiece => 'Незащищённая фигура';

  @override
  String get puzzleThemeHangingPieceDescription => 'Тактика, при которой фигура соперника не защищена или недостаточно защищена и может быть взята.';

  @override
  String get puzzleThemeHookMate => 'Хук-мат';

  @override
  String get puzzleThemeHookMateDescription => 'Мат ладьёй и конём, защищённым пешкой, при том, что одна из пешек противника занимает единственное доступное поле для отхода его короля.';

  @override
  String get puzzleThemeInterference => 'Перекрытие';

  @override
  String get puzzleThemeInterferenceDescription => 'Ход, перекрывающий линию взаимодействия дальнобойных фигур противника, в результате которого одна или обе фигуры становятся беззащитными. Например, конь встаёт на защищённое поле между двумя ладьями.';

  @override
  String get puzzleThemeIntermezzo => 'Промежуточный ход';

  @override
  String get puzzleThemeIntermezzoDescription => 'Вместо того, чтобы сделать ожидаемый ход, сначала делается другой ход, представляющий непосредственную угрозу, на которую противник должен ответить. Также известен как «Zwischenzug» или «Intermezzo».';

  @override
  String get puzzleThemeKnightEndgame => 'Коневой эндшпиль';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Эндшпиль, в котором на доске остались только кони и пешки.';

  @override
  String get puzzleThemeLong => 'Трёхходовая задача';

  @override
  String get puzzleThemeLongDescription => 'Три хода до победы.';

  @override
  String get puzzleThemeMaster => 'Партии мастеров';

  @override
  String get puzzleThemeMasterDescription => 'Задачи из партий с участием титулованных игроков.';

  @override
  String get puzzleThemeMasterVsMaster => 'Партии двух мастеров';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Задачи из партий с участием двух титулованных игроков.';

  @override
  String get puzzleThemeMate => 'Мат';

  @override
  String get puzzleThemeMateDescription => 'Закончите игру красиво.';

  @override
  String get puzzleThemeMateIn1 => 'Мат в 1 ход';

  @override
  String get puzzleThemeMateIn1Description => 'Поставьте мат в один ход.';

  @override
  String get puzzleThemeMateIn2 => 'Мат в два хода';

  @override
  String get puzzleThemeMateIn2Description => 'Поставьте мат в два хода.';

  @override
  String get puzzleThemeMateIn3 => 'Мат в 3 хода';

  @override
  String get puzzleThemeMateIn3Description => 'Поставьте мат в три хода.';

  @override
  String get puzzleThemeMateIn4 => 'Мат в 4 хода';

  @override
  String get puzzleThemeMateIn4Description => 'Поставьте мат за четыре хода.';

  @override
  String get puzzleThemeMateIn5 => 'Мат в 5 или более ходов';

  @override
  String get puzzleThemeMateIn5Description => 'Найдите последовательность ходов, ведущую к мату.';

  @override
  String get puzzleThemeMiddlegame => 'Миттельшпиль';

  @override
  String get puzzleThemeMiddlegameDescription => 'Тактика во второй стадии игры.';

  @override
  String get puzzleThemeOneMove => 'Одноходовая задача';

  @override
  String get puzzleThemeOneMoveDescription => 'Задача, где нужно сделать только один выигрывающий ход.';

  @override
  String get puzzleThemeOpening => 'Дебют';

  @override
  String get puzzleThemeOpeningDescription => 'Тактика в первой стадии игры.';

  @override
  String get puzzleThemePawnEndgame => 'Пешечный эндшпиль';

  @override
  String get puzzleThemePawnEndgameDescription => 'Эндшпиль с пешками.';

  @override
  String get puzzleThemePin => 'Связка';

  @override
  String get puzzleThemePinDescription => 'Тактика, использующая связку, когда фигура не может сделать ход, иначе под атаку попадёт стоящая за ней более ценная фигура.';

  @override
  String get puzzleThemePromotion => 'Превращение';

  @override
  String get puzzleThemePromotionDescription => 'Ход при котором пешка ходит на последнюю горизонталь и заменяется по выбору игрока на любую другую фигуру того же цвета, кроме короля.';

  @override
  String get puzzleThemeQueenEndgame => 'Ферзевый эндшпиль';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Эндшпиль с ферзями и пешками.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Ферзево-ладейный эндшпиль';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Эндшпиль с ферзями, ладьями и пешками.';

  @override
  String get puzzleThemeQueensideAttack => 'Атака на ферзевом фланге';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Атака короля, рокировавшегося в длинную сторону.';

  @override
  String get puzzleThemeQuietMove => 'Тихий ход';

  @override
  String get puzzleThemeQuietMoveDescription => 'Ход без шаха или взятия, который тем не менее подготавливает неизбежную угрозу.';

  @override
  String get puzzleThemeRookEndgame => 'Ладейный эндшпиль';

  @override
  String get puzzleThemeRookEndgameDescription => 'Эндшпиль с ладьями и пешками.';

  @override
  String get puzzleThemeSacrifice => 'Жертва';

  @override
  String get puzzleThemeSacrificeDescription => 'Тактика, при которой происходит отдача какого-либо материала для получения преимущества, объявления мата или сведения игры вничью.';

  @override
  String get puzzleThemeShort => 'Двухходовая задача';

  @override
  String get puzzleThemeShortDescription => 'Два хода до победы.';

  @override
  String get puzzleThemeSkewer => 'Линейный удар';

  @override
  String get puzzleThemeSkewerDescription => 'Разновидность связки, но в этом случае наоборот, более ценная фигура оказывается на линии атаки перед менее ценной или равноценной фигурой.';

  @override
  String get puzzleThemeSmotheredMate => 'Спёртый мат';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Мат конём королю, который не может уйти от мата, потому что окружён (спёрт) своими же собственными фигурами.';

  @override
  String get puzzleThemeSuperGM => 'Партии супергроссмейстеров';

  @override
  String get puzzleThemeSuperGMDescription => 'Задачи из партий, сыгранных лучшими шахматистами в мире.';

  @override
  String get puzzleThemeTrappedPiece => 'Ловля фигуры';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Фигура не может уйти от нападения, потому что не имеет свободных полей для отхода, или эти поля тоже находятся под нападением.';

  @override
  String get puzzleThemeUnderPromotion => 'Слабое превращение';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Превращение пешки не в ферзя, а в коня, слона или ладью.';

  @override
  String get puzzleThemeVeryLong => 'Многоходовая задача';

  @override
  String get puzzleThemeVeryLongDescription => 'Четыре или более ходов для победы.';

  @override
  String get puzzleThemeXRayAttack => 'Рентген';

  @override
  String get puzzleThemeXRayAttackDescription => 'Ситуация, когда на линии нападения или защиты дальнобойной фигуры стоит фигура противника.';

  @override
  String get puzzleThemeZugzwang => 'Цугцванг';

  @override
  String get puzzleThemeZugzwangDescription => 'Противник вынужден сделать один из немногих возможных ходов, но любой ход ведёт к ухудшению его положения.';

  @override
  String get puzzleThemeHealthyMix => 'Сборная солянка';

  @override
  String get puzzleThemeHealthyMixDescription => 'Всего понемногу. Вы не знаете, чего ожидать, так что будьте готовы ко всему! Прямо как в настоящей партии.';

  @override
  String get puzzleThemePlayerGames => 'Партии игрока';

  @override
  String get puzzleThemePlayerGamesDescription => 'Найти задачи, созданные из ваших партий, или партий других игроков.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Эти задачи находятся в общественном достоянии и вы можете скачать их: $param.';
  }

  @override
  String get searchSearch => 'Поиск';

  @override
  String get settingsSettings => 'Настройки';

  @override
  String get settingsCloseAccount => 'Удалить учётную запись';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Ваш аккаунт находится под управлением и не может быть закрыт.';

  @override
  String get settingsClosingIsDefinitive => 'Закрытие невозможно будет отменить. Вы уверены?';

  @override
  String get settingsCantOpenSimilarAccount => 'Вы не сможете создать новый аккаунт с таким же именем, даже если регистр символов отличается.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Я передумал, не закрывайте мой аккаунт';

  @override
  String get settingsCloseAccountExplanation => 'Вы уверены, что хотите закрыть свой аккаунт? Закрытие аккаунта необратимо. Вы никогда больше не сможете в него войти.';

  @override
  String get settingsThisAccountIsClosed => 'Этот аккаунт закрыт.';

  @override
  String get playWithAFriend => 'Сыграть с другом';

  @override
  String get playWithTheMachine => 'Сыграть с компьютером';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Чтобы пригласить друга, отправьте ему эту ссылку';

  @override
  String get gameOver => 'Партия окончена';

  @override
  String get waitingForOpponent => 'Ожидание соперника';

  @override
  String get orLetYourOpponentScanQrCode => 'Или дайте вашему сопернику отсканировать этот QR-код';

  @override
  String get waiting => 'Ожидание';

  @override
  String get yourTurn => 'Ваш ход';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 уровня $param2';
  }

  @override
  String get level => 'Уровень';

  @override
  String get strength => 'Сложность';

  @override
  String get toggleTheChat => 'Показывать окно чата';

  @override
  String get chat => 'Отправить сообщение';

  @override
  String get resign => 'Сдаться';

  @override
  String get checkmate => 'Мат';

  @override
  String get stalemate => 'Пат';

  @override
  String get white => 'Белые';

  @override
  String get black => 'Чёрные';

  @override
  String get asWhite => 'за белых';

  @override
  String get asBlack => 'за чёрных';

  @override
  String get randomColor => 'Случайный цвет';

  @override
  String get createAGame => 'Создать игру';

  @override
  String get whiteIsVictorious => 'Победа белых';

  @override
  String get blackIsVictorious => 'Победа чёрных';

  @override
  String get youPlayTheWhitePieces => 'Вы играете белыми фигурами';

  @override
  String get youPlayTheBlackPieces => 'Вы играете чёрными фигурами';

  @override
  String get itsYourTurn => 'Ваш ход!';

  @override
  String get cheatDetected => 'Обнаружено жульничество';

  @override
  String get kingInTheCenter => 'Король в центре';

  @override
  String get threeChecks => 'Три шаха';

  @override
  String get raceFinished => 'Гонка окончена';

  @override
  String get variantEnding => 'Партия окончена';

  @override
  String get newOpponent => 'Найти другого соперника';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Соперник предлагает вам сыграть ещё раз';

  @override
  String get joinTheGame => 'Принять вызов';

  @override
  String get whitePlays => 'Ход белых';

  @override
  String get blackPlays => 'Ход чёрных';

  @override
  String get opponentLeftChoices => 'Вероятно, ваш соперник покинул игру. Вы можете объявить победу или ничью, или ещё подождать.';

  @override
  String get forceResignation => 'Объявить победу';

  @override
  String get forceDraw => 'Объявить ничью';

  @override
  String get talkInChat => 'Будьте вежливы в чате!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'С вами сыграет первый, кто перейдёт по этой ссылке.';

  @override
  String get whiteResigned => 'Белые сдались';

  @override
  String get blackResigned => 'Чёрные сдались';

  @override
  String get whiteLeftTheGame => 'Белые вышли из игры';

  @override
  String get blackLeftTheGame => 'Чёрные вышли из игры';

  @override
  String get whiteDidntMove => 'Белые не сделали ход';

  @override
  String get blackDidntMove => 'Чёрные не сделали ход';

  @override
  String get requestAComputerAnalysis => 'Выполнить компьютерный анализ';

  @override
  String get computerAnalysis => 'Компьютерный анализ';

  @override
  String get computerAnalysisAvailable => 'Доступен компьютерный анализ';

  @override
  String get computerAnalysisDisabled => 'Компьютерный анализ отключён';

  @override
  String get analysis => 'Анализировать партию';

  @override
  String depthX(String param) {
    return 'Глубина $param';
  }

  @override
  String get usingServerAnalysis => 'Используется серверный анализ';

  @override
  String get loadingEngine => 'Загрузка движка...';

  @override
  String get calculatingMoves => 'Идёт расчёт ходов...';

  @override
  String get engineFailed => 'Ошибка загрузки движка';

  @override
  String get cloudAnalysis => 'Облачный анализ';

  @override
  String get goDeeper => 'Анализировать глубже';

  @override
  String get showThreat => 'Показать ответную угрозу';

  @override
  String get inLocalBrowser => 'в браузере';

  @override
  String get toggleLocalEvaluation => 'Включить локальный анализ';

  @override
  String get promoteVariation => 'Повысить приоритет варианта';

  @override
  String get makeMainLine => 'Сделать этот вариант главным';

  @override
  String get deleteFromHere => 'Удалить с этого места';

  @override
  String get collapseVariations => 'Свернуть варианты';

  @override
  String get expandVariations => 'Развернуть варианты';

  @override
  String get forceVariation => 'Сделать вариантом';

  @override
  String get copyVariationPgn => 'Скопировать вариант в формате PGN';

  @override
  String get move => 'Ход';

  @override
  String get variantLoss => 'Проигрышный ход';

  @override
  String get variantWin => 'Победный ход';

  @override
  String get insufficientMaterial => 'Недостаточно материала для мата';

  @override
  String get pawnMove => 'Ход пешки';

  @override
  String get capture => 'Взятие';

  @override
  String get close => 'Закрыть';

  @override
  String get winning => 'Выигрывают';

  @override
  String get losing => 'Проигрывают';

  @override
  String get drawn => 'Вничью';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get database => 'Архив партий';

  @override
  String get whiteDrawBlack => 'Белые / Ничья / Чёрные';

  @override
  String averageRatingX(String param) {
    return 'Средний рейтинг: $param';
  }

  @override
  String get recentGames => 'Недавние игры';

  @override
  String get topGames => 'Лучшие игры';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Два миллиона игр, проведённых за доской игроками FIDE с рейтингом $param1+ с $param2 по $param3';
  }

  @override
  String get dtzWithRounding => 'Правило 50 ходов: объявляется ничья, если на протяжении последних 50 ходов ни одна фигура не была взята и ни одна пешка не сделала хода';

  @override
  String get noGameFound => 'Партий не найдено';

  @override
  String get maxDepthReached => 'Достигнута максимальная глубина!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Возможно, стоит включить больше игр в настройках?';

  @override
  String get openings => 'Дебюты';

  @override
  String get openingExplorer => 'База дебютов';

  @override
  String get openingEndgameExplorer => 'База дебютов/окончаний';

  @override
  String xOpeningExplorer(String param) {
    return 'База дебютов для $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Играть первый ход изучателя дебютов/эндшпилей';

  @override
  String get winPreventedBy50MoveRule => 'Не удаётся победить из-за правила 50 ходов';

  @override
  String get lossSavedBy50MoveRule => 'Удаётся избежать поражения из-за правила 50 ходов';

  @override
  String get winOr50MovesByPriorMistake => 'Победа или правило 50 ходов';

  @override
  String get lossOr50MovesByPriorMistake => 'Поражение или 50 ходов после последней ошибки';

  @override
  String get unknownDueToRounding => 'Победа/поражение гарантируется только если рекомендуемая последовательность ходов была выполнена с момента последнего взятия фигуры или хода пешки из-за возможного округления значений DTZ в базах Syzygy.';

  @override
  String get allSet => 'Готово!';

  @override
  String get importPgn => 'Импортировать в PGN';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteThisImportedGame => 'Удалить эту импортированную игру?';

  @override
  String get replayMode => 'Смотреть в повторе';

  @override
  String get realtimeReplay => 'Как в партии';

  @override
  String get byCPL => 'По ошибкам';

  @override
  String get openStudy => 'Открыть в студии';

  @override
  String get enable => 'Включить';

  @override
  String get bestMoveArrow => 'Показывать лучшие ходы стрелками';

  @override
  String get showVariationArrows => 'Показать стрелки вариантов';

  @override
  String get evaluationGauge => 'Шкала оценки';

  @override
  String get multipleLines => 'Множество вариантов';

  @override
  String get cpus => 'Потоки';

  @override
  String get memory => 'Память';

  @override
  String get infiniteAnalysis => 'Бесконечный анализ';

  @override
  String get removesTheDepthLimit => 'Снимает ограничение на глубину анализа, но заставляет поработать ваш компьютер';

  @override
  String get engineManager => 'Менеджер движка';

  @override
  String get blunder => 'Зевок';

  @override
  String get mistake => 'Ошибка';

  @override
  String get inaccuracy => 'Неточность';

  @override
  String get moveTimes => 'Время на ход';

  @override
  String get flipBoard => 'Перевернуть доску';

  @override
  String get threefoldRepetition => 'Троекратное повторение позиции';

  @override
  String get claimADraw => 'Потребовать ничью';

  @override
  String get offerDraw => 'Предложить ничью';

  @override
  String get draw => 'Ничья';

  @override
  String get drawByMutualAgreement => 'Ничья по обоюдному согласию';

  @override
  String get fiftyMovesWithoutProgress => 'Пятьдесят ходов без прогресса';

  @override
  String get currentGames => 'Текущие партии';

  @override
  String get viewInFullSize => 'Посмотреть в полном размере';

  @override
  String get logOut => 'Выйти';

  @override
  String get signIn => 'Войти';

  @override
  String get rememberMe => 'Не выходить из аккаунта';

  @override
  String get youNeedAnAccountToDoThat => 'Вам нужно зарегистрироваться, чтобы сделать это';

  @override
  String get signUp => 'Регистрация';

  @override
  String get computersAreNotAllowedToPlay => 'Создание учётных записей для ботов запрещено. Пожалуйста, во время игры не используйте шахматные движки, базы данных или подсказки других игроков. Также учтите, что создание нескольких аккаунтов не приветствуется и чрезмерное их количество приведёт к блокировке.';

  @override
  String get games => 'Игры';

  @override
  String get forum => 'Форум';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 написал сообщение в теме $param2';
  }

  @override
  String get latestForumPosts => 'Последние сообщения на форуме';

  @override
  String get players => 'Игроки';

  @override
  String get friends => 'Друзья';

  @override
  String get discussions => 'Беседы';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get minutesPerSide => 'Минут на партию';

  @override
  String get variant => 'Вариант';

  @override
  String get variants => 'Варианты';

  @override
  String get timeControl => 'Контроль времени';

  @override
  String get realTime => 'По часам';

  @override
  String get correspondence => 'Игра по переписке';

  @override
  String get daysPerTurn => 'Дней на ход';

  @override
  String get oneDay => 'Один день';

  @override
  String get time => 'Время';

  @override
  String get rating => 'Рейтинг';

  @override
  String get ratingStats => 'Распределение рейтингов';

  @override
  String get username => 'Имя пользователя';

  @override
  String get usernameOrEmail => 'Логин или электронная почта';

  @override
  String get changeUsername => 'Изменить имя пользователя';

  @override
  String get changeUsernameNotSame => 'Можно изменить только регистр символов. Например, поменять «Johndoe» на «JohnDoe».';

  @override
  String get changeUsernameDescription => 'Изменить имя пользователя. Это можно сделать только один раз, при этом можно изменить только регистр символов.';

  @override
  String get signupUsernameHint => 'Убедитесь, что вы выбрали благопристойное имя пользователя. Вы не сможете изменить его позже, при этом все учётные записи с неприличными именами будут закрыты!';

  @override
  String get signupEmailHint => 'Мы будем использовать его только для сброса пароля.';

  @override
  String get password => 'Пароль';

  @override
  String get changePassword => 'Сменить пароль';

  @override
  String get changeEmail => 'Сменить адрес электронной почты';

  @override
  String get email => 'Электронная почта';

  @override
  String get passwordReset => 'Сброс пароля';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get error_weakPassword => 'Этот пароль очень распространён, и его слишком легко угадать.';

  @override
  String get error_namePassword => 'Пожалуйста, не используйте свой логин в качестве пароля.';

  @override
  String get blankedPassword => 'Вы использовали такой же пароль на другом сайте, а тот сайт был скомпрометирован. Теперь для безопасности вашей учётной записи на Lichess необходимо установить новый пароль. Спасибо за ваше понимание.';

  @override
  String get youAreLeavingLichess => 'Вы покидаете Lichess';

  @override
  String get neverTypeYourPassword => 'Никогда не вводите свой пароль Lichess на другом сайте!';

  @override
  String proceedToX(String param) {
    return 'Перейти на $param';
  }

  @override
  String get passwordSuggestion => 'Не устанавливайте пароль, предложенный другими людьми. Они с его помощью украдут вашу учётную запись.';

  @override
  String get emailSuggestion => 'Не устанавливайте адрес электронной почты, предложенный другими людьми. Они с его помощью украдут вашу учётную запись.';

  @override
  String get emailConfirmHelp => 'Помощь с подтверждением электронной почты';

  @override
  String get emailConfirmNotReceived => 'Не получили подтверждение по электронной почте после регистрации?';

  @override
  String get whatSignupUsername => 'Какое имя пользователя вы использовали для регистрации?';

  @override
  String usernameNotFound(String param) {
    return 'Мы не смогли найти пользователя по имени: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Вы можете использовать это имя пользователя для создания новой учётной записи';

  @override
  String emailSent(String param) {
    return 'Мы отправили письмо на адрес $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Получение письма может занять некоторое время.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Подождите 5 минут и обновите ваш почтовый ящик.';

  @override
  String get checkSpamFolder => 'Также проверьте папку со спамом, письмо может оказаться там. Если это так, пометьте его как не спам.';

  @override
  String get emailForSignupHelp => 'Если ничего не получилось, отправьте нам это письмо:';

  @override
  String copyTextToEmail(String param) {
    return 'Скопируйте и вставьте текст выше и отправьте его по адресу $param';
  }

  @override
  String get waitForSignupHelp => 'Мы скоро вернёмся к вам чтобы помочь завершить регистрацию.';

  @override
  String accountConfirmed(String param) {
    return 'Пользователь $param успешно подтверждён.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Вы можете войти прямо сейчас как $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Вам не требуется подтверждение по электронной почте.';

  @override
  String accountClosed(String param) {
    return 'Аккаунт $param закрыт.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Учётная запись $param зарегистрирована без электронной почты.';
  }

  @override
  String get rank => 'Ранг';

  @override
  String rankX(String param) {
    return 'Место: $param';
  }

  @override
  String get gamesPlayed => 'Сыграно партий';

  @override
  String get cancel => 'Отменить';

  @override
  String get whiteTimeOut => 'Белые просрочили время';

  @override
  String get blackTimeOut => 'Чёрные просрочили время';

  @override
  String get drawOfferSent => 'Предложение ничьей отправлено';

  @override
  String get drawOfferAccepted => 'Предложение ничьей принято';

  @override
  String get drawOfferCanceled => 'Предложение ничьей отменено';

  @override
  String get whiteOffersDraw => 'Белые предлагают ничью';

  @override
  String get blackOffersDraw => 'Чёрные предлагают ничью';

  @override
  String get whiteDeclinesDraw => 'Белые отклонили предложение ничьей';

  @override
  String get blackDeclinesDraw => 'Чёрные отклонили предложение ничьей';

  @override
  String get yourOpponentOffersADraw => 'Ваш соперник предлагает вам ничью';

  @override
  String get accept => 'Принять';

  @override
  String get decline => 'Отклонить';

  @override
  String get playingRightNow => 'Идёт игра';

  @override
  String get eventInProgress => 'Идёт прямо сейчас';

  @override
  String get finished => 'Завершён';

  @override
  String get abortGame => 'Отменить игру';

  @override
  String get gameAborted => 'Игра отменена';

  @override
  String get standard => 'Классические шахматы';

  @override
  String get customPosition => 'Настраиваемая позиция';

  @override
  String get unlimited => 'Отсутствует';

  @override
  String get mode => 'Режим';

  @override
  String get casual => 'Товарищеская';

  @override
  String get rated => 'Рейтинговая';

  @override
  String get casualTournament => 'Товарищеский';

  @override
  String get ratedTournament => 'Рейтинговый';

  @override
  String get thisGameIsRated => 'Игра на рейтинг';

  @override
  String get rematch => 'Реванш';

  @override
  String get rematchOfferSent => 'Предложение реванша отправлено';

  @override
  String get rematchOfferAccepted => 'Предложение реванша принято';

  @override
  String get rematchOfferCanceled => 'Предложение реванша отменено';

  @override
  String get rematchOfferDeclined => 'Предложение реванша отклонено';

  @override
  String get cancelRematchOffer => 'Отказаться от реванша';

  @override
  String get viewRematch => 'Посмотреть матч-реванш';

  @override
  String get confirmMove => 'Подтвердить ход';

  @override
  String get play => 'Игра';

  @override
  String get inbox => 'Входящие';

  @override
  String get chatRoom => 'Чат';

  @override
  String get loginToChat => 'Войдите, чтобы общаться в чате';

  @override
  String get youHaveBeenTimedOut => 'Чат временно недоступен для вас.';

  @override
  String get spectatorRoom => 'Чат для зрителей';

  @override
  String get composeMessage => 'Написать сообщение';

  @override
  String get subject => 'Тема';

  @override
  String get send => 'Отправить';

  @override
  String get incrementInSeconds => 'Добавление секунд на ход';

  @override
  String get freeOnlineChess => 'Бесплатные шахматы онлайн';

  @override
  String get exportGames => 'Скачать игры';

  @override
  String get ratingRange => 'Рейтинг соперника';

  @override
  String get thisAccountViolatedTos => 'Этот игрок нарушил условия пользовательского соглашения';

  @override
  String get openingExplorerAndTablebase => 'База дебютов и эндшпилей';

  @override
  String get takeback => 'Вернуть ход';

  @override
  String get proposeATakeback => 'Попросить соперника вернуть ход';

  @override
  String get takebackPropositionSent => 'Предложение вернуть ход отправлено';

  @override
  String get takebackPropositionDeclined => 'Предложение вернуть ход отклонено';

  @override
  String get takebackPropositionAccepted => 'Предложение вернуть ход принято';

  @override
  String get takebackPropositionCanceled => 'Предложение вернуть ход отменено';

  @override
  String get yourOpponentProposesATakeback => 'Ваш соперник просит вас вернуть ход';

  @override
  String get bookmarkThisGame => 'Отметить эту игру';

  @override
  String get tournament => 'Турнир';

  @override
  String get tournaments => 'Турниры';

  @override
  String get tournamentPoints => 'Турнирные очки';

  @override
  String get viewTournament => 'Перейти в турнир';

  @override
  String get backToTournament => 'Вернуться к турниру';

  @override
  String get noDrawBeforeSwissLimit => 'Вы не можете предлагать ничью до 30-го хода в турнире по швейцарской системе.';

  @override
  String get thematic => 'Тематический';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Ваш рейтинг в $param ещё недостоверный';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ваш рейтинг в $param1 ($param2) слишком высок для участия';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ваш еженедельный рейтинг в $param1 ($param2) слишком высок';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Ваш рейтинг в $param1 ($param2) недостаточен для участия';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Рейтинг ≥ $param1 в $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Рейтинг ≤ $param1 в $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Вы должны быть членом клуба $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Вы не член клуба $param';
  }

  @override
  String get backToGame => 'Вернуться к игре';

  @override
  String get siteDescription => 'Бесплатный шахматный сервер. Сыграйте в шахматы прямо сейчас в простом интерфейсе без рекламы. Не требует регистрации и скачивания программы. Играйте в шахматы с компьютером, друзьями или случайными соперниками.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 вступил в клуб $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 организовал клуб $param2';
  }

  @override
  String get startedStreaming => 'начал(-а) стрим';

  @override
  String xStartedStreaming(String param) {
    return '$param запустил стрим';
  }

  @override
  String get averageElo => 'Средний рейтинг участников';

  @override
  String get location => 'Местоположение';

  @override
  String get filterGames => 'Фильтр партий';

  @override
  String get reset => 'Сбросить';

  @override
  String get apply => 'Сохранить';

  @override
  String get save => 'Сохранить';

  @override
  String get leaderboard => 'Лучшие игроки';

  @override
  String get screenshotCurrentPosition => 'Сделать снимок этой позиции';

  @override
  String get gameAsGIF => 'Партия в формате GIF';

  @override
  String get pasteTheFenStringHere => 'Вставьте строку в формате FEN';

  @override
  String get pasteThePgnStringHere => 'Вставьте текст в формате PGN';

  @override
  String get orUploadPgnFile => 'Или загрузите PGN-файл';

  @override
  String get fromPosition => 'С позиции';

  @override
  String get continueFromHere => 'Продолжить с этой позиции';

  @override
  String get toStudy => 'Студия';

  @override
  String get importGame => 'Импортировать партию';

  @override
  String get importGameExplanation => 'Вставьте запись партии в формате PGN, и вы получите возможность переигрывать партию, выполнять компьютерный анализ, общаться в чате и делиться ссылкой на эту игру.';

  @override
  String get importGameCaveat => 'Варианты будут удалены. Чтобы их сохранить, импортируйте PGN в студии.';

  @override
  String get importGameDataPrivacyWarning => 'Этот PGN-файл может быть доступен публично. Чтобы импортировать игру приватно, используйте студию.';

  @override
  String get thisIsAChessCaptcha => 'Это шахматная капча.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Кликните по доске и сделайте ход, чтобы доказать, что вы человек, а не компьютер. (Всем известно, что компьютеры не умеют играть в шахматы!).';

  @override
  String get captcha_fail => 'Пожалуйста, решите шахматную капчу.';

  @override
  String get notACheckmate => 'Это не мат';

  @override
  String get whiteCheckmatesInOneMove => 'Белые ставят мат в один ход';

  @override
  String get blackCheckmatesInOneMove => 'Чёрные ставят мат в один ход';

  @override
  String get retry => 'Повторить';

  @override
  String get reconnecting => 'Переподключение';

  @override
  String get noNetwork => 'Офлайн';

  @override
  String get favoriteOpponents => 'Предпочитаемые соперники';

  @override
  String get follow => 'Подписаться';

  @override
  String get following => 'Подписаны';

  @override
  String get unfollow => 'Отписаться';

  @override
  String followX(String param) {
    return 'Подписаться на $param';
  }

  @override
  String unfollowX(String param) {
    return 'Отписаться от $param';
  }

  @override
  String get block => 'Заблокировать';

  @override
  String get blocked => 'Заблокированные';

  @override
  String get unblock => 'Разблокировать';

  @override
  String get followsYou => 'Подписан на вас';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 подписался на $param2';
  }

  @override
  String get more => 'Ещё';

  @override
  String get memberSince => 'Дата регистрации';

  @override
  String lastSeenActive(String param) {
    return 'Был онлайн $param';
  }

  @override
  String get player => 'Игрок';

  @override
  String get list => 'Список';

  @override
  String get graph => 'Диаграмма';

  @override
  String get required => 'Обязательное поле.';

  @override
  String get openTournaments => 'Открытые турниры';

  @override
  String get duration => 'Длительность';

  @override
  String get winner => 'Победитель';

  @override
  String get standing => 'Турнирная таблица';

  @override
  String get createANewTournament => 'Создать турнир';

  @override
  String get tournamentCalendar => 'Турнирный календарь';

  @override
  String get conditionOfEntry => 'Условия участия:';

  @override
  String get advancedSettings => 'Дополнительные настройки';

  @override
  String get safeTournamentName => 'Выберите для турнира как можно более безопасное название.';

  @override
  String get inappropriateNameWarning => 'Если название хотя бы немного покажется неуместным, вас могут заблокировать.';

  @override
  String get emptyTournamentName => 'Оставьте пустым, чтобы назвать турнир в честь случайного гроссмейстера.';

  @override
  String get makePrivateTournament => 'Сделать турнир закрытым и ограничить доступ паролем';

  @override
  String get join => 'Участвовать';

  @override
  String get withdraw => 'Покинуть';

  @override
  String get points => 'Очки';

  @override
  String get wins => 'Победы';

  @override
  String get losses => 'Поражения';

  @override
  String get createdBy => 'Создан';

  @override
  String get tournamentIsStarting => 'Турнир начинается';

  @override
  String get tournamentPairingsAreNowClosed => 'Жеребьёвка турнира завершена.';

  @override
  String standByX(String param) {
    return 'Ожидайте, $param, идёт жеребьёвка. Будьте готовы!';
  }

  @override
  String get pause => 'Приостановить';

  @override
  String get resume => 'Возобновить';

  @override
  String get youArePlaying => 'Вы в игре!';

  @override
  String get winRate => 'Победы';

  @override
  String get berserkRate => 'Берсерк';

  @override
  String get performance => 'Перформанс';

  @override
  String get tournamentComplete => 'Турнир завершён';

  @override
  String get movesPlayed => 'Сделано ходов';

  @override
  String get whiteWins => 'Побед белыми';

  @override
  String get blackWins => 'Побед чёрными';

  @override
  String get drawRate => 'Показатель ничьих';

  @override
  String get draws => 'Ничьих';

  @override
  String nextXTournament(String param) {
    return 'Следующий турнир по $param:';
  }

  @override
  String get averageOpponent => 'Средний рейтинг соперников';

  @override
  String get boardEditor => 'Редактор доски';

  @override
  String get setTheBoard => 'Установить позицию';

  @override
  String get popularOpenings => 'Популярные дебюты';

  @override
  String get endgamePositions => 'Эндшпильные позиции';

  @override
  String chess960StartPosition(String param) {
    return 'Начальная позиция в шахматах Фишера: $param';
  }

  @override
  String get startPosition => 'Начальная позиция';

  @override
  String get clearBoard => 'Очистить доску';

  @override
  String get loadPosition => 'Загрузить позицию';

  @override
  String get isPrivate => 'Закрытый';

  @override
  String reportXToModerators(String param) {
    return 'Сообщить о $param модераторам';
  }

  @override
  String profileCompletion(String param) {
    return 'Профиль заполнен на $param';
  }

  @override
  String xRating(String param) {
    return 'Рейтинг $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Если нет, оставьте пустым';

  @override
  String get profile => 'Профиль';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Задайте свой эмодзи';

  @override
  String get flair => 'Эмодзи';

  @override
  String get youCanHideFlair => 'Эта настройка скрывает все эмодзи пользователей на всём сайте.';

  @override
  String get biography => 'О себе';

  @override
  String get countryRegion => 'Страна или регион';

  @override
  String get thankYou => 'Спасибо!';

  @override
  String get socialMediaLinks => 'Ссылки на соцсети';

  @override
  String get oneUrlPerLine => 'Один URL на строку.';

  @override
  String get inlineNotation => 'Строчная нотация';

  @override
  String get makeAStudy => 'Чтобы сохранить и поделиться, рассмотрите возможность создания Студии.';

  @override
  String get clearSavedMoves => 'Очистить ходы';

  @override
  String get previouslyOnLichessTV => 'Ранее на Lichess TV';

  @override
  String get onlinePlayers => 'Игроки в сети';

  @override
  String get activePlayers => 'Активные игроки';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Внимание, это рейтинговая игра, хотя и без ограничения по времени!';

  @override
  String get success => 'Получилось';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'После хода автоматически переходить к следующей игре';

  @override
  String get autoSwitch => 'Автосмена';

  @override
  String get puzzles => 'Задачи';

  @override
  String get onlineBots => 'Онлайн боты';

  @override
  String get name => 'Имя';

  @override
  String get description => 'Описание';

  @override
  String get descPrivate => 'Описание для членов команды';

  @override
  String get descPrivateHelp => 'Текст, который будут видеть только члены команды(добавленный текст заменит публичное описание для членов команды).';

  @override
  String get no => 'Нет';

  @override
  String get yes => 'Да';

  @override
  String get help => 'Помощь:';

  @override
  String get createANewTopic => 'Создать новую тему';

  @override
  String get topics => 'Темы';

  @override
  String get posts => 'Сообщения';

  @override
  String get lastPost => 'Последнее сообщение';

  @override
  String get views => 'Просмотры';

  @override
  String get replies => 'Ответы';

  @override
  String get replyToThisTopic => 'Ответить в этой теме';

  @override
  String get reply => 'Ответить';

  @override
  String get message => 'Сообщение';

  @override
  String get createTheTopic => 'Создать тему';

  @override
  String get reportAUser => 'Сообщить о пользователе';

  @override
  String get user => 'Пользователь';

  @override
  String get reason => 'Причина';

  @override
  String get whatIsIheMatter => 'Что это было?';

  @override
  String get cheat => 'Жульничество';

  @override
  String get troll => 'Троллинг';

  @override
  String get other => 'Другое';

  @override
  String get reportDescriptionHelp => 'Поделитесь с нами ссылками на игры, где, как вам кажется, были нарушены правила, и опишите, в чём дело. Недостаточно просто написать «он мухлюет», пожалуйста, опишите, как вы пришли к такому выводу. Мы сработаем оперативнее, если вы напишете на английском языке.';

  @override
  String get error_provideOneCheatedGameLink => 'Пожалуйста, добавьте ссылку хотя бы на одну игру, где по вашему мнению были нарушены правила.';

  @override
  String by(String param) {
    return '$param';
  }

  @override
  String importedByX(String param) {
    return 'Импортировано $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Эта тема закрыта.';

  @override
  String get blog => 'Блог';

  @override
  String get notes => 'Заметки';

  @override
  String get typePrivateNotesHere => 'Здесь вы можете оставить личные заметки об игре';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Написать приватную заметку об этом пользователе';

  @override
  String get noNoteYet => 'Пока нет ни одной заметки';

  @override
  String get invalidUsernameOrPassword => 'Неверное имя пользователя или пароль';

  @override
  String get incorrectPassword => 'Неверный пароль';

  @override
  String get invalidAuthenticationCode => 'Неверный код аутентификации';

  @override
  String get emailMeALink => 'Прислать ссылку мне на почту';

  @override
  String get currentPassword => 'Текущий пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get newPasswordAgain => 'Новый пароль (ещё раз)';

  @override
  String get newPasswordsDontMatch => 'Новые пароли не совпадают';

  @override
  String get newPasswordStrength => 'Надёжность пароля';

  @override
  String get clockInitialTime => 'Начальное время на часах';

  @override
  String get clockIncrement => 'Добавка времени';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get letOtherPlayersFollowYou => 'Разрешить другим игрокам подписываться на вас';

  @override
  String get letOtherPlayersChallengeYou => 'Разрешить другим игрокам вызывать вас на игру';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Разрешить другим игрокам приглашать вас в студию';

  @override
  String get sound => 'Звук';

  @override
  String get none => 'Нет';

  @override
  String get fast => 'Быстро';

  @override
  String get normal => 'Нормальная';

  @override
  String get slow => 'Медленно';

  @override
  String get insideTheBoard => 'Внутри доски';

  @override
  String get outsideTheBoard => 'Вне доски';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'В медленных играх';

  @override
  String get always => 'Всегда';

  @override
  String get never => 'Никогда';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 решил участвовать в $param2';
  }

  @override
  String get victory => 'Победа';

  @override
  String get defeat => 'Поражение';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 против $param2 в $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 против $param2 в $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 против $param2 в $param3';
  }

  @override
  String get timeline => 'Хронология';

  @override
  String get starting => 'Начинается:';

  @override
  String get allInformationIsPublicAndOptional => 'Вся указываемая здесь информация будет доступна публично, добавляйте её по своему желанию.';

  @override
  String get biographyDescription => 'Расскажите о себе, что вы любите в шахматах, ваши любимые дебюты, партии, игроки...';

  @override
  String get listBlockedPlayers => 'Список игроков, которых вы заблокировали';

  @override
  String get human => 'Человек';

  @override
  String get computer => 'Компьютер';

  @override
  String get side => 'Сторона';

  @override
  String get clock => 'Часы';

  @override
  String get opponent => 'Соперник';

  @override
  String get learnMenu => 'Обучение';

  @override
  String get studyMenu => 'Студия';

  @override
  String get practice => 'Практика';

  @override
  String get community => 'Сообщество';

  @override
  String get tools => 'Инструменты';

  @override
  String get increment => 'Добавка';

  @override
  String get error_unknown => 'Неверное значение';

  @override
  String get error_required => 'Это обязательное поле';

  @override
  String get error_email => 'Неверный адрес электронной почты';

  @override
  String get error_email_acceptable => 'Этот адрес электронной почты недопустим. Проверьте его и повторите попытку.';

  @override
  String get error_email_unique => 'Адрес электронной почты недействителен или уже занят';

  @override
  String get error_email_different => 'Это уже и так ваш адрес электронной почты';

  @override
  String error_minLength(String param) {
    return 'Минимальная длина — $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Максимальная длина — $param';
  }

  @override
  String error_min(String param) {
    return 'Значение должно быть больше либо равным $param';
  }

  @override
  String error_max(String param) {
    return 'Значение должно быть меньше либо равным $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Если их рейтинг ± $param';
  }

  @override
  String get ifRegistered => 'Если зарегистрированы';

  @override
  String get onlyExistingConversations => 'Только существующие обсуждения';

  @override
  String get onlyFriends => 'Только друзьям';

  @override
  String get menu => 'Меню';

  @override
  String get castling => 'Рокировка';

  @override
  String get whiteCastlingKingside => 'Белые O-O';

  @override
  String get blackCastlingKingside => 'Чёрные O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Проведённое за игрой время: $param';
  }

  @override
  String get watchGames => 'Смотреть игры';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Времени на TV: $param';
  }

  @override
  String get watch => 'Просмотр';

  @override
  String get videoLibrary => 'Видеотека';

  @override
  String get streamersMenu => 'Стримеры';

  @override
  String get mobileApp => 'Мобильное приложение';

  @override
  String get webmasters => 'Разработчикам';

  @override
  String get about => 'О сайте';

  @override
  String aboutX(String param) {
    return 'О $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 — бесплатный ($param2) шахматный сервер с открытым исходным кодом без рекламы.';
  }

  @override
  String get really => 'именно так';

  @override
  String get contribute => 'Внести вклад в развитие';

  @override
  String get termsOfService => 'Пользовательское соглашение';

  @override
  String get sourceCode => 'Исходный код';

  @override
  String get simultaneousExhibitions => 'Сеанс одновременной игры';

  @override
  String get host => 'Сеансёр';

  @override
  String hostColorX(String param) {
    return 'Цвет сеансёра: $param';
  }

  @override
  String get yourPendingSimuls => 'Ваши предстоящие сеансы';

  @override
  String get createdSimuls => 'Недавно созданные сеансы';

  @override
  String get hostANewSimul => 'Создать новый сеанс';

  @override
  String get signUpToHostOrJoinASimul => 'Зарегистрируйтесь, чтобы организовать сеанс или присоединиться к нему';

  @override
  String get noSimulFound => 'Сеанс не найден';

  @override
  String get noSimulExplanation => 'Этот сеанс одновременной игры не существует.';

  @override
  String get returnToSimulHomepage => 'Вернуться на страницу сеансов';

  @override
  String get aboutSimul => 'Сеансы подразумевают сражение одного игрока с несколькими противниками одновременно.';

  @override
  String get aboutSimulImage => 'Из общего числа в 50 игр Фишер выиграл 47, сыграл вничью 2 и проиграл 1.';

  @override
  String get aboutSimulRealLife => 'Идея повторяет принятую в живых шахматах концепцию, когда дающий сеанс одновременной игры перемещается от стола к столу, чтобы совершить один ход.';

  @override
  String get aboutSimulRules => 'Когда начинается сеанс одновременной игры, каждый игрок начинает игру с сеансёром, который играет белыми. Сеанс закончится, когда все партии будут сыграны.';

  @override
  String get aboutSimulSettings => 'Сеансы одновременной игры не предполагают партий на рейтинг. Переигровки, отмены ходов и «добавки времени» запрещены.';

  @override
  String get create => 'Создать';

  @override
  String get whenCreateSimul => 'Если вы создадите сеанс одновременной игры, вам придётся сыграть против нескольких игроков одновременно.';

  @override
  String get simulVariantsHint => 'Если вы выберете несколько вариантов игры, тогда каждый игрок выберет тот из них, в который он хочет сыграть с вами.';

  @override
  String get simulClockHint => 'Настройка часов Фишера. Чем больше игроков играет против вас, тем больше времени вам может понадобится.';

  @override
  String get simulAddExtraTime => 'Вы можете взять себе дополнительное время на обдумывание партий.';

  @override
  String get simulHostExtraTime => 'Дополнительное время сеансёра';

  @override
  String get simulAddExtraTimePerPlayer => 'Добавьте начальное время на ваших часах для каждого игрока, вошедшего в ваш сеанс одновременной игры.';

  @override
  String get simulHostExtraTimePerPlayer => 'Добавка времени сеансёра для каждого игрока';

  @override
  String get lichessTournaments => 'Турниры Lichess';

  @override
  String get tournamentFAQ => 'Вопросы и ответы про Арену';

  @override
  String get timeBeforeTournamentStarts => 'Время до начала турнира';

  @override
  String get averageCentipawnLoss => 'Потери сантипешек в среднем';

  @override
  String get accuracy => 'Точность';

  @override
  String get keyboardShortcuts => 'Горячие клавиши';

  @override
  String get keyMoveBackwardOrForward => 'ход назад/вперёд';

  @override
  String get keyGoToStartOrEnd => 'в начало/конец';

  @override
  String get keyCycleSelectedVariation => 'Прокручивать выбранный вариант';

  @override
  String get keyShowOrHideComments => 'показать/скрыть комментарии';

  @override
  String get keyEnterOrExitVariation => 'ввести/закрыть вариант';

  @override
  String get keyRequestComputerAnalysis => 'Запросите компьютерный анализ, Учитесь на своих ошибках';

  @override
  String get keyNextLearnFromYourMistakes => 'Далее (Разобрать свои ошибки)';

  @override
  String get keyNextBlunder => 'Следующий зевок';

  @override
  String get keyNextMistake => 'Следующая ошибка';

  @override
  String get keyNextInaccuracy => 'Следующая неточность';

  @override
  String get keyPreviousBranch => 'Предыдущая ветка';

  @override
  String get keyNextBranch => 'Следующая ветка';

  @override
  String get toggleVariationArrows => 'Переключить стрелки вариантов';

  @override
  String get cyclePreviousOrNextVariation => 'Прокручивать предыдущий/следующий вариант';

  @override
  String get toggleGlyphAnnotations => 'Переключить значки аннотации';

  @override
  String get togglePositionAnnotations => 'Переключить аннотацию позиций';

  @override
  String get variationArrowsInfo => 'Стрелки вариантов позволяют вам перемещаться без использования списка ходов.';

  @override
  String get playSelectedMove => 'сыграть выбранный ход';

  @override
  String get newTournament => 'Новый турнир';

  @override
  String get tournamentHomeTitle => 'Шахматный турнир по различным вариантам шахмат и контролем времени';

  @override
  String get tournamentHomeDescription => 'Играйте в быстрые шахматы на турнире! Выбирайте любой из официальных турниров Lichess или создайте свой собственный. Пуля, блиц, классика, шахматы Фишера, король в центре, три шаха и другие варианты игры обеспечат вам бесконечное шахматное удовольствие!';

  @override
  String get tournamentNotFound => 'Турнир не найден';

  @override
  String get tournamentDoesNotExist => 'Такого турнира не существует.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Может быть отменён в том случае, если все игроки покинули турнир до его старта.';

  @override
  String get returnToTournamentsHomepage => 'Главная страница турниров';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Еженедельное распределение рейтингов в $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Ваш рейтинг в $param1 — $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Вы сильнее $param1 игроков в $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 лучше $param2 игроков в $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Лучше, чем $param1 из $param2 игроков';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Ваш рейтинг в $param ещё не определён.';
  }

  @override
  String get yourRating => 'Ваш рейтинг';

  @override
  String get cumulative => 'Всего';

  @override
  String get glicko2Rating => 'Рейтинг Glicko-2';

  @override
  String get checkYourEmail => 'Проверьте свой почтовый ящик';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Мы отправили вам письмо. Для активации учётной записи нажмите на ссылку в письме.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Если письма нет, проверьте папку для спама и другие места, куда оно могло попасть.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Мы отправили письмо по адресу $param. Нажмите на ссылку в нём для сброса пароля.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Регистрируясь, вы берёте на себя обязанность соблюдать наше $param';
  }

  @override
  String readAboutOur(String param) {
    return 'Ознакомьтесь с нашей $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Задержки передачи данных между вами и серверами lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Время обработки хода на сервере';

  @override
  String get downloadAnnotated => 'Скачать с аннотациями';

  @override
  String get downloadRaw => 'Скачать в исходном виде';

  @override
  String get downloadImported => 'Скачать в исходном виде';

  @override
  String get crosstable => 'Счёт';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Для перелистывания ходов можно использовать колёсико мыши над доской.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Пролистывайте варианты для их просмотра.';

  @override
  String get analysisShapesHowTo => 'Чтобы рисовать на доске кружки и стрелки, используйте Shift+левую кнопку мыши или правую кнопку.';

  @override
  String get letOtherPlayersMessageYou => 'Разрешить присылать вам сообщения';

  @override
  String get receiveForumNotifications => 'Получать уведомления при упоминании на форуме';

  @override
  String get shareYourInsightsData => 'Делиться вашей шахматной аналитикой';

  @override
  String get withNobody => 'Ни с кем';

  @override
  String get withFriends => 'С друзьями';

  @override
  String get withEverybody => 'Со всеми';

  @override
  String get kidMode => 'Детский режим';

  @override
  String get kidModeIsEnabled => 'Детский режим включён.';

  @override
  String get kidModeExplanation => 'Это для безопасности. В детском режиме отключены все коммуникации на сайте. Включите его для ваших детей и учеников, чтобы защитить их от других пользователей интернета.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'В детском режиме к логотипу lichess добавляется значок в виде $param, чтобы вы знали, что ваши дети находятся в безопасности.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Ваш аккаунт находится под управлением. Спросите своего учителя по шахматам об удалении детского режима.';

  @override
  String get enableKidMode => 'Включить детский режим';

  @override
  String get disableKidMode => 'Отключить детский режим';

  @override
  String get security => 'Безопасность';

  @override
  String get sessions => 'Сессии';

  @override
  String get revokeAllSessions => 'закрыть все сессии';

  @override
  String get playChessEverywhere => 'Играйте в шахматы везде';

  @override
  String get asFreeAsLichess => 'Бесплатен, как Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'С любовью к шахматам, а не к деньгам';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Все возможности для всех бесплатно';

  @override
  String get zeroAdvertisement => 'Никакой рекламы';

  @override
  String get fullFeatured => 'Максимальная функциональность';

  @override
  String get phoneAndTablet => 'На телефоне и планшете';

  @override
  String get bulletBlitzClassical => 'Блиц, Рапид, Классика';

  @override
  String get correspondenceChess => 'По переписке';

  @override
  String get onlineAndOfflinePlay => 'Игра онлайн и офлайн';

  @override
  String get viewTheSolution => 'Посмотреть решение';

  @override
  String get followAndChallengeFriends => 'Подписки и игра с друзьями';

  @override
  String get gameAnalysis => 'Анализ игры';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 создал $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 присоединился к $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 понравилось $param2';
  }

  @override
  String get quickPairing => 'Быстрый старт';

  @override
  String get lobby => 'Зал ожидания';

  @override
  String get anonymous => 'Аноним';

  @override
  String yourScore(String param) {
    return 'Ваш счёт: $param';
  }

  @override
  String get language => 'Язык (Language)';

  @override
  String get background => 'Тема';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get transparent => 'Прозрачная';

  @override
  String get deviceTheme => 'Системная';

  @override
  String get backgroundImageUrl => 'URL фонового изображения:';

  @override
  String get board => 'Доска';

  @override
  String get size => 'Размер';

  @override
  String get opacity => 'Непрозрачность';

  @override
  String get brightness => 'Яркость';

  @override
  String get hue => 'Насыщенность';

  @override
  String get boardReset => 'Сбросить на цвета по умолчанию';

  @override
  String get pieceSet => 'Оформление фигур';

  @override
  String get embedInYourWebsite => 'Получить код для вставки на свой сайт';

  @override
  String get usernameAlreadyUsed => 'Такое имя пользователя уже занято. Пожалуйста, попробуйте другое.';

  @override
  String get usernamePrefixInvalid => 'Имя пользователя должно начинаться с буквы.';

  @override
  String get usernameSuffixInvalid => 'Имя пользователя должно заканчиваться буквой или цифрой.';

  @override
  String get usernameCharsInvalid => 'Имя пользователя должно состоять только из букв, цифр, подчёркиваний и дефисов.';

  @override
  String get usernameUnacceptable => 'Это имя пользователя уже занято или недопустимо.';

  @override
  String get playChessInStyle => 'В шахматном стиле';

  @override
  String get chessBasics => 'Основы шахмат';

  @override
  String get coaches => 'Тренеры';

  @override
  String get invalidPgn => 'Некорректный PGN';

  @override
  String get invalidFen => 'Некорректный FEN';

  @override
  String get custom => 'Своя игра';

  @override
  String get notifications => 'Уведомления';

  @override
  String notificationsX(String param1) {
    return 'Уведомлений: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get practiceWithComputer => 'Тренировка с компьютером';

  @override
  String anotherWasX(String param) {
    return 'Можно было $param';
  }

  @override
  String bestWasX(String param) {
    return 'Лучше было $param';
  }

  @override
  String get youBrowsedAway => 'Вы вышли из режима тренировки';

  @override
  String get resumePractice => 'Возобновить тренировку';

  @override
  String get drawByFiftyMoves => 'Партия была сыграна вничью по правилу пятидесяти ходов.';

  @override
  String get theGameIsADraw => 'Игра окончилась вничью.';

  @override
  String get computerThinking => 'Компьютер думает...';

  @override
  String get seeBestMove => 'Посмотреть лучший ход';

  @override
  String get hideBestMove => 'Скрыть лучший ход';

  @override
  String get getAHint => 'Взять подсказку';

  @override
  String get evaluatingYourMove => 'Оценка вашего хода...';

  @override
  String get whiteWinsGame => 'Белые выиграли';

  @override
  String get blackWinsGame => 'Чёрные выиграли';

  @override
  String get learnFromYourMistakes => 'Разобрать свои ошибки';

  @override
  String get learnFromThisMistake => 'Разобрать эту ошибку';

  @override
  String get skipThisMove => 'Пропустить этот ход';

  @override
  String get next => 'Далее';

  @override
  String xWasPlayed(String param) {
    return 'Было сыграно $param';
  }

  @override
  String get findBetterMoveForWhite => 'Найдите более сильный ход за белых';

  @override
  String get findBetterMoveForBlack => 'Найдите более сильный ход за чёрных';

  @override
  String get resumeLearning => 'Вернуться к обучению';

  @override
  String get youCanDoBetter => 'Есть более сильный ход';

  @override
  String get tryAnotherMoveForWhite => 'Попробуйте другой ход за белых';

  @override
  String get tryAnotherMoveForBlack => 'Попробуйте другой ход за чёрных';

  @override
  String get solution => 'Ответ';

  @override
  String get waitingForAnalysis => 'Ожидание получения анализа';

  @override
  String get noMistakesFoundForWhite => 'Ошибок белых не найдено';

  @override
  String get noMistakesFoundForBlack => 'Ошибок чёрных не найдено';

  @override
  String get doneReviewingWhiteMistakes => 'Ошибки белых разобраны';

  @override
  String get doneReviewingBlackMistakes => 'Ошибки чёрных разобраны';

  @override
  String get doItAgain => 'Выполнить ещё раз';

  @override
  String get reviewWhiteMistakes => 'Разобрать ошибки белых';

  @override
  String get reviewBlackMistakes => 'Разобрать ошибки чёрных';

  @override
  String get advantage => 'Преимущество';

  @override
  String get opening => 'Дебют';

  @override
  String get middlegame => 'Миттельшпиль';

  @override
  String get endgame => 'Эндшпиль';

  @override
  String get conditionalPremoves => 'Условные предходы';

  @override
  String get addCurrentVariation => 'Добавить текущий вариант';

  @override
  String get playVariationToCreateConditionalPremoves => 'Выполните ходы на доске, чтобы задать условные предходы';

  @override
  String get noConditionalPremoves => 'Безусловные предходы';

  @override
  String playX(String param) {
    return 'Сыграть $param';
  }

  @override
  String get showUnreadLichessMessage => 'Вы получили личное сообщение от Lichess.';

  @override
  String get clickHereToReadIt => 'Нажмите здесь, чтобы прочитать его';

  @override
  String get sorry => 'Извините :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Мы вынуждены прервать вас на время.';

  @override
  String get why => 'Почему?';

  @override
  String get pleasantChessExperience => 'Наша цель — сделать шахматы интересными для всех.';

  @override
  String get goodPractice => 'Чтобы этого добиться, мы должны сделать так, чтобы все игроки следовали правилам хорошего тона.';

  @override
  String get potentialProblem => 'Когда мы обнаруживаем потенциальную проблему, мы показываем это сообщение.';

  @override
  String get howToAvoidThis => 'Как избежать этого?';

  @override
  String get playEveryGame => 'Доигрывайте все партии, которые начинали.';

  @override
  String get tryToWin => 'Пытайтесь выиграть (или хотя бы свести на ничью) каждую свою партию.';

  @override
  String get resignLostGames => 'Сдавайтесь в безнадёжной позиции (а не ждите, когда время закончится).';

  @override
  String get temporaryInconvenience => 'Приносим извинения за временные неудобства,';

  @override
  String get wishYouGreatGames => 'и желаем вам отличной игры на lichess.org.';

  @override
  String get thankYouForReading => 'Спасибо за внимание!';

  @override
  String get lifetimeScore => 'Счёт за всё время';

  @override
  String get currentMatchScore => 'Счёт в текущем матче';

  @override
  String get agreementAssistance => 'Подтверждаю, что я никогда не воспользуюсь посторонней помощью в своих играх (из шахматных программ, книг, баз данных и от других игроков).';

  @override
  String get agreementNice => 'Подтверждаю, что я буду с уважением относиться к другим игрокам.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Я согласен с тем, что не должен создавать множество учётных записей (за исключением причин, указанных в $param).';
  }

  @override
  String get agreementPolicy => 'Подтверждаю, что я буду следовать всем правилам Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Найти обсуждение или начать новое';

  @override
  String get edit => 'Изменить';

  @override
  String get bullet => 'Пуля';

  @override
  String get blitz => 'Блиц';

  @override
  String get rapid => 'Рапид';

  @override
  String get classical => 'Классика';

  @override
  String get ultraBulletDesc => 'Безумно быстрые игры: менее 30 секунд';

  @override
  String get bulletDesc => 'Очень быстрые игры: менее 3 минут';

  @override
  String get blitzDesc => 'Быстрые игры: от 3 до 8 минут';

  @override
  String get rapidDesc => 'Быстрые игры: от 8 до 25 минут';

  @override
  String get classicalDesc => 'Классические игры: 25 минут и больше';

  @override
  String get correspondenceDesc => 'Игры по переписке: один или несколько дней на ход';

  @override
  String get puzzleDesc => 'Тактический тренажёр';

  @override
  String get important => 'Важно';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'На ваш вопрос уже мог быть дан ответ $param1';
  }

  @override
  String get inTheFAQ => 'в ЧаВо';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Чтобы сообщить о мошенничестве или недостойном поведении, $param1';
  }

  @override
  String get useTheReportForm => 'заполните форму обращения';

  @override
  String toRequestSupport(String param1) {
    return 'Чтобы получить поддержку, $param1';
  }

  @override
  String get tryTheContactPage => 'посмотрите контактную информацию';

  @override
  String makeSureToRead(String param1) {
    return 'Не забудьте прочитать $param1';
  }

  @override
  String get theForumEtiquette => 'форумный этикет';

  @override
  String get thisTopicIsArchived => 'Эта тема была помещена в архив и добавить комментарий уже нельзя.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Вступите в $param1, чтобы писать в этом форуме';
  }

  @override
  String teamNamedX(String param1) {
    return 'клуб $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Вы пока не можете писать на форуме. Сыграйте несколько партий!';

  @override
  String get subscribe => 'Подписаться';

  @override
  String get unsubscribe => 'Отписаться';

  @override
  String mentionedYouInX(String param1) {
    return 'упомянул вас в «$param1».';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 упомянул вас в «$param2».';
  }

  @override
  String invitedYouToX(String param1) {
    return 'пригласил вас в «$param1».';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 пригласил вас в «$param2».';
  }

  @override
  String get youAreNowPartOfTeam => 'Теперь вы член клуба.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Вы вступили в «$param1».';
  }

  @override
  String get someoneYouReportedWasBanned => 'Кто-то был заблокирован по вашему обращению';

  @override
  String get congratsYouWon => 'Поздравляем, вы выиграли!';

  @override
  String gameVsX(String param1) {
    return 'Игра против $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 против $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Вы проиграли тому, кто нарушил пользовательское соглашение Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Возврат: $param1 $param2 рейтинговых очков.';
  }

  @override
  String get timeAlmostUp => 'Время почти истекло!';

  @override
  String get clickToRevealEmailAddress => '[Нажмите, чтобы раскрыть адрес электронной почты]';

  @override
  String get download => 'Загрузить';

  @override
  String get coachManager => 'Для тренеров';

  @override
  String get streamerManager => 'Управление стримом';

  @override
  String get cancelTournament => 'Отменить турнир';

  @override
  String get tournDescription => 'Описание турнира';

  @override
  String get tournDescriptionHelp => 'Хотите рассказать что-то пользователям? Постарайтесь быть лаконичны. Доступны ссылки в формате Markdown: [name](https://url)';

  @override
  String get ratedFormHelp => 'Игры идут с обсчётом рейтинга\nи влияют на рейтинг игроков';

  @override
  String get onlyMembersOfTeam => 'Только для членов клуба';

  @override
  String get noRestriction => 'Без ограничений';

  @override
  String get minimumRatedGames => 'Минимум рейтинговых игр';

  @override
  String get minimumRating => 'Минимальный рейтинг';

  @override
  String get maximumWeeklyRating => 'Максимальный еженедельный рейтинг';

  @override
  String positionInputHelp(String param) {
    return 'Вставьте правильную строку FEN, чтобы каждая игра начиналась с заданной позиции.\nЭто работает только для стандартных игр, но не с вариантами.\nВы можете использовать $param для создания позиции FEN, а затем вставить её здесь.\nОставьте поле пустым, чтобы игры начинались с обычной начальной позиции.';
  }

  @override
  String get cancelSimul => 'Отменить сеанс';

  @override
  String get simulHostcolor => 'Цвет сеансёра в каждой партии';

  @override
  String get estimatedStart => 'Предполагаемое время начала сеанса';

  @override
  String simulFeatured(String param) {
    return 'Показывать на $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Показывать сеанс на $param. Отключите для частных сеансов.';
  }

  @override
  String get simulDescription => 'Описание сеанса';

  @override
  String get simulDescriptionHelp => 'Хотите что-нибудь сказать участникам?';

  @override
  String markdownAvailable(String param) {
    return '$param доступен для расширенного форматирования.';
  }

  @override
  String get embedsAvailable => 'Вставьте URL игры или ссылку на студию, чтобы встроить её.';

  @override
  String get inYourLocalTimezone => 'В вашем часовом поясе';

  @override
  String get tournChat => 'Чат турнира';

  @override
  String get noChat => 'Без чата';

  @override
  String get onlyTeamLeaders => 'Только организаторы клуба';

  @override
  String get onlyTeamMembers => 'Только члены клуба';

  @override
  String get navigateMoveTree => 'Переход по ходам';

  @override
  String get mouseTricks => 'Движения мышкой';

  @override
  String get toggleLocalAnalysis => 'Включить компьютерный анализ';

  @override
  String get toggleAllAnalysis => 'Переключить все способы компьютерного анализа';

  @override
  String get playComputerMove => 'Play best computer move';

  @override
  String get analysisOptions => 'Параметры анализа';

  @override
  String get focusChat => 'Переключиться в окно чата';

  @override
  String get showHelpDialog => 'Показать справку';

  @override
  String get reopenYourAccount => 'Переоткройте свой аккаунт';

  @override
  String get closedAccountChangedMind => 'Если вы закрыли свой аккаунт, но с тех пор передумали, то у вас есть однократная возможность восстановить его.';

  @override
  String get onlyWorksOnce => 'Это сработает только один раз.';

  @override
  String get cantDoThisTwice => 'Если вы закроете свой аккаунт ещё раз, вы уже не сможете открыть его.';

  @override
  String get emailAssociatedToaccount => 'Адрес электронной почты, привязанный в этому аккаунту';

  @override
  String get sentEmailWithLink => 'Мы отправили вам письмо со ссылкой.';

  @override
  String get tournamentEntryCode => 'Код для участия в турнире';

  @override
  String get hangOn => 'Подождите!';

  @override
  String gameInProgress(String param) {
    return 'У вас идёт игра с $param.';
  }

  @override
  String get abortTheGame => 'Прервать игру';

  @override
  String get resignTheGame => 'Сдаться';

  @override
  String get youCantStartNewGame => 'Вы не можете начать новую игру, пока не завершена текущая.';

  @override
  String get since => 'С';

  @override
  String get until => 'До';

  @override
  String get lichessDbExplanation => 'Рейтинговые игры по всем игрокам Lichess';

  @override
  String get switchSides => 'Сменить сторону';

  @override
  String get closingAccountWithdrawAppeal => 'Закрытие вашей учётной записи отменит ваше обращение';

  @override
  String get ourEventTips => 'Наши советы по организации мероприятий';

  @override
  String get instructions => 'Руководство';

  @override
  String get showMeEverything => 'Показать всё';

  @override
  String get lichessPatronInfo => 'Lichess - это благотворительное и полностью бесплатное программное обеспечение с открытым исходным кодом.\nВсе эксплуатационные расходы, разработка и контент финансируются исключительно за счет пожертвований пользователей.';

  @override
  String get nothingToSeeHere => 'Здесь ничего нет пока.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ваш соперник покинул игру. Вы можете объявить победу через $count секунд.',
      many: 'Ваш соперник покинул игру. Вы можете объявить победу через $count секунд.',
      few: 'Ваш соперник покинул игру. Вы можете объявить победу через $count секунды.',
      one: 'Ваш соперник покинул игру. Вы можете объявить победу через $count секунду.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мат в $count полуходов',
      many: 'Мат в $count полуходов',
      few: 'Мат в $count полухода',
      one: 'Мат в $count полуход',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зевков',
      many: '$count зевков',
      few: '$count зевка',
      one: '$count зевок',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ошибок',
      many: '$count ошибок',
      few: '$count ошибки',
      one: '$count ошибка',
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
      few: '$count неточности',
      one: '$count неточность',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игроков',
      many: '$count игроков',
      few: '$count игрока',
      one: '$count игрок',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игр',
      many: '$count игр',
      few: '$count игры',
      one: '$count игра',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Рейтинг $count за $param2 партий',
      many: 'Рейтинг $count за $param2 партий',
      few: 'Рейтинг $count за $param2 партии',
      one: 'Рейтинг $count за $param2 партию',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отмеченных',
      many: '$count отмеченных',
      few: '$count отмеченные',
      one: '$count отмеченная',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часов',
      many: '$count часов',
      few: '$count часа',
      one: '$count час',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минут',
      many: '$count минут',
      few: '$count минуты',
      one: '$count минута',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Место обновляется каждые $count минут',
      many: 'Место обновляется каждые $count минут',
      few: 'Место обновляется каждые $count минуты',
      one: 'Место обновляется ежеминутно',
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
      few: '$count задачи',
      one: '$count задача',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count партий с вами',
      many: '$count партий с вами',
      few: '$count партии с вами',
      one: '$count партия с вами',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рейтинговых',
      many: '$count рейтинговых',
      few: '$count рейтинговые',
      one: '$count рейтинговая',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count побед',
      many: '$count побед',
      few: '$count победы',
      one: '$count победа',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поражений',
      many: '$count поражений',
      few: '$count поражения',
      one: '$count поражение',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ничьих',
      many: '$count ничьих',
      few: '$count ничьи',
      one: '$count ничья',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играются',
      many: '$count играются',
      few: '$count играются',
      one: '$count играется',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Дать $count секунд',
      many: 'Дать $count секунд',
      few: 'Дать $count секунды',
      one: 'Дать $count секунду',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count турнирных очков',
      many: '$count турнирных очков',
      few: '$count турнирных очка',
      one: '$count турнирное очко',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count студий',
      many: '$count студий',
      few: '$count студии',
      one: '$count студия',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сеансов',
      many: '$count сеансов',
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
      other: 'Рейтинговых игр ≥ $count',
      many: 'Рейтинговых игр ≥ $count',
      few: 'Рейтинговых игр ≥ $count',
      one: 'Рейтинговых игр ≥ $count',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Рейтинговых игр в $param2 ≥ $count',
      many: 'Рейтинговых игр в $param2 ≥ $count',
      few: 'Рейтинговых игр в $param2 ≥ $count',
      one: 'Рейтинговых игр в $param2 ≥ $count',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вы должны сыграть ещё $count рейтинговых игр в $param2',
      many: 'Вы должны сыграть ещё $count рейтинговых игр в $param2',
      few: 'Вы должны сыграть ещё $count рейтинговые игры в $param2',
      one: 'Вы должны сыграть ещё $count рейтинговую игру в $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вы должны сыграть ещё $count рейтинговых игр',
      many: 'Вы должны сыграть ещё $count рейтинговых игр',
      few: 'Вы должны сыграть ещё $count рейтинговые игры',
      one: 'Вы должны сыграть ещё $count рейтинговую игру',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count импортированных',
      many: '$count импортированных',
      few: '$count импортированные',
      one: '$count импортированная',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count друзей онлайн',
      many: '$count друзей онлайн',
      few: '$count друга онлайн',
      one: '$count друг онлайн',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count подписчиков',
      many: '$count подписчиков',
      few: '$count подписчика',
      one: '$count подписчик',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'подписан на $count игроков',
      many: 'подписан на $count игроков',
      few: 'подписаны $count',
      one: 'подписан на $count игрока',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Менее $count минут',
      many: 'Менее $count минут',
      few: 'Менее $count минут',
      one: 'Менее $count минуты',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count партий',
      many: '$count партий',
      few: '$count партии',
      one: '$count партия',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Максимум: $count символов.',
      many: 'Максимум: $count символов.',
      few: 'Максимум: $count символа.',
      one: 'Максимум: $count символ.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count блокировок',
      many: '$count блокировок',
      few: '$count блокировки',
      one: '$count блокировка',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сообщений на форуме',
      many: '$count сообщений на форуме',
      few: '$count сообщения на форуме',
      one: '$count сообщение на форуме',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игроков в $param2 на этой неделе.',
      many: '$count игроков в $param2 на этой неделе.',
      few: '$count игрока в $param2 на этой неделе.',
      one: '$count игрок в $param2 на этой неделе.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Доступно на $count языках!',
      many: 'Доступно на $count языках!',
      few: 'Доступно на $count языках!',
      one: 'Доступно на $count языке!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунд на первый ход',
      many: '$count секунд на первый ход',
      few: '$count секунды на первый ход',
      one: '$count секунда на первый ход',
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
      few: '$count секунды',
      one: '$count секунда',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'и сохранить $count последовательностей',
      many: 'и сохранить $count последовательностей',
      few: 'и сохранить $count последовательности',
      one: 'и сохранить $count последовательность',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Сделайте ход, чтобы начать';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Вы играете белыми фигурами во всех задачах';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Вы играете чёрными фигурами во всех задачах';

  @override
  String get stormPuzzlesSolved => 'задач решено';

  @override
  String get stormNewDailyHighscore => 'Новый дневной рекорд!';

  @override
  String get stormNewWeeklyHighscore => 'Новый недельный рекорд!';

  @override
  String get stormNewMonthlyHighscore => 'Новый месячный рекорд!';

  @override
  String get stormNewAllTimeHighscore => 'Новый рекорд за всё время!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Предыдущий рекорд был $param';
  }

  @override
  String get stormPlayAgain => 'Сыграть снова';

  @override
  String stormHighscoreX(String param) {
    return 'Рекорд: $param';
  }

  @override
  String get stormScore => 'Результат';

  @override
  String get stormMoves => 'Ходов';

  @override
  String get stormAccuracy => 'Точность';

  @override
  String get stormCombo => 'Комбо';

  @override
  String get stormTime => 'Время';

  @override
  String get stormTimePerMove => 'Времени на ход';

  @override
  String get stormHighestSolved => 'Труднейшая задача';

  @override
  String get stormPuzzlesPlayed => 'Сыгранные задачи';

  @override
  String get stormNewRun => 'Новая попытка (клавиша: Пробел)';

  @override
  String get stormEndRun => 'Закончить попытку (клавиша: Ввод)';

  @override
  String get stormHighscores => 'Рекорды';

  @override
  String get stormViewBestRuns => 'Посмотреть лучшие попытки';

  @override
  String get stormBestRunOfDay => 'Лучшая попытка дня';

  @override
  String get stormRuns => 'Серий';

  @override
  String get stormGetReady => 'Приготовьтесь!';

  @override
  String get stormWaitingForMorePlayers => 'Ожидание других игроков...';

  @override
  String get stormRaceComplete => 'Гонка завершена!';

  @override
  String get stormSpectating => 'Наблюдение';

  @override
  String get stormJoinTheRace => 'Присоединиться к гонке!';

  @override
  String get stormStartTheRace => 'Начать гонку';

  @override
  String stormYourRankX(String param) {
    return 'Ваше место: $param';
  }

  @override
  String get stormWaitForRematch => 'Ожидание реванша';

  @override
  String get stormNextRace => 'Следующая гонка';

  @override
  String get stormJoinRematch => 'Присоединиться к реваншу';

  @override
  String get stormWaitingToStart => 'Ожидание начала';

  @override
  String get stormCreateNewGame => 'Создать новую игру';

  @override
  String get stormJoinPublicRace => 'Принять участие в общей гонке';

  @override
  String get stormRaceYourFriends => 'Погоняться с друзьями';

  @override
  String get stormSkip => 'пропустить';

  @override
  String get stormSkipHelp => 'НОВИНКА! Вы можете пропустить один ход за гонку:';

  @override
  String get stormSkipExplanation => 'Пропустить этот ход, чтобы сохранить комбо! Только один раз за гонку.';

  @override
  String get stormFailedPuzzles => 'Нерешённые задачи';

  @override
  String get stormSlowPuzzles => 'Долго решаемые задачи';

  @override
  String get stormSkippedPuzzle => 'Пропущенная задача';

  @override
  String get stormThisWeek => 'На этой неделе';

  @override
  String get stormThisMonth => 'В этом месяце';

  @override
  String get stormAllTime => 'За всё время';

  @override
  String get stormClickToReload => 'Нажмите, чтобы перезагрузить';

  @override
  String get stormThisRunHasExpired => 'Время этой серии истекло!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Эта серия была открыта в другой вкладке!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count попыток',
      many: '$count попыток',
      few: '$count попытки',
      one: '1 попытка',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сыграно $count серий в $param2',
      many: 'Сыграны $count серий в $param2',
      few: 'Сыграны $count серии в $param2',
      one: 'Сыграна $count серия в $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Стримеры Lichess';

  @override
  String get studyShareAndExport => 'Поделиться и экспортировать';

  @override
  String get studyStart => 'Начать';
}
