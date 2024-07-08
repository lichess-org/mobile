import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

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
  String get activityActivity => 'Toiminta';

  @override
  String get activityHostedALiveStream => 'Piti livestreamin';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Tuli $param1. sijalle turnauksessa $param2';
  }

  @override
  String get activitySignedUp => 'Liittyi lichess.orgiin';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'On tukenut lichess.orgia $count kuukauden ajan ${param2}ina',
      one: 'On tukenut lichess.orgia $count kuukauden ajan ${param2}ina',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Harjoitteli $count $param2 -tilannetta',
      one: 'Harjoitteli $count $param2 -tilannetta',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ratkaisi $count taktiikkatehtävää',
      one: 'Ratkaisi $count taktiikkatehtävän',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pelasi $count $param2-peliä',
      one: 'Pelasi $count $param2-pelin',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lähetti $count viestiä alueelle $param2',
      one: 'Lähetti $count viestin alueelle $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pelasi $count siirtoa',
      one: 'Pelasi $count siirtoa',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kirjeshakkipelissä',
      one: '$count kirjeshakkipelissä',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pelasi $count kirjeshakkipeliä',
      one: 'Pelasi $count kirjeshakkipelin',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alkoi seuraamaan $count pelaajaa',
      one: 'Alkoi seuraamaan $count pelaajaa',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sai $count uutta seuraajaa',
      one: 'Sai $count uuden seuraajan',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Piti $count simultaania',
      one: 'Piti $count simultaanin',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Osallistui $count simultaaniin',
      one: 'Osallistui $count simultaaniin',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Teki $count uutta tutkielmaa',
      one: 'Teki $count uuden tutkielman',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilpaili $count turnauksessa',
      one: 'Kilpaili $count turnauksessa',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sijoittui $count. sijalle (parhaaseen $param2%) pelattuaan $param3 peliä turnauksessa $param4',
      one: 'Sijoittui $count. sijalle (parhaaseen $param2%) pelattuaan $param3 pelin turnauksessa $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Osallistui $count sveitsiläiseen turnaukseen',
      one: 'Osallistui $count sveitsiläiseen turnaukseen',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Liittyi $count joukkueeseen',
      one: 'Liittyi $count joukkueeseen',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Lähetykset';

  @override
  String get broadcastLiveBroadcasts => 'Suorat lähetykset turnauksista';

  @override
  String challengeChallengesX(String param1) {
    return 'Haasteet: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Haasta peliin';

  @override
  String get challengeChallengeDeclined => 'Haasteesta kieltäydyttiin';

  @override
  String get challengeChallengeAccepted => 'Haaste hyväksytty!';

  @override
  String get challengeChallengeCanceled => 'Haaste peruutettu.';

  @override
  String get challengeRegisterToSendChallenges => 'Rekisteröidy niin voit lähettää haasteita.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Et voi haastaa pelaajaa $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param ei ota haasteita vastaan.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return '$param1-vahvuuslukusi on liian kaukana pelaajan $param2 vahvuusluvusta.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Et voi haastaa, koska $param-vahvuuslukusi on tilapäinen.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param ottaa vastaan haasteita vain kavereiltaan.';
  }

  @override
  String get challengeDeclineGeneric => 'En ota tällä hetkellä haasteita vastaan.';

  @override
  String get challengeDeclineLater => 'Ajankohta ei sovi minulle juuri nyt, pyydä myöhemmin uudelleen.';

  @override
  String get challengeDeclineTooFast => 'Tämä aikaraja on minulle liian nopea, haasta minut uudelleen hitaampaan peliin.';

  @override
  String get challengeDeclineTooSlow => 'Tämä aikaraja on minulle liian hidas, haasta minut uudelleen nopeampaan peliin.';

  @override
  String get challengeDeclineTimeControl => 'En ota vastaan haasteita tällä aikarajalla.';

  @override
  String get challengeDeclineRated => 'Lähetä minulle sen sijaan haaste pisteytettyyn peliin.';

  @override
  String get challengeDeclineCasual => 'Lähetä minulle sen sijaan haaste rentoon peliin.';

  @override
  String get challengeDeclineStandard => 'En juuri nyt ota vastaan haasteita variantteihin.';

  @override
  String get challengeDeclineVariant => 'En juuri nyt halua pelata tätä varianttia.';

  @override
  String get challengeDeclineNoBot => 'En ota vastaan haasteita boteilta.';

  @override
  String get challengeDeclineOnlyBot => 'Otan vastaan haasteita vain boteilta.';

  @override
  String get challengeInviteLichessUser => 'Tai kutsu Lichess-käyttäjä:';

  @override
  String get contactContact => 'Ota yhteyttä';

  @override
  String get contactContactLichess => 'Ota yhteyttä Lichessiin';

  @override
  String get patronDonate => 'Lahjoita';

  @override
  String get patronLichessPatron => 'Lichessin tukija';

  @override
  String perfStatPerfStats(String param) {
    return '$param-tilastot';
  }

  @override
  String get perfStatViewTheGames => 'Katso pelit';

  @override
  String get perfStatProvisional => 'tilapäinen';

  @override
  String get perfStatNotEnoughRatedGames => 'Ei ole pelattu riittävän montaa pisteytettyä peliä, jotta voitaisiin muodostaa luotettava vahvuusluku.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Kehitys viimeisten $param pelin aikana:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Vahvuuslukupoikkeama: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Alempi arvo tarkoittaa, että vahvuusluku on vakiintuneempi. Kun arvo on yli $param1, vahvuusluku on tilapäinen. Vahvuuslukulistalle pääsee, kun tämä arvo on alle $param2 (tavallisessa shakissa) tai $param3 (varianteissa).';
  }

  @override
  String get perfStatTotalGames => 'Pelejä yhteensä';

  @override
  String get perfStatRatedGames => 'Pisteytettyjä pelejä';

  @override
  String get perfStatTournamentGames => 'Turnauspelejä';

  @override
  String get perfStatBerserkedGames => 'Berserkkipelejä';

  @override
  String get perfStatTimeSpentPlaying => 'Pelaamiseen käytetty aika';

  @override
  String get perfStatAverageOpponent => 'Keskimääräinen vastustaja';

  @override
  String get perfStatVictories => 'Voittoja';

  @override
  String get perfStatDefeats => 'Tappioita';

  @override
  String get perfStatDisconnections => 'Yhteys katkennut';

  @override
  String get perfStatNotEnoughGames => 'Ei tarpeeksi pelattuja pelejä';

  @override
  String perfStatHighestRating(String param) {
    return 'Korkein vahvuusluku: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Alin vahvuusluku: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'aikavälillä $param1–$param2';
  }

  @override
  String get perfStatWinningStreak => 'Voittoputki';

  @override
  String get perfStatLosingStreak => 'Tappioputki';

  @override
  String perfStatLongestStreak(String param) {
    return 'Pisin putki: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Nykyinen putki: $param';
  }

  @override
  String get perfStatBestRated => 'Korkeimman vahvuusluvun voitot';

  @override
  String get perfStatGamesInARow => 'Peräjälkeen pelattuja pelejä';

  @override
  String get perfStatLessThanOneHour => 'Alle tunti pelien välissä';

  @override
  String get perfStatMaxTimePlaying => 'Pisin yhtäjaksoinen peliaika';

  @override
  String get perfStatNow => 'nyt';

  @override
  String get preferencesPreferences => 'Asetukset';

  @override
  String get preferencesDisplay => 'Näyttöasetukset';

  @override
  String get preferencesPrivacy => 'Yksityisyysasetukset';

  @override
  String get preferencesNotifications => 'Ilmoitukset';

  @override
  String get preferencesPieceAnimation => 'Nappuloiden animaatio';

  @override
  String get preferencesMaterialDifference => 'Materiaaliero';

  @override
  String get preferencesBoardHighlights => 'Laudan korostukset (viimeisin siirto ja shakki)';

  @override
  String get preferencesPieceDestinations => 'Lailliset siirrot ja esisiirrot';

  @override
  String get preferencesBoardCoordinates => 'Laudan koordinaatit (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Siirtolista pelin aikana';

  @override
  String get preferencesPgnPieceNotation => 'Siirtojen merkintätapa';

  @override
  String get preferencesChessPieceSymbol => 'Shakkinappulasymbolit';

  @override
  String get preferencesPgnLetter => 'Kirjaimet (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen-moodi';

  @override
  String get preferencesShowPlayerRatings => 'Näytä pelaajien vahvuusluvut';

  @override
  String get preferencesShowFlairs => 'Näytä pelaajien tyylit';

  @override
  String get preferencesExplainShowPlayerRatings => 'Tämän avulla voit piilottaa sivustolta kaikki vahvuusluvut, jotta voit keskittyä paremmin shakinpeluuseen. Pelit kyllä pisteytetään normaalisti, tällä asetuksella on vaikutus vain sinun näkymääsi.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Näytä laudan koon muokkauskahva';

  @override
  String get preferencesOnlyOnInitialPosition => 'Vain alkuasemassa';

  @override
  String get preferencesInGameOnly => 'Vain pelin aikana';

  @override
  String get preferencesChessClock => 'Shakkikello';

  @override
  String get preferencesTenthsOfSeconds => 'Sekunnin kymmenesosat';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Kun aikaa jäljellä < 10 sekuntia';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Vaakasuora vihreä ajanetenemispalkki';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Äänimerkki kun aika on vähissä';

  @override
  String get preferencesGiveMoreTime => 'Anna lisää aikaa';

  @override
  String get preferencesGameBehavior => 'Pelillisiä lisäasetuksia';

  @override
  String get preferencesHowDoYouMovePieces => 'Kuinka siirrät nappuloita?';

  @override
  String get preferencesClickTwoSquares => 'Klikkaa kahta ruutua';

  @override
  String get preferencesDragPiece => 'Raahaa nappulaa';

  @override
  String get preferencesBothClicksAndDrag => 'Molemmat';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Esisiirrot (pelaaminen vastustajan vuorolla)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Siirtojen peruminen (vastustajan hyväksynnällä)';

  @override
  String get preferencesInCasualGamesOnly => 'Vain rennoissa peleissä';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Korota automaattisesti kuningattareksi';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Pidä <ctrl>-näppäintä painettuna korottaessasi sotilaan, jos haluat ottaa automaattisen korotuksen väliaikaisesti pois käytöstä';

  @override
  String get preferencesWhenPremoving => 'Esisiirtäessä';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Vaadi tasapeli automaattisesti kolminkertaisen toiston sattuessa';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Kun aikaa on jäljellä < 30 sekuntia';

  @override
  String get preferencesMoveConfirmation => 'Siirron vahvistus';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Voidaan poistaa käytöstä pelin aikana lautavalikon kautta';

  @override
  String get preferencesInCorrespondenceGames => 'Kirjeshakissa';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Kirjeshakki ja aikarajaton';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Vahvista luovutukset ja tasapelitarjoukset';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Kuinka linnoittaudut';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Siirrä kuningasta kaksi ruutua';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Siirrä kuningas tornin päälle';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Syötä siirtoja näppäimistöllä';

  @override
  String get preferencesInputMovesWithVoice => 'Syötä siirtosi puheella';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Merkitse mahdolliset siirrot nuolilla';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Sano \"Good game, well played\" (suom. \"Hyvä peli, hyvin pelattu\") tasapelin tai tappion jälkeen';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Asetuksesi on tallennettu.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Vierittämällä laudan yllä voit katsoa siirtoja uudelleen';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Päivittäinen sähköposti-ilmoitus, jossa listataan kirjeshakkipelisi';

  @override
  String get preferencesNotifyStreamStart => 'Striimaaja aloittaa striimin';

  @override
  String get preferencesNotifyInboxMsg => 'Uusi saapunut viesti';

  @override
  String get preferencesNotifyForumMention => 'Sinut mainitaan foorumin kommentissa';

  @override
  String get preferencesNotifyInvitedStudy => 'Kutsu tutkielmaan';

  @override
  String get preferencesNotifyGameEvent => 'Kirjeshakkipelien uudet tapahtumat';

  @override
  String get preferencesNotifyChallenge => 'Haasteet';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnaus alkamassa pian';

  @override
  String get preferencesNotifyTimeAlarm => 'Kirjeshakkipelin aika loppumassa';

  @override
  String get preferencesNotifyBell => 'Kilahtava ilmoitus Lichessissä';

  @override
  String get preferencesNotifyPush => 'Laitteen ilmoitus, kun et ole Lichessissä';

  @override
  String get preferencesNotifyWeb => 'Selain';

  @override
  String get preferencesNotifyDevice => 'Laite';

  @override
  String get preferencesBellNotificationSound => 'Ilmoitusten kilahdusääni';

  @override
  String get puzzlePuzzles => 'Tehtävät';

  @override
  String get puzzlePuzzleThemes => 'Tehtävien aiheet';

  @override
  String get puzzleRecommended => 'Suosittelemme';

  @override
  String get puzzlePhases => 'Pelin vaiheet';

  @override
  String get puzzleMotifs => 'Motiivit';

  @override
  String get puzzleAdvanced => 'Edistyneille';

  @override
  String get puzzleLengths => 'Pituudet';

  @override
  String get puzzleMates => 'Matit';

  @override
  String get puzzleGoals => 'Tavoitteet';

  @override
  String get puzzleOrigin => 'Alkuperä';

  @override
  String get puzzleSpecialMoves => 'Erityissiirrot';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Piditkö tästä tehtävästä?';

  @override
  String get puzzleVoteToLoadNextOne => 'Anna arviosi, niin seuraava latautuu!';

  @override
  String get puzzleUpVote => 'Arvioi tehtävä hyväksi';

  @override
  String get puzzleDownVote => 'Arvioi tehtävä huonoksi';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Tehtävävahvuuslukusi ei muutu. Huomaa, että tehtävien ratkaisu ei ole kilpailu. Vahvuusluvun perusteella saat ratkaistavaksesi tämänhetkistä taitotasoasi parhaiten vastaavia tehtäviä.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Löydä valkean paras siirto.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Löydä mustan paras siirto.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Halutessasi henkilökohtaisia tehtäviä:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Tehtävä $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Päivän tehtävä';

  @override
  String get puzzleDailyPuzzle => 'Päivän tehtävä';

  @override
  String get puzzleClickToSolve => 'Ratkaise klikkaamalla';

  @override
  String get puzzleGoodMove => 'Hyvä siirto';

  @override
  String get puzzleBestMove => 'Paras siirto!';

  @override
  String get puzzleKeepGoing => 'Jatka…';

  @override
  String get puzzlePuzzleSuccess => 'Onnistui!';

  @override
  String get puzzlePuzzleComplete => 'Tehtävä ratkaistu!';

  @override
  String get puzzleByOpenings => 'Avausryhmitys';

  @override
  String get puzzlePuzzlesByOpenings => 'Tehtäviä avausten mukaan ryhmitettyinä';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Pisteytetyissä peleissä eniten pelaamasi avaukset';

  @override
  String get puzzleUseFindInPage => 'Löydä lempiavauksesi valitsemalla selaimen valikosta \"Etsi sivulta\"!';

  @override
  String get puzzleUseCtrlF => 'Löydä lempiavauksesi painamalla Ctrl+F!';

  @override
  String get puzzleNotTheMove => 'Tuo siirto se ei ole!';

  @override
  String get puzzleTrySomethingElse => 'Kokeile jotain muuta.';

  @override
  String puzzleRatingX(String param) {
    return 'Vahvuusluku: $param';
  }

  @override
  String get puzzleHidden => 'piilotettu';

  @override
  String puzzleFromGameLink(String param) {
    return 'Pelistä $param';
  }

  @override
  String get puzzleContinueTraining => 'Jatka harjoittelua';

  @override
  String get puzzleDifficultyLevel => 'Vaikeustaso';

  @override
  String get puzzleNormal => 'Keskitaso';

  @override
  String get puzzleEasier => 'Helpompi';

  @override
  String get puzzleEasiest => 'Helpoin';

  @override
  String get puzzleHarder => 'Vaikeampi';

  @override
  String get puzzleHardest => 'Vaikein';

  @override
  String get puzzleExample => 'Esimerkki';

  @override
  String get puzzleAddAnotherTheme => 'Lisää toinen teema';

  @override
  String get puzzleNextPuzzle => 'Seuraava tehtävä';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Jatka heti seuraavaan tehtävään';

  @override
  String get puzzlePuzzleDashboard => 'Tehtävien hallinta';

  @override
  String get puzzleImprovementAreas => 'Paranna näitä';

  @override
  String get puzzleStrengths => 'Vahvuutesi';

  @override
  String get puzzleHistory => 'Tehtävähistoria';

  @override
  String get puzzleSolved => 'ratkaistu';

  @override
  String get puzzleFailed => 'epäonnistui';

  @override
  String get puzzleStreakDescription => 'Ratkaise asteittain vaikeutuvia tehtäviä ja luo voittoputki. Kello ei ole käytössä, joten voit miettiä rauhassa. Yksikin väärä siirto, niin peli on ohi! Kunkin sarjan aikana voit kuitenkin ohittaa yhden siirron.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Putkesi: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Ohita tämä siirto jatkaaksesi putkea! Toimii kunkin sarjan aikana vain kerran.';

  @override
  String get puzzleContinueTheStreak => 'Jatka putkea';

  @override
  String get puzzleNewStreak => 'Uusi putki';

  @override
  String get puzzleFromMyGames => 'Omista peleistäni';

  @override
  String get puzzleLookupOfPlayer => 'Hae tehtäviä tietyn pelaajan peleistä';

  @override
  String puzzleFromXGames(String param) {
    return 'Tehtäviä pelaajan $param peleistä';
  }

  @override
  String get puzzleSearchPuzzles => 'Hae tehtäviä';

  @override
  String get puzzleFromMyGamesNone => 'Tietokannassa ei ole tehtäviä sinulta, mutta olet silti Lichessille erittäin tärkeä.\nKun pelaat lisää nopeita ja klassisia pelejä, on suurempi mahdollisuus, että sinunkin peleistäsi luodaan tehtävä!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return 'Löytyi $param1 tehtävää $param2 pelistä';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Harjoittele, analysoi, kehity';

  @override
  String puzzlePercentSolved(String param) {
    return '$param ratkaistu';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Täällä ei ole vielä mitään nähtävää – tee ensin joitakin tehtäviä!';

  @override
  String get puzzleImprovementAreasDescription => 'Harjoittele näitä tehostaaksesi edistymistäsi!';

  @override
  String get puzzleStrengthDescription => 'Suoriudut parhaiten näissä aiheissa';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pelattu $count kertaa',
      one: 'Pelattu $count kerran',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistettä matalampi tehtävävahvuusluku kuin sinulla',
      one: 'Yhden pisteen matalampi tehtävävahvuusluku kuin sinulla',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistettä korkeampi tehtävävahvuusluku kuin sinulla',
      one: 'Yhden pisteen korkeampi tehtävävahvuusluku kuin sinulla',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pelattu',
      one: '$count pelattu',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kerrattavaa',
      one: '$count kerrattava',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Pitkälle edennyt sotilas';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Taktiikassa keskeistä on sotilas, joka korottuu tai uhkaa korottua.';

  @override
  String get puzzleThemeAdvantage => 'Etu';

  @override
  String get puzzleThemeAdvantageDescription => 'Tartu tilaisuuteen hankkia ratkaiseva etu. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasian matti';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Ratsun sekä tornin tai daamin yhteistyöllä vastustajan kuningas jää kiinni laudan reunan ja oman nappulan välissä.';

  @override
  String get puzzleThemeArabianMate => 'Arabialainen matti';

  @override
  String get puzzleThemeArabianMateDescription => 'Ratsun ja tornin yhteistyöllä vastustajan kuningas jää kiinni laudan nurkassa.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Hyökkäys f2:een tai f7:ään';

  @override
  String get puzzleThemeAttackingF2F7Description => 'F2- tai f7-sotilaaseen kohdistuva hyökkäys, kuten esimerkiksi Preussilaisen pelin Fried Liver eli Fegatello-muunnelma.';

  @override
  String get puzzleThemeAttraction => 'Houkutus';

  @override
  String get puzzleThemeAttractionDescription => 'Vaihto tai uhraus, joka houkuttelee tai pakottaa vastustajan nappulan tiettyyn ruutuun ja mahdollistaa siten taktisen jatkon.';

  @override
  String get puzzleThemeBackRankMate => 'Takarivin matti';

  @override
  String get puzzleThemeBackRankMateDescription => 'Matita kuningas takarivillä, kun sen omat nappulat estävät sitä siirtymästä pois.';

  @override
  String get puzzleThemeBishopEndgame => 'Lähettiloppupeli';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Loppupeli, jossa on vain lähettejä ja sotilaita.';

  @override
  String get puzzleThemeBodenMate => 'Bodenin matti';

  @override
  String get puzzleThemeBodenMateDescription => 'Kaksi ristiäviltä diagonaaleilta hyökkäävää lähettiä matittaa omien nappuloidensa estämän kuninkaan.';

  @override
  String get puzzleThemeCastling => 'Linnoitus';

  @override
  String get puzzleThemeCastlingDescription => 'Vie kuninkaasi turvaan ja tuo tornisi mukaan hyökkäykseen.';

  @override
  String get puzzleThemeCapturingDefender => 'Lyö puolustava nappula';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Lyö toisen nappulan suojelemiseen käytetty nappula, jotta voit seuraavilla siirroilla lyödä toisen nappulan, joka ei ole enää suojeltu.';

  @override
  String get puzzleThemeCrushing => 'Murskaava etu';

  @override
  String get puzzleThemeCrushingDescription => 'Löydä vastustajan vakava virhe ja hanki murskaava etu. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Kahden lähetin matti';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Kaksi vierekkäisiltä diagonaaleilta hyökkäävää lähettiä matittaa omien nappuloidensa estämän kuninkaan.';

  @override
  String get puzzleThemeDovetailMate => 'Cozion matti';

  @override
  String get puzzleThemeDovetailMateDescription => 'Daami matittaa vieressään olevan kuninkaan, jonka omat nappulat vievät siltä sen ainoat kaksi pakoruutua.';

  @override
  String get puzzleThemeEquality => 'Tasoitus';

  @override
  String get puzzleThemeEqualityDescription => 'Nouse häviöasemasta takaisin peliin ja saavuta tasapeli tai tasapainoinen asema. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Hyökkäys kuningassivustalla';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Hyökkää vastustajan kuninkaan kimppuun tämän linnoituttua kuningassivustalle.';

  @override
  String get puzzleThemeClearance => 'Vapautus';

  @override
  String get puzzleThemeClearanceDescription => 'Usein tempolla tehtävä siirto, joka vapauttaa ruudun, linjan tai diagonaalin seuraavaa taktista ideaa varten.';

  @override
  String get puzzleThemeDefensiveMove => 'Puolustussiirto';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Tarkka siirto tai siirtosarja, joka tarvitaan materiaali- tai muun edun menetyksen välttämiseksi.';

  @override
  String get puzzleThemeDeflection => 'Harhautus';

  @override
  String get puzzleThemeDeflectionDescription => 'Siirto, jolla harhautetaan vastustajan nappula pois suorittamasta jotain toista tehtävää, kuten vartioimasta tärkeää ruutua.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Paljastushyökkäys';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Siirrä nappulaa, joka on tähän asti peittänyt jonkin ulottuvaisen nappulan hyökkäyksen, esimerkiksi ratsu pois tornin edestä.';

  @override
  String get puzzleThemeDoubleCheck => 'Kaksoisshakki';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Shakkaa samanaikaisesti kahdella nappulalla niin, että paljastushyökkäyksessäsi sekä liikkuva nappula että sen paljastama nappula uhkaavat vastustajan kuningasta.';

  @override
  String get puzzleThemeEndgame => 'Loppupeli';

  @override
  String get puzzleThemeEndgameDescription => 'Taktiikka pelin viimeisessä vaiheessa.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktiikka, jossa sovelletaan ohestalyöntisääntöä, eli jossa sotilas voi lyödä sellaisen vastustajan sotilaan, joka on juuri ensimmäisellä kahden ruudun siirrollaan ohittanut sen.';

  @override
  String get puzzleThemeExposedKing => 'Suojaton kuningas';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktiikka, jossa kuninkaan ympärillä on vain vähän puolustajia, ja joka usein johtaa mattiin.';

  @override
  String get puzzleThemeFork => 'Haarukka';

  @override
  String get puzzleThemeForkDescription => 'Siirto, jolla siirrettävä nappula uhkaa samanaikaisesti kahta vastustajan nappulaa.';

  @override
  String get puzzleThemeHangingPiece => 'Ilmainen nappula';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktiikka, jossa vastustajan nappulaa ei ole suojattu lainkaan tai ei riittävästi, ja jossa se on vapaasti lyötävissä.';

  @override
  String get puzzleThemeHookMate => 'Koukkumatti';

  @override
  String get puzzleThemeHookMateDescription => 'Tornin, ratsun ja sotilaan yhteispelillä syntyvä matti, jossa vastustajan sotilas vie kuninkaaltaan yhden pakoruudun.';

  @override
  String get puzzleThemeInterference => 'Katko';

  @override
  String get puzzleThemeInterferenceDescription => 'Siirrä nappulasi kahden vastustajan nappulan väliin niin, että yksi tai molemmat vastustajan nappuloista jäävät ilman suojaa, esimerkiksi ratsusi suojattuun ruutuun kahden tornin väliin.';

  @override
  String get puzzleThemeIntermezzo => 'Välisiirto';

  @override
  String get puzzleThemeIntermezzoDescription => 'Tee odotetun siirron sijaan ensin toinen siirto, jonka synnyttämään välittömään uhkaan vastustajasi täytyy vastata. Tunnetaan myös nimellä \"Zwischenzug\".';

  @override
  String get puzzleThemeKnightEndgame => 'Ratsuloppupeli';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Loppupeli, jossa on vain ratsuja ja sotilaita.';

  @override
  String get puzzleThemeLong => 'Pitkä tehtävä';

  @override
  String get puzzleThemeLongDescription => 'Voittoon tarvitaan kolme siirtoa.';

  @override
  String get puzzleThemeMaster => 'Mestaritason pelit';

  @override
  String get puzzleThemeMasterDescription => 'Tehtäviä arvonimen saaneiden pelaajien peleistä.';

  @override
  String get puzzleThemeMasterVsMaster => 'Kahden mestarin väliset pelit';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Tehtäviä kahden arvonimen saaneen pelaajan välisistä peleistä.';

  @override
  String get puzzleThemeMate => 'Matti';

  @override
  String get puzzleThemeMateDescription => 'Voita peli tyylillä.';

  @override
  String get puzzleThemeMateIn1 => '1 siirron matti';

  @override
  String get puzzleThemeMateIn1Description => 'Tee matti yhdessä siirrossa.';

  @override
  String get puzzleThemeMateIn2 => '2 siirron matti';

  @override
  String get puzzleThemeMateIn2Description => 'Tee matti kahdessa siirrossa.';

  @override
  String get puzzleThemeMateIn3 => '3 siirron matti';

  @override
  String get puzzleThemeMateIn3Description => 'Tee matti kolmessa siirrossa.';

  @override
  String get puzzleThemeMateIn4 => '4 siirron matti';

  @override
  String get puzzleThemeMateIn4Description => 'Tee matti neljässä siirrossa.';

  @override
  String get puzzleThemeMateIn5 => '5 tai useamman siirron matti';

  @override
  String get puzzleThemeMateIn5Description => 'Löydä pitkä mattisommitelma.';

  @override
  String get puzzleThemeMiddlegame => 'Keskipeli';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktiikka pelin toisessa vaiheessa.';

  @override
  String get puzzleThemeOneMove => 'Yhden siirron tehtävä';

  @override
  String get puzzleThemeOneMoveDescription => 'Tehtävä, jossa vaaditaan vain yksi siirto.';

  @override
  String get puzzleThemeOpening => 'Avaus';

  @override
  String get puzzleThemeOpeningDescription => 'Taktiikka pelin ensimmäisessä vaiheessa.';

  @override
  String get puzzleThemePawnEndgame => 'Sotilasloppupeli';

  @override
  String get puzzleThemePawnEndgameDescription => 'Loppupeli, jossa on vain sotilaita.';

  @override
  String get puzzleThemePin => 'Kiinnitys';

  @override
  String get puzzleThemePinDescription => 'Taktiikka, jossa kiinnitetty nappula ei pysty liikkumaan paljastamatta arvokkaampaan nappulaan kohdistuvaa hyökkäystä.';

  @override
  String get puzzleThemePromotion => 'Korotus';

  @override
  String get puzzleThemePromotionDescription => 'Taktiikassa keskeistä on sotilas, joka korottuu tai uhkaa korottua.';

  @override
  String get puzzleThemeQueenEndgame => 'Daamiloppupeli';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Loppupeli, jossa on vain daamit ja sotilaita.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Daami- ja torniloppupeli';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Loppupeli, jossa on vain daameja, torneja ja sotilaita.';

  @override
  String get puzzleThemeQueensideAttack => 'Hyökkäys daamisivustalla';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Hyökkää vastustajan kuninkaan kimppuun tämän linnoituttua daamisivustalle.';

  @override
  String get puzzleThemeQuietMove => 'Hiljainen siirto';

  @override
  String get puzzleThemeQuietMoveDescription => 'Siirto, joka ei shakkaa eikä lyö, mutta pohjustaa tulevalle siirrolle väistämättömän uhan.';

  @override
  String get puzzleThemeRookEndgame => 'Torniloppupeli';

  @override
  String get puzzleThemeRookEndgameDescription => 'Loppupeli, jossa on vain torneja ja sotilaita.';

  @override
  String get puzzleThemeSacrifice => 'Uhraus';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktiikka, jossa luovutaan väliaikaisesti materiaalista, jotta pakottavan sommitelman päätteeksi saavutetaan jälleen etu.';

  @override
  String get puzzleThemeShort => 'Lyhyt tehtävä';

  @override
  String get puzzleThemeShortDescription => 'Voittoon tarvitaan kaksi siirtoa.';

  @override
  String get puzzleThemeSkewer => 'Varrastus';

  @override
  String get puzzleThemeSkewerDescription => 'Siirto, jolla uhataan arvokkaampaa nappulaa, jonka siirtyessä sen takana oleva nappula jää uhatuksi ja on lyötävissä, eli toisin päin kuin kiinnityksessä.';

  @override
  String get puzzleThemeSmotheredMate => 'Pussimatti';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Ratsun tekemä matti, jossa matitettava kuningas ei pysty liikkumaan, koska sen omat nappulat ympäröivät sitä (eli pussittavat sen).';

  @override
  String get puzzleThemeSuperGM => 'Supersuurmestarien pelit';

  @override
  String get puzzleThemeSuperGMDescription => 'Tehtäviä maailman parhaiden pelaajien pelaamista peleistä.';

  @override
  String get puzzleThemeTrappedPiece => 'Ansaan jäävä nappula';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Nappula ei pääse pakenemaan lyömiseltä sopivien pakosiirtojen puuttuessa.';

  @override
  String get puzzleThemeUnderPromotion => 'Alikorotus';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Korotus ratsuksi, lähetiksi tai torniksi.';

  @override
  String get puzzleThemeVeryLong => 'Erittäin pitkä tehtävä';

  @override
  String get puzzleThemeVeryLongDescription => 'Voittoon tarvitaan neljä siirtoa tai enemmän.';

  @override
  String get puzzleThemeXRayAttack => 'Röntgenhyökkäys';

  @override
  String get puzzleThemeXRayAttackDescription => 'Nappula uhkaa tai puolustaa ruutua vastustajan nappulan läpi.';

  @override
  String get puzzleThemeZugzwang => 'Siirtopakko';

  @override
  String get puzzleThemeZugzwangDescription => 'Vastustajalla on rajoitettu määrä mahdollisia siirtoja, ja niistä kaikki heikentävät hänen asemaansa.';

  @override
  String get puzzleThemeHealthyMix => 'Terve sekoitus';

  @override
  String get puzzleThemeHealthyMixDescription => 'Vähän kaikkea. Et tiedä mitä tuleman pitää, joten olet valmiina mihin tahansa! Aivan kuten oikeissa peleissäkin.';

  @override
  String get puzzleThemePlayerGames => 'Pelaajan peleistä';

  @override
  String get puzzleThemePlayerGamesDescription => 'Tehtäviä sinun tai jonkun toisen yksittäisen pelaajan peleistä.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Nämä tehtävät ovat vapaasti käytettävissä ja ladattavissa osoitteesta $param.';
  }

  @override
  String get searchSearch => 'Etsi';

  @override
  String get settingsSettings => 'Asetukset';

  @override
  String get settingsCloseAccount => 'Sulje tili';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Käyttäjätunnuksesi on hallinnassa, eikä sitä voi sulkea.';

  @override
  String get settingsClosingIsDefinitive => 'Tunnuksen sulku on lopullinen. Et voi myöhemmin peruuttaa sitä. Oletko varma?';

  @override
  String get settingsCantOpenSimilarAccount => 'Et voi luoda uutta käyttäjätunnusta samalla nimellä, et vaikka muuttaisit isoja kirjaimia pieniksi tai päinvastoin.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Muutin mieleni, älä sulje tunnustani';

  @override
  String get settingsCloseAccountExplanation => 'Haluatko varmasti sulkea tilisi? Sulkeminen on pysyvä päätös. Et voi ENÄÄ KOSKAAN kirjautua sisään.';

  @override
  String get settingsThisAccountIsClosed => 'Tämä tunnus on suljettu.';

  @override
  String get playWithAFriend => 'Pelaa kaveria vastaan';

  @override
  String get playWithTheMachine => 'Pelaa tietokonetta vastaan';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Lähetä tämä linkki kaverillesi, jonka haluat kutsua pelaamaan';

  @override
  String get gameOver => 'Peli ohi';

  @override
  String get waitingForOpponent => 'Odotetaan vastustajaa';

  @override
  String get orLetYourOpponentScanQrCode => 'Tai anna vastustajasi skannata tämä QR-koodi';

  @override
  String get waiting => 'Odotetaan';

  @override
  String get yourTurn => 'Sinun vuorosi';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 taso $param2';
  }

  @override
  String get level => 'Taso';

  @override
  String get strength => 'Vahvuus';

  @override
  String get toggleTheChat => 'Keskustelu päälle / pois';

  @override
  String get chat => 'Keskustelu';

  @override
  String get resign => 'Luovuta';

  @override
  String get checkmate => 'Shakkimatti';

  @override
  String get stalemate => 'Patti';

  @override
  String get white => 'Valkea';

  @override
  String get black => 'Musta';

  @override
  String get asWhite => 'valkeilla';

  @override
  String get asBlack => 'mustilla';

  @override
  String get randomColor => 'Satunnainen';

  @override
  String get createAGame => 'Luo uusi peli';

  @override
  String get whiteIsVictorious => 'Valkea voittaa';

  @override
  String get blackIsVictorious => 'Musta voittaa';

  @override
  String get youPlayTheWhitePieces => 'Sinä pelaat valkeilla';

  @override
  String get youPlayTheBlackPieces => 'Sinä pelaat mustilla';

  @override
  String get itsYourTurn => 'Sinun vuorosi!';

  @override
  String get cheatDetected => 'Huijaus havaittu';

  @override
  String get kingInTheCenter => 'Kuningas keskustassa';

  @override
  String get threeChecks => 'Kolme shakkia';

  @override
  String get raceFinished => 'Kilpa loppunut';

  @override
  String get variantEnding => 'Lopetus varianttisääntöjen mukaan';

  @override
  String get newOpponent => 'Uusi vastustaja';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Vastustajasi haluaa pelata uudelleen';

  @override
  String get joinTheGame => 'Liity peliin';

  @override
  String get whitePlays => 'Valkean vuoro';

  @override
  String get blackPlays => 'Mustan vuoro';

  @override
  String get opponentLeftChoices => 'Vastustajasi on poistunut pelistä. Voit julistautua voittajaksi, sopia tasapelin tai odottaa häntä.';

  @override
  String get forceResignation => 'Julistaudu voittajaksi';

  @override
  String get forceDraw => 'Pakota tasapeli';

  @override
  String get talkInChat => 'Kirjoita keskusteluun. Ole kohtelias!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Pelaat sen kaverin kanssa, joka ensimmäisenä avaa linkin.';

  @override
  String get whiteResigned => 'Valkea luovutti';

  @override
  String get blackResigned => 'Musta luovutti';

  @override
  String get whiteLeftTheGame => 'Valkea lähti pelistä';

  @override
  String get blackLeftTheGame => 'Musta lähti pelistä';

  @override
  String get whiteDidntMove => 'Valkea ei siirtänyt';

  @override
  String get blackDidntMove => 'Musta ei siirtänyt';

  @override
  String get requestAComputerAnalysis => 'Pyydä tietokoneanalyysiä';

  @override
  String get computerAnalysis => 'Tietokoneanalyysi';

  @override
  String get computerAnalysisAvailable => 'Tietokoneanalyysi käytettävissä';

  @override
  String get computerAnalysisDisabled => 'Tietokoneanalyysi poissa käytöstä';

  @override
  String get analysis => 'Analyysilauta';

  @override
  String depthX(String param) {
    return 'Syvyys $param';
  }

  @override
  String get usingServerAnalysis => 'Palvelimen analyysi';

  @override
  String get loadingEngine => 'Tietokonetta ladataan ...';

  @override
  String get calculatingMoves => 'Lasketaan siirtoja...';

  @override
  String get engineFailed => 'Virhe tietokoneen lataamisessa';

  @override
  String get cloudAnalysis => 'Pilvianalyysi';

  @override
  String get goDeeper => 'Syvennä analyysiä';

  @override
  String get showThreat => 'Näytä uhka';

  @override
  String get inLocalBrowser => 'paikallisesta selaimesta';

  @override
  String get toggleLocalEvaluation => 'Paikallinen analyysi päälle/pois';

  @override
  String get promoteVariation => 'Nosta muunnelmaa';

  @override
  String get makeMainLine => 'Päämuunnelmaksi';

  @override
  String get deleteFromHere => 'Poista tästä alkaen';

  @override
  String get collapseVariations => 'Taita kokoon muunnelmat';

  @override
  String get expandVariations => 'Laajenna muunnelmat';

  @override
  String get forceVariation => 'Pakota muunnelmaksi';

  @override
  String get copyVariationPgn => 'Kopioi muunnelman PGN';

  @override
  String get move => 'Siirto';

  @override
  String get variantLoss => 'Variantin tappio';

  @override
  String get variantWin => 'Variantin voitto';

  @override
  String get insufficientMaterial => 'Riittämätön materiaali';

  @override
  String get pawnMove => 'Sotilaan siirto';

  @override
  String get capture => 'Lyönti';

  @override
  String get close => 'Sulje';

  @override
  String get winning => 'Voittaa';

  @override
  String get losing => 'Häviää';

  @override
  String get drawn => 'Tasapeli';

  @override
  String get unknown => 'Tuntematon';

  @override
  String get database => 'Tietokanta';

  @override
  String get whiteDrawBlack => 'Valkea / Tasapeli / Musta';

  @override
  String averageRatingX(String param) {
    return 'Vahvuuslukukeskiarvo $param';
  }

  @override
  String get recentGames => 'Viimeaikaiset pelit';

  @override
  String get topGames => 'Kärkipelit';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return '2 miljoonaa $param1+ FIDE-rankattujen pelaajien vuosina $param2-$param3 laudalla pelaamaa peliä';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' pyöristettynä, puolisiirtojen määrä seuraavaan lyöntiin tai sotilaan siirtoon';

  @override
  String get noGameFound => 'Pelejä ei löytynyt';

  @override
  String get maxDepthReached => 'Maksimisyvyys saavutettu!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Voisit sisällyttää lisää pelejä asetusvalikosta?';

  @override
  String get openings => 'Avaukset';

  @override
  String get openingExplorer => 'Avausselain';

  @override
  String get openingEndgameExplorer => 'Avaus- ja loppupeliselain';

  @override
  String xOpeningExplorer(String param) {
    return '$param -avausselain';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Pelaa ensimmäinen avaus-/loppupeliselaimen siirto';

  @override
  String get winPreventedBy50MoveRule => '50 siirron sääntö estää voiton';

  @override
  String get lossSavedBy50MoveRule => '50 siirron sääntö estää tappion';

  @override
  String get winOr50MovesByPriorMistake => 'Voitto tai 50 siirtoa edeltävän virheen seurauksena';

  @override
  String get lossOr50MovesByPriorMistake => 'Tappio tai 50 siirtoa edeltävän virheen seurauksena';

  @override
  String get unknownDueToRounding => 'Voitto tai tappio on varma vain, jos tietokannan suosittamaa jatkoa on noudatettu viimeisestä nappulan lyönnistä tai sotilaan siirrosta lähtien. Tämä johtuu DTZ-arvojen mahdollisesta pyöristymisestä Syzygy-tietokannoissa.';

  @override
  String get allSet => 'Valmis!';

  @override
  String get importPgn => 'Tuo PGN';

  @override
  String get delete => 'Poista';

  @override
  String get deleteThisImportedGame => 'Poista tuotu peli?';

  @override
  String get replayMode => 'Toistotapa';

  @override
  String get realtimeReplay => 'Reaaliaik.';

  @override
  String get byCPL => 'Virheet';

  @override
  String get openStudy => 'Avaa tutkielma';

  @override
  String get enable => 'Käytössä';

  @override
  String get bestMoveArrow => 'Parhaan siirron nuoli';

  @override
  String get showVariationArrows => 'Näytä muunnelman nuolet';

  @override
  String get evaluationGauge => 'Arviomittari';

  @override
  String get multipleLines => 'Muunnelmien määrä';

  @override
  String get cpus => 'Suorittimia';

  @override
  String get memory => 'Muistia';

  @override
  String get infiniteAnalysis => 'Loputon analyysi';

  @override
  String get removesTheDepthLimit => 'Poistaa syvyysrajoituksen ja pitää koneesi lämpöisenä';

  @override
  String get engineManager => 'Moottorin hallinta';

  @override
  String get blunder => 'Vakava virhe';

  @override
  String get mistake => 'Virhe';

  @override
  String get inaccuracy => 'Epätarkkuus';

  @override
  String get moveTimes => 'Siirtoihin käytetty aika';

  @override
  String get flipBoard => 'Käännä lauta';

  @override
  String get threefoldRepetition => 'Aseman toisto kolmesti';

  @override
  String get claimADraw => 'Vaadi tasapeli';

  @override
  String get offerDraw => 'Ehdota tasapeliä';

  @override
  String get draw => 'Tasapeli';

  @override
  String get drawByMutualAgreement => 'Ehdotettu ja hyväksytty tasapeli';

  @override
  String get fiftyMovesWithoutProgress => 'Viidenkymmenen siirron sääntö';

  @override
  String get currentGames => 'Meneillään olevat pelit';

  @override
  String get viewInFullSize => 'Näytä täysikokoisena';

  @override
  String get logOut => 'Kirjaudu ulos';

  @override
  String get signIn => 'Kirjaudu sisään';

  @override
  String get rememberMe => 'Muista minut';

  @override
  String get youNeedAnAccountToDoThat => 'Tämä toiminto vaatii käyttäjätunnuksen';

  @override
  String get signUp => 'Rekisteröidy';

  @override
  String get computersAreNotAllowedToPlay => 'Tietokoneet ja tietokoneen avustamat pelaajat eivät saa pelata täällä. Kun pelaat, älä käytä apunasi shakkiohjelmia tai -tietokantoja äläkä toisten pelaajien neuvoja. Ota myös huomioon, että useiden käyttäjätunnuksien luomista ei katsota lainkaan hyvällä, ja liiallisuuksiin mennessään se johtaa porttikieltoon.';

  @override
  String get games => 'Pelit';

  @override
  String get forum => 'Foorumi';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 lähetti viestin ketjuun $param2';
  }

  @override
  String get latestForumPosts => 'Uusimmat foorumiviestit';

  @override
  String get players => 'Pelaajat';

  @override
  String get friends => 'Kaverit';

  @override
  String get discussions => 'Keskustelut';

  @override
  String get today => 'Tänään';

  @override
  String get yesterday => 'Eilen';

  @override
  String get minutesPerSide => 'Minuuttia per pelaaja';

  @override
  String get variant => 'Variantti';

  @override
  String get variants => 'Variantit';

  @override
  String get timeControl => 'Aikajärjestelmä';

  @override
  String get realTime => 'Pikapeli';

  @override
  String get correspondence => 'Kirjeshakki';

  @override
  String get daysPerTurn => 'Päivää per vuoro';

  @override
  String get oneDay => 'Yksi päivä';

  @override
  String get time => 'Aika';

  @override
  String get rating => 'Vahvuusluku';

  @override
  String get ratingStats => 'Vahvuuslukutilastot';

  @override
  String get username => 'Käyttäjänimi';

  @override
  String get usernameOrEmail => 'Käyttäjätunnus tai sähköpostiosoite';

  @override
  String get changeUsername => 'Muuta käyttäjänimeä';

  @override
  String get changeUsernameNotSame => 'Voit muuttaa vain pieniä kirjaimia isoiksi tai toisinpäin. Esimerkiksi \"mattimeikäläinen\" voidaan muuttaa muotoon \"MattiMeikäläinen\".';

  @override
  String get changeUsernameDescription => 'Muuta käyttäjänimeä. Tämän voi tehdä vain kerran. Voit muuttaa vain pieniä kirjaimia isoiksi kirjaimiksi ja toisinpäin.';

  @override
  String get signupUsernameHint => 'Nimeä käyttäjätunnuksesi niin, että se sopii kaikenikäisten nähtäväksi. Et voi muuttaa tunnusta myöhemmin. Kaikki epäasiallisesti nimetyt käyttäjätunnukset suljetaan!';

  @override
  String get signupEmailHint => 'Käytämme sitä vain, jos pyydät uutta salasanaa.';

  @override
  String get password => 'Salasana';

  @override
  String get changePassword => 'Vaihda salasana';

  @override
  String get changeEmail => 'Vaihda sähköpostiosoitetta';

  @override
  String get email => 'Sähköpostiosoite';

  @override
  String get passwordReset => 'Salasanan uusiminen';

  @override
  String get forgotPassword => 'Unohditko salasanasi?';

  @override
  String get error_weakPassword => 'Tämä salasana on erittäin yleinen ja liian helppo arvata.';

  @override
  String get error_namePassword => 'Älä laita salasanaksesi käyttäjänimeäsi.';

  @override
  String get blankedPassword => 'Olet käyttänyt samaa salasanaa toisella sivustolla, ja kyseinen sivusto on vaarantunut. Sinun on asetettava uusi salasana Lichess-tunnuksesi turvallisuuden varmistamiseksi. Kiitokset ymmärtäväisyydestäsi.';

  @override
  String get youAreLeavingLichess => 'Olet poistumassa Lichessistä';

  @override
  String get neverTypeYourPassword => 'Älä koskaan kirjoita Lichess-salasanaasi toiselle sivustolle!';

  @override
  String proceedToX(String param) {
    return 'Siirry $param';
  }

  @override
  String get passwordSuggestion => 'Älä ota käyttöön jonkun toisen ehdottamaa salasanaa. Hän voi varastaa sen avulla käyttäjätunnuksesi.';

  @override
  String get emailSuggestion => 'Älä ota käyttöön jonkun toisen ehdottamaa sähköpostiosoitetta. Hän voi varastaa sen avulla käyttäjätunnuksesi.';

  @override
  String get emailConfirmHelp => 'Apua sähköpostin vahvistamiseen';

  @override
  String get emailConfirmNotReceived => 'Etkö saanut vahvistussähköpostiasi rekisteröitymisen jälkeen?';

  @override
  String get whatSignupUsername => 'Millä nimellä rekisteröidyit käyttäjäksi?';

  @override
  String usernameNotFound(String param) {
    return 'Nimellä $param ei löytynyt käyttäjää.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Voit luoda uuden tunnuksen sillä käyttäjänimellä';

  @override
  String emailSent(String param) {
    return 'Olemme lähettäneet sähköpostin osoitteeseen $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Sähköpostin saapuminen voi kestää jonkin aikaa.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Odota 5 minuuttia ja päivitä sähköpostin saapuneet-kansio.';

  @override
  String get checkSpamFolder => 'Tarkistathan myös roskapostikansiosi, koska se saattaa joutua sinne. Jos niin käy, merkitse, että viesti ei ole roskaposti.';

  @override
  String get emailForSignupHelp => 'Jos mikään muu ei auta, lähetä meille tällainen sähköposti:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopioi ja liitä yllä oleva teksti ja lähetä se osoitteeseen $param';
  }

  @override
  String get waitForSignupHelp => 'Saat pian sähköpostitse ohjeet siihen, miten voit saattaa rekisteröitymisesi loppuun.';

  @override
  String accountConfirmed(String param) {
    return 'Käyttäjän $param vahvistaminen onnistui.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Voit nyt kirjautua sisään tunnuksella $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Et tarvitse vahvistussähköpostia.';

  @override
  String accountClosed(String param) {
    return 'Käyttäjätunnus $param on suljettu.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Käyttäjätunnus $param rekisteröitiin ilman sähköpostia.';
  }

  @override
  String get rank => 'Sijoitus';

  @override
  String rankX(String param) {
    return 'Sijoitus: $param';
  }

  @override
  String get gamesPlayed => 'Pelattuja pelejä';

  @override
  String get cancel => 'Peruuta';

  @override
  String get whiteTimeOut => 'Valkealta loppui aika';

  @override
  String get blackTimeOut => 'Mustalta loppui aika';

  @override
  String get drawOfferSent => 'Tasapeliehdotus lähetetty';

  @override
  String get drawOfferAccepted => 'Tasapeliehdotus hyväksytty';

  @override
  String get drawOfferCanceled => 'Tasapeliehdotus peruttu';

  @override
  String get whiteOffersDraw => 'Valkea ehdottaa tasapeliä';

  @override
  String get blackOffersDraw => 'Musta ehdottaa tasapeliä';

  @override
  String get whiteDeclinesDraw => 'Valkea kieltäytyy tasapelistä';

  @override
  String get blackDeclinesDraw => 'Musta kieltäytyy tasapelistä';

  @override
  String get yourOpponentOffersADraw => 'Vastustajasi ehdottaa tasapeliä';

  @override
  String get accept => 'Hyväksy';

  @override
  String get decline => 'Hylkää';

  @override
  String get playingRightNow => 'Pelaamassa juuri nyt';

  @override
  String get eventInProgress => 'Parhaillaan menossa';

  @override
  String get finished => 'Päättynyt';

  @override
  String get abortGame => 'Keskeytä peli';

  @override
  String get gameAborted => 'Peli keskeytetty';

  @override
  String get standard => 'Tavallinen';

  @override
  String get customPosition => 'Itse määritetty asema';

  @override
  String get unlimited => 'Rajaton';

  @override
  String get mode => 'Tyyppi';

  @override
  String get casual => 'Rento';

  @override
  String get rated => 'Pisteytetty';

  @override
  String get casualTournament => 'Rento';

  @override
  String get ratedTournament => 'Pisteytetty';

  @override
  String get thisGameIsRated => 'Tämä peli on pisteytetty';

  @override
  String get rematch => 'Revanssi';

  @override
  String get rematchOfferSent => 'Revanssipyyntö lähetetty';

  @override
  String get rematchOfferAccepted => 'Revanssipyyntö hyväksytty';

  @override
  String get rematchOfferCanceled => 'Revanssipyyntö peruttu';

  @override
  String get rematchOfferDeclined => 'Revanssipyyntö hylätty';

  @override
  String get cancelRematchOffer => 'Hylkää revanssipyyntö';

  @override
  String get viewRematch => 'Katso revanssi';

  @override
  String get confirmMove => 'Vahvista siirto';

  @override
  String get play => 'Pelaa';

  @override
  String get inbox => 'Postilaatikko';

  @override
  String get chatRoom => 'Keskusteluhuone';

  @override
  String get loginToChat => 'Kirjaudu osallistuaksesi keskusteluun';

  @override
  String get youHaveBeenTimedOut => 'Olet jäähyllä.';

  @override
  String get spectatorRoom => 'Katsojienhuone';

  @override
  String get composeMessage => 'Luo viesti';

  @override
  String get subject => 'Aihe';

  @override
  String get send => 'Lähetä';

  @override
  String get incrementInSeconds => 'Lisäaika sekunteina';

  @override
  String get freeOnlineChess => 'Maksutonta shakkia verkossa';

  @override
  String get exportGames => 'Vie pelejä';

  @override
  String get ratingRange => 'Vahvuuslukualue';

  @override
  String get thisAccountViolatedTos => 'Tämä käyttäjätunnus rikkoi Lichessin käyttöehtoja';

  @override
  String get openingExplorerAndTablebase => 'Avausselain ja -tietokanta';

  @override
  String get takeback => 'Peruuta siirto';

  @override
  String get proposeATakeback => 'Ehdota siirron peruutusta';

  @override
  String get takebackPropositionSent => 'Siirron peruutusta ehdotettu';

  @override
  String get takebackPropositionDeclined => 'Siirron peruutuksen ehdotus hylätty';

  @override
  String get takebackPropositionAccepted => 'Siirron peruutuksen ehdotus hyväksytty';

  @override
  String get takebackPropositionCanceled => 'Siirron peruutuksen ehdotus peruttu';

  @override
  String get yourOpponentProposesATakeback => 'Vastustajasi ehdottaa siirron peruutusta';

  @override
  String get bookmarkThisGame => 'Jätä kirjanmerkki tähän peliin';

  @override
  String get tournament => 'Turnaus';

  @override
  String get tournaments => 'Turnaukset';

  @override
  String get tournamentPoints => 'Turnauspisteet';

  @override
  String get viewTournament => 'Katso turnausta';

  @override
  String get backToTournament => 'Takaisin turnaukseen';

  @override
  String get noDrawBeforeSwissLimit => 'Sveitsiläisessä turnauksessa tasapeliä ei voi sopia ennen kuin 30 siirtoa on pelattu.';

  @override
  String get thematic => 'Teemallinen';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Vahvuuslukusi $param on tilapäinen';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return '$param1-vahvuuslukusi ($param2) on liian suuri';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Viikon korkein $param1-vahvuuslukusi ($param2) on liian suuri';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return '$param1-vahvuuslukusi ($param2) ei riitä';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2-vahvuusluku ≥ $param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2-vahvuusluku ≤ $param1';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Tulee olla joukkueessa $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Et ole joukkueessa $param';
  }

  @override
  String get backToGame => 'Takaisin peliin';

  @override
  String get siteDescription => 'Ilmaista virtuaalishakkia. Pelaa shakkia selkeällä käyttöliittymällä. Ei rekisteröitymistä, ei mainoksia eikä selaimen lisäosia. Pelaa shakkia kavereita, satunnaisia vastustajia tai tekoälyä vastaan.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 liittyi joukkueeseen $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 loi joukkueen $param2';
  }

  @override
  String get startedStreaming => 'alkoi striimata';

  @override
  String xStartedStreaming(String param) {
    return '$param alkoi striimata';
  }

  @override
  String get averageElo => 'Vahvuuslukukeskiarvo';

  @override
  String get location => 'Sijainti';

  @override
  String get filterGames => 'Suodata pelejä';

  @override
  String get reset => 'Nollaa';

  @override
  String get apply => 'Ota käyttöön';

  @override
  String get save => 'Tallenna';

  @override
  String get leaderboard => 'Pistetaulukko';

  @override
  String get screenshotCurrentPosition => 'Ota tämänhetkisestä asemasta kuvakaappaus';

  @override
  String get gameAsGIF => 'Tallenna peli GIF:nä';

  @override
  String get pasteTheFenStringHere => 'Liitä FEN-merkkijono tähän';

  @override
  String get pasteThePgnStringHere => 'Liitä PGN-merkkijono tähän';

  @override
  String get orUploadPgnFile => 'Tai lataa PGN-tiedosto';

  @override
  String get fromPosition => 'Asemasta';

  @override
  String get continueFromHere => 'Jatka tästä';

  @override
  String get toStudy => 'Tutki';

  @override
  String get importGame => 'Tuo peli';

  @override
  String get importGameExplanation => 'Liitä pelin PGN, niin voit selata peliä ja saat sille tietokoneanalyysin, keskusteluhuoneen sekä URL:n, jonka voit jakaa.';

  @override
  String get importGameCaveat => 'Muunnelmat poistetaan. Jos haluat säilyttää ne, tuo PGN ensin tutkielmaan.';

  @override
  String get importGameDataPrivacyWarning => 'Tähän PGN:ään on julkinen pääsy. Käytä tutkielmaa halutessasi tuoda pelin ja pitää sen yksityisenä.';

  @override
  String get thisIsAChessCaptcha => 'Tämä on shakkivarmistus.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Tee siirtosi todistaaksesi olevasi ihminen.';

  @override
  String get captcha_fail => 'Ratkaise shakki-captcha.';

  @override
  String get notACheckmate => 'Siirto ei ole shakkimatti';

  @override
  String get whiteCheckmatesInOneMove => 'Valkean yhden siirron matti';

  @override
  String get blackCheckmatesInOneMove => 'Mustan yhden siirron matti';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get reconnecting => 'Yhdistetään uudelleen';

  @override
  String get noNetwork => 'Ei yhteyttä';

  @override
  String get favoriteOpponents => 'Suosikkivastustajat';

  @override
  String get follow => 'Seuraa';

  @override
  String get following => 'Seurataan';

  @override
  String get unfollow => 'Älä seuraa';

  @override
  String followX(String param) {
    return 'Seuraa $param';
  }

  @override
  String unfollowX(String param) {
    return 'Lopeta käyttäjän $param seuraaminen';
  }

  @override
  String get block => 'Estä';

  @override
  String get blocked => 'Estetty';

  @override
  String get unblock => 'Poista esto';

  @override
  String get followsYou => 'Seuraa sinua';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 alkoi seurata $param2';
  }

  @override
  String get more => 'Lisää';

  @override
  String get memberSince => 'Liittynyt';

  @override
  String lastSeenActive(String param) {
    return 'Nähty viimeksi $param';
  }

  @override
  String get player => 'Pelaaja';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Kaavio';

  @override
  String get required => 'Vaadittu.';

  @override
  String get openTournaments => 'Avoimet turnaukset';

  @override
  String get duration => 'Kesto';

  @override
  String get winner => 'Voittaja';

  @override
  String get standing => 'Sija';

  @override
  String get createANewTournament => 'Luo uusi turnaus';

  @override
  String get tournamentCalendar => 'Turnauskalenteri';

  @override
  String get conditionOfEntry => 'Liittymisehto:';

  @override
  String get advancedSettings => 'Lisäasetukset';

  @override
  String get safeTournamentName => 'Valitse asiallinen nimi turnaukselle.';

  @override
  String get inappropriateNameWarning => 'Hiemankin epäasiallinen nimi voi johtaa käyttäjätunnuksesi sulkemiseen.';

  @override
  String get emptyTournamentName => 'Jos jätät tyhjäksi, turnaus nimetään jonkun suurmestarin mukaan.';

  @override
  String get makePrivateTournament => 'Tee turnauksesta yksityinen ja aseta salasana, jolla siihen pääsee';

  @override
  String get join => 'Liity';

  @override
  String get withdraw => 'Peru osallistuminen';

  @override
  String get points => 'Pisteet';

  @override
  String get wins => 'Voitot';

  @override
  String get losses => 'Tappiot';

  @override
  String get createdBy => 'Tekijä:';

  @override
  String get tournamentIsStarting => 'Turnaus alkaa';

  @override
  String get tournamentPairingsAreNowClosed => 'Turnauksen peliparien määritys on päättynyt.';

  @override
  String standByX(String param) {
    return 'Ole valmiina $param, etsimme sinulle seuraavaa vastustajaa!';
  }

  @override
  String get pause => 'Pidä tauko';

  @override
  String get resume => 'Jatka';

  @override
  String get youArePlaying => 'Sinä pelaat!';

  @override
  String get winRate => 'Voittoprosentti';

  @override
  String get berserkRate => 'Berserkkiprosentti';

  @override
  String get performance => 'Suoritus';

  @override
  String get tournamentComplete => 'Turnaus päättynyt';

  @override
  String get movesPlayed => 'Siirtoja';

  @override
  String get whiteWins => 'Valkean voittoja';

  @override
  String get blackWins => 'Mustan voittoja';

  @override
  String get drawRate => 'Tasapelien osuus';

  @override
  String get draws => 'Tasapelejä';

  @override
  String nextXTournament(String param) {
    return 'Seuraava $param-turnaus:';
  }

  @override
  String get averageOpponent => 'Keskimääräinen vastustaja';

  @override
  String get boardEditor => 'Lautaeditori';

  @override
  String get setTheBoard => 'Asettele lauta';

  @override
  String get popularOpenings => 'Suosittuja avauksia';

  @override
  String get endgamePositions => 'Loppupeliasemat';

  @override
  String chess960StartPosition(String param) {
    return 'Shakki960-alkuasema: $param';
  }

  @override
  String get startPosition => 'Alkuasema';

  @override
  String get clearBoard => 'Tyhjennä lauta';

  @override
  String get loadPosition => 'Lataa asema';

  @override
  String get isPrivate => 'Yksityinen';

  @override
  String reportXToModerators(String param) {
    return 'Ilmianna $param moderaattoreille';
  }

  @override
  String profileCompletion(String param) {
    return 'Profiilia täytetty: $param';
  }

  @override
  String xRating(String param) {
    return '$param-vahvuusluku';
  }

  @override
  String get ifNoneLeaveEmpty => 'Jätä tyhjäksi jos ei ole';

  @override
  String get profile => 'Profiili';

  @override
  String get editProfile => 'Muokkaa profiilia';

  @override
  String get realName => 'Oikea nimi';

  @override
  String get setFlair => 'Valitse tyylisi';

  @override
  String get flair => 'Tyyli';

  @override
  String get youCanHideFlair => 'On olemassa asetus, jolla voit piilottaa kaikkien käyttäjien tyylit koko sivustolla.';

  @override
  String get biography => 'Kuvaus';

  @override
  String get countryRegion => 'Maa tai alue';

  @override
  String get thankYou => 'Kiitos!';

  @override
  String get socialMediaLinks => 'Sosiaalisen median linkit';

  @override
  String get oneUrlPerLine => 'Yksi URL per rivi.';

  @override
  String get inlineNotation => 'Rivinsisäinen kommentointi';

  @override
  String get makeAStudy => 'Tallenna analyysisi tutkielmaksi, jos haluat säilyttää sen tai jakaa sen muiden kanssa.';

  @override
  String get clearSavedMoves => 'Tyhjennä siirrot';

  @override
  String get previouslyOnLichessTV => 'Viimeksi Lichess TV:ssä';

  @override
  String get onlinePlayers => 'Paikalla olevat pelaajat';

  @override
  String get activePlayers => 'Aktiiviset pelaajat';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Huomaa, että peli on pisteytetty, vaikka siinä ei olekaan aikarajoitetta!';

  @override
  String get success => 'Onnistuit';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Avaa heti seuraavan pelisi tehtyäsi siirron';

  @override
  String get autoSwitch => 'Automaattinen siirtyminen';

  @override
  String get puzzles => 'Tehtävät';

  @override
  String get onlineBots => 'Online-botit';

  @override
  String get name => 'Nimi';

  @override
  String get description => 'Kuvaus';

  @override
  String get descPrivate => 'Yksityinen kuvaus';

  @override
  String get descPrivateHelp => 'Teksti, jonka vain joukkueen jäsenet näkevät. Tähän laadittu kuvaus korvaa joukkueen jäseneiden kohdalla julkisen kuvauksen.';

  @override
  String get no => 'Ei';

  @override
  String get yes => 'Kyllä';

  @override
  String get help => 'Apu:';

  @override
  String get createANewTopic => 'Luo uusi aihe';

  @override
  String get topics => 'Aiheet';

  @override
  String get posts => 'Viestit';

  @override
  String get lastPost => 'Viimeisin viesti';

  @override
  String get views => 'Katselukertoja';

  @override
  String get replies => 'Vastaukset';

  @override
  String get replyToThisTopic => 'Vastaa tähän aiheeseen';

  @override
  String get reply => 'Vastaa';

  @override
  String get message => 'Viesti';

  @override
  String get createTheTopic => 'Luo aihe';

  @override
  String get reportAUser => 'Raportoi käyttäjä';

  @override
  String get user => 'Käyttäjä';

  @override
  String get reason => 'Syy';

  @override
  String get whatIsIheMatter => 'Mikä hätänä?';

  @override
  String get cheat => 'Huijaus';

  @override
  String get troll => 'Trolli';

  @override
  String get other => 'Muu';

  @override
  String get reportDescriptionHelp => 'Liitä linkki peliin/peleihin ja kerro, mikä on pielessä tämän käyttäjän käytöksessä. Älä vain sano että \"hän huijaa\", vaan kerro meille miksi ajattelet näin. Raporttisi käydään läpi nopeammin, jos se on kirjoitettu englanniksi.';

  @override
  String get error_provideOneCheatedGameLink => 'Anna ainakin yksi linkki peliin, jossa epäilet huijaamista.';

  @override
  String by(String param) {
    return '$param';
  }

  @override
  String importedByX(String param) {
    return 'Käyttäjän $param tuoma';
  }

  @override
  String get thisTopicIsNowClosed => 'Tämä aihe on nyt suljettu.';

  @override
  String get blog => 'Blogi';

  @override
  String get notes => 'Muistiinpanot';

  @override
  String get typePrivateNotesHere => 'Kirjoita yksityisiä muistiinpanoja tähän';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Kirjoita tätä käyttäjää koskeva yksityinen muistiinpano';

  @override
  String get noNoteYet => 'Ei vielä muistiinpanoja';

  @override
  String get invalidUsernameOrPassword => 'Virheellinen käyttäjätunnus tai salasana';

  @override
  String get incorrectPassword => 'Salasana ei kelpaa';

  @override
  String get invalidAuthenticationCode => 'Tunnistautumiskoodi ei kelpaa';

  @override
  String get emailMeALink => 'Lähetä minulle linkki';

  @override
  String get currentPassword => 'Nykyinen salasana';

  @override
  String get newPassword => 'Uusi salasana';

  @override
  String get newPasswordAgain => 'Varmista uusi salasana';

  @override
  String get newPasswordsDontMatch => 'Uudet salasanat eivät täsmää';

  @override
  String get newPasswordStrength => 'Salasanan vahvuus';

  @override
  String get clockInitialTime => 'Alkuaika';

  @override
  String get clockIncrement => 'Lisäaika';

  @override
  String get privacy => 'Yksityisyys';

  @override
  String get privacyPolicy => 'tietosuojakäytännöstämme';

  @override
  String get letOtherPlayersFollowYou => 'Anna muiden pelaajien seurata sinua';

  @override
  String get letOtherPlayersChallengeYou => 'Anna muiden pelaajien haastaa sinut';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Salli muiden pelaajien kutsua sinut tutkielmiin';

  @override
  String get sound => 'Äänet';

  @override
  String get none => 'Ei ollenkaan';

  @override
  String get fast => 'Nopea';

  @override
  String get normal => 'Normaali';

  @override
  String get slow => 'Hidas';

  @override
  String get insideTheBoard => 'Laudan sisäpuolella';

  @override
  String get outsideTheBoard => 'Laudan ulkopuolella';

  @override
  String get allSquaresOfTheBoard => 'Kaikki laudan ruudut';

  @override
  String get onSlowGames => 'Hitaissa peleissä';

  @override
  String get always => 'Aina';

  @override
  String get never => 'Ei koskaan';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 kilpailee turnauksessa $param2';
  }

  @override
  String get victory => 'Voitto';

  @override
  String get defeat => 'Tappio';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 $param3-pelissä $param2 vastaan';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vastustajalta $param2 pelissä $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vastustajaa $param2 vastaan pelissä $param3';
  }

  @override
  String get timeline => 'Tapahtunutta aikajärjestyksessä';

  @override
  String get starting => 'Alkamassa:';

  @override
  String get allInformationIsPublicAndOptional => 'Kaikki informaatio on julkista ja vapaaehtoista.';

  @override
  String get biographyDescription => 'Kerro itsestäsi, parhaista asioista shakissa tai suosikkiavauksistasi, -peleistäsi, -pelaajistasi…';

  @override
  String get listBlockedPlayers => 'Torjutut pelaajat';

  @override
  String get human => 'Ihminen';

  @override
  String get computer => 'Tietokone';

  @override
  String get side => 'Puoli';

  @override
  String get clock => 'Kello';

  @override
  String get opponent => 'Vastapelaaja';

  @override
  String get learnMenu => 'Opi';

  @override
  String get studyMenu => 'Tutki';

  @override
  String get practice => 'Harjoittele';

  @override
  String get community => 'Yhteisö';

  @override
  String get tools => 'Työkalut';

  @override
  String get increment => 'Lisäaika';

  @override
  String get error_unknown => 'Virheellinen arvo';

  @override
  String get error_required => 'Tämä kenttä vaaditaan';

  @override
  String get error_email => 'Sähköpostiosoite on virheellinen';

  @override
  String get error_email_acceptable => 'Sähköpostiosoite ei ole kelvollinen. Tarkista se, ja yritä uudelleen.';

  @override
  String get error_email_unique => 'Sähköpostiosoite on virheellinen tai jo käytössä';

  @override
  String get error_email_different => 'Tämä on jo nyt sähköpostiosoitteesi';

  @override
  String error_minLength(String param) {
    return 'Vähimmäispituus on $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Enimmäispituus on $param';
  }

  @override
  String error_min(String param) {
    return 'Luvun on oltava vähintään $param';
  }

  @override
  String error_max(String param) {
    return 'Luvun on oltava enintään $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Jos vahvuusluku on ± $param';
  }

  @override
  String get ifRegistered => 'Vain rekisteröityneet';

  @override
  String get onlyExistingConversations => 'Vain jo aloitettuihin keskusteluihin';

  @override
  String get onlyFriends => 'Vain kaverit';

  @override
  String get menu => 'Valikko';

  @override
  String get castling => 'Linnoitus';

  @override
  String get whiteCastlingKingside => 'Valkea O-O';

  @override
  String get blackCastlingKingside => 'Musta O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Pelaamiseen käytetty aika: $param';
  }

  @override
  String get watchGames => 'Katso pelejä';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Aika TV:ssä: $param';
  }

  @override
  String get watch => 'Katso';

  @override
  String get videoLibrary => 'Videokirjasto';

  @override
  String get streamersMenu => 'Striimaajat';

  @override
  String get mobileApp => 'Mobiilisovellus';

  @override
  String get webmasters => 'Ylläpitäjät';

  @override
  String get about => 'Tietoa sivustosta';

  @override
  String aboutX(String param) {
    return 'Tietoa $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 on ilmainen ($param2), vapaa ja mainokseton avoimen lähdekoodin shakkipalvelin.';
  }

  @override
  String get really => 'oikeasti';

  @override
  String get contribute => 'Osallistu';

  @override
  String get termsOfService => 'Käyttöehdot';

  @override
  String get sourceCode => 'Lähdekoodi';

  @override
  String get simultaneousExhibitions => 'Simultaanit';

  @override
  String get host => 'Isäntä';

  @override
  String hostColorX(String param) {
    return 'Isännän väri: $param';
  }

  @override
  String get yourPendingSimuls => 'Odottavat simultaanisi';

  @override
  String get createdSimuls => 'Äskettäin luodut simultaanit';

  @override
  String get hostANewSimul => 'Pidä uusi simultaani';

  @override
  String get signUpToHostOrJoinASimul => 'Kirjaudu niin voit antaa simultaanin tai liittyä sellaiseen';

  @override
  String get noSimulFound => 'Simultaania ei löydy';

  @override
  String get noSimulExplanation => 'Tätä simultaania ei ole olemassa.';

  @override
  String get returnToSimulHomepage => 'Palaa simultaanin kotisivulle';

  @override
  String get aboutSimul => 'Simultaaneissa yksi pelaaja pelaa useampaa pelaajaa vastaan samanaikaisesti.';

  @override
  String get aboutSimulImage => '50 vastustajastaan Fischer voitti 47, pelasi kahdesti tasan ja hävisi yhden.';

  @override
  String get aboutSimulRealLife => 'Simultaanien käsite on otettu netin ulkopuolisista tapahtumista; niissä simultaaninäytöksen antaja liikkuu pöydältä toiselle pelaten siirron kerrallaan.';

  @override
  String get aboutSimulRules => 'Kun simultaani alkaa, jokainen pelaaja aloittaa pelin simultaanin pitäjää vastaan. Simultaanin pitäjä pelaa valkeilla nappuloilla. Simultaani loppuu, kun kaikki pelit ovat loppuneet.';

  @override
  String get aboutSimulSettings => 'Simultaanit ovat aina rentoja. Revanssit, siirtojen perumiset ja ajan lisääminen ovat pois käytöstä.';

  @override
  String get create => 'Luo';

  @override
  String get whenCreateSimul => 'Jos luot simultaanin, sinun täytyy pelata useita pelaajia vastaan kerralla.';

  @override
  String get simulVariantsHint => 'Jos valitset useita variantteja, jokainen pelaaja valitsee mihin osallistuu.';

  @override
  String get simulClockHint => 'Fischer-kellon asetukset. Mitä enemmän pelaajia on, sitä enemmän aikaa saatat tarvita.';

  @override
  String get simulAddExtraTime => 'Voit lisätä aikaa kelloosi selviytyäksesi simultaanista.';

  @override
  String get simulHostExtraTime => 'Isännän ylimääräinen aika';

  @override
  String get simulAddExtraTimePerPlayer => 'Lisää alussa kelloosi aikaa jokaista simultaaniin liittyvää pelaajaa kohden.';

  @override
  String get simulHostExtraTimePerPlayer => 'Lisää jokaista pelaajaa kohden isännän kelloon lisää aikaa';

  @override
  String get lichessTournaments => 'Lichessin turnaukset';

  @override
  String get tournamentFAQ => 'Areenaturnausten FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Aika ennen turnauksen alkua';

  @override
  String get averageCentipawnLoss => 'Keskimääräinen sadasosasotilaan menetys';

  @override
  String get accuracy => 'Tarkkuus';

  @override
  String get keyboardShortcuts => 'Pikanäppäimet';

  @override
  String get keyMoveBackwardOrForward => 'siirry eteenpäin/taaksepäin';

  @override
  String get keyGoToStartOrEnd => 'siirry alkuun/loppuun';

  @override
  String get keyCycleSelectedVariation => 'Vaihda valittu muunnelma';

  @override
  String get keyShowOrHideComments => 'näytä/piilota kommentit';

  @override
  String get keyEnterOrExitVariation => 'lisää/poista muunnelma';

  @override
  String get keyRequestComputerAnalysis => 'Pyydä tietokoneanalyysiä, opi virheistäsi';

  @override
  String get keyNextLearnFromYourMistakes => 'Seuraava (Opi virheistäsi)';

  @override
  String get keyNextBlunder => 'Seuraava vakava virhe';

  @override
  String get keyNextMistake => 'Seuraava virhe';

  @override
  String get keyNextInaccuracy => 'Seuraava epätarkkuus';

  @override
  String get keyPreviousBranch => 'Edellinen haara';

  @override
  String get keyNextBranch => 'Seuraava haara';

  @override
  String get toggleVariationArrows => 'Muunnelmanuolet päälle/pois';

  @override
  String get cyclePreviousOrNextVariation => 'Siirry edelliseen/seuraavaan muunnelmaan';

  @override
  String get toggleGlyphAnnotations => 'Symbolikommentit päälle/pois';

  @override
  String get togglePositionAnnotations => 'Aseman kommentit päälle/pois';

  @override
  String get variationArrowsInfo => 'Muunnelmanuolia napsauttamalla voit edetä muunnelmissa siirtolistaa käyttämättä.';

  @override
  String get playSelectedMove => 'tee valittu siirto';

  @override
  String get newTournament => 'Uusi turnaus';

  @override
  String get tournamentHomeTitle => 'Shakkiturnaus, jossa on monia aikarajoja ja variantteja';

  @override
  String get tournamentHomeDescription => 'Pelaa nopeita shakkiturnauksia! Osallistu aikataulutettuihin turnauksiin tai luo omasi. Tarjolla monia variantteja loputtomaan hauskanpitoon: Bullet, Pikapeli, Klassinen, Shakki960, King of the Hill, Threecheck ja paljon muuta.';

  @override
  String get tournamentNotFound => 'Turnausta ei löydy';

  @override
  String get tournamentDoesNotExist => 'Tätä turnausta ei ole olemassa.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Se on saatettua perua, jos kaikki pelaajat poistuivat turnauksesta ennen sen alkamista.';

  @override
  String get returnToTournamentsHomepage => 'Palaa turnausten aloitussivulle';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Viikoittainen pelaajien vahvuuslukujakauma ($param)';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Sinun $param1-vahvuuslukusi on $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Olet parempi kuin $param1 $param2-pelaajista.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 on parempi kuin $param2 $param3-pelaajista.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Parempi kuin $param1 $param2 -pelaajista';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Sinulla ei ole luotettavaa $param-vahvuuslukua.';
  }

  @override
  String get yourRating => 'Vahvuuslukusi';

  @override
  String get cumulative => 'Kumulatiivinen';

  @override
  String get glicko2Rating => 'Glicko-2 -vahvuusluku';

  @override
  String get checkYourEmail => 'Tarkista sähköpostisi';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Olemme lähettäneet sinulle sähköpostiviestin. Klikkaa viestissä olevaa linkkiä aktivoidaksesi käyttäjätunnuksesi.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Jos et näe viestiä, tarkista muut paikat joihin se voi olla joutunut (kuten roskaposti- ja spämmikansiot).';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Olemme lähettäneet sähköpostiviestin osoitteeseen $param. Klikkaa viestissä olevaa linkkiä nollataksesi salasanasi.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Rekisteröitymällä hyväksyt Lichessin $param ja sitoudut noudattamaan niitä.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lue lisää $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Verkkoviive sinun ja lichessin välillä';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Palvelimen siirtojen käsittelyyn vaatima aika';

  @override
  String get downloadAnnotated => 'Lataa kommenttien kanssa';

  @override
  String get downloadRaw => 'Lataa ilman kommentteja';

  @override
  String get downloadImported => 'Imuroi tuotu PGN';

  @override
  String get crosstable => 'Pistetaulukko';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Voit kelata siirtoja myös hiiren vieritysrullalla.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Esikatsele tietokoneen muunnelmia viemällä hiiren osoitin niiden päälle.';

  @override
  String get analysisShapesHowTo => 'Käytä hiiren kakkospainiketta (tai shiftiä ja ykköspainiketta) piirtääksesi ympyröitä ja nuolia laudalle.';

  @override
  String get letOtherPlayersMessageYou => 'Anna muiden käyttäjien lähettää sinulle viestejä';

  @override
  String get receiveForumNotifications => 'Lähetä ilmoitus, kun minut mainitaan foorumissa';

  @override
  String get shareYourInsightsData => 'Jaa Insights-tietosi';

  @override
  String get withNobody => 'Ei kenellekään';

  @override
  String get withFriends => 'Kavereille';

  @override
  String get withEverybody => 'Kaikille';

  @override
  String get kidMode => 'Lapsitila';

  @override
  String get kidModeIsEnabled => 'Lapsitila on käytössä.';

  @override
  String get kidModeExplanation => 'Turvallisuusasia. Lapsitilassa kaikki kommunikointi sivustolla on pois käytöstä. Käytä tätä suojaamaan lasta tai koululaista muilta internetin käyttäjiltä.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Lapsitilassa Lichessin logoon liitetään $param-kuvake, josta tiedät lastesi olevan turvassa.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Käyttäjätunnuksesi on hallinnassa. Lapsitilan poistoa voit pyytää shakkiopettajaltasi.';

  @override
  String get enableKidMode => 'Lapsitila käyttöön';

  @override
  String get disableKidMode => 'Lapsitila käytöstä';

  @override
  String get security => 'Turvallisuus';

  @override
  String get sessions => 'Istunnot';

  @override
  String get revokeAllSessions => 'katkaista kaikki sessiot';

  @override
  String get playChessEverywhere => 'Pelaa shakkia kaikkialla';

  @override
  String get asFreeAsLichess => 'Yhtä ilmainen ja vapaa kuin lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Rakennettu rakkaudesta shakkiin, ei rahaan';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Jokainen saa kaikki ominaisuudet ilmaiseksi';

  @override
  String get zeroAdvertisement => 'Ei mainoksia';

  @override
  String get fullFeatured => 'Kaikki ominaisuudet';

  @override
  String get phoneAndTablet => 'Puhelin ja tabletti';

  @override
  String get bulletBlitzClassical => 'Bullet, pikapeli, klassinen';

  @override
  String get correspondenceChess => 'Kirjeshakki';

  @override
  String get onlineAndOfflinePlay => 'Online- ja offline-peli';

  @override
  String get viewTheSolution => 'Katso ratkaisu';

  @override
  String get followAndChallengeFriends => 'Seuraa ja haasta kavereitasi';

  @override
  String get gameAnalysis => 'Pelianalyysi';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 isännöi $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 liittyi $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 tykkää $param2';
  }

  @override
  String get quickPairing => 'Nopeasti peliin';

  @override
  String get lobby => 'Aula';

  @override
  String get anonymous => 'Nimetön';

  @override
  String yourScore(String param) {
    return 'Pisteesi: $param';
  }

  @override
  String get language => 'Kieli';

  @override
  String get background => 'Tausta';

  @override
  String get light => 'Vaalea';

  @override
  String get dark => 'Tumma';

  @override
  String get transparent => 'Läpinäkyvä';

  @override
  String get deviceTheme => 'Laitteen teema';

  @override
  String get backgroundImageUrl => 'Taustakuvan URL:';

  @override
  String get board => 'Lauta';

  @override
  String get size => 'Koko';

  @override
  String get opacity => 'Peittävyys';

  @override
  String get brightness => 'Kirkkaus';

  @override
  String get hue => 'Värisävy';

  @override
  String get boardReset => 'Palauta oletusvärit';

  @override
  String get pieceSet => 'Nappuloiden tyyli';

  @override
  String get embedInYourWebsite => 'Upota sivustollesi';

  @override
  String get usernameAlreadyUsed => 'Käyttäjänimi varattu, kokeile jotain toista.';

  @override
  String get usernamePrefixInvalid => 'Käyttäjänimen täytyy alkaa kirjaimella.';

  @override
  String get usernameSuffixInvalid => 'Käyttäjänimen täytyy loppua kirjaimeen tai numeroon.';

  @override
  String get usernameCharsInvalid => 'Käyttäjänimi voi sisältää vain kirjaimia, numeroita, alaviivoja ja väliviivoja.';

  @override
  String get usernameUnacceptable => 'Käyttäjänimi ei kelpaa.';

  @override
  String get playChessInStyle => 'Tyylikästä shakinpeluuta';

  @override
  String get chessBasics => 'Shakin perusteet';

  @override
  String get coaches => 'Valmentajat';

  @override
  String get invalidPgn => 'PGN ei kelpaa';

  @override
  String get invalidFen => 'FEN ei kelpaa';

  @override
  String get custom => 'Mukautettu';

  @override
  String get notifications => 'Ilmoitukset';

  @override
  String notificationsX(String param1) {
    return 'Ilmoitukset: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Vahvuusluku: $param';
  }

  @override
  String get practiceWithComputer => 'Harjoittele tietokonetta vastaan';

  @override
  String anotherWasX(String param) {
    return 'Hyvä oli myös $param';
  }

  @override
  String bestWasX(String param) {
    return 'Paras oli $param';
  }

  @override
  String get youBrowsedAway => 'Selailit pois';

  @override
  String get resumePractice => 'Jatka harjoitusta';

  @override
  String get drawByFiftyMoves => 'Peli päättyi tasapeliin 50 siirron säännön perusteella.';

  @override
  String get theGameIsADraw => 'Peli on tasapeli.';

  @override
  String get computerThinking => 'Tietokone miettii...';

  @override
  String get seeBestMove => 'Katso paras siirto';

  @override
  String get hideBestMove => 'Piilota paras siirto';

  @override
  String get getAHint => 'Haluan vihjeen';

  @override
  String get evaluatingYourMove => 'Siirtoasi arvioidaan...';

  @override
  String get whiteWinsGame => 'Valkea voittaa';

  @override
  String get blackWinsGame => 'Musta voittaa';

  @override
  String get learnFromYourMistakes => 'Opi virheistäsi';

  @override
  String get learnFromThisMistake => 'Opi tästä virheestä';

  @override
  String get skipThisMove => 'Ohita tämä siirto';

  @override
  String get next => 'Seuraava';

  @override
  String xWasPlayed(String param) {
    return '$param pelattiin';
  }

  @override
  String get findBetterMoveForWhite => 'Keksi parempi valkean siirto';

  @override
  String get findBetterMoveForBlack => 'Keksi parempi mustan siirto';

  @override
  String get resumeLearning => 'Jatka oppimista';

  @override
  String get youCanDoBetter => 'Parempikin löytyy';

  @override
  String get tryAnotherMoveForWhite => 'Kokeile muuta valkean siirtoa';

  @override
  String get tryAnotherMoveForBlack => 'Kokeile muuta mustan siirtoa';

  @override
  String get solution => 'Ratkaisu';

  @override
  String get waitingForAnalysis => 'Analyysi käynnissä';

  @override
  String get noMistakesFoundForWhite => 'Ei löytynyt valkean virheitä';

  @override
  String get noMistakesFoundForBlack => 'Ei löytynyt mustan virheitä';

  @override
  String get doneReviewingWhiteMistakes => 'Olet käynyt läpi valkean virheet';

  @override
  String get doneReviewingBlackMistakes => 'Olet käynyt läpi mustan virheet';

  @override
  String get doItAgain => 'Sama uudelleen';

  @override
  String get reviewWhiteMistakes => 'Tarkastele valkean virheitä';

  @override
  String get reviewBlackMistakes => 'Tarkastele mustan virheitä';

  @override
  String get advantage => 'Etu';

  @override
  String get opening => 'Avausvaihe';

  @override
  String get middlegame => 'Keskipeli';

  @override
  String get endgame => 'Loppupeli';

  @override
  String get conditionalPremoves => 'Ehdolliset esisiirrot';

  @override
  String get addCurrentVariation => 'Lisää nykyinen muunnelma';

  @override
  String get playVariationToCreateConditionalPremoves => 'Luo ehdollisia esisiirtoja pelaamalla muunnelma';

  @override
  String get noConditionalPremoves => 'Ei ehdollisia esisiirtoja';

  @override
  String playX(String param) {
    return 'Siirrä $param';
  }

  @override
  String get showUnreadLichessMessage => 'Olet saanut henkilökohtaisen viestin Lichessiltä.';

  @override
  String get clickHereToReadIt => 'Lue se napsauttamalla tästä';

  @override
  String get sorry => 'Pahoittelumme :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Meidän täytyi komentaa sinut jäähylle hetkeksi.';

  @override
  String get why => 'Miksi?';

  @override
  String get pleasantChessExperience => 'Haluamme tarjota mukavan shakkielämyksen kaikille.';

  @override
  String get goodPractice => 'Siksi meidän on huolehdittava siitä, että kaikki käyttäytyvät asiallisesti.';

  @override
  String get potentialProblem => 'Kun mahdollinen ongelma havaitaan, näytämme tämän viestin.';

  @override
  String get howToAvoidThis => 'Kuinka voit välttää tämän?';

  @override
  String get playEveryGame => 'Pelaa loppuun jokainen aloittamasi peli.';

  @override
  String get tryToWin => 'Yritä voittaa (tai edes pelata tasan) jokainen pelisi.';

  @override
  String get resignLostGames => 'Luovuta hävityt pelit (äläkä anna ajan kulua loppuun).';

  @override
  String get temporaryInconvenience => 'Pahoittelemme tilapäistä harmia,';

  @override
  String get wishYouGreatGames => 'ja toivotamme hyviä pelejä lichess.org -sivustolla.';

  @override
  String get thankYouForReading => 'Kiitos, että luit tämän!';

  @override
  String get lifetimeScore => 'Kaikkien aikojen yhteistilanne';

  @override
  String get currentMatchScore => 'Nykyisen ottelun tilanne';

  @override
  String get agreementAssistance => 'Vakuutan etten ota vastaan ulkopuolista apua pelieni aikana (shakkitietokoneilta, kirjoilta, tietokannoilta enkä muilta ihmisiltä).';

  @override
  String get agreementNice => 'Vakuutan että käyttäydyn aina muita pelaajia kunnioittaen.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Hyväksyn, että en luo useampaa kuin yhtä käyttäjätunnusta (paitsi kohdassa $param mainituista syistä).';
  }

  @override
  String get agreementPolicy => 'Vakuutan että noudatan Lichessin sääntöjä.';

  @override
  String get searchOrStartNewDiscussion => 'Hae tai aloita uusi keskustelu';

  @override
  String get edit => 'Muokkaa';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Pikapeli';

  @override
  String get rapid => 'Nopea';

  @override
  String get classical => 'Klassinen';

  @override
  String get ultraBulletDesc => 'Järjettömän nopeat pelit: alle 30 sekuntia';

  @override
  String get bulletDesc => 'Hyvin nopeat pelit: alle 3 minuuttia';

  @override
  String get blitzDesc => 'Pikapelit: 3-8 minuuttia';

  @override
  String get rapidDesc => 'Nopeat pelit: 8-25 minuuttia';

  @override
  String get classicalDesc => 'Klassiset pelit: 25 minuuttia tai enemmän';

  @override
  String get correspondenceDesc => 'Kirjeshakkipelit: yksi tai useampi päivä per siirto';

  @override
  String get puzzleDesc => 'Taktiikkaharjoittelu';

  @override
  String get important => 'Tärkeää';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Kysymykseesi saattaa jo löytyä vastaus $param1';
  }

  @override
  String get inTheFAQ => 'FAQ:sta';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Toisen käyttäjän huijauksesta tai huonosta käytöksestä voit ilmoittaa $param1';
  }

  @override
  String get useTheReportForm => 'ilmoituslomakkeella';

  @override
  String toRequestSupport(String param1) {
    return 'Ongelmiin voit pyytää apua $param1';
  }

  @override
  String get tryTheContactPage => 'yhteydenottosivulta';

  @override
  String makeSureToRead(String param1) {
    return 'Lue ensi töiksesi $param1';
  }

  @override
  String get theForumEtiquette => 'foorumin etiketti';

  @override
  String get thisTopicIsArchived => 'Tämä aihe on arkistoitu, eikä siihen voi enää vastata.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Kirjoittaaksesi tähän foorumiin sinun on liityttävä $param1';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 -joukkueeseen';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Et voi vielä lähettää viestejä foorumeihin. Pelaa ensin muutama peli!';

  @override
  String get subscribe => 'Tilaa';

  @override
  String get unsubscribe => 'Peruuta tilaus';

  @override
  String mentionedYouInX(String param1) {
    return 'mainitsi sinut \"$param1\":ssa.';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 mainitsi sinut viestissä \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'kutsui sinut tutkielmaan \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 kutsui sinut tutkielmaan \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Olet nyt joukkueen jäsen.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Olet liittynyt joukkueeseen \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Ilmoittamasi pelaaja on saanut porttikiellon';

  @override
  String get congratsYouWon => 'Onnittelut, sinä voitit!';

  @override
  String gameVsX(String param1) {
    return 'Peli käyttäjää $param1 vastaan';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vastaan $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Olet hävinnyt Lichessin käyttöehtoja rikkoneelle henkilölle';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Hyvitys: $param1 $param2 vahvuuslukupistettä.';
  }

  @override
  String get timeAlmostUp => 'Aika on melkein lopussa!';

  @override
  String get clickToRevealEmailAddress => '[Paljasta sähköpostiosoite napsauttamalla tästä]';

  @override
  String get download => 'Lataa';

  @override
  String get coachManager => 'Valmentaja-asetukset';

  @override
  String get streamerManager => 'Striimausasetukset';

  @override
  String get cancelTournament => 'Peruuta turnaus';

  @override
  String get tournDescription => 'Turnauksen kuvaus';

  @override
  String get tournDescriptionHelp => 'Haluatko kertoa osallistujille jotain erityistä? Kerro se lyhyesti ja ytimekkäästi. Voit käyttää markdown-linkkejä: [name](https://url)';

  @override
  String get ratedFormHelp => 'Pelit pisteytetään ja niillä on\nvaikutus pelaajien vahvuuslukuihin';

  @override
  String get onlyMembersOfTeam => 'Vain joukkueen jäsenet';

  @override
  String get noRestriction => 'Ei rajoituksia';

  @override
  String get minimumRatedGames => 'Pisteytettyjä pelejä vähintään';

  @override
  String get minimumRating => 'Vahvuusluku vähintään';

  @override
  String get maximumWeeklyRating => 'Viikoittainen vahvuusluku enintään';

  @override
  String positionInputHelp(String param) {
    return 'Liitä tähän FEN-koodi, jos haluat jokaisen pelin alkavan tietystä asemasta.\nSe toimii vain tavallisissa peleissä, ei varianteissa.\nVoit luoda aseman ${param}lla ja kopioida FEN-koodin sieltä tänne.\nJätä kenttä tyhjäksi, jos haluat pelien alkavan normaalista alkuasemasta.';
  }

  @override
  String get cancelSimul => 'Peruuta simultaani';

  @override
  String get simulHostcolor => 'Isännän väri joka pelissä';

  @override
  String get estimatedStart => 'Arvioitu alkamisaika';

  @override
  String simulFeatured(String param) {
    return 'Näytä sivulla $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Näytä simultaanisi kaikille ${param}lla. Poista valinta pitääksesi simultaanin yksityisenä.';
  }

  @override
  String get simulDescription => 'Simultaanin kuvaus';

  @override
  String get simulDescriptionHelp => 'Haluatko kertoa osallistujille jotain?';

  @override
  String markdownAvailable(String param) {
    return 'Tekstin yksityiskohtaisempaan muotoiluun voit käyttää $param-kieltä.';
  }

  @override
  String get embedsAvailable => 'Voit upottaa pelin tai tutkielman kappaleen liittämällä sen URL-osoitteen.';

  @override
  String get inYourLocalTimezone => 'Omalla aikavyöhykkeelläsi';

  @override
  String get tournChat => 'Turnauksen keskusteluhuone';

  @override
  String get noChat => 'Ei keskustelua';

  @override
  String get onlyTeamLeaders => 'Vain joukkueenjohtajille';

  @override
  String get onlyTeamMembers => 'Vain joukkueen jäsenille';

  @override
  String get navigateMoveTree => 'Siirtolistalla liikkuminen';

  @override
  String get mouseTricks => 'Hiiritoiminnot';

  @override
  String get toggleLocalAnalysis => 'Paikallinen tietokoneanalyysi päälle/pois';

  @override
  String get toggleAllAnalysis => 'Kaikki tietokoneanalyysi päälle/pois';

  @override
  String get playComputerMove => 'Pelaa tietokoneen paras siirto';

  @override
  String get analysisOptions => 'Analyysiasetukset';

  @override
  String get focusChat => 'Kohdista keskusteluun';

  @override
  String get showHelpDialog => 'Näytä tämä ohjevalintaikkuna';

  @override
  String get reopenYourAccount => 'Avaa käyttäjätunnuksesi uudelleen';

  @override
  String get closedAccountChangedMind => 'Jos olet sulkenut käyttäjätunnuksesi mutta sen jälkeen muuttanut mieltäsi, saat yhden mahdollisuuden palauttaa tunnuksesi.';

  @override
  String get onlyWorksOnce => 'Tämä toimii vain kerran.';

  @override
  String get cantDoThisTwice => 'Jos suljet tunnuksesi toisen kerran, sitä ei voi palauttaa enää millään tavalla.';

  @override
  String get emailAssociatedToaccount => 'Tunnukseen kuuluva sähköpostiosoite';

  @override
  String get sentEmailWithLink => 'Olemme lähettäneet sinulle sähköpostin, jossa on linkki.';

  @override
  String get tournamentEntryCode => 'Turnauksen sisäänpääsykoodi';

  @override
  String get hangOn => 'Hetkinen!';

  @override
  String gameInProgress(String param) {
    return 'Sinulla on peli meneillään pelaajan $param kanssa.';
  }

  @override
  String get abortTheGame => 'Keskeytä peli';

  @override
  String get resignTheGame => 'Luovuta peli';

  @override
  String get youCantStartNewGame => 'Et voi aloittaa uutta peliä ennen kuin tämä peli on päättynyt.';

  @override
  String get since => 'Alkaen';

  @override
  String get until => 'Saakka';

  @override
  String get lichessDbExplanation => 'Lichessin kaikkien pelaajien pisteytetyt pelit';

  @override
  String get switchSides => 'Vaihda puolta';

  @override
  String get closingAccountWithdrawAppeal => 'Jos suljet tunnuksesi, valituksesi raukeaa';

  @override
  String get ourEventTips => 'Meidän vinkkimme tapahtumien järjestämiseen';

  @override
  String get instructions => 'Ohjeet';

  @override
  String get showMeEverything => 'Näytä kaikki';

  @override
  String get lichessPatronInfo => 'Lichess on hyväntekeväisyysjärjestö ja täysin ilmainen avoimen lähdekoodin ohjelmisto.\nKaikki toimintakustannukset, kehitystyö ja sisältö rahoitetaan yksinomaan käyttäjien lahjoituksilla.';

  @override
  String get nothingToSeeHere => 'Täällä ei ole tällä hetkellä mitään nähtävää.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vastustajasi on poistunut pelistä. Voit julistautua voittajaksi $count sekunnin kuluttua.',
      one: 'Vastustajasi on poistunut pelistä. Voit julistautua voittajaksi $count sekunnin kuluttua.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matti $count puolisiirrolla',
      one: 'Matti $count puolisiirrolla',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vakavaa virhettä',
      one: '$count vakava virhe',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count virhettä',
      one: '$count virhe',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count epätarkkuutta',
      one: '$count epätarkkuus',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pelaajaa',
      one: '$count pelaaja',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count peliä pelattu',
      one: '$count peliä pelattu',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-vahvuusluku $param2 pelistä',
      one: '$count-vahvuusluku $param2 pelistä',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count omaa kirjanmerkkiä',
      one: '$count oma kirjanmerkki',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count päivää',
      one: '$count päivä',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tuntia',
      one: '$count tunti',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuuttia',
      one: '$count minuutti',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sijoitus päivitetään $count minuutin välein',
      one: 'Sijoitus päivitetään joka minuutti',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tehtävää',
      one: '$count tehtävä',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pelejä kanssasi',
      one: '$count pelejä kanssasi',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pisteytettyä',
      one: '$count pisteytetty',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voittoa',
      one: '$count voittoa',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count häviötä',
      one: '$count häviötä',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasapeliä',
      one: '$count tasapeliä',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meneillään',
      one: '$count meneillään',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anna $count sekuntia',
      one: 'Anna $count sekuntia',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnauspistettä',
      one: '$count turnauspiste',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '­$count tutkielmaa',
      one: '$count tutkielma',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultaania',
      one: '$count simultaani',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count pisteytettyä peliä',
      one: '≥ $count pisteytetty peli',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count pisteytettyä $param2-peliä',
      one: '≥ $count pisteytetty $param2-peli',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sinun pitää pelata vielä $count pisteytettyä $param2-peliä',
      one: 'Sinun pitää pelata vielä $count pisteytetty $param2-peli',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sinun täytyy pelata vielä $count pisteytettyä peliä',
      one: 'Sinun täytyy pelata vielä $count pisteytetty peli',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tuotua peliä',
      one: '$count Tuotua peliä',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaveria paikalla',
      one: '$count kaveri paikalla',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seuraajaa',
      one: '$count seuraaja',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seurattua',
      one: '$count seurattua',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count minuuttia',
      one: 'Alle $count minuutti',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count peliä meneillään',
      one: '$count peliä meneillään',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimi: $count merkkiä.',
      one: 'Maksimi: $count merkkiä.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estettyä pelaajaa',
      one: '$count estettyä pelaajaa',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foorumiviestiä',
      one: '$count foorumiviesti',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2-pelaajaa tällä viikolla.',
      one: '$count $param2-pelaaja tällä viikolla.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saatavilla $count eri kielellä!',
      one: 'Saatavilla $count eri kielellä!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekuntia aikaa pelata ensimmäinen siirto',
      one: '$count sekuntia aikaa pelata ensimmäinen siirto',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekuntia',
      one: '$count sekunti',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ja tallenna $count esisiirtolinjaa',
      one: 'ja tallenna $count esisiirtolinja',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Aloita tekemällä siirto';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Pelaat kaikissa tehtävissä valkeilla';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Pelaat kaikissa tehtävissä mustilla';

  @override
  String get stormPuzzlesSolved => 'tehtävää ratkaistu';

  @override
  String get stormNewDailyHighscore => 'Päivän uusi ennätys!';

  @override
  String get stormNewWeeklyHighscore => 'Viikon uusi ennätys!';

  @override
  String get stormNewMonthlyHighscore => 'Kuukauden uusi ennätys!';

  @override
  String get stormNewAllTimeHighscore => 'Uusi kaikkien aikojen ennätys!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Edellinen ennätys oli $param';
  }

  @override
  String get stormPlayAgain => 'Pelaa uudelleen';

  @override
  String stormHighscoreX(String param) {
    return 'Paras tulos: $param';
  }

  @override
  String get stormScore => 'Pisteet';

  @override
  String get stormMoves => 'Siirtoja';

  @override
  String get stormAccuracy => 'Tarkkuus';

  @override
  String get stormCombo => 'Putki';

  @override
  String get stormTime => 'Aika';

  @override
  String get stormTimePerMove => 'Aika per siirto';

  @override
  String get stormHighestSolved => 'Vaikein ratkaistu';

  @override
  String get stormPuzzlesPlayed => 'Tehdyt tehtävät';

  @override
  String get stormNewRun => 'Uusi sarja (pikanäppäin: välilyönti)';

  @override
  String get stormEndRun => 'Lopeta sarja (pikanäppäin: Enter)';

  @override
  String get stormHighscores => 'Ennätykset';

  @override
  String get stormViewBestRuns => 'Näytä parhaat sarjat';

  @override
  String get stormBestRunOfDay => 'Päivän paras sarja';

  @override
  String get stormRuns => 'Sarjoja';

  @override
  String get stormGetReady => 'Ole valmiina!';

  @override
  String get stormWaitingForMorePlayers => 'Odotetaan lisää pelaajia mukaan...';

  @override
  String get stormRaceComplete => 'Kisa on päättynyt!';

  @override
  String get stormSpectating => 'Katsomassa';

  @override
  String get stormJoinTheRace => 'Liity kisaan!';

  @override
  String get stormStartTheRace => 'Aloita kisa';

  @override
  String stormYourRankX(String param) {
    return 'Sijoituksesi: $param';
  }

  @override
  String get stormWaitForRematch => 'Odota revanssia';

  @override
  String get stormNextRace => 'Seuraava kisa';

  @override
  String get stormJoinRematch => 'Liity revanssiin';

  @override
  String get stormWaitingToStart => 'Odotetaan alkamista';

  @override
  String get stormCreateNewGame => 'Luo uusi peli';

  @override
  String get stormJoinPublicRace => 'Liity avoimeen kisaan';

  @override
  String get stormRaceYourFriends => 'Kilpaile kaveriesi kanssa';

  @override
  String get stormSkip => 'ohita';

  @override
  String get stormSkipHelp => 'Kunkin kilvan aikana voit ohittaa yhden siirron:';

  @override
  String get stormSkipExplanation => 'Ohita tämä siirto jatkaaksesi putkea! Toimii kunkin kilvan aikana vain kerran.';

  @override
  String get stormFailedPuzzles => 'Epäonnistuneet tehtävät';

  @override
  String get stormSlowPuzzles => 'Hitaat tehtävät';

  @override
  String get stormSkippedPuzzle => 'Ohitettu tehtävä';

  @override
  String get stormThisWeek => 'Tällä viikolla';

  @override
  String get stormThisMonth => 'Tässä kuussa';

  @override
  String get stormAllTime => 'Paras koskaan';

  @override
  String get stormClickToReload => 'Lataa uudelleen';

  @override
  String get stormThisRunHasExpired => 'Tämä sarja on vanhentunut!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Tämä sarja on avattu toiseen välilehteen!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sarjaa',
      one: '1 sarja',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pelasi $count sarjaa ${param2}ia',
      one: 'Pelasi yhden sarjan ${param2}ia',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess-striimaajat';

  @override
  String get studyShareAndExport => 'Jaa & vie';

  @override
  String get studyStart => 'Aloita';
}
