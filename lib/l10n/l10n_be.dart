import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Belarusian (`be`).
class AppLocalizationsBe extends AppLocalizations {
  AppLocalizationsBe([String locale = 'be']) : super(locale);

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
  String get activityActivity => 'Актыўнасць';

  @override
  String get activityHostedALiveStream => 'Правялі прамую трансляцыю';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Скончыў на $param1 месцы ў $param2';
  }

  @override
  String get activitySignedUp => 'Зарэгістраваўся на lichess';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Падтрымаў lichess.org на $count месяцаў як $param2',
      many: 'Падтрымаў lichess.org на $count месяцаў як $param2',
      few: 'Падтрымаў lichess.org на $count месяцы як $param2',
      one: 'Падтрымаў lichess.org на $count месяц як $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Практыкаваны пазіцыі $count у $param2',
      many: 'Практыкаваны пазіцыі $count у $param2',
      few: 'Практыкаваны пазіцыі $count у $param2',
      one: 'Практыкавана пазіцыя $count у $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вырашана $count задач',
      many: 'Вырашана $count задач',
      few: 'Вырашана $count задач',
      one: 'Вырашана $count задача',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Згуляна $count гульняў у $param2',
      many: 'Згуляна $count гульняў у $param2',
      few: 'Згуляна $count гульняў у $param2',
      one: 'Згуляна $count гульня ў $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Апублікавана $count паведамленняў у $param2',
      many: 'Апублікавана $count паведамленняў у $param2',
      few: 'Апублікавана $count паведамленняў у $param2',
      one: 'Апублікавана $count паведамленне ў $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Згуляна $count хадоў',
      many: 'Згуляна $count хадоў',
      few: 'Згуляна $count хады',
      one: 'Згуляны $count ход',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'у $count гульнях па ліставанні',
      many: 'у $count гульнях па ліставанні',
      few: 'у $count гульнях па ліставанні',
      one: 'у $count гульні па ліставанні',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Згуляна $count гульняў па ліставанні',
      many: 'Згуляна $count гульняў па ліставанні',
      few: 'Згуляна $count гульні па ліставанні',
      one: 'Згуляна $count гульня па ліставанні',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Падпісаўся на $count гульцоў',
      many: 'Падпісаўся на $count гульцоў',
      few: 'Падпісаўся на $count гульцоў',
      one: 'Падпісаўся на $count гульца',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count новых падпісчыкаў',
      many: '$count новых падпісчыкаў',
      few: '$count новых падпісчыкі',
      one: '$count новы падпісчык',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Правёў $count сеансаў адначасовай гульні',
      many: 'Правёў $count сеансаў адначасовай гульні',
      few: 'Правёў $count сеансы адначасовай гульні',
      one: 'Правёў $count сеанс адначасовай гульні',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Браў удзел у $count сеансах адначасовай гульні',
      many: 'Браў удзел у $count сеансах адначасовай гульні',
      few: 'Браў удзел у $count сеансах адначасовай гульні',
      one: 'Браў удзел у $count сеансе адначасовай гульні',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Стварыў $count новых даследаванняў',
      many: 'Стварыў $count новых даследаванняў',
      few: 'Стварыў $count новыя даследаванні',
      one: 'Стварыў $count новае даследаванне',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Паўдзельнічаў у $count турнірах',
      many: 'Паўдзельнічаў у $count турнірах',
      few: 'Паўдзельнічаў у $count турнірах',
      one: 'Паўдзельнічаў у $count турніры',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Заняў $count месца (лепшыя $param2%) турніру $param4, узяўшы ўдзел у $param3 гульнях',
      many: 'Заняў $count месца (лепшыя $param2%) турніру $param4, узяўшы ўдзел у $param3 гульнях',
      few: 'Заняў $count месца (лепшыя $param2%) турніру $param4, узяўшы ўдзел у $param3 гульнях',
      one: 'Заняў $count месца (лепшыя $param2%) турніру $param4, узяўшы ўдзел у $param3 гульні',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Паўдзельнічаў(-ла) у $count турнірах па швейцырскай сістэме',
      many: 'Паўдзельнічаў(-ла) у $count турнірах па швейцырскай сістэме',
      few: 'Паўдзельнічаў(-ла) у $count турнірах па швейцырскай сістэме',
      one: 'Паўдзельнічаў(-ла) у $count турніры па швейцарскай сістэме',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Далучыўся да $count каманд',
      many: 'Далучыўся да $count каманд',
      few: 'Далучыўся да $count каманд',
      one: 'Далучыўся да $count каманды',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Трансляцыі';

  @override
  String get broadcastLiveBroadcasts => 'Прамыя трансляцыі турніраў';

  @override
  String challengeChallengesX(String param1) {
    return 'Выклікаў: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Выклікаць на гульню';

  @override
  String get challengeChallengeDeclined => 'Выклік адхілены';

  @override
  String get challengeChallengeAccepted => 'Выклік прыняты!';

  @override
  String get challengeChallengeCanceled => 'Выклік скасаваны.';

  @override
  String get challengeRegisterToSendChallenges => 'Зарэгіструйцеся, каб выклікаць супернікаў на гульню.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Вы не можаце выклікаць на гульню $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param не прымае выклікі.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Ваш рэйтынг у рэжыме «$param1» значна адрозніваецца ад $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Не магчыма выклікаць на гульню з умоўным $param рэйтынгам.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param прымае выклікі толькі ад сяброў.';
  }

  @override
  String get challengeDeclineGeneric => 'Не прымаю выклікі на дадзены момант.';

  @override
  String get challengeDeclineLater => 'Гэта ня зрычны час для мяне, калі ласка, спытайцеся пазней.';

  @override
  String get challengeDeclineTooFast => 'Гэты кантроль часу занадта хуткі для мяне, калі ласка, выклічце зноў на больш павольную гульню.';

  @override
  String get challengeDeclineTooSlow => 'Гэты кантроль часу занадта павольны для мяне, калі ласка, выклічце зноў на больш хуткую гульню.';

  @override
  String get challengeDeclineTimeControl => 'Не прымаю выклікі з гэтым кантролем часу.';

  @override
  String get challengeDeclineRated => 'Калі ласка, прышлі рэйтынгавы выклік замест гэтага.';

  @override
  String get challengeDeclineCasual => 'Калі ласка, замест дашліце таварыскі выклік.';

  @override
  String get challengeDeclineStandard => 'Не прымаю выклікі ў некласічныя шахматы на дадзены момант.';

  @override
  String get challengeDeclineVariant => 'Я ня хочу граць гэты варыянт зараз.';

  @override
  String get challengeDeclineNoBot => 'Я не прымаю выклікі ад ботаў.';

  @override
  String get challengeDeclineOnlyBot => 'Я прымаю выклікі толькі ад ботаў.';

  @override
  String get challengeInviteLichessUser => 'Ці запрасіце карыстальніка Lichess:';

  @override
  String get contactContact => 'Звязацца';

  @override
  String get contactContactLichess => 'Звязацца з Lichess';

  @override
  String get patronDonate => 'Ахвяраваць';

  @override
  String get patronLichessPatron => 'Спонсар Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Статыстыка $param';
  }

  @override
  String get perfStatViewTheGames => 'Праглядзець гульні';

  @override
  String get perfStatProvisional => 'умоўны';

  @override
  String get perfStatNotEnoughRatedGames => 'Не было згуляна дастаткова рэйтынгавых гульняў, каб усталяваць дакладны рэйтынг.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Прагрэс за апошнія $param гульняў:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Адхіленне рэйтынгу: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Чым ніжэй значэнне, тым больш усталяваным з\'яўляецца рэйтынг. Рэйтынг вышэйшы за $param1, лічыцца ўмоўным. Каб быць уключаным у спісы рэйтынгу, гэта значэнне павінна быць ніжэй за $param2 (звычайныя шахматы) або $param3 (варыянты).';
  }

  @override
  String get perfStatTotalGames => 'Агулам гульняў';

  @override
  String get perfStatRatedGames => 'Рэйтынгавыя гульні';

  @override
  String get perfStatTournamentGames => 'Гульні ў турнірах';

  @override
  String get perfStatBerserkedGames => 'Гульні з бярсеркам';

  @override
  String get perfStatTimeSpentPlaying => 'Агульны час за гульнёй';

  @override
  String get perfStatAverageOpponent => 'Сярэдні рэйтынг суперніка';

  @override
  String get perfStatVictories => 'Перамогі';

  @override
  String get perfStatDefeats => 'Паразы';

  @override
  String get perfStatDisconnections => 'Адключэнні';

  @override
  String get perfStatNotEnoughGames => 'Згуляна недастаткова партый';

  @override
  String perfStatHighestRating(String param) {
    return 'Найвышэйшы рэйтынг: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Найніжэйшы рэйтынг: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'ад $param1 да $param2';
  }

  @override
  String get perfStatWinningStreak => 'Перамог запар';

  @override
  String get perfStatLosingStreak => 'Паразаў запар';

  @override
  String perfStatLongestStreak(String param) {
    return 'Найдаўжэйшая серыя: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Бягучая серыя: $param';
  }

  @override
  String get perfStatBestRated => 'Найлепшыя рэйтынгавыя перамогі';

  @override
  String get perfStatGamesInARow => 'Гульняў сыграна запар';

  @override
  String get perfStatLessThanOneHour => 'Менш за гадзіну паміж гульнямі';

  @override
  String get perfStatMaxTimePlaying => 'Максімальны час за гульнёй';

  @override
  String get perfStatNow => 'зараз';

  @override
  String get preferencesPreferences => 'Налады';

  @override
  String get preferencesDisplay => 'Адлюстраванне';

  @override
  String get preferencesPrivacy => 'Прыватнасць';

  @override
  String get preferencesNotifications => 'Апавяшчэнні';

  @override
  String get preferencesPieceAnimation => 'Анімацыя фігур';

  @override
  String get preferencesMaterialDifference => 'Паказваць розніцу ў фігурах';

  @override
  String get preferencesBoardHighlights => 'Падсвечваць апошні ход і шах';

  @override
  String get preferencesPieceDestinations => 'Паказваць дапушчальныя хады';

  @override
  String get preferencesBoardCoordinates => 'Каардынаты дошкі';

  @override
  String get preferencesMoveListWhilePlaying => 'Паказваць спіс рухаў пад час гульні';

  @override
  String get preferencesPgnPieceNotation => 'Натацыя рухаў';

  @override
  String get preferencesChessPieceSymbol => 'Сымбаль шахматнай фігуры';

  @override
  String get preferencesPgnLetter => 'Літара (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Рэжым Дзэн';

  @override
  String get preferencesShowPlayerRatings => 'Паказваць рэйтынг гульцоў';

  @override
  String get preferencesShowFlairs => 'Паказваць эмодзі гульцоў';

  @override
  String get preferencesExplainShowPlayerRatings => 'Гэта дазваляе схаваць усе рэйтынгі на сайце, каб дапамагчы сканцэнтравацца на шахматах. Гульні ўсё яшчэ могуць быць рэйтынгавымі, змены адбудуцца толькі візуальныя.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Паказваць ручку змены памеру дошкі';

  @override
  String get preferencesOnlyOnInitialPosition => 'Толькі ў пачатковым становішчы';

  @override
  String get preferencesInGameOnly => 'Выключна ў партыі';

  @override
  String get preferencesChessClock => 'Шахматны гадзіннік';

  @override
  String get preferencesTenthsOfSeconds => 'Дзясятыя долі секунды';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Калі засталося менш за 10 с';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Індыкатар часу';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Гукавое апавяшчэнне калі час хутка скончыцца';

  @override
  String get preferencesGiveMoreTime => 'Дадаць часу';

  @override
  String get preferencesGameBehavior => 'Гульнявыя паводзіны';

  @override
  String get preferencesHowDoYouMovePieces => 'Як вы перасоўваеце фігуры?';

  @override
  String get preferencesClickTwoSquares => 'Націскам на дзве клеткі';

  @override
  String get preferencesDragPiece => 'Перацягваннем фігуры';

  @override
  String get preferencesBothClicksAndDrag => 'Абодвума спосабамі';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Ход на апярэджанне (падчас ходу суперніка)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Скасаванні ходу (са згоды суперніка)';

  @override
  String get preferencesInCasualGamesOnly => 'Толькі ў таварыскіх гульнях';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Аўтаматычна пераўтвараць пешку ў ферзя';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Зацісніце клавішу <ctrl> пад час пераўтварэння, каб часова адключыць аўта-пераўтварэнне';

  @override
  String get preferencesWhenPremoving => 'Пры ходзе на апярэджанне';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Аўтаматычна запытваць нічыю пры трохразовым паўторы ходу';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Калі застаецца < 30 секунд';

  @override
  String get preferencesMoveConfirmation => 'Пацверджанне руху';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Можа быць адключана падчас гульні з дапамогай меню дошкі';

  @override
  String get preferencesInCorrespondenceGames => 'У гульні па ліставанні';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Па ліставанні і без абмежавання часу';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Пацвярджаць здаччу і прапановы нічый';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Спосаб ракіроўкі';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Караля на дзьве клеткі';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Караля перасунуць на ладдзю';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Уводзіць хады з дапамогай клавіятуры';

  @override
  String get preferencesInputMovesWithVoice => 'Уводзьце хады вашым голасам';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Маляваць стрэлки толькі да магчымых хадоў';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Казаць \"Good game, well played\" пасля паразы або нічыі';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Вашы налады былі захаваныя.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Гартайце колцам мышцы на дошцы, каб прагледзець хады';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Штодзённае апавяшчэнне па пошце з пералікам вашых гульняў па ліставанні';

  @override
  String get preferencesNotifyStreamStart => 'Стрымер вядзе трансляцыю';

  @override
  String get preferencesNotifyInboxMsg => 'Новае паведамленне';

  @override
  String get preferencesNotifyForumMention => 'Каментарый на форуме закранае Вас';

  @override
  String get preferencesNotifyInvitedStudy => 'Запрашэнне на ўрок';

  @override
  String get preferencesNotifyGameEvent => 'Абнаўленне ў гульні па перапісцы';

  @override
  String get preferencesNotifyChallenge => 'Выклікі';

  @override
  String get preferencesNotifyTournamentSoon => 'У хуткім часе пачынаецца турнір';

  @override
  String get preferencesNotifyTimeAlarm => 'Час зыходзіць у гульні па перепісцы';

  @override
  String get preferencesNotifyBell => 'Гукавое паведамленне ад Lichess';

  @override
  String get preferencesNotifyPush => 'Паведамленне на прыладу, калі Вы не на Lichess';

  @override
  String get preferencesNotifyWeb => 'Браўзер';

  @override
  String get preferencesNotifyDevice => 'Прылада';

  @override
  String get preferencesBellNotificationSound => 'Гукавое паведамленне';

  @override
  String get puzzlePuzzles => 'Задачы';

  @override
  String get puzzlePuzzleThemes => 'Тэмы задач';

  @override
  String get puzzleRecommended => 'Рэкамендаваныя';

  @override
  String get puzzlePhases => 'Стадыі гульні';

  @override
  String get puzzleMotifs => 'Матывы';

  @override
  String get puzzleAdvanced => 'Прасунутыя';

  @override
  String get puzzleLengths => 'Колькасць хадоў';

  @override
  String get puzzleMates => 'Маты';

  @override
  String get puzzleGoals => 'Мэты';

  @override
  String get puzzleOrigin => 'Паходжанне';

  @override
  String get puzzleSpecialMoves => 'Адмысловыя хады';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ці спадабалася задача?';

  @override
  String get puzzleVoteToLoadNextOne => 'Прагаласуйце, каб перайсці да наступнай!';

  @override
  String get puzzleUpVote => 'Задача спадабалася';

  @override
  String get puzzleDownVote => 'Задача не спадабалася';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Ваш рэйтынг задач не зменіцца. Заўважце, што задачы гэта не спаборніцтва. Рэйтынг дапамагае абіраць найлепшыя задачы для вашага бягучага ўзроўню.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Знайдзіце найлепшы ход белых.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Знайдзіце найлепшы ход чорных.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Каб атрымаць персаналізаваныя задачы:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Задача $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Задача дня';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Націсніце, каб рашыць';

  @override
  String get puzzleGoodMove => 'Добры ход';

  @override
  String get puzzleBestMove => 'Найлепшы ход!';

  @override
  String get puzzleKeepGoing => 'Працягвайце…';

  @override
  String get puzzlePuzzleSuccess => 'Поспех!';

  @override
  String get puzzlePuzzleComplete => 'Задача вырашана!';

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
  String get puzzleNotTheMove => 'Гэта не той ход!';

  @override
  String get puzzleTrySomethingElse => 'Паспрабуйце нешта іншае.';

  @override
  String puzzleRatingX(String param) {
    return 'Рэйтынг: $param';
  }

  @override
  String get puzzleHidden => 'схаваны';

  @override
  String puzzleFromGameLink(String param) {
    return 'З гульні $param';
  }

  @override
  String get puzzleContinueTraining => 'Працягнуць трэніроўку';

  @override
  String get puzzleDifficultyLevel => 'Узровень складанасці';

  @override
  String get puzzleNormal => 'Нармальны';

  @override
  String get puzzleEasier => 'Лёгкі';

  @override
  String get puzzleEasiest => 'Найлягчэйшы';

  @override
  String get puzzleHarder => 'Цяжкі';

  @override
  String get puzzleHardest => 'Найцяжэйшы';

  @override
  String get puzzleExample => 'Прыклад';

  @override
  String get puzzleAddAnotherTheme => 'Дадаць іншую тэму';

  @override
  String get puzzleNextPuzzle => 'Наступная задача';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Адразу перайсці да наступнай задачы';

  @override
  String get puzzlePuzzleDashboard => 'Панэль задач';

  @override
  String get puzzleImprovementAreas => 'Напрамкі паляпшэння';

  @override
  String get puzzleStrengths => 'Моцныя бакі';

  @override
  String get puzzleHistory => 'Гісторыя задач';

  @override
  String get puzzleSolved => 'вырашана правільна';

  @override
  String get puzzleFailed => 'памылка';

  @override
  String get puzzleStreakDescription => 'Вырашайце патупова ўскладняючыеся задачы і стварыце пераможную серыю. Тут няма гадзінніку, таму не спяшайцеся. Адзін няправільны ход і гульня скончана! Але можна прапусціць адзін ход за спробу.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Ваша серыя: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Прапусціце гэты ход, каб захаваць серыю! Можна скарыстаць толькі адзін раз.';

  @override
  String get puzzleContinueTheStreak => 'Працягнуць серыю';

  @override
  String get puzzleNewStreak => 'Новая серыя';

  @override
  String get puzzleFromMyGames => 'З маіх гульняў';

  @override
  String get puzzleLookupOfPlayer => 'Шукаць задачы з партый гульца';

  @override
  String puzzleFromXGames(String param) {
    return 'Задачы з гульняў $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Шукаць задачы';

  @override
  String get puzzleFromMyGamesNone => 'Базе дадзеных няма задач з вашых гульня, але Liches усе роўна любіць вас!\nПагуляйце ў хуткія або класічныя шахматы каб павялічыць шанец выкарыстання вашых гульняў у задачах.';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Знойдзена $param1 задач ў $param2 гульнях';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Трэніруйцеся, аналізуйце, паляпшайцеся';

  @override
  String puzzlePercentSolved(String param) {
    return '$param вырашана правільна';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Нічога няма, вырашыце некалькі задач спачатку!';

  @override
  String get puzzleImprovementAreasDescription => 'Трэніруйце гэта, каб палепшыць прагрэс!';

  @override
  String get puzzleStrengthDescription => 'Найбольш атрымоўваюцца гэтыя тэмы';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Згуляна $count разоў',
      many: 'Згуляна $count разоў',
      few: 'Згуляна $count разы',
      one: 'Згуляна $count раз',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count балаў менш за ваш рэйтынг задач',
      many: '$count балаў менш за ваш рэйтынг задач',
      few: '$count бала менш за ваш рэйтынг задач',
      one: 'Адзін бал менш за ваш рэйтынг задач',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count балаў вышэй за ваш рэйтынг задач',
      many: '$count балаў вышэй за ваш рэйтынг задач',
      few: '$count бала вышэй за ваш рэйтынг задач',
      one: 'Адзін бал вышэй за ваш рэйтынг задач',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вырашана',
      many: '$count вырашана',
      few: '$count вырашаны',
      one: '$count вырашана',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count перарашаць',
      many: '$count перарашаць',
      few: '$count перарашаць',
      one: '$count перарашаць',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Далёка прасунутая пешка';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Адна з вашых пешак глыбока ў пазіцыі суперніка, магчыма пагражае ператварэннем.';

  @override
  String get puzzleThemeAdvantage => 'Перавага';

  @override
  String get puzzleThemeAdvantageDescription => 'Не ўпусціце шанец, каб атрымаць вырашальную перавагу. (200сп ≤ ацэнка ≤ 600сп)';

  @override
  String get puzzleThemeAnastasiaMate => 'Мат Анастасіі';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Конь і ладдзя (ці ферзь) працуюць разам, каб заматаваць караля суперніка паміж сваёй фігурай і краем дошкі.';

  @override
  String get puzzleThemeArabianMate => 'Арабскі мат';

  @override
  String get puzzleThemeArabianMateDescription => 'Конь і ладдзя працуюць разам, каб заматаваць караля суперніка ў кутку дошкі.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Напад на f2 або f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Нападзенне, накіраванае на пешку на f2 або f7, як у дэбюце Атакі Фегатэлла.';

  @override
  String get puzzleThemeAttraction => 'Прыцягненне';

  @override
  String get puzzleThemeAttractionDescription => 'Абмен або ахвяра, якая заахвочвае або прымушае фігуру суперніка выйсці на поле, што дазваляе здейсніць тактыку.';

  @override
  String get puzzleThemeBackRankMate => 'Мат на апошняй гарызанталі';

  @override
  String get puzzleThemeBackRankMateDescription => 'Пастаўце мат каралю на хатняй гарызанталі, калі ён заблакаваны сваімі фігурамі.';

  @override
  String get puzzleThemeBishopEndgame => 'Слановы эндшпіль';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Эндшпіль выключна са сланамі і пешкамі.';

  @override
  String get puzzleThemeBodenMate => 'Мат Бодэна';

  @override
  String get puzzleThemeBodenMateDescription => 'Два нападаючых слана па перакрыжаваных дыяганалях матуюць караля, які акружаны сваімі фігурамі.';

  @override
  String get puzzleThemeCastling => 'Ракіроўка';

  @override
  String get puzzleThemeCastlingDescription => 'Адпраўце караля ў бяспеку і выведзіце ладдзю ў атаку.';

  @override
  String get puzzleThemeCapturingDefender => 'Узяцце абаронцы';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Адцягненне або ўзяцце фігуры, якая з\'яўляца крытычнай для абароны іншай фігуры, што дазваляе ўзяце неабароненую фігуру наступным ходам.';

  @override
  String get puzzleThemeCrushing => 'Зруйнаванне';

  @override
  String get puzzleThemeCrushingDescription => 'Знайдзіце позех суперніка і атрымайце разгромную перавагу. (ацэнка ≥ 600сп)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Мат двума сланамі';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Два нападаючых слана на суседніх дыяганалях матуюць караля, які акружаны сваімі фігурамі.';

  @override
  String get puzzleThemeDovetailMate => 'Мат \"галубіны хвост\"';

  @override
  String get puzzleThemeDovetailMateDescription => 'Ферзь ставіць мат сумежнаму каралю, адзіныя два палі адыхода якога заняты яго ж фігурамі.';

  @override
  String get puzzleThemeEquality => 'Выраўненне';

  @override
  String get puzzleThemeEqualityDescription => 'Адыграйцеся з прайгранай пазіцыі і забяспечце нічыйную або збалансаваную пазіцыю. (ацэнка пазіціі ≤ 200сп)';

  @override
  String get puzzleThemeKingsideAttack => 'Атака на каралеўскім флангу';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Атака на караля суперніка, пасля ягонай кароткай ракіроўкі.';

  @override
  String get puzzleThemeClearance => 'Расчыстка поля';

  @override
  String get puzzleThemeClearanceDescription => 'Ход, часта з тэмпам, які расчышчае поле, лінію або дыяганал для паследуючай тактыкі.';

  @override
  String get puzzleThemeDefensiveMove => 'Абарончы ход';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Дакладны ход або паслядоўнасць хадоў, неабходная каб пазбегнуць страты матэрыялу або іншай перавагі.';

  @override
  String get puzzleThemeDeflection => 'Адцягненне';

  @override
  String get puzzleThemeDeflectionDescription => 'Ход, які адцягвае фігуру суперніка ад выканання іншага абавязку, напрыклад, аховы ключавога поля. Часам таксама называецца \"перагрузка\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ўскрыты напад';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Ход фігурай (напрыклад канём), якая раней блакавала фігуру далёкага дзеяння (напрыклад ладдзю), з лініі нападу гэтай фігуры.';

  @override
  String get puzzleThemeDoubleCheck => 'Падвойны шах';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Шах дзвюма фігурамі адначасова, у выніку ўскрытыга нападу, калі і фігура, якая ходзіць, і раскрытая фігура атакуюць караля суперніка.';

  @override
  String get puzzleThemeEndgame => 'Эндшпіль';

  @override
  String get puzzleThemeEndgameDescription => 'Тактыка на апошнім этапе гульні.';

  @override
  String get puzzleThemeEnPassantDescription => 'Задача звязаная з \"узяццем на праходзе\", дзе пешка можа ўзяць пешку суперніка, якая прайшла побач, выкарыстоўвыючы першы ход на два палі.';

  @override
  String get puzzleThemeExposedKing => 'Адкрыты кароль';

  @override
  String get puzzleThemeExposedKingDescription => 'Тактыка, уключаючая недастаткова абароненага караля, якая часта скончваецца матам.';

  @override
  String get puzzleThemeFork => 'Відэлец';

  @override
  String get puzzleThemeForkDescription => 'Ход, калі фігура, якой пахадзілі, нападае адразу на дзве фігуры суперніка.';

  @override
  String get puzzleThemeHangingPiece => 'Вісячая фігура';

  @override
  String get puzzleThemeHangingPieceDescription => 'Тактыка, уключаючая неабароненую фігуру суперніка ці недастатковую колькасць яе абаронцоў, якую можна з\'есці.';

  @override
  String get puzzleThemeHookMate => 'Хук-мат';

  @override
  String get puzzleThemeHookMateDescription => 'Мат ладдзёй, канём і пешкай разам з дапамогай адной пешкай суперніка, абмяжоўваючай адыход варожага караля.';

  @override
  String get puzzleThemeInterference => 'Перакрыццё';

  @override
  String get puzzleThemeInterferenceDescription => 'Перамяшчэнне фігуры паміж дзвюма фігурамі суперніка, каб адна або абедзве фігуры суперніка засталіся без абароны, напрыклад, конь на абароненым полі паміж дзвюма ладдзямі.';

  @override
  String get puzzleThemeIntermezzo => 'Прамежкавы ход';

  @override
  String get puzzleThemeIntermezzoDescription => 'Замест чаканага хода, спачатку зрабіце іншы ход, ствараючы непасрэдную пагрозу, на якую супернік павінен адказаць. Таксама вядомы як \"Zwischenzug\" або \"Intermezzo\".';

  @override
  String get puzzleThemeKnightEndgame => 'Канёвы эндшпіль';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Эндшпіль выключна з канямі і пешкамі.';

  @override
  String get puzzleThemeLong => 'Доўгая задача';

  @override
  String get puzzleThemeLongDescription => 'Да перамогі 3 хады.';

  @override
  String get puzzleThemeMaster => 'Гульні майстроў';

  @override
  String get puzzleThemeMasterDescription => 'Задачы з гульняў тытулаваных гульцоў.';

  @override
  String get puzzleThemeMasterVsMaster => 'З гульняў майстроў';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Задачы з гульняў паміж тытулаванымі гульцамі.';

  @override
  String get puzzleThemeMate => 'Мат';

  @override
  String get puzzleThemeMateDescription => 'Выйграйце стылёва.';

  @override
  String get puzzleThemeMateIn1 => 'Мат у 1 ход';

  @override
  String get puzzleThemeMateIn1Description => 'Пастаўце мат у адзін ход.';

  @override
  String get puzzleThemeMateIn2 => 'Мат у 2 хады';

  @override
  String get puzzleThemeMateIn2Description => 'Пастаўце мат у два хады.';

  @override
  String get puzzleThemeMateIn3 => 'Мат у 3 хады';

  @override
  String get puzzleThemeMateIn3Description => 'Пастаўце мат у тры хады.';

  @override
  String get puzzleThemeMateIn4 => 'Мат у 4 хады';

  @override
  String get puzzleThemeMateIn4Description => 'Пастаўце мат у чатыры хады.';

  @override
  String get puzzleThemeMateIn5 => 'Мат у 5 хадоў';

  @override
  String get puzzleThemeMateIn5Description => 'Знайдзіце доўгую матавую паслядоўнасць.';

  @override
  String get puzzleThemeMiddlegame => 'Мітальшпіль';

  @override
  String get puzzleThemeMiddlegameDescription => 'Тактыка на другім этапе гульні.';

  @override
  String get puzzleThemeOneMove => 'Аднахадовая задача';

  @override
  String get puzzleThemeOneMoveDescription => 'Задача ў адзін ход.';

  @override
  String get puzzleThemeOpening => 'Дэбют';

  @override
  String get puzzleThemeOpeningDescription => 'Тактыка на першым этапе гульні.';

  @override
  String get puzzleThemePawnEndgame => 'Пешачны эндшпіль';

  @override
  String get puzzleThemePawnEndgameDescription => 'Эндшпіль выключна з пешкамі.';

  @override
  String get puzzleThemePin => 'Звязка';

  @override
  String get puzzleThemePinDescription => 'Тактыка, уключаючая звязкі, дзе фігура не можа рухацца, не дазволіўшы нападзенне на больш каштоўную фігуру.';

  @override
  String get puzzleThemePromotion => 'Ператварэнне пешкі';

  @override
  String get puzzleThemePromotionDescription => 'Ператварыцце адну з пешак ў ферзя або легкую фігуру.';

  @override
  String get puzzleThemeQueenEndgame => 'Ферзевы эндшпіль';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Эндшпіль выключна з ферзмі і пешкамі.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Ферзева-ладдзейны эндшпіль';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Эндшпіль выключна з ферзямі, ладдзямі і пешкамі.';

  @override
  String get puzzleThemeQueensideAttack => 'Атака на ферзевам флангу';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Атака на караля суперніка, пасля ягонай доўгай ракіроўкі.';

  @override
  String get puzzleThemeQuietMove => 'Павольны ход';

  @override
  String get puzzleThemeQuietMoveDescription => 'Ход, які не робіць не шах, не збівае штосьці, не стварае непасрэднай пагрозы, але рыхтуе схваную немянуючую пагрозу для наступных хадоў.';

  @override
  String get puzzleThemeRookEndgame => 'Ладзейны эндшпіль';

  @override
  String get puzzleThemeRookEndgameDescription => 'Эндшпіль выключна з ладдзямі і пешкамі.';

  @override
  String get puzzleThemeSacrifice => 'Ахвяра';

  @override
  String get puzzleThemeSacrificeDescription => 'Тактыка, уключаючая кароткатэрміновае ахвяраванне матэрыялу, дзеля атрымання перавагі пасля вымушанай паслядоўнасці хадоў.';

  @override
  String get puzzleThemeShort => 'Кароткая задача';

  @override
  String get puzzleThemeShortDescription => 'Да перамогі 2 хады.';

  @override
  String get puzzleThemeSkewer => 'Скразны ўдар';

  @override
  String get puzzleThemeSkewerDescription => 'Матыў, уключаючы напад на каштоўную фігуру, якая сыходзячы з лініі нападу, дазваляе збіць або атакаваць стаячую ззаду менш каштоўную фігуры ззаду, адваротная звязка.';

  @override
  String get puzzleThemeSmotheredMate => 'Спёрты мат';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Мат пастаўленны канём, калі заматаваны кароль не можа рухацца, бо акружаны (ці запёрты) сваімі фігурамі.';

  @override
  String get puzzleThemeSuperGM => 'Партыі супергросмайстраў';

  @override
  String get puzzleThemeSuperGMDescription => 'Задачы з партый найлепшых гульцоў у свеце.';

  @override
  String get puzzleThemeTrappedPiece => 'Фігура ў пастцы';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Фігура не можа пазбегнуць збіцця, бо абмежавана ў хадах.';

  @override
  String get puzzleThemeUnderPromotion => 'Слабае пераўтварэнне';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Пераўтварэнне пешкі ў каня, слана або ладдзю.';

  @override
  String get puzzleThemeVeryLong => 'Вельмі доўгая задача';

  @override
  String get puzzleThemeVeryLongDescription => 'Чатыры або больш хадоў да перамогі.';

  @override
  String get puzzleThemeXRayAttack => 'Рэнтген';

  @override
  String get puzzleThemeXRayAttackDescription => 'Фігара нападае або бараніць поле праз варожую фігуру.';

  @override
  String get puzzleThemeZugzwang => 'Цугцванг';

  @override
  String get puzzleThemeZugzwangDescription => 'Супернік абмежаваны ў хадах і ўсе магчымыя хады пагаршаюць яго пазіцыю.';

  @override
  String get puzzleThemeHealthyMix => 'Здаровая сумесь';

  @override
  String get puzzleThemeHealthyMixDescription => 'Патрошкі ўсяго. Вы ня ведаеце чаго чакаць, таму гатовы да ўсяго! Як у сапраўдных гульнях.';

  @override
  String get puzzleThemePlayerGames => 'З партый гульца';

  @override
  String get puzzleThemePlayerGamesDescription => 'Праглядзіце задачы ўзятыя з вашых гульняў, ці з партый іншага гульца.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Гэта публічныя задачы, іх магчыма спампаваць з $param.';
  }

  @override
  String get searchSearch => 'Пошук';

  @override
  String get settingsSettings => 'Налады';

  @override
  String get settingsCloseAccount => 'Выдаліць уліковы запіс';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Your account is managed, and cannot be closed.';

  @override
  String get settingsClosingIsDefinitive => 'Зачыненне немагчыма будзе адмяніць. Не будзе шляху назад. Вы ўпэўнены?';

  @override
  String get settingsCantOpenSimilarAccount => 'Вам не будзе дазволена стварыць новы ўліковы запіс з тым жа імем, нават калі рэгістр сімвалаў адрозніваецца.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Я перадумаў, не выдаляйце мой уліковы запіс';

  @override
  String get settingsCloseAccountExplanation => 'Вы сапраўды хочаце выдаліць свой уліковы запіс? Гэта неадваротнае дзеянне: увайсці ў яго будзе немагчыма.';

  @override
  String get settingsThisAccountIsClosed => 'Гэты ўліковы запіс зачынены.';

  @override
  String get playWithAFriend => 'Гуляць з сябрам';

  @override
  String get playWithTheMachine => 'Гуляць з камп\'ютарам';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Выкарыстайце гэтую спасылку каб запрасіць кагосьці да гульні';

  @override
  String get gameOver => 'Гульня скончана';

  @override
  String get waitingForOpponent => 'Чакаем апанента';

  @override
  String get orLetYourOpponentScanQrCode => 'Або дазвольце апаненту адсканаваць гэты QR-код';

  @override
  String get waiting => 'Чакаем';

  @override
  String get yourTurn => 'Ваша чарга';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 узровень $param2';
  }

  @override
  String get level => 'Узровень';

  @override
  String get strength => 'Сіла';

  @override
  String get toggleTheChat => 'Уключыць/выключыць чат';

  @override
  String get chat => 'Чат';

  @override
  String get resign => 'Здацца';

  @override
  String get checkmate => 'Мат';

  @override
  String get stalemate => 'Пат';

  @override
  String get white => 'Белыя';

  @override
  String get black => 'Чорныя';

  @override
  String get asWhite => 'за белых';

  @override
  String get asBlack => 'за чорных';

  @override
  String get randomColor => 'Выпадковая старана';

  @override
  String get createAGame => 'Стварыць гульню';

  @override
  String get whiteIsVictorious => 'Белыя перамаглі';

  @override
  String get blackIsVictorious => 'Чорныя перамаглі';

  @override
  String get youPlayTheWhitePieces => 'Вы гуляеце белымі фігурамі';

  @override
  String get youPlayTheBlackPieces => 'Вы гуляеце чорнымі фігурамі';

  @override
  String get itsYourTurn => 'Зараз ваш ход!';

  @override
  String get cheatDetected => 'Выяўлена несумленная гульня';

  @override
  String get kingInTheCenter => 'Кароль у цэнтры';

  @override
  String get threeChecks => 'Тры шахі';

  @override
  String get raceFinished => 'Гонка скончаная';

  @override
  String get variantEnding => 'Канчатковы варыянт';

  @override
  String get newOpponent => 'Новы супернік';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Супернік хоча згуляць з вамі ізноў';

  @override
  String get joinTheGame => 'Далучыцца да гульні';

  @override
  String get whitePlays => 'Ход белых';

  @override
  String get blackPlays => 'Ход чорных';

  @override
  String get opponentLeftChoices => 'Ваш сапернік пакінуў гульню. Вы можаце абвясціць перамогу ці нічыю, або пачакаць.';

  @override
  String get forceResignation => 'Абвясціць перамогу';

  @override
  String get forceDraw => 'Залічыць нічыю';

  @override
  String get talkInChat => 'Калі ласка, будзьце ветлівыя!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Першы, хто пройдзе па гэтай спасылцы, згуляе з вамі.';

  @override
  String get whiteResigned => 'Белыя здаліся';

  @override
  String get blackResigned => 'Чорныя здаліся';

  @override
  String get whiteLeftTheGame => 'Гулец з боку белых пакінуў гульню';

  @override
  String get blackLeftTheGame => 'Гулец з боку чорных пакінуў гульню';

  @override
  String get whiteDidntMove => 'Белыя не зрабілі ход';

  @override
  String get blackDidntMove => 'Чорныя не зрабілі ход';

  @override
  String get requestAComputerAnalysis => 'Запытаць кампутарны аналіз';

  @override
  String get computerAnalysis => 'Кампутарны аналіз';

  @override
  String get computerAnalysisAvailable => 'Даступны кампутарны аналіз';

  @override
  String get computerAnalysisDisabled => 'Кампутарны аналіз забаронены';

  @override
  String get analysis => 'Дошка для аналіза';

  @override
  String depthX(String param) {
    return 'Глыбіня $param';
  }

  @override
  String get usingServerAnalysis => 'Выкарыстоўваецца серверны аналіз';

  @override
  String get loadingEngine => 'Загружаем шахматную праграму...';

  @override
  String get calculatingMoves => 'Пралічваем хады...';

  @override
  String get engineFailed => 'Памылка пры загрузцы шахматнай праграмы';

  @override
  String get cloudAnalysis => 'Воблачны аналіз';

  @override
  String get goDeeper => 'Паглыбіць';

  @override
  String get showThreat => 'Паказваць пагрозы';

  @override
  String get inLocalBrowser => 'у вашым браўзеры';

  @override
  String get toggleLocalEvaluation => 'Пераключыць лакальны аналіз';

  @override
  String get promoteVariation => 'Прасунуць варыянт';

  @override
  String get makeMainLine => 'Зрабіць асноўным варыянтам';

  @override
  String get deleteFromHere => 'Выдаліць з гэтага месца';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Прасунуць варыянт';

  @override
  String get copyVariationPgn => 'Скап\'яваць варыянт у фармаце PGN';

  @override
  String get move => 'Ход';

  @override
  String get variantLoss => 'Пройгрышны варыянт';

  @override
  String get variantWin => 'Пераможны варыянт';

  @override
  String get insufficientMaterial => 'Недастаткова матэрыялу';

  @override
  String get pawnMove => 'Ход пешкай';

  @override
  String get capture => 'Узяцце';

  @override
  String get close => 'Закрыць';

  @override
  String get winning => 'Пераможны';

  @override
  String get losing => 'Пройгрышны';

  @override
  String get drawn => 'Нічыя';

  @override
  String get unknown => 'Невядома';

  @override
  String get database => 'База дадзеных';

  @override
  String get whiteDrawBlack => 'Белыя / Нічыя / Чорныя';

  @override
  String averageRatingX(String param) {
    return 'Сярэдні рэйтынг: $param';
  }

  @override
  String get recentGames => 'Нядаўнія гульні';

  @override
  String get topGames => 'Лепшыя гульні';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '$param1+ гульняў за дошкай гульцоў з сілай F.I.D.E. ад $param2 да $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' з акругленнем, заснавана на колькасці паўходаў да наступнага ўзяцця ці ходу пешкі';

  @override
  String get noGameFound => 'Гульняў не знойдзена';

  @override
  String get maxDepthReached => 'Дасягнута максімальная глыбіня!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Паспрабуйце пашырыць ахоп пошуку ў наладах.';

  @override
  String get openings => 'Дэбюты';

  @override
  String get openingExplorer => 'Аглядальнік дэбютаў';

  @override
  String get openingEndgameExplorer => 'Аглядальнік дэбютаў/эндшпіляў';

  @override
  String xOpeningExplorer(String param) {
    return 'Аглядальнік дэбютаў $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => 'Перамога немагчыма па правілу 50 хадоў';

  @override
  String get lossSavedBy50MoveRule => 'Паражанне немагчыма па правілу 50 хадоў';

  @override
  String get winOr50MovesByPriorMistake => 'Перамога ці 50 хадоў ад папярэдняй памылкі';

  @override
  String get lossOr50MovesByPriorMistake => 'Параженне або 50 хадоў ад папярэдняй памылкі';

  @override
  String get unknownDueToRounding => 'Перамога/параза гарантуецца толькі ў тым выпадку, калі рэкамендаваная лінія табліцы эндшпіляў выконвалася з моманту апошняга ўзяцця ці ходу пешкі, з-за магчымага акруглення значэнняў DTZ у табліцах эндшпілю Syzygy.';

  @override
  String get allSet => 'Усё гатова!';

  @override
  String get importPgn => 'Імпартаваць PGN';

  @override
  String get delete => 'Выдаліць';

  @override
  String get deleteThisImportedGame => 'Выдаліць гэтую імпартаваную гульню?';

  @override
  String get replayMode => 'Рэжым паўтору';

  @override
  String get realtimeReplay => 'У рэальным часе';

  @override
  String get byCPL => 'Цікавае';

  @override
  String get openStudy => 'Адкрыць навучанне';

  @override
  String get enable => 'Уключыць';

  @override
  String get bestMoveArrow => 'Паказваць стрэлкай найлепшы ход';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Шкала ацэнкі';

  @override
  String get multipleLines => 'Дадатковыя хады';

  @override
  String get cpus => 'Працэсары';

  @override
  String get memory => 'Памяць';

  @override
  String get infiniteAnalysis => 'Бясконцы аналіз';

  @override
  String get removesTheDepthLimit => 'Здымае абмежаванне на глыбіню. Асцярожна, ваш камп’ютар можа перагрэцца!';

  @override
  String get engineManager => 'Engine manager';

  @override
  String get blunder => 'Грубая памылка';

  @override
  String get mistake => 'Памылка';

  @override
  String get inaccuracy => 'Недакладнасць';

  @override
  String get moveTimes => 'Час на ход';

  @override
  String get flipBoard => 'Перавярнуць дошку';

  @override
  String get threefoldRepetition => 'Трохразовы паўтор';

  @override
  String get claimADraw => 'Запатрабаваць нічыю';

  @override
  String get offerDraw => 'Прапанаваць нічыю';

  @override
  String get draw => 'Нічыя';

  @override
  String get drawByMutualAgreement => 'Нічыя па ўзаемнай згодзе';

  @override
  String get fiftyMovesWithoutProgress => 'Пяцьдзесят хадоў без прагрэсу';

  @override
  String get currentGames => 'Бягучыя гульні';

  @override
  String get viewInFullSize => 'Глядзець у поўным памеры';

  @override
  String get logOut => 'Выйсці';

  @override
  String get signIn => 'Увайсці';

  @override
  String get rememberMe => 'Заставацца ў сістэме';

  @override
  String get youNeedAnAccountToDoThat => 'Вам патрэбны ўліковы запіс, каб зрабіць гэта';

  @override
  String get signUp => 'Зарэгістравацца';

  @override
  String get computersAreNotAllowedToPlay => 'Майце на ўвазе, што да гульні не дапускаюцца «камп’ютарныя гульцы» і гульцы, якія карыстаюцца дапамогай камп’ютару. Любыя дапаможныя сродкі – шахматныя вылічальныя праграмы, базы звестак ці парады іншых гульцоў – забаронены. Мы просім вас гуляць па правілах. Таксама не ўхваляецца стварэнне некалькіх уліковых запісаў: пры злоўжыванні гэта можа прывесці да перманентнай блакіроўкі.';

  @override
  String get games => 'Гульні';

  @override
  String get forum => 'Форум';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 размясціў допіс у тэме $param2';
  }

  @override
  String get latestForumPosts => 'Апошнія допісы на форуме';

  @override
  String get players => 'Гульцы';

  @override
  String get friends => 'Сябры';

  @override
  String get discussions => 'Размовы';

  @override
  String get today => 'Сёння';

  @override
  String get yesterday => 'Учора';

  @override
  String get minutesPerSide => 'Хвілін на кожны бок';

  @override
  String get variant => 'Варыянт';

  @override
  String get variants => 'Варыянты';

  @override
  String get timeControl => 'Абмежаванне часу';

  @override
  String get realTime => 'Жывая гульня';

  @override
  String get correspondence => 'Па ліставанні';

  @override
  String get daysPerTurn => 'Дзён на ход';

  @override
  String get oneDay => 'Aдзін дзень';

  @override
  String get time => 'Час';

  @override
  String get rating => 'Рэйтынг';

  @override
  String get ratingStats => 'Статыстыка па рэйтынгу';

  @override
  String get username => 'Імя карыстальніка';

  @override
  String get usernameOrEmail => 'Імя карыстальніка ці адрас электроннай пошты';

  @override
  String get changeUsername => 'Змяніць імя карыстальніка';

  @override
  String get changeUsernameNotSame => 'Можна мяняць толькі рэгістр літар, да прыкладу, \"janlucevich\" na \"JanLucevich\".';

  @override
  String get changeUsernameDescription => 'Вы можаце змяніць рэгістр літар у вашым імені карыстальніка. Зрабіць гэта можна толькі адзін раз.';

  @override
  String get signupUsernameHint => 'Пераканайцеся, што выбралі імя карыстальніка, зручнае для сям\'і. Вы не можаце змяніць яго пазней, і любыя ўліковыя запісы з неадпаведнымі імёнамі карыстальнікаў будуць зачынены!';

  @override
  String get signupEmailHint => 'Мы будзем выкарыстоўваць яго толькі для скіду пароля.';

  @override
  String get password => 'Пароль';

  @override
  String get changePassword => 'Змяніць пароль';

  @override
  String get changeEmail => 'Змяніць адрас электроннай пошты';

  @override
  String get email => 'Электронная пошта';

  @override
  String get passwordReset => 'Скінуць пароль';

  @override
  String get forgotPassword => 'Забыліся на пароль?';

  @override
  String get error_weakPassword => 'Гэты пароль вельмі распаўсюджаны, і яго занадта лёгка адгадаць.';

  @override
  String get error_namePassword => 'Калі ласка, не выкарыстоўвайце сваё імя карыстальніка ў якасці пароля.';

  @override
  String get blankedPassword => 'Вы выкарыстоўвалі той жа пароль на іншым сайце, і гэты сайт быў узламаны. Каб забяспечыць бяспеку вашага ўліковага запісу Lichess, трэба каб вы ўсталявалі новы пароль. Дзякуй за разуменне.';

  @override
  String get youAreLeavingLichess => 'Вы пакідаеце Lichess';

  @override
  String get neverTypeYourPassword => 'Ніколі не ўводзьце свой пароль Lichess на іншым сайце!';

  @override
  String proceedToX(String param) {
    return 'Перайсці да $param';
  }

  @override
  String get passwordSuggestion => 'Не ўстанаўлівайце пароль, прапанаваны кімсьці. Яго могуць выкарыстаць, каб скрасці ваш уліковы запіс.';

  @override
  String get emailSuggestion => 'Не ўстанаўлівайце адрас электроннай пошты, прапанаваны кімсьці. Яго могуць выкарыстаць, каб скрасці ваш уліковы запіс.';

  @override
  String get emailConfirmHelp => 'Дапамога з пацвярджэннем электроннай пошты';

  @override
  String get emailConfirmNotReceived => 'Не атрымалі ліст з пацвярджэннем пасля рэгістрацыі?';

  @override
  String get whatSignupUsername => 'Якое імя карыстальніка вы выкарыстоўвалі для рэгістрацыі?';

  @override
  String usernameNotFound(String param) {
    return 'Мы не змаглі знайсці ніводнага карыстальніка з такім імем: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Вы можаце выкарыстоўваць гэтае імя карыстальніка для стварэння новага ўліковага запісу';

  @override
  String emailSent(String param) {
    return 'Мы адправілі электронны ліст на $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Ён можа прыйсці праз некаторы час.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Пачакайце 5 хвілін і абнавіце паштовую скрыню.';

  @override
  String get checkSpamFolder => 'Таксама праверце папку са спамам, ён можа апынуцца там. Калі так, адзначце гэта як не спам.';

  @override
  String get emailForSignupHelp => 'Калі ўсё астатняе не дапамагае, адпраўце нам гэты ліст:';

  @override
  String copyTextToEmail(String param) {
    return 'Скапіруйце і ўстаўце прыведзены вышэй тэкст і адпраўце яго $param';
  }

  @override
  String get waitForSignupHelp => 'Мы звяжамся з вамі ў бліжэйшы час, каб дапамагчы вам завяршыць рэгістрацыю.';

  @override
  String accountConfirmed(String param) {
    return 'Карыстальнік $param паспяхова пацверджаны.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Вы можаце ўвайсці зараз як $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Вам не патрэбна пацвярджэнне па электроннай пошце.';

  @override
  String accountClosed(String param) {
    return 'Уліковы запіс $param зачынены.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Уліковы запіс $param быў зарэгістраваны без электроннай пошты.';
  }

  @override
  String get rank => 'Ранг';

  @override
  String rankX(String param) {
    return 'Рэйтынг: $param';
  }

  @override
  String get gamesPlayed => 'Партый згуляна';

  @override
  String get cancel => 'Скасаваць';

  @override
  String get whiteTimeOut => 'Час белых скончыўся';

  @override
  String get blackTimeOut => 'Час чорных скончыўся';

  @override
  String get drawOfferSent => 'Прапанова нічыі даслана';

  @override
  String get drawOfferAccepted => 'Прапанова нічыі прынята';

  @override
  String get drawOfferCanceled => 'Прапанова нічыі скасавана';

  @override
  String get whiteOffersDraw => 'Белыя прапануюць нічыю';

  @override
  String get blackOffersDraw => 'Чорныя прапануюць нічыю';

  @override
  String get whiteDeclinesDraw => 'Белыя адхіляюць нічыю';

  @override
  String get blackDeclinesDraw => 'Чорныя адхіляюць нічыю';

  @override
  String get yourOpponentOffersADraw => 'Супернік прапануе нічыю';

  @override
  String get accept => 'Прыняць';

  @override
  String get decline => 'Адхіліць';

  @override
  String get playingRightNow => 'Граецца зараз';

  @override
  String get eventInProgress => 'Граецца зараз';

  @override
  String get finished => 'Скончана';

  @override
  String get abortGame => 'Скасаваць гульню';

  @override
  String get gameAborted => 'Гульня скасавана';

  @override
  String get standard => 'Стандартная';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Без абмежавання часу';

  @override
  String get mode => 'Рэжым';

  @override
  String get casual => 'Таварыская';

  @override
  String get rated => 'Рэйтынгавая';

  @override
  String get casualTournament => 'Таварыскі';

  @override
  String get ratedTournament => 'Рэйтынгавая';

  @override
  String get thisGameIsRated => 'Гульня на рэйтынг';

  @override
  String get rematch => 'Рэванш';

  @override
  String get rematchOfferSent => 'Прапанова рэваншу даслана';

  @override
  String get rematchOfferAccepted => 'Прапанова рэваншу прынятая';

  @override
  String get rematchOfferCanceled => 'Прапанова рэваншу скасаваная';

  @override
  String get rematchOfferDeclined => 'Прапанова рэваншу адхілена';

  @override
  String get cancelRematchOffer => 'Скасаваць прапанову рэваншу';

  @override
  String get viewRematch => 'Праглядзець рэванш';

  @override
  String get confirmMove => 'Пацвердзіць ход';

  @override
  String get play => 'Гуляць';

  @override
  String get inbox => 'Уваходныя';

  @override
  String get chatRoom => 'Чат';

  @override
  String get loginToChat => 'Увайдзіце, каб скарыстаць чат';

  @override
  String get youHaveBeenTimedOut => 'Вы былі адключаны.';

  @override
  String get spectatorRoom => 'Пакой назіральнікаў';

  @override
  String get composeMessage => 'Напісаць паведамленне';

  @override
  String get subject => 'Тэма';

  @override
  String get send => 'Даслаць';

  @override
  String get incrementInSeconds => 'Дадаванне секунд за ход';

  @override
  String get freeOnlineChess => 'Бясплатныя шахматы онлайн';

  @override
  String get exportGames => 'Экспарт гульняў';

  @override
  String get ratingRange => 'Дыяпазон рэйтынгу';

  @override
  String get thisAccountViolatedTos => 'Гэты ўліковы запіс парушыў Умовы выкарыстання Lichess';

  @override
  String get openingExplorerAndTablebase => 'База дэбютаў і эндшпіляў';

  @override
  String get takeback => 'Скасаваць ход';

  @override
  String get proposeATakeback => 'Прапанаваць скасаваць ход';

  @override
  String get takebackPropositionSent => 'Прапанова скасаваць ход даслана';

  @override
  String get takebackPropositionDeclined => 'Прапанова скасаваць ход адхілена';

  @override
  String get takebackPropositionAccepted => 'Прапанова скасаваць ход прынята';

  @override
  String get takebackPropositionCanceled => 'Прапанова скасаваная';

  @override
  String get yourOpponentProposesATakeback => 'Супернік прапануе скасаваць ход';

  @override
  String get bookmarkThisGame => 'Дадаць гэтую гульню ў закладкі';

  @override
  String get tournament => 'Турнір';

  @override
  String get tournaments => 'Турніры';

  @override
  String get tournamentPoints => 'Турнірныя балы';

  @override
  String get viewTournament => 'Адкрыць турнір';

  @override
  String get backToTournament => 'Вярнуцца да турніру';

  @override
  String get noDrawBeforeSwissLimit => 'У турніры па швейцарская сістэме вы не можаце згуляць унічыю раней, чым будзе зроблена 30 хадоў.';

  @override
  String get thematic => 'Тэматычны';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Ваш рэйтынг у рэжыме $param не пацверджаны';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ваш рэйтынг у рэжыме «$param1» ($param2) занадта высокі';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ваш штотыднёвы рэйтынг у рэжыме «$param1» ($param2) занадта высокі';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Ваш рэйтынг у рэжыме «$param1» ($param2) занадта нізкі';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Рэйтынг ≥ $param1 у рэжыме «$param2»';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Рэйтынг ≤ $param1 у рэжыме «$param2»';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Вы павінны быць удзельнікам каманды $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Вы не ўдзельнік каманды $param';
  }

  @override
  String get backToGame => 'Вярнуцца да гульні';

  @override
  String get siteDescription => 'Бясплатныя анлайн шахматы. Зручны інтэрфэйс. Без рэгістрацыі, без рэкламы, без дадатковых плагінаў. Гуляйце у шахматы з камп\'ютарам, сябрамі ці выпадковымі супернікамі.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 далучыўся да каманды $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 стварыў каманду $param2';
  }

  @override
  String get startedStreaming => 'пачаў трансляцыю';

  @override
  String xStartedStreaming(String param) {
    return '$param пачаў трансляцыю';
  }

  @override
  String get averageElo => 'Сярэдні рэйтынг';

  @override
  String get location => 'Месцазнаходжання';

  @override
  String get filterGames => 'Фільтраваць гульні';

  @override
  String get reset => 'Скінуць';

  @override
  String get apply => 'Ужыць';

  @override
  String get save => 'Захаваць';

  @override
  String get leaderboard => 'Лепшыя гульцы';

  @override
  String get screenshotCurrentPosition => 'Зрабіць здымак экрана з бягучай пазіцыяй';

  @override
  String get gameAsGIF => 'Партыя ў фармаце GIF';

  @override
  String get pasteTheFenStringHere => 'Устаўце сюды радок у фармаце FEN';

  @override
  String get pasteThePgnStringHere => 'Устаўце сюды радок у фармаце PGN';

  @override
  String get orUploadPgnFile => 'Або загрузіце PGN файл';

  @override
  String get fromPosition => 'З пазіцыі';

  @override
  String get continueFromHere => 'Працягнуць адсюль';

  @override
  String get toStudy => 'Навучанне';

  @override
  String get importGame => 'Імпартаваць гульню';

  @override
  String get importGameExplanation => 'Калі вы імпартуеце PGN-натацыю гульні, вы атрымаеце спасылку на гэтую гульню і зможаце праглядаць яе паўтор у браўзеры і аналізаваць яе. Таксама будзе даступны чат.';

  @override
  String get importGameCaveat => 'Варыянты будуць выдалены. Каб захаваць іх, імпартуйце PGN праз студыю.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Гэта шахматная CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Зрабіце ход, каб даказаць, што вы – чалавек.';

  @override
  String get captcha_fail => 'Калі ласка, вырашыце шахматную CAPTCHA.';

  @override
  String get notACheckmate => 'Гэта не мат';

  @override
  String get whiteCheckmatesInOneMove => 'Белыя ставяць мат у адзін ход';

  @override
  String get blackCheckmatesInOneMove => 'Чорныя ставяць мат у адзін ход';

  @override
  String get retry => 'Яшчэ раз';

  @override
  String get reconnecting => 'Перападлучэнне';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Улюбленыя супернікі';

  @override
  String get follow => 'Падпісацца';

  @override
  String get following => 'Вы падпісаны';

  @override
  String get unfollow => 'Адпісацца';

  @override
  String followX(String param) {
    return 'Падпісацца на $param';
  }

  @override
  String unfollowX(String param) {
    return 'Адпісацца ад $param';
  }

  @override
  String get block => 'Заблакаваць';

  @override
  String get blocked => 'Заблакаваны';

  @override
  String get unblock => 'Разблакіраваць';

  @override
  String get followsYou => 'Падпісаны на вас';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 падпісаўся на $param2';
  }

  @override
  String get more => 'Яшчэ';

  @override
  String get memberSince => 'Далучыўся';

  @override
  String lastSeenActive(String param) {
    return 'Анлайн $param';
  }

  @override
  String get player => 'Гулец';

  @override
  String get list => 'Спіс';

  @override
  String get graph => 'Дыяграма';

  @override
  String get required => 'Абавязкова.';

  @override
  String get openTournaments => 'Адкрытыя турніры';

  @override
  String get duration => 'Працягласць';

  @override
  String get winner => 'Пераможца';

  @override
  String get standing => 'Турнірная табліца';

  @override
  String get createANewTournament => 'Стварыць новы турнір';

  @override
  String get tournamentCalendar => 'Каляндар турніру';

  @override
  String get conditionOfEntry => 'Умовы ўваходу:';

  @override
  String get advancedSettings => 'Дадатковыя налады';

  @override
  String get safeTournamentName => 'Абярыце назву для турніру (бяспечную, калі ласка).';

  @override
  String get inappropriateNameWarning => 'Усё, што нават крыху апынецца недарэчным, можа прывесці да блакіроўкі.';

  @override
  String get emptyTournamentName => 'Пакіньце пустым, каб назваць турнір у гонар выпадковага гросмайстра.';

  @override
  String get makePrivateTournament => 'Зрабіць турнір прыватным і абмяжаваць доступ паролем';

  @override
  String get join => 'Далучыцца';

  @override
  String get withdraw => 'Адмовіцца ад удзелу';

  @override
  String get points => 'Балы';

  @override
  String get wins => 'Перамогі';

  @override
  String get losses => 'Паразы';

  @override
  String get createdBy => 'Стварыў';

  @override
  String get tournamentIsStarting => 'Турнір пачынаецца';

  @override
  String get tournamentPairingsAreNowClosed => 'Лёсаванне турніру скончана.';

  @override
  String standByX(String param) {
    return '$param, ідзе лёсаванне. Напагатове!';
  }

  @override
  String get pause => 'Паўза';

  @override
  String get resume => 'Працягнуць';

  @override
  String get youArePlaying => 'Вы ў гульні!';

  @override
  String get winRate => 'Працэнт перамог';

  @override
  String get berserkRate => 'Шаленства';

  @override
  String get performance => 'Эфектыўнасць';

  @override
  String get tournamentComplete => 'Турнір скончаны';

  @override
  String get movesPlayed => 'Зроблена хадоў';

  @override
  String get whiteWins => 'Перамог белых';

  @override
  String get blackWins => 'Перамог чорных';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Нічыіх';

  @override
  String nextXTournament(String param) {
    return 'Наступны турнір $param:';
  }

  @override
  String get averageOpponent => 'Сярэдні рэйтынг суперніка';

  @override
  String get boardEditor => 'Рэдактар дошкі';

  @override
  String get setTheBoard => 'Абраць пазіцыю';

  @override
  String get popularOpenings => 'Папулярныя дэбюты';

  @override
  String get endgamePositions => 'Пазіцыі ў эндшпілі';

  @override
  String chess960StartPosition(String param) {
    return 'Пачатковая пазіцыя ў шахматах Фішэра: $param';
  }

  @override
  String get startPosition => 'Пачатковая пазіцыя';

  @override
  String get clearBoard => 'Ачысціць дошку';

  @override
  String get loadPosition => 'Загрузіць пазіцыю';

  @override
  String get isPrivate => 'Прыватна';

  @override
  String reportXToModerators(String param) {
    return 'Паведаміць пра $param мадэратару';
  }

  @override
  String profileCompletion(String param) {
    return 'Запоўненасць профілю: $param';
  }

  @override
  String xRating(String param) {
    return 'Рэйтынг $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Калі няма, пакіньце пустым';

  @override
  String get profile => 'Профіль';

  @override
  String get editProfile => 'Рэдагаваць профіль';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Біяграфія';

  @override
  String get countryRegion => 'Краіна або рэгіён';

  @override
  String get thankYou => 'Дзякуй!';

  @override
  String get socialMediaLinks => 'Спасылкі на сацсеткі';

  @override
  String get oneUrlPerLine => 'Адзін URL на радок.';

  @override
  String get inlineNotation => 'Убудаваная натацыя';

  @override
  String get makeAStudy => 'Для захавання і сумеснага выкарыстання стварыце студыю.';

  @override
  String get clearSavedMoves => 'Ачысціць хады';

  @override
  String get previouslyOnLichessTV => 'Раней на Lichess TV';

  @override
  String get onlinePlayers => 'Гульцы анлайн';

  @override
  String get activePlayers => 'Актыўныя гульцы';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Увага! Гэта рэйтынгавая гульня, але без абмежавання часу!';

  @override
  String get success => 'Поспех';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Аўтаматычна пераходзіць да наступнай гульні пасля ходу';

  @override
  String get autoSwitch => 'Аўтапераключэнне';

  @override
  String get puzzles => 'Задачы';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Назва';

  @override
  String get description => 'Апісанне';

  @override
  String get descPrivate => 'Прыватнае апісанне';

  @override
  String get descPrivateHelp => 'Дапамагчы зрабіць \"прыватнае апісанне\".';

  @override
  String get no => 'Не';

  @override
  String get yes => 'Так';

  @override
  String get help => 'Дапамога:';

  @override
  String get createANewTopic => 'Стварыць новую тэму';

  @override
  String get topics => 'Тэмы';

  @override
  String get posts => 'Допісы';

  @override
  String get lastPost => 'Апошні допіс';

  @override
  String get views => 'Прагляды';

  @override
  String get replies => 'Адказы';

  @override
  String get replyToThisTopic => 'Адказаць у гэтую тэму';

  @override
  String get reply => 'Адказаць';

  @override
  String get message => 'Паведамленне';

  @override
  String get createTheTopic => 'Стварыць тэму';

  @override
  String get reportAUser => 'Паскардзіцца на карыстальніка';

  @override
  String get user => 'Карыстальнік';

  @override
  String get reason => 'Прычына';

  @override
  String get whatIsIheMatter => 'Што здарылася?';

  @override
  String get cheat => 'Несумленная гульня';

  @override
  String get troll => 'Троль';

  @override
  String get other => 'Іншае';

  @override
  String get reportDescriptionHelp => 'Пакіньце ніжэй спасылку на гульню (ці гульні) і патлумачце, што вас непакоіць у паводзінах гэтага карыстальніка. Не пішыце нешта кшталту «ён чмут!» – патлумачце, як вы прыйшлі да гэтага выніку. Мы хутчэй разбярэмся ў сітуацыі, калі вы напішаце нам па-англійску.';

  @override
  String get error_provideOneCheatedGameLink => 'Калі ласка, дадайце спасылку хаця б на адну гульню, дзе былі парушаны правілы.';

  @override
  String by(String param) {
    return 'аўтар: $param';
  }

  @override
  String importedByX(String param) {
    return 'Імпартваў/-ла $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Тэма закрытая';

  @override
  String get blog => 'Блог';

  @override
  String get notes => 'Нататкі';

  @override
  String get typePrivateNotesHere => 'Тут можна зрабіць асабістыя нататкі аб гульні';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Напісаць прыватную нататку пра гэтага карыстальніка';

  @override
  String get noNoteYet => 'Пакуль нататкаў няма';

  @override
  String get invalidUsernameOrPassword => 'Няправільнае імя карыстальніка або пароль';

  @override
  String get incorrectPassword => 'Няправільны пароль';

  @override
  String get invalidAuthenticationCode => 'Няправільны код пацверджання';

  @override
  String get emailMeALink => 'Дашліце мне спасылку па электроннай пошце';

  @override
  String get currentPassword => 'Бягучы пароль';

  @override
  String get newPassword => 'Новы пароль';

  @override
  String get newPasswordAgain => 'Новы пароль (яшчэ раз)';

  @override
  String get newPasswordsDontMatch => 'Новыя паролі не супадаюць';

  @override
  String get newPasswordStrength => 'Надзейнасць пароля';

  @override
  String get clockInitialTime => 'Пачатковы час на часах';

  @override
  String get clockIncrement => 'Дадатак часу';

  @override
  String get privacy => 'Прыватнасць';

  @override
  String get privacyPolicy => 'Палітыка прыватнасці';

  @override
  String get letOtherPlayersFollowYou => 'Дазволіць іншых гульцам падпісвацца на вас';

  @override
  String get letOtherPlayersChallengeYou => 'Дазволіць іншым гульцам выклікаць вас на гульню';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Дазволіць іншым гульцам запрасіць вас на даследаванне';

  @override
  String get sound => 'Гук';

  @override
  String get none => 'Няма';

  @override
  String get fast => 'Хуткая';

  @override
  String get normal => 'Сярэдняя';

  @override
  String get slow => 'Павольная';

  @override
  String get insideTheBoard => 'Унутры дошкі';

  @override
  String get outsideTheBoard => 'Па-за дошкай';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'У павольных гульнях';

  @override
  String get always => 'Заўседы';

  @override
  String get never => 'Ніколі';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 прымае ўдзел у турніры $param2';
  }

  @override
  String get victory => 'Перамога';

  @override
  String get defeat => 'Параза';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 супраць $param2 у $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 супраць $param2 у $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 супраць $param2 у $param3';
  }

  @override
  String get timeline => 'Храналогія';

  @override
  String get starting => 'Пачатак:';

  @override
  String get allInformationIsPublicAndOptional => 'Уся інфармацыя з\'яўляецца публічнай і неабавязковай.';

  @override
  String get biographyDescription => 'Раскажыце пра сябе, вашы інтарэсы, што падабаецца ў шахматах, ўлюбляныя дэбюты, гульцы...';

  @override
  String get listBlockedPlayers => 'Спіс заблакаваных вамі гульцоў';

  @override
  String get human => 'Чалавек';

  @override
  String get computer => 'Камп\'ютар';

  @override
  String get side => 'Бок';

  @override
  String get clock => 'Гадзіннік';

  @override
  String get opponent => 'Апанэнт';

  @override
  String get learnMenu => 'Вучыцца';

  @override
  String get studyMenu => 'Навучанні';

  @override
  String get practice => 'Практыка';

  @override
  String get community => 'Супольнасць';

  @override
  String get tools => 'Інструменты';

  @override
  String get increment => 'Прырост';

  @override
  String get error_unknown => 'Недапушчальнае значэнне';

  @override
  String get error_required => 'Абавязковае поле';

  @override
  String get error_email => 'Гэта немагчымы адрас электронай пошты';

  @override
  String get error_email_acceptable => 'Гэты адрас электроннай пошты непрымальны. Калі ласка, пераправерце і паспрабуйце зноўку.';

  @override
  String get error_email_unique => 'Адрас электронай пошты немагчымы або ўжо заняты';

  @override
  String get error_email_different => 'Гэта ўжо ваш адрас электронай пошты';

  @override
  String error_minLength(String param) {
    return 'Павінна быць не менш за $param сімвалаў';
  }

  @override
  String error_maxLength(String param) {
    return 'Павінна быць не больш за $param сімвалаў';
  }

  @override
  String error_min(String param) {
    return 'Павінна быць не менш за $param';
  }

  @override
  String error_max(String param) {
    return 'Павінна быць не больш за $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Калі рэйтынг ± $param';
  }

  @override
  String get ifRegistered => 'Калі зарэгістраваны';

  @override
  String get onlyExistingConversations => 'Толькі існыя размовы';

  @override
  String get onlyFriends => 'Толькі сябрам';

  @override
  String get menu => 'Меню';

  @override
  String get castling => 'Ракіроўка';

  @override
  String get whiteCastlingKingside => 'Белыя O-O';

  @override
  String get blackCastlingKingside => 'Чорныя O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Агульны час у гульні: $param';
  }

  @override
  String get watchGames => 'Назіраць за гульнямі';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Час у TV: $param';
  }

  @override
  String get watch => 'Глядзець';

  @override
  String get videoLibrary => 'Відэатэка';

  @override
  String get streamersMenu => 'Стрымеры';

  @override
  String get mobileApp => 'Мабільная праграма';

  @override
  String get webmasters => 'Распрацоўшчыкам';

  @override
  String get about => 'Пра сайт';

  @override
  String aboutX(String param) {
    return 'Пра $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 – шахматны анлайн-сэрвіс: бясплатны ($param2), без рэкламы і з адкрытым зыходным кодам.';
  }

  @override
  String get really => 'чыстая праўда!';

  @override
  String get contribute => 'Зрабіць унёсак';

  @override
  String get termsOfService => 'Умовы карыстання';

  @override
  String get sourceCode => 'Зыходны код';

  @override
  String get simultaneousExhibitions => 'Сеансы адначасовай гульні';

  @override
  String get host => 'Арганізатар';

  @override
  String hostColorX(String param) {
    return 'Колер арганізатара: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Нядаўна створаныя сеансы';

  @override
  String get hostANewSimul => 'Арганізаваць новы сеанс';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Сеанс не знойдзены';

  @override
  String get noSimulExplanation => 'Не атрымалася знайсці такі сеанс.';

  @override
  String get returnToSimulHomepage => 'Вярнуцца да асноўнай старонкі сеансу';

  @override
  String get aboutSimul => 'Сеанс адначасовай гульні – рэжым, калі адзін гулец супрацьстаіць некалькім супернікам у адначассе.';

  @override
  String get aboutSimulImage => 'Фішэр гуляў адначасова з 50 супернікамі: ён перамог у 47 гульнях, сцярпеў паразу ў адной і дзве згуляў унічыю.';

  @override
  String get aboutSimulRealLife => 'Такія гульні праводзяцца і «ужывую»: сеансёр ходзіць ад стала да стала, робячы хады.';

  @override
  String get aboutSimulRules => 'Калі пачынаецца сеанс адначасовай гульні, кожны ўдзельнік гуляе асобную партыю з сеансёрам. Сеанс лічыцца скончаным, калі ўсе гульні завершаны.';

  @override
  String get aboutSimulSettings => 'Сеансы адначасовай гульні заўсёды таварыскія. Нельга перахадзіць ці дадаваць час.';

  @override
  String get create => 'Стварыць';

  @override
  String get whenCreateSimul => 'Калі вы створыце сеанс адначасовай гульні, вам прыйдзецца гуляць супраць некалькіх супернікаў у адначассе.';

  @override
  String get simulVariantsHint => 'Вы таксама можаце абраць некалькі варыянтаў для гульні: тады кожны гулец абярэ той з іх, у якім ён хоча гуляць з вамі.';

  @override
  String get simulClockHint => 'Налады гадзінніку Фішэра. Чым больш у вас супернікаў, тым больш часу вам можа спатрэбіцца.';

  @override
  String get simulAddExtraTime => 'Вы можаце ўзяць сабе дадатковы час на роздумы.';

  @override
  String get simulHostExtraTime => 'Дадатковы час для арганізатара';

  @override
  String get simulAddExtraTimePerPlayer => 'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'Турніры Lichess';

  @override
  String get tournamentFAQ => 'Частыя пытанні пра турніры арэны';

  @override
  String get timeBeforeTournamentStarts => 'Турнір пачнецца праз';

  @override
  String get averageCentipawnLoss => 'У сярэднім страчана сотых пешкі';

  @override
  String get accuracy => 'Дакладнасць';

  @override
  String get keyboardShortcuts => 'Скароты';

  @override
  String get keyMoveBackwardOrForward => 'на ход уперад/наперад';

  @override
  String get keyGoToStartOrEnd => 'да пачатку/канцу';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'паказаць/схаваць каментары';

  @override
  String get keyEnterOrExitVariation => 'увайсці/выйсці з варыянту';

  @override
  String get keyRequestComputerAnalysis => 'Request computer analysis, Learn from your mistakes';

  @override
  String get keyNextLearnFromYourMistakes => 'Далей (Работа над памылкамі)';

  @override
  String get keyNextBlunder => 'Наступны зявок';

  @override
  String get keyNextMistake => 'Наступная памылка';

  @override
  String get keyNextInaccuracy => 'Наступная недакладнасць';

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
  String get newTournament => 'Новы турнір';

  @override
  String get tournamentHomeTitle => 'Шахматны турнір';

  @override
  String get tournamentHomeDescription => 'Грайце ў хутка мінаючыя шахматныя турніры! Далучайцеся да любых з афіцыйна запланаваных турніраў ці стварыце ўласны. «Куля», бліц, класічныя, шахматы Фішэра, «кароль гары», тры шахі і яшчэ бясконцае мноства варыянтаў. Весяліцеся.';

  @override
  String get tournamentNotFound => 'Турнір не знойдзены';

  @override
  String get tournamentDoesNotExist => 'Гэты турнір не існуе.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Магчыма, ён быў скасаваны, калі ўсе гульцы выйшлі да пачатку.';

  @override
  String get returnToTournamentsHomepage => 'Вярнуцца да галоўнай старонкі турніраў';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Штотыднёвае размеркаванне па рэйтынгу $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Ваш рэйтынг у рэжыме «$param1» – $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Вы гуляеце ў «$param1» лепей за $param2 гульцоў.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 лепей $param2 гульцоў у $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Мацней за $param1 гульцоў у $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Ваш рэйтынг у рэжыме «$param» яшчэ не вызначаны.';
  }

  @override
  String get yourRating => 'Ваш рэйтынг';

  @override
  String get cumulative => 'Сукупна';

  @override
  String get glicko2Rating => 'Рэйтынг Glicko-2';

  @override
  String get checkYourEmail => 'Праверце сваю пошту';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Мы адаслалі ліст на вашу электронную пошту. Націсніце на спасылку ў лісце, каб актываваць ваш уліковы запіс.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Калі вы не бачыце ліст, праверце, магчыма, ён трапіў у тэчку для спаму.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Мы адправілі ліст на вашу пошту $param. Перайдзіце па спасылцы ў лісце, каб аднавіць ваш пароль.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Звярніце ўвагу: рэгіструючыся, вы прымаеце нашыя $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Чытай пра нас $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Затрымка сеткі паміж вамі і Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Час апрацоўкі ходу на серверы';

  @override
  String get downloadAnnotated => 'Спампаваць з анатацыямі';

  @override
  String get downloadRaw => 'Спампаваць без анатацый';

  @override
  String get downloadImported => 'Спампаваць у арыгінальным выглядзе';

  @override
  String get crosstable => 'Лік';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Вы таксама можаце гартаць хады колцам мышы, калі навядзецеся на дошку.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Пракруціць кампутарныя варыяцыі, каб праглядзець іх.';

  @override
  String get analysisShapesHowTo => 'Каб маляваць стрэлкі і кружкі на дошцы, карыстайцеся Shift + ЛКМ або ПКМ.';

  @override
  String get letOtherPlayersMessageYou => 'Дазволіць дасылаць вам паведамленні';

  @override
  String get receiveForumNotifications => 'Атрымоўваць апавяшчэнні, пры згадванні на форуме';

  @override
  String get shareYourInsightsData => 'Дзяліцца вашым шахматнымі аналітычнымі данымі';

  @override
  String get withNobody => 'Ні з кім';

  @override
  String get withFriends => 'З сябрамі';

  @override
  String get withEverybody => 'З усімі';

  @override
  String get kidMode => 'Дзіцячы рэжым';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Гэта для бяспекі. У дзіцячым рэжыме адключаны ўсе камунікацыі на сайце. Уключыце гэта для вашых дзяцей і школьнікаў, каб абараніць іх ад іншых карыстачоў Інтэрнэту.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'У дзіцячым рэжыме лагатып lichess атрымвае значок у выглядзе $param, так што вы ведаеце, што вашы дзеці знаходзяцца ў бяспецы.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'Уключыць дзіцячы рэжым';

  @override
  String get disableKidMode => 'Адключыць дзіцячы рэжым';

  @override
  String get security => 'Бяспека';

  @override
  String get sessions => 'Сэсіі';

  @override
  String get revokeAllSessions => 'скасаваць усе сесіі';

  @override
  String get playChessEverywhere => 'Гуляйце ў шахматы дзе заўгодна';

  @override
  String get asFreeAsLichess => 'Бясплатна, як і Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Створана дзеля шахматаў, а не дзеля грошай';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Кожны бясплатна атрымлівае ўсе магчымасці';

  @override
  String get zeroAdvertisement => 'Без рэкламы';

  @override
  String get fullFeatured => 'Паўнавартасны';

  @override
  String get phoneAndTablet => 'Для смартфонаў і планшэтаў';

  @override
  String get bulletBlitzClassical => '«Куля», бліц, класічны рэжым';

  @override
  String get correspondenceChess => 'Шахматы па ліставанні';

  @override
  String get onlineAndOfflinePlay => 'Гульня анлайн і афлайн';

  @override
  String get viewTheSolution => 'Паглядзець рашэнне';

  @override
  String get followAndChallengeFriends => 'Падпісацца і выклікаць на гульню сяброў';

  @override
  String get gameAnalysis => 'Аналіз гульні';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 стварыў $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 далучыўся да $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 упадабаў $param2';
  }

  @override
  String get quickPairing => 'Хуткі старт';

  @override
  String get lobby => 'Лобі';

  @override
  String get anonymous => 'Ананімны гулец';

  @override
  String yourScore(String param) {
    return 'Ваш лік: $param';
  }

  @override
  String get language => 'Мова';

  @override
  String get background => 'Фон';

  @override
  String get light => 'Светлы';

  @override
  String get dark => 'Цёмны';

  @override
  String get transparent => 'Празрысты';

  @override
  String get deviceTheme => 'Тэма прылады';

  @override
  String get backgroundImageUrl => 'Спасылка на фон:';

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
  String get pieceSet => 'Набор фігур';

  @override
  String get embedInYourWebsite => 'Убудаваць у свой сайт';

  @override
  String get usernameAlreadyUsed => 'Гэтае імя карыстальніка ўжо занятае. Калі ласка, паспрабуйце іншае.';

  @override
  String get usernamePrefixInvalid => 'Імя карыстальніка павінна пачынацца з літары.';

  @override
  String get usernameSuffixInvalid => 'Імя карыстальніка павінна сканчацца на лічбу або літару.';

  @override
  String get usernameCharsInvalid => 'Імя карыстальніка можа ўтрымліваць толькі літары, лічбы, ніжнія падкрэсліванні і злучок.';

  @override
  String get usernameUnacceptable => 'Недапушчальнае імя карыстальніка.';

  @override
  String get playChessInStyle => 'Гуляйце стылёва!';

  @override
  String get chessBasics => 'Асновы шахмат';

  @override
  String get coaches => 'Трэнеры';

  @override
  String get invalidPgn => 'Некарэктны PGN';

  @override
  String get invalidFen => 'Некарэктны FEN';

  @override
  String get custom => 'Свая гульня';

  @override
  String get notifications => 'Апавяшчэнні';

  @override
  String notificationsX(String param1) {
    return 'Апавяшчэнні: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Рэйтынг: $param';
  }

  @override
  String get practiceWithComputer => 'Трэніроўка з камп’ютарам';

  @override
  String anotherWasX(String param) {
    return 'Таксама можна: $param';
  }

  @override
  String bestWasX(String param) {
    return 'Найлепшы ход $param';
  }

  @override
  String get youBrowsedAway => 'Вы выйшлі з прагляду';

  @override
  String get resumePractice => 'Працягнуць трэніроўку';

  @override
  String get drawByFiftyMoves => 'Партыя была згуляна ўнічыю па правілу пяцідзесяці хадоў.';

  @override
  String get theGameIsADraw => 'Гульня скончылася ўнічыю.';

  @override
  String get computerThinking => 'Камп’ютар думае...';

  @override
  String get seeBestMove => 'Паказаць найлепшы ход';

  @override
  String get hideBestMove => 'Схаваць найлепшы ход';

  @override
  String get getAHint => 'Атрымаць падказку';

  @override
  String get evaluatingYourMove => 'Ацэнка вашага ходу...';

  @override
  String get whiteWinsGame => 'Белыя перамаглі';

  @override
  String get blackWinsGame => 'Чорныя перамаглі';

  @override
  String get learnFromYourMistakes => 'Работа над памылкамі';

  @override
  String get learnFromThisMistake => 'Разабраць гэту памылку';

  @override
  String get skipThisMove => 'Прапусціць гэты ход';

  @override
  String get next => 'Далей';

  @override
  String xWasPlayed(String param) {
    return 'Быў зроблены ход $param';
  }

  @override
  String get findBetterMoveForWhite => 'Знайдзіце за белых мацнейшы ход';

  @override
  String get findBetterMoveForBlack => 'Знайдзіце за белых мацнейшы ход';

  @override
  String get resumeLearning => 'Працягнуць навучанне';

  @override
  String get youCanDoBetter => 'Ёсць і мацнейшы ход';

  @override
  String get tryAnotherMoveForWhite => 'Паспрабуйце іншы ход за белых';

  @override
  String get tryAnotherMoveForBlack => 'Паспрабуйце іншы ход за чорных';

  @override
  String get solution => 'Рашэнне';

  @override
  String get waitingForAnalysis => 'Выконваем аналіз';

  @override
  String get noMistakesFoundForWhite => 'У белых няма памылак';

  @override
  String get noMistakesFoundForBlack => 'У чорных няма памылак';

  @override
  String get doneReviewingWhiteMistakes => 'Разгляд памылак белых скончаны';

  @override
  String get doneReviewingBlackMistakes => 'Разгляд памылак чорных скончаны';

  @override
  String get doItAgain => 'Яшчэ раз';

  @override
  String get reviewWhiteMistakes => 'Разабраць памылкі белых';

  @override
  String get reviewBlackMistakes => 'Разабраць памылкі чорных';

  @override
  String get advantage => 'Перавага';

  @override
  String get opening => 'Дэбют';

  @override
  String get middlegame => 'Мітальшпіль';

  @override
  String get endgame => 'Эндшпіль';

  @override
  String get conditionalPremoves => 'Умоўныя хады на апярэджанне';

  @override
  String get addCurrentVariation => 'Дадаць бягучы варыянт';

  @override
  String get playVariationToCreateConditionalPremoves => 'Згуляйце варыянт, каб стварыць умоўныя ходы на апярэджанне';

  @override
  String get noConditionalPremoves => 'Хады на апярэджанне без умоў';

  @override
  String playX(String param) {
    return 'Згуляць $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Прабачце :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Нам прыйшлося на нейкі час выдаць вам тайм-аўт.';

  @override
  String get why => 'Чаму?';

  @override
  String get pleasantChessExperience => 'Мы імкнемся даставіць задавальненне ад шахмат ўсім гульцам.';

  @override
  String get goodPractice => 'Каб дамагчыся гэтага, мы павінны забяспечыць, каб усе гульцы вынікалі правілам добрага тону.';

  @override
  String get potentialProblem => 'Калі мы выяўляем патэнцыйную праблему, мы паказваем гэтае паведамленне.';

  @override
  String get howToAvoidThis => 'Як пазбегнуць гэтага?';

  @override
  String get playEveryGame => 'Дагульвайце усе гульні якія вы пачалі.';

  @override
  String get tryToWin => 'Паспрабуйце перамагчы (або звесці на нічыю) кожную вашу гульню.';

  @override
  String get resignLostGames => 'Здавайцеся ў ясна прайграных гульнях (а не чакайце, пакуль час скончыцца).';

  @override
  String get temporaryInconvenience => 'Мы просім прабачэння за часовыя нязручнасці,';

  @override
  String get wishYouGreatGames => 'і жадаем вам вельмі добрых гульняў на lichess.org.';

  @override
  String get thankYouForReading => 'Дзякуй за ўвагу!';

  @override
  String get lifetimeScore => 'Лік за ўвесь час';

  @override
  String get currentMatchScore => 'Лік бягучага матчу';

  @override
  String get agreementAssistance => 'Я згаджаюся, што я ніколі не скарыстаюся старонняй дапамогай у сваіх гульнях (ад шахматных праграм, кніг, баз даных або іншых гульцоў).';

  @override
  String get agreementNice => 'Я згаджаюся, што я заўсёды адносіцца з павагай да другіх гульцоў.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Я пагаджаюся не ствараць некалькі ўліковых запісаў (акрамя выпадкаў апісаных у $param).';
  }

  @override
  String get agreementPolicy => 'Я згаджаюся, што я буду прытрымлівацца ўсіх правіл Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Знайсці размову або пачаць новую';

  @override
  String get edit => 'Рэдагаваць';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Бліц';

  @override
  String get rapid => 'Хуткія';

  @override
  String get classical => 'Класіка';

  @override
  String get ultraBulletDesc => 'Вар\'яцкі хуткія гульні: меней 30 секунд';

  @override
  String get bulletDesc => 'Вельмі хуткія гульні: меней 3 хвілін';

  @override
  String get blitzDesc => 'Хуткія гульні: ад 3 да 8 хвілін';

  @override
  String get rapidDesc => 'Хуткія гульні: ад 8 да 25 хвілін';

  @override
  String get classicalDesc => 'Класічныя гульні: 25 хвілін і больш';

  @override
  String get correspondenceDesc => 'Гульні па ліставанні: адзін або некалькі дзён на ход';

  @override
  String get puzzleDesc => 'Трэнер па шахматнай тактыцы';

  @override
  String get important => 'Важліва';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Адказ на ваша пытанне можа ўжо існаваць $param1';
  }

  @override
  String get inTheFAQ => 'у частых пытаннях';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Каб паведаміць аб падмане ці дрэнных паводзінах карыстальніка, $param1';
  }

  @override
  String get useTheReportForm => 'скарыстайцеся формай справаздачы';

  @override
  String toRequestSupport(String param1) {
    return 'Каб атрымаць дапамогу, $param1';
  }

  @override
  String get tryTheContactPage => 'паспрабуйце старонку кантактаў';

  @override
  String makeSureToRead(String param1) {
    return 'Абавязкова прачытайце $param1';
  }

  @override
  String get theForumEtiquette => 'этыкет форуму';

  @override
  String get thisTopicIsArchived => 'Гэта тэма была архівавана і абмяркаваць яе больш немагчыма.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Далучыцеся да $param1, каб пакінуць пісаць на форуме';
  }

  @override
  String teamNamedX(String param1) {
    return 'каманда $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Вы яшчэ не можаце публікаваць на формах. Згуляйце некалькі партый!';

  @override
  String get subscribe => 'Падпісацца';

  @override
  String get unsubscribe => 'Адпісацца';

  @override
  String mentionedYouInX(String param1) {
    return 'вас згадалі ў «$param1».';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 вас згадаў у «$param2».';
  }

  @override
  String invitedYouToX(String param1) {
    return 'вас запрасілі ў «$param1».';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 запрасіў вас у «$param2».';
  }

  @override
  String get youAreNowPartOfTeam => 'Цяпер вы з\'яўляецеся часткай каманды.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Вы далучыліся да $param1.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Хтосьці заблакаваны па вашаму звароту';

  @override
  String get congratsYouWon => 'Віншуем, вы перамаглі!';

  @override
  String gameVsX(String param1) {
    return 'Партыя супраць $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 супраць $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Вы прайгралі камусьці, хто парушыў ўмовы карыстання Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Вяртанне: $param1 $param2 балаў рэйтынгу.';
  }

  @override
  String get timeAlmostUp => 'Час амаль выйшаў!';

  @override
  String get clickToRevealEmailAddress => 'Націсніце, каб высветліць электроную пошту';

  @override
  String get download => 'Спампаваць';

  @override
  String get coachManager => 'Трэнерская старонка';

  @override
  String get streamerManager => 'Стрымерская старонка';

  @override
  String get cancelTournament => 'Скасаваць турнір';

  @override
  String get tournDescription => 'Апісанне турніру';

  @override
  String get tournDescriptionHelp => 'Хочаце сказаць удзельнікам што-небудзь асаблівае? Паспрабуйце зрабіць гэта сцісла. Markdown спасылкі даступныя: [name](https://url)';

  @override
  String get ratedFormHelp => 'Гульні - рэйтынгавыя\nі ўплываюць на рэйтынг гульцоў';

  @override
  String get onlyMembersOfTeam => 'Толькі чальцы каманды';

  @override
  String get noRestriction => 'Без абмежаванняў';

  @override
  String get minimumRatedGames => 'Мінімальная колькасць рэйтынгавый партый';

  @override
  String get minimumRating => 'Мінімальны рэйтынг';

  @override
  String get maximumWeeklyRating => 'Максімальны рэйтынг на працягу тыдня';

  @override
  String positionInputHelp(String param) {
    return 'Устаўце дакладны FEN, каб пачынаць кожную гульню з зададзенай пазіцыі.\nПрацуе толькі ў стандартных шахматах, не ў варыянтах.\nМожаце выкарыстаць $param для генерацыі пазіцыі FEN, а потым уставіць тут.\nПакіньце пустым, каб пачынаць гульні са звычайнай пачатковай пазіцыі.';
  }

  @override
  String get cancelSimul => 'Скасаваць сеанс адначасовай гульні';

  @override
  String get simulHostcolor => 'Колер арганізатара ў кожнай гульне';

  @override
  String get estimatedStart => 'Меркаваны час пачатку';

  @override
  String simulFeatured(String param) {
    return 'Паказваць на $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Паказваць сеанс адначасовай гульні усім на $param. Адключыце для прыватных сеансаў.';
  }

  @override
  String get simulDescription => 'Апісанне сеансу';

  @override
  String get simulDescriptionHelp => 'Жадаеце штосьці сказаць удзельнікам?';

  @override
  String markdownAvailable(String param) {
    return 'Можаце выкарыстаць $param для больш адмысловага сінтаксісу.';
  }

  @override
  String get embedsAvailable => 'Устаўце спасылку на гульню ці спасылку на раздзел навучання каб убудаваць яе.';

  @override
  String get inYourLocalTimezone => 'У вашым часавым поясе';

  @override
  String get tournChat => 'Чат турніру';

  @override
  String get noChat => 'Без чату';

  @override
  String get onlyTeamLeaders => 'Толькі лідары каманды';

  @override
  String get onlyTeamMembers => 'Толькі чальцы каманды';

  @override
  String get navigateMoveTree => 'Рухацца па дрэву ходаў';

  @override
  String get mouseTricks => 'Трукі мышшу';

  @override
  String get toggleLocalAnalysis => 'Укл./адкл. лакальны камп\'ютарны аналіз';

  @override
  String get toggleAllAnalysis => 'Укл./адкл. усе камп\'ютарныя аналізы';

  @override
  String get playComputerMove => 'Згуляць лепшы ход на думку камп\'ютару';

  @override
  String get analysisOptions => 'Параметры аналізу';

  @override
  String get focusChat => 'Сфакусавацца на чаце';

  @override
  String get showHelpDialog => 'Паказаць чат дапамогі';

  @override
  String get reopenYourAccount => 'Пераадкрыць уліковы запіс';

  @override
  String get closedAccountChangedMind => 'Калі пасля закрыцця ўліковага запісу, вы перадумалі, у вас ёсць адзін шанец аднавіць яго.';

  @override
  String get onlyWorksOnce => 'Гэта спрацуе толькі адзін раз.';

  @override
  String get cantDoThisTwice => 'Калі вы зачыніце яго ў другі раз, то ўжо не будзе шляху назад.';

  @override
  String get emailAssociatedToaccount => 'Адрас электроннай пошты, звязаны з уліковым запісам';

  @override
  String get sentEmailWithLink => 'Мы адправілі вам электронны ліст са спасылка.';

  @override
  String get tournamentEntryCode => 'Код далучэння да турніру';

  @override
  String get hangOn => 'Пачакайце!';

  @override
  String gameInProgress(String param) {
    return 'Вы зараз гуляеце з $param.';
  }

  @override
  String get abortTheGame => 'Скасаваць гульню';

  @override
  String get resignTheGame => 'Здацца';

  @override
  String get youCantStartNewGame => 'Вы не можаце пачаць новую гульню, пакуль гэта няскончана.';

  @override
  String get since => 'З';

  @override
  String get until => 'Да';

  @override
  String get lichessDbExplanation => 'Рэйтынгавыя партыі ўсіх гульцоў на Lichess';

  @override
  String get switchSides => 'Змяніць бок';

  @override
  String get closingAccountWithdrawAppeal => 'Закрыцце вашага ўліковага запісу адкліча вашу апеляцыю';

  @override
  String get ourEventTips => 'Нашы парады па арганізацыі падзей';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess - гэта дабрачынная і цалкам бясплатная праграма з адкрытым зыходным кодам.\nУсе аперацыйныя выдаткі, распрацоўка і шахматны кантэнт фінансуюцца выключна за кошт ахвяраванняў карыстальнікаў.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ваш супернік пакінуў гульню. Вы можаце абвясціць перамогу праз $count секунд.',
      many: 'Ваш супернік пакінуў гульню. Вы можаце абвясціць перамогу праз $count секунд.',
      few: 'Ваш сапернік пакінуў гульню. Вы можаце абвясціць перамогу праз $count секунд(у,ы).',
      one: 'Ваш сапернік пакінуў гульню. Вы можаце абвясціць перамогу праз $count секунды.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мат за $count паўхадоў',
      many: 'Мат за $count паўхадоў',
      few: 'Мат за $count паўхады',
      one: 'Мат за $count паўхадоў',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count позехаў',
      many: '$count позехаў',
      few: '$count позеха',
      one: '$count позех',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count памылак',
      many: '$count памылак',
      few: '$count памылкі',
      one: '$count памылка',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count недакладнасцяў',
      many: '$count недакладнасцяў',
      few: '$count недакладнасці',
      one: '$count недакладнасць',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гульцоў',
      many: '$count гульцоў',
      few: '$count гульцы',
      one: '$count гулец',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гульняў',
      many: '$count гульняў',
      few: '$count гульні',
      one: '$count гульня',
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
      other: '$count закладак',
      many: '$count закладак',
      few: '$count закладкі',
      one: '$count закладка',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дзён',
      many: '$count дзён',
      few: '$count дні',
      one: '$count дзень',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гадзін',
      many: '$count гадзін',
      few: '$count гадзіны',
      one: '$count гадзіна',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хвілін',
      many: '$count хвілін',
      few: '$count хвіліны',
      one: '$count хвіліна',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Рэйтынг абнаўляецца кожныя $count хвілін',
      many: 'Рэйтынг абнаўляецца кожныя $count хвілін',
      few: 'Рэйтынг абнаўляецца кожныя $count хвіліны',
      one: 'Рэйтынг абнаўляецца кожную хвіліну',
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
      few: '$count задачы',
      one: '$count задача',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count партый з вамі',
      many: '$count партый з вамі',
      few: '$count партыі з вамі',
      one: '$count партыя з вамі',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рэйтынгавых',
      many: '$count рэйтынгавых',
      few: '$count рэйтынгавыя',
      one: '$count рэйтынгавая',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count перамог',
      many: '$count перамог',
      few: '$count перамогі',
      one: '$count перамога',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count паразаў',
      many: '$count паразаў',
      few: '$count паразы',
      one: '$count параза',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count унічыю',
      many: '$count унічыю',
      few: '$count унічыю',
      one: '$count унічыю',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count у працэсе',
      many: '$count у працэсе',
      few: '$count у працэсе',
      one: '$count у працэсе',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Даць $count секунд',
      many: 'Даць $count секунд',
      few: 'Даць $count секунды',
      one: 'Даць $count секунду',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count турнірных балаў',
      many: '$count турнірных балаў',
      few: '$count турнірныя балы',
      one: '$count турнірны бал',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count навучанняў',
      many: '$count навучанняў',
      few: '$count навучанні',
      one: '$count навучанне',
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
      other: '≥$count рэйтынгавых гульняў',
      many: '$count рэйтынгавых гульняў',
      few: '≥$count рэйтынгавыя гульні',
      one: '≥$count рэйтынгавая гульня',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count рэйтынгавых гульняў ў рэжыме «$param2»',
      many: '≥ $count рэйтынгавых гульняў ў рэжыме «$param2»',
      few: '≥ $count рэйтынгавыя гульні ў рэжыме «$param2»',
      one: '≥ $count рэйтынгавая гульня ў рэжыме «$param2»',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вы павінны згуляць яшчэ $count рэйтынгавых гульняў ў рэжыме «$param2»',
      many: 'Вы павінны згуляць яшчэ $count рэйтынгавых гульняў у рэжыме «$param2»',
      few: 'Вы павінны згуляць яшчэ $count рэйтынгавыя гульні ў рэжыме «$param2»',
      one: 'Вы павінны згуляць яшчэ $count рэйтынгавую гульню ў рэжыме «$param2»',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вы павінны згуляць яшчэ $count рэйтынгавых гульняў',
      many: 'Вы павінны згуляць яшчэ $count рэйтынгавых гульняў',
      few: 'Вы павінны згуляць яшчэ $count рэйтынгавыя гульні',
      one: 'Вы павінны згуляць яшчэ $count рэйтынгавую гульню',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count імпартаваных гульняў',
      many: '$count імпартаваных гульняў',
      few: '$count імпартаваныя гульні',
      one: '$count імпартаваная гульня',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сяброў у сетцы',
      many: '$count сяброў у сетцы',
      few: '$count сябра ў сетцы',
      one: '$count сябар у сетцы',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count падпісчыкаў',
      many: '$count падпісчыкаў',
      few: '$count падпісчыкі',
      one: '$count падпісчык',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'падпісаны на $count гульцоў',
      many: 'падпісаны на $count гульцоў',
      few: 'падпісаны на $count гульцоў',
      one: 'падпісаны на $count гульца',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Менш за $count хвілін',
      many: 'Менш за $count хвілін',
      few: 'Менш за $count хвіліны',
      one: 'Менш за $count хвіліну',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count бягучых гульняў',
      many: '$count бягучых гульняў',
      few: '$count бягучыя гульні',
      one: '$count бягучая гульня',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Максімум: $count сімвалаў.',
      many: 'Максімум: $count сімвалаў.',
      few: 'Максімум: $count сімвалы.',
      one: 'Максімум: $count сімвал.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count заблакіраваных гульцоў',
      many: '$count заблакіраваных гульцоў',
      few: '$count заблакіраваных гульцы',
      one: '$count заблакіраваны гулец',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count допісаў на форуме',
      many: '$count допісаў на форуме',
      few: '$count допісы на форуме',
      one: '$count допіс на форуме',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гульцоў у $param2 на гэтым тыдні.',
      many: '$count гульцоў у $param2 на гэтым тыдні.',
      few: '$count гульцы у $param2 на гэтым тыдні.',
      one: '$count гулец у $param2 на гэтым тыдні.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Даступна на $count мовах!',
      many: 'Даступна на $count мовах!',
      few: 'Даступна на $count мовах!',
      one: 'Даступна на $count мове!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count секунд на першы ход',
      many: '$count секунд на першы ход',
      few: '$count секунды на першы ход',
      one: '$count секунда на першы ход',
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
      other: 'і захаваць $count паслядоўнасцяў',
      many: 'і захаваць $count паслядоўнасцяў',
      few: 'і захаваць $count паслядоўнасці',
      one: 'і захаваць $count паслядоўнасць',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Зрабіце ход, каб пачаць';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Вы гуляеце белымі фігурамі ва ўсіх задачах';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Вы гуляеце чорнымі фігурамі ва ўсіх задачах';

  @override
  String get stormPuzzlesSolved => 'задач вырашана';

  @override
  String get stormNewDailyHighscore => 'Новы дзённы рэкорд!';

  @override
  String get stormNewWeeklyHighscore => 'Новы тыднёвы рэкорд!';

  @override
  String get stormNewMonthlyHighscore => 'Новы месячны рэкорд!';

  @override
  String get stormNewAllTimeHighscore => 'Новы рэкорд за ўвесь час!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Папярэдні рэкорд $param';
  }

  @override
  String get stormPlayAgain => 'Гуляць яшчэ раз';

  @override
  String stormHighscoreX(String param) {
    return 'Рэкорд: $param';
  }

  @override
  String get stormScore => 'Вынік';

  @override
  String get stormMoves => 'Хады';

  @override
  String get stormAccuracy => 'Дакладнасць';

  @override
  String get stormCombo => 'Серыя';

  @override
  String get stormTime => 'Час';

  @override
  String get stormTimePerMove => 'Час на ход';

  @override
  String get stormHighestSolved => 'Найцяжейшая вырашаная';

  @override
  String get stormPuzzlesPlayed => 'Задач згуляна';

  @override
  String get stormNewRun => 'Новая спроба (клавіша: Space)';

  @override
  String get stormEndRun => 'Скончыць спробу (клавіша: Enter)';

  @override
  String get stormHighscores => 'Рэкорды';

  @override
  String get stormViewBestRuns => 'Праглядзець найлепшыя спробы';

  @override
  String get stormBestRunOfDay => 'Лепшая спроба за дзень';

  @override
  String get stormRuns => 'Спробы';

  @override
  String get stormGetReady => 'Прыгатуйцеся!';

  @override
  String get stormWaitingForMorePlayers => 'Пачакайце пакуль больш гульцоў далучыцца...';

  @override
  String get stormRaceComplete => 'Гонка завершана!';

  @override
  String get stormSpectating => 'Заяўзятарства';

  @override
  String get stormJoinTheRace => 'Далучыцца да гонкі!';

  @override
  String get stormStartTheRace => 'Распачаць гонку';

  @override
  String stormYourRankX(String param) {
    return 'Ваш вынік: $param';
  }

  @override
  String get stormWaitForRematch => 'Чакаць матчу-рэваншу';

  @override
  String get stormNextRace => 'Наступная гонка';

  @override
  String get stormJoinRematch => 'Далучыцца да матчу-рэваншу';

  @override
  String get stormWaitingToStart => 'Пачакайце пачатку';

  @override
  String get stormCreateNewGame => 'Стварыць новую гульню';

  @override
  String get stormJoinPublicRace => 'Далучыцца да публічнай гонкі';

  @override
  String get stormRaceYourFriends => 'Паганяцца з сябрамі';

  @override
  String get stormSkip => 'прапусціць';

  @override
  String get stormSkipHelp => 'Вы можаце прапусціць адзін ход за гонку:';

  @override
  String get stormSkipExplanation => 'Прапусціце ход, каб захаваць серыю! Працуе адзін раз на гонку.';

  @override
  String get stormFailedPuzzles => 'Нявырашыная задачы';

  @override
  String get stormSlowPuzzles => 'Павольныя задачы';

  @override
  String get stormSkippedPuzzle => 'Skipped puzzle';

  @override
  String get stormThisWeek => 'На гэтым тыдні';

  @override
  String get stormThisMonth => 'У гэтым месяцы';

  @override
  String get stormAllTime => 'За ўвесь час';

  @override
  String get stormClickToReload => 'Націсніце, каб перазагрузіць';

  @override
  String get stormThisRunHasExpired => 'Гэта спроба скончылася!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Гэта спроба адкрыта ў іншай укладцы!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count спробаў',
      many: '$count спробаў',
      few: '$count спробы',
      one: '1 спроба',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выкарастана $count з $param2 спробаў',
      many: 'Выкарастана $count з $param2 спробаў',
      few: 'Выкарастана $count з $param2 спроб',
      one: 'Выкарастана адна з $param2 спроб',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Стрымеры на Lichess';

  @override
  String get studyShareAndExport => 'Падзяліцца & экспартаваць';

  @override
  String get studyStart => 'Пачаць';
}
