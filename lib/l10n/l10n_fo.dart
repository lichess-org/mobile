// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Faroese (`fo`).
class AppLocalizationsFo extends AppLocalizations {
  AppLocalizationsFo([String locale = 'fo']) : super(locale);

  @override
  String get mobileAllGames => 'All games';

  @override
  String get mobileAreYouSure => 'Are you sure?';

  @override
  String get mobileCancelTakebackOffer => 'Cancel takeback offer';

  @override
  String get mobileClearButton => 'Clear';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Clear saved move';

  @override
  String get mobileCustomGameJoinAGame => 'Join a game';

  @override
  String get mobileFeedbackButton => 'Feedback';

  @override
  String mobileGreeting(String param) {
    return 'Hello, $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Hello';

  @override
  String get mobileHideVariation => 'Hide variation';

  @override
  String get mobileHomeTab => 'Home';

  @override
  String get mobileLiveStreamers => 'Live streamers';

  @override
  String get mobileMustBeLoggedIn => 'You must be logged in to view this page.';

  @override
  String get mobileNoSearchResults => 'No results';

  @override
  String get mobileNotFollowingAnyUser => 'You are not following any user.';

  @override
  String get mobileOkButton => 'OK';

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
  String get mobilePuzzleStormSubtitle => 'Solve as many puzzles as possible in 3 minutes.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Play puzzles from your favorite openings, or choose a theme.';

  @override
  String get mobilePuzzlesTab => 'Puzzles';

  @override
  String get mobileRecentSearches => 'Recent searches';

  @override
  String get mobileSettingsHapticFeedback => 'Haptic feedback';

  @override
  String get mobileSettingsImmersiveMode => 'Immersive mode';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and Puzzle Storm screens.';

  @override
  String get mobileSettingsTab => 'Settings';

  @override
  String get mobileShareGamePGN => 'Share PGN';

  @override
  String get mobileShareGameURL => 'Share game URL';

  @override
  String get mobileSharePositionAsFEN => 'Share position as FEN';

  @override
  String get mobileSharePuzzle => 'Share this puzzle';

  @override
  String get mobileShowComments => 'Show comments';

  @override
  String get mobileShowResult => 'Show result';

  @override
  String get mobileShowVariations => 'Show variations';

  @override
  String get mobileSomethingWentWrong => 'Something went wrong.';

  @override
  String get mobileSystemColors => 'System colors';

  @override
  String get mobileTheme => 'Theme';

  @override
  String get mobileToolsTab => 'Tools';

  @override
  String get mobileWaitingForOpponentToJoin => 'Waiting for opponent to join...';

  @override
  String get mobileWatchTab => 'Watch';

  @override
  String get activityActivity => 'Virkni';

  @override
  String get activityHostedALiveStream => 'Var vertur fyri beinleiðis stroyming';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Styrkismettur ≤ $param1 í $param2';
  }

  @override
  String get activitySignedUp => 'Innritaður í lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Stuðlaði lichess.org í $count mánaðir sum ein $param2',
      one: 'Stuðlaði lichess.org í $count mánaða sum ein $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vandi $count støður í $param2',
      one: 'Vandi $count støðu í $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Loysti $count taktiskar uppgávur',
      one: 'Loysti $count taktiska uppgávu',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Telvaði $count $param2 talv',
      one: 'Telvaði $count $param2 talv',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skrivaði $count boð í $param2',
      one: 'Skrivaði $count boð í $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Telvaði $count leikir',
      one: 'Telvaði $count leik',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'í $count brævtalvum',
      one: 'í $count brævtalvi',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fullførdi $count brævtalv',
      one: 'Fullførdi $count brævtalv',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Completed $count $param2 correspondence games',
      one: 'Completed $count $param2 correspondence game',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fór undir at fylgja $count telvarum',
      one: 'Fór undir at fylgja $count telvara',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fekk $count nýggjar fylgjarar',
      one: 'Fekk $count nýggjan fylgjara',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Var vertur fyri $count fjøltalvum',
      one: 'Var vertur fyri $count fjøltalvi',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Var við í $count fjøltalvum',
      one: 'Var við í $count fjøltalvi',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Stovnaði $count nýggjar rannsóknir',
      one: 'Stovnaði $count nýggja rannsókn',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kappaðist í $count kappingum',
      one: 'Kappaðist í $count kapping',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Styrkismettur #$count (top $param2%) við $param3 talvum í $param4',
      one: 'Styrkismettur #$count (top $param2%) við $param3 talvi í $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kappaðist í $count swisskappingum',
      one: 'Kappaðist í $count swisskapping',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fór upp í $count lið',
      one: 'Fór upp í $count lið',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Sendingar';

  @override
  String get broadcastMyBroadcasts => 'My broadcasts';

  @override
  String get broadcastLiveBroadcasts => 'Beinleiðis sendingar frá kappingum';

  @override
  String get broadcastBroadcastCalendar => 'Broadcast calendar';

  @override
  String get broadcastNewBroadcast => 'Nýggj beinleiðis sending';

  @override
  String get broadcastSubscribedBroadcasts => 'Subscribed broadcasts';

  @override
  String get broadcastAboutBroadcasts => 'About broadcasts';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'How to use Lichess Broadcasts.';

  @override
  String get broadcastTheNewRoundHelp => 'The new round will have the same members and contributors as the previous one.';

  @override
  String get broadcastAddRound => 'Add a round';

  @override
  String get broadcastOngoing => 'Í gongd';

  @override
  String get broadcastUpcoming => 'Komandi';

  @override
  String get broadcastCompleted => 'Liðug sending';

  @override
  String get broadcastCompletedHelp => 'Lichess detects round completion, but can get it wrong. Use this to set it manually.';

  @override
  String get broadcastRoundName => 'Round name';

  @override
  String get broadcastRoundNumber => 'Nummar á umfari';

  @override
  String get broadcastTournamentName => 'Tournament name';

  @override
  String get broadcastTournamentDescription => 'Short tournament description';

  @override
  String get broadcastFullDescription => 'Fullfíggjað lýsing av tiltaki';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Valfrí long lýsing av sending. $param1 er tøkt. Longdin má vera styttri enn $param2 bókstavir.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Source URL';

  @override
  String get broadcastSourceUrlHelp => 'URL-leinki, ið Lichess fer at kanna til tess at fáa PGN dagføringar. Leinkið nýtist at vera alment atkomiligt á alnetinum.';

  @override
  String get broadcastSourceGameIds => 'Up to 64 Lichess game IDs, separated by spaces.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Start date in the tournament local timezone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Valfrítt, um tú veitst, nær tiltakið byrjar';

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
  String get broadcastDeleteAllGamesOfThisRound => 'Delete all games of this round. The source will need to be active in order to re-create them.';

  @override
  String get broadcastEditRoundStudy => 'Edit round study';

  @override
  String get broadcastDeleteTournament => 'Delete this tournament';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Definitively delete the entire tournament, all its rounds and all its games.';

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
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Bjóða av at telva';

  @override
  String get challengeChallengeDeclined => 'Avbjóðing avvíst';

  @override
  String get challengeChallengeAccepted => 'Avbjóðing góðtikin!';

  @override
  String get challengeChallengeCanceled => 'Avbjóðing avlýst.';

