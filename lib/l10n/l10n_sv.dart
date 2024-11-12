import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get mobileHomeTab => 'Hem';

  @override
  String get mobilePuzzlesTab => 'Problem';

  @override
  String get mobileToolsTab => 'Verktyg';

  @override
  String get mobileWatchTab => 'Titta';

  @override
  String get mobileSettingsTab => 'Settings';

  @override
  String get mobileMustBeLoggedIn => 'You must be logged in to view this page.';

  @override
  String get mobileSystemColors => 'Systemets färger';

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
  String get mobileAllGames => 'Alla spel';

  @override
  String get mobileRecentSearches => 'Senaste sökningar';

  @override
  String get mobileClearButton => 'Rensa';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Spelare med \"$param\"';
  }

  @override
  String get mobileNoSearchResults => 'Inga resultat';

  @override
  String get mobileAreYouSure => 'Är du säker?';

  @override
  String get mobilePuzzleStreakAbortWarning => 'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleStormNothingToShow => 'Nothing to show. Play some runs of Puzzle Storm.';

  @override
  String get mobileSharePuzzle => 'Dela detta schackproblem';

  @override
  String get mobileShareGameURL => 'Dela parti-URL';

  @override
  String get mobileShareGamePGN => 'Dela PGN';

  @override
  String get mobileSharePositionAsFEN => 'Share position as FEN';

  @override
  String get mobileShowVariations => 'Visa variationer';

  @override
  String get mobileHideVariation => 'Dölj variationer';

  @override
  String get mobileShowComments => 'Visa kommentarer';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Do you want to end this run?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Nothing to show, please change the filters';

  @override
  String get mobileCancelTakebackOffer => 'Cancel takeback offer';

  @override
  String get mobileWaitingForOpponentToJoin => 'Waiting for opponent to join...';

  @override
  String get mobileBlindfoldMode => 'I blindo';

  @override
  String get mobileLiveStreamers => 'Live streamers';

  @override
  String get mobileCustomGameJoinAGame => 'Gå med i spel';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Clear saved move';

  @override
  String get mobileSomethingWentWrong => 'Något gick fel.';

  @override
  String get mobileShowResult => 'Visa resultat';

  @override
  String get mobilePuzzleThemesSubtitle => 'Play puzzles from your favorite openings, or choose a theme.';

  @override
  String get mobilePuzzleStormSubtitle => 'Solve as many puzzles as possible in 3 minutes.';

  @override
  String mobileGreeting(String param) {
    return 'Hej $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Hej';

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Magnify dragged piece';

  @override
  String get activityActivity => 'Aktivitet';

  @override
  String get activityHostedALiveStream => 'Var värd för en direktsänd videosändning';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Rankad #$param1 i $param2';
  }

  @override
  String get activitySignedUp => 'Registrerade sig på lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har stött lichess.org i $count månader som en $param2',
      one: 'Har stött lichess.org i $count månad som en $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tränade $count ställningar på $param2',
      one: 'Tränade $count ställning på $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Löste $count taktikproblem',
      one: 'Löste $count taktikproblem',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spelade $count $param2-partier',
      one: 'Spelade $count $param2-parti',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Postade $count inlägg i $param2',
      one: 'Postade $count inlägg i $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spelade $count drag',
      one: 'Spelade $count drag',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count korrespondenspartier',
      one: 'i $count korrespondensparti',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Avslutade $count korrespondenspartier',
      one: 'Avslutade $count korrespondensparti',
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
      other: 'Började följa $count spelare',
      one: 'Började följa $count spelare',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fick $count nya följare',
      one: 'Fick $count ny följare',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Var värd för $count simultanmatcher',
      one: 'Var värd för $count simultanmatch',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deltog i $count simultanmatcher',
      one: 'Deltog i $count simultanmatch',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skapade $count nya studier',
      one: 'Skapade $count ny studie',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tävlade i $count turneringar',
      one: 'Tävlade i $count turnering',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rankad #$count (topp $param2%) med $param3 partier i $param4',
      one: 'Rankad #$count (topp $param2%) med $param3 partier i $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tävlade i $count swissturneringar',
      one: 'Tävlade i $count swissturnering',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gick med i $count lag',
      one: 'Gick med i $count lag',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Sändningar';

  @override
  String get broadcastMyBroadcasts => 'Mina sändningar';

  @override
  String get broadcastLiveBroadcasts => 'Direktsända turneringar';

  @override
  String get broadcastBroadcastCalendar => 'Broadcast calendar';

  @override
  String get broadcastNewBroadcast => 'Ny direktsändning';

  @override
  String get broadcastSubscribedBroadcasts => 'Subscribed broadcasts';

  @override
  String get broadcastAboutBroadcasts => 'Om sändningar';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Hur man använder Lichess-Sändningar.';

  @override
  String get broadcastTheNewRoundHelp => 'Den nya rundan kommer att ha samma medlemmar och bidragsgivare som den föregående.';

  @override
  String get broadcastAddRound => 'Lägg till en omgång';

  @override
  String get broadcastOngoing => 'Pågående';

  @override
  String get broadcastUpcoming => 'Kommande';

  @override
  String get broadcastCompleted => 'Slutförda';

  @override
  String get broadcastCompletedHelp => 'Lichess upptäcker slutförandet av rundor baserat på källspelen. Använd detta alternativ om det inte finns någon källa.';

  @override
  String get broadcastRoundName => 'Omgångens namn';

  @override
  String get broadcastRoundNumber => 'Omgångens nummer';

  @override
  String get broadcastTournamentName => 'Turneringens namn';

  @override
  String get broadcastTournamentDescription => 'Kort beskrivning av turneringen';

  @override
  String get broadcastFullDescription => 'Fullständig beskrivning';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Valfri längre beskrivning av sändningen. $param1 är tillgänglig. Längden måste vara mindre än $param2 tecken.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN Source URL';

  @override
  String get broadcastSourceUrlHelp => 'URL som Lichess kan använda för att få PGN-uppdateringar. Den måste vara publikt tillgänglig från Internet.';

  @override
  String get broadcastSourceGameIds => 'Up to 64 Lichess game IDs, separated by spaces.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Start date in the tournament local timezone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Valfritt, om du vet när händelsen startar';

  @override
  String get broadcastCurrentGameUrl => 'Länk till aktuellt parti (URL)';

  @override
  String get broadcastDownloadAllRounds => 'Ladda ner alla omgångar';

  @override
  String get broadcastResetRound => 'Återställ den här omgången';

  @override
  String get broadcastDeleteRound => 'Ta bort den här omgången';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Ta bort denna runda och dess partier definitivt.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Radera alla partier i denna runda. Källan kommer behöva vara aktiv för att återskapa dem.';

  @override
  String get broadcastEditRoundStudy => 'Redigera studie för ronden';

  @override
  String get broadcastDeleteTournament => 'Radera turnering';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Definitivt radera turnering.';

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
      other: '$count sändningar',
      one: '$count sändning',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Utmaningar: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Utmana till ett parti';

  @override
  String get challengeChallengeDeclined => 'Utmaning avböjd';

  @override
  String get challengeChallengeAccepted => 'Utmaning accepterad!';

  @override
  String get challengeChallengeCanceled => 'Utmaning avbruten.';

  @override
  String get challengeRegisterToSendChallenges => 'Vänligen registrera ett konto för att skicka utmaningar.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Du kan inte utmana $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param accepterar inte utmaningar.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Din ${param1}rating är för långt ifrån $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Kan inte utmana på grund av provisorisk ${param}rating.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param accepterar endast utmaningar från vänner.';
  }

  @override
  String get challengeDeclineGeneric => 'Jag accepterar inte utmaningar för tillfället.';

  @override
  String get challengeDeclineLater => 'Detta är inte rätt tid för mig, vänligen fråga igen senare.';

  @override
  String get challengeDeclineTooFast => 'Denna tidskontroll är för snabb för mig, vänligen utmana igen med ett långsammare parti.';

  @override
  String get challengeDeclineTooSlow => 'Denna tidskontroll är för långsam för mig, vänligen utmana igen med ett snabbare parti.';

  @override
  String get challengeDeclineTimeControl => 'Jag antar inte utmaningar med denna tidskontroll.';

  @override
  String get challengeDeclineRated => 'Vänligen skicka en rankad utmaning istället.';

  @override
  String get challengeDeclineCasual => 'Vänligen skicka en orankad utmaning istället.';

  @override
  String get challengeDeclineStandard => 'Jag antar inte utmaningar med varianter för tillfället.';

  @override
  String get challengeDeclineVariant => 'Jag vill inte spela denna variant för tillfället.';

  @override
  String get challengeDeclineNoBot => 'Jag antar inte utmaningar från bottar.';

  @override
  String get challengeDeclineOnlyBot => 'Jag antar endast utmaningar från bottar.';

  @override
  String get challengeInviteLichessUser => 'Eller bjud in en Lichess-användare:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Kontakta Lichess';

  @override
  String get coordinatesCoordinates => 'Koordinater';

  @override
  String get coordinatesCoordinateTraining => 'Träna på koordinaterna';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return 'Genomsnittlig poäng som vit: $param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return 'Genomsnittlig poäng som svart: $param';
  }

  @override
  String get coordinatesKnowingTheChessBoard => 'Att veta schackbrädets koordinater är en mycket viktig schackfärdighet:';

  @override
  String get coordinatesMostChessCourses => 'De flesta schackkurserna och övningarna använder algebraisk notation.';

  @override
  String get coordinatesTalkToYourChessFriends => 'Det gör det lättare att prata med dina schackvänner eftersom ni bägge förstår ”schackspråket”.';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively => 'Ett parti analyseras ännu effektivare om du inte behöver söka efter rutornas koordinater.';

  @override
  String get coordinatesACoordinateAppears => 'En koordinat visas på brädet och du ska klicka på motsvarande ruta.';

  @override
  String get coordinatesASquareIsHighlightedExplanation => 'En ruta är markerad på tavlan och du ska ange dess koordinat (t.ex. \"e4\").';

  @override
  String get coordinatesYouHaveThirtySeconds => 'Du har 30 sekunder på dig att korrekt namnge så många rutor som möjligt!';

  @override
  String get coordinatesGoAsLongAsYouWant => 'Fortsätt så länge du vill, det finns ingen tidsbegränsning!';

  @override
  String get coordinatesShowCoordinates => 'Visa koordinater';

  @override
  String get coordinatesShowCoordsOnAllSquares => 'Coordinates on every square';

  @override
  String get coordinatesShowPieces => 'Visa pjäser';

  @override
  String get coordinatesStartTraining => 'Starta träningen';

  @override
  String get coordinatesFindSquare => 'Hitta ruta';

  @override
  String get coordinatesNameSquare => 'Namnge ruta';

  @override
  String get patronDonate => 'Donera';

  @override
  String get patronLichessPatron => 'Lichess-donator';

  @override
  String perfStatPerfStats(String param) {
    return '$param-statistik';
  }

  @override
  String get perfStatViewTheGames => 'Visa partierna';

  @override
  String get perfStatProvisional => 'provisorisk';

  @override
  String get perfStatNotEnoughRatedGames => 'Inte tillräckligt många rankade partier har spelats för att fastställa en tillförlitlig rating.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Utveckling under de senaste $param spelen:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Ratingavvikelse: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Lägre värde betyder att ratingen är mer stabil. Vid värden över $param1 anses ratingen vara provisorisk. För att inkluderas i rankinglistorna bör detta värde vara under $param2 (standardschack) eller $param3 (varianter).';
  }

  @override
  String get perfStatTotalGames => 'Antal partier totalt';

  @override
  String get perfStatRatedGames => 'Rankade partier';

  @override
  String get perfStatTournamentGames => 'Turneringspartier';

  @override
  String get perfStatBerserkedGames => 'Berserk-partier';

  @override
  String get perfStatTimeSpentPlaying => 'Total speltid';

  @override
  String get perfStatAverageOpponent => 'Genomsnittlig motståndare';

  @override
  String get perfStatVictories => 'Segrar';

  @override
  String get perfStatDefeats => 'Förluster';

  @override
  String get perfStatDisconnections => 'Avbrutna partier';

  @override
  String get perfStatNotEnoughGames => 'Inte tillräckligt med spelade partier';

  @override
  String perfStatHighestRating(String param) {
    return 'Högsta rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Lägsta rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'från $param1 till $param2';
  }

  @override
  String get perfStatWinningStreak => 'Vinster i rad';

  @override
  String get perfStatLosingStreak => 'Förluster i rad';

  @override
  String perfStatLongestStreak(String param) {
    return 'Längsta serie: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Nuvarande serie: $param';
  }

  @override
  String get perfStatBestRated => 'Högst rankade segrar';

  @override
  String get perfStatGamesInARow => 'Partier som spelats i rad';

  @override
  String get perfStatLessThanOneHour => 'Mindre än en timme mellan partierna';

  @override
  String get perfStatMaxTimePlaying => 'Längsta speltid';

  @override
  String get perfStatNow => 'nu';

  @override
  String get preferencesPreferences => 'Inställningar';

  @override
  String get preferencesDisplay => 'Visningsalternativ';

  @override
  String get preferencesPrivacy => 'Sekretess';

  @override
  String get preferencesNotifications => 'Notifieringar';

  @override
  String get preferencesPieceAnimation => 'Pjäsanimation';

  @override
  String get preferencesMaterialDifference => 'Materialskillnad';

  @override
  String get preferencesBoardHighlights => 'Brädmarkeringar (föregående drag och schack)';

  @override
  String get preferencesPieceDestinations => 'Möjliga drag (giltiga drag och förhandsdrag)';

  @override
  String get preferencesBoardCoordinates => 'Brädkoordinater (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Lista med drag under spelets gång';

  @override
  String get preferencesPgnPieceNotation => 'Dragnotation';

  @override
  String get preferencesChessPieceSymbol => 'Schackpjäs-symbol';

  @override
  String get preferencesPgnLetter => 'Bokstav (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen-läge';

  @override
  String get preferencesShowPlayerRatings => 'Visa spelarens rating';

  @override
  String get preferencesShowFlairs => 'Visa spelarflairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Detta gör det möjligt att dölja all rating från webbplatsen, för att fokusera på schackspelet. Partiet kan fortfarande vara med rating, detta handlar bara om vad du får se.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Visa handtag för att ändra brädets storlek';

  @override
  String get preferencesOnlyOnInitialPosition => 'Endast vid ursprunglig position';

  @override
  String get preferencesInGameOnly => 'Endast i parti';

  @override
  String get preferencesChessClock => 'Schack-klocka';

  @override
  String get preferencesTenthsOfSeconds => 'Tiondels sekunder';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'När återstående tid < 10 sekunder';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horisontella gröna förloppsindikatorer';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Ljud när tiden blir kritisk';

  @override
  String get preferencesGiveMoreTime => 'Ge mer tid';

  @override
  String get preferencesGameBehavior => 'Spelbeteende';

  @override
  String get preferencesHowDoYouMovePieces => 'Flytta pjäser';

  @override
  String get preferencesClickTwoSquares => 'Klicka två rutor';

  @override
  String get preferencesDragPiece => 'Drag pjäs';

  @override
  String get preferencesBothClicksAndDrag => 'Båda';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Förhandsdrag (göra drag i förväg under motståndarens tur)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Ta tillbaka drag (med motståndarens godkännande)';

  @override
  String get preferencesInCasualGamesOnly => 'Endast i icke rankade partier';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promovera till drottning automatiskt';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Håll ner <ctrl> -tangenten medan du uppgraderar för att tillfälligt inaktivera automatisk förvandling';

  @override
  String get preferencesWhenPremoving => 'Vid förhandsdrag';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Begär remi automatiskt vid trefaldig upprepning';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'När återstående tid < 30 sekunder';

  @override
  String get preferencesMoveConfirmation => 'Bekräftelse av drag';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Kan inaktiveras under ett spel med forummenyn';

  @override
  String get preferencesInCorrespondenceGames => 'I korrespondenspartier';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korrespondens och obegränsad';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Bekräfta resignation och remi-anbud';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Sätt att göra rockad';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Flytta kungen två rutor';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Flytta kungen till tornet eller 2 steg';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Mata in drag via tangentbord';

  @override
  String get preferencesInputMovesWithVoice => 'Gör drag med din röst';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Dra pilar för giltiga drag';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Säg \"Bra parti, väl spelat\" vid förlust eller remi';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Dina inställningar har sparats.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Bläddra på tavlan för att spela upp rörelser';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Daglig e-postavisering som listar dina korrespondensspel';

  @override
  String get preferencesNotifyStreamStart => 'Strömmen går igång';

  @override
  String get preferencesNotifyInboxMsg => 'Nytt meddelande i inkorgen';

  @override
  String get preferencesNotifyForumMention => 'Forumkommentar nämner dig';

  @override
  String get preferencesNotifyInvitedStudy => 'Inbjudan till studier';

  @override
  String get preferencesNotifyGameEvent => 'Korrespondensspelsuppdateringar';

  @override
  String get preferencesNotifyChallenge => 'Utmaningar';

  @override
  String get preferencesNotifyTournamentSoon => 'Turneringen startar snart';

  @override
  String get preferencesNotifyTimeAlarm => 'Korrespondensklockans tid tar slut';

  @override
  String get preferencesNotifyBell => 'Spela upp ett klockljud vid ny avisering';

  @override
  String get preferencesNotifyPush => 'Enhetsnotifiering när du inte använder Lichess';

  @override
  String get preferencesNotifyWeb => 'Webbläsare';

  @override
  String get preferencesNotifyDevice => 'Enhet';

  @override
  String get preferencesBellNotificationSound => 'Klock-notisljud';

  @override
  String get puzzlePuzzles => 'Problem';

  @override
  String get puzzlePuzzleThemes => 'Teman för schackproblem';

  @override
  String get puzzleRecommended => 'Rekommenderad';

  @override
  String get puzzlePhases => 'Faser';

  @override
  String get puzzleMotifs => 'Motiv';

  @override
  String get puzzleAdvanced => 'Avancerat';

  @override
  String get puzzleLengths => 'Längd';

  @override
  String get puzzleMates => 'Mattar';

  @override
  String get puzzleGoals => 'Mål';

  @override
  String get puzzleOrigin => 'Ursprung';

  @override
  String get puzzleSpecialMoves => 'Speciella drag';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Gillade du det här problemet?';

  @override
  String get puzzleVoteToLoadNextOne => 'Rösta för att ladda nästa!';

  @override
  String get puzzleUpVote => 'Rösta upp pussel';

  @override
  String get puzzleDownVote => 'Rösta ner pussel';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Din pusselrating kommer inte ändras. Observera att pussel inte är en tävling. Rating hjälper till att välja de bästa pusseln för din nuvarande skicklighet.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Hitta bästa draget för vit.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Hitta bästa draget för svart.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'För att få personanpassade problem:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Problem $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Dagens problem';

  @override
  String get puzzleDailyPuzzle => 'Dagens problem';

  @override
  String get puzzleClickToSolve => 'Klicka för att lösa';

  @override
  String get puzzleGoodMove => 'Bra drag';

  @override
  String get puzzleBestMove => 'Bästa draget!';

  @override
  String get puzzleKeepGoing => 'Fortsätt…';

  @override
  String get puzzlePuzzleSuccess => 'Rätt!';

  @override
  String get puzzlePuzzleComplete => 'Problemet klart!';

  @override
  String get puzzleByOpenings => 'Efter öppningar';

  @override
  String get puzzlePuzzlesByOpenings => 'Schackproblem efter öppningar';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Öppningar som du spelade mest i rankade partier';

  @override
  String get puzzleUseFindInPage => 'Använd \"Hitta på sida\" i webbläsarmenyn för att hitta din favoritöppning!';

  @override
  String get puzzleUseCtrlF => 'Använd Ctrl+f för att hitta din favoritöppning!';

  @override
  String get puzzleNotTheMove => 'Det är inte rätt drag!';

  @override
  String get puzzleTrySomethingElse => 'Prova något annat.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'gömd';

  @override
  String puzzleFromGameLink(String param) {
    return 'Från parti: $param';
  }

  @override
  String get puzzleContinueTraining => 'Fortsätt träningen';

  @override
  String get puzzleDifficultyLevel => 'Svårighetsgrad';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Lättare';

  @override
  String get puzzleEasiest => 'Lättaste';

  @override
  String get puzzleHarder => 'Svårare';

  @override
  String get puzzleHardest => 'Svåraste';

  @override
  String get puzzleExample => 'Exempel';

  @override
  String get puzzleAddAnotherTheme => 'Lägg till ett annat tema';

  @override
  String get puzzleNextPuzzle => 'Nästa schackproblem';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Hoppa till nästa schackproblem direkt';

  @override
  String get puzzlePuzzleDashboard => 'Meny för schackproblem';

  @override
  String get puzzleImprovementAreas => 'Förbättringsområden';

  @override
  String get puzzleStrengths => 'Styrkor';

  @override
  String get puzzleHistory => 'Historik för schackproblem';

  @override
  String get puzzleSolved => 'löst';

  @override
  String get puzzleFailed => 'olöst';

  @override
  String get puzzleStreakDescription => 'Lös gradvis svårare pussel och bygg en vinstserie. Det finns ingen klocka, så ta din tid. Ett feldrag och spelet är över! Men du kan skippa ett drag per session.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Din vinstserie: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Skippa detta drag för att bevara din vinstserie! Fungerar bara en gång per spel.';

  @override
  String get puzzleContinueTheStreak => 'Fortsätt vinstserien';

  @override
  String get puzzleNewStreak => 'Ny vinstserie';

  @override
  String get puzzleFromMyGames => 'Från mina partier';

  @override
  String get puzzleLookupOfPlayer => 'Leta upp schackproblem från en spelares partier';

  @override
  String puzzleFromXGames(String param) {
    return 'Pussel från ${param}s spel';
  }

  @override
  String get puzzleSearchPuzzles => 'Sök schackproblem';

  @override
  String get puzzleFromMyGamesNone => 'Du har inga schackproblem i databasen, men Lichess tycker om dig väldigt mycket ändå.\nSpela snabbschack och klassiska partier för att öka dina chanser att få ett av dina schackproblem tillagt!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 schackproblem hittade i $param2 partier';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Träna, analysera, förbättra';

  @override
  String puzzlePercentSolved(String param) {
    return '$param lösta';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Ingenting att visa, gå och lös några problem först!';

  @override
  String get puzzleImprovementAreasDescription => 'Öva på dessa för att optimera dina framsteg!';

  @override
  String get puzzleStrengthDescription => 'Du presterar bäst i dessa teman';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spelat $count gånger',
      one: 'Spelat $count gånger',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poäng under ditt pusselbetyg',
      one: 'En poäng under ditt pusselbetyg',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poäng över ditt pusselbetyg',
      one: 'En poäng över ditt pusselbetyg',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelade',
      one: '$count spelad',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count att spela om',
      one: '$count att spela om',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Avancerande bonde';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'En bonde som promoverar eller hotar att promovera är nyckeln till taktiken.';

  @override
  String get puzzleThemeAdvantage => 'Fördel';

  @override
  String get puzzleThemeAdvantageDescription => 'Ta chansen att få en avgörande fördel. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasias matt';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'En springare samarbetar med ett torn eller en dam för att fånga motståndarkungen mellan kanten på brädet och en vänlig pjäs.';

  @override
  String get puzzleThemeArabianMate => 'Arabisk matt';

  @override
  String get puzzleThemeArabianMateDescription => 'En springare och ett torn samarbetar för att fånga motståndarkungen i ett hörn av brädet.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Attackera f2 eller f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'En attack som fokuserar på f2 eller f7 bonden, som i stekt leveröppning.';

  @override
  String get puzzleThemeAttraction => 'Attraktion';

  @override
  String get puzzleThemeAttractionDescription => 'Ett byte eller offer som inbjuder eller tvingar motståndarens pjäs till en ruta som ger möjlighet till fler taktiska finesser.';

  @override
  String get puzzleThemeBackRankMate => 'Plaskmatt';

  @override
  String get puzzleThemeBackRankMateDescription => 'Schackmatta kungen på första raden, när den är instängd av sina egna pjäser.';

  @override
  String get puzzleThemeBishopEndgame => 'Löparslutspel';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Ett slutspel med bara löpare och bönder.';

  @override
  String get puzzleThemeBodenMate => 'Bodens matt';

  @override
  String get puzzleThemeBodenMateDescription => 'Två attackerande löpare på korsande diagonaler sätter en kung som är blockerad av egna pjäser i matt.';

  @override
  String get puzzleThemeCastling => 'Rockad';

  @override
  String get puzzleThemeCastlingDescription => 'För din kung i säkerhet, och använd ditt torn till att angripa.';

  @override
  String get puzzleThemeCapturingDefender => 'Ta försvararen';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Ta en pjäs som försvarar en annan pjäs, så att du kan ta den nu oförsvarade pjäsen i nästa drag.';

  @override
  String get puzzleThemeCrushing => 'Krossande';

  @override
  String get puzzleThemeCrushingDescription => 'Upptäck motståndares blunder för att få en förkrossande fördel. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Matt med två löpare';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Två attackerande löpare på intilligande diagonaler sätter en kung som är blockerad av egna pjäser i matt.';

  @override
  String get puzzleThemeDovetailMate => 'Cozios matt';

  @override
  String get puzzleThemeDovetailMateDescription => 'En dam levererar matt till en närliggande kung, vars enda två flyktrutor blockeras av egna pjäser.';

  @override
  String get puzzleThemeEquality => 'Utjämning';

  @override
  String get puzzleThemeEqualityDescription => 'Kom tillbaka från en förlorad position och säkra en remi eller en utjämnad position. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Kungsflygelattack';

  @override
  String get puzzleThemeKingsideAttackDescription => 'En attack mot motståndarens kung, efter att de rockerat på kungsflygeln.';

  @override
  String get puzzleThemeClearance => 'Rensning';

  @override
  String get puzzleThemeClearanceDescription => 'Ett drag, ofta med tempo, som rensar en ruta, linje eller diagonal för en uppföljande taktisk idé.';

  @override
  String get puzzleThemeDefensiveMove => 'Defensivt drag';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Ett exakt drag eller sekvens av drag som är nödvändiga för att undvika att förlora material eller annan fördel.';

  @override
  String get puzzleThemeDeflection => 'Avledande drag';

  @override
  String get puzzleThemeDeflectionDescription => 'Ett drag som avleder en motståndarpjäs från en annan uppgift, såsom att bevaka en viktig ruta. Kallas Ibland också \"överbelastning\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Avdragsattack';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Flytta en pjäs som tidigare blockerade en attack från en annan pjäs med lång räckvidd, såsom en springare ur vägen för ett torn.';

  @override
  String get puzzleThemeDoubleCheck => 'Dubbelschack';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Schack med två pjäser i samma drag, som ett resultat av avdragsattack (avdragsschack) där både den rörliga pjäsen och den avtäckta pjäsen attackerar motståndarens kung.';

  @override
  String get puzzleThemeEndgame => 'Slutspel';

  @override
  String get puzzleThemeEndgameDescription => 'En taktik under spelets sista fas.';

  @override
  String get puzzleThemeEnPassantDescription => 'En taktik som involverar \"en passant\"-regeln, där en bonde kan slå en bonde som har passerat den med ett tvåstegsdrag.';

  @override
  String get puzzleThemeExposedKing => 'Oskyddad kung';

  @override
  String get puzzleThemeExposedKingDescription => 'En taktik som involverar en kung med få försvarare runt omkring sig, leder ofta till schack matt.';

  @override
  String get puzzleThemeFork => 'Gaffel';

  @override
  String get puzzleThemeForkDescription => 'Ett drag där den rörda pjäsen attackerar två motståndarpjäser samtidigt.';

  @override
  String get puzzleThemeHangingPiece => 'Ogarderad pjäs';

  @override
  String get puzzleThemeHangingPieceDescription => 'En taktik som drar fördel av att en motståndares pjäs är oförsvarad eller otillräckligt försvarad och fri att slå.';

  @override
  String get puzzleThemeHookMate => 'Krokmatt';

  @override
  String get puzzleThemeHookMateDescription => 'Schackmatta med ett torn, en springare och en bonde tillsammans med en motståndarbonde för att begränsa motståndarkungens undanflykt.';

  @override
  String get puzzleThemeInterference => 'Interference';

  @override
  String get puzzleThemeInterferenceDescription => 'Placerar en pjäs mellan två motståndares pjäser för att lämna en eller båda motståndarpjäserna ogarderade, till exempel springare på en garderad ruta mellan två torn.';

  @override
  String get puzzleThemeIntermezzo => 'Mellandrag';

  @override
  String get puzzleThemeIntermezzoDescription => 'Istället för att spela det förväntade draget, görs ett annat drag som utgör ett omedelbart hot som motståndaren måste svara på. Även känt som \"zwischenzug\" eller \"intermezzo\".';

  @override
  String get puzzleThemeKnightEndgame => 'Springareslutspel';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Ett slutspel med bara springare och bönder.';

  @override
  String get puzzleThemeLong => 'Långa schackproblem';

  @override
  String get puzzleThemeLongDescription => 'Tre drag för att vinna.';

  @override
  String get puzzleThemeMaster => 'Mästarpartier';

  @override
  String get puzzleThemeMasterDescription => 'Schackproblem från partier som spelats av spelare med mästartitel.';

  @override
  String get puzzleThemeMasterVsMaster => 'Mästare mot mästare partier';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Schackproblem från partier som spelats av två spelare med mästartitel.';

  @override
  String get puzzleThemeMate => 'Matt';

  @override
  String get puzzleThemeMateDescription => 'Vinn partiet med stil.';

  @override
  String get puzzleThemeMateIn1 => 'Matt i 1 drag';

  @override
  String get puzzleThemeMateIn1Description => 'Gör schackmatt i ett drag.';

  @override
  String get puzzleThemeMateIn2 => 'Matt i 2 drag';

  @override
  String get puzzleThemeMateIn2Description => 'Gör schackmatt i två drag.';

  @override
  String get puzzleThemeMateIn3 => 'Matt i 3 drag';

  @override
  String get puzzleThemeMateIn3Description => 'Gör schackmatt i tre drag.';

  @override
  String get puzzleThemeMateIn4 => 'Matt i 4 drag';

  @override
  String get puzzleThemeMateIn4Description => 'Gör schackmatt i fyra drag.';

  @override
  String get puzzleThemeMateIn5 => 'Matt i 5 eller fler drag';

  @override
  String get puzzleThemeMateIn5Description => 'Räkna ut en lång schackmattsekvens.';

  @override
  String get puzzleThemeMiddlegame => 'Mittspel';

  @override
  String get puzzleThemeMiddlegameDescription => 'En taktik under spelets andra fas.';

  @override
  String get puzzleThemeOneMove => 'Schackproblem med bara ett drag';

  @override
  String get puzzleThemeOneMoveDescription => 'Ett schackproblem som bara är ett drag långt.';

  @override
  String get puzzleThemeOpening => 'Öppning';

  @override
  String get puzzleThemeOpeningDescription => 'En taktik under spelets första fas.';

  @override
  String get puzzleThemePawnEndgame => 'Bondeslutspel';

  @override
  String get puzzleThemePawnEndgameDescription => 'Ett slutspel med endast bönder.';

  @override
  String get puzzleThemePin => 'Fastlåsning';

  @override
  String get puzzleThemePinDescription => 'En taktik som involverar fastlåsning, där en attackerad pjäs inte kan flyttas utan att exponera en mer värdefull pjäs.';

  @override
  String get puzzleThemePromotion => 'Promovering';

  @override
  String get puzzleThemePromotionDescription => 'En taktik som bygger på en bonde som förvandlas eller hotar att förvandlas.';

  @override
  String get puzzleThemeQueenEndgame => 'Damslutspel';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Ett slutspel med endast dam och bönder.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dam och torn';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Ett slutspel med endast damer, torn och bönder.';

  @override
  String get puzzleThemeQueensideAttack => 'Damflygelattack';

  @override
  String get puzzleThemeQueensideAttackDescription => 'En attack mot motståndarens kung, efter att motståndaren gjort kort rockad.';

  @override
  String get puzzleThemeQuietMove => 'Tyst drag';

  @override
  String get puzzleThemeQuietMoveDescription => 'Ett drag som inte gör en schackar eller slår, men förbereder ett oundvikligt hot för ett senare drag.';

  @override
  String get puzzleThemeRookEndgame => 'Tornslutspel';

  @override
  String get puzzleThemeRookEndgameDescription => 'Ett slutspel med endast torn och bönder.';

  @override
  String get puzzleThemeSacrifice => 'Offer';

  @override
  String get puzzleThemeSacrificeDescription => 'En taktik som innebär att man ger upp material på kort sikt, för att vinna en fördel efter en tvingande sekvens av drag.';

  @override
  String get puzzleThemeShort => 'Kort schackproblem';

  @override
  String get puzzleThemeShortDescription => 'Två drag för att vinna.';

  @override
  String get puzzleThemeSkewer => 'Dolk';

  @override
  String get puzzleThemeSkewerDescription => 'En taktik som innebär att en värdefull pjäs attackeras för att tvinga bort den från en pjäs bakom som då kan slås eller attackeras. Motsatsen till fastlåsning.';

  @override
  String get puzzleThemeSmotheredMate => 'Kvävmatt';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Schack matt av en springare där den schackade kungen inte kan röra sig eftersom den är instängd (eller kvävd) av sina egna pjäser.';

  @override
  String get puzzleThemeSuperGM => 'Super GM-partier';

  @override
  String get puzzleThemeSuperGMDescription => 'Schackproblem från partier spelade av de bästa spelarna i världen.';

  @override
  String get puzzleThemeTrappedPiece => 'Fångad pjäs';

  @override
  String get puzzleThemeTrappedPieceDescription => 'En pjäs kan inte komma undan eftersom den inte kan flytta till någon bra ruta.';

  @override
  String get puzzleThemeUnderPromotion => 'Underpromovering';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Förvandling till springare, löpare eller torn.';

  @override
  String get puzzleThemeVeryLong => 'Mycket långa schackproblem';

  @override
  String get puzzleThemeVeryLongDescription => 'Fyra eller fler drag för att vinna.';

  @override
  String get puzzleThemeXRayAttack => 'Röntgenattack';

  @override
  String get puzzleThemeXRayAttackDescription => 'En pjäs attackerar eller försvarar en ruta, genom en motståndarpjäs.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Motspelaren har begränsat antal möjliga drag, och alla möjliga drag förvärrar motspelarens position.';

  @override
  String get puzzleThemeMix => 'Blandad kompott';

  @override
  String get puzzleThemeMixDescription => 'Lite av varje. Du vet inte vad som kommer, så du behöver vara redo för allt! Precis som i riktiga partier.';

  @override
  String get puzzleThemePlayerGames => 'Spelarspel';

  @override
  String get puzzleThemePlayerGamesDescription => 'Hitta pussel genererade från dina egna parti, eller från andra spelares parti.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Dessa pussel tillhör den allmänna egendomen, och kan laddas ner från $param.';
  }

  @override
  String get searchSearch => 'Sök';

  @override
  String get settingsSettings => 'Inställningar';

  @override
  String get settingsCloseAccount => 'Avsluta konto';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Ditt konto hanteras och kan inte stängas.';

  @override
  String get settingsClosingIsDefinitive => 'Stängningen är definitiv, det finns ingen återvändo. Är du säker?';

  @override
  String get settingsCantOpenSimilarAccount => 'Du får inte öppna ett nytt konto med samma namn, även om du byter gemener till versaler eller tvärtom.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Jag ändrade mig, avsluta inte mitt konto';

  @override
  String get settingsCloseAccountExplanation => 'Är du säker på att du vill avsluta ditt konto? Att avsluta ditt konto är ett permanent beslut. Du kommer ALDRIG kunna logga in NÅGONSIN IGEN.';

  @override
  String get settingsThisAccountIsClosed => 'Det här kontot är avslutat';

  @override
  String get playWithAFriend => 'Spela med en vän';

  @override
  String get playWithTheMachine => 'Spela mot datorn';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'För att bjuda in någon att spela, ge dem den här länken';

  @override
  String get gameOver => 'Partiet är slut';

  @override
  String get waitingForOpponent => 'Väntar på motståndare';

  @override
  String get orLetYourOpponentScanQrCode => 'Eller låt din motståndare skanna denna QR-kod';

  @override
  String get waiting => 'Väntar';

  @override
  String get yourTurn => 'Din tur';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 nivå $param2';
  }

  @override
  String get level => 'Nivå';

  @override
  String get strength => 'Styrka';

  @override
  String get toggleTheChat => 'Dölj/visa chattrutan';

  @override
  String get chat => 'Chatta';

  @override
  String get resign => 'Ge upp';

  @override
  String get checkmate => 'Schackmatt';

  @override
  String get stalemate => 'Patt';

  @override
  String get white => 'Vit';

  @override
  String get black => 'Svart';

  @override
  String get asWhite => 'som vit';

  @override
  String get asBlack => 'som svart';

  @override
  String get randomColor => 'Slumpvis färg';

  @override
  String get createAGame => 'Skapa ett parti';

  @override
  String get whiteIsVictorious => 'Vit har vunnit';

  @override
  String get blackIsVictorious => 'Svart har vunnit';

  @override
  String get youPlayTheWhitePieces => 'Du spelar med de vita pjäserna';

  @override
  String get youPlayTheBlackPieces => 'Du spelar med de svarta pjäserna';

  @override
  String get itsYourTurn => 'Det är din tur!';

  @override
  String get cheatDetected => 'Fusk upptäckt';

  @override
  String get kingInTheCenter => 'Kungen är i centrum';

  @override
  String get threeChecks => 'Tre schackar';

  @override
  String get raceFinished => 'Lopp slut';

  @override
  String get variantEnding => 'Variantbaserat slut';

  @override
  String get newOpponent => 'Ny motståndare';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Din motståndare vill spela ett nytt parti med dig';

  @override
  String get joinTheGame => 'Starta partiet';

  @override
  String get whitePlays => 'Vits drag';

  @override
  String get blackPlays => 'Svarts drag';

  @override
  String get opponentLeftChoices => 'Motståndaren har kanske lämnat partiet. Du kan begära vinst, remi eller invänta att motståndaren kommer tillbaka.';

  @override
  String get forceResignation => 'Begär vinst';

  @override
  String get forceDraw => 'Begär remi';

  @override
  String get talkInChat => 'Vänligen uppträd trevligt i chatten!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Den första som använder den här länken kommer att spela med dig.';

  @override
  String get whiteResigned => 'Vit har gett upp';

  @override
  String get blackResigned => 'Svart har gett upp';

  @override
  String get whiteLeftTheGame => 'Vit har lämnat partiet';

  @override
  String get blackLeftTheGame => 'Svart har lämnat partiet';

  @override
  String get whiteDidntMove => 'Vit flyttade inte';

  @override
  String get blackDidntMove => 'Vit flyttade inte';

  @override
  String get requestAComputerAnalysis => 'Begär datoranalys';

  @override
  String get computerAnalysis => 'Datoranalys';

  @override
  String get computerAnalysisAvailable => 'Datoranalys tillgänglig';

  @override
  String get computerAnalysisDisabled => 'Datoranalys otillgänglig';

  @override
  String get analysis => 'Analysbräde';

  @override
  String depthX(String param) {
    return 'Djup $param';
  }

  @override
  String get usingServerAnalysis => 'Använder serveranalys';

  @override
  String get loadingEngine => 'Laddar schackmotor...';

  @override
  String get calculatingMoves => 'Beräknar drag...';

  @override
  String get engineFailed => 'Fel vid laddning av schackmotor';

  @override
  String get cloudAnalysis => 'Molnanalys';

  @override
  String get goDeeper => 'Sök djupare';

  @override
  String get showThreat => 'Visa hot';

  @override
  String get inLocalBrowser => 'i lokal webbläsare';

  @override
  String get toggleLocalEvaluation => 'Lokal analys av/på';

  @override
  String get promoteVariation => 'Höj upp variant';

  @override
  String get makeMainLine => 'Gör till huvudvariant';

  @override
  String get deleteFromHere => 'Radera härifrån';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Visa som variant';

  @override
  String get copyVariationPgn => 'Kopiera variations-PGN';

  @override
  String get move => 'Drag';

  @override
  String get variantLoss => 'Variantförlust';

  @override
  String get variantWin => 'Variantvinst';

  @override
  String get insufficientMaterial => 'Otillräckligt material';

  @override
  String get pawnMove => 'Bondedrag';

  @override
  String get capture => 'Slag';

  @override
  String get close => 'Stäng';

  @override
  String get winning => 'Vinner';

  @override
  String get losing => 'Förlorar';

  @override
  String get drawn => 'Remi';

  @override
  String get unknown => 'Okänd';

  @override
  String get database => 'Databas';

  @override
  String get whiteDrawBlack => 'Vit / Remi / Svart';

  @override
  String averageRatingX(String param) {
    return 'Medelrating: $param';
  }

  @override
  String get recentGames => 'Senaste partier';

  @override
  String get topGames => 'Toppartier';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Två miljoner schackpartier, spelade över ett fysiskt bräde, av $param1+ Elo-rankade spelare från $param2 till $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" med avrundning, baserat på antalet halvdrag till nästa slag eller bondedrag';

  @override
  String get noGameFound => 'Inget parti hittades';

  @override
  String get maxDepthReached => 'Maxdjup nått!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Överväg att ändra inställningarna för att inkludera fler partier.';

  @override
  String get openings => 'Öppningar';

  @override
  String get openingExplorer => 'Öppningsbok';

  @override
  String get openingEndgameExplorer => 'Öppning-/slutspelsutforskare';

  @override
  String xOpeningExplorer(String param) {
    return '$param öppningsutforskare';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Spela första drag från öppnings-/slutspelsutforskaren';

  @override
  String get winPreventedBy50MoveRule => 'Vinst förhindrad genom 50-dragsregeln';

  @override
  String get lossSavedBy50MoveRule => 'Förlust förhindrad genom 50-dragsregeln';

  @override
  String get winOr50MovesByPriorMistake => 'Vinst eller 50 drag på grund av tidigare misstag';

  @override
  String get lossOr50MovesByPriorMistake => 'Förlust eller 50 drag på grund av tidigare misstag';

  @override
  String get unknownDueToRounding => 'Vinst/förlust är endast garanterad om den rekommenderade öppningsboksvarianten har följts sedan senaste slag eller bondedrag, på grund av möjlig avrundning av DTZ värde i Syzygyöppningsböcker.';

  @override
  String get allSet => 'Klart!';

  @override
  String get importPgn => 'Importera PGN';

  @override
  String get delete => 'Ta bort';

  @override
  String get deleteThisImportedGame => 'Ta bort detta importerade parti?';

  @override
  String get replayMode => 'Uppspelningsläge';

  @override
  String get realtimeReplay => 'Realtid';

  @override
  String get byCPL => 'CPL';

  @override
  String get enable => 'Aktivera';

  @override
  String get bestMoveArrow => 'Pil som anger bästa drag';

  @override
  String get showVariationArrows => 'Visa variationspilar';

  @override
  String get evaluationGauge => 'Utvärderingsmätare';

  @override
  String get multipleLines => 'Flera linjer';

  @override
  String get cpus => 'Processorer';

  @override
  String get memory => 'Minne';

  @override
  String get infiniteAnalysis => 'Oändlig analys';

  @override
  String get removesTheDepthLimit => 'Tar bort sökdjupsbegränsningen och håller datorn varm';

  @override
  String get blunder => 'Blunder';

  @override
  String get mistake => 'Misstag';

  @override
  String get inaccuracy => 'Felaktighet';

  @override
  String get moveTimes => 'Dragtider';

  @override
  String get flipBoard => 'Vänd brädet';

  @override
  String get threefoldRepetition => 'Trefaldig upprepning';

  @override
  String get claimADraw => 'Begär remi';

  @override
  String get offerDraw => 'Föreslå remi';

  @override
  String get draw => 'Remi';

  @override
  String get drawByMutualAgreement => 'Remi genom ömsesidig överenskommelse';

  @override
  String get fiftyMovesWithoutProgress => 'Femtio drag utan framsteg';

  @override
  String get currentGames => 'Pågående partier';

  @override
  String get viewInFullSize => 'Visa i full storlek';

  @override
  String get logOut => 'Logga ut';

  @override
  String get signIn => 'Logga in';

  @override
  String get rememberMe => 'Håll mig inloggad';

  @override
  String get youNeedAnAccountToDoThat => 'Du behöver ett konto för att göra detta';

  @override
  String get signUp => 'Registrera dig';

  @override
  String get computersAreNotAllowedToPlay => 'Datorer och datorassisterade spelare tillåts inte spela. Vänligen, ta inte hjälp ifrån schackmotorer, databaser eller från andra spelare när du spelar. Notera även att skapande av flera konton avrådes och skapande av överdrivet många konton leder till avstängning.';

  @override
  String get games => 'Partier';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 skrev i forumtråden $param2';
  }

  @override
  String get latestForumPosts => 'Senaste foruminläggen';

  @override
  String get players => 'Spelare';

  @override
  String get friends => 'Vänner';

  @override
  String get otherPlayers => 'other players';

  @override
  String get discussions => 'Konversationer';

  @override
  String get today => 'Idag';

  @override
  String get yesterday => 'Igår';

  @override
  String get minutesPerSide => 'Minuter per spelare';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Varianter';

  @override
  String get timeControl => 'Tidskontroll';

  @override
  String get realTime => 'Realtid';

  @override
  String get correspondence => 'Korrespondens';

  @override
  String get daysPerTurn => 'Dagar per drag';

  @override
  String get oneDay => 'En dag';

  @override
  String get time => 'Tid';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Ratingstatistik';

  @override
  String get username => 'Användarnamn';

  @override
  String get usernameOrEmail => 'Användarnamn eller e-post';

  @override
  String get changeUsername => 'Byt användarnamn';

  @override
  String get changeUsernameNotSame => 'Bara storleken på bokstäver kan ändras. Till exempel \"anderssvensson\" till \"AndersSvenson\".';

  @override
  String get changeUsernameDescription => 'Ändra ditt användarnamn. Detta kan bara göras en gång och det är endast tillåtet att ändra skiftläget för bokstäverna i ditt användarnamn.';

  @override
  String get signupUsernameHint => 'Se till att välja ett familjevänligt användarnamn. Du kan inte ändra det senare och alla konton med olämpliga användarnamn kommer att stängas!';

  @override
  String get signupEmailHint => 'Vi kommer endast att använda den för att återställa lösenordet.';

  @override
  String get password => 'Lösenord';

  @override
  String get changePassword => 'Byt lösenord';

  @override
  String get changeEmail => 'Ändra e-postadress';

  @override
  String get email => 'E-post';

  @override
  String get passwordReset => 'Återställ lösenord';

  @override
  String get forgotPassword => 'Glömt lösenordet?';

  @override
  String get error_weakPassword => 'Detta lösenord är extremt vanligt, och alltför lätt att gissa.';

  @override
  String get error_namePassword => 'Använd inte ditt användarnamn som lösenord.';

  @override
  String get blankedPassword => 'Du har använt samma lösenord på en annan hemsida, och den hemsidan har blivit hackad. För att säkra ditt Lichesskonto måste du välja ett nytt lösenord. Tack för din förståelse.';

  @override
  String get youAreLeavingLichess => 'Du lämnar Lichess';

  @override
  String get neverTypeYourPassword => 'Skriv aldrig ditt Lichess-lösenord på en annan webbplats!';

  @override
  String proceedToX(String param) {
    return 'Gå vidare till $param';
  }

  @override
  String get passwordSuggestion => 'Ange inte ett lösenord som föreslagits av någon annan. De kommer att använda det för att stjäla ditt konto.';

  @override
  String get emailSuggestion => 'Ange inte en e-postadress som föreslagits av någon annan. De kommer att använda den för att stjäla ditt konto.';

  @override
  String get emailConfirmHelp => 'Hjälp med e-postbekräftelse';

  @override
  String get emailConfirmNotReceived => 'Har du inte fått din e-postbekräftelse efter att du registrerade dig?';

  @override
  String get whatSignupUsername => 'Vilket användarnamn använde du för att registrera dig?';

  @override
  String usernameNotFound(String param) {
    return 'Vi kunde inte hitta någon användare med namnet: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Du kan använda detta användarnamn för att skapa ett nytt konto';

  @override
  String emailSent(String param) {
    return 'Vi har skickat ett mejl till $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Det kan ta en stund för det att komma.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Vänta 5 minuter och uppdatera din inkorg.';

  @override
  String get checkSpamFolder => 'Kontrollera även din skräppost, det kan hamna där. I så fall, markera det som ej skräppost.';

  @override
  String get emailForSignupHelp => 'Om allt annat misslyckas, skicka oss denna mejl:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopiera och klistra in den ovanstående texten och skicka den till $param';
  }

  @override
  String get waitForSignupHelp => 'Vi återkopplar snart och hjälper dig slutföra din registrering.';

  @override
  String accountConfirmed(String param) {
    return 'Användaren $param är bekräftad.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Du kan nu logga in som $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Du behöver inte en e-postbekräftelse.';

  @override
  String accountClosed(String param) {
    return 'Kontot $param är stängt.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Kontot $param registrerades utan e-post.';
  }

  @override
  String get rank => 'Rankning';

  @override
  String rankX(String param) {
    return 'Placering: $param';
  }

  @override
  String get gamesPlayed => 'Partier spelade';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Avbryt';

  @override
  String get whiteTimeOut => 'Vits tid är slut';

  @override
  String get blackTimeOut => 'Svarts tid är slut';

  @override
  String get drawOfferSent => 'Remierbjudande skickat';

  @override
  String get drawOfferAccepted => 'Remierbjudande accepterat';

  @override
  String get drawOfferCanceled => 'Remierbjudande avbrutet';

  @override
  String get whiteOffersDraw => 'Vit erbjuder remi';

  @override
  String get blackOffersDraw => 'Svart erbjuder remi';

  @override
  String get whiteDeclinesDraw => 'Vit avböjer remi';

  @override
  String get blackDeclinesDraw => 'Svart avböjer remi';

  @override
  String get yourOpponentOffersADraw => 'Din motståndare erbjuder remi';

  @override
  String get accept => 'Acceptera';

  @override
  String get decline => 'Avböj';

  @override
  String get playingRightNow => 'Spelas just nu';

  @override
  String get eventInProgress => 'Spelas just nu';

  @override
  String get finished => 'Slut';

  @override
  String get abortGame => 'Avbryt partiet';

  @override
  String get gameAborted => 'Partiet avbröts';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Obegränsad';

  @override
  String get mode => 'Läge';

  @override
  String get casual => 'Ej rankat';

  @override
  String get rated => 'Rankat';

  @override
  String get casualTournament => 'Ej rankad';

  @override
  String get ratedTournament => 'Rankad';

  @override
  String get thisGameIsRated => 'Detta parti är rankat';

  @override
  String get rematch => 'Returmatch';

  @override
  String get rematchOfferSent => 'Erbjudande om returmatch skickat';

  @override
  String get rematchOfferAccepted => 'Erbjudande om returmatch accepterat';

  @override
  String get rematchOfferCanceled => 'Förfrågan om returmatch tillbakadragen';

  @override
  String get rematchOfferDeclined => 'Erbjudande om returmatch avböjt';

  @override
  String get cancelRematchOffer => 'Dra tillbaka förfrågan om returmatch';

  @override
  String get viewRematch => 'Visa returmatch';

  @override
  String get confirmMove => 'Bekräfta drag';

  @override
  String get play => 'Spela';

  @override
  String get inbox => 'Inkorg';

  @override
  String get chatRoom => 'Chattrum';

  @override
  String get loginToChat => 'Logga in för att chatta';

  @override
  String get youHaveBeenTimedOut => 'Du har fått en timeout.';

  @override
  String get spectatorRoom => 'Åskådarrum';

  @override
  String get composeMessage => 'Skriv meddelande';

  @override
  String get subject => 'Ämne';

  @override
  String get send => 'Skicka';

  @override
  String get incrementInSeconds => 'Tilläggssekunder';

  @override
  String get freeOnlineChess => 'Gratis schack på internet';

  @override
  String get exportGames => 'Exportera partier';

  @override
  String get ratingRange => 'Ratingomfång';

  @override
  String get thisAccountViolatedTos => 'Detta konto bröt mot användarvillkoren för Lichess';

  @override
  String get openingExplorerAndTablebase => 'Öppningsutforskare & slutspelsteori';

  @override
  String get takeback => 'Gör om drag';

  @override
  String get proposeATakeback => 'Fråga om du får göra om draget';

  @override
  String get takebackPropositionSent => 'Förslag att göra om draget skickat';

  @override
  String get takebackPropositionDeclined => 'Förslag att göra om draget nekat';

  @override
  String get takebackPropositionAccepted => 'Förslag att göra om draget godkänt';

  @override
  String get takebackPropositionCanceled => 'Förslag att göra om draget har dragits tillbaka';

  @override
  String get yourOpponentProposesATakeback => 'Din motståndare vill göra om det senaste draget';

  @override
  String get bookmarkThisGame => 'Bokmärk detta parti';

  @override
  String get tournament => 'Turnering';

  @override
  String get tournaments => 'Turneringar';

  @override
  String get tournamentPoints => 'Turneringspoäng';

  @override
  String get viewTournament => 'Visa turnering';

  @override
  String get backToTournament => 'Tillbaka till turnering';

  @override
  String get noDrawBeforeSwissLimit => 'Ni kan inte ta remi innan drag 30 i en schweizer-turnering.';

  @override
  String get thematic => 'Tema';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Din ${param}rating är provisorisk';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Din rating i $param1 är för hög ($param2)';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Din topprating denna vecka i $param1 är för hög ($param2)';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Din rating i $param1 är för låg ($param2)';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Rankad ≥ $param1 i $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rankad ≤ $param1 i $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Du måste vara medlem i $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Du är inte medlem i $param';
  }

  @override
  String get backToGame => 'Tillbaka till partiet';

  @override
  String get siteDescription => 'Gratis Schack på internet. Spela Schack nu, med ett enkelt gränssnitt. Ingen registrering, inga annonser, inga insticksprogram behövs. Spela schack mot datorn, vänner eller vem som helst.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 gick med i lag $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 skapade lag $param2';
  }

  @override
  String get startedStreaming => 'började strömma';

  @override
  String xStartedStreaming(String param) {
    return '$param började sända video';
  }

  @override
  String get averageElo => 'Medelrating';

  @override
  String get location => 'Plats';

  @override
  String get filterGames => 'Filtrera partier';

  @override
  String get reset => 'Återställ';

  @override
  String get apply => 'Använd';

  @override
  String get save => 'Spara';

  @override
  String get leaderboard => 'Topplista';

  @override
  String get screenshotCurrentPosition => 'Ta en skärmdump på den aktuella positionen';

  @override
  String get gameAsGIF => 'Spara som GIF';

  @override
  String get pasteTheFenStringHere => 'Klistra in FEN-koden här';

  @override
  String get pasteThePgnStringHere => 'Klistra in PGN-koden här';

  @override
  String get orUploadPgnFile => 'Eller ladda upp en PGN-fil';

  @override
  String get fromPosition => 'Från position';

  @override
  String get continueFromHere => 'Fortsätt härifrån';

  @override
  String get toStudy => 'Studera';

  @override
  String get importGame => 'Importera parti';

  @override
  String get importGameExplanation => 'Klistra in ett partis PGN-kod så får du en bläddringsbar uppspelning, en datoranalys, en spel-chatt och en delbar URL.';

  @override
  String get importGameCaveat => 'Variationer kommer att raderas. För att behålla dem, importera PGN:en via en studie.';

  @override
  String get importGameDataPrivacyWarning => 'Denna PGN kan nås av allmänheten. För att importera ett parti privat, använd en studie.';

  @override
  String get thisIsAChessCaptcha => 'Detta är en schack-CAPTCHA';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klicka på brädet och gör ditt drag för att bevisa att du är en människa.';

  @override
  String get captcha_fail => 'Vänligen lös schack-captchan.';

  @override
  String get notACheckmate => 'Inte schackmatt';

  @override
  String get whiteCheckmatesInOneMove => 'Vit gör schackmatt på ett drag';

  @override
  String get blackCheckmatesInOneMove => 'Svart gör schackmatt på ett drag';

  @override
  String get retry => 'Försök igen';

  @override
  String get reconnecting => 'Återansluter';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Favoritmotståndare';

  @override
  String get follow => 'Följ';

  @override
  String get following => 'Följer';

  @override
  String get unfollow => 'Sluta följa';

  @override
  String followX(String param) {
    return 'Följ $param';
  }

  @override
  String unfollowX(String param) {
    return 'Sluta följa $param';
  }

  @override
  String get block => 'Blockera';

  @override
  String get blocked => 'Blockerad';

  @override
  String get unblock => 'Avblockera';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 började följa $param2';
  }

  @override
  String get more => 'Visa mer';

  @override
  String get memberSince => 'Medlem sedan';

  @override
  String lastSeenActive(String param) {
    return 'Senast aktiv $param';
  }

  @override
  String get player => 'Spelare';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Graf';

  @override
  String get required => 'Obligatoriskt.';

  @override
  String get openTournaments => 'Öppna turneringar';

  @override
  String get duration => 'Varaktighet';

  @override
  String get winner => 'Vinnare';

  @override
  String get standing => 'Ställning';

  @override
  String get createANewTournament => 'Skapa en ny turnering';

  @override
  String get tournamentCalendar => 'Turneringskalender';

  @override
  String get conditionOfEntry => 'Inträdesvillkor:';

  @override
  String get advancedSettings => 'Avancerade inställningar';

  @override
  String get safeTournamentName => 'Välj ett mycket säkert namn för turneringen.';

  @override
  String get inappropriateNameWarning => 'Någonting, om än bara lite, olämpligt skulle kunna få ditt konto att stängas.';

  @override
  String get emptyTournamentName => 'Lämna tom för att namnge turneringen efter en slumpmässig stormästare.';

  @override
  String get makePrivateTournament => 'Gör turneringen privat, och begränsa åtkomst med ett lösenord';

  @override
  String get join => 'Delta';

  @override
  String get withdraw => 'Lämna';

  @override
  String get points => 'Poäng';

  @override
  String get wins => 'Vinster';

  @override
  String get losses => 'Förluster';

  @override
  String get createdBy => 'Skapad av';

  @override
  String get tournamentIsStarting => 'Turneringen startar';

  @override
  String get tournamentPairingsAreNowClosed => 'Turneringsparningarna är nu avslutade.';

  @override
  String standByX(String param) {
    return '$param, vänta, parar spelare, var redo!';
  }

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Fortsätt';

  @override
  String get youArePlaying => 'Du spelar!';

  @override
  String get winRate => 'Vinstfrekvens';

  @override
  String get berserkRate => 'Berserkfrekvens';

  @override
  String get performance => 'Prestation';

  @override
  String get tournamentComplete => 'Turneringen avslutad';

  @override
  String get movesPlayed => 'Drag spelade';

  @override
  String get whiteWins => 'Vinster Vit';

  @override
  String get blackWins => 'Vinster Svart';

  @override
  String get drawRate => 'Gräns för remi';

  @override
  String get draws => 'Remier';

  @override
  String nextXTournament(String param) {
    return 'Nästa $param turnering:';
  }

  @override
  String get averageOpponent => 'Genomsnittlig motståndare';

  @override
  String get boardEditor => 'Brädeditor';

  @override
  String get setTheBoard => 'Ställ upp brädet';

  @override
  String get popularOpenings => 'Populära öppningar';

  @override
  String get endgamePositions => 'Slutspelspositioner';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 startposition: $param';
  }

  @override
  String get startPosition => 'Startposition';

  @override
  String get clearBoard => 'Rensa brädet';

  @override
  String get loadPosition => 'Ladda ställning';

  @override
  String get isPrivate => 'Privat';

  @override
  String reportXToModerators(String param) {
    return 'Rapportera $param till moderatorerna';
  }

  @override
  String profileCompletion(String param) {
    return 'Profilfulländning: $param';
  }

  @override
  String xRating(String param) {
    return '${param}rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'Om ingen, lämna tomt';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Ändra profil';

  @override
  String get realName => 'Verkligt namn';

  @override
  String get setFlair => 'Ställ in din flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'Det finns en inställning för att dölja alla användarflairs över hela webbplatsen.';

  @override
  String get biography => 'Biografi';

  @override
  String get countryRegion => 'Land eller region';

  @override
  String get thankYou => 'Tack!';

  @override
  String get socialMediaLinks => 'Länkar till sociala medier';

  @override
  String get oneUrlPerLine => 'En URL per rad.';

  @override
  String get inlineNotation => 'Visa notation';

  @override
  String get makeAStudy => 'För förvaring och delning, överväg att göra en studie.';

  @override
  String get clearSavedMoves => 'Rensa schack drag';

  @override
  String get previouslyOnLichessTV => 'Föregående Lichess-TV';

  @override
  String get onlinePlayers => 'Inloggade spelare';

  @override
  String get activePlayers => 'Mest aktiva spelare';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'OBS! Partiet är rankat men har ingen tidsgräns.';

  @override
  String get success => 'Slutfört';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Fortsätt automatiskt till nästa parti efter att du gjort ett drag';

  @override
  String get autoSwitch => 'Automatiskt partibyte';

  @override
  String get puzzles => 'Schackproblem';

  @override
  String get onlineBots => 'Online-bottar';

  @override
  String get name => 'Namn';

  @override
  String get description => 'Beskrivning';

  @override
  String get descPrivate => 'Privat beskrivning';

  @override
  String get descPrivateHelp => 'Text som endast lagmedlemmarna kommer att se. Om angivet, ersätter den offentliga beskrivningen för lagmedlemmar.';

  @override
  String get no => 'Nej';

  @override
  String get yes => 'Ja';

  @override
  String get website => 'Website';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Hjälp:';

  @override
  String get createANewTopic => 'Skapa ett nytt ämne';

  @override
  String get topics => 'Ämnen';

  @override
  String get posts => 'Inlägg';

  @override
  String get lastPost => 'Senaste inlägget';

  @override
  String get views => 'Visningar';

  @override
  String get replies => 'Svar';

  @override
  String get replyToThisTopic => 'Svara på ämnet';

  @override
  String get reply => 'Svara';

  @override
  String get message => 'Meddelande';

  @override
  String get createTheTopic => 'Skapa ämnet';

  @override
  String get reportAUser => 'Rapportera en användare';

  @override
  String get user => 'Användare';

  @override
  String get reason => 'Anledning';

  @override
  String get whatIsIheMatter => 'Vad är problemet?';

  @override
  String get cheat => 'Fusk';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Annat';

  @override
  String get reportCheatBoostHelp => 'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp => 'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish => 'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink => 'Ange minst en länk till ett spel där användaren fuskade.';

  @override
  String by(String param) {
    return 'av $param';
  }

  @override
  String importedByX(String param) {
    return 'Importerad av $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Det här ämnet är nu stängt.';

  @override
  String get blog => 'Blogg';

  @override
  String get notes => 'Anteckningar';

  @override
  String get typePrivateNotesHere => 'Skriv privata anteckningar här';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Skriv en privat anteckning om den här användaren';

  @override
  String get noNoteYet => 'Ingen anteckning ännu';

  @override
  String get invalidUsernameOrPassword => 'Ogiltigt användarnamn eller lösenord';

  @override
  String get incorrectPassword => 'Felaktigt lösenord';

  @override
  String get invalidAuthenticationCode => 'Ogiltig bekräftelsekod';

  @override
  String get emailMeALink => 'Skicka en länk till min e-post';

  @override
  String get currentPassword => 'Nuvarande lösenord';

  @override
  String get newPassword => 'Nytt lösenord';

  @override
  String get newPasswordAgain => 'Nytt lösenord (igen)';

  @override
  String get newPasswordsDontMatch => 'De nya lösenorden är inte lika';

  @override
  String get newPasswordStrength => 'Lösenordsstyrka';

  @override
  String get clockInitialTime => 'Starttid';

  @override
  String get clockIncrement => 'Tidstillägg';

  @override
  String get privacy => 'Sekretess';

  @override
  String get privacyPolicy => 'Integritetspolicy';

  @override
  String get letOtherPlayersFollowYou => 'Låt andra spelare följa dig';

  @override
  String get letOtherPlayersChallengeYou => 'Låt andra spelare utmana dig';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Låt andra spelare bjuda in dig till studier';

  @override
  String get sound => 'Ljud';

  @override
  String get none => 'Ingen';

  @override
  String get fast => 'Snabb';

  @override
  String get normal => 'Medel';

  @override
  String get slow => 'Långsam';

  @override
  String get insideTheBoard => 'På brädet';

  @override
  String get outsideTheBoard => 'Utanför brädet';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'I långsamma partier';

  @override
  String get always => 'Alltid';

  @override
  String get never => 'Aldrig';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 tävlar i $param2';
  }

  @override
  String get victory => 'Vinst';

  @override
  String get defeat => 'Förlust';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 mot $param2 i $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 mot $param2 i $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 mot $param2 i $param3';
  }

  @override
  String get timeline => 'Tidslinje';

  @override
  String get starting => 'Startar:';

  @override
  String get allInformationIsPublicAndOptional => 'All information är synlig för alla och frivillig.';

  @override
  String get biographyDescription => 'Berätta om dig själv, dina intressen, vad du gillar med schack, dina favoritöppningar, spelare, ...';

  @override
  String get listBlockedPlayers => 'Lista spelare som du blockerat';

  @override
  String get human => 'Människa';

  @override
  String get computer => 'Dator';

  @override
  String get side => 'Sida';

  @override
  String get clock => 'Klocka';

  @override
  String get opponent => 'Motståndare';

  @override
  String get learnMenu => 'Lär dig';

  @override
  String get studyMenu => 'Studier';

  @override
  String get practice => 'Träning';

  @override
  String get community => 'Gemenskap';

  @override
  String get tools => 'Verktyg';

  @override
  String get increment => 'Tidstillägg';

  @override
  String get error_unknown => 'Ogiltigt värde';

  @override
  String get error_required => 'Detta fält är obligatoriskt';

  @override
  String get error_email => 'Den här e-postadressen är ogiltig';

  @override
  String get error_email_acceptable => 'Oacceptabel e-postadress. Var vänlig dubbelkolla den och försök igen.';

  @override
  String get error_email_unique => 'E-postadressen är ogiltig eller upptagen';

  @override
  String get error_email_different => 'Detta är redan din e-postadress';

  @override
  String error_minLength(String param) {
    return 'Måste vara minst $param tecken långt';
  }

  @override
  String error_maxLength(String param) {
    return 'Får vara högst $param tecken lång';
  }

  @override
  String error_min(String param) {
    return 'Måste vara minst $param';
  }

  @override
  String error_max(String param) {
    return 'Måste vara högst $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Om rating är ± $param';
  }

  @override
  String get ifRegistered => 'Om registrerad';

  @override
  String get onlyExistingConversations => 'Endast befintliga konversationer';

  @override
  String get onlyFriends => 'Bara vänner';

  @override
  String get menu => 'Meny';

  @override
  String get castling => 'Rockad';

  @override
  String get whiteCastlingKingside => 'Vit O-O';

  @override
  String get blackCastlingKingside => 'Svart O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Total speltid: $param';
  }

  @override
  String get watchGames => 'Titta på spel';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Total TV-tid: $param';
  }

  @override
  String get watch => 'Titta';

  @override
  String get videoLibrary => 'Videobibliotek';

  @override
  String get streamersMenu => 'Videosändningar';

  @override
  String get mobileApp => 'Mobilapp';

  @override
  String get webmasters => 'Webbmasters';

  @override
  String get about => 'Om Lichess';

  @override
  String aboutX(String param) {
    return 'Om $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 är en gratis ($param2), oberoende och reklamfri schackserver med öppen källkod.';
  }

  @override
  String get really => 'på riktigt';

  @override
  String get contribute => 'Bidra';

  @override
  String get termsOfService => 'Användarvillkor';

  @override
  String get sourceCode => 'Källkod';

  @override
  String get simultaneousExhibitions => 'Simultanschack';

  @override
  String get host => 'Värd';

  @override
  String hostColorX(String param) {
    return 'Värdens färg: $param';
  }

  @override
  String get yourPendingSimuls => 'Dina väntande simuleringar';

  @override
  String get createdSimuls => 'Nyligen skapade simultanmatcher';

  @override
  String get hostANewSimul => 'Skapa ny simultanmatch';

  @override
  String get signUpToHostOrJoinASimul => 'Registrera dig för att vara värd eller gå med i en simulation';

  @override
  String get noSimulFound => 'Denna simultanmatch hittades ej';

  @override
  String get noSimulExplanation => 'Denna simultanmatch existerar inte.';

  @override
  String get returnToSimulHomepage => 'Återvänd till hemsidan för simultan';

  @override
  String get aboutSimul => 'Simultan går ut på att en spelare möter flera spelare samtidigt.';

  @override
  String get aboutSimulImage => 'Av totalt 50 partier vann Fischer 47, spelade två remier och förlorade ett.';

  @override
  String get aboutSimulRealLife => 'Konceptet är taget från verkliga evenemang. I verkligheten involverar det att simultan-värden rör sig från bord till bord för att göra sina drag.';

  @override
  String get aboutSimulRules => 'När simultanmatchen börjar startar varje spelare ett parti med värden som spelar vit i alla partier.  Simultanmatchen slutar när alla partier är avklarade.';

  @override
  String get aboutSimulSettings => 'Simultanpartier är alltid orankade. Returmatch, ångerdrag och \"extratid\" är inaktiverat.';

  @override
  String get create => 'Skapa';

  @override
  String get whenCreateSimul => 'När du skapar en simultan får du spela mot flera spelare samtidigt.';

  @override
  String get simulVariantsHint => 'Om du väljer flera varianter får varje spelare välja vilken de vill spela.';

  @override
  String get simulClockHint => 'Inställningar för fischerklocka. Ju fler spelare du tar dig an, desto mer tid kan du behöva.';

  @override
  String get simulAddExtraTime => 'Du kan lägga till extra tid till dig för att klara av simultanspelet.';

  @override
  String get simulHostExtraTime => 'Värdens extratid';

  @override
  String get simulAddExtraTimePerPlayer => 'Lägg till en starttid på klockan för varje spelare som går med i simultanmatchen.';

  @override
  String get simulHostExtraTimePerPlayer => 'Extratid för värden för varje spelare som deltar';

  @override
  String get lichessTournaments => 'Lichess-turneringar';

  @override
  String get tournamentFAQ => 'Turnering: Vanliga frågor';

  @override
  String get timeBeforeTournamentStarts => 'Tid tills turneringen börjar';

  @override
  String get averageCentipawnLoss => 'Genomsnittligt förlorad hundradelsbonde';

  @override
  String get accuracy => 'Precision';

  @override
  String get keyboardShortcuts => 'Snabbkommandon';

  @override
  String get keyMoveBackwardOrForward => 'bakåtdrag/framåtdrag';

  @override
  String get keyGoToStartOrEnd => 'gå till början/slut';

  @override
  String get keyCycleSelectedVariation => 'Cykla vald variant';

  @override
  String get keyShowOrHideComments => 'visa/göm kommentarer';

  @override
  String get keyEnterOrExitVariation => 'påbörja/avsluta variant';

  @override
  String get keyRequestComputerAnalysis => 'Begär datoranalys, lär av dina misstag';

  @override
  String get keyNextLearnFromYourMistakes => 'Nästa (Lär av dina misstag)';

  @override
  String get keyNextBlunder => 'Nästa blunder';

  @override
  String get keyNextMistake => 'Nästa misstag';

  @override
  String get keyNextInaccuracy => 'Nästa felaktighet';

  @override
  String get keyPreviousBranch => 'Föregående gren';

  @override
  String get keyNextBranch => 'Nästa gren';

  @override
  String get toggleVariationArrows => 'Växla variationspilar';

  @override
  String get cyclePreviousOrNextVariation => 'Cykla föregående/nästa variant';

  @override
  String get toggleGlyphAnnotations => 'Växla glyph-anteckningar';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => 'Variationspilar låter dig navigera utan att använda draglistan.';

  @override
  String get playSelectedMove => 'spela markerat drag';

  @override
  String get newTournament => 'Ny turnering';

  @override
  String get tournamentHomeTitle => 'Schackturnering med olika betänketider och schackvarianter';

  @override
  String get tournamentHomeDescription => 'Spela snabba schackturneringar! Delta i en officiell schemalagd turnering, eller skapa din egen. Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck och fler alternativ erbjuds för ändlösa schacknöjen.';

  @override
  String get tournamentNotFound => 'Turneringen kunde inte hittas';

  @override
  String get tournamentDoesNotExist => 'Denna turnering finns inte.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Turneringen kan blivit inställd om alla spelare lämnade innan den började.';

  @override
  String get returnToTournamentsHomepage => 'Återgå till turneringens hemsida';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Veckans ${param}ratingfördelning';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Din ${param1}rating är $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Du är bättre än $param1 av alla som spelar $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 är bättre än $param2 av alla ${param3}spelare.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Bättre än $param1 av ${param2}spelare';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Du har inte en etablerad ${param}rating.';
  }

  @override
  String get yourRating => 'Din rating';

  @override
  String get cumulative => 'Kumulativ';

  @override
  String get glicko2Rating => 'Glicko-2-rating';

  @override
  String get checkYourEmail => 'Kontrollera din e-post';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Vi har skickat ett e-postmeddelande. Klicka på länken i meddelandet för att aktivera ditt konto.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Om du inte ser e-postmeddelandet, kontrollera andra ställen där det kan vara, som din skräppost, spam, sociala eller andra mappar.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Vi har skickat ett e-postmeddelande till $param. Tryck på länken i e-posten för att återställa ditt lösenord.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Genom att registrera samtycker du till att vara bunden av våra $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Läs om vår $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Nätverksfördröjning mellan dig och lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tid att bearbeta ett drag på lichess server';

  @override
  String get downloadAnnotated => 'Hämta med noter';

  @override
  String get downloadRaw => 'Hämta avskalad';

  @override
  String get downloadImported => 'Hämta importerad';

  @override
  String get crosstable => 'Tabell';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Du kan också skrolla över brädet för att gå framåt/bakåt i partiet.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Rulla över datorvarianter för att förhandsgranska dem.';

  @override
  String get analysisShapesHowTo => 'Håll nere Skift när du klickar eller högerklickar för att rita cirklar och pilar på brädet.';

  @override
  String get letOtherPlayersMessageYou => 'Tillåt att andra spelare skickar meddelanden till dig';

  @override
  String get receiveForumNotifications => 'Få aviseringar vid omnämningar i forumet';

  @override
  String get shareYourInsightsData => 'Dela din information från Chess Insights';

  @override
  String get withNobody => 'Med ingen';

  @override
  String get withFriends => 'Med vänner';

  @override
  String get withEverybody => 'Med alla';

  @override
  String get kidMode => 'Barnsäkert läge';

  @override
  String get kidModeIsEnabled => 'Barnsäkert läge är aktiverat.';

  @override
  String get kidModeExplanation => 'Detta är en säkerhetsinställning. I barnsäkert läge är all kommunikation inaktiverad. Använd detta för dina barn och skolelever för att skydda dem från andra internetanvändare.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'I barnsäkert läge får lichess-logotypen en $param ikon, så att du vet att dina barn är säkra.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Ditt konto hanteras. Fråga din schacklärare om att ta bort barnläget.';

  @override
  String get enableKidMode => 'Aktivera barnsäkert läge';

  @override
  String get disableKidMode => 'Avaktivera barnsäkert läge';

  @override
  String get security => 'Säkerhet';

  @override
  String get sessions => 'Sessioner';

  @override
  String get revokeAllSessions => 'återkalla alla sessioner';

  @override
  String get playChessEverywhere => 'Spela schack var du vill';

  @override
  String get asFreeAsLichess => 'Lika gratis som lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Byggt med kärlek till schack, inte pengar';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Alla får alla funktioner gratis';

  @override
  String get zeroAdvertisement => 'Ingen reklam';

  @override
  String get fullFeatured => 'Alla funktioner';

  @override
  String get phoneAndTablet => 'Mobil och platta';

  @override
  String get bulletBlitzClassical => 'Bullet, blixt och klassiskt';

  @override
  String get correspondenceChess => 'Korrespondensschack';

  @override
  String get onlineAndOfflinePlay => 'Spela uppkopplad eller nedkopplad';

  @override
  String get viewTheSolution => 'Visa lösningen';

  @override
  String get followAndChallengeFriends => 'Följ och utmana vänner';

  @override
  String get gameAnalysis => 'Partianalys';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 är värd för $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 deltar i $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 gillar $param2';
  }

  @override
  String get quickPairing => 'Snabbparning';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonym';

  @override
  String yourScore(String param) {
    return 'Dina poäng: $param';
  }

  @override
  String get language => 'Språk';

  @override
  String get background => 'Bakgrund';

  @override
  String get light => 'Ljus';

  @override
  String get dark => 'Mörk';

  @override
  String get transparent => 'Genomskinlig';

  @override
  String get deviceTheme => 'Enhetstema';

  @override
  String get backgroundImageUrl => 'Bakgrundsbild URL:';

  @override
  String get board => 'Bräde';

  @override
  String get size => 'Storlek';

  @override
  String get opacity => 'Genomskinlighet';

  @override
  String get brightness => 'Ljusstyrka';

  @override
  String get hue => 'Nyans';

  @override
  String get boardReset => 'Reset colours to default';

  @override
  String get pieceSet => 'Pjäsuppsättning';

  @override
  String get embedInYourWebsite => 'Integrera i din webbplats';

  @override
  String get usernameAlreadyUsed => 'Användarnamnet är upptaget, vänligen försök med ett annat.';

  @override
  String get usernamePrefixInvalid => 'Användarnamnet måste börja med en bokstav.';

  @override
  String get usernameSuffixInvalid => 'Användarnamnet måste sluta med en bokstav eller ett nummer.';

  @override
  String get usernameCharsInvalid => 'Användarnamnet får bara innehålla bokstäver, siffror, understrykningstecken och bindestreck.';

  @override
  String get usernameUnacceptable => 'Detta användarnamn är inte acceptabelt.';

  @override
  String get playChessInStyle => 'Spela schack med stil';

  @override
  String get chessBasics => 'Grunderna i schack';

  @override
  String get coaches => 'Schacktränare';

  @override
  String get invalidPgn => 'Ogiltig PGN';

  @override
  String get invalidFen => 'Ogiltig FEN';

  @override
  String get custom => 'Anpassad';

  @override
  String get notifications => 'Aviseringar';

  @override
  String notificationsX(String param1) {
    return 'Notiser: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Öva med datormotståndare';

  @override
  String anotherWasX(String param) {
    return 'Ett alternativt bra drag var $param';
  }

  @override
  String bestWasX(String param) {
    return 'Bästa draget var $param';
  }

  @override
  String get youBrowsedAway => 'Du scrollade iväg';

  @override
  String get resumePractice => 'Återuppta övning';

  @override
  String get drawByFiftyMoves => 'Spelet är remi på grund av femtio drags regeln.';

  @override
  String get theGameIsADraw => 'Remiparti.';

  @override
  String get computerThinking => 'Datorn tänker...';

  @override
  String get seeBestMove => 'Visa det bästa draget';

  @override
  String get hideBestMove => 'Dölj det bästa draget';

  @override
  String get getAHint => 'Ledtråd?';

  @override
  String get evaluatingYourMove => 'Utvärderar ditt drag...';

  @override
  String get whiteWinsGame => 'Vit vinner';

  @override
  String get blackWinsGame => 'Svart vinner';

  @override
  String get learnFromYourMistakes => 'Lär av dina misstag';

  @override
  String get learnFromThisMistake => 'Lär av detta misstaget';

  @override
  String get skipThisMove => 'Hoppa över detta drag';

  @override
  String get next => 'Nästa';

  @override
  String xWasPlayed(String param) {
    return '$param spelades';
  }

  @override
  String get findBetterMoveForWhite => 'Hitta ett bättre drag för vit';

  @override
  String get findBetterMoveForBlack => 'Hitta ett bättre drag för svart';

  @override
  String get resumeLearning => 'Återuppta inlärning';

  @override
  String get youCanDoBetter => 'Du kan bättre';

  @override
  String get tryAnotherMoveForWhite => 'Prova ett annat drag som vit';

  @override
  String get tryAnotherMoveForBlack => 'Prova ett annat drag som svart';

  @override
  String get solution => 'Lösning';

  @override
  String get waitingForAnalysis => 'Väntar på analys';

  @override
  String get noMistakesFoundForWhite => 'Hittar inga misstag för vit';

  @override
  String get noMistakesFoundForBlack => 'Hittar inga misstag för svart';

  @override
  String get doneReviewingWhiteMistakes => 'Färdig med utvärderingen av vits misstag';

  @override
  String get doneReviewingBlackMistakes => 'Färdig med utvärderingen av svarts misstag';

  @override
  String get doItAgain => 'Gör det igen';

  @override
  String get reviewWhiteMistakes => 'Granska vits misstag';

  @override
  String get reviewBlackMistakes => 'Granska svarts misstag';

  @override
  String get advantage => 'Fördel';

  @override
  String get opening => 'Öppning';

  @override
  String get middlegame => 'Mittparti';

  @override
  String get endgame => 'Slutspel';

  @override
  String get conditionalPremoves => 'Villkorade förhandsdrag';

  @override
  String get addCurrentVariation => 'Lägg till aktuell variant';

  @override
  String get playVariationToCreateConditionalPremoves => 'Spela en variant för att skapa villkorade förhandsdrag';

  @override
  String get noConditionalPremoves => 'Inga villkorade förhandsdrag';

  @override
  String playX(String param) {
    return 'Spela $param';
  }

  @override
  String get showUnreadLichessMessage => 'Du har fått ett privat meddelande från Lichess.';

  @override
  String get clickHereToReadIt => 'Klicka här för att läsa den';

  @override
  String get sorry => 'Beklagar :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Vi är tvugna att stänga av dig en stund.';

  @override
  String get why => 'Varför?';

  @override
  String get pleasantChessExperience => 'Vårt mål är att tillhandahålla alla en behaglig schackupplevelse till alla.';

  @override
  String get goodPractice => 'Därför måste vi försäkra oss om att alla spelare följer god sed.';

  @override
  String get potentialProblem => 'När ett möjligt problem upptäcks visar vi detta meddelande.';

  @override
  String get howToAvoidThis => 'Hur undviker jag det här?';

  @override
  String get playEveryGame => 'Spela varje parti som du påbörjar.';

  @override
  String get tryToWin => 'Försök vinna (eller åtminstone nå remi i) varje parti som du spelar.';

  @override
  String get resignLostGames => 'Ge upp förlorade partier (i stället för att låta tiden rinna ut).';

  @override
  String get temporaryInconvenience => 'Vi ber om ursäkt för den tillfälliga olägenheten,';

  @override
  String get wishYouGreatGames => 'och önskar dig bra partier på lichess.org.';

  @override
  String get thankYouForReading => 'Tack för att du läste!';

  @override
  String get lifetimeScore => 'Livstidspoäng';

  @override
  String get currentMatchScore => 'Nuvarande matchpoäng';

  @override
  String get agreementAssistance => 'Jag lovar att jag inte kommer att få hjälp under mina partier (från en schackdator, bok, databas eller annan person).';

  @override
  String get agreementNice => 'Jag lovar att jag alltid kommer att vara respektfull mot andra spelare.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Jag godkänner att jag inte kommer att skapa flera konton (förutom av de skäl som anges i $param).';
  }

  @override
  String get agreementPolicy => 'Jag instämmer med att jag kommer att följa alla Lichess-regler.';

  @override
  String get searchOrStartNewDiscussion => 'Sök eller starta ny konversation';

  @override
  String get edit => 'Redigera';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Snabbschack';

  @override
  String get classical => 'Classical';

  @override
  String get ultraBulletDesc => 'Vansinnigt snabba partier: mindre än 30 sekunder';

  @override
  String get bulletDesc => 'Mycket snabba partier: mindre än 3 minuter';

  @override
  String get blitzDesc => 'Snabba partier: 3 till 8 minuter';

  @override
  String get rapidDesc => 'Snabba partier: 8 till 25 minuter';

  @override
  String get classicalDesc => 'Klassiska partier: 25 minuter och mer';

  @override
  String get correspondenceDesc => 'Korrespondensschack: en eller flera dagar per drag';

  @override
  String get puzzleDesc => 'Schacktaktikträning';

  @override
  String get important => 'Viktigt';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Din fråga kan redan ha ett svar $param1';
  }

  @override
  String get inTheFAQ => 'i Vanliga frågor.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'För att rapportera en användare för fusk eller dåligt beteende, $param1';
  }

  @override
  String get useTheReportForm => 'använd rapportformuläret';

  @override
  String toRequestSupport(String param1) {
    return 'För att begära support, $param1';
  }

  @override
  String get tryTheContactPage => 'prova kontaktsidan';

  @override
  String makeSureToRead(String param1) {
    return 'Se till att läsa $param1';
  }

  @override
  String get theForumEtiquette => 'forumets etikett';

  @override
  String get thisTopicIsArchived => 'Detta ämne har arkiverats och kan inte längre besvaras.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Gå med i $param1, för att posta i detta forum';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1-teamet';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Du kan inte posta i forumen ännu. Spela några partier!';

  @override
  String get subscribe => 'Prenumerera';

  @override
  String get unsubscribe => 'Avprenumerera';

  @override
  String mentionedYouInX(String param1) {
    return 'nämnde dig i \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 nämnde dig i \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'bjöd in dig till \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 bjöd in dig till \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Du är nu en del av laget.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Du har gått med i \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Någon du rapporterade blev avstängd';

  @override
  String get congratsYouWon => 'Grattis, du vann!';

  @override
  String gameVsX(String param1) {
    return 'Parti mot $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 mot $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Du förlorade mot någon som bröt mot Lichess TOS';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Ersättning: $param1 $param2 rankingpoäng.';
  }

  @override
  String get timeAlmostUp => 'Tiden är nästan slut!';

  @override
  String get clickToRevealEmailAddress => '[Klicka för att visa mailadress]';

  @override
  String get download => 'Ladda ner';

  @override
  String get coachManager => 'Coach-hanterare';

  @override
  String get streamerManager => 'Stream-hanterare';

  @override
  String get cancelTournament => 'Avbryt turneringen';

  @override
  String get tournDescription => 'Turneringsbeskrivning';

  @override
  String get tournDescriptionHelp => 'Något speciellt du vill berätta för deltagarna? Försök att hålla det kort. Markdown länkar finns tillgängliga: [name](https://url)';

  @override
  String get ratedFormHelp => 'Partier är rankade\noch påverkar spelares rating';

  @override
  String get onlyMembersOfTeam => 'Endast medlemmar i lag';

  @override
  String get noRestriction => 'Ingen begränsning';

  @override
  String get minimumRatedGames => 'Minst antal rankade partier';

  @override
  String get minimumRating => 'Lägsta rating';

  @override
  String get maximumWeeklyRating => 'Högsta vecko-rating';

  @override
  String positionInputHelp(String param) {
    return 'Klistra in en giltig FEN för att starta varje spel från en given position.\nDet fungerar endast för standardspel, inte med varianter.\nDu kan använda $param för att generera en FEN-position, sedan klistra in den här.\nLämna tomt för att starta spel från den normala startpositionen.';
  }

  @override
  String get cancelSimul => 'Avbryt simultanen';

  @override
  String get simulHostcolor => 'Värdfärg för varje parti';

  @override
  String get estimatedStart => 'Beräknad starttid';

  @override
  String simulFeatured(String param) {
    return 'Visa på $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Visa din simultan för alla på $param. Inaktivera för privata simultaner.';
  }

  @override
  String get simulDescription => 'Simultan-beskrivning';

  @override
  String get simulDescriptionHelp => 'Något du vill berätta för deltagarna?';

  @override
  String markdownAvailable(String param) {
    return '$param är tillgängligt för mer avancerad syntax.';
  }

  @override
  String get embedsAvailable => 'Klistra in en spel-länk eller en studiekapitel-länk för att infoga den.';

  @override
  String get inYourLocalTimezone => 'I din egen lokala tidszon';

  @override
  String get tournChat => 'Turneringschatt';

  @override
  String get noChat => 'Ingen chatt';

  @override
  String get onlyTeamLeaders => 'Endast lagledare';

  @override
  String get onlyTeamMembers => 'Endast lagmedlemmar';

  @override
  String get navigateMoveTree => 'Navigera i dragträdet';

  @override
  String get mouseTricks => 'Mus-trick';

  @override
  String get toggleLocalAnalysis => 'Växla lokal datoranalys';

  @override
  String get toggleAllAnalysis => 'Växla all datoranalys';

  @override
  String get playComputerMove => 'Spela bästa datordraget';

  @override
  String get analysisOptions => 'Analysalternativ';

  @override
  String get focusChat => 'Fokusera chatten';

  @override
  String get showHelpDialog => 'Visa denna hjälpdialog';

  @override
  String get reopenYourAccount => 'Öppna ditt konto igen';

  @override
  String get closedAccountChangedMind => 'Om du stängt ditt konto, men sedan dess har ändrat dig, får du en chans att få tillbaka ditt konto.';

  @override
  String get onlyWorksOnce => 'Detta fungerar bara en gång.';

  @override
  String get cantDoThisTwice => 'Om du stänger ditt konto en andra gång, kommer det inte att finnas något sätt att återställa det.';

  @override
  String get emailAssociatedToaccount => 'E-postadress kopplad till kontot';

  @override
  String get sentEmailWithLink => 'Vi har skickat ett e-postmeddelande med en länk.';

  @override
  String get tournamentEntryCode => 'Inträdeskod till turnering';

  @override
  String get hangOn => 'Var god vänta!';

  @override
  String gameInProgress(String param) {
    return 'Du har ett pågående parti med $param.';
  }

  @override
  String get abortTheGame => 'Avbryt partiet';

  @override
  String get resignTheGame => 'Ge upp partiet';

  @override
  String get youCantStartNewGame => 'Du kan inte starta ett nytt parti förräm detta är klart.';

  @override
  String get since => 'Sedan';

  @override
  String get until => 'Tills';

  @override
  String get lichessDbExplanation => 'Rankade spel från alla Lichess spelare';

  @override
  String get switchSides => 'Växla sida';

  @override
  String get closingAccountWithdrawAppeal => 'Att avsluta ditt konto kommer att dra tillbaka ditt överklagande';

  @override
  String get ourEventTips => 'Våra tips för anordnande av evenemang';

  @override
  String get instructions => 'Instruktioner';

  @override
  String get showMeEverything => 'Visa mig allt';

  @override
  String get lichessPatronInfo => 'Lichess är en välgörenhet och helt gratis/fri programvara med öppen källkod.\nAlla driftskostnader, utveckling och innehåll finansieras enbart av användardonationer.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String get stats => 'Stats';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Din motståndare lämnade partiet. Du kan begära seger om $count sekunder.',
      one: 'Din motståndare lämnade partiet. Du kan begära seger om $count sekund.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matt på $count halvdrag',
      one: 'Matt på $count halvdrag',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blundrar',
      one: '$count blunder',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count misstag',
      one: '$count misstag',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count felaktigheter',
      one: '$count felaktighet',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelare',
      one: '$count spelare',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partier',
      one: '$count parti',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '${count}ranking över $param2 partier',
      one: '${count}ranking över $param2 parti',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bokmärken',
      one: '$count bokmärke',
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
      other: '$count timmar',
      one: '$count timme',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuter',
      one: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Placeringar uppdateras efter $count minuter',
      one: 'Placeringen uppdateras varje minut',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count schackproblem',
      one: '$count schackproblem',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partier med dig',
      one: '$count parti med dig',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rankade',
      one: '$count rankat',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vinster',
      one: '$count vinst',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count förluster',
      one: '$count förlust',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remier',
      one: '$count remi',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelas',
      one: '$count spelas',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ge $count sekunder',
      one: 'Ge $count sekund',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turneringspoäng',
      one: '$count turneringspoäng',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studier',
      one: '$count studie',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultanpartier',
      one: '$count simultanparti',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count rankade partier',
      one: '≥ $count rankat parti',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count rankade $param2 partier',
      one: '≥ $count rankat $param2 parti',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du behöver spela ytterligare $count rankade ${param2}partier',
      one: 'Du behöver spela ytterligare $count rankat ${param2}parti',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du behöver spela ytterligare $count rankade partier',
      one: 'Du behöver spela ytterligare $count rankat parti',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Importerade partier',
      one: '$count Importerat parti',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vänner inloggade',
      one: '$count vän inloggad',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count följare',
      one: '$count följare',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'följer $count',
      one: 'följer $count',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mindre än $count minuter',
      one: 'Mindre än $count minut',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partier spelas',
      one: '$count parti spelas',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Max: $count tecken.',
      one: 'Max: $count tecken.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blockeringar',
      one: '$count blockering',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foruminlägg',
      one: '$count foruminlägg',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ${param2}spelare denna vecka.',
      one: '$count ${param2}spelare denna vecka.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tillgänglig på $count olika språk!',
      one: 'Tillgänglig på $count olika språk!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekunder kvar för att spela första draget',
      one: '$count sekund kvar för att spela första draget',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekunder',
      one: '$count sekund',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'och spara $count linje av förhandsdrag',
      one: 'och spara $count linje av förhandsdrag',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Flytta för att starta';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Du spelar de vita pjäserna i alla pussel';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Du spelar de svarta pjäserna i alla pussel';

  @override
  String get stormPuzzlesSolved => 'schackproblem lösta';

  @override
  String get stormNewDailyHighscore => 'Nytt dagligt rekord!';

  @override
  String get stormNewWeeklyHighscore => 'Nytt vecko-rekord!';

  @override
  String get stormNewMonthlyHighscore => 'Nytt månads-rekord!';

  @override
  String get stormNewAllTimeHighscore => 'Nytt rekord!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Tidigare rekord var $param';
  }

  @override
  String get stormPlayAgain => 'Spela igen';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Poäng';

  @override
  String get stormMoves => 'Drag';

  @override
  String get stormAccuracy => 'Precision';

  @override
  String get stormCombo => 'Kombo';

  @override
  String get stormTime => 'Tid';

  @override
  String get stormTimePerMove => 'Tid per drag';

  @override
  String get stormHighestSolved => 'Högsta lösta';

  @override
  String get stormPuzzlesPlayed => 'Spelade schackproblem';

  @override
  String get stormNewRun => 'Nytt försök (snabbkommando: mellanslag)';

  @override
  String get stormEndRun => 'Avsluta försök (snabbkommando: retur)';

  @override
  String get stormHighscores => 'Rekord';

  @override
  String get stormViewBestRuns => 'Se bästa försök';

  @override
  String get stormBestRunOfDay => 'Dagens bästa försök';

  @override
  String get stormRuns => 'Försök';

  @override
  String get stormGetReady => 'Gör dig redo!';

  @override
  String get stormWaitingForMorePlayers => 'Väntar på att fler spelare ska gå med...';

  @override
  String get stormRaceComplete => 'Loppet är klart!';

  @override
  String get stormSpectating => 'Åskådar';

  @override
  String get stormJoinTheRace => 'Gå med i loppet!';

  @override
  String get stormStartTheRace => 'Starta loppet';

  @override
  String stormYourRankX(String param) {
    return 'Din placering: $param';
  }

  @override
  String get stormWaitForRematch => 'Vänta på returmatch';

  @override
  String get stormNextRace => 'Nästa lopp';

  @override
  String get stormJoinRematch => 'Gå med i returmatch';

  @override
  String get stormWaitingToStart => 'Väntar på att starta';

  @override
  String get stormCreateNewGame => 'Skapa ett nytt lopp';

  @override
  String get stormJoinPublicRace => 'Gå med i ett öppet lopp';

  @override
  String get stormRaceYourFriends => 'Utmana dina vänner';

  @override
  String get stormSkip => 'skippa';

  @override
  String get stormSkipHelp => 'Du kan skippa ett drag per lopp:';

  @override
  String get stormSkipExplanation => 'Skippa detta drag för att bevara din kombo! Detta fungerar bara en gång per lopp.';

  @override
  String get stormFailedPuzzles => 'Ej lösta schackproblem';

  @override
  String get stormSlowPuzzles => 'Långsamma schackproblem';

  @override
  String get stormSkippedPuzzle => 'Skippat pussel';

  @override
  String get stormThisWeek => 'Denna vecka';

  @override
  String get stormThisMonth => 'Denna månad';

  @override
  String get stormAllTime => 'Genom alla tider';

  @override
  String get stormClickToReload => 'Klicka för att ladda om';

  @override
  String get stormThisRunHasExpired => 'Detta loppet har löpt ut!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Denna loppet har öppnats i en annan flik!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count försök',
      one: '1 försök',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spelade $count omgångar $param2',
      one: 'Spelade en omgång $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Videokanaler från Lichess';

  @override
  String get studyPrivate => 'Privat';

  @override
  String get studyMyStudies => 'Mina studier';

  @override
  String get studyStudiesIContributeTo => 'Studier som jag bidrar till';

  @override
  String get studyMyPublicStudies => 'Mina offentliga studier';

  @override
  String get studyMyPrivateStudies => 'Mina privata studier';

  @override
  String get studyMyFavoriteStudies => 'Mina favoritstudier';

  @override
  String get studyWhatAreStudies => 'Vad är studier?';

  @override
  String get studyAllStudies => 'Alla studier';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studier skapade av $param';
  }

  @override
  String get studyNoneYet => 'Inga ännu.';

  @override
  String get studyHot => 'Populära';

  @override
  String get studyDateAddedNewest => 'Datum tillagd (nyaste)';

  @override
  String get studyDateAddedOldest => 'Datum tillagd (nyaste)';

  @override
  String get studyRecentlyUpdated => 'Nyligen uppdaterade';

  @override
  String get studyMostPopular => 'Mest populära';

  @override
  String get studyAlphabetical => 'Alfabetisk';

  @override
  String get studyAddNewChapter => 'Lägg till ett nytt kapitel';

  @override
  String get studyAddMembers => 'Lägg till medlemmar';

  @override
  String get studyInviteToTheStudy => 'Bjud in till studien';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Viktigt: bjud bara in människor du känner och som aktivt vill gå med i studien.';

  @override
  String get studySearchByUsername => 'Sök efter användarnamn';

  @override
  String get studySpectator => 'Åskådare';

  @override
  String get studyContributor => 'Bidragsgivare';

  @override
  String get studyKick => 'Sparka';

  @override
  String get studyLeaveTheStudy => 'Lämna studien';

  @override
  String get studyYouAreNowAContributor => 'Du är nu bidragsgivare';

  @override
  String get studyYouAreNowASpectator => 'Du är nu en åskådare';

  @override
  String get studyPgnTags => 'PGN taggar';

  @override
  String get studyLike => 'Gilla';

  @override
  String get studyUnlike => 'Sluta gilla';

  @override
  String get studyNewTag => 'Ny tag';

  @override
  String get studyCommentThisPosition => 'Kommentera denna position';

  @override
  String get studyCommentThisMove => 'Kommentera detta drag';

  @override
  String get studyAnnotateWithGlyphs => 'Kommentera med glyfer';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Kapitlet är för kort för att analyseras.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Endast studiens bidragsgivare kan begära en datoranalys.';

  @override
  String get studyGetAFullComputerAnalysis => 'Hämta en fullständig serveranalys av huvudlinjen.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Försäkra dig om att kapitlet är färdigt. Du kan bara begära analysen en gång.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Alla SYNC-medlemmar är kvar på samma position';

  @override
  String get studyShareChanges => 'Dela ändringar med åskådare och spara dem på servern';

  @override
  String get studyPlaying => 'Spelar';

  @override
  String get studyShowEvalBar => 'Värderingsfält';

  @override
  String get studyFirst => 'Första';

  @override
  String get studyPrevious => 'Föregående';

  @override
  String get studyNext => 'Nästa';

  @override
  String get studyLast => 'Sista';

  @override
  String get studyShareAndExport => 'Dela & exportera';

  @override
  String get studyCloneStudy => 'Klona';

  @override
  String get studyStudyPgn => 'Studiens PGN';

  @override
  String get studyDownloadAllGames => 'Ladda ner alla partier';

  @override
  String get studyChapterPgn => 'Kapitel PGN';

  @override
  String get studyCopyChapterPgn => 'Kopiera PGN';

  @override
  String get studyDownloadGame => 'Ladda ner parti';

  @override
  String get studyStudyUrl => 'Studiens URL';

  @override
  String get studyCurrentChapterUrl => 'Aktuell kapitel URL';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Du kan klistra in detta i forumet för att infoga';

  @override
  String get studyStartAtInitialPosition => 'Start vid ursprunglig position';

  @override
  String studyStartAtX(String param) {
    return 'Börja på $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Infoga på din hemsida eller blogg';

  @override
  String get studyReadMoreAboutEmbedding => 'Läs mer om att infoga';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Endast offentliga studier kan läggas till!';

  @override
  String get studyOpen => 'Öppna';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1 gjord av $param2';
  }

  @override
  String get studyStudyNotFound => 'Studien kan inte hittas';

  @override
  String get studyEditChapter => 'Redigera kapitel';

  @override
  String get studyNewChapter => 'Nytt kapitel';

  @override
  String studyImportFromChapterX(String param) {
    return 'Importera från $param';
  }

  @override
  String get studyOrientation => 'Orientering';

  @override
  String get studyAnalysisMode => 'Analysläge';

  @override
  String get studyPinnedChapterComment => 'Fastnålad kommentar till kapitlet';

  @override
  String get studySaveChapter => 'Spara kapitlet';

  @override
  String get studyClearAnnotations => 'Rensa kommentarer';

  @override
  String get studyClearVariations => 'Rensa variationer';

  @override
  String get studyDeleteChapter => 'Ta bort kapitel';

  @override
  String get studyDeleteThisChapter => 'Ta bort detta kapitel. Det går inte att ångra!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Rensa alla kommentarer, symboler och former i detta kapitel?';

  @override
  String get studyRightUnderTheBoard => 'Direkt under brädet';

  @override
  String get studyNoPinnedComment => 'Ingen';

  @override
  String get studyNormalAnalysis => 'Normal analys';

  @override
  String get studyHideNextMoves => 'Dölj nästa drag';

  @override
  String get studyInteractiveLesson => 'Interaktiv lektion';

  @override
  String studyChapterX(String param) {
    return 'Kapitel $param';
  }

  @override
  String get studyEmpty => 'Tom';

  @override
  String get studyStartFromInitialPosition => 'Starta från ursprunglig position';

  @override
  String get studyEditor => 'Redigeringsverktyg';

  @override
  String get studyStartFromCustomPosition => 'Starta från anpassad position';

  @override
  String get studyLoadAGameByUrl => 'Importera ett spel med URL';

  @override
  String get studyLoadAPositionFromFen => 'Importera en position med FEN-kod';

  @override
  String get studyLoadAGameFromPgn => 'Importera ett spel med PGN-kod';

  @override
  String get studyAutomatic => 'Automatisk';

  @override
  String get studyUrlOfTheGame => 'URL till partiet';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Importera ett parti från $param1 eller $param2';
  }

  @override
  String get studyCreateChapter => 'Skapa kapitel';

  @override
  String get studyCreateStudy => 'Skapa en studie';

  @override
  String get studyEditStudy => 'Redigera studie';

  @override
  String get studyVisibility => 'Synlighet';

  @override
  String get studyPublic => 'Offentlig';

  @override
  String get studyUnlisted => 'Ej listad';

  @override
  String get studyInviteOnly => 'Endast inbjudna';

  @override
  String get studyAllowCloning => 'Tillåt kloning';

  @override
  String get studyNobody => 'Ingen';

  @override
  String get studyOnlyMe => 'Bara mig';

  @override
  String get studyContributors => 'Medhjälpare';

  @override
  String get studyMembers => 'Medlemmar';

  @override
  String get studyEveryone => 'Alla';

  @override
  String get studyEnableSync => 'Aktivera synkronisering';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Ja: håll alla på samma position';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Nej: låt alla bläddra fritt';

  @override
  String get studyPinnedStudyComment => 'Ständigt synlig studiekommentar';

  @override
  String get studyStart => 'Starta';

  @override
  String get studySave => 'Spara';

  @override
  String get studyClearChat => 'Rensa Chatten';

  @override
  String get studyDeleteTheStudyChatHistory => 'Radera studiens chatthistorik? Detta går inte att ångra!';

  @override
  String get studyDeleteStudy => 'Ta bort studie';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Radera hela studien? Detta går inte att ångra! Skriv namnet på studien för att bekräfta: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Var vill du studera detta?';

  @override
  String get studyGoodMove => 'Bra drag';

  @override
  String get studyMistake => 'Misstag';

  @override
  String get studyBrilliantMove => 'Lysande drag';

  @override
  String get studyBlunder => 'Blunder';

  @override
  String get studyInterestingMove => 'Intressant drag';

  @override
  String get studyDubiousMove => 'Tvivelaktigt drag';

  @override
  String get studyOnlyMove => 'Enda draget';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Likvärdig position';

  @override
  String get studyUnclearPosition => 'Oklar position';

  @override
  String get studyWhiteIsSlightlyBetter => 'Vit är något bättre';

  @override
  String get studyBlackIsSlightlyBetter => 'Svart är något bättre';

  @override
  String get studyWhiteIsBetter => 'Vit är bättre';

  @override
  String get studyBlackIsBetter => 'Svart är bättre';

  @override
  String get studyWhiteIsWinning => 'Vit vinner';

  @override
  String get studyBlackIsWinning => 'Svart vinner';

  @override
  String get studyNovelty => 'Ny variant';

  @override
  String get studyDevelopment => 'Utveckling';

  @override
  String get studyInitiative => 'Initiativ';

  @override
  String get studyAttack => 'Attack';

  @override
  String get studyCounterplay => 'Motspel';

  @override
  String get studyTimeTrouble => 'Tidsproblem';

  @override
  String get studyWithCompensation => 'Med kompensation';

  @override
  String get studyWithTheIdea => 'Med idén';

  @override
  String get studyNextChapter => 'Nästa kapitel';

  @override
  String get studyPrevChapter => 'Föregående kapitel';

  @override
  String get studyStudyActions => 'Studie-alternativ';

  @override
  String get studyTopics => 'Ämnen';

  @override
  String get studyMyTopics => 'Mina ämnen';

  @override
  String get studyPopularTopics => 'Populära ämnen';

  @override
  String get studyManageTopics => 'Hantera ämnen';

  @override
  String get studyBack => 'Tillbaka';

  @override
  String get studyPlayAgain => 'Spela igen';

  @override
  String get studyWhatWouldYouPlay => 'Vad skulle du spela i denna position?';

  @override
  String get studyYouCompletedThisLesson => 'Grattis! Du har slutfört denna lektionen.';

  @override
  String studyPerPage(String param) {
    return '$param per page';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '$count Kapitel',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partier',
      one: '$count partier',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Medlemmar',
      one: '$count Medlem',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Klistra in din PGN-kod här, upp till $count partier',
      one: 'Klistra in din PGN-kod här, upp till $count parti',
    );
    return '$_temp0';
  }
}
