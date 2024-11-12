import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Breton (`br`).
class AppLocalizationsBr extends AppLocalizations {
  AppLocalizationsBr([String locale = 'br']) : super(locale);

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
  String get mobilePuzzleStormNothingToShow => 'Nothing to show. Play some runs of Puzzle Storm.';

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
  String get mobileShowResult => 'Show result';

  @override
  String get mobilePuzzleThemesSubtitle => 'Play puzzles from your favorite openings, or choose a theme.';

  @override
  String get mobilePuzzleStormSubtitle => 'Solve as many puzzles as possible in 3 minutes.';

  @override
  String mobileGreeting(String param) {
    return 'Hello, $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Hello';

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Magnify dragged piece';

  @override
  String get activityActivity => 'Obererezhioù diwezhañ';

  @override
  String get activityHostedALiveStream => 'Kinniget he/en deus ur stream war-eeun';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Renket #$param1 e $param2';
  }

  @override
  String get activitySignedUp => 'Lakaet en deus e anv war lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skoazellet he/en deus lichess.org e-pad $count miz evel $param2',
      many: 'Skoazellet he/en deus lichess.org e-pad $count miz evel $param2',
      few: 'Skoazellet he/en deus lichess.org e-pad $count miz evel $param2',
      two: 'Skoazellet he/en deus lichess.org e-pad $count viz evel $param2',
      one: 'Skoazellet he/en deus lichess.org e-pad $count miz evel $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pleustret he/en deus war $count lec\'hiadur e $param2',
      many: 'Pleustret he/en deus war $count lec\'hiadur e $param2',
      few: 'Pleustret he/en deus war $count lec\'hiadur e $param2',
      two: 'Pleustret he/en deus war $count lec\'hiadur e $param2',
      one: 'Pleustret he/en deus war $count lec\'hiadur e $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dirouestlet he/en deus $count poelladenn strategiezh',
      many: 'Dirouestlet he/en deus $count poelladenn strategiezh',
      few: 'Dirouestlet he/en deus $count poelladenn strategiezh',
      two: 'Dirouestlet he/en deus $count boelladenn strategiezh',
      one: 'Dirouestlet he/en deus $count boelladenn strategiezh',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count krogad $param2 c\'hoariet',
      many: '$count krogad $param2 c\'hoariet',
      few: '$count krogad $param2 c\'hoariet',
      two: '$count grogad $param2 c\'hoariet',
      one: '$count c\'hrogad $param2 c\'hoariet',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kemennadenn e $param2 zo bet skrivet ganti/gantañ',
      many: '$count kemennadenn e $param2 zo bet skrivet ganti/gantañ',
      few: '$count kemennadenn e $param2 zo bet skrivet ganti/gantañ',
      two: '$count gemennadenn e $param2 zo bet skrivet ganti/gantañ',
      one: '$count gemennadenn e $param2 zo bet skrivet ganti/gantañ',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'C\'hoariet he/en deus $count fiñvadenn',
      many: 'C\'hoariet he/en deus $count fiñvadenn',
      few: 'C\'hoariet he/en deus $count fiñvadenn',
      two: 'C\'hoariet he/en deus $count fiñvadenn',
      one: 'C\'hoariet he/en deus $count fiñvadenn',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'e $count krogad a-bell',
      many: 'e $count krogad a-bell',
      few: 'e $count krogad a-bell',
      two: 'e $count grogad a-bell',
      one: 'en $count c\'hrogad a-bell',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count krogad a-bell echuet',
      many: '$count krogad a-bell echuet',
      few: '$count krogad a-bell echuet',
      two: '$count grogad a-bell echuet',
      one: '$count c\'hrogad a-bell echuet',
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
      other: 'Krog eo da heuliañ $count c\'hoarier',
      many: 'Krog eo da heuliañ $count c\'hoarier',
      few: 'Krog eo da heuliañ $count c\'hoarier',
      two: 'Krog eo da heuliañ $count c\'hoarier',
      one: 'Krog eo da heuliañ $count c\'hoarier',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heulier nevez',
      many: '$count heulier nevez',
      few: '$count heulier nevez',
      two: '$count heulier nevez',
      one: '$count heulier nevez',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Roet bod da $count abadenn gempred',
      many: 'Roet bod da $count abadenn gempred',
      few: 'Roet bod da $count abadenn gempred',
      two: 'Roet bod da $count abadenn gempred',
      one: 'Roet bod d\' $count abadenn gempred',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kemeret perzh e $count abadenn gempred',
      many: 'Kemeret perzh e $count abadenn gempred',
      few: 'Kemeret perzh e $count abadenn gempred',
      two: 'Kemeret perzh e $count abadenn gempred',
      one: 'Kemeret perzh en $count abadenn gempred',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Krouet $count studiadenn gantañ',
      many: 'Krouet $count studiadenn gantañ',
      few: 'Krouet $count studiadenn gantañ',
      two: 'Krouet $count studiadenn gantañ',
      one: 'Krouet $count studiadenn gantañ',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kemeret he/en deus perzh e $count tournamant',
      many: 'Kemeret he/en deus perzh e $count tournamant',
      few: 'Kemeret he/en deus perzh e $count tournamant',
      two: 'Kemeret he/en deus perzh e $count dournamant',
      one: 'Kemeret he/en deus perzh en $count tournamant',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Renket #$count (to$param2%) gant $param3 krogad e $param4',
      many: 'Renket #$count (to$param2%) gant $param3 krogad e $param4',
      few: 'Renket #$count (to$param2%) gant $param3 krogad e $param4',
      two: 'Renket #$count (to$param2%) gant $param3 grogad e $param4',
      one: 'Renket #$count (to$param2%) gant $param3 c\'hrogad e $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kemeret he/en deus perzh e $count tournamant suis',
      many: 'Kemeret he/en deus perzh e $count tournamant suis',
      few: 'Kemeret he/en deus perzh e $count tournamant suis',
      two: 'Kemeret he/en deus perzh e $count tournamant suis',
      one: 'Kemeret he/en deus perzh e $count tournamant suis',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ezel eus $count skipailh',
      many: 'Ezel eus $count skipailh',
      few: 'Ezel eus $count skipailh',
      two: 'Ezel eus $count skipailh',
      one: 'Ezel eus $count skipailh',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'War-eeun';

  @override
  String get broadcastMyBroadcasts => 'My broadcasts';

  @override
  String get broadcastLiveBroadcasts => 'Tournamantoù skignet war-eeun';

  @override
  String get broadcastBroadcastCalendar => 'Broadcast calendar';

  @override
  String get broadcastNewBroadcast => 'Skignañ war-eeun nevez';

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
  String get broadcastOngoing => 'O ren';

  @override
  String get broadcastUpcoming => 'A-benn nebeut';

  @override
  String get broadcastCompleted => 'Tremenet';

  @override
  String get broadcastCompletedHelp => 'Lichess detects round completion, but can get it wrong. Use this to set it manually.';

  @override
  String get broadcastRoundName => 'Round name';

  @override
  String get broadcastRoundNumber => 'Niverenn ar batalm';

  @override
  String get broadcastTournamentName => 'Tournament name';

  @override
  String get broadcastTournamentDescription => 'Short tournament description';

  @override
  String get broadcastFullDescription => 'Deskrivadur an abadenn a-bezh';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Deskrivadur hir ar skignañ war-eeun ma fell deoc\'h.$param1 zo dijabl. Ne vo ket hiroc\'h evit $param2 sin.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Source URL';

  @override
  String get broadcastSourceUrlHelp => 'An URL a ray Lichess ganti evit kaout hizivadurioù ar PGN. Ret eo dezhi bezañ digor d\'an holl war Internet.';

  @override
  String get broadcastSourceGameIds => 'Up to 64 Lichess game IDs, separated by spaces.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Start date in the tournament local timezone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Diret eo, ma ouzit pegoulz e krogo';

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
  String get broadcastDeleteTournament => 'Dilemel an tournamant-mañ';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Dilemel an tournamant da viken, an holl grogadoù ha pep tra penn-da-benn.';

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
  String get broadcastUpcomingBroadcasts => 'Upcoming broadcasts';

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
    return 'Daeoù: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Daeañ ar c\'hoarier-mañ';

  @override
  String get challengeChallengeDeclined => 'Dae nac’het';

  @override
  String get challengeChallengeAccepted => 'Dae asantet!';

  @override
  String get challengeChallengeCanceled => 'Dae nullet.';

