// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get mobileAllGames => 'Toate jocurile';

  @override
  String get mobileAreYouSure => 'Ești sigur?';

  @override
  String get mobileCancelTakebackOffer => 'Anulați propunerea de revanșă';

  @override
  String get mobileClearButton => 'Resetare';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Șterge mutarea salvată';

  @override
  String get mobileCustomGameJoinAGame => 'Alătură-te unui joc';

  @override
  String get mobileFeedbackButton => 'Feedback';

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
  String get mobileHideVariation => 'Ascunde variațiile';

  @override
  String get mobileHomeTab => 'Acasă';

  @override
  String get mobileLiveStreamers => 'Fluxuri live';

  @override
  String get mobileMustBeLoggedIn => 'Trebuie să te autentifici pentru a accesa această pagină.';

  @override
  String get mobileNoSearchResults => 'Niciun rezultat';

  @override
  String get mobileNotFollowingAnyUser => 'Nu urmărești niciun utilizator.';

  @override
  String get mobileOkButton => 'OK';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Jucători cu \"$param\"';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Mărește piesa trasă';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Vrei să termini acest run?';

  @override
  String get mobilePuzzleStormFilterNothingToShow =>
      'Nimic de afișat, vă rugăm să schimbați filtrele';

  @override
  String get mobilePuzzleStormNothingToShow =>
      'Nimic de arătat. Jucați câteva partide de Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Rezolvă cât mai multe puzzle-uri în 3 minute.';

  @override
  String get mobilePuzzleStreakAbortWarning =>
      'Îți vei pierde streak-ul actual iar scorul va fi salvat.';

  @override
  String get mobilePuzzleThemesSubtitle =>
      'Joacă puzzle-uri din deschiderile tale preferate sau alege o temă.';

  @override
  String get mobilePuzzlesTab => 'Puzzle-uri';

  @override
  String get mobileRecentSearches => 'Căutări recente';

  @override
  String get mobileSettingsImmersiveMode => 'Mod imersiv';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and puzzle screens.';

  @override
  String get mobileSettingsTab => 'Setări';

  @override
  String get mobileShareGamePGN => 'Distribuie PGN';

  @override
  String get mobileShareGameURL => 'Distribuie URL-ul jocului';

  @override
  String get mobileSharePositionAsFEN => 'Distribuie poziția ca FEN';

  @override
  String get mobileSharePuzzle => 'Distribuie acest puzzle';

  @override
  String get mobileShowComments => 'Afişează сomentarii';

  @override
  String get mobileShowResult => 'Arată rezultatul';

  @override
  String get mobileShowVariations => 'Arată variațiile';

  @override
  String get mobileSomethingWentWrong => 'Ceva nu a mers bine. :(';

  @override
  String get mobileSystemColors => 'Culori sistem';

  @override
  String get mobileTheme => 'Tema';

  @override
  String get mobileToolsTab => 'Unelte';

  @override
  String get mobileWaitingForOpponentToJoin => 'În așteptarea unui jucător...';

  @override
  String get mobileWatchTab => 'Vizionează';

  @override
  String get activityActivity => 'Activitate';

  @override
  String get activityHostedALiveStream => 'A găzduit un live stream';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Evaluat #$param1 în $param2';
  }

  @override
  String get activitySignedUp => 'S-a înregistrat pe lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A sprijinit lichess.org pentru $count luni ca și $param2',
      few: 'A sprijinit lichess.org pentru $count luni ca și $param2',
      one: 'A sprijinit lichess.org pentru $count lună ca și $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A practicat $count poziții pe $param2',
      few: 'A practicat $count poziții pe $param2',
      one: 'A practicat $count poziție pe $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A rezolvat $count puzzle-uri tactice',
      few: 'A rezolvat $count puzzle-uri tactice',
      one: 'A rezolvat $count puzzle tactic',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A jucat $count meciuri $param2',
      few: 'A jucat $count meciuri $param2',
      one: 'A jucat $count meci $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A postat $count mesaje în $param2',
      few: 'A postat $count mesaje în $param2',
      one: 'A postat $count mesaj în $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A jucat $count mutări',
      few: 'A jucat $count mutări',
      one: 'A jucat $count mutare',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'în $count jocuri de corespondență',
      few: 'în $count jocuri de corespondență',
      one: 'în $count joc de corespondență',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A completat $count meciuri de corespondență',
      few: 'A completat $count meciuri de corespondență',
      one: 'A completat $count meci de corespondență',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Terminat $count jocuri de tip $param2 de corespondență',
      few: 'Terminat $count jocuri de tip $param2 de corespondență',
      one: 'Terminat $count joc de tip $param2 de corespondență',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A început să urmărească $count jucători',
      few: 'A început să urmărească $count jucători',
      one: 'A început să urmărească $count jucător',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A obținut $count urmăritori noi',
      few: 'A obținut $count urmăritori noi',
      one: 'A obținut $count urmăritor nou',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A găzduit $count simultane de șah',
      few: 'A găzduit $count simultane de șah',
      one: 'A găzduit $count simultană de șah',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A participat în $count simultane de șah',
      few: 'A participat în $count simultane de șah',
      one: 'A participat în $count simultan de șah',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A creat $count studii noi',
      few: 'A creat $count studii noi',
      one: 'A creat $count studiu nou',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A concurat în $count competiții',
      few: 'A concurat în $count competiții',
      one: 'A concurat în $count competiție',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Clasat #$count (top $param2%) cu $param3 meciuri în $param4',
      few: 'Clasat #$count (top $param2%) cu $param3 meciuri în $param4',
      one: 'Clasat #$count (top $param2%) cu $param3 meci în $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A concurat în $count turnee elvețiene',
      few: 'A concurat în $count turnee elvețiene',
      one: 'A concurat în $count turneu elvețian',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'S-a alăturat la $count echipe',
      few: 'S-a alăturat la $count echipe',
      one: 'S-a alăturat la $count echipă',
    );
    return '$_temp0';
  }

  @override
  String get arenaArena => 'Arena';

  @override
  String get arenaArenaTournaments => 'Arena tournaments';

  @override
  String get arenaIsItRated => 'Is it rated?';

  @override
  String get arenaWillBeNotified =>
      'You will be notified when the tournament starts, so it is safe to play in another tab while waiting.';

  @override
  String get arenaIsRated => 'This tournament is rated and will affect your rating.';

  @override
  String get arenaIsNotRated => 'This tournament is *not* rated and will *not* affect your rating.';

  @override
  String get arenaSomeRated => 'Some tournaments are rated and will affect your rating.';

  @override
  String get arenaHowAreScoresCalculated => 'How are scores calculated?';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      'A win has a base score of 2 points, a draw 1 point, and a loss is worth no points.\nIf you win two games consecutively you will start a double-point streak, represented by a flame icon.\nThe following games will continue to be worth double points until you fail to win a game.\nThat is, a win will be worth 4 points, a draw 2 points and a loss will still not award any points.\n\nFor example, two wins followed by a draw will be worth 6 points: 2 + 2 + (2 x 1)';

  @override
  String get arenaBerserk => 'Arena Berserk';

  @override
  String get arenaBerserkAnswer =>
      'When a player clicks the Berserk button at the beginning of the game, they lose half of their clock time, but the win is worth one extra tournament point.\n\nGoing Berserk in time controls with an increment also cancels the increment (1+2 is an exception, it gives 1+0).\n\nBerserk is not available for games with zero initial time (0+1, 0+2).\n\nBerserk only grants an extra point if you play at least 7 moves in the game.';

  @override
  String get arenaHowIsTheWinnerDecided => 'How is the winner decided?';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      'The player(s) with the most points after the tournament\'s set time limit will be announced the winner(s).\n\nWhen two or more players have the same number of points, the tournament performance is the tie break.';

  @override
  String get arenaHowDoesPairingWork => 'How does the pairing work?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      'At the beginning of the tournament, players are paired based on their rating.\nAs soon as you finish a game, return to the tournament lobby: you will then be paired with a player close to your ranking. This ensures minimum wait time, however, you may not face all other players in the tournament.\nPlay fast and return to the lobby to play more games and win more points.';

  @override
  String get arenaHowDoesItEnd => 'How does it end?';

  @override
  String get arenaHowDoesItEndAnswer =>
      'The tournament has a countdown clock. When it reaches zero, the tournament rankings are frozen, and the winner is announced. Games in progress must be finished, however, they don\'t count for the tournament.';

  @override
  String get arenaOtherRules => 'Other important rules';

  @override
  String get arenaThereIsACountdown =>
      'There is a countdown for your first move. Failing to make a move within this time will forfeit the game to your opponent.';

  @override
  String get arenaThisIsPrivate => 'This is a private tournament';

  @override
  String arenaShareUrl(String param) {
    return 'Share this URL to let people join: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return 'Draw streaks: When a player has consecutive draws in an arena, only the first draw will result in a point or draws lasting more than $param moves in standard games. The draw streak can only be broken by a win, not a loss or a draw.';
  }

  @override
  String get arenaDrawStreakVariants =>
      'The minimum game length for drawn games to award points differs by variant. The table below lists the threshold for each variant.';

  @override
  String get arenaVariant => 'Variant';

  @override
  String get arenaMinimumGameLength => 'Minimum game length';

  @override
  String get arenaHistory => 'Arena History';

  @override
  String get arenaNewTeamBattle => 'New Team Battle';

  @override
  String get arenaCustomStartDate => 'Custom start date';

  @override
  String get arenaCustomStartDateHelp =>
      'In your own local timezone. This overrides the \"Time before tournament starts\" setting';

  @override
  String get arenaAllowBerserk => 'Allow Berserk';

  @override
  String get arenaAllowBerserkHelp => 'Let players halve their clock time to gain an extra point';

  @override
  String get arenaAllowChatHelp => 'Let players discuss in a chat room';

  @override
  String get arenaArenaStreaks => 'Arena streaks';

  @override
  String get arenaArenaStreaksHelp => 'After 2 wins, consecutive wins grant 4 points instead of 2.';

  @override
  String get arenaNoBerserkAllowed => 'No Berserk allowed';

  @override
  String get arenaNoArenaStreaks => 'No Arena streaks';

  @override
  String get arenaAveragePerformance => 'Average performance';

  @override
  String get arenaAverageScore => 'Average score';

  @override
  String get arenaMyTournaments => 'My tournaments';

  @override
  String get arenaEditTournament => 'Edit tournament';

  @override
  String get arenaEditTeamBattle => 'Edit team battle';

  @override
  String get arenaDefender => 'Defender';

  @override
  String get arenaPickYourTeam => 'Pick your team';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle =>
      'Which team will you represent in this battle?';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate =>
      'You must join one of these teams to participate!';

  @override
  String get arenaCreated => 'Created';

  @override
  String get arenaRecentlyPlayed => 'Recently played';

  @override
  String get arenaBestResults => 'Best results';

  @override
  String get arenaTournamentStats => 'Tournament stats';

  @override
  String get arenaRankAvgHelp =>
      'The rank average is a percentage of your ranking. Lower is better.\n\nFor instance, being ranked 3 in a tournament of 100 players = 3%. Being ranked 10 in a tournament of 1000 players = 1%.';

  @override
  String get arenaMedians => 'medians';

  @override
  String arenaAllAveragesAreX(String param) {
    return 'All averages on this page are $param.';
  }

  @override
  String get arenaTotal => 'Total';

  @override
  String get arenaPointsAvg => 'Points average';

  @override
  String get arenaPointsSum => 'Points sum';

  @override
  String get arenaRankAvg => 'Rank average';

  @override
  String get arenaTournamentWinners => 'Tournament winners';

  @override
  String get arenaTournamentShields => 'Tournament shields';

  @override
  String get arenaOnlyTitled => 'Only titled players';

  @override
  String get arenaOnlyTitledHelp => 'Require an official title to join the tournament';

  @override
  String get arenaTournamentPairingsAreNowClosed => 'The tournament pairings are now closed.';

  @override
  String get arenaBerserkRate => 'Berserk rate';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Drawing the game within the first $count moves will earn neither player any points.',
      one: 'Drawing the game within the first $count move will earn neither player any points.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'View all $count teams',
      one: 'View the team',
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
    return 'Provocări: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Provoacă la o partidă';

  @override
  String get challengeChallengeDeclined => 'Provocare refuzată';

  @override
  String get challengeChallengeAccepted => 'Provocare acceptată!';

  @override
  String get challengeChallengeCanceled => 'Provocare anulată.';

  @override
  String get challengeRegisterToSendChallenges =>
      'Te rugăm să te înregistrezi pentru a putea trimite provocări.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Nu poți să îl provoci pe $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param nu acceptă provocări.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Scorul tău pe $param1 este prea mare față de $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Nu se poate provoca datorită scorului provizoriu la $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param acceptă provocări doar de la prieteni.';
  }

  @override
  String get challengeDeclineGeneric => 'Nu accept provocări la momentul actual.';

  @override
  String get challengeDeclineLater => 'Nu este timpul potrivit, te rog întreabă mai târziu.';

  @override
  String get challengeDeclineTooFast =>
      'Acest timp este prea rapid pentru mine, te rog să mă provoci cu un timp mai lent.';

  @override
  String get challengeDeclineTooSlow =>
      'Acest timp este prea lent pentru mine, te rog să mă provoci cu un timp mai rapid.';

  @override
  String get challengeDeclineTimeControl => 'Nu accept provocări cu acest timp.';

  @override
  String get challengeDeclineRated => 'Te rog să îmi trimiți în loc o provocare oficială.';

  @override
  String get challengeDeclineCasual => 'Te rog să îmi trimiți în loc o provocare neoficială.';

  @override
  String get challengeDeclineStandard => 'Nu accept provocări de variantă acum.';

  @override
  String get challengeDeclineVariant => 'Nu sunt dispus să joc această variantă acum.';

  @override
  String get challengeDeclineNoBot => 'Nu accept provocările roboților.';

  @override
  String get challengeDeclineOnlyBot => 'Accept doar provocări de la roboți.';

  @override
  String get challengeInviteLichessUser => 'Sau invitați un utilizator Lichess:';

  @override
  String get contactContact => 'Contact';

  @override
  String get contactContactLichess => 'Contactează Lichess';

  @override
  String get coordinatesCoordinates => 'Coordinates';

  @override
  String get coordinatesCoordinateTraining => 'Coordinate training';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return 'Average score as white: $param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return 'Average score as black: $param';
  }

  @override
  String get coordinatesKnowingTheChessBoard =>
      'Knowing the chessboard coordinates is a very important skill for several reasons:';

  @override
  String get coordinatesMostChessCourses =>
      'Most chess courses and exercises use the algebraic notation extensively.';

  @override
  String get coordinatesTalkToYourChessFriends =>
      'It makes it easier to talk to your chess friends, since you both understand the \'language of chess\'.';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively =>
      'You can analyse a game more effectively if you can quickly recognise coordinates.';

  @override
  String get coordinatesACoordinateAppears =>
      'A coordinate appears on the board and you must click on the corresponding square.';

  @override
  String get coordinatesASquareIsHighlightedExplanation =>
      'A square is highlighted on the board and you must enter its coordinate (e.g. \"e4\").';

  @override
  String get coordinatesYouHaveThirtySeconds =>
      'You have 30 seconds to correctly map as many squares as possible!';

  @override
  String get coordinatesGoAsLongAsYouWant => 'Go as long as you want, there is no time limit!';

  @override
  String get coordinatesShowCoordinates => 'Show coordinates';

  @override
  String get coordinatesShowCoordsOnAllSquares => 'Coordinates on every square';

  @override
  String get coordinatesShowPieces => 'Show pieces';

  @override
  String get coordinatesStartTraining => 'Start training';

  @override
  String get coordinatesFindSquare => 'Find square';

  @override
  String get coordinatesNameSquare => 'Name square';

  @override
  String get coordinatesPracticeOnlySomeFilesAndRanks => 'Practice only some files & ranks';

  @override
  String get patronDonate => 'Donează';

  @override
  String get patronLichessPatron => 'Patron Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Statistici $param';
  }

  @override
  String get perfStatViewTheGames => 'Vezi jocurile';

  @override
  String get perfStatProvisional => 'provizoriu';

  @override
  String get perfStatNotEnoughRatedGames =>
      'Nu au fost jucate destule meciuri oficiale pentru a stabili un rating solid.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progres în ultimele $param meciuri:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Devierea ratingului: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'O valoare mai mică înseamnă că ratingul este mai stabil. Peste $param1, ratingul este considerat provizoriu. Pentru a fi inclus în clasament, această valoare ar trebui să fie sub $param2 (șah standard) sau $param3 (variante).';
  }

  @override
  String get perfStatTotalGames => 'Meciuri totale';

  @override
  String get perfStatRatedGames => 'Meciuri oficiale';

  @override
  String get perfStatTournamentGames => 'Meciuri de turnee';

  @override
  String get perfStatBerserkedGames => 'Meciuri berserked';

  @override
  String get perfStatTimeSpentPlaying => 'Timp petrecut jucând';

  @override
  String get perfStatAverageOpponent => 'Adversar în medie';

  @override
  String get perfStatVictories => 'Victorii';

  @override
  String get perfStatDefeats => 'Înfrângeri';

  @override
  String get perfStatDisconnections => 'Deconectări';

  @override
  String get perfStatNotEnoughGames => 'N-au fost jucate destule meciuri';

  @override
  String perfStatHighestRating(String param) {
    return 'Cel mai mare rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Cel mai mic rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'de la $param1 la $param2';
  }

  @override
  String get perfStatWinningStreak => 'Victorii consecutive';

  @override
  String get perfStatLosingStreak => 'Înfrângeri consecutive';

  @override
  String perfStatLongestStreak(String param) {
    return 'Cea mai lungă secvență: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Secvența curentă: $param';
  }

  @override
  String get perfStatBestRated => 'Cele mai bune victorii oficiale';

  @override
  String get perfStatGamesInARow => 'Meciuri jucate consecutiv';

  @override
  String get perfStatLessThanOneHour => 'Mai puțin de o oră între meciuri';

  @override
  String get perfStatMaxTimePlaying => 'Cel mai mult timp petrecut jucând';

  @override
  String get perfStatNow => 'acum';

  @override
  String get preferencesPreferences => 'Preferințe';

  @override
  String get preferencesDisplay => 'Afișare';

  @override
  String get preferencesPrivacy => 'Confidențialitate';

  @override
  String get preferencesNotifications => 'Notificări';

  @override
  String get preferencesPieceAnimation => 'Animația piesei';

  @override
  String get preferencesMaterialDifference => 'Diferență de piese capturate';

  @override
  String get preferencesBoardHighlights => 'Evidențiază pe tablă (ultima mutare și șahul)';

  @override
  String get preferencesPieceDestinations => 'Destinația piesei (mutări valide și premutări)';

  @override
  String get preferencesBoardCoordinates => 'Coordonatele tablei (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Lista de mutări în timpul jocului';

  @override
  String get preferencesPgnPieceNotation => 'Notația mutării';

  @override
  String get preferencesChessPieceSymbol => 'Simbolul piesei de șah';

  @override
  String get preferencesPgnLetter => 'Literă (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Modul Zen';

  @override
  String get preferencesShowPlayerRatings => 'Arată evaluările jucătorului';

  @override
  String get preferencesShowFlairs => 'Arată pictograma personalizată a jucătorului';

  @override
  String get preferencesExplainShowPlayerRatings =>
      'Acest lucru permite ascunderea tuturor ratingurilor de pe site, pentru a ajuta la concentrarea pe jocul de șah. Jocurile pot fi evaluate, această setare este doar despre ce se poate vedea.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Arată indicatorul de redimensionare a tablei';

  @override
  String get preferencesOnlyOnInitialPosition => 'Doar inainte de prima mutare';

  @override
  String get preferencesInGameOnly => 'Doar în joc';

  @override
  String get preferencesExceptInGame => 'Exceptând în timpul jocului';

  @override
  String get preferencesChessClock => 'Ceasul de șah';

  @override
  String get preferencesTenthsOfSeconds => 'Zecimi de secundă';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Când rămân mai puțin de 10 secunde';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Bare orizontale verzi cu progresul';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Sunet când timpul e aproape de expirare';

  @override
  String get preferencesGiveMoreTime => 'Adaugă timp adversarului';

  @override
  String get preferencesGameBehavior => 'Comportamentul din joc';

  @override
  String get preferencesHowDoYouMovePieces => 'Cum mutați piesele?';

  @override
  String get preferencesClickTwoSquares => 'Apasă pe două pătrățele';

  @override
  String get preferencesDragPiece => 'Trage o piesă';

  @override
  String get preferencesBothClicksAndDrag => 'Ambele';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn =>
      'Mutare anticipată (mută pe timpul adversarului)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Dă înapoi (cu aprobarea adversarului)';

  @override
  String get preferencesInCasualGamesOnly => 'În jocuri amicale';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promovează automat în damă';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      'Țineți apăsată tasta <ctrl> în timp ce promovați un pion pentru a dezactiva temporar promovarea automată';

  @override
  String get preferencesWhenPremoving => 'În cazul mutărilor anticipate';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically =>
      'Declară automat o remiză în cazul a trei repetări';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds =>
      'Când timpul rămas e mai scurt de 30 de secunde';

  @override
  String get preferencesMoveConfirmation => 'Confirmare mutare';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled =>
      'Poate fi dezactivat în timpul unui joc cu meniul de tablă';

  @override
  String get preferencesInCorrespondenceGames => 'În jocuri prin corespondență';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Corespondență sau timp nelimitat';

  @override
  String get preferencesConfirmResignationAndDrawOffers =>
      'Confirmă abandonarea și oferirea remizei';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook =>
      'Metoda prin care faci rocada';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Mută regele două pătrățele';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Mută regele pe turn';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Introdu mutări folosind tastatura';

  @override
  String get preferencesInputMovesWithVoice => 'Execută mișcările cu vocea';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Trage săgețile la mutările valide';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      'Spune \"Joc bun, bine jucat\" la înfrângere sau la remiză';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Preferințele tale au fost salvate';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves =>
      'Derulează pe tablă pentru a rejuca mutările';

  @override
  String get preferencesCorrespondenceEmailNotification =>
      'Notificare zilnică prin email cu lista jocurilor prin corespondență';

  @override
  String get preferencesNotifyStreamStart => 'Un streamer e live';

  @override
  String get preferencesNotifyInboxMsg => 'Mesaj nou';

  @override
  String get preferencesNotifyForumMention => 'Un comentariu din forum vă menționează';

  @override
  String get preferencesNotifyInvitedStudy => 'Invitație la un studiu';

  @override
  String get preferencesNotifyGameEvent => 'Actualizări la jocurile prin corespondență';

  @override
  String get preferencesNotifyChallenge => 'Provocări';

  @override
  String get preferencesNotifyTournamentSoon => 'Turneul începe în curând';

  @override
  String get preferencesNotifyTimeAlarm => 'Timpul rămas la jocurile prin corespondenţă e scurt';

  @override
  String get preferencesNotifyBell => 'Notificare în Lichess';

  @override
  String get preferencesNotifyPush => 'Notificare dispozitiv când nu ești în Lichess';

  @override
  String get preferencesNotifyWeb => 'Navigator';

  @override
  String get preferencesNotifyDevice => 'Dispozitiv';

  @override
  String get preferencesBellNotificationSound => 'Sunet de notificare';

  @override
  String get preferencesBlindfold => 'Legat la ochi';

  @override
  String get puzzlePuzzles => 'Probleme de șah';

  @override
  String get puzzlePuzzleThemes => 'Teme pentru problemele de șah';

  @override
  String get puzzleRecommended => 'Recomandare';

  @override
  String get puzzlePhases => 'Faze';

  @override
  String get puzzleMotifs => 'Motive';

  @override
  String get puzzleAdvanced => 'Avansat';

  @override
  String get puzzleLengths => 'Lungimi';

  @override
  String get puzzleMates => 'Mate';

  @override
  String get puzzleGoals => 'Obiective';

  @override
  String get puzzleOrigin => 'Origine';

  @override
  String get puzzleSpecialMoves => 'Mutări speciale';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ți-a plăcut această problemă?';

  @override
  String get puzzleVoteToLoadNextOne => 'Votează pentru a-l încărca pe următorul!';

  @override
  String get puzzleUpVote => 'Îmi place';

  @override
  String get puzzleDownVote => 'Vot negativ';

  @override
  String get puzzleYourPuzzleRatingWillNotChange =>
      'Evaluarea ta la puzzle-uri nu se va schimba. Iți amintim că puzzle-urile nu sunt o competiție. Evaluarea ajută la selectarea celor mai bune puzzle-uri care corespund nivelului tău.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Găsiți cea mai bună mutare pentru alb.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Găsiți cea mai bună mutare pentru negru.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Pentru a primi probleme de șah personalizate:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Problema de șah $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Problema zilei';

  @override
  String get puzzleDailyPuzzle => 'Puzzle Zilnic';

  @override
  String get puzzleClickToSolve => 'Dă click pentru a rezolva';

  @override
  String get puzzleGoodMove => 'Mutare bună';

  @override
  String get puzzleBestMove => 'Cea mai bună mutare!';

  @override
  String get puzzleKeepGoing => 'Continuați cu următoarea mutare…';

  @override
  String get puzzlePuzzleSuccess => 'Succes!';

  @override
  String get puzzlePuzzleComplete => 'Puzzle complet!';

  @override
  String get puzzleByOpenings => 'După deschideri';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzzle-uri după deschidere';

  @override
  String get puzzleOpeningsYouPlayedTheMost =>
      'Deschideri pe care le-ai jucat cel mai mult în meciurile evaluate';

  @override
  String get puzzleUseFindInPage =>
      'Folosește \"Găsește în pagină\" în meniul browser-ului pentru a găsi deschiderea ta preferată!';

  @override
  String get puzzleUseCtrlF => 'Folosește Ctrl+f pentru a găsi deschiderea favorită!';

  @override
  String get puzzleNotTheMove => 'Nu este asta mișcarea!';

  @override
  String get puzzleTrySomethingElse => 'Încercă altceva.';

  @override
  String puzzleRatingX(String param) {
    return 'Scor: $param';
  }

  @override
  String get puzzleHidden => 'ascuns';

  @override
  String puzzleFromGameLink(String param) {
    return 'Din partida $param';
  }

  @override
  String get puzzleContinueTraining => 'Continuați antrenamentul';

  @override
  String get puzzleDifficultyLevel => 'Nivel de dificultate';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Mai ușor';

  @override
  String get puzzleEasiest => 'Cel mai ușor';

  @override
  String get puzzleHarder => 'Mai Greu';

  @override
  String get puzzleHardest => 'Cel mai greu';

  @override
  String get puzzleExample => 'Exemplu';

  @override
  String get puzzleAddAnotherTheme => 'Adăugați o altă temă';

  @override
  String get puzzleNextPuzzle => 'Puzzle-ul următor';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Sari imediat la problema următoare';

  @override
  String get puzzlePuzzleDashboard => 'Panoul de control pentru probleme de șah';

  @override
  String get puzzleImprovementAreas => 'Zone de îmbunătățit';

  @override
  String get puzzleStrengths => 'Puncte tari';

  @override
  String get puzzleHistory => 'Istoric probleme de șah';

  @override
  String get puzzleSolved => 'rezolvat';

  @override
  String get puzzleFailed => 'eșuat';

  @override
  String get puzzleStreakDescription =>
      'Rezolvă probleme din ce în ce mai grele și construiește un șir de victorii consecutive. Nu există limită de timp, deci nu te grăbi. O mișcare greșită și jocul s-a terminat! Dar poți sări peste o mutare în fiecare sesiune.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Probleme consecutive: $param';
  }

  @override
  String get puzzleStreakSkipExplanation =>
      'Sări peste această mutare pentru a-ți păstra șirul de probleme consecutive reușite! Funcționează o singură dată pe sesiune.';

  @override
  String get puzzleContinueTheStreak => 'Continuă secvența';

  @override
  String get puzzleNewStreak => 'Începe o nouă secvență';

  @override
  String get puzzleFromMyGames => 'Din jocurile mele';

  @override
  String get puzzleLookupOfPlayer => 'Caută puzzle-uri din jocurile unui jucător';

  @override
  String get puzzleSearchPuzzles => 'Caută puzzle-uri';

  @override
  String get puzzleFromMyGamesNone =>
      'Nu ai nici o problemă în baza de date, dar Lichess tot te apreciază foarte mult.\nJoacă jocuri rapide și clasice pentru a crește șansele de a vedea adăugată o problemă extrasă din partidele tale!';

  @override
  String get puzzlePuzzleDashboardDescription => 'Antreneaza-te, analizează, fii mai bun';

  @override
  String puzzlePercentSolved(String param) {
    return '$param rezolvate';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nimic de arătat, joacă mai întâi câteva puzzle-uri!';

  @override
  String get puzzleImprovementAreasDescription => 'Antreneaza-te pentru a-ti optimiza progresul!';

  @override
  String get puzzleStrengthDescription => 'Obțineți cele mai bune rezultate la aceste teme';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jucat de $count ori',
      few: 'Jucat de $count ori',
      one: 'Jucat $count dată',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de puncte sub ratingul tău de puzzle-uri',
      few: '$count puncte sub ratingul tău de puzzle-uri',
      one: 'Un punct sub ratingul tău de puzzle-uri',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de puncte deasupra ratingului tău de puzzle-uri',
      few: '$count puncte deasupra ratingului tău de puzzle-uri',
      one: 'Un punct deasupra ratingului tău de puzzle-uri',
    );
    return '$_temp0';
  }

  @override
  String puzzlePuzzlesFoundInUserGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puzzle-uri găsite în jocurile utilizatorului $param2',
      few: '$count puzzle-uri găsite în jocurile utilizatorului $param2',
      one: 'Un puzzle găsit în jocurile utilizatorului $param2',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jucate',
      few: '$count jucate',
      one: '$count jucat',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de rejucat',
      few: '$count de rejucat',
      one: '$count de rejucat',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Pion avansat';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'Unul dintre pionii care este avansat in teritoriul inamic, poate amenință să promoveze.';

  @override
  String get puzzleThemeAdvantage => 'Avantaj';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Profită de șansa ta pentru a obține un avantaj decisiv. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mat-ul Anastasiei';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'Un cal şi o tură sau o regină fac echipă pentru a prinde regele opus între marginea tablei şi o piesă aliată.';

  @override
  String get puzzleThemeArabianMate => 'Mat-ul arab';

  @override
  String get puzzleThemeArabianMateDescription =>
      'Un cal și o tură au făcut echipă să prinda regele într-un colț de tablă.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Atac pe f2 sau f7';

  @override
  String get puzzleThemeAttackingF2F7Description =>
      'Un atac concentrat pe pionul f2 sau f7, cum ar fi în deschiderea ficat prăjit (atacul Fegatello).';

  @override
  String get puzzleThemeAttraction => 'Atragere';

  @override
  String get puzzleThemeAttractionDescription =>
      'Un schimb sau sacrificiu care încurajează sau forțează o piesă adversară pe un pătrat care permite o tactică ulterioară.';

  @override
  String get puzzleThemeBackRankMate => 'Mat pe rândul din spate';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Dă șah mat regelui pe rândul inițial, când e blocat acolo de propriele lui piese.';

  @override
  String get puzzleThemeBishopEndgame => 'Final cu nebuni';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Un final de partidă doar cu nebuni și pioni.';

  @override
  String get puzzleThemeBodenMate => 'Mat-ul lui Boden';

  @override
  String get puzzleThemeBodenMateDescription =>
      'Doi nebuni care atacă pe diagonale încrucișate livrează mat-ul unui rege blocat de piese aliate.';

  @override
  String get puzzleThemeCastling => 'Rocada';

  @override
  String get puzzleThemeCastlingDescription => 'Adu regele în siguranță și mută tura pentru atac.';

  @override
  String get puzzleThemeCapturingDefender => 'Capturează apărătorul';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Capturarea unei piese esențiale apărării alteia, permițând captura piesei acum neapărată la o mutare ulterioară.';

  @override
  String get puzzleThemeCrushing => 'Zdrobitor';

  @override
  String get puzzleThemeCrushingDescription =>
      'Observă gafa adversarului pentru a obține un avantaj zdrobitor. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat-ul cu doi nebuni';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Doi nebuni care atacă pe diagonale adiacente livrează mat-ul unui rege blocat de piese aliate.';

  @override
  String get puzzleThemeDovetailMate => 'Mat-ul dovertail';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'O regină livrează mat-ul unui rege adiacent, care are doar două patrate de scapare dar sunt blocate de piese aliate.';

  @override
  String get puzzleThemeEquality => 'Egalitate';

  @override
  String get puzzleThemeEqualityDescription =>
      'Întoarce-te dintr-o poziție de pierdere și asigură o remiză sau o poziție echilibrată. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Atac pe partea regelui';

  @override
  String get puzzleThemeKingsideAttackDescription =>
      'Un atac al regelui adversarului, după ce a făcut rocada pe partea regelui.';

  @override
  String get puzzleThemeClearance => 'Îndepărtare';

  @override
  String get puzzleThemeClearanceDescription =>
      'O mutare, adeseori cu tempo, care eliberează un pătrat, o coloană sau o diagonală pentru o idee tactică ulterioară.';

  @override
  String get puzzleThemeDefensiveMove => 'Mutare defensivă';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'O mutare precisă sau o secvență de mutări care e necesară pentru a evita pierderea pieselor sau a unui alt avantaj.';

  @override
  String get puzzleThemeDeflection => 'Deviere';

  @override
  String get puzzleThemeDeflectionDescription =>
      'O mutare care distrage o piesă adversară de la o altă funcție pe care o îndeplinește, cum ar fi apărarea unui pătrat esențial.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Atac prin descoperire';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Mutarea unei piese care bloca anterior un atac de la o altă piesă cu rază lungă de acțiune, cum ar fi un cal din calea unui turn.';

  @override
  String get puzzleThemeDoubleCheck => 'Șah dublu';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Șahul cu două piese deodată, ca rezultat al unui atac descoperit unde și piesa mutată, și cea descoperită atacă regele adversarului.';

  @override
  String get puzzleThemeEndgame => 'Final de partidă';

  @override
  String get puzzleThemeEndgameDescription => 'O tactică în ultima etapă a jocului.';

  @override
  String get puzzleThemeEnPassantDescription =>
      'O tactică cu regula en passant, unde un pion poate captura un pion adversar care l-a întrecut folosind mutarea sa inițială de două pătrate.';

  @override
  String get puzzleThemeExposedKing => 'Rege expus';

  @override
  String get puzzleThemeExposedKingDescription =>
      'O tactică ce implică un rege cu puțini apărători în jurul său, adeseori rezultând în șah mat.';

  @override
  String get puzzleThemeFork => 'Bifurcare';

  @override
  String get puzzleThemeForkDescription =>
      'O mutare unde piesa mutată atacă două piese adversare deodată.';

  @override
  String get puzzleThemeHangingPiece => 'Piesă neprotejată';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'O tactică ce implică o piesă adversară care e neprotejată sau apărată insuficient și e liberă pentru capturare.';

  @override
  String get puzzleThemeHookMate => 'Mat-ul hook';

  @override
  String get puzzleThemeHookMateDescription =>
      'Șah mat cu o tură, un cal și un pion alături de un pion inamic pentru a limita metodele de scăpare ale regelui.';

  @override
  String get puzzleThemeInterference => 'Obstacol';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Mutarea unei piese între două piese adversare pentru a lăsa una sau ambele piese adversare neprotejate, cum ar fi un cal pe un pătrat protejat dintre două ture.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'În loc să faci mutarea așteptată, mai întâi intervii cu o altă mutare care e o amenințare imediată, căreia adversarul trebuie să-i răspundă. Cunoscut și ca \"Zwischenzug\" sau \"In between\".';

  @override
  String get puzzleThemeKillBoxMate => 'Mat în casetă mortală';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'O tură este lingă regele inamic și susținută de o regină care de asemenea blochează pătratele pe unde ar putea evada regele. Tura și regina îl prind pe rege într-o \"casetă mortală\" de 3x3.';

  @override
  String get puzzleThemeVukovicMate => 'Mat Vukovic';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'O tură și un cal fac echipă pentru a da șah mat regelui. Tura dă mat fiind apărată de o a treia piesă iar calul blochează toate căile de scăpare ale regelui.';

  @override
  String get puzzleThemeKnightEndgame => 'Final cu cai';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Un final de partidă doar cu pioni și cai.';

  @override
  String get puzzleThemeLong => 'Puzzle lung';

  @override
  String get puzzleThemeLongDescription => 'Trei mutări pentru a câștiga.';

  @override
  String get puzzleThemeMaster => 'Partidele maeștrilor';

  @override
  String get puzzleThemeMasterDescription =>
      'Puzzle-uri din partidele jucate de jucători care au primit titluri FIDE.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partide maestru vs maestru';

  @override
  String get puzzleThemeMasterVsMasterDescription =>
      'Puzzle-uri din partidele jucate între doi jucători care au primit titluri FIDE.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Câștigă jocul cu stil.';

  @override
  String get puzzleThemeMateIn1 => 'Mat din 1';

  @override
  String get puzzleThemeMateIn1Description => 'Dă mat dintr-o mutare.';

  @override
  String get puzzleThemeMateIn2 => 'Mat din 2';

  @override
  String get puzzleThemeMateIn2Description => 'Dă mat din două mutări.';

  @override
  String get puzzleThemeMateIn3 => 'Mat din 3';

  @override
  String get puzzleThemeMateIn3Description => 'Dă mat din trei mutări.';

  @override
  String get puzzleThemeMateIn4 => 'Mat din 4';

  @override
  String get puzzleThemeMateIn4Description => 'Dă mat din patru mutări.';

  @override
  String get puzzleThemeMateIn5 => 'Mat din 5 sau mai multe';

  @override
  String get puzzleThemeMateIn5Description => 'Găsește o secvență lungă de mat.';

  @override
  String get puzzleThemeMiddlegame => 'Mijlocul jocului';

  @override
  String get puzzleThemeMiddlegameDescription => 'O tactică în a doua etapă a jocului.';

  @override
  String get puzzleThemeOneMove => 'Puzzle de o mutare';

  @override
  String get puzzleThemeOneMoveDescription => 'Un puzzle care are doar o mutare.';

  @override
  String get puzzleThemeOpening => 'Deschidere';

  @override
  String get puzzleThemeOpeningDescription => 'O tactică în prima etapă a jocului.';

  @override
  String get puzzleThemePawnEndgame => 'Final cu pioni';

  @override
  String get puzzleThemePawnEndgameDescription => 'Un final de partidă doar cu pioni.';

  @override
  String get puzzleThemePin => 'Blocare';

  @override
  String get puzzleThemePinDescription =>
      'O tactică cu blocări, unde o piesă nu se poate mișca fără a descoperi un atac asupra unei piese mai valoroase.';

  @override
  String get puzzleThemePromotion => 'Promovare';

  @override
  String get puzzleThemePromotionDescription =>
      'Un pion care promovează sau amenință să promoveze e cheia acestei tactici.';

  @override
  String get puzzleThemeQueenEndgame => 'Final cu regine';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Un final de partidă doar cu regine și pioni.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Final cu regine și turnuri';

  @override
  String get puzzleThemeQueenRookEndgameDescription =>
      'Un final de partidă doar cu regine, turnuri și pioni.';

  @override
  String get puzzleThemeQueensideAttack => 'Atac pe partea reginei';

  @override
  String get puzzleThemeQueensideAttackDescription =>
      'Un atac asupra regelui adversarului, după ce a făcut rocada pe partea reginei.';

  @override
  String get puzzleThemeQuietMove => 'Mutare silențioasă';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'O mutare care nu capturează sau dă șah, dar care pregătește o amenințare inevitabilă pentru o mutare ulterioară.';

  @override
  String get puzzleThemeRookEndgame => 'Final cu turnuri';

  @override
  String get puzzleThemeRookEndgameDescription => 'Un final de partidă doar cu turnuri și pioni.';

  @override
  String get puzzleThemeSacrifice => 'Sacrificiu';

  @override
  String get puzzleThemeSacrificeDescription =>
      'O tactică care implică renunțarea la material pe termen scurt pentru a câștiga un avantaj din nou după o secvență forțată de mutări.';

  @override
  String get puzzleThemeShort => 'Puzzle scurt';

  @override
  String get puzzleThemeShortDescription => 'Două mutări pentru a câștiga.';

  @override
  String get puzzleThemeSkewer => 'Skewer';

  @override
  String get puzzleThemeSkewerDescription =>
      'Un motiv care implică atacarea unei piese de mare valoare, mutarea înafara traseului, și permițând capturarea sau atacarea unei piese cu valoare inferioară în spatele ei, inversul unui pin.';

  @override
  String get puzzleThemeSmotheredMate => 'Mat sufocat';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'Un șah mat livrat de un cal în care regele împerechiat este incapabil să se miște deoarece este înconjurat (sau sufocat) de piesele lui aliate.';

  @override
  String get puzzleThemeSuperGM => 'Partidele Super GM';

  @override
  String get puzzleThemeSuperGMDescription =>
      'Puzzle-uri din partidele jucate de cei mai buni jucători din lume.';

  @override
  String get puzzleThemeTrappedPiece => 'Piesa blocată';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'O piesa este incapabilă de a scăpa din capturarea deoarece are mutări limitate.';

  @override
  String get puzzleThemeUnderPromotion => 'Subpromovare';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promovează într-un cal, un nebun sau o tură.';

  @override
  String get puzzleThemeVeryLong => 'Problemă foarte lungă';

  @override
  String get puzzleThemeVeryLongDescription => 'Patru mutări sau mai multe pentru a câștiga.';

  @override
  String get puzzleThemeXRayAttack => 'Atac raze x';

  @override
  String get puzzleThemeXRayAttackDescription =>
      'O piesă atacă sau apară un patrat, printr-o piesă inamică.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription =>
      'Adversarul este limitat în mișcările pe care le poate face, iar toate mișcările îi înrăutățesc poziția.';

  @override
  String get puzzleThemeMix => 'Mixt';

  @override
  String get puzzleThemeMixDescription =>
      'Un pic din toate. Nu știi la ce să te aștepți, așa că rămâi gata pentru orice! La fel ca în jocurile reale.';

  @override
  String get puzzleThemePlayerGames => 'Partide jucători';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Caută puzzle-uri generate din partidele tale sau din partidele unui alt jucător.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Aceste puzzle-uri sunt în domeniul public și pot fi descărcate de la $param.';
  }

  @override
  String get searchSearch => 'Căutare';

  @override
  String get settingsSettings => 'Setări';

  @override
  String get settingsCloseAccount => 'Închide contul';

  @override
  String get settingsManagedAccountCannotBeClosed =>
      'Contul tău este gestionat și nu poate fi închis.';

  @override
  String get settingsCantOpenSimilarAccount =>
      'Nu îți va fi permis să creezi un cont nou cu același nume, indiferent dacă literele sunt minuscule sau majuscule.';

  @override
  String get settingsCancelKeepAccount => 'Anulează și păstrează contul';

  @override
  String get settingsCloseAccountAreYouSure => 'Ești sigur că vrei să închizi contul?';

  @override
  String get settingsThisAccountIsClosed => 'Contul este închis.';

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
  String get stormMoveToStart => 'Miscă-te ca să începi';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Joci cu piesele albe în toate puzzle-urile';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles =>
      'Joci cu piesele negre în toate puzzle-urile';

  @override
  String get stormPuzzlesSolved => 'probleme rezolvate';

  @override
  String get stormNewDailyHighscore => 'Scor de top nou zilnic!';

  @override
  String get stormNewWeeklyHighscore => 'Scor de top nou săptămânal!';

  @override
  String get stormNewMonthlyHighscore => 'Scor de top nou lunar!';

  @override
  String get stormNewAllTimeHighscore => 'Scor nou de top din toate timpurile!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Scorul de top anterior a fost $param';
  }

  @override
  String get stormPlayAgain => 'Joacă din nou';

  @override
  String stormHighscoreX(String param) {
    return 'Scor de top: $param';
  }

  @override
  String get stormScore => 'Scor';

  @override
  String get stormMoves => 'Mutări';

  @override
  String get stormAccuracy => 'Acuratețe';

  @override
  String get stormCombo => 'Combinație';

  @override
  String get stormTime => 'Timp';

  @override
  String get stormTimePerMove => 'Timp per mutare';

  @override
  String get stormHighestSolved => 'Cel mai bun rezolvat';

  @override
  String get stormPuzzlesPlayed => 'Probleme jucate';

  @override
  String get stormNewRun => 'Încercare nouă (tasta: Space)';

  @override
  String get stormEndRun => 'Încheie încercarea (tasta: Enter)';

  @override
  String get stormHighscores => 'Scoruri de top';

  @override
  String get stormViewBestRuns => 'Vezi cele mai bune încercări';

  @override
  String get stormBestRunOfDay => 'Încercarea zilei';

  @override
  String get stormRuns => 'Încercări';

  @override
  String get stormGetReady => 'Pregătește-te!';

  @override
  String get stormWaitingForMorePlayers => 'Se așteaptă mai mulți jucători...';

  @override
  String get stormRaceComplete => 'Cursă terminată!';

  @override
  String get stormSpectating => 'Spectator';

  @override
  String get stormJoinTheRace => 'Intră în cursă!';

  @override
  String get stormStartTheRace => 'Începe cursa';

  @override
  String stormYourRankX(String param) {
    return 'Poziția ta: $param';
  }

  @override
  String get stormWaitForRematch => 'Așteaptă pentru revanșă';

  @override
  String get stormNextRace => 'Următoarea cursă';

  @override
  String get stormJoinRematch => 'Intră în cursa pentru revanșă';

  @override
  String get stormWaitingToStart => 'Se așteaptă startul';

  @override
  String get stormCreateNewGame => 'Creează o nouă partidă';

  @override
  String get stormJoinPublicRace => 'Alătură-te unei curse publice';

  @override
  String get stormRaceYourFriends => 'Invită-ți prietenii';

  @override
  String get stormSkip => 'omite';

  @override
  String get stormSkipHelp => 'Poți sări peste o mutare pe cursă:';

  @override
  String get stormSkipExplanation =>
      'Sări peste această mutare pentru a păstra combo-ul! Funcționează o singură dată pe cursă.';

  @override
  String get stormFailedPuzzles => 'Probleme eșuate';

  @override
  String get stormSlowPuzzles => 'Probleme lente';

  @override
  String get stormSkippedPuzzle => 'Probleme sărite';

  @override
  String get stormThisWeek => 'Săptămâna aceasta';

  @override
  String get stormThisMonth => 'Luna aceasta';

  @override
  String get stormAllTime => 'De la început';

  @override
  String get stormClickToReload => 'Click pentru a reîncărca';

  @override
  String get stormThisRunHasExpired => 'Această rundă a expirat!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Runda a fost deschisă într-o altă filă!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count încercări',
      few: '$count încercări',
      one: 'O încercare',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A jucat $count încercări de $param2',
      few: 'A jucat $count încercări de $param2',
      one: 'A jucat o încercare de $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streameri';

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
  String get timeagoJustNow => 'chiar acum';

  @override
  String get timeagoRightNow => 'chiar acum';

  @override
  String get timeagoCompleted => 'completat';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'în $count de secunde',
      few: 'în $count secunde',
      one: 'în $count secundă',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'în $count de minute',
      few: 'în $count minute',
      one: 'în $count minut',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'în $count de ore',
      few: 'în $count ore',
      one: 'în $count oră',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'în $count de zile',
      few: 'în $count zile',
      one: 'în $count zi',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'în $count de săptămâni',
      few: 'în $count săptămâni',
      one: 'în $count săptămână',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'în $count de luni',
      few: 'în $count luni',
      one: 'în $count lună',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'în $count de ani',
      few: 'în $count ani',
      one: 'în $count an',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cu $count de minute în urmă',
      few: 'cu $count minute în urmă',
      one: 'cu $count minut în urmă',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cu $count de ore în urmă',
      few: 'cu $count ore în urmă',
      one: 'cu $count oră în urmă',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cu $count de zile în urmă',
      few: 'cu $count zile în urmă',
      one: 'cu $count zi în urmă',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cu $count de săptămâni în urmă',
      few: 'cu $count săptămâni în urmă',
      one: 'cu $count săptămână în urmă',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cu $count de luni în urmă',
      few: 'cu $count luni în urmă',
      one: 'cu $count lună în urmă',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cu $count de ani în urmă',
      few: 'cu $count ani în urmă',
      one: 'cu $count an în urmă',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minute rămase',
      few: '$count minute rămase',
      one: '$count minut rămas',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore rămase',
      few: '$count ore rămase',
      one: '$count oră rămasă',
    );
    return '$_temp0';
  }
}
