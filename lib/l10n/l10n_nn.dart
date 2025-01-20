// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Nynorsk (`nn`).
class AppLocalizationsNn extends AppLocalizations {
  AppLocalizationsNn([String locale = 'nn']) : super(locale);

  @override
  String get mobileAllGames => 'Alle spel';

  @override
  String get mobileAreYouSure => 'Er du sikker?';

  @override
  String get mobileCancelTakebackOffer => 'Avbryt tilbud om angrerett';

  @override
  String get mobileClearButton => 'Tøm';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Fjern lagra trekk';

  @override
  String get mobileCustomGameJoinAGame => 'Bli med på eit parti';

  @override
  String get mobileFeedbackButton => 'Tilbakemelding';

  @override
  String mobileGreeting(String param) {
    return 'Hei $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Hei';

  @override
  String get mobileHideVariation => 'Skjul variant';

  @override
  String get mobileHomeTab => 'Startside';

  @override
  String get mobileLiveStreamers => 'Direkte strøymarar';

  @override
  String get mobileMustBeLoggedIn => 'Du må vera innlogga for å sjå denne sida.';

  @override
  String get mobileNoSearchResults => 'Ingen resultat';

  @override
  String get mobileNotFollowingAnyUser => 'Du følgjer ingen brukarar.';

  @override
  String get mobileOkButton => 'Ok';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Spelarar med \"$param\"';
  }

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Forstørr brikke som vert trekt';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Vil du avslutte dette løpet?';

  @override
  String get mobilePuzzleStormFilterNothingToShow => 'Ikkje noko å syna, ver venleg å endre filtera';

  @override
  String get mobilePuzzleStormNothingToShow => 'Ikkje noko å visa. Spel nokre omgangar Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Løys så mange oppgåver som du maktar på tre minutt.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'Du vil mista din noverande vinstrekke og poengsummen din vert lagra.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Spel oppgåver frå favorittopningane dine, eller velg eit tema.';

  @override
  String get mobilePuzzlesTab => 'Oppgåver';

  @override
  String get mobileRecentSearches => 'Nylege søk';

  @override
  String get mobileSettingsHapticFeedback => 'Haptisk tilbakemelding';

  @override
  String get mobileSettingsImmersiveMode => 'Immersiv modus';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Skjul system-UI mens du spelar. Bruk dette dersom systemet sine navigasjonsrørsler ved skjermkanten forstyrrar deg. Gjelder skjermbileta for spel og oppgåvestorm.';

  @override
  String get mobileSettingsTab => 'Innstillingar';

  @override
  String get mobileShareGamePGN => 'Del PGN';

  @override
  String get mobileShareGameURL => 'Del URLen til partiet';

  @override
  String get mobileSharePositionAsFEN => 'Del stilling som FEN';

  @override
  String get mobileSharePuzzle => 'Del denne oppgåva';

  @override
  String get mobileShowComments => 'Vis kommentarar';

  @override
  String get mobileShowResult => 'Vis resultat';

  @override
  String get mobileShowVariations => 'Vis variantpilar';

  @override
  String get mobileSomethingWentWrong => 'Det oppsto ein feil.';

  @override
  String get mobileSystemColors => 'Systemfargar';

  @override
  String get mobileTheme => 'Tema';

  @override
  String get mobileToolsTab => 'Verktøy';

  @override
  String get mobileWaitingForOpponentToJoin => 'Ventar på motspelar...';

  @override
  String get mobileWatchTab => 'Sjå';

  @override
  String get activityActivity => 'Aktivitet';

