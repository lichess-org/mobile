// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class AppLocalizationsAf extends AppLocalizations {
  AppLocalizationsAf([String locale = 'af']) : super(locale);

  @override
  String get mobileAllGames => 'Alle spelle';

  @override
  String get mobileAreYouSure => 'Is jy seker?';

  @override
  String get mobileCancelTakebackOffer => 'Cancel takeback offer';

  @override
  String get mobileClearButton => 'Clear';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Vee gestoorde skuif uit';

  @override
  String get mobileCustomGameJoinAGame => 'Sluit aan by \'n spel';

  @override
  String get mobileFeedbackButton => 'Terugvoer';

  @override
  String mobileGreeting(String param) {
    return 'Hallo, $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Hallo';

  @override
  String get mobileHideVariation => 'Verberg variasie';

  @override
  String get mobileHomeTab => 'Tuis';

  @override
  String get mobileLiveStreamers => 'Live streamers';

  @override
  String get mobileMustBeLoggedIn => 'Jy moet ingeteken wees om hierdie bladsy te kan sien.';

  @override
  String get mobileNoSearchResults => 'Geen resultate nie';

  @override
  String get mobileNotFollowingAnyUser => 'Jy volg nie enige gebruikers nie.';

  @override
  String get mobileOkButton => 'Reg';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Spelers met \"$param\"';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Vergroot gesleepte stuk';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Wil jy hierdie lopie beëindig?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Niks om te wys nie; verander asb. die filters';

  @override
  String get mobilePuzzleStormNothingToShow => 'Nothing to show. Play some runs of Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Los soveel kopkrappers moontlik op in 3 minute.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'You will lose your current streak and your score will be saved.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Doen kopkrappers van jou gunstelingopenings, of kies \'n tema.';

  @override
  String get mobilePuzzlesTab => 'Kopkrappers';

  @override
  String get mobileRecentSearches => 'Onlangse soektogte';

  @override
  String get mobileSettingsHapticFeedback => 'Vibrasieterugvoer';

  @override
  String get mobileSettingsImmersiveMode => 'Volskermmodus';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Hide system UI while playing. Use this if you are bothered by the system\'s navigation gestures at the edges of the screen. Applies to game and Puzzle Storm screens.';

  @override
  String get mobileSettingsTab => 'Instellings';

  @override
  String get mobileShareGamePGN => 'Deel PGN';

  @override
  String get mobileShareGameURL => 'Deel spel se bronadres';

  @override
  String get mobileSharePositionAsFEN => 'Deel posisie as FEN';

  @override
  String get mobileSharePuzzle => 'Deel hierdie kopkrapper';

  @override
  String get mobileShowComments => 'Wys kommentaar';

  @override
  String get mobileShowResult => 'Wys resultaat';

  @override
  String get mobileShowVariations => 'Wys variasies';

  @override
  String get mobileSomethingWentWrong => 'Iets het skeefgeloop.';

  @override
  String get mobileSystemColors => 'Stelselkleure';

  @override
  String get mobileTheme => 'Theme';

  @override
  String get mobileToolsTab => 'Hulpmiddels';

  @override
  String get mobileWaitingForOpponentToJoin => 'Wag vir opponent om aan te sluit...';

  @override
  String get mobileWatchTab => 'Hou dop';

  @override
  String get activityActivity => 'Aktiwiteite';

  @override
  String get activityHostedALiveStream => 'Het \'n lewendige uitsending aangebied';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Rang van #$param1 uit $param2';
  }

  @override
  String get activitySignedUp => 'Geregistreer op lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het lichess.org vir $count maande ondersteun as \'n $param2',
      one: 'Het lichess.org vir $count maand ondersteun as \'n $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het $count posisies op $param2 geoefen',
      one: 'Het $count posisie op $param2 geoefen',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het $count taktiese kopkrappers opgelos',
      one: 'Het $count taktiese kopkrapper opgelos',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het $count $param2 spelle gespeel',
      one: 'Het $count $param2 spel gespeel',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het $count boodskappe in $param2 geplaas',
      one: 'Het $count boodskap in $param2 geplaas',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het $count skuiwe gespeel',
      one: 'Het $count skuif gespeel',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count korrespondensie spelle',
      one: 'in $count korrespondensie spel',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Voltooi $count korrespondensie spelle',
      one: 'Voltooi $count korrespondensie spel',
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
      other: 'Het $count spelers begin volg',
      one: 'Het $count speler begin volg',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het $count nuwe volgers bygekry',
      one: 'Het $count nuwe volger bygekry',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het $count simuls(gelyktydige ekshibisies) gereël',
      one: 'Het $count simul(gelyktydige ekshibisie) gereël',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het $count simuls(gelyktydige ekshibisies) gespeel',
      one: 'Het in $count simul(gelyktydige ekshibisie) gespeel',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het $count nuwe studies geskep',
      one: 'Het $count nuwe studie geskep',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het aan $count toernooie deelgeneem',
      one: 'Het aan $count toernooi deelgeneem',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het rang van #$count(top $param2%) met $param3 spelle in $param4',
      one: 'Het rang van #$count(top $param2%) met $param3 spel in $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het aan $count swiss toernooie deelgeneem',
      one: 'Het aan $count swiss toernooi deelgeneem',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Het aangesluit by $count spanne',
      one: 'Het aangesluit by $count span',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Uitsendings';

  @override
  String get broadcastMyBroadcasts => 'My uitsendings';

  @override
  String get broadcastLiveBroadcasts => 'Regstreekse toernooi uitsendings';

  @override
  String get broadcastBroadcastCalendar => 'Broadcast calendar';

  @override
  String get broadcastNewBroadcast => 'Nuwe regstreekse uitsendings';

  @override
  String get broadcastSubscribedBroadcasts => 'Subscribed broadcasts';

  @override
  String get broadcastAboutBroadcasts => 'About broadcasts';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'How to use Lichess Broadcasts.';

  @override
  String get broadcastTheNewRoundHelp => 'The new round will have the same members and contributors as the previous one.';

  @override
  String get broadcastAddRound => 'Voeg \'n ronde by';

  @override
  String get broadcastOngoing => 'Deurlopend';

  @override
  String get broadcastUpcoming => 'Opkomend';

  @override
  String get broadcastCompleted => 'Voltooi';

  @override
  String get broadcastCompletedHelp => 'Lichess detects round completion, but can get it wrong. Use this to set it manually.';

  @override
  String get broadcastRoundName => 'Ronde se naam';

  @override
  String get broadcastRoundNumber => 'Ronde getal';

  @override
  String get broadcastTournamentName => 'Toernooi se naam';

  @override
  String get broadcastTournamentDescription => 'Kort beskrywing van die toernooi';

  @override
  String get broadcastFullDescription => 'Volle geleentheid beskrywing';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Opsionele lang beskrywing van die uitsending. $param1 is beskikbaar. Lengte moet minder as $param2 karakters.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN-Bronskakel';

  @override
  String get broadcastSourceUrlHelp => 'URL wat Lichess sal nagaan vir PGN opdaterings. Dit moet openbaar beskikbaar wees vanaf die Internet.';

  @override
  String get broadcastSourceGameIds => 'Up to 64 Lichess game IDs, separated by spaces.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Start date in the tournament local timezone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Optioneel, indien jy weet wanner die geleentheid begin';

  @override
  String get broadcastCurrentGameUrl => 'Huidige spel se bronadres';

  @override
  String get broadcastDownloadAllRounds => 'Laai al die rondes af';

  @override
  String get broadcastResetRound => 'Herstel die ronde';

  @override
  String get broadcastDeleteRound => 'Skrap die ronde';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Skrap die rondte en sy spelle beslis uit.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Skrap alle spelle van hierdie rondte. Die bron sal aktief moet wees om hulle te kan herskep.';

  @override
  String get broadcastEditRoundStudy => 'Edit round study';

  @override
  String get broadcastDeleteTournament => 'Vee hierdie toernooi uit';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Vee beslis die hele toernooi uit, met al sy rondtes en spelle.';

  @override
  String get broadcastShowScores => 'Show players scores based on game results';

  @override
  String get broadcastReplacePlayerTags => 'Opsioneel: vervang spelername, graderings en titels';

  @override
  String get broadcastFideFederations => 'FIDE-federasies';

  @override
  String get broadcastTop10Rating => 'Top 10 gradering';

  @override
  String get broadcastFidePlayers => 'FIDE-deelnemers';

  @override
  String get broadcastFidePlayerNotFound => 'FIDE-deelnemer nie gevind nie';

  @override
  String get broadcastFideProfile => 'FIDE-profiel';

  @override
  String get broadcastFederation => 'Federasie';

  @override
  String get broadcastAgeThisYear => 'Ouderdom vanjaar';

  @override
  String get broadcastUnrated => 'Ongegradeerd';

  @override
  String get broadcastRecentTournaments => 'Onlangse toernooie';

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
    return 'Uitdagings: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Daag uit tot \'n spel';

  @override
  String get challengeChallengeDeclined => 'Uitdaging afgewys.';

  @override
  String get challengeChallengeAccepted => 'Uitdaging aanvaar!';

  @override
  String get challengeChallengeCanceled => 'Uitdaging gekanselleer.';

  @override
  String get challengeRegisterToSendChallenges => 'Registreer om uitdagings te stuur.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Jy kan nie $param uitdaag nie.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param aanvaar nie uitdagings nie.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Jou $param1 gradering is te ver van $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Kan nie uitdaag nie weens voorlopige $param gradering.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param aanvaar net uitdagings van vriende.';
  }

  @override
  String get challengeDeclineGeneric => 'Ek aanvaar nie uitdagings op die oomblik nie.';

  @override
  String get challengeDeclineLater => 'Dit is \'n ongeleë tyd, vra asseblief weer later.';

  @override
  String get challengeDeclineTooFast => 'Die tydskontrole is te vinnig vir my, daag my weer uit met \'n stadiger tydskontrole.';

  @override
  String get challengeDeclineTooSlow => 'Die tydskontrole is te stadig vir my, daag my weer uit met \'n vinniger tydskontrole.';

  @override
  String get challengeDeclineTimeControl => 'Ek aanvaar nie uitdagings met hierdie tydskontrole nie.';

  @override
  String get challengeDeclineRated => 'Stuur eerder vir my \'n gegradeerde uitdaging asseblief.';

  @override
  String get challengeDeclineCasual => 'Stuur eerder vir my \'n vriendskaplike uitdaging asseblief.';

  @override
  String get challengeDeclineStandard => 'Ek aanvaar nie variant-uitdagings op die oomblik nie.';

  @override
  String get challengeDeclineVariant => 'Ek is nie bereid om hierdie variant op die oomblik te speel nie.';

  @override
  String get challengeDeclineNoBot => 'Ek aanvaar nie uitdagings deur bots nie.';

  @override
  String get challengeDeclineOnlyBot => 'Ek aanvaar slegs uitdagings deur bots.';

  @override
  String get challengeInviteLichessUser => 'Of nooi \'n Lichess-gebruiker uit:';

  @override
  String get contactContact => 'Kontak';

  @override
  String get contactContactLichess => 'Kontak Lichess';

  @override
  String get patronDonate => 'Maak \'n skenking';

  @override
  String get patronLichessPatron => 'Lichess Beskermheer';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistiek';
  }

  @override
  String get perfStatViewTheGames => 'Bekyk die spelle';

  @override
  String get perfStatProvisional => 'voorlopig';

  @override
  String get perfStatNotEnoughRatedGames => 'Nie genoeg gegradeerde spelle is gespeel om \'n betroubare gradering te vestig nie.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Vordering oor die laaste $param spelle:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Gradering afwyking: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return '\'n Laer waarde beteken dat die gradering is meer stabiel. Bo $param1, word die gradering as voorlopig beskou. Om ingesluit te wees in die ranglys moet hierdie waarde of onder $param2 (standaard skaak) of onder $param3 (variante) wees.';
  }

  @override
  String get perfStatTotalGames => 'Totale spelle';

  @override
  String get perfStatRatedGames => 'Gegradeerde spelle';

  @override
  String get perfStatTournamentGames => 'Toernooi spelle';

  @override
  String get perfStatBerserkedGames => 'Gebeserkte spelle';

  @override
  String get perfStatTimeSpentPlaying => 'Tyd gespeel';

  @override
  String get perfStatAverageOpponent => 'Gemiddelde opponent';

  @override
  String get perfStatVictories => 'Oorwinnings';

  @override
  String get perfStatDefeats => 'Nederlae';

  @override
  String get perfStatDisconnections => 'Diskonneksies';

  @override
  String get perfStatNotEnoughGames => 'Nie genoeg spelle gespeel';

  @override
  String perfStatHighestRating(String param) {
    return 'Hoogste gradering: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Laagste gradering: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'vanaf $param1 tot $param2';
  }

  @override
  String get perfStatWinningStreak => 'Weghol-wen reeks';

  @override
  String get perfStatLosingStreak => 'Verloor reeks';

  @override
  String perfStatLongestStreak(String param) {
    return 'Langste reeks: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Huidige reeks: $param';
  }

  @override
  String get perfStatBestRated => 'Hoogste gegradeerde oorwinnings';

  @override
  String get perfStatGamesInARow => 'Spelle gespeel in \'n ry';

  @override
  String get perfStatLessThanOneHour => 'Minder as een uur tussen spelle';

  @override
  String get perfStatMaxTimePlaying => 'Maks tyd spandeer op speel';

  @override
  String get perfStatNow => 'nou';

  @override
  String get preferencesPreferences => 'Voorkeure';

  @override
  String get preferencesDisplay => 'Vertoon';

  @override
  String get preferencesPrivacy => 'Privaatheid';

  @override
  String get preferencesNotifications => 'Kennisgewings';

  @override
  String get preferencesPieceAnimation => 'Stuk animasie';

  @override
  String get preferencesMaterialDifference => 'Materiaal verskil';

  @override
  String get preferencesBoardHighlights => 'Bord hoogtepunte (onlangste skuif en skaak)';

  @override
  String get preferencesPieceDestinations => 'Stuk bestemmings (geldige skuiwe en vooraf-skuiwe)';

  @override
  String get preferencesBoardCoordinates => 'Bord koördinate (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Skuiflys tydens spel';

  @override
  String get preferencesPgnPieceNotation => 'Skuif notasie';

  @override
  String get preferencesChessPieceSymbol => 'Skaakstuk simbool';

  @override
  String get preferencesPgnLetter => 'Letter (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen Modus';

  @override
  String get preferencesShowPlayerRatings => 'Vertoon speler graderings';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Dit laat toe om alle graderings weg te steek om te help fokus op die skaak. Spelle kan steeds gegradeer word; dit is slegs oor wat jy kan sien.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Vertoon opsie om bord se groote te verander';

  @override
  String get preferencesOnlyOnInitialPosition => 'Slegs by begin posisie';

  @override
  String get preferencesInGameOnly => 'In-game only';

  @override
  String get preferencesExceptInGame => 'Except in-game';

  @override
  String get preferencesChessClock => 'Skaakklok';

  @override
  String get preferencesTenthsOfSeconds => 'Tiendes van sekondes';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => '< 10 sekondes voor tyd uitloop';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horisontale groen voortgangsbalkies';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Klank as tyd noop';

  @override
  String get preferencesGiveMoreTime => 'Gee meer tyd';

  @override
  String get preferencesGameBehavior => 'Spel gedrag';

  @override
  String get preferencesHowDoYouMovePieces => 'Hoe beweeg jy stukke?';

  @override
  String get preferencesClickTwoSquares => 'Druk op twee selle';

  @override
  String get preferencesDragPiece => 'Sleep \'n stuk';

  @override
  String get preferencesBothClicksAndDrag => 'Albei';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Vooraf-skuiwe (speel tydens opponent se beurt)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Terug-vat (met goedkeuring van opponent)';

  @override
  String get preferencesInCasualGamesOnly => 'Slegs in vriendskaplike spelle';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promoveer outomaties tot Dame';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Druk die <ctrl>-sleutel terwyl jy promoveer om outo-promovering tydelik te deaktiveer';

  @override
  String get preferencesWhenPremoving => 'Tydens vooraf-skuiwe';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Eis gelykop met drievoudige repetisie outomaties';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => '< 30 sekondes voor tyd uitloop';

  @override
  String get preferencesMoveConfirmation => 'Skuif bevestiging';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'Korrespondensie spelle';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korrespondensie en onbeperkte';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Bevestig oorgawe en gelykop voorstelle';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Kastelerings metode';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Beweeg koning twee blokkies';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Plaas koning op toring';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Voer skuiwe in met sleutelbord';

  @override
  String get preferencesInputMovesWithVoice => 'Maak skuiwe met jou stem';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Beperk pyltjies tot geldige skuiwe';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Sê \"Good game, well played\" (Goeie spel, mooi gespeel) met \'n nederlaag of gelykop';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Jou voorkeure is gestoor.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Roll die muis op die bord om skuiwe te herspeel';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Daaglikse e-pos met \'n lys van jou korrespondensiespelle';

  @override
  String get preferencesNotifyStreamStart => 'Uitsending het begin';

  @override
  String get preferencesNotifyInboxMsg => 'Nuwe inboks boodskap';

  @override
  String get preferencesNotifyForumMention => 'Jy is genoem in \'n forumboodskap';

  @override
  String get preferencesNotifyInvitedStudy => 'Studie-uitnodiging';

  @override
  String get preferencesNotifyGameEvent => 'Korrespondensiespelopdaterings';

  @override
  String get preferencesNotifyChallenge => 'Uitdagings';

  @override
  String get preferencesNotifyTournamentSoon => 'Toernooi begin binnekort';

  @override
  String get preferencesNotifyTimeAlarm => 'Korrespondensietyd raak min';

  @override
  String get preferencesNotifyBell => 'Klokkie kennisgewing binne Lichess';

  @override
  String get preferencesNotifyPush => 'Toetstel kennisgewing wanneer jy nie op Lichess is nie';

  @override
  String get preferencesNotifyWeb => 'Blaaier';

  @override
  String get preferencesNotifyDevice => 'Toestel';

  @override
  String get preferencesBellNotificationSound => 'Klokkie kennisgewing klank';

  @override
  String get preferencesBlindfold => 'Blinddoek';

  @override
  String get puzzlePuzzles => 'Raaisels';

  @override
  String get puzzlePuzzleThemes => 'Raaisel temas';

  @override
  String get puzzleRecommended => 'Aanbeveeldede';

  @override
  String get puzzlePhases => 'Fases';

  @override
  String get puzzleMotifs => 'Redes';

  @override
  String get puzzleAdvanced => 'Gevorderd';

  @override
  String get puzzleLengths => 'Lengtes';

  @override
  String get puzzleMates => 'Matte';

  @override
  String get puzzleGoals => 'Doelwitte';

  @override
  String get puzzleOrigin => 'Oorsprong';

  @override
  String get puzzleSpecialMoves => 'Spesiale bewegings';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Hou jy van hierdie raaisel?';

  @override
  String get puzzleVoteToLoadNextOne => 'Stem om die volgende een te laai!';

  @override
  String get puzzleUpVote => 'Stem vir raaisel';

  @override
  String get puzzleDownVote => 'Stem teen raaisel';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Jou raaisel gradeering sal nie verander nie. Neem kennis dat raaisels is nie \'n kompetisie nie. Jou gradeering help om die mees geskikte raaisels vir jou vermoë te kies.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Vind die beste skuif vir wit.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Vind die beste skuif vir swart.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Om persoonlike raaisels te kry:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Raaisels $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Raaisels van die dag';

  @override
  String get puzzleDailyPuzzle => 'Daaglikse Raaisel';

  @override
  String get puzzleClickToSolve => 'Druk om op te los';

  @override
  String get puzzleGoodMove => 'Goeie skuif';

  @override
  String get puzzleBestMove => 'Beste skuif!';

  @override
  String get puzzleKeepGoing => 'Hou aan…';

  @override
  String get puzzlePuzzleSuccess => 'Sukses!';

  @override
  String get puzzlePuzzleComplete => 'Raaisel voltooid!';

  @override
  String get puzzleByOpenings => 'Vir openinge';

  @override
  String get puzzlePuzzlesByOpenings => 'Raaisels vir openinge';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Openinge wat jy die meeste in gradeerde spelle speel';

  @override
  String get puzzleUseFindInPage => 'Gebruik die \"Find in page\" in die blaaier se gids om jou gunsteling opening te vind!';

  @override
  String get puzzleUseCtrlF => 'Gebruik Ctrl+f om jou gensteling opening te vind!';

  @override
  String get puzzleNotTheMove => 'Dit is nie die skuif nie!';

  @override
  String get puzzleTrySomethingElse => 'Probeer iets anders.';

  @override
  String puzzleRatingX(String param) {
    return 'Gradering: $param';
  }

  @override
  String get puzzleHidden => 'verborge';

  @override
  String puzzleFromGameLink(String param) {
    return 'Van spel $param';
  }

  @override
  String get puzzleContinueTraining => 'Gaan voort met opleiding';

  @override
  String get puzzleDifficultyLevel => 'Moeilikheidsgraad';

  @override
  String get puzzleNormal => 'Normaal';

  @override
  String get puzzleEasier => 'Makliker';

  @override
  String get puzzleEasiest => 'Maklikste';

  @override
  String get puzzleHarder => 'Moeiliker';

  @override
  String get puzzleHardest => 'Moeilikste';

  @override
  String get puzzleExample => 'Voorbeeld';

  @override
  String get puzzleAddAnotherTheme => 'Voeg nog \'n tema by';

  @override
  String get puzzleNextPuzzle => 'Volgende raaisel';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Spring onmiddellik na die volgende kopkrapper';

  @override
  String get puzzlePuzzleDashboard => 'Kopkrapper paneelbord';

  @override
  String get puzzleImprovementAreas => 'Areas van verbetering';

  @override
  String get puzzleStrengths => 'Sterkpunte';

  @override
  String get puzzleHistory => 'Kopkrapper geskiedenis';

  @override
  String get puzzleSolved => 'opgelos';

  @override
  String get puzzleFailed => 'gefaal';

  @override
  String get puzzleStreakDescription => 'Los toenemend moeiliker raaisels op en bou \'n wen reeks. Daar is nie \'n tydsfaktor nie, so vat dit rustig. Een verkeerde skuif en dit stuit! Maar jy kan \'n skuif per sessie oorslaan.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Jou wen reeks: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Slaan die skuif oor, om jou reeks te behou! Werk slegs een keer per ronde.';

  @override
  String get puzzleContinueTheStreak => 'Gaan voort met die reeks';

  @override
  String get puzzleNewStreak => 'Nuwe reeks';

  @override
  String get puzzleFromMyGames => 'Van my spelle';

  @override
  String get puzzleLookupOfPlayer => 'Beloer raaisels van \'n speler se spelle';

  @override
  String puzzleFromXGames(String param) {
    return 'Raaisels van $param se spelle';
  }

  @override
  String get puzzleSearchPuzzles => 'Soek raaisels';

  @override
  String get puzzleFromMyGamesNone => 'Jy het geen raaisels in die databasis nie, maar Lichess waardeer steeds jou.\n\nSpeel snel en klassieke spelle om jou kanse te verhoog dat een van jou eie raaisels bygevoeg word!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 raaisels gevind in $param2 se spelle';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Oefen, analiseer, verbeter';

  @override
  String puzzlePercentSolved(String param) {
    return '$param opgelos';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Niks om te wys nie, gaan los eers \'n paar raaisels op!';

  @override
  String get puzzleImprovementAreasDescription => 'Oefen hierdie om jou progressie te optimaliseer!';

  @override
  String get puzzleStrengthDescription => 'Jy presteer die beste in hierdie temas';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count keer gespeel',
      one: '$count keer gespeel',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punte onder jou raaisel gradering',
      one: 'Een punt onder jou raaisel gradering',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punt bo jou raaisel gradering',
      one: 'Een punt bo jou raaisel gradering',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gespeel',
      one: '$count gespeel',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count om te herhaal',
      one: '$count om te herhaal',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Gevorderde pion';

  @override
  String get puzzleThemeAdvancedPawnDescription => '\'n Pion wat bevorder of dreig om te bevorder, is die sleutel tot die taktiek.';

  @override
  String get puzzleThemeAdvantage => 'Voordeel';

  @override
  String get puzzleThemeAdvantageDescription => 'Gryp u kans aan om \'n deurslaggewende voordeel te behaal. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasia se mat';

  @override
  String get puzzleThemeAnastasiaMateDescription => '\'n Ruiter en \'n toring of \'n dame span saam om die opposisie koning tussen die kant van die bord en \'n vriendelike stuk vas te vang.';

  @override
  String get puzzleThemeArabianMate => 'Arebierse mat';

  @override
  String get puzzleThemeArabianMateDescription => '\'n Ruiter en \'n toring span saam om die opponerende koning in die hoek van die bord vas te vang.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Aanval f2 of f7';

  @override
  String get puzzleThemeAttackingF2F7Description => '\'n Aanval wat op die f2- of f7-pion fokus, soos in die gebraaide leweropening.';

  @override
  String get puzzleThemeAttraction => 'Aantrekkingskrag';

  @override
  String get puzzleThemeAttractionDescription => '\'N Uitwisseling of opoffering wat \'n opponentstuk aanmoedig of dwing na \'n vierkant wat \'n opvolgtaktiek moontlik maak.';

  @override
  String get puzzleThemeBackRankMate => 'Agter rang mat';

  @override
  String get puzzleThemeBackRankMateDescription => 'Skaakmat die koning op die tuisrang, as hy daar vasgevang word deur sy eie stukke.';

  @override
  String get puzzleThemeBishopEndgame => 'Biskop eindspel';

  @override
  String get puzzleThemeBishopEndgameDescription => '\'N Eindspel met slegs biskoppe en pionne.';

  @override
  String get puzzleThemeBodenMate => 'Boden se mat';

  @override
  String get puzzleThemeBodenMateDescription => 'Twee aanvallende lopers op oorkruisende diagonale mat \'n koning wat deur sy eie stukke geblok word.';

  @override
  String get puzzleThemeCastling => 'Kasteel';

  @override
  String get puzzleThemeCastlingDescription => 'Bring die koning in veiligheid en sit die toring in vir aanval.';

  @override
  String get puzzleThemeCapturingDefender => 'Vang die verdediger vas';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Verwyder \'n stuk wat van kritieke belang is vir die verdediging van \'n ander stuk, sodat die nou onverdedigde stuk op \'n volgende skuif vasgevang kan word.';

  @override
  String get puzzleThemeCrushing => 'Verpletter';

  @override
  String get puzzleThemeCrushingDescription => 'Let op die flater van die teenstander om \'n verpletterende voordeel te behaal. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Dubbel loper mat';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Twee aanvallende lopers op aaneengrensende diagonale mat \'n koning wat deur sy eie stukke vasgekeer is.';

  @override
  String get puzzleThemeDovetailMate => 'Duifstert mat';

  @override
  String get puzzleThemeDovetailMateDescription => '\'n Dame mat \'n aangrensende koning, wie se twee onsnapping\'s blokkies deur sy eie stukke geblok is.';

  @override
  String get puzzleThemeEquality => 'Gelykheid';

  @override
  String get puzzleThemeEqualityDescription => 'Kom terug uit \'n verloorposisie en verseker \'n gelykopuitslag of \'n gebalanseerde posisie. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Kingside aanval';

  @override
  String get puzzleThemeKingsideAttackDescription => '\'N Aanval van die koning van die teenstander, nadat hulle aan die koningskant gegooi het.';

  @override
  String get puzzleThemeClearance => 'Opruiming';

  @override
  String get puzzleThemeClearanceDescription => '\'N Beweging, dikwels met tempo, wat \'n vierkant, lêer of skuins skoonmaak vir \'n opvolg taktiese idee.';

  @override
  String get puzzleThemeDefensiveMove => 'Verdedigende skuif';

  @override
  String get puzzleThemeDefensiveMoveDescription => '\'N Presiese skuif of volgorde van bewegings wat benodig word om materiaal of \'n ander voordeel te verloor.';

  @override
  String get puzzleThemeDeflection => 'Buiging';

  @override
  String get puzzleThemeDeflectionDescription => '\'N Skuif wat \'n teenstander se aandag aftrek van \'n ander plig wat dit uitvoer, soos die beskerming van \'n sleutelvierkant.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ontdek aanval';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Om \'n stuk wat voorheen \'n aanval deur \'n ander langafstandstuk, soos \'n ridder, geblokkeer het, uit die pad van \'n toring te skuif.';

  @override
  String get puzzleThemeDoubleCheck => 'Maak seker';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Kontroleer met twee stukke gelyktydig, as gevolg van \'n ontdekte aanval waar beide die bewegende stuk en die onthulde stuk die teenstander se koning aanval.';

  @override
  String get puzzleThemeEndgame => 'Eindspel';

  @override
  String get puzzleThemeEndgameDescription => '\'N Taktiek tydens die laaste fase van die wedstryd.';

  @override
  String get puzzleThemeEnPassantDescription => '\'N Taktiek waarby die en passant-reël betrokke is, waar \'n pion \'n teenstanderspion kan vang wat dit omseil het met die aanvanklike beweging van twee vierkante.';

  @override
  String get puzzleThemeExposedKing => 'Blootgestelde koning';

  @override
  String get puzzleThemeExposedKingDescription => '\'N Taktiek waarby \'n koning betrokke was, met min verdedigers rondom, wat dikwels gelei het tot skaakmat.';

  @override
  String get puzzleThemeFork => 'Vurk';

  @override
  String get puzzleThemeForkDescription => '\'N Beweging waar die bewegende stuk twee teenstanderstukke gelyktydig aanval.';

  @override
  String get puzzleThemeHangingPiece => 'Hangstuk';

  @override
  String get puzzleThemeHangingPieceDescription => '\'N Taktiek waarby \'n teenstander onverdedig of onvoldoende verdedig word en vry is om vas te lê.';

  @override
  String get puzzleThemeHookMate => 'Haak mat';

  @override
  String get puzzleThemeHookMateDescription => 'Skaakmat deur \'n toring, ruiter en pion saam met een van die opponent se pione wat die ontsnapping keer.';

  @override
  String get puzzleThemeInterference => 'Inmenging';

  @override
  String get puzzleThemeInterferenceDescription => 'Om \'n stuk tussen twee teenstanderstukke te skuif om een ​​of albei teenstanderstukke onverdedig te laat, soos \'n ridder op \'n verdedigde vierkant tussen twee toring.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'In plaas daarvan om die verwagte skuif te speel, moet u eers \'n ander stap inbring wat \'n onmiddellike bedreiging inhou wat die opponent moet beantwoord. Ook bekend as \"Zwischenzug\" of \"Tussenin\".';

  @override
  String get puzzleThemeKnightEndgame => 'Ridder eindspel';

  @override
  String get puzzleThemeKnightEndgameDescription => '\'N Eindspel met net ridders en pionne.';

  @override
  String get puzzleThemeLong => 'Lang legkaart';

  @override
  String get puzzleThemeLongDescription => 'Drie skofte om te wen.';

  @override
  String get puzzleThemeMaster => 'Meester spelle';

  @override
  String get puzzleThemeMasterDescription => 'Kopkrappers uit spelle van getitelde spelers.';

  @override
  String get puzzleThemeMasterVsMaster => 'Meester vs Meester spelle';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Kopkrappers uit spelle tussen twee getitelde spelers.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Wen die spel met styl.';

  @override
  String get puzzleThemeMateIn1 => 'Mat in 1';

  @override
  String get puzzleThemeMateIn1Description => 'Lewer skaakmat in een beweging.';

  @override
  String get puzzleThemeMateIn2 => 'Mat in 2';

  @override
  String get puzzleThemeMateIn2Description => 'Lewer skaakmat in twee bewegings.';

  @override
  String get puzzleThemeMateIn3 => 'Mat in 3';

  @override
  String get puzzleThemeMateIn3Description => 'Lewer skaakmat in drie bewegings.';

  @override
  String get puzzleThemeMateIn4 => 'Mat in 4';

  @override
  String get puzzleThemeMateIn4Description => 'Lewer skaakmat in vier bewegings.';

  @override
  String get puzzleThemeMateIn5 => 'Par in 5 of meer';

  @override
  String get puzzleThemeMateIn5Description => 'Stel \'n lang paringsvolgorde uit.';

  @override
  String get puzzleThemeMiddlegame => 'Middelspel';

  @override
  String get puzzleThemeMiddlegameDescription => '\'N Taktiek tydens die tweede fase van die wedstryd.';

  @override
  String get puzzleThemeOneMove => 'Een-beweeg legkaart';

  @override
  String get puzzleThemeOneMoveDescription => '\'N Raaisel wat net een beweging lank is.';

  @override
  String get puzzleThemeOpening => 'Opening';

  @override
  String get puzzleThemeOpeningDescription => '\'N Taktiek tydens die eerste fase van die wedstryd.';

  @override
  String get puzzleThemePawnEndgame => 'Pand eindspel';

  @override
  String get puzzleThemePawnEndgameDescription => '\'N Eindspel met slegs pionne.';

  @override
  String get puzzleThemePin => 'Speld';

  @override
  String get puzzleThemePinDescription => '\'N Taktiek wat spelde insluit, waar \'n stuk nie kan beweeg sonder om \'n aanval op \'n stuk met \'n hoër waarde te openbaar nie.';

  @override
  String get puzzleThemePromotion => 'Promosie';

  @override
  String get puzzleThemePromotionDescription => '\'N Pion wat bevorder of dreig om te bevorder, is die sleutel tot die taktiek.';

  @override
  String get puzzleThemeQueenEndgame => 'Koningin eindspel';

  @override
  String get puzzleThemeQueenEndgameDescription => '\'N Eindspel met slegs koninginne en pionne.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Queen and Rook endgame';

  @override
  String get puzzleThemeQueenRookEndgameDescription => '\'N Eindspel met slegs koninginne, toring en pionne.';

  @override
  String get puzzleThemeQueensideAttack => 'Queenside aanval';

  @override
  String get puzzleThemeQueensideAttackDescription => '\'N Aanval van die koning van die opponent, nadat hulle aan die koninginkant gegooi het.';

  @override
  String get puzzleThemeQuietMove => 'Rustige skuif';

  @override
  String get puzzleThemeQuietMoveDescription => '\'N Skuif wat nie \'n tjek maak of vaslê nie, maar \'n onvermydelike bedreiging voorberei vir \'n latere skuif.';

  @override
  String get puzzleThemeRookEndgame => 'Rook eindspel';

  @override
  String get puzzleThemeRookEndgameDescription => '\'N Eindspel met slegs toring en pionne.';

  @override
  String get puzzleThemeSacrifice => 'Offer';

  @override
  String get puzzleThemeSacrificeDescription => '\'N Taktiek wat op kort termyn afstaan ​​van materiaal om weer \'n voordeel te kry na \'n gedwonge reeks bewegings.';

  @override
  String get puzzleThemeShort => 'Kort legkaart';

  @override
  String get puzzleThemeShortDescription => 'Twee skofte om te wen.';

  @override
  String get puzzleThemeSkewer => 'Sosatiepen-Aanval';

  @override
  String get puzzleThemeSkewerDescription => '\'N Motief waarby \'n waarde van \'n hoë waarde aangeval word, wat uit die weg beweeg en \'n laer waarde agter dit kan vasvang of aanval, die omgekeerde van \'n pen.';

  @override
  String get puzzleThemeSmotheredMate => 'Versmoorde mat';

  @override
  String get puzzleThemeSmotheredMateDescription => '\'N Skaakmat wat deur \'n ridder afgelewer word waarin die gepaste koning nie kan beweeg nie omdat dit deur sy eie stukke omring (of versmoor word).';

  @override
  String get puzzleThemeSuperGM => 'Super GM spelle';

  @override
  String get puzzleThemeSuperGMDescription => 'Kopkrappers uit spelle tussen die beste spelers in die wêreld.';

  @override
  String get puzzleThemeTrappedPiece => 'Vasgevang stuk';

  @override
  String get puzzleThemeTrappedPieceDescription => '\'N Stuk kan nie vang om te ontsnap nie, aangesien dit beperkte bewegings het.';

  @override
  String get puzzleThemeUnderPromotion => 'Onderbevordering';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Bevordering tot \'n ridder, biskop of toring.';

  @override
  String get puzzleThemeVeryLong => 'Baie lang legkaart';

  @override
  String get puzzleThemeVeryLongDescription => 'Vier bewegings of meer om te wen.';

  @override
  String get puzzleThemeXRayAttack => 'X-Ray aanval';

  @override
  String get puzzleThemeXRayAttackDescription => '\'N Stuk val of verdedig \'n vierkant deur \'n vyandige stuk.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Die opponent is beperk in die bewegings wat hulle kan maak, en alle bewegings vererger hul posisie.';

  @override
  String get puzzleThemeMix => 'Gesonde mengsel';

  @override
  String get puzzleThemeMixDescription => '\'N Bietjie van alles. Jy weet nie wat om te verwag nie, dus bly jy gereed vir enigiets! Net soos in regte speletjies.';

  @override
  String get puzzleThemePlayerGames => 'Speler se spelle';

  @override
  String get puzzleThemePlayerGamesDescription => 'Beloer kopkrappers wat ontstaan van jou spelle, of van ander se spelle af.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Die raaisels is in openbare domain en kan afgelaai word vanaf $param.';
  }

  @override
  String get searchSearch => 'Soek';

  @override
  String get settingsSettings => 'Instellings';

  @override
  String get settingsCloseAccount => 'Sluit rekening';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Jou rekening word bestuur en kan nie gesluit word nie.';

  @override
  String get settingsClosingIsDefinitive => 'Sluiting is finaal. Daar is geen omdraaikans nie. Is jy seker?';

  @override
  String get settingsCantOpenSimilarAccount => 'Jy sal nie toegelaat word om \'n nuwe rekening met dieselfde naam te open nie, selfs al is die hoof- en kleinletters verskillend.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Ek het van plan verander, moenie my rekening sluit nie';

  @override
  String get settingsCloseAccountExplanation => 'Is jy seker jy wil die rekening toemaak? Om die rekening toe te maak is \'n permanente besluit. Jy sal NOOIT WEER kan aanmeld nie.';

  @override
  String get settingsThisAccountIsClosed => 'Hierdie rekening is gesluit.';

  @override
  String get playWithAFriend => 'Speel teen \'n vriend';

  @override
  String get playWithTheMachine => 'Speel teen die rekenaar';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Nooi iemand vir \'n spel, gebruik hierdie URL';

  @override
  String get gameOver => 'Spel Verby';

  @override
  String get waitingForOpponent => 'Wag vir uitdager';

  @override
  String get orLetYourOpponentScanQrCode => 'Of laat jou opponent hierdie QR-kode skandeer';

  @override
  String get waiting => 'Wagtend';

  @override
  String get yourTurn => 'Jou beurt';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 vlak $param2';
  }

  @override
  String get level => 'Vlak';

  @override
  String get strength => 'Krag';

  @override
  String get toggleTheChat => 'Wissel klets';

  @override
  String get chat => 'Klets';

  @override
  String get resign => 'Gee oor';

  @override
  String get checkmate => 'Skaakmat';

  @override
  String get stalemate => 'Dooiepunt';

  @override
  String get white => 'Wit';

  @override
  String get black => 'Swart';

  @override
  String get asWhite => 'as wit';

  @override
  String get asBlack => 'as swart';

  @override
  String get randomColor => 'Lukrake kant';

  @override
  String get createAGame => 'Skep \'n spel';

  @override
  String get whiteIsVictorious => 'Wit het gewen';

  @override
  String get blackIsVictorious => 'Swart het gewen';

  @override
  String get youPlayTheWhitePieces => 'Jy speel met die wit stukke';

  @override
  String get youPlayTheBlackPieces => 'Jy speel met die swart stukke';

  @override
  String get itsYourTurn => 'Dit is jou beurt!';

  @override
  String get cheatDetected => 'BedrogOpgespoor';

  @override
  String get kingInTheCenter => 'Koning in die middel';

  @override
  String get threeChecks => 'Drie maal skaak';

  @override
  String get raceFinished => 'Race klaar';

  @override
  String get variantEnding => 'Variant geëindig';

  @override
  String get newOpponent => 'Nuwe opponent';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Jou teenstander wil weer teen jou speel';

  @override
  String get joinTheGame => 'Sluit aan by spel';

  @override
  String get whitePlays => 'Wit aan die beurt';

  @override
  String get blackPlays => 'Swart aan die beurt';

  @override
  String get opponentLeftChoices => 'Ander speler het die spel verlaat. Jy kan ’n oorwinning verklaar, gelykspel eis, of wag.';

  @override
  String get forceResignation => 'Eis die oorwinning';

  @override
  String get forceDraw => 'Eis \'n gelykop';

  @override
  String get talkInChat => 'Wees asseblief vriendelik!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Die eerste persoon wat dié skakel volg, speel teen jou.';

  @override
  String get whiteResigned => 'Wit gee oor';

  @override
  String get blackResigned => 'Swart gee oor';

  @override
  String get whiteLeftTheGame => 'Wit het die spel verlaat';

  @override
  String get blackLeftTheGame => 'Swart het die spel verlaat';

  @override
  String get whiteDidntMove => 'WitHetniebeweegnie';

  @override
  String get blackDidntMove => 'Swart het nie geskuif nie';

  @override
  String get requestAComputerAnalysis => 'Versoek \'n rekenaar analise';

  @override
  String get computerAnalysis => 'Rekenaar analise';

  @override
  String get computerAnalysisAvailable => 'Rekenaar analise beskikbaar';

  @override
  String get computerAnalysisDisabled => 'Rekenaaranalise gedeaktiveer';

  @override
  String get analysis => 'Ontledingsbord';

  @override
  String depthX(String param) {
    return 'Diepte $param';
  }

  @override
  String get usingServerAnalysis => 'Die gebruik van bediener analise';

  @override
  String get loadingEngine => 'Enjin laai tans ...';

  @override
  String get calculatingMoves => 'Bereken skuiwe...';

  @override
  String get engineFailed => 'Kon nie enjin laai nie';

  @override
  String get cloudAnalysis => 'Wolkanalise';

  @override
  String get goDeeper => 'Gaan dieper';

  @override
  String get showThreat => 'Toon bedreiging';

  @override
  String get inLocalBrowser => 'in plaaslike blaaier';

  @override
  String get toggleLocalEvaluation => 'Verander plaaslike evaluering';

  @override
  String get promoteVariation => 'Bevorder variasie';

  @override
  String get makeMainLine => 'Maak hooflyn';

  @override
  String get deleteFromHere => 'Verwyder hiervandaan';

  @override
  String get collapseVariations => 'Verberg variasies';

  @override
  String get expandVariations => 'Vertoon variasies';

  @override
  String get forceVariation => 'Forseer variasie';

  @override
  String get copyVariationPgn => 'Kopieer variasie-PGN';

  @override
  String get move => 'Skuif';

  @override
  String get variantLoss => 'Variant verloor';

  @override
  String get variantWin => 'Variant wen';

  @override
  String get insufficientMaterial => 'Onvoldoende materiaal';

  @override
  String get pawnMove => 'Pionskuif';

  @override
  String get capture => 'Buiting';

  @override
  String get close => 'Maak toe';

  @override
  String get winning => 'Besig om te wen';

  @override
  String get losing => 'Besig om te verloor';

  @override
  String get drawn => 'Gelykop gespeel';

  @override
  String get unknown => 'Onbekend';

  @override
  String get database => 'Databasis';

  @override
  String get whiteDrawBlack => 'Wit / Gelyk / Swart';

  @override
  String averageRatingX(String param) {
    return 'Gemiddelde Gradering: $param';
  }

  @override
  String get recentGames => 'Onlangse wedstryde';

  @override
  String get topGames => 'Top spelle';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Twee miljoen Oor die Bord spelle van $param1+ FIDE-gegradeerde spelers van $param2 tot $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" met afronding, gebaseer op die hoeveelheid half-skuiwe tot die volgende vat of pionskuif';

  @override
  String get noGameFound => 'Geen spel gevind';

  @override
  String get maxDepthReached => 'Maksimum diepte is bereik!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Voeg dalk meer wedstryde van die voorkeure kieslys by?';

  @override
  String get openings => 'Openinge';

  @override
  String get openingExplorer => 'Opening ontdekker';

  @override
  String get openingEndgameExplorer => 'Opening/eindspel-verkenner';

  @override
  String xOpeningExplorer(String param) {
    return '$param opening ontdekker';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Speel eerste opening/eindspel-verkenner skuif';

  @override
  String get winPreventedBy50MoveRule => 'Oorwinning gekelder deur 50-skuifreël';

  @override
  String get lossSavedBy50MoveRule => 'Verloor voorkom deur 50-skuifreël';

  @override
  String get winOr50MovesByPriorMistake => 'Wen of 50 skuiwe deur vorige fout';

  @override
  String get lossOr50MovesByPriorMistake => 'Verloor of 50 skuiwe deur vorige fout';

  @override
  String get unknownDueToRounding => 'Wen/verloor slegs gewaarborg as aanbevole tafelbasis lyn gevolg is sedert die laaste vat of pion skuif, weens moontlike afronding van DTZ waardes in Syzygy tafelbasisse.';

  @override
  String get allSet => 'Gereed!';

  @override
  String get importPgn => 'Voer PGN in';

  @override
  String get delete => 'Skrap';

  @override
  String get deleteThisImportedGame => 'Skrap hierdie ingevoerde spel?';

  @override
  String get replayMode => 'Oorspeel modus';

  @override
  String get realtimeReplay => 'Ware Tyd';

  @override
  String get byCPL => 'Met CPL';

  @override
  String get enable => 'Aktief';

  @override
  String get bestMoveArrow => 'Beste skuif pyl';

  @override
  String get showVariationArrows => 'Wys variasiepyle';

  @override
  String get evaluationGauge => 'Evaluering meter';

  @override
  String get multipleLines => 'Aantal lyne';

  @override
  String get cpus => 'CPU';

  @override
  String get memory => 'Geheue';

  @override
  String get infiniteAnalysis => 'Oneindige analise';

  @override
  String get removesTheDepthLimit => 'Verwyder dieptelimiet, en hou jou rekenaar warm';

  @override
  String get blunder => 'Flater';

  @override
  String get mistake => 'Fout';

  @override
  String get inaccuracy => 'Onakkuraatheid';

  @override
  String get moveTimes => 'Skuif tye';

  @override
  String get flipBoard => 'Keer bord om';

  @override
  String get threefoldRepetition => 'Drie-malige herhaling';

  @override
  String get claimADraw => 'Eis gelykop';

  @override
  String get offerDraw => 'Bied gelykop aan';

  @override
  String get draw => 'Gelykop';

  @override
  String get drawByMutualAgreement => 'Gelykop deur wedersydse ooreenkoms';

  @override
  String get fiftyMovesWithoutProgress => 'Vyftig skuiwe sonder vordering';

  @override
  String get currentGames => 'Lopende spelle';

  @override
  String get viewInFullSize => 'Sien in volgrootte';

  @override
  String get logOut => 'Teken uit';

  @override
  String get signIn => 'Teken in';

  @override
  String get rememberMe => 'Onthou my';

  @override
  String get youNeedAnAccountToDoThat => 'Jy het \'n rekening nodig om dit te doen';

  @override
  String get signUp => 'Registreer';

  @override
  String get computersAreNotAllowedToPlay => 'Rekenaars en rekenaargesteunde spelers word nie toegelaat om te speel. Moet asseblief nie die hulp van skaak enjins, databasisse, of uit ander spelers te kry, terwyl die speel van. Let ook daarop dat die maak van verskeie rekeninge is ten sterkste ontmoedig en oormatige multi-rekeningkunde sal lei tot verban.';

  @override
  String get games => 'Spelle';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 het \'n boodskap gepos in forum $param2';
  }

  @override
  String get latestForumPosts => 'Jongste forumplasings';

  @override
  String get players => 'Spelers';

  @override
  String get friends => 'Vriende';

  @override
  String get otherPlayers => 'ander spelers';

  @override
  String get discussions => 'Gesprekke';

  @override
  String get today => 'Vandag';

  @override
  String get yesterday => 'Gister';

  @override
  String get minutesPerSide => 'Minute per kant';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Variante';

  @override
  String get timeControl => 'Tydkontrole';

  @override
  String get realTime => 'Intyds';

  @override
  String get correspondence => 'Korrespondensie';

  @override
  String get daysPerTurn => 'Dae per beurt';

  @override
  String get oneDay => 'Een dag';

  @override
  String get time => 'Tyd';

  @override
  String get rating => 'Gradering';

  @override
  String get ratingStats => 'Gradering statistieke';

  @override
  String get username => 'Gebruiker naam';

  @override
  String get usernameOrEmail => 'Gebruikersnaam of e-pos';

  @override
  String get changeUsername => 'Verander gebruikersnaam';

  @override
  String get changeUsernameNotSame => 'Slegs die hoof-/kleinletters kan verander. Byvoorbeeld \"pietsmit\" na \"PietSmit\".';

  @override
  String get changeUsernameDescription => 'Verander jou gebruikersnaam. Dit kan slegs een keer gedoen word, en jy kan net die hoof-/kleinletters in die gebruikersnaam verander.';

  @override
  String get signupUsernameHint => 'Kies asseblief \'n aanvaarbare gebruikersnaam. Dit kan nie later verander word nie, en enige onaanvaarbare gebruikersname sal gesluit word!';

  @override
  String get signupEmailHint => 'Dit sal slegs gebruik word om wagwoorde te herstel.';

  @override
  String get password => 'Wagwoord';

  @override
  String get changePassword => 'Verander wagwoord';

  @override
  String get changeEmail => 'Verander e-pos';

  @override
  String get email => 'E-pos';

  @override
  String get passwordReset => 'Wagwoord herstel';

  @override
  String get forgotPassword => 'Wagwoord vergeet?';

  @override
  String get error_weakPassword => 'Hierdie wagwoord is besonder algemeen en maklik om te raai.';

  @override
  String get error_namePassword => 'Moenie jou gebruikernaam as wagwoord gebruik nie.';

  @override
  String get blankedPassword => 'Jy het die selfde wagwoord op \'n ander webwerf gebruik, en die wagwoord was ontbloot. Om die veiligheid van jou Lichess rekening te verseker, moet ons jou wagwoord vervang. Dankie vir jou samewerking.';

  @override
  String get youAreLeavingLichess => 'Jy verlaat Lichess';

  @override
  String get neverTypeYourPassword => 'Moenie jou Lichess wagwoord ooit op \'n ander werf intik nie!';

  @override
  String proceedToX(String param) {
    return 'Gaan na $param';
  }

  @override
  String get passwordSuggestion => 'Moenie \'n wagwoord gebruik wat deur iemand anders voorgestel is nie. Dit kan gebruik word om jou rekening te steel.';

  @override
  String get emailSuggestion => 'Moenie \'n epos-adres gebruik wat deur iemand anders voorgestel is nie. Dit kan gebruik word om jou rekening te steel.';

  @override
  String get emailConfirmHelp => 'Hulp met e-posbevestiging';

  @override
  String get emailConfirmNotReceived => 'Geen bevestigingsboodskap ontvang nadat jy ingeteken het nie?';

  @override
  String get whatSignupUsername => 'Watter gebruikersnaam het jy gebruik om mee in te teken?';

  @override
  String usernameNotFound(String param) {
    return 'Kon geen gebruiker met hierdie naam vind nie: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Gebruk hierdie gebruikersnaam om \'n nuwe rekening te skep';

  @override
  String emailSent(String param) {
    return 'Ons het \'n e-pos gestuur na $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Dit mag \'n rukkie neem om te ontvang.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Wag 5 minute en verfris jou e-pos.';

  @override
  String get checkSpamFolder => 'Kyk ook in jou strooipos lêer, dit mag dalk daarin opeinding. In dien dit die geval is, merk dit as nie strooipos nie.';

  @override
  String get emailForSignupHelp => 'Indien niks werk nie, stuur die volgende boodskap:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopieer en plak die teks hierbo en stuur dit na $param';
  }

  @override
  String get waitForSignupHelp => 'Ons sal spoedig na jou terugkom en jou help met die intekenproses.';

  @override
  String accountConfirmed(String param) {
    return 'Die gebruiker $param is bevestig.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Jy kan nou inteken as $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Jy benodig nie \'n bevestigingsboodskap nie.';

  @override
  String accountClosed(String param) {
    return 'Die rekening $param is gesluit.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Die rekening $param is geregistreer sonder \'n e-pos.';
  }

  @override
  String get rank => 'Rang';

  @override
  String rankX(String param) {
    return 'Rang: $param';
  }

  @override
  String get gamesPlayed => 'Spelle gespeel';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Kanseleer';

  @override
  String get whiteTimeOut => 'Wit tyd verstreke';

  @override
  String get blackTimeOut => 'Swart time-out';

  @override
  String get drawOfferSent => 'Gelykop aanbod gestuur';

  @override
  String get drawOfferAccepted => 'Gelykop aanbod aanvaar';

  @override
  String get drawOfferCanceled => 'Gelykop aanbod gekanselleer';

  @override
  String get whiteOffersDraw => 'Wit maak gelykspel aanbod';

  @override
  String get blackOffersDraw => 'Swart maak gelykspel aanbod';

  @override
  String get whiteDeclinesDraw => 'Wit wys gelykspel aanbod van die hand';

  @override
  String get blackDeclinesDraw => 'Swart wys gelykspel aanbod van die hand';

  @override
  String get yourOpponentOffersADraw => 'Jou teenstander bied gelykop aan';

  @override
  String get accept => 'Aanvaar';

  @override
  String get decline => 'Verwerp';

  @override
  String get playingRightNow => 'In spel';

  @override
  String get eventInProgress => 'Tans besig om te speel';

  @override
  String get finished => 'Klaar';

  @override
  String get abortGame => 'Staak spel';

  @override
  String get gameAborted => 'Spel gestaak';

  @override
  String get standard => 'Standaard';

  @override
  String get customPosition => 'Gebruiklike Posisie';

  @override
  String get unlimited => 'Oneindig';

  @override
  String get mode => 'Modus';

  @override
  String get casual => 'Vriendskaplik';

  @override
  String get rated => 'Gegradeer';

  @override
  String get casualTournament => 'Vriendskaplik';

  @override
  String get ratedTournament => 'Gegradeer';

  @override
  String get thisGameIsRated => 'Hierdie spel is gegradeer';

  @override
  String get rematch => 'Herwedstryd';

  @override
  String get rematchOfferSent => 'Herwedstryd aanbod gestuur';

  @override
  String get rematchOfferAccepted => 'Herwedstryd aanbod aanvaar';

  @override
  String get rematchOfferCanceled => 'Herwedstryd aanbod gekanselleer';

  @override
  String get rematchOfferDeclined => 'Herwedstryd aanbod afgewys';

  @override
  String get cancelRematchOffer => 'Wys herwedstryd aanbod af';

  @override
  String get viewRematch => 'Sien heruitdagingsaanbod';

  @override
  String get confirmMove => 'Bevestig skuif';

  @override
  String get play => 'Speel';

  @override
  String get inbox => 'Inbox';

  @override
  String get chatRoom => 'Kletskamer';

  @override
  String get loginToChat => 'Teken in om te klets';

  @override
  String get youHaveBeenTimedOut => 'Jy het nie nou toegang tot die kletskamer nie.';

  @override
  String get spectatorRoom => 'Toeskouer kamer';

  @override
  String get composeMessage => 'Tik boodskap';

  @override
  String get subject => 'Onderwerp';

  @override
  String get send => 'Stuur';

  @override
  String get incrementInSeconds => 'Inkrement in sekondes';

  @override
  String get freeOnlineChess => 'Gratis Aanlyn Skaak';

  @override
  String get exportGames => 'Spelle aflaai (export)';

  @override
  String get ratingRange => 'Gradering reeks';

  @override
  String get thisAccountViolatedTos => 'Hierdie rekening oortree die diensvoorwaardes van Lichess';

  @override
  String get openingExplorerAndTablebase => 'Openings-verkenner & tafelbasis';

  @override
  String get takeback => 'Terug-vat';

  @override
  String get proposeATakeback => 'Stel terug-vat voor';

  @override
  String get takebackPropositionSent => 'Terug-vat aanbod gestuur';

  @override
  String get takebackPropositionDeclined => 'Terug-vat aanbod afgewys';

  @override
  String get takebackPropositionAccepted => 'Terug-vat aanvaar';

  @override
  String get takebackPropositionCanceled => 'Terug-vat aanbod gekanselleer';

  @override
  String get yourOpponentProposesATakeback => 'Jou teenstander stel \'n terug-vat voor';

  @override
  String get bookmarkThisGame => 'Boekmerk die spel';

  @override
  String get tournament => 'Toernooi';

  @override
  String get tournaments => 'Toernooie';

  @override
  String get tournamentPoints => 'Toernooipunte';

  @override
  String get viewTournament => 'Sien toernooi';

  @override
  String get backToTournament => 'Terug na toernooi';

  @override
  String get noDrawBeforeSwissLimit => 'Geen gelykop voor 30 skuiwe tydens \'n Switserse toernooi nie.';

  @override
  String get thematic => 'Tematies';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Jou $param gradering is voorlopig';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Jou $param1 gradering ($param2) is te hoog';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Jou top weeklikse $param1 gradering ($param2) is te hoog';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Jou $param1 gradering ($param2) is te laag';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Gradering ≥ $param1 in $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rated ≥ $param1 in $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Moet in $param span wees';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Jy is nie in $param span nie';
  }

  @override
  String get backToGame => 'Terug na spel';

  @override
  String get siteDescription => 'Gratis aanlyn Skaak spel. Speel nou Skaak met \'n maklike skerm. Geen registrasie nodig, geen advertensies, niks om te installeer. Speel Skaak teen rekenaar, vriende of nuwe uitdagers.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 het aangesluit by span $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 het span $param2 geskep';
  }

  @override
  String get startedStreaming => 'het begin met \'n uitsending';

  @override
  String xStartedStreaming(String param) {
    return '$param het begin met \'n uitsending';
  }

  @override
  String get averageElo => 'Gemiddelde gradering';

  @override
  String get location => 'Ligging';

  @override
  String get filterGames => 'Spel filter';

  @override
  String get reset => 'Herstel';

  @override
  String get apply => 'Pas toe';

  @override
  String get save => 'Stoor';

  @override
  String get leaderboard => 'Leierbord';

  @override
  String get screenshotCurrentPosition => 'Neem \'n skermfoto van die huidige posisie';

  @override
  String get gameAsGIF => 'Spel as \'n GIF';

  @override
  String get pasteTheFenStringHere => 'Plak die FEN string hier';

  @override
  String get pasteThePgnStringHere => 'Plak die PGN string hier';

  @override
  String get orUploadPgnFile => 'Of laai ‘n PGN-lêer op';

  @override
  String get fromPosition => 'Van posisie';

  @override
  String get continueFromHere => 'Gaan voort van hier af';

  @override
  String get toStudy => 'Bestudeer';

  @override
  String get importGame => 'Voer spel in';

  @override
  String get importGameExplanation => 'Plak \'n wedstryd PGN om dit deursoekbaar te herspeel,\nrekenaar analise, kletskamer en deelbare URL te kry.';

  @override
  String get importGameCaveat => 'Variasies sal uitgevee word. Voer die PGN in d.m.v. \'n studie om hulle te behou.';

  @override
  String get importGameDataPrivacyWarning => 'Hierdie PGN is toeganklik vir die algemene publiek. Gebruik \'n studie om \'n spel privaat in te voer.';

  @override
  String get thisIsAChessCaptcha => 'Hierdie is \'n skaak CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Kliek op die bord om jou skuif te maak, en te bewys jy is \'n mens.';

  @override
  String get captcha_fail => 'Los asseblief die skaak captcha op.';

  @override
  String get notACheckmate => 'Nie skaakmat nie';

  @override
  String get whiteCheckmatesInOneMove => 'Wit om te skaakmat in een skuif';

  @override
  String get blackCheckmatesInOneMove => 'Swart om te skaakmat in een skuif';

  @override
  String get retry => 'Probeer weer';

  @override
  String get reconnecting => 'Konnekteer weer';

  @override
  String get noNetwork => 'Vanlyn af';

  @override
  String get favoriteOpponents => 'Gunsteling opponente';

  @override
  String get follow => 'Volg';

  @override
  String get following => 'Besig om te volg';

  @override
  String get unfollow => 'Ontvolg';

  @override
  String followX(String param) {
    return 'Volg $param';
  }

  @override
  String unfollowX(String param) {
    return 'Ontvolg $param';
  }

  @override
  String get block => 'Blokeer';

  @override
  String get blocked => 'Geblok';

  @override
  String get unblock => 'Ontblok';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 het begin om $param2 te volg';
  }

  @override
  String get more => 'Meer';

  @override
  String get memberSince => 'Lid sedert';

  @override
  String lastSeenActive(String param) {
    return 'Laas ingeteken $param';
  }

  @override
  String get player => 'Speler';

  @override
  String get list => 'Lys';

  @override
  String get graph => 'Grafiek';

  @override
  String get required => 'Vereiste.';

  @override
  String get openTournaments => 'Oop toernooie';

  @override
  String get duration => 'Duur';

  @override
  String get winner => 'Wenner';

  @override
  String get standing => 'Stand';

  @override
  String get createANewTournament => 'Skep \'n nuwe toernooi';

  @override
  String get tournamentCalendar => 'Toernooidagboek';

  @override
  String get conditionOfEntry => 'Inskrywing vereistes:';

  @override
  String get advancedSettings => 'Gevorderde instellings';

  @override
  String get safeTournamentName => 'Kies \'n baie veilige naam vir die toernooi.';

  @override
  String get inappropriateNameWarning => 'Enige iets ongepaste kan maak dat jou rekening gesluit word.';

  @override
  String get emptyTournamentName => 'Laat leeg om die toernooi na \'n noemenswaardige speler te vernoem.';

  @override
  String get makePrivateTournament => 'Maak die toernooi privaat, en beperk toegang met \'n wagwoord';

  @override
  String get join => 'Sluit aan';

  @override
  String get withdraw => 'Ontrek';

  @override
  String get points => 'Punte';

  @override
  String get wins => 'Oorwinnings';

  @override
  String get losses => 'Verliese';

  @override
  String get createdBy => 'Geskep deur';

  @override
  String get tournamentIsStarting => 'Toernooi gaan nou begin';

  @override
  String get tournamentPairingsAreNowClosed => 'Die toernooi plasings is nou gesluit.';

  @override
  String standByX(String param) {
    return 'Op jou merke, $param, plaas tans spelers, maak gereed!';
  }

  @override
  String get pause => 'Onderbreek';

  @override
  String get resume => 'Hervat';

  @override
  String get youArePlaying => 'Jy speel nou!';

  @override
  String get winRate => 'Wen koers';

  @override
  String get berserkRate => 'Beserk koers';

  @override
  String get performance => 'Prestasie plasing';

  @override
  String get tournamentComplete => 'Toernooi afgehandel';

  @override
  String get movesPlayed => 'Skuiwe gespeel';

  @override
  String get whiteWins => 'Gewen deur wit';

  @override
  String get blackWins => 'Gewen deur swart';

  @override
  String get drawRate => 'Gelykopwaarskynlikheid';

  @override
  String get draws => 'Gelykop gespeel';

  @override
  String nextXTournament(String param) {
    return 'Volgende $param toernooi:';
  }

  @override
  String get averageOpponent => 'Gemmidelde opponent';

  @override
  String get boardEditor => 'Bord redigeerder';

  @override
  String get setTheBoard => 'Pak die bord';

  @override
  String get popularOpenings => 'Gewilde openinge';

  @override
  String get endgamePositions => 'Eindspel posisies';

  @override
  String chess960StartPosition(String param) {
    return 'Skaak960 begin posisie: $param';
  }

  @override
  String get startPosition => 'Begin posisie';

  @override
  String get clearBoard => 'Maak bord skoon';

  @override
  String get loadPosition => 'Laai posisie';

  @override
  String get isPrivate => 'Privaat';

  @override
  String reportXToModerators(String param) {
    return 'Raporteer $param aan moderators';
  }

  @override
  String profileCompletion(String param) {
    return 'Profiel voltooiing: $param';
  }

  @override
  String xRating(String param) {
    return '$param gradering';
  }

  @override
  String get ifNoneLeaveEmpty => 'As geen, los oop';

  @override
  String get profile => 'Profiel';

  @override
  String get editProfile => 'Verander profiel';

  @override
  String get realName => 'Regte naam';

  @override
  String get setFlair => 'Stel jou Vlam';

  @override
  String get flair => 'Vlam';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Biografie';

  @override
  String get countryRegion => 'Land of streek';

  @override
  String get thankYou => 'Dankie!';

  @override
  String get socialMediaLinks => 'Sosiale media skakels';

  @override
  String get oneUrlPerLine => 'Een skakel per lyn.';

  @override
  String get inlineNotation => 'Binnelyn notasie';

  @override
  String get makeAStudy => 'Oorweeg dit om \'n studie te skep om te bewaar en met ander te deel.';

  @override
  String get clearSavedMoves => 'Verwyder skuiwe';

  @override
  String get previouslyOnLichessTV => 'Voorigekeer op Lichess TV';

  @override
  String get onlinePlayers => 'Aanlyn spelers';

  @override
  String get activePlayers => 'Aktiewe spelers';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Pasop, dié spel is gegradeer, maar sonder \'n klok!';

  @override
  String get success => 'Sukses';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Gaan outomaties voort na die volgende spel ná jy skuif';

  @override
  String get autoSwitch => 'Outomatiese oorskakel';

  @override
  String get puzzles => 'Kopkrappers';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Naam';

  @override
  String get description => 'Beskrywing';

  @override
  String get descPrivate => 'Private beskrywing';

  @override
  String get descPrivateHelp => 'Teks wat slegs spanlede sal sien. Indien gestel vervang dit die publieke beskrywing vir spanlede.';

  @override
  String get no => 'Nee';

  @override
  String get yes => 'Ja';

  @override
  String get website => 'Webtuiste';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Help:';

  @override
  String get createANewTopic => 'Skep \'n nuwe onderwerp';

  @override
  String get topics => 'Onderwerpe';

  @override
  String get posts => 'Plasings';

  @override
  String get lastPost => 'Nuutste plasing';

  @override
  String get views => 'Kyke';

  @override
  String get replies => 'Antwoorde';

  @override
  String get replyToThisTopic => 'Antwoord op hierdie onderwerp';

  @override
  String get reply => 'Antwoord';

  @override
  String get message => 'Boodskap';

  @override
  String get createTheTopic => 'Skep die onderwerp';

  @override
  String get reportAUser => 'Rapporteer \'n gebruiker';

  @override
  String get user => 'Gebruiker';

  @override
  String get reason => 'Rede';

  @override
  String get whatIsIheMatter => 'Wat makeer?';

  @override
  String get cheat => 'Kul';

  @override
  String get troll => 'Boelie';

  @override
  String get other => 'Ander';

  @override
  String get reportCheatBoostHelp => 'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp => 'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish => 'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink => 'Verskaf asseblief ten minste een skakel na \'n spel waar hulle gekroek het.';

  @override
  String by(String param) {
    return 'deur $param';
  }

  @override
  String importedByX(String param) {
    return 'Ingevoer deur $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Hierdie onderwerp is nou gesluit.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notas';

  @override
  String get typePrivateNotesHere => 'Tik private notas hier in';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Skryf \'n private nota oor hierdie verbruiker';

  @override
  String get noNoteYet => 'Nog geen nota nie';

  @override
  String get invalidUsernameOrPassword => 'Ongeldige gebruikersnaam of wagwoord';

  @override
  String get incorrectPassword => 'Verkeerde wagwoord';

  @override
  String get invalidAuthenticationCode => 'Ongeldige verifikasiekode';

  @override
  String get emailMeALink => 'E-pos \'n skakel aan my';

  @override
  String get currentPassword => 'Huidige wagwoord';

  @override
  String get newPassword => 'Nuwe wagwoord';

  @override
  String get newPasswordAgain => 'Nuwe wagwoord (weer)';

  @override
  String get newPasswordsDontMatch => 'Die nuwe wagwoorde stem nie ooreen nie';

  @override
  String get newPasswordStrength => 'Wagwoord sterkte';

  @override
  String get clockInitialTime => 'Aanvanklike kloktyd';

  @override
  String get clockIncrement => 'Klok inkrement';

  @override
  String get privacy => 'Privaatheid';

  @override
  String get privacyPolicy => 'Privaatheid Beleid';

  @override
  String get letOtherPlayersFollowYou => 'Laat toe dat ander spelers jou te volg';

  @override
  String get letOtherPlayersChallengeYou => 'Laat toe dat ander spelers jou uitdaag';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Laat ander spelers toe om jou na studies te nooi';

  @override
  String get sound => 'Klank';

  @override
  String get none => 'Geen';

  @override
  String get fast => 'Vinnig';

  @override
  String get normal => 'Normaal';

  @override
  String get slow => 'Stadig';

  @override
  String get insideTheBoard => 'In die bord';

  @override
  String get outsideTheBoard => 'Buite die bord';

  @override
  String get allSquaresOfTheBoard => 'Al die blokkies van die bord';

  @override
  String get onSlowGames => 'Op stadig spelle';

  @override
  String get always => 'Altyd';

  @override
  String get never => 'Nooit';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 kompeteer in $param2';
  }

  @override
  String get victory => 'Oorwinning';

  @override
  String get defeat => 'Nederlaag';

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
  String get timeline => 'Tydlyn';

  @override
  String get starting => 'Aanvang:';

  @override
  String get allInformationIsPublicAndOptional => 'Alle besonderhede is openbaar en nie-verpligtend.';

  @override
  String get biographyDescription => 'Vertel oor jouself, jou belangstellings, jou skaak passies, jou gunsteling openinge, spelers, ...';

  @override
  String get listBlockedPlayers => 'Lys geweierde spelers';

  @override
  String get human => 'Mens';

  @override
  String get computer => 'Rekenaar';

  @override
  String get side => 'Kant';

  @override
  String get clock => 'Klok';

  @override
  String get opponent => 'Opponent';

  @override
  String get learnMenu => 'Verryking';

  @override
  String get studyMenu => 'Studies';

  @override
  String get practice => 'Oefen';

  @override
  String get community => 'Gemeenskap';

  @override
  String get tools => 'Gereedskap';

  @override
  String get increment => 'Inkrement';

  @override
  String get error_unknown => 'Ongeldige waarde';

  @override
  String get error_required => 'Dié veld word vereis';

  @override
  String get error_email => 'Hierdie epos adres is ongeldig';

  @override
  String get error_email_acceptable => 'Hierdie e-pos adres is nie aanvaarbaar nie. Maak seker dis reg en probeer weer.';

  @override
  String get error_email_unique => 'E-pos adres is ongeldig of reeds geneem';

  @override
  String get error_email_different => 'Hierdie is reeds jou e-pos adres';

  @override
  String error_minLength(String param) {
    return 'Moet ten minste $param karakters lank wees';
  }

  @override
  String error_maxLength(String param) {
    return 'Moet op die meeste $param karakters lank wees';
  }

  @override
  String error_min(String param) {
    return 'Moet minstens $param wees';
  }

  @override
  String error_max(String param) {
    return 'Moet meestens $param wees';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Indien gradering ± $param is';
  }

  @override
  String get ifRegistered => 'Sleg geregistreerdes';

  @override
  String get onlyExistingConversations => 'Slegs bestaande gesprekke';

  @override
  String get onlyFriends => 'Slegs vriende';

  @override
  String get menu => 'Kieslys';

  @override
  String get castling => 'Kastelering';

  @override
  String get whiteCastlingKingside => 'Wit O-O';

  @override
  String get blackCastlingKingside => 'Swart O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tyd gespeel: $param';
  }

  @override
  String get watchGames => 'Hou spelle dop';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tyd op TV: $param';
  }

  @override
  String get watch => 'Bekyk';

  @override
  String get videoLibrary => 'Video biblioteek';

  @override
  String get streamersMenu => 'Aanbieders';

  @override
  String get mobileApp => 'Mobiele Toep';

  @override
  String get webmasters => 'Webmeesters';

  @override
  String get about => 'Leer meer';

  @override
  String aboutX(String param) {
    return 'Leer meer oor $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 is ’n gratis ($param2), vry, oopbron-skaakbediener sonder advertensies.';
  }

  @override
  String get really => 'regtig';

  @override
  String get contribute => 'Dra by';

  @override
  String get termsOfService => 'Bepalings en Voorwaardes';

  @override
  String get sourceCode => 'Bron Kode';

  @override
  String get simultaneousExhibitions => 'Gelyktydige uitstallings(Simul)';

  @override
  String get host => 'Gasheer';

  @override
  String hostColorX(String param) {
    return 'Gasheer kleur: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Nuwe simuls';

  @override
  String get hostANewSimul => 'Bied \'n nuwe simul aan';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Simul nie gevind nie';

  @override
  String get noSimulExplanation => 'Dit gelyktydige uitstalling(simul) bestaan ​​nie.';

  @override
  String get returnToSimulHomepage => 'Terug na simul tuisblad';

  @override
  String get aboutSimul => 'Simuls behels dat \'n enkele speler \'n paar spelers gelyktydig in die gesig staar.';

  @override
  String get aboutSimulImage => 'Uit 50 teenstanders, het Fischer 47 wedstryde gewen, 2 gelykop gespeel en 1 verloor.';

  @override
  String get aboutSimulRealLife => 'Die konsep is geneem uit regte geleenthede. In die werklike lewe, behels die simul dat die gasheer beweeg van tafel tot tafel om \'n enkele skuif te speel.';

  @override
  String get aboutSimulRules => 'Wanneer die simul begin, begin elke speler \'n spel met die gasheer, die gasheer kry altyd die wit stukke. Die simul eindig wanneer al die spelle is voltooi.';

  @override
  String get aboutSimulSettings => 'Simuls is altyd vriendskaplik. Heruitdagings, terug-vat en ekstra tyd is afgeskakel.';

  @override
  String get create => 'Skep';

  @override
  String get whenCreateSimul => 'As jy \'n Simul skep, kan jy teen \'n paar spelers gelyktydig speel.';

  @override
  String get simulVariantsHint => 'As jy \'n paar variasies kies, kan elke speler kies watter een om te speel.';

  @override
  String get simulClockHint => 'Fischer Klok stelling. Hoe meer spelers wat jy aanvat, hoe meer tyd kan jy benodig.';

  @override
  String get simulAddExtraTime => 'Jy kan ekstra tyd by jou klok sit om jou te help om die simul te hanteer.';

  @override
  String get simulHostExtraTime => 'Gasheer ekstra kloktyd';

  @override
  String get simulAddExtraTimePerPlayer => 'Voeg begintyd by jou klok vir elke speler wat die simul aansluit.';

  @override
  String get simulHostExtraTimePerPlayer => 'Gasheer ekstra tyd per speller';

  @override
  String get lichessTournaments => 'Lichess toernooie';

  @override
  String get tournamentFAQ => 'Arena toernooi Vrae';

  @override
  String get timeBeforeTournamentStarts => 'Tydsduur tot aanvang van toernooi';

  @override
  String get averageCentipawnLoss => 'Gemiddelde sentipion verlies';

  @override
  String get accuracy => 'Akkuraatheid';

  @override
  String get keyboardShortcuts => 'Sleutelbord kortpaaie';

  @override
  String get keyMoveBackwardOrForward => 'skuif terug/vorentoe';

  @override
  String get keyGoToStartOrEnd => 'gaan na begin/einde';

  @override
  String get keyCycleSelectedVariation => 'Wissel geselekteerde variasie';

  @override
  String get keyShowOrHideComments => 'vertoon/versteek kommentaar';

  @override
  String get keyEnterOrExitVariation => 'betree/verlaat variasie';

  @override
  String get keyRequestComputerAnalysis => 'Vra rekenaaranalise aan, Leer uit jou foute';

  @override
  String get keyNextLearnFromYourMistakes => 'Volgende (Leer uit jou foute)';

  @override
  String get keyNextBlunder => 'Volgende flater';

  @override
  String get keyNextMistake => 'Volgende fout';

  @override
  String get keyNextInaccuracy => 'Volgende onakkuraatheid';

  @override
  String get keyPreviousBranch => 'Vorige tak';

  @override
  String get keyNextBranch => 'Volgende tak';

  @override
  String get toggleVariationArrows => 'Wissel variasie pyle';

  @override
  String get cyclePreviousOrNextVariation => 'Wissel vorige/volgende variasie';

  @override
  String get toggleGlyphAnnotations => 'Wissel glyf-annotasies';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => 'Variasie pyle laat jou toe om te vaar sonder die skuif lys.';

  @override
  String get playSelectedMove => 'speel geselekteerde skuif';

  @override
  String get newTournament => 'Nuwe toernooi';

  @override
  String get tournamentHomeTitle => 'Skaaktoernooie met verskeie tydkontroles en variante';

  @override
  String get tournamentHomeDescription => 'Speel hoë-tempo skaak toernooie! Sluit aan by \'n amptelik geskeduleerde toernooi, of skep jou eie. Bullet, Blitz, klassiek, Skaak960, Heuwel Heerser, Trippelskaak, en meer beskikbare opsies vir oneindige skaak pret.';

  @override
  String get tournamentNotFound => 'Toernooi nie te vinde';

  @override
  String get tournamentDoesNotExist => 'Dié toernooi bestaan nie.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Dit kon gekanselleer wees, indien alle spelers die toernooi verlaat het voor die aanvang daarvan.';

  @override
  String get returnToTournamentsHomepage => 'Keer terug na die toernooie tuisblad';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Weeklikse $param gradering verdeling';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Jou $param1 gradering is $param2';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Jy vaar beter as $param1 van $param2 spelers.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 is beter as $param2 van $param3 spelers.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Beter as $param1 uit $param2 spelers';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Jy het nie \'n gevestigde $param gradering nie.';
  }

  @override
  String get yourRating => 'Jou gradering';

  @override
  String get cumulative => 'Kumulatiewe';

  @override
  String get glicko2Rating => 'Glicko-2 gradering';

  @override
  String get checkYourEmail => 'Kyk na jou e-pos';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Ons het vir jou \'n e-pos gestuur. Klik die skakel in die e-pos om jou rekening te aktiveer.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'As jy nie die e-pos sien nie, kyk na ander plekke waar dit kan wees, soos jou gemorspos, sosiaal en ander leêrs.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Ons het \'n e-pos na $param gestuur. Klik die skakel in die e-pos om die wagwoord te herstel.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Deur te regisreer, stem jy in om aan ons $param gebonde te wees.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lees oor ons $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Netwerk lag tussen jou en Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tyd om ’n skuif op Lichess se bediener te verwerk';

  @override
  String get downloadAnnotated => 'Laai geannoteerde af';

  @override
  String get downloadRaw => 'Laai rou af';

  @override
  String get downloadImported => 'Aflaai ingevoer';

  @override
  String get crosstable => 'Kruistabel';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Jy kan ook blaai oor die bord om te beweeg in die spel.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Hou die muis oor die rekenaar variante om dit te voorskou.';

  @override
  String get analysisShapesHowTo => 'Druk shift+klik of regs-kliek om sirkels en pyle te trek op die bord.';

  @override
  String get letOtherPlayersMessageYou => 'Laat ander spelers boodskappe aan jou stuur';

  @override
  String get receiveForumNotifications => 'Laat weet wanneer in die forum genoem word';

  @override
  String get shareYourInsightsData => 'Deel jou data oor Skaak Insigte';

  @override
  String get withNobody => 'Met niemand';

  @override
  String get withFriends => 'Met vriende';

  @override
  String get withEverybody => 'Met almal';

  @override
  String get kidMode => 'Kinder mode';

  @override
  String get kidModeIsEnabled => 'Kindermodus is geaktiveer.';

  @override
  String get kidModeExplanation => 'Hierdie gaan oor veiligheid. In kindermodus, alle webwerf kommunikasie word afgeskakel. Skakel dit aan vir jou kinders en skoliere, om hulle te beskerm teen ander internet gebruikers.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'In kindermodus kry die Lichess handelsmerk \'n $param ikoon, sodat jy weet jou kinders is veilig.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Jou rekening word bestuur deur jou skaak onderwyser. Vra hulle om kinder modus af te skakel.';

  @override
  String get enableKidMode => 'Skakel kindermodus aan';

  @override
  String get disableKidMode => 'Skakel kindermodus aan';

  @override
  String get security => 'Sekuriteit';

  @override
  String get sessions => 'Sessies';

  @override
  String get revokeAllSessions => 'alle sessies herroep';

  @override
  String get playChessEverywhere => 'Speel skaak oral';

  @override
  String get asFreeAsLichess => 'So gratis soos Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Gebou as gevolg van die liefde vir skaak, nie geld nie';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Almal kry al die funksies gratis';

  @override
  String get zeroAdvertisement => 'Niks advertensies';

  @override
  String get fullFeatured => 'Volledige kenmerke';

  @override
  String get phoneAndTablet => 'Selfoon en tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, klassieke';

  @override
  String get correspondenceChess => 'Korrespondensie skaak';

  @override
  String get onlineAndOfflinePlay => 'Aanlyn en aflyn speel';

  @override
  String get viewTheSolution => 'Kyk na die oplossing';

  @override
  String get followAndChallengeFriends => 'Volg en daag vriende uit';

  @override
  String get gameAnalysis => 'Spel analise';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 bied $param2 aan';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 sluit by $param2 aan';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 hou van $param2';
  }

  @override
  String get quickPairing => 'Vinnige plasing';

  @override
  String get lobby => 'Ontvangs';

  @override
  String get anonymous => 'Anoniem';

  @override
  String yourScore(String param) {
    return 'Jou puntetelling: $param';
  }

  @override
  String get language => 'Taal';

  @override
  String get background => 'Agtergrond';

  @override
  String get light => 'Lig';

  @override
  String get dark => 'Donker';

  @override
  String get transparent => 'Deurdigtig';

  @override
  String get deviceTheme => 'Toestel se tema';

  @override
  String get backgroundImageUrl => 'Agtergrond prent URL:';

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
  String get pieceSet => 'Stuk stel';

  @override
  String get embedInYourWebsite => 'Embed in jou webwerf';

  @override
  String get usernameAlreadyUsed => 'Hierdie gebruikersnaam is reeds in gebruik, probeer asseblief \'n ander een.';

  @override
  String get usernamePrefixInvalid => 'Die gebruikersnaam moet met \'n letter begin.';

  @override
  String get usernameSuffixInvalid => 'Die gebruikersnaam moet met \'n letter of nommer eindig.';

  @override
  String get usernameCharsInvalid => 'Die gebruikersnaam mag net letters, nommers, onderstrepings en koppeltekens bevat.';

  @override
  String get usernameUnacceptable => 'Hierdie gebruikersnaam is nie aanvaarbaar nie.';

  @override
  String get playChessInStyle => 'Speel skaak in styl';

  @override
  String get chessBasics => 'Grondbeginsels';

  @override
  String get coaches => 'Afrigters';

  @override
  String get invalidPgn => 'Ongeldige PGN';

  @override
  String get invalidFen => 'Ongeldige FEN';

  @override
  String get custom => 'Pasmaak';

  @override
  String get notifications => 'Kennisgewings';

  @override
  String notificationsX(String param1) {
    return 'Kennisgewings: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Gradering: $param';
  }

  @override
  String get practiceWithComputer => 'Oefen met \'n rekenaar';

  @override
  String anotherWasX(String param) {
    return 'Nog een was $param';
  }

  @override
  String bestWasX(String param) {
    return 'Beste was $param';
  }

  @override
  String get youBrowsedAway => 'Jy het weggedwaal';

  @override
  String get resumePractice => 'Hervat oefening';

  @override
  String get drawByFiftyMoves => 'Hierdie spel is gelykop weens die vyftig-skuif reël.';

  @override
  String get theGameIsADraw => 'Die spel is gelykop.';

  @override
  String get computerThinking => 'Die rekenaar dink ...';

  @override
  String get seeBestMove => 'Bekyk die beste skuif';

  @override
  String get hideBestMove => 'Versteek die beste skuif';

  @override
  String get getAHint => 'Kry \'n leidraad';

  @override
  String get evaluatingYourMove => 'Jou skuif word geëvalueer ...';

  @override
  String get whiteWinsGame => 'Wit wen';

  @override
  String get blackWinsGame => 'Swart wen';

  @override
  String get learnFromYourMistakes => 'Leer uit jou foute';

  @override
  String get learnFromThisMistake => 'Leer uit hierdie fout';

  @override
  String get skipThisMove => 'Slaan hierdie skuif oor';

  @override
  String get next => 'Volgende';

  @override
  String xWasPlayed(String param) {
    return '$param is gespeel';
  }

  @override
  String get findBetterMoveForWhite => 'Kry \'n beter skuif vir wit';

  @override
  String get findBetterMoveForBlack => 'Kry \'n beter skuif vir swart';

  @override
  String get resumeLearning => 'Leer verder';

  @override
  String get youCanDoBetter => 'Jy kan daarop verbeter';

  @override
  String get tryAnotherMoveForWhite => 'Probeer \'n ander skuif vir wit';

  @override
  String get tryAnotherMoveForBlack => 'Probeer \'n ander skuif vir swart';

  @override
  String get solution => 'Oplossing';

  @override
  String get waitingForAnalysis => 'Wag nog vir rekenaar analise';

  @override
  String get noMistakesFoundForWhite => 'Geen foute gevind vir wit nie';

  @override
  String get noMistakesFoundForBlack => 'Geen foute vir swart gevind nie';

  @override
  String get doneReviewingWhiteMistakes => 'Wit se foute is klaar hersien';

  @override
  String get doneReviewingBlackMistakes => 'Swart se foute is klaar hersien';

  @override
  String get doItAgain => 'Doen dit weer';

  @override
  String get reviewWhiteMistakes => 'Hersien wit se foute';

  @override
  String get reviewBlackMistakes => 'Hersien swart se foute';

  @override
  String get advantage => 'Voordeel';

  @override
  String get opening => 'Opening';

  @override
  String get middlegame => 'Middelspel';

  @override
  String get endgame => 'Eindspel';

  @override
  String get conditionalPremoves => 'Voorwaardelike voorafskuiwe';

  @override
  String get addCurrentVariation => 'Voeg huidige variasie by';

  @override
  String get playVariationToCreateConditionalPremoves => 'Speel \'n variasie om voorwaardige voorafskuiwe te skep';

  @override
  String get noConditionalPremoves => 'Geen voorwaardelike voorafskuiwe';

  @override
  String playX(String param) {
    return 'Speel $param';
  }

  @override
  String get showUnreadLichessMessage => 'Jy het \'n privaatboodskap van Lichess ontvang.';

  @override
  String get clickHereToReadIt => 'Klik hier om dit te lees';

  @override
  String get sorry => 'Skies :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Jy moet vir \'n rukkie in die hoek sit.';

  @override
  String get why => 'Hoekom?';

  @override
  String get pleasantChessExperience => 'Ons poog om \'n aangename ervaring aan alle spelers te gee.';

  @override
  String get goodPractice => 'Om dit reg te kry, moet ons seker maak dat alle spelers goeie praktyke handhaaf.';

  @override
  String get potentialProblem => 'As \'n potensiele probleem opgemerk word, wys ons hierdie boodskap.';

  @override
  String get howToAvoidThis => 'Hoe om hierdie te vermy?';

  @override
  String get playEveryGame => 'Speel elke wedstryd wat jy begin.';

  @override
  String get tryToWin => 'Probeer om te wen (of ten minste gelykop) elke keer as jy speel.';

  @override
  String get resignLostGames => 'Gee hopelose wedstryde oor (moenie dat jou tyd uithardloop nie).';

  @override
  String get temporaryInconvenience => 'Ons vra omverskoning vir die tydelike ongerief,';

  @override
  String get wishYouGreatGames => 'en ons wens jou voorspoed toe vir jou spelle op lichess.org.';

  @override
  String get thankYouForReading => 'Dankie vir die tyd!';

  @override
  String get lifetimeScore => 'Lewenslange punte';

  @override
  String get currentMatchScore => 'Huidige reeks puntetelling';

  @override
  String get agreementAssistance => 'Ek stem in om nooit enige hulp te ontvang tydens my spelle nie (vanaf \'n skaakrekenaar, boek, databasis of ander persoon).';

  @override
  String get agreementNice => 'Ek stem in om altyd respek aan ander spelers te betoon.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Ek verklaar dat ek nie meer as een rekening sal skep nie (met die uitsondering van redes genoem in die $param).';
  }

  @override
  String get agreementPolicy => 'Ek stem in om al Lichess se beleide na te volg.';

  @override
  String get searchOrStartNewDiscussion => 'Soek of begin \'n nuwe gesprek';

  @override
  String get edit => 'Pas aan';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blits';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Klassieke';

  @override
  String get ultraBulletDesc => 'Bitter vinnige spelle: minder as 30 sekondes';

  @override
  String get bulletDesc => 'Baie vinnige spelle: minder as 3 minute';

  @override
  String get blitzDesc => 'Vinnige spelle: 3 tot 8 minute';

  @override
  String get rapidDesc => 'Rapid spelle: 8 tot 25 minute';

  @override
  String get classicalDesc => 'Klassieke spelle: 25 minute en meer';

  @override
  String get correspondenceDesc => 'Korrespondensie spelle: een of meer dae per skuif';

  @override
  String get puzzleDesc => 'Skaak kopkrapper instrukteur';

  @override
  String get important => 'Tshivenda';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Your question may already have an answer $param1';
  }

  @override
  String get inTheFAQ => 'in die F.A.Q.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Om \'n gebruiker aan te kondig vir bedrog of slegte gedrag, $param1';
  }

  @override
  String get useTheReportForm => 'gebruik die meldingsformulier';

  @override
  String toRequestSupport(String param1) {
    return 'Om hulp te vra, $param1';
  }

  @override
  String get tryTheContactPage => 'probeer die kontak bladsy';

  @override
  String makeSureToRead(String param1) {
    return 'Maak seker om $param1 te lees';
  }

  @override
  String get theForumEtiquette => 'die forum etiket';

  @override
  String get thisTopicIsArchived => 'Hierdie onderwerp is geargiveer en kan nie meer beantwoord word nie.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Sluit aan by die $param1 om in hierdie forum te plaas';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 span';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'U kan nog nie in die forums plaas nie. Speel \'n paar speletjies!';

  @override
  String get subscribe => 'Skryf in';

  @override
  String get unsubscribe => 'Beëindig inskrywing';

  @override
  String mentionedYouInX(String param1) {
    return 'het jou genoem in \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 het jou genoem in \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'het jou genooi na \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 het jou genooi na \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Jy is nou deel van die span.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Jy het by \"$param1\" aangesluit.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Iemand wat jy aangemeld het, is verban';

  @override
  String get congratsYouWon => 'Baie geluk, jy het gewen!';

  @override
  String gameVsX(String param1) {
    return 'Spel teen $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 teen $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Jy het teen iemand verloor wat nie die Lichess bepalings nagekom het nie';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Terugbetaling:$param1 $param2 graderingspunte.';
  }

  @override
  String get timeAlmostUp => 'Tyd is byna op!';

  @override
  String get clickToRevealEmailAddress => '[Klik om e-posadres te beskou]';

  @override
  String get download => 'Laai af';

  @override
  String get coachManager => 'Afrigter bestuurder';

  @override
  String get streamerManager => 'Uitsender bestuurder';

  @override
  String get cancelTournament => 'Kanseleer die toernooi';

  @override
  String get tournDescription => 'Toernooi beskrywing';

  @override
  String get tournDescriptionHelp => 'Enige iets spesiaal wat jy aan die deelnemers wil vertel? Probeer dit kort hou. \"Markdown\" skakels is beskikbaar: [name](https://url)';

  @override
  String get ratedFormHelp => 'Spelle is gegradeer\nen beïnvloed speler graderings';

  @override
  String get onlyMembersOfTeam => 'Slegs lede van span';

  @override
  String get noRestriction => 'Geen beperking';

  @override
  String get minimumRatedGames => 'Minimum gegradeerde spelle';

  @override
  String get minimumRating => 'Minimum gradering';

  @override
  String get maximumWeeklyRating => 'Maksimum weeklikse gradering';

  @override
  String positionInputHelp(String param) {
    return 'Plak \'n geldige FEN om elke spel van \'n sekere posisie te begin.\nDit werk slegs met standaard spelle, nie met variante nie.\nJy kan die $param gebruik om \'n FEN posisie te genereer, en dit dan hier plak.\nLaat dit leeg om elke spel vanaf die normale posisie te begin.';
  }

  @override
  String get cancelSimul => 'Kanseleer die simul';

  @override
  String get simulHostcolor => 'Gasheer kleur vir elke spel';

  @override
  String get estimatedStart => 'Verwagte begin tyd';

  @override
  String simulFeatured(String param) {
    return 'Vertoon op $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Wys jou simul aan almal op $param. Deaktiveer vir private simuls.';
  }

  @override
  String get simulDescription => 'Simul beskrywing';

  @override
  String get simulDescriptionHelp => 'Enige iets wat jy vir die deelnemers wil vertel?';

  @override
  String markdownAvailable(String param) {
    return '$param is beskikbaar vir meer ingewikkelde sintaks.';
  }

  @override
  String get embedsAvailable => 'Plak \'n spel URL of a studie hoofstuk URL om dit in te bed.';

  @override
  String get inYourLocalTimezone => 'In you eie plaaslike tydsone';

  @override
  String get tournChat => 'Toernooi klets';

  @override
  String get noChat => 'Geen klets';

  @override
  String get onlyTeamLeaders => 'Slegs spanleiers';

  @override
  String get onlyTeamMembers => 'Slegs spanlede';

  @override
  String get navigateMoveTree => 'Skuif boom navigasie';

  @override
  String get mouseTricks => 'Muis toertjies';

  @override
  String get toggleLocalAnalysis => 'Wissel plaaslike rekenaar analise';

  @override
  String get toggleAllAnalysis => 'Wissel alle rekenaar analise';

  @override
  String get playComputerMove => 'Speel die beste rekenaarskuif';

  @override
  String get analysisOptions => 'Analise opsies';

  @override
  String get focusChat => 'Lê fokus klets';

  @override
  String get showHelpDialog => 'Wys hierdie hulp dialoog';

  @override
  String get reopenYourAccount => 'Herstel jou rekening';

  @override
  String get closedAccountChangedMind => 'As jou rekening gesluit het, maar het intussen van plan verander, kry jy sleg een kans om jou rekening terug te kry.';

  @override
  String get onlyWorksOnce => 'Dié sal slegs een keer werk.';

  @override
  String get cantDoThisTwice => 'In die jy jou rekening \'n tweede keer sluit, sal daar nie \'n manier wees om dit te herstel nie.';

  @override
  String get emailAssociatedToaccount => 'E-pos adress geassosieer met die rekening';

  @override
  String get sentEmailWithLink => 'Ons het vir jou \'n e-pos met n skakel gestuur.';

  @override
  String get tournamentEntryCode => 'Toernooi ingangskode';

  @override
  String get hangOn => 'Hou vas!';

  @override
  String gameInProgress(String param) {
    return 'Jou het \'n spel met $param aan die gang.';
  }

  @override
  String get abortTheGame => 'Staak die spel';

  @override
  String get resignTheGame => 'Bedank die spel';

  @override
  String get youCantStartNewGame => 'Jy kan nie \'n nuwe spel begin nie, tot hierdie spel klaar is.';

  @override
  String get since => 'Sedert';

  @override
  String get until => 'Tot';

  @override
  String get lichessDbExplanation => 'Gegradeerde spelle gekies uit alle Lichess-spelers';

  @override
  String get switchSides => 'Ruil kante';

  @override
  String get closingAccountWithdrawAppeal => 'Sluiting van jou rekening beteken terugtrekking van jou appèl';

  @override
  String get ourEventTips => 'Ons wenke om gebeurtenisse te organiseer';

  @override
  String get instructions => 'Instruksies';

  @override
  String get showMeEverything => 'Wys vir my alles';

  @override
  String get lichessPatronInfo => 'Lichess is \'n liefdadigheidsorganisasie en heeltemal gratis/libre oopbron sagteware.\nAlle bestuurskostes, ontwikkeling en inhoud word heeltemal gefinansier deur lede bydraes.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String get stats => 'Stats';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jou opponent het die spel verlaat. Jy kan die oorwinning in $count sekondes eis.',
      one: 'Jou opponent het die spel verlaat. Jy kan die oorwinning in $count sekonde eis.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat in $count half-skuiwe',
      one: 'Mat in $count half-skuif',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count flaters',
      one: '$count flater',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foute',
      one: '$count fout',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count onakuraathede',
      one: '$count onakuraatheid',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelers',
      one: '$count speler',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sien al $count spelle',
      one: 'Sien al $count spelle',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gradering oor $param2 spelle',
      one: '$count gradering oor $param2 spel',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count boekmerke',
      one: '$count boekmerk',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dae',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ure',
      one: '$count uur',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minute',
      one: '$count minuut',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rang word elke $count minute opgedateer',
      one: 'Rang word elke minuut opgedateer',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kopkrappers',
      one: '$count kopkrapper',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelle teen jou',
      one: '$count spel teen jou',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gegradeer',
      one: '$count gegradeer',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gewen',
      one: '$count gewen',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verloor',
      one: '$count verloor',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gelykop',
      one: '$count gelykop',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count In Spel',
      one: '$count In Spel',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gee $count sekondes',
      one: 'Gee $count sekonde',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count toernooipunte',
      one: '$count toernooipunt',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studies',
      one: '$count studie',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simulasies',
      one: '$count simulasie',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count gegradeerde spelle',
      one: '≥ $count gegradeerde spel',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 gegradeerde spelle',
      one: '≥ $count $param2 gegradeerde spel',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jy het nodig om $count meer gegradeerde $param2 spelle te speel',
      one: 'Jy het nodig om $count meer gegradeerde $param2 spel te speel',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jy moet $count meer gegradeerde spelle speel',
      one: 'Jy moet $count meer gegradeerde spel speel',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count het spelle ingetrek',
      one: '$count ingevoerde spel',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aanlyn vriende',
      one: '$count aanlyn vriend',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gevolg deur $count',
      one: 'Gevolg deur $count',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'volg $count',
      one: 'volg $count',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Minder as $count minute',
      one: 'Minder as $count minuut',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelle aan die gang',
      one: '$count spel aan die gang',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimum: $count karakters.',
      one: 'Maksimum: $count karakter.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weieringe',
      one: '$count weiering',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forum plasings',
      one: '$count forum plasing',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 spelers hierdie week.',
      one: '$count $param2 speler hierdie week.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Beskikbaar in $count tale!',
      one: 'Beskikbaar in $count taal!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekondes om die eerste skuif te speel',
      one: '$count sekonde om die eerste skuif te speel',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekondes',
      one: '$count sekonde',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'en stoor $count voorafskuif variasies',
      one: 'en stoor $count voorafskuif variasie',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Skuif om te begin';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Jy speel wit in al die raaisels';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Jy speel swart in al die raaisels';

  @override
  String get stormPuzzlesSolved => 'raaisels opgelos';

  @override
  String get stormNewDailyHighscore => 'Nuwe daaglikse hoë telling!';

  @override
  String get stormNewWeeklyHighscore => 'Nuwe weeklikse hoë telling!';

  @override
  String get stormNewMonthlyHighscore => 'Nuwe maandelikse hoë telling!';

  @override
  String get stormNewAllTimeHighscore => 'Nuwe hoë telling van alle tye!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Vorige hoë telling was $param';
  }

  @override
  String get stormPlayAgain => 'Speel weer';

  @override
  String stormHighscoreX(String param) {
    return 'Hoë telling: $param';
  }

  @override
  String get stormScore => 'Telling';

  @override
  String get stormMoves => 'Skuiwe';

  @override
  String get stormAccuracy => 'Akkuraatheid';

  @override
  String get stormCombo => 'Kombinasie';

  @override
  String get stormTime => 'Tyd';

  @override
  String get stormTimePerMove => 'Tyd per skuif';

  @override
  String get stormHighestSolved => 'Hoogste opgelos';

  @override
  String get stormPuzzlesPlayed => 'Raaisels opgelos';

  @override
  String get stormNewRun => 'Nuwe lopie (kortpad sleutel: spasie)';

  @override
  String get stormEndRun => 'Beëinding lopie (kortpad sleutel: \'Enter\')';

  @override
  String get stormHighscores => 'Hoë tellings';

  @override
  String get stormViewBestRuns => 'Beloer beste lopies';

  @override
  String get stormBestRunOfDay => 'Beste lopie van die dag';

  @override
  String get stormRuns => 'Lopies';

  @override
  String get stormGetReady => 'Wees gereed!';

  @override
  String get stormWaitingForMorePlayers => 'Wag vir meer spelers om aan te sluit...';

  @override
  String get stormRaceComplete => 'Wedren voltooid!';

  @override
  String get stormSpectating => 'Toeskou';

  @override
  String get stormJoinTheRace => 'Neem deel aan die reisies!';

  @override
  String get stormStartTheRace => 'Begin die reisies';

  @override
  String stormYourRankX(String param) {
    return 'Jou rang: $param';
  }

  @override
  String get stormWaitForRematch => 'Wag vir herwedstryd';

  @override
  String get stormNextRace => 'Volgende reisies';

  @override
  String get stormJoinRematch => 'Sluit by herwedstryd aan';

  @override
  String get stormWaitingToStart => 'Wag om te begin';

  @override
  String get stormCreateNewGame => 'Maak \'n nuwe spel';

  @override
  String get stormJoinPublicRace => 'Sluit aan by \'n openbare reisies';

  @override
  String get stormRaceYourFriends => 'Reisies teen jou vriende';

  @override
  String get stormSkip => 'slaan oor';

  @override
  String get stormSkipHelp => 'Jy kan een skuif per reisies oorslaan:';

  @override
  String get stormSkipExplanation => 'Slaan die skuif oor, om jou kombinasie te behou! Werk slegs een keer per reisies.';

  @override
  String get stormFailedPuzzles => 'Mislukte raaisels';

  @override
  String get stormSlowPuzzles => 'Vertraagde raaisels';

  @override
  String get stormSkippedPuzzle => 'Raaisel oorgeslaan';

  @override
  String get stormThisWeek => 'Hierdie week';

  @override
  String get stormThisMonth => 'Hierdie maand';

  @override
  String get stormAllTime => 'Van alle tye';

  @override
  String get stormClickToReload => 'Druk om te herlaai';

  @override
  String get stormThisRunHasExpired => 'Hierdie lopie het versper!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Hierdie lopie was oop in \'n ander oortjie!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lopies',
      one: '1 lopie',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Speel $count lopies van $param2',
      one: 'Speel een lopie van $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess aanbieders';

  @override
  String get studyPrivate => 'Privaat';

  @override
  String get studyMyStudies => 'My studies';

  @override
  String get studyStudiesIContributeTo => 'Studies waartoe ek bydra';

  @override
  String get studyMyPublicStudies => 'My publieke studies';

  @override
  String get studyMyPrivateStudies => 'My privaat studies';

  @override
  String get studyMyFavoriteStudies => 'My gunsteling studies';

  @override
  String get studyWhatAreStudies => 'Wat is studies?';

  @override
  String get studyAllStudies => 'Alle studies';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studies gemaak deur $param';
  }

  @override
  String get studyNoneYet => 'Nog geen.';

  @override
  String get studyHot => 'Gewild';

  @override
  String get studyDateAddedNewest => 'Datum bygevoeg (nuutste)';

  @override
  String get studyDateAddedOldest => 'Datum bygevoeg (oudste)';

  @override
  String get studyRecentlyUpdated => 'Onlangs opgedateer';

  @override
  String get studyMostPopular => 'Mees gewilde';

  @override
  String get studyAlphabetical => 'Alfabeties';

  @override
  String get studyAddNewChapter => 'Voeg \'n nuwe hoofstuk by';

  @override
  String get studyAddMembers => 'Voeg iemand by';

  @override
  String get studyInviteToTheStudy => 'Nooi uit om deel te wees van die studie';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Nooi asseblief net mense uit wat jy ken of wat aktief wil deelneem aan die studie.';

  @override
  String get studySearchByUsername => 'Soek vir gebruikersnaam';

  @override
  String get studySpectator => 'Toeskouer';

  @override
  String get studyContributor => 'Bydraer';

  @override
  String get studyKick => 'Verwyder';

  @override
  String get studyLeaveTheStudy => 'Verlaat die studie';

  @override
  String get studyYouAreNowAContributor => 'Jy is nou \'n bydraer';

  @override
  String get studyYouAreNowASpectator => 'Jy is nou \'n toeskouer';

  @override
  String get studyPgnTags => 'PGN etikette';

  @override
  String get studyLike => 'Hou van';

  @override
  String get studyUnlike => 'Afkeur';

  @override
  String get studyNewTag => 'Nuwe etiket';

  @override
  String get studyCommentThisPosition => 'Lewer kommentaar op hierdie posisie';

  @override
  String get studyCommentThisMove => 'Lewer kommentaar op hierdie skuif';

  @override
  String get studyAnnotateWithGlyphs => 'Annoteer met karakters';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Die hoofstuk is te kort om geanaliseer te word.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Slegs die studie bydraers kan versoek om \'n rekenaar analise te doen.';

  @override
  String get studyGetAFullComputerAnalysis => 'Kry \'n vol-bediener rekenaar analise van die hooflyn.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Maak seker dat die hoofstuk volledig is. Jy kan slegs eenkeer \'n analise versoek.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Alle SYNC lede bly op dieselfde posisie';

  @override
  String get studyShareChanges => 'Deel veranderinge met toeskouers en stoor dit op die bediener';

  @override
  String get studyPlaying => 'Besig om te speel';

  @override
  String get studyShowEvalBar => 'Evaluation bars';

  @override
  String get studyFirst => 'Eerste';

  @override
  String get studyPrevious => 'Vorige';

  @override
  String get studyNext => 'Volgende';

  @override
  String get studyLast => 'Laaste';

  @override
  String get studyShareAndExport => 'Deel & voer uit';

  @override
  String get studyCloneStudy => 'Kloneer';

  @override
  String get studyStudyPgn => 'Studie PGN';

  @override
  String get studyDownloadAllGames => 'Laai alle speletjies af';

  @override
  String get studyChapterPgn => 'Hoofstuk PGN';

  @override
  String get studyCopyChapterPgn => 'Kopieer PGN';

  @override
  String get studyDownloadGame => 'Aflaai spel';

  @override
  String get studyStudyUrl => 'Bestudeer URL';

  @override
  String get studyCurrentChapterUrl => 'Huidige hoofstuk URL';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'U kan dit in die forum plak om in te bed';

  @override
  String get studyStartAtInitialPosition => 'Begin by die oorspronklike posisie';

  @override
  String studyStartAtX(String param) {
    return 'Begin by $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Bed in u webwerf of blog';

  @override
  String get studyReadMoreAboutEmbedding => 'Lees meer oor inbedding';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Slegs openbare studies kan ingebed word!';

  @override
  String get studyOpen => 'Maak oop';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1, aan jou beskikbaar gestel deur $param2';
  }

  @override
  String get studyStudyNotFound => 'Studie kon nie gevind word nie';

  @override
  String get studyEditChapter => 'Verander die hoofstuk';

  @override
  String get studyNewChapter => 'Nuwe hoofstuk';

  @override
  String studyImportFromChapterX(String param) {
    return 'Voer in vanaf $param';
  }

  @override
  String get studyOrientation => 'Oriëntasie';

  @override
  String get studyAnalysisMode => 'Analiseer mode';

  @override
  String get studyPinnedChapterComment => 'Vasgepende hoofstuk kommentaar';

  @override
  String get studySaveChapter => 'Stoor hoofstuk';

  @override
  String get studyClearAnnotations => 'Vee annotasies uit';

  @override
  String get studyClearVariations => 'Verwyder variasies';

  @override
  String get studyDeleteChapter => 'Vee hoofstuk uit';

  @override
  String get studyDeleteThisChapter => 'Vee die hoofstuk uit? Jy gaan dit nie kan terugvat nie!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Vee al die kommentaar, karakters en getekende vorms in die hoofstuk uit?';

  @override
  String get studyRightUnderTheBoard => 'Reg onder die bord';

  @override
  String get studyNoPinnedComment => 'Geen';

  @override
  String get studyNormalAnalysis => 'Normale analise';

  @override
  String get studyHideNextMoves => 'Versteek die volgende skuiwe';

  @override
  String get studyInteractiveLesson => 'Interaktiewe les';

  @override
  String studyChapterX(String param) {
    return 'Hoofstuk $param';
  }

  @override
  String get studyEmpty => 'Leeg';

  @override
  String get studyStartFromInitialPosition => 'Begin vanaf oorspronklike posisie';

  @override
  String get studyEditor => 'Redakteur';

  @override
  String get studyStartFromCustomPosition => 'Begin vanaf eie posisie';

  @override
  String get studyLoadAGameByUrl => 'Laai \'n wedstryd op deur die URL';

  @override
  String get studyLoadAPositionFromFen => 'Laai posisie vanaf FEN';

  @override
  String get studyLoadAGameFromPgn => 'Laai wedstryd vanaf PGN';

  @override
  String get studyAutomatic => 'Outomaties';

  @override
  String get studyUrlOfTheGame => 'URL van die wedstryd';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Laai \'n wedstryd van $param1 of $param2';
  }

  @override
  String get studyCreateChapter => 'Skep \'n hoofstuk';

  @override
  String get studyCreateStudy => 'Skep \'n studie';

  @override
  String get studyEditStudy => 'Verander studie';

  @override
  String get studyVisibility => 'Sigbaarheid';

  @override
  String get studyPublic => 'Publiek';

  @override
  String get studyUnlisted => 'Ongelys';

  @override
  String get studyInviteOnly => 'Slegs op uitnodiging';

  @override
  String get studyAllowCloning => 'Laat kloning toe';

  @override
  String get studyNobody => 'Niemand';

  @override
  String get studyOnlyMe => 'Net ek';

  @override
  String get studyContributors => 'Bydraers';

  @override
  String get studyMembers => 'Lede';

  @override
  String get studyEveryone => 'Almal';

  @override
  String get studyEnableSync => 'Maak sync beskikbaar';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Ja: hou almal op dieselfde posisie';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Nee: laat mense toe om vrylik deur te gaan';

  @override
  String get studyPinnedStudyComment => 'Vasgepende studie opmerking';

  @override
  String get studyStart => 'Begin';

  @override
  String get studySave => 'Stoor';

  @override
  String get studyClearChat => 'Maak die gesprek skoon';

  @override
  String get studyDeleteTheStudyChatHistory => 'Vee die gesprek uit? Onthou, jy kan dit nie terug kry nie!';

  @override
  String get studyDeleteStudy => 'Vee die studie uit';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Skrap die hele studie? Daar is geen terugkeer nie! Tik die naam van die studie om te bevesting: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Waar wil jy dit bestudeer?';

  @override
  String get studyGoodMove => 'Goeie skuif';

  @override
  String get studyMistake => 'Fout';

  @override
  String get studyBrilliantMove => 'Skitterende skuif';

  @override
  String get studyBlunder => 'Flater';

  @override
  String get studyInterestingMove => 'Interesante skuif';

  @override
  String get studyDubiousMove => 'Twyfelagte skuif';

  @override
  String get studyOnlyMove => 'Eenigste skuif';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Gelyke posisie';

  @override
  String get studyUnclearPosition => 'Onduidelike posise';

  @override
  String get studyWhiteIsSlightlyBetter => 'Wit is effens beter';

  @override
  String get studyBlackIsSlightlyBetter => 'Swart is effens beter';

  @override
  String get studyWhiteIsBetter => 'Wit is beter';

  @override
  String get studyBlackIsBetter => 'Swart is beter';

  @override
  String get studyWhiteIsWinning => 'Wit is beter';

  @override
  String get studyBlackIsWinning => 'Swart is beter';

  @override
  String get studyNovelty => 'Nuwigheid';

  @override
  String get studyDevelopment => 'Ontwikkeling';

  @override
  String get studyInitiative => 'Inisiatief';

  @override
  String get studyAttack => 'Aanval';

  @override
  String get studyCounterplay => 'Teenstoot';

  @override
  String get studyTimeTrouble => 'Tydskommer';

  @override
  String get studyWithCompensation => 'Met vergoeding';

  @override
  String get studyWithTheIdea => 'Met die idee';

  @override
  String get studyNextChapter => 'Volgende hoofstuk';

  @override
  String get studyPrevChapter => 'Vorige hoofstuk';

  @override
  String get studyStudyActions => 'Studie aksie';

  @override
  String get studyTopics => 'Onderwerpe';

  @override
  String get studyMyTopics => 'My onderwerpe';

  @override
  String get studyPopularTopics => 'Gewilde onderwerpe';

  @override
  String get studyManageTopics => 'Bestuur onderwerpe';

  @override
  String get studyBack => 'Terug';

  @override
  String get studyPlayAgain => 'Speel weer';

  @override
  String get studyWhatWouldYouPlay => 'Wat sal jy in hierdie posisie speel?';

  @override
  String get studyYouCompletedThisLesson => 'Geluk! Jy het hierdie les voltooi.';

  @override
  String studyPerPage(String param) {
    return '$param per page';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Hoofstukke',
      one: '$count Hoofstuk',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wedstryde',
      one: '$count Wedstryd',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Lede',
      one: '$count Lid',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Plak jou PGN teks hier, tot by $count spelle',
      one: 'Plak jou PGN teks hier, tot by $count spel',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'sopas';

  @override
  String get timeagoRightNow => 'nou';

  @override
  String get timeagoCompleted => 'voltooi';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count sekondes',
      one: 'in $count sekonde',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count minute',
      one: 'in $count minuut',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count ure',
      one: 'in $count uur',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count dae',
      one: 'in $count dag',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count weke',
      one: 'in $count week',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count maande',
      one: 'in $count maand',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count jare',
      one: 'in $count jaar',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minute gelede',
      one: '$count minuut gelede',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ure gelede',
      one: '$count uur gelede',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dae gelede',
      one: '$count dag gelede',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weke gelede',
      one: '$count week gelede',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maande gelede',
      one: '$count maand gelede',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jare gelede',
      one: '$count jaar gelede',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nog $count minute oor',
      one: 'nog $count minuut oor',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nog $count ure oor',
      one: 'nog $count uur oor',
    );
    return '$_temp0';
  }
}
