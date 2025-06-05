// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Armenian (`hy`).
class AppLocalizationsHy extends AppLocalizations {
  AppLocalizationsHy([String locale = 'hy']) : super(locale);

  @override
  String get mobileAllGames => 'All games';

  @override
  String get mobileAreYouSure => 'Are you sure?';

  @override
  String get mobileBoardSettings => 'Board settings';

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
  String get mobilePuzzleStreakAbortWarning =>
      'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleThemesSubtitle =>
      'Play puzzles from your favorite openings, or choose a theme.';

  @override
  String get mobilePuzzlesTab => 'Puzzles';

  @override
  String get mobileRecentSearches => 'Recent searches';

  @override
  String get mobileRemoveBookmark => 'Remove bookmark';

  @override
  String get mobileSettingsImmersiveMode => 'Immersive mode';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and puzzle screens.';

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
  String get mobileTapHereToStartPlayingChess => 'Tap here to start playing chess.';

  @override
  String get mobileTheme => 'Theme';

  @override
  String get mobileToolsTab => 'Tools';

  @override
  String get mobileWaitingForOpponentToJoin => 'Waiting for opponent to join...';

  @override
  String get mobileWatchTab => 'Watch';

  @override
  String get mobileWelcomeToLichessApp => 'Welcome to Lichess app!';

  @override
  String get activityActivity => 'Activity';

