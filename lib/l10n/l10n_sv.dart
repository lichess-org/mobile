// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get mobileAllGames => 'Alla spel';

  @override
  String get mobileAreYouSure => 'Är du säker?';

  @override
  String get mobileCancelTakebackOffer => 'Neka att ta tillbaka drag';

  @override
  String get mobileClearButton => 'Rensa';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Rensa sparade drag';

  @override
  String get mobileCustomGameJoinAGame => 'Gå med i spel';

  @override
  String get mobileFeedbackButton => 'Återkoppling';

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
  String get mobileHideVariation => 'Dölj variationer';

  @override
  String get mobileHomeTab => 'Hem';

  @override
  String get mobileLiveStreamers => 'Videokanaler från Lichess';

  @override
  String get mobileMustBeLoggedIn => 'Du måste vara inloggad för att se denna sida.';

  @override
  String get mobileNoSearchResults => 'Inga resultat';

  @override
  String get mobileNotFollowingAnyUser => 'Du följer inte någon användare.';

  @override
  String get mobileOkButton => 'OK';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Spelare med \"$param\"';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Förstora flyttad pjäs';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Vill du avsluta denna omgång?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Ingenting att visa, vänligen ändra filtren';

  @override
  String get mobilePuzzleStormNothingToShow =>
      'Inget att visa. Spela några omgångar av Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Lös så många pussel som möjligt på 3 minuter.';

  @override
  String get mobilePuzzleStreakAbortWarning =>
      'Du kommer att förlora din nuvarande serie och din poäng kommer att sparas.';

  @override
  String get mobilePuzzleThemesSubtitle =>
      'Spela pussel från dina favoritöppningar, eller välj ett tema.';

  @override
  String get mobilePuzzlesTab => 'Problem';

  @override
  String get mobileRecentSearches => 'Senaste sökningar';

  @override
  String get mobileRemoveBookmark => 'Remove bookmark';

  @override
  String get mobileSettingsImmersiveMode => 'Expanderat läge';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and puzzle screens.';

  @override
  String get mobileSettingsTab => 'Inställn.';

  @override
  String get mobileShareGamePGN => 'Dela PGN';

  @override
  String get mobileShareGameURL => 'Dela parti-URL';

  @override
  String get mobileSharePositionAsFEN => 'Dela position som FEN';

  @override
  String get mobileSharePuzzle => 'Dela detta schackproblem';

  @override
  String get mobileShowComments => 'Visa kommentarer';

  @override
  String get mobileShowResult => 'Visa resultat';

  @override
  String get mobileShowVariations => 'Visa variationer';

  @override
  String get mobileSomethingWentWrong => 'Något gick fel.';

  @override
  String get mobileSystemColors => 'Systemets färger';

  @override
  String get mobileTheme => 'Tema';

  @override
  String get mobileToolsTab => 'Verktyg';

  @override
  String get mobileWaitingForOpponentToJoin => 'Väntar på motståndare...';

  @override
  String get mobileWatchTab => 'Titta';

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
      other: 'Avslutade $count $param2 korrespondenspartier',
      one: 'Avslutade $count $param2 korrespondensparti',
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
  String get arenaArena => 'Arena';

  @override
  String get arenaArenaTournaments => 'Arena-turneringar';

  @override
  String get arenaIsItRated => 'Är det rankat?';

  @override
  String get arenaWillBeNotified =>
      'Du får ett meddelande när turneringen startar, så du kan utan problem spela i en annan flik medan du väntar.';

  @override
  String get arenaIsRated => 'Turneringen är rankad och kommer påverka din rating.';

  @override
  String get arenaIsNotRated =>
      'Turneringen är *inte* rankad och kommer *inte* att påverka din rating.';

  @override
  String get arenaSomeRated => 'Vissa turneringar är rankade och kommer att påverka din rating.';

  @override
  String get arenaHowAreScoresCalculated => 'Hur räknas poängen?';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      'En vinst har baspoäng 2, remi 1 och förlust 0 poäng. Om du vinner två partier i rad så startar en dubbelpoängserie representerad av en flamma som ikon. Efterföljande partier är då värda dubbla poäng tills du misslyckas med att vinna ett parti. En vinst är då värd 4 poäng, remi 2 och förlust 0 poäng.\n\nEtt exempel, två vinster följt av en remi är värt 6 poäng: 2 + 2 + (2 x 1)';

  @override
  String get arenaBerserk => 'Arena-Bärsärk';

  @override
  String get arenaBerserkAnswer =>
      'När en spelare klickar på Bärsärk-knappen i början av partiet, halveras dennes betänketid, men en vinst blir värd en extra turneringspoäng. Att gå Bärsärk vid tidskontroller med tidstillägg medför också att tidstillägget förloras. \n(1+2 är ett undantag, vilket blir 1+0)\n\nBärsärk är ej möjligt för partier med noll i starttid (0+1, 0+2).\n\nBärsärk ger en extrapoäng endast om du spelar minst 7 drag i partiet.';

  @override
  String get arenaHowIsTheWinnerDecided => 'Hur avgörs vem som vunnit turneringen?';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      'Den/de spelare som har flest poäng när turneringstiden går ut utropas till turneringsvinnare.';

  @override
  String get arenaHowDoesPairingWork => 'Hur fungerar lottningen?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      'I början av turneringen lottas spelarna baserat på deras rating. Så snart du avslutat ett parti och återvänt till turneringslobbyn, kommer du lottas med en spelare som ligger nära dig poängmässigt. Detta garanterar minimal väntetid, men samtidigt är det inte säkert att du får möta alla deltagare i turneringen. Ett tips är att spela fort och återvända till lobbyn snarast möjligt för chans till fler partier och fler poäng.';

  @override
  String get arenaHowDoesItEnd => 'Hur slutar turneringen?';

  @override
  String get arenaHowDoesItEndAnswer =>
      'Turneringen har en tidsnedräkning. När den nått noll, fryses turneringsplaceringarna och vinnaren annonseras. Turneringspartier som då pågår spelas klart men poängen räknas inte in i turneringsresultatet.';

  @override
  String get arenaOtherRules => 'Andra viktiga regler.';

  @override
  String get arenaThereIsACountdown =>
      'Det finns en nedräkning för ditt första drag. Om du inte gör ett drag inom denna tid kommer du att förlora partiet.';

  @override
  String get arenaThisIsPrivate => 'Detta är en privat turnering';

  @override
  String arenaShareUrl(String param) {
    return 'Dela denna länk för att låta spelare delta: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return 'Remiserier: När en spelare har konsekutiva remier i en arena så kommer bara den första att ge ett poäng, eller remier som varar mer än $param drag i standardpartier. Remiserien kan bara brytas av en vinst, inte en förlust eller remi.';
  }

  @override
  String get arenaDrawStreakVariants =>
      'Minsta partilängden för att remier ska ge poäng är olika mellan varianter. Tabellen nedan listar gränsvärden för varje variant.';

  @override
  String get arenaVariant => 'Variant';

  @override
  String get arenaMinimumGameLength => 'Minsta partilängd';

  @override
  String get arenaHistory => 'Arena-historik';

  @override
  String get arenaNewTeamBattle => 'Ny Lagmatch';

  @override
  String get arenaCustomStartDate => 'Anpassat startdatum';

  @override
  String get arenaCustomStartDateHelp =>
      'I din egen lokala tidszon. Detta åsidosätter inställningen \"Tid tills turneringen börjar\"';

  @override
  String get arenaAllowBerserk => 'Tillåt Bärsärk';

  @override
  String get arenaAllowBerserkHelp => 'Låt spelarna halvera sin klocktid för att få en extra poäng';

  @override
  String get arenaAllowChatHelp => 'Låt spelare diskutera i ett chattrum';

  @override
  String get arenaArenaStreaks => 'Arenavinster i rad';

  @override
  String get arenaArenaStreaksHelp =>
      'Efter 2 vinster, ger efterföljande vinster 4 poäng i stället för 2.';

  @override
  String get arenaNoBerserkAllowed => 'Bärsärk tillåts ej';

  @override
  String get arenaNoArenaStreaks => 'Inga arena streaks';

  @override
  String get arenaAveragePerformance => 'Genomsnittlig prestanda';

  @override
  String get arenaAverageScore => 'Medelpoäng';

  @override
  String get arenaMyTournaments => 'Mina turneringar';

  @override
  String get arenaEditTournament => 'Redigera turnering';

  @override
  String get arenaEditTeamBattle => 'Redigera lagtävling';

  @override
  String get arenaDefender => 'Försvarare';

  @override
  String get arenaPickYourTeam => 'Välj ditt lag';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle =>
      'Vilket lag ska du representera i denna tävling?';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate =>
      'Du måste gå med i ett av dessa lag för att delta!';

  @override
  String get arenaCreated => 'Skapad';

  @override
  String get arenaRecentlyPlayed => 'Senast spelade';

  @override
  String get arenaBestResults => 'Bästa resultat';

  @override
  String get arenaTournamentStats => 'Turneringsstatistik';

  @override
  String get arenaRankAvgHelp =>
      'Rankningsgenomsnittet är en procentsats baserad på din rankning. Lägre är bättre.\n\nTill exempel: Rankad 3 i en turnering på 100 spelare = 3%. Rankad 10 i en turnering på 1000 spelare = 1%.';

  @override
  String get arenaMedians => 'medianer';

  @override
  String arenaAllAveragesAreX(String param) {
    return 'Alla medelvärden på denna sida är $param.';
  }

  @override
  String get arenaTotal => 'Summa';

  @override
  String get arenaPointsAvg => 'Genomsnittlig poäng';

  @override
  String get arenaPointsSum => 'Poängsumma';

  @override
  String get arenaRankAvg => 'Genomsnittlig rankning';

  @override
  String get arenaTournamentWinners => 'Turneringsvinnare';

  @override
  String get arenaTournamentShields => 'Turneringssköldar';

  @override
  String get arenaOnlyTitled => 'Endast för spelare med schacktitlar';

  @override
  String get arenaOnlyTitledHelp => 'Kräv en officiell schacktitel för att delta i turneringen';

  @override
  String get arenaTournamentPairingsAreNowClosed => 'Turneringsmatchningarna är nu avslutade.';

  @override
  String get arenaBerserkRate => 'Bärsärk-frekvens';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Att göra remi inom $count drag kommer inte ge poäng till någon av spelarna.',
      one: 'Att göra remi inom $count drag kommer inte ge poäng till någon av spelarna.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Visa alla $count lag',
      one: 'Visa laget',
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
  String get broadcastBroadcastCalendar => 'Sändningsschema';

  @override
  String get broadcastNewBroadcast => 'Ny direktsändning';

  @override
  String get broadcastSubscribedBroadcasts => 'Bokade sändningar';

  @override
  String get broadcastAboutBroadcasts => 'Om sändningar';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Hur man använder Lichess-Sändningar.';

  @override
  String get broadcastTheNewRoundHelp =>
      'Den nya rundan kommer att ha samma medlemmar och bidragsgivare som den föregående.';

  @override
  String get broadcastAddRound => 'Lägg till en omgång';

  @override
  String get broadcastOngoing => 'Pågående';

  @override
  String get broadcastUpcoming => 'Kommande';

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
  String get broadcastSourceSingleUrl => 'PNG-källans URL';

  @override
  String get broadcastSourceUrlHelp =>
      'URL som Lichess kan använda för att få PGN-uppdateringar. Den måste vara publikt tillgänglig från Internet.';

  @override
  String get broadcastSourceGameIds =>
      'Upp till 64 Lichess-partiers ID, separerade med mellanslag.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Startdatum i turneringens lokala tidszon: $param';
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
  String get broadcastDeleteAllGamesOfThisRound =>
      'Radera alla partier i denna runda. Källan kommer behöva vara aktiv för att återskapa dem.';

  @override
  String get broadcastEditRoundStudy => 'Redigera studie för ronden';

  @override
  String get broadcastDeleteTournament => 'Radera turnering';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Definitivt radera turnering.';

  @override
  String get broadcastShowScores => 'Visa spelares poäng efter matchresultat';

  @override
  String get broadcastReplacePlayerTags => 'Valfritt: byt ut spelarnamn, ranking och titlar';

  @override
  String get broadcastFideFederations => 'FIDE-förbund';

  @override
  String get broadcastTop10Rating => 'Topp 10 rating';

  @override
  String get broadcastFidePlayers => 'FIDE-spelare';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE-spelare hittades inte';

  @override
  String get broadcastFideProfile => 'FIDE-profil';

  @override
  String get broadcastFederation => 'Förbund';

  @override
  String get broadcastAgeThisYear => 'Ålder i år';

  @override
  String get broadcastUnrated => 'Ej rankat';

  @override
  String get broadcastRecentTournaments => 'Senaste turneringar';

  @override
  String get broadcastOpenLichess => 'Öppna i Lichess';

  @override
  String get broadcastTeams => 'Lag';

  @override
  String get broadcastBoards => 'Partier';

  @override
  String get broadcastOverview => 'Översikt';

  @override
  String get broadcastSubscribeTitle =>
      'Prenumerera för att meddelas när varje runda startar. Du kan växla mellan klock- eller push-meddelanden för sändningar i dina kontoinställningar.';

  @override
  String get broadcastUploadImage => 'Ladda upp turneringsbild';

  @override
  String get broadcastNoBoardsYet =>
      'Inga partier ännu. Dessa kommer att visas när spelen är uppladdade.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Tavlor kan laddas med en källa eller via $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Startar efter $param';
  }

  @override
  String get broadcastStartVerySoon => 'Sändningen kommer att starta mycket snart.';

  @override
  String get broadcastNotYetStarted => 'Sändningen har ännu inte startat.';

  @override
  String get broadcastOfficialWebsite => 'Officiell webbplats';

  @override
  String get broadcastStandings => 'Ställningar';

  @override
  String get broadcastOfficialStandings => 'Officiella ställningar';

  @override
  String broadcastIframeHelp(String param) {
    return 'Fler alternativ på $param';
  }

  @override
  String get broadcastWebmastersPage => 'webbmasterns sida';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'En offentlig PGN-källa i realtid för denna omgång. Vi erbjuder även en $param för snabbare och effektivare synkronisering.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Infoga denna sändning på din webbplats';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Infoga $param på din webbplats';
  }

  @override
  String get broadcastRatingDiff => 'Rating diff';

  @override
  String get broadcastGamesThisTournament => 'Partier i denna turnering';

  @override
  String get broadcastScore => 'Poäng';

  @override
  String get broadcastAllTeams => 'Alla lag';

  @override
  String get broadcastTournamentFormat => 'Turneringens format';

  @override
  String get broadcastTournamentLocation => 'Turneringens plats';

  @override
  String get broadcastTopPlayers => 'Toppspelare';

  @override
  String get broadcastTimezone => 'Tidszon';

  @override
  String get broadcastFideRatingCategory => 'Kategori för FIDE-rating';

  @override
  String get broadcastOptionalDetails => 'Valfri information';

  @override
  String get broadcastPastBroadcasts => 'Tidigare sändningar';

  @override
  String get broadcastAllBroadcastsByMonth => 'Visa alla sändningar efter månad';

  @override
  String get broadcastBackToLiveMove => 'Tillbaka till nuvarande drag';

  @override
  String get broadcastSinceHideResults =>
      'Eftersom du valde att dölja resultatet är alla förhandsgransknings-bräden tomma, för att undvika spoilers.';

  @override
  String get broadcastLiveboard => 'Nuvarande position';

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
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tittare',
      one: '$count tittare',
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
  String get challengeRegisterToSendChallenges =>
      'Vänligen registrera ett konto för att skicka utmaningar.';

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
  String get challengeDeclineTooFast =>
      'Denna tidskontroll är för snabb för mig, vänligen utmana igen med ett långsammare parti.';

  @override
  String get challengeDeclineTooSlow =>
      'Denna tidskontroll är för långsam för mig, vänligen utmana igen med ett snabbare parti.';

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
  String get coordinatesKnowingTheChessBoard =>
      'Att veta schackbrädets koordinater är en mycket viktig schackfärdighet:';

  @override
  String get coordinatesMostChessCourses =>
      'De flesta schackkurserna och övningarna använder algebraisk notation.';

  @override
  String get coordinatesTalkToYourChessFriends =>
      'Det gör det lättare att prata med dina schackvänner eftersom ni bägge förstår ”schackspråket”.';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively =>
      'Ett parti analyseras ännu effektivare om du inte behöver söka efter rutornas koordinater.';

  @override
  String get coordinatesACoordinateAppears =>
      'En koordinat visas på brädet och du ska klicka på motsvarande ruta.';

  @override
  String get coordinatesASquareIsHighlightedExplanation =>
      'En ruta är markerad på tavlan och du ska ange dess koordinat (t.ex. \"e4\").';

  @override
  String get coordinatesYouHaveThirtySeconds =>
      'Du har 30 sekunder på dig att korrekt namnge så många rutor som möjligt!';

  @override
  String get coordinatesGoAsLongAsYouWant =>
      'Fortsätt så länge du vill, det finns ingen tidsbegränsning!';

  @override
  String get coordinatesShowCoordinates => 'Visa koordinater';

  @override
  String get coordinatesShowCoordsOnAllSquares => 'Koordinater på varje ruta';

  @override
  String get coordinatesShowPieces => 'Visa pjäser';

  @override
  String get coordinatesStartTraining => 'Starta träningen';

  @override
  String get coordinatesFindSquare => 'Hitta ruta';

  @override
  String get coordinatesNameSquare => 'Namnge ruta';

  @override
  String get coordinatesPracticeOnlySomeFilesAndRanks => 'Öva bara på linjer & rader';

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
  String get perfStatNotEnoughRatedGames =>
      'Inte tillräckligt många rankade partier har spelats för att fastställa en tillförlitlig rating.';

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
  String get perfStatBerserkedGames => 'Bärsärk-partier';

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
  String get preferencesExplainShowPlayerRatings =>
      'Detta gör det möjligt att dölja all rating från webbplatsen, för att fokusera på schackspelet. Partiet kan fortfarande vara med rating, detta handlar bara om vad du får se.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Visa handtag för att ändra brädets storlek';

  @override
  String get preferencesOnlyOnInitialPosition => 'Endast vid ursprunglig position';

  @override
  String get preferencesInGameOnly => 'Endast i parti';

  @override
  String get preferencesExceptInGame => 'Utom i pågående parti';

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
  String get preferencesPremovesPlayingDuringOpponentTurn =>
      'Förhandsdrag (göra drag i förväg under motståndarens tur)';

  @override
  String get preferencesTakebacksWithOpponentApproval =>
      'Ta tillbaka drag (med motståndarens godkännande)';

  @override
  String get preferencesInCasualGamesOnly => 'Endast i icke rankade partier';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promovera till drottning automatiskt';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      'Håll ner <ctrl> -tangenten medan du uppgraderar för att tillfälligt inaktivera automatisk förvandling';

  @override
  String get preferencesWhenPremoving => 'Vid förhandsdrag';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically =>
      'Begär remi automatiskt vid trefaldig upprepning';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds =>
      'När återstående tid < 30 sekunder';

  @override
  String get preferencesMoveConfirmation => 'Bekräftelse av drag';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled =>
      'Kan inaktiveras under ett spel med forummenyn';

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
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      'Säg \"Bra parti, väl spelat\" vid förlust eller remi';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Dina inställningar har sparats.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves =>
      'Bläddra på tavlan för att spela upp rörelser';

  @override
  String get preferencesCorrespondenceEmailNotification =>
      'Daglig e-postavisering som listar dina korrespondensspel';

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
  String get preferencesBlindfold => 'I blindo';

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
  String get puzzleThemeAdvancedPawn => 'Avancerande bonde';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'En bonde som promoverar eller hotar att promovera är nyckeln till taktiken.';

  @override
  String get puzzleThemeAdvantage => 'Fördel';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Ta chansen att få ett avgörande övertag. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasias matt';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'En springare samarbetar med ett torn eller en dam för att fånga motståndarkungen mellan kanten på brädet och en vänlig pjäs.';

  @override
  String get puzzleThemeArabianMate => 'Arabisk matt';

  @override
  String get puzzleThemeArabianMateDescription =>
      'En springare och ett torn samarbetar för att fånga motståndarkungen i ett hörn av brädet.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Attackera f2 eller f7';

  @override
  String get puzzleThemeAttackingF2F7Description =>
      'En attack som fokuserar på f2 eller f7 bonden, som i stekt leveröppning.';

  @override
  String get puzzleThemeAttraction => 'Attraktion';

  @override
  String get puzzleThemeAttractionDescription =>
      'Ett byte eller offer som inbjuder eller tvingar motståndarens pjäs till en ruta som ger möjlighet till fler taktiska finesser.';

  @override
  String get puzzleThemeBackRankMate => 'Plaskmatt';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Schackmatta kungen på första raden, när den är instängd av sina egna pjäser.';

  @override
  String get puzzleThemeBishopEndgame => 'Löparslutspel';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Ett slutspel med bara löpare och bönder.';

  @override
  String get puzzleThemeBodenMate => 'Bodens matt';

  @override
  String get puzzleThemeBodenMateDescription =>
      'Två attackerande löpare på korsande diagonaler sätter en kung som är blockerad av egna pjäser i matt.';

  @override
  String get puzzleThemeCastling => 'Rockad';

  @override
  String get puzzleThemeCastlingDescription =>
      'För din kung i säkerhet, och använd ditt torn till att angripa.';

  @override
  String get puzzleThemeCapturingDefender => 'Ta försvararen';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Ta en pjäs som försvarar en annan pjäs, så att du kan ta den nu oförsvarade pjäsen i nästa drag.';

  @override
  String get puzzleThemeCrushing => 'Krossande';

  @override
  String get puzzleThemeCrushingDescription =>
      'Upptäck motståndares blunder för att få en förkrossande fördel. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Matt med två löpare';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Två attackerande löpare på intilligande diagonaler sätter en kung som är blockerad av egna pjäser i matt.';

  @override
  String get puzzleThemeDovetailMate => 'Cozios matt';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'En dam levererar matt till en närliggande kung, vars enda två flyktrutor blockeras av egna pjäser.';

  @override
  String get puzzleThemeEquality => 'Utjämning';

  @override
  String get puzzleThemeEqualityDescription =>
      'Kom tillbaka från en förlorad position och säkra en remi eller en utjämnad position. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Kungsflygelattack';

  @override
  String get puzzleThemeKingsideAttackDescription =>
      'En attack mot motståndarens kung, efter att de rockerat på kungsflygeln.';

  @override
  String get puzzleThemeClearance => 'Rensning';

  @override
  String get puzzleThemeClearanceDescription =>
      'Ett drag, ofta med tempo, som rensar en ruta, linje eller diagonal för en uppföljande taktisk idé.';

  @override
  String get puzzleThemeDefensiveMove => 'Defensivt drag';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'Ett exakt drag eller sekvens av drag som är nödvändiga för att undvika att förlora material eller annan fördel.';

  @override
  String get puzzleThemeDeflection => 'Avledande drag';

  @override
  String get puzzleThemeDeflectionDescription =>
      'Ett drag som avleder en motståndarpjäs från en annan uppgift, såsom att bevaka en viktig ruta. Kallas Ibland också \"överbelastning\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Avdragsattack';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Flytta en pjäs som tidigare blockerade en attack från en annan pjäs med lång räckvidd, såsom en springare ur vägen för ett torn.';

  @override
  String get puzzleThemeDoubleCheck => 'Dubbelschack';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Schack med två pjäser i samma drag, som ett resultat av avdragsattack (avdragsschack) där både den rörliga pjäsen och den avtäckta pjäsen attackerar motståndarens kung.';

  @override
  String get puzzleThemeEndgame => 'Slutspel';

  @override
  String get puzzleThemeEndgameDescription => 'En taktik under spelets sista fas.';

  @override
  String get puzzleThemeEnPassantDescription =>
      'En taktik som involverar \"en passant\"-regeln, där en bonde kan slå en bonde som har passerat den med ett tvåstegsdrag.';

  @override
  String get puzzleThemeExposedKing => 'Oskyddad kung';

  @override
  String get puzzleThemeExposedKingDescription =>
      'En taktik som involverar en kung med få försvarare runt omkring sig, leder ofta till schack matt.';

  @override
  String get puzzleThemeFork => 'Gaffel';

  @override
  String get puzzleThemeForkDescription =>
      'Ett drag där den rörda pjäsen attackerar två motståndarpjäser samtidigt.';

  @override
  String get puzzleThemeHangingPiece => 'Ogarderad pjäs';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'En taktik som drar fördel av att en motståndares pjäs är oförsvarad eller otillräckligt försvarad och fri att slå.';

  @override
  String get puzzleThemeHookMate => 'Krokmatt';

  @override
  String get puzzleThemeHookMateDescription =>
      'Schackmatta med ett torn, en springare och en bonde tillsammans med en motståndarbonde för att begränsa motståndarkungens undanflykt.';

  @override
  String get puzzleThemeInterference => 'Interference';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Placerar en pjäs mellan två motståndares pjäser för att lämna en eller båda motståndarpjäserna ogarderade, till exempel springare på en garderad ruta mellan två torn.';

  @override
  String get puzzleThemeIntermezzo => 'Mellandrag';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'Istället för att spela det förväntade draget, görs ett annat drag som utgör ett omedelbart hot som motståndaren måste svara på. Även känt som \"zwischenzug\" eller \"intermezzo\".';

  @override
  String get puzzleThemeKillBoxMate => 'Dödsbox-matt';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'Ett torn ligger bredvid motståndarens kung och understöds av en dam som också stänger kungens flyktrutor. Tornet och damen fångar fiendens kung i en 3 gånger 3-kvadrat, \"dödsbox\".';

  @override
  String get puzzleThemeVukovicMate => 'Vukovic matt';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'Ett torn och en springare samarbetar för att fånga kungen. Tornen ger matt med stöd av en tredje pjäs, och springaren används för att blockera kungens flyktrutor.';

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
  String get puzzleThemeMasterDescription =>
      'Schackproblem från partier som spelats av spelare med mästartitel.';

  @override
  String get puzzleThemeMasterVsMaster => 'Mästare mot mästare partier';

  @override
  String get puzzleThemeMasterVsMasterDescription =>
      'Schackproblem från partier som spelats av två spelare med mästartitel.';

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
  String get puzzleThemePinDescription =>
      'En taktik som involverar fastlåsning, där en attackerad pjäs inte kan flyttas utan att exponera en mer värdefull pjäs.';

  @override
  String get puzzleThemePromotion => 'Promovering';

  @override
  String get puzzleThemePromotionDescription =>
      'En taktik som bygger på en bonde som förvandlas eller hotar att förvandlas.';

  @override
  String get puzzleThemeQueenEndgame => 'Damslutspel';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Ett slutspel med endast dam och bönder.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dam och torn';

  @override
  String get puzzleThemeQueenRookEndgameDescription =>
      'Ett slutspel med endast damer, torn och bönder.';

  @override
  String get puzzleThemeQueensideAttack => 'Damflygelattack';

  @override
  String get puzzleThemeQueensideAttackDescription =>
      'En attack mot motståndarens kung, efter att motståndaren gjort kort rockad.';

  @override
  String get puzzleThemeQuietMove => 'Tyst drag';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'Ett drag som inte gör en schackar eller slår, men förbereder ett oundvikligt hot för ett senare drag.';

  @override
  String get puzzleThemeRookEndgame => 'Tornslutspel';

  @override
  String get puzzleThemeRookEndgameDescription => 'Ett slutspel med endast torn och bönder.';

  @override
  String get puzzleThemeSacrifice => 'Offer';

  @override
  String get puzzleThemeSacrificeDescription =>
      'En taktik som innebär att man ger upp material på kort sikt, för att vinna en fördel efter en tvingande sekvens av drag.';

  @override
  String get puzzleThemeShort => 'Kort schackproblem';

  @override
  String get puzzleThemeShortDescription => 'Två drag för att vinna.';

  @override
  String get puzzleThemeSkewer => 'Dolk';

  @override
  String get puzzleThemeSkewerDescription =>
      'En taktik som innebär att en värdefull pjäs attackeras för att tvinga bort den från en pjäs bakom som då kan slås eller attackeras. Motsatsen till fastlåsning.';

  @override
  String get puzzleThemeSmotheredMate => 'Kvävmatt';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'Schack matt av en springare där den schackade kungen inte kan röra sig eftersom den är instängd (eller kvävd) av sina egna pjäser.';

  @override
  String get puzzleThemeSuperGM => 'Super GM-partier';

  @override
  String get puzzleThemeSuperGMDescription =>
      'Schackproblem från partier spelade av de bästa spelarna i världen.';

  @override
  String get puzzleThemeTrappedPiece => 'Fångad pjäs';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'En pjäs kan inte komma undan eftersom den inte kan flytta till någon bra ruta.';

  @override
  String get puzzleThemeUnderPromotion => 'Underpromovering';

  @override
  String get puzzleThemeUnderPromotionDescription =>
      'Förvandling till springare, löpare eller torn.';

  @override
  String get puzzleThemeVeryLong => 'Mycket långa schackproblem';

  @override
  String get puzzleThemeVeryLongDescription => 'Fyra eller fler drag för att vinna.';

  @override
  String get puzzleThemeXRayAttack => 'Röntgenattack';

  @override
  String get puzzleThemeXRayAttackDescription =>
      'En pjäs attackerar eller försvarar en ruta, genom en motståndarpjäs.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription =>
      'Motspelaren har begränsat antal möjliga drag, och alla möjliga drag förvärrar motspelarens position.';

  @override
  String get puzzleThemeMix => 'Blandad kompott';

  @override
  String get puzzleThemeMixDescription =>
      'Lite av varje. Du vet inte vad som kommer, så du behöver vara redo för allt! Precis som i riktiga partier.';

  @override
  String get puzzleThemePlayerGames => 'Spelarspel';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Hitta pussel genererade från dina egna parti, eller från andra spelares parti.';

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
  String get settingsCantOpenSimilarAccount =>
      'Du får inte öppna ett nytt konto med samma namn, även om du byter gemener till versaler eller tvärtom.';

  @override
  String get settingsCancelKeepAccount => 'Avbryt och behåll mitt konto';

  @override
  String get settingsCloseAccountAreYouSure => 'Är du säker på att du vill stänga ditt konto?';

  @override
  String get settingsThisAccountIsClosed => 'Det här kontot är avslutat';

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
  String get stormSkipExplanation =>
      'Skippa detta drag för att bevara din kombo! Detta fungerar bara en gång per lopp.';

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
  String get studyPleaseOnlyInvitePeopleYouKnow =>
      'Viktigt: bjud bara in människor du känner och som aktivt vill gå med i studien.';

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
  String get studyOnlyContributorsCanRequestAnalysis =>
      'Endast studiens bidragsgivare kan begära en datoranalys.';

  @override
  String get studyGetAFullComputerAnalysis => 'Hämta en fullständig serveranalys av huvudlinjen.';

  @override
  String get studyMakeSureTheChapterIsComplete =>
      'Försäkra dig om att kapitlet är färdigt. Du kan bara begära analysen en gång.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition =>
      'Alla SYNC-medlemmar är kvar på samma position';

  @override
  String get studyShareChanges => 'Dela ändringar med åskådare och spara dem på servern';

  @override
  String get studyPlaying => 'Spelar';

  @override
  String get studyShowResults => 'Resultat';

  @override
  String get studyShowEvalBar => 'Värderingsfält';

  @override
  String get studyNext => 'Nästa';

  @override
  String get studyShareAndExport => 'Dela & exportera';

  @override
  String get studyCloneStudy => 'Klona';

  @override
  String get studyStudyPgn => 'Studiens PGN';

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
  String get studyYouCanPasteThisInTheForumToEmbed =>
      'Du kan klistra in detta i forumet för att infoga';

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
  String get studyClearAllCommentsInThisChapter =>
      'Rensa alla kommentarer, symboler och former i detta kapitel?';

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
  String get studyDeleteTheStudyChatHistory =>
      'Radera studiens chatthistorik? Detta går inte att ångra!';

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
    return '$param per sida';
  }

  @override
  String get studyGetTheTour => 'Behöver du hjälp? Ta en snabbtur!';

  @override
  String get studyWelcomeToLichessStudyTitle => 'Välkommen till Lichess Studier!';

  @override
  String get studyWelcomeToLichessStudyText =>
      'Detta är ett delat analysbräde.<br><br>Använd det för att analysera och kommentera partier,<br>diskutera positioner med vänner,<br>och naturligtvis för schacklektioner!<br><br>Det är ett kraftfullt verktyg, låt oss ta lite tid att se hur det fungerar.';

  @override
  String get studySharedAndSaveTitle => 'Delat och sparat';

  @override
  String get studySharedAndSavedText =>
      'Andra medlemmar kan se dina drag i realtid!<br>Och allt sparas för evigt.';

  @override
  String get studyStudyMembersTitle => 'Studiens medlemmar';

  @override
  String studyStudyMembersText(String param1, String param2) {
    return '$param1 Åskådare kan se studien och skriva i chatten.<br><br>$param2 Bidragsgivare kan göra drag och uppdatera studien.';
  }

  @override
  String studyAddMembersText(String param) {
    return 'Klicka på $param -knappen.<br>Bestäm sedan vem som ska eller inte ska kunna bidra.';
  }

  @override
  String get studyStudyChaptersTitle => 'Studie kapitel';

  @override
  String get studyStudyChaptersText =>
      'En studie kan innehålla flera kapitel.<br>Varje kapitel har en ursprunglig position och en uppsättning drag.';

  @override
  String get studyCommentPositionTitle => 'Kommentera en position';

  @override
  String studyCommentPositionText(String param) {
    return 'Klicka på knappen $param eller högerklicka på drag-listan till höger.<br>Kommentarer delas och sparas.';
  }

  @override
  String get studyAnnotatePositionTitle => 'Annotera en position';

  @override
  String get studyAnnotatePositionText =>
      'Klicka på knappen !?, eller högerklicka på drag-listan till höger.<br>Kommentarer delas och sparas.';

  @override
  String get studyConclusionTitle => 'Tack för din tid';

  @override
  String get studyConclusionText =>
      'Du hittar dina <a href=\'/study/mine/hot\'>tidigare studier</a> på din profilsida.<br>Det finns också ett <a href=\'//lichess.org/blog/V0KrLSkAAMo3hsi4/study-chess-the-lichess-way\'>blogginlägg om studier</a>.<br>Erfarna användare kanske vill trycka på \"?\" för att se kortkommandon.<br>Ha så kul!';

  @override
  String get studyCreateChapterTitle => 'Låt oss skapa ett studiekapitel';

  @override
  String get studyCreateChapterText =>
      'En studie kan ha flera kapitel.<br>Varje kapitel har ett distinkt drag-träd,<br>och kan skapas på olika sätt.';

  @override
  String get studyFromInitialPositionTitle => 'Från ursprunglig position';

  @override
  String get studyFromInitialPositionText =>
      'Bara en bräduppställning för ett nytt parti.<br>Passar för att utforska öppningar.';

  @override
  String get studyCustomPositionTitle => 'Från position';

  @override
  String get studyCustomPositionText =>
      'Ställ in brädet sim di vill ha det.<br>Passar för att utforska slutspel.';

  @override
  String get studyLoadExistingLichessGameTitle => 'Ladda ett befintligt lichess-parti';

  @override
  String get studyLoadExistingLichessGameText =>
      'Klistra in en länk till ett lichess-parti<br>(som till exempel lichess.org/7fHIU0XI)<br>för att hämta partiets drag till kapitlet.';

  @override
  String get studyFromFenStringTitle => 'Från en FEN-sträng';

  @override
  String get studyFromFenStringText =>
      'Klistra in en position i FEN-format<br><i>4k3/4rb2/8/7p/8/5Q2/1PP5/1K6 w</i><br>för att starta kapitlet från en position.';

  @override
  String get studyFromPgnGameTitle => 'Från ett PGN-parti';

  @override
  String get studyFromPgnGameText =>
      'Klistra in ett spel i PGN-format.<br>för att hämta drag, kommentarer och variationer till kapitlet.';

  @override
  String get studyVariantsAreSupportedTitle => 'Studier stödjer varianter';

  @override
  String get studyVariantsAreSupportedText =>
      'Ja, du kan studera crazyhouse<br>och alla varianter som finns på Lichess!';

  @override
  String get studyChapterConclusionText =>
      'Kapitel sparas för evigt.<br>Ha kul med att organisera ditt schackinnehåll!';

  @override
  String get studyDoubleDefeat => 'Dubbel förlust';

  @override
  String get studyBlackDefeatWhiteCanNotWin => 'Svart förlorar, men vit kan inte vinna';

  @override
  String get studyWhiteDefeatBlackCanNotWin => 'Vitt förlorar, men svart kan inte vinna';

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

  @override
  String get timeagoJustNow => 'just nu';

  @override
  String get timeagoRightNow => 'just nu';

  @override
  String get timeagoCompleted => 'slutfört';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count sekunder',
      one: 'om $count sekund',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count minuter',
      one: 'om $count minut',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count timmar',
      one: 'om $count timme',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count dagar',
      one: 'om $count dag',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count veckor',
      one: 'om $count vecka',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count månader',
      one: 'om $count månad',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count år',
      one: 'om $count år',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuter sedan',
      one: '$count minut sedan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count timmar sedan',
      one: '$count timme sedan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagar sedan',
      one: '$count dag sedan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veckor sedan',
      one: '$count vecka sedan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count månader sedan',
      one: '$count månad sedan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count år sedan',
      one: '$count år sedan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuter återstår',
      one: '$count minut återstår',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count timmar återstår',
      one: '$count timme återstår',
    );
    return '$_temp0';
  }
}