  @override
  String get activityHostedALiveStream => 'Starta en direktestraum';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Vart nr. $param1 i $param2';
  }

  @override
  String get activitySignedUp => 'Er registrert på Lichess';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Stødde lichess.org i $count månader som $param2',
      one: 'Stødde lichess.org for $count i månaden som $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har øvd på $count stillingar i emnet $param2',
      one: 'Har øvd på $count stillingar i emnet $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har løyst $count taktikkoppgåver',
      one: 'Har løyst $count taktikkoppgåve',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har spela $count $param2 parti',
      one: 'Har spela $count $param2 parti',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har skrive $count innlegg i $param2',
      one: 'Har skrive $count innlegg i $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spelt $count trekk',
      one: 'Spelt $count trekk',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i $count fjernsjakkparti',
      one: 'i $count fjernsjakkparti',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har spela $count fjernsjakkparti',
      one: 'Har spela $count fjernsjakkparti',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har spelt $count $param2-fjernsjakkparti',
      one: 'Har spelt $count $param2-fjernsjakkparti',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Følgjer $count spelarar',
      one: 'Følgjer $count spelar',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har $count nye følgjarar',
      one: 'Har $count ny følgjar',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har vore vert for $count simultan-matcher',
      one: 'Har vore vert for $count simultanframsyningar',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har vore deltakar i $count simultanmatcher',
      one: 'Har vore deltakar i $count simultanframsyningar',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har laga $count nye studiar',
      one: 'Har laga $count nye studiar',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har deltatt i $count turneringar',
      one: 'Har deltatt i $count turnering',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kom på plass #$count (topp $param2%) med $param3 parti i $param4',
      one: 'Kom på plass #$count (topp $param2%) med $param3 parti i $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har vore med i $count sveitserturneringar',
      one: 'Har vore med i $count sveitserturnering',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Er medlem av $count lag',
      one: 'Er medlem av $count lag',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Overføringar';

  @override
  String get broadcastMyBroadcasts => 'Mine sendingar';

  @override
  String get broadcastLiveBroadcasts => 'Direktesende turneringar';

  @override
  String get broadcastBroadcastCalendar => 'Kaldender for sendingar';

  @override
  String get broadcastNewBroadcast => 'Ny direktesending';

  @override
  String get broadcastSubscribedBroadcasts => 'Sendingar du abonnerar på';

  @override
  String get broadcastAboutBroadcasts => 'Om sending';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Korleis bruke Lichess-sendingar.';

  @override
  String get broadcastTheNewRoundHelp => 'Den nye runden vil ha same medlemar og bidragsytarar som den førre.';

  @override
  String get broadcastAddRound => 'Legg til ein runde';

  @override
  String get broadcastOngoing => 'Pågåande';

  @override
  String get broadcastUpcoming => 'Kommande';

  @override
  String get broadcastCompleted => 'Fullførde';

  @override
  String get broadcastCompletedHelp => 'Lichess detekterer ferdigspela rundar basert på kjeldeparita. Bruk denne innstillinga om det ikkje finst ei kjelde.';

  @override
  String get broadcastRoundName => 'Rundenamn';

  @override
  String get broadcastRoundNumber => 'Rundenummer';

  @override
  String get broadcastTournamentName => 'Turneringsnamn';

  @override
  String get broadcastTournamentDescription => 'Kortfatta skildring av turneringa';

  @override
  String get broadcastFullDescription => 'Full omtale av arrangementet';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Valfri lang omtale av turneringa. $param1 er tilgjengeleg. Omtalen må vera kortare enn $param2 teikn.';
  }

  @override
  String get broadcastSourceSingleUrl => 'PGN kjelde-URL';

  @override
  String get broadcastSourceUrlHelp => 'Lenke som Lichess vil hente PGN-oppdateringar frå. Den må vera offentleg tilgjengeleg på internett.';

  @override
  String get broadcastSourceGameIds => 'Opp til 64 Lichess spel-ID\'ar, skilde med mellomrom.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Startdato i turneringas lokale tidssone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Valfritt, om du veit når arrangementet startar';

  @override
  String get broadcastCurrentGameUrl => 'URL til pågåande parti';

  @override
  String get broadcastDownloadAllRounds => 'Last ned alle rundene';

  @override
  String get broadcastResetRound => 'Tilbakestill denne runden';

  @override
  String get broadcastDeleteRound => 'Slett denne runden';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Slett runden og tilhøyrande parti ugjenkalleleg.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Fjern alle parti frå denne runden. Kjelda må vera aktiv om dei skal kunne rettast opp att.';

  @override
  String get broadcastEditRoundStudy => 'Rediger rundestudie';

  @override
  String get broadcastDeleteTournament => 'Slett denne turneringa';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Slett heile turneringa med alle rundene og alle partia.';

  @override
  String get broadcastShowScores => 'Vis poengsummane til spelarar basert på spelresultatet deira';

  @override
  String get broadcastReplacePlayerTags => 'Valfritt: bytt ut spelarnamn, rangeringar og titlar';

  @override
  String get broadcastFideFederations => 'FIDE-forbund';

  @override
  String get broadcastTop10Rating => 'Topp 10 rating';

  @override
  String get broadcastFidePlayers => 'FIDE-spelarar';

  @override
  String get broadcastFidePlayerNotFound => 'Fann ikkje FIDE-spelar';

  @override
  String get broadcastFideProfile => 'FIDE-profil';

  @override
  String get broadcastFederation => 'Forbund';

  @override
  String get broadcastAgeThisYear => 'Alder i år';

  @override
  String get broadcastUnrated => 'Urangert';

  @override
  String get broadcastRecentTournaments => 'Nylegaste turneringar';

  @override
  String get broadcastOpenLichess => 'Opne i Lichess';

  @override
  String get broadcastTeams => 'Lag';

  @override
  String get broadcastBoards => 'Brett';

  @override
  String get broadcastOverview => 'Oversikt';

  @override
  String get broadcastSubscribeTitle => 'Abonner for å få melding når kvarr runde startar. I konto-innstillingane dine kan du velje kva form varslane skal sendas som.';

  @override
  String get broadcastUploadImage => 'Last opp turneringsbilete';

  @override
  String get broadcastNoBoardsYet => 'Førebels er det ikkje brett å syne. Desse vert først vist når spel er lasta opp.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Brett kan lastas med ei kjelde eller via $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Startar etter $param';
  }

  @override
  String get broadcastStartVerySoon => 'Sending vil starte om ikkje lenge.';

  @override
  String get broadcastNotYetStarted => 'Sendinga har førebels ikkje starta.';

  @override
  String get broadcastOfficialWebsite => 'Offisiell nettside';

  @override
  String get broadcastStandings => 'Resultat';

  @override
  String get broadcastOfficialStandings => 'Offisiell tabell';

  @override
  String broadcastIframeHelp(String param) {
    return 'Fleire alternativ på $param';
  }

  @override
  String get broadcastWebmastersPage => 'administratoren si side';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'Ei offentleg PGN-kjelde i sanntid for denne runden. Vi tilbyr og ei $param for raskare og meir effektiv synkronisering.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Bygg inn denne sendinga på nettstaden din';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Bygg inn $param på nettstaden din';
  }

  @override
  String get broadcastRatingDiff => 'Rangeringsdiff';

  @override
  String get broadcastGamesThisTournament => 'Spel i denne turneringa';

  @override
  String get broadcastScore => 'Poengskår';

  @override
  String get broadcastAllTeams => 'Alle lag';

  @override
  String get broadcastTournamentFormat => 'Turneringsformat';

  @override
  String get broadcastTournamentLocation => 'Turneringsstad';

  @override
  String get broadcastTopPlayers => 'Toppspelarar';

  @override
  String get broadcastTimezone => 'Tidssone';

  @override
  String get broadcastFideRatingCategory => 'FIDE-ratingkategori';

  @override
  String get broadcastOptionalDetails => 'Valfrie detaljar';

  @override
  String get broadcastPastBroadcasts => 'Tidlegare overføringar';

  @override
  String get broadcastAllBroadcastsByMonth => 'Vis alle overføringar etter månad';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sendingar',
      one: '$count sending',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Utfordringar: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Utfordra til eit parti';

  @override
  String get challengeChallengeDeclined => 'Utfordring avvist';

  @override
  String get challengeChallengeAccepted => 'Utfordring akseptert!';

  @override
  String get challengeChallengeCanceled => 'Utfordring avbroten.';

  @override
  String get challengeRegisterToSendChallenges => 'Du må registrera deg om du vil oppretta utfordringar.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Du kan ikkje utfordra $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param tek ikkje i mot utfordringar.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Ratinga di i $param1 er for langt unna $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Kan ikkje utfordre grunna mellombels $param rating.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param tek berre mot utfordringar frå vener.';
  }

  @override
  String get challengeDeclineGeneric => 'Eg tek for tida ikkje mot utfordringar.';

  @override
  String get challengeDeclineLater => 'Det passar ikkje nett no, men spør meg gjerne seinare.';

  @override
  String get challengeDeclineTooFast => 'Denne tidskontrollen er for snøgg for meg, men send gjerne ei ny utfordring til eit langsamare parti.';

  @override
  String get challengeDeclineTooSlow => 'Denne tidskontrollen er for langsam for meg, men send gjerne ei ny utfordring til eit snøggare parti.';

  @override
  String get challengeDeclineTimeControl => 'Jeg tek ikkje mot utfordringar med denne tidskontrollen.';

  @override
  String get challengeDeclineRated => 'Utfordra meg heller til eit rangert parti.';

  @override
  String get challengeDeclineCasual => 'Send meg heller ei utfordring til eit uformelt parti.';

  @override
  String get challengeDeclineStandard => 'Eg tek ikkje utfordringar til variantar nett no.';

  @override
  String get challengeDeclineVariant => 'Eg ønskjer ikkje å spela denne varianten nett no.';

  @override
  String get challengeDeclineNoBot => 'Eg tek ikkje utfordringar frå bottar.';

  @override
  String get challengeDeclineOnlyBot => 'Eg tek berre utfordringar frå bottar.';

  @override
  String get challengeInviteLichessUser => 'Eller inviter ein Lichess-brukar:';

  @override
  String get contactContact => 'Kontakt';

  @override
  String get contactContactLichess => 'Ta kontakt med Lichess';

  @override
  String get patronDonate => 'Donér';

  @override
  String get patronLichessPatron => 'Bidragsytar til Lichess';

  @override
  String perfStatPerfStats(String param) {
    return '$param-statistikk';
  }

  @override
  String get perfStatViewTheGames => 'Syn partia';

  @override
  String get perfStatProvisional => 'mellombels';

  @override
  String get perfStatNotEnoughRatedGames => 'For få rangerte parti til at ei stabil rating kan bereknas.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Endring over de siste $param partia:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Ratingavvik: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Lågare verdi tyder at ratinga er meir stabil. Over $param1 vert ratinga rekna som mellombels. For å koma på ratinglista må verdien vera under $param2 for standardsjakk og under $param3 for variantar.';
  }

  @override
  String get perfStatTotalGames => 'Totalt antal parti';

  @override
  String get perfStatRatedGames => 'Rangerte parti';

  @override
  String get perfStatTournamentGames => 'Turneringsparti';

  @override
  String get perfStatBerserkedGames => 'Berserkparti';

  @override
  String get perfStatTimeSpentPlaying => 'Total speletid';

  @override
  String get perfStatAverageOpponent => 'Gjennomsnittleg motspelarrating';

  @override
  String get perfStatVictories => 'Sigrar';

  @override
  String get perfStatDefeats => 'Tap';

  @override
  String get perfStatDisconnections => 'Fråkoplingar';

  @override
  String get perfStatNotEnoughGames => 'For få spela parti';

  @override
  String perfStatHighestRating(String param) {
    return 'Høgaste rating: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Lågaste rating: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'frå $param1 til $param2';
  }

  @override
  String get perfStatWinningStreak => 'Vinstrekkje';

  @override
  String get perfStatLosingStreak => 'Tapsrekke';

  @override
  String perfStatLongestStreak(String param) {
    return 'Lengste rekke: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Noverande rekke: $param';
  }

  @override
  String get perfStatBestRated => 'Beste sigrar';

  @override
  String get perfStatGamesInARow => 'Parti spela på rad';

  @override
  String get perfStatLessThanOneHour => 'Mindre enn ein time mellom partia';

  @override
  String get perfStatMaxTimePlaying => 'Lengste speletid';

  @override
  String get perfStatNow => 'no';

  @override
  String get preferencesPreferences => 'Preferansar';

  @override
  String get preferencesDisplay => 'Utsjånad';

  @override
  String get preferencesPrivacy => 'Privatsfære';

  @override
  String get preferencesNotifications => 'Meldingar';

  @override
  String get preferencesPieceAnimation => 'Brikkeanimasjon';

  @override
  String get preferencesMaterialDifference => 'Materiellskilnad';

  @override
  String get preferencesBoardHighlights => 'Feltmarkering (siste trekk og sjakk)';

  @override
  String get preferencesPieceDestinations => 'Brikkedestinasjonar (moglege trekk og førehandstrekk)';

  @override
  String get preferencesBoardCoordinates => 'Brettkoordinatar (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Vis liste over trekk medan partiet pågår';

  @override
  String get preferencesPgnPieceNotation => 'Notasjon';

  @override
  String get preferencesChessPieceSymbol => 'Brikkesymbol';

  @override
  String get preferencesPgnLetter => 'Bokstav (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen-modus';

  @override
  String get preferencesShowPlayerRatings => 'Vis ratingen til spelarane';

  @override
  String get preferencesShowFlairs => 'Vis symbol for talentet til spelarane';

  @override
  String get preferencesExplainShowPlayerRatings => 'Denne innstillinga gjer det mogleg å gøyme alle ratingar frå nettsida. Dette for å hjelpa til med å fokusera på sjakken. Du kan framleis spela rangerte parti, dette handlar berre om kva du får sjå.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Vis handtak for brettstorleik';

  @override
  String get preferencesOnlyOnInitialPosition => 'Berre for startstillinga';

  @override
  String get preferencesInGameOnly => 'Berre under eit parti';

  @override
  String get preferencesExceptInGame => 'Unnateke i partiet';

  @override
  String get preferencesChessClock => 'Sjakkur';

  @override
  String get preferencesTenthsOfSeconds => 'Tidels sekund';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Når det er mindre enn 10 sekundar igjen';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horisontal grøn progresjonsline';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Lyd når det er kritisk lite tid att';

  @override
  String get preferencesGiveMoreTime => 'Gje meir tid';

  @override
  String get preferencesGameBehavior => 'Spelframferd';

  @override
  String get preferencesHowDoYouMovePieces => 'Korleis flytta brikker?';

  @override
  String get preferencesClickTwoSquares => 'Klikk to felt';

  @override
  String get preferencesDragPiece => 'Dra brikke';

  @override
  String get preferencesBothClicksAndDrag => 'Begge';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Førehandstrekk (når det er motspelaren sitt trekk)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Ta trekket attende (etter stadfesting frå motspelaren)';

  @override
  String get preferencesInCasualGamesOnly => 'Berre i parti som ikkje påverkar rating';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Omvandle til dronning automatisk';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Hald <ctrl>-tasten nede under bondeomvandlinga for å mellombels deaktivera automatisk omvandling';

  @override
  String get preferencesWhenPremoving => 'Ved førehandstrekk';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Krev remis automatisk ved trekkgjentaking';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Når attverande tid < 30 sekundar';

  @override
  String get preferencesMoveConfirmation => 'Trekkstadfesting';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Kan under pågåande parti deaktiveras ved hjelp av brettmenyen';

  @override
  String get preferencesInCorrespondenceGames => 'I fjernsjakksparti';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Fjernsjakk og uavgrensa tid';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Stadfest når du gir opp eller tilbyr remis';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Metode for å rokere';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Flytt kongen to felt';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Sett kongen på tårnet, eller to felt';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Skriv trekk med tastaturet';

  @override
  String get preferencesInputMovesWithVoice => 'Oppgje trekk med røysta';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Marker lovlege trekk med piler';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Sei \"Bra parti, godt spela\" etter nederlag eller remis';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Preferansane dine er lagra.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Rull (\"scroll med musehjulet\") ned på brettet for å spela trekk omatt';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Dagleg e-postmelding med ei liste av fjernsjakkpartia dine';

  @override
  String get preferencesNotifyStreamStart => 'Strøyminga er i gang';

  @override
  String get preferencesNotifyInboxMsg => 'Ny melding i innboksen';

  @override
  String get preferencesNotifyForumMention => 'Du er nemnd i ein forumkommentar';

  @override
  String get preferencesNotifyInvitedStudy => 'Invitasjon til studie';

  @override
  String get preferencesNotifyGameEvent => 'Oppdateringar for fjernsjakkparti';

  @override
  String get preferencesNotifyChallenge => 'Utfordringar';

  @override
  String get preferencesNotifyTournamentSoon => 'Turneringa startar snart';

  @override
  String get preferencesNotifyTimeAlarm => 'Fjernsjakkuret er i ferd med å løpa ut';

  @override
  String get preferencesNotifyBell => 'Klokkemelding i Lichess';

  @override
  String get preferencesNotifyPush => 'Melding på eininga når du ikkje brukar Lichess';

  @override
  String get preferencesNotifyWeb => 'Nettlesar';

  @override
  String get preferencesNotifyDevice => 'Eining';

  @override
  String get preferencesBellNotificationSound => 'Varsellyd';

  @override
  String get preferencesBlindfold => 'Blindsjakk';

  @override
  String get puzzlePuzzles => 'Taktikkoppgåver';

  @override
  String get puzzlePuzzleThemes => 'Oppgåvetema';

  @override
  String get puzzleRecommended => 'Anbefalt';

  @override
  String get puzzlePhases => 'Fasar';

  @override
  String get puzzleMotifs => 'Motiv';

  @override
  String get puzzleAdvanced => 'Vidarekomande';

  @override
  String get puzzleLengths => 'Lengder';

  @override
  String get puzzleMates => 'Mattar';

  @override
  String get puzzleGoals => 'Mål';

  @override
  String get puzzleOrigin => 'Opphav';

  @override
  String get puzzleSpecialMoves => 'Spesialtrekk';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Likte du denne oppgåva?';

  @override
  String get puzzleVoteToLoadNextOne => 'Stem for å laste den neste!';

  @override
  String get puzzleUpVote => 'God oppgåve';

  @override
  String get puzzleDownVote => 'Mindre god oppgåve';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Oppgåve-ratinga di vil ikkje endre seg. Merk at oppgåver ikkje er konkurranse. Ratinga er til hjelp når det gjeld å finne dei mest passande oppgåvene for ditt noverande dugleiksnivå.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Finn det beste trekket for kvit.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Finn det beste trekket for svart.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'For å få personleg tilpassa oppgåver:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Oppgåve $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Dagens oppgåve';

  @override
  String get puzzleDailyPuzzle => 'Dagens sjakkproblem';

  @override
  String get puzzleClickToSolve => 'Klikk for å løyse oppgåva';

  @override
  String get puzzleGoodMove => 'Godt trekk';

  @override
  String get puzzleBestMove => 'Beste trekk!';

  @override
  String get puzzleKeepGoing => 'Fortsett…';

  @override
  String get puzzlePuzzleSuccess => 'Korrekt!';

  @override
  String get puzzlePuzzleComplete => 'Oppgåva er fullført!';

  @override
  String get puzzleByOpenings => 'Etter opningar';

  @override
  String get puzzlePuzzlesByOpenings => 'Oppgåver etter opningar';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Opningar du spelte mest av i rangerte parti';

  @override
  String get puzzleUseFindInPage => 'Bruk \"Finn side\" i nettlesarmenyen for å finne den opninga du spelar mest!';

  @override
  String get puzzleUseCtrlF => 'Bruk Ctrl+f for å finne den opninga du spelar mest!';

  @override
  String get puzzleNotTheMove => 'Det er ikkje rett trekk!';

  @override
  String get puzzleTrySomethingElse => 'Prøv noko anna.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'løynd';

  @override
  String puzzleFromGameLink(String param) {
    return 'Frå parti $param';
  }

  @override
  String get puzzleContinueTraining => 'Neste oppgåve';

  @override
  String get puzzleDifficultyLevel => 'Vanskenivå';

  @override
  String get puzzleNormal => 'Middels';

  @override
  String get puzzleEasier => 'Enklare';

  @override
  String get puzzleEasiest => 'Enklast';

  @override
  String get puzzleHarder => 'Vanskelegare';

  @override
  String get puzzleHardest => 'Vanskelegast';

  @override
  String get puzzleExample => 'Døme';

  @override
  String get puzzleAddAnotherTheme => 'Legg til endå eit tema';

  @override
  String get puzzleNextPuzzle => 'Neste oppgåve';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Hopp straks til neste oppgåve';

  @override
  String get puzzlePuzzleDashboard => 'Oppgåveoversikt';

  @override
  String get puzzleImprovementAreas => 'Forbetringsområde';

  @override
  String get puzzleStrengths => 'Styrkeområde';

  @override
  String get puzzleHistory => 'Oppgåvehistorikk';

  @override
  String get puzzleSolved => 'løyst';

  @override
  String get puzzleFailed => 'uløyst';

  @override
  String get puzzleStreakDescription => 'Løys gradvis vanskelegare oppgåver og bygg ei vinstrekkje. Det er inga tidsavgrensing, så det er berre å ta tida til hjelp. Spelet er over om du gjer eit feiltrekk. Men du kan hoppe over eit trekk for kvar omgang.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Vinstrekkja di: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Hopp over dette trekket for å bevare vinstrekkja di! Fungerer berre ein gong i kvar omgang.';

  @override
  String get puzzleContinueTheStreak => 'Fortsett vinstrekkja';

  @override
  String get puzzleNewStreak => 'Ny vinstrekkje';

  @override
  String get puzzleFromMyGames => 'Frå partia mine';

  @override
  String get puzzleLookupOfPlayer => 'Søk etter sjakknøtter frå partia til ein vald spelar';

  @override
  String puzzleFromXGames(String param) {
    return 'Sjakknøtter frå parti med $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Søk etter sjakknøtter';

  @override
  String get puzzleFromMyGamesNone => 'Du har ingen sjakknøtter i databasen, men like fullt set Lichess umåtelig stor pris på deg.\nSpel parti i snøggsjakk og klassisk sjakk for å auke sjansen for å få med ei sjakknøtt!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 sjakknøtter funne i parti med $param2';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Øva, analysera, forbetra';

  @override
  String puzzlePercentSolved(String param) {
    return '$param løyst';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Ikkje noko å visa, spel nokre oppgåver fyrst!';

  @override
  String get puzzleImprovementAreasDescription => 'Øv på desse for å betra framgongen!';

  @override
  String get puzzleStrengthDescription => 'Du klarar deg best i disse temaa';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spela $count gonger',
      one: 'Spela $count gong',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poeng under problemløysar-ratinga di',
      one: 'Eitt poeng under problemløysar-ratinga di',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poeng over problemløysar-ratinga di',
      one: 'Eitt poeng over problemløysar-ratinga di',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spela',
      one: '$count spela',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count å spela omatt',
      one: '$count å spela omatt',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Framskoten bonde';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Ein bonde som blir forvandla eller trugar med å bli forvandla er ein taktisk nøkkel.';

  @override
  String get puzzleThemeAdvantage => 'Fordel';

  @override
  String get puzzleThemeAdvantageDescription => 'Grip sjansen til å få eit avgjerande fortrinn. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasia-matt';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Tårn eller dronning samarbeidar med ein springar om å fange kongen mellom brettkanten og ei av motspelarens eigne brikker.';

  @override
  String get puzzleThemeArabianMate => 'Arabisk matt';

  @override
  String get puzzleThemeArabianMateDescription => 'Springar og tårn samarbeider om å setja kongen matt inne i hjørnet av brettet.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Gå til åtak på f2 eller f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Eit åtak som konsentrerar seg om bøndene på f2 eller f7, som til dømes i prøyssisk opning, fegatellovarianten (\"Fried Liver Attack\").';

  @override
  String get puzzleThemeAttraction => 'Magnet';

  @override
  String get puzzleThemeAttractionDescription => 'Avbyte eller offer (magnetoffer) som lokkar eller tvingar motspelaren til å flytte ei brikke til eit felt som gjer det mogleg å setje i verk ein taktisk plan.';

  @override
  String get puzzleThemeBackRankMate => 'Matt på åttanderaden';

  @override
  String get puzzleThemeBackRankMateDescription => 'Sjakkmatt på åttanderaden, ved at kongen er stengd inne av eigne brikker.';

  @override
  String get puzzleThemeBishopEndgame => 'Løparsluttspel';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Sluttspel med berre løparar og bønder.';

  @override
  String get puzzleThemeBodenMate => 'Bodens matt';

  @override
  String get puzzleThemeBodenMateDescription => 'To angripande løparar på kryssande diagonalar set matt, hjelpt av at kongen er blokkert av eigne brikker.';

  @override
  String get puzzleThemeCastling => 'Rokade';

  @override
  String get puzzleThemeCastlingDescription => 'Få kongen din i tryggleik og gjer tårnet klårt for åtak.';

  @override
  String get puzzleThemeCapturingDefender => 'Slå ut forsvararen';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Slå ut ei brikke som er kritisk som dekning for ei anna brikke, slik at brikka som no står udekka kan fjernast i eit seinare trekk.';

  @override
  String get puzzleThemeCrushing => 'Avgjerande fordel';

  @override
  String get puzzleThemeCrushingDescription => 'Finn motspelarens feil for å få ein avgjerande fordel. (eval ≥ 600 centibønder)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Dobbeltløparmatt';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'To angripande løparar på tilstøytande diagonalar mattar, hjelpt av at kongen er blokkert av eigne brikker.';

  @override
  String get puzzleThemeDovetailMate => 'Stjertmatt';

  @override
  String get puzzleThemeDovetailMateDescription => 'Ei dronning plassert heilt inntil motstandarkongen set matt fordi dei to einaste fluktfelta til kongen er blokkert av eigne brikker.';

  @override
  String get puzzleThemeEquality => 'Utjamning';

  @override
  String get puzzleThemeEqualityDescription => 'Vend ei tapt stilling til remis eller utjamna stilling. (eval ≤ 200 centibønder)';

  @override
  String get puzzleThemeKingsideAttack => 'Åtak på kongefløya';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Eit åtak på konge som motspelaren har tatt kort rokade med.';

  @override
  String get puzzleThemeClearance => 'Klarering';

  @override
  String get puzzleThemeClearanceDescription => 'Eit trekk, gjerne med tempo, som opnar eit felt, ei line eller ein diagonal for ein påfølgjande taktisk idé.';

  @override
  String get puzzleThemeDefensiveMove => 'Forsvarstrekk';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Presist trekk eller trekkserie som er naudsynt for å unngå å tape materiell eller andre fordelar.';

  @override
  String get puzzleThemeDeflection => 'Avleiing';

  @override
  String get puzzleThemeDeflectionDescription => 'Eit trekk som leier ei av brikkene til motstpelaren bort frå ei anna oppgåve, som til dømes oppdekking av eit viktig felt.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Avdekkaråtak';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Å flytte ei brikke som før åtaket blokkerer ei anna langtrekkande brikke. Til dømes flytte ein springar av vegen for eit tårn.';

  @override
  String get puzzleThemeDoubleCheck => 'Dobbeltsjakk';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Sjakk med to brikker samstundes, som eit resultat av eit avdekkaråtak der både brikka som vert flytta og den avdekka brikka set kongen til motspelaren i sjakk.';

  @override
  String get puzzleThemeEndgame => 'Sluttspel';

  @override
  String get puzzleThemeEndgameDescription => 'Taktikk i den siste fasen av partiet.';

  @override
  String get puzzleThemeEnPassantDescription => 'Ein taktikk som inneber at en-passant-regelen blir tatt i bruk. Det betyr at ein bonde kan slå ut ein motspelar-bonde som har passert den etter å ha starta med å flytte to felt, på samme måte som om den hadde starta med å flytte ett felt.';

  @override
  String get puzzleThemeExposedKing => 'Eksponert konge';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktikk retta mot ein konge med få forsvarar rundt seg, noko som ofte leier til sjakk matt.';

  @override
  String get puzzleThemeFork => 'Gaffel';

  @override
  String get puzzleThemeForkDescription => 'Eit trekk der brikka som vart flytta går til åtak på meir enn ei motstandarbrikke på same tid.';

  @override
  String get puzzleThemeHangingPiece => 'Hengande brikke';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktikk som utnyttar at det mogleg å slå ut ei udekt eller utilstrekkeleg dekt brikke.';

  @override
  String get puzzleThemeHookMate => 'Krokmatt';

  @override
  String get puzzleThemeHookMateDescription => 'Sjakkmatt med tårn, springar og bonde pluss ei motstandarbrikke som tek opp av eit felta kongen elles kunne flykta til.';

  @override
  String get puzzleThemeInterference => 'Hindring';

  @override
  String get puzzleThemeInterferenceDescription => 'Flytte ei brikke mellom to motstandarbrikker for å oppnå at ei eller begge vert udekka. Til dømes ein springar til eit dekka felt mellom to tårn.';

  @override
  String get puzzleThemeIntermezzo => 'Mellomtrekk';

  @override
  String get puzzleThemeIntermezzoDescription => 'Eit trekk som kjem før det venta trekket og som utgjer eit trugsmål motspelaren straks må svare på.';

  @override
  String get puzzleThemeKillBoxMate => 'Kassematt';

  @override
  String get puzzleThemeKillBoxMateDescription => 'Eit tårn står ved sida av motspelarens konge og er støtta av ei dronning som i tillegg stengjer fluktfelta til kongen. Tårnet og dronninga fangar motspelarkongen i ei 3x3 «kasse».';

  @override
  String get puzzleThemeKnightEndgame => 'Springarsluttspel';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Sluttspel med berre springarar og bønder.';

  @override
  String get puzzleThemeLong => 'Lang taktikkoppgåve';

  @override
  String get puzzleThemeLongDescription => 'Vinst i tre trekk.';

  @override
  String get puzzleThemeMaster => 'Meisterparti';

  @override
  String get puzzleThemeMasterDescription => 'Sjakknøtter frå parti med spelarar som har sjakktittel.';

  @override
  String get puzzleThemeMasterVsMaster => 'Meister mot meister-parti';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Sjakknøtter frå parti mellom to spelarar som har sjakktittel.';

  @override
  String get puzzleThemeMate => 'Matt';

  @override
  String get puzzleThemeMateDescription => 'Vinn partiet med stil.';

  @override
  String get puzzleThemeMateIn1 => 'Matt i eitt trekk';

  @override
  String get puzzleThemeMateIn1Description => 'Set matt i eitt trekk.';

  @override
  String get puzzleThemeMateIn2 => 'Matt i to trekk';

  @override
  String get puzzleThemeMateIn2Description => 'Set matt i to trekk.';

  @override
  String get puzzleThemeMateIn3 => 'Matt i tre trekk';

  @override
  String get puzzleThemeMateIn3Description => 'Set matt i tre trekk.';

  @override
  String get puzzleThemeMateIn4 => 'Matt i fire trekk';

  @override
  String get puzzleThemeMateIn4Description => 'Set matt i fire trekk.';

  @override
  String get puzzleThemeMateIn5 => 'Matt i fem eller fleire trekk';

  @override
  String get puzzleThemeMateIn5Description => 'Finn ein lang trekksekvens som leier fram til matt.';

  @override
  String get puzzleThemeMiddlegame => 'Mellomspel';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktikk i den andre fasen av partiet.';

  @override
  String get puzzleThemeOneMove => 'Eitt-trekks oppgåve';

  @override
  String get puzzleThemeOneMoveDescription => 'Ei taktikkoppgåve på berre eitt trekk.';

  @override
  String get puzzleThemeOpening => 'Opning';

  @override
  String get puzzleThemeOpeningDescription => 'Taktikk i den første fasen av partiet.';

  @override
  String get puzzleThemePawnEndgame => 'Bondesluttspel';

  @override
  String get puzzleThemePawnEndgameDescription => 'Sluttspel med berre bønder.';

  @override
  String get puzzleThemePin => 'Binding';

  @override
  String get puzzleThemePinDescription => 'Taktikk som utnyttar bindingar, dvs. at ei brikke ikkje kan flyttast utan at ei brikke av høgare verdi vert truga.';

  @override
  String get puzzleThemePromotion => 'Forvandling';

  @override
  String get puzzleThemePromotionDescription => 'Ein bonde som blir forvandla eller trugar med å bli forvandla er den taktiske nøkkelen.';

  @override
  String get puzzleThemeQueenEndgame => 'Dronningsluttspel';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Sluttspel med berre dronningar og bønder.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dronning- og tårnsluttspel';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Sluttspel med berre dronningar, tårn og bønder.';

  @override
  String get puzzleThemeQueensideAttack => 'Åtak på dronningfløya';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Eit åtak på konge som motspelaren har tatt lang rokade med.';

  @override
  String get puzzleThemeQuietMove => 'Stille trekk';

  @override
  String get puzzleThemeQuietMoveDescription => 'Trekk som ikkje gjev sjakk eller slår ei brikke, men som førebur eit uavvendeleg trugsmål i eit seinare trekk.';

  @override
  String get puzzleThemeRookEndgame => 'Tårnsluttspel';

  @override
  String get puzzleThemeRookEndgameDescription => 'Sluttspel med berre tårn og bønder.';

  @override
  String get puzzleThemeSacrifice => 'Offer';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktikk der ei brikke blir ofra på kort sikt med tanke på seinare vinst eller ei tvungen trekkrekke.';

  @override
  String get puzzleThemeShort => 'Kort taktikkoppgåve';

  @override
  String get puzzleThemeShortDescription => 'Vinst i to trekk.';

  @override
  String get puzzleThemeSkewer => 'Spidding';

  @override
  String get puzzleThemeSkewerDescription => 'Eit motiv der ei høgverdig brikke kjem under åtak og må flyttast slik at ei brikke av lågare verde som står bak kan slås ut eller verte truga. Spidding kan utførast med løpar, dronning eller tårn. Spiddar vert rekna som motsatsen til binding.';

  @override
  String get puzzleThemeSmotheredMate => 'Kvelarmatt';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Ein sjakkmatt ved hjelp av ein springar der motspelarens konge er stengd inne (eller kjøvd) av eigne brikker.';

  @override
  String get puzzleThemeSuperGM => 'Superstormeister-parti';

  @override
  String get puzzleThemeSuperGMDescription => 'Oppgåver frå parti spela av verdas beste sjakkspelarar.';

  @override
  String get puzzleThemeTrappedPiece => 'Fanga brikke';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Ei brikke som ikkje kjem unna grunna mangel på utvegar.';

  @override
  String get puzzleThemeUnderPromotion => 'Underforvandling';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Bondeforvandling til springar, løpar eller tårn.';

  @override
  String get puzzleThemeVeryLong => 'Særs lang taktikkoppgåve';

  @override
  String get puzzleThemeVeryLongDescription => 'Fire trekk eller fleire for å vinne.';

  @override
  String get puzzleThemeXRayAttack => 'Røntgenåtak';

  @override
  String get puzzleThemeXRayAttackDescription => 'Ein situasjon der ei brikke går til åtak gjennom ei eller fleire andre brikker, gjerne brikker som høyrer til motspelaren.';

  @override
  String get puzzleThemeZugzwang => 'Trekktvang';

  @override
  String get puzzleThemeZugzwangDescription => 'Ei stilling der alle moglege trekk skadar stillinga.';

  @override
  String get puzzleThemeMix => 'Blanda drops';

  @override
  String get puzzleThemeMixDescription => 'Litt av alt. Du veit ikkje kva du blir møtt med, så du må vera førebudd på det meste. Nett som i verkelege parti.';

  @override
  String get puzzleThemePlayerGames => 'Spelar parti';

  @override
  String get puzzleThemePlayerGamesDescription => 'Finn oppgåver generert frå dine eller andre sine parti.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Desse oppgåvene er offentleg eigedom og kan lastast ned frå $param.';
  }

  @override
  String get searchSearch => 'Søk';

  @override
  String get settingsSettings => 'Innstillingar';

  @override
  String get settingsCloseAccount => 'Steng konto';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Kontoen din er under administrasjon og kan ikkje stengast.';

  @override
  String get settingsClosingIsDefinitive => 'Å stenge kontoen er ei avgjerd som ikkje kan reverseras. Er du heilt sikker?';

  @override
  String get settingsCantOpenSimilarAccount => 'Du kan ikkje oppretta ein ny konto med det same brukarnamnet, sjølv om du endrar bokstavstorleiken (små bokstaver til STORE eller STORE bokstavar til små).';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Eg ombestemte meg, ikkje steng kontoen min';

  @override
  String get settingsCloseAccountExplanation => 'Er du heilt sikker på at du vil lukke denne kontoen? Det er ei permanent avgjerd. Du vil aldri bli i stand til å logg inn att.';

  @override
  String get settingsThisAccountIsClosed => 'Denne kontoen er stengd.';

  @override
  String get playWithAFriend => 'Spel mot ein ven';

  @override
  String get playWithTheMachine => 'Spel mot sjakkprogrammet';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Send denne lekkja til den du utfordrar';

  @override
  String get gameOver => 'Partiet er avslutta';

  @override
  String get waitingForOpponent => 'Ventar på motspelar';

  @override
  String get orLetYourOpponentScanQrCode => 'Eller la motspelaren din skanna denne QR-koden';

  @override
  String get waiting => 'Ventar';

  @override
  String get yourTurn => 'Ditt trekk';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 på nivå $param2';
  }

  @override
  String get level => 'Nivå';

  @override
  String get strength => 'Styrke';

  @override
  String get toggleTheChat => 'Chat av/på';

  @override
  String get chat => 'Praterom';

  @override
  String get resign => 'Gje opp';

  @override
  String get checkmate => 'Sjakk matt';

  @override
  String get stalemate => 'Patt';

  @override
  String get white => 'Kvit';

  @override
  String get black => 'Svart';

  @override
  String get asWhite => 'som kvit';

  @override
  String get asBlack => 'som svart';

  @override
  String get randomColor => 'Vilkårleg farge';

  @override
  String get createAGame => 'Start eit parti';

  @override
  String get whiteIsVictorious => 'Kvit vann partiet';

  @override
  String get blackIsVictorious => 'Svart vann partiet';

  @override
  String get youPlayTheWhitePieces => 'Du spelar med dei kvite brikkene';

  @override
  String get youPlayTheBlackPieces => 'Du spelar med dei svarte brikkene';

  @override
  String get itsYourTurn => 'Det er ditt trekk!';

  @override
  String get cheatDetected => 'Juks oppdaga';

  @override
  String get kingInTheCenter => 'Kongen i sentrum';

  @override
  String get threeChecks => 'Sjakk tre gonger';

  @override
  String get raceFinished => 'Kappløp er avslutta';

  @override
  String get variantEnding => 'Variantavslutning';

  @override
  String get newOpponent => 'Ny motspelar';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Motspelaren din ønskjer å spela eit nytt parti med deg';

  @override
  String get joinTheGame => 'Bli med';

  @override
  String get whitePlays => 'Kvit i trekket';

  @override
  String get blackPlays => 'Svart i trekket';

  @override
  String get opponentLeftChoices => 'Motspelaren kan ha forlate partiet. Du kan velja mellom å krevja vinst, kunngjera remis eller venta til motspelaren kjem attende.';

  @override
  String get forceResignation => 'Krev siger';

  @override
  String get forceDraw => 'Erklær remis';

  @override
  String get talkInChat => 'Vær venleg i praterommet';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Den første som kjem til denne lekkja vil spela med deg.';

  @override
  String get whiteResigned => 'Kvit gav opp';

  @override
  String get blackResigned => 'Svart gav opp';

  @override
  String get whiteLeftTheGame => 'Kvit har forlate partiet';

  @override
  String get blackLeftTheGame => 'Svart har forlate partiet';

  @override
  String get whiteDidntMove => 'Kvit gjorde ikkje trekket sitt';

  @override
  String get blackDidntMove => 'Svart gjorde ikkje trekket sitt';

  @override
  String get requestAComputerAnalysis => 'Start sjakkprogramanalyse';

  @override
  String get computerAnalysis => 'Sjakkprogramanalyse';

  @override
  String get computerAnalysisAvailable => 'Dataanalyse er tilgjengeleg';

  @override
  String get computerAnalysisDisabled => 'Maskinanalyse er slått av';

  @override
  String get analysis => 'Analysebrett';

  @override
  String depthX(String param) {
    return 'Djupn $param';
  }

  @override
  String get usingServerAnalysis => 'Brukar serveranalyse';

  @override
  String get loadingEngine => 'Lastar sjakkmotor ...';

  @override
  String get calculatingMoves => 'Reknar på trekk...';

  @override
  String get engineFailed => 'Feil under innlasting av berekningsmotor';

  @override
  String get cloudAnalysis => 'Skyanalyse';

  @override
  String get goDeeper => 'Søk djupare';

  @override
  String get showThreat => 'Vis trussel';

  @override
  String get inLocalBrowser => 'i lokal nettlesar';

  @override
  String get toggleLocalEvaluation => 'Lokal analyse av/på';

  @override
  String get promoteVariation => 'Forfremjingsvariant';

  @override
  String get makeMainLine => 'Gjer til hovudline';

  @override
  String get deleteFromHere => 'Slett herifrå';

  @override
  String get collapseVariations => 'Skjul variantar';

  @override
  String get expandVariations => 'Vis variantar';

  @override
  String get forceVariation => 'Tving fram varianten';

  @override
  String get copyVariationPgn => 'Kopier variant-PGN';

  @override
  String get move => 'Trekk';

  @override
  String get variantLoss => 'Variant tap';

  @override
  String get variantWin => 'Variant vinn';

  @override
  String get insufficientMaterial => 'Ikkje nok materiale';

  @override
  String get pawnMove => 'Bondetrekk';

  @override
  String get capture => 'Slagtrekk';

  @override
  String get close => 'Steng';

  @override
  String get winning => 'Vinn';

  @override
  String get losing => 'Tapar';

  @override
  String get drawn => 'Remis';

  @override
  String get unknown => 'Ukjend';

  @override
  String get database => 'Database';

  @override
  String get whiteDrawBlack => 'Kvit / Remis / Svart';

  @override
  String averageRatingX(String param) {
    return 'Snittrating: $param';
  }

  @override
  String get recentGames => 'Nylege parti';

  @override
  String get topGames => 'Topp-parti';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Brettsjakkparti med spelarar som har FIDE-rating $param1+ frå $param2 til $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' med avrunding, basert på antal halvtrekk fram til neste brikketaking eller bondetrekk';

  @override
  String get noGameFound => 'Fann ikkje noko parti';

  @override
  String get maxDepthReached => 'Maksimal djupn er nådd!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Gå til innstillingsmenyen om du vil søkje blant fleire parti.';

  @override
  String get openings => 'Opningar';

  @override
  String get openingExplorer => 'Opningsbok';

  @override
  String get openingEndgameExplorer => 'Opnings-/sluttspelbok';

  @override
  String xOpeningExplorer(String param) {
    return '$param opningsutforskar';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Spel det første trekket frå opning- og sluttspelbok';

  @override
  String get winPreventedBy50MoveRule => 'Vinst forhindra av 50-trekkregelen';

  @override
  String get lossSavedBy50MoveRule => 'Tap forhindra av 50-trekkregelen';

  @override
  String get winOr50MovesByPriorMistake => 'Vinst eller 50 trekk etter tidlegare feil';

  @override
  String get lossOr50MovesByPriorMistake => 'Tap eller 50 trekk etter tidlegare feil';

  @override
  String get unknownDueToRounding => 'Vinst/tap berre garantert dersom den tilrådde trekkrekka i databasen er følgd etter siste brikkeutslag eller bondetrekk, på grunn av mogleg avrunding.';

  @override
  String get allSet => 'Alt klart!';

  @override
  String get importPgn => 'Importér PGN-fil';

  @override
  String get delete => 'Slett';

  @override
  String get deleteThisImportedGame => 'Slette dette importerte partiet?';

  @override
  String get replayMode => 'Modus for å spele oppatt';

  @override
  String get realtimeReplay => 'Sanntid';

  @override
  String get byCPL => 'CPL';

  @override
  String get enable => 'Aktiver';

  @override
  String get bestMoveArrow => 'Pil for beste trekk';

  @override
  String get showVariationArrows => 'Vis variantpiler';

  @override
  String get evaluationGauge => 'Syn evaluering';

  @override
  String get multipleLines => 'Fleire variantar';

  @override
  String get cpus => 'Prosessorar';

  @override
  String get memory => 'Minne';

  @override
  String get infiniteAnalysis => 'Uendeleg analyse';

  @override
  String get removesTheDepthLimit => 'Tar bort avgrensing i søke-djupna, og varmar opp maskina';

  @override
  String get blunder => 'Bukk';

  @override
  String get mistake => 'Mistak';

  @override
  String get inaccuracy => 'Småfeil';

  @override
  String get moveTimes => 'Tidsbruk per trekk';

  @override
  String get flipBoard => 'Snu brettet';

  @override
  String get threefoldRepetition => 'Trefaldig trekkgjentaking';

  @override
  String get claimADraw => 'Krev remis';

  @override
  String get offerDraw => 'Tilby remis';

  @override
  String get draw => 'Remis';

  @override
  String get drawByMutualAgreement => 'Remis etter semje';

  @override
  String get fiftyMovesWithoutProgress => 'Femti trekk utan framgang';

  @override
  String get currentGames => 'Parti som blir spela no';

  @override
  String get viewInFullSize => 'Vis i full storleik';

  @override
  String get logOut => 'Logg ut';

  @override
  String get signIn => 'Logg inn';

  @override
  String get rememberMe => 'Lagra mine påloggingsdata';

  @override
  String get youNeedAnAccountToDoThat => 'For å gjera det treng du ein konto';

  @override
  String get signUp => 'Registrer deg';

  @override
  String get computersAreNotAllowedToPlay => 'Datamaskinar og spelarar som brukar sjakkprogram har ikkje lov til å spela. Ver venleg å ikkje ta i bruk hjelp frå sjakkprogram, databasar eller andre spelarar så lenge partiet er i gang. Merk at det vert sterkt frårådd å oppretta fleire kontoar. Oppretting av svært mange kontoar vil føra til utestenging.';

  @override
  String get games => 'Parti';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 postlagt i forumet $param2';
  }

  @override
  String get latestForumPosts => 'Siste innlegg i forumet';

  @override
  String get players => 'Spelarar';

  @override
  String get friends => 'Vener';

  @override
  String get otherPlayers => 'andre spelarar';

  @override
  String get discussions => 'Diskusjonar';

  @override
  String get today => 'I dag';

  @override
  String get yesterday => 'I går';

  @override
  String get minutesPerSide => 'Minutt per spelar';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Variantar';

  @override
  String get timeControl => 'Tidskontroll';

  @override
  String get realTime => 'Sanntid';

  @override
  String get correspondence => 'Fjernsjakk';

  @override
  String get daysPerTurn => 'Dagar per trekk';

  @override
  String get oneDay => 'Ein dag';

  @override
  String get time => 'Tid';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Ratingstatistikk';

  @override
  String get username => 'Brukarnamn';

  @override
  String get usernameOrEmail => 'Brukarnamn eller e-post';

  @override
  String get changeUsername => 'Endre brukarnamn';

  @override
  String get changeUsernameNotSame => 'Du kan berre bytte små til store bokstavar, eller store til små. Til dømes \"olanormann\" til \"OlaNormann\".';

  @override
  String get changeUsernameDescription => 'Endre brukarnamnet. Det kan berre gjerast ein gong, og du kan berre endre store bokstavar til små eller små til store.';

  @override
  String get signupUsernameHint => 'Gå for eit familievenleg brukarnamn. Namnet kan ikkje endrast seinare og kontoar med upassande brukarnamn vert stengde!';

  @override
  String get signupEmailHint => 'Vi vil berre bruka den dersom det vert naudsynt å nullstilla passordet.';

  @override
  String get password => 'Passord';

  @override
  String get changePassword => 'Endre passord';

  @override
  String get changeEmail => 'Endre e-postadresse';

  @override
  String get email => 'E-post';

  @override
  String get passwordReset => 'Sett passordet på nytt.';

  @override
  String get forgotPassword => 'Har du gløymt passordet?';

  @override
  String get error_weakPassword => 'Passordet er svært vanleg og for lett å gjette.';

  @override
  String get error_namePassword => 'Ikkje bruk namnet ditt som passord.';

  @override
  String get blankedPassword => 'Du har brukt det same passordet på ei nettside som er vorte kompromittert. For å ta i vare tryggleiken på Lichess-kontoen din, er det naudynt at du lagar eit nytt passord. Takk for di forståing.';

  @override
  String get youAreLeavingLichess => 'Du forlèt Lichess';

  @override
  String get neverTypeYourPassword => 'Skriv aldri Lichess-passordet på ei anna webside!';

  @override
  String proceedToX(String param) {
    return 'Fortsett til $param';
  }

  @override
  String get passwordSuggestion => 'Ikkje bruk passord føreslått av andre. Dei kan bruka det til å stela kontoen din.';

  @override
  String get emailSuggestion => 'Ikkje bruk ein e-postadresse føreslått av andre. Dei kan bruka det til å stela kontoen din.';

  @override
  String get emailConfirmHelp => 'Hjelp med å stadfesta e-posten';

  @override
  String get emailConfirmNotReceived => 'Mottok du ikkje stadfesting på e-post etter at du registrerte deg?';

  @override
  String get whatSignupUsername => 'Kva var brukarnamnet du registrerte deg med?';

  @override
  String usernameNotFound(String param) {
    return 'Vi fann ingen brukar med namnet $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Du kan bruka dette namnet for å oppretta ein ny konto';

  @override
  String emailSent(String param) {
    return 'Vi har sendt ein e-post til $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Det kan ta litt tid før den kjem.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Vent fem minutt før du oppdaterer innboksen.';

  @override
  String get checkSpamFolder => 'Kontroller at e-posten ikkje har hamna i mappa for søplepost. Om det har skjedd må du markere e-posten som ikkje-spam.';

  @override
  String get emailForSignupHelp => 'Om alt anna feilar kan du sende oss denne e-posten:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopier og lim inn teksten ovanfor og send den til $param';
  }

  @override
  String get waitForSignupHelp => 'Vi tek om kort tid kontakt med deg for å hjelpa til med å fullføre registreringa.';

  @override
  String accountConfirmed(String param) {
    return 'Brukar $param vart stadfesta.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Du kan no logga inn som $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Du treng ikkje stadfesting på e-post.';

  @override
  String accountClosed(String param) {
    return 'Kontoen $param er stengd.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Kontoen $param vart registrert utan e-post.';
  }

  @override
  String get rank => 'Rangering';

  @override
  String rankX(String param) {
    return 'Plassering: $param';
  }

  @override
  String get gamesPlayed => 'Spelte parti';

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Avbryt';

  @override
  String get whiteTimeOut => 'Tida er ute for kvit';

  @override
  String get blackTimeOut => 'Tida er ute for svart';

  @override
  String get drawOfferSent => 'Tilbod om remis er sendt';

  @override
  String get drawOfferAccepted => 'Remistilbod godtatt';

  @override
  String get drawOfferCanceled => 'Remistilbodet vart trekt attende';

  @override
  String get whiteOffersDraw => 'Kvit tilbyr remis';

  @override
  String get blackOffersDraw => 'Svart tilbyr remis';

  @override
  String get whiteDeclinesDraw => 'Kvit avslår remis';

  @override
  String get blackDeclinesDraw => 'Svart avslår remis';

  @override
  String get yourOpponentOffersADraw => 'Motspelaren tilbyr remis';

  @override
  String get accept => 'Godta';

  @override
  String get decline => 'Avslå';

  @override
  String get playingRightNow => 'Pågår';

  @override
  String get eventInProgress => 'Pågår';

  @override
  String get finished => 'Slutt';

  @override
  String get abortGame => 'Avbryt partiet';

  @override
  String get gameAborted => 'Partiet blei avbrote';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Brukardefinert stilling';

  @override
  String get unlimited => 'Uavgrensa';

  @override
  String get mode => 'Modus';

  @override
  String get casual => 'Urangert';

  @override
  String get rated => 'Rangert';

  @override
  String get casualTournament => 'Uformell';

  @override
  String get ratedTournament => 'Rangert';

  @override
  String get thisGameIsRated => 'Dette partiet er rangert';

  @override
  String get rematch => 'Omkamp';

  @override
  String get rematchOfferSent => 'Tilbod om omkamp sendt';

  @override
  String get rematchOfferAccepted => 'Tilbod om omkamp godteke';

  @override
  String get rematchOfferCanceled => 'Førespurnad om omkamp trekt attende';

  @override
  String get rematchOfferDeclined => 'Tilbod om omkamp avslått';

  @override
  String get cancelRematchOffer => 'Avbryt førespurnad om omkamp';

  @override
  String get viewRematch => 'Vis omkampen';

  @override
  String get confirmMove => 'Stadfest trekk';

  @override
  String get play => 'Spel';

  @override
  String get inbox => 'Innboks';

  @override
  String get chatRoom => 'Praterom';

  @override
  String get loginToChat => 'Logg inn for å chatte';

  @override
  String get youHaveBeenTimedOut => 'Tidsavbrot.';

  @override
  String get spectatorRoom => 'Tilskodarrom';

  @override
  String get composeMessage => 'Skriv melding';

  @override
  String get subject => 'Emne';

  @override
  String get send => 'Send';

  @override
  String get incrementInSeconds => 'Tilleggstid i sekund';

  @override
  String get freeOnlineChess => 'Fritt tilgjengeleg nettsjakk';

  @override
  String get exportGames => 'Eksporter parti';

  @override
  String get ratingRange => 'Ratingspenn';

  @override
  String get thisAccountViolatedTos => 'Brukaren bak denne kontoen braut med Lichess sine brukarvilkår';

  @override
  String get openingExplorerAndTablebase => 'Opningsutforskar & tabellbase';

  @override
  String get takeback => 'Gjer om trekket';

  @override
  String get proposeATakeback => 'Framlegg om å gjera om trekket';

  @override
  String get takebackPropositionSent => 'Framlegg om å gjera om trekket blei sendt';

  @override
  String get takebackPropositionDeclined => 'Framlegget om å gjera om trekket blei avslått';

  @override
  String get takebackPropositionAccepted => 'Framlegget om å gjera om trekket blei godteke';

  @override
  String get takebackPropositionCanceled => 'Framlegget om å gjera om trekket blei avbrote';

  @override
  String get yourOpponentProposesATakeback => 'Motstandaren gjer framlegg om å gjera om trekket';

  @override
  String get bookmarkThisGame => 'Bokmerk denne sida';

  @override
  String get tournament => 'Turnering';

  @override
  String get tournaments => 'Turneringar';

  @override
  String get tournamentPoints => 'Turneringspoeng';

  @override
  String get viewTournament => 'Vis turnering';

  @override
  String get backToTournament => 'Attende til turneringa';

  @override
  String get noDrawBeforeSwissLimit => 'I sveitsarturneringer må det spelast minst 30 trekk før det er lov å tilby remis.';

  @override
  String get thematic => 'Tematisk';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Ratinga di på $param er mellombels';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Ratinga di i $param1 ($param2) er for høg';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Den beste vekesratinga di i $param1 ($param2) er for høg';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Ratinga di i $param1 ($param2) er for låg';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Rangert ≥ $param1 i $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rangert ≤ $param1 i $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Du må vera medlem av lag $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Du er ikkje med i lag $param';
  }

  @override
  String get backToGame => 'Attende til partiet';

  @override
  String get siteDescription => 'Fritt tilgjengeleg nettsjakk. Spel sjakk på ei rein nettside utan registrering, reklame eller programtillegg. Spel sjakk mot datamaskin, vener eller tilfeldige motspelarar.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 blei med i laget $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 oppretta lag $param2';
  }

  @override
  String get startedStreaming => 'starta å strøyma';

  @override
  String xStartedStreaming(String param) {
    return '$param starta å strøyme';
  }

  @override
  String get averageElo => 'Snittrating';

  @override
  String get location => 'Stad';

  @override
  String get filterGames => 'Filtrer parti';

  @override
  String get reset => 'Attendestill';

  @override
  String get apply => 'Bruk';

  @override
  String get save => 'Lagre';

  @override
  String get leaderboard => 'Leiartabell';

  @override
  String get screenshotCurrentPosition => 'Ta eit skjermbilete av gjeldande stilling';

  @override
  String get gameAsGIF => 'Parti som GIF';

  @override
  String get pasteTheFenStringHere => 'Lim inn FEN-koden her';

  @override
  String get pasteThePgnStringHere => 'Lim inn PGN-koden her';

  @override
  String get orUploadPgnFile => 'Eller last opp ei PGN-fil';

  @override
  String get fromPosition => 'Frå stilling';

  @override
  String get continueFromHere => 'Fortsett herfrå';

  @override
  String get toStudy => 'Studér';

  @override
  String get importGame => 'Importér parti';

  @override
  String get importGameExplanation => 'Når du limer inn eit PGN-parti kan du bla gjennom partiet,\nfå en computeranalyse, chatte eller dele ein URL.';

  @override
  String get importGameCaveat => 'Variantar vert sletta. Vil du behalde dei kan du importere PGN\'en via ein studie.';

  @override
  String get importGameDataPrivacyWarning => 'Denne PGN-fila er offentleg tilgjengeleg. Bruk ein studie for å importere eit parti berre for deg.';

  @override
  String get thisIsAChessCaptcha => 'Dette er ein sjakk-CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Gjer eit trekk på brettet for å prova at du er eit menneske.';

  @override
  String get captcha_fail => 'Ver venleg og løys sjakkproblemet.';

  @override
  String get notACheckmate => 'Ikkje sjakk matt';

  @override
  String get whiteCheckmatesInOneMove => 'Kvit set matt i eitt trekk';

  @override
  String get blackCheckmatesInOneMove => 'Svart set matt i eitt trekk';

  @override
  String get retry => 'Prøv om att';

  @override
  String get reconnecting => 'Koplar til på ny';

  @override
  String get noNetwork => 'Fråkopla';

  @override
  String get favoriteOpponents => 'Favorittmotstandarar';

  @override
  String get follow => 'Følg';

  @override
  String get following => 'Følgjer';

  @override
  String get unfollow => 'Slutt å følgja';

  @override
  String followX(String param) {
    return 'Følg $param';
  }

  @override
  String unfollowX(String param) {
    return 'Slutt å følgja $param';
  }

  @override
  String get block => 'Blokkér';

  @override
  String get blocked => 'Blokkert';

  @override
  String get unblock => 'Fjern blokkering';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 byrja å følgja $param2';
  }

  @override
  String get more => 'Meir';

  @override
  String get memberSince => 'Medlem sidan';

  @override
  String lastSeenActive(String param) {
    return 'Siste innlogging $param';
  }

  @override
  String get player => 'Spelar';

  @override
  String get list => 'Liste';

  @override
  String get graph => 'Graf';

  @override
  String get required => 'Påkrevd.';

  @override
  String get openTournaments => 'Opne turneringar';

  @override
  String get duration => 'Tidslengd';

  @override
  String get winner => 'Vinnar';

  @override
  String get standing => 'Stilling';

  @override
  String get createANewTournament => 'Lag ei ny turnering';

  @override
  String get tournamentCalendar => 'Turneringskalender';

  @override
  String get conditionOfEntry => 'Vilkår for å delta:';

  @override
  String get advancedSettings => 'Avanserte innstillingar';

  @override
  String get safeTournamentName => 'Finn eit svært sikkert namn på turneringa.';

  @override
  String get inappropriateNameWarning => 'Upassande innhald kan føre til at brukarkontoen din blir stengd.';

  @override
  String get emptyTournamentName => 'Lat stå tomt for at turneringa skal få namn etter ein tilfeldig stormester.';

  @override
  String get makePrivateTournament => 'Gjer turneringa privat og avgrens tilgang vha. eit passord';

  @override
  String get join => 'Bli med';

  @override
  String get withdraw => 'Trekk deg';

  @override
  String get points => 'Poeng';

  @override
  String get wins => 'Sigrar';

  @override
  String get losses => 'Tap';

  @override
  String get createdBy => 'Oppretta av';

  @override
  String get tournamentIsStarting => 'Turneringa startar';

  @override
  String get tournamentPairingsAreNowClosed => 'Turneringsoppsettet er no stengd.';

  @override
  String standByX(String param) {
    return 'Vent litt $param, koplar saman spelarar, hald deg klar!';
  }

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsett';

  @override
  String get youArePlaying => 'Du spelar!';

  @override
  String get winRate => 'Vinstfrekvens';

  @override
  String get berserkRate => 'Berserkfrekvens';

  @override
  String get performance => 'Prestasjon';

  @override
  String get tournamentComplete => 'Turnering fullførd';

  @override
  String get movesPlayed => 'Trekk spela';

  @override
  String get whiteWins => 'Kvit vinn';

  @override
  String get blackWins => 'Svart vinn';

  @override
  String get drawRate => 'Remis-rate';

  @override
  String get draws => 'Remis';

  @override
  String nextXTournament(String param) {
    return 'Neste $param turnering:';
  }

  @override
  String get averageOpponent => 'Gjennomsnittleg motstand';

  @override
  String get boardEditor => 'Brettskipar';

  @override
  String get setTheBoard => 'Still opp brett';

  @override
  String get popularOpenings => 'Omtykte opningar';

  @override
  String get endgamePositions => 'Sluttspelstillingar';

  @override
  String chess960StartPosition(String param) {
    return 'Fishersjakk, startoppstilling $param';
  }

  @override
  String get startPosition => 'Startposisjon';

  @override
  String get clearBoard => 'Tøm brettet';

  @override
  String get loadPosition => 'Last inn stilling';

  @override
  String get isPrivate => 'Privat';

  @override
  String reportXToModerators(String param) {
    return 'Meld $param til moderator';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil fullført: $param';
  }

  @override
  String xRating(String param) {
    return '$param rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'Om ingen, lat stå tomt';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Rediger profilen';

  @override
  String get realName => 'Verkelege namn';

  @override
  String get setFlair => 'Vel eit ikon som best representerer talentet ditt';

  @override
  String get flair => 'Talent';

  @override
  String get youCanHideFlair => 'Det finst ei innstilling for å skjule symbolet for spelarane sine talent på heile nettstaden.';

  @override
  String get biography => 'Biografi';

  @override
  String get countryRegion => 'Land eller region';

  @override
  String get thankYou => 'Takk!';

  @override
  String get socialMediaLinks => 'Lenker til sosiale media';

  @override
  String get oneUrlPerLine => 'Ein URL per line.';

  @override
  String get inlineNotation => 'Innbygd notasjon';

  @override
  String get makeAStudy => 'Om du vil ta vare på trekka til seinare er det betre å laga ein studie.';

  @override
  String get clearSavedMoves => 'Fjern trekk';

  @override
  String get previouslyOnLichessTV => 'Tidlegare på Lichess TV';

  @override
  String get onlinePlayers => 'Innlogga spelarar';

  @override
  String get activePlayers => 'Aktive spelarar';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Legg merke til at partiet er rangert, men ikkje tidsavgrensa!';

  @override
  String get success => 'Korrekt';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Gå automatisk til neste parti etter trekk';

  @override
  String get autoSwitch => 'Hopp automatisk til neste parti';

  @override
  String get puzzles => 'Sjakknøtter';

  @override
  String get onlineBots => 'Online botar';

  @override
  String get name => 'Namn';

  @override
  String get description => 'Forklaring';

  @override
  String get descPrivate => 'Privat omtale';

  @override
  String get descPrivateHelp => 'Tekst som berre lagmedlemar kan sjå. Dersom utfylt vert den ei erstatning av den offentlege omtalen, til bruk for laget sine medlemar.';

  @override
  String get no => 'Nei';

  @override
  String get yes => 'Ja';

  @override
  String get website => 'Nettside';

  @override
  String get mobile => 'Mobil';

  @override
  String get help => 'Hjelp:';

  @override
  String get createANewTopic => 'Opprett eit nytt emne';

  @override
  String get topics => 'Emne';

  @override
  String get posts => 'Innlegg';

  @override
  String get lastPost => 'Siste innlegg';

  @override
  String get views => 'Visningar';

  @override
  String get replies => 'Svar';

  @override
  String get replyToThisTopic => 'Svar på dette emnet';

  @override
  String get reply => 'Svar';

  @override
  String get message => 'Melding';

  @override
  String get createTheTopic => 'Opprett emnet';

  @override
  String get reportAUser => 'Rapportér ein brukar';

  @override
  String get user => 'Brukar';

  @override
  String get reason => 'Årsak';

  @override
  String get whatIsIheMatter => 'Kva gjeld saka?';

  @override
  String get cheat => 'Juks';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Anna';

  @override
  String get reportCheatBoostHelp => 'Legg ved lenke til partiet/partia og forklar kva som er gale med åtferda til denne brukaren. Å berre påstå at brukaren juksar er ikkje nok, men gje ei nærare forklaring på korleis du kom til denne konklusjonen.';

  @override
  String get reportUsernameHelp => 'Forklår kva som gjer brukarnamnet er støytande. Det held ikkje med å påstå at \"namnet er støytande/upassande\", men fortell oss korleis du kom til denne konklusjonen, spesielt om tydinga er uklår, ikkje er på engelsk, er eit slanguttrykk, eller har ein historisk/kulturell referanse.';

  @override
  String get reportProcessedFasterInEnglish => 'Rapporten din blir raskare behandla om du skriv på engelsk.';

  @override
  String get error_provideOneCheatedGameLink => 'Oppgje minst ei lenke til eit jukseparti.';

  @override
  String by(String param) {
    return 'av $param';
  }

  @override
  String importedByX(String param) {
    return 'Importert av $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Dette emnet er no lukka.';

  @override
  String get blog => 'Blogg';

  @override
  String get notes => 'Notat';

  @override
  String get typePrivateNotesHere => 'Skriv private notat her';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Skriv eit privat notat om denne brukaren';

  @override
  String get noNoteYet => 'Ingen merknad så langt';

  @override
  String get invalidUsernameOrPassword => 'Feil brukarnamn eller passord';

  @override
  String get incorrectPassword => 'Feil passord';

  @override
  String get invalidAuthenticationCode => 'Ugyldig godkjenningskode';

  @override
  String get emailMeALink => 'Send lekkje til meg på epost';

  @override
  String get currentPassword => 'Gjeldande passord';

  @override
  String get newPassword => 'Nytt passord';

  @override
  String get newPasswordAgain => 'Nytt passord (igjen)';

  @override
  String get newPasswordsDontMatch => 'Dei nye passorda stemmer ikkje overreins';

  @override
  String get newPasswordStrength => 'Passordstyrke';

  @override
  String get clockInitialTime => 'Starttid på klokka';

  @override
  String get clockIncrement => 'Inkrement';

  @override
  String get privacy => 'Privatsfære';

  @override
  String get privacyPolicy => 'Personvernpolitikk';

  @override
  String get letOtherPlayersFollowYou => 'Lat andre spelarar følgja deg';

  @override
  String get letOtherPlayersChallengeYou => 'Lat andre spelarar utfordra deg';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Lat andre spelarar invitere til studium';

  @override
  String get sound => 'Lyd';

  @override
  String get none => 'Ingen';

  @override
  String get fast => 'Rask';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Sakte';

  @override
  String get insideTheBoard => 'På brettet';

  @override
  String get outsideTheBoard => 'Utanfor brettet';

  @override
  String get allSquaresOfTheBoard => 'Alle felt på brettet';

  @override
  String get onSlowGames => 'I parti med lang tid';

  @override
  String get always => 'Alltid';

  @override
  String get never => 'Aldri';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 deltek i $param2';
  }

  @override
  String get victory => 'Vinst';

  @override
  String get defeat => 'Tap';

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
  String get allInformationIsPublicAndOptional => 'All informasjon er offentleg og valfri.';

  @override
  String get biographyDescription => 'Fortell om deg sjølv, kva du likar i sjakk, favorittopningane dine, favorittparti, favorittspelarar…';

  @override
  String get listBlockedPlayers => 'List opp spelarar du har sperra for';

  @override
  String get human => 'Menneske';

  @override
  String get computer => 'Datamaskin';

  @override
  String get side => 'Farge';

  @override
  String get clock => 'Klokke';

  @override
  String get opponent => 'Motspelar';

  @override
  String get learnMenu => 'Lær';

  @override
  String get studyMenu => 'Studie';

  @override
  String get practice => 'Øvingar';

  @override
  String get community => 'Fellesskap';

  @override
  String get tools => 'Verktøy';

  @override
  String get increment => 'Tilleggstid';

  @override
  String get error_unknown => 'Ugyldig verdi';

  @override
  String get error_required => 'Dette feltet er obligatorisk';

  @override
  String get error_email => 'E-postadressa er ikkje gyldig';

  @override
  String get error_email_acceptable => 'E-postadressa er ikkje akseptabel. Ver god og dobbeltsjekk den og prøv på nytt.';

  @override
  String get error_email_unique => 'E-postadressa er ikkje gyldig eller er allereie i bruk';

  @override
  String get error_email_different => 'Dette er allereie e-postadressa di';

  @override
  String error_minLength(String param) {
    return 'Minste lengd er $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Største lengd er $param';
  }

  @override
  String error_min(String param) {
    return 'Må vera større eller lik $param';
  }

  @override
  String error_max(String param) {
    return 'Må vera mindre eller lik $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Dersom rating er ± $param';
  }

  @override
  String get ifRegistered => 'Dersom registrert';

  @override
  String get onlyExistingConversations => 'Berre eksisterande samtalar';

  @override
  String get onlyFriends => 'Berre vener';

  @override
  String get menu => 'Meny';

  @override
  String get castling => 'Rokade';

  @override
  String get whiteCastlingKingside => 'Kvit O-O';

  @override
  String get blackCastlingKingside => 'Svart O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tid brukt på å spela: $param';
  }

  @override
  String get watchGames => 'Sjå parti';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tid på TV: $param';
  }

  @override
  String get watch => 'Sjå';

  @override
  String get videoLibrary => 'Videobibliotek';

  @override
  String get streamersMenu => 'Strøymingar';

  @override
  String get mobileApp => 'Mobilapp';

  @override
  String get webmasters => 'Webadministratorar';

  @override
  String get about => 'Om';

  @override
  String aboutX(String param) {
    return 'Om $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 er ein fritt tilgjengeleg ($param2), libre, annonsefri, open kjeldekode sjakk-server.';
  }

  @override
  String get really => 'verkeleg';

  @override
  String get contribute => 'Bidra';

  @override
  String get termsOfService => 'Brukarvilkår';

  @override
  String get sourceCode => 'Kjeldekode';

  @override
  String get simultaneousExhibitions => 'Simultanframsyningar';

  @override
  String get host => 'Vert';

  @override
  String hostColorX(String param) {
    return 'Vertsfarge: $param';
  }

  @override
  String get yourPendingSimuls => 'Dine ventande simultanar';

  @override
  String get createdSimuls => 'Nyleg laga simultanarrangement';

  @override
  String get hostANewSimul => 'Lag ei ny simultanframsyning';

  @override
  String get signUpToHostOrJoinASimul => 'Registrer deg for å bli vert eller deltakar i ein simultan';

  @override
  String get noSimulFound => 'Finn ikkje simultanframsyning';

  @override
  String get noSimulExplanation => 'Denne simultanframsyninga finst ikkje.';

  @override
  String get returnToSimulHomepage => 'Returner til simultanheimesida';

  @override
  String get aboutSimul => 'Simultanframsyning inneber at ein spelar møter fleire motspelarar samstundes.';

  @override
  String get aboutSimulImage => 'Mot 50 motspelarar, fekk Fischer 47 sigrar, to remisar og eit tap.';

  @override
  String get aboutSimulRealLife => 'Konseptet er henta frå verkelege framsyningar der verten for arrangementet går frå bord til bord og spelar mot fleire motstandarar samstundes.';

  @override
  String get aboutSimulRules => 'Når simultanframsyninga byrjar, startar alle deltakarane eit parti mot den som er vert. Verten får spela med dei kvite brikkene. Simultanoppvisinga endar når alle partia er ferdigspelte.';

  @override
  String get aboutSimulSettings => 'Simultanframsyningar er alltid urangerte. Omstart, attendetrekk og \"meirtid\" er slått av.';

  @override
  String get create => 'Opprett';

  @override
  String get whenCreateSimul => 'Når du arrangerer ei simultanframsyning spelar du mot fleire motstandarar samstundes.';

  @override
  String get simulVariantsHint => 'Om du vel fleire variantar, får kvar spelar velje kva variant dei ønskjer.';

  @override
  String get simulClockHint => 'Fischer klokkesett. Jo fleire spelarar du tar med, jo meir tid kan du trengje.';

  @override
  String get simulAddExtraTime => 'Du kan legge til ekstra tid på di eiga klokka for å makte simultanframsyninga.';

  @override
  String get simulHostExtraTime => 'Ekstra tid for simultanoppvisaren';

  @override
  String get simulAddExtraTimePerPlayer => 'Legg ekstra tenketid til klokka di for kvar spelar som melder seg på simultanspelet.';

  @override
  String get simulHostExtraTimePerPlayer => 'Ekstra tenketid som simultanverten får for kvar spelar';

  @override
  String get lichessTournaments => 'Lichess-turnering';

  @override
  String get tournamentFAQ => 'Spørsmål og svar knytta til arenaturnering';

  @override
  String get timeBeforeTournamentStarts => 'Tid til turneringa startar';

  @override
  String get averageCentipawnLoss => 'Gjennomsnittleg centibondetap';

  @override
  String get accuracy => 'Presisjon';

  @override
  String get keyboardShortcuts => 'Snarvegar på tastaturet';

  @override
  String get keyMoveBackwardOrForward => 'flytt att og fram';

  @override
  String get keyGoToStartOrEnd => 'gå til byrjinga/slutten';

  @override
  String get keyCycleSelectedVariation => 'Gå gjennom den valde varianten';

  @override
  String get keyShowOrHideComments => 'syn/gøym kommentarar';

  @override
  String get keyEnterOrExitVariation => 'gå inn i/gå ut av varianten';

  @override
  String get keyRequestComputerAnalysis => 'Be om maskinanalyse. Lær av feila dine';

  @override
  String get keyNextLearnFromYourMistakes => 'Neste (lær av feila dine)';

  @override
  String get keyNextBlunder => 'Neste store mistak (\"bukk\")';

  @override
  String get keyNextMistake => 'Neste mistak';

  @override
  String get keyNextInaccuracy => 'Neste upresise trekk';

  @override
  String get keyPreviousBranch => 'Førre grein';

  @override
  String get keyNextBranch => 'Neste grein';

  @override
  String get toggleVariationArrows => 'Slå variantpilar på/av';

  @override
  String get cyclePreviousOrNextVariation => 'Gå gjennom førre/neste variant';

  @override
  String get toggleGlyphAnnotations => 'Slå symbol-merknadar på/av';

  @override
  String get togglePositionAnnotations => 'Slå merknader for stillingar på/av';

  @override
  String get variationArrowsInfo => 'Med hjelp av variantpiler kan du navigere utan å bruka trekklista.';

  @override
  String get playSelectedMove => 'spel valde trekk';

  @override
  String get newTournament => 'Ny turnering';

  @override
  String get tournamentHomeTitle => 'Sjakkturnering med varierande tid og sjakkvariantar';

  @override
  String get tournamentHomeDescription => 'Spel fartsfylte sjakkturneringar! Delta i offisielle, faste turneringar eller lag dine eigne. Lynsjakk, snøggsjakk, fishersjakk og andre variantar er tilgjengeleg for endelaus sjakkmoro.';

  @override
  String get tournamentNotFound => 'Kan ikke finne turneringa';

  @override
  String get tournamentDoesNotExist => 'Denna turneringa finst ikkje.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Den kan ha blitt avbroten om alle spelarane trakk seg før turneringa starta.';

  @override
  String get returnToTournamentsHomepage => 'Returner til turneringas heimeside.';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Vekentleg $param fordeling i rating';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Ratinga di i $param1 er $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Du er betre enn $param1 av $param2-spelarane.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 er betre enn $param2 av $param3-spelarane.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Betre enn $param1 av $param2 spelarar';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Du har ikkje etablert ein $param-rating.';
  }

  @override
  String get yourRating => 'Ratinga di i er';

  @override
  String get cumulative => 'Akkumulert';

  @override
  String get glicko2Rating => 'Glicko-2 rating';

  @override
  String get checkYourEmail => 'Sjekk e-posten din';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Vi har sendt deg ein e-post. Trykk på lenka i e-posten for å aktivere kontoen din.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Hvis du ikkje ser e-posten, sjekk om den ligg i mappene spam, søppel, sosialt eller liknande.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Vi har sendt en e-post til $param. Trykk på lenka i e-posten for å attendestille passordet ditt.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Ved å registrera deg godtek du å binda deg til våre $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Les om vår $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Nettverksforseinking mellom deg og lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tida det tar å handsama eit trekk på serveren';

  @override
  String get downloadAnnotated => 'Last ned kommentert';

  @override
  String get downloadRaw => 'Last ned rådata';

  @override
  String get downloadImported => 'Last ned importert';

  @override
  String get crosstable => 'Tabell';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Du kan også scrolle over brettet for å flytte.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scroll over datamaskin-variasjonane for å førehandsvisa dei.';

  @override
  String get analysisShapesHowTo => 'Trykk shift-klikk eller høyreklikk for å tegne sirklar og piler på brettet.';

  @override
  String get letOtherPlayersMessageYou => 'Lat andre spelarar ta kontakt med deg';

  @override
  String get receiveForumNotifications => 'Bli varsla når du vert nemd i forumet';

  @override
  String get shareYourInsightsData => 'Del den personlege spelarstatistikken din';

  @override
  String get withNobody => 'Med ingen';

  @override
  String get withFriends => 'Med vener';

  @override
  String get withEverybody => 'Med alle';

  @override
  String get kidMode => 'Barnemodus';

  @override
  String get kidModeIsEnabled => 'Barnemodus er aktivert.';

  @override
  String get kidModeExplanation => 'Dette handlar om tryggleik. I barnemodus er all kommunikasjon avskrudd. Bruk dette for å verne barn og skoleelevar mot andre Internett-brukarar.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'I barnemodus får lichess-logoen eit $param symbol, så du kan sjå at barna dine er trygge.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Kontoen din er under administrasjon. Spør sjakklæraren din om det er mogleg å få oppheva barnemodusen.';

  @override
  String get enableKidMode => 'Skru på barnemodus';

  @override
  String get disableKidMode => 'Skru av barnemodus';

  @override
  String get security => 'Tryggleik';

  @override
  String get sessions => 'Økter';

  @override
  String get revokeAllSessions => 'lukke alle økter';

  @override
  String get playChessEverywhere => 'Spel sjakk overalt';

  @override
  String get asFreeAsLichess => 'Så fri som lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Bygd for kjærleik til sjakk, ikkje pengar';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Alle saman får tilgang til alle tenester gratis';

  @override
  String get zeroAdvertisement => 'Annonsefri';

  @override
  String get fullFeatured => 'Alle funksjonar';

  @override
  String get phoneAndTablet => 'Mobiltelefon og nettbrett';

  @override
  String get bulletBlitzClassical => 'Bullet, lynsjakk, saktesjakk';

  @override
  String get correspondenceChess => 'Fjernsjakk';

  @override
  String get onlineAndOfflinePlay => 'Spel online og offline';

  @override
  String get viewTheSolution => 'Vis løysinga';

  @override
  String get followAndChallengeFriends => 'Følg og utfordre vener';

  @override
  String get gameAnalysis => 'Analyse av partiet';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 er vert for $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 tar del i $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 liker $param2';
  }

  @override
  String get quickPairing => 'Snøgt parti';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonym';

  @override
  String yourScore(String param) {
    return 'Din poengsum: $param';
  }

  @override
  String get language => 'Språk';

  @override
  String get background => 'Bakgrunn';

  @override
  String get light => 'Lys';

  @override
  String get dark => 'Mørk';

  @override
  String get transparent => 'Gjennomskinleg';

  @override
  String get deviceTheme => 'Einingstema';

  @override
  String get backgroundImageUrl => 'URL for bakgrunnsbilete:';

  @override
  String get board => 'Brett';

  @override
  String get size => 'Storleik';

  @override
  String get opacity => 'Opasitet';

  @override
  String get brightness => 'Lysstyrke';

  @override
  String get hue => 'Fargetone';

  @override
  String get boardReset => 'Sttendestill til standardfargar';

  @override
  String get pieceSet => 'Brikkesett';

  @override
  String get embedInYourWebsite => 'Bygg inn i nettsida di';

  @override
  String get usernameAlreadyUsed => 'Dette brukarnamnet er allereie i bruk, ver venleg og prøv eit anna.';

  @override
  String get usernamePrefixInvalid => 'Det første teiknet i brukarnamnet må vera ein bokstav.';

  @override
  String get usernameSuffixInvalid => 'Det siste teiknet i brukarnamnet må vera ein bokstav eller eit tal.';

  @override
  String get usernameCharsInvalid => 'Brukarnamnet kan berre innehalde bokstavar, tal, understrekingsteikn og bindestrekar.';

  @override
  String get usernameUnacceptable => 'Dette brukarnamnet er ikkje akseptabelt.';

  @override
  String get playChessInStyle => 'Spel sjakk med stil';

  @override
  String get chessBasics => 'Grunnleggande sjakk';

  @override
  String get coaches => 'Sjakklærarar';

  @override
  String get invalidPgn => 'Ugyldig PGN';

  @override
  String get invalidFen => 'Ugyldig FEN';

  @override
  String get custom => 'Tilpassa';

  @override
  String get notifications => 'Meldingar';

  @override
  String notificationsX(String param1) {
    return 'Varsel: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Øv med computer';

  @override
  String anotherWasX(String param) {
    return 'Eit anna var $param';
  }

  @override
  String bestWasX(String param) {
    return 'Best var $param';
  }

  @override
  String get youBrowsedAway => 'Du bladde deg vekk';

  @override
  String get resumePractice => 'Ta opp att øving';

  @override
  String get drawByFiftyMoves => 'Partiet enda med remis etter femtitrekksregelen.';

  @override
  String get theGameIsADraw => 'Partiet endar med remis.';

  @override
  String get computerThinking => 'Computer tenker...';

  @override
  String get seeBestMove => 'Sjå beste trekk';

  @override
  String get hideBestMove => 'Skjul beste trekk';

  @override
  String get getAHint => 'Få eit hint';

  @override
  String get evaluatingYourMove => 'Vurderer trekket ditt...';

  @override
  String get whiteWinsGame => 'Kvit vinn';

  @override
  String get blackWinsGame => 'Svart vinn';

  @override
  String get learnFromYourMistakes => 'Lær av feila dine';

  @override
  String get learnFromThisMistake => 'Lær av dette mistaket';

  @override
  String get skipThisMove => 'Hopp over dette trekket';

  @override
  String get next => 'Neste';

  @override
  String xWasPlayed(String param) {
    return '$param vart spela';
  }

  @override
  String get findBetterMoveForWhite => 'Finn eit betre trekk for kvit';

  @override
  String get findBetterMoveForBlack => 'Finn eit betre trekk for svart';

  @override
  String get resumeLearning => 'Fortsett læring';

  @override
  String get youCanDoBetter => 'Du kan gjera det betre';

  @override
  String get tryAnotherMoveForWhite => 'Prøv eit anna trekk for kvit';

  @override
  String get tryAnotherMoveForBlack => 'Prøv eit anna trekk for svart';

  @override
  String get solution => 'Løysing';

  @override
  String get waitingForAnalysis => 'Ventar på analyse';

  @override
  String get noMistakesFoundForWhite => 'Ingen feil funne for kvit';

  @override
  String get noMistakesFoundForBlack => 'Ingen feil funne for svart';

  @override
  String get doneReviewingWhiteMistakes => 'Ferdig med å gå gjennom kvit sine feil';

  @override
  String get doneReviewingBlackMistakes => 'Ferdig med å gå gjennom svart sine feil';

  @override
  String get doItAgain => 'Gjer om att';

  @override
  String get reviewWhiteMistakes => 'Gå gjennom kvit sine feil';

  @override
  String get reviewBlackMistakes => 'Gå gjennom svart sine feil';

  @override
  String get advantage => 'Fordel';

  @override
  String get opening => 'Opning';

  @override
  String get middlegame => 'Midtspel';

  @override
  String get endgame => 'Sluttspel';

  @override
  String get conditionalPremoves => 'Vilkårsbundne førehandstrekk';

  @override
  String get addCurrentVariation => 'Legg til gjeldande variant';

  @override
  String get playVariationToCreateConditionalPremoves => 'Spel ein variant for å lage vilkårsbundne førehandstrekk';

  @override
  String get noConditionalPremoves => 'Ingen vilkårsbundne førehandstrekk';

  @override
  String playX(String param) {
    return 'Spel $param';
  }

  @override
  String get showUnreadLichessMessage => 'Du har fått ei privat melding frå Lichess.';

  @override
  String get clickHereToReadIt => 'Klikk her for å lesa den';

  @override
  String get sorry => 'Beklagar :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Vi måtte gje deg ein timeout.';

  @override
  String get why => 'Kvifor?';

  @override
  String get pleasantChessExperience => 'Vi freistar å gje alle ei god sjakk-oppleving.';

  @override
  String get goodPractice => 'For å oppnå det må vi sikre at alle spelarane respekterar god praksis.';

  @override
  String get potentialProblem => 'Vi syner vi denne meldinga når eit potensielt problem vert oppdaga.';

  @override
  String get howToAvoidThis => 'Korleis unngå dette?';

  @override
  String get playEveryGame => 'Spel alle parti du startar.';

  @override
  String get tryToWin => 'Forsøk å vinne (eller i det minste oppnå remis) i alle parti du spelar.';

  @override
  String get resignLostGames => 'Resigner ved tapte stillingar (ikkje la tida renne ut).';

  @override
  String get temporaryInconvenience => 'Vi seier oss leie for det kortvarige bryet,';

  @override
  String get wishYouGreatGames => 'og vonar du får gode sjakkoppgjer på lichess.org.';

  @override
  String get thankYouForReading => 'Takk for at du leste!';

  @override
  String get lifetimeScore => 'Livstidsscore';

  @override
  String get currentMatchScore => 'Gjeldande kampscore';

  @override
  String get agreementAssistance => 'Eg forsikrar at eg ikkje på noko tidspunkt under mine parti vil motta assistanse, korkje frå sjakkprogram, bøker, databasar eller andre personar.';

  @override
  String get agreementNice => 'Eg lovar å alltid oppføre meg skikkeleg mot andre spelarar.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Eg er innforstått med at eg ikkje kan oppretta fleire kontoar, så sant årsakene ikkje fell inn under $param.';
  }

  @override
  String get agreementPolicy => 'Eg lovar at eg vil følge alle reglane til Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Søk eller start ein ny diskusjon';

  @override
  String get edit => 'Rediger';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Lyn';

  @override
  String get rapid => 'Snøggsjakk';

  @override
  String get classical => 'Langsjakk';

  @override
  String get ultraBulletDesc => 'Ekstremt snøgge parti: under 30 sekund';

  @override
  String get bulletDesc => 'Særs snøgge parti: mindre enn 3 minutt';

  @override
  String get blitzDesc => 'Snøgge parti: 3 til 8 minutt';

  @override
  String get rapidDesc => 'Snøggsjakk: 8 til 25 minutt';

  @override
  String get classicalDesc => 'Langsjakk: 25 minutt eller meir';

  @override
  String get correspondenceDesc => 'Fjernsjakkparti: eit til fleire døger per trekk';

  @override
  String get puzzleDesc => 'Sjakktaktikk-trenar';

  @override
  String get important => 'Viktig';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Spørsmålet ditt kan allereie ha fått eit svar $param1';
  }

  @override
  String get inTheFAQ => 'I sidene for ofte stilte spørsmål';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Får å rapporter ein spelar for fusk eller dårleg framferd, $param1';
  }

  @override
  String get useTheReportForm => 'bruk rapportskjemaet';

  @override
  String toRequestSupport(String param1) {
    return 'For å få hjelp, $param1';
  }

  @override
  String get tryTheContactPage => 'prøv kontaktsida';

  @override
  String makeSureToRead(String param1) {
    return 'Sørg for at du les $param1';
  }

  @override
  String get theForumEtiquette => 'skikk og bruk i forumet';

  @override
  String get thisTopicIsArchived => 'Dette emnet er flytta til arkivet og kan ikkje lengre svarast på.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Meld deg på $param1, for å poste meldingar i dette forumet';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 lag';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Du kan så langt ikkje skrive oppslag i foraane. Spel nokre parti fyrst!';

  @override
  String get subscribe => 'Abonner';

  @override
  String get unsubscribe => 'Avslutt abonnement';

  @override
  String mentionedYouInX(String param1) {
    return 'nemnde deg i \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 nemnde deg i \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'inviterte deg til \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 inviterte deg til \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Du er no med i laget.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Du har blitt med i \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Nokon du rapporterte vart stengt ute';

  @override
  String get congratsYouWon => 'Gratulerer, du vann!';

  @override
  String gameVsX(String param1) {
    return 'Spel mot $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 mot $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Du tapte mot nokon som braut med Lichess\' sine vilkår';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Refundering: $param1 $param2 ratingpoeng.';
  }

  @override
  String get timeAlmostUp => 'Tida er nesten ute!';

  @override
  String get clickToRevealEmailAddress => '[Klikk for å visa epost-adresse]';

  @override
  String get download => 'Last ned';

  @override
  String get coachManager => 'Trenarleiar';

  @override
  String get streamerManager => 'Strøymingsleiar';

  @override
  String get cancelTournament => 'Avlys turneringa';

  @override
  String get tournDescription => 'Beskriving av turneringa';

  @override
  String get tournDescriptionHelp => 'Noko du vil seie til deltakarane? Ver kortfatta. Du kan gje URL\'en eit namn: [name](https://url)';

  @override
  String get ratedFormHelp => 'Partia er rangert\nog påverkar rangeringa til spelarane';

  @override
  String get onlyMembersOfTeam => 'Berre medlemar av laget';

  @override
  String get noRestriction => 'Inga avgrensingar';

  @override
  String get minimumRatedGames => 'Minste antal rangerte parti';

  @override
  String get minimumRating => 'Lågaste rating';

  @override
  String get maximumWeeklyRating => 'Høgste rating siste veke';

  @override
  String positionInputHelp(String param) {
    return 'Sett inn ein gyldig FEN for å starte kvart parti frå gjeven stilling.\nDet fungerar berre for standardparti, ikke for variantar.\nDu kan bruke $param for å generere en FEN-stilling, som du limar inn her.\nLa feltet stå tomt for å starte partia frå den normale utgangsstillinga.';
  }

  @override
  String get cancelSimul => 'Avbryt simultantilskipinga';

  @override
  String get simulHostcolor => 'Vertsfarge for kvart parti';

  @override
  String get estimatedStart => 'Forventa starttidspunkt';

  @override
  String simulFeatured(String param) {
    return 'Vis på $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Vis simultantilskipinga til alle på $param. Deaktivér for private simultantilskipingar.';
  }

  @override
  String get simulDescription => 'Beskriving av simultantilskipinga';

  @override
  String get simulDescriptionHelp => 'Noko du vil fortelja deltakarane?';

  @override
  String markdownAvailable(String param) {
    return '$param er tilgjengeleg for meir avansert syntaks.';
  }

  @override
  String get embedsAvailable => 'Sett inn URLen til eit spel eller studiekapittel for å bygge det inn.';

  @override
  String get inYourLocalTimezone => 'I di tidssone';

  @override
  String get tournChat => 'Turneringschat';

  @override
  String get noChat => 'Ikkje chat';

  @override
  String get onlyTeamLeaders => 'Berre lagleiarar';

  @override
  String get onlyTeamMembers => 'Berre lagsmedlemer';

  @override
  String get navigateMoveTree => 'Naviger i trekk-treet';

  @override
  String get mouseTricks => 'Musekunstar';

  @override
  String get toggleLocalAnalysis => 'Aktiver/deaktiver lokal maskinanalyse';

  @override
  String get toggleAllAnalysis => 'Aktiver/deaktiver all maskinanalyse';

  @override
  String get playComputerMove => 'Spel det beste maskintrekket';

  @override
  String get analysisOptions => 'Analyseval';

  @override
  String get focusChat => 'Fokusér prateromet';

  @override
  String get showHelpDialog => 'Vis denne hjelpedialogen';

  @override
  String get reopenYourAccount => 'Opne kontoen din på ny';

  @override
  String get closedAccountChangedMind => 'Om du har stengd kontoen din, men ynskjer å ta den attende, får du eitt høve til å opna den på ny.';

  @override
  String get onlyWorksOnce => 'Dette kan du berre gjera ein einaste gong.';

  @override
  String get cantDoThisTwice => 'Om du stengde kontoen ein andre gong, er det ikkje lengre mogleg å opna den att.';

  @override
  String get emailAssociatedToaccount => 'E-postadressa som er tilknytt kontoen';

  @override
  String get sentEmailWithLink => 'Vi har sendt deg ein e-post med ei lenke.';

  @override
  String get tournamentEntryCode => 'Tilgangskode til turnering';

  @override
  String get hangOn => 'Vent litt!';

  @override
  String gameInProgress(String param) {
    return 'Du spelar no eit parti mot $param.';
  }

  @override
  String get abortTheGame => 'Avbryt partiet';

  @override
  String get resignTheGame => 'Gje opp partiet';

  @override
  String get youCantStartNewGame => 'Du kan ikkje starte eit nytt parti før dette er avslutta.';

  @override
  String get since => 'Frå';

  @override
  String get until => 'Til';

  @override
  String get lichessDbExplanation => 'Rangerte parti samla inn frå alle Lichess-spelarar';

  @override
  String get switchSides => 'Byt side';

  @override
  String get closingAccountWithdrawAppeal => 'Dersom du stenger kontoen din vil protesten din bli trekt attende';

  @override
  String get ourEventTips => 'Tips for å organisere arrangement';

  @override
  String get instructions => 'Instruksjonar';

  @override
  String get showMeEverything => 'Vis alt';

  @override
  String get lichessPatronInfo => 'Lichess er ein velgjerdsorganisasjon basert på fritt tilgjengeleg open-kjeldekode-programvare.\nAlle kostnader for drift, utvikling og innhald vert finansiert eine og åleine av brukardonasjonar.';

  @override
  String get nothingToSeeHere => 'Ikkje noko å sjå nett no.';

  @override
  String get stats => 'Statistikk';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Motspelaren din har forlate partiet. Du kan krevje siger om $count sekund.',
      one: 'Motspelaren din har forlate partiet. Du kan krevje vinst om $count sekund.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matt om $count halvtrekk',
      one: 'Matt om $count halvtrekk',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bukkar',
      one: '$count bukk',
    );
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bukkar',
      one: '$count Bukk',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count feil',
      one: '$count feil',
    );
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Feil',
      one: '$count Feil',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count upresise trekk',
      one: '$count upresist trekk',
    );
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Upresise trekk',
      one: '$count Upresist trekk',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelarar',
      one: '$count spelar',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parti',
      one: '$count parti',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rating over $param2 parti',
      one: '$count rating over $param2 parti',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bokmerke',
      one: '$count bokmerke',
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
      other: '$count timar',
      one: '$count time',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutt',
      one: '$count minutt',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rating blir oppdatert kvart $count. minutt',
      one: 'Rangeringa blir oppdatert kvart minutt',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sjakkproblem',
      one: '$count sjakkproblem',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parti med deg',
      one: '$count parti med deg',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rangerte',
      one: '$count rangert',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sigrar',
      one: '$count siger',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tap',
      one: '$count tap',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remisar',
      one: '$count remis',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pågår',
      one: '$count pågår',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gje $count sekund',
      one: 'Gje $count sekund',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turneringspoeng',
      one: '$count turneringspoeng',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studiar',
      one: '$count studie',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultane parti',
      one: '$count simultant parti',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count rangerte parti',
      one: '≥ $count rangert parti',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count rangerte $param2-parti',
      one: '≥ $count rangert $param2 parti',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du må spela endå $count rangerte $param2 parti',
      one: 'Du må spela $count fleire $param2 rangerte parti',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du må spela endå $count rangerte parti',
      one: 'Du må spela endå $count rangert parti',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importerte parti',
      one: '$count importert parti',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vener er innlogga',
      one: '$count ven er innlogga',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count følgjarar',
      one: '$count følgjar',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fylgjer',
      one: '$count følgjer',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mindre enn $count minutt',
      one: 'Mindre enn $count minutt',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parti pågår',
      one: '$count parti pågår',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimalt: $count bokstavar.',
      one: 'Maksimalt: $count bokstav.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sperringar',
      one: '$count sperringar',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foruminnlegg',
      one: '$count foruminnlegg',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 spelarar denne veka.',
      one: '$count $param2 spelar denne veka.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tilgjengeleg på $count språk!',
      one: 'Tilgjengeleg på $count språk!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekund til å ta det første trekket',
      one: '$count sekund til å ta det første trekket',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekund',
      one: '$count sekund',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'og lagra $count liner med førehandstrekk',
      one: 'og lagra $count line med førehandstrekk',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Start ved å gjera eit trekk';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Du spelar med kvite brikker i alle oppgåvene';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Du spelar med svarte brikker i alle oppgåvene';

  @override
  String get stormPuzzlesSolved => 'sjakkoppgåvene løyst';

  @override
  String get stormNewDailyHighscore => 'Ny dagsrekord!';

  @override
  String get stormNewWeeklyHighscore => 'Ny vekesrekord!';

  @override
  String get stormNewMonthlyHighscore => 'Ny månadsrekord!';

  @override
  String get stormNewAllTimeHighscore => 'Ny personleg rekord!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Førre rekord var $param';
  }

  @override
  String get stormPlayAgain => 'Spel igjen';

  @override
  String stormHighscoreX(String param) {
    return 'Rekord: $param';
  }

  @override
  String get stormScore => 'Poengsum';

  @override
  String get stormMoves => 'Trekk';

  @override
  String get stormAccuracy => 'Presisjon';

  @override
  String get stormCombo => 'Vinstrekke';

  @override
  String get stormTime => 'Tid';

  @override
  String get stormTimePerMove => 'Tid per trekk';

  @override
  String get stormHighestSolved => 'Høgste vanskegrad';

  @override
  String get stormPuzzlesPlayed => 'Spelte oppgåver';

  @override
  String get stormNewRun => 'Ny runde (hurtigtast: mellomrom)';

  @override
  String get stormEndRun => 'Avslutt runden (hurtigtast: Enter)';

  @override
  String get stormHighscores => 'Rekordar';

  @override
  String get stormViewBestRuns => 'Vis beste runde';

  @override
  String get stormBestRunOfDay => 'Dagens beste runde';

  @override
  String get stormRuns => 'Runder';

  @override
  String get stormGetReady => 'Gjer deg klar!';

  @override
  String get stormWaitingForMorePlayers => 'Ventar på fleire deltakarar...';

  @override
  String get stormRaceComplete => 'Kappløpet er fullført!';

  @override
  String get stormSpectating => 'Sjå på';

  @override
  String get stormJoinTheRace => 'Bli med på kappløpet!';

  @override
  String get stormStartTheRace => 'Start kappløpet';

  @override
  String stormYourRankX(String param) {
    return 'Du er rangert som nr. $param';
  }

  @override
  String get stormWaitForRematch => 'Vent på ein ny omgang';

  @override
  String get stormNextRace => 'Neste kappløp';

  @override
  String get stormJoinRematch => 'Bli med på neste race';

  @override
  String get stormWaitingToStart => 'Vent på starten';

  @override
  String get stormCreateNewGame => 'Lag eit nytt race';

  @override
  String get stormJoinPublicRace => 'Bli med i eit offentleg kappløp';

  @override
  String get stormRaceYourFriends => 'Inviter venene dine til å delta i eit kappløp';

  @override
  String get stormSkip => 'hopp over';

  @override
  String get stormSkipHelp => 'Du kan hoppe over eit trekk i kvart kappløp:';

  @override
  String get stormSkipExplanation => 'Hopp over dette trekket for å bevara vinstrekka din! Fungerer berre ein gong i kvart kappløp.';

  @override
  String get stormFailedPuzzles => 'Mislukka oppgåveløysingar';

  @override
  String get stormSlowPuzzles => 'Langsame oppgåver';

  @override
  String get stormSkippedPuzzle => 'Oppgåve som er hoppa over';

  @override
  String get stormThisWeek => 'Denne veka';

  @override
  String get stormThisMonth => 'Denne månaden';

  @override
  String get stormAllTime => 'Frå starten av';

  @override
  String get stormClickToReload => 'Klikk for å lasta inn på ny';

  @override
  String get stormThisRunHasExpired => 'Denne runden er avslutta!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Denne runden vart opna i ei anna fane!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rundar',
      one: '1 runde',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Har spela $count rundar med $param2',
      one: 'Har spela ein runde med $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess-strøymarar';

  @override
  String get studyPrivate => 'Privat';

  @override
  String get studyMyStudies => 'Mine studiar';

  @override
  String get studyStudiesIContributeTo => 'Studiar eg bidreg til';

  @override
  String get studyMyPublicStudies => 'Mine offentlege studiar';

  @override
  String get studyMyPrivateStudies => 'Mine private studiar';

  @override
  String get studyMyFavoriteStudies => 'Mine favorittstudiar';

  @override
  String get studyWhatAreStudies => 'Kva er studiar?';

  @override
  String get studyAllStudies => 'Alle studiar';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studiar oppretta av $param';
  }

  @override
  String get studyNoneYet => 'Ingen så langt.';

  @override
  String get studyHot => 'Omtykt';

  @override
  String get studyDateAddedNewest => 'Dato tilføydd (siste)';

  @override
  String get studyDateAddedOldest => 'Dato tilføydd (første)';

  @override
  String get studyRecentlyUpdated => 'Nyleg oppdatert';

  @override
  String get studyMostPopular => 'Mest omtykt';

  @override
  String get studyAlphabetical => 'Alfabetisk';

  @override
  String get studyAddNewChapter => 'Føy til eit nytt kapittel';

  @override
  String get studyAddMembers => 'Legg til medlemar';

  @override
  String get studyInviteToTheStudy => 'Inviter til studien';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Inviter berre folk du kjenner og som aktivt ynskjer å delta i studien.';

  @override
  String get studySearchByUsername => 'Søk på brukarnamn';

  @override
  String get studySpectator => 'Tilskodar';

  @override
  String get studyContributor => 'Bidragsytar';

  @override
  String get studyKick => 'Kast ut';

  @override
  String get studyLeaveTheStudy => 'Forlat studien';

  @override
  String get studyYouAreNowAContributor => 'Du er no bidragsytar';

  @override
  String get studyYouAreNowASpectator => 'Du er no tilskodar';

  @override
  String get studyPgnTags => 'PGN-merkelappar';

  @override
  String get studyLike => 'Lik';

  @override
  String get studyUnlike => 'Slutt å lika';

  @override
  String get studyNewTag => 'Ny merkelapp';

  @override
  String get studyCommentThisPosition => 'Kommenter denne stillinga';

  @override
  String get studyCommentThisMove => 'Kommenter dette trekket';

  @override
  String get studyAnnotateWithGlyphs => 'Kommenter med symbol';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Kapittelet er for kort for å analyserast.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Berre bidragsytarar til studien kan be om maskinanalyse.';

  @override
  String get studyGetAFullComputerAnalysis => 'Få full maskinanalyse av hovedvarianten frå serveren.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Sørg for at kapittelet er fullført. Du kan berre be om analyse ein gong.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Alle SYNC-medlemene ser den same stillingen';

  @override
  String get studyShareChanges => 'Lagre endringar på serveren og del dei med tilskodarar';

  @override
  String get studyPlaying => 'Spelar no';

  @override
  String get studyShowResults => 'Resultat';

  @override
  String get studyShowEvalBar => 'Evalueringssøyler';

  @override
  String get studyFirst => 'Første';

  @override
  String get studyPrevious => 'Attende';

  @override
  String get studyNext => 'Neste';

  @override
  String get studyLast => 'Siste';

  @override
  String get studyShareAndExport => 'Del & eksporter';

  @override
  String get studyCloneStudy => 'Klon';

  @override
  String get studyStudyPgn => 'Studie-PGN';

  @override
  String get studyDownloadAllGames => 'Last ned alle spel';

  @override
  String get studyChapterPgn => 'Kapittel-PGN';

  @override
  String get studyCopyChapterPgn => 'Kopier PGN';

  @override
  String get studyDownloadGame => 'Last ned spel';

  @override
  String get studyStudyUrl => 'Studie-URL';

  @override
  String get studyCurrentChapterUrl => 'Kapittel-URL';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Du kan lime inn dette i forumet for å syna det der';

  @override
  String get studyStartAtInitialPosition => 'Start ved innleiande stilling';

  @override
  String studyStartAtX(String param) {
    return 'Start ved $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Inkorporer i websida eller bloggen din';

  @override
  String get studyReadMoreAboutEmbedding => 'Les meir om innbygging';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Berre offentlege studiar kan byggast inn!';

  @override
  String get studyOpen => 'Opne';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1 presentert av $param2';
  }

  @override
  String get studyStudyNotFound => 'Fann ikkje studien';

  @override
  String get studyEditChapter => 'Rediger kapittel';

  @override
  String get studyNewChapter => 'Nytt kapittel';

  @override
  String studyImportFromChapterX(String param) {
    return 'Importer frå $param';
  }

  @override
  String get studyOrientation => 'Retning';

  @override
  String get studyAnalysisMode => 'Analysemodus';

  @override
  String get studyPinnedChapterComment => 'Fastspikra kapittelkommentar';

  @override
  String get studySaveChapter => 'Lagre kapittelet';

  @override
  String get studyClearAnnotations => 'Fjern notat';

  @override
  String get studyClearVariations => 'Fjern variantar';

  @override
  String get studyDeleteChapter => 'Slett kapittel';

  @override
  String get studyDeleteThisChapter => 'Slette dette kapittelet? Avgjerda er endeleg og kan ikkje angrast!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Fjern alle kommentarar og figurar i dette kapittelet?';

  @override
  String get studyRightUnderTheBoard => 'Rett under brettet';

  @override
  String get studyNoPinnedComment => 'Ingen';

  @override
  String get studyNormalAnalysis => 'Normal analyse';

  @override
  String get studyHideNextMoves => 'Skjul neste trekk';

  @override
  String get studyInteractiveLesson => 'Interaktiv leksjon';

  @override
  String studyChapterX(String param) {
    return 'Kapittel $param';
  }

  @override
  String get studyEmpty => 'Tom';

  @override
  String get studyStartFromInitialPosition => 'Start ved innleiande stilling';

  @override
  String get studyEditor => 'Editor';

  @override
  String get studyStartFromCustomPosition => 'Start frå innleiande stilling';

  @override
  String get studyLoadAGameByUrl => 'Last opp eit parti frå URL';

  @override
  String get studyLoadAPositionFromFen => 'Last opp ein stilling frå FEN';

  @override
  String get studyLoadAGameFromPgn => 'Last opp eit parti frå PGN';

  @override
  String get studyAutomatic => 'Automatisk';

  @override
  String get studyUrlOfTheGame => 'URL for partiet';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Last opp eit parti frå $param1 eller $param2';
  }

  @override
  String get studyCreateChapter => 'Opprett kapittel';

  @override
  String get studyCreateStudy => 'Opprett ein studie';

  @override
  String get studyEditStudy => 'Rediger studie';

  @override
  String get studyVisibility => 'Synlegheit';

  @override
  String get studyPublic => 'Offentleg';

  @override
  String get studyUnlisted => 'Ikkje opplista';

  @override
  String get studyInviteOnly => 'Berre etter invitasjon';

  @override
  String get studyAllowCloning => 'Tillat kloning';

  @override
  String get studyNobody => 'Ingen';

  @override
  String get studyOnlyMe => 'Berre meg';

  @override
  String get studyContributors => 'Bidragsytarar';

  @override
  String get studyMembers => 'Medlemar';

  @override
  String get studyEveryone => 'Alle';

  @override
  String get studyEnableSync => 'Aktiver synk';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Ja: behald alle i den same stilllinga';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Nei: lat folk sjå fritt gjennom';

  @override
  String get studyPinnedStudyComment => 'Fastspikra studiekommentar';

  @override
  String get studyStart => 'Start';

  @override
  String get studySave => 'Lagre';

  @override
  String get studyClearChat => 'Fjern teksten frå kommentarfeltet';

  @override
  String get studyDeleteTheStudyChatHistory => 'Slette studiens kommentar-historikk? Du kan ikkje angre!';

  @override
  String get studyDeleteStudy => 'Slett studie';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Slette heile studien? Avgjerda er endeleg og kan ikke gjeras om! Skriv namnet på studien som skal stadfestast: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Kva for ein studie vil du bruke?';

  @override
  String get studyGoodMove => 'Godt trekk';

  @override
  String get studyMistake => 'Mistak';

  @override
  String get studyBrilliantMove => 'Strålande trekk';

  @override
  String get studyBlunder => 'Bukk';

  @override
  String get studyInterestingMove => 'Interessant trekk';

  @override
  String get studyDubiousMove => 'Tvilsamt trekk';

  @override
  String get studyOnlyMove => 'Einaste moglege trekk';

  @override
  String get studyZugzwang => 'Trekktvang';

  @override
  String get studyEqualPosition => 'Lik stilling';

  @override
  String get studyUnclearPosition => 'Uavklart stilling';

  @override
  String get studyWhiteIsSlightlyBetter => 'Kvit står litt betre';

  @override
  String get studyBlackIsSlightlyBetter => 'Svart står litt betre';

  @override
  String get studyWhiteIsBetter => 'Kvit står betre';

  @override
  String get studyBlackIsBetter => 'Svart står betre';

  @override
  String get studyWhiteIsWinning => 'Kvit står til vinst';

  @override
  String get studyBlackIsWinning => 'Svart står til vinst';

  @override
  String get studyNovelty => 'Nyskapning';

  @override
  String get studyDevelopment => 'Utvikling';

  @override
  String get studyInitiative => 'Initiativ';

  @override
  String get studyAttack => 'Åtak';

  @override
  String get studyCounterplay => 'Motspel';

  @override
  String get studyTimeTrouble => 'Tidsnaud';

  @override
  String get studyWithCompensation => 'Med kompensasjon';

  @override
  String get studyWithTheIdea => 'Med ideen';

  @override
  String get studyNextChapter => 'Neste kapittel';

  @override
  String get studyPrevChapter => 'Førre kapittel';

  @override
  String get studyStudyActions => 'Studiehandlingar';

  @override
  String get studyTopics => 'Tema';

  @override
  String get studyMyTopics => 'Mine tema';

  @override
  String get studyPopularTopics => 'Omtykte tema';

  @override
  String get studyManageTopics => 'Administrer tema';

  @override
  String get studyBack => 'Tilbake';

  @override
  String get studyPlayAgain => 'Spel på ny';

  @override
  String get studyWhatWouldYouPlay => 'Kva vil du spela i denne stillinga?';

  @override
  String get studyYouCompletedThisLesson => 'Gratulerar! Du har fullført denne leksjonen.';

  @override
  String studyPerPage(String param) {
    return '$param per side';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kapittel',
      one: '$count kapittel',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parti',
      one: '$count parti',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count medlemar',
      one: '$count medlem',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sett inn PGN-teksten din her, maksimum $count parti',
      one: 'Sett inn PGN-teksten din her, maksimum $count parti',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'for kort tid sidan';

  @override
  String get timeagoRightNow => 'nett no';

  @override
  String get timeagoCompleted => 'fullført';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count sekund',
      one: 'om $count sekund',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count minutt',
      one: 'om $count minutt',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'om $count timar',
      one: 'om $count time',
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
      other: 'om $count veker',
      one: 'om $count veke',
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
      other: '$count minutt sidan',
      one: '$count minutt sidan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count timar sidan',
      one: '$count time sidan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagar sidan',
      one: '$count dag sidan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veker sidan',
      one: '$count veke sidan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count månader sidan',
      one: '$count månad sidan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count år sidan',
      one: '$count år sidan',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutt igjen',
      one: '$count minutt igjen',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count timar igjen',
      one: '$count time igjen',
    );
    return '$_temp0';
  }
}
