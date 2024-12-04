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
  String get mobileBlindfoldMode => 'Legat la ochi';

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
  String mobileGreeting(String param) {
    return 'Salut, $param';
  }

  @override
  String get mobileGreetingWithoutName => 'Salut';

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
  String get mobilePuzzleStormFilterNothingToShow => 'Nimic de afișat, vă rugăm să schimbați filtrele';

  @override
  String get mobilePuzzleStormNothingToShow => 'Nimic de arătat. Jucați câteva partide de Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Rezolvă cât mai multe puzzle-uri în 3 minute.';

  @override
  String get mobilePuzzleStreakAbortWarning => 'Îți vei pierde streak-ul actual iar scorul va fi salvat.';

  @override
  String get mobilePuzzleThemesSubtitle => 'Joacă puzzle-uri din deschiderile tale preferate sau alege o temă.';

  @override
  String get mobilePuzzlesTab => 'Puzzle-uri';

  @override
  String get mobileRecentSearches => 'Căutări recente';

  @override
  String get mobileSettingsHapticFeedback => 'Control tactil';

  @override
  String get mobileSettingsImmersiveMode => 'Mod imersiv';

  @override
  String get mobileSettingsImmersiveModeSubtitle => 'Ascunde interfața de utilizator a sistemului în timpul jocului. Folosește această opțiune dacă ești deranjat de gesturile de navigare ale sistemului la marginile ecranului. Se aplică pentru ecranele de joc și Puzzle Storm.';

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
  String get mobileTheme => 'Theme';

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
  String get broadcastBroadcasts => 'Transmisiuni';

  @override
  String get broadcastMyBroadcasts => 'Transmisiile mele';

  @override
  String get broadcastLiveBroadcasts => 'Difuzări de turnee în direct';

  @override
  String get broadcastBroadcastCalendar => 'Broadcast calendar';

  @override
  String get broadcastNewBroadcast => 'O nouă difuzare în direct';

  @override
  String get broadcastSubscribedBroadcasts => 'Transmisii abonate';

  @override
  String get broadcastAboutBroadcasts => 'Despre emisiuni';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Cum să utilizați emisiunile Lichess.';

  @override
  String get broadcastTheNewRoundHelp => 'Runda noua va avea aceiași membri și contribuitori ca cea anterioară.';

  @override
  String get broadcastAddRound => 'Adaugă o rundă';

  @override
  String get broadcastOngoing => 'În desfășurare';

  @override
  String get broadcastUpcoming => 'Următoare';

  @override
  String get broadcastCompleted => 'Terminate';

  @override
  String get broadcastCompletedHelp => 'Lichess detectează finalizarea rundei pe baza jocurilor sursă. Utilizați această comutare dacă nu există nicio sursă.';

  @override
  String get broadcastRoundName => 'Numele rundei';

  @override
  String get broadcastRoundNumber => 'Număr rotund';

  @override
  String get broadcastTournamentName => 'Numele turneului';

  @override
  String get broadcastTournamentDescription => 'O descriere scurtă a turneului';

  @override
  String get broadcastFullDescription => 'Întreaga descriere a evenimentului';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return 'Descriere lungă, opțională, a difuzării. $param1 este disponibil. Lungimea trebuie să fie mai mică decât $param2 caractere.';
  }

  @override
  String get broadcastSourceSingleUrl => 'URL sursă PGN';

  @override
  String get broadcastSourceUrlHelp => 'URL-ul pe care Lichess îl va verifica pentru a obține actualizări al PGN-ului. Trebuie să fie public accesibil pe Internet.';

  @override
  String get broadcastSourceGameIds => 'Până la 64 de ID-uri de joc Lichess, separate prin spații.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Start date in the tournament local timezone: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Opțional, dacă știi când va începe evenimentul';

  @override
  String get broadcastCurrentGameUrl => 'URL-ul partidei curente';

  @override
  String get broadcastDownloadAllRounds => 'Descarcă toate rundele';

  @override
  String get broadcastResetRound => 'Resetează această rundă';

  @override
  String get broadcastDeleteRound => 'Șterge această rundă';

  @override
  String get broadcastDefinitivelyDeleteRound => 'Șterge definitiv runda și jocurile sale.';

  @override
  String get broadcastDeleteAllGamesOfThisRound => 'Șterge toate jocurile din această rundă. Sursa va trebui să fie activă pentru a le recrea.';

  @override
  String get broadcastEditRoundStudy => 'Editare rundă de studiu';

  @override
  String get broadcastDeleteTournament => 'Șterge acest turneu';

  @override
  String get broadcastDefinitivelyDeleteTournament => 'Sigur doresc să ștergeți întregul turneu, toate rundele și toate jocurile sale.';

  @override
  String get broadcastShowScores => 'Arată scorurile jucătorilor pe baza rezultatelor jocului';

  @override
  String get broadcastReplacePlayerTags => 'Opțional: înlocuiește numele jucătorilor, ratingurile și titlurile';

  @override
  String get broadcastFideFederations => 'Federații FIDE';

  @override
  String get broadcastTop10Rating => 'Top 10 evaluări';

  @override
  String get broadcastFidePlayers => 'Jucători FIDE';

  @override
  String get broadcastFidePlayerNotFound => 'Jucătorul FIDE nu a fost găsit';

  @override
  String get broadcastFideProfile => 'Profil FIDE';

  @override
  String get broadcastFederation => 'Federație';

  @override
  String get broadcastAgeThisYear => 'Vârsta în acest an';

  @override
  String get broadcastUnrated => 'Fără rating';

  @override
  String get broadcastRecentTournaments => 'Turnee recente';

  @override
  String get broadcastOpenLichess => 'Deschide în Lichess';

  @override
  String get broadcastTeams => 'Echipe';

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
  String get broadcastStandings => 'Clasament';

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
  String get broadcastScore => 'Scor';

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
      other: '$count de transmisiuni',
      few: '$count transmisiuni',
      one: '$count transmisiune',
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
  String get challengeRegisterToSendChallenges => 'Te rugăm să te înregistrezi pentru a putea trimite provocări.';

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
  String get challengeDeclineTooFast => 'Acest timp este prea rapid pentru mine, te rog să mă provoci cu un timp mai lent.';

  @override
  String get challengeDeclineTooSlow => 'Acest timp este prea lent pentru mine, te rog să mă provoci cu un timp mai rapid.';

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
  String get perfStatNotEnoughRatedGames => 'Nu au fost jucate destule meciuri oficiale pentru a stabili un rating solid.';

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
  String get preferencesExplainShowPlayerRatings => 'Acest lucru permite ascunderea tuturor ratingurilor de pe site, pentru a ajuta la concentrarea pe jocul de șah. Jocurile pot fi evaluate, această setare este doar despre ce se poate vedea.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Arată indicatorul de redimensionare a tablei';

  @override
  String get preferencesOnlyOnInitialPosition => 'Doar inainte de prima mutare';

  @override
  String get preferencesInGameOnly => 'Doar în joc';

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
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Mutare anticipată (mută pe timpul adversarului)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Dă înapoi (cu aprobarea adversarului)';

  @override
  String get preferencesInCasualGamesOnly => 'În jocuri amicale';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promovează automat în damă';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Țineți apăsată tasta <ctrl> în timp ce promovați un pion pentru a dezactiva temporar promovarea automată';

  @override
  String get preferencesWhenPremoving => 'În cazul mutărilor anticipate';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Declară automat o remiză în cazul a trei repetări';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Când timpul rămas e mai scurt de 30 de secunde';

  @override
  String get preferencesMoveConfirmation => 'Confirmare mutare';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Poate fi dezactivat în timpul unui joc cu meniul de tablă';

  @override
  String get preferencesInCorrespondenceGames => 'În jocuri prin corespondență';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Corespondență sau timp nelimitat';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Confirmă abandonarea și oferirea remizei';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Metoda prin care faci rocada';

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
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Spune \"Joc bun, bine jucat\" la înfrângere sau la remiză';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Preferințele tale au fost salvate';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Derulează pe tablă pentru a rejuca mutările';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Notificare zilnică prin email cu lista jocurilor prin corespondență';

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
  String get puzzleYourPuzzleRatingWillNotChange => 'Evaluarea ta la puzzle-uri nu se va schimba. Iți amintim că puzzle-urile nu sunt o competiție. Evaluarea ajută la selectarea celor mai bune puzzle-uri care corespund nivelului tău.';

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
  String get puzzleOpeningsYouPlayedTheMost => 'Deschideri pe care le-ai jucat cel mai mult în meciurile evaluate';

  @override
  String get puzzleUseFindInPage => 'Folosește \"Găsește în pagină\" în meniul browser-ului pentru a găsi deschiderea ta preferată!';

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
  String get puzzleStreakDescription => 'Rezolvă probleme din ce în ce mai grele și construiește un șir de victorii consecutive. Nu există limită de timp, deci nu te grăbi. O mișcare greșită și jocul s-a terminat! Dar poți sări peste o mutare în fiecare sesiune.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Probleme consecutive: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Sări peste această mutare pentru a-ți păstra șirul de probleme consecutive reușite! Funcționează o singură dată pe sesiune.';

  @override
  String get puzzleContinueTheStreak => 'Continuă secvența';

  @override
  String get puzzleNewStreak => 'Începe o nouă secvență';

  @override
  String get puzzleFromMyGames => 'Din jocurile mele';

  @override
  String get puzzleLookupOfPlayer => 'Caută puzzle-uri din jocurile unui jucător';

  @override
  String puzzleFromXGames(String param) {
    return 'Puzzle-uri din jocurile $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Caută puzzle-uri';

  @override
  String get puzzleFromMyGamesNone => 'Nu ai nici o problemă în baza de date, dar Lichess tot te apreciază foarte mult.\nJoacă jocuri rapide și clasice pentru a crește șansele de a vedea adăugată o problemă extrasă din partidele tale!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 probleme găsite în $param2 jocuri';
  }

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
  String get puzzleThemeAdvancedPawnDescription => 'Unul dintre pionii care este avansat in teritoriul inamic, poate amenință să promoveze.';

  @override
  String get puzzleThemeAdvantage => 'Avantaj';

  @override
  String get puzzleThemeAdvantageDescription => 'Profită de șansa ta pentru a obține un avantaj decisiv. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mat-ul Anastasiei';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Un cal şi o tură sau o regină fac echipă pentru a prinde regele opus între marginea tablei şi o piesă aliată.';

  @override
  String get puzzleThemeArabianMate => 'Mat-ul arab';

  @override
  String get puzzleThemeArabianMateDescription => 'Un cal și o tură au făcut echipă să prinda regele într-un colț de tablă.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Atac pe f2 sau f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Un atac concentrat pe pionul f2 sau f7, cum ar fi în deschiderea ficat prăjit (atacul Fegatello).';

  @override
  String get puzzleThemeAttraction => 'Atragere';

  @override
  String get puzzleThemeAttractionDescription => 'Un schimb sau sacrificiu care încurajează sau forțează o piesă adversară pe un pătrat care permite o tactică ulterioară.';

  @override
  String get puzzleThemeBackRankMate => 'Mat pe rândul din spate';

  @override
  String get puzzleThemeBackRankMateDescription => 'Dă șah mat regelui pe rândul inițial, când e blocat acolo de propriele lui piese.';

  @override
  String get puzzleThemeBishopEndgame => 'Final cu nebuni';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Un final de partidă doar cu nebuni și pioni.';

  @override
  String get puzzleThemeBodenMate => 'Mat-ul lui Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Doi nebuni care atacă pe diagonale încrucișate livrează mat-ul unui rege blocat de piese aliate.';

  @override
  String get puzzleThemeCastling => 'Rocada';

  @override
  String get puzzleThemeCastlingDescription => 'Adu regele în siguranță și mută tura pentru atac.';

  @override
  String get puzzleThemeCapturingDefender => 'Capturează apărătorul';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Capturarea unei piese esențiale apărării alteia, permițând captura piesei acum neapărată la o mutare ulterioară.';

  @override
  String get puzzleThemeCrushing => 'Zdrobitor';

  @override
  String get puzzleThemeCrushingDescription => 'Observă gafa adversarului pentru a obține un avantaj zdrobitor. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat-ul cu doi nebuni';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Doi nebuni care atacă pe diagonale adiacente livrează mat-ul unui rege blocat de piese aliate.';

  @override
  String get puzzleThemeDovetailMate => 'Mat-ul dovertail';

  @override
  String get puzzleThemeDovetailMateDescription => 'O regină livrează mat-ul unui rege adiacent, care are doar două patrate de scapare dar sunt blocate de piese aliate.';

  @override
  String get puzzleThemeEquality => 'Egalitate';

  @override
  String get puzzleThemeEqualityDescription => 'Întoarce-te dintr-o poziție de pierdere și asigură o remiză sau o poziție echilibrată. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Atac pe partea regelui';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Un atac al regelui adversarului, după ce a făcut rocada pe partea regelui.';

  @override
  String get puzzleThemeClearance => 'Îndepărtare';

  @override
  String get puzzleThemeClearanceDescription => 'O mutare, adeseori cu tempo, care eliberează un pătrat, o coloană sau o diagonală pentru o idee tactică ulterioară.';

  @override
  String get puzzleThemeDefensiveMove => 'Mutare defensivă';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'O mutare precisă sau o secvență de mutări care e necesară pentru a evita pierderea pieselor sau a unui alt avantaj.';

  @override
  String get puzzleThemeDeflection => 'Deviere';

  @override
  String get puzzleThemeDeflectionDescription => 'O mutare care distrage o piesă adversară de la o altă funcție pe care o îndeplinește, cum ar fi apărarea unui pătrat esențial.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Atac prin descoperire';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Mutarea unei piese care bloca anterior un atac de la o altă piesă cu rază lungă de acțiune, cum ar fi un cal din calea unui turn.';

  @override
  String get puzzleThemeDoubleCheck => 'Șah dublu';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Șahul cu două piese deodată, ca rezultat al unui atac descoperit unde și piesa mutată, și cea descoperită atacă regele adversarului.';

  @override
  String get puzzleThemeEndgame => 'Final de partidă';

  @override
  String get puzzleThemeEndgameDescription => 'O tactică în ultima etapă a jocului.';

  @override
  String get puzzleThemeEnPassantDescription => 'O tactică cu regula en passant, unde un pion poate captura un pion adversar care l-a întrecut folosind mutarea sa inițială de două pătrate.';

  @override
  String get puzzleThemeExposedKing => 'Rege expus';

  @override
  String get puzzleThemeExposedKingDescription => 'O tactică ce implică un rege cu puțini apărători în jurul său, adeseori rezultând în șah mat.';

  @override
  String get puzzleThemeFork => 'Bifurcare';

  @override
  String get puzzleThemeForkDescription => 'O mutare unde piesa mutată atacă două piese adversare deodată.';

  @override
  String get puzzleThemeHangingPiece => 'Piesă neprotejată';

  @override
  String get puzzleThemeHangingPieceDescription => 'O tactică ce implică o piesă adversară care e neprotejată sau apărată insuficient și e liberă pentru capturare.';

  @override
  String get puzzleThemeHookMate => 'Mat-ul hook';

  @override
  String get puzzleThemeHookMateDescription => 'Șah mat cu o tură, un cal și un pion alături de un pion inamic pentru a limita metodele de scăpare ale regelui.';

  @override
  String get puzzleThemeInterference => 'Obstacol';

  @override
  String get puzzleThemeInterferenceDescription => 'Mutarea unei piese între două piese adversare pentru a lăsa una sau ambele piese adversare neprotejate, cum ar fi un cal pe un pătrat protejat dintre două ture.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'În loc să faci mutarea așteptată, mai întâi intervii cu o altă mutare care e o amenințare imediată, căreia adversarul trebuie să-i răspundă. Cunoscut și ca \"Zwischenzug\" sau \"In between\".';

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
  String get puzzleThemeMasterDescription => 'Puzzle-uri din partidele jucate de jucători care au primit titluri FIDE.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partide maestru vs maestru';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Puzzle-uri din partidele jucate între doi jucători care au primit titluri FIDE.';

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
  String get puzzleThemePinDescription => 'O tactică cu blocări, unde o piesă nu se poate mișca fără a descoperi un atac asupra unei piese mai valoroase.';

  @override
  String get puzzleThemePromotion => 'Promovare';

  @override
  String get puzzleThemePromotionDescription => 'Un pion care promovează sau amenință să promoveze e cheia acestei tactici.';

  @override
  String get puzzleThemeQueenEndgame => 'Final cu regine';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Un final de partidă doar cu regine și pioni.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Final cu regine și turnuri';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Un final de partidă doar cu regine, turnuri și pioni.';

  @override
  String get puzzleThemeQueensideAttack => 'Atac pe partea reginei';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Un atac asupra regelui adversarului, după ce a făcut rocada pe partea reginei.';

  @override
  String get puzzleThemeQuietMove => 'Mutare silențioasă';

  @override
  String get puzzleThemeQuietMoveDescription => 'O mutare care nu capturează sau dă șah, dar care pregătește o amenințare inevitabilă pentru o mutare ulterioară.';

  @override
  String get puzzleThemeRookEndgame => 'Final cu turnuri';

  @override
  String get puzzleThemeRookEndgameDescription => 'Un final de partidă doar cu turnuri și pioni.';

  @override
  String get puzzleThemeSacrifice => 'Sacrificiu';

  @override
  String get puzzleThemeSacrificeDescription => 'O tactică care implică renunțarea la material pe termen scurt pentru a câștiga un avantaj din nou după o secvență forțată de mutări.';

  @override
  String get puzzleThemeShort => 'Puzzle scurt';

  @override
  String get puzzleThemeShortDescription => 'Două mutări pentru a câștiga.';

  @override
  String get puzzleThemeSkewer => 'Skewer';

  @override
  String get puzzleThemeSkewerDescription => 'Un motiv care implică atacarea unei piese de mare valoare, mutarea înafara traseului, și permițând capturarea sau atacarea unei piese cu valoare inferioară în spatele ei, inversul unui pin.';

  @override
  String get puzzleThemeSmotheredMate => 'Mat sufocat';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Un șah mat livrat de un cal în care regele împerechiat este incapabil să se miște deoarece este înconjurat (sau sufocat) de piesele lui aliate.';

  @override
  String get puzzleThemeSuperGM => 'Partidele Super GM';

  @override
  String get puzzleThemeSuperGMDescription => 'Puzzle-uri din partidele jucate de cei mai buni jucători din lume.';

  @override
  String get puzzleThemeTrappedPiece => 'Piesa blocată';

  @override
  String get puzzleThemeTrappedPieceDescription => 'O piesa este incapabilă de a scăpa din capturarea deoarece are mutări limitate.';

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
  String get puzzleThemeXRayAttackDescription => 'O piesă atacă sau apară un patrat, printr-o piesă inamică.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Adversarul este limitat în mișcările pe care le poate face, iar toate mișcările îi înrăutățesc poziția.';

  @override
  String get puzzleThemeMix => 'Amestec sănătos';

  @override
  String get puzzleThemeMixDescription => 'Un pic din toate. Nu știi la ce să te aștepți, așa că rămâi gata pentru orice! La fel ca în jocurile reale.';

  @override
  String get puzzleThemePlayerGames => 'Partide jucători';

  @override
  String get puzzleThemePlayerGamesDescription => 'Caută puzzle-uri generate din partidele tale sau din partidele unui alt jucător.';

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
  String get settingsManagedAccountCannotBeClosed => 'Contul tău este gestionat și nu poate fi închis.';

  @override
  String get settingsClosingIsDefinitive => 'Închiderea este definitivă. Nu există cale de întoarcere. Ești sigur?';

  @override
  String get settingsCantOpenSimilarAccount => 'Nu îți va fi permis să creezi un cont nou cu același nume, indiferent dacă literele sunt minuscule sau majuscule.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'M-am răzgandit, nu îmi închide contul.';

  @override
  String get settingsCloseAccountExplanation => 'Ești sigur că vrei să-ți închizi contul? Închiderea contului este o decizie permanentă. NU te vei mai putea conecta NICIODATĂ.';

  @override
  String get settingsThisAccountIsClosed => 'Contul este închis.';

  @override
  String get playWithAFriend => 'Jucaţi cu un prieten';

  @override
  String get playWithTheMachine => 'Jucați cu calculatorul';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Pentru a invita pe cineva să joace, folosiți acest URL';

  @override
  String get gameOver => 'Partidă încheiată';

  @override
  String get waitingForOpponent => 'Se așteaptă adversarul';

  @override
  String get orLetYourOpponentScanQrCode => 'Sau lăsați adversarul să scaneze acest cod QR';

  @override
  String get waiting => 'Se așteaptă';

  @override
  String get yourTurn => 'Rândul tău';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 nivel $param2';
  }

  @override
  String get level => 'Nivel';

  @override
  String get strength => 'Putere';

  @override
  String get toggleTheChat => 'Arată/ascunde discuția';

  @override
  String get chat => 'Discuţie';

  @override
  String get resign => 'Abandonează';

  @override
  String get checkmate => 'Şah mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Alb';

  @override
  String get black => 'Negru';

  @override
  String get asWhite => 'cu albele';

  @override
  String get asBlack => 'cu negrele';

  @override
  String get randomColor => 'Culoare aleatorie';

  @override
  String get createAGame => 'Creează un joc';

  @override
  String get whiteIsVictorious => 'Albul a câștigat';

  @override
  String get blackIsVictorious => 'Negrul a câștigat';

  @override
  String get youPlayTheWhitePieces => 'Joci cu albele';

  @override
  String get youPlayTheBlackPieces => 'Joci cu negrele';

  @override
  String get itsYourTurn => 'E rândul tău!';

  @override
  String get cheatDetected => 'S-a trişat';

  @override
  String get kingInTheCenter => 'Regele în centru';

  @override
  String get threeChecks => 'Trei șahuri';

  @override
  String get raceFinished => 'Competiție terminată';

  @override
  String get variantEnding => 'Sfârșit prin variantă';

  @override
  String get newOpponent => 'Adversar nou';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Adversarul dvs. vă propune o nouă partidă';

  @override
  String get joinTheGame => 'Intră în partidă';

  @override
  String get whitePlays => 'Albul joacă';

  @override
  String get blackPlays => 'Negrul joacă';

  @override
  String get opponentLeftChoices => 'Adversarul tău a părăsit jocul. Poți cere victoria, decide remiza sau îl poți aștepta.';

  @override
  String get forceResignation => 'Revendică victoria';

  @override
  String get forceDraw => 'Anunță remiză';

  @override
  String get talkInChat => 'Te rog să fii cu bun simț pe chat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Prima persoană care accesează acest link va juca cu tine.';

  @override
  String get whiteResigned => 'Albul a cedat';

  @override
  String get blackResigned => 'Negrul a cedat';

  @override
  String get whiteLeftTheGame => 'Albul a părăsit partida';

  @override
  String get blackLeftTheGame => 'Negrul a părăsit partida';

  @override
  String get whiteDidntMove => 'Albul nu s-a mișcat';

  @override
  String get blackDidntMove => 'Negrul nu s-a mișcat';

  @override
  String get requestAComputerAnalysis => 'Cereți o analiză făcută de calculator';

  @override
  String get computerAnalysis => 'Analiza computer-ului';

  @override
  String get computerAnalysisAvailable => 'Analiză computerizată disponibilă';

  @override
  String get computerAnalysisDisabled => 'Analiză computerizată dezactivată';

  @override
  String get analysis => 'Tablă de analiză';

  @override
  String depthX(String param) {
    return 'Profunzime $param';
  }

  @override
  String get usingServerAnalysis => 'Utilizează analiză de server';

  @override
  String get loadingEngine => 'Se încarcă motorul de analiză...';

  @override
  String get calculatingMoves => 'Se calculează mutările...';

  @override
  String get engineFailed => 'Eroare încărcare motor';

  @override
  String get cloudAnalysis => 'Analiză online';

  @override
  String get goDeeper => 'Mergi mai în profunzime';

  @override
  String get showThreat => 'Afișează amenințarea';

  @override
  String get inLocalBrowser => 'în browserul local';

  @override
  String get toggleLocalEvaluation => 'Pornește/oprește evaluarea locală';

  @override
  String get promoteVariation => 'Promovează variația';

  @override
  String get makeMainLine => 'Fă-o variația principală';

  @override
  String get deleteFromHere => 'Șterge de aici';

  @override
  String get collapseVariations => 'Restrânge variațiile';

  @override
  String get expandVariations => 'Extinde variațiile';

  @override
  String get forceVariation => 'Forțează variația';

  @override
  String get copyVariationPgn => 'Copiază varianta PGN';

  @override
  String get move => 'Mutare';

  @override
  String get variantLoss => 'Variantă pierdere';

  @override
  String get variantWin => 'Variantă câștig';

  @override
  String get insufficientMaterial => 'Material insuficient';

  @override
  String get pawnMove => 'Mutare de pion';

  @override
  String get capture => 'Captură';

  @override
  String get close => 'Închide';

  @override
  String get winning => 'Câştigă';

  @override
  String get losing => 'Pierde';

  @override
  String get drawn => 'Remiză';

  @override
  String get unknown => 'Necunoscut';

  @override
  String get database => 'Bază de date';

  @override
  String get whiteDrawBlack => 'Alb / Remiză / Negru';

  @override
  String averageRatingX(String param) {
    return 'Medie evaluare: $param';
  }

  @override
  String get recentGames => 'Jocuri recente';

  @override
  String get topGames => 'Cele mai bune jocuri';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Două milioane de jocuri reale OTB ale jucătorilor cu evaluare FIDE $param1+ între $param2 și $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' cu rotunjire, bazat pe numărul de jumătăți de mutări până la următoarea captură sau mutare de pion';

  @override
  String get noGameFound => 'Nu a fost găsit nici un joc';

  @override
  String get maxDepthReached => 'Adâncime maximă atinsă!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Poate doriți să includeți mai multe jocuri din meniul de preferințe?';

  @override
  String get openings => 'Deschideri';

  @override
  String get openingExplorer => 'Exploratorul de deschideri';

  @override
  String get openingEndgameExplorer => 'Explorator de deschideri/finaluri de joc';

  @override
  String xOpeningExplorer(String param) {
    return 'Exploratorul de deschideri $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Joacă prima mutare de deschidere/final de joc-explorator';

  @override
  String get winPreventedBy50MoveRule => 'Victoria partidei a fost împiedicată de regula celor 50 de mutări';

  @override
  String get lossSavedBy50MoveRule => 'Pierderea partidei a fost împiedicată de regula celor 50 de mutări';

  @override
  String get winOr50MovesByPriorMistake => 'Câștig sau remiză la 50 de mutări din cauza unei greșeli anterioare';

  @override
  String get lossOr50MovesByPriorMistake => 'Pierdere sau remiză la 50 de mutări din cauza unei greșeli anterioare';

  @override
  String get unknownDueToRounding => 'Câștigul sau pierderea este garantată numai dacă a fost urmată linia de bază recomandată de la ultima capturare sau mișcare de pion, din cauza eventualelor rotunjiri.';

  @override
  String get allSet => 'Gata!';

  @override
  String get importPgn => 'Importare PGN';

  @override
  String get delete => 'Șterge';

  @override
  String get deleteThisImportedGame => 'Ștergi acest joc importat?';

  @override
  String get replayMode => 'Modul de reluare';

  @override
  String get realtimeReplay => 'În timp real';

  @override
  String get byCPL => 'După CPL';

  @override
  String get enable => 'Activează';

  @override
  String get bestMoveArrow => 'Săgeată pentru cea mai bună mutare';

  @override
  String get showVariationArrows => 'Afișează săgețile variației';

  @override
  String get evaluationGauge => 'Indicator de evaluare';

  @override
  String get multipleLines => 'Mutări multiple';

  @override
  String get cpus => 'Procesoare';

  @override
  String get memory => 'Memorie';

  @override
  String get infiniteAnalysis => 'Analiză infinită';

  @override
  String get removesTheDepthLimit => 'Elimină limita de adâncime (și încălzește computerul)';

  @override
  String get blunder => 'Gafă';

  @override
  String get mistake => 'Greșeală';

  @override
  String get inaccuracy => 'Inexactitate';

  @override
  String get moveTimes => 'Timpii de mutare';

  @override
  String get flipBoard => 'Rotiţi tabla';

  @override
  String get threefoldRepetition => 'Repetare de trei ori';

  @override
  String get claimADraw => 'Cere remiză';

  @override
  String get offerDraw => 'Propune remiză';

  @override
  String get draw => 'Remiză';

  @override
  String get drawByMutualAgreement => 'Remiză prin acord reciproc';

  @override
  String get fiftyMovesWithoutProgress => 'Cincizeci de mișcări fără progres';

  @override
  String get currentGames => 'Partide active';

  @override
  String get viewInFullSize => 'Vezi la dimensiune completă';

  @override
  String get logOut => 'Deconectare';

  @override
  String get signIn => 'Autentificare';

  @override
  String get rememberMe => 'Ține-mă minte';

  @override
  String get youNeedAnAccountToDoThat => 'Aveți nevoie de cont pentru această acțiune';

  @override
  String get signUp => 'Înregistrare';

  @override
  String get computersAreNotAllowedToPlay => 'Computerele și jucătorii asistați de computer nu au voie să joace. Vă rugăm ca în timpul partidei să nu primiți asistență de la motoare de șah, baze de date, sau de la alți jucători. Rețineți totodată că acțiunea de creare a mai multor conturi este descurajată și că un număr mare de conturi vor conduce la blocarea accesului pe site (ban).';

  @override
  String get games => 'Partide';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 a comentat la subiectul $param2';
  }

  @override
  String get latestForumPosts => 'Ultimele postări pe forum';

  @override
  String get players => 'Jucători';

  @override
  String get friends => 'Prieteni';

  @override
  String get otherPlayers => 'alți jucători';

  @override
  String get discussions => 'Discuții';

  @override
  String get today => 'Astăzi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get minutesPerSide => 'Minute pe parte';

  @override
  String get variant => 'Variantă';

  @override
  String get variants => 'Variante';

  @override
  String get timeControl => 'Controlul de timp';

  @override
  String get realTime => 'În timp real';

  @override
  String get correspondence => 'Corespondență';

  @override
  String get daysPerTurn => 'Zile pentru o mutare';

  @override
  String get oneDay => 'O zi';

  @override
  String get time => 'Timp';

  @override
  String get rating => 'Clasament';

  @override
  String get ratingStats => 'Statistică pentru clasament';

  @override
  String get username => 'Nume de utilizator';

  @override
  String get usernameOrEmail => 'Nume de utilizator sau email';

  @override
  String get changeUsername => 'Schimbă numele de utilizator';

  @override
  String get changeUsernameNotSame => 'Se poate interschimba din minuscule în majuscule. De exemplu: „johndoe” în „JohnDoe”.';

  @override
  String get changeUsernameDescription => 'Schimbă-ți numele de utilizator. Această operație poate fi efectuată o singură dată și presupune doar schimbarea literelor din minuscule în majuscule și invers.';

  @override
  String get signupUsernameHint => 'Asigurați-vă că alegeți un nume de utilizator decent. Nu îl puteți schimba mai târziu și orice cont cu nume de utilizator indecent va fi închis!';

  @override
  String get signupEmailHint => 'Îl vom folosi doar pentru resetarea parolei.';

  @override
  String get password => 'Parolă';

  @override
  String get changePassword => 'Schimbă parola';

  @override
  String get changeEmail => 'Schimbă emailul';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Resetează parola';

  @override
  String get forgotPassword => 'Ți-ai uitat parola?';

  @override
  String get error_weakPassword => 'Această parolă este extrem de comună şi prea uşor de ghicit.';

  @override
  String get error_namePassword => 'Te rugăm să nu folosești numele tău de utilizator ca parolă.';

  @override
  String get blankedPassword => 'Ați folosit aceeași parolă pe un alt site, iar acel site a fost compromis. Pentru a asigura siguranța contului dvs. Lichess, trebuie să setați o parolă nouă. Vă mulțumim pentru înțelegere.';

  @override
  String get youAreLeavingLichess => 'Părăsești Lichess';

  @override
  String get neverTypeYourPassword => 'Nu introduceți niciodată parola Lichess pe un alt site!';

  @override
  String proceedToX(String param) {
    return 'Continuă către $param';
  }

  @override
  String get passwordSuggestion => 'Nu seta o parolă sugerată de altcineva. O vor folosi pentru a vă fura contul.';

  @override
  String get emailSuggestion => 'Nu setați o adresă de e-mail sugerată de altcineva. O vor folosi pentru a vă fura contul.';

  @override
  String get emailConfirmHelp => 'Ajutor cu confirmarea adresei de email';

  @override
  String get emailConfirmNotReceived => 'Nu ai primit emailul de confirmare după înregistrare?';

  @override
  String get whatSignupUsername => 'Ce nume de utilizator ai folosit pentru a te înregistra?';

  @override
  String usernameNotFound(String param) {
    return 'Nu am putut găsi niciun utilizator cu acest nume: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Poți folosi acest nume de utilizator pentru a crea un cont nou';

  @override
  String emailSent(String param) {
    return 'Am trimis un email la $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Poate dura ceva timp să ajungă.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Așteptați 5 minute și reîncărcați emailurile primite.';

  @override
  String get checkSpamFolder => 'De asemenea, verificați folderul de spam, ar putea ajunge acolo. În acel caz, marcați-l ca nefiind spam.';

  @override
  String get emailForSignupHelp => 'Dacă niciuna dintre variantele anterioare nu functioneaza, trimiteți-ne acest email:';

  @override
  String copyTextToEmail(String param) {
    return 'Dați copy-paste la textul de mai sus și trimiteți-l la $param';
  }

  @override
  String get waitForSignupHelp => 'Vom reveni în curând cu un răspuns pentru a vă ajuta să finalizați înregistrarea.';

  @override
  String accountConfirmed(String param) {
    return 'Utilizatorul $param a fost confirmat cu succes.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Vă puteți autentifica chiar acum ca $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Nu aveți nevoie de un email de confirmare.';

  @override
  String accountClosed(String param) {
    return 'Contul $param este închis.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Contul $param a fost înregistrat fără o adresă de email.';
  }

  @override
  String get rank => 'Clasificare';

  @override
  String rankX(String param) {
    return 'Loc în clasament: $param';
  }

  @override
  String get gamesPlayed => 'Partide jucate';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Anulare';

  @override
  String get whiteTimeOut => 'Timpul pentru alb a expirat';

  @override
  String get blackTimeOut => 'Timpul pentru negru a expirat';

  @override
  String get drawOfferSent => 'Propunere de remiză trimisă';

  @override
  String get drawOfferAccepted => 'Propunere de remiză acceptată';

  @override
  String get drawOfferCanceled => 'Propunere remiză anulată';

  @override
  String get whiteOffersDraw => 'Albul a oferit remiza';

  @override
  String get blackOffersDraw => 'Negrul a oferit remiza';

  @override
  String get whiteDeclinesDraw => 'Albul refuză propunerea de remiză';

  @override
  String get blackDeclinesDraw => 'Negrul refuză propunerea de remiză';

  @override
  String get yourOpponentOffersADraw => 'Adversarul dvs. vă propune remiza';

  @override
  String get accept => 'Acceptați';

  @override
  String get decline => 'Refuzați';

  @override
  String get playingRightNow => 'În desfășurare...';

  @override
  String get eventInProgress => 'În desfășurare';

  @override
  String get finished => 'Terminat';

  @override
  String get abortGame => 'Abandonați partida';

  @override
  String get gameAborted => 'Partidă abandonată';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Poziție personalizată';

  @override
  String get unlimited => 'Nelimitat';

  @override
  String get mode => 'Mod';

  @override
  String get casual => 'Amical';

  @override
  String get rated => 'Oficial';

  @override
  String get casualTournament => 'Amical';

  @override
  String get ratedTournament => 'Oficial';

  @override
  String get thisGameIsRated => 'Această partidă este oficială';

  @override
  String get rematch => 'Revanșă';

  @override
  String get rematchOfferSent => 'Propunerea de revanșă a fost trimisă';

  @override
  String get rematchOfferAccepted => 'Propunerea de revanșă a fost acceptată';

  @override
  String get rematchOfferCanceled => 'Propunerea de revanșă a fost anulată';

  @override
  String get rematchOfferDeclined => 'Propunerea de revanșă a fost respinsă';

  @override
  String get cancelRematchOffer => 'Anulați propunerea de revanșă';

  @override
  String get viewRematch => 'Urmărește revanșa';

  @override
  String get confirmMove => 'Confirmă mutarea';

  @override
  String get play => 'Joacă';

  @override
  String get inbox => 'Căsuță poștală';

  @override
  String get chatRoom => 'Zona de chat';

  @override
  String get loginToChat => 'Conectare la chat';

  @override
  String get youHaveBeenTimedOut => 'Pentru o perioadă, nu mai aveți acces la chat.';

  @override
  String get spectatorRoom => 'Zona spectatorilor';

  @override
  String get composeMessage => 'Compune un mesaj';

  @override
  String get subject => 'Subiect';

  @override
  String get send => 'Trimite';

  @override
  String get incrementInSeconds => 'Adaos de timp în secunde';

  @override
  String get freeOnlineChess => 'Șah Online Gratuit';

  @override
  String get exportGames => 'Exportă partidele';

  @override
  String get ratingRange => 'Nivel valoric';

  @override
  String get thisAccountViolatedTos => 'Acest cont a încălcat condițiile de utilizare ale site-ului Lichess';

  @override
  String get openingExplorerAndTablebase => 'Deschide exploratorul & baza de date';

  @override
  String get takeback => 'Revocare';

  @override
  String get proposeATakeback => 'Propune revocarea mutării';

  @override
  String get takebackPropositionSent => 'Propunere de revocare trimisă';

  @override
  String get takebackPropositionDeclined => 'Propunerea de revocare respinsă';

  @override
  String get takebackPropositionAccepted => 'Propunerea de revocare acceptată';

  @override
  String get takebackPropositionCanceled => 'Propunerea de revocare anulată';

  @override
  String get yourOpponentProposesATakeback => 'Adversarul tău propune revocarea unei mutări';

  @override
  String get bookmarkThisGame => 'Marcați această partidă';

  @override
  String get tournament => 'Turneu';

  @override
  String get tournaments => 'Turnee';

  @override
  String get tournamentPoints => 'Puncte de turneu';

  @override
  String get viewTournament => 'Vizualizați turneul';

  @override
  String get backToTournament => 'Înapoi la turneu';

  @override
  String get noDrawBeforeSwissLimit => 'Nu poți declara remiză înainte ca 30 de mutări să fie jucate într-un turneu elvețian.';

  @override
  String get thematic => 'Tematică';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Scorul tău la $param este provizoriu';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Scorul tău la $param1 ($param2) este prea mare';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Scorul tău săptămânal la $param1 ($param2) este prea mare';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Scorul tău la $param1 ($param2) este prea mic';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Evaluat ≥ $param1 în $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Evaluat ≤ $param1 în $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Trebuie să fii in echipa $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Nu sunteți în echipa $param';
  }

  @override
  String get backToGame => 'Înapoi la joc';

  @override
  String get siteDescription => 'Șah online gratuit. Joacă șah acum într-o interfață simplă. Fără înregistrare, fără reclame, fără plugin-uri. Joacă șah cu calculatorul, cu prietenii sau cu alți jucători aleși la întâmplare.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 a intrat în echipa $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 a creat echipa $param2';
  }

  @override
  String get startedStreaming => 'e live';

  @override
  String xStartedStreaming(String param) {
    return '$param a început să facă stream';
  }

  @override
  String get averageElo => 'Medie rating';

  @override
  String get location => 'Locaţie';

  @override
  String get filterGames => 'Filtrați partidele';

  @override
  String get reset => 'Resetare';

  @override
  String get apply => 'Aplicați';

  @override
  String get save => 'Salvează';

  @override
  String get leaderboard => 'Clasament';

  @override
  String get screenshotCurrentPosition => 'Captură de ecran cu poziția curentă';

  @override
  String get gameAsGIF => 'Salvați jocul ca fișier GIF';

  @override
  String get pasteTheFenStringHere => 'Lipește textul FEN aici';

  @override
  String get pasteThePgnStringHere => 'Lipește textul PGN aici';

  @override
  String get orUploadPgnFile => 'Sau încarcă un fișier PGN';

  @override
  String get fromPosition => 'De la poziția';

  @override
  String get continueFromHere => 'Continuați de aici';

  @override
  String get toStudy => 'Studiază';

  @override
  String get importGame => 'Importați partida';

  @override
  String get importGameExplanation => 'Copiați o partidă în format PGN pentru a putea apoi sa o rejucati, sa cereti o analiză a computerului, sa folositi functia de chat și sa obtineti un URL pentru distribuire.';

  @override
  String get importGameCaveat => 'Variațiile vor fi șterse. Pentru a le păstra, importați PGN-ul printr-un studiu.';

  @override
  String get importGameDataPrivacyWarning => 'Acest PGN poate fi accesat public. Pentru a importa un joc în mod privat, folosește un studiu.';

  @override
  String get thisIsAChessCaptcha => 'Aceasta este o verificare anti-spam pe baza unei poziții de șah.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Apăsați pe tablă pentru a muta, dovedind că sunteți om.';

  @override
  String get captcha_fail => 'Vă rugăm să completați acest puzzle.';

  @override
  String get notACheckmate => 'Nu este sah mat';

  @override
  String get whiteCheckmatesInOneMove => 'Albele să dea șah mat într-o mutare';

  @override
  String get blackCheckmatesInOneMove => 'Negrele să dea șah mat într-o mutare';

  @override
  String get retry => 'Mai încercați';

  @override
  String get reconnecting => 'Se reconectează';

  @override
  String get noNetwork => 'Deconectat';

  @override
  String get favoriteOpponents => 'Adversari preferați';

  @override
  String get follow => 'Urmăriți';

  @override
  String get following => 'Se urmărește';

  @override
  String get unfollow => 'Opriți urmărirea';

  @override
  String followX(String param) {
    return 'Urmărește utilizatorul $param';
  }

  @override
  String unfollowX(String param) {
    return 'Nu mai urmări utilizatorul $param';
  }

  @override
  String get block => 'Blocare';

  @override
  String get blocked => 'Blocat';

  @override
  String get unblock => 'Deblocare';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 a început să vă urmărească $param2';
  }

  @override
  String get more => 'Mai mult';

  @override
  String get memberSince => 'Membru din';

  @override
  String lastSeenActive(String param) {
    return 'Ultima autentificare $param';
  }

  @override
  String get player => 'Jucător';

  @override
  String get list => 'Listă';

  @override
  String get graph => 'Grafic';

  @override
  String get required => 'Obligatoriu.';

  @override
  String get openTournaments => 'Turnee deschise';

  @override
  String get duration => 'Durată';

  @override
  String get winner => 'Câștigător';

  @override
  String get standing => 'Clasament';

  @override
  String get createANewTournament => 'Creați un turneu nou';

  @override
  String get tournamentCalendar => 'Calendarul competiției';

  @override
  String get conditionOfEntry => 'Condiții de intrare:';

  @override
  String get advancedSettings => 'Setări avansate';

  @override
  String get safeTournamentName => 'Alege un nume foarte sigur pentru turneu.';

  @override
  String get inappropriateNameWarning => 'Orice nume care este chiar și ușor nepotrivit poate cauza închiderea contului tău.';

  @override
  String get emptyTournamentName => 'Lăsați necompletat pentru a numi turneul după un jucător bun de șah.';

  @override
  String get makePrivateTournament => 'Faceți competiția privată și restricționați accesul cu o parolă';

  @override
  String get join => 'Intră';

  @override
  String get withdraw => 'Retrage-te';

  @override
  String get points => 'Puncte';

  @override
  String get wins => 'Victorii';

  @override
  String get losses => 'Înfrângeri';

  @override
  String get createdBy => 'Creat de';

  @override
  String get tournamentIsStarting => 'Turneul începe';

  @override
  String get tournamentPairingsAreNowClosed => 'Cuplarea partenerilor de turneu s-a încheiat.';

  @override
  String standByX(String param) {
    return 'Fii pe fază, $param, jucătorii sunt cuplați, pregătește-te!';
  }

  @override
  String get pause => 'Pauză';

  @override
  String get resume => 'Continuare';

  @override
  String get youArePlaying => 'Te joci!';

  @override
  String get winRate => 'Procent de câștig';

  @override
  String get berserkRate => 'Procent jocuri cu timp înjumătățit';

  @override
  String get performance => 'Performanță';

  @override
  String get tournamentComplete => 'Turneu încheiat';

  @override
  String get movesPlayed => 'Mutări jucate';

  @override
  String get whiteWins => 'Albul câștigă';

  @override
  String get blackWins => 'Negrul câștigă';

  @override
  String get drawRate => 'Rata de remiză';

  @override
  String get draws => 'Remize';

  @override
  String nextXTournament(String param) {
    return 'Următorul turneu $param:';
  }

  @override
  String get averageOpponent => 'Cota medie a adversarilor';

  @override
  String get boardEditor => 'Editorul de tablă';

  @override
  String get setTheBoard => 'Așează tabla';

  @override
  String get popularOpenings => 'Deschideri populare';

  @override
  String get endgamePositions => 'Poziții de sfârșit';

  @override
  String chess960StartPosition(String param) {
    return 'Poziție de start Chess960: $param';
  }

  @override
  String get startPosition => 'Poziția de start';

  @override
  String get clearBoard => 'Curăță tabla';

  @override
  String get loadPosition => 'Încarcă poziția';

  @override
  String get isPrivate => 'Privat';

  @override
  String reportXToModerators(String param) {
    return 'Raportează-l pe $param moderatorilor';
  }

  @override
  String profileCompletion(String param) {
    return 'Completarea profilului: $param';
  }

  @override
  String xRating(String param) {
    return '$param rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'Dacă nu există, nu completați';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Editează profilul';

  @override
  String get realName => 'Nume real';

  @override
  String get setFlair => 'Arată-ți stilul';

  @override
  String get flair => 'Pictograma personalizată';

  @override
  String get youCanHideFlair => 'Există o setare pentru a ascunde flair-ul utilizatorilor pe întregului site.';

  @override
  String get biography => 'Biografie';

  @override
  String get countryRegion => 'Țara sau regiunea';

  @override
  String get thankYou => 'Mulţumesc!';

  @override
  String get socialMediaLinks => 'Link-urile rețelelor de socializare';

  @override
  String get oneUrlPerLine => 'Un URL pe linie.';

  @override
  String get inlineNotation => 'Notație integrată';

  @override
  String get makeAStudy => 'Pentru păstrare în siguranță și partajare, aveți în vedere crearea unui studiu.';

  @override
  String get clearSavedMoves => 'Șterge mutările';

  @override
  String get previouslyOnLichessTV => 'Anterior pe Lichess TV';

  @override
  String get onlinePlayers => 'Jucători conectați';

  @override
  String get activePlayers => 'Jucători activi';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Atenție, partida este oficială, dar se joacă fără ceas!';

  @override
  String get success => 'Succes';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Du-te automat la partida următoare după mutare';

  @override
  String get autoSwitch => 'Schimbă automat';

  @override
  String get puzzles => 'Probleme de șah';

  @override
  String get onlineBots => 'Boți online';

  @override
  String get name => 'Nume';

  @override
  String get description => 'Descriere';

  @override
  String get descPrivate => 'Descriere privată';

  @override
  String get descPrivateHelp => 'Text pe care îl vor vedea doar membrii echipei. Dacă este setat, înlocuiește descrierea publică pentru membrii echipei.';

  @override
  String get no => 'Nu';

  @override
  String get yes => 'Da';

  @override
  String get website => 'Pagină web';

  @override
  String get mobile => 'Mobil';

  @override
  String get help => 'Ajutor:';

  @override
  String get createANewTopic => 'Creează un nou topic';

  @override
  String get topics => 'Subiecte';

  @override
  String get posts => 'Postări';

  @override
  String get lastPost => 'Ultima postare';

  @override
  String get views => 'Vizualizări';

  @override
  String get replies => 'Răspunsuri';

  @override
  String get replyToThisTopic => 'Răspunde la acest topic';

  @override
  String get reply => 'Răspunde';

  @override
  String get message => 'Mesaj';

  @override
  String get createTheTopic => 'Creează un topic';

  @override
  String get reportAUser => 'Raportează un utilizator';

  @override
  String get user => 'Utilizator';

  @override
  String get reason => 'Motiv';

  @override
  String get whatIsIheMatter => 'Care este problema?';

  @override
  String get cheat => 'Trișează';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Altceva';

  @override
  String get reportCheatBoostHelp => 'Adaugă link-ul de la joc(uri) și arată ce este greșit cu privire la acest comportament al utilizatorului. Nu preciza doar \"trișează\", ci spune-ne cum ai ajuns la această concluzie.';

  @override
  String get reportUsernameHelp => 'Explică de ce acest nume de utilizator este jignitor. Nu spune doar \"e ofensiv/inadecvat\", ci spune-ne cum ai ajuns la această concluzie, mai ales în cazul în care insulta este obscură, nu este în engleză, este jargon sau este o referință istorică/culturală.';

  @override
  String get reportProcessedFasterInEnglish => 'Raportul tău va fi procesat mai rapid dacă este scris în engleză.';

  @override
  String get error_provideOneCheatedGameLink => 'Te rugăm să furnizezi cel puțin un link către un joc în care s-a trișat.';

  @override
  String by(String param) {
    return 'de $param';
  }

  @override
  String importedByX(String param) {
    return 'Importat de $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Acest topic este acum închis.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Note';

  @override
  String get typePrivateNotesHere => 'Scrie în privat aici';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Scrie o notiță privată despre acest utilizator';

  @override
  String get noNoteYet => 'Încă nu există notițe';

  @override
  String get invalidUsernameOrPassword => 'Nume sau parolă invalidă';

  @override
  String get incorrectPassword => 'Parolă greșită';

  @override
  String get invalidAuthenticationCode => 'Cod de autentificare incorect';

  @override
  String get emailMeALink => 'Trimite-mi un email cu link-ul';

  @override
  String get currentPassword => 'Parola curentă';

  @override
  String get newPassword => 'Noua parolă';

  @override
  String get newPasswordAgain => 'Noua parolă (repetă)';

  @override
  String get newPasswordsDontMatch => 'Parolele introduse nu se potrivesc';

  @override
  String get newPasswordStrength => 'Dificultatea parolei';

  @override
  String get clockInitialTime => 'Timpul inițial al ceasului';

  @override
  String get clockIncrement => 'Incrementarea ceasului';

  @override
  String get privacy => 'Confidențialitate';

  @override
  String get privacyPolicy => 'Politica de confidențialitate';

  @override
  String get letOtherPlayersFollowYou => 'Permite altor jucători să te urmărească';

  @override
  String get letOtherPlayersChallengeYou => 'Permite altor jucători să te provoace la joc';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Lasă alți jucători să te invite într-un studiu';

  @override
  String get sound => 'Sunet';

  @override
  String get none => 'Nici una';

  @override
  String get fast => 'Rapidă';

  @override
  String get normal => 'Normală';

  @override
  String get slow => 'Lentă';

  @override
  String get insideTheBoard => 'Pe interiorul tablei';

  @override
  String get outsideTheBoard => 'În afara tablei';

  @override
  String get allSquaresOfTheBoard => 'Toate pătratele de pe tablă';

  @override
  String get onSlowGames => 'În jocurile lente';

  @override
  String get always => 'Întotdeauna';

  @override
  String get never => 'Niciodată';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 concurează în $param2';
  }

  @override
  String get victory => 'Victorie';

  @override
  String get defeat => 'Înfrângere';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 în $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 în $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 în $param3';
  }

  @override
  String get timeline => 'Activitate recentă';

  @override
  String get starting => 'Începe în:';

  @override
  String get allInformationIsPublicAndOptional => 'Aceste date sunt publice și opționale.';

  @override
  String get biographyDescription => 'Descrie-te, ce-ți place în șah, deschiderea favorită, jocurile, jucătorii tăi favoriți…';

  @override
  String get listBlockedPlayers => 'Afișează jucătorii pe care i-ai blocat';

  @override
  String get human => 'Om';

  @override
  String get computer => 'Calculator';

  @override
  String get side => 'Parte';

  @override
  String get clock => 'Ceas';

  @override
  String get opponent => 'Adversar';

  @override
  String get learnMenu => 'Învață';

  @override
  String get studyMenu => 'Studiază';

  @override
  String get practice => 'Antrenează-te';

  @override
  String get community => 'Comunitate';

  @override
  String get tools => 'Unelte';

  @override
  String get increment => 'Suplimentar';

  @override
  String get error_unknown => 'Valoarea nu este validă';

  @override
  String get error_required => 'Acest camp este necesar';

  @override
  String get error_email => 'Această adresă de e-mail nu este validă';

  @override
  String get error_email_acceptable => 'Această adresă de e-mail nu este acceptată. Te rugăm să o verifici și să încerci din nou.';

  @override
  String get error_email_unique => 'Adresa de e-mail nu este validă sau este deja folosită';

  @override
  String get error_email_different => 'Aceasta este deja adresa dvs. de e-mail';

  @override
  String error_minLength(String param) {
    return 'Lungimea minimă este $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Lungimea maximă este $param';
  }

  @override
  String error_min(String param) {
    return 'Trebuie să fie mai mare sau egal cu $param';
  }

  @override
  String error_max(String param) {
    return 'Trebuie să fie mai mic sau egal cu $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Dacă rating-ul este ± $param';
  }

  @override
  String get ifRegistered => 'Dacă este înregistrat';

  @override
  String get onlyExistingConversations => 'Doar conversații existente';

  @override
  String get onlyFriends => 'Doar prieteni';

  @override
  String get menu => 'Meniu';

  @override
  String get castling => 'Rocada';

  @override
  String get whiteCastlingKingside => 'Alb O-O';

  @override
  String get blackCastlingKingside => 'Negru O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Timp petrecut jucând: $param';
  }

  @override
  String get watchGames => 'Vezi partide';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Timp la TV: $param';
  }

  @override
  String get watch => 'Privește';

  @override
  String get videoLibrary => 'Librărie video';

  @override
  String get streamersMenu => 'Streameri';

  @override
  String get mobileApp => 'Aplicația mobilă';

  @override
  String get webmasters => 'Webmasteri';

  @override
  String get about => 'Despre';

  @override
  String aboutX(String param) {
    return 'Despre $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 este un server de șah gratuit ($param2), fără reclame și open-source.';
  }

  @override
  String get really => 'pe bune';

  @override
  String get contribute => 'Contribuie';

  @override
  String get termsOfService => 'Termeni și condiții';

  @override
  String get sourceCode => 'Cod sursă';

  @override
  String get simultaneousExhibitions => 'Simultane de șah';

  @override
  String get host => 'Gazdă';

  @override
  String hostColorX(String param) {
    return 'Culoarea gazdei: $param';
  }

  @override
  String get yourPendingSimuls => 'Simultanele tale în așteptare';

  @override
  String get createdSimuls => 'Simultan nou creat';

  @override
  String get hostANewSimul => 'Găzduiește un nou simultan';

  @override
  String get signUpToHostOrJoinASimul => 'Înregistrează-te pentru a găzdui sau pentru participarea la un simultan';

  @override
  String get noSimulFound => 'Simultanul nu a fost găsit';

  @override
  String get noSimulExplanation => 'Acest simultan nu există.';

  @override
  String get returnToSimulHomepage => 'Înapoi la pagina simultanului';

  @override
  String get aboutSimul => 'Simultanele înseamnă un singur jucător în fața mai multor jucători în același timp.';

  @override
  String get aboutSimulImage => 'Din 50 de oponenți, Fischer a câștigat 47 de partide, a făcut remiză în 2 partide și a pierdut 1 partida.';

  @override
  String get aboutSimulRealLife => 'Conceptul provine din evenimentele din lumea reală. În viața reală, jucătorul care acordă un simultan se deplasează de la o tablă la alta pentru a juca la fiecare câte o singură mutare.';

  @override
  String get aboutSimulRules => 'Când simultanul începe, fiecare jucător începe jocul cu gazda și va juca cu piesele albe. Simultanul se termină când toate jocurile sunt complete.';

  @override
  String get aboutSimulSettings => 'Simultanele sunt tot timpul amicale. Revanșele, mutările înapoi și opțiunea \"mai mult timp\" sunt dezactivate.';

  @override
  String get create => 'Creează';

  @override
  String get whenCreateSimul => 'Când creezi un simultan, vei juca cu mai mulți jucători în același timp.';

  @override
  String get simulVariantsHint => 'Dacă alegi mai multe variante, fiecare jucător va avea de ales ce variantă va juca.';

  @override
  String get simulClockHint => 'Configurare de ceas Fischer. Cu cât joci împotriva mai multor jucători, cu atât vei avea nevoie de mai mult timp.';

  @override
  String get simulAddExtraTime => 'Poți adăuga timp în plus pe ceasul tău pentru a te ajuta să faci față simultanului.';

  @override
  String get simulHostExtraTime => 'Timp suplimentar pe ceasul gazdei';

  @override
  String get simulAddExtraTimePerPlayer => 'Adaugă timp inițial la ceasul tău pentru fiecare jucător care se alătură jocului simultan.';

  @override
  String get simulHostExtraTimePerPlayer => 'Timp suplimentar pentru ceasul gazdei, pentru fiecare jucător';

  @override
  String get lichessTournaments => 'Turnee Lichess';

  @override
  String get tournamentFAQ => 'Întrebări și răspunsuri pentru turneu';

  @override
  String get timeBeforeTournamentStarts => 'Timp până la începerea turneului';

  @override
  String get averageCentipawnLoss => 'Medie pion-cenți pierduți';

  @override
  String get accuracy => 'Acuratețe';

  @override
  String get keyboardShortcuts => 'Scurtături taste';

  @override
  String get keyMoveBackwardOrForward => 'mută înapoi/înainte';

  @override
  String get keyGoToStartOrEnd => 'început/sfârșit';

  @override
  String get keyCycleSelectedVariation => 'Următoarea variație';

  @override
  String get keyShowOrHideComments => 'arată/ascunde comentarii';

  @override
  String get keyEnterOrExitVariation => 'acceptă/respinge variație';

  @override
  String get keyRequestComputerAnalysis => 'Solicită analiza calculatorului, Învață din greșelile tale';

  @override
  String get keyNextLearnFromYourMistakes => 'Următorul (Învață din greșelile tale)';

  @override
  String get keyNextBlunder => 'Următoarea greșeală gravă';

  @override
  String get keyNextMistake => 'Următoarea greșeală';

  @override
  String get keyNextInaccuracy => 'Următoarea neacuratețe';

  @override
  String get keyPreviousBranch => 'Ramura precedentă';

  @override
  String get keyNextBranch => 'Ramura următoare';

  @override
  String get toggleVariationArrows => 'Comută săgețile de variație';

  @override
  String get cyclePreviousOrNextVariation => 'Ciclu de variație precedentă/următoare';

  @override
  String get toggleGlyphAnnotations => 'Comută adnotările gilfelor';

  @override
  String get togglePositionAnnotations => 'Activează/Dezactivează adnotările pozițiilor';

  @override
  String get variationArrowsInfo => 'Săgețile de variație vă permit să navigați fără a utiliza lista de mutare.';

  @override
  String get playSelectedMove => 'joacă mutarea selectată';

  @override
  String get newTournament => 'Turneu nou';

  @override
  String get tournamentHomeTitle => 'Turneu de șah cu control de timp și variante';

  @override
  String get tournamentHomeDescription => 'Joacă turnee rapide de șah! Intră într-un turneu oficial planificat sau crează-ți-l tu. Bullet (Glonț),  Blitz (Fulger), Classical (Clasic), Chess960, Regele în centru, Trei șahuri și alte opțiuni sunt disponibile pentru o distracție continuă.';

  @override
  String get tournamentNotFound => 'Turneul nu a fost găsit';

  @override
  String get tournamentDoesNotExist => 'Acest turneu nu există.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Posibil să fi fost anulat, dacă toți jucătorii au plecat înainte de începerea turneului.';

  @override
  String get returnToTournamentsHomepage => 'Înapoi la pagina turneului';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Distribuția săptămânală a palmaresului $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Scorul $param1 este $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Ești mai bun ca $param1 dintre jucătorii de $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return 'Jucătorul $param1 este mai bun decât $param2 dintre jucătorii de $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Mai bun decât $param1 dintre jucătorii de $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Nu aveți un scor $param definit.';
  }

  @override
  String get yourRating => 'Scorul tău';

  @override
  String get cumulative => 'Cumulativ';

  @override
  String get glicko2Rating => 'Evaluare Glicko-2';

  @override
  String get checkYourEmail => 'Verifică-ți adresa de email';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'V-am trimis un email. Dă click pe link-ul din email pentru a-ți activa contul.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Dacă nu vezi email-ul trimis, verifică și în alte locuri, cum ar fi folderul de spam, gunoi, mesaje sociale sau alte foldere.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Am trimis un email la $param. Dă click pe link-ul trimis în acel email pentru a-ți reseta parola.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Înregistrându-te, ești de acord cu $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Citește despre $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Întârziere de rețea între tine și Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Timpul necesar procesării unei mutări pe serverul Lichess';

  @override
  String get downloadAnnotated => 'Descarcă cu note';

  @override
  String get downloadRaw => 'Descarcă brut';

  @override
  String get downloadImported => 'Descarcă importat';

  @override
  String get crosstable => 'Tabel de scoruri';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'De asemenea, poți acționa rotița mouse-ului pentru a face mutări pe tablă.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Derulați variantele calculatorului pentru a le previzualiza.';

  @override
  String get analysisShapesHowTo => 'Apasă shift+click sau click-dreapta pentru a desena cercuri și săgeți pe tablă.';

  @override
  String get letOtherPlayersMessageYou => 'Permite altor jucători să îți trimită mesaje';

  @override
  String get receiveForumNotifications => 'Primește notificări atunci când ești menționat în forum';

  @override
  String get shareYourInsightsData => 'Partajează-ți statisticile legate de jocuri';

  @override
  String get withNobody => 'Cu nimeni';

  @override
  String get withFriends => 'Cu prietenii';

  @override
  String get withEverybody => 'Cu toată lumea';

  @override
  String get kidMode => 'Mod pentru copii';

  @override
  String get kidModeIsEnabled => 'Modul copil este activat.';

  @override
  String get kidModeExplanation => 'În modul „copil”, toate modalitățile de comunicare sunt dezactivate. Activează asta pentru copilul tău sau pentru școlari, pentru a-i proteja de alți utilizatori ai internetului.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'În modul „copil”, sigla paginii va avea iconița $param, în felul acesta vei ști când copiii tăi sunt în siguranță.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Contul tău este gestionat. Întreabă-ți profesorul de șah despre scoaterea modului copil.';

  @override
  String get enableKidMode => 'Activează modul „copil”';

  @override
  String get disableKidMode => 'Dezactivează modul „copil”';

  @override
  String get security => 'Securitate';

  @override
  String get sessions => 'Sesiuni';

  @override
  String get revokeAllSessions => 'revocați toate sesiunile';

  @override
  String get playChessEverywhere => 'Joacă șah oriunde';

  @override
  String get asFreeAsLichess => 'Gratis ca Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Creat din dragoste pentru șah, nu pentru bani';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Toată lumea are access la toate opțiunile, gratuit';

  @override
  String get zeroAdvertisement => 'Zero reclame';

  @override
  String get fullFeatured => 'Toate opțiunile';

  @override
  String get phoneAndTablet => 'Telefon și tabletă';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz și clasic';

  @override
  String get correspondenceChess => 'Șah prin corespondență';

  @override
  String get onlineAndOfflinePlay => 'Joc online și offline';

  @override
  String get viewTheSolution => 'Vezi soluția';

  @override
  String get followAndChallengeFriends => 'Urmărește și provoacă-ți prietenii';

  @override
  String get gameAnalysis => 'Analiza jocului';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 găzduiește $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 se alătură $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 îi place $param2';
  }

  @override
  String get quickPairing => 'Potrivire rapidă';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonim';

  @override
  String yourScore(String param) {
    return 'Scorul tău: $param';
  }

  @override
  String get language => 'Limbă';

  @override
  String get background => 'Fundal';

  @override
  String get light => 'Luminos';

  @override
  String get dark => 'Culoare închisă';

  @override
  String get transparent => 'Transparent';

  @override
  String get deviceTheme => 'Tema dispozitivului';

  @override
  String get backgroundImageUrl => 'URL-ul imaginii de fundal:';

  @override
  String get board => 'Tablă';

  @override
  String get size => 'Dimensiune';

  @override
  String get opacity => 'Opacitate';

  @override
  String get brightness => 'Luminozitate';

  @override
  String get hue => 'Nuanță';

  @override
  String get boardReset => 'Resetează culorile la valorile implicite';

  @override
  String get pieceSet => 'Set de piese';

  @override
  String get embedInYourWebsite => 'Incorporează în site-ul tău';

  @override
  String get usernameAlreadyUsed => 'Nume de utilzator este deja folosit, te rugam să încerci altul.';

  @override
  String get usernamePrefixInvalid => 'Numele de utilizator trebuie să înceapă cu o literă.';

  @override
  String get usernameSuffixInvalid => 'Numele de utilizator trebuie să se termine cu o literă sau o cifră.';

  @override
  String get usernameCharsInvalid => 'Numele de utilizator poate conține doar litere, cifre, linii de subliniere și cratime.';

  @override
  String get usernameUnacceptable => 'Numele de utilizator nu e acceptabil.';

  @override
  String get playChessInStyle => 'Joacă șah cu stil';

  @override
  String get chessBasics => 'Bazele șahului';

  @override
  String get coaches => 'Antrenori';

  @override
  String get invalidPgn => 'PGN invalid';

  @override
  String get invalidFen => 'FEN invalid';

  @override
  String get custom => 'Personalizat';

  @override
  String get notifications => 'Notificări';

  @override
  String notificationsX(String param1) {
    return 'Notificări: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Joacă cu computer-ul';

  @override
  String anotherWasX(String param) {
    return 'Altă mutare bună este: $param';
  }

  @override
  String bestWasX(String param) {
    return 'Cea mai bună mutare este: $param';
  }

  @override
  String get youBrowsedAway => 'Ați părăsit jocul cu computer-ul';

  @override
  String get resumePractice => 'Reia antrenamentul';

  @override
  String get drawByFiftyMoves => 'Partida s-a terminat remiză din cauza regulii de 50 de mutări.';

  @override
  String get theGameIsADraw => 'Remiză.';

  @override
  String get computerThinking => 'Calculatorul se gândește ...';

  @override
  String get seeBestMove => 'Vezi cea mai bună mutare';

  @override
  String get hideBestMove => 'Ascunde cea mai bună mutare';

  @override
  String get getAHint => 'Obține un indiciu';

  @override
  String get evaluatingYourMove => 'Evaluându-ți mutarea ...';

  @override
  String get whiteWinsGame => 'Albele câștigă';

  @override
  String get blackWinsGame => 'Negrele câștigă';

  @override
  String get learnFromYourMistakes => 'Învață din greșelile tale';

  @override
  String get learnFromThisMistake => 'Învață din greșeli';

  @override
  String get skipThisMove => 'Sari peste această mutare';

  @override
  String get next => 'Următorea';

  @override
  String xWasPlayed(String param) {
    return '$param a fost mutat';
  }

  @override
  String get findBetterMoveForWhite => 'Găsește o mutare mai bună pentru albe';

  @override
  String get findBetterMoveForBlack => 'Găsește o mutare mai bună pentru negre';

  @override
  String get resumeLearning => 'Reia învățatul';

  @override
  String get youCanDoBetter => 'Poți mai bine';

  @override
  String get tryAnotherMoveForWhite => 'Încearcă altă mutare pentru albe';

  @override
  String get tryAnotherMoveForBlack => 'Încearcă altă mutare pentru negre';

  @override
  String get solution => 'Soluție';

  @override
  String get waitingForAnalysis => 'Așteptând pentru analize';

  @override
  String get noMistakesFoundForWhite => 'Nici o greșeală găsită din partea albelor';

  @override
  String get noMistakesFoundForBlack => 'Nici o greșeală găsită din partea negrelor';

  @override
  String get doneReviewingWhiteMistakes => 'Gata cu analiza greșelilor din partea albelor';

  @override
  String get doneReviewingBlackMistakes => 'Gata cu analiza greșelilor din partea negrelor';

  @override
  String get doItAgain => 'Fă-o din nou';

  @override
  String get reviewWhiteMistakes => 'Analizează greșelile albelor';

  @override
  String get reviewBlackMistakes => 'Analizează greșelile negrelor';

  @override
  String get advantage => 'Avantaj';

  @override
  String get opening => 'Deschidere';

  @override
  String get middlegame => 'Mijlocul jocului';

  @override
  String get endgame => 'Sfârșitul jocului';

  @override
  String get conditionalPremoves => 'Mutări anticipate condiționale';

  @override
  String get addCurrentVariation => 'Adaugă variația curentă';

  @override
  String get playVariationToCreateConditionalPremoves => 'Joacă o variație pentru a crea mutări anticipate condiționale';

  @override
  String get noConditionalPremoves => 'Fără mutări anticipate condiționale';

  @override
  String playX(String param) {
    return 'Mută $param';
  }

  @override
  String get showUnreadLichessMessage => 'Ați primit un mesaj privat de la Lichess.';

  @override
  String get clickHereToReadIt => 'Click aici pentru a-l citi';

  @override
  String get sorry => 'Scuze :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Am fost nevoiți să suspendăm activitatea pentru puțin timp.';

  @override
  String get why => 'De ce?';

  @override
  String get pleasantChessExperience => 'Dorim să oferim o experiență plăcută tuturor jucătorilor de șah.';

  @override
  String get goodPractice => 'Ca acest lucru să se întâmple, trebuie să ne asigurăm că toți jucătorii respectă bunele practici.';

  @override
  String get potentialProblem => 'Când o potențială problemă este detectată, afișăm acest mesaj.';

  @override
  String get howToAvoidThis => 'Cum puteți preveni suspendarea?';

  @override
  String get playEveryGame => 'Jucați fiecare meci pe care-l începeți.';

  @override
  String get tryToWin => 'Încercați să câștigați (sau măcar să faceți remiză) fiecare meci pe care-l jucați.';

  @override
  String get resignLostGames => 'Abandonați partidele pierdute (nu lăsați timpul să expire).';

  @override
  String get temporaryInconvenience => 'Ne pare rău pentru neplăcerile temporare';

  @override
  String get wishYouGreatGames => 'și vă dorim partide deosebite pe Lichess.org.';

  @override
  String get thankYouForReading => 'Îți mulțumim pentru atenție!';

  @override
  String get lifetimeScore => 'Scorul total';

  @override
  String get currentMatchScore => 'Scorul curent';

  @override
  String get agreementAssistance => 'Sunt de acord să nu primesc niciodată asistență în timpul partidelor mele (de la un calculator, o carte, o bază de date sau de la o altă persoană).';

  @override
  String get agreementNice => 'Sunt de acord să fiu mereu respectuos cu alți jucători.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Sunt de acord să nu creez conturi multiple (cu excepția motivelor declarate în $param).';
  }

  @override
  String get agreementPolicy => 'Sunt de acord cu respectarea tuturor politicilor Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Caută sau începe o nouă conversație';

  @override
  String get edit => 'Modifică';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Clasic';

  @override
  String get ultraBulletDesc => 'Partide incredibil de rapide: mai puțin de 30 de secunde';

  @override
  String get bulletDesc => 'Partide foarte rapide: mai puțin de 3 minute';

  @override
  String get blitzDesc => 'Partide rapide: între 3 și 8 minute';

  @override
  String get rapidDesc => 'Partide destul de rapide: între 8 și 25 de minute';

  @override
  String get classicalDesc => 'Partide clasice: 25 de minute sau mai mult';

  @override
  String get correspondenceDesc => 'Partide prin corespondență: o mutare la una sau mai multe zile';

  @override
  String get puzzleDesc => 'Antrenor de tactici de șah';

  @override
  String get important => 'Important';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Este posibil ca întrebarea ta să aibă deja un răspuns $param1';
  }

  @override
  String get inTheFAQ => 'la întrebări și răspunsuri.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Pentru a raporta un utilizator pentru trișare sau comportament inadecvat, $param1';
  }

  @override
  String get useTheReportForm => 'folosiți formularul de raportare';

  @override
  String toRequestSupport(String param1) {
    return 'Pentru a solicita asistență, $param1';
  }

  @override
  String get tryTheContactPage => 'încercați pagina de contact';

  @override
  String makeSureToRead(String param1) {
    return 'Asigură-te că citești $param1';
  }

  @override
  String get theForumEtiquette => 'normele de comportare în forum';

  @override
  String get thisTopicIsArchived => 'Acest subiect a fost arhivat și nu mai acceptă răspunsuri.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Alăturați-vă echipei $param1, pentru a posta pe acest forum';
  }

  @override
  String teamNamedX(String param1) {
    return 'echipa $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Încă nu puteți posta în forumuri. Jucați câteva partide!';

  @override
  String get subscribe => 'Abonați-vă';

  @override
  String get unsubscribe => 'Dezabonați-vă';

  @override
  String mentionedYouInX(String param1) {
    return 'te-a menționat în \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 te-a menționat în \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'te-a invitat la \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 te-a invitat la \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Acum faci parte din echipă.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'V-ați alăturat la \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Cineva pe care l-ai raportat a fost banat';

  @override
  String get congratsYouWon => 'Felicitări, ați câștigat!';

  @override
  String gameVsX(String param1) {
    return 'Joc vs $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Ai pierdut în fața cuiva care a încălcat Termenii și Condițiile Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Rambursare: $param1 puncte de evaluare $param2.';
  }

  @override
  String get timeAlmostUp => 'Timpul se apropie de sfârșit!';

  @override
  String get clickToRevealEmailAddress => '[Click pentru a dezvălui adresa de e-mail]';

  @override
  String get download => 'Descărcare';

  @override
  String get coachManager => 'Setări pentru antrenor';

  @override
  String get streamerManager => 'Setări pentru streamer';

  @override
  String get cancelTournament => 'Anulează turneul';

  @override
  String get tournDescription => 'Descrierea turneului';

  @override
  String get tournDescriptionHelp => 'Vrei să spui participanților ceva special? Încearcă să fii succint. Poți folosi legături Markdown: [name](https://url)';

  @override
  String get ratedFormHelp => 'Partidele sunt evaluate\nși vor avea ca rezultat modificarea ratingului';

  @override
  String get onlyMembersOfTeam => 'Numai membrii echipei';

  @override
  String get noRestriction => 'Fără restricții';

  @override
  String get minimumRatedGames => 'Numar minim de partide evaluate jucate';

  @override
  String get minimumRating => 'Rating minim';

  @override
  String get maximumWeeklyRating => 'Rating săptămânal maxim';

  @override
  String positionInputHelp(String param) {
    return 'Lipiți un FEN valid pentru a începe fiecare joc dintr-o poziție dată.\nFuncționează doar pentru jocuri standard, nu si pentru variante.\nPuteți utiliza $param pentru a genera o poziție FEN, apoi lipiți-o aici.\nLăsați gol pentru a începe jocurile din poziția inițială normală.';
  }

  @override
  String get cancelSimul => 'Anulează simul';

  @override
  String get simulHostcolor => 'Culoare gazdă pentru fiecare joc';

  @override
  String get estimatedStart => 'Timp de începere estimat';

  @override
  String simulFeatured(String param) {
    return 'Recomandat de $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Arătați-vă simul tuturor de pe $param. Dezactivați pentru simul private.';
  }

  @override
  String get simulDescription => 'Descriere Simul';

  @override
  String get simulDescriptionHelp => 'Ce vrei să spui participanţilor?';

  @override
  String markdownAvailable(String param) {
    return '$param este disponibil pentru sintaxă mai avansată.';
  }

  @override
  String get embedsAvailable => 'Lipește un URL al jocului sau un URL de capitol de studiu pentru a-l încorpora.';

  @override
  String get inYourLocalTimezone => 'În fusul orar local';

  @override
  String get tournChat => 'Conversatie';

  @override
  String get noChat => 'Fără conversație';

  @override
  String get onlyTeamLeaders => 'Doar lideri de echipă';

  @override
  String get onlyTeamMembers => 'Doar membrii echipei';

  @override
  String get navigateMoveTree => 'Navigați pe arborele de mutări';

  @override
  String get mouseTricks => 'Trucuri cu mouse-ul';

  @override
  String get toggleLocalAnalysis => 'Activează/dezactivează analiza computerizată locală';

  @override
  String get toggleAllAnalysis => 'Activează/dezactivează analiza computerizată';

  @override
  String get playComputerMove => 'Joacă cea mai bună mutare a calculatorului';

  @override
  String get analysisOptions => 'Opțiuni de analiză';

  @override
  String get focusChat => 'Focalizează conversația';

  @override
  String get showHelpDialog => 'Arată acest dialog de ajutor';

  @override
  String get reopenYourAccount => 'Redeschide contul tău';

  @override
  String get closedAccountChangedMind => 'Dacă ți-ai închis contul, dar de atunci te-ai răzgândit, primești o șansă să-ți recuperezi contul.';

  @override
  String get onlyWorksOnce => 'Acest lucru va funcţiona o singură dată.';

  @override
  String get cantDoThisTwice => 'Dacă închideți contul de a doua oară, nu va mai exista nicio modalitate de recuperare a acestuia.';

  @override
  String get emailAssociatedToaccount => 'Adresa de e-mail asociată contului';

  @override
  String get sentEmailWithLink => 'Ți-am trimis un e-mail cu un link.';

  @override
  String get tournamentEntryCode => 'Cod de intrare în turneu';

  @override
  String get hangOn => 'Așteaptă!';

  @override
  String gameInProgress(String param) {
    return 'Ai un joc în desfășurare cu $param.';
  }

  @override
  String get abortTheGame => 'Abandonează jocul';

  @override
  String get resignTheGame => 'Cedează jocul';

  @override
  String get youCantStartNewGame => 'Nu poți începe un joc nou până când acesta nu se termină.';

  @override
  String get since => 'De la';

  @override
  String get until => 'Până la';

  @override
  String get lichessDbExplanation => 'Partide evaluate obținute de la toți jucătorii Lichess';

  @override
  String get switchSides => 'Întoarce tabla';

  @override
  String get closingAccountWithdrawAppeal => 'Închiderea contului dvs. vă va retrage apelul';

  @override
  String get ourEventTips => 'Sfaturile noastre pentru organizarea evenimentelor';

  @override
  String get instructions => 'Instrucțiuni';

  @override
  String get showMeEverything => 'Afișează-mi tot';

  @override
  String get lichessPatronInfo => 'Lichess este o asociație non-profit și un software gratuit și open-source.\nToate costurile de operare și de dezvoltare sunt finanțate doar din donațiile utilizatorilor.';

  @override
  String get nothingToSeeHere => 'Nimic de văzut aici momentan.';

  @override
  String get stats => 'Statistici';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adversarul tău a părăsit jocul. Poți revendica victoria peste $count secunde.',
      few: 'Adversarul tău a părăsit jocul. Poți revendica victoria peste $count secunde.',
      one: 'Adversarul tău a părăsit jocul. Poți revendica victoria peste $count secundă.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat în $count mutări',
      few: 'Mat în $count mutări',
      one: 'Mat la prima mutare',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de gafe',
      few: '$count gafe',
      one: '$count gafă',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de greșeli',
      few: '$count greșeli',
      one: '$count greșeală',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de inexactități',
      few: '$count inexactități',
      one: '$count inexactitate',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de jucători',
      few: '$count jucători',
      one: '$count jucător',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de partide',
      few: '$count partide',
      one: '$count partidă',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rating $count din $param2 de meciuri',
      few: 'Rating $count din $param2 meciuri',
      one: 'Rating $count din $param2 meci',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count marcate',
      few: '$count marcate',
      one: '$count marcat',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de zile',
      few: '$count zile',
      one: '$count zi',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de ore',
      few: '$count ore',
      one: '$count oră',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de minute',
      few: '$count minute',
      one: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Locul în clasament este actualizat la fiecare $count minute',
      few: 'Locul în clasament este actualizat la fiecare $count minute',
      one: 'Locul în clasament este actualizat în fiecare minut',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poziții',
      few: '$count poziții',
      one: 'O poziție',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partide cu tine',
      few: '$count partide cu tine',
      one: '$count partidă cu tine',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count evaluate',
      few: '$count evaluate',
      one: '$count evaluat',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de victorii',
      few: '$count victorii',
      one: '$count victorie',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de înfrângeri',
      few: '$count înfrângeri',
      one: '$count înfrângere',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de remize',
      few: '$count remize',
      one: '$count remiză',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count le joacă',
      few: '$count le joacă',
      one: '$count îl joacă',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Acordă $count secunde',
      few: 'Acordă $count secunde',
      one: 'Acordă $count secundă',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puncte de turneu',
      few: '$count puncte de turneu',
      one: '$count punct de turneu',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de studii',
      few: '$count studii',
      one: '$count studiu',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simul',
      few: '$count simul',
      one: '$count simul',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partide evaluate',
      few: '$count meciuri evaluate',
      one: '$count meci evaluat',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 partide jucate',
      few: '$count $param2 meciuri jucate',
      one: '$count $param2 meci jucat',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trebuie să joci încă $count partide $param2 evaluate',
      few: 'Trebuie să joci încă $count meciuri in variantă $param2',
      one: 'Trebuie să joci încă $count meci in variantă $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trebuie să joci încă $count meciuri evaluate',
      few: 'Trebuie să joci încă $count meciuri evaluate',
      one: 'Trebuie să joci încă $count meci evaluat',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partide importate',
      few: '$count partide importate',
      one: '$count partidă importată',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prieteni online',
      few: '$count prieteni online',
      one: '$count prieten online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count urmăritori',
      few: '$count urmăritori',
      one: '$count urmăritor',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count urmăriți',
      few: '$count urmăriți',
      one: '$count urmărit',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mai puțin de $count minute',
      few: 'Mai puțin de $count minute',
      one: 'Mai puțin de $count minut',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de partide în desfășurare',
      few: '$count partide în desfășurare',
      one: '$count partidă în desfășurare',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maxim: $count caractere.',
      few: 'Maxim: $count caractere.',
      one: 'Maxim: $count caracter.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jucători blocați',
      few: '$count jucători blocați',
      one: '$count jucător blocat',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de postări pe forum',
      few: '$count postări pe forum',
      one: '$count postare pe forum',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jucători $param2 în această săptămână.',
      few: '$count jucători $param2 în această săptămână.',
      one: '$count jucător $param2 în această săptămână.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Disponibil în $count limbi!',
      few: 'Disponibil în $count limbi!',
      one: 'Disponibil într-o limbă!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count secunde rămase pentru a începe jocul',
      few: '$count secunde rămase pentru a începe jocul',
      one: '$count secundă rămasă pentru a începe jocul',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count secunde',
      few: '$count secunde',
      one: '$count secundă',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'și salvează $count variațiile cu mutare anticipată',
      few: 'și salvează $count variațiile cu mutare anticipată',
      one: 'și salvează $count variație cu mutare anticipată',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Miscă-te ca să începi';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Joci cu piesele albe în toate puzzle-urile';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Joci cu piesele negre în toate puzzle-urile';

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
  String get stormSkipExplanation => 'Sări peste această mutare pentru a păstra combo-ul! Funcționează o singură dată pe cursă.';

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
  String get studyPrivate => 'Privat';

  @override
  String get studyMyStudies => 'Studiile mele';

  @override
  String get studyStudiesIContributeTo => 'Studiile la care contribui';

  @override
  String get studyMyPublicStudies => 'Studiile mele publice';

  @override
  String get studyMyPrivateStudies => 'Studiile mele private';

  @override
  String get studyMyFavoriteStudies => 'Studiile mele preferate';

  @override
  String get studyWhatAreStudies => 'Ce sunt studiile?';

  @override
  String get studyAllStudies => 'Toate studiile';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studii create de $param';
  }

  @override
  String get studyNoneYet => 'Niciunul încă.';

  @override
  String get studyHot => 'Populare';

  @override
  String get studyDateAddedNewest => 'Data adăugată (cele mai noi)';

  @override
  String get studyDateAddedOldest => 'Data adăugată (cele mai vechi)';

  @override
  String get studyRecentlyUpdated => 'Încărcate recent';

  @override
  String get studyMostPopular => 'Cele mai populare';

  @override
  String get studyAlphabetical => 'Alfabetic';

  @override
  String get studyAddNewChapter => 'Adaugă un nou capitol';

  @override
  String get studyAddMembers => 'Adaugă membri';

  @override
  String get studyInviteToTheStudy => 'Invită la studiu';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow => 'Vă rugăm să invitați doar persoanele pe care le cunoașteți și care vor în mod activ să se alăture studiului.';

  @override
  String get studySearchByUsername => 'Caută după numele de utilizator';

  @override
  String get studySpectator => 'Spectator';

  @override
  String get studyContributor => 'Contribuitor';

  @override
  String get studyKick => 'Înlătură';

  @override
  String get studyLeaveTheStudy => 'Părăsește studiul';

  @override
  String get studyYouAreNowAContributor => 'Acum ești un contribuitor';

  @override
  String get studyYouAreNowASpectator => 'Acum ești un spectator';

  @override
  String get studyPgnTags => 'Etichete PGN';

  @override
  String get studyLike => 'Apreciază';

  @override
  String get studyUnlike => 'Nu îmi mai place';

  @override
  String get studyNewTag => 'Etichetă nouă';

  @override
  String get studyCommentThisPosition => 'Comentează această poziție';

  @override
  String get studyCommentThisMove => 'Comentează această mutare';

  @override
  String get studyAnnotateWithGlyphs => 'Adnotează cu simboluri';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed => 'Capitolul este prea mic pentru a fi analizat.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis => 'Numai contribuitorii studiului pot solicita o analiză a computerului.';

  @override
  String get studyGetAFullComputerAnalysis => 'Obțineți o întreagă analiză server-side a computerului a variației principale.';

  @override
  String get studyMakeSureTheChapterIsComplete => 'Asigurați-vă că acest capitol este complet. Puteți solicita o analiză doar o singură dată.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition => 'Toți membri sincronizați rămân la aceeași poziție';

  @override
  String get studyShareChanges => 'Împărtășește modificările cu spectatorii și salvează-le pe server';

  @override
  String get studyPlaying => 'În desfășurare';

  @override
  String get studyShowEvalBar => 'Bară de evaluare';

  @override
  String get studyFirst => 'Prima';

  @override
  String get studyPrevious => 'Precedentă';

  @override
  String get studyNext => 'Următoarea';

  @override
  String get studyLast => 'Ultima';

  @override
  String get studyShareAndExport => 'Împărtășește & exportă';

  @override
  String get studyCloneStudy => 'Clonează';

  @override
  String get studyStudyPgn => 'PGN-ul studiului';

  @override
  String get studyDownloadAllGames => 'Descarcă toate partidele';

  @override
  String get studyChapterPgn => 'PGN-ul capitolului';

  @override
  String get studyCopyChapterPgn => 'Copiază PGN';

  @override
  String get studyDownloadGame => 'Descarcă partida';

  @override
  String get studyStudyUrl => 'URL-ul studiului';

  @override
  String get studyCurrentChapterUrl => 'URL-ul capitolului curent';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed => 'Poți lipi acest cod în forum pentru a îngloba';

  @override
  String get studyStartAtInitialPosition => 'Începeți de la poziția inițială';

  @override
  String studyStartAtX(String param) {
    return 'Începeți la $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Înglobează pe site-ul sau blog-ul tău';

  @override
  String get studyReadMoreAboutEmbedding => 'Citește mai multe despre înglobare';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded => 'Numai studii publice pot fi înglobate!';

  @override
  String get studyOpen => 'Deschideți';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1, oferit pentru dvs. de $param2';
  }

  @override
  String get studyStudyNotFound => 'Studiul nu a fost găsit';

  @override
  String get studyEditChapter => 'Editează capitolul';

  @override
  String get studyNewChapter => 'Capitol nou';

  @override
  String studyImportFromChapterX(String param) {
    return 'Importă din $param';
  }

  @override
  String get studyOrientation => 'Orientare';

  @override
  String get studyAnalysisMode => 'Tip de analiză';

  @override
  String get studyPinnedChapterComment => 'Comentariu fixat';

  @override
  String get studySaveChapter => 'Salvează capitolul';

  @override
  String get studyClearAnnotations => 'Curățați adnotările';

  @override
  String get studyClearVariations => 'Curățați variațiile';

  @override
  String get studyDeleteChapter => 'Ștergeți capitolul';

  @override
  String get studyDeleteThisChapter => 'Ștergeți acest capitol? Nu există cale de întoarcere!';

  @override
  String get studyClearAllCommentsInThisChapter => 'Ștergeți toate comentariile, simbolurile și figurile desenate din acest capitol?';

  @override
  String get studyRightUnderTheBoard => 'Fix sub tablă';

  @override
  String get studyNoPinnedComment => 'Niciunul';

  @override
  String get studyNormalAnalysis => 'Analiză normală';

  @override
  String get studyHideNextMoves => 'Ascunde următoarele mutări';

  @override
  String get studyInteractiveLesson => 'Lecție interactivă';

  @override
  String studyChapterX(String param) {
    return 'Capitolul $param';
  }

  @override
  String get studyEmpty => 'Gol';

  @override
  String get studyStartFromInitialPosition => 'Începeți de la poziția inițială';

  @override
  String get studyEditor => 'Editor';

  @override
  String get studyStartFromCustomPosition => 'Începeți de la o poziție personalizată';

  @override
  String get studyLoadAGameByUrl => 'Încărcați meciul din URL';

  @override
  String get studyLoadAPositionFromFen => 'Încărcați o poziție din FEN';

  @override
  String get studyLoadAGameFromPgn => 'Încărcați un joc din PGN';

  @override
  String get studyAutomatic => 'Automată';

  @override
  String get studyUrlOfTheGame => 'URL-ul jocului';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Încărcați un joc de pe $param1 sau $param2';
  }

  @override
  String get studyCreateChapter => 'Creați capitolul';

  @override
  String get studyCreateStudy => 'Creați studiul';

  @override
  String get studyEditStudy => 'Editați studiul';

  @override
  String get studyVisibility => 'Vizibilitate';

  @override
  String get studyPublic => 'Public';

  @override
  String get studyUnlisted => 'Nelistat';

  @override
  String get studyInviteOnly => 'Doar invitați';

  @override
  String get studyAllowCloning => 'Permiteți clonarea';

  @override
  String get studyNobody => 'Nimeni';

  @override
  String get studyOnlyMe => 'Doar eu';

  @override
  String get studyContributors => 'Contribuitori';

  @override
  String get studyMembers => 'Membri';

  @override
  String get studyEveryone => 'Toată lumea';

  @override
  String get studyEnableSync => 'Activați sincronizarea';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Da: menține-i pe toți la aceeași poziție';

  @override
  String get studyNoLetPeopleBrowseFreely => 'Nu: permite navigarea liberă';

  @override
  String get studyPinnedStudyComment => 'Comentariu fixat';

  @override
  String get studyStart => 'Începe';

  @override
  String get studySave => 'Salvează';

  @override
  String get studyClearChat => 'Șterge conversația';

  @override
  String get studyDeleteTheStudyChatHistory => 'Ștergeți istoricul chatului? Nu există cale de întoarcere!';

  @override
  String get studyDeleteStudy => 'Ștergeți studiul';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Ștergeți întregul studiu? Nu există cale de întoarcere! Introduceți numele studiului pentru a confirma: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Unde vreți s-o studiați?';

  @override
  String get studyGoodMove => 'Mutare bună';

  @override
  String get studyMistake => 'Greșeală';

  @override
  String get studyBrilliantMove => 'Mișcare genială';

  @override
  String get studyBlunder => 'Gafă';

  @override
  String get studyInterestingMove => 'Mișcare interesantă';

  @override
  String get studyDubiousMove => 'Mutare dubioasă';

  @override
  String get studyOnlyMove => 'Singura mișcare posibilă';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Poziție egală';

  @override
  String get studyUnclearPosition => 'Poziție neclară';

  @override
  String get studyWhiteIsSlightlyBetter => 'Albul este puțin mai bun';

  @override
  String get studyBlackIsSlightlyBetter => 'Negrul este puțin mai bun';

  @override
  String get studyWhiteIsBetter => 'Albul este mai bun';

  @override
  String get studyBlackIsBetter => 'Negrul este mai bun';

  @override
  String get studyWhiteIsWinning => 'Albul câștigă';

  @override
  String get studyBlackIsWinning => 'Negrul câștigă';

  @override
  String get studyNovelty => 'Noutate';

  @override
  String get studyDevelopment => 'Dezvoltare';

  @override
  String get studyInitiative => 'Inițiativă';

  @override
  String get studyAttack => 'Atac';

  @override
  String get studyCounterplay => 'Contraatac';

  @override
  String get studyTimeTrouble => 'Probleme de timp';

  @override
  String get studyWithCompensation => 'Cu compensații';

  @override
  String get studyWithTheIdea => 'Cu ideea';

  @override
  String get studyNextChapter => 'Capitolul următor';

  @override
  String get studyPrevChapter => 'Capitolul precedent';

  @override
  String get studyStudyActions => 'Acţiuni de studiu';

  @override
  String get studyTopics => 'Subiecte';

  @override
  String get studyMyTopics => 'Subiectele mele';

  @override
  String get studyPopularTopics => 'Subiecte populare';

  @override
  String get studyManageTopics => 'Gestionează subiecte';

  @override
  String get studyBack => 'Înapoi';

  @override
  String get studyPlayAgain => 'Joacă din nou';

  @override
  String get studyWhatWouldYouPlay => 'Ce ai juca în această poziție?';

  @override
  String get studyYouCompletedThisLesson => 'Felicitări! Ai terminat această lecție.';

  @override
  String studyPerPage(String param) {
    return '$param per page';
  }

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capitole',
      few: '$count capitole',
      one: '$count capitol',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partide',
      few: '$count partide',
      one: '$count partidă',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membri',
      few: '$count membri',
      one: '$count membru',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lipiți textul PGN aici, până la $count meciuri',
      few: 'Lipiți textul PGN aici, până la $count meciuri',
      one: 'Lipiți textul PGN aici, până la $count meci',
    );
    return '$_temp0';
  }
}