  @override
  String get challengeRegisterToSendChallenges => 'Kevreit evit daeañ an implijer-mañ mar plij.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Ne c\'hallit ket daeañ $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param n\'he/en deus ket c\'hant da vezañ daeet.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Re vras an diforc\'h etre ho renkadur $param1 hag hini $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Ne c\'hallit ket daeañ abalamour d\'ar renkadur $param da c\'hortoz.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return 'Ne vez ket degemeret daeoù nemet digant mignoned gant $param.';
  }

  @override
  String get challengeDeclineGeneric => 'Ne zegemeran ket daeoù er mare-mañ.';

  @override
  String get challengeDeclineLater => 'N\'on ket dijabl evit poent, kasit ur goulenn din en-dro diwezhatoc\'h mar plij ganeoc\'h.';

  @override
  String get challengeDeclineTooFast => 'This time control is too fast for me, please challenge again with a slower game.';

  @override
  String get challengeDeclineTooSlow => 'This time control is too slow for me, please challenge again with a faster game.';

  @override
  String get challengeDeclineTimeControl => 'I\'m not accepting challenges with this time control.';

  @override
  String get challengeDeclineRated => 'Kasit din un dae renket kentoc\'h, mar plij ganeoc\'h.';

  @override
  String get challengeDeclineCasual => 'Kasit un dae ordin din kentoc\'h mar plij ganeoc\'h.';

  @override
  String get challengeDeclineStandard => 'I\'m not accepting variant challenges right now.';

  @override
  String get challengeDeclineVariant => 'Ne fell ket din c\'hoari an doare echedoù-mañ evit poent.';

  @override
  String get challengeDeclineNoBot => 'Ne zegemeran ket daeoù kaset gant robotoù.';

  @override
  String get challengeDeclineOnlyBot => 'Daeoù kaset gant robotoù a zegemeran nemetken.';

  @override
  String get challengeInviteLichessUser => 'Pediñ ur c\'hoarier war Lichess mod-all:';

  @override
  String get contactContact => 'Darempred';

  @override
  String get contactContactLichess => 'Mont e darempred gant Lichess';

  @override
  String get coordinatesCoordinates => 'Daveennoù';

  @override
  String get coordinatesCoordinateTraining => 'Pleustriñ war an daveennoù';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return 'Disoc\'h keitat eus tu ar re wenn: $param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return 'Disoc\'h keitat eus tu ar re zu: $param';
  }

  @override
  String get coordinatesKnowingTheChessBoard => 'Anavezout daveennoù an dachenn emgann zo ur varregezh a-bouez bras:';

  @override
  String get coordinatesMostChessCourses => 'Darn vrasañ eus ar c\'hentelioù ha poelladennoù a ra gant an notadur aljebrek.';

  @override
  String get coordinatesTalkToYourChessFriends => 'Aesoc\'h e vo deoc\'h kaozeal gant ho mignoned peogwir e veoc\'h gouest da gomz \"yezh an echedoù\" asambles gante.';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively => 'Efedusoc\'h eo an dielfennañ pa ouzer diouzhtu pelec\'h emaomp war an dachenn emgann.';

  @override
  String get coordinatesACoordinateAppears => 'Un daveenn a zifoup war an dablez hag e rankit klikañ war ar garezenn.';

  @override
  String get coordinatesASquareIsHighlightedExplanation => 'Lakaet \'vez liv war ur garrezenn war an dablez hag e rankit skrivañ he daveennoù (sk \"e4).';

  @override
  String get coordinatesYouHaveThirtySeconds => 'You have 30 seconds to correctly map as many squares as possible!';

  @override
  String get coordinatesGoAsLongAsYouWant => 'Go as long as you want, there is no time limit!';

  @override
  String get coordinatesShowCoordinates => 'Show coordinates';

  @override
  String get coordinatesShowCoordsOnAllSquares => 'Coordinates on every square';

  @override
  String get coordinatesShowPieces => 'Show pieces';

  @override
  String get coordinatesStartTraining => 'Kregiñ ganti';

  @override
  String get coordinatesFindSquare => 'Find square';

  @override
  String get coordinatesNameSquare => 'Name square';

  @override
  String get patronDonate => 'Ober un donezon';

  @override
  String get patronLichessPatron => 'Lichess Patron';

  @override
  String perfStatPerfStats(String param) {
    return 'Stadegoù $param';
  }

  @override
  String get perfStatViewTheGames => 'Gwelet ar c\'hrogadoù';

  @override
  String get perfStatProvisional => 'da c\'hortoz';

  @override
  String get perfStatNotEnoughRatedGames => 'N\'eo ket bet c\'hoariet trawalc\'h a grogadoù renket evit kaout ur renkadur a glot gant ho live.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Araokadennoù e-pad an/ar $param krogad diwezhañ:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Forc\'had standard: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Lower value means the rating is more stable. Above $param1, the rating is considered provisional. To be included in the rankings, this value should be below $param2 (standard chess) or $param3 (variants).';
  }

  @override
  String get perfStatTotalGames => 'Niver a grogadoù';

  @override
  String get perfStatRatedGames => 'Krogadoù renket';

  @override
  String get perfStatTournamentGames => 'Krogadoù tournamant';

  @override
  String get perfStatBerserkedGames => 'Krogadoù berserket';

  @override
  String get perfStatTimeSpentPlaying => 'Amzer o c\'hoari';

  @override
  String get perfStatAverageOpponent => 'Live keitat an enebour';

  @override
  String get perfStatVictories => 'Trec\'hioù';

  @override
  String get perfStatDefeats => 'Lammoù';

  @override
  String get perfStatDisconnections => 'Digevreadennoù';

  @override
  String get perfStatNotEnoughGames => 'N\'ho peus ket c\'hoariet a-walc\'h c\'hoazh';

  @override
  String perfStatHighestRating(String param) {
    return 'Renkadur uhelañ: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Renkadur izelañ: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'etre $param1 ha $param2';
  }

  @override
  String get perfStatWinningStreak => 'Krogadoù gounezet da-heul';

  @override
  String get perfStatLosingStreak => 'Krogadoù kollet da-heul';

  @override
  String perfStatLongestStreak(String param) {
    return 'Brasañ niver da heul: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Niver a grogadoù da heul evit poent: $param';
  }

  @override
  String get perfStatBestRated => 'Gwellañ trec\'hioù renket';

  @override
  String get perfStatGamesInARow => 'Krogadoù c\'hoariet hep troc\'h';

  @override
  String get perfStatLessThanOneHour => 'Nebeutoc\'h evit un eur etre daou grogad';

  @override
  String get perfStatMaxTimePlaying => 'Ar muiañ a amzer o c\'hoari dizehan';

  @override
  String get perfStatNow => 'bremañ';

  @override
  String get preferencesPreferences => 'Dibaboù';

  @override
  String get preferencesDisplay => 'Display';

  @override
  String get preferencesPrivacy => 'Buhez prevez';

  @override
  String get preferencesNotifications => 'Kemennoù';

  @override
  String get preferencesPieceAnimation => 'Mod da fiñval ar pezhioù';

  @override
  String get preferencesMaterialDifference => 'Diforc\'hioù a-fet dafar';

  @override
  String get preferencesBoardHighlights => 'Gouleier evit sikour war an dablez (fiñvadenn ziwezhañ ha bec\'h d\'ar roue)';

  @override
  String get preferencesPieceDestinations => 'Karrezennoù degemer (fiñvadennoù ha rak-fiñvadennoù gwiriek)';

  @override
  String get preferencesBoardCoordinates => 'Daveennoù an dablez (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Roll ar fiñvadennoù e-pad ar c\'hrogad';

  @override
  String get preferencesPgnPieceNotation => 'Notenniñ ar fiñvadennoù';

  @override
  String get preferencesChessPieceSymbol => 'Arouez ar pezh echedoù';

  @override
  String get preferencesPgnLetter => 'Lizherenn (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Mod zen';

  @override
  String get preferencesShowPlayerRatings => 'Diskouez renkadur ar c\'hoarier';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'This hides all ratings from Lichess, to help focus on the chess. Rated games still impact your rating, this is only about what you get to see.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Diskouez an arouez evit cheñch ment an dablez';

  @override
  String get preferencesOnlyOnInitialPosition => 'Lec\'hiadur kentañ nemetken';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesChessClock => 'Horolaj echedoù';

  @override
  String get preferencesTenthsOfSeconds => 'Dekvedennoù an eilennoù';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Pa chom nebeutoc\'h evit < 10 eilenn';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Barrennoù dibunañ gwer a-blaen';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Trouz pa ne chom ket kalz amzer';

  @override
  String get preferencesGiveMoreTime => 'Reiñ muioc\'h a amzer';

  @override
  String get preferencesGameBehavior => 'Mont en-dro ar c\'hrogad';

  @override
  String get preferencesHowDoYouMovePieces => 'Penaos e lakaer ar pezhioù da fiñval?';

  @override
  String get preferencesClickTwoSquares => 'Klikañ war div garrezenn';

  @override
  String get preferencesDragPiece => 'Lakaat ar pezh da riklañ';

  @override
  String get preferencesBothClicksAndDrag => 'An daou';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Rak-fiñvadennoù (c\'hoari e-pad tro hoc\'h enebour)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Nullañ ar fiñvadenn ziwezhañ (gant asant an enebour)';

  @override
  String get preferencesInCasualGamesOnly => 'E krogadoù a vignoniezh hepken';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Treiñ da rouanez en un doare emgefreek';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hold the <ctrl> key while promoting to temporarily disable auto-promotion';

  @override
  String get preferencesWhenPremoving => 'E-pad ar rak-fiñvadenn';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Arc\'hañ bezañ rampo goude fiñvadennoù heñvel-poch en un doare emgefreek';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Pa chom nebeutoc\'h evit < 30 eilenn';

  @override
  String get preferencesMoveConfirmation => 'Kadarnaat ar fiñvadenn';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Krogadoù a-bell';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'A-bell ha diharz';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Kadarnaat ar c\'hodianañ hag ar goulenn bezañ rampo';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Doareoù da rokañ';

  @override
  String get preferencesCastleByMovingTwoSquares => 'O tiplasañ ar roue deus div garrezenn';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Diblasañ ar roue war an tour evit rokañ';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Aozañ an touchennaoueg evit c\'hoari gantañ';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Snap arrows to valid moves';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Say \"Good game, well played\" upon defeat or draw';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Savetaet eo bet ho tibaboù.';

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
  String get preferencesNotifyTournamentSoon => 'Un tournamant a vo a-benn nebeut';

  @override
  String get preferencesNotifyTimeAlarm => 'Correspondence clock running out';

  @override
  String get preferencesNotifyBell => 'Bell notification within Lichess';

  @override
  String get preferencesNotifyPush => 'Device notification when you\'re not on Lichess';

  @override
  String get preferencesNotifyWeb => 'Merdeer';

  @override
  String get preferencesNotifyDevice => 'Device';

  @override
  String get preferencesBellNotificationSound => 'Klevet ar c\'hloc\'h';

  @override
  String get puzzlePuzzles => 'Poelladennoù';

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
  String get puzzleGoals => 'Palioù';

  @override
  String get puzzleOrigin => 'Mammenn';

  @override
  String get puzzleSpecialMoves => 'Special moves';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ha plijet oc\'h bet gant ar boelladenn-mañ?';

  @override
  String get puzzleVoteToLoadNextOne => 'Votit evit kaout unan all!';

  @override
  String get puzzleUpVote => 'Up vote puzzle';

  @override
  String get puzzleDownVote => 'Down vote puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Your puzzle rating will not change. Note that puzzles are not a competition. Your rating helps selecting the best puzzles for your current skill.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Find the best move for white.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Find the best move for black.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'To get personalized puzzles:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Poelladenn $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Poelladenn an deiz';

  @override
  String get puzzleDailyPuzzle => 'Poelladenn pemdeziek';

  @override
  String get puzzleClickToSolve => 'Klikit da ziskoulmañ';

  @override
  String get puzzleGoodMove => 'Good move';

  @override
  String get puzzleBestMove => 'Best move!';

  @override
  String get puzzleKeepGoing => 'Kendalc\'hit…';

  @override
  String get puzzlePuzzleSuccess => 'Deuet eo ganeoc\'h!';

  @override
  String get puzzlePuzzleComplete => 'Puzzle complete!';

  @override
  String get puzzleByOpenings => 'Dre zigoradurioù';

  @override
  String get puzzlePuzzlesByOpenings => 'Poelladennoù dre zigoradurioù';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Digoradurioù ho peus c\'hoariet alies e krogadoù renket';

  @override
  String get puzzleUseFindInPage => 'Use \"Find in page\" in the browser menu to find your favourite opening!';

  @override
  String get puzzleUseCtrlF => 'Grit gant Ctrl+f evit kavout ho tigoradurioù muiañ-karet!';

  @override
  String get puzzleNotTheMove => 'That\'s not the move!';

  @override
  String get puzzleTrySomethingElse => 'Klaskit un doare all.';

  @override
  String puzzleRatingX(String param) {
    return 'Renkadur: $param';
  }

  @override
  String get puzzleHidden => 'kuzhet';

  @override
  String puzzleFromGameLink(String param) {
    return 'C\'hoariet gant $param';
  }

  @override
  String get puzzleContinueTraining => 'Kenderc\'hel gant ar pleustriñ';

  @override
  String get puzzleDifficultyLevel => 'Difficulty level';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Aesoc\'h';

  @override
  String get puzzleEasiest => 'Aesañ';

  @override
  String get puzzleHarder => 'Startoc\'h';

  @override
  String get puzzleHardest => 'Startañ';

  @override
  String get puzzleExample => 'Skouer';

  @override
  String get puzzleAddAnotherTheme => 'Add another theme';

  @override
  String get puzzleNextPuzzle => 'Poelladenn nesañ';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Cheñch poelladenn diouzhtu';

  @override
  String get puzzlePuzzleDashboard => 'Puzzle Dashboard';

  @override
  String get puzzleImprovementAreas => 'Ar pezh a zo da wellaat';

  @override
  String get puzzleStrengths => 'Strengths';

  @override
  String get puzzleHistory => 'Puzzle history';

  @override
  String get puzzleSolved => 'solved';

  @override
  String get puzzleFailed => 'n\'eo ket mat';

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
  String get puzzleFromMyGames => 'Diwar ma c\'hrogadoù';

  @override
  String get puzzleLookupOfPlayer => 'Lookup puzzles from a player\'s games';

  @override
  String puzzleFromXGames(String param) {
    return 'Puzzles from $param\' games';
  }

  @override
  String get puzzleSearchPuzzles => 'Search puzzles';

  @override
  String get puzzleFromMyGamesNone => 'N\'eus poelladenn ebet tennet diwar ho krogadoù met gant Lichess oc\'h karet memestra.\nKontant e vefec\'h e vefe savet ur boelladenn diwar unan eus ho partiennoù? C\'hoariit krogadoù prim pe glasel evit kaout muioc\'h a chañs!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 puzzles found in $param2 games';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Pleustriñ, dielfennañ, mont war-raok';

  @override
  String puzzlePercentSolved(String param) {
    return '$param solved';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nothing to show, go play some puzzles first!';

  @override
  String get puzzleImprovementAreasDescription => 'Pleustrit war ar re-mañ evit mont war-raok!';

  @override
  String get puzzleStrengthDescription => 'You perform the best in these themes';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'C\'hoariet $count gwech',
      many: 'C\'hoariet $count gwech',
      few: 'C\'hoariet $count gwech',
      two: 'C\'hoariet $count wech',
      one: 'C\'hoariet $count wech',
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
  String get puzzleThemeAdvancedPawn => 'Advanced pawn';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'One of your pawns is deep into the opponent position, maybe threatening to promote.';

  @override
  String get puzzleThemeAdvantage => 'Advantage';

  @override
  String get puzzleThemeAdvantageDescription => 'Seize your chance to get a decisive advantage. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Lamm d\'ar roue mod Ananastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'A knight and rook or queen team up to trap the opposing king between the side of the board and a friendly piece.';

  @override
  String get puzzleThemeArabianMate => 'Lamm d\'ar roue mod Arabia';

  @override
  String get puzzleThemeArabianMateDescription => 'A knight and a rook team up to trap the opposing king on a corner of the board.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Tagañ f2 pe f7';

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
  String get puzzleThemeBodenMate => 'Lamm d\'ar roue mod Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Two attacking bishops on criss-crossing diagonals deliver mate to a king obstructed by friendly pieces.';

  @override
  String get puzzleThemeCastling => 'Rokañ';

  @override
  String get puzzleThemeCastlingDescription => 'Gwarezit ho roue ha kasit ho tour d\'an emgann.';

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
  String get puzzleThemeDovetailMate => 'Lamm d\'ar roue mod Dovetail';

  @override
  String get puzzleThemeDovetailMateDescription => 'A queen delivers mate to an adjacent king, whose only two escape squares are obstructed by friendly pieces.';

  @override
  String get puzzleThemeEquality => 'Equality';

  @override
  String get puzzleThemeEqualityDescription => 'Come back from a losing position, and secure a draw or a balanced position. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Tagañ tu ar roue';

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
  String get puzzleThemeDoubleCheck => 'Bec\'h d\'ar roue doubl';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Checking with two pieces at once, as a result of a discovered attack where both the moving piece and the unveiled piece attack the opponent\'s king.';

  @override
  String get puzzleThemeEndgame => 'Fin ar c\'hrogad';

  @override
  String get puzzleThemeEndgameDescription => 'A tactic during the last phase of the game.';

  @override
  String get puzzleThemeEnPassantDescription => 'A tactic involving the en passant rule, where a pawn can capture an opponent pawn that has bypassed it using its initial two-square move.';

  @override
  String get puzzleThemeExposedKing => 'Exposed king';

  @override
  String get puzzleThemeExposedKingDescription => 'A tactic involving a king with few defenders around it, often leading to checkmate.';

  @override
  String get puzzleThemeFork => 'Forc\'h';

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
  String get puzzleThemeLong => 'Poelladenn hir';

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
  String get puzzleThemeMate => 'Lamm d\'ar roue';

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
  String get puzzleThemeMiddlegame => 'Kreiz ar c\'hrogad';

  @override
  String get puzzleThemeMiddlegameDescription => 'A tactic during the second phase of the game.';

  @override
  String get puzzleThemeOneMove => 'One-move puzzle';

  @override
  String get puzzleThemeOneMoveDescription => 'A puzzle that is only one move long.';

  @override
  String get puzzleThemeOpening => 'Digoradur';

  @override
  String get puzzleThemeOpeningDescription => 'A tactic during the first phase of the game.';

  @override
  String get puzzleThemePawnEndgame => 'Pawn endgame';

  @override
  String get puzzleThemePawnEndgameDescription => 'An endgame with only pawns.';

  @override
  String get puzzleThemePin => 'Tachañ';

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
  String get puzzleThemeSacrifice => 'Aberzh';

  @override
  String get puzzleThemeSacrificeDescription => 'A tactic involving giving up material in the short-term, to gain an advantage again after a forced sequence of moves.';

  @override
  String get puzzleThemeShort => 'Poelladenn verr';

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
  String get puzzleThemeVeryLong => 'Poelladenn hir-tre';

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
  String get puzzleThemeMix => 'A bep seurt';

  @override
  String get puzzleThemeMixDescription => 'A bep seurt. N\'ouzit ket petra gortoz hag e mod-se e voc\'h prest evit pep tra! Heñvel ouzh ar c\'hrogadoù gwir.';

  @override
  String get puzzleThemePlayerGames => 'Player games';

  @override
  String get puzzleThemePlayerGamesDescription => 'Lookup puzzles generated from your games, or from another player\'s games.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'These puzzles are in the public domain, and can be downloaded from $param.';
  }

  @override
  String get searchSearch => 'Klask';

  @override
  String get settingsSettings => 'Arventennoù';

  @override
  String get settingsCloseAccount => 'Serriñ ar gont';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Meret eo ho kont ha ne c\'hall ket bezañ serret.';

  @override
  String get settingsClosingIsDefinitive => 'Serret e vo ho kont da viken. Ne c\'halloc\'h ket cheñch ho soñj. Sur oc\'h?';

  @override
  String get settingsCantOpenSimilarAccount => 'Ne voc\'h ket aotreet da grouiñ ur gont nevez gant ar memes anv, pa vije gant ur ment lizherennoù disheñvel.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Cheñchet em eus ma soñj, na serrit ket ma c\'hont';

  @override
  String get settingsCloseAccountExplanation => 'Serret e vo ho kont, sur oc\'h? Un diviz-pad an hini eo. NE c\'halloc\'h KET adkavout anezhi ken, BIKEN.';

  @override
  String get settingsThisAccountIsClosed => 'Serr eo ar gont-mañ.';

  @override
  String get playWithAFriend => 'C\'hoari a-enep ur mignon';

  @override
  String get playWithTheMachine => 'C\'hoari a-enep an urzhiataer';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Evit pediñ unan bennak da c\'hoari, kasit dezhañ/dezhi an URL -mañ';

  @override
  String get gameOver => 'Krogad echu';

  @override
  String get waitingForOpponent => 'O c\'hortoz an enebour';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Gortozit';

  @override
  String get yourTurn => 'Deoc\'h-c\'hwi';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 live $param2';
  }

  @override
  String get level => 'Live';

  @override
  String get strength => 'Live';

  @override
  String get toggleTheChat => 'Enaouiñ/lazhañ ar flapañ';

  @override
  String get chat => 'Kaozeadenn';

  @override
  String get resign => 'Dilezel';

  @override
  String get checkmate => 'Lamm d\'ar roue';

  @override
  String get stalemate => 'Gwalllamm';

  @override
  String get white => 'Ar re wenn';

  @override
  String get black => 'Ar re zu';

  @override
  String get asWhite => 'gant ar re wenn';

  @override
  String get asBlack => 'gant ar re zu';

  @override
  String get randomColor => 'Liv dre zegouezh';

  @override
  String get createAGame => 'Kregiñ gant ur c\'hrogad';

  @override
  String get whiteIsVictorious => 'Trec\'h eo ar re wenn';

  @override
  String get blackIsVictorious => 'Trec\'h eo ar re zu';

  @override
  String get youPlayTheWhitePieces => 'C\'hoari a rit gant ar re wenn';

  @override
  String get youPlayTheBlackPieces => 'C\'hoari a rit gant ar re zu';

  @override
  String get itsYourTurn => 'Deoc\'h c\'hwi!';

  @override
  String get cheatDetected => 'Trucherez diskoachet';

  @override
  String get kingInTheCenter => 'Roue e kreiz';

  @override
  String get threeChecks => 'Tri bec\'h';

  @override
  String get raceFinished => 'Echu ar redadeg';

  @override
  String get variantEnding => 'Fin ar variant';

  @override
  String get newOpponent => 'Enebour nevez';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Hoc\'h enebour en deus c\'hoant da c\'hoari a-enep deoc\'h adarre';

  @override
  String get joinTheGame => 'Kregiñ ganti';

  @override
  String get whitePlays => 'Tro ar re wenn';

  @override
  String get blackPlays => 'Tro ar re zu';

  @override
  String get opponentLeftChoices => 'Aet eo kuit hoc\'h enebour marteze. Gallout a rit arc\'hañ an trec\'h, dibab bezañ rampo pe gortoz.';

  @override
  String get forceResignation => 'Arc\'hañ an trec\'h';

  @override
  String get forceDraw => 'Diskleriañ ar rampo';

  @override
  String get talkInChat => 'Bezit hegarat pa flapit!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'An den kentañ a zeuy war an URL -mañ a c\'hoario a-enep deoc\'h.';

  @override
  String get whiteResigned => 'Ar re wenn o deus dilezet';

  @override
  String get blackResigned => 'Ar re zu o deus dilezet';

  @override
  String get whiteLeftTheGame => 'Ar re wenn o deus kuitaet ar c\'hrogad';

  @override
  String get blackLeftTheGame => 'Ar re zu o deus kuitaet ar c\'hrogad';

  @override
  String get whiteDidntMove => 'Ar re wenn n’o deus ket fiñvet';

  @override
  String get blackDidntMove => 'Ar re zu n’o deus ket fiñvet';

  @override
  String get requestAComputerAnalysis => 'Goulenn un dielfennañ digant an urzhiataer';

  @override
  String get computerAnalysis => 'Dielfennadenn an urzhiataer';

  @override
  String get computerAnalysisAvailable => 'Gallout a rit dielfennañ gant an urzhiataer';

  @override
  String get computerAnalysisDisabled => 'Dielfennadennoù an urzhiataer lazhet';

  @override
  String get analysis => 'Tablez dielfennañ';

  @override
  String depthX(String param) {
    return 'Donder $param';
  }

  @override
  String get usingServerAnalysis => 'O tielfennañ emañ an urzhiataer';

  @override
  String get loadingEngine => 'O kargañ ar c\'heflusker...';

  @override
  String get calculatingMoves => 'O jediñ fiñvadennoù...';

  @override
  String get engineFailed => 'Ur gudenn zo bet';

  @override
  String get cloudAnalysis => 'Dielfennañ er goumoulenn';

  @override
  String get goDeeper => 'Mont pelloc\'h';

  @override
  String get showThreat => 'Diskouez ar gourdrouz';

  @override
  String get inLocalBrowser => 'er merdeer lec\'hel';

  @override
  String get toggleLocalEvaluation => 'Enaouiñ/lazhañ an dielfennañ lec\'hel';

  @override
  String get promoteVariation => 'Lakaat ar variant da bennlinenn';

  @override
  String get makeMainLine => 'Lakaat da bennlinenn';

  @override
  String get deleteFromHere => 'Dilemel adalek amañ';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Troiñ en ur variant';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get move => 'Fiñvadenn';

  @override
  String get variantLoss => 'Variant a lak koll';

  @override
  String get variantWin => 'Variant a lak trec\'h';

  @override
  String get insufficientMaterial => 'N\'eus ket trawalc\'h a bezhioù';

  @override
  String get pawnMove => 'Fiñvadenn ar pezh gwerin';

  @override
  String get capture => 'Tapadenn';

  @override
  String get close => 'Serriñ';

  @override
  String get winning => 'A lakay trec\'hiñ';

  @override
  String get losing => 'A lakay koll';

  @override
  String get drawn => 'Rampo';

  @override
  String get unknown => 'Dianav';

  @override
  String get database => 'Dataeg';

  @override
  String get whiteDrawBlack => 'Gwenn / Rampo / Du';

  @override
  String averageRatingX(String param) {
    return 'Renkadur keitat: $param';
  }

  @override
  String get recentGames => 'Krogadoù diwezhañ';

  @override
  String get topGames => 'Partiennoù kreñvañ';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Daou vilion c\'hoari $param1 + FIDE gant c\'hoarerien etre $param2 ha $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' with rounding, based on number of half-moves until next capture or pawn move';

  @override
  String get noGameFound => 'Krogad ebet kavet';

  @override
  String get maxDepthReached => 'Max depth reached!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Degemer muioc\'h a grogadoù o tont eus lañser an dibaboù?';

  @override
  String get openings => 'Digoradurioù';

  @override
  String get openingExplorer => 'Furcher an digoradurioù';

  @override
  String get openingEndgameExplorer => 'Ergerzher digoradur/dibenn-partienn';

  @override
  String xOpeningExplorer(String param) {
    return 'furcher an digoradurioù $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => 'Trec\'h harzet gant reolenn an 50 taol';

  @override
  String get lossSavedBy50MoveRule => 'Trec\'hidigezh harzet gant reolennoù an 50 taol';

  @override
  String get winOr50MovesByPriorMistake => 'Win or 50 moves by prior mistake';

  @override
  String get lossOr50MovesByPriorMistake => 'Loss or 50 moves by prior mistake';

  @override
  String get unknownDueToRounding => 'Win/loss only guaranteed if recommended tablebase line has been followed since the last capture or pawn move, due to possible rounding of DTZ values in Syzygy tablebases.';

  @override
  String get allSet => 'Prest eo!';

  @override
  String get importPgn => 'Enporzhiañ PGN';

  @override
  String get delete => 'Dilemel';

  @override
  String get deleteThisImportedGame => 'Dilemel ar c\'hrogad enporzhiet-mañ?';

  @override
  String get replayMode => 'Mod adwelet';

  @override
  String get realtimeReplay => 'Amzer wirion';

  @override
  String get byCPL => 'Dre CPL';

  @override
  String get enable => 'Enaouiñ';

  @override
  String get bestMoveArrow => 'Bir ar gwellañ fiñvadenn';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Jaoj priziañ';

  @override
  String get multipleLines => 'Meur a linenn';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Memor';

  @override
  String get infiniteAnalysis => 'Dielfennañ didermen';

  @override
  String get removesTheDepthLimit => 'Removes the depth limit, and keeps your computer warm';

  @override
  String get blunder => 'Bourd';

  @override
  String get mistake => 'Fazi';

  @override
  String get inaccuracy => 'Diresisted';

  @override
  String get moveTimes => 'Amzer dre fiñvadenn';

  @override
  String get flipBoard => 'Cheñch tu an dablez c\'hoari';

  @override
  String get threefoldRepetition => 'Teir gwech ar memestra';

  @override
  String get claimADraw => 'Goulenn bezañ rampo';

  @override
  String get offerDraw => 'Kinnig bezañ rampo';

  @override
  String get draw => 'Rampo';

  @override
  String get drawByMutualAgreement => 'Rampo dre asant pep hini';

  @override
  String get fiftyMovesWithoutProgress => 'Hanter-kant taol hep araokadenn';

  @override
  String get currentGames => 'Krogadoù o ren';

  @override
  String get viewInFullSize => 'Brasaat';

  @override
  String get logOut => 'Digevreañ';

  @override
  String get signIn => 'Kevreañ';

  @override
  String get rememberMe => 'Chom a rin kevreet';

  @override
  String get youNeedAnAccountToDoThat => 'Ezhomm ho peus da gaout ur gont evit hen ober';

  @override
  String get signUp => 'Lakaat e anv';

  @override
  String get computersAreNotAllowedToPlay => 'Urzhiataerioù ha c\'hoarierien sikouret gant un urzhiataer n\'int ket aotreet da c\'hoari. Na vezit ket skoazellet gant mekanikoù, diaz roadennoù pe c\'hoarierien all pa vezit o c\'hoari. Ne aliomp ket ac\'hanoc\'h da gaout kalz kontoù kennebeut. M\'ho peus re a gontoù e veoc\'h forbannet.';

  @override
  String get games => 'Krogadoù';

  @override
  String get forum => 'Forom';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 he/en deus embannet er forom $param2';
  }

  @override
  String get latestForumPosts => 'Embannoù diwezhañ er forom';

  @override
  String get players => 'C\'hoarierien';

  @override
  String get friends => 'Mignoned';

  @override
  String get otherPlayers => 'other players';

  @override
  String get discussions => 'Kaozeadennoù';

  @override
  String get today => 'Hiziv';

  @override
  String get yesterday => 'Dec\'h';

  @override
  String get minutesPerSide => 'Munutennoù evit pep c\'hoarier';

  @override
  String get variant => 'Doare';

  @override
  String get variants => 'Eilstummoù';

  @override
  String get timeControl => 'Tizh';

  @override
  String get realTime => 'Amzer wirion';

  @override
  String get correspondence => 'Krogadoù war hir dermen';

  @override
  String get daysPerTurn => 'Deizioù dre fiñvadenn';

  @override
  String get oneDay => 'Un deiz';

  @override
  String get time => 'Amzer';

  @override
  String get rating => 'Renkad';

  @override
  String get ratingStats => 'Stadegoù ar renkadur';

  @override
  String get username => 'Anv implijer';

  @override
  String get usernameOrEmail => 'Anv implijer pe chomlec\'h postel';

  @override
  String get changeUsername => 'Cheñch anv implijer';

  @override
  String get changeUsernameNotSame => 'Ment al lizherennoù a c\'hall cheñch hepken. Lakaomp \"yannc\'hoarier\" a ya da \"YannC\'hoarier\".';

  @override
  String get changeUsernameDescription => 'Cheñchit hoc\'h anv implijer. Gallout a rit hen ober ur wech hepken ha ne c\'hallit kemm nemet ment al lizherennoù.';

  @override
  String get signupUsernameHint => 'Make sure to choose a family-friendly username. You cannot change it later and any accounts with inappropriate usernames will get closed!';

  @override
  String get signupEmailHint => 'Arveret e vo gant m\'ho peus ezhomm da cheñch ho ker-kuzh.';

  @override
  String get password => 'Ger-kuzh';

  @override
  String get changePassword => 'Kemm ar ger-tremen';

  @override
  String get changeEmail => 'Kemm ar postel';

  @override
  String get email => 'Postel';

  @override
  String get passwordReset => 'Adderaouekaat ar ger-tremen';

  @override
  String get forgotPassword => 'Disoñjet hoc\'h eus ho ker-tremen?';

  @override
  String get error_weakPassword => 'Ordin eo ho ker-kuzh betek re hag aes-tre da gavout.';

  @override
  String get error_namePassword => 'Disheñvel e vo ho ker-kuzh diouzh hoc\'h anv-implijer mar plij ganeoc\'h.';

  @override
  String get blankedPassword => 'Ar memes ger-kuzh ho peus graet gantañ war ul lec\'hienn all hag a zo bet preizhet. Ur ger-kuzh nevez zo ezhomm da gaout neuze evit ma chomfe diarvar ho kont Lichess. Ho trugarekaat a reomp.';

  @override
  String get youAreLeavingLichess => 'O kuitaat Lichess emaoc\'h';

  @override
  String get neverTypeYourPassword => 'Arabat bizskrivañ ho ker-kuzh Lichess war ul lec\'hienn all!';

  @override
  String proceedToX(String param) {
    return 'Kuitaat war-zu $param';
  }

  @override
  String get passwordSuggestion => 'Na choazit ket ur ger-kuzh bet silet e pleg ho skouarn gant unan all. Arveriet e vo evit laerezh ho kont diganeoc\'h.';

  @override
  String get emailSuggestion => 'Na choazit ket ur chomlec\'h postel bet aliet deoc\'h gant unan all. Arveriet e vo evit laerezh ho kont diganeoc\'h.';

  @override
  String get emailConfirmHelp => 'Un tamm sikour evit ar postel kadarnaat';

  @override
  String get emailConfirmNotReceived => 'Didn\'t receive your confirmation email after signing up?';

  @override
  String get whatSignupUsername => 'Petra oa hoc\'h anv-implijer da vare hoc\'h enskrivadur?';

  @override
  String usernameNotFound(String param) {
    return 'N\'omp ket deuet a-benn da gavout ur c\'hoarier anvet: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Gallout a rit ober gant an anv implijer-mañ evit krouiñ ur gont nevez';

  @override
  String emailSent(String param) {
    return 'Kaset hon eus ur postel da $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Marteze ne vo ket resevet diouzhtu-dak.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Gortozit pemp munutenn ha freskait ho pajenn goude-se.';

  @override
  String get checkSpamFolder => 'Taolit ur sell en ho strobelloù e ken kas. Ma c\'hoarvez seul taol ganeoc\'h e vo dav resisaat n\'eo ket ur strobell.';

  @override
  String get emailForSignupHelp => 'Kasit deomp ar postel-mañ ma n\'oc\'h ket deuet a-benn:';

  @override
  String copyTextToEmail(String param) {
    return 'Eilit ha pegit an destennig ha kasit anezhi da $param';
  }

  @override
  String get waitForSignupHelp => 'We will come back to you shortly to help you complete your signup.';

  @override
  String accountConfirmed(String param) {
    return 'Kadarnaet eo bet krouidigezh ar c\'hoarier $param.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Gallout a rit kevreañ dindan an anv $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'N\'ho peus ket ezhomm deus ur postel-kadarnaat.';

  @override
  String accountClosed(String param) {
    return 'Serr eo ar gont $param.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Ar gont $param zo bet krouet hep chomlec\'h postel.';
  }

  @override
  String get rank => 'Renk';

  @override
  String rankX(String param) {
    return 'Renk: $param';
  }

  @override
  String get gamesPlayed => 'Krogadoù c\'hoariet';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Nullañ';

  @override
  String get whiteTimeOut => 'Amzer ebet ken evit ar re wenn';

  @override
  String get blackTimeOut => 'Amzer ebet ken evit ar re zu';

  @override
  String get drawOfferSent => 'Kinnig rampo kaset';

  @override
  String get drawOfferAccepted => 'Kinnig rampo asantet';

  @override
  String get drawOfferCanceled => 'Kinnig rampo nullet';

  @override
  String get whiteOffersDraw => 'Ar re wenn a ginnig bezañ rampo';

  @override
  String get blackOffersDraw => 'Ar re zu a ginnig bezañ rampo';

  @override
  String get whiteDeclinesDraw => 'Ar re wenn a nac\'h bezañ rampo';

  @override
  String get blackDeclinesDraw => 'Ar re zu a nac\'h bezañ rampo';

  @override
  String get yourOpponentOffersADraw => 'Hoc\'h enebour a ginnig deoc\'h bezañ rampo';

  @override
  String get accept => 'Asantiñ';

  @override
  String get decline => 'Nac\'hañ';

  @override
  String get playingRightNow => 'O c\'hoari bremañ';

  @override
  String get eventInProgress => 'O c\'hoari bremañ';

  @override
  String get finished => 'Echu';

  @override
  String get abortGame => 'Nullañ ar c\'hrogad';

  @override
  String get gameAborted => 'Krogad nullet';

  @override
  String get standard => 'Normal';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Didermen';

  @override
  String get mode => 'Mod';

  @override
  String get casual => 'Nann-renket';

  @override
  String get rated => 'Renket';

  @override
  String get casualTournament => 'Nann-renket';

  @override
  String get ratedTournament => 'Renket';

  @override
  String get thisGameIsRated => 'Renket eo ar c\'hrogad-mañ';

  @override
  String get rematch => 'C\'hoari en-dro';

  @override
  String get rematchOfferSent => 'Kinnig c\'hoari en-dro kaset';

  @override
  String get rematchOfferAccepted => 'Kinnig c\'hoari en-dro asantet';

  @override
  String get rematchOfferCanceled => 'Kinnig c\'hoari en-dro nullet';

  @override
  String get rematchOfferDeclined => 'Kinnig c\'hoari en-dro nac\'het';

  @override
  String get cancelRematchOffer => 'Nullañ ar c\'hinnig c\'hoari en-dro';

  @override
  String get viewRematch => 'Gwelet an digoll';

  @override
  String get confirmMove => 'Kadarnaat ar fiñvadenn';

  @override
  String get play => 'C\'hoari';

  @override
  String get inbox => 'Boest lizhiri';

  @override
  String get chatRoom => 'Lec\'h evit flapañ';

  @override
  String get loginToChat => 'Kevreañ evit flapañ';

  @override
  String get youHaveBeenTimedOut => 'Astalet oc\'h bet.';

  @override
  String get spectatorRoom => 'Sal an arvesterien';

  @override
  String get composeMessage => 'Bizskrivañ ur gemennadenn';

  @override
  String get subject => 'Danvez';

  @override
  String get send => 'Kas';

  @override
  String get incrementInSeconds => 'Inkremant e eilennoù';

  @override
  String get freeOnlineChess => 'C\'hoari echedoù enlinenn digoust';

  @override
  String get exportGames => 'Ezporzhiañ krogadoù';

  @override
  String get ratingRange => 'Renkadur hoc\'h enebourien';

  @override
  String get thisAccountViolatedTos => 'Perc\'henner ar gont-mañ n\'en deus ket doujet da Reolennoù Lichess';

  @override
  String get openingExplorerAndTablebase => 'Furcher an digoradurioù & tablebase';

  @override
  String get takeback => 'Nullañ ar fiñvadenn ziwezhañ';

  @override
  String get proposeATakeback => 'Kinnig nullañ ar fiñvadenn ziwezhañ';

  @override
  String get takebackPropositionSent => 'Kaset eo bet ar c\'hinnig nullañ ar fiñvadenn ziwezhañ';

  @override
  String get takebackPropositionDeclined => 'Nac\'het eo bet nullañ ar fiñvadenn ziwezhañ';

  @override
  String get takebackPropositionAccepted => 'Asantet eo bet nullañ ar fiñvadenn ziwezhañ';

  @override
  String get takebackPropositionCanceled => 'Ar c\'hinnig nullañ ar fiñvadenn ziwezhañ zo bet nullet';

  @override
  String get yourOpponentProposesATakeback => 'Kinnig a ra oc\'h enebour e vefe nullet ho fiñvadenn ziwezhañ';

  @override
  String get bookmarkThisGame => 'Miret ar c\'hrogad-mañ er roll-istor';

  @override
  String get tournament => 'Tournamant';

  @override
  String get tournaments => 'Tournamantoù';

  @override
  String get tournamentPoints => 'Poentoù tournamant';

  @override
  String get viewTournament => 'Sellet ouzh an tournamant';

  @override
  String get backToTournament => 'Distreiñ d\'an tournamant';

  @override
  String get noDrawBeforeSwissLimit => 'You cannot draw before 30 moves are played in a Swiss tournament.';

  @override
  String get thematic => 'Tematek';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Da c\'hortoz eo ho renkadur $param';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Re uhel eo ho renkadur $param1 ($param2)';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Re uhel eo ho renkadur gwellañ e $param1 ($param2) ar sizhun-mañ';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Re izel eo ho renkadur e $param1 ($param2)';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Renket ≥ $param1 e $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Renket ≤ $param1 e $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'A rank bezañ e skipailh $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'N\'oc\'h ket e skipailh $param';
  }

  @override
  String get backToGame => 'Distreiñ d\'ar c\'hrogad';

  @override
  String get siteDescription => 'C\'hoari echedoù enlinenn evit netra gant un etrefas simpl. Enskrivadur ebet, bruderezh ebet ha lugant ebet. C\'hoarit a-enep an urzhiataer, a-enep ho mignoned pe a-enep enebourien dianav deus ar bed a-bezh.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 zo deuet da vezañ ezel eus skipailh $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return 'Gant $param1 zo bet krouet ar skipailh $param2';
  }

  @override
  String get startedStreaming => 'zo krog da skignañ ur video dre froud';

  @override
  String xStartedStreaming(String param) {
    return '$param zo krog da skignañ ur video dre froud';
  }

  @override
  String get averageElo => 'Renkadur keitat';

  @override
  String get location => 'Kumun';

  @override
  String get filterGames => 'Silañ ar c\'hrogadoù';

  @override
  String get reset => 'Adkregiñ';

  @override
  String get apply => 'Enrollañ';

  @override
  String get save => 'Saveteiñ';

  @override
  String get leaderboard => 'Taolenn ar re varrekañ';

  @override
  String get screenshotCurrentPosition => 'Kaout al lec\'hiadur a vremañ';

  @override
  String get gameAsGIF => 'Krogad e stumm GIF';

  @override
  String get pasteTheFenStringHere => 'Pegañ an destenn FEN amañ';

  @override
  String get pasteThePgnStringHere => 'Pegañ an destenn PGN amañ';

  @override
  String get orUploadPgnFile => 'Pe pellkargañ ur restr PGN';

  @override
  String get fromPosition => 'Kregiñ gant ul lec\'hiadur ispisial';

  @override
  String get continueFromHere => 'Kenderc\'hel adalek amañ';

  @override
  String get toStudy => 'Studiañ';

  @override
  String get importGame => 'Enporzhiañ ur c\'hrogad';

  @override
  String get importGameExplanation => 'Pegit ur c\'hrogad PGN evit gallout e c\'hoari den-dro, e zielfennañ gant an urzhiataer, ober gant ar flaper ha kaout un URL da skignañ.';

  @override
  String get importGameCaveat => 'Variations will be erased. To keep them, import the PGN via a study.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Ur c\'hCAPTCHA echedoù an hini eo.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klikit war an dachenn emgann d\'ober ho fiñvadenn ha prouit oc\'h un den.';

  @override
  String get captcha_fail => 'Diskoulmit ar c\'hCAPTCHA echedoù mar plij.';

  @override
  String get notACheckmate => 'N\'eus ket lamm d\'ar roue';

  @override
  String get whiteCheckmatesInOneMove => 'Ar re wenn a ray lamm d\'ar roue gant ur fiñvadenn';

  @override
  String get blackCheckmatesInOneMove => 'Ar re zu a ray lamm d\'ar roue gant ur fiñvadenn';

  @override
  String get retry => 'Klask en-dro';

  @override
  String get reconnecting => 'Oc\'h adkennaskañ';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Enebourien muiañ-karet';

  @override
  String get follow => 'Heuliañ';

  @override
  String get following => 'O heuliañ';

  @override
  String get unfollow => 'Paouez da heuliañ';

  @override
  String followX(String param) {
    return 'Heuliañ $param';
  }

  @override
  String unfollowX(String param) {
    return 'Paouez da heuliañ $param';
  }

  @override
  String get block => 'Stankañ';

  @override
  String get blocked => 'Stanket';

  @override
  String get unblock => 'Distankañ';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 zo krog da heuliañ $param2';
  }

  @override
  String get more => 'Muioc\'h';

  @override
  String get memberSince => 'Ezel abaoe an/ar';

  @override
  String lastSeenActive(String param) {
    return 'Oberiant $param';
  }

  @override
  String get player => 'C\'hoarier';

  @override
  String get list => 'Roll';

  @override
  String get graph => 'Krommenn';

  @override
  String get required => 'Rekis.';

  @override
  String get openTournaments => 'Tournamantoù digor';

  @override
  String get duration => 'Padelezh';

  @override
  String get winner => 'Trec\'hour';

  @override
  String get standing => 'Renkadur';

  @override
  String get createANewTournament => 'Krouiñ un tournamant nevez';

  @override
  String get tournamentCalendar => 'Deiziadur an tournamantoù';

  @override
  String get conditionOfEntry => 'Rekizoù evit kemer perzh:';

  @override
  String get advancedSettings => 'Arventennoù kempleshoc\'h';

  @override
  String get safeTournamentName => 'Choazit un anv dereat-tre evit an tournamant.';

  @override
  String get inappropriateNameWarning => 'Un draig ha ne vefe ket dereat a vefe trawalc\'h evit ma serrfemp ho kont.';

  @override
  String get emptyTournamentName => 'Laoskit goullo evit envel an tournamant diouzh anv ur c\'hoarier echedoù brudet.';

  @override
  String get makePrivateTournament => 'Gallout a rit krouiñ un tournamant prevez oc\'h ouzhpennañ ur ger-tremen';

  @override
  String get join => 'Kemer perzh';

  @override
  String get withdraw => 'Dilezel';

  @override
  String get points => 'Poentoù';

  @override
  String get wins => 'Trec\'hioù';

  @override
  String get losses => 'Lammoù';

  @override
  String get createdBy => 'Krouet gant';

  @override
  String get tournamentIsStarting => 'Emañ an tournamant o kregiñ';

  @override
  String get tournamentPairingsAreNowClosed => 'Echu eo koubladegoù an tournamant.';

  @override
  String standByX(String param) {
    return 'Gortozit $param, o koublañ ar c\'hoarierien, bezit prest!';
  }

  @override
  String get pause => 'Ehan';

  @override
  String get resume => 'Adkregiñ';

  @override
  String get youArePlaying => 'O c\'hoari emaoc\'h!';

  @override
  String get winRate => 'Feur trec\'hiñ';

  @override
  String get berserkRate => 'Feur berserk';

  @override
  String get performance => 'Performañs';

  @override
  String get tournamentComplete => 'Echu eo an tournamant';

  @override
  String get movesPlayed => 'Niver a fiñvadennoù';

  @override
  String get whiteWins => 'Feur trec\'hiñ ar re zu';

  @override
  String get blackWins => 'Feur trec\'hiñ ar re zu';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Krogadoù rampo';

  @override
  String nextXTournament(String param) {
    return 'Tournamant $param war-lerc\'h:';
  }

  @override
  String get averageOpponent => 'Keidenn live an enebour';

  @override
  String get boardEditor => 'Krouer plegennoù';

  @override
  String get setTheBoard => 'Kargit ul lec\'hiadur';

  @override
  String get popularOpenings => 'Digoradurioù brudet';

  @override
  String get endgamePositions => 'Plegennoù an dibenn-partienn';

  @override
  String chess960StartPosition(String param) {
    return 'Lec’hiadur e deroù ar c’hrogad Chess960: $param';
  }

  @override
  String get startPosition => 'Plegenn orin';

  @override
  String get clearBoard => 'Tennañ pep tra';

  @override
  String get loadPosition => 'Kargañ ul lec\'hiadur';

  @override
  String get isPrivate => 'Prevez';

  @override
  String reportXToModerators(String param) {
    return 'Diskleriañ $param d\'an habaskaerien';
  }

  @override
  String profileCompletion(String param) {
    return 'Feur leuniañ ar profil: $param';
  }

  @override
  String xRating(String param) {
    return 'Renkadur $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Ma n\'eus ket, laoskit goullo';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Aozañ ar profil';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Diwar ho penn';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Trugarez!';

  @override
  String get socialMediaLinks => 'Liammoù ar mediaoù sokial';

  @override
  String get oneUrlPerLine => 'Un URL dre linenn.';

  @override
  String get inlineNotation => 'Notennoù en-linenn';

  @override
  String get makeAStudy => 'For safekeeping and sharing, consider making a study.';

  @override
  String get clearSavedMoves => 'Clear moves';

  @override
  String get previouslyOnLichessTV => 'N\'eus ket pell zo war Lichess TV';

  @override
  String get onlinePlayers => 'C\'hoarierien enlinenn';

  @override
  String get activePlayers => 'C\'hoarierien oberiat';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Diwallit, renket eo ar c\'hrogad met n\'eus horolaj ebet!';

  @override
  String get success => 'Deuet oc\'h a-benn';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Cheñch krogad en un doare emgefreek goude ur fiñvadenn';

  @override
  String get autoSwitch => 'Cheñch tu emgefreek';

  @override
  String get puzzles => 'Poelladennoù';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Anv';

  @override
  String get description => 'Deskrivadur';

  @override
  String get descPrivate => 'Deskrivadur prevez';

  @override
  String get descPrivateHelp => 'Testenn a vo gwelet gant izili ar skipailh nemetken. Mard eo roet, lakaet e lec’h an deskrivadur foran evit izili ar skipailh.';

  @override
  String get no => 'Nann';

  @override
  String get yes => 'Ya';

  @override
  String get website => 'Website';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Sikour:';

  @override
  String get createANewTopic => 'Krouiñ ur sujed nevez';

  @override
  String get topics => 'Temoù';

  @override
  String get posts => 'Kemennadennoù';

  @override
  String get lastPost => 'Kemennadenn ziwezhañ';

  @override
  String get views => 'Gwelet';

  @override
  String get replies => 'Respontoù';

  @override
  String get replyToThisTopic => 'Respont d\'ar sujed-mañ';

  @override
  String get reply => 'Respont';

  @override
  String get message => 'Kemennadenn';

  @override
  String get createTheTopic => 'Krouiñ ur sujed';

  @override
  String get reportAUser => 'Diskleriañ un implijer d\'an habaskaerien';

  @override
  String get user => 'Implijer';

  @override
  String get reason => 'Abeg';

  @override
  String get whatIsIheMatter => 'Peseurt kudenn zo?';

  @override
  String get cheat => 'Trucherezh';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'All';

  @override
  String get reportCheatBoostHelp => 'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp => 'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish => 'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink => 'Roit d\'an nebeutañ ul liamm hag a gas d\'ur c\'hrogad trucherezh ennañ.';

  @override
  String by(String param) {
    return 'gant $param';
  }

  @override
  String importedByX(String param) {
    return 'Enportzhiet gant $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Serr eo ar sujed-mañ bremañ.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notennoù';

  @override
  String get typePrivateNotesHere => 'Bizskrivañ notennoù prevez amañ';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Skrivañ un notenn brevez diwar-benn ar c\'hoarier-mañ';

  @override
  String get noNoteYet => 'Notenn ebet evit poent';

  @override
  String get invalidUsernameOrPassword => 'N\'eo ket mat an anv-implijer pe ar ger-tremen-mañ';

  @override
  String get incorrectPassword => 'N\'eo ket mat ar ger-kuzh';

  @override
  String get invalidAuthenticationCode => 'Kod dilesadur fall';

  @override
  String get emailMeALink => 'Kasit din ul liamm dre bostel';

  @override
  String get currentPassword => 'Ger-tremen evit poent';

  @override
  String get newPassword => 'Ger-tremen nevez';

  @override
  String get newPasswordAgain => 'Ger-tremen nevez (c\'hoazh)';

  @override
  String get newPasswordsDontMatch => 'Ne glot ket an daou cher-tremen';

  @override
  String get newPasswordStrength => 'Surentez ar ger-tremen';

  @override
  String get clockInitialTime => 'An amzer ho po e penn kentañ';

  @override
  String get clockIncrement => 'Inkrement an horolaj';

  @override
  String get privacy => 'Buhez prevez';

  @override
  String get privacyPolicy => 'Reolennoù prevezded';

  @override
  String get letOtherPlayersFollowYou => 'Aotreañ ar c\'hoarierien all d\'ho heuliañ';

  @override
  String get letOtherPlayersChallengeYou => 'Aotreañ ar c\'hoarierien all d\'ho taeañ';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Aotreañ ar c\'hoarerien all d\'ho pediñ da studiañ';

  @override
  String get sound => 'Son';

  @override
  String get none => 'Hini ebet';

  @override
  String get fast => 'Buan';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Goustadik';

  @override
  String get insideTheBoard => 'E-barzh an dablez';

  @override
  String get outsideTheBoard => 'Er-maez eus an dablez';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'E-pad ar c\'hrogadoù difonn';

  @override
  String get always => 'Bepred';

  @override
  String get never => 'Morse';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 a gemer perzh e-barzh $param2';
  }

  @override
  String get victory => 'Trec\'h';

  @override
  String get defeat => 'Lamm';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 a-enep $param2 e $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 a-enep $param2 e $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 a-enep $param2 e $param3';
  }

  @override
  String get timeline => 'Roll istor';

  @override
  String get starting => 'Kregiñ a ray da:';

  @override
  String get allInformationIsPublicAndOptional => 'An holl ditouroù a c\'hall bezañ foran ha da zibab.';

  @override
  String get biographyDescription => 'Kaozeal diwar ho penn, ho tudioù, ar pezh a blij deoc\'h en echedoù, ho toare da gregiñ gant ur c\'hrogad, c\'hoarierien, ...';

  @override
  String get listBlockedPlayers => 'Roll ar c\'hoarierien stanket ganeoc\'h';

  @override
  String get human => 'Mab-den';

  @override
  String get computer => 'Urzhiataer';

  @override
  String get side => 'Kostez';

  @override
  String get clock => 'Horolaj';

  @override
  String get opponent => 'Enebour';

  @override
  String get learnMenu => 'Deskiñ';

  @override
  String get studyMenu => 'Studiañ';

  @override
  String get practice => 'Pleustriñ';

  @override
  String get community => 'Kumuniezh';

  @override
  String get tools => 'Ostilhoù';

  @override
  String get increment => 'Inkrement';

  @override
  String get error_unknown => 'Invalid value';

  @override
  String get error_required => 'Ret eo skrivañ un dra bennak';

  @override
  String get error_email => 'Diwiriek eo ar chomlec\'h postel-mañ';

  @override
  String get error_email_acceptable => 'Ne c\'hall ket bet degemeret ar chomlec\'h postel-mañ. Gwiriit anezhañ mar plij, ha klaskit en-dro.';

  @override
  String get error_email_unique => 'Chomlec\'h postel fazius pe implijet dija';

  @override
  String get error_email_different => 'Ho chomlec\'h postel an hini eo dija';

  @override
  String error_minLength(String param) {
    return '$param arouezenn d\'an nebeutañ';
  }

  @override
  String error_maxLength(String param) {
    return '$param arouezenn d\'ar muiañ-tout';
  }

  @override
  String error_min(String param) {
    return 'A rank bezañ $param da nebeutañ';
  }

  @override
  String error_max(String param) {
    return 'A rank bezañ $param da vuiañ';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Ma \'z eo ar renkadur ± $param';
  }

  @override
  String get ifRegistered => 'Enskrivet hepken';

  @override
  String get onlyExistingConversations => 'Kaozeadennoù o ren hepken';

  @override
  String get onlyFriends => 'Mignoned hepken';

  @override
  String get menu => 'Lañser';

  @override
  String get castling => 'Rokañ';

  @override
  String get whiteCastlingKingside => 'Gwenn O-O';

  @override
  String get blackCastlingKingside => 'Du O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Amzer o c\'hoari: $param';
  }

  @override
  String get watchGames => 'Sellet ouzh krogadoù';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Pegeit oc\'h bet gwelet en tele: $param';
  }

  @override
  String get watch => 'Sellet';

  @override
  String get videoLibrary => 'Levraoueg videoioù';

  @override
  String get streamersMenu => 'Streamerien';

  @override
  String get mobileApp => 'Arload pellgomz';

  @override
  String get webmasters => 'Mistri-gwiad';

  @override
  String get about => 'A-zivout';

  @override
  String aboutX(String param) {
    return 'A-zivout $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return 'Digoust ($param2) eo $param1, dieub, hep bruderezh ha digor he mammenn.';
  }

  @override
  String get really => 'da vat';

  @override
  String get contribute => 'Kenoberiañ';

  @override
  String get termsOfService => 'Divizoù hollek an implij';

  @override
  String get sourceCode => 'Boneg Tarzh';

  @override
  String get simultaneousExhibitions => 'Abadennoù kempred';

  @override
  String get host => 'Ostiz';

  @override
  String hostColorX(String param) {
    return 'Liv an ostiz: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Abadennoù kempred nevez krouet';

  @override
  String get hostANewSimul => 'Krouiñ un abadenn gempred nevez';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'N\'eo ket bet kavet an abadenn gempred';

  @override
  String get noSimulExplanation => 'N\'eus ket deus an abadenn gempred-mañ.';

  @override
  String get returnToSimulHomepage => 'Distreiñ d\'al lañser abadennoù kempred';

  @override
  String get aboutSimul => 'Abadennoù kempred enne ur c\'hoarier oc\'h enebiñ ouzh meur a hini war an dro.';

  @override
  String get aboutSimulImage => 'A-enep 50 enebour eo bet trec\'h Fischer 47 gwech, div wech rampo ha trec\'het ur wech nemetken.';

  @override
  String get aboutSimulRealLife => 'Bezañ ez eus diouzh abadennoù e-giz-se evit gwir. D\'ar c\'hoarier da vont deus un daol d\'eben evit ober ur fiñvadenn bep tro.';

  @override
  String get aboutSimulRules => 'Pa grog an abadenn gempred e krog pep krogad gant an ostiz ivez. Gantañ e vez c\'hoariet ar re wenn. Ur wech echu an holl grogadoù e vo fin an abadenn gempred.';

  @override
  String get aboutSimulSettings => 'Krogadoù a vignoniezh eo an abadennoù kempred bepred. Kinnigoù c\'hoari en-dro, nullañ ar fiñvadenn ziwezhañ pe ouzhpennañ amzer zo diweredekaet.';

  @override
  String get create => 'Krouiñ';

  @override
  String get whenCreateSimul => 'Pa grouit un abadenn gempred ho pez meur a c\'hoarier da enebiñ oute.';

  @override
  String get simulVariantsHint => 'Ma choazit meur a eilstumm en do pep c\'hoarier da zibab pehini c\'hoari.';

  @override
  String get simulClockHint => 'Aozet an horolaj e mod Fischer. Seul vuioc\'h a c\'hoarierien seul vuioc\'h a amzer ho po ezhomm da gaout.';

  @override
  String get simulAddExtraTime => 'Gallout a rit lakaat amzer ouzhpenn d\'ho horolaj, evit ho sikour d\'ober war-dro ar bartienn gempred.';

  @override
  String get simulHostExtraTime => 'Lakaat amzer ouzhpenn d\'ho horolaj';

  @override
  String get simulAddExtraTimePerPlayer => 'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'Tournamantoù Lichess';

  @override
  String get tournamentFAQ => 'FAG aren an tournamant';

  @override
  String get timeBeforeTournamentStarts => 'Ar pezh a chom a-raok ma krogfe an tournamant';

  @override
  String get averageCentipawnLoss => 'Koll keitat e sentipawn';

  @override
  String get accuracy => 'Resisted';

  @override
  String get keyboardShortcuts => 'Berradennoù an douchennaoueg';

  @override
  String get keyMoveBackwardOrForward => 'mont war-raok/kilañ';

  @override
  String get keyGoToStartOrEnd => 'mont d\'an deroù/d\'ar fin';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'diskouez/skoachañ an evezhiadennoù';

  @override
  String get keyEnterOrExitVariation => 'mont ebarzh/kuitaat an eilstumm';

  @override
  String get keyRequestComputerAnalysis => 'Request computer analysis, Learn from your mistakes';

  @override
  String get keyNextLearnFromYourMistakes => 'Da heul (deskit diouzh ho fazioù)';

  @override
  String get keyNextBlunder => 'Blunder nesañ';

  @override
  String get keyNextMistake => 'Fazi nesañ';

  @override
  String get keyNextInaccuracy => 'Diresisted nesañ';

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
  String get newTournament => 'Tournamant nevez';

  @override
  String get tournamentHomeTitle => 'Tournamantoù echedoù o zizh hag o variantoù liesseurt';

  @override
  String get tournamentHomeDescription => 'C\'hoariit tournamantoù echedoù fonnus! Kemerit perzh en un tournamant ofisiel raktreset, pe krouit hoc\'h hini. Bullet, Blitz, Klasel, Echedoù960, Roue d\'ar c\'hreiz, Tribec\'h, ha dibaboù all evit ur blijadur beurbadus gant an echedoù.';

  @override
  String get tournamentNotFound => 'N\'eo ket bet kavet an tournamant';

  @override
  String get tournamentDoesNotExist => 'N\'eus ket diouzh an tournamant-mañ.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Marteze eo bet nullet an tournamant dre ma \'z eo aet kuit an holl c\'hoarerien a-raok ma krogfe.';

  @override
  String get returnToTournamentsHomepage => 'Distreiñ da lañser an tournamantoù';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Dasparzh sizhuniek ar renkadur $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return '$param2 eo ho renkadur e $param1.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Barrekoc\'h oc\'h evit $param1 eus ar c\'hoarierien $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return 'Barrekoc\'h eo $param1 evit $param2 eus ar c\'hoarierien $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Gwelloc\'h evit $param1 eus ar c\'hoarierien $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'N\'ho peus ket ur renkadur e $param c\'hoazh.';
  }

  @override
  String get yourRating => 'Ho renkadur';

  @override
  String get cumulative => 'Berniet';

  @override
  String get glicko2Rating => 'Renkadur Glicko-2';

  @override
  String get checkYourEmail => 'Gwiriañ ar posteloù';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Kaset zo bet ur postel deoc\'h. Klikit war al liamm er postel evit gweredekaat ho kont.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ma ne zeuit ket a-benn gwelet ar postel-mañ, klaskit e lec\'hioù all evel ar boubellenn, ar stroboù pe teuliadoù all c\'hoazh.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Kaset hon eus ur postel da $param. Klikit war al liamm er postel evit cheñch ho ker-tremen.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'En ur lakaat hoc\'h anv e asantit d\'hor $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Goût hiroc\'h diwar-benn hor $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => '\"Lag\" zo etrezoc\'h ha Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Amzer ret evit ober ur fiñvadenn war servijer Lichess';

  @override
  String get downloadAnnotated => 'Pellgargañ gant an notennoù';

  @override
  String get downloadRaw => 'Pellgargañ ar PGN kriz';

  @override
  String get downloadImported => 'Enkargañ enporzhiet';

  @override
  String get crosstable => 'Roll-istor ar c\'hrogadoù';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Gallout a rit ivez treiñ rodell al logodenn evit mont eus an eil taolioù d\'ar re all.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scroll over computer variations to preview them.';

  @override
  String get analysisShapesHowTo => 'Pouezit war shift+klik pe klik-dehou da dresañ kelc\'hioù ha biroù war an tablez.';

  @override
  String get letOtherPlayersMessageYou => 'Aotreañ ar c\'hoarierien da gas kemennadennoù deoc\'h';

  @override
  String get receiveForumNotifications => 'Receive notifications when mentioned in the forum';

  @override
  String get shareYourInsightsData => 'Rannañ roadennoù hoc\'h anien echedoù';

  @override
  String get withNobody => 'Gant den ebet';

  @override
  String get withFriends => 'Gant ma mignoned';

  @override
  String get withEverybody => 'Gant an holl dud';

  @override
  String get kidMode => 'Mod evit ar vugale';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Un afer a surentez an hini eo. Ne c\'haller ket mont e darempred gant ar re all pa c\'hoarier er mod evit ar vugale. Mat eo evit ho pugale pe ho skolidi evit o gwareziñ diouzh ar c\'hoarierien all war internet.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'An ikonenn $param zo pa vezer o c\'hoari gant er mod evit ar vugale ha gant se e ouzit eo gwarezet ho moused.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'Gweredekaat ar mod evit ar vugale';

  @override
  String get disableKidMode => 'Diweredekaat ar mod evit ar vugale';

  @override
  String get security => 'Surentez';

  @override
  String get sessions => 'Sessions';

  @override
  String get revokeAllSessions => 'skarzhañ an holl zalc\'hoù';

  @override
  String get playChessEverywhere => 'C\'hoari echedoù e pep lec\'h';

  @override
  String get asFreeAsLichess => 'Ken digoust ha lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Krouiñ evit an echedoù ha n\'eo ket evit an arc\'hant';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Forzh piv a c\'hall kaout an holl arc\'hweladurioù, digoust eo';

  @override
  String get zeroAdvertisement => 'Tamm bruderezh ebet';

  @override
  String get fullFeatured => 'Lichess ha muioc\'h c\'hoazh';

  @override
  String get phoneAndTablet => 'Pellgomzer ha tabletenn';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, klasel';

  @override
  String get correspondenceChess => 'Echedoù war hir dermen';

  @override
  String get onlineAndOfflinePlay => 'C\'hoari enlinenn pe get';

  @override
  String get viewTheSolution => 'Gwelet ar respont';

  @override
  String get followAndChallengeFriends => 'Heuliañ ha c\'hoari a-enep mignoned';

  @override
  String get gameAnalysis => 'Dielfennañ ar c\'hrogad';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 a ro bod da $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 a gemer perzh e $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return 'Plijet eo $param1 gant $param2';
  }

  @override
  String get quickPairing => 'Koubladeg war ar prim';

  @override
  String get lobby => 'Saloñs';

  @override
  String get anonymous => 'Dianav';

  @override
  String yourScore(String param) {
    return 'Ho tisoc\'h: $param';
  }

  @override
  String get language => 'Yezh';

  @override
  String get background => 'Drekleur';

  @override
  String get light => 'Sklaer';

  @override
  String get dark => 'Teñval';

  @override
  String get transparent => 'Treuzwelus';

  @override
  String get deviceTheme => 'Device theme';

  @override
  String get backgroundImageUrl => 'URL skeudenn an drekleur :';

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
  String get pieceSet => 'Ar pezhioù';

  @override
  String get embedInYourWebsite => 'Enframmañ en ho lec\'hienn';

  @override
  String get usernameAlreadyUsed => 'Implijet eo an anv-mañ dija. Dibabit unan all mar plij.';

  @override
  String get usernamePrefixInvalid => 'Gant ul lizherenn e rank kregiñ an anv implijer.';

  @override
  String get usernameSuffixInvalid => 'Gant ul lizherenn pe ur sifr e echu an anv-implijer, dre ret.';

  @override
  String get usernameCharsInvalid => 'Lizherennoù, sifroù ha tiretennoù a c\'haller kavout er anv-implijer.';

  @override
  String get usernameUnacceptable => 'Ne c\'haller degemer an anv-implijer-mañ.';

  @override
  String get playChessInStyle => 'Ho pezit neuz en ur c\'hoari echedoù';

  @override
  String get chessBasics => 'Diazezoù an echedoù';

  @override
  String get coaches => 'Gourdonerien';

  @override
  String get invalidPgn => 'Ur gudenn zo gant ar PGN';

  @override
  String get invalidFen => 'Ur gudenn zo gant ar FEN';

  @override
  String get custom => 'Personelaet';

  @override
  String get notifications => 'Kemennoù';

  @override
  String notificationsX(String param1) {
    return 'Rebuzadurioù: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Renk: $param';
  }

  @override
  String get practiceWithComputer => 'Pleustriñ gant an urzhiataer';

  @override
  String anotherWasX(String param) {
    return 'Unan all a oa $param';
  }

  @override
  String bestWasX(String param) {
    return 'Gwelloc\'h e oa $param';
  }

  @override
  String get youBrowsedAway => 'Aet oc\'h da bourmen';

  @override
  String get resumePractice => 'Adkregiñ gant ar pleustriñ';

  @override
  String get drawByFiftyMoves => 'Rampo eo ar c\'hrogad da-heul ar reolenn hanter-kant fiñvadenn.';

  @override
  String get theGameIsADraw => 'Rampo oc\'h.';

  @override
  String get computerThinking => 'O prederiañ emañ an urzhiataer ...';

  @override
  String get seeBestMove => 'Gwelet ar gwellañ fiñvadenn';

  @override
  String get hideBestMove => 'Kuzhat ar gwellañ fiñvadenn';

  @override
  String get getAHint => 'Kaout un tamm sikour';

  @override
  String get evaluatingYourMove => 'O priziañ ho fiñvadenn...';

  @override
  String get whiteWinsGame => 'Trec\'h eo ar re wenn';

  @override
  String get blackWinsGame => 'Ar re zu zo trec\'h';

  @override
  String get learnFromYourMistakes => 'Deskiñ diouzh ho fazioù';

  @override
  String get learnFromThisMistake => 'Deskiñ diouzh ar fazi-mañ';

  @override
  String get skipThisMove => 'Leuskel ar fiñvadenn-mañ a gostez';

  @override
  String get next => 'Kenderc\'hel';

  @override
  String xWasPlayed(String param) {
    return '$param zo bet c\'hoariet';
  }

  @override
  String get findBetterMoveForWhite => 'Kavit ur gwellañ fiñvadenn evit ar re wenn';

  @override
  String get findBetterMoveForBlack => 'Kavit ur gwellañ fiñvadenn evit ar re zu';

  @override
  String get resumeLearning => 'Adkregiñ gant an deskiñ';

  @override
  String get youCanDoBetter => 'Gallout a rit ober gwelloc\'h';

  @override
  String get tryAnotherMoveForWhite => 'Klaskit ur fiñvadenn all evit ar re wenn';

  @override
  String get tryAnotherMoveForBlack => 'Klaskit ur fiñvadenn all evit ar re zu';

  @override
  String get solution => 'Respont';

  @override
  String get waitingForAnalysis => 'O c\'hortoz an dielfennañ';

  @override
  String get noMistakesFoundForWhite => 'Fazi ebet a-berzh ar re wenn';

  @override
  String get noMistakesFoundForBlack => 'Fazi ebet a-berzh ar re zu';

  @override
  String get doneReviewingWhiteMistakes => 'Echu gant an deskiñ diouzh fazioù ar re wenn';

  @override
  String get doneReviewingBlackMistakes => 'Echu gant an deskiñ diouzh fazioù ar re zu';

  @override
  String get doItAgain => 'Klask en-dro';

  @override
  String get reviewWhiteMistakes => 'Studiañ fazioù ar re wenn';

  @override
  String get reviewBlackMistakes => 'Studiañ fazioù ar re zu';

  @override
  String get advantage => 'Splet';

  @override
  String get opening => 'Digoradur';

  @override
  String get middlegame => 'Kreiz ar bartienn';

  @override
  String get endgame => 'Fin ar c\'hrogad';

  @override
  String get conditionalPremoves => 'Raktaolioù rekiz';

  @override
  String get addCurrentVariation => 'Ouzhpennañ an eilstumm o ren';

  @override
  String get playVariationToCreateConditionalPremoves => 'C\'hoariit ur variant evit krouiñ raktaolioù rekiz';

  @override
  String get noConditionalPremoves => 'Raktaol rekiz ebet';

  @override
  String playX(String param) {
    return 'C\'hoari $param';
  }

  @override
  String get showUnreadLichessMessage => 'Resevet ho peus ur gemennadenn brevez eus perzh Lichess.';

  @override
  String get clickHereToReadIt => 'Klikit amañ evit lenn anezhi';

  @override
  String get sorry => 'Hon digarezit :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Ret e oa deomp ho skarzhañ e-pad ur prantad.';

  @override
  String get why => 'Perak?';

  @override
  String get pleasantChessExperience => 'Plijout a rafe deomp e vourrfe pep hini c\'hoari echedoù war Lichess.';

  @override
  String get goodPractice => 'Evit hen ober e dav deomp bezañ sur e vez graet gant doareoù dereat gant an holl.';

  @override
  String get potentialProblem => 'Pa vez merzhet ar pezh a c\'hallfe bezañ ur gudenn e vez dispaket ar gemennadenn-mañ ganeomp.';

  @override
  String get howToAvoidThis => 'Penaos ober kuit ma c\'hoarvezfe an dra-mañ en-dro?';

  @override
  String get playEveryGame => 'Kit betek penn ho krogadoù.';

  @override
  String get tryToWin => 'Klaskit gounit pep krogad (pe bezañ rampo diantav).';

  @override
  String get resignLostGames => 'Dilezit ar c\'hrogadoù pa ne vez ket an tu kreñv ganeoc\'h (ha n\'eo ket gortoz ez afe an amzer e-biou).';

  @override
  String get temporaryInconvenience => 'Hon digarezit evit an diaezamant berrbad,';

  @override
  String get wishYouGreatGames => 'hag e hetomp krogadoù mat deoc\'h war lichess.org.';

  @override
  String get thankYouForReading => 'Mersi da vezañ lennet!';

  @override
  String get lifetimeScore => 'Disoc\'h hollek';

  @override
  String get currentMatchScore => 'Taolenn an disoc\'hoù etrezoc\'h';

  @override
  String get agreementAssistance => 'Biken ne vin sikouret e-pad ma c\'hrogadoù (na gant un urzhiataer echedoù, na gant ul levr, un diaz roadennoù pe un den all).';

  @override
  String get agreementNice => 'Prometiñ a ran bezañ bepred hegarat ouzh ar c\'hoarierien all.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Akord on ne grouin ket meur a gont (nemet evit an abegoù menneget e $param).';
  }

  @override
  String get agreementPolicy => 'Prometiñ a ran e heuilhin reolennoù Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Klask ur gaozeadenn pe krouiñ unan nevez';

  @override
  String get edit => 'Cheñch';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Prim';

  @override
  String get classical => 'Klasel';

  @override
  String get ultraBulletDesc => 'Krogadoù prim-prim-kenañ: nebeutoc\'h evit 30 eilenn';

  @override
  String get bulletDesc => 'Krogadoù prim-tre: nebeutoc\'h evit 3 munutenn';

  @override
  String get blitzDesc => 'Krogadoù prim: etre 3 ha 8 munutenn';

  @override
  String get rapidDesc => 'Krogadoù fonnus: etre 8 ha 25 munutenn';

  @override
  String get classicalDesc => 'Krogadoù klasel: 25 munutenn ha muioc\'h';

  @override
  String get correspondenceDesc => 'Krogadoù war hir dermen: un deiz pe meur a hini evit bep fiñvadenn';

  @override
  String get puzzleDesc => 'Gourdoner poelladennoù echedoù';

  @override
  String get important => 'A-bouez';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Ur respont zo bet d\'ho koulenn dija marteze $param1';
  }

  @override
  String get inTheFAQ => 'er FAG.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Ma faotañ deoc\'h mont e darempred ganeomp abalamour d\'un trucher pe d\'un den displijus, $param1';
  }

  @override
  String get useTheReportForm => 'grit gant ar furmskrid diskleriañ';

  @override
  String toRequestSupport(String param1) {
    return 'Evit bezañ sikouret $param1';
  }

  @override
  String get tryTheContactPage => 'klaskit war ar bajenn mont e darempred';

  @override
  String makeSureToRead(String param1) {
    return 'Lennit $param1 mar plij ganeoc\'h';
  }

  @override
  String get theForumEtiquette => 'reolennoù ar forom';

  @override
  String get thisTopicIsArchived => 'Diellaouet eo bet ar sujed-mañ ha ne c\'haller ket respont ken.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Ret eo bezañ ezel eus $param1 evit skrivañ ur gemennadenn er forom-mañ';
  }

  @override
  String teamNamedX(String param1) {
    return 'Skipailh $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Ne c\'hallit ket skrivañ ur gemennadenn war ar foromoù evit poent. C\'hoarit un tamm a-raok!';

  @override
  String get subscribe => 'Heuliañ';

  @override
  String get unsubscribe => 'Paouez da heuliañ';

  @override
  String mentionedYouInX(String param1) {
    return 'he/en deus meneget ac\'hanoc\'h e \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return 'Meneget oc’h bet gant $param1 e \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'en deus pedet ac’hanoc’h da \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return 'Pedet oc’h bet gant $param1 da \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Ezel eus ar skipailh oc’h bremañ.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Ezel oc\'h eus \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Skarzhet eo bet kuit unan bennak ho peus savet klemm outañ';

  @override
  String get congratsYouWon => 'Gourc’hemennoù, aet eo ar maout ganeoc’h!';

  @override
  String gameVsX(String param1) {
    return 'Krogad a-enep $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 a-enep $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Kollet ho peus poentoù a-enep unan ha n\'en deus ket doujet d\'ar reolennoù';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Bet daskoret: $param1 poent e $param2.';
  }

  @override
  String get timeAlmostUp => 'Ne chom ket kalz amzer!';

  @override
  String get clickToRevealEmailAddress => '[Klikit da ziskouez ar chomlec’h postel]';

  @override
  String get download => 'Pellgargañ';

  @override
  String get coachManager => 'Korn ar gourdoner';

  @override
  String get streamerManager => 'Merañ ar stream';

  @override
  String get cancelTournament => 'Nullañ an tournamant';

  @override
  String get tournDescription => 'Ur gerig diwar-benn an tournamant';

  @override
  String get tournDescriptionHelp => 'Un dra bennak a fell deoc\'h lâret d\'ar re a gemero perzh? E berr gomzoù mar plij. Liammoù Markdown zo: [name](https://url)';

  @override
  String get ratedFormHelp => 'Renket eo ar c\'hrogadoù ha cheñch a reont renkadur ar c\'hoarierien';

  @override
  String get onlyMembersOfTeam => 'Izili ar skipailh hepken';

  @override
  String get noRestriction => 'Harz ebet';

  @override
  String get minimumRatedGames => 'Niver a grogadoù renket rekis';

  @override
  String get minimumRating => 'Renkadur bihanañ';

  @override
  String get maximumWeeklyRating => 'Maximum weekly rating';

  @override
  String positionInputHelp(String param) {
    return 'Paste a valid FEN to start every game from a given position.\nIt only works for standard games, not with variants.\nYou can use the $param to generate a FEN position, then paste it here.\nLeave empty to start games from the normal initial position.';
  }

  @override
  String get cancelSimul => 'Cancel the simul';

  @override
  String get simulHostcolor => 'Liv an ostiz evit pep krogad';

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
  String get simulDescriptionHelp => 'Un dra bennak da lâret d\'ar re a gemero perzh?';

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
  String get noChat => 'Flap ebet';

  @override
  String get onlyTeamLeaders => 'Mistri ar skipailh hepken';

  @override
  String get onlyTeamMembers => 'Izili ar skipailh hepken';

  @override
  String get navigateMoveTree => 'Navigate the move tree';

  @override
  String get mouseTricks => 'Gant al logodenn';

  @override
  String get toggleLocalAnalysis => 'Toggle local computer analysis';

  @override
  String get toggleAllAnalysis => 'Toggle all computer analysis';

  @override
  String get playComputerMove => 'Play best computer move';

  @override
  String get analysisOptions => 'Optionoù dielfennañ';

  @override
  String get focusChat => 'Ar flap da gentañ';

  @override
  String get showHelpDialog => 'Show this help dialog';

  @override
  String get reopenYourAccount => 'Addigeriñ ho kont';

  @override
  String get closedAccountChangedMind => 'M\'ho peus serret ho kont, met cheñchet ho soñj ganeoc\'h, ho peus un tu da gaout ho kont en dro.';

  @override
  String get onlyWorksOnce => 'Ur wech e yelo en dro an dra se nemetken.';

  @override
  String get cantDoThisTwice => 'Ma serrit ho kont un eil gwech, ne vo ket tu deoc\'h adtapout anezhañ.';

  @override
  String get emailAssociatedToaccount => 'Postel liammet ouzh ar gont';

  @override
  String get sentEmailWithLink => 'Ur postel gant ul liamm \'zo bet kaset deoc\'h.';

  @override
  String get tournamentEntryCode => 'Kod mont e-barzh an tournamant';

  @override
  String get hangOn => 'O c\'hoari emaoc\'h dija!';

  @override
  String gameInProgress(String param) {
    return 'O c\'hoari emaoc\'h a-enep $param.';
  }

  @override
  String get abortTheGame => 'Nullañ ar c\'hrogad';

  @override
  String get resignTheGame => 'Dilezel ar c\'hrogad';

  @override
  String get youCantStartNewGame => 'Ne c\'haller ket kregiñ gant ur c\'hrogad all keit ha ma ne vo ket echu gant ar c\'hrogad-mañ.';

  @override
  String get since => 'Adalek';

  @override
  String get until => 'Betek';

  @override
  String get lichessDbExplanation => 'Krogadoù renket c\'hoariet war Lichess';

  @override
  String get switchSides => 'Cheñch tu';

  @override
  String get closingAccountWithdrawAppeal => 'Nullet e vo hoc\'h engalv ma serrit ho kont';

  @override
  String get ourEventTips => 'Alioù fur a-raok aozañ abadennoù';

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
      other: 'Hoc\'h enebour en deus kuitaet ar c\'hrogad. Gallout a reoc\'h goulenn bezañ trec\'h a-benn $count eilenn.',
      many: 'Hoc\'h enebour en deus kuitaet ar c\'hrogad. Gallout a reoc\'h goulenn bezañ trec\'h a-benn $count eilenn.',
      few: 'Hoc\'h enebourien o deus kuitaet ar c\'hrogad. Gallout a reoc\'h goulenn bezañ trec\'h a-benn $count eilenn.',
      two: 'Hoc\'h enebour en deus kuitaet ar c\'hrogad. Gallout a reoc\'h goulenn bezañ trec\'h a-benn $count eilenn.',
      one: 'Hoc\'h enebour en deus kuitaet ar c\'hrogad. Gallout a reoc\'h goulenn bezañ trec\'h a-benn $count eilenn.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lamm d\'ar roue goude $count hanter-fiñvadenn',
      many: 'Lamm d\'ar roue goude $count hanter-fiñvadenn',
      few: 'Lamm d\'ar roue goude $count hanter-fiñvadenn',
      two: 'Lamm d\'ar roue goude $count hanter-fiñvadenn',
      one: 'Lamm d\'ar roue goude $count hanter-fiñvadenn',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bourd',
      many: '$count bourd',
      few: '$count bourd',
      two: '$count vourd',
      one: '$count bourd',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fazi',
      many: '$count fazi',
      few: '$count fazi',
      two: '$count fazi',
      one: '$count fazi',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count diresisted',
      many: '$count diresisted',
      few: '$count diresisted',
      two: '$count ziresisted',
      one: '$count diresisted',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count c\'hoarier',
      many: '$count c\'hoarier',
      few: '$count c\'hoarier',
      two: '$count c\'hoarier',
      one: '$count c\'hoarier',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count krogad',
      many: '$count krogad',
      few: '$count krogad',
      two: '$count grogad',
      one: '$count c\'hrogad',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Renkadur $count diwar $param2 c\'hrogad',
      many: 'Renkadur $count diwar $param2 c\'hrogad',
      few: 'Renkadur $count diwar $param2 c\'h/krogad',
      two: 'Renkadur $count diwar $param2 grogad',
      one: 'Renkadur $count diwar $param2 c\'hrogad',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count er roll-istor',
      many: '$count er roll-istor',
      few: '$count er roll-istor',
      two: '$count er roll-istor',
      one: '$count er roll-istor',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deiz',
      many: '$count deiz',
      few: '$count deiz',
      two: '$count zeiz',
      one: '$count deiz',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eur',
      many: '$count eur',
      few: '$count eur',
      two: '$count eur',
      one: '$count eur',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count munutenn',
      many: '$count munutenn',
      few: '$count munutenn',
      two: '$count vunutenn',
      one: '$count vunutenn',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bep $count munutenn e vez hizivaet ar renkadur',
      many: 'Bep $count munutenn e vez hizivaet ar renkadur',
      few: 'Bep $count munutenn e vez hizivaet ar renkadur',
      two: 'Bep $count vunutenn e vez hizivaet ar renkadur',
      one: 'Bep munutenn e vez hizivaet ar renkadur',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poelladennoù',
      many: '$count poelladennoù',
      few: '$count poelladennoù',
      two: '$count boelladenn',
      one: '$count poelladenn taktik',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count krogad a-enep deoc\'h',
      many: '$count krogad a-enep deoc\'h',
      few: '$count krogad a-enep deoc\'h',
      two: '$count grogad a-enep deoc\'h',
      one: '$count c\'hrogad a-enep deoc\'h',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count c\'hoari renket',
      many: '$count c\'hoari renket',
      few: '$count c\'hoari renket',
      two: '$count c\'hoari renket',
      one: '$count c\'hoari renket',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trec\'h',
      many: '$count trec\'h',
      few: '$count trec\'h',
      two: '$count drec\'h',
      one: '$count trec\'h',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count koll',
      many: '$count koll',
      few: '$count koll',
      two: '$count goll',
      one: '$count c\'holl',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rampo',
      many: '$count rampo',
      few: '$count rampo',
      two: '$count rampo',
      one: '$count rampo',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count o c\'hoari',
      many: '$count o c\'hoari',
      few: '$count o c\'hoari',
      two: '$count o c\'hoari',
      one: '$count o c\'hoari',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reiñ $count eilenn',
      many: 'Reiñ $count eilenn',
      few: 'Reiñ $count eilenn',
      two: 'Reiñ $count eilenn',
      one: 'Reiñ $count eilenn',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poent tournamant',
      many: '$count poent tournamant',
      few: '$count poent tournamant',
      two: '$count boent tournamant',
      one: '$count poent tournamant',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studiadenn',
      many: '$count studiadenn',
      few: '$count studiadenn',
      two: '$count studiadenn',
      one: '$count studiadenn',
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
      other: '≥ $count krogad renket',
      many: '≥ $count krogad renket',
      few: '≥ $count krogad renket',
      two: '≥ $count grogad renket',
      one: '≥ $count c\'hrogad renket',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count krogad $param2 renket',
      many: '≥ $count krogad $param2 renket',
      few: '≥ $count krogad $param2 renket',
      two: '≥ $count grogad $param2 renket',
      one: '≥ $count c\'hrogad $param2 renket',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ret eo deoc\'h kemer perzh e $count krogad $param2 renket ouzhpenn',
      many: 'Ret eo deoc\'h kemer perzh e $count krogad $param2 renket ouzhpenn',
      few: 'Ret eo deoc\'h kemer perzh e $count krogad $param2 renket ouzhpenn',
      two: 'Ret eo deoc\'h kemer perzh e $count grogad $param2 renket ouzhpenn',
      one: 'Ret eo deoc\'h kemer perzh en $count c\'hrogad $param2 renket ouzhpenn',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ret eo deoc\'h kemer perzh e $count krogad renket ouzhpenn',
      many: 'Ret eo deoc\'h kemer perzh e $count krogad renket ouzhpenn',
      few: 'Ret eo deoc\'h kemer perzh e $count krogad renket ouzhpenn',
      two: 'Ret eo deoc\'h kemer perzh e $count grogad renket ouzhpenn',
      one: 'Ret eo deoc\'h kemer perzh en $count c\'hrogad renket ouzhpenn',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count krogad enporzhiet',
      many: '$count krogad enporzhiet',
      few: '$count krogad enporzhiet',
      two: '$count grogad enporzhiet',
      one: '$count c\'hrogad enporzhiet',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mignon enlinenn',
      many: '$count mignon enlinenn',
      few: '$count mignon enlinenn',
      two: '$count vignon enlinenn',
      one: '$count mignon enlinenn',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count den o heuliañ',
      many: '$count den o heuliañ',
      few: '$count den o heuliañ',
      two: '$count zen o heuliañ',
      one: '$count den o heuliañ',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O heuliañ $count c\'hoarier',
      many: 'O heuliañ $count c\'hoarier',
      few: 'O heuliañ $count c\'hoarier',
      two: 'O heuliañ $count c\'hoarier',
      one: 'O heuliañ $count c\'hoarier',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nebeutoc\'h evit $count munutenn',
      many: 'Nebeutoc\'h evit $count munutenn',
      few: 'Nebeutoc\'h evit $count munutenn',
      two: 'Nebeutoc\'h evit $count vunutenn',
      one: 'Nebeutoc\'h evit $count vunutenn',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count krogad o ren bremañ',
      many: '$count krogad o ren bremañ',
      few: '$count krogad o ren bremañ',
      two: '$count grogad o ren bremañ',
      one: '$count c\'hrogad o ren bremañ',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hirder brasañ: $count arouezenn.',
      many: 'Hirder brasañ: $count arouezenn.',
      few: 'Hirder brasañ: $count arouezenn.',
      two: 'Hirder brasañ: $count arouezenn.',
      one: 'Hirder brasañ : $count arouezenn.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stanket',
      many: '$count stanket',
      few: '$count stanket',
      two: '$count stanket',
      one: '$count stanket',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kemennadenn er forom',
      many: '$count kemennadenn er forom',
      few: '$count kemennadenn er forom',
      two: '$count gemennadenn er forom',
      one: '$count gemennadenn er forom',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count c\'hoarier $param2 ar sizhun-mañ.',
      many: '$count c\'hoarier $param2 ar sizhun-mañ.',
      few: '$count c\'hoarier $param2 ar sizhun-mañ.',
      two: '$count c\'hoarier $param2 ar sizhun-mañ.',
      one: '$count c\'hoarier $param2 ar sizhun-mañ.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gallout a reer dibab etre $count yezh!',
      many: 'Gallout a reer dibab etre $count yezh!',
      few: 'Gallout a reer dibab etre $count yezh!',
      two: 'Gallout a reer dibab etre $count yezh!',
      one: 'Gallout a reer dibab etre $count yezh!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eilenn evit fiñval ho pezh kentañ c\'hoazh',
      many: '$count eilenn evit fiñval ho pezh kentañ c\'hoazh',
      few: '$count eilenn evit fiñval ho pezh kentañ c\'hoazh',
      two: '$count eilenn evit fiñval ho pezh kentañ c\'hoazh',
      one: '$count eilenn evit fiñval ho pezh kentañ c\'hoazh',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eilenn',
      many: '$count eilenn',
      few: '$count eilenn',
      two: '$count eilenn',
      one: '$count eilenn',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hag enrollit $count linennoù raktaolioù',
      many: 'hag enrollit $count linennoù raktaolioù',
      few: 'hag enrollit $count linennoù raktaolioù',
      two: 'hag enrollit $count linenn raktaolioù',
      one: 'hag enrollit $count linenn raktaolioù',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Grit un taol evit kregiñ';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'C\'hoari a rit gant ar re wenn e pep poelladenn';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'C\'hoari a rit gant ar re zu e pep poelladenn';

  @override
  String get stormPuzzlesSolved => 'poelladennoù diskoulmet';

  @override
  String get stormNewDailyHighscore => 'Disoc\'h gwellañ an devezh!';

  @override
  String get stormNewWeeklyHighscore => 'Disoc\'h gwellañ ar sizhun!';

  @override
  String get stormNewMonthlyHighscore => 'Disoc\'h gwellañ ar miz!';

  @override
  String get stormNewAllTimeHighscore => 'Disoc\'h gwellañ a-viskoazh!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Ho tisoc\'h gwellañ kent a oa $param';
  }

  @override
  String get stormPlayAgain => 'C\'hoari c\'hoazh';

  @override
  String stormHighscoreX(String param) {
    return 'Disoc\'h gwellañ: $param';
  }

  @override
  String get stormScore => 'Disoc\'h';

  @override
  String get stormMoves => 'Taolioù';

  @override
  String get stormAccuracy => 'Pizhder';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Padelezh';

  @override
  String get stormTimePerMove => 'Padelezh dre daol';

  @override
  String get stormHighestSolved => 'Hini uhelañ diskoulmet';

  @override
  String get stormPuzzlesPlayed => 'Poelladennoù c\'hoariet';

  @override
  String get stormNewRun => 'Frapad nevez (hotkey: Space)';

  @override
  String get stormEndRun => 'Fin ar frapad (hotkey: Enter)';

  @override
  String get stormHighscores => 'Disoc\'hoù gwellañ';

  @override
  String get stormViewBestRuns => 'Gwelet ar frapadoù gwellañ';

  @override
  String get stormBestRunOfDay => 'Frapad gwellañ an devezh';

  @override
  String get stormRuns => 'Frapadoù';

  @override
  String get stormGetReady => 'Bezit prest!';

  @override
  String get stormWaitingForMorePlayers => 'O c\'hortoz c\'hoarierien ouzhpenn da zont...';

  @override
  String get stormRaceComplete => 'Achu ar redadeg!';

  @override
  String get stormSpectating => 'Oc\'h arvestiñ';

  @override
  String get stormJoinTheRace => 'Kregiñ gant ar redadeg!';

  @override
  String get stormStartTheRace => 'Start the race';

  @override
  String stormYourRankX(String param) {
    return 'Ho renk: $param';
  }

  @override
  String get stormWaitForRematch => 'Gortozit evit c\'hoari en dro';

  @override
  String get stormNextRace => 'Ur redadeg c\'hoazh';

  @override
  String get stormJoinRematch => 'Kemer e zial';

  @override
  String get stormWaitingToStart => 'Gortozit e krogfe';

  @override
  String get stormCreateNewGame => 'Krouiñ ur redadeg nevez';

  @override
  String get stormJoinPublicRace => 'Kemer perzh en ur redadeg foran';

  @override
  String get stormRaceYourFriends => 'Grit ar redadeg a-enep ho mignoned';

  @override
  String get stormSkip => 'tremen e-biou';

  @override
  String get stormSkipHelp => 'Gallout a rit lammat un taol eus pep redadeg:';

  @override
  String get stormSkipExplanation => 'Lammit war an taol-se evit derc\'hel ho kombo! Ur wech e pep redadeg hepken.';

  @override
  String get stormFailedPuzzles => 'Failed puzzles';

  @override
  String get stormSlowPuzzles => 'Slow puzzles';

  @override
  String get stormSkippedPuzzle => 'Skipped puzzle';

  @override
  String get stormThisWeek => 'Ar sizhun-mañ';

  @override
  String get stormThisMonth => 'Ar miz-mañ';

  @override
  String get stormAllTime => 'A-viskoazh';

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
      other: '$count frapad',
      many: '$count frapad',
      few: '$count frapad',
      two: '$count frapad',
      one: '1 frapad',
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
  String get streamerLichessStreamers => 'Streamerien Lichess';

  @override
  String get studyPrivate => 'Prevez';

  @override
  String get studyMyStudies => 'Ma studiadennoù';

  @override
  String get studyStudiesIContributeTo => 'Studiadennoù am eus kemeret perzh enne';

  @override
  String get studyMyPublicStudies => 'Ma studiadennoù foran';

  @override
  String get studyMyPrivateStudies => 'Ma studiadennoù prevez';

  @override
  String get studyMyFavoriteStudies => 'Ma studiadennoù muiañ-karet';

  @override
  String get studyWhatAreStudies => 'Petra eo ar studiadennoù?';

  @override
  String get studyAllStudies => 'An holl studiadennoù';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studiadennoù krouet gant $param';
  }

  @override
  String get studyNoneYet => 'Hini ebet evit poent.';

  @override
  String get studyHot => 'Deus ar c\'hiz';

  @override
  String get studyDateAddedNewest => 'Deiziad ouzhpennet (nevesañ)';

  @override
  String get studyDateAddedOldest => 'Deiziad ouzhpennet (koshañ)';

  @override
  String get studyRecentlyUpdated => 'Hizivaet a-nevez';

  @override
  String get studyMostPopular => 'Muiañ karet';

  @override
  String get studyAlphabetical => 'Alphabetical';

  @override
  String get studyAddNewChapter => 'Ouzhpennañ ur pennad';

  @override
  String get studyAddMembers => 'Ouzhpennañ izili';

  @override
  String get studyInviteToTheStudy => 'Pediñ d\'ar studiadenn';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Na bedit nemet tud a anavezit hag o deus c\'hoant da gemer perzh da vat en ho studiadenn.';

  @override
  String get studySearchByUsername => 'Klask dre anv implijer';

  @override
  String get studySpectator => 'Arvester';

  @override
  String get studyContributor => 'Perzhiad';

  @override
  String get studyKick => 'Forbannañ';

  @override
  String get studyLeaveTheStudy => 'Kuitaat ar studiadenn';

  @override
  String get studyYouAreNowAContributor => 'Perzhiad oc\'h bremañ';

  @override
  String get studyYouAreNowASpectator => 'Un arvester oc\'h bremañ';

  @override
  String get studyPgnTags => 'Tikedennoù PGN';

  @override
  String get studyLike => 'Plijet';

  @override
  String get studyUnlike => 'Unlike';

  @override
  String get studyNewTag => 'Tikedenn nevez';

  @override
  String get studyCommentThisPosition => 'Lâret ur ger diwar-benn al lakadur-mañ';

  @override
  String get studyCommentThisMove => 'Ober un evezhiadenn diwar-benn ar fiñvadenn-mañ';

  @override
  String get studyAnnotateWithGlyphs => 'Notennaouiñ gant arouezioù';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Re verr eo ar pennad evit bezañ dielfennet.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'N\'eus nemet perzhidi ar studiadenn a c\'hall goulenn un dielfennañ urzhiataer.';

  @override
  String get studyGetAFullComputerAnalysis => 'Kaout un dielfennañ klok eus ar bennlinenn graet gant un urzhiataer.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Bezit sur eo klok ar pennad. Ne c\'hallit goulenn un dielfennañ nemet ur wech.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Er memes lec\'hiadur e chom holl izili ar SYNC';

  @override
  String get studyShareChanges => 'Rannañ cheñchamantoù gant an arvesterien ha saveteiñ anezhe war ar servor';

  @override
  String get studyPlaying => 'O c\'hoari';

  @override
  String get studyShowEvalBar => 'Evaluation bars';

  @override
  String get studyFirst => 'Kentañ';

  @override
  String get studyPrevious => 'War-gil';

  @override
  String get studyNext => 'War-lec\'h';

  @override
  String get studyLast => 'Diwezhañ';

  @override
  String get studyShareAndExport => 'Skignañ & ezporzhiañ';

  @override
  String get studyCloneStudy => 'Eilañ';

  @override
  String get studyStudyPgn => 'PGN ar studi';

  @override
  String get studyDownloadAllGames => 'Pellgargañ an holl grogadoù';

  @override
  String get studyChapterPgn => 'PGN ar pennad';

  @override
  String get studyCopyChapterPgn => 'Copy PGN';

  @override
  String get studyDownloadGame => 'Pellgargañ ur c\'hrogad';

  @override
  String get studyStudyUrl => 'Studiañ URL';

  @override
  String get studyCurrentChapterUrl => 'URL ar pennad evit poent';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Gallout a rit pegañ se er forom evit ensoc\'hañ';

  @override
  String get studyStartAtInitialPosition => 'Kregiñ el lec\'hiadur kentañ';

  @override
  String studyStartAtX(String param) {
    return 'Kregiñ e $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Enframmañ en ho lec\'hienn pe blog';

  @override
  String get studyReadMoreAboutEmbedding => 'Goût hiroc\'h diwar-benn an ensoc\'hañ';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Ar studiadennoù foran a c\'hall bezañ ensoc\'het!';

  @override
  String get studyOpen => 'Digeriñ';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1, zo kaset deoc\'h gant $param2';
  }

  @override
  String get studyStudyNotFound => 'N\'eo ket bet kavet ar studiadenn';

  @override
  String get studyEditChapter => 'Aozañ ar pennad';

  @override
  String get studyNewChapter => 'Pennad nevez';

  @override
  String studyImportFromChapterX(String param) {
    return 'Import from $param';
  }

  @override
  String get studyOrientation => 'Tuadur';

  @override
  String get studyAnalysisMode => 'Doare dielfennañ';

  @override
  String get studyPinnedChapterComment => 'Ali war ar pennad spilhet';

  @override
  String get studySaveChapter => 'Saveteiñ pennad';

  @override
  String get studyClearAnnotations => 'Diverkañ an notennoù';

  @override
  String get studyClearVariations => 'Clear variations';

  @override
  String get studyDeleteChapter => 'Dilemel pennad';

  @override
  String get studyDeleteThisChapter => 'Dilemel ar pennad-mañ? Hep distro e vo!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Diverkañ an holl evezhiadennoù ha notennoù er pennad?';

  @override
  String get studyRightUnderTheBoard => 'Dindan an dablez';

  @override
  String get studyNoPinnedComment => 'Hini ebet';

  @override
  String get studyNormalAnalysis => 'Dielfennañ normal';

  @override
  String get studyHideNextMoves => 'Kuzhat ar fiñvadennoù da heul';

  @override
  String get studyInteractiveLesson => 'Kentel etreoberiat';

  @override
  String studyChapterX(String param) {
    return 'Pennad $param';
  }

  @override
  String get studyEmpty => 'Goullo';

  @override
  String get studyStartFromInitialPosition => 'Kregiñ el lec\'hiadur kentañ';

  @override
  String get studyEditor => 'Aozer';

  @override
  String get studyStartFromCustomPosition => 'Kregiñ adalek ul lakadur aozet';

  @override
  String get studyLoadAGameByUrl => 'Kargañ ur c\'hrogad dre URL';

  @override
  String get studyLoadAPositionFromFen => 'Kargañ ul lakadur dre FEN';

  @override
  String get studyLoadAGameFromPgn => 'Kargañ ul lakadur dre PGN';

  @override
  String get studyAutomatic => 'Emgefre';

  @override
  String get studyUrlOfTheGame => 'URL ar c\'hrogad';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Kargañ ur c\'hrogad eus $param1 pe $param2';
  }

  @override
  String get studyCreateChapter => 'Krouiñ pennad';

  @override
  String get studyCreateStudy => 'Krouiñ ur studiadenn';

  @override
  String get studyEditStudy => 'Aozañ studiadenn';

  @override
  String get studyVisibility => 'Gwelusted';

  @override
  String get studyPublic => 'Foran';

  @override
  String get studyUnlisted => 'N\'eo ket bet listennet';

  @override
  String get studyInviteOnly => 'Kouvidi hepken';

  @override
  String get studyAllowCloning => 'Aotreañ ar c\'hlonañ';

  @override
  String get studyNobody => 'Den ebet';

  @override
  String get studyOnlyMe => 'Me hepken';

  @override
  String get studyContributors => 'Perzhidi';

  @override
  String get studyMembers => 'Izili';

  @override
  String get studyEveryone => 'An holl dud';

  @override
  String get studyEnableSync => 'Gweredekaat sync';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Ya: laoskit an traoù evel m\'emaint';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Nann: laoskit an dud merdeiñ trankilik';

  @override
  String get studyPinnedStudyComment => 'Ali war ar studiadenn spilhet';

  @override
  String get studyStart => 'Kregiñ';

  @override
  String get studySave => 'Saveteiñ';

  @override
  String get studyClearChat => 'Diverkañ ar flapañ';

  @override
  String get studyDeleteTheStudyChatHistory => 'Dilemel an istor-flapañ? Hep distro e vo!';

  @override
  String get studyDeleteStudy => 'Dilemel ar studiadenn';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Delete the entire study? There is no going back! Type the name of the study to confirm: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Pelec\'h ho peus c\'hoant da studiañ se?';

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
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pennad',
      many: '$count pennad',
      few: '$count pennad',
      two: '$count pennad',
      one: '$count pennad',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count C\'hoariadenn',
      many: '$count C\'hoariadenn',
      few: '$count C\'hoariadenn',
      two: '$count C\'hoariadenn',
      one: '$count C\'hoariadenn',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ezel',
      many: '$count Ezel',
      few: '$count Ezel',
      two: '$count Ezel',
      one: '$count Ezel',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pegit testenn ho PGN amañ, betek $count krogadoù',
      many: 'Pegit testenn ho PGN amañ, betek $count krogadoù',
      few: 'Pegit testenn ho PGN amañ, betek $count krogadoù',
      two: 'Pegit testenn ho PGN amañ, betek $count grogad',
      one: 'Pegit testenn ho PGN amañ, betek $count krogad',
    );
    return '$_temp0';
  }
}
