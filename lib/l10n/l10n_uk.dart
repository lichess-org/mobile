// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get mobileAllGames => 'Усі ігри';

  @override
  String get mobileAreYouSure => 'Ви впевнені?';

  @override
  String get mobileCancelTakebackOffer => 'Скасувати пропозицію повернення ходу';

  @override
  String get mobileClearButton => 'Очистити';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Очистити збережений хід';

  @override
  String get mobileCustomGameJoinAGame => 'Приєднатися до гри';

  @override
  String get mobileFeedbackButton => 'Відгук';

  @override
  String mobileGoodEvening(String param) {
    return 'Good evening, $param';
  }

  @override
  String get mobileGoodEveningWithoutName => 'Good evening';

  @override
  String mobileGoodDay(String param) {
    return 'Good day, $param';
  }

  @override
  String get mobileGoodDayWithoutName => 'Good day';

  @override
  String get mobileHideVariation => 'Сховати варіанти';

  @override
  String get mobileHomeTab => 'Головна';

  @override
  String get mobileLiveStreamers => 'Стримери в прямому етері';

  @override
  String get mobileMustBeLoggedIn => 'Ви повинні ввійти, аби переглянути цю сторінку.';

  @override
  String get mobileNoSearchResults => 'Немає результатів ';

  @override
  String get mobileNotFollowingAnyUser => 'Ви ні на кого не підписані.';

  @override
  String get mobileOkButton => 'Гаразд';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Гравці з «$param»';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Збільшувати розмір фігури при перетягуванні';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Ви хочете закінчити цю серію?';

  @override
  String get mobilePuzzleStormFilterNothingToShow =>
      'Нічого не знайдено, будь ласка, змініть фільтри';

  @override
  String get mobilePuzzleStormNothingToShow => 'Нічого показати. Зіграйте в гру Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Розв\'яжіть якомога більше задач за 3 хвилини.';

  @override
  String get mobilePuzzleStreakAbortWarning =>
      'Ви втратите поточну серію, і ваш рахунок буде збережено.';

  @override
  String get mobilePuzzleThemesSubtitle =>
      'Розв\'язуйте задачі з улюбленими дебютами або обирайте тему.';

  @override
  String get mobilePuzzlesTab => 'Задачі';

  @override
  String get mobileRecentSearches => 'Недавні пошуки';

  @override
  String get mobileRemoveBookmark => 'Remove bookmark';

  @override
  String get mobileSettingsImmersiveMode => 'Повноекранний режим';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and puzzle screens.';

  @override
  String get mobileSettingsTab => 'Налашт.';

  @override
  String get mobileShareGamePGN => 'Поділитися PGN';

  @override
  String get mobileShareGameURL => 'Поділитися посиланням на гру';

  @override
  String get mobileSharePositionAsFEN => 'Поділитися FEN';

  @override
  String get mobileSharePuzzle => 'Поділитися задачею';

  @override
  String get mobileShowComments => 'Показати коментарі';

  @override
  String get mobileShowResult => 'Показати результат';

  @override
  String get mobileShowVariations => 'Показати варіанти';

  @override
  String get mobileSomethingWentWrong => 'Щось пішло не так.';

  @override
  String get mobileSystemColors => 'Системні кольори';

  @override
  String get mobileTheme => 'Тема';

  @override
  String get mobileToolsTab => 'Засоби';

  @override
  String get mobileWaitingForOpponentToJoin => 'Очікування на суперника...';

  @override
  String get mobileWatchTab => 'Дивитися';

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
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зіграно $count $param2 заочних ігор',
      many: 'Зіграно $count $param2 заочних ігор',
      few: 'Зіграно $count $param2 заочні гри',
      one: 'Зіграно $count $param2 заочну гру',
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
  String get arenaArena => 'Арена';

  @override
  String get arenaArenaTournaments => 'Турніри Арена';

  @override
  String get arenaIsItRated => 'Він рейтинговий?';

  @override
  String get arenaWillBeNotified =>
      'Вас повідомлять про початок турніру, тому поки що можете пограти, відкривши іншу вкладку.';

  @override
  String get arenaIsRated => 'Цей турнір рейтинговий та вплине на ваш рейтинг.';

  @override
  String get arenaIsNotRated => 'Цей турнір *не є* рейтинговим та *не* вплине на ваш рейтинг.';

  @override
  String get arenaSomeRated => 'Деякі турніри рейтингові та впливають на ваш рейтинг.';

  @override
  String get arenaHowAreScoresCalculated => 'Як обчислюються очки?';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      'Перемога приносить 2 очки, нічия 1 очко, а програш не принесе очок. Якщо ви виграєте 2 гри поспіль, активується подвоєння очок, що зображено значком полум\'я.\nНаступні ігри приноситимуть подвоєні очки, поки триває виграшна серія.\nТобто, перемога принесе 4 очки, нічия 2 очки, а поразка не принесе жодного очка.\n\nНаприклад, дві перемоги з подальшою нічиєю принесуть 6 очок: 2 + 2 + (2 х 1)';

  @override
  String get arenaBerserk => 'Арена Берсерк';

  @override
  String get arenaBerserkAnswer =>
      'Коли гравець натискає кнопку Берсерк на початку гри, він втрачає половину часу, але перемога принесе додаткове очко турніру. \n\nВикористання Берсерку в контролі часу з приростом часу відміняє приріст (1+2 є винятком, дається 1+0)\n\nБерсерк недоступний для ігор без початкового часу (0+1, 0+2).\n\nБерсерк дає додаткове очко лише за умови, що у цій грі ви зробили хоча б 7 ходів.';

  @override
  String get arenaHowIsTheWinnerDecided => 'Як визначається переможець?';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      'Гравець(ці) з найбільшою кількістю очків по закінченню часу турніру буде обраний як переможець(ці).\nЯкщо двоє або більше гравців набрали однакову кількість очок, переможець буде визначений за допомогою турнірного перфомансу.';

  @override
  String get arenaHowDoesPairingWork => 'Як працює підбір?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      'На початку турніру пари гравців обираються за їх рейтингом. По завершенню гри ви повертаєтесь на сторінку турніру, тоді для вас буде обрано гравця, найближчого до вас за очками. Це гарантує мінімальний час очікування, однак ви можете не зустрітися з усіма гравцями в турнірі.\nГрайте швидко і повертайтесь на сторінку турніру, щоб грати більше ігор і вигравати більше очок.';

  @override
  String get arenaHowDoesItEnd => 'Як завершується турнір?';

  @override
  String get arenaHowDoesItEndAnswer =>
      'Турнір має таймер зворотнього відліку. Коли він досягає нуля, позиції в турнірі фіксуються та оголошується переможець. Ігри, які ще тривають, мають завершитися, хоча вони не зарахуються.';

  @override
  String get arenaOtherRules => 'Інші важливі правила';

  @override
  String get arenaThereIsACountdown =>
      'Існує зворотний відлік для вашого першого ходу. Якщо ви не зробите хід протягом цього часу, то ви програєте.';

  @override
  String get arenaThisIsPrivate => 'Це приватний турнір';

  @override
  String arenaShareUrl(String param) {
    return 'Поділіться цим посиланням, щоб запросити гравців приєднатися: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return 'Серія нічиїх: Якщо гравець має послідовні нічиї на арені, то одне очко зарахується лише за першу нічию, або нічию, яка триватиме більше ніж $param ходів. Серію нічиїх можна перервати лише перемогою, але не програшем чи нічиєю.';
  }

  @override
  String get arenaDrawStreakVariants =>
      'Мінімальна тривалість партії для нічиєї та отримання балів залежить від варіанту. Таблиця нижче містить поріг для кожного варіанту.';

  @override
  String get arenaVariant => 'Варіант';

  @override
  String get arenaMinimumGameLength => 'Мінімальна тривалість гри';

  @override
  String get arenaHistory => 'Історія Арени';

  @override
  String get arenaNewTeamBattle => 'Нова Командна битва';

  @override
  String get arenaCustomStartDate => 'Власна дата початку';

  @override
  String get arenaCustomStartDateHelp =>
      'У вашому локальному часовому поясі. Це замінює налаштування \"Час до початку турніру\"';

  @override
  String get arenaAllowBerserk => 'Дозволити Берсерк';

  @override
  String get arenaAllowBerserkHelp =>
      'Дозволити гравцям зменшити наполовину свій час, щоб отримати додаткове очко';

  @override
  String get arenaAllowChatHelp => 'Дозволити гравцям обговорення в чаті';

  @override
  String get arenaArenaStreaks => 'Серії Арени';

  @override
  String get arenaArenaStreaksHelp =>
      'Після двох перемог, кожна наступна перемога принесе 4 бали замість 2.';

  @override
  String get arenaNoBerserkAllowed => 'Берсерк не дозволений';

  @override
  String get arenaNoArenaStreaks => 'Немає серій Арени';

  @override
  String get arenaAveragePerformance => 'Середня продуктивність';

  @override
  String get arenaAverageScore => 'Середній результат';

  @override
  String get arenaMyTournaments => 'Мої турніри';

  @override
  String get arenaEditTournament => 'Редагувати турнір';

  @override
  String get arenaEditTeamBattle => 'Редагувати командну битву';

  @override
  String get arenaDefender => 'Захисник';

  @override
  String get arenaPickYourTeam => 'Оберіть команду';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle =>
      'Яку команду ви представлятимете в цій битві?';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate =>
      'Ви повинні приєднатися до однієї з цих команд, щоб взяти участь!';

  @override
  String get arenaCreated => 'Створено';

  @override
  String get arenaRecentlyPlayed => 'Нещодавно зіграні';

  @override
  String get arenaBestResults => 'Найкращі результати';

  @override
  String get arenaTournamentStats => 'Показники турніру';

  @override
  String get arenaRankAvgHelp =>
      'Середній ранг - відсоток від вашого рейтингу. Нижчий - краще.\n\nНаприклад, посідаючи 3 місце на турнірі з 100 гравців = 3%. Маючи 10 місце в турнірі 1000 гравців = 1%.';

  @override
  String get arenaMedians => 'медіани';

  @override
  String arenaAllAveragesAreX(String param) {
    return 'Усі середні значення на цій сторінці є $param.';
  }

  @override
  String get arenaTotal => 'Загальні';

  @override
  String get arenaPointsAvg => 'Середні значення очків';

  @override
  String get arenaPointsSum => 'Сума очок';

  @override
  String get arenaRankAvg => 'Середнє місце';

  @override
  String get arenaTournamentWinners => 'Переможці турніру';

  @override
  String get arenaTournamentShields => 'Турнірні щити';

  @override
  String get arenaOnlyTitled => 'Тільки титуловані гравці';

  @override
  String get arenaOnlyTitledHelp => 'Необхідний офіційний титул, щоб приєднатися до турніру';

  @override
  String get arenaTournamentPairingsAreNowClosed => 'Формування пар у турнірі завершено.';

  @override
  String get arenaBerserkRate => 'Ігор з берсерком';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нічия у грі, що тривала $count ходів, не дасть гравцям жодного очка.',
      many: 'Нічия у грі, що тривала $count ходів, не дасть гравцям жодного очка.',
      few: 'Нічия у грі, що тривала $count ходи, не дасть гравцям жодного очка.',
      one: 'Нічия у грі, що тривала менше $count ходів, не дасть гравцям жодного очка.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Переглянути $count команди',
      many: 'Переглянути $count команд',
      few: 'Переглянути $count команди',
      one: 'Переглянути команду',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Broadcasts';

  @override
  String get broadcastMyBroadcasts => 'My broadcasts';

  @override
  String get broadcastLiveBroadcasts => 'Live tournament broadcasts';

  @override
  String get broadcastBroadcastCalendar => 'Broadcast calendar';

  @override
  String get broadcastNewBroadcast => 'New live broadcast';

  @override
  String get broadcastSubscribedBroadcasts => 'Subscribed broadcasts';

  @override
  String get broadcastAboutBroadcasts => 'About broadcasts';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'How to use Lichess Broadcasts.';

  @override
  String get broadcastTheNewRoundHelp =>
      'The new round will have the same members and contributors as the previous one.';

  @override
  String get broadcastAddRound => 'Add a round';

  @override
  String get broadcastOngoing => 'Ongoing';

  @override
  String get broadcastUpcoming => 'Upcoming';

  @override
  String get broadcastRoundName => 'Round name';

  @override
  String get broadcastRoundNumber => 'Round number';

  @override
  String get broadcastTournamentName => 'Tournament name';

  @override
  String get broadcastTournamentDescription => 'Short tournament description';

  @override
  String get broadcastFullDescription => 'Full tournament description';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Optional long description of the tournament. $param1 is available. Length must be less than $param2 characters.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Source URL';

  @override
  String get broadcastSourceUrlHelp =>
      'URL that Lichess will check to get PGN updates. It must be publicly accessible from the Internet.';

  @override
  String get broadcastSourceGameIds => 'Up to 64 Lichess game IDs, separated by spaces.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Start date in the tournament local timezone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Optional, if you know when the event starts';

  @override
  String get broadcastCurrentGameUrl => 'Current game URL';

  @override
  String get broadcastDownloadAllRounds => 'Download all rounds';

  @override
  String get broadcastResetRound => 'Reset this round';

  @override
  String get broadcastDeleteRound => 'Delete this round';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Definitively delete the round and all its games.';

  @override
  String get broadcastDeleteAllGamesOfThisRound =>
      'Delete all games of this round. The source will need to be active in order to re-create them.';

  @override
  String get broadcastEditRoundStudy => 'Edit round study';

  @override
  String get broadcastDeleteTournament => 'Delete this tournament';

  @override
  String get broadcastDefinitivelyDeleteTournament =>
      'Definitively delete the entire tournament, all its rounds and all its games.';

  @override
  String get broadcastShowScores => 'Show players scores based on game results';

  @override
  String get broadcastReplacePlayerTags => 'Optional: replace player names, ratings and titles';

  @override
  String get broadcastFideFederations => 'FIDE federations';

  @override
  String get broadcastTop10Rating => 'Top 10 rating';

  @override
  String get broadcastFidePlayers => 'FIDE players';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE player not found';

  @override
  String get broadcastFideProfile => 'FIDE profile';

  @override
  String get broadcastFederation => 'Federation';

  @override
  String get broadcastAgeThisYear => 'Age this year';

  @override
  String get broadcastUnrated => 'Unrated';

  @override
  String get broadcastRecentTournaments => 'Recent tournaments';

  @override
  String get broadcastOpenLichess => 'Open in Lichess';

  @override
  String get broadcastTeams => 'Teams';

  @override
  String get broadcastBoards => 'Boards';

  @override
  String get broadcastOverview => 'Overview';

  @override
  String get broadcastSubscribeTitle =>
      'Subscribe to be notified when each round starts. You can toggle bell or push notifications for broadcasts in your account preferences.';

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
    return 'Starts after $param';
  }

  @override
  String get broadcastStartVerySoon => 'The broadcast will start very soon.';

  @override
  String get broadcastNotYetStarted => 'The broadcast has not yet started.';

  @override
  String get broadcastOfficialWebsite => 'Official website';

  @override
  String get broadcastStandings => 'Standings';

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
  String get broadcastGamesThisTournament => 'Games in this tournament';

  @override
  String get broadcastScore => 'Score';

  @override
  String get broadcastAllTeams => 'All teams';

  @override
  String get broadcastTournamentFormat => 'Tournament format';

  @override
  String get broadcastTournamentLocation => 'Tournament Location';

  @override
  String get broadcastTopPlayers => 'Top players';

  @override
  String get broadcastTimezone => 'Time zone';

  @override
  String get broadcastFideRatingCategory => 'FIDE rating category';

  @override
  String get broadcastOptionalDetails => 'Optional details';

  @override
  String get broadcastPastBroadcasts => 'Past broadcasts';

  @override
  String get broadcastAllBroadcastsByMonth => 'View all broadcasts by month';

  @override
  String get broadcastBackToLiveMove => 'Back to live move';

  @override
  String get broadcastSinceHideResults =>
      'Since you chose to hide the results, all the preview boards are empty to avoid spoilers.';

  @override
  String get broadcastLiveboard => 'Live board';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count broadcasts',
      one: '$count broadcast',
    );
    return '$_temp0';
  }

  @override
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viewers',
      one: '$count viewer',
    );
    return '$_temp0';
  }

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
  String get challengeRegisterToSendChallenges =>
      'Зареєструйтесь, щоб викликати суперників на гру.';

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
  String get challengeDeclineLater =>
      'Зараз не найкращий час для мене, будь ласка, напишіть пізніше.';

  @override
  String get challengeDeclineTooFast =>
      'Цей контроль часу занадто швидкий для мене, будь ласка, киньте виклик з більш повільною грою.';

  @override
  String get challengeDeclineTooSlow =>
      'Цей контроль часу занадто повільний для мене, будь ласка, киньте виклик з більш швидкою грою.';

  @override
  String get challengeDeclineTimeControl => 'Я не приймаю виклики з таким контролем часу.';

  @override
  String get challengeDeclineRated =>
      'Будь ласка, замість цього відправте мені рейтинговий виклик.';

  @override
  String get challengeDeclineCasual =>
      'Будь ласка, замість цього відправте мені товариський виклик.';

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
  String get coordinatesCoordinates => 'Координати';

  @override
  String get coordinatesCoordinateTraining => 'Координатне тренування';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return 'Середній результат за білих: $param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return 'Середній результат за чорних: $param';
  }

  @override
  String get coordinatesKnowingTheChessBoard =>
      'Знання координат шахівниці - дуже важлива шахова навичка:';

  @override
  String get coordinatesMostChessCourses =>
      'У більшості шахових задач активно використовуються шахова нотація.';

  @override
  String get coordinatesTalkToYourChessFriends =>
      'Це спрощує розмову з друзями-шахістами, бо Ви обидва розумієте «мову шахів».';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively =>
      'Ви можете більш ефективно аналізувати ігри, якщо вам не потрібно шукати координати.';

  @override
  String get coordinatesACoordinateAppears =>
      'Координата з\'являється на дошці, ви повинні натиснути на відповідний квадрат.';

  @override
  String get coordinatesASquareIsHighlightedExplanation =>
      'Квадрат виділяється на дошці, і ви повинні ввести його координати (наприклад, \"e4\").';

  @override
  String get coordinatesYouHaveThirtySeconds =>
      'Ви маєте 30 секунд для того, щоб відмітити якнайбільше полів!';

  @override
  String get coordinatesGoAsLongAsYouWant =>
      'Витрачайте стільки часу, скільки забажаєте - жодних лімітів!';

  @override
  String get coordinatesShowCoordinates => 'Відображати координати';

  @override
  String get coordinatesShowCoordsOnAllSquares => 'Координати на кожному полі';

  @override
  String get coordinatesShowPieces => 'Показувати фігури';

  @override
  String get coordinatesStartTraining => 'Розпочати тренування';

  @override
  String get coordinatesFindSquare => 'Знайти поле';

  @override
  String get coordinatesNameSquare => 'Назва поля';

  @override
  String get coordinatesPracticeOnlySomeFilesAndRanks => 'Практикувати лише деякі ряди та стовпці';

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
  String get perfStatNotEnoughRatedGames =>
      'Зіграно недостатньо рейтингових ігор для встановлення точного рейтингу.';

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
  String get preferencesPieceDestinations =>
      'Поля для ходів (можливі ходи та ходи на випередження)';

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
  String get preferencesExplainShowPlayerRatings =>
      'Дає змогу приховувати всі рейтинги з сайту, щоб допомогти зосередитись на шахах. Ігри все ще рейтингові, це лише для відображення.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Показати інструмент для зміни розміру дошки';

  @override
  String get preferencesOnlyOnInitialPosition => 'Лише в початковій позиції';

  @override
  String get preferencesInGameOnly => 'Лише під час гри';

  @override
  String get preferencesExceptInGame => 'Окрім під час гри';

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
  String get preferencesPremovesPlayingDuringOpponentTurn =>
      'Ходи на випередження (коли хід суперника)';

  @override
  String get preferencesTakebacksWithOpponentApproval =>
      'Можливість переходити (за згоди суперника)';

  @override
  String get preferencesInCasualGamesOnly => 'Тільки у товариських іграх';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Перетворення пішака завжди на ферзя';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      'Утримуйте клавішу <ctrl> під час перетворення, щоб тимчасово вимкнути автоматичне перетворення';

  @override
  String get preferencesWhenPremoving => 'Для ходів на випередження';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically =>
      'Автоматично оголошувати нічию при троєкратному повторенні ходів';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds =>
      'Коли часу залишається < 30 секунд';

  @override
  String get preferencesMoveConfirmation => 'Підтвердження ходу';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled =>
      'Можна вимкнути під час гри в меню дошки';

  @override
  String get preferencesInCorrespondenceGames => 'У заочних партіях';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Заочні та необмежені';

  @override
  String get preferencesConfirmResignationAndDrawOffers =>
      'Підтверджувати повернення ходу та пропозиції нічий';

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
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      'Писати в чат \"Хороша гра, добре зіграно\" після поразки або нічиєї';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Ваші налаштування збережено.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves =>
      'Прокрутіть колесом миші на дошці, для того щоб відтворити ходи';

  @override
  String get preferencesCorrespondenceEmailNotification =>
      'Щоденне сповіщення на електронну пошту зі списком ваших заочних ігор';

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
  String get preferencesBlindfold => 'Наосліп';

  @override
  String get puzzlePuzzles => 'Puzzles';

  @override
  String get puzzlePuzzleThemes => 'Puzzle Themes';

  @override
  String get puzzleRecommended => 'Recommended';

  @override
  String get puzzlePhases => 'Phases';

  @override
  String get puzzleMotifs => 'Motifs';

  @override
  String get puzzleAdvanced => 'Advanced';

  @override
  String get puzzleLengths => 'Lengths';

  @override
  String get puzzleMates => 'Mates';

  @override
  String get puzzleGoals => 'Goals';

  @override
  String get puzzleOrigin => 'Origin';

  @override
  String get puzzleSpecialMoves => 'Special moves';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Did you like this puzzle?';

  @override
  String get puzzleVoteToLoadNextOne => 'Vote to load the next one!';

  @override
  String get puzzleUpVote => 'Up vote puzzle';

  @override
  String get puzzleDownVote => 'Down vote puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange =>
      'Your puzzle rating will not change. Note that puzzles are not a competition. Your rating helps selecting the best puzzles for your current skill.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Find the best move for white.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Find the best move for black.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'To get personalized puzzles:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Puzzle $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Puzzle of the day';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Click to solve';

  @override
  String get puzzleGoodMove => 'Good move';

  @override
  String get puzzleBestMove => 'Best move!';

  @override
  String get puzzleKeepGoing => 'Keep going…';

  @override
  String get puzzlePuzzleSuccess => 'Success!';

  @override
  String get puzzlePuzzleComplete => 'Puzzle complete!';

  @override
  String get puzzleByOpenings => 'By openings';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzzles by openings';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Openings you played the most in rated games';

  @override
  String get puzzleUseFindInPage =>
      'Use \"Find in page\" in the browser menu to find your favourite opening!';

  @override
  String get puzzleUseCtrlF => 'Use Ctrl+f to find your favourite opening!';

  @override
  String get puzzleNotTheMove => 'That\'s not the move!';

  @override
  String get puzzleTrySomethingElse => 'Try something else.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'hidden';

  @override
  String puzzleFromGameLink(String param) {
    return 'From game $param';
  }

  @override
  String get puzzleContinueTraining => 'Continue training';

  @override
  String get puzzleDifficultyLevel => 'Difficulty level';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Easier';

  @override
  String get puzzleEasiest => 'Easiest';

  @override
  String get puzzleHarder => 'Harder';

  @override
  String get puzzleHardest => 'Hardest';

  @override
  String get puzzleExample => 'Example';

  @override
  String get puzzleAddAnotherTheme => 'Add another theme';

  @override
  String get puzzleNextPuzzle => 'Next puzzle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Jump to next puzzle immediately';

  @override
  String get puzzlePuzzleDashboard => 'Puzzle Dashboard';

  @override
  String get puzzleImprovementAreas => 'Improvement areas';

  @override
  String get puzzleStrengths => 'Strengths';

  @override
  String get puzzleHistory => 'Puzzle history';

  @override
  String get puzzleSolved => 'solved';

  @override
  String get puzzleFailed => 'incorrect';

  @override
  String get puzzleStreakDescription =>
      'Solve progressively harder puzzles and build a win streak. There is no clock, so take your time. One wrong move, and it\'s game over! But you can skip one move per session.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Your streak: $param';
  }

  @override
  String get puzzleStreakSkipExplanation =>
      'Skip this move to preserve your streak! Only works once per run.';

  @override
  String get puzzleContinueTheStreak => 'Continue the streak';

  @override
  String get puzzleNewStreak => 'New streak';

  @override
  String get puzzleFromMyGames => 'From my games';

  @override
  String get puzzleLookupOfPlayer => 'Lookup puzzles from a player\'s games';

  @override
  String get puzzleSearchPuzzles => 'Search puzzles';

  @override
  String get puzzleFromMyGamesNone =>
      'You have no puzzles in the database, but Lichess still loves you very much.\n\nPlay rapid and classical games to increase your chances of having a puzzle of yours added!';

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
      other: 'Played $count times',
      one: 'Played $count time',
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
  String puzzlePuzzlesFoundInUserGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puzzles found in games by $param2',
      one: 'One puzzle found in games by $param2',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count played');
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count to replay');
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Просунутий пішак';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'Один з Ваших пішаків просунувся по позиціях суперника, ймовірна загроза перетворення.';

  @override
  String get puzzleThemeAdvantage => 'Перевага';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Скористайтесь шансом отримати вирішальну перевагу. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Мат Анастасії';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'Кінь з турою або ферзем ловлять короля між краєм дошки та власною фігурою.';

  @override
  String get puzzleThemeArabianMate => 'Арабський мат';

  @override
  String get puzzleThemeArabianMateDescription =>
      'Кінь та тура разом ловлять короля у кутку дошки.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Атака f2 або f7';

  @override
  String get puzzleThemeAttackingF2F7Description =>
      'Атака, спрямована на f2 або f7, наприклад, як у дебюті смаженої печінки.';

  @override
  String get puzzleThemeAttraction => 'Заманювання';

  @override
  String get puzzleThemeAttractionDescription =>
      'Обмін або жертва, що заманює або примушує суперника зробити хід, що дозволяє проводити подальшу тактику.';

  @override
  String get puzzleThemeBackRankMate => 'Мат по останній горизонталі';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Мат королю в домашньому ряду, коли він у пастці між власними фігурами.';

  @override
  String get puzzleThemeBishopEndgame => 'Слоновий ендшпіль';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Ендшпіль лише зі слонами та пішаками.';

  @override
  String get puzzleThemeBodenMate => 'Мат Бодена';

  @override
  String get puzzleThemeBodenMateDescription =>
      'Два слони на перехресних діагоналях ставлять мат королю, який оточений власними фігурами.';

  @override
  String get puzzleThemeCastling => 'Рокіровка';

  @override
  String get puzzleThemeCastlingDescription => 'Захистіть свого короля й виведіть у бій туру.';

  @override
  String get puzzleThemeCapturingDefender => 'Захоплення захисника';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Захоплення фігури, що захищає іншу фігуру, дозволяє захопити незахищену фігуру наступним ходом.';

  @override
  String get puzzleThemeCrushing => 'Руйнування';

  @override
  String get puzzleThemeCrushingDescription =>
      'Знайдіть грубу помилку суперника, щоб отримати нищівну перевагу. (eval ≥ 600 cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Мат двома слонами';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Два слони на сусідніх діагоналях ставлять мат королю, який оточений власними фігурами.';

  @override
  String get puzzleThemeDovetailMate => 'Мат \"ластів\'ячий хвіст\"';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'Королева ставить мат королю поруч, єдині два поля для відступу якого зайняті його власними фігурами.';

  @override
  String get puzzleThemeEquality => 'Рівність';

  @override
  String get puzzleThemeEqualityDescription =>
      'Повернення з програшної позиції, забезпечення нічиєї або отримання збалансованої позиції. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Атака на королівський фланг';

  @override
  String get puzzleThemeKingsideAttackDescription =>
      'Атака короля суперника, після його короткого рокірування.';

  @override
  String get puzzleThemeClearance => 'Очищення';

  @override
  String get puzzleThemeClearanceDescription =>
      'Хід, зазвичай з темпом, що звільнює поле, вертикаль чи діагональ з подальшою тактичною ідеєю.';

  @override
  String get puzzleThemeDefensiveMove => 'Захисний хід';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'Точний хід або послідовність ходів, що необхідні для уникнення втрати матеріалу чи іншої переваги.';

  @override
  String get puzzleThemeDeflection => 'Відволікання';

  @override
  String get puzzleThemeDeflectionDescription =>
      'Хід, що відволікає фігуру суперника від іншої виконуваної задачі, наприклад, захисту ключового поля. Деколи ще звуть \"перевантаженням\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Відкритий напад';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Хід фігурою (наприклад, конем), яка до цього блокувала атаку далекобійної фігури (наприклад, тури), геть з лінії цієї фігури.';

  @override
  String get puzzleThemeDoubleCheck => 'Подвійний шах';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Шах двома фігурами одночасно, як наслідок відкриття атаки на короля, коли обидві фігури неможливо захопити.';

  @override
  String get puzzleThemeEndgame => 'Ендшпіль';

  @override
  String get puzzleThemeEndgameDescription => 'Тактика на останній фазі гри.';

  @override
  String get puzzleThemeEnPassantDescription =>
      'Тактика із застосуванням правила \"взяття на проході\", коли пішак може взяти пішака суперника, що зробив початковий хід на два поля, внаслідок якого перетинаюче поле під боєм пішака.';

  @override
  String get puzzleThemeExposedKing => 'Незахищений король';

  @override
  String get puzzleThemeExposedKingDescription =>
      'Король з малою кількістю захисників, що часто призводить до мату.';

  @override
  String get puzzleThemeFork => 'Вилка';

  @override
  String get puzzleThemeForkDescription => 'Хід, коли фігура атакує дві фігури одночасно.';

  @override
  String get puzzleThemeHangingPiece => 'Незахищена фігура';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'Незахищена або недостатньо захищена фігура, що може бути атакована.';

  @override
  String get puzzleThemeHookMate => 'Хук-мат';

  @override
  String get puzzleThemeHookMateDescription =>
      'Мат турою, конем і пішаком разом з одним ворожим пішаком, щоб обмежити втечу ворожого короля.';

  @override
  String get puzzleThemeInterference => 'Перешкода';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Хід фігурою між двома фігурами суперника, що перешкоджає одній або двом фігурам суперника і робить їх незахищеними, наприклад, кінь на захищеному полі між двома турами.';

  @override
  String get puzzleThemeIntermezzo => 'Проміжний хід';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'Замість очікуваного ходу, спочатку робиться інший хід з безпосередньою атакою, на яку суперник має відповісти. Також відомий як \"Zwischenzug\" або \"In between\".';

  @override
  String get puzzleThemeKillBoxMate => 'Мат: Смертельна коробка';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'Тура стає біля ворожого короля під захистом ферзя. Ферзь у той самий час блокує всі поля, через які король може втекти. Тура й ферзь ловлять ворожого короля у «смертельну коробку» розміру 3 на 3.';

  @override
  String get puzzleThemeVukovicMate => 'Мат Вуковіча';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'Тура й кінь об\'єднуються, аби поставити мат королю. Тура, яку захищає третя фігура, ставить мат, а кінь блокує всі поля, через які король може втекти.';

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
  String get puzzleThemeMasterVsMasterDescription =>
      'Задачі з ігор, які були зіграні двома титулованими гравцями.';

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
  String get puzzleThemeMateIn5Description =>
      'Знайдіть послідовність ходів, що призводить до мату.';

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
  String get puzzleThemePinDescription =>
      'Тактика, коли фігура не може зробити хід, тому що буде втрачена цінніша фігура.';

  @override
  String get puzzleThemePromotion => 'Перетворення';

  @override
  String get puzzleThemePromotionDescription =>
      'Перетворення пішака або загроза перетворення є ключовою тактикою.';

  @override
  String get puzzleThemeQueenEndgame => 'Ферзевий ендшпіль';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Ендшпіль лише з ферзем та пішаками.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Ферзевий та туровий ендшпіль';

  @override
  String get puzzleThemeQueenRookEndgameDescription =>
      'Ендшпіль лише з ферзями, турами та пішаками.';

  @override
  String get puzzleThemeQueensideAttack => 'Атака на ферзевому фланзі';

  @override
  String get puzzleThemeQueensideAttackDescription =>
      'Атака на короля суперника, після того як він зробив рокіровку на ферзевому фланзі.';

  @override
  String get puzzleThemeQuietMove => 'Тихий хід';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'Хід, який не робить шах чи захоплення, але готує неминучу загрозу для подальшого ходу.';

  @override
  String get puzzleThemeRookEndgame => 'Туровий ендшпіль';

  @override
  String get puzzleThemeRookEndgameDescription => 'Ендшпіль лише з турами та пішаками.';

  @override
  String get puzzleThemeSacrifice => 'Жертва';

  @override
  String get puzzleThemeSacrificeDescription =>
      'Тактика, що полягає в жертві матеріалу з подальшим отриманням переваги після послідовності вимушених ходів.';

  @override
  String get puzzleThemeShort => 'Коротка задача';

  @override
  String get puzzleThemeShortDescription => 'Два ходи до перемоги.';

  @override
  String get puzzleThemeSkewer => 'Лінійний удар';

  @override
  String get puzzleThemeSkewerDescription =>
      'Мотив, що включає атаку цінної фігури менш цінною, протилежність зв\'язування.';

  @override
  String get puzzleThemeSmotheredMate => 'Спертий мат';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'Мат конем, коли король не може вийти з-під атаки, тому що оточений (спертий) власними фігурами.';

  @override
  String get puzzleThemeSuperGM => 'Ігри супергросмейстерів';

  @override
  String get puzzleThemeSuperGMDescription =>
      'Задачі з ігор, які були зіграні найкращими гравцями світу.';

  @override
  String get puzzleThemeTrappedPiece => 'Фігура у пастці';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'Фігура не може уникнути захоплення, тому що не має ходів для відступу.';

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
  String get puzzleThemeXRayAttackDescription =>
      'Фігура, що атакує чи захищає поле, що знаходиться за фігурою суперника.';

  @override
  String get puzzleThemeZugzwang => 'Цугцванг';

  @override
  String get puzzleThemeZugzwangDescription =>
      'Суперник обмежений в своїх ходах, а кожен хід погіршує його позицію.';

  @override
  String get puzzleThemeMix => 'Усього потрохи';

  @override
  String get puzzleThemeMixDescription =>
      'Усього потрохи. Ви не знатимете, чого очікувати, тому готуйтеся до всього! Як у справжніх партіях.';

  @override
  String get puzzleThemePlayerGames => 'Ігри гравця';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Пошук задач, згенерованих з ваших ігор або з ігор інших гравців.';

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
  String get settingsManagedAccountCannotBeClosed =>
      'Ваш обліковий запис керований і не може бути закритим.';

  @override
  String get settingsCantOpenSimilarAccount =>
      'Ви не зможете створити новий обліковий запис з такою ж назвою, навіть зі зміною регістру.';

  @override
  String get settingsCancelKeepAccount => 'Скасувати і зберегти мій обліковий запис';

  @override
  String get settingsCloseAccountAreYouSure =>
      'Ви впевнені, що хочете закрити свій обліковий запис?';

  @override
  String get settingsThisAccountIsClosed => 'Цей обліковий запис видалено.';

  @override
  String get playWithAFriend => 'Play with a friend';

  @override
  String get playWithTheMachine => 'Play with the computer';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'To invite someone to play, give this URL';

  @override
  String get gameOver => 'Game Over';

  @override
  String get waitingForOpponent => 'Waiting for opponent';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Waiting';

  @override
  String get yourTurn => 'Your turn';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 level $param2';
  }

  @override
  String get level => 'Level';

  @override
  String get strength => 'Strength';

  @override
  String get toggleTheChat => 'Toggle the chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Resign';

  @override
  String get checkmate => 'Checkmate';

  @override
  String get stalemate => 'Stalemate';

  @override
  String get white => 'White';

  @override
  String get black => 'Black';

  @override
  String get asWhite => 'as white';

  @override
  String get asBlack => 'as black';

  @override
  String get randomColor => 'Random side';

  @override
  String get createAGame => 'Create a game';

  @override
  String get createTheGame => 'Create the game';

  @override
  String get whiteIsVictorious => 'White is victorious';

  @override
  String get blackIsVictorious => 'Black is victorious';

  @override
  String get youPlayTheWhitePieces => 'You play the white pieces';

  @override
  String get youPlayTheBlackPieces => 'You play the black pieces';

  @override
  String get itsYourTurn => 'It\'s your turn!';

  @override
  String get cheatDetected => 'Cheat Detected';

  @override
  String get kingInTheCenter => 'King in the centre';

  @override
  String get threeChecks => 'Three checks';

  @override
  String get raceFinished => 'Race finished';

  @override
  String get variantEnding => 'Variant ending';

  @override
  String get newOpponent => 'New opponent';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou =>
      'Your opponent wants to play a new game with you';

  @override
  String get joinTheGame => 'Join the game';

  @override
  String get whitePlays => 'White to play';

  @override
  String get blackPlays => 'Black to play';

  @override
  String get opponentLeftChoices =>
      'Your opponent left the game. You can claim victory, call the game a draw, or wait.';

  @override
  String get forceResignation => 'Claim victory';

  @override
  String get forceDraw => 'Call draw';

  @override
  String get talkInChat => 'Please be nice in the chat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou =>
      'The first person to come to this URL will play with you.';

  @override
  String get whiteResigned => 'White resigned';

  @override
  String get blackResigned => 'Black resigned';

  @override
  String get whiteLeftTheGame => 'White left the game';

  @override
  String get blackLeftTheGame => 'Black left the game';

  @override
  String get whiteDidntMove => 'White didn\'t move';

  @override
  String get blackDidntMove => 'Black didn\'t move';

  @override
  String get requestAComputerAnalysis => 'Request a computer analysis';

  @override
  String get computerAnalysis => 'Computer analysis';

  @override
  String get computerAnalysisAvailable => 'Computer analysis available';

  @override
  String get computerAnalysisDisabled => 'Computer analysis disabled';

  @override
  String get analysis => 'Analysis board';

  @override
  String depthX(String param) {
    return 'Depth $param';
  }

  @override
  String get usingServerAnalysis => 'Using server analysis';

  @override
  String get loadingEngine => 'Loading engine...';

  @override
  String get calculatingMoves => 'Calculating moves...';

  @override
  String get engineFailed => 'Error loading engine';

  @override
  String get cloudAnalysis => 'Cloud analysis';

  @override
  String get goDeeper => 'Go deeper';

  @override
  String get showThreat => 'Show threat';

  @override
  String get inLocalBrowser => 'in local browser';

  @override
  String get toggleLocalEvaluation => 'Toggle local evaluation';

  @override
  String get promoteVariation => 'Promote variation';

  @override
  String get makeMainLine => 'Make mainline';

  @override
  String get deleteFromHere => 'Delete from here';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Force variation';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get copyMainLinePgn => 'Copy mainline PGN';

  @override
  String get move => 'Move';

  @override
  String get variantLoss => 'Variant loss';

  @override
  String get variantWin => 'Variant win';

  @override
  String get insufficientMaterial => 'Insufficient material';

  @override
  String get pawnMove => 'Pawn move';

  @override
  String get capture => 'Capture';

  @override
  String get close => 'Close';

  @override
  String get winning => 'Winning';

  @override
  String get losing => 'Losing';

  @override
  String get drawn => 'Drawn';

  @override
  String get unknown => 'Unknown';

  @override
  String get database => 'Database';

  @override
  String get whiteDrawBlack => 'White / Draw / Black';

  @override
  String averageRatingX(String param) {
    return 'Average rating: $param';
  }

  @override
  String get recentGames => 'Recent games';

  @override
  String get topGames => 'Top games';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'OTB games of $param1+ FIDE-rated players from $param2 to $param3';
  }

  @override
  String get dtzWithRounding =>
      'DTZ50\'\' with rounding, based on number of half-moves until next capture or pawn move';

  @override
  String get noGameFound => 'No game found';

  @override
  String get maxDepthReached => 'Max depth reached!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu =>
      'Maybe include more games from the preferences menu?';

  @override
  String get openings => 'Openings';

  @override
  String get openingExplorer => 'Opening explorer';

  @override
  String get openingEndgameExplorer => 'Opening/endgame explorer';

  @override
  String xOpeningExplorer(String param) {
    return '$param opening explorer';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => 'Win prevented by 50-move rule';

  @override
  String get lossSavedBy50MoveRule => 'Loss prevented by 50-move rule';

  @override
  String get winOr50MovesByPriorMistake => 'Win or 50 moves by prior mistake';

  @override
  String get lossOr50MovesByPriorMistake => 'Loss or 50 moves by prior mistake';

  @override
  String get unknownDueToRounding =>
      'Win/loss only guaranteed if recommended tablebase line has been followed since the last capture or pawn move, due to possible rounding of DTZ values in Syzygy tablebases.';

  @override
  String get allSet => 'All set!';

  @override
  String get importPgn => 'Import PGN';

  @override
  String get delete => 'Delete';

  @override
  String get deleteThisImportedGame => 'Delete this imported game?';

  @override
  String get replayMode => 'Replay mode';

  @override
  String get realtimeReplay => 'Realtime';

  @override
  String get byCPL => 'By CPL';

  @override
  String get enable => 'Enable';

  @override
  String get bestMoveArrow => 'Best move arrow';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Evaluation gauge';

  @override
  String get multipleLines => 'Multiple lines';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Memory';

  @override
  String get infiniteAnalysis => 'Infinite analysis';

  @override
  String get removesTheDepthLimit => 'Removes the depth limit, and keeps your computer warm';

  @override
  String get blunder => 'Blunder';

  @override
  String get mistake => 'Mistake';

  @override
  String get inaccuracy => 'Inaccuracy';

  @override
  String get moveTimes => 'Move times';

  @override
  String get flipBoard => 'Flip board';

  @override
  String get threefoldRepetition => 'Threefold repetition';

  @override
  String get claimADraw => 'Claim a draw';

  @override
  String get drawClaimed => 'Draw claimed';

  @override
  String get offerDraw => 'Offer draw';

  @override
  String get draw => 'Draw';

  @override
  String get drawByMutualAgreement => 'Draw by mutual agreement';

  @override
  String get fiftyMovesWithoutProgress => 'Fifty moves without progress';

  @override
  String get currentGames => 'Current games';

  @override
  String joinedX(String param) {
    return 'Joined $param';
  }

  @override
  String get viewInFullSize => 'View in full size';

  @override
  String get logOut => 'Sign out';

  @override
  String get signIn => 'Sign in';

  @override
  String get rememberMe => 'Keep me logged in';

  @override
  String get youNeedAnAccountToDoThat => 'You need an account to do that';

  @override
  String get signUp => 'Register';

  @override
  String get computersAreNotAllowedToPlay =>
      'Computers and computer-assisted players are not allowed to play. Please do not get assistance from chess engines, databases, or from other players while playing. Also note that making multiple accounts is strongly discouraged and excessive multi-accounting will lead to being banned.';

  @override
  String get games => 'Games';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 posted in topic $param2';
  }

  @override
  String get latestForumPosts => 'Latest forum posts';

  @override
  String get players => 'Players';

  @override
  String get friends => 'Friends';

  @override
  String get otherPlayers => 'other players';

  @override
  String get discussions => 'Conversations';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get minutesPerSide => 'Minutes per side';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Variants';

  @override
  String get timeControl => 'Time control';

  @override
  String get realTime => 'Real time';

  @override
  String get correspondence => 'Correspondence';

  @override
  String get daysPerTurn => 'Days per turn';

  @override
  String get oneDay => 'One day';

  @override
  String get time => 'Time';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Rating stats';

  @override
  String get username => 'User name';

  @override
  String get usernameOrEmail => 'User name or email';

  @override
  String get changeUsername => 'Change username';

  @override
  String get changeUsernameNotSame =>
      'Only the case of the letters can change. For example \"johndoe\" to \"JohnDoe\".';

  @override
  String get changeUsernameDescription =>
      'Change your username. This can only be done once and you are only allowed to change the case of the letters in your username.';

  @override
  String get signupUsernameHint =>
      'Make sure to choose a username that\'s appropriate for all ages. You cannot change it later and any accounts with inappropriate usernames will get closed!';

  @override
  String get signupEmailHint => 'We will only use it for password reset.';

  @override
  String get password => 'Password';

  @override
  String get changePassword => 'Change password';

  @override
  String get changeEmail => 'Change email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Password reset';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get error_weakPassword => 'This password is extremely common, and too easy to guess.';

  @override
  String get error_namePassword => 'Please don\'t use your username as your password.';

  @override
  String get blankedPassword =>
      'You have used the same password on another site, and that site has been compromised. To ensure the safety of your Lichess account, we need you to set a new password. Thank you for your understanding.';

  @override
  String get youAreLeavingLichess => 'You are leaving Lichess';

  @override
  String get neverTypeYourPassword => 'Never type your Lichess password on another site!';

  @override
  String proceedToX(String param) {
    return 'Proceed to $param';
  }

  @override
  String get passwordSuggestion =>
      'Do not set a password suggested by someone else. They will use it to steal your account.';

  @override
  String get emailSuggestion =>
      'Do not set an email address suggested by someone else. They will use it to steal your account.';

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
  String get checkSpamFolder =>
      'Also check your spam folder, it might end up there. If so, mark it as not spam.';

  @override
  String get emailForSignupHelp => 'If everything else fails, then send us this email:';

  @override
  String copyTextToEmail(String param) {
    return 'Copy and paste the above text and send it to $param';
  }

  @override
  String get waitForSignupHelp =>
      'We will come back to you shortly to help you complete your signup.';

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
  String get rank => 'Rank';

  @override
  String rankX(String param) {
    return 'Rank: $param';
  }

  @override
  String get gamesPlayed => 'Games played';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get whiteTimeOut => 'White time out';

  @override
  String get blackTimeOut => 'Black time out';

  @override
  String get drawOfferSent => 'Draw offer sent';

  @override
  String get drawOfferAccepted => 'Draw offer accepted';

  @override
  String get drawOfferCanceled => 'Draw offer cancelled';

  @override
  String get whiteOffersDraw => 'White offers draw';

  @override
  String get blackOffersDraw => 'Black offers draw';

  @override
  String get whiteDeclinesDraw => 'White declines draw';

  @override
  String get blackDeclinesDraw => 'Black declines draw';

  @override
  String get yourOpponentOffersADraw => 'Your opponent offers a draw';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get playingRightNow => 'Playing right now';

  @override
  String get eventInProgress => 'Playing now';

  @override
  String get finished => 'Finished';

  @override
  String get abortGame => 'Abort game';

  @override
  String get gameAborted => 'Game aborted';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get mode => 'Mode';

  @override
  String get casual => 'Casual';

  @override
  String get rated => 'Rated';

  @override
  String get casualTournament => 'Casual';

  @override
  String get ratedTournament => 'Rated';

  @override
  String get thisGameIsRated => 'This game is rated';

  @override
  String get rematch => 'Rematch';

  @override
  String get rematchOfferSent => 'Rematch offer sent';

  @override
  String get rematchOfferAccepted => 'Rematch offer accepted';

  @override
  String get rematchOfferCanceled => 'Rematch offer cancelled';

  @override
  String get rematchOfferDeclined => 'Rematch offer declined';

  @override
  String get cancelRematchOffer => 'Cancel rematch offer';

  @override
  String get viewRematch => 'View rematch';

  @override
  String get confirmMove => 'Confirm move';

  @override
  String get play => 'Play';

  @override
  String get inbox => 'Inbox';

  @override
  String get chatRoom => 'Chat room';

  @override
  String get loginToChat => 'Sign in to chat';

  @override
  String get youHaveBeenTimedOut => 'You have been timed out.';

  @override
  String get spectatorRoom => 'Spectator room';

  @override
  String get composeMessage => 'Compose message';

  @override
  String get subject => 'Subject';

  @override
  String get send => 'Send';

  @override
  String get incrementInSeconds => 'Increment in seconds';

  @override
  String get freeOnlineChess => 'Free Online Chess';

  @override
  String get exportGames => 'Export games';

  @override
  String get ratingRange => 'Rating range';

  @override
  String get thisAccountViolatedTos => 'This account violated the Lichess Terms of Service';

  @override
  String get openingExplorerAndTablebase => 'Opening explorer & tablebase';

  @override
  String get takeback => 'Takeback';

  @override
  String get proposeATakeback => 'Propose a takeback';

  @override
  String get whiteProposesTakeback => 'White proposes takeback';

  @override
  String get blackProposesTakeback => 'Black proposes takeback';

  @override
  String get takebackPropositionSent => 'Takeback sent';

  @override
  String get whiteDeclinesTakeback => 'White declines takeback';

  @override
  String get blackDeclinesTakeback => 'Black declines takeback';

  @override
  String get whiteAcceptsTakeback => 'White accepts takeback';

  @override
  String get blackAcceptsTakeback => 'Black accepts takeback';

  @override
  String get whiteCancelsTakeback => 'White cancels takeback';

  @override
  String get blackCancelsTakeback => 'Black cancels takeback';

  @override
  String get yourOpponentProposesATakeback => 'Your opponent proposes a takeback';

  @override
  String get bookmarkThisGame => 'Bookmark this game';

  @override
  String get tournament => 'Tournament';

  @override
  String get tournaments => 'Tournaments';

  @override
  String get tournamentPoints => 'Tournament points';

  @override
  String get viewTournament => 'View tournament';

  @override
  String get backToTournament => 'Back to tournament';

  @override
  String get noDrawBeforeSwissLimit =>
      'You cannot draw before 30 moves are played in a Swiss tournament.';

  @override
  String get thematic => 'Thematic';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Your $param rating is provisional';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Your $param1 rating ($param2) is too high';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Your top weekly $param1 rating ($param2) is too high';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Your $param1 rating ($param2) is too low';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Rated ≥ $param1 in $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rated ≤ $param1 in $param2 for the last week';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Must be in team $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'You are not in the team $param';
  }

  @override
  String get backToGame => 'Back to game';

  @override
  String get siteDescription =>
      'Free online chess server. Play chess in a clean interface. No registration, no ads, no plugin required. Play chess with the computer, friends or random opponents.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 joined team $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 created team $param2';
  }

  @override
  String get startedStreaming => 'started streaming';

  @override
  String xStartedStreaming(String param) {
    return '$param started streaming';
  }

  @override
  String get averageElo => 'Average rating';

  @override
  String get location => 'Location';

  @override
  String get filterGames => 'Filter games';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Submit';

  @override
  String get save => 'Save';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get screenshotCurrentPosition => 'Screenshot current position';

  @override
  String get gameAsGIF => 'Game as GIF';

  @override
  String get pasteTheFenStringHere => 'Paste the FEN text here';

  @override
  String get pasteThePgnStringHere => 'Paste the PGN text here';

  @override
  String get orUploadPgnFile => 'Or upload a PGN file';

  @override
  String get fromPosition => 'From position';

  @override
  String get continueFromHere => 'Continue from here';

  @override
  String get toStudy => 'Study';

  @override
  String get importGame => 'Import game';

  @override
  String get importGameExplanation =>
      'Paste a game PGN to get a browsable replay, computer analysis, game chat and public shareable URL.';

  @override
  String get importGameCaveat =>
      'Variations will be erased. To keep them, import the PGN via a study.';

  @override
  String get importGameDataPrivacyWarning =>
      'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'This is a chess CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove =>
      'Click on the board to make your move, and prove you are human.';

  @override
  String get captcha_fail => 'Please solve the chess captcha.';

  @override
  String get notACheckmate => 'Not a checkmate';

  @override
  String get whiteCheckmatesInOneMove => 'White to checkmate in one move';

  @override
  String get blackCheckmatesInOneMove => 'Black to checkmate in one move';

  @override
  String get retry => 'Retry';

  @override
  String get reconnecting => 'Reconnecting';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Favourite opponents';

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get unfollow => 'Unfollow';

  @override
  String followX(String param) {
    return 'Follow $param';
  }

  @override
  String unfollowX(String param) {
    return 'Unfollow $param';
  }

  @override
  String get block => 'Block';

  @override
  String get blocked => 'Blocked';

  @override
  String get unblock => 'Unblock';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 started following $param2';
  }

  @override
  String get more => 'More';

  @override
  String get memberSince => 'Member since';

  @override
  String lastSeenActive(String param) {
    return 'Active $param';
  }

  @override
  String get player => 'Player';

  @override
  String get list => 'List';

  @override
  String get graph => 'Graph';

  @override
  String get required => 'Required.';

  @override
  String get openTournaments => 'Open tournaments';

  @override
  String get duration => 'Duration';

  @override
  String get winner => 'Winner';

  @override
  String get standing => 'Standing';

  @override
  String get createANewTournament => 'Create a new tournament';

  @override
  String get tournamentCalendar => 'Tournament calendar';

  @override
  String get conditionOfEntry => 'Entry requirements:';

  @override
  String get advancedSettings => 'Advanced settings';

  @override
  String get safeTournamentName => 'Pick a very safe name for the tournament.';

  @override
  String get inappropriateNameWarning =>
      'Anything even slightly inappropriate could get your account closed.';

  @override
  String get emptyTournamentName =>
      'Leave empty to name the tournament after a notable chess player.';

  @override
  String get makePrivateTournament =>
      'Make the tournament private, and restrict access with a password';

  @override
  String get join => 'Join';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get points => 'Points';

  @override
  String get wins => 'Wins';

  @override
  String get losses => 'Losses';

  @override
  String get createdBy => 'Created by';

  @override
  String get startingIn => 'Starting in';

  @override
  String standByX(String param) {
    return 'Stand by $param, pairing players, get ready!';
  }

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get youArePlaying => 'You are playing!';

  @override
  String get winRate => 'Win rate';

  @override
  String get performance => 'Performance';

  @override
  String get tournamentComplete => 'Tournament complete';

  @override
  String get movesPlayed => 'Moves played';

  @override
  String get whiteWins => 'White wins';

  @override
  String get blackWins => 'Black wins';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Draws';

  @override
  String get averageOpponent => 'Average opponent';

  @override
  String get boardEditor => 'Board editor';

  @override
  String get setTheBoard => 'Set the board';

  @override
  String get popularOpenings => 'Popular openings';

  @override
  String get endgamePositions => 'Endgame positions';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 start position: $param';
  }

  @override
  String get startPosition => 'Starting position';

  @override
  String get clearBoard => 'Clear board';

  @override
  String get loadPosition => 'Load position';

  @override
  String get isPrivate => 'Private';

  @override
  String reportXToModerators(String param) {
    return 'Report $param to moderators';
  }

  @override
  String profileCompletion(String param) {
    return 'Profile completion: $param';
  }

  @override
  String xRating(String param) {
    return '$param rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'If none, leave empty';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair =>
      'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Biography';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Thank you!';

  @override
  String get socialMediaLinks => 'Social media links';

  @override
  String get oneUrlPerLine => 'One URL per line.';

  @override
  String get inlineNotation => 'Inline notation';

  @override
  String get makeAStudy => 'For safekeeping and sharing, consider making a study.';

  @override
  String get clearSavedMoves => 'Clear moves';

  @override
  String get previouslyOnLichessTV => 'Previously on Lichess TV';

  @override
  String get onlinePlayers => 'Online players';

  @override
  String get activePlayers => 'Active players';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Beware, the game is rated but has no clock!';

  @override
  String get success => 'Success';

  @override
  String get automaticallyProceedToNextGameAfterMoving =>
      'Automatically proceed to next game after moving';

  @override
  String get autoSwitch => 'Auto switch';

  @override
  String get puzzles => 'Puzzles';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get descPrivate => 'Private description';

  @override
  String get descPrivateHelp =>
      'Text that only the team members will see. If set, replaces the public description for team members.';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get website => 'Website';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Help:';

  @override
  String get createANewTopic => 'Create a new topic';

  @override
  String get topics => 'Topics';

  @override
  String get posts => 'Posts';

  @override
  String get lastPost => 'Last post';

  @override
  String get views => 'Views';

  @override
  String get replies => 'Replies';

  @override
  String get replyToThisTopic => 'Reply to this topic';

  @override
  String get reply => 'Reply';

  @override
  String get message => 'Message';

  @override
  String get createTheTopic => 'Create the topic';

  @override
  String get reportAUser => 'Report a user';

  @override
  String get user => 'User';

  @override
  String get reason => 'Reason';

  @override
  String get whatIsIheMatter => 'What\'s the matter?';

  @override
  String get cheat => 'Cheat';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Other';

  @override
  String get reportCheatBoostHelp =>
      'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp =>
      'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish =>
      'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink =>
      'Please provide at least one link to a cheated game.';

  @override
  String by(String param) {
    return 'by $param';
  }

  @override
  String importedByX(String param) {
    return 'Imported by $param';
  }

  @override
  String get thisTopicIsNowClosed => 'This topic is now closed.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notes';

  @override
  String get typePrivateNotesHere => 'Type private notes here';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Write a private note about this user';

  @override
  String get noNoteYet => 'No note yet';

  @override
  String get invalidUsernameOrPassword => 'Invalid username or password';

  @override
  String get incorrectPassword => 'Incorrect password';

  @override
  String get invalidAuthenticationCode => 'Invalid authentication code';

  @override
  String get emailMeALink => 'Email me a link';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordAgain => 'New password (again)';

  @override
  String get newPasswordsDontMatch => 'The new passwords don\'t match';

  @override
  String get newPasswordStrength => 'Password strength';

  @override
  String get clockInitialTime => 'Clock initial time';

  @override
  String get clockIncrement => 'Clock increment';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get letOtherPlayersFollowYou => 'Let other players follow you';

  @override
  String get letOtherPlayersChallengeYou => 'Let other players challenge you';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Let other players invite you to study';

  @override
  String get sound => 'Sound';

  @override
  String get none => 'None';

  @override
  String get fast => 'Fast';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Slow';

  @override
  String get insideTheBoard => 'Inside the board';

  @override
  String get outsideTheBoard => 'Outside the board';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'On slow games';

  @override
  String get always => 'Always';

  @override
  String get never => 'Never';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 competes in $param2';
  }

  @override
  String get victory => 'Victory';

  @override
  String get defeat => 'Defeat';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 in $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 in $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 in $param3';
  }

  @override
  String get timeline => 'Timeline';

  @override
  String get starting => 'Starting:';

  @override
  String get allInformationIsPublicAndOptional => 'All information is public and optional.';

  @override
  String get biographyDescription =>
      'Talk about yourself, your interests, what you like in chess, your favourite openings, players, ...';

  @override
  String get listBlockedPlayers => 'List players you have blocked';

  @override
  String get human => 'Human';

  @override
  String get computer => 'Computer';

  @override
  String get side => 'Side';

  @override
  String get clock => 'Clock';

  @override
  String get opponent => 'Opponent';

  @override
  String get learnMenu => 'Learn';

  @override
  String get studyMenu => 'Study';

  @override
  String get practice => 'Practice';

  @override
  String get community => 'Community';

  @override
  String get tools => 'Tools';

  @override
  String get increment => 'Increment';

  @override
  String get error_unknown => 'Invalid value';

  @override
  String get error_required => 'This field is required';

  @override
  String get error_email => 'This email address is invalid';

  @override
  String get error_email_acceptable =>
      'This email address is not acceptable. Please double-check it, and try again.';

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
    return 'If rating is ± $param';
  }

  @override
  String get ifRegistered => 'If registered';

  @override
  String get onlyExistingConversations => 'Only existing conversations';

  @override
  String get onlyFriends => 'Only friends';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Castling';

  @override
  String get whiteCastlingKingside => 'White O-O';

  @override
  String get blackCastlingKingside => 'Black O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Time spent playing: $param';
  }

  @override
  String get watchGames => 'Watch games';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Time featured on TV: $param';
  }

  @override
  String get watch => 'Watch';

  @override
  String get videoLibrary => 'Video library';

  @override
  String get streamersMenu => 'Streamers';

  @override
  String get mobileApp => 'Mobile App';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'About';

  @override
  String aboutX(String param) {
    return 'About $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 is a free ($param2), libre, no-ads, open source chess server.';
  }

  @override
  String get really => 'really';

  @override
  String get contribute => 'Contribute';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get titleVerification => 'Title verification';

  @override
  String get sourceCode => 'Source Code';

  @override
  String get simultaneousExhibitions => 'Simultaneous exhibitions';

  @override
  String get host => 'Host';

  @override
  String hostColorX(String param) {
    return 'Host colour: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Newly created simuls';

  @override
  String get hostANewSimul => 'Host a new simul';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Simul not found';

  @override
  String get noSimulExplanation => 'This simultaneous exhibition does not exist.';

  @override
  String get returnToSimulHomepage => 'Return to simul homepage';

  @override
  String get aboutSimul => 'Simuls involve a single player facing several players at once.';

  @override
  String get aboutSimulImage => 'Out of 50 opponents, Fischer won 47 games, drew 2 and lost 1.';

  @override
  String get aboutSimulRealLife =>
      'The concept is taken from real world events. In real life, this involves the simul host moving from table to table to play a single move.';

  @override
  String get aboutSimulRules =>
      'When the simul starts, every player starts a game with the host. The simul ends when all games are complete.';

  @override
  String get aboutSimulSettings =>
      'Simuls are always casual. Rematches, takebacks and adding time are disabled.';

  @override
  String get create => 'Create';

  @override
  String get whenCreateSimul => 'When you create a Simul, you get to play several players at once.';

  @override
  String get simulVariantsHint =>
      'If you select several variants, each player gets to choose which one to play.';

  @override
  String get simulClockHint =>
      'Fischer Clock setup. The more players you take on, the more time you may need.';

  @override
  String get simulAddExtraTime =>
      'You may add extra initial time to your clock to help you cope with the simul.';

  @override
  String get simulHostExtraTime => 'Host extra initial clock time';

  @override
  String get simulAddExtraTimePerPlayer =>
      'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'Lichess tournaments';

  @override
  String get tournamentFAQ => 'Arena tournament FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Time before tournament starts';

  @override
  String get averageCentipawnLoss => 'Average centipawn loss';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get keyboardShortcuts => 'Keyboard shortcuts';

  @override
  String get keyMoveBackwardOrForward => 'move backward/forward';

  @override
  String get keyGoToStartOrEnd => 'go to start/end';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'show/hide comments';

  @override
  String get keyEnterOrExitVariation => 'enter/exit variation';

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
  String get variationArrowsInfo =>
      'Variation arrows let you navigate without using the move list.';

  @override
  String get playSelectedMove => 'play selected move';

  @override
  String get newTournament => 'New tournament';

  @override
  String get tournamentHomeTitle =>
      'Chess tournaments featuring various time controls and variants';

  @override
  String get tournamentHomeDescription =>
      'Play fast-paced chess tournaments! Join an official scheduled tournament, or create your own. Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck, and more options available for endless chess fun.';

  @override
  String get tournamentNotFound => 'Tournament not found';

  @override
  String get tournamentDoesNotExist => 'This tournament does not exist.';

  @override
  String get tournamentMayHaveBeenCanceled =>
      'The tournament may have been cancelled if all players left before it started.';

  @override
  String get returnToTournamentsHomepage => 'Return to tournaments homepage';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Weekly $param rating distribution';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Your $param1 rating is $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'You are better than $param1 of $param2 players.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 is better than $param2 of $param3 players.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'You do not have an established $param rating.';
  }

  @override
  String get yourRating => 'Your rating';

  @override
  String get cumulative => 'Cumulative';

  @override
  String get glicko2Rating => 'Glicko-2 rating';

  @override
  String get checkYourEmail => 'Check your Email';

  @override
  String get weHaveSentYouAnEmailClickTheLink =>
      'We\'ve sent you an email. Click the link in the email to activate your account.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces =>
      'If you don\'t see the email, check other places it might be, like your junk, spam, social, or other folders.';

  @override
  String get ifYouDoNotGetTheEmail => 'If you do not get the email within 5 minutes:';

  @override
  String get checkAllEmailFolders => 'Check all junk, spam, and other folders';

  @override
  String verifyYourAddress(String param) {
    return 'Verify that $param is your email address';
  }

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'We\'ve sent an email to $param. Click the link in the email to reset your password.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'By registering, you agree to the $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Read about our $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Network lag between you and Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Time to process a move on Lichess\'s server';

  @override
  String get downloadAnnotated => 'Download annotated';

  @override
  String get downloadRaw => 'Download raw';

  @override
  String get downloadImported => 'Download imported';

  @override
  String get downloadAllGames => 'Download all games';

  @override
  String get crosstable => 'Crosstable';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame =>
      'Scroll over the board to move in the game.';

  @override
  String get scrollOverComputerVariationsToPreviewThem =>
      'Scroll over computer variations to preview them.';

  @override
  String get analysisShapesHowTo =>
      'Press shift+click or right-click to draw circles and arrows on the board.';

  @override
  String get letOtherPlayersMessageYou => 'Let other players message you';

  @override
  String get receiveForumNotifications => 'Receive notifications when mentioned in the forum';

  @override
  String get shareYourInsightsData => 'Share your chess insights data';

  @override
  String get withNobody => 'With nobody';

  @override
  String get withFriends => 'With friends';

  @override
  String get withEverybody => 'With everybody';

  @override
  String get kidMode => 'Kid mode';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation =>
      'This is about safety. In kid mode, all site communications are disabled. Enable this for your children and school students, to protect them from other internet users.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'In kid mode, the Lichess logo gets a $param icon, so you know your kids are safe.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode =>
      'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'Enable Kid mode';

  @override
  String get disableKidMode => 'Disable Kid mode';

  @override
  String get security => 'Security';

  @override
  String get sessions => 'Sessions';

  @override
  String get revokeAllSessions => 'revoke all sessions';

  @override
  String get playChessEverywhere => 'Play chess everywhere';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Everybody gets all features for free';

  @override
  String get viewTheSolution => 'View the solution';

  @override
  String get noChallenges => 'No challenges.';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 hosts $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 joins $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 likes $param2';
  }

  @override
  String get quickPairing => 'Quick pairing';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonymous';

  @override
  String yourScore(String param) {
    return 'Your score: $param';
  }

  @override
  String get language => 'Language';

  @override
  String get allLanguages => 'All languages';

  @override
  String get background => 'Background';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get transparent => 'Transparent';

  @override
  String get deviceTheme => 'Device theme';

  @override
  String get backgroundImageUrl => 'Background image URL:';

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
  String get pieceSet => 'Piece set';

  @override
  String get embedInYourWebsite => 'Embed in your website';

  @override
  String get usernameAlreadyUsed => 'This username is already in use, please try another one.';

  @override
  String get usernamePrefixInvalid => 'The username must start with a letter.';

  @override
  String get usernameSuffixInvalid => 'The username must end with a letter or a number.';

  @override
  String get usernameCharsInvalid =>
      'The username must only contain letters, numbers, underscores, and hyphens. Consecutive underscores and hyphens are not allowed.';

  @override
  String get usernameUnacceptable => 'This username is not acceptable.';

  @override
  String get playChessInStyle => 'Play chess in style';

  @override
  String get chessBasics => 'Chess basics';

  @override
  String get coaches => 'Coaches';

  @override
  String get invalidPgn => 'Invalid PGN';

  @override
  String get invalidFen => 'Invalid FEN';

  @override
  String get custom => 'Custom';

  @override
  String get notifications => 'Notifications';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Practice with computer';

  @override
  String anotherWasX(String param) {
    return 'Another was $param';
  }

  @override
  String bestWasX(String param) {
    return 'Best was $param';
  }

  @override
  String get youBrowsedAway => 'You browsed away';

  @override
  String get resumePractice => 'Resume practice';

  @override
  String get drawByFiftyMoves => 'The game has been drawn by the fifty move rule.';

  @override
  String get theGameIsADraw => 'The game is a draw.';

  @override
  String get computerThinking => 'Computer thinking ...';

  @override
  String get seeBestMove => 'See best move';

  @override
  String get hideBestMove => 'Hide best move';

  @override
  String get getAHint => 'Get a hint';

  @override
  String get evaluatingYourMove => 'Evaluating your move ...';

  @override
  String get whiteWinsGame => 'White wins';

  @override
  String get blackWinsGame => 'Black wins';

  @override
  String get learnFromYourMistakes => 'Learn from your mistakes';

  @override
  String get learnFromThisMistake => 'Learn from this mistake';

  @override
  String get skipThisMove => 'Skip this move';

  @override
  String get next => 'Next';

  @override
  String xWasPlayed(String param) {
    return '$param was played';
  }

  @override
  String get findBetterMoveForWhite => 'Find a better move for white';

  @override
  String get findBetterMoveForBlack => 'Find a better move for black';

  @override
  String get resumeLearning => 'Resume learning';

  @override
  String get youCanDoBetter => 'You can do better';

  @override
  String get tryAnotherMoveForWhite => 'Try another move for white';

  @override
  String get tryAnotherMoveForBlack => 'Try another move for black';

  @override
  String get solution => 'Solution';

  @override
  String get waitingForAnalysis => 'Waiting for analysis';

  @override
  String get noMistakesFoundForWhite => 'No mistakes found for white';

  @override
  String get noMistakesFoundForBlack => 'No mistakes found for black';

  @override
  String get doneReviewingWhiteMistakes => 'Done reviewing white mistakes';

  @override
  String get doneReviewingBlackMistakes => 'Done reviewing black mistakes';

  @override
  String get doItAgain => 'Do it again';

  @override
  String get reviewWhiteMistakes => 'Review white mistakes';

  @override
  String get reviewBlackMistakes => 'Review black mistakes';

  @override
  String get advantage => 'Advantage';

  @override
  String get opening => 'Opening';

  @override
  String get middlegame => 'Middlegame';

  @override
  String get endgame => 'Endgame';

  @override
  String get conditionalPremoves => 'Conditional premoves';

  @override
  String get addCurrentVariation => 'Add current variation';

  @override
  String get playVariationToCreateConditionalPremoves =>
      'Play a variation to create conditional premoves';

  @override
  String get noConditionalPremoves => 'No conditional premoves';

  @override
  String playX(String param) {
    return 'Play $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Sorry :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'We had to time you out for a while.';

  @override
  String get why => 'Why?';

  @override
  String get pleasantChessExperience =>
      'We aim to provide a pleasant chess experience for everyone.';

  @override
  String get goodPractice =>
      'To that effect, we must ensure that all players follow good practice.';

  @override
  String get potentialProblem => 'When a potential problem is detected, we display this message.';

  @override
  String get howToAvoidThis => 'How to avoid this?';

  @override
  String get playEveryGame => 'Play every game you start.';

  @override
  String get tryToWin => 'Try to win (or at least draw) every game you play.';

  @override
  String get resignLostGames => 'Resign lost games (don\'t let the clock run down).';

  @override
  String get temporaryInconvenience => 'We apologise for the temporary inconvenience,';

  @override
  String get wishYouGreatGames => 'and wish you great games on lichess.org.';

  @override
  String get thankYouForReading => 'Thank you for reading!';

  @override
  String get lifetimeScore => 'Lifetime score';

  @override
  String get currentMatchScore => 'Current match score';

  @override
  String get agreementAssistance =>
      'I agree that I will at no time receive assistance during my games (from a chess computer, book, database or another person).';

  @override
  String get agreementNice => 'I agree that I will always be respectful to other players.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'I agree that I will not create multiple accounts (except for the reasons stated in the $param).';
  }

  @override
  String get agreementPolicy => 'I agree that I will follow all Lichess policies.';

  @override
  String get searchOrStartNewDiscussion => 'Search or start new conversation';

  @override
  String get edit => 'Edit';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Classical';

  @override
  String get ultraBulletDesc => 'Insanely fast games: less than 30 seconds';

  @override
  String get bulletDesc => 'Very fast games: less than 3 minutes';

  @override
  String get blitzDesc => 'Fast games: 3 to 8 minutes';

  @override
  String get rapidDesc => 'Rapid games: 8 to 25 minutes';

  @override
  String get classicalDesc => 'Classical games: 25 minutes and more';

  @override
  String get correspondenceDesc => 'Correspondence games: one or several days per move';

  @override
  String get puzzleDesc => 'Chess tactics trainer';

  @override
  String get important => 'Important';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Your question may already have an answer $param1';
  }

  @override
  String get inTheFAQ => 'in the FAQ';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'To report a user for cheating or bad behaviour, $param1';
  }

  @override
  String get useTheReportForm => 'use the report form';

  @override
  String toRequestSupport(String param1) {
    return 'To request support, $param1';
  }

  @override
  String get tryTheContactPage => 'try the contact page';

  @override
  String makeSureToRead(String param1) {
    return 'Make sure to read $param1';
  }

  @override
  String get theForumEtiquette => 'the forum etiquette';

  @override
  String get thisTopicIsArchived => 'This topic has been archived and can no longer be replied to.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Join the $param1, to post in this forum';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 team';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'You can\'t post in the forums yet. Play some games!';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get unsubscribe => 'Unsubscribe';

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
  String get youAreNowPartOfTeam => 'You are now part of the team.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'You have joined \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Someone you reported was banned';

  @override
  String get congratsYouWon => 'Congratulations, you won!';

  @override
  String gameVsX(String param1) {
    return 'Game vs $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator =>
      'You lost rating points to someone who violated the Lichess TOS';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Refund: $param1 $param2 rating points.';
  }

  @override
  String get timeAlmostUp => 'Time is almost up!';

  @override
  String get clickToRevealEmailAddress => '[Click to reveal email address]';

  @override
  String get download => 'Download';

  @override
  String get coachManager => 'Coach manager';

  @override
  String get streamerManager => 'Streamer manager';

  @override
  String get cancelTournament => 'Cancel the tournament';

  @override
  String get tournDescription => 'Tournament description';

  @override
  String get tournDescriptionHelp =>
      'Anything special you want to tell the participants? Try to keep it short. Markdown links are available: [name](https://url)';

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
  String get reopenYourAccountDescription =>
      'If you closed your account, but have since changed your mind, you get a chance of getting your account back.';

  @override
  String get emailAssociatedToaccount => 'Email address associated to the account';

  @override
  String get sentEmailWithLink => 'We\'ve sent you an email with a link.';

  @override
  String get tournamentEntryCode => 'Tournament entry code';

  @override
  String get hangOn => 'Hang on!';

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
  String get lichessPatronInfo =>
      'Lichess is a charity and entirely free/libre open source software.\nAll operating costs, development, and content are funded solely by user donations.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String get stats => 'Stats';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get enableBlindMode => 'Enable blind mode';

  @override
  String get disableBlindMode => 'Disable blind mode';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your opponent left the game. You can claim victory in $count seconds.',
      one: 'Your opponent left the game. You can claim victory in $count second.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mate in $count half-moves',
      one: 'Mate in $count half-move',
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
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Blunders',
      one: '$count Blunder',
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
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mistakes',
      one: '$count Mistake',
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
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Inaccuracies',
      one: '$count Inaccuracy',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count players',
      one: '$count player',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games',
      one: '$count game',
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
      other: '$count bookmarks',
      one: '$count bookmark',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '$count hour',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '$count minute',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rank is updated every $count minutes',
      one: 'Rank is updated every minute',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puzzles',
      one: '$count puzzle',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games with you',
      one: '$count game with you',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rated',
      one: '$count rated',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wins',
      one: '$count win',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count losses',
      one: '$count loss',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count draws',
      one: '$count draw',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count playing',
      one: '$count playing',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Give $count seconds',
      one: 'Give $count second',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tournament points',
      one: '$count tournament point',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studies',
      one: '$count study',
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
      other: '≥ $count rated games',
      one: '≥ $count rated game',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 rated games',
      one: '≥ $count $param2 rated game',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You need to play $count more $param2 rated games',
      one: 'You need to play $count more $param2 rated game',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You need to play $count more rated games',
      one: 'You need to play $count more rated game',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imported games',
      one: '$count imported game',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends online',
      one: '$count friend online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '$count follower',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count following',
      one: '$count following',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Less than $count minutes',
      one: 'Less than $count minute',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games in play',
      one: '$count game in play',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maximum: $count characters.',
      one: 'Maximum: $count character.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blocks',
      one: '$count block',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forum posts',
      one: '$count forum post',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 players this week.',
      one: '$count $param2 player this week.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Available in $count languages!',
      one: 'Available in $count language!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds to play the first move',
      one: '$count second to play the first move',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds',
      one: '$count second',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'and save $count premove lines',
      one: 'and save $count premove line',
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
  String get stormSkipExplanation =>
      'Пропустіть цей хід, щоб зберегти комбо! Можна використати лише один раз.';

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
  String get studyPrivate => 'Private';

  @override
  String get studyMyStudies => 'My studies';

  @override
  String get studyStudiesIContributeTo => 'Studies I contribute to';

  @override
  String get studyMyPublicStudies => 'My public studies';

  @override
  String get studyMyPrivateStudies => 'My private studies';

  @override
  String get studyMyFavoriteStudies => 'My favourite studies';

  @override
  String get studyWhatAreStudies => 'What are studies?';

  @override
  String get studyAllStudies => 'All studies';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studies created by $param';
  }

  @override
  String get studyNoneYet => 'None yet.';

  @override
  String get studyHot => 'Hot';

  @override
  String get studyDateAddedNewest => 'Date added (newest)';

  @override
  String get studyDateAddedOldest => 'Date added (oldest)';

  @override
  String get studyRecentlyUpdated => 'Recently updated';

  @override
  String get studyMostPopular => 'Most popular';

  @override
  String get studyAlphabetical => 'Alphabetical';

  @override
  String get studyAddNewChapter => 'Add a new chapter';

  @override
  String get studyAddMembers => 'Add members';

  @override
  String get studyInviteToTheStudy => 'Invite to the study';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow =>
      'Please only invite people who know you, and who actively want to join this study.';

  @override
  String get studySearchByUsername => 'Search by username';

  @override
  String get studySpectator => 'Spectator';

  @override
  String get studyContributor => 'Contributor';

  @override
  String get studyKick => 'Kick';

  @override
  String get studyLeaveTheStudy => 'Leave the study';

  @override
  String get studyYouAreNowAContributor => 'You are now a contributor';

  @override
  String get studyYouAreNowASpectator => 'You are now a spectator';

  @override
  String get studyPgnTags => 'PGN tags';

  @override
  String get studyLike => 'Like';

  @override
  String get studyUnlike => 'Unlike';

  @override
  String get studyNewTag => 'New tag';

  @override
  String get studyCommentThisPosition => 'Comment on this position';

  @override
  String get studyCommentThisMove => 'Comment on this move';

  @override
  String get studyAnnotateWithGlyphs => 'Annotate with glyphs';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'The chapter is too short to be analysed.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis =>
      'Only the study contributors can request a computer analysis.';

  @override
  String get studyGetAFullComputerAnalysis =>
      'Get a full server-side computer analysis of the mainline.';

  @override
  String get studyMakeSureTheChapterIsComplete =>
      'Make sure the chapter is complete. You can only request analysis once.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition =>
      'All SYNC members remain on the same position';

  @override
  String get studyShareChanges => 'Share changes with spectators and save them on the server';

  @override
  String get studyPlaying => 'Playing';

  @override
  String get studyShowResults => 'Results';

  @override
  String get studyShowEvalBar => 'Evaluation bars';

  @override
  String get studyNext => 'Next';

  @override
  String get studyShareAndExport => 'Share & export';

  @override
  String get studyCloneStudy => 'Clone';

  @override
  String get studyStudyPgn => 'Study PGN';

  @override
  String get studyChapterPgn => 'Chapter PGN';

  @override
  String get studyCopyChapterPgn => 'Copy PGN';

  @override
  String get studyDownloadGame => 'Download game';

  @override
  String get studyStudyUrl => 'Study URL';

  @override
  String get studyCurrentChapterUrl => 'Current chapter URL';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed =>
      'You can paste this in the forum or your Lichess blog to embed';

  @override
  String get studyStartAtInitialPosition => 'Start at initial position';

  @override
  String studyStartAtX(String param) {
    return 'Start at $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Embed in your website';

  @override
  String get studyReadMoreAboutEmbedding => 'Read more about embedding';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Only public studies can be embedded!';

  @override
  String get studyOpen => 'Open';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1, brought to you by $param2';
  }

  @override
  String get studyStudyNotFound => 'Study not found';

  @override
  String get studyEditChapter => 'Edit chapter';

  @override
  String get studyNewChapter => 'New chapter';

  @override
  String studyImportFromChapterX(String param) {
    return 'Import from $param';
  }

  @override
  String get studyOrientation => 'Orientation';

  @override
  String get studyAnalysisMode => 'Analysis mode';

  @override
  String get studyPinnedChapterComment => 'Pinned chapter comment';

  @override
  String get studySaveChapter => 'Save chapter';

  @override
  String get studyClearAnnotations => 'Clear annotations';

  @override
  String get studyClearVariations => 'Clear variations';

  @override
  String get studyDeleteChapter => 'Delete chapter';

  @override
  String get studyDeleteThisChapter => 'Delete this chapter. There is no going back!';

  @override
  String get studyClearAllCommentsInThisChapter =>
      'Clear all comments, glyphs and drawn shapes in this chapter';

  @override
  String get studyRightUnderTheBoard => 'Right under the board';

  @override
  String get studyNoPinnedComment => 'None';

  @override
  String get studyNormalAnalysis => 'Normal analysis';

  @override
  String get studyHideNextMoves => 'Hide next moves';

  @override
  String get studyInteractiveLesson => 'Interactive lesson';

  @override
  String studyChapterX(String param) {
    return 'Chapter $param';
  }

  @override
  String get studyEmpty => 'Empty';

  @override
  String get studyStartFromInitialPosition => 'Start from initial position';

  @override
  String get studyEditor => 'Editor';

  @override
  String get studyStartFromCustomPosition => 'Start from custom position';

  @override
  String get studyLoadAGameByUrl => 'Load games by URLs';

  @override
  String get studyLoadAPositionFromFen => 'Load a position from FEN';

  @override
  String get studyLoadAGameFromPgn => 'Load games from PGN';

  @override
  String get studyAutomatic => 'Automatic';

  @override
  String get studyUrlOfTheGame => 'URL of the games, one per line';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Load games from $param1 or $param2';
  }

  @override
  String get studyCreateChapter => 'Create chapter';

  @override
  String get studyCreateStudy => 'Create study';

  @override
  String get studyEditStudy => 'Edit study';

  @override
  String get studyVisibility => 'Visibility';

  @override
  String get studyPublic => 'Public';

  @override
  String get studyUnlisted => 'Unlisted';

  @override
  String get studyInviteOnly => 'Invite only';

  @override
  String get studyAllowCloning => 'Allow cloning';

  @override
  String get studyNobody => 'Nobody';

  @override
  String get studyOnlyMe => 'Only me';

  @override
  String get studyContributors => 'Contributors';

  @override
  String get studyMembers => 'Members';

  @override
  String get studyEveryone => 'Everyone';

  @override
  String get studyEnableSync => 'Enable sync';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Yes: keep everyone on the same position';

  @override
  String get studyNoLetPeopleBrowseFreely => 'No: let people browse freely';

  @override
  String get studyPinnedStudyComment => 'Pinned study comment';

  @override
  String get studyStart => 'Start';

  @override
  String get studySave => 'Save';

  @override
  String get studyClearChat => 'Clear chat';

  @override
  String get studyDeleteTheStudyChatHistory =>
      'Delete the study chat history? There is no going back!';

  @override
  String get studyDeleteStudy => 'Delete study';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Delete the entire study? There is no going back! Type the name of the study to confirm: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Where do you want to study that?';

  @override
  String get studyGoodMove => 'Good move';

  @override
  String get studyMistake => 'Mistake';

  @override
  String get studyBrilliantMove => 'Brilliant move';

  @override
  String get studyBlunder => 'Blunder';

  @override
  String get studyInterestingMove => 'Interesting move';

  @override
  String get studyDubiousMove => 'Dubious move';

  @override
  String get studyOnlyMove => 'Only move';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Equal position';

  @override
  String get studyUnclearPosition => 'Unclear position';

  @override
  String get studyWhiteIsSlightlyBetter => 'White is slightly better';

  @override
  String get studyBlackIsSlightlyBetter => 'Black is slightly better';

  @override
  String get studyWhiteIsBetter => 'White is better';

  @override
  String get studyBlackIsBetter => 'Black is better';

  @override
  String get studyWhiteIsWinning => 'White is winning';

  @override
  String get studyBlackIsWinning => 'Black is winning';

  @override
  String get studyNovelty => 'Novelty';

  @override
  String get studyDevelopment => 'Development';

  @override
  String get studyInitiative => 'Initiative';

  @override
  String get studyAttack => 'Attack';

  @override
  String get studyCounterplay => 'Counterplay';

  @override
  String get studyTimeTrouble => 'Time trouble';

  @override
  String get studyWithCompensation => 'With compensation';

  @override
  String get studyWithTheIdea => 'With the idea';

  @override
  String get studyNextChapter => 'Next chapter';

  @override
  String get studyPrevChapter => 'Previous chapter';

  @override
  String get studyStudyActions => 'Study actions';

  @override
  String get studyTopics => 'Topics';

  @override
  String get studyMyTopics => 'My topics';

  @override
  String get studyPopularTopics => 'Popular topics';

  @override
  String get studyManageTopics => 'Manage topics';

  @override
  String get studyBack => 'Back';

  @override
  String get studyPlayAgain => 'Play again';

  @override
  String get studyWhatWouldYouPlay => 'What would you play in this position?';

  @override
  String get studyYouCompletedThisLesson => 'Congratulations! You completed this lesson.';

  @override
  String studyPerPage(String param) {
    return '$param per page';
  }

  @override
  String get studyGetTheTour => 'Need help? Get the tour!';

  @override
  String get studyWelcomeToLichessStudyTitle => 'Welcome to Lichess Study!';

  @override
  String get studyWelcomeToLichessStudyText =>
      'This is a shared analysis board.<br><br>Use it to analyse and annotate games,<br>discuss positions with friends,<br>and of course for chess lessons!<br><br>It\'s a powerful tool, let\'s take some time to see how it works.';

  @override
  String get studySharedAndSaveTitle => 'Shared and saved';

  @override
  String get studySharedAndSavedText =>
      'Other members can see your moves in real time!<br>Plus, everything is saved forever.';

  @override
  String get studyStudyMembersTitle => 'Study members';

  @override
  String studyStudyMembersText(String param1, String param2) {
    return '$param1 Spectators can view the study and talk in the chat.<br><br>$param2 Contributors can make moves and update the study.';
  }

  @override
  String studyAddMembersText(String param) {
    return 'Click the $param button.<br>Then decide who can contribute or not.';
  }

  @override
  String get studyStudyChaptersTitle => 'Study chapters';

  @override
  String get studyStudyChaptersText =>
      'A study can contain several chapters.<br>Each chapter has a distinct initial position and move tree.';

  @override
  String get studyCommentPositionTitle => 'Comment on a position';

  @override
  String studyCommentPositionText(String param) {
    return 'Click the $param button, or right click on the move list on the right.<br>Comments are shared and saved.';
  }

  @override
  String get studyAnnotatePositionTitle => 'Annotate a position';

  @override
  String get studyAnnotatePositionText =>
      'Click the !? button, or a right click on the move list on the right.<br>Annotation glyphs are shared and saved.';

  @override
  String get studyConclusionTitle => 'Thanks for your time';

  @override
  String get studyConclusionText =>
      'You can find your <a href=\'/study/mine/hot\'>previous studies</a> from your profile page.<br>There is also a <a href=\'//lichess.org/blog/V0KrLSkAAMo3hsi4/study-chess-the-lichess-way\'>blog post about studies</a>.<br>Power users might want to press \"?\" to see keyboard shortcuts.<br>Have fun!';

  @override
  String get studyCreateChapterTitle => 'Let\'s create a study chapter';

  @override
  String get studyCreateChapterText =>
      'A study can have several chapters.<br>Each chapter has a distinct move tree,<br>and can be created in various ways.';

  @override
  String get studyFromInitialPositionTitle => 'From initial position';

  @override
  String get studyFromInitialPositionText =>
      'Just a board setup for a new game.<br>Suited to explore openings.';

  @override
  String get studyCustomPositionTitle => 'Custom position';

  @override
  String get studyCustomPositionText => 'Setup the board your way.<br>Suited to explore endgames.';

  @override
  String get studyLoadExistingLichessGameTitle => 'Load an existing lichess game';

  @override
  String get studyLoadExistingLichessGameText =>
      'Paste a lichess game URL<br>(like lichess.org/7fHIU0XI)<br>to load the game moves in the chapter.';

  @override
  String get studyFromFenStringTitle => 'From a FEN string';

  @override
  String get studyFromFenStringText =>
      'Paste a position in FEN format<br><i>4k3/4rb2/8/7p/8/5Q2/1PP5/1K6 w</i><br>to start the chapter from a position.';

  @override
  String get studyFromPgnGameTitle => 'From a PGN game';

  @override
  String get studyFromPgnGameText =>
      'Paste a game in PGN format.<br>to load moves, comments and variations in the chapter.';

  @override
  String get studyVariantsAreSupportedTitle => 'Studies support variants';

  @override
  String get studyVariantsAreSupportedText =>
      'Yes, you can study crazyhouse<br>and all lichess variants!';

  @override
  String get studyChapterConclusionText =>
      'Chapters are saved forever.<br>Have fun organizing your chess content!';

  @override
  String get studyDoubleDefeat => 'Double defeat';

  @override
  String get studyBlackDefeatWhiteCanNotWin => 'Black defeat, but White can\'t win';

  @override
  String get studyWhiteDefeatBlackCanNotWin => 'White defeat, but Black can\'t win';

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Chapters',
      one: '$count Chapter',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Games',
      one: '$count Game',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Members',
      one: '$count Member',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Paste games as PGN text here. For each game, a new chapter is created. The study can have up to $count chapters.',
      one: 'Paste your PGN text here, up to $count game',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'щойно';

  @override
  String get timeagoRightNow => 'зараз';

  @override
  String get timeagoCompleted => 'завершено';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'за $count секунди',
      many: 'за $count секунд',
      few: 'за $count секунди',
      one: 'за $count секунду',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'за $count хвилини',
      many: 'за $count хвилин',
      few: 'за $count хвилини',
      one: 'за $count хвилину',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'за $count години',
      many: 'за $count годин',
      few: 'за $count години',
      one: 'за $count годину',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'за $count дня',
      many: 'за $count днів',
      few: 'за $count дні',
      one: 'за $count день',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'за $count тижня',
      many: 'за $count тижнів',
      few: 'за $count тижні',
      one: 'за $count тиждень',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'за $count місяця',
      many: 'за $count місяців',
      few: 'за $count місяці',
      one: 'за $count місяць',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'за $count року',
      many: 'за $count років',
      few: 'за $count роки',
      one: 'за $count рік',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хвилини тому',
      many: '$count хвилин тому',
      few: '$count хвилини тому',
      one: '$count хвилину тому',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count години тому',
      many: '$count годин тому',
      few: '$count години тому',
      one: '$count годину тому',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня тому',
      many: '$count днів тому',
      few: '$count дні тому',
      one: '$count день тому',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тижня тому',
      many: '$count тижнів тому',
      few: '$count тижні тому',
      one: '$count тиждень тому',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count місяця тому',
      many: '$count місяців тому',
      few: '$count місяці тому',
      one: '$count місяць тому',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count року тому',
      many: '$count років тому',
      few: '$count роки тому',
      one: '$count рік тому',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'залишилося $count хвилини',
      many: 'залишилося $count хвилин',
      few: 'залишилося $count хвилини',
      one: 'залишилася $count хвилина',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'залишилося $count години',
      many: 'залишилося $count годин',
      few: 'залишилося $count години',
      one: 'залишилася $count година',
    );
    return '$_temp0';
  }
}