  @override
  String get challengeRegisterToSendChallenges => 'Skráset teg vinaliga at senda avbjóðingar.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Tú kanst ikki bjóða $param av.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param tekur ikki ímóti avbjóðingum.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Títt $param1 styrkital er ov langt frá $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Fær ikki bjóðað av vegna fyribils $param styrkital.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param tekur bert við avbjóðingum frá vinum.';
  }

  @override
  String get challengeDeclineGeneric => 'Eg taki ikki móti avbjóðingum í løtuni.';

  @override
  String get challengeDeclineLater => 'Eg taki ikki ímóti avbjóðingum í løtuni. Spyr vinaliga aftur seinni.';

  @override
  String get challengeDeclineTooFast => 'Henda tíðarásetingin er ov skjót fyri meg. Bjóða mær vinaliga av aftur við einum seinførari talvi.';

  @override
  String get challengeDeclineTooSlow => 'Henda tíðarásetingin er ov sein fyri meg. Bjóða mær vinaliga av aftur við einum skjótari talvi.';

  @override
  String get challengeDeclineTimeControl => 'Eg taki ikki móti avbjóðingum við hesari tíðarásetingini.';

  @override
  String get challengeDeclineRated => 'Send mær vinaliga eina styrkismetta avbjóðing ístaðin.';

  @override
  String get challengeDeclineCasual => 'Send mær vinaliga eina óformella avbjóðing ístaðin.';

  @override
  String get challengeDeclineStandard => 'Eg taki ikki ímóti avbrigdisavbjóðingum í løtuni.';

  @override
  String get challengeDeclineVariant => 'Eg eri ikki sinnað/ur at telva hetta avbrigdið beint nú.';

  @override
  String get challengeDeclineNoBot => 'Eg taki ikki móti avbjóðingum frá teldum.';

  @override
  String get challengeDeclineOnlyBot => 'Eg taki bert móti avbjóðingum frá teldum.';

  @override
  String get challengeInviteLichessUser => 'Or invite a Lichess user:';

  @override
  String get contactContact => 'Samband';

  @override
  String get contactContactLichess => 'Set teg í samband við Lichess';

  @override
  String get patronDonate => 'Stuðla';

  @override
  String get patronLichessPatron => 'Lichess stuðul';

  @override
  String perfStatPerfStats(String param) {
    return '$param stats';
  }

  @override
  String get perfStatViewTheGames => 'View the games';

  @override
  String get perfStatProvisional => 'provisional';

  @override
  String get perfStatNotEnoughRatedGames => 'Not enough rated games have been played to establish a reliable rating.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progression over the last $param games:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Rating deviation: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Lower value means the rating is more stable. Above $param1, the rating is considered provisional. To be included in the rankings, this value should be below $param2 (standard chess) or $param3 (variants).';
  }

  @override
  String get perfStatTotalGames => 'Total games';

  @override
  String get perfStatRatedGames => 'Rated games';

  @override
  String get perfStatTournamentGames => 'Tournament games';

  @override
  String get perfStatBerserkedGames => 'Berserked games';

  @override
  String get perfStatTimeSpentPlaying => 'Time spent playing';

  @override
  String get perfStatAverageOpponent => 'Average opponent';

  @override
  String get perfStatVictories => 'Victories';

  @override
  String get perfStatDefeats => 'Defeats';

  @override
  String get perfStatDisconnections => 'Disconnections';

  @override
  String get perfStatNotEnoughGames => 'Not enough games played';

  @override
  String perfStatHighestRating(String param) {
    return 'Highest rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Lowest rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'from $param1 to $param2';
  }

  @override
  String get perfStatWinningStreak => 'Winning streak';

  @override
  String get perfStatLosingStreak => 'Losing streak';

  @override
  String perfStatLongestStreak(String param) {
    return 'Longest streak: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Current streak: $param';
  }

  @override
  String get perfStatBestRated => 'Best rated victories';

  @override
  String get perfStatGamesInARow => 'Games played in a row';

  @override
  String get perfStatLessThanOneHour => 'Less than one hour between games';

  @override
  String get perfStatMaxTimePlaying => 'Max time spent playing';

  @override
  String get perfStatNow => 'nú';

  @override
  String get preferencesPreferences => 'Stillingar';

  @override
  String get preferencesDisplay => 'Display';

  @override
  String get preferencesPrivacy => 'Privacy';

  @override
  String get preferencesNotifications => 'Notifications';

  @override
  String get preferencesPieceAnimation => 'Snið á talvfólki';

  @override
  String get preferencesMaterialDifference => 'Virðismunur';

  @override
  String get preferencesBoardHighlights => 'Upplýstir talvpuntar (seinasti leikur og skák)';

  @override
  String get preferencesPieceDestinations => 'Ætlingastaðir (lógligir leikir)';

  @override
  String get preferencesBoardCoordinates => 'Talvborðskrosstøl (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Leikalisti, meðan telvað verður';

  @override
  String get preferencesPgnPieceNotation => 'Teknskipan';

  @override
  String get preferencesChessPieceSymbol => 'Talvfólkaímyndir';

  @override
  String get preferencesPgnLetter => 'Bókstavir (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zenstøða';

  @override
  String get preferencesShowPlayerRatings => 'Show player ratings';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'This hides all ratings from Lichess, to help focus on the chess. Rated games still impact your rating, this is only about what you get to see.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Vís tól at vaksa og minka um talvborðið';

  @override
  String get preferencesOnlyOnInitialPosition => 'Bert við byrjanarstøðu';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Talvklokka';

  @override
  String get preferencesTenthsOfSeconds => 'Tíggjundapartar av sekundum';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Tá ið minni enn 10 sekund eru eftir';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Vatnrættar grønar framgongulinjur';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Ljóð, tá ið lítil tíð er eftir';

  @override
  String get preferencesGiveMoreTime => 'Gev meira tíð';

  @override
  String get preferencesGameBehavior => 'Hvussu telvað verður';

  @override
  String get preferencesHowDoYouMovePieces => 'Hvussu flytir tú fólkini?';

  @override
  String get preferencesClickTwoSquares => 'Klikk á tveir puntar';

  @override
  String get preferencesDragPiece => 'Drag talvfólkið';

  @override
  String get preferencesBothClicksAndDrag => 'Bæði';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Forhandarleikur (at leika, meðan mótparturin eigur leik)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Afturtøka (við loyvi frá mótleikaranum)';

  @override
  String get preferencesInCasualGamesOnly => 'Bert í talvum, ið ikki ávirka styrkitøl';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Umskapa til frúgv sjálvvirkið';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'Við forhandarleikum';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Krev remis sjálvvirkið aftaná trífalda endurtøku';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Tá ið minni enn 30 sekund eru eftir';

  @override
  String get preferencesMoveConfirmation => 'Vátta leik';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Brævtalv';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Brævtalv og óavmarkað';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Vátta, tá ið tú gevur upp ella býður remis';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Háttur at leypa í borg';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Flyt kongin tveir puntar';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Flyt kongin yvir á rókin';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Skriva leikirnar við lyklaborðinum';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Vís lógligar leikir við pílum';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Sig \"Gott talv, væl telvað,\" tá ið tú vinnur ella telvar javnt';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Tínar stillingar eru goymdar.';

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
  String get preferencesBlindfold => 'Blindfold';

  @override
  String get puzzlePuzzles => 'Uppgávur';

  @override
  String get puzzlePuzzleThemes => 'Uppgávuevni';

  @override
  String get puzzleRecommended => 'Viðmældar uppgávur';

  @override
  String get puzzlePhases => 'Skifti';

  @override
  String get puzzleMotifs => 'Ætlanir';

  @override
  String get puzzleAdvanced => 'Framkomið stig';

  @override
  String get puzzleLengths => 'Longdir';

  @override
  String get puzzleMates => 'Mát';

  @override
  String get puzzleGoals => 'Mál';

  @override
  String get puzzleOrigin => 'Uppruni';

  @override
  String get puzzleSpecialMoves => 'Serligir leikir';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Dámdi tær hesa uppgávuna?';

  @override
  String get puzzleVoteToLoadNextOne => 'Atkvøð at innlesa ta næstu!';

  @override
  String get puzzleUpVote => 'Up vote puzzle';

  @override
  String get puzzleDownVote => 'Down vote puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Your puzzle rating will not change. Note that puzzles are not a competition. Your rating helps selecting the best puzzles for your current skill.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Finn besta leikin hjá hvítum.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Finn besta leikin hjá svørtum.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Fá uppgávur lagaðar til tín:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Uppgáva $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Dagsins talvuppgáva';

  @override
  String get puzzleDailyPuzzle => 'Daily Puzzle';

  @override
  String get puzzleClickToSolve => 'Klikk á at loysa';

  @override
  String get puzzleGoodMove => 'Góður leikur';

  @override
  String get puzzleBestMove => 'Besti leikur!';

  @override
  String get puzzleKeepGoing => 'Halt fram…';

  @override
  String get puzzlePuzzleSuccess => 'Tað eydnaðist!';

  @override
  String get puzzlePuzzleComplete => 'Uppgávan er loyst!';

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
  String get puzzleNotTheMove => 'Hatta er ikki rætti leikurin!';

  @override
  String get puzzleTrySomethingElse => 'Royn okkurt annað.';

  @override
  String puzzleRatingX(String param) {
    return 'Styrkital: $param';
  }

  @override
  String get puzzleHidden => 'fjalt';

  @override
  String puzzleFromGameLink(String param) {
    return 'Úr talvi $param';
  }

  @override
  String get puzzleContinueTraining => 'Halt fram við venjing';

  @override
  String get puzzleDifficultyLevel => 'Torleikastig';

  @override
  String get puzzleNormal => 'Vanligt';

  @override
  String get puzzleEasier => 'Lættari';

  @override
  String get puzzleEasiest => 'Einfaldasta';

  @override
  String get puzzleHarder => 'Truplari';

  @override
  String get puzzleHardest => 'Truplasta';

  @override
  String get puzzleExample => 'Dømi';

  @override
  String get puzzleAddAnotherTheme => 'Legg eitt nýtt tema aftrat';

  @override
  String get puzzleNextPuzzle => 'Next puzzle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Far til næstu uppgávu beinanvegin';

  @override
  String get puzzlePuzzleDashboard => 'Uppgávuyvirlit';

  @override
  String get puzzleImprovementAreas => 'Øki at bøta um';

  @override
  String get puzzleStrengths => 'Styrkir';

  @override
  String get puzzleHistory => 'Uppgávusøga';

  @override
  String get puzzleSolved => 'loyst';

  @override
  String get puzzleFailed => 'miseydnaðist';

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
      other: 'Telvað $count ferðir',
      one: 'Telvað $count ferð',
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
  String get puzzleThemeAdvancedPawn => 'Frífinna';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Ein finna, ið umskapast ella hóttir við at umskapast, er lykilin til taktikkin.';

  @override
  String get puzzleThemeAdvantage => 'Fyrimunur';

  @override
  String get puzzleThemeAdvantageDescription => 'Tak av møguleikanum at fáa avgerandi fyrimun. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mát Anastasiu';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Riddari og rókur ella frúgv samstarva um at fanga mótstøðukongin millum síðuna á talvborðinum og eitt vinarligt sinnað fólk.';

  @override
  String get puzzleThemeArabianMate => 'Arábiskt mát';

  @override
  String get puzzleThemeArabianMateDescription => 'Ein riddari og ein rókur samstarva um at fanga mótstøðukongin í einum av hornunum á talvborðinum.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Álop á f2 ella f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Eitt álop, ið savnar seg um f2 ella f7-finnuna, eins og í fegatello-álopinum (Fried Liver Attack).';

  @override
  String get puzzleThemeAttraction => 'Atdráttur';

  @override
  String get puzzleThemeAttractionDescription => 'Eitt umbýti ella offur, ið eggjar ella noyðir eitt mótleikarafólk til ein punt, ið síðani letur upp fyri eini taktiskari atgerð.';

  @override
  String get puzzleThemeBackRankMate => 'Mát á aftasta rað';

  @override
  String get puzzleThemeBackRankMateDescription => 'Set kongin skák og mát á aftasta rað, har egnu fólk hansara byrgja hann inni.';

  @override
  String get puzzleThemeBishopEndgame => 'Bispaendaspæl';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Endaspæl við bispum og finnum.';

  @override
  String get puzzleThemeBodenMate => 'Bodensmát';

  @override
  String get puzzleThemeBodenMateDescription => 'Tveir bispar, ið leypa á á krossandi hornalinjum (diagonalum), seta kongin, ið er forðaður av sínum egna fólki, skák og mát.';

  @override
  String get puzzleThemeCastling => 'At leypa í borg';

  @override
  String get puzzleThemeCastlingDescription => 'Flyt kongin í tryggleika, og tak rókin í nýtslu, so hann fær lopið á.';

  @override
  String get puzzleThemeCapturingDefender => 'Tak fólkið, ið verjir';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'At beina eitt fólk burtur, ið hevur týdning í verjuni av einum øðrum fólki. Hetta ger tað møguligt at taka fólkið, ið nú er óvart, í einum seinni leiki.';

  @override
  String get puzzleThemeCrushing => 'At knúsa';

  @override
  String get puzzleThemeCrushingDescription => 'Finn mistakið hjá mótleikaranum til tess at ogna tær knúsandi fyrimun. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Tvífalt bispamát';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Tveir bispar, ið leypa á á tveimum grannahornalinjum, seta kongin, ið er forðaður av sínum egna fólki, skák og mát.';

  @override
  String get puzzleThemeDovetailMate => 'Sýlt mát (dúgvuvelamát)';

  @override
  String get puzzleThemeDovetailMateDescription => 'Ein frúgv stendur beint við mótstøðukongin og setir hann skák og mát, tí at kongsins egnu fólk forða konginum í at flýggja til einastu tveir puntarnar, ið eru tøkir.';

  @override
  String get puzzleThemeEquality => 'Javnstøða';

  @override
  String get puzzleThemeEqualityDescription => 'Kom afturíaftur úr eini tapandi støðu, og tryggja tær remis ella eina javna støðu. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Álop kongamegin';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Álop á mótstøðukongin, aftaná at hann er lopin í borg kongamegin.';

  @override
  String get puzzleThemeClearance => 'Rudding';

  @override
  String get puzzleThemeClearanceDescription => 'Ein leikur, ofta við tempo, ið ruddar ein punt, eitt rað ella eina tvørlinju, ið gevur møguleika fyri einari taktiskari atgerð.';

  @override
  String get puzzleThemeDefensiveMove => 'Verjuleikur';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Ein ávísur leikur ella ein røð av leikum, ið eru neyðugir, um sleppast skal undan at missa fólk ella annan fyrimun.';

  @override
  String get puzzleThemeDeflection => 'Avbending';

  @override
  String get puzzleThemeDeflectionDescription => 'Ein leikur, ið dregur eitt mótstøðufólk burtur frá at útynna eina aðra uppgávu; eitt nú at ansa eftir einum týdningarmiklum punti.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Avdúkað álop';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'At flyta eitt fólk, ið frammanundan forðaði einum fólki í at leypa á; eitt nú at flyta ein riddara, ið stendur framman fyri ein rók.';

  @override
  String get puzzleThemeDoubleCheck => 'Tvískák';

  @override
  String get puzzleThemeDoubleCheckDescription => 'At skáka við tveimum fólkum samstundis. Úrslit av einum ávdúkaraálopi, har bæði fólkið, ið flutti, og fólkið, ið varð avdúkað, leypa á mótstøðukongin.';

  @override
  String get puzzleThemeEndgame => 'Endatalv';

  @override
  String get puzzleThemeEndgameDescription => 'Taktisk atgerð í seinasta skeiðinum av talvinum.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktisk atgerð, ið inniber at taka í framlopi, har ein finna kann taka eina mótstøðufinnu, ið er komin at standa undir liðini á henni, aftaná at finnan í fyrsta leiki sínum júst er flutt tveir puntar fram.';

  @override
  String get puzzleThemeExposedKing => 'Kongur í andgletti';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktisk atgerð móti kongi, ið bert hevur fá verndarfólk um seg. Ber ofta skák og mát við sær.';

  @override
  String get puzzleThemeFork => 'Gaffil';

  @override
  String get puzzleThemeForkDescription => 'Leikur, har flutta fólkið loypur á tvey mótstøðufólk í senn.';

  @override
  String get puzzleThemeHangingPiece => 'Hangandi fólk';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktisk atgerð móti einum mótstøðufólki, ið ikki er vart ella ikki nóg væl vart, og tí lætt at taka.';

  @override
  String get puzzleThemeHookMate => 'Húkamát';

  @override
  String get puzzleThemeHookMateDescription => 'Skák og mát við róki, riddara og finnu, sum saman við einari fíggindafinnu forða mótstøðukonginum í at sleppa til rýmingar.';

  @override
  String get puzzleThemeInterference => 'Uppílegging';

  @override
  String get puzzleThemeInterferenceDescription => 'Flyt eitt fólk millum tvey mótstøðufólk, so annað mótstøðufólkið stendur óvart ella bæði standa óvard; flyt t.d. ein riddara á ein vardan punt millum tveir rókar.';

  @override
  String get puzzleThemeIntermezzo => 'Millumleikur';

  @override
  String get puzzleThemeIntermezzoDescription => 'Ístaðin fyri at leika tann væntaða leikin, skalt tú leika ein annan leik, ið er ein hóttandi vandi, ið mótleikarin má varða seg ímóti her og nú. Leikurin er eisini kendur sum \"Zwischenzug\" ella \"In between\".';

  @override
  String get puzzleThemeKnightEndgame => 'Riddaraendatalv';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Endatalv við riddarum og finnum.';

  @override
  String get puzzleThemeLong => 'Long uppgáva';

  @override
  String get puzzleThemeLongDescription => 'Tríggir leikir, so er vunnið.';

  @override
  String get puzzleThemeMaster => 'Meistaratalv';

  @override
  String get puzzleThemeMasterDescription => 'Uppgávur úr talvum, ið telvarar við meistaraheitum hava telvað.';

  @override
  String get puzzleThemeMasterVsMaster => 'Meistari móti meistaratalvum';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Uppgávur úr talvum millum tveir telvarar við meistaraheitum.';

  @override
  String get puzzleThemeMate => 'Mát';

  @override
  String get puzzleThemeMateDescription => 'Vinn talvið við stíli.';

  @override
  String get puzzleThemeMateIn1 => 'Mát í einum';

  @override
  String get puzzleThemeMateIn1Description => 'Set skák og mát í einum leiki.';

  @override
  String get puzzleThemeMateIn2 => 'Mát í tveimum';

  @override
  String get puzzleThemeMateIn2Description => 'Set skák og mát í tveimum leikum.';

  @override
  String get puzzleThemeMateIn3 => 'Mát í trimum';

  @override
  String get puzzleThemeMateIn3Description => 'Set skák og mát í trimum leikum.';

  @override
  String get puzzleThemeMateIn4 => 'Mát í fýra';

  @override
  String get puzzleThemeMateIn4Description => 'Set skák og mát í fýra leikum.';

  @override
  String get puzzleThemeMateIn5 => 'Mát í fimm ella fleiri';

  @override
  String get puzzleThemeMateIn5Description => 'Finn útav eini langari mátraðfylgju.';

  @override
  String get puzzleThemeMiddlegame => 'Miðtalv';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktisk atgerð í seinna skeiði av talvinum.';

  @override
  String get puzzleThemeOneMove => 'Uppgáva við einum leiki';

  @override
  String get puzzleThemeOneMoveDescription => 'Uppgáva, ið bert krevur ein leik.';

  @override
  String get puzzleThemeOpening => 'Byrjanartalv';

  @override
  String get puzzleThemeOpeningDescription => 'Taktisk atgerð í fyrsta skeiðinum av talvinum.';

  @override
  String get puzzleThemePawnEndgame => 'Finnuendatalv';

  @override
  String get puzzleThemePawnEndgameDescription => 'Endatalv við finnum burturav.';

  @override
  String get puzzleThemePin => 'Binding';

  @override
  String get puzzleThemePinDescription => 'Taktisk atgerð við bindingum, har eitt fólk ikki er ført fyri at flyta uttan at lata upp fyri álopi á eitt fólk við hægri virði.';

  @override
  String get puzzleThemePromotion => 'Umskapan';

  @override
  String get puzzleThemePromotionDescription => 'Ein finna, ið umskapast ella hóttir við at umskapast, er lykilin til taktikkin.';

  @override
  String get puzzleThemeQueenEndgame => 'Frúgvaendatalv';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Endatalv við frúgvum og finnum burturav.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Frúgv og rókur';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Endatalv við frúm, rókum og finnum.';

  @override
  String get puzzleThemeQueensideAttack => 'Álop frúgvamegin';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Álop á mótstøðukongin, aftaná at hann er lopin í borg frúgvamegin.';

  @override
  String get puzzleThemeQuietMove => 'Stillførur leikur';

  @override
  String get puzzleThemeQuietMoveDescription => 'Leikur, ið hvørki skákar ella tekur, men slóðar fyri eini hóttan, ið ikki slepst undan, í einum seinni leiki.';

  @override
  String get puzzleThemeRookEndgame => 'Rókaendatalv';

  @override
  String get puzzleThemeRookEndgameDescription => 'Endatalv við rókum og finnum.';

  @override
  String get puzzleThemeSacrifice => 'Offur';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktisk atgerð, ið inniber at geva fólk burtur, við tí fyri eyga at vinna sær ein fyrimun seinni aftaná eina røð av tvungnum leikum.';

  @override
  String get puzzleThemeShort => 'Stutt uppgáva';

  @override
  String get puzzleThemeShortDescription => 'Tveir leikir, so er vunnið.';

  @override
  String get puzzleThemeSkewer => 'Spjót';

  @override
  String get puzzleThemeSkewerDescription => 'Ein hugsan, ið inniber, at eitt fólk við høgum virði, ið verður álopið, flytur burtur, soleiðis at eitt fólk við lægri virði kann verða tikið ella vera fyri álopi. Tað øvuta av eini binding.';

  @override
  String get puzzleThemeSmotheredMate => 'Kvalt mát';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Skák og mát, framt av einum riddara, har mátaði kongurin ikki er førur fyri at flyta, tí at hann er umgyrdur (ella kvaldur) av egnum fólki.';

  @override
  String get puzzleThemeSuperGM => 'Superstórmeistaratalv';

  @override
  String get puzzleThemeSuperGMDescription => 'Uppgávur úr talvum, ið heimsins bestu telvarar hava telvað.';

  @override
  String get puzzleThemeTrappedPiece => 'Innibyrgt fólk';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Eitt fólk er ikki ført fyri at sleppa sær undan at verða tikið, tí tað hevur avmarkaðar leikmøguleikar.';

  @override
  String get puzzleThemeUnderPromotion => 'Undirumskapan';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Umskapan til riddara, bisp ella rók.';

  @override
  String get puzzleThemeVeryLong => 'Sera long uppgáva';

  @override
  String get puzzleThemeVeryLongDescription => 'Fýra leikir ella fleiri til tess at vinna.';

  @override
  String get puzzleThemeXRayAttack => 'Geisling';

  @override
  String get puzzleThemeXRayAttackDescription => 'Eitt fólk loypur á ella verjir ein punt gjøgnum eitt mótstøðufólk.';

  @override
  String get puzzleThemeZugzwang => 'Leiktvingsil';

  @override
  String get puzzleThemeZugzwangDescription => 'Mótleikarin hevur avmarkaðar møguleikar at flyta, og allir leikir gera støðu hansara verri.';

  @override
  String get puzzleThemeMix => 'Sunt bland';

  @override
  String get puzzleThemeMixDescription => 'Eitt sindur av øllum. Tú veitst ikki, hvat tú kanst vænta tær, so ver til reiðar til alt! Júst sum í veruligum talvum.';

  @override
  String get puzzleThemePlayerGames => 'Player games';

  @override
  String get puzzleThemePlayerGamesDescription => 'Lookup puzzles generated from your games, or from another player\'s games.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'These puzzles are in the public domain, and can be downloaded from $param.';
  }

  @override
  String get searchSearch => 'Leita';

  @override
  String get settingsSettings => 'Stillingar';

  @override
  String get settingsCloseAccount => 'Lat kontu aftur';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Your account is managed, and cannot be closed.';

  @override
  String get settingsClosingIsDefinitive => 'At lata eina kontu aftur er endaligt. Til ber ikki at venda við. Ert tú vís/ur í hesum?';

  @override
  String get settingsCantOpenSimilarAccount => 'Tú fært ikki loyvi at lata eina nýggja kontu upp við sama navni. Ei heldur, um bókstavirnir eru við stórum ella lítlum.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Eg broytti meining. Lat ikki kontu mína aftur';

  @override
  String get settingsCloseAccountExplanation => 'Ert tú vís/ur í, at tú vilt lata kontu tína aftur? Hetta er ein endalig avgerð. Tað fer ikki at bera til at logga á aftur.';

  @override
  String get settingsThisAccountIsClosed => 'Henda konta er afturlatin.';

  @override
  String get playWithAFriend => 'Telva móti einum vini';

  @override
  String get playWithTheMachine => 'Telva móti telduni';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Bjóða einum at telva við at geva honum hesa adressuna';

  @override
  String get gameOver => 'Talvið er liðugt';

  @override
  String get waitingForOpponent => 'Bíða eftir móttelvara';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Bíða';

  @override
  String get yourTurn => 'Tú eigur leik';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 stig $param2';
  }

  @override
  String get level => 'Stig';

  @override
  String get strength => 'Styrki';

  @override
  String get toggleTheChat => 'Goym/Vís kjatt';

  @override
  String get chat => 'Kjatta';

  @override
  String get resign => 'Legg kong';

  @override
  String get checkmate => 'Skák og mát';

  @override
  String get stalemate => 'Pattstøða';

  @override
  String get white => 'Hvítur';

  @override
  String get black => 'Svartur';

  @override
  String get asWhite => 'við hvítum';

  @override
  String get asBlack => 'við svørtum';

  @override
  String get randomColor => 'Tilvildarligur litur';

  @override
  String get createAGame => 'Byrja eitt talv';

  @override
  String get whiteIsVictorious => 'Hvítur hevur vunnið';

  @override
  String get blackIsVictorious => 'Svartur hevur vunnið';

  @override
  String get youPlayTheWhitePieces => 'Tú telvar við hvítum';

  @override
  String get youPlayTheBlackPieces => 'Tú telvar við svørtum';

  @override
  String get itsYourTurn => 'Tú eigur leik!';

  @override
  String get cheatDetected => 'Snýt uppdagað';

  @override
  String get kingInTheCenter => 'Kongur í miðjuni';

  @override
  String get threeChecks => 'Trý skák';

  @override
  String get raceFinished => 'Kapprenning liðug';

  @override
  String get variantEnding => 'Avbrigdarendi';

  @override
  String get newOpponent => 'Nýggjur móttelvari';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Tín móttelvari vil telva móti tær av nýggjum';

  @override
  String get joinTheGame => 'Byrja talvið';

  @override
  String get whitePlays => 'Hvítur eigur leik';

  @override
  String get blackPlays => 'Svartur eigur leik';

  @override
  String get opponentLeftChoices => 'Tín móttelvari er farin frá talvinum. Tú kanst antin krevja sigur, siga tað vera remis ella bíða.';

  @override
  String get forceResignation => 'Krev sigur';

  @override
  String get forceDraw => 'Krev remis';

  @override
  String get talkInChat => 'Ver vinalig/ur í kjattinum!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Tann fyrsti persónurin, sum brúkar hesa adressuna, verður tín mótpartur.';

  @override
  String get whiteResigned => 'Hvítur leggur kong';

  @override
  String get blackResigned => 'Svartur legði kong';

  @override
  String get whiteLeftTheGame => 'Hvítur er farin frá talvinum';

  @override
  String get blackLeftTheGame => 'Svartur er farin frá talvinum';

  @override
  String get whiteDidntMove => 'Hvítur leikti ikki';

  @override
  String get blackDidntMove => 'Svartur leikti ikki';

  @override
  String get requestAComputerAnalysis => 'Bið um eina teldugreining';

  @override
  String get computerAnalysis => 'Teldugreining';

  @override
  String get computerAnalysisAvailable => 'Teldugreining tøk';

  @override
  String get computerAnalysisDisabled => 'Teldugreining óvirkin';

  @override
  String get analysis => 'Greiningarborð';

  @override
  String depthX(String param) {
    return 'Dýpd $param';
  }

  @override
  String get usingServerAnalysis => 'Nýtir ambætaragreining';

  @override
  String get loadingEngine => 'Inntekur engine ...';

  @override
  String get calculatingMoves => 'Roknar leikir út...';

  @override
  String get engineFailed => 'Maskinuinnlesing miseydnaðist';

  @override
  String get cloudAnalysis => 'Skíggjagreining';

  @override
  String get goDeeper => 'Greina djúpari';

  @override
  String get showThreat => 'Vís hóttan';

  @override
  String get inLocalBrowser => 'í tínum egna kaga';

  @override
  String get toggleLocalEvaluation => 'Slá meting til';

  @override
  String get promoteVariation => 'Flyt frábrigdi upp';

  @override
  String get makeMainLine => 'Ger til høvuðsleik';

  @override
  String get deleteFromHere => 'Tak burtur hiðani';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Noyð frábrigdi';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'Leikur';

  @override
  String get variantLoss => 'Avbrigdistap';

  @override
  String get variantWin => 'Avbrigdissigur';

  @override
  String get insufficientMaterial => 'Ov fá talvfólk eftir';

  @override
  String get pawnMove => 'Finnuleikur';

  @override
  String get capture => 'Tekur';

  @override
  String get close => 'Lat aftur';

  @override
  String get winning => 'Vinnur';

  @override
  String get losing => 'Tapir';

  @override
  String get drawn => 'Javnt';

  @override
  String get unknown => 'Ókent';

  @override
  String get database => 'Dátugrunnur';

  @override
  String get whiteDrawBlack => 'Hvítur / Javnt / Svartur';

  @override
  String averageRatingX(String param) {
    return 'Miðal styrkismeting: $param';
  }

  @override
  String get recentGames => 'Nýliga telvað talv';

  @override
  String get topGames => 'Bestu talv';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Tvær milliónir OTB talv hjá $param1+ FIDE-styrkismettum telvarum frá $param2 til $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' with rounding, based on number of half-moves until next capture or pawn move';

  @override
  String get noGameFound => 'Einki talv funnið';

  @override
  String get maxDepthReached => 'Max depth reached!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Vilt tú taka fleiri talv úr tínari egnu valmynd?';

  @override
  String get openings => 'Openings';

  @override
  String get openingExplorer => 'Rannsaka byrjanartalv';

  @override
  String get openingEndgameExplorer => 'Opening/endgame explorer';

  @override
  String xOpeningExplorer(String param) {
    return '$param rannsaka byrjanartalv';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => '50-leikareglan forðar fyri sigri';

  @override
  String get lossSavedBy50MoveRule => '50-leikareglan forðar fyri tapi';

  @override
  String get winOr50MovesByPriorMistake => 'Win or 50 moves by prior mistake';

  @override
  String get lossOr50MovesByPriorMistake => 'Loss or 50 moves by prior mistake';

  @override
  String get unknownDueToRounding => 'Win/loss only guaranteed if recommended tablebase line has been followed since the last capture or pawn move, due to possible rounding of DTZ values in Syzygy tablebases.';

  @override
  String get allSet => 'Til reiðar!';

  @override
  String get importPgn => 'Les inn PGN';

  @override
  String get delete => 'Strika';

  @override
  String get deleteThisImportedGame => 'Strika hetta innlisna talvið?';

  @override
  String get replayMode => 'Endurspælsháttur';

  @override
  String get realtimeReplay => 'Verulig tíð';

  @override
  String get byCPL => 'Við CPL';

  @override
  String get enable => 'Loyv';

  @override
  String get bestMoveArrow => 'Pílur fyri besta leik';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Eftirmetingarmát';

  @override
  String get multipleLines => 'Fleiri linjur';

  @override
  String get cpus => 'CPUir';

  @override
  String get memory => 'Minni';

  @override
  String get infiniteAnalysis => 'Óendalig greining';

  @override
  String get removesTheDepthLimit => 'Tekur dýpdaravmarkingar burtur, og heldur telduna hjá tær heita';

  @override
  String get blunder => 'Bukkur';

  @override
  String get mistake => 'Mistak';

  @override
  String get inaccuracy => 'Óneyvleiki';

  @override
  String get moveTimes => 'Leiktíðir';

  @override
  String get flipBoard => 'Vend borði við';

  @override
  String get threefoldRepetition => 'Endurtøka tríggjar ferðir';

  @override
  String get claimADraw => 'Krev remis (javnleik)';

  @override
  String get offerDraw => 'Bjóða remis';

  @override
  String get draw => 'Remis';

  @override
  String get drawByMutualAgreement => 'Remis eftir semju';

  @override
  String get fiftyMovesWithoutProgress => '50 leikir uttan framsókn';

  @override
  String get currentGames => 'Talv, ið verða telvað nú';

  @override
  String get viewInFullSize => 'Síggj í fullari stødd';

  @override
  String get logOut => 'Rita út';

  @override
  String get signIn => 'Rita inn';

  @override
  String get rememberMe => 'Keep me logged in';

  @override
  String get youNeedAnAccountToDoThat => 'Tær nýtist at hava eina konto at gera hetta';

  @override
  String get signUp => 'Skráset teg';

  @override
  String get computersAreNotAllowedToPlay => 'Teldur og telvarar, ið fáa hjálp frá teldum, hava ikki loyvi at telva. Bannað er at leita sær hjálp frá talvtólum (chess engines), dátugrunnum ella øðrum telvarum, meðan telvað verður. Gev eisini gætur, at tað verður staðiliga frámælt at fáa sær fleiri kontur, og telvarar við nógvum kontum, kunnu verða útihýstir.';

  @override
  String get games => 'Talv';

  @override
  String get forum => 'Talvtos';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 legði út á evninum $param2';
  }

  @override
  String get latestForumPosts => 'Seinastu uppsløg';

  @override
  String get players => 'Telvarar';

  @override
  String get friends => 'Vinir';

  @override
  String get otherPlayers => 'other players';

  @override
  String get discussions => 'Samrøður';

  @override
  String get today => 'Í dag';

  @override
  String get yesterday => 'Í gjár';

  @override
  String get minutesPerSide => 'Minuttir í part';

  @override
  String get variant => 'Avbrigdi';

  @override
  String get variants => 'Avbrigdi';

  @override
  String get timeControl => 'Tíðaravmarking';

  @override
  String get realTime => 'Verulig tíð';

  @override
  String get correspondence => 'Brævtalv';

  @override
  String get daysPerTurn => 'Dagar fyri hvønn leik';

  @override
  String get oneDay => 'Ein dag';

  @override
  String get time => 'Tíð';

  @override
  String get rating => 'Styrkital';

  @override
  String get ratingStats => 'Styrkitalastøða';

  @override
  String get username => 'Brúkaranavn';

  @override
  String get usernameOrEmail => 'Brúkaranavn ella teldupostbústaður';

  @override
  String get changeUsername => 'Broyt brúkaranavn';

  @override
  String get changeUsernameNotSame => 'Til ber bert at broyta støddina á bókstøvunum. T. d. \"fípanfagra\" til \"FípanFagra\".';

  @override
  String get changeUsernameDescription => 'Broyt brúkaranavn títt. Hetta ber bert til at gera eina ferð, og tú kanst bert broyta, hvørt bókstavirnir eru við stórum ella lítlum.';

  @override
  String get signupUsernameHint => 'Make sure to choose a family-friendly username. You cannot change it later and any accounts with inappropriate usernames will get closed!';

  @override
  String get signupEmailHint => 'We will only use it for password reset.';

  @override
  String get password => 'Loyniorð';

  @override
  String get changePassword => 'Broyt loyniorð';

  @override
  String get changeEmail => 'Broyt teldupost';

  @override
  String get email => 'Teldupostur';

  @override
  String get passwordReset => 'Endurset loyniorð';

  @override
  String get forgotPassword => 'Gloymt loyniorð?';

  @override
  String get error_weakPassword => 'This password is extremely common, and too easy to guess.';

  @override
  String get error_namePassword => 'Please don\'t use your username as your password.';

  @override
  String get blankedPassword => 'You have used the same password on another site, and that site has been compromised. To ensure the safety of your Lichess account, we need you to set a new password. Thank you for your understanding.';

  @override
  String get youAreLeavingLichess => 'Tú fert nú úr Lichess';

  @override
  String get neverTypeYourPassword => 'Skriva ongantíð títt Lichess loyniorð á aðra síðu!';

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
  String get rank => 'Støða';

  @override
  String rankX(String param) {
    return 'Støða: $param';
  }

  @override
  String get gamesPlayed => 'Talv telvað';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Ógilda';

  @override
  String get whiteTimeOut => 'Tíð uppi hjá hvítum';

  @override
  String get blackTimeOut => 'Tíð uppi hjá svørtum';

  @override
  String get drawOfferSent => 'Tilboð um javnleik sent';

  @override
  String get drawOfferAccepted => 'Tilboð um javnleik góðtikið';

  @override
  String get drawOfferCanceled => 'Tilboð um javnleik avlýst';

  @override
  String get whiteOffersDraw => 'Hvítur bjóðar javnt';

  @override
  String get blackOffersDraw => 'Svartur bjóðar javnt';

  @override
  String get whiteDeclinesDraw => 'Hvítur tekur ikki av javnleiki';

  @override
  String get blackDeclinesDraw => 'Svartur tekur ikki av javnleiki';

  @override
  String get yourOpponentOffersADraw => 'Mótleikarin bjóðar tær javnt';

  @override
  String get accept => 'Góðtak';

  @override
  String get decline => 'Havna';

  @override
  String get playingRightNow => 'Verður telvað beint nú';

  @override
  String get eventInProgress => 'Telvað beint nú';

  @override
  String get finished => 'Liðugt';

  @override
  String get abortGame => 'Enda talvið';

  @override
  String get gameAborted => 'Talvið varð brotið av';

  @override
  String get standard => 'Vanligt';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Óavmarkað';

  @override
  String get mode => 'Støða';

  @override
  String get casual => 'Óformelt';

  @override
  String get rated => 'Styrkismett';

  @override
  String get casualTournament => 'Óformelt';

  @override
  String get ratedTournament => 'Styrkismett';

  @override
  String get thisGameIsRated => 'Hetta talv verður styrkimett';

  @override
  String get rematch => 'Umaftur';

  @override
  String get rematchOfferSent => 'Tilboð um nýtt talv sent';

  @override
  String get rematchOfferAccepted => 'Tilboð um nýtt talv góðtikið';

  @override
  String get rematchOfferCanceled => 'Tilboð um nýtt talv avlýst';

  @override
  String get rematchOfferDeclined => 'Tilboð um nýtt talv afturvíst';

  @override
  String get cancelRematchOffer => 'Avlýs tilboð um nýtt talv';

  @override
  String get viewRematch => 'Hygg at nýggjum talvi';

  @override
  String get confirmMove => 'Játta leik';

  @override
  String get play => 'Telva';

  @override
  String get inbox => 'Innbakki';

  @override
  String get chatRoom => 'Kjattrúm';

  @override
  String get loginToChat => 'Rita inn at kjatta';

  @override
  String get youHaveBeenTimedOut => 'Tú hevur fingið leikbrá.';

  @override
  String get spectatorRoom => 'Áskoðararúm';

  @override
  String get composeMessage => 'Skriva eini boð';

  @override
  String get subject => 'Evni';

  @override
  String get send => 'Send';

  @override
  String get incrementInSeconds => 'Vøkstur í sekundum';

  @override
  String get freeOnlineChess => 'Ókeypis talv á netinum';

  @override
  String get exportGames => 'Flyt út talv';

  @override
  String get ratingRange => 'Styrkitalaspenni';

  @override
  String get thisAccountViolatedTos => 'Ánarin av hesari konto breyt Lichess tænastutreytirnar';

  @override
  String get openingExplorerAndTablebase => 'Lat dátugrunn við byrjanar- og endatalvum upp';

  @override
  String get takeback => 'Tak aftur';

  @override
  String get proposeATakeback => 'Ber fram ynski um afturtøku';

  @override
  String get takebackPropositionSent => 'Boð um afturtøku sent';

  @override
  String get takebackPropositionDeclined => 'Afturtøka havnað';

  @override
  String get takebackPropositionAccepted => 'Afturtøka góðtikin';

  @override
  String get takebackPropositionCanceled => 'Afturtøka avlýst';

  @override
  String get yourOpponentProposesATakeback => 'Mótleikarin ber fram ynski um afturtøku';

  @override
  String get bookmarkThisGame => 'Set bókamerki við hetta talvið';

  @override
  String get tournament => 'Kapping';

  @override
  String get tournaments => 'Kappingar';

  @override
  String get tournamentPoints => 'Kappingastig';

  @override
  String get viewTournament => 'Hygg at kapping';

  @override
  String get backToTournament => 'Aftur til kapping';

  @override
  String get noDrawBeforeSwissLimit => 'You cannot draw before 30 moves are played in a Swiss tournament.';

  @override
  String get thematic => 'Evnislýsandi';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Títt $param styrkital er fyribils';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Títt $param1 styrkital ($param2) er ov høgt';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Títt vikuliga $param1 styrkital ($param2) er ov høgt';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Títt $param1 styrkital ($param2) er ov lágt';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Styrkismettur ≥ $param1 í $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Styrkismettur ≤ $param1 í $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Tær nýtist at vera á $param liðnum';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Tú ert ikki á liðnum $param';
  }

  @override
  String get backToGame => 'Aftur til talvið';

  @override
  String get siteDescription => 'Ókeypis netborin talvambætari. Neyðugt er ikki við skráseting ella ískoytisforriti, og ongar lýsingar eru. Telva móti telduni, vinum ella tilvildarligum mótleikarum.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 kom upp í liðið $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 stovnaði liðið $param2';
  }

  @override
  String get startedStreaming => 'started streaming';

  @override
  String xStartedStreaming(String param) {
    return '$param byrjaði at stroyma';
  }

  @override
  String get averageElo => 'Miðalstyrkital';

  @override
  String get location => 'Staður';

  @override
  String get filterGames => 'Sálda talv frá';

  @override
  String get reset => 'Endurset';

  @override
  String get apply => 'Vátta';

  @override
  String get save => 'Goym';

  @override
  String get leaderboard => 'Stigatalva';

  @override
  String get screenshotCurrentPosition => 'Screenshot current position';

  @override
  String get gameAsGIF => 'Game as GIF';

  @override
  String get pasteTheFenStringHere => 'Flyt FEN tekstin higar';

  @override
  String get pasteThePgnStringHere => 'Flyt PGN tekstin higar';

  @override
  String get orUploadPgnFile => 'Or upload a PGN file';

  @override
  String get fromPosition => 'Frá støðuni';

  @override
  String get continueFromHere => 'Halt fram hiðani';

  @override
  String get toStudy => 'Rannsókn';

  @override
  String get importGame => 'Les inn talv';

  @override
  String get importGameExplanation => 'Flyt PGN úr einum talvi higar. Fá eitt endurspæl, tú kanst kaga í, teldugreining, talvkjatt og PGN, sum til ber at deila við onnur.';

  @override
  String get importGameCaveat => 'Variations will be erased. To keep them, import the PGN via a study.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Hetta er eitt talv-CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klikk á borðið at leika, og prógva, tú ert eitt menniskja.';

  @override
  String get captcha_fail => 'Loys vinaliga talv-CAPTCHA\'ið.';

  @override
  String get notACheckmate => 'Ikki skák og mát';

  @override
  String get whiteCheckmatesInOneMove => 'Hvítur setir skák og mát í einum leiki';

  @override
  String get blackCheckmatesInOneMove => 'Svartur setir skák og mát í einum leiki';

  @override
  String get retry => 'Royn aftur';

  @override
  String get reconnecting => 'Bindur saman aftur';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Yndismótleikarar';

  @override
  String get follow => 'Fylg';

  @override
  String get following => 'Fylgir';

  @override
  String get unfollow => 'Fylg ikki';

  @override
  String followX(String param) {
    return 'Fylg $param';
  }

  @override
  String unfollowX(String param) {
    return 'Steðga at fylgja $param';
  }

  @override
  String get block => 'Forða';

  @override
  String get blocked => 'Forðaður';

  @override
  String get unblock => 'Forða ikki';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 byrjaði at fylgja $param2';
  }

  @override
  String get more => 'Meira';

  @override
  String get memberSince => 'Limur síðani';

  @override
  String lastSeenActive(String param) {
    return 'Virkin $param';
  }

  @override
  String get player => 'Telvari';

  @override
  String get list => 'Listi';

  @override
  String get graph => 'Strikumynd';

  @override
  String get required => 'Kravt.';

  @override
  String get openTournaments => 'Opnar kappingar';

  @override
  String get duration => 'Longd';

  @override
  String get winner => 'Vinnari';

  @override
  String get standing => 'Støðan';

  @override
  String get createANewTournament => 'Stovna eina nýggja kapping';

  @override
  String get tournamentCalendar => 'Kappingakalendari';

  @override
  String get conditionOfEntry => 'Luttøkutreytir:';

  @override
  String get advancedSettings => 'Framkomnar stillingar';

  @override
  String get safeTournamentName => 'Vel eitt trygt og hóskiligt navn til kappingina.';

  @override
  String get inappropriateNameWarning => 'Er navnið á nakran hátt ósømiligt, kann konta tín verða stongd.';

  @override
  String get emptyTournamentName => 'Lat teigin vera tóman, um tú vilt, at kappingin verður nevnd eftir gitnum telvara.';

  @override
  String get makePrivateTournament => 'Ger so kappingin ikki er almen, og avmarka atgongdina við einum loyniorði';

  @override
  String get join => 'Tak lut';

  @override
  String get withdraw => 'Far úr';

  @override
  String get points => 'Stig';

  @override
  String get wins => 'Sigrar';

  @override
  String get losses => 'Tapt';

  @override
  String get createdBy => 'Stovnað hevur';

  @override
  String get tournamentIsStarting => 'Kappingin byrjar';

  @override
  String get tournamentPairingsAreNowClosed => 'Liðugt er at seta luttakararnar saman tveir og tveir.';

  @override
  String standByX(String param) {
    return 'Bíða $param, telvarar verða greipaðir, ger teg til reiðar!';
  }

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get youArePlaying => 'Tú telvar!';

  @override
  String get winRate => 'Sigurslutfall';

  @override
  String get berserkRate => 'Berserksstig';

  @override
  String get performance => 'Avrik';

  @override
  String get tournamentComplete => 'Kappingin fullfíggjað';

  @override
  String get movesPlayed => 'Telvdir leikir';

  @override
  String get whiteWins => 'Sigrar við hvítum';

  @override
  String get blackWins => 'Sigrar við svørtum';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Javnleikir';

  @override
  String nextXTournament(String param) {
    return 'Næsta $param kapping:';
  }

  @override
  String get averageOpponent => 'Miðalmótleikari';

  @override
  String get boardEditor => 'Talvborðsritil';

  @override
  String get setTheBoard => 'Set talvborðið upp';

  @override
  String get popularOpenings => 'Væl dámd byrjanartalv';

  @override
  String get endgamePositions => 'Endatalvstøður';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960-byrjanarstøða: $param';
  }

  @override
  String get startPosition => 'Byrjanarstøðan';

  @override
  String get clearBoard => 'Rudda borðið';

  @override
  String get loadPosition => 'Les støðuna inn';

  @override
  String get isPrivate => 'Innanhýsis';

  @override
  String reportXToModerators(String param) {
    return 'Sig fyriskiparum frá um $param';
  }

  @override
  String profileCompletion(String param) {
    return 'Vangamynd útfylt: $param';
  }

  @override
  String xRating(String param) {
    return '$param styrkital';
  }

  @override
  String get ifNoneLeaveEmpty => 'Um einki, lat teigin vera tóman';

  @override
  String get profile => 'Vangamynd';

  @override
  String get editProfile => 'Broyt vangamynd';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Ævilýsing';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Takk fyri!';

  @override
  String get socialMediaLinks => 'Leinki til sosialar miðlar';

  @override
  String get oneUrlPerLine => 'Eitt URL fyri hvørja reglu.';

  @override
  String get inlineNotation => 'Innbygd teknskipan';

  @override
  String get makeAStudy => 'For safekeeping and sharing, consider making a study.';

  @override
  String get clearSavedMoves => 'Clear moves';

  @override
  String get previouslyOnLichessTV => 'Áður víst í Lichess-sjónvarpi';

  @override
  String get onlinePlayers => 'Telvarar á netinum nú';

  @override
  String get activePlayers => 'Virknir telvarar';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Gev gætur, at talvið verður styrkismett, men hevur onga klokku!';

  @override
  String get success => 'Tað eydnaðist';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Halt sjálvvirkið fram við næsta talvi aftaná at hava flutt';

  @override
  String get autoSwitch => 'Sjálvvirknisknøttur';

  @override
  String get puzzles => 'Uppgávur';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Navn';

  @override
  String get description => 'Lýsing';

  @override
  String get descPrivate => 'Innanhýsis lýsing';

  @override
  String get descPrivateHelp => 'Tekstur ið bert limir á liðnum fara síggja. Um hann er útfyltur, verður hann fyri limir brúktur í staðin fyri almennu lýsingina.';

  @override
  String get no => 'Nei';

  @override
  String get yes => 'Ja';

  @override
  String get website => 'Website';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Hjálp:';

  @override
  String get createANewTopic => 'Stovna eitt nýtt evni';

  @override
  String get topics => 'Evni';

  @override
  String get posts => 'Uppsløg';

  @override
  String get lastPost => 'Seinasta uppslag';

  @override
  String get views => 'Áskoðanir';

  @override
  String get replies => 'Svar';

  @override
  String get replyToThisTopic => 'Svara í sambandi við hetta evnið';

  @override
  String get reply => 'Svara';

  @override
  String get message => 'Boð';

  @override
  String get createTheTopic => 'Stovna evnið';

  @override
  String get reportAUser => 'Sig frá um ein brúkara';

  @override
  String get user => 'Brúkari';

  @override
  String get reason => 'Orsøk';

  @override
  String get whatIsIheMatter => 'Hvat bagir?';

  @override
  String get cheat => 'Snýt';

  @override
  String get troll => 'Trøll';

  @override
  String get other => 'Annað';

  @override
  String get reportCheatBoostHelp => 'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp => 'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish => 'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink => 'Útvega leinki til í minsta lagi eitt talv, har snýtt varð.';

  @override
  String by(String param) {
    return 'eftir $param';
  }

  @override
  String importedByX(String param) {
    return '$param las inn';
  }

  @override
  String get thisTopicIsNowClosed => 'Evnið er nú afturlatið.';

  @override
  String get blog => 'Bloggur';

  @override
  String get notes => 'Upprit';

  @override
  String get typePrivateNotesHere => 'Skriva tíni egnu upprit her';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Write a private note about this user';

  @override
  String get noNoteYet => 'No note yet';

  @override
  String get invalidUsernameOrPassword => 'Ógildugt brúkaranavn ella loyniorð';

  @override
  String get incorrectPassword => 'Skeivt loyniorð';

  @override
  String get invalidAuthenticationCode => 'Ógildug samgildiskota';

  @override
  String get emailMeALink => 'Send mær leinki við telduposti';

  @override
  String get currentPassword => 'Núverandi loyniorð';

  @override
  String get newPassword => 'Nýtt loyniorð';

  @override
  String get newPasswordAgain => 'Nýtt loyniorð (aftur)';

  @override
  String get newPasswordsDontMatch => 'Nýggju loyniorðini eru ikki eins';

  @override
  String get newPasswordStrength => 'Loyniorðsstyrki';

  @override
  String get clockInitialTime => 'Byrjanartíð á klokku';

  @override
  String get clockIncrement => 'Øking á klokku';

  @override
  String get privacy => 'Privatlív';

  @override
  String get privacyPolicy => 'Verndarpolitikkur';

  @override
  String get letOtherPlayersFollowYou => 'Lat aðrar telvarar fylgja tær';

  @override
  String get letOtherPlayersChallengeYou => 'Lat aðrar telvarar bjóða tær av';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Lat aðrar telvarar bjóða tær at rannsaka';

  @override
  String get sound => 'Ljóð';

  @override
  String get none => 'Eingin';

  @override
  String get fast => 'Skjótt';

  @override
  String get normal => 'Vanligt';

  @override
  String get slow => 'Seint';

  @override
  String get insideTheBoard => 'Inni á borðinum';

  @override
  String get outsideTheBoard => 'Uttanfyri borðið';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Í seinførum talvum';

  @override
  String get always => 'Altíð';

  @override
  String get never => 'Ongantíð';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 kappast í $param2';
  }

  @override
  String get victory => 'Sigur';

  @override
  String get defeat => 'Tap';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 móti $param2 í $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 móti $param2 í $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 móti $param2 í $param3';
  }

  @override
  String get timeline => 'Tíðarlinja';

  @override
  String get starting => 'Byrjar:';

  @override
  String get allInformationIsPublicAndOptional => 'Allar upplýsingar eru almennar og valfríar.';

  @override
  String get biographyDescription => 'Greið frá um teg sjálva/n, og um tíni áhugamál, hvat tær dámar við talvi, hvørji yndisbyrjanartalv tíni eru, telvarar o.s.fr.';

  @override
  String get listBlockedPlayers => 'Ger lista yvir telvarar, tú hevur forðað';

  @override
  String get human => 'Menniskja';

  @override
  String get computer => 'Telda';

  @override
  String get side => 'Litur';

  @override
  String get clock => 'Klokka';

  @override
  String get opponent => 'Mótleikari';

  @override
  String get learnMenu => 'Lær';

  @override
  String get studyMenu => 'Rannsókn';

  @override
  String get practice => 'Venjing';

  @override
  String get community => 'Felagsskapur';

  @override
  String get tools => 'Amboð';

  @override
  String get increment => 'Hækking';

  @override
  String get error_unknown => 'Invalid value';

  @override
  String get error_required => 'Hesin teigur er kravdur';

  @override
  String get error_email => 'Henda teldupostadressa er ógildig';

  @override
  String get error_email_acceptable => 'Henda teldupostaddressa er ikki góðtikin. Kanna, um hon er rætt, og royn so aftur.';

  @override
  String get error_email_unique => 'Teldupostaddressan er antin ógildug ella longu tikin';

  @override
  String get error_email_different => 'Hetta er longu tín teldupostadressa';

  @override
  String error_minLength(String param) {
    return 'Minsta longdin er $param tekn';
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
    return 'Um styrkitalið er ± $param';
  }

  @override
  String get ifRegistered => 'If registered';

  @override
  String get onlyExistingConversations => 'Einastu samrøður, ið eru til';

  @override
  String get onlyFriends => 'Bert vinir';

  @override
  String get menu => 'Valmynd';

  @override
  String get castling => 'Loypur í borg';

  @override
  String get whiteCastlingKingside => 'Hvítur O-O';

  @override
  String get blackCastlingKingside => 'Svartur O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tíð nýtt at telva: $param';
  }

  @override
  String get watchGames => 'Hygg at talvum';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tíð í sjónvarpi (TV): $param';
  }

  @override
  String get watch => 'Hygg';

  @override
  String get videoLibrary => 'Sjónfílusavn';

  @override
  String get streamersMenu => 'Stroymarar';

  @override
  String get mobileApp => 'Snildfonaapp';

  @override
  String get webmasters => 'Vevstjórar';

  @override
  String get about => 'Um';

  @override
  String aboutX(String param) {
    return 'Um $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 er ein ókeypis ($param2), óhandilsligur talvkagi uttan lýsingar.';
  }

  @override
  String get really => 'álvara';

  @override
  String get contribute => 'Stuðla';

  @override
  String get termsOfService => 'Tænastutreytir';

  @override
  String get sourceCode => 'Keldukota';

  @override
  String get simultaneousExhibitions => 'Fjøltelvingar';

  @override
  String get host => 'Vertur';

  @override
  String hostColorX(String param) {
    return 'Litur hjá verti: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Nýliga stovnað fjøltalv';

  @override
  String get hostANewSimul => 'Stovna nýtt fjøltalv';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Fjøltalv ikki funnið';

  @override
  String get noSimulExplanation => 'Henda sýning við fjøltalvi er ikki til.';

  @override
  String get returnToSimulHomepage => 'Far aftur til fjøltelvingarheimasíðu';

  @override
  String get aboutSimul => 'Í fjøltalvum telvar einstakur telvari móti fleiri telvarum samstundis.';

  @override
  String get aboutSimulImage => 'Móti 50 mótleikarum vann Fischer 47 talv, telvaði 2 jøvn og tapti 1.';

  @override
  String get aboutSimulRealLife => 'Hugtakið er tikið úr veruliga heiminum, har verturin fyri fjøltalvum gongur frá einum borði til tað næsta at flyta ein leik í senn.';

  @override
  String get aboutSimulRules => 'Tá ið fjøltalvið byrjar, fer hvør leikari undir eitt talv móti vertinum, ið sleppur at telva við hvíta fólkinum. Fjøltalvið endar, tá ið øll talv eru liðug.';

  @override
  String get aboutSimulSettings => 'Fjøltalv eru altíð uttan styrkismetingar. Til ber ikki at leggja tíð aftrat, telva nýggj talv ella telva við afturtøkum.';

  @override
  String get create => 'Stovna';

  @override
  String get whenCreateSimul => 'Tá ið tú stovnar eitt fjøltalv, sleppur tú at telva móti fleiri telvarum í senn.';

  @override
  String get simulVariantsHint => 'Velur tú fleiri avbrigdi, sleppur hvør telvari at gera av, hvat avbrigdi telvað verður.';

  @override
  String get simulClockHint => 'Fischerklokku-uppseting. Fleiri telvarum, tú telvar móti, meiri tíð tørvar tær.';

  @override
  String get simulAddExtraTime => 'Tú hevur loyvi at leggja tíð aftrat tínari klokku til tess at hjálpa tær at megna at telva fjøltalvið.';

  @override
  String get simulHostExtraTime => 'Vertur fær eyka klokkutíð';

  @override
  String get simulAddExtraTimePerPlayer => 'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'Lichess kappingar';

  @override
  String get tournamentFAQ => 'Arena-kapping FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Tíð áðrenn kapping byrjar';

  @override
  String get averageCentipawnLoss => 'Miðal centifinnu-tap';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get keyboardShortcuts => 'Knappaborðssnarvegir';

  @override
  String get keyMoveBackwardOrForward => 'flyt aftur/fram';

  @override
  String get keyGoToStartOrEnd => 'far til byrjan/enda';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'vís/fjal viðmerkingar';

  @override
  String get keyEnterOrExitVariation => 'lat upp/lat aftur avbrigdi';

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
  String get newTournament => 'Nýggj kapping';

  @override
  String get tournamentHomeTitle => 'Talvkappingar við ymiskum tíðaravmarkingum og avbrigdum';

  @override
  String get tournamentHomeDescription => 'Telva í talvkappingum við høgari ferð! Far upp í eina almenna tíðarásetta kapping ella set tína egnu kapping á stovn. Bullet, snar, vanligt, Chess960, King of the Hill, Threecheck, og aðrir valmøguleikar eru.';

  @override
  String get tournamentNotFound => 'Kapping ikki funnin';

  @override
  String get tournamentDoesNotExist => 'Kappingin er ikki til.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Kappingin er møguliga avlýst, um allir telvarar fóru burturúr, áðrenn hon byrjaði.';

  @override
  String get returnToTournamentsHomepage => 'Far aftur til heimasíðu við kappingum';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Styrkital fyri $param hesa vikuna';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Títt $param1 styrkital er $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Tú ert betri enn $param1 av $param2 telvarum.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 er betri enn $param2 av $param3 telvarum.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Tú hevur ikki eitt grundfest $param styrkital.';
  }

  @override
  String get yourRating => 'Títt styrkital';

  @override
  String get cumulative => 'Vøkstur';

  @override
  String get glicko2Rating => 'Glicko-2 styrkital';

  @override
  String get checkYourEmail => 'Kanna tín teldupost';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Vit hava sent tær teldupost. Klikk á leinkið í teldupostinum at virkja tína kontu.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Um tú ikki sært teldupostin, kanna onnur støð, hann kann vera. Eitt nú í junk, spam, social ella øðrum faldarum.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Vit hava sent $param ein teldupost. Klikk á leinkið í teldupostinum at endurseta títt loyniorð.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Við at skráseta teg, samtykkir tú í at vera bundin av okkara $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Les um, hvør $param okkara er.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Netseinkan millum teg og Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tíð at viðgera ein leik í Lichess-ambætaranum';

  @override
  String get downloadAnnotated => 'Tak viðmerkingar niður';

  @override
  String get downloadRaw => 'Tak niður rátt';

  @override
  String get downloadImported => 'Niðurtøka innflutt';

  @override
  String get crosstable => 'Krossborð';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Til ber eisini at skrulla yvirum borðið at flyta leikir í talvinum.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scroll over computer variations to preview them.';

  @override
  String get analysisShapesHowTo => 'Trýst shift+click ella right-click at tekna rundingar og pílar á talvborðinum.';

  @override
  String get letOtherPlayersMessageYou => 'Lat aðrar telvarar senda tær boð';

  @override
  String get receiveForumNotifications => 'Receive notifications when mentioned in the forum';

  @override
  String get shareYourInsightsData => 'Deil tínar talvinnlitsdátur';

  @override
  String get withNobody => 'Við ongan';

  @override
  String get withFriends => 'Við vinir';

  @override
  String get withEverybody => 'Við øll';

  @override
  String get kidMode => 'Barnastøða';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Hetta snýr seg um trygd. Í barnastøðu er alt samskifti á síðuni óvirkið. Vel barnastøðu, soleiðis at børn tíni og skúlanæmingar ikki hava við aðrar internetbrúkarar at gera.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Í barnastøðu fær Lichess-búmerkið eina $param mynd, so tú veitst, at børn tíni eru trygg.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'Vel barnastøðu';

  @override
  String get disableKidMode => 'Sløkk barnastøðu';

  @override
  String get security => 'Trygd';

  @override
  String get sessions => 'Sessions';

  @override
  String get revokeAllSessions => 'strika allar setur (sessions)';

  @override
  String get playChessEverywhere => 'Telva allastaðni';

  @override
  String get asFreeAsLichess => 'Ókeypis sum Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Bygt við alski til telving, ikki pengar';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Øll fáa allar hentleikar ókeypis';

  @override
  String get zeroAdvertisement => 'Ongar lýsingar';

  @override
  String get fullFeatured => 'Við øllum hentleikum';

  @override
  String get phoneAndTablet => 'Snildfon og teldil';

  @override
  String get bulletBlitzClassical => 'Bullet, snartalv, vanligt';

  @override
  String get correspondenceChess => 'Brævtalv';

  @override
  String get onlineAndOfflinePlay => 'Telva á netinum og uttan net';

  @override
  String get viewTheSolution => 'Síggj svarið';

  @override
  String get followAndChallengeFriends => 'Fylg vinum og bjóða teimum av';

  @override
  String get gameAnalysis => 'Talvgreining';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 er vertur fyri $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 fer upp í $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 dámar $param2';
  }

  @override
  String get quickPairing => 'Skjót greiping';

  @override
  String get lobby => 'Salur';

  @override
  String get anonymous => 'Dulnevnt';

  @override
  String yourScore(String param) {
    return 'Títt stigatal: $param';
  }

  @override
  String get language => 'Mál';

  @override
  String get background => 'Bakgrund';

  @override
  String get light => 'Ljóst';

  @override
  String get dark => 'Myrkt';

  @override
  String get transparent => 'Gjøgnumskygt';

  @override
  String get deviceTheme => 'Device theme';

  @override
  String get backgroundImageUrl => 'Bakgrundsmynd URL:';

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
  String get pieceSet => 'Snið á talvfólki';

  @override
  String get embedInYourWebsite => 'Fell inn í heimasíðu tína';

  @override
  String get usernameAlreadyUsed => 'Hetta brúkaranavnið verður longu nýtt. Royn vinaliga eitt annað.';

  @override
  String get usernamePrefixInvalid => 'Brúkaranavnið má byrja við einum bókstavi.';

  @override
  String get usernameSuffixInvalid => 'Brúkaranavnið má enda við einum bókstavi ella tali.';

  @override
  String get usernameCharsInvalid => 'Í brúkaranavninum mugu bert vera bókstavir, tøl, undirstrikur og sambindingarstrikur.';

  @override
  String get usernameUnacceptable => 'Brúkaranavnið verður ikki góðtikið.';

  @override
  String get playChessInStyle => 'Telva við stíli';

  @override
  String get chessBasics => 'Grundleggjandi talv';

  @override
  String get coaches => 'Venjarar';

  @override
  String get invalidPgn => 'Ógildugt PGN';

  @override
  String get invalidFen => 'Ógildugt FEN';

  @override
  String get custom => 'Tillagað';

  @override
  String get notifications => 'Fráboðanir';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Styrkital: $param';
  }

  @override
  String get practiceWithComputer => 'Ven við telduni';

  @override
  String anotherWasX(String param) {
    return 'Annar leikur var $param';
  }

  @override
  String bestWasX(String param) {
    return 'Besti leikur var $param';
  }

  @override
  String get youBrowsedAway => 'Tú kagaði burtur';

  @override
  String get resumePractice => 'Tak venjingina upp aftur';

  @override
  String get drawByFiftyMoves => 'The game has been drawn by the fifty move rule.';

  @override
  String get theGameIsADraw => 'Talvið er javnt.';

  @override
  String get computerThinking => 'Teldan hugsar ...';

  @override
  String get seeBestMove => 'Síggj besta leikin';

  @override
  String get hideBestMove => 'Fjal besta leikin';

  @override
  String get getAHint => 'Fá eina ábending';

  @override
  String get evaluatingYourMove => 'Leikurin verður greinaður ...';

  @override
  String get whiteWinsGame => 'Hvítur vinnur';

  @override
  String get blackWinsGame => 'Svartur vinnur';

  @override
  String get learnFromYourMistakes => 'Lær av tínum mistøkum';

  @override
  String get learnFromThisMistake => 'Lær av hesum mistaki';

  @override
  String get skipThisMove => 'Loyp henda leikin um';

  @override
  String get next => 'Næsti';

  @override
  String xWasPlayed(String param) {
    return '$param varð telvað';
  }

  @override
  String get findBetterMoveForWhite => 'Finn ein betri leik fyri hvítan';

  @override
  String get findBetterMoveForBlack => 'Finn ein betri leik fyri svartan';

  @override
  String get resumeLearning => 'Halt fram við at læra';

  @override
  String get youCanDoBetter => 'Tú fært leikað betur';

  @override
  String get tryAnotherMoveForWhite => 'Royn ein annan leik við hvítum';

  @override
  String get tryAnotherMoveForBlack => 'Royn ein annan leik við svørtum';

  @override
  String get solution => 'Svar';

  @override
  String get waitingForAnalysis => 'Bíðar eftir greining';

  @override
  String get noMistakesFoundForWhite => 'Eingi mistøk funnin hjá hvítum';

  @override
  String get noMistakesFoundForBlack => 'Eingi mistøk funnin hjá svørtum';

  @override
  String get doneReviewingWhiteMistakes => 'Liðugt at viðgera mistøk hjá hvítum';

  @override
  String get doneReviewingBlackMistakes => 'Liðugt at viðgera mistøk hjá svørtum';

  @override
  String get doItAgain => 'Ger tað aftur';

  @override
  String get reviewWhiteMistakes => 'Met um hvít mistøk';

  @override
  String get reviewBlackMistakes => 'Met um svørt mistøk';

  @override
  String get advantage => 'Fyrimunur';

  @override
  String get opening => 'Byrjanartalv';

  @override
  String get middlegame => 'Miðtalv';

  @override
  String get endgame => 'Endatalv';

  @override
  String get conditionalPremoves => 'Treytaðir undanleikir';

  @override
  String get addCurrentVariation => 'Skoyt núverandi brigdi upp í';

  @override
  String get playVariationToCreateConditionalPremoves => 'Telva eitt brigdi til tess at skapa treytaðar undanleikir';

  @override
  String get noConditionalPremoves => 'Eingir treytaðir undanleikir';

  @override
  String playX(String param) {
    return 'Telva $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Orsaka :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Vit noyddust at geva tær leikbrá eina tíð.';

  @override
  String get why => 'Hví?';

  @override
  String get pleasantChessExperience => 'Vit miða ímóti at veita øllum eina góða talvuppliving.';

  @override
  String get goodPractice => 'Tískil mugu vit vissa okkum, at allir telvarar sýna góðan atburð.';

  @override
  String get potentialProblem => 'Tá ið ein møguligur trupulleiki verður staðfestur, vísa vit hesi boðini.';

  @override
  String get howToAvoidThis => 'Hvussu slepst undan hesum?';

  @override
  String get playEveryGame => 'Telva hvørt talv, tú byrjar.';

  @override
  String get tryToWin => 'Royn at vinna ella fáa javnleik í hvørjum talvi, tú telvir.';

  @override
  String get resignLostGames => 'Er tap í hendi, legg so kongin (ikki lata klokkuna ganga út).';

  @override
  String get temporaryInconvenience => 'Vit biðja teg halda okkum til góðar fyri fyribils órógvanina';

  @override
  String get wishYouGreatGames => 'og ynskja tær nógv góð talv á lichess.org.';

  @override
  String get thankYouForReading => 'Takk fyri, at tú las hetta!';

  @override
  String get lifetimeScore => 'Lívstíðarstigatal';

  @override
  String get currentMatchScore => 'Núverandi dystarstigatal';

  @override
  String get agreementAssistance => 'Eg lovi, at eg ongantíð taki ímóti hjálp, meðan eg telvi (frá telvingarteldum, bókum, dátugrunnum ella øðrum telvarum).';

  @override
  String get agreementNice => 'Eg lovi altíð at sýna virðing móti øðrum telvarum.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Eg játti at eg ikki fari at stovna fleiri kontur (uttan so at tað fellur undir grundirnar í $param).';
  }

  @override
  String get agreementPolicy => 'Eg samtykki, at eg fari at fylgja øllum Lichess-reglugerðum.';

  @override
  String get searchOrStartNewDiscussion => 'Leita eftir samrøðu ella byrja eina nýggja';

  @override
  String get edit => 'Broyt';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Kviktalv';

  @override
  String get classical => 'Vanligt';

  @override
  String get ultraBulletDesc => 'Vitleyst skjót talv: styttri enn 30 sekund';

  @override
  String get bulletDesc => 'Ógvuliga skjót talv: styttri enn 3 minuttir';

  @override
  String get blitzDesc => 'Skjót talv: 3 til 8 minuttir';

  @override
  String get rapidDesc => 'Kviktalv: 8 til 25 minuttir';

  @override
  String get classicalDesc => 'Klassisk talv: 25 minuttir ella longur';

  @override
  String get correspondenceDesc => 'Brævtalv: ein ella fleiri dagar fyri hvønn leik';

  @override
  String get puzzleDesc => 'Taktikkvenjing';

  @override
  String get important => 'Umráðandi';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Spurningur tín hevur kanska longu eitt svar $param1';
  }

  @override
  String get inTheFAQ => 'í F.A.Q.-inum.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Til tess at melda brúkara fyri at snýta ella sýna ringan atburð, $param1';
  }

  @override
  String get useTheReportForm => 'nýt útfyllingarskjalið';

  @override
  String toRequestSupport(String param1) {
    return 'Til tess at biðja um stuðul, $param1';
  }

  @override
  String get tryTheContactPage => 'royn síðuna við sambondum';

  @override
  String makeSureToRead(String param1) {
    return 'Make sure to read $param1';
  }

  @override
  String get theForumEtiquette => 'the forum etiquette';

  @override
  String get thisTopicIsArchived => 'Hetta evnið er goymt í savninum, og til ber ikki at gera viðmerkingar til tað longur.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Far upp í $param1, at gera uppsløg á hesum torgi';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 lið';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Tú kanst ikki seta uppsløg upp á torgunum enn. Telva nøkur talv!';

  @override
  String get subscribe => 'Melda til';

  @override
  String get unsubscribe => 'Melda teg úr';

  @override
  String mentionedYouInX(String param1) {
    return 'nevndi teg í \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 mentioned you in \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'bjóðaði tær til \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 bjóðaði tær til \"$param2\".';
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
  String get congratsYouWon => 'Til lukku, tú vanst!';

  @override
  String gameVsX(String param1) {
    return 'Talv móti $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 móti $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'You lost rating points to someone who violated the Lichess TOS';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Refund: $param1 $param2 rating points.';
  }

  @override
  String get timeAlmostUp => 'Tíðin er skjótt úti!';

  @override
  String get clickToRevealEmailAddress => '[Click to reveal email address]';

  @override
  String get download => 'Tak niður';

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
  String get noChat => 'Einki kjatt';

  @override
  String get onlyTeamLeaders => 'Bert liðleiðarar';

  @override
  String get onlyTeamMembers => 'Bert limir av liðnum';

  @override
  String get navigateMoveTree => 'Far runt í leiktrænum';

  @override
  String get mouseTricks => 'Músasnildir';

  @override
  String get toggleLocalAnalysis => 'Toggle local computer analysis';

  @override
  String get toggleAllAnalysis => 'Toggle all computer analysis';

  @override
  String get playComputerMove => 'Telv besta telduleikin';

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
  String get onlyWorksOnce => 'Hetta riggar bert eina ferð.';

  @override
  String get cantDoThisTwice => 'If you close your account a second time, there will be no way of recovering it.';

  @override
  String get emailAssociatedToaccount => 'Email address associated to the account';

  @override
  String get sentEmailWithLink => 'We\'ve sent you an email with a link.';

  @override
  String get tournamentEntryCode => 'Tournament entry code';

  @override
  String get hangOn => 'Bíða líka!';

  @override
  String gameInProgress(String param) {
    return 'You have a game in progress with $param.';
  }

  @override
  String get abortTheGame => 'Enda talvið';

  @override
  String get resignTheGame => 'Gev upp talvið';

  @override
  String get youCantStartNewGame => 'Tú kanst ikki byrja eitt nýtt talv áðrenn hetta endar.';

  @override
  String get since => 'Síðan';

  @override
  String get until => 'Til';

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
  String get stats => 'Stats';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Títt mótstøðufólk fór frá talvinum. Tú kanst siga teg hava vunnið um $count sekund.',
      one: 'Mótleikarin fór frá talvinum. Tú kanst siga teg hava vunnið um $count sekund.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skák og mát í $count hálvum leikum',
      one: 'Skák og mát í $count hálvum leiki',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bukkar',
      one: '$count bukkur',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mistøk',
      one: '$count mistak',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count óneyvleikar',
      one: '$count óneyvleiki',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count telvarar',
      one: '$count telvari',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count talv',
      one: '$count talv',
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
      other: '$count bókamerki',
      one: '$count bókamerki',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagar',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tímar',
      one: '$count tími',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuttir',
      one: '$count minuttur',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Støða/tign verður dagførd $count minuttir ímillum',
      one: 'Støða/tign verður dagførd hvønn minutt',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uppgávur',
      one: '$count uppgáva',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count talv móti tær',
      one: '$count talv móti tær',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count styrkismett',
      one: '$count styrkismettur',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sigrar',
      one: '$count sigur',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ósigrar',
      one: '$count ósigur',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jøvn',
      one: '$count javnt',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count í gongd',
      one: '$count í gongd',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gev $count sekund',
      one: 'Gev $count sekund',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kappingastig',
      one: '$count kappingarstig',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rannsóknir',
      one: '$count rannsókn',
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
      other: '≥ $count styrkismett talv',
      one: '≥ $count styrkismett talv',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 styrkismett talv',
      one: '≥ $count $param2 styrkismett talv',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tær nýtist at telva $count fleiri $param2 styrkismett talv',
      one: 'Tær nýtist at telva $count $param2 styrkismett talv aftrat',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tær nýtist at telva $count styrkismett talv aftrat',
      one: 'Tær nýtist at telva $count styrkismett talv aftrat',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count innflutt talv',
      one: '$count innflutt talv',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vinir á alnetinum',
      one: '$count vinur á alnetinum',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fylgjarar',
      one: '$count fylgjari',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fylgja',
      one: '$count fylgir',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Minni enn $count minuttir',
      one: 'Minni enn $count minuttur',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count talv verða telvað',
      one: '$count talv verður telvað',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Í mesta lagi: $count bókstavir.',
      one: 'Í mesta lagi: $count bókstavur.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forðaðir',
      one: '$count forðaður',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uppsløg á torgi',
      one: '$count uppslag á torgi',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 telvarar hesa vikuna.',
      one: '$count $param2 telvari hesa vikuna.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tøkt á $count málum!',
      one: 'Tøkt á $count máli!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundir at flyta fyrsta leik',
      one: '$count sekund at flyta fyrsta leik',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundir',
      one: '$count sekund',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'og goym $count undanleikir',
      one: 'og goym $count undanleik',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Flyt eitt fólk at byrja';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Tú telvar við hvítum í ølllum uppgávum';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Tú telvar við svørtum í ølllum uppgávum';

  @override
  String get stormPuzzlesSolved => 'uppgávur loystar';

  @override
  String get stormNewDailyHighscore => 'Nýtt dagsmet!';

  @override
  String get stormNewWeeklyHighscore => 'Nýtt vikumet!';

  @override
  String get stormNewMonthlyHighscore => 'Nýtt mánaðarmet!';

  @override
  String get stormNewAllTimeHighscore => 'Nýtt met!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Undanfarna met var $param';
  }

  @override
  String get stormPlayAgain => 'Telva aftur';

  @override
  String stormHighscoreX(String param) {
    return 'Met: $param';
  }

  @override
  String get stormScore => 'Stig';

  @override
  String get stormMoves => 'Leikir';

  @override
  String get stormAccuracy => 'Neyvleiki';

  @override
  String get stormCombo => 'Bland';

  @override
  String get stormTime => 'Tíð';

  @override
  String get stormTimePerMove => 'Tíð fyri hvønn leik';

  @override
  String get stormHighestSolved => 'Truplastu loystu uppgávurnar';

  @override
  String get stormPuzzlesPlayed => 'Telvdar uppgávur';

  @override
  String get stormNewRun => 'Nýtt umfar (snarknøttur: glopp)';

  @override
  String get stormEndRun => 'Endaumfar (snarknøttur: Enter)';

  @override
  String get stormHighscores => 'Met (háskora)';

  @override
  String get stormViewBestRuns => 'Síggj bestu umfør';

  @override
  String get stormBestRunOfDay => 'Dagsins besta umfar';

  @override
  String get stormRuns => 'Umfør';

  @override
  String get stormGetReady => 'Ver til reiðar!';

  @override
  String get stormWaitingForMorePlayers => 'Vit bíða eftir fleiri telvarum at koma upp í...';

  @override
  String get stormRaceComplete => 'Kapprenning fullførd!';

  @override
  String get stormSpectating => 'Áskoðari';

  @override
  String get stormJoinTheRace => 'Kom við í kapprenningina!';

  @override
  String get stormStartTheRace => 'Start the race';

  @override
  String stormYourRankX(String param) {
    return 'Tín støða: $param';
  }

  @override
  String get stormWaitForRematch => 'Bíða eftir nýggjum talvi';

  @override
  String get stormNextRace => 'Næsta kapprenning';

  @override
  String get stormJoinRematch => 'Join rematch';

  @override
  String get stormWaitingToStart => 'Bíða eftir byrjan';

  @override
  String get stormCreateNewGame => 'Byrja nýtt talv';

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
      other: '$count umfør',
      one: '1 umfar',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Telvaði $count umfør av $param2',
      one: 'Telvaði eitt umfar av $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess stroymarar';

  @override
  String get studyPrivate => 'Egin (privat)';

  @override
  String get studyMyStudies => 'Mínar rannsóknir';

  @override
  String get studyStudiesIContributeTo => 'Rannsóknir, eg gevi mítt íkast til';

  @override
  String get studyMyPublicStudies => 'Mínar almennu rannsóknir';

  @override
  String get studyMyPrivateStudies => 'Mínar egnu rannsóknir';

  @override
  String get studyMyFavoriteStudies => 'Mínar yndisrannsóknir';

  @override
  String get studyWhatAreStudies => 'Hvat eru rannsóknir?';

  @override
  String get studyAllStudies => 'Allar rannsóknir';

  @override
  String studyStudiesCreatedByX(String param) {
    return '$param stovnaði hesar rannsóknir';
  }

  @override
  String get studyNoneYet => 'Ongar enn.';

  @override
  String get studyHot => 'Heitar';

  @override
  String get studyDateAddedNewest => 'Eftir dagfesting (nýggjastu)';

  @override
  String get studyDateAddedOldest => 'Eftir dagfesting (eldstu)';

  @override
  String get studyRecentlyUpdated => 'Nýliga dagførdar';

  @override
  String get studyMostPopular => 'Best dámdu';

  @override
  String get studyAlphabetical => 'Alphabetical';

  @override
  String get studyAddNewChapter => 'Skoyt nýggjan kapittul upp í';

  @override
  String get studyAddMembers => 'Legg limir aftrat';

  @override
  String get studyInviteToTheStudy => 'Bjóða uppí rannsóknina';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Bjóða vinaliga bert fólki, tú kennir, og sum vilja taka virknan lut í rannsóknini.';

  @override
  String get studySearchByUsername => 'Leita eftir brúkaranavni';

  @override
  String get studySpectator => 'Áskoðari';

  @override
  String get studyContributor => 'Gevur íkast';

  @override
  String get studyKick => 'Koyr úr';

  @override
  String get studyLeaveTheStudy => 'Far úr rannsóknini';

  @override
  String get studyYouAreNowAContributor => 'Tú ert nú ein, ið leggur aftrat rannsóknini';

  @override
  String get studyYouAreNowASpectator => 'Tú ert nú áskoðari';

  @override
  String get studyPgnTags => 'PGN-frámerki';

  @override
  String get studyLike => 'Dáma';

  @override
  String get studyUnlike => 'Unlike';

  @override
  String get studyNewTag => 'Nýtt frámerki';

  @override
  String get studyCommentThisPosition => 'Viðmerk hesa støðuna';

  @override
  String get studyCommentThisMove => 'Viðmerk henda leikin';

  @override
  String get studyAnnotateWithGlyphs => 'Skriva við teknum';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Kapittulin er ov stuttur til at verða greinaður.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Bert tey, ið geva sítt íkast til rannsóknina, kunnu biðja um eina teldugreining.';

  @override
  String get studyGetAFullComputerAnalysis => 'Fá eina fullfíggjaða teldugreining av høvuðsbrigdinum frá ambætaranum.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Tryggja tær, at kapittulin er fullfíggjaður. Tú kanst bert biðja um greining eina ferð.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Allir SYNC-limir verða verandi í somu støðu';

  @override
  String get studyShareChanges => 'Deil broytingar við áskoðarar, og goym tær á ambætaranum';

  @override
  String get studyPlaying => 'Í gongd';

  @override
  String get studyShowEvalBar => 'Evaluation bars';

  @override
  String get studyFirst => 'Fyrsta';

  @override
  String get studyPrevious => 'Undanfarna';

  @override
  String get studyNext => 'Næsta';

  @override
  String get studyLast => 'Síðsta';

  @override
  String get studyShareAndExport => 'Deil & flyt út';

  @override
  String get studyCloneStudy => 'Klona';

  @override
  String get studyStudyPgn => 'PGN rannsókn';

  @override
  String get studyDownloadAllGames => 'Tak øll talv niður';

  @override
  String get studyChapterPgn => 'PGN kapittul';

  @override
  String get studyCopyChapterPgn => 'Copy PGN';

  @override
  String get studyDownloadGame => 'Tak talv niður';

  @override
  String get studyStudyUrl => 'URL rannsókn';

  @override
  String get studyCurrentChapterUrl => 'Núverandi URL partur';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Tú kanst seta hetta inn í torgið at sýna tað har';

  @override
  String get studyStartAtInitialPosition => 'Byrja við byrjanarstøðuni';

  @override
  String studyStartAtX(String param) {
    return 'Byrja við $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Fell inn í heimasíðu tína ella blogg tín';

  @override
  String get studyReadMoreAboutEmbedding => 'Les meira um at fella inn í';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Bert almennar rannsóknir kunnu verða feldar inn í!';

  @override
  String get studyOpen => 'Lat upp';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param2 fekk tær $param1 til vegar';
  }

  @override
  String get studyStudyNotFound => 'Rannsókn ikki funnin';

  @override
  String get studyEditChapter => 'Broyt kapittul';

  @override
  String get studyNewChapter => 'Nýggjur kapittul';

  @override
  String studyImportFromChapterX(String param) {
    return 'Import from $param';
  }

  @override
  String get studyOrientation => 'Helling';

  @override
  String get studyAnalysisMode => 'Greiningarstøða';

  @override
  String get studyPinnedChapterComment => 'Føst viðmerking til kapittulin';

  @override
  String get studySaveChapter => 'Goym kapittulin';

  @override
  String get studyClearAnnotations => 'Strika viðmerkingar';

  @override
  String get studyClearVariations => 'Clear variations';

  @override
  String get studyDeleteChapter => 'Strika kapittul';

  @override
  String get studyDeleteThisChapter => 'Strika henda kapittulin? Til ber ikki at angra!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Skulu allar viðmerkingar, øll tekn og teknað skap strikast úr hesum kapitli?';

  @override
  String get studyRightUnderTheBoard => 'Beint undir talvborðinum';

  @override
  String get studyNoPinnedComment => 'Einki';

  @override
  String get studyNormalAnalysis => 'Vanlig greining';

  @override
  String get studyHideNextMoves => 'Fjal næstu leikirnar';

  @override
  String get studyInteractiveLesson => 'Samvirkin frálæra';

  @override
  String studyChapterX(String param) {
    return 'Kapittul $param';
  }

  @override
  String get studyEmpty => 'Tómur';

  @override
  String get studyStartFromInitialPosition => 'Byrja við byrjanarstøðuni';

  @override
  String get studyEditor => 'Ritstjóri';

  @override
  String get studyStartFromCustomPosition => 'Byrja við støðu, ið brúkari ger av';

  @override
  String get studyLoadAGameByUrl => 'Les inn talv frá URL';

  @override
  String get studyLoadAPositionFromFen => 'Les inn talvstøðu frá FEN';

  @override
  String get studyLoadAGameFromPgn => 'Les inn talv frá PGN';

  @override
  String get studyAutomatic => 'Sjálvvirkið';

  @override
  String get studyUrlOfTheGame => 'URL fyri talvini';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Les talv inn frá $param1 ella $param2';
  }

  @override
  String get studyCreateChapter => 'Stovna kapittul';

  @override
  String get studyCreateStudy => 'Stovna rannsókn';

  @override
  String get studyEditStudy => 'Ritstjórna rannsókn';

  @override
  String get studyVisibility => 'Sýni';

  @override
  String get studyPublic => 'Almen';

  @override
  String get studyUnlisted => 'Ikki skrásett';

  @override
  String get studyInviteOnly => 'Bert innboðin';

  @override
  String get studyAllowCloning => 'Loyv kloning';

  @override
  String get studyNobody => 'Eingin';

  @override
  String get studyOnlyMe => 'Bert eg';

  @override
  String get studyContributors => 'Luttakarar';

  @override
  String get studyMembers => 'Limir';

  @override
  String get studyEveryone => 'Øll';

  @override
  String get studyEnableSync => 'Samstilling møgulig';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Ja: varðveit øll í somu støðu';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Nei: lat fólk kaga frítt';

  @override
  String get studyPinnedStudyComment => 'Føst rannsóknarviðmerking';

  @override
  String get studyStart => 'Byrja';

  @override
  String get studySave => 'Goym';

  @override
  String get studyClearChat => 'Rudda kjatt';

  @override
  String get studyDeleteTheStudyChatHistory => 'Skal kjattsøgan í rannsóknini strikast? Til ber ikki at angra!';

  @override
  String get studyDeleteStudy => 'Burturbein rannsókn';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Delete the entire study? There is no going back! Type the name of the study to confirm: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Hvar vilt tú rannsaka hatta?';

  @override
  String get studyGoodMove => 'Góður leikur';

  @override
  String get studyMistake => 'Mistak';

  @override
  String get studyBrilliantMove => 'Framúrskarandi leikur';

  @override
  String get studyBlunder => 'Bukkur';

  @override
  String get studyInterestingMove => 'Áhugaverdur leikur';

  @override
  String get studyDubiousMove => 'Ivasamur leikur';

  @override
  String get studyOnlyMove => 'Einasti leikur';

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
  String get studyWhiteIsWinning => 'Hvítur stendur til at vinna';

  @override
  String get studyBlackIsWinning => 'Svartur stendur til at vinna';

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
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kapitlar',
      one: '$count kapittul',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count talv',
      one: '$count talv',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count limir',
      one: '$count limur',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Set PGN tekstin hjá tær inn her, upp til $count talv',
      one: 'Set PGN tekstin hjá tær inn her, upp til $count talv',
    );
    return '$_temp0';
  }
}
