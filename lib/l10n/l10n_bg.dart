// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get mobileAllGames => 'Всички игри';

  @override
  String get mobileAreYouSure => 'Сигурни ли сте?';

  @override
  String get mobileCancelTakebackOffer => 'Cancel takeback offer';

  @override
  String get mobileClearButton => 'Изчисти';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Clear saved move';

  @override
  String get mobileCustomGameJoinAGame => 'Join a game';

  @override
  String get mobileFeedbackButton => 'Отзиви';

  @override
  String mobileGreeting(String param) {
    return 'Здравейте, $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Здравейте';

  @override
  String get mobileHideVariation => 'Скрий вариацията';

  @override
  String get mobileHomeTab => 'Начало';

  @override
  String get mobileLiveStreamers => 'Live streamers';

  @override
  String get mobileMustBeLoggedIn => 'За да видите тази страница, трябва да влезете в профила си.';

  @override
  String get mobileNoSearchResults => 'Няма резултати';

  @override
  String get mobileNotFollowingAnyUser => 'You are not following any user.';

  @override
  String get mobileOkButton => 'ОК';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Players with \"$param\"';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Magnify dragged piece';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Do you want to end this run?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Nothing to show, please change the filters';

  @override
  String get mobilePuzzleStormNothingToShow => 'Nothing to show. Play some runs of Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Решете колкото можете повече задачи за 3 минути.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Решавайте задачи от любимите Ви дебюти или изберете друга тема.';

  @override
  String get mobilePuzzlesTab => 'Задачи';

  @override
  String get mobileRecentSearches => 'Последни търсения';

  @override
  String get mobileSettingsHapticFeedback => 'Вибрация при докосване';

  @override
  String get mobileSettingsImmersiveMode => 'Режим \"Цял екран\"';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and Puzzle Storm screens.';

  @override
  String get mobileSettingsTab => 'Настройки';

  @override
  String get mobileShareGamePGN => 'Сподели PGN';

  @override
  String get mobileShareGameURL => 'Сподели URL на играта';

  @override
  String get mobileSharePositionAsFEN => 'Сподели позицията във формат FEN';

  @override
  String get mobileSharePuzzle => 'Сподели тази задача';

  @override
  String get mobileShowComments => 'Покажи коментарите';

  @override
  String get mobileShowResult => 'Покажи резултат';

  @override
  String get mobileShowVariations => 'Покажи вариациите';

  @override
  String get mobileSomethingWentWrong => 'Възникна грешка.';

  @override
  String get mobileSystemColors => 'Системни цветове';

  @override
  String get mobileTheme => 'Тема';

  @override
  String get mobileToolsTab => 'Анализ';

  @override
  String get mobileWaitingForOpponentToJoin => 'Waiting for opponent to join...';

  @override
  String get mobileWatchTab => 'Гледай';

  @override
  String get activityActivity => 'Дейност';

  @override
  String get activityHostedALiveStream => 'Стартира предаване на живо';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Рейтинг #$param1 от $param2';
  }

  @override
  String get activitySignedUp => 'Регистрира се в lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Подкрепи lichess.org за $count месеца като $param2',
      one: 'Подкрепи lichess.org за $count месец като $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Упражнил $count позиции на $param2',
      one: 'Упражнил $count позиция на $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Реши $count тактически пъзела',
      one: 'Реши $count тактически пъзел',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изиграл $count $param2 игри',
      one: 'Изигра $count $param2 игра',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Публикувал $count съобщения в $param2',
      one: 'Публикува $count съобщение в $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изигра $count хода',
      one: 'Изигра $count ход',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'в $count кореспондентски игри',
      one: 'в $count кореспондентска игра',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завършил $count кореспондентни игри',
      one: 'Завърши $count кореспондентна игра',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изиграни $count $param2 кореспондентски игри',
      one: 'Изиграна $count $param2 кореспондентска игра',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Следва $count играчи',
      one: 'Последва $count играч',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Прибави $count нови последователи',
      one: 'Прибави $count нов последовател',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Домакин на $count шахматни сеанса',
      one: 'Бе домакин на $count шахматен сеанс',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Участва в $count шахматни сеанса',
      one: 'Участва в $count шахматен сеанс',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Създаде $count нови проучвания',
      one: 'Създаде $count ново проучване',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Участва в $count турнира',
      one: 'Участва в $count турнир',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '#$count място (горен $param2%) с $param3 игра в $param4',
      one: '#$count място (топ $param2%) с $param3 игра в $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Участва в $count турнира по швейцарската система',
      one: 'Участва в $count турнир по швейцарската система',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Присъедини се в $count отбори',
      one: 'Присъедини се в $count отбор',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Излъчване';

  @override
  String get broadcastMyBroadcasts => 'Моите излъчвания';

  @override
  String get broadcastLiveBroadcasts => 'Излъчвания на турнир на живо';

  @override
  String get broadcastBroadcastCalendar => 'Календар на излъчванията';

  @override
  String get broadcastNewBroadcast => 'Нови предавания на живо';

  @override
  String get broadcastSubscribedBroadcasts => 'Излчвания които следя';

  @override
  String get broadcastAboutBroadcasts => 'About broadcasts';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'How to use Lichess Broadcasts.';

  @override
  String get broadcastTheNewRoundHelp => 'The new round will have the same members and contributors as the previous one.';

  @override
  String get broadcastAddRound => 'Добави рунд';

  @override
  String get broadcastOngoing => 'Текущи';

  @override
  String get broadcastUpcoming => 'Предстоящи';

  @override
  String get broadcastRoundName => 'Име на рунда';

  @override
  String get broadcastRoundNumber => 'Номер на рунда';

  @override
  String get broadcastTournamentName => 'Име на турнира';

  @override
  String get broadcastTournamentDescription => 'Кратко описание на турнира';

  @override
  String get broadcastFullDescription => 'Пълно описание на събитието';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Незадължително дълго описание на излъчването. $param1 е налично. Дължината трябва да по-малка от $param2 знака.';
  }

  @override
  String get broadcastSourceSingleUrl => 'URL на PGN източника';

  @override
  String get broadcastSourceUrlHelp => 'Уебадресът, който Lichess ще проверява, за да получи осъвременявания на PGN. Той трябва да е публично достъпен от интернет.';

  @override
  String get broadcastSourceGameIds => 'До 64 идентификатора на игри в Lichess, разделени с празни места.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Start date in the tournament local timezone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'По избор, ако знаете, кога започва събитието';

  @override
  String get broadcastCurrentGameUrl => 'URL на настоящата партия';

  @override
  String get broadcastDownloadAllRounds => 'Изтегли всички рундове';

  @override
  String get broadcastResetRound => 'Нулирай този рунд';

  @override
  String get broadcastDeleteRound => 'Изтрий този рунд';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Окончателно изтрийте този рунд и всичките му игри.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Изтрийте този рунд и всичките му игри. Източникът трябва да е активен за да можете да ги възстановите.';

  @override
  String get broadcastEditRoundStudy => 'Edit round study';

  @override
  String get broadcastDeleteTournament => 'Изтрий този турнир';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Окончателно изтрий целия турнир, всичките му рундове и игри.';

  @override
  String get broadcastShowScores => 'Show players scores based on game results';

  @override
  String get broadcastReplacePlayerTags => 'По избор: промени имената на играчите, рейтингите и титлите';

  @override
  String get broadcastFideFederations => 'ФИДЕ федерации';

  @override
  String get broadcastTop10Rating => 'Top 10 rating';

  @override
  String get broadcastFidePlayers => 'FIDE players';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE player not found';

  @override
  String get broadcastFideProfile => 'ФИДЕ профил';

  @override
  String get broadcastFederation => 'Федерация';

  @override
  String get broadcastAgeThisYear => 'Възраст (тази година)';

  @override
  String get broadcastUnrated => 'Unrated';

  @override
  String get broadcastRecentTournaments => 'Recent tournaments';

  @override
  String get broadcastOpenLichess => 'Отвори в Lichess';

  @override
  String get broadcastTeams => 'Отбори';

  @override
  String get broadcastBoards => 'Дъски';

  @override
  String get broadcastOverview => 'Общ преглед';

  @override
  String get broadcastSubscribeTitle => 'Subscribe to be notified when each round starts. You can toggle bell or push notifications for broadcasts in your account preferences.';

  @override
  String get broadcastUploadImage => 'Upload tournament image';

  @override
  String get broadcastNoBoardsYet => 'No boards yet. These will appear once games are uploaded.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Boards can be loaded with a source or via the $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Започва след $param';
  }

  @override
  String get broadcastStartVerySoon => 'Излъчването ще започне след малко.';

  @override
  String get broadcastNotYetStarted => 'The broadcast has not yet started.';

  @override
  String get broadcastOfficialWebsite => 'Официален уебсайт';

  @override
  String get broadcastStandings => 'Класиране';

  @override
  String get broadcastOfficialStandings => 'Official Standings';

  @override
  String broadcastIframeHelp(String param) {
    return 'More options on the $param';
  }

  @override
  String get broadcastWebmastersPage => 'webmasters page';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'A public, real-time PGN source for this round. We also offer a $param for faster and more efficient synchronisation.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Embed this broadcast in your website';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Embed $param in your website';
  }

  @override
  String get broadcastRatingDiff => 'Rating diff';

  @override
  String get broadcastGamesThisTournament => 'Игри в този турнир';

  @override
  String get broadcastScore => 'Резултат';

  @override
  String get broadcastAllTeams => 'All teams';

  @override
  String get broadcastTournamentFormat => 'Формат на състезанието';

  @override
  String get broadcastTournamentLocation => 'Място на състезанието';

  @override
  String get broadcastTopPlayers => 'Top players';

  @override
  String get broadcastTimezone => 'Часова зона';

  @override
  String get broadcastFideRatingCategory => 'FIDE rating category';

  @override
  String get broadcastOptionalDetails => 'Optional details';

  @override
  String get broadcastPastBroadcasts => 'Минали излъчвания';

  @override
  String get broadcastAllBroadcastsByMonth => 'Виж всички излъчвания по месец';

  @override
  String get broadcastBackToLiveMove => 'Back to live move';

  @override
  String get broadcastSinceHideResults => 'Since you chose to hide the results, all the preview boards are empty to avoid spoilers.';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count излъчвания',
      one: '$count излъчване',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Предизвикателства: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Предизвикайте на партия';

  @override
  String get challengeChallengeDeclined => 'Предизвикателството е отказано';

  @override
  String get challengeChallengeAccepted => 'Предизвикателството е прието!';

  @override
  String get challengeChallengeCanceled => 'Предизвикателството е отменено.';

  @override
  String get challengeRegisterToSendChallenges => 'Регистрирайте се, за да отправяте предизвикателства.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Не можете да предизвикате $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param не приема предизвикателства.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Разликата между вашия рейтинг $param1 и $param2 е твърде голяма.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Не можете да отправите предизвикателството поради временен рейтинг $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param приема предизвикателства само от приятели.';
  }

  @override
  String get challengeDeclineGeneric => 'Не приемам предизвикателства в момента.';

  @override
  String get challengeDeclineLater => 'Не приемам предизвикателства точно сега, моля опитайте пак по-късно.';

  @override
  String get challengeDeclineTooFast => 'Този контрол на времето е прекалено бърз за мен, моля, предизвикайте ме пак с по-бавна игра.';

  @override
  String get challengeDeclineTooSlow => 'Този контрол на времето е твърде бавен за мен, моля, предизвикайте ме пак с по-бърза игра.';

  @override
  String get challengeDeclineTimeControl => 'Не приемам предизвикателства с такъв времеви формат.';

  @override
  String get challengeDeclineRated => 'Вместо това изпращайте ми рейтингови предизвикателства, моля.';

  @override
  String get challengeDeclineCasual => 'Моля изпратете ми приятелско предизвикателство.';

  @override
  String get challengeDeclineStandard => 'Не приемам вариант за партия шах в момента.';

  @override
  String get challengeDeclineVariant => 'Не желая да играя този вариант в момента.';

  @override
  String get challengeDeclineNoBot => 'Не приемам предизвикателства от ботове.';

  @override
  String get challengeDeclineOnlyBot => 'Приемам предизвикателства само от ботове.';

  @override
  String get challengeInviteLichessUser => 'Или поканете Lichess потребител:';

  @override
  String get contactContact => 'Контакти';

  @override
  String get contactContactLichess => 'Свържи се с нас';

  @override
  String get patronDonate => 'Дарете';

  @override
  String get patronLichessPatron => 'Lichess Дарител';

  @override
  String perfStatPerfStats(String param) {
    return '$param статистика';
  }

  @override
  String get perfStatViewTheGames => 'Виж игрите';

  @override
  String get perfStatProvisional => 'временен';

  @override
  String get perfStatNotEnoughRatedGames => 'Няма достатъчно игри с рейтинг, за да бъде изчислен точен рейтинг.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Прогрес през последните $param игри:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Отклонение на рейтинга: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'По-ниска стойност означава, че рейтингът е по-стабилен. Ако е над $param1, рейтингът се счита за условен. За да бъде включена в класиранията, тази стойност трябва да бъде под $param2 (стандартен шахмат) или $param3 (варианти).';
  }

  @override
  String get perfStatTotalGames => 'Общ брой игри';

  @override
  String get perfStatRatedGames => 'Игри с рейтинг';

  @override
  String get perfStatTournamentGames => 'Турнирни игри';

  @override
  String get perfStatBerserkedGames => 'Партии берсерк';

  @override
  String get perfStatTimeSpentPlaying => 'Време прекарано в игра';

  @override
  String get perfStatAverageOpponent => 'Среден рейтинг на противник';

  @override
  String get perfStatVictories => 'Победи';

  @override
  String get perfStatDefeats => 'Загуби';

  @override
  String get perfStatDisconnections => 'Прекъсната връзка';

  @override
  String get perfStatNotEnoughGames => 'Не са играни достатъчно игри';

  @override
  String perfStatHighestRating(String param) {
    return 'Най-висок рейтинг: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Най-нисък рейтинг: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'от $param1 до $param2';
  }

  @override
  String get perfStatWinningStreak => 'Печеливша поредица';

  @override
  String get perfStatLosingStreak => 'Губеща поредица';

  @override
  String perfStatLongestStreak(String param) {
    return 'Най-дълга поредица: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Текуща поредица: $param';
  }

  @override
  String get perfStatBestRated => 'Най-добри победи в игри с рейтинг';

  @override
  String get perfStatGamesInARow => 'Изиграни игри подред';

  @override
  String get perfStatLessThanOneHour => 'По-малко от час между игри';

  @override
  String get perfStatMaxTimePlaying => 'Най-дълго време прекарано в игра';

  @override
  String get perfStatNow => 'сега';

  @override
  String get preferencesPreferences => 'Предпочитания';

  @override
  String get preferencesDisplay => 'Изглед';

  @override
  String get preferencesPrivacy => 'Поверителност';

  @override
  String get preferencesNotifications => 'Известия';

  @override
  String get preferencesPieceAnimation => 'Движение на фигурите';

  @override
  String get preferencesMaterialDifference => 'Разлика в притежанието';

  @override
  String get preferencesBoardHighlights => 'Осветяване на дъската (последен ход и шах)';

  @override
  String get preferencesPieceDestinations => 'Обозначение на ходовете (позволени ходове и предварително задаване)';

  @override
  String get preferencesBoardCoordinates => 'Координати на дъската (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Списък на ходовете докато играя';

  @override
  String get preferencesPgnPieceNotation => 'Нотация';

  @override
  String get preferencesChessPieceSymbol => 'Символ';

  @override
  String get preferencesPgnLetter => 'Буква (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Режим Zen';

  @override
  String get preferencesShowPlayerRatings => 'Показване на рейтинга на играчите';

  @override
  String get preferencesShowFlairs => 'Показване на емоджитата на играчите';

  @override
  String get preferencesExplainShowPlayerRatings => 'Това позволява скриването на всички рейтинги от уебсайта за да можете да се фокусирате само на шахмата. Игрите все още може да са с рейтинг; тази настройка променя само това което виждате.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Показване на инструмента за промяна на размера на дъската';

  @override
  String get preferencesOnlyOnInitialPosition => 'Само в началната позиция';

  @override
  String get preferencesInGameOnly => 'Само по време на игра';

  @override
  String get preferencesExceptInGame => 'Освен по време на игра';

  @override
  String get preferencesChessClock => 'Шахматен часовник';

  @override
  String get preferencesTenthsOfSeconds => 'Десети от секундата';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Когато останалото време е < 10 секунди';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Водоравен стълб на времето';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Звук, когато времето привършва';

  @override
  String get preferencesGiveMoreTime => 'Дайте повече време';

  @override
  String get preferencesGameBehavior => 'Настройки на играта';

  @override
  String get preferencesHowDoYouMovePieces => 'Как да премествате фигури?';

  @override
  String get preferencesClickTwoSquares => 'Щракане върху две полета';

  @override
  String get preferencesDragPiece => 'Влачене на фигури';

  @override
  String get preferencesBothClicksAndDrag => 'И двете';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Предварителни ходове (докато противникът е на ход)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Връщане на ход (с одобрение на противника)';

  @override
  String get preferencesInCasualGamesOnly => 'Само в приятелски игри';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Автоматично изкарване на царица';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Задръжте клавиша <ctrl> по време на произвеждане за да изключите временно авто-произвеждането';

  @override
  String get preferencesWhenPremoving => 'Когато е направен предварителен ход';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Автоматично реми при трикратно повторение';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Когато остават по-малко от 30 секунди';

  @override
  String get preferencesMoveConfirmation => 'Потвърждение на хода';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Може да бъде изключено по време на игра от менюто на дъската';

  @override
  String get preferencesInCorrespondenceGames => 'Кореспондентски игри';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Кореспондентен и без ограничение';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Потвърждаване на предаване и предложение за реми';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Начин на рокада';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Преместване на царя с две полета';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Преместване на царя върху топа';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Въвеждане на ходове с клавиатурата';

  @override
  String get preferencesInputMovesWithVoice => 'Избирайте ходове с гласа си';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Ограничи стрелките да показват само допустими ходове';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Изпратете в чата \"Good game, well played\" след загуба или реми';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Вашите предпочитания бяха записани.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'За да прегледате ходовете, превъртете колелцето на мишката над дъската';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Ежедневен имейл със списък на Вашите кореспондентски игри';

  @override
  String get preferencesNotifyStreamStart => 'Стриймър започва да излъчва';

  @override
  String get preferencesNotifyInboxMsg => 'Ново входящо съобщение';

  @override
  String get preferencesNotifyForumMention => 'Споменати сте във форум';

  @override
  String get preferencesNotifyInvitedStudy => 'Покана към казус';

  @override
  String get preferencesNotifyGameEvent => 'Известия от кореспондентски игри';

  @override
  String get preferencesNotifyChallenge => 'Предизвикателства';

  @override
  String get preferencesNotifyTournamentSoon => 'Турнирът започва скоро';

  @override
  String get preferencesNotifyTimeAlarm => 'Времето в кореспондентска игра изтича';

  @override
  String get preferencesNotifyBell => 'Звукови известия в Lichess';

  @override
  String get preferencesNotifyPush => 'Получаване на известия на устойството Ви когато не сте в Lichess';

  @override
  String get preferencesNotifyWeb => 'Браузър';

  @override
  String get preferencesNotifyDevice => 'Устройство';

  @override
  String get preferencesBellNotificationSound => 'Мелодия за известия';

  @override
  String get preferencesBlindfold => 'Блинд';

  @override
  String get puzzlePuzzles => 'Задачи';

  @override
  String get puzzlePuzzleThemes => 'Задачи по теми';

  @override
  String get puzzleRecommended => 'Препоръчани';

  @override
  String get puzzlePhases => 'Етапи';

  @override
  String get puzzleMotifs => 'Тактики';

  @override
  String get puzzleAdvanced => 'За напреднали';

  @override
  String get puzzleLengths => 'Дължини';

  @override
  String get puzzleMates => 'Матове';

  @override
  String get puzzleGoals => 'Цели';

  @override
  String get puzzleOrigin => 'Произход';

  @override
  String get puzzleSpecialMoves => 'Специални ходове';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Хареса ли Ви този пъзел?';

  @override
  String get puzzleVoteToLoadNextOne => 'Гласувайте и преминете към следващия!';

  @override
  String get puzzleUpVote => 'Задачата ми хареса';

  @override
  String get puzzleDownVote => 'Задачата не ми хареса';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Пъзел рейтингът Ви няма да се промени. Обърнете внимание, че пъзелите не са състезание. Вашият рейтинг помага за подбирането на най-подходящите пъзели спрямо настоящите Ви умения.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Открийте най-добрия ход за белите.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Открийте най-добрия ход за черните.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'За да получите персонализирани задачи:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Задача $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Задача на деня';

  @override
  String get puzzleDailyPuzzle => 'Задача на деня';

  @override
  String get puzzleClickToSolve => 'Щракнете, за да решите';

  @override
  String get puzzleGoodMove => 'Добър ход';

  @override
  String get puzzleBestMove => 'Най-добър ход!';

  @override
  String get puzzleKeepGoing => 'Продължи…';

  @override
  String get puzzlePuzzleSuccess => 'Успех!';

  @override
  String get puzzlePuzzleComplete => 'Задачата е решена!';

  @override
  String get puzzleByOpenings => 'По дебюти';

  @override
  String get puzzlePuzzlesByOpenings => 'Задачи по дебюти';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Дебюти, които сте играли най-много в игри с рейтинг';

  @override
  String get puzzleUseFindInPage => 'Използвайте \"Намери на страницата\" в менюто на браузера за да намерите любимия си дебют!';

  @override
  String get puzzleUseCtrlF => 'Използвайте Ctrl+f за да намерите любимия си дебют!';

  @override
  String get puzzleNotTheMove => 'Това не е верният ход!';

  @override
  String get puzzleTrySomethingElse => 'Опитайте нещо друго.';

  @override
  String puzzleRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get puzzleHidden => 'скрито';

  @override
  String puzzleFromGameLink(String param) {
    return 'От игра $param';
  }

  @override
  String get puzzleContinueTraining => 'Продължи упражнението';

  @override
  String get puzzleDifficultyLevel => 'Ниво на трудност';

  @override
  String get puzzleNormal => 'Средно';

  @override
  String get puzzleEasier => 'По-лесно';

  @override
  String get puzzleEasiest => 'Най-лесно';

  @override
  String get puzzleHarder => 'По-трудно';

  @override
  String get puzzleHardest => 'Най-трудно';

  @override
  String get puzzleExample => 'Пример';

  @override
  String get puzzleAddAnotherTheme => 'Добавяне на нова тема';

  @override
  String get puzzleNextPuzzle => 'Следваща задача';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Веднага продължи към следващата задача';

  @override
  String get puzzlePuzzleDashboard => 'Панел на задачите';

  @override
  String get puzzleImprovementAreas => 'Области за подобрение';

  @override
  String get puzzleStrengths => 'Силни страни';

  @override
  String get puzzleHistory => 'История на задачите';

  @override
  String get puzzleSolved => 'решени';

  @override
  String get puzzleFailed => 'неуспешни';

  @override
  String get puzzleStreakDescription => 'Решавайте задачи с нарастваща трудност и направете поредица от победи. Няма хронометър, така че играйте спокойно. Един грешен ход, и играта свършва! Можете да пропуснете по един ход на сесия.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Вашите поредни победи: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Пропуснете този ход за да запазите поредицата си! Може да го направите само веднъж на сесия.';

  @override
  String get puzzleContinueTheStreak => 'Продължете поредицата';

  @override
  String get puzzleNewStreak => 'Нова поредица';

  @override
  String get puzzleFromMyGames => 'От моите партии';

  @override
  String get puzzleLookupOfPlayer => 'Търсене на задачи от партиите на играч';

  @override
  String puzzleFromXGames(String param) {
    return 'Задачи от партиите на $param\'';
  }

  @override
  String get puzzleSearchPuzzles => 'Търсене на задачи';

  @override
  String get puzzleFromMyGamesNone => 'В базата данни няма задачи от Ваши игри но Lichess разчита на Вас.\nИграйте още ускорени и класически партии за да увеличите шансовете задачи от Ваши партии да бъдат добавени!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 задачи намерени в $param2 игри';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Тренирай, анализирай, усъвършенствай се';

  @override
  String puzzlePercentSolved(String param) {
    return '$param решени';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Няма нищо за показване, първо порешавайте малко пъзели!';

  @override
  String get puzzleImprovementAreasDescription => 'Упражнявайте се върху тези, за да оптимизирате прогреса си!';

  @override
  String get puzzleStrengthDescription => 'Справяте се най-добре в тези теми';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изиграна $count пъти',
      one: 'Решавана $count пъти',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count точки под Вашия рейтинг на задачите',
      one: 'Една точка под Вашия рейтинг на задачите',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count точки над Вашия рейтинг на задачите',
      one: 'Една точка над Вашия рейтинг на задачите',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count решени',
      one: '$count решена',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count за повторение',
      one: '$count за повторение',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Напреднала пешка';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Произвеждането на пешка, или заплахата за произвеждане, е ключова стратегия.';

  @override
  String get puzzleThemeAdvantage => 'Предимство';

  @override
  String get puzzleThemeAdvantageDescription => 'Възползване от шанс за решаващо предимство. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Мат на Анастасия';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Кон и топ (или дама) се координират за да приклещят противниковия цар между края на дъската и друга фигура.';

  @override
  String get puzzleThemeArabianMate => 'Арабски мат';

  @override
  String get puzzleThemeArabianMateDescription => 'Кон и топ матират царя в ъгъла на полето.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Атака на f2 или f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Атака, фокусирана върху пешката на f2 или f7, подобно на прочутия Fried Liver дебют.';

  @override
  String get puzzleThemeAttraction => 'Завличане';

  @override
  String get puzzleThemeAttractionDescription => 'Размяна или жертване, окуражаващо или заставящо противникова фигура да се премести на поле, което дава възможност за тактическо развитие.';

  @override
  String get puzzleThemeBackRankMate => 'Мат на задна линия';

  @override
  String get puzzleThemeBackRankMateDescription => 'Мат на царя на неговия хоризонтал, когато е заклещен от собствените си фигури.';

  @override
  String get puzzleThemeBishopEndgame => 'Офицерски ендшпил';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Ендшпил само с офицери и пешки.';

  @override
  String get puzzleThemeBodenMate => 'Мат на Боден';

  @override
  String get puzzleThemeBodenMateDescription => 'Два офицера използват пресичащи се диагонали за да матират цар обкръжен от собствените си фигури.';

  @override
  String get puzzleThemeCastling => 'Рокада';

  @override
  String get puzzleThemeCastlingDescription => 'Защити царя си, и приготви топа си за атака.';

  @override
  String get puzzleThemeCapturingDefender => 'Премахни защитата';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Премахване на главната защита на фигура, което позволява на вече незащитената фигура да бъде взета на следващия ход.';

  @override
  String get puzzleThemeCrushing => 'Погром';

  @override
  String get puzzleThemeCrushingDescription => 'Използвайте грешката на противника за да получите смазващо преимущество. (≥ 600сп)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Мат с два офицера';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Два офицера на съседни диагонали матират цар обкръжен от собствените си фигури.';

  @override
  String get puzzleThemeDovetailMate => 'Мат на Коцио';

  @override
  String get puzzleThemeDovetailMateDescription => 'Дамата матира стоящият до нея цар, чиито единствени две полета за отстъпление са блокирани от собствените му фигури.';

  @override
  String get puzzleThemeEquality => 'Изравняване';

  @override
  String get puzzleThemeEqualityDescription => 'Обрат от губеща позиция и постигане на равенство или равностойна позиция. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Атака на царския фланг';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Атака над противниковия цар след малка рокада.';

  @override
  String get puzzleThemeClearance => 'Освобождаване на поле';

  @override
  String get puzzleThemeClearanceDescription => 'Ход, често с темпо, който освобождава поле, вертикал или диагонал за последваща тактическа идея.';

  @override
  String get puzzleThemeDefensiveMove => 'Защитен ход';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Точен ход или поредица от ходове, за да се избегне загуба на материал или друго предимство за опонента.';

  @override
  String get puzzleThemeDeflection => 'Отвличане';

  @override
  String get puzzleThemeDeflectionDescription => 'Ход, с който се отвлича фигура от задължението ѝ - например да пази друга фигура. Също познато като \"претоварване\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Открита атака';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Преместване на фигура (например кон), която е блокирала пътя на далекобойна фигура (например топ), така че вече да не го блокира.';

  @override
  String get puzzleThemeDoubleCheck => 'Двоен шах';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Шах с две фигури едновременно. Получава се, когато преместената фигура дава шах заедно с далекобойна, която досега е била блокирана.';

  @override
  String get puzzleThemeEndgame => 'Ендшпил';

  @override
  String get puzzleThemeEndgameDescription => 'Тактика в последната фаза на играта.';

  @override
  String get puzzleThemeEnPassantDescription => 'Тактика включваща вземане \"ан пасан\", където пешка може да вземе противникова пешка, която я е подминала правейки двоен ход.';

  @override
  String get puzzleThemeExposedKing => 'Незащитен цар';

  @override
  String get puzzleThemeExposedKingDescription => 'Противниковият цар е не добре защитен, което често води до шах и мат.';

  @override
  String get puzzleThemeFork => 'Вилица';

  @override
  String get puzzleThemeForkDescription => 'Ход, в който фигура атакува едновременно поне две противникови фигури.';

  @override
  String get puzzleThemeHangingPiece => 'Висяща фигура';

  @override
  String get puzzleThemeHangingPieceDescription => 'Тактика, при която фигура на противника не е защитена или е недостатъчно защитена и може да бъде взета.';

  @override
  String get puzzleThemeHookMate => 'Мат-кука';

  @override
  String get puzzleThemeHookMateDescription => 'Шах и мат с топ, кон и пешка заедно с противникова пешка ограничаваща движението на противниковия цар.';

  @override
  String get puzzleThemeInterference => 'Вмешателство';

  @override
  String get puzzleThemeInterferenceDescription => 'Преместване на фигура между две противникови, така че едната или и двете да останат незащитени. Например кон на защитено поле между два топа.';

  @override
  String get puzzleThemeIntermezzo => 'Междинен ход';

  @override
  String get puzzleThemeIntermezzoDescription => 'Вместо да се играе очаквания ход, първо се прави друг (междинен) ход, който представлява заплаха за опонента и трябва да бъде предотвратена.';

  @override
  String get puzzleThemeKillBoxMate => 'Kill box mate';

  @override
  String get puzzleThemeKillBoxMateDescription => 'A rook is next to the enemy king and supported by a queen that also blocks the king\'s escape squares. The rook and the queen catch the enemy king in a 3 by 3 \"kill box\".';

  @override
  String get puzzleThemeVukovicMate => 'Vukovic mate';

  @override
  String get puzzleThemeVukovicMateDescription => 'A rook and knight team up to mate the king. The rook delivers mate while supported by a third piece, and the knight is used to block the king\'s escape squares.';

  @override
  String get puzzleThemeKnightEndgame => 'Конски ендшпил';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Ендшпил само с коне и пешки.';

  @override
  String get puzzleThemeLong => 'Дълга задача';

  @override
  String get puzzleThemeLongDescription => 'Победа в три хода.';

  @override
  String get puzzleThemeMaster => 'Майсторски Игри';

  @override
  String get puzzleThemeMasterDescription => 'Задачи от партии играни от титулувани играчи.';

  @override
  String get puzzleThemeMasterVsMaster => 'Партии Майстор срещу Майстор';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Задачи от партии между двама титулувани играчи.';

  @override
  String get puzzleThemeMate => 'Матове';

  @override
  String get puzzleThemeMateDescription => 'Победи със стил.';

  @override
  String get puzzleThemeMateIn1 => 'Мат в 1 ход';

  @override
  String get puzzleThemeMateIn1Description => 'Матирай с един ход.';

  @override
  String get puzzleThemeMateIn2 => 'Мат в 2 хода';

  @override
  String get puzzleThemeMateIn2Description => 'Матирай с два хода.';

  @override
  String get puzzleThemeMateIn3 => 'Мат в 3 хода';

  @override
  String get puzzleThemeMateIn3Description => 'Матирай с три хода.';

  @override
  String get puzzleThemeMateIn4 => 'Мат в 4 хода';

  @override
  String get puzzleThemeMateIn4Description => 'Матирай с четири хода.';

  @override
  String get puzzleThemeMateIn5 => 'Мат в 5 или повече хода';

  @override
  String get puzzleThemeMateIn5Description => 'Намерете дълга последователност от ходове водеща до мат.';

  @override
  String get puzzleThemeMiddlegame => 'Мителшпил';

  @override
  String get puzzleThemeMiddlegameDescription => 'Тактика във втората фаза на играта.';

  @override
  String get puzzleThemeOneMove => 'Едноходови задачи';

  @override
  String get puzzleThemeOneMoveDescription => 'Задача, която се решава само с един ход.';

  @override
  String get puzzleThemeOpening => 'Дебют';

  @override
  String get puzzleThemeOpeningDescription => 'Тактика в първата фаза на играта.';

  @override
  String get puzzleThemePawnEndgame => 'Пешечен Ендшпил';

  @override
  String get puzzleThemePawnEndgameDescription => 'Ендшпил само с пешки.';

  @override
  String get puzzleThemePin => 'Свръзка';

  @override
  String get puzzleThemePinDescription => 'Тактика, използваща свръзка, където една фигура не може да бъде преместена без да оголи за атака стоящата зад нея по-ценна фигура.';

  @override
  String get puzzleThemePromotion => 'Произвеждане';

  @override
  String get puzzleThemePromotionDescription => 'Произвеждането на пешка, или заплахата за произвеждане, е ключова стратегия.';

  @override
  String get puzzleThemeQueenEndgame => 'Дамски ендшпили';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Ендшпил само с дами и пешки.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Дама и топ';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Ендшпил само с дами, топове и пешки.';

  @override
  String get puzzleThemeQueensideAttack => 'Атака на дамския фланг';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Атака на противниковия цар след голяма рокада.';

  @override
  String get puzzleThemeQuietMove => 'Тих ход';

  @override
  String get puzzleThemeQuietMoveDescription => 'Ход, с който не се дава шах и не се залавя фигура, но осигурява неизбежна опасност при последващ ход.';

  @override
  String get puzzleThemeRookEndgame => 'Топовен ендшпил';

  @override
  String get puzzleThemeRookEndgameDescription => 'Ендшпил само с топове и пешки.';

  @override
  String get puzzleThemeSacrifice => 'Жертване';

  @override
  String get puzzleThemeSacrificeDescription => 'Тактика, включваща краткосрочното жертване на материал, с цел получаване на предимство след последваща редица от форсирани ходове.';

  @override
  String get puzzleThemeShort => 'Кратка задача';

  @override
  String get puzzleThemeShortDescription => 'Победа в два хода.';

  @override
  String get puzzleThemeSkewer => 'Линеен удар';

  @override
  String get puzzleThemeSkewerDescription => 'Мотив, включващ атакуването на силна фигура, с цел тя да се отмести и да позволи по-слаба фигура зад нея да бъде взета или атакувана - обратното на свръзка.';

  @override
  String get puzzleThemeSmotheredMate => 'Задушаващ мат';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Шах и мат от кон, при който царят не може да бъде местен, защото е обграден (задушен) от свои фигури.';

  @override
  String get puzzleThemeSuperGM => 'Партии на Супер Гросмайстори';

  @override
  String get puzzleThemeSuperGMDescription => 'Задачи от игри играни от най-добрите играчи в света.';

  @override
  String get puzzleThemeTrappedPiece => 'Фигура в капан';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Фигура, която не може да избегне вземане поради ограничени ходове.';

  @override
  String get puzzleThemeUnderPromotion => 'Подпроизвеждане на пешка';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Произвеждане в кон, офицер или топ.';

  @override
  String get puzzleThemeVeryLong => 'Много дълги задачи';

  @override
  String get puzzleThemeVeryLongDescription => 'Четири или повече хода до победа.';

  @override
  String get puzzleThemeXRayAttack => 'Рентгенова атака';

  @override
  String get puzzleThemeXRayAttackDescription => 'Фигура атакува или защитава поле зад противникова фигура.';

  @override
  String get puzzleThemeZugzwang => 'Цугцванг';

  @override
  String get puzzleThemeZugzwangDescription => 'Опонентът има малко възможни ходове и всеки един от тях води до влошаване на положението му.';

  @override
  String get puzzleThemeMix => 'От всичко по малко';

  @override
  String get puzzleThemeMixDescription => 'По малко от всичко. Не знаете какво да очаквате, така че бъдете готови за всичко! Точно като в истинските игри.';

  @override
  String get puzzleThemePlayerGames => 'Партии на играча';

  @override
  String get puzzleThemePlayerGamesDescription => 'Разгледайте пъзели генерирани от вашите игри, или игрите на други играчи.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Тези пъзели са публични и могат да бъдат изтеглени от $param.';
  }

  @override
  String get searchSearch => 'Търсене';

  @override
  String get settingsSettings => 'Настройки';

  @override
  String get settingsCloseAccount => 'Закриване на регистрацията';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Вашият акаунт се управлява и не може да бъде закрит.';

  @override
  String get settingsCantOpenSimilarAccount => 'Няма да Ви бъде позволено да направите нова регистрация със същото име, дори и с различна големина на буквите.';

  @override
  String get settingsCancelKeepAccount => 'Откажи и запази акаунта';

  @override
  String get settingsCloseAccountAreYouSure => 'Сигурни ли сте, че искате да затворите акаунта си?';

  @override
  String get settingsThisAccountIsClosed => 'Тази регистрация е закрита.';

  @override
  String get playWithAFriend => 'Играй с приятел';

  @override
  String get playWithTheMachine => 'Играй с компютъра';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'За да поканите някого на игра, дайте му този адрес';

  @override
  String get gameOver => 'Край на партията';

  @override
  String get waitingForOpponent => 'Изчакване на противник';

  @override
  String get orLetYourOpponentScanQrCode => 'Или дайте на противника си да сканира този QR код';

  @override
  String get waiting => 'Изчакване';

  @override
  String get yourTurn => 'Вашият ход';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 ниво $param2';
  }

  @override
  String get level => 'Ниво';

  @override
  String get strength => 'Сила';

  @override
  String get toggleTheChat => 'Превключи чата';

  @override
  String get chat => 'Чат';

  @override
  String get resign => 'Предавам се';

  @override
  String get checkmate => 'Шах и мат';

  @override
  String get stalemate => 'Пат';

  @override
  String get white => 'Бели';

  @override
  String get black => 'Черни';

  @override
  String get asWhite => 'с белите';

  @override
  String get asBlack => 'с черните';

  @override
  String get randomColor => 'Произволна страна';

  @override
  String get createAGame => 'Създай игра';

  @override
  String get whiteIsVictorious => 'Белите победиха';

  @override
  String get blackIsVictorious => 'Черните победиха';

  @override
  String get youPlayTheWhitePieces => 'Вие играете с белите фигури';

  @override
  String get youPlayTheBlackPieces => 'Вие играете с черните фигури';

  @override
  String get itsYourTurn => 'Ваш ред е!';

  @override
  String get cheatDetected => 'Открита е измама';

  @override
  String get kingInTheCenter => 'Царят е в центъра';

  @override
  String get threeChecks => 'Три шаха';

  @override
  String get raceFinished => 'Надпреварата завърши';

  @override
  String get variantEnding => 'Край на варианта';

  @override
  String get newOpponent => 'Нов противник';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Противникът иска да играе нова игра с вас';

  @override
  String get joinTheGame => 'Влез в играта';

  @override
  String get whitePlays => 'Белите на ход';

  @override
  String get blackPlays => 'Черните на ход';

  @override
  String get opponentLeftChoices => 'Другият играч напусна играта. Можете да изискате победа, реми, или да изчакате.';

  @override
  String get forceResignation => 'Обяви победа';

  @override
  String get forceDraw => 'Обяви реми';

  @override
  String get talkInChat => 'Моля бъдете учтиви в чата!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Първият човек който отвори този адрес ще играе с вас.';

  @override
  String get whiteResigned => 'Белите се предадоха';

  @override
  String get blackResigned => 'Черните се предадоха';

  @override
  String get whiteLeftTheGame => 'Белите напуснаха';

  @override
  String get blackLeftTheGame => 'Черните напуснаха';

  @override
  String get whiteDidntMove => 'Белите не направиха ход';

  @override
  String get blackDidntMove => 'Черните не направиха ход';

  @override
  String get requestAComputerAnalysis => 'Поискайте компютърен анализ';

  @override
  String get computerAnalysis => 'Компютърен анализ';

  @override
  String get computerAnalysisAvailable => 'Компютърният анализ е наличен';

  @override
  String get computerAnalysisDisabled => 'Компютърният анализ е изключен';

  @override
  String get analysis => 'Анализ';

  @override
  String depthX(String param) {
    return 'Дълбочина $param';
  }

  @override
  String get usingServerAnalysis => 'Използване на сървърен анализ';

  @override
  String get loadingEngine => 'Зареждане на програмата ...';

  @override
  String get calculatingMoves => 'Изчисляване на ходовете...';

  @override
  String get engineFailed => 'Грешка при зареждане на програмата';

  @override
  String get cloudAnalysis => 'Облачен анализ';

  @override
  String get goDeeper => 'По-детайлно';

  @override
  String get showThreat => 'Покажи заплаха';

  @override
  String get inLocalBrowser => 'в локалния браузър';

  @override
  String get toggleLocalEvaluation => 'Превключване на локална оценка';

  @override
  String get promoteVariation => 'Повиши вариацията';

  @override
  String get makeMainLine => 'Направи основна линия';

  @override
  String get deleteFromHere => 'Изтриване от тук';

  @override
  String get collapseVariations => 'Скрий вариациите';

  @override
  String get expandVariations => 'Покажи вариациите';

  @override
  String get forceVariation => 'Покажи като вариация';

  @override
  String get copyVariationPgn => 'Копирай PGN на вариацията';

  @override
  String get move => 'Ход';

  @override
  String get variantLoss => 'Вариант на загуба';

  @override
  String get variantWin => 'Вариант на победа';

  @override
  String get insufficientMaterial => 'Недостатъчен материал';

  @override
  String get pawnMove => 'Ход с пешка';

  @override
  String get capture => 'Взимане';

  @override
  String get close => 'Затвори';

  @override
  String get winning => 'Печеливш';

  @override
  String get losing => 'Губещ';

  @override
  String get drawn => 'Реми';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get database => 'База данни';

  @override
  String get whiteDrawBlack => 'Бели / Реми / Черни';

  @override
  String averageRatingX(String param) {
    return 'Среден рейтинг: $param';
  }

  @override
  String get recentGames => 'Скорошни игри';

  @override
  String get topGames => 'Най-добрите игри';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Два милиона турнирни игри от $param1+ FIDE играчи от $param2 до $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' със закръгляне, базирано на броя полуходове до следващото вземане на фигура или преместване на пешка';

  @override
  String get noGameFound => 'Няма намерени игри';

  @override
  String get maxDepthReached => 'Максималната дълбочина е достигната!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Защо не включите повече игри в базата данни от менюто?';

  @override
  String get openings => 'Дебюти';

  @override
  String get openingExplorer => 'Изследовател на дебютите';

  @override
  String get openingEndgameExplorer => 'Изследовател на дебюти/ендшпили';

  @override
  String xOpeningExplorer(String param) {
    return '$param база данни';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Изиграй първия ход от изследователя на дебютите/ендшпилите';

  @override
  String get winPreventedBy50MoveRule => 'Победата е предотвратена от 50-ходовото правило';

  @override
  String get lossSavedBy50MoveRule => 'Загубата е преодоляна от правилото за 50 хода';

  @override
  String get winOr50MovesByPriorMistake => 'Победа или 50 хода заради грешка';

  @override
  String get lossOr50MovesByPriorMistake => 'Загуба или 50 хода заради грешка';

  @override
  String get unknownDueToRounding => 'Победа/загуба е гарантирана само ако е следвана препоръчваната вариация от последното вземане на фигура или преместване на пешка, поради възможното закръгляне на оставащите ходове до петдесетходовото правила в Syzygy ендшпил базата.';

  @override
  String get allSet => 'Готово!';

  @override
  String get importPgn => 'Въведи PGN';

  @override
  String get delete => 'Изтрий';

  @override
  String get deleteThisImportedGame => 'Желаете ли да изтриете играта?';

  @override
  String get replayMode => 'Режим на повторение';

  @override
  String get realtimeReplay => 'В реално време';

  @override
  String get byCPL => 'По CPL';

  @override
  String get enable => 'Включване';

  @override
  String get bestMoveArrow => 'Показване на най-добър ход';

  @override
  String get showVariationArrows => 'Показване на стрелки за вариациите';

  @override
  String get evaluationGauge => 'Показване на оценка';

  @override
  String get multipleLines => 'Множество ходове';

  @override
  String get cpus => 'Процесори';

  @override
  String get memory => 'Памет';

  @override
  String get infiniteAnalysis => 'Неограничен анализ';

  @override
  String get removesTheDepthLimit => 'Анализът ще е безкраен, а компютърът ви - топъл';

  @override
  String get blunder => 'Груба грешка';

  @override
  String get mistake => 'Грешка';

  @override
  String get inaccuracy => 'Неточност';

  @override
  String get moveTimes => 'Време за ход';

  @override
  String get flipBoard => 'Завърти дъската';

  @override
  String get threefoldRepetition => 'Тройно повторение';

  @override
  String get claimADraw => 'Обяви реми';

  @override
  String get offerDraw => 'Предложи реми';

  @override
  String get draw => 'Реми';

  @override
  String get drawByMutualAgreement => 'Реми по взаимно съгласие';

  @override
  String get fiftyMovesWithoutProgress => 'Петдесет хода без напредък';

  @override
  String get currentGames => 'Текущи игри';

  @override
  String get viewInFullSize => 'Гледай на пълен екран';

  @override
  String get logOut => 'Излез';

  @override
  String get signIn => 'Влез';

  @override
  String get rememberMe => 'Запомни ме';

  @override
  String get youNeedAnAccountToDoThat => 'Трябва Ви регистрация, за да направите това';

  @override
  String get signUp => 'Регистрирайте се';

  @override
  String get computersAreNotAllowedToPlay => 'Не е позволено използването на компютърна помощ. Моля, не си помагайте с програми за шах, архиви или други играчи по време на игра. Също, създаването на множество регистрации е силно непрепоръчително и ще се накаже с бан.';

  @override
  String get games => 'Игри';

  @override
  String get forum => 'Форум';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 написа по темата $param2';
  }

  @override
  String get latestForumPosts => 'Последни съобщения във форума';

  @override
  String get players => 'Играчи';

  @override
  String get friends => 'Приятели';

  @override
  String get otherPlayers => 'други играчи';

  @override
  String get discussions => 'Разговори';

  @override
  String get today => 'Днес';

  @override
  String get yesterday => 'Вчера';

  @override
  String get minutesPerSide => 'Време в минути';

  @override
  String get variant => 'Вариант';

  @override
  String get variants => 'Варианти';

  @override
  String get timeControl => 'Времева контрола';

  @override
  String get realTime => 'Определено време';

  @override
  String get correspondence => 'Кореспондентски';

  @override
  String get daysPerTurn => 'Дни за ход';

  @override
  String get oneDay => 'Един ден';

  @override
  String get time => 'Време';

  @override
  String get rating => 'Рейтинг';

  @override
  String get ratingStats => 'Рейтинг статистика';

  @override
  String get username => 'Потребителско име';

  @override
  String get usernameOrEmail => 'Потребител или имейл';

  @override
  String get changeUsername => 'Промяна на потребителско име';

  @override
  String get changeUsernameNotSame => 'Единствено могат да се заменят малки с главни букви. Например, \"johndoe\" с \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'Промяна на потребителско име. Може да се извърши само веднъж и можете да сменяте единствено малки и главни букви.';

  @override
  String get signupUsernameHint => 'Изберете прилично потребителско име. Няма да можете да го смените по-късно и всички регистрации с нецензурни имена биват затворени!';

  @override
  String get signupEmailHint => 'Ще го използваме само за възстановяване на паролата.';

  @override
  String get password => 'Парола';

  @override
  String get changePassword => 'Промяна на паролата';

  @override
  String get changeEmail => 'Промяна на имейла';

  @override
  String get email => 'Имейл';

  @override
  String get passwordReset => 'Задаване на нова парола';

  @override
  String get forgotPassword => 'Забравена парола?';

  @override
  String get error_weakPassword => 'Тази парола е често срещана и несигурна.';

  @override
  String get error_namePassword => 'Моля, не използвайте потребителското си име като парола.';

  @override
  String get blankedPassword => 'Използвали сте същата парола в друг сайт и той е бил компрометиран. За да гарантираме сигурността на вашия акаунт в Lichess, трябва да зададете нова парола. Благодарим ви за разбирането.';

  @override
  String get youAreLeavingLichess => 'Напускате Lichess';

  @override
  String get neverTypeYourPassword => 'Никога не използвайте паролата си за Lichess в друг сайт!';

  @override
  String proceedToX(String param) {
    return 'Продължи към $param';
  }

  @override
  String get passwordSuggestion => 'Не използвайте парола предложена от друг човек. Понеже може да ви открадне профила.';

  @override
  String get emailSuggestion => 'Не използвайте имейл адрес на друг човек. Понеже може да ви открадне профила.';

  @override
  String get emailConfirmHelp => 'Помощ за потвърждение на имейл';

  @override
  String get emailConfirmNotReceived => 'Не сте получили имейл за потвърждение на регистрацията ви?';

  @override
  String get whatSignupUsername => 'Кое потребителско име сте използвали, за да се регистрирате?';

  @override
  String usernameNotFound(String param) {
    return 'Не успяхме да намерим потребител с това име: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Можете да използвате това потребителско име, за да създадете нов акаунт';

  @override
  String emailSent(String param) {
    return 'Изпратихме имейл до $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Пристигането му може да отнеме известно време.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Изчакайте 5 минути и презаредете вашата поща.';

  @override
  String get checkSpamFolder => 'Проверете и папката спам, може да попадне там. Ако е така, моля отбележете го като \"не спам\".';

  @override
  String get emailForSignupHelp => 'Ако всичко останало се провали, изпратете ни този имейл:';

  @override
  String copyTextToEmail(String param) {
    return 'Копирайте и поставете горния текст и го изпратете на $param';
  }

  @override
  String get waitForSignupHelp => 'Скоро ще се свържем с вас, за да ви помогнем да завършите регистрацията си.';

  @override
  String accountConfirmed(String param) {
    return 'Потребителят $param е успешно потвърден.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Сега можете да влезете в системата като $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Не е необходимо да получавате имейл за потвърждение.';

  @override
  String accountClosed(String param) {
    return 'Регистрацията $param е закрита.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Акаунтът $param е регистриран без имейл.';
  }

  @override
  String get rank => 'Класация';

  @override
  String rankX(String param) {
    return 'Класация: $param';
  }

  @override
  String get gamesPlayed => 'Изиграни игри';

  @override
  String get ok => 'ОК';

  @override
  String get cancel => 'Отказ';

  @override
  String get whiteTimeOut => 'Времето на белите изтече';

  @override
  String get blackTimeOut => 'Времето на черните изтече';

  @override
  String get drawOfferSent => 'Изпратено предложение за реми';

  @override
  String get drawOfferAccepted => 'Предложението за реми е прието';

  @override
  String get drawOfferCanceled => 'Предложението за реми е отхвърлено';

  @override
  String get whiteOffersDraw => 'Белите предлагат реми';

  @override
  String get blackOffersDraw => 'Черните предлагат реми';

  @override
  String get whiteDeclinesDraw => 'Белите отказват реми';

  @override
  String get blackDeclinesDraw => 'Черните отказват реми';

  @override
  String get yourOpponentOffersADraw => 'Твоят противник предлага реми';

  @override
  String get accept => 'Приеми';

  @override
  String get decline => 'Откажи';

  @override
  String get playingRightNow => 'Играещи сега';

  @override
  String get eventInProgress => 'Играещи сега';

  @override
  String get finished => 'Приключи';

  @override
  String get abortGame => 'Отмени играта';

  @override
  String get gameAborted => 'Играта е отменена';

  @override
  String get standard => 'Обикновен';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Неограничено';

  @override
  String get mode => 'Начин';

  @override
  String get casual => 'Приятелски';

  @override
  String get rated => 'С рейтинг';

  @override
  String get casualTournament => 'Приятелски';

  @override
  String get ratedTournament => 'С рейтинг';

  @override
  String get thisGameIsRated => 'Тази игра е с рейтинг';

  @override
  String get rematch => 'Повторна';

  @override
  String get rematchOfferSent => 'Предложението за повторна е изпратено';

  @override
  String get rematchOfferAccepted => 'Предложението за повторна е прието';

  @override
  String get rematchOfferCanceled => 'Предложението за повторна е отхвърлено';

  @override
  String get rematchOfferDeclined => 'Предложението за повторна е отказано';

  @override
  String get cancelRematchOffer => 'Откажи предложението';

  @override
  String get viewRematch => 'Виж продължението';

  @override
  String get confirmMove => 'Потвърждаване на хода';

  @override
  String get play => 'Играй';

  @override
  String get inbox => 'Входящи';

  @override
  String get chatRoom => 'Стая за чатене';

  @override
  String get loginToChat => 'Влез в профила си за чат';

  @override
  String get youHaveBeenTimedOut => 'Времето ви за изчакване изтече.';

  @override
  String get spectatorRoom => 'Гледачница';

  @override
  String get composeMessage => 'Съставяне на съобщение';

  @override
  String get subject => 'Тема';

  @override
  String get send => 'Подаване';

  @override
  String get incrementInSeconds => 'Добавка в секунди';

  @override
  String get freeOnlineChess => 'Безплатен онлайн шах';

  @override
  String get exportGames => 'Изтегли партиите';

  @override
  String get ratingRange => 'Рейтинг на съперника';

  @override
  String get thisAccountViolatedTos => 'Този профил е нарушил Условията за Ползване на Lichess';

  @override
  String get openingExplorerAndTablebase => '& - Изследовател на дебютите';

  @override
  String get takeback => 'Върни ход';

  @override
  String get proposeATakeback => 'Предложи връщане на ход';

  @override
  String get takebackPropositionSent => 'Предложение за връщане на ход изпратено';

  @override
  String get takebackPropositionDeclined => 'Предложение за връщане на ход отказано';

  @override
  String get takebackPropositionAccepted => 'Предложение за връщане на ход прието';

  @override
  String get takebackPropositionCanceled => 'Предложението за връщане отхвърлено';

  @override
  String get yourOpponentProposesATakeback => 'Вашият противник предлага връщане';

  @override
  String get bookmarkThisGame => 'Отбележи тази игра';

  @override
  String get tournament => 'Турнир';

  @override
  String get tournaments => 'Турнири';

  @override
  String get tournamentPoints => 'Точки от турнири';

  @override
  String get viewTournament => 'Виж турнира';

  @override
  String get backToTournament => 'Продължи турнира';

  @override
  String get noDrawBeforeSwissLimit => 'В турнир по швейцарската система не можете да предложите реми при по-малко от 30 хода.';

  @override
  String get thematic => 'Тематичен';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Вашият $param рейтинг е условен';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Вашият $param1 рейтинг ($param2) е твърде висок';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Вашият топ седмичен $param1 рейтинг ($param2) е твърде висок';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Вашият $param1 рейтинг ($param2) е твърде висок';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 рейтинг ≥ $param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 рейтинг ≤ $param1';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Трябва да сте в отбора $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Не сте в отбора $param';
  }

  @override
  String get backToGame => 'Връщане към играта';

  @override
  String get siteDescription => 'Безплатна онлайн шах игра. Играй шах сега в изчистен интерфейс. Без нужда от регистрация, реклами или добавки. Играй шах с компютъра, с приятели или случайни противници.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 се присъедини към отбор $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 създаде отбор $param2';
  }

  @override
  String get startedStreaming => 'започна да излъчва';

  @override
  String xStartedStreaming(String param) {
    return '$param започна излъчване';
  }

  @override
  String get averageElo => 'Среден рейтинг на играчите';

  @override
  String get location => 'Местоположение';

  @override
  String get filterGames => 'Подбери игри';

  @override
  String get reset => 'Преустанови';

  @override
  String get apply => 'Подаване';

  @override
  String get save => 'Запази';

  @override
  String get leaderboard => 'Табло с водачите';

  @override
  String get screenshotCurrentPosition => 'Снимане на екрана на текущата позиция';

  @override
  String get gameAsGIF => 'Запазване на партията като гифче';

  @override
  String get pasteTheFenStringHere => 'Постави FEN низа тук';

  @override
  String get pasteThePgnStringHere => 'Постави PGN низа тук';

  @override
  String get orUploadPgnFile => 'Или качете PGN файл';

  @override
  String get fromPosition => 'От позиция';

  @override
  String get continueFromHere => 'Продължаване от тук';

  @override
  String get toStudy => 'Разучи';

  @override
  String get importGame => 'Добави игра';

  @override
  String get importGameExplanation => 'При поставяне на PGN може да разгледате играта с чата,\nда получите компютърен анализ и линк за споделяне.';

  @override
  String get importGameCaveat => 'Вариациите ще бъдат изтрити. За да ги запазите, импортирайте PGN чрез казус.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Това е шахматна CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Играйте хода си на дъската и докажете че сте човек.';

  @override
  String get captcha_fail => 'Моля решете шахматната captcha';

  @override
  String get notACheckmate => 'Не е шах-и-мат';

  @override
  String get whiteCheckmatesInOneMove => 'Белите на ход, мат в един ход';

  @override
  String get blackCheckmatesInOneMove => 'Черните на ход, мат в един ход';

  @override
  String get retry => 'Опитай отново';

  @override
  String get reconnecting => 'Свързване';

  @override
  String get noNetwork => 'Офлайн';

  @override
  String get favoriteOpponents => 'Предпочитани съперници';

  @override
  String get follow => 'Следвай';

  @override
  String get following => 'Следвам';

  @override
  String get unfollow => 'Не следвай';

  @override
  String followX(String param) {
    return 'Последвай $param';
  }

  @override
  String unfollowX(String param) {
    return 'Прекрати следването на $param';
  }

  @override
  String get block => 'Блокирай';

  @override
  String get blocked => 'Блокирани';

  @override
  String get unblock => 'Отблокирай';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 започна да следва $param2';
  }

  @override
  String get more => 'Още';

  @override
  String get memberSince => 'Член от';

  @override
  String lastSeenActive(String param) {
    return 'Последно влизане $param';
  }

  @override
  String get player => 'Играч';

  @override
  String get list => 'Списък';

  @override
  String get graph => 'Графика';

  @override
  String get required => 'Изисквано.';

  @override
  String get openTournaments => 'Отворени турнири';

  @override
  String get duration => 'Времетраене';

  @override
  String get winner => 'Победител';

  @override
  String get standing => 'Място';

  @override
  String get createANewTournament => 'Създаване на нов турнир';

  @override
  String get tournamentCalendar => 'Календар с турнирите';

  @override
  String get conditionOfEntry => 'Условие за участие:';

  @override
  String get advancedSettings => 'Разширени настройки';

  @override
  String get safeTournamentName => 'Изберете много безопасно име за турнира.';

  @override
  String get inappropriateNameWarning => 'Нещо дори и леко неуместно може да доведе до затваряне на вашия акаунт.';

  @override
  String get emptyTournamentName => 'Ако оставите празно името, тогава турнирът ще бъде кръстен на случайно избран гросмайстор.';

  @override
  String get makePrivateTournament => 'Ограничи достъпа до турнира с парола';

  @override
  String get join => 'Включи се';

  @override
  String get withdraw => 'Напусни';

  @override
  String get points => 'Точки';

  @override
  String get wins => 'Победи';

  @override
  String get losses => 'Загуби';

  @override
  String get createdBy => 'Създадено от';

  @override
  String get tournamentIsStarting => 'Турнирът започва';

  @override
  String get tournamentPairingsAreNowClosed => 'Съчетаването на играчи вече приключи.';

  @override
  String standByX(String param) {
    return 'Приготви се, $param, играчите ще бъдат съчетани!';
  }

  @override
  String get pause => 'Пауза';

  @override
  String get resume => 'Възобновяване';

  @override
  String get youArePlaying => 'Играете!';

  @override
  String get winRate => 'Успеваемост';

  @override
  String get berserkRate => 'Коефициент на Берсерк';

  @override
  String get performance => 'Производителност';

  @override
  String get tournamentComplete => 'Турнирът завърши';

  @override
  String get movesPlayed => 'Изиграни ходове';

  @override
  String get whiteWins => 'Белите печелят';

  @override
  String get blackWins => 'Черните печелят';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Равенства';

  @override
  String nextXTournament(String param) {
    return 'Следващ $param турнир:';
  }

  @override
  String get averageOpponent => 'Среден противник';

  @override
  String get boardEditor => 'Шахматен редактор';

  @override
  String get setTheBoard => 'Подреди дъската';

  @override
  String get popularOpenings => 'Популярни дебюти';

  @override
  String get endgamePositions => 'Ендшпилни позиции';

  @override
  String chess960StartPosition(String param) {
    return 'Начална позиция в Chess960: $param';
  }

  @override
  String get startPosition => 'Начална позиция';

  @override
  String get clearBoard => 'Празна дъска';

  @override
  String get loadPosition => 'Зареди позиция';

  @override
  String get isPrivate => 'Лично';

  @override
  String reportXToModerators(String param) {
    return 'Докладвай $param на съдийте';
  }

  @override
  String profileCompletion(String param) {
    return 'Завършеност на профила: $param';
  }

  @override
  String xRating(String param) {
    return '$param рейтинг';
  }

  @override
  String get ifNoneLeaveEmpty => 'При липса оставете празно';

  @override
  String get profile => 'Профил';

  @override
  String get editProfile => 'Редактирай профила';

  @override
  String get realName => 'Истинско име';

  @override
  String get setFlair => 'Изберете вашето емоджи';

  @override
  String get flair => 'Емоджи';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Животопис';

  @override
  String get countryRegion => 'Държава или регион';

  @override
  String get thankYou => 'Благодаря!';

  @override
  String get socialMediaLinks => 'Връзки към социални медии';

  @override
  String get oneUrlPerLine => 'Един URL на ред.';

  @override
  String get inlineNotation => 'Вградена нотация';

  @override
  String get makeAStudy => 'За съхранение и споделяне помислете за изготвяне на казус.';

  @override
  String get clearSavedMoves => 'Изтрий ходовете';

  @override
  String get previouslyOnLichessTV => 'Приключили игри';

  @override
  String get onlinePlayers => 'Играчи на линия';

  @override
  String get activePlayers => 'Дейни играчи';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Внимание, играта е с рейтинг, но без часовник!';

  @override
  String get success => 'Успех';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Автоматично преминаване към следващата игра след хода';

  @override
  String get autoSwitch => 'Автоматично превключване';

  @override
  String get puzzles => 'Задачи';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Име';

  @override
  String get description => 'Описание';

  @override
  String get descPrivate => 'Вътрешно описание';

  @override
  String get descPrivateHelp => 'Описание, което ще бъде видимо само от членовете на отбора. Ако е дадено, то ще замени публичното описание което членовете на отбора виждат.';

  @override
  String get no => 'Не';

  @override
  String get yes => 'Да';

  @override
  String get website => 'Уебсайт';

  @override
  String get mobile => 'Мобилен';

  @override
  String get help => 'Помощ:';

  @override
  String get createANewTopic => 'Създаване на нова тема';

  @override
  String get topics => 'Теми';

  @override
  String get posts => 'Публикации';

  @override
  String get lastPost => 'Последна публикация';

  @override
  String get views => 'Преглеждания';

  @override
  String get replies => 'Отговори';

  @override
  String get replyToThisTopic => 'Отговори по този въпрос';

  @override
  String get reply => 'Отговор';

  @override
  String get message => 'Съобщение';

  @override
  String get createTheTopic => 'Създай тема';

  @override
  String get reportAUser => 'Докладвай потребител';

  @override
  String get user => 'Потребител';

  @override
  String get reason => 'Причина';

  @override
  String get whatIsIheMatter => 'Какъв е случаят?';

  @override
  String get cheat => 'Измама';

  @override
  String get troll => 'Вредител';

  @override
  String get other => 'Друго';

  @override
  String get reportCheatBoostHelp => 'Поставете линкът към играта/игрите и обяснете какво не е наред с поведението на този потребител. Не казвайте само \"мами\", а ни кажете как стигнахте до това заключение.';

  @override
  String get reportUsernameHelp => 'Обяснете защо потребителското име е обидно. Не казвайте само \"обидно/неуместно е\", а ни кажете как стигнахте до това заключение - особено ако обидата е прикрита, не е на английски, или е историческа или културна препратка.';

  @override
  String get reportProcessedFasterInEnglish => 'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink => 'Моля дай поне един линк до измамна игра.';

  @override
  String by(String param) {
    return 'от $param';
  }

  @override
  String importedByX(String param) {
    return 'Внесени от $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Темата е затворена';

  @override
  String get blog => 'Блог';

  @override
  String get notes => 'Белeжки';

  @override
  String get typePrivateNotesHere => 'Запишете лични бележки тук';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Напишете лична бележка относно този потребител';

  @override
  String get noNoteYet => 'Още няма бележки';

  @override
  String get invalidUsernameOrPassword => 'Грешен потребител или парола';

  @override
  String get incorrectPassword => 'Неправилна парола';

  @override
  String get invalidAuthenticationCode => 'Невалиден код за удостоверяване';

  @override
  String get emailMeALink => 'Изпрати ми препратка на имейла';

  @override
  String get currentPassword => 'Текуща парола';

  @override
  String get newPassword => 'Нова парола';

  @override
  String get newPasswordAgain => 'Нова парола (пак)';

  @override
  String get newPasswordsDontMatch => 'Новите пароли не съвпадат';

  @override
  String get newPasswordStrength => 'Сила на паролата';

  @override
  String get clockInitialTime => 'Начално време на часовника';

  @override
  String get clockIncrement => 'Добавено време на часовника';

  @override
  String get privacy => 'Поверителност';

  @override
  String get privacyPolicy => 'Политика за поверителност';

  @override
  String get letOtherPlayersFollowYou => 'Позволи на другите играчи да ви следват';

  @override
  String get letOtherPlayersChallengeYou => 'Позволи на други играчи да ви предизвикват';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Позволяване на играчи да ви поканят в проучване';

  @override
  String get sound => 'Звук';

  @override
  String get none => 'Не';

  @override
  String get fast => 'Бързо';

  @override
  String get normal => 'Средно';

  @override
  String get slow => 'Бавно';

  @override
  String get insideTheBoard => 'На дъската';

  @override
  String get outsideTheBoard => 'Извън дъската';

  @override
  String get allSquaresOfTheBoard => 'Всички полета на дъската';

  @override
  String get onSlowGames => 'При бавни игри';

  @override
  String get always => 'Винаги';

  @override
  String get never => 'Никога';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 играе в $param2';
  }

  @override
  String get victory => 'Победа';

  @override
  String get defeat => 'Загуба';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 срещу $param2 в $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 срещу $param2 в $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 срещу $param2 в $param3';
  }

  @override
  String get timeline => 'Уведомления';

  @override
  String get starting => 'Начало:';

  @override
  String get allInformationIsPublicAndOptional => 'Всички данни са обществени и са по избор.';

  @override
  String get biographyDescription => 'Разкажете за себе си, какво харесвате в шахмата, вашите любими дебюти, игри, играчи…';

  @override
  String get listBlockedPlayers => 'Покажи блокираните играчи';

  @override
  String get human => 'Човек';

  @override
  String get computer => 'Компютър';

  @override
  String get side => 'Страна';

  @override
  String get clock => 'Часовник';

  @override
  String get opponent => 'Противник';

  @override
  String get learnMenu => 'Научи';

  @override
  String get studyMenu => 'Казус';

  @override
  String get practice => 'Упражнявайте се';

  @override
  String get community => 'Общност';

  @override
  String get tools => 'Средства';

  @override
  String get increment => 'Прибавяне';

  @override
  String get error_unknown => 'Невалидна стойност';

  @override
  String get error_required => 'Полето се изисква';

  @override
  String get error_email => 'Адресът на имейла е невалиден';

  @override
  String get error_email_acceptable => 'Този имейл адрес е неприемлив. Моля проверете дали сте го въвели правилно и опитайте отново.';

  @override
  String get error_email_unique => 'Този имейл адрес е невалиден или вече се използва';

  @override
  String get error_email_different => 'Това е текущият Ви имейл адрес';

  @override
  String error_minLength(String param) {
    return 'Трябва да е поне $param символа';
  }

  @override
  String error_maxLength(String param) {
    return 'Трябва да е максимум $param символа';
  }

  @override
  String error_min(String param) {
    return 'Трябва да е поне $param';
  }

  @override
  String error_max(String param) {
    return 'Трябва да е максимум $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Ако рейтингът е ± $param';
  }

  @override
  String get ifRegistered => 'Ако са регистрирани';

  @override
  String get onlyExistingConversations => 'Само съществуващи дискусии';

  @override
  String get onlyFriends => 'Само приятели';

  @override
  String get menu => 'Меню';

  @override
  String get castling => 'Рокада';

  @override
  String get whiteCastlingKingside => 'Бели O-O';

  @override
  String get blackCastlingKingside => 'Черни O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Прекарано време в игра: $param';
  }

  @override
  String get watchGames => 'Гледай на живо';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Време пред TV: $param';
  }

  @override
  String get watch => 'Гледай';

  @override
  String get videoLibrary => 'Видеотека';

  @override
  String get streamersMenu => 'Поточно предаващи';

  @override
  String get mobileApp => 'Приложение за мобилни';

  @override
  String get webmasters => 'Уебмайстори';

  @override
  String get about => 'Относно';

  @override
  String aboutX(String param) {
    return 'Относно $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 е шахматен сървър който е безплатен ($param2), свободен, без реклами и с отворен код.';
  }

  @override
  String get really => 'наистина';

  @override
  String get contribute => 'Принос';

  @override
  String get termsOfService => 'Условия';

  @override
  String get sourceCode => 'Изходен код';

  @override
  String get simultaneousExhibitions => 'Сеанси';

  @override
  String get host => 'Домакин';

  @override
  String hostColorX(String param) {
    return 'Домакин: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Нови сеанси';

  @override
  String get hostANewSimul => 'Бъди домакин на сеанс';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Сеансът не е намерен';

  @override
  String get noSimulExplanation => 'Този сеанс не съществува.';

  @override
  String get returnToSimulHomepage => 'Връщане към Главната страница';

  @override
  String get aboutSimul => 'Сеансът включва един играч срещу няколко други наведнъж.';

  @override
  String get aboutSimulImage => 'От 50 противника, Fischer спечели 47 игри, изравни 2 и загуби 1.';

  @override
  String get aboutSimulRealLife => 'Понятието е взето от събития в действителния свят. В действителния свят при сеансите приемащият сеанса се движи от маса на маса, за да играе хода си.';

  @override
  String get aboutSimulRules => 'Когато едновременното предизвикателство започне, всеки играч започва игра с приемащия, който играе с белите. Предизвикателството свършва когато всички игри са завършели.';

  @override
  String get aboutSimulSettings => 'Сеансите са винаги без рейтинг. Искане на повторна игра, връщане на ход и добавяне на време са изключени.';

  @override
  String get create => 'Създай';

  @override
  String get whenCreateSimul => 'Когато създадете сеанс, трябва да можете да играете с много играчи наведнъж.';

  @override
  String get simulVariantsHint => 'Ако изберете няколко варианта, всеки играч може да избере кой да играе.';

  @override
  String get simulClockHint => 'Fischer-засичане на времето. Колкото повече играчи приемеш, толкова повече време ти е нужно.';

  @override
  String get simulAddExtraTime => 'Можеш да си прибавиш време, за да се справиш с предизвикателството.';

  @override
  String get simulHostExtraTime => 'Допълнително време';

  @override
  String get simulAddExtraTimePerPlayer => 'Добавете начално време на Вашия часовник за всеки играч, който се присъедини към сеанса.';

  @override
  String get simulHostExtraTimePerPlayer => 'Допълнително време на организатора за всеки играч';

  @override
  String get lichessTournaments => 'Lichess състезания';

  @override
  String get tournamentFAQ => 'ЧЗВ относно състезанието';

  @override
  String get timeBeforeTournamentStarts => 'Време до началото на турнира';

  @override
  String get averageCentipawnLoss => 'Средна загуба в стотни на пешка';

  @override
  String get accuracy => 'Точност';

  @override
  String get keyboardShortcuts => 'Клавиатурни комбинации';

  @override
  String get keyMoveBackwardOrForward => 'мести напред/назад';

  @override
  String get keyGoToStartOrEnd => 'към началото/края';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'покажи/скрий коментарите';

  @override
  String get keyEnterOrExitVariation => 'влез/излез от вариацията';

  @override
  String get keyRequestComputerAnalysis => 'Поискайте компютърен анализ, Учете се от грешките си';

  @override
  String get keyNextLearnFromYourMistakes => 'Продължи (Учете се от грешките си)';

  @override
  String get keyNextBlunder => 'Следваща груба грешка';

  @override
  String get keyNextMistake => 'Следваща грешка';

  @override
  String get keyNextInaccuracy => 'Следваща неточност';

  @override
  String get keyPreviousBranch => 'Предходен клон';

  @override
  String get keyNextBranch => 'Следващ клон';

  @override
  String get toggleVariationArrows => 'Toggle variation arrows';

  @override
  String get cyclePreviousOrNextVariation => 'Превключи между предходна/следваща вариация';

  @override
  String get toggleGlyphAnnotations => 'Toggle move annotations';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => 'Variation arrows let you navigate without using the move list.';

  @override
  String get playSelectedMove => 'изиграй избраният ход';

  @override
  String get newTournament => 'Нов турнир';

  @override
  String get tournamentHomeTitle => 'Шахматният турнир включва различни времеви контроли и варианти';

  @override
  String get tournamentHomeDescription => 'Играй в състезания по бърз шахмат! Участвай в разписаните състезания или създай свое собствено. Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck и още възможности предоставящи безкрайна шахматна забава.';

  @override
  String get tournamentNotFound => 'Турнирът не е намерен';

  @override
  String get tournamentDoesNotExist => 'Този турнир не съществува.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Може да е отменен, ако всички участници са напуснали преди да е започнало.';

  @override
  String get returnToTournamentsHomepage => 'Връщане към началната страница';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Седмично разпределение на $param рейтинга';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Вашият $param1 рейтинг е $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Вие сте по-добър от $param1 от $param2 играчите.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 в по-добър от $param2 от $param3 играчите.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'По-добър от $param1 от $param2 играчите';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Нямате установен $param рейтинг.';
  }

  @override
  String get yourRating => 'Вашият рейтинг';

  @override
  String get cumulative => 'С натрупване';

  @override
  String get glicko2Rating => 'Рейтинг по Glicko-2';

  @override
  String get checkYourEmail => 'Проверете имейла си';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Изпратихме Ви имейл. Натиснете върху връзката в имейла, за да задействате регистрацията си.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ако не намирате имейла, проверете и на другите места където може бъде, като например кошче, спам, социални или други папки.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Изпратихме имейл на $param. Натиснете връзката в имейла, за да промените паролата на Вашата регистрация.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Със записването си, се съгласявате да спазвате нашите $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Прочетете за нашата $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Мрежово забавяне между вас и lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Времето, което отнема на lichess сървъра, за да обработи един ход';

  @override
  String get downloadAnnotated => 'Свали анотирана';

  @override
  String get downloadRaw => 'Свали необработена';

  @override
  String get downloadImported => 'Свали добавена';

  @override
  String get crosstable => 'Таблица';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Може още да скролираш върху дъската, за да местиш ходовете.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Задръжте курсора над компютърните вариации за да ги прегледате.';

  @override
  String get analysisShapesHowTo => 'Натисни shift едновременно с ляво или дясно копче за да рисуваш кръгове и стрелки върху дъската.';

  @override
  String get letOtherPlayersMessageYou => 'Разреши на другите да ви пишат';

  @override
  String get receiveForumNotifications => 'Получаване на съобщения когато сте споменати във форума';

  @override
  String get shareYourInsightsData => 'Споделете измерванията върху вашата игра';

  @override
  String get withNobody => 'С никой';

  @override
  String get withFriends => 'С приятели';

  @override
  String get withEverybody => 'С всеки';

  @override
  String get kidMode => 'Детски режим';

  @override
  String get kidModeIsEnabled => 'Детският режим е включен.';

  @override
  String get kidModeExplanation => 'В името на безопасността. В детския режим цялата комуникация в сайта е изключена. Включете детския режим, за да защитите вашите деца и ученици от другите потребители.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'В детския режим логото на Lichess става $param, за да сте сигурни в безопасността на своите деца.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Вашата сметка се управлява. Попитайте учителя си по шахмат за вдигане на детския режим.';

  @override
  String get enableKidMode => 'Включване на детски режим';

  @override
  String get disableKidMode => 'Изключване на детски режим';

  @override
  String get security => 'Сигурност';

  @override
  String get sessions => 'Заседания';

  @override
  String get revokeAllSessions => 'отмени всички сесии';

  @override
  String get playChessEverywhere => 'Играй шах навсякъде';

  @override
  String get asFreeAsLichess => 'Така безплатно, както lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Създадено с любов към шаха, а не към парите';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Всеки взима всички възможности безплатно';

  @override
  String get zeroAdvertisement => 'Без реклами';

  @override
  String get fullFeatured => 'С всичките му подробности';

  @override
  String get phoneAndTablet => 'Телефон и таблет';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, classical';

  @override
  String get correspondenceChess => 'Кореспондентен шах';

  @override
  String get onlineAndOfflinePlay => 'Онлайн и офлайн игра';

  @override
  String get viewTheSolution => 'Виж решението';

  @override
  String get followAndChallengeFriends => 'Следвай и предизвикай приятели';

  @override
  String get noChallenges => 'No challenges.';

  @override
  String get gameAnalysis => 'Анализ на партията';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 води $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 се присъедини към $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 хареса $param2';
  }

  @override
  String get quickPairing => 'Бързо свързване';

  @override
  String get lobby => 'Лоби';

  @override
  String get anonymous => 'Анонимен';

  @override
  String yourScore(String param) {
    return 'Резултатът ви: $param';
  }

  @override
  String get language => 'Език';

  @override
  String get background => 'Фон';

  @override
  String get light => 'Светъл';

  @override
  String get dark => 'Тъмен';

  @override
  String get transparent => 'Прозрачен';

  @override
  String get deviceTheme => 'Тема на устройството';

  @override
  String get backgroundImageUrl => 'URL адрес на фоновия образ:';

  @override
  String get board => 'Дъска';

  @override
  String get size => 'Размер';

  @override
  String get opacity => 'Прозрачност';

  @override
  String get brightness => 'Яркост';

  @override
  String get hue => 'Цветови тон';

  @override
  String get boardReset => 'Възстановяване на стандартните цветовете';

  @override
  String get pieceSet => 'Дизайн на фигури';

  @override
  String get embedInYourWebsite => 'Вграждане в уебсайта ви';

  @override
  String get usernameAlreadyUsed => 'Потребителското име е заето. Опитайте с друго име.';

  @override
  String get usernamePrefixInvalid => 'Потребителското име трябва да започва с буква.';

  @override
  String get usernameSuffixInvalid => 'Потребителското име трябва да завършва с буква или число.';

  @override
  String get usernameCharsInvalid => 'Потребителското име трябва да съдържа само букви, цифри, долни черти и тирета. Не се допускат последователни долни черти и тирета.';

  @override
  String get usernameUnacceptable => 'Това потребителско име не е приемливо.';

  @override
  String get playChessInStyle => 'Играй шах в стил';

  @override
  String get chessBasics => 'Основи на шаха';

  @override
  String get coaches => 'Треньори';

  @override
  String get invalidPgn => 'Невалиден PGN';

  @override
  String get invalidFen => 'Невалиден FEN';

  @override
  String get custom => 'По избор';

  @override
  String get notifications => 'Известия';

  @override
  String notificationsX(String param1) {
    return 'Известия: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Рейтинг: $param';
  }

  @override
  String get practiceWithComputer => 'Практикуване с компютър';

  @override
  String anotherWasX(String param) {
    return 'Друг ход бе $param';
  }

  @override
  String bestWasX(String param) {
    return 'Най-добър ход е $param';
  }

  @override
  String get youBrowsedAway => 'Навигирахте към друг изглед';

  @override
  String get resumePractice => 'Подновяване на упражнението';

  @override
  String get drawByFiftyMoves => 'Играта е реми по правилото за петдесетте хода.';

  @override
  String get theGameIsADraw => 'Партията е реми.';

  @override
  String get computerThinking => 'Компютърът размишлява...';

  @override
  String get seeBestMove => 'Вижте най-добрия ход';

  @override
  String get hideBestMove => 'Скриване на най-добрия ход';

  @override
  String get getAHint => 'Подсказка';

  @override
  String get evaluatingYourMove => 'Оценяване на хода...';

  @override
  String get whiteWinsGame => 'Белите побеждават';

  @override
  String get blackWinsGame => 'Черните побеждават';

  @override
  String get learnFromYourMistakes => 'Учете се от грешките си';

  @override
  String get learnFromThisMistake => 'Поучете се от тази грешка';

  @override
  String get skipThisMove => 'Пропускане на този ход';

  @override
  String get next => 'Напред';

  @override
  String xWasPlayed(String param) {
    return 'Предишен ход: $param';
  }

  @override
  String get findBetterMoveForWhite => 'Намерете по-добър ход за белите';

  @override
  String get findBetterMoveForBlack => 'Намерете по-добър ход за черните';

  @override
  String get resumeLearning => 'Възобновяване на обучението';

  @override
  String get youCanDoBetter => 'Можете да го направите по-добре';

  @override
  String get tryAnotherMoveForWhite => 'Опитайте друг ход за белите';

  @override
  String get tryAnotherMoveForBlack => 'Опитайте друг ход за черните';

  @override
  String get solution => 'Решение';

  @override
  String get waitingForAnalysis => 'Чакане на анализ';

  @override
  String get noMistakesFoundForWhite => 'Не са намерени грешки за белите';

  @override
  String get noMistakesFoundForBlack => 'Не са намерени грешки за черните';

  @override
  String get doneReviewingWhiteMistakes => 'Приключен преглед за грешки на белите';

  @override
  String get doneReviewingBlackMistakes => 'Приключен преглед за грешки на черните';

  @override
  String get doItAgain => 'Направете го пак';

  @override
  String get reviewWhiteMistakes => 'Преглед на грешки при белите';

  @override
  String get reviewBlackMistakes => 'Преглед на грешки при черните';

  @override
  String get advantage => 'Предимство';

  @override
  String get opening => 'Дебют';

  @override
  String get middlegame => 'Мителшпил';

  @override
  String get endgame => 'Ендшпил';

  @override
  String get conditionalPremoves => 'Предварителен ход под условие';

  @override
  String get addCurrentVariation => 'Добавяне на настоящата вариация';

  @override
  String get playVariationToCreateConditionalPremoves => 'Изиграйте вариация за да създадете предварителни ходове под условие';

  @override
  String get noConditionalPremoves => 'Без предварителни ходове под условие';

  @override
  String playX(String param) {
    return 'Играй $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Щракнете тук, за да го прочетете';

  @override
  String get sorry => 'Съжалявам :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Наложи се да Ви сложим в принудителна почивка за известно време.';

  @override
  String get why => 'Защо?';

  @override
  String get pleasantChessExperience => 'Стремим се да доставим приятно удоволствие от Шаха на всеки.';

  @override
  String get goodPractice => 'С тази цел трябва да подсигурим, че всички играчи спазват добри практики.';

  @override
  String get potentialProblem => 'Ако е налице потенциален проблем, показваме това съобщение.';

  @override
  String get howToAvoidThis => 'Как да се избегне това?';

  @override
  String get playEveryGame => 'Играйте всяка игра, която започнете.';

  @override
  String get tryToWin => 'Опитайте да спечелите (или поне да свършите наравно) всяка игра, която играете.';

  @override
  String get resignLostGames => 'Предавайте се, когато играта е загубена (не оставяйте часовникът просто да спре).';

  @override
  String get temporaryInconvenience => 'Извиняваме се за временното неудобство';

  @override
  String get wishYouGreatGames => 'и Ви желаем чудесни игри на lichess.org.';

  @override
  String get thankYouForReading => 'Благодарим, че прочетохте това!';

  @override
  String get lifetimeScore => 'Общ резултат';

  @override
  String get currentMatchScore => 'Текущ резултат';

  @override
  String get agreementAssistance => 'Съгласявам се, че никога няма да получавам помощ по време на игра (от компютър, книга, база данни или друг човек).';

  @override
  String get agreementNice => 'Съгласявам се, че винаги ще уважавам другите играчи.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Съгласявам се, че няма да се регистрирам няколко пъти (с изключение на причините изброени в $param).';
  }

  @override
  String get agreementPolicy => 'Съгласявам се, че ше спазвам всички правила на Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Търси или започни нов разговор';

  @override
  String get edit => 'Редактиране';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Ускорен';

  @override
  String get classical => 'Класически';

  @override
  String get ultraBulletDesc => 'Изключително бързи игри: под 30 секунди';

  @override
  String get bulletDesc => 'Много бързи игри: под 3 минути';

  @override
  String get blitzDesc => 'Бързи игри: 3 до 8 минути';

  @override
  String get rapidDesc => 'Ускорен (Rapid) шахмат: 8 до 25 минути';

  @override
  String get classicalDesc => 'Класически игри: над 25 минути';

  @override
  String get correspondenceDesc => 'Кореспондентски игри: един или повече дни на ход';

  @override
  String get puzzleDesc => 'Инструктор шахматни тактики';

  @override
  String get important => 'Важно';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Вашият въпрос може вече да има отговор $param1';
  }

  @override
  String get inTheFAQ => 'в Ч.З.В.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'За да докладвате потребител за нечестна игра или лошо поведение, $param1';
  }

  @override
  String get useTheReportForm => 'използвайте формуляра за докладване';

  @override
  String toRequestSupport(String param1) {
    return 'За да поискате помощ, $param1';
  }

  @override
  String get tryTheContactPage => 'опитайте страницата за контакти';

  @override
  String makeSureToRead(String param1) {
    return 'Моля прочетете $param1';
  }

  @override
  String get theForumEtiquette => 'правилата за етикет на форума';

  @override
  String get thisTopicIsArchived => 'Тази тема е архивирана и не може да получава повече мнения.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Присъединете се към $param1, за да публикувате в този форум';
  }

  @override
  String teamNamedX(String param1) {
    return 'отбора $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Все още не можете да публикувате във форумите. Изиграйте няколко игри!';

  @override
  String get subscribe => 'Абонирай се';

  @override
  String get unsubscribe => 'Отпиши ме';

  @override
  String mentionedYouInX(String param1) {
    return 'Ви спомена в \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 Ви спомена в \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'Ви покани на \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 Ви покани на \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Сега сте в отбора.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Присъединихте се към \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Някого когото сте докладвали беше блокиран';

  @override
  String get congratsYouWon => 'Поздравления, спечелихте!';

  @override
  String gameVsX(String param1) {
    return 'Партия срещу $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 срещу $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Изгубили сте партия срещу някой който е нарушил правилата за ползване на Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Възстановяване: $param1 $param2 точки.';
  }

  @override
  String get timeAlmostUp => 'Времето почти изтече!';

  @override
  String get clickToRevealEmailAddress => '[Щракнете, за да видите имейл адреса]';

  @override
  String get download => 'Изтегли';

  @override
  String get coachManager => 'Настройки за треньори';

  @override
  String get streamerManager => 'Настройки за стриймъри';

  @override
  String get cancelTournament => 'Отмяна на турнира';

  @override
  String get tournDescription => 'Описание на турнира';

  @override
  String get tournDescriptionHelp => 'Искате да кажете нещо специално на участниците? Моля бъдете кратки. За връзки можете да използвате Markdown: [name](https://url)';

  @override
  String get ratedFormHelp => 'Игрите са с рейтинг и влияят на рейтинга на играчите';

  @override
  String get onlyMembersOfTeam => 'Само членове на отбора';

  @override
  String get noRestriction => 'Без ограничение';

  @override
  String get minimumRatedGames => 'Минимален брой игри с рейтинг';

  @override
  String get minimumRating => 'Минимален рейтинг';

  @override
  String get maximumWeeklyRating => 'Максимален седмичен рейтинг';

  @override
  String positionInputHelp(String param) {
    return 'За започва всяка игра от зададена позиция, въведете валиден FEN код. \nТова работи само за стандартни игри, но не с варианти. Можете да използвате $param за да създадете FEN позиция и след това да копирате кода тук.\nЗа да започват игрите от обичайната позиция, оставете полето празно.';
  }

  @override
  String get cancelSimul => 'Отмени сеанса';

  @override
  String get simulHostcolor => 'Цвят на домакина във всяка игра';

  @override
  String get estimatedStart => 'Очаквано време на започване';

  @override
  String simulFeatured(String param) {
    return 'Показва се на $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Показвайте сеанса си всички на $param. Изключете за частни сеанси.';
  }

  @override
  String get simulDescription => 'Описание на сеанса';

  @override
  String get simulDescriptionHelp => 'Има ли нещо което искате да кажете на участниците?';

  @override
  String markdownAvailable(String param) {
    return '$param е достъпен за разширено форматиране.';
  }

  @override
  String get embedsAvailable => 'Копирайте URL на игра или на глава от проучване за да я включите в страницата.';

  @override
  String get inYourLocalTimezone => 'Във Вашата часова зона';

  @override
  String get tournChat => 'Чат в турнира';

  @override
  String get noChat => 'Без чат';

  @override
  String get onlyTeamLeaders => 'Само организаторите на отбора';

  @override
  String get onlyTeamMembers => 'Само членовете на отбора';

  @override
  String get navigateMoveTree => 'Навигирайте листа на ходовете';

  @override
  String get mouseTricks => 'Миши трик';

  @override
  String get toggleLocalAnalysis => 'Включи/изключи локалния компютърен анализ';

  @override
  String get toggleAllAnalysis => 'Включи/изключи целия компютърен анализ';

  @override
  String get playComputerMove => 'Изиграй най-добрия компютърен ход';

  @override
  String get analysisOptions => 'Параметри на анализа';

  @override
  String get focusChat => 'Фокусирай текста';

  @override
  String get showHelpDialog => 'Показване на този диалогов прозорец за помощ';

  @override
  String get reopenYourAccount => 'Отворете отново акаунта Ви';

  @override
  String get reopenYourAccountDescription => 'If you closed your account, but have since changed your mind, you get a chance of getting your account back.';

  @override
  String get emailAssociatedToaccount => 'Имейл адресът асоцииран с този акаунт';

  @override
  String get sentEmailWithLink => 'Изпратихме Ви имейл с линк.';

  @override
  String get tournamentEntryCode => 'Код за участие в турнира';

  @override
  String get hangOn => 'Внимание!';

  @override
  String gameInProgress(String param) {
    return 'Имате текуща игра с $param.';
  }

  @override
  String get abortTheGame => 'Прекъсване на играта';

  @override
  String get resignTheGame => 'Предаване';

  @override
  String get youCantStartNewGame => 'Не можете да започнете нова игра преди тази да е приключила.';

  @override
  String get since => 'От';

  @override
  String get until => 'До';

  @override
  String get lichessDbExplanation => 'Игри с рейтинг измежду всички Lichess играчи';

  @override
  String get switchSides => 'Смени страната';

  @override
  String get closingAccountWithdrawAppeal => 'Закриването на регистрацията Ви ще оттегли Вашето обжалване';

  @override
  String get ourEventTips => 'Нашите съвети за организиране на събития';

  @override
  String get instructions => 'Инструкции';

  @override
  String get showMeEverything => 'Покажи ми всичко';

  @override
  String get lichessPatronInfo => 'Lichess е благотворителна организация и работи с напълно безплатен софтуер и отворен код. Всички разходи за опериране, разработка и съдържание са финансирани единствено от дарения от потребителите ни.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String get stats => 'Статистика';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Опонентът напусна играта. Можете да заявите победа след $count секунди.',
      one: 'Противникът напусна играта. Можете да заявите победа след $count секунди.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мат в $count полухода',
      one: 'Мат в $count полуход',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count груби грешки',
      one: '$count груба грешка',
    );
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Груби грешки',
      one: '$count Груба грешка',
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
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Грешки',
      one: '$count Грешка',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count неточности',
      one: '$count неточност',
    );
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Неточности',
      one: '$count Неточност',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играчи',
      one: '$count играч',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Партии',
      one: '$count Партия',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рейтинг базирано на $param2 игри',
      one: '$count рейтинг базирано на $param2 игра',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Отбелязани',
      one: '$count Отбелязани',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дни',
      one: '$count ден',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа',
      one: '$count час',
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
      other: 'Класирането се обновява на всеки $count минути',
      one: 'Класирането се обновява всяка минута',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пъзели',
      one: '$count задача',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игри с вас',
      one: '$count игри с вас',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count оценени',
      one: '$count оценена',
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
      other: '$count загуби',
      one: '$count загуби',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count равенства',
      one: '$count равенства',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count текущи',
      one: '$count текуща',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Дай $count sec',
      one: 'Дай $count sec',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count точки от турнира',
      one: '$count точка от турнира',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count казуси',
      one: '$count казус',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сеанса',
      one: '$count сеанс',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count оценени игри',
      one: '≥ $count оценена игра',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 оценени игри',
      one: '≥ $count $param2 оценена игра',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Трябва да изиграете още $count оценени $param2 игри',
      one: 'Трябва да изиграете още $count оценена $param2 игра',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Трябва да изиграете още $count оценени игри',
      one: 'Трябва да изиграете още $count оценена игра',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Добавени игри',
      one: '$count Добавени игри',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count приятели онлайн',
      one: '$count приятел онлайн',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count последователи',
      one: '$count последователи',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count следва',
      one: '$count следва',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'По-малко от $count минути',
      one: 'По-малко от $count минута',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игри в ход',
      one: '$count игра в ход',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Max: $count знака.',
      one: 'Max: $count знака.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count блокирани играчи',
      one: '$count блокирани играчи',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Съобщения във форума',
      one: '$count Съобщения във форума',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 играчи тази седмица.',
      one: '$count $param2 играч тази седмица.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Преведена на $count езика!',
      one: 'Преведена на $count езика!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунди за първия ход',
      one: '$count секунда за първия ход',
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
      other: 'и запиши $count като предварителен ход',
      one: 'и запиши $count като предварителен ход',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Направете ход, за да започнете';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Играете с белите фигури във всички задачи';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Играете с черните фигури във всички задачи';

  @override
  String get stormPuzzlesSolved => 'решени пъзели';

  @override
  String get stormNewDailyHighscore => 'Нов дневен рекорд!';

  @override
  String get stormNewWeeklyHighscore => 'Нов седмичен рекорд!';

  @override
  String get stormNewMonthlyHighscore => 'Нов месечен рекорд!';

  @override
  String get stormNewAllTimeHighscore => 'Нов рекорд за всички времена!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Предишният рекорд беше $param';
  }

  @override
  String get stormPlayAgain => 'Играйте отново';

  @override
  String stormHighscoreX(String param) {
    return 'Рекорд: $param';
  }

  @override
  String get stormScore => 'Резултат';

  @override
  String get stormMoves => 'Ходове';

  @override
  String get stormAccuracy => 'Точност';

  @override
  String get stormCombo => 'Комбо';

  @override
  String get stormTime => 'Време';

  @override
  String get stormTimePerMove => 'Време на ход';

  @override
  String get stormHighestSolved => 'Най-сложната решена';

  @override
  String get stormPuzzlesPlayed => 'Изиграни задачи';

  @override
  String get stormNewRun => 'Нов опит (натисни: Интервал)';

  @override
  String get stormEndRun => 'Приключване на опита (натисни: Enter)';

  @override
  String get stormHighscores => 'Рекорди';

  @override
  String get stormViewBestRuns => 'Вижте най-добрите опити';

  @override
  String get stormBestRunOfDay => 'Най-добрият опит за деня';

  @override
  String get stormRuns => 'Опити';

  @override
  String get stormGetReady => 'Пригответе се!';

  @override
  String get stormWaitingForMorePlayers => 'Изчакване на още играчи...';

  @override
  String get stormRaceComplete => 'Надпреварата приключи!';

  @override
  String get stormSpectating => 'Наблюдаване';

  @override
  String get stormJoinTheRace => 'Влезте в надпреварата!';

  @override
  String get stormStartTheRace => 'Започни надпреварата';

  @override
  String stormYourRankX(String param) {
    return 'Вашето класиране: $param';
  }

  @override
  String get stormWaitForRematch => 'Изчакайте за реванш';

  @override
  String get stormNextRace => 'Следваща надпревара';

  @override
  String get stormJoinRematch => 'Започнете реванша';

  @override
  String get stormWaitingToStart => 'Изчакване на започването';

  @override
  String get stormCreateNewGame => 'Създайте нова игра';

  @override
  String get stormJoinPublicRace => 'Участвайте в публична надпревара';

  @override
  String get stormRaceYourFriends => 'Състезавайте се с приятели';

  @override
  String get stormSkip => 'пропусни';

  @override
  String get stormSkipHelp => 'Можете да пропуснете един ход на състезание:';

  @override
  String get stormSkipExplanation => 'Пропуснете този ход за да запазите комбинацията си! Можете да го направите само веднъж на състезание.';

  @override
  String get stormFailedPuzzles => 'Сгрешени задачи';

  @override
  String get stormSlowPuzzles => 'Бавни задачи';

  @override
  String get stormSkippedPuzzle => 'Пропусната задача';

  @override
  String get stormThisWeek => 'Тази седмица';

  @override
  String get stormThisMonth => 'Този месец';

  @override
  String get stormAllTime => 'За всички времена';

  @override
  String get stormClickToReload => 'Натиснете за да презаредите';

  @override
  String get stormThisRunHasExpired => 'Времето за този опит изтече!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Този опит беше отворен в друг таб!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count опита',
      one: '1 опит',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изиграни $count опита от $param2',
      one: 'Изигран един опит от $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess стриймъри';

  @override
  String get studyPrivate => 'Лични';

  @override
  String get studyMyStudies => 'Моите казуси';

  @override
  String get studyStudiesIContributeTo => 'Казуси, към които допринасям';

  @override
  String get studyMyPublicStudies => 'Моите публични казуси';

  @override
  String get studyMyPrivateStudies => 'Моите лични казуси';

  @override
  String get studyMyFavoriteStudies => 'Моите любими казуси';

  @override
  String get studyWhatAreStudies => 'Какво представляват казусите?';

  @override
  String get studyAllStudies => 'Всички казуси';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Казуси от $param';
  }

  @override
  String get studyNoneYet => 'Все още няма.';

  @override
  String get studyHot => 'Популярни';

  @override
  String get studyDateAddedNewest => 'Дата на добавяне (най-нови)';

  @override
  String get studyDateAddedOldest => 'Дата на добавяне (най-стари)';

  @override
  String get studyRecentlyUpdated => 'Скоро обновени';

  @override
  String get studyMostPopular => 'Най-популярни';

  @override
  String get studyAlphabetical => 'Азбучно';

  @override
  String get studyAddNewChapter => 'Добавяне на нов раздел';

  @override
  String get studyAddMembers => 'Добави членове';

  @override
  String get studyInviteToTheStudy => 'Покани към казуса';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Моля канете само хора, които познавате и които биха искали да се присъединят.';

  @override
  String get studySearchByUsername => 'Търсене по потребителско име';

  @override
  String get studySpectator => 'Зрител';

  @override
  String get studyContributor => 'Сътрудник';

  @override
  String get studyKick => 'Изритване';

  @override
  String get studyLeaveTheStudy => 'Напусни казуса';

  @override
  String get studyYouAreNowAContributor => 'Вие сте сътрудник';

  @override
  String get studyYouAreNowASpectator => 'Вие сте зрител';

  @override
  String get studyPgnTags => 'PGN тагове';

  @override
  String get studyLike => 'Харесай';

  @override
  String get studyUnlike => 'Не харесвам';

  @override
  String get studyNewTag => 'Нов таг';

  @override
  String get studyCommentThisPosition => 'Коментирай позицията';

  @override
  String get studyCommentThisMove => 'Коментирай хода';

  @override
  String get studyAnnotateWithGlyphs => 'Анотация със специални символи';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Тази глава е твърде къса и не може да бъде анализирана.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Само сътрудници към казуса могат да пускат компютърен анализ.';

  @override
  String get studyGetAFullComputerAnalysis => 'Вземи пълен сървърен анализ на основна линия.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Уверете се, че главата е завършена. Можете да пуснете анализ само веднъж.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Всички синхронизирани членове остават на същата позиция';

  @override
  String get studyShareChanges => 'Споделете промените със зрителите и ги запазете на сървъра';

  @override
  String get studyPlaying => 'Играе се';

  @override
  String get studyShowResults => 'Results';

  @override
  String get studyShowEvalBar => 'Evaluation bars';

  @override
  String get studyFirst => 'Първа';

  @override
  String get studyPrevious => 'Предишна';

  @override
  String get studyNext => 'Следваща';

  @override
  String get studyLast => 'Последна';

  @override
  String get studyShareAndExport => 'Сподели';

  @override
  String get studyCloneStudy => 'Клонирай';

  @override
  String get studyStudyPgn => 'PGN на казуса';

  @override
  String get studyDownloadAllGames => 'Изтегли всички партии';

  @override
  String get studyChapterPgn => 'PGN на главата';

  @override
  String get studyCopyChapterPgn => 'Копирай PGN';

  @override
  String get studyDownloadGame => 'Изтегли партия';

  @override
  String get studyStudyUrl => 'URL на казуса';

  @override
  String get studyCurrentChapterUrl => 'URL на настоящата глава';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Можете да поставите това във форум и ще бъде вградено';

  @override
  String get studyStartAtInitialPosition => 'Започни от начална позиция';

  @override
  String studyStartAtX(String param) {
    return 'Започни от $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Вгради в твоя сайт или блог';

  @override
  String get studyReadMoreAboutEmbedding => 'Прочети повече за вграждането';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Само публични казуси могат да бъдат вграждани!';

  @override
  String get studyOpen => 'Отвори';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1, предоставени от $param2';
  }

  @override
  String get studyStudyNotFound => 'Казусът не бе открит';

  @override
  String get studyEditChapter => 'Промени глава';

  @override
  String get studyNewChapter => 'Нова глава';

  @override
  String studyImportFromChapterX(String param) {
    return 'Импортиране от $param';
  }

  @override
  String get studyOrientation => 'Ориентация';

  @override
  String get studyAnalysisMode => 'Режим на анализ';

  @override
  String get studyPinnedChapterComment => 'Коментар на главата';

  @override
  String get studySaveChapter => 'Запази глава';

  @override
  String get studyClearAnnotations => 'Изтрий анотациите';

  @override
  String get studyClearVariations => 'Изчисти вариациите';

  @override
  String get studyDeleteChapter => 'Изтрий глава';

  @override
  String get studyDeleteThisChapter => 'Изтриване на главата? Това е необратимо!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Изтрий всички коментари, специални символи и нарисувани форми в главата?';

  @override
  String get studyRightUnderTheBoard => 'Точно под дъската';

  @override
  String get studyNoPinnedComment => 'Никакви';

  @override
  String get studyNormalAnalysis => 'Нормален анализ';

  @override
  String get studyHideNextMoves => 'Скриване на следващите ходове';

  @override
  String get studyInteractiveLesson => 'Интерактивен урок';

  @override
  String studyChapterX(String param) {
    return 'Глава: $param';
  }

  @override
  String get studyEmpty => 'Празна';

  @override
  String get studyStartFromInitialPosition => 'Започни от начална позиция';

  @override
  String get studyEditor => 'Редактор';

  @override
  String get studyStartFromCustomPosition => 'Започни от избрана позиция';

  @override
  String get studyLoadAGameByUrl => 'Зареди партии от URL';

  @override
  String get studyLoadAPositionFromFen => 'Зареди позиция от FEN';

  @override
  String get studyLoadAGameFromPgn => 'Зареди партии от PGN';

  @override
  String get studyAutomatic => 'Автоматичен';

  @override
  String get studyUrlOfTheGame => 'URL на партиите, по една на линия';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Зареди партии от $param1 или $param2';
  }

  @override
  String get studyCreateChapter => 'Създай';

  @override
  String get studyCreateStudy => 'Създай казус';

  @override
  String get studyEditStudy => 'Редактирай казус';

  @override
  String get studyVisibility => 'Видимост';

  @override
  String get studyPublic => 'Публични';

  @override
  String get studyUnlisted => 'Несподелени';

  @override
  String get studyInviteOnly => 'Само с покани';

  @override
  String get studyAllowCloning => 'Позволи клониране';

  @override
  String get studyNobody => 'Никой';

  @override
  String get studyOnlyMe => 'Само за мен';

  @override
  String get studyContributors => 'Сътрудници';

  @override
  String get studyMembers => 'Членове';

  @override
  String get studyEveryone => 'Всички';

  @override
  String get studyEnableSync => 'Разреши синхронизиране';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Да: дръж всички на същата позиция';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Не: позволи свободно разглеждане';

  @override
  String get studyPinnedStudyComment => 'Коментар на казуса';

  @override
  String get studyStart => 'Начало';

  @override
  String get studySave => 'Запази';

  @override
  String get studyClearChat => 'Изтрий чат съобщенията';

  @override
  String get studyDeleteTheStudyChatHistory => 'Изтриване на чат историята? Това е необратимо!';

  @override
  String get studyDeleteStudy => 'Изтрий казуса';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Изтриване на целия казус? Това е необратимо! Въведете името на казуса за да потвърдите: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Къде да бъде проучено това?';

  @override
  String get studyGoodMove => 'Добър ход';

  @override
  String get studyMistake => 'Грешка';

  @override
  String get studyBrilliantMove => 'Отличен ход';

  @override
  String get studyBlunder => 'Груба грешка';

  @override
  String get studyInterestingMove => 'Интересен ход';

  @override
  String get studyDubiousMove => 'Съмнителен ход';

  @override
  String get studyOnlyMove => 'Единствен ход';

  @override
  String get studyZugzwang => 'Цугцванг';

  @override
  String get studyEqualPosition => 'Равна позиция';

  @override
  String get studyUnclearPosition => 'Неясна позиция';

  @override
  String get studyWhiteIsSlightlyBetter => 'Белите са малко по-добре';

  @override
  String get studyBlackIsSlightlyBetter => 'Черните са малко по-добре';

  @override
  String get studyWhiteIsBetter => 'Белите са по-добре';

  @override
  String get studyBlackIsBetter => 'Черните са по-добре';

  @override
  String get studyWhiteIsWinning => 'Белите печелят';

  @override
  String get studyBlackIsWinning => 'Черните печелят';

  @override
  String get studyNovelty => 'Нововъведeние';

  @override
  String get studyDevelopment => 'Развитие';

  @override
  String get studyInitiative => 'Инициатива';

  @override
  String get studyAttack => 'Атака';

  @override
  String get studyCounterplay => 'Контра атака';

  @override
  String get studyTimeTrouble => 'Проблем с времето';

  @override
  String get studyWithCompensation => 'С компенсация';

  @override
  String get studyWithTheIdea => 'С идеята';

  @override
  String get studyNextChapter => 'Следваща глава';

  @override
  String get studyPrevChapter => 'Предишна глава';

  @override
  String get studyStudyActions => 'Опции за учене';

  @override
  String get studyTopics => 'Теми';

  @override
  String get studyMyTopics => 'Моите теми';

  @override
  String get studyPopularTopics => 'Популярни теми';

  @override
  String get studyManageTopics => 'Управление на темите';

  @override
  String get studyBack => 'Обратно';

  @override
  String get studyPlayAgain => 'Играйте отново';

  @override
  String get studyWhatWouldYouPlay => 'Какво бихте играли в тази позиция?';

  @override
  String get studyYouCompletedThisLesson => 'Поздравления! Вие завършихте този урок.';

  @override
  String studyPerPage(String param) {
    return '$param на страница';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Глави',
      one: '$count Глава',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Игри',
      one: '$count Игра',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Членове',
      one: '$count Член',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Постави твоя PGN текст тук, до $count партии',
      one: 'Постави твоя PGN текст тук, до $count партия',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'току що';

  @override
  String get timeagoRightNow => 'точно сега';

  @override
  String get timeagoCompleted => 'завършено';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'след $count секунди',
      one: 'след $count секунда',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'след $count минути',
      one: 'след $count минута',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'след $count часа',
      one: 'след $count час',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'след $count дни',
      one: 'след $count ден',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'след $count седмици',
      one: 'след $count седмица',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'след $count месеца',
      one: 'след $count месец',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'след $count години',
      one: 'след $count година',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'преди $count минути',
      one: 'преди $count минута',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Преди $count часа',
      one: 'преди $count час',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Преди $count дни',
      one: 'преди $count ден',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'преди $count седмици',
      one: 'преди $count седмица',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'преди $count месеца',
      one: 'преди $count месец',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'преди $count години',
      one: 'преди $count година',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'остават $count минути',
      one: 'остава $count минутa',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'остават $count часа',
      one: 'остава $count час',
    );
    return '$_temp0';
  }
}