  @override
  String get activityHostedALiveStream => 'Hosted a live stream';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Ranked #$param1 in $param2';
  }

  @override
  String get activitySignedUp => 'Signed up to lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supported lichess.org for $count months as a $param2',
      one: 'Supported lichess.org for $count month as a $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Practised $count positions on $param2',
      one: 'Practised $count position on $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Solved $count training puzzles',
      one: 'Solved $count training puzzle',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Played $count $param2 games',
      one: 'Played $count $param2 game',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Posted $count messages in $param2',
      one: 'Posted $count message in $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Played $count moves',
      one: 'Played $count move',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count correspondence games',
      one: 'in $count correspondence game',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Completed $count correspondence games',
      one: 'Completed $count correspondence game',
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
      other: 'Started following $count players',
      one: 'Started following $count player',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gained $count new followers',
      one: 'Gained $count new follower',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hosted $count simultaneous exhibitions',
      one: 'Hosted $count simultaneous exhibition',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Participated in $count simultaneous exhibitions',
      one: 'Participated in $count simultaneous exhibition',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Created $count new studies',
      one: 'Created $count new study',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Competed in $count Arena tournaments',
      one: 'Competed in $count Arena tournament',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ranked #$count (top $param2%) with $param3 games in $param4',
      one: 'Ranked #$count (top $param2%) with $param3 game in $param4',
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
      other: 'Joined $count teams',
      one: 'Joined $count team',
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
    return 'Մարտահրավերներ: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Ուղարկել խաղի մարտահրավեր';

  @override
  String get challengeChallengeDeclined => 'Մարտահրավերը մերժված է';

  @override
  String get challengeChallengeAccepted => 'Մարտահրավերն ընդունված է';

  @override
  String get challengeChallengeCanceled => 'Մարտահրավերը կասեցված է';

  @override
  String get challengeRegisterToSendChallenges => 'Գրանցվեք՝ մրցակիցներին խաղի հրավիրելու համար։';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Դուք չեք կարող խաղին հրավիրել $param-ին։';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param-ը չի ընդունում մարտահրավերները։';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Ձեր $param1 վարկանիշը շատ հեռու է $param2-ից։';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Հնարավոր չէ հրավիրել խաղի՝ $param վարկանիշի անհավաստիության պատճառով։';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param-ն մարտահրավերներ է ընդունում միայն ընկերներից։';
  }

  @override
  String get challengeDeclineGeneric => 'Այս պահին մարտահրավերներ չեմ ընդունում։';

  @override
  String get challengeDeclineLater =>
      'Այս պահին մարտահրավերներ չեմ ընդունում, խնդրում եմ, հրավիրեք ինձ ավելի ուշ։';

  @override
  String get challengeDeclineTooFast =>
      'Այդ ժամակարգն ինձ համար շատ արագ է, խնդրում եմ, հրավիրեք ինձ ավելի երկար ժամակարգով խաղի։';

  @override
  String get challengeDeclineTooSlow =>
      'Այդ ժամակարգն ինձ համար շատ դանդաղ է, խնդրում եմ, հրավիրեք ինձ ավելի կարճ ժամակարգով խաղի։';

  @override
  String get challengeDeclineTimeControl => 'Այդպիսի ժամակարգով մարտահրավերներ չեմ ընդունում։';

  @override
  String get challengeDeclineRated => 'Հրավիրեք ինձ վարկանիշային խաղի, խնդրում եմ։';

  @override
  String get challengeDeclineCasual => 'Հրավիրեք ինձ ընկերական խաղի, խնդրում եմ։';

  @override
  String get challengeDeclineStandard =>
      'Ես չեմ ընդունում ոչ դասական շախմատի մարտահրավերներ հենց հիմա։';

  @override
  String get challengeDeclineVariant => 'Ես չեմ ցանկանում շախմատի այս տարբերակը խաղալ հիմա։';

  @override
  String get challengeDeclineNoBot => 'Ես չեմ ընդունում բոտերի մարտահրավերները։';

  @override
  String get challengeDeclineOnlyBot => 'Ես ընդունում եմ միայն բոտերի մարտահրավերները։';

  @override
  String get challengeInviteLichessUser => 'Կամ հրավիրեք Lichess-ի օգտատիրոջ.';

  @override
  String get contactContact => 'Contact';

  @override
  String get contactContactLichess => 'Contact Lichess';

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
  String get patronDonate => 'Donate';

  @override
  String get patronLichessPatron => 'Lichess Patron';

  @override
  String perfStatPerfStats(String param) {
    return '$param վիճակագրություն';
  }

  @override
  String get perfStatViewTheGames => 'Դիտել պարտիաները';

  @override
  String get perfStatProvisional => 'նախնական';

  @override
  String get perfStatNotEnoughRatedGames =>
      'Ճշգրիտ վարկանիշն իմանալու համար վարկանիշային պարտիաների քանակը բավարար չէ։';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Աճը վերջին $param խաղերի ընթացքում.';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Վարկանիշի շեղումը` $param։';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Ցածրագույն արժեքը նշանակում է, որ վարկանիշն ավելի կայուն է։ Եթե այդ ցուցանիշը գերազանցում է $param1-ը, ապա վարկանիշը համարվում է մոտավոր։ Վարկանիշի ցանկերում ընդգրկվելու համար այդ ցուցանիշը պետք է փոքր լինի $param2-ից (դասական շախմատ) կամ $param3-ից (տարբերակներ)։';
  }

  @override
  String get perfStatTotalGames => 'Ընդամենը պարտիաներ';

  @override
  String get perfStatRatedGames => 'Վարկանիշային պարտիաներ';

  @override
  String get perfStatTournamentGames => 'Մրցաշարային պարտիաներ';

  @override
  String get perfStatBerserkedGames => 'Բերսերկով պարտիաներ';

  @override
  String get perfStatTimeSpentPlaying => 'Ընդհանուր խաղաժամանակ';

  @override
  String get perfStatAverageOpponent => 'Մրցակիցների միջին վարկանիշը';

  @override
  String get perfStatVictories => 'Հաղթանակներ';

  @override
  String get perfStatDefeats => 'Պարտություններ';

  @override
  String get perfStatDisconnections => 'Անջատումներ';

  @override
  String get perfStatNotEnoughGames => 'Խաղացված պարտիաների քանակն անբավարար է';

  @override
  String perfStatHighestRating(String param) {
    return 'Բարձրագույն վարկանիշ` $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Ցածրագույն վարկանիշ` $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1-ից $param2';
  }

  @override
  String get perfStatWinningStreak => 'Անընդմեջ հաղթանակներ';

  @override
  String get perfStatLosingStreak => 'Անընդմեջ պարտություններ';

  @override
  String perfStatLongestStreak(String param) {
    return 'Ամենաերկար շարքը` $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Ընթացիկ շարքը` $param';
  }

  @override
  String get perfStatBestRated => 'Հաղթանակներ ամենաբարձր վարկանիշ ունեցողների նկատմամբ';

  @override
  String get perfStatGamesInARow => 'Անընդմեջ խաղացված պարտիաներ';

  @override
  String get perfStatLessThanOneHour => 'Պարտիաների միջև դադարը` մեկ ժամից պակաս';

  @override
  String get perfStatMaxTimePlaying => 'Առավելագույն խաղաժամանակ';

  @override
  String get perfStatNow => 'հիմա';

  @override
  String get preferencesPreferences => 'Preferences';

  @override
  String get preferencesDisplay => 'Display';

  @override
  String get preferencesPrivacy => 'Privacy';

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
  String get preferencesPgnLetter => 'Letter (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen mode';

  @override
  String get preferencesShowPlayerRatings => 'Show player ratings';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings =>
      'This hides all ratings from Lichess, to help focus on the chess. Rated games still impact your rating, this is only about what you get to see.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Show board resize handle';

  @override
  String get preferencesOnlyOnInitialPosition => 'Only on initial position';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesExceptInGame => 'Except in-game';

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
  String get preferencesPremovesPlayingDuringOpponentTurn =>
      'Premoves (playing during opponent turn)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Takebacks (with opponent approval)';

  @override
  String get preferencesInCasualGamesOnly => 'In casual games only';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promote to Queen automatically';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'When premoving';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically =>
      'Claim draw on threefold repetition automatically';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds =>
      'When time remaining < 30 seconds';

  @override
  String get preferencesMoveConfirmation => 'Move confirmation';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled =>
      'Can be disabled during a game with the board menu';

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
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      'Say \"Good game, well played\" upon defeat or draw';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Your preferences have been saved.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Scroll on the board to replay moves';

  @override
  String get preferencesCorrespondenceEmailNotification =>
      'Daily email listing your correspondence games';

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
  String get puzzleThemeAdvancedPawn => 'Առաջ գնացած զինվոր';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'Զինվորը վերածվելու կամ զինվորը վերածվելու սպառնալիքի հետ կապված մարտավարություն։';

  @override
  String get puzzleThemeAdvantage => 'Առավելություն';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Օգտագործեք որոշիչ առավելություն ստանալու Ձեր հնարավորությունը (200-ից 600 սանտիզինվոր)';

  @override
  String get puzzleThemeAnastasiaMate => 'Անաստասիայի մատ';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'Ձին և նավակը (կամ թագուհին) մրցակցի արքային մատ են անում խաղատախտակի եզրի և մրցակցի այլ խաղաքարի միջև։';

  @override
  String get puzzleThemeArabianMate => 'Արաբական մատ';

  @override
  String get puzzleThemeArabianMateDescription =>
      'Ձին և նավակը մրցակցի արքային մատ են անում խաղատախտակի անկյունում։';

  @override
  String get puzzleThemeAttackingF2F7 => 'Գրոհ f2-ի կամ f7-ի վրա';

  @override
  String get puzzleThemeAttackingF2F7Description =>
      'f2 կամ f7 զինվորների վրա ուղղված գրոհ, օրինակ, Ֆեգատելլոյի գրոհում (տապակած լյարդի սկզբնախաղում)։';

  @override
  String get puzzleThemeAttraction => 'Հրապուրում';

  @override
  String get puzzleThemeAttractionDescription =>
      'Փոխանակում կամ զոհաբերություն, որը ստիպում կամ մղում է մրցակցի խաղաքարին զբաղեցնել դաշտը, որից հետո հնարավոր է դառնում հետագա մարտավարական հնարքը։';

  @override
  String get puzzleThemeBackRankMate => 'Մատ վերջին հորիզոնականում';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Մատ արքային նրա իսկ հորիզոնականում, երբ նա շրջափակված է իր իսկ խաղաքարերով։';

  @override
  String get puzzleThemeBishopEndgame => 'Փղային վերջնախաղ';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Միայն փղերով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeBodenMate => 'Բոդենի մատ';

  @override
  String get puzzleThemeBodenMateDescription =>
      'Խաչվող անկյունագծերում գտնվող երկու փղերը մատ են հայտարարում մրցակցի արքային, որը շրջափակված է սեփական խաղաքարերով։';

  @override
  String get puzzleThemeCastling => 'Փոխատեղում';

  @override
  String get puzzleThemeCastlingDescription =>
      'Արքայի տեղափոխումն ապահով տեղ և նավակի դուրսբերումը մարտի։';

  @override
  String get puzzleThemeCapturingDefender => 'Պաշտպանի վերացում';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Այլ խաղաքարը պաշտպանող խաղաքարի շահում կամ փոխանակում՝ հետագայում անպաշտպան մնացած խաղաքարի շահումով։';

  @override
  String get puzzleThemeCrushing => 'Ջախջախում';

  @override
  String get puzzleThemeCrushingDescription =>
      'Օգտագործեք մրցակցի վրիպումը՝ ջախջախիչ առավելություն (600 և ավելի սանտիզինվոր) ստանալու համար';

  @override
  String get puzzleThemeDoubleBishopMate => 'Մատ երկու փղով';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Հարակից անկյունագծերում գտնվող երկու փղերը մատ են հայտարարում մրցակցի արքային, որը շրջափակված է սեփական խաղաքարերով։';

  @override
  String get puzzleThemeDovetailMate => '«Ծիծեռնակի պոչ» մատ';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'Մատ թագուհով կողքին կանգնած արքային, որի նահանջի միակ երկու դաշտերը զբաղեցնում են սեփական խաղաքարերը։';

  @override
  String get puzzleThemeEquality => 'Հավասարեցում';

  @override
  String get puzzleThemeEqualityDescription =>
      'Պարտված դիրքից հավասարեցրեք խաղը. պարտիան ավարտեք ոչ-ոքի կամ ստացեք նյութական հավասարություն (200 սանտիզինվորից պակաս)';

  @override
  String get puzzleThemeKingsideAttack => 'Գրոհ արքայական թևում';

  @override
  String get puzzleThemeKingsideAttackDescription =>
      'Գրոհ մրցակցի՝ կարճ կողմում փոխատեղում կատարած արքայի վրա։';

  @override
  String get puzzleThemeClearance => 'Գծի կամ դաշտի ազատում';

  @override
  String get puzzleThemeClearanceDescription =>
      'Որպես կանոն, տեմպով կատարվող քայլ, որն ազատում է դաշտը, գիծը կամ անկյունագիծը՝ մարտավարական մտահղացումն իրագործելու նպատակով։';

  @override
  String get puzzleThemeDefensiveMove => 'Պաշտպանական քայլ';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'Ճշգրիտ քայլ կամ քայլերի հաջորդականություն, որոնք անհրաժեշտ են նյութական կամ առավելության կորստից խուսափելու համար։';

  @override
  String get puzzleThemeDeflection => 'Շեղում';

  @override
  String get puzzleThemeDeflectionDescription =>
      'Քայլ, որը մրցակցի խաղաքարը շեղում է կարևոր խնդրից, օրինակ, հանգուցային դաշտի պաշտպանությունից։';

  @override
  String get puzzleThemeDiscoveredAttack => 'Բացված հարձակում';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Քայլ խաղաքարով, որ ծածկում է հեռահար խաղաքարի գրոհի գիծը։ Օրինակ, քայլ ձիով, որով բացվում է գիծը նրա հետևում կանգնած նավակի համար։';

  @override
  String get puzzleThemeDoubleCheck => 'Կրկնակի շախ';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Շախ միաժամանակ երկու խաղաքարով՝ բաց հարձակման միջոցով։ Հնարավոր չէ վերցնել երկու գրոհող խաղաքարերը և հնարավոր չէ ծածկվել դրանցից, հետևաբար արքան կարող է միայն հեռանալ շախից։';

  @override
  String get puzzleThemeEndgame => 'Վերջնախաղ';

  @override
  String get puzzleThemeEndgameDescription => 'Մարտավարություն խաղի վերջնամասում։';

  @override
  String get puzzleThemeEnPassantDescription =>
      'Մարտավարություն «կողանցիկ հարված» կանոնի կիրառմամբ, որտեղ զինվորը կարող է հարվածել մրցակցի զինվորը, որը առաջին քայլն է կատարել՝ տեղաշարժվելով երկու դաշտ, ընդ որում՝ հատվող դաշտը գտնվում է մրցակցի զինվորի հարվածի տակ, որը կարող է վերցնել այդ զինվորը։';

  @override
  String get puzzleThemeExposedKing => 'Մերկ արքա';

  @override
  String get puzzleThemeExposedKingDescription =>
      'Անպաշտպան կամ թույլ պաշտպանված արքան հաճախ դառնում է մատային գրոհի զոհը։';

  @override
  String get puzzleThemeFork => 'Պատառաքաղ';

  @override
  String get puzzleThemeForkDescription =>
      'Քայլ, որի դեպքում հարվածի տակ է հայտնվում մրցակցի երկու խաղաքար։';

  @override
  String get puzzleThemeHangingPiece => 'Անպաշտպան խաղաքար';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'Մարտավարություն, որի ժամանակ մրցակցի խաղաքարը պաշտպանված չէ կամ լավ պաշտպանված չէ և կարող է վերցվել։';

  @override
  String get puzzleThemeHookMate => 'Հուք մատ';

  @override
  String get puzzleThemeHookMateDescription =>
      'Մատ զինվորով պաշտպանված ձիով և նավակով, ընդ որում` մրցակցի զինվորներից մեկը զբաղեցնում է նրա արքայի նահանջի միակ դաշտը։';

  @override
  String get puzzleThemeInterference => 'Ծածկում';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Քայլ, որով ծածկվում է մրցակցի հեռահար խաղաքարերի համագործակցության գիծը, որի արդյունքում այդ խաղաքարերը կամ նրանցից մեկը դառնում են անպաշտպան։ Օրինակ, ձին կանգնում է նավակների միջև գտնվող պաշտպանված վանդակին։';

  @override
  String get puzzleThemeIntermezzo => 'Միջանկյալ քայլ';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'Սպասելի քայլ կատարելու փոխարեն, սկզբում կատարվում է այլ, անմիջական սպառնալիք ստեղծող քայլ, որին մրցակիցը պետք է պատասխանի։ Հայտնի է նաև  «Zwischenzug» կամ «Intermezzo» անուններով։';

  @override
  String get puzzleThemeKillBoxMate => '«Մահացու տուփ» մատ';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'Նավակը տեղադրվում է մրցակցի արքայի կողքին՝ թագուհու պաշտպանության տակ, որը միաժամանակ կանխում է արքայի փախուստը։ Նավակը և թագուհին մրցակցի արքան վերցնում են 3x3 «մահացու տուփի» մեջ։';

  @override
  String get puzzleThemeVukovicMate => 'Վուկովիչի մատ';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'Նավակը և ձին համատեղ մատ են անում արքային։ Մեկ խաղաքարով պաշտպանված նավակը մատ է անում, իսկ ձին կտրում է մրցակցի արքայի նահանջի դաշտերը։';

  @override
  String get puzzleThemeKnightEndgame => 'Ձիու վերջնախաղ';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Միայն ձիերով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeLong => 'Եռաքայլ խնդիր';

  @override
  String get puzzleThemeLongDescription => 'Երեք քայլ մինչև հաղթանակ։';

  @override
  String get puzzleThemeMaster => 'Վարպետների պարտիաներ';

  @override
  String get puzzleThemeMasterDescription =>
      'Խնդիրներ տիտղոսակիր խաղացողների մասնակցությամբ պարտիաներից։';

  @override
  String get puzzleThemeMasterVsMaster => 'Երկու վարպետների պարտիաներ';

  @override
  String get puzzleThemeMasterVsMasterDescription =>
      'Խնդիրներ երկու տիտղոսակիր խաղացողների մասնակցությամբ պարտիաներից։';

  @override
  String get puzzleThemeMate => 'Մատ';

  @override
  String get puzzleThemeMateDescription => 'Ավարտեք խաղը գեղեցիկ';

  @override
  String get puzzleThemeMateIn1 => 'Մատ 1 քայլից';

  @override
  String get puzzleThemeMateIn1Description => 'Արեք մատ մեկ քայլից։';

  @override
  String get puzzleThemeMateIn2 => 'Մատ 2 քայլից';

  @override
  String get puzzleThemeMateIn2Description => 'Արեք մատ երկու քայլից։';

  @override
  String get puzzleThemeMateIn3 => 'Մատ 3 քայլից';

  @override
  String get puzzleThemeMateIn3Description => 'Արեք մատ երեք քայլից։';

  @override
  String get puzzleThemeMateIn4 => 'Մատ 4 քայլից';

  @override
  String get puzzleThemeMateIn4Description => 'Արեք մատ չորս քայլից։';

  @override
  String get puzzleThemeMateIn5 => 'Մատ 5 և ավելի քայլից';

  @override
  String get puzzleThemeMateIn5Description => 'Գտեք դեպի մատը տանող քայլերի հաջորդականությունը։';

  @override
  String get puzzleThemeMiddlegame => 'Միջնախաղ';

  @override
  String get puzzleThemeMiddlegameDescription => 'Մարտավարություն խաղի երկրորդ փուլում։';

  @override
  String get puzzleThemeOneMove => 'Մեկքայլանի խնդիր';

  @override
  String get puzzleThemeOneMoveDescription => 'Խնդիր, որտեղ պետք է անել միայն մեկ հաղթող քայլ։';

  @override
  String get puzzleThemeOpening => 'Սկզբնախաղ';

  @override
  String get puzzleThemeOpeningDescription => 'Մարտավարություն խաղի առաջին փուլում։';

  @override
  String get puzzleThemePawnEndgame => 'Զինվորային վերջնախաղ';

  @override
  String get puzzleThemePawnEndgameDescription => 'Վերջնախաղ զինվորներով։';

  @override
  String get puzzleThemePin => 'Կապ';

  @override
  String get puzzleThemePinDescription =>
      'Կապի օգտագործումով մարտավարություն, երբ խաղաքարը չի կարող քայլել, այլապես գրոհի տակ կհայտնվի նրա հետևում գտնվող ավելի արժեքավոր խաղաքարը։';

  @override
  String get puzzleThemePromotion => 'Վերածում';

  @override
  String get puzzleThemePromotionDescription =>
      'Քայլ, որի ժամանակ զինվորը հասնում է վերջին հորիզոնականին և վերածվում նույն գույնի ցանկացած խաղաքարի, բացի արքայից։';

  @override
  String get puzzleThemeQueenEndgame => 'Թագուհու վերջնախաղ';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Միայն թագուհիներով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeQueenRookEndgame => 'Թագուհով և նավակով վերջնախաղ';

  @override
  String get puzzleThemeQueenRookEndgameDescription =>
      'Միայն թագուհիներով, նավակներով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeQueensideAttack => 'Գրոհ թագուհու թևում';

  @override
  String get puzzleThemeQueensideAttackDescription =>
      'Գրոհ մրցակցի՝ երկար կողմում փոխատեղում կատարած արքայի վրա։';

  @override
  String get puzzleThemeQuietMove => 'Հանգիստ քայլ';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'Քայլ առանց շախի կամ խաղաքար վերցնելու, որն այնուամենայնիվ նախապատրաստում է անխուսափելի սպառնալիք։';

  @override
  String get puzzleThemeRookEndgame => 'Նավակային վերջնախաղ';

  @override
  String get puzzleThemeRookEndgameDescription => 'Միայն նավակներով և զինվորներով վերջնախաղ։';

  @override
  String get puzzleThemeSacrifice => 'Զոհաբերություն';

  @override
  String get puzzleThemeSacrificeDescription =>
      'Մարտավարություն, որի ժամանակ տրվում է որևէ խաղաքար` առավելություն ստանալու, մատ հայտարարելու կամ պարտիան ոչ-ոքի ավարտելու նպատակով։';

  @override
  String get puzzleThemeShort => 'Երկքայլանի խնդիր';

  @override
  String get puzzleThemeShortDescription => 'Երկու քայլ մինչև հաղթանակ։';

  @override
  String get puzzleThemeSkewer => 'Գծային հարձակում';

  @override
  String get puzzleThemeSkewerDescription =>
      'Կապի տեսակ է, բայց այս դեպքում հակառակն է՝ ավելի թանկ խաղաքարը հայտնվում է պակաս արժեքավոր կամ համարժեք խաղաքարի գրոհի գծում։';

  @override
  String get puzzleThemeSmotheredMate => 'Խեղդուկ մատ';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'Մատ ձիով արքային, որը չի կարող փախչել, որովհետև շրջափակված է (խեղդված է) սեփական խաղաքարերով։';

  @override
  String get puzzleThemeSuperGM => 'Սուպերգրոսմայստերների պարտիաներ';

  @override
  String get puzzleThemeSuperGMDescription =>
      'Խնդիրներ աշխարհի լավագույն շախմատիստների պարտիաներից։';

  @override
  String get puzzleThemeTrappedPiece => 'Խաղաքարի որսում';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'Խաղաքարը չի կարող հեռանալ հարձակումից, քանի որ չունի նահանջի ազատ դաշտեր, կամ այդ դաշտերը ևս հարվածի տակ են։';

  @override
  String get puzzleThemeUnderPromotion => 'Թույլ վերածում';

  @override
  String get puzzleThemeUnderPromotionDescription =>
      'Զինվորի վերածում ոչ թե թագուհու, այլ ձիու, փղի կամ նավակի։';

  @override
  String get puzzleThemeVeryLong => 'Բազմաքայլ խնդիր';

  @override
  String get puzzleThemeVeryLongDescription => 'Չորս կամ ավելի քայլ հաղթելու համար։';

  @override
  String get puzzleThemeXRayAttack => 'Ռենտգեն';

  @override
  String get puzzleThemeXRayAttackDescription =>
      'Իրավիճակ, երբ հեռահար խաղաքարի հարձակման կամ պաշտպանության գծին կանգնած է մրցակցի խաղաքարը։';

  @override
  String get puzzleThemeZugzwang => 'Ցուգցվանգ';

  @override
  String get puzzleThemeZugzwangDescription =>
      'Մրցակիցը ստիպված է անել հնարավոր փոքրաթիվ քայլերից մեկը,  բայց քայլերից ցանկացածը տանում է դիրքի վատացման։';

  @override
  String get puzzleThemeMix => 'Խառը խնդիրներ';

  @override
  String get puzzleThemeMixDescription =>
      'Ամեն ինչից` քիչ-քիչ։ Դուք չգիտեք` ինչ է սպասվում, այնպես որ, պատրաստ եղեք ամեն ինչի։ Ինչպես իսկական պարտիայում։';

  @override
  String get puzzleThemePlayerGames => 'Խաղացողի պարտիաները';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Գտնել խնդիրներ, որոնք ստեղծվել են Ձեր պարտիաներից, կամ այլ խաղացողների պարտիաներից։';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Այս խնդիրները հանրության սեփականությունն են, և Դուք կարող եք ներբեռնել դրանք՝ $param։';
  }

  @override
  String get searchSearch => 'Փնտրել';

  @override
  String get settingsSettings => 'Settings';

  @override
  String get settingsCloseAccount => 'Close account';

  @override
  String get settingsManagedAccountCannotBeClosed =>
      'Your account is managed, and cannot be closed.';

  @override
  String get settingsCantOpenSimilarAccount =>
      'The username will NOT be available for registration again.';

  @override
  String get settingsCancelKeepAccount => 'Cancel and keep my account';

  @override
  String get settingsCloseAccountAreYouSure => 'Are you sure you want to close your account?';

  @override
  String get settingsThisAccountIsClosed => 'This account is closed.';

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
  String get stormMoveToStart => 'Սկսելու համար քայլ կատարեք';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles =>
      'Դուք խաղում եք սպիտակ խաղաքարերով բոլոր խնդիրներում';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles =>
      'Դուք խաղում եք սև խաղաքարերով բոլոր խնդիրներում';

  @override
  String get stormPuzzlesSolved => 'խնդիրներ լուծվել են';

  @override
  String get stormNewDailyHighscore => 'Օրվա նո՛ր ռեկորդ';

  @override
  String get stormNewWeeklyHighscore => 'Շաբաթվա նոր ռեկորդ';

  @override
  String get stormNewMonthlyHighscore => 'Ամսվա նոր ռեկորդ';

  @override
  String get stormNewAllTimeHighscore => 'Բոլոր ժամանակների նոր ռեկորդ';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Նախորդ ռեկորդը եղել է $param';
  }

  @override
  String get stormPlayAgain => 'Խաղալ նորից';

  @override
  String stormHighscoreX(String param) {
    return 'Ռեկորդ՝ $param';
  }

  @override
  String get stormScore => 'Արդյունք';

  @override
  String get stormMoves => 'Քայլ';

  @override
  String get stormAccuracy => 'Ճշգրտություն';

  @override
  String get stormCombo => 'Քոմբո';

  @override
  String get stormTime => 'Ժամանակ';

  @override
  String get stormTimePerMove => 'Ժամանակ քայլին';

  @override
  String get stormHighestSolved => 'Շատ բարդ խնդիր';

  @override
  String get stormPuzzlesPlayed => 'Խաղացված խնդիրներ';

  @override
  String get stormNewRun => 'Նոր փորձ («Բացատ» ստեղն)';

  @override
  String get stormEndRun => 'Ավարտել փորձը («Մուտք» ստեղն)';

  @override
  String get stormHighscores => 'Ռեկորդներ';

  @override
  String get stormViewBestRuns => 'Դիտել լավագույն փորձերը';

  @override
  String get stormBestRunOfDay => 'Օրվա լավագույն փորձը';

  @override
  String get stormRuns => 'Շարքեր';

  @override
  String get stormGetReady => 'Պատրաստվե՜ք';

  @override
  String get stormWaitingForMorePlayers => 'Սպասում ենք այլ խաղացողների...';

  @override
  String get stormRaceComplete => 'Մրցավազքն ավարտված է';

  @override
  String get stormSpectating => 'Դիտում';

  @override
  String get stormJoinTheRace => 'Միանալ մրցավազքին';

  @override
  String get stormStartTheRace => 'Սկսել մրցավազքը';

  @override
  String stormYourRankX(String param) {
    return 'Ձեր տեղը՝ $param';
  }

  @override
  String get stormWaitForRematch => 'Սպասում ենք ռևանշի';

  @override
  String get stormNextRace => 'Հաջորդ մրցավազքը';

  @override
  String get stormJoinRematch => 'Միանալ ռևանշին';

  @override
  String get stormWaitingToStart => 'Սպասում ենք մեկնարկին';

  @override
  String get stormCreateNewGame => 'Ստեղծել նոր խաղ';

  @override
  String get stormJoinPublicRace => 'Մասնակցել ընդհանուր մրցավազքին';

  @override
  String get stormRaceYourFriends => 'Մրցել ընկերների հետ';

  @override
  String get stormSkip => 'բաց թողնել';

  @override
  String get stormSkipHelp => 'Մրցավազքի ընթացքում Դուք կարող եք բաց թողնել մեկ քայլ.';

  @override
  String get stormSkipExplanation =>
      'Բաց թողնել այս քայլը՝ շարքը պահպանելու համար։ Մրցավազքի ընթացքում կարելի է օգտագործել միայն մեկ անգամ։';

  @override
  String get stormFailedPuzzles => 'Չլուծված խնդիրներ';

  @override
  String get stormSlowPuzzles => 'Երկար լուծելի խնդիրներ';

  @override
  String get stormSkippedPuzzle => 'Բաց թողնված խնդիր';

  @override
  String get stormThisWeek => 'Այս շաբաթ';

  @override
  String get stormThisMonth => 'Այս ամիս';

  @override
  String get stormAllTime => 'Ամբողջ ընթացքում';

  @override
  String get stormClickToReload => 'Հպեք՝ վերագործարկելու համար';

  @override
  String get stormThisRunHasExpired => 'Այս շարքի ժամանակը սպառվե՛լ է:';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Այս շարքը բացվել է մեկ ա՛յլ ներդիրում:';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count փորձ',
      one: '1 փորձ',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Խաղացվել է $count շարք $param2-ում',
      one: 'Խաղացվել է մեկ շարք $param2-ում',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streamers';

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
  String get timeagoJustNow => 'just now';

  @override
  String get timeagoRightNow => 'right now';

  @override
  String get timeagoCompleted => 'completed';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count seconds',
      one: 'in $count second',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count minutes',
      one: 'in $count minute',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count hours',
      one: 'in $count hour',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count days',
      one: 'in $count day',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count weeks',
      one: 'in $count week',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count months',
      one: 'in $count month',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count years',
      one: 'in $count year',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '$count minute ago',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '$count hour ago',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '$count day ago',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks ago',
      one: '$count week ago',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '$count month ago',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '$count year ago',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes remaining',
      one: '$count minute remaining',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours remaining',
      one: '$count hour remaining',
    );
    return '$_temp0';
  }
}
