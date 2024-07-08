import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

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
  String get activityActivity => 'Jarduera';

  @override
  String get activityHostedALiveStream => 'Zuzeneko emanaldi bat egin du';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Sailkapena $param1/$param2';
  }

  @override
  String get activitySignedUp => 'Lichess.org-en izena eman du';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lichess.org-i laguntza eman zion $count hilabetez $param2 gisa',
      one: 'Lichess.org-i laguntza eman zion hilabete $count-z $param2 gisa',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 erako $count posizio praktikatu ditu',
      one: '$param2 erako posizio $count praktikatu du',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ariketa ebatzi ditu',
      one: 'Ariketa $count ebatzi du',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 partida jokatu ditu',
      one: '$param2 partida $count jokatu du',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 foroan $count mezu argitaratu ditu',
      one: '$param2 foroan mezu $count argitaratu du',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jokaldi $count egin du',
      one: 'Jokaldi $count egin du',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'posta bidezko partida $count-en',
      one: 'posta bidezko partida $count-en',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Posta bidezko $count partida jokatu ditu',
      one: 'Posta bidezko partida $count jokatu du',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jokalari jarraitzen hasi da',
      one: 'Jokalari $count jarraitzen hasi da',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jarraitzaile berri lortu ditu',
      one: 'Jarraitzaile berri $count lortu du',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aldibereko partiden $count saio antolatu ditu',
      one: 'Aldibereko partiden saio $count antolatu du',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aldibireko $count saiotan hartu du parte',
      one: 'Aldibireko saio ${count}ean hartu du parte',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count azterlan berri sortu ditu',
      one: 'Azterlan berri $count sortu du',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count txapelketetan parte hartu du',
      one: 'Txapelketa ${count}ean parte hartu du',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count. postua (% $param2 onenen artean) $param3 partida jokatuta $param4 txapelketan',
      one: '$count. postua lortu du (% $param2 onenen artean) partida $param3 jokatuta $param4 txapelketan',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count txapelketa suitzarretan hartu du parte',
      one: 'Txapelketa suitzar ${count}en hartu du parte',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taldetara sartu da',
      one: 'Talde ${count}era sartu da',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Emanaldiak';

  @override
  String get broadcastLiveBroadcasts => 'Txapelketen zuzeneko emanaldiak';

  @override
  String challengeChallengesX(String param1) {
    return 'Erronkak: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Partida baterako erronka egin';

  @override
  String get challengeChallengeDeclined => 'Erronka baztertuta';

  @override
  String get challengeChallengeAccepted => 'Erronka onartuta!';

  @override
  String get challengeChallengeCanceled => 'Erronka bertan behera utzita.';

  @override
  String get challengeRegisterToSendChallenges => 'Eman izena erronkak bidaltzeko.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Ezin diozu $param erabiltzaileri erronka egin.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param erabiltzaileak ez du erronkarik onartzen.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Zure $param1 puntuazioa urrunegi dago $param2-tik.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Ezin duzu erronkarik egin behin-behineko $param puntuazioa duzulako.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param erabiltzaileak bere lagunen erronkak onartzen ditu bakarrik.';
  }

  @override
  String get challengeDeclineGeneric => 'Orain ez dut erronkarik onartzen.';

  @override
  String get challengeDeclineLater => 'Hori ez da momenturik onena, eskatu beranduago.';

  @override
  String get challengeDeclineTooFast => 'Erritmo hori azkarregia da, proposatu partida geldoago bat.';

  @override
  String get challengeDeclineTooSlow => 'Erritmo hori geldoegia da, proposatu partida azkarrago bat.';

  @override
  String get challengeDeclineTimeControl => 'Ez dut erritmo horretako erronkarik onartzen.';

  @override
  String get challengeDeclineRated => 'Mesedez bidali puntuaziorako balio duen erronka bat.';

  @override
  String get challengeDeclineCasual => 'Mesedez bidali lagunarteko erronka bat, puntuaziorako balio ez duena.';

  @override
  String get challengeDeclineStandard => 'Ez dut aldaeren erronkarik onartzen.';

  @override
  String get challengeDeclineVariant => 'Ez dut aldaera horretan jokatu nahi.';

  @override
  String get challengeDeclineNoBot => 'Ez dut erroboten erronkarik onartzen.';

  @override
  String get challengeDeclineOnlyBot => 'Erroboten erronkak bakarrik onartzen ditut.';

  @override
  String get challengeInviteLichessUser => 'Edo gonbidatu Lichesseko erabiltzaile bat:';

  @override
  String get contactContact => 'Harremana';

  @override
  String get contactContactLichess => 'Jarri kontaktuan Lichessekin';

  @override
  String get patronDonate => 'Dirua eman';

  @override
  String get patronLichessPatron => 'Lichess babeslea';

  @override
  String perfStatPerfStats(String param) {
    return '$param estatistikak';
  }

  @override
  String get perfStatViewTheGames => 'Partidak ikusi';

  @override
  String get perfStatProvisional => 'behin-behinekoa';

  @override
  String get perfStatNotEnoughRatedGames => 'Ez duzu puntuaziorako balio duten behar adina partida jokatu.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Azken $param partidetako aurrerapena:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Puntuazioaren desbideraketa: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Balio baxuagoak puntuazioa egonkorragoa dela esan nahi du. ${param1}tik gorako balioak puntuazioa behin-behinekoa dela esan nahi du. Sailkapenetan agertzeko, balio hori $param2 baino baxuagoa (xake estandarrean) eta $param3 baino baxuagoa (aldaeretan) izan behar da.';
  }

  @override
  String get perfStatTotalGames => 'Partida kopurua';

  @override
  String get perfStatRatedGames => 'Puntuaziorako balio duten partidak';

  @override
  String get perfStatTournamentGames => 'Txapelketetako partidak';

  @override
  String get perfStatBerserkedGames => 'Berserk erabilitako partidak';

  @override
  String get perfStatTimeSpentPlaying => 'Jokatzen emandako denbora';

  @override
  String get perfStatAverageOpponent => 'Aurkarien batazbestekoa';

  @override
  String get perfStatVictories => 'Garaipenak';

  @override
  String get perfStatDefeats => 'Porrotak';

  @override
  String get perfStatDisconnections => 'Deskonektatutakoak';

  @override
  String get perfStatNotEnoughGames => 'Ez duzu partida nahiko jokatu';

  @override
  String perfStatHighestRating(String param) {
    return 'Puntuazio altuena: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Puntuazio baxuena: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return '$param1 - $param2';
  }

  @override
  String get perfStatWinningStreak => 'Garaipenen segida';

  @override
  String get perfStatLosingStreak => 'Porroten segida';

  @override
  String perfStatLongestStreak(String param) {
    return 'Segida luzeena: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Uneko segida: $param';
  }

  @override
  String get perfStatBestRated => 'Garaipen onenak';

  @override
  String get perfStatGamesInARow => 'Jarraian jokatutako partida kopurua';

  @override
  String get perfStatLessThanOneHour => 'Partiden artean ordubete baino gutxiago';

  @override
  String get perfStatMaxTimePlaying => 'Jokatzen emandako denbora gehiena';

  @override
  String get perfStatNow => 'orain';

  @override
  String get preferencesPreferences => 'Lehentasunak';

  @override
  String get preferencesDisplay => 'Erakutsi';

  @override
  String get preferencesPrivacy => 'Pribatutasuna';

  @override
  String get preferencesNotifications => 'Jakinarazpenak';

  @override
  String get preferencesPieceAnimation => 'Piezen animazioa';

  @override
  String get preferencesMaterialDifference => 'Material desoreka';

  @override
  String get preferencesBoardHighlights => 'Taulan markak erakutsi (azken jokaldia eta xakea)';

  @override
  String get preferencesPieceDestinations => 'Piezen norakoak (jokaldi zuzenak eta aurre-jokaldiak)';

  @override
  String get preferencesBoardCoordinates => 'Taularen koordinatutak (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Jokaldi-zerrenda partidan zehar';

  @override
  String get preferencesPgnPieceNotation => 'Jokaldien idazketa';

  @override
  String get preferencesChessPieceSymbol => 'Xake piezen ikurra';

  @override
  String get preferencesPgnLetter => 'Hizkiak (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen modua';

  @override
  String get preferencesShowPlayerRatings => 'Erakutsi jokalarien puntuazioak';

  @override
  String get preferencesShowFlairs => 'Ikusi jokalarien iruditxoak';

  @override
  String get preferencesExplainShowPlayerRatings => 'Horri esker, gunearen puntuazio guztiak ezkutatu daitezke, xakean arreta jartzen laguntzeko. Partidak puntuka izan daitezke oraindik, hau da zuk ikus dezakezuna.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Xake-taularen tamaina aldatzeko aukera erakutsi';

  @override
  String get preferencesOnlyOnInitialPosition => 'Hasierako posizioan bakarrik';

  @override
  String get preferencesInGameOnly => 'Partidan zehar bakarrik';

  @override
  String get preferencesChessClock => 'Xake-erlojua';

  @override
  String get preferencesTenthsOfSeconds => 'Segundo-hamarrenak erakutsi';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Denbora 10 segundotik behera dagoenean';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Aurrerabide-barra berdea horizontalki';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Soinua jo denbora bukatzear dagoenean';

  @override
  String get preferencesGiveMoreTime => 'Denbora gehiago eman';

  @override
  String get preferencesGameBehavior => 'Partidaren portaera';

  @override
  String get preferencesHowDoYouMovePieces => 'Nola mugitzen dituzu piezak?';

  @override
  String get preferencesClickTwoSquares => 'Bi laukitan klik eginda';

  @override
  String get preferencesDragPiece => 'Pieza arrastatuta';

  @override
  String get preferencesBothClicksAndDrag => 'Edozein';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Aldez aurretik mugitzea (aurkariaren txanda den bitartean mugitu)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Jokaldia atzera botatzea  (aurkariaren onespenarekin)';

  @override
  String get preferencesInCasualGamesOnly => 'Puntu-aldaketarik gabeko partidetan bakarrik';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Dama automatikoki sustatzea';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Eutsi <ctrl> tekla sakatuta sustapenean sustapen automatikoa aldi baterako desaktibatzeko';

  @override
  String get preferencesWhenPremoving => 'Aldez aurreko jokaldia egiten denean';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Posizioa hirutan errepikatzen denean berdinketa automatikoki eskatu';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => '30 segundo baino gutxiago geratzen denean';

  @override
  String get preferencesMoveConfirmation => 'Jokaldia baieztatzea';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Partida baten zehar taularen menua erabiliz desaktibatu daiteke';

  @override
  String get preferencesInCorrespondenceGames => 'Posta bidezko partidak';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Posta-xakea,  denbora-eperik gabe';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Etsitze eta berdinketa eskaeren baieztapena eskatu';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Endrokatzeko modua';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Erregea bi lauki mugitu';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Erregea gazteluaren gainera mugitu';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Jokaldiak teklatuarekin sartu';

  @override
  String get preferencesInputMovesWithVoice => 'Egin jokaldiak zure ahotsarekin';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Marraztutako geziak legezko jokaldietara mugatu';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Txateam \"Good game, well played\" esan partida galdu edo berdintzean';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Zure ezarpenak ondo gorde dira.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Mugitu taula gainean jokaldiak ikusteko';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Jaso posta elektronikoz zure posta-bidezko partiden jakinarazpenen zerrenda egunero';

  @override
  String get preferencesNotifyStreamStart => 'Streamerra zuzenean dago';

  @override
  String get preferencesNotifyInboxMsg => 'Mezu berria postontzian';

  @override
  String get preferencesNotifyForumMention => 'Foroko erantzunean aipatu zaituzte';

  @override
  String get preferencesNotifyInvitedStudy => 'Azterlanreko gonbidapena';

  @override
  String get preferencesNotifyGameEvent => 'Posta bidezko partidetan eguneraketa';

  @override
  String get preferencesNotifyChallenge => 'Erronkak';

  @override
  String get preferencesNotifyTournamentSoon => 'Txapelketa laster hasiko da';

  @override
  String get preferencesNotifyTimeAlarm => 'Posta bidezko partidaren denbora amaitzen ari da';

  @override
  String get preferencesNotifyBell => 'Kanpai bidezko jakinarazpena Lichess barruan';

  @override
  String get preferencesNotifyPush => 'Gailuko jakinarazpena Lichessen ez zaudenean';

  @override
  String get preferencesNotifyWeb => 'Nabigatzailea';

  @override
  String get preferencesNotifyDevice => 'Gailua';

  @override
  String get preferencesBellNotificationSound => 'Kanpaiaren jakinarazpen soinua';

  @override
  String get puzzlePuzzles => 'Ariketak';

  @override
  String get puzzlePuzzleThemes => 'Ariketen gaiak';

  @override
  String get puzzleRecommended => 'Gomendatutakoak';

  @override
  String get puzzlePhases => 'Faseak';

  @override
  String get puzzleMotifs => 'Gaiak';

  @override
  String get puzzleAdvanced => 'Aurreratua';

  @override
  String get puzzleLengths => 'Luzera';

  @override
  String get puzzleMates => 'Mateak';

  @override
  String get puzzleGoals => 'Helburuak';

  @override
  String get puzzleOrigin => 'Jatorria';

  @override
  String get puzzleSpecialMoves => 'Jokaldi bereziak';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ariketa gustukoa izan da?';

  @override
  String get puzzleVoteToLoadNextOne => 'Eman bozka hurrengoa kargatzeko!';

  @override
  String get puzzleUpVote => 'Ariketari +1 botoa';

  @override
  String get puzzleDownVote => 'Ariketari -1 botoa';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Ariketen zure puntuazioa ez da aldatuko. Kontuan izan ariketak ez direla txapelketa bat. Puntuaziok zure gaitasunen araberako ariketak aukeratzen laguntzen du.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Zurien jokaldi onena bilatu.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Beltzen jokaldi onena bilatu.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Ariketa pertsonalizatuak lortzeko:';

  @override
  String puzzlePuzzleId(String param) {
    return '$param ariketa';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Eguneko ariketa';

  @override
  String get puzzleDailyPuzzle => 'Eguneroko ariketa';

  @override
  String get puzzleClickToSolve => 'Ebazteko klik egin';

  @override
  String get puzzleGoodMove => 'Jokaldi ona';

  @override
  String get puzzleBestMove => 'Jokaldi onena!';

  @override
  String get puzzleKeepGoing => 'Jarraitu…';

  @override
  String get puzzlePuzzleSuccess => 'Zorionak!';

  @override
  String get puzzlePuzzleComplete => 'Ariketa osatuta!';

  @override
  String get puzzleByOpenings => 'Hasieraka';

  @override
  String get puzzlePuzzlesByOpenings => 'Hasierakako ariketak';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Gehien jokatu dituzun hasierak';

  @override
  String get puzzleUseFindInPage => 'Erabili zure nabigatzaileko \"Bilatu orrian\" funtzioa zure hasiera gogokoena bilatzeko!';

  @override
  String get puzzleUseCtrlF => 'Erabili Ctrl+f zure hasiera gogokoena bilatzeko!';

  @override
  String get puzzleNotTheMove => 'Hori ez zen jokaldia!';

  @override
  String get puzzleTrySomethingElse => 'Saiatu beste batekin.';

  @override
  String puzzleRatingX(String param) {
    return 'Sailkapena: $param';
  }

  @override
  String get puzzleHidden => 'ezkutuan';

  @override
  String puzzleFromGameLink(String param) {
    return '$param partidatik hartua';
  }

  @override
  String get puzzleContinueTraining => 'Entrenatzen jarraitu';

  @override
  String get puzzleDifficultyLevel => 'Zailtasun-maila';

  @override
  String get puzzleNormal => 'Arrunta';

  @override
  String get puzzleEasier => 'Erraza';

  @override
  String get puzzleEasiest => 'Errazena';

  @override
  String get puzzleHarder => 'Zaila';

  @override
  String get puzzleHardest => 'Zailena';

  @override
  String get puzzleExample => 'Adibidea';

  @override
  String get puzzleAddAnotherTheme => 'Beste gai bat gehitu';

  @override
  String get puzzleNextPuzzle => 'Hurrengo ariketa';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Salto egin hurrengo ariketara berehala';

  @override
  String get puzzlePuzzleDashboard => 'Ariketen kontrol-panela';

  @override
  String get puzzleImprovementAreas => 'Hobetzekoak';

  @override
  String get puzzleStrengths => 'Indarguneak';

  @override
  String get puzzleHistory => 'Ariketen historikoa';

  @override
  String get puzzleSolved => 'ebatzita';

  @override
  String get puzzleFailed => 'huts eginda';

  @override
  String get puzzleStreakDescription => 'Ebatzi gero eta zailagoak diren ariketak eta garaipen-bolada lortu. Ez dago erlojurik, beraz hartu behar duzun denbora. Jokaldi oker bat eta akabo! Baina aldi bakoitzean behin salto egin dezakezu.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Zure garaipen-bolada: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Jokaldi hau saltatu zure bolada mantentzeko! Lasterketa bakoitzean behin bakarrik erabili dezakezu.';

  @override
  String get puzzleContinueTheStreak => 'Jarraitu garaipen-bolada';

  @override
  String get puzzleNewStreak => 'Garaipen-bolada berria';

  @override
  String get puzzleFromMyGames => 'Nire partidetatik';

  @override
  String get puzzleLookupOfPlayer => 'Bilatu jokalari baten partidetatik ateratako ariketak';

  @override
  String puzzleFromXGames(String param) {
    return '$param jokalariaren partidetako ariketak';
  }

  @override
  String get puzzleSearchPuzzles => 'Ariketak bilatu';

  @override
  String get puzzleFromMyGamesNone => 'Ez duzu ariketarik datu-basean, hala ere Lichessek asko maite zaitu.\nJokatu partida azkar eta arruntak zure partidetatik eratorritako ariketak izateko!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 ariketa aurkitu dira $param2 partidatan';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Entrenatu, aztertu, hobetu';

  @override
  String puzzlePercentSolved(String param) {
    return '$param ebatzita';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Ez dago ezer erakusteko, ebatzi ariketa batzuk!';

  @override
  String get puzzleImprovementAreasDescription => 'Entrenatu zure eboluzioa hobetzeko!';

  @override
  String get puzzleStrengthDescription => 'Gai hauetan zabiltza ondoen';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aldiz jokatuta',
      one: 'Behin jokatuta',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ariketen zure puntuazioa baino $count puntu beherago',
      one: 'Ariketen zure puntuazioa baino puntu bat beherago',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ariketen zure puntuazioa baino $count puntu gorago',
      one: 'Ariketen zure puntuazioa baino puntu bat gorago',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jokatuta',
      one: '$count jokatuta',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count berriz egiteko',
      one: '$count berriz egiteko',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Peoi aurreratua';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Sustatuko den edo sustatze-bidean dagoen peoia da ariketa honen muina.';

  @override
  String get puzzleThemeAdvantage => 'Abantaila';

  @override
  String get puzzleThemeAdvantageDescription => 'Abantaila osoa lortzen saiatu (200cp ≤ ebaluazioa ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasiaren matea';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Zaldun bat eta gaztelua eta damak aurkariaren erregea taularen bazter baten eta bere pieza baten artean harrapatzen dute.';

  @override
  String get puzzleThemeArabianMate => 'Mate arabiarra';

  @override
  String get puzzleThemeArabianMateDescription => 'Zaldun eta gaztelu banak elkarrekin lan egiten dute aurkariaren erregea xake-taularen bazter baten harrapatzeko.';

  @override
  String get puzzleThemeAttackingF2F7 => 'f2 edo f7 erasotu';

  @override
  String get puzzleThemeAttackingF2F7Description => 'f2 edo f7ko peoia helburu duen erasoa.';

  @override
  String get puzzleThemeAttraction => 'Erakarmena';

  @override
  String get puzzleThemeAttractionDescription => 'Aurkariaren pieza bat ondorengo erasoa erraztuko duen lauki batera mugitzeko pieza-aldaketa edo sakrifizioa.';

  @override
  String get puzzleThemeBackRankMate => 'Azken lerroko matea';

  @override
  String get puzzleThemeBackRankMateDescription => 'Bere piezekin trabatuta dagoenean erregeari bere errenkadan matea ematea.';

  @override
  String get puzzleThemeBishopEndgame => 'Alfilen bukaera';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Alfilak eta peoiak bakarrik dituen partida-bukaera.';

  @override
  String get puzzleThemeBodenMate => 'Bodenen matea';

  @override
  String get puzzleThemeBodenMateDescription => 'Bi alfilek beren piezen artean trabatuta dagoen erregeari ematen dioten matea.';

  @override
  String get puzzleThemeCastling => 'Endrokea';

  @override
  String get puzzleThemeCastlingDescription => 'Babestu erregea eta ekarri gaztelua erasora.';

  @override
  String get puzzleThemeCapturingDefender => 'Defendatzailea harrapatu';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Beste pieza bat defendatzeko funtsezkoa den pieza kentzea, hurrengo jokaldietan lehenengo pieza hori harrapatzeko.';

  @override
  String get puzzleThemeCrushing => 'Zapalketa';

  @override
  String get puzzleThemeCrushingDescription => 'Akatsa aurkitu eta guztizko abantaila lortu. (ebaluazioa ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Bi alfilen matea';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Bi alfilek beren piezen artean trabatuta dagoen erregeari ematen dioten matea.';

  @override
  String get puzzleThemeDovetailMate => 'Mirubuztanaren matea';

  @override
  String get puzzleThemeDovetailMateDescription => 'Damak ematen duen matea erregearen ihes-laukiak bere piezekin trabatuta daudenean.';

  @override
  String get puzzleThemeEquality => 'Berdintasuna';

  @override
  String get puzzleThemeEqualityDescription => 'Partida galduta izatetik, berdinketa edo posizio berdintsua lortzera itzuli. (ebaluazioa ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Erregearen aldeko erasoa';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Aurkariaren erregearen aurkako erasoa, hau motzean endrokatu ostean.';

  @override
  String get puzzleThemeClearance => 'Garbiketa';

  @override
  String get puzzleThemeClearanceDescription => 'Lauki, errenkada edo diagonala garbitzen duen jokaldia, ondoren beste ideia taktiko bat erabiltzeko.';

  @override
  String get puzzleThemeDefensiveMove => 'Defentsa-jokaldia';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Materiala edo beste edozein abantaila galtzea ekiditeko jokaldi edo jokaldi-multzoa.';

  @override
  String get puzzleThemeDeflection => 'Desbideraketa';

  @override
  String get puzzleThemeDeflectionDescription => 'Aurkariaren pieza berezkoa duen betebehar batetik desbideratzea, adibidez lauki bat babestetik. Batzuetan \"gainkarga\" ere deitzen zaio.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ageriko erasoa';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Beste pieza baten erasoa blokeatzen duen pieza bat mugitzea.';

  @override
  String get puzzleThemeDoubleCheck => 'Xake bikoitza';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Bi piezarekin batera xake egitea, ageriko eraso baten ondorioz, mugitutako eta ezkutuan zegoen piezak aurkariaren erregea erasotuz.';

  @override
  String get puzzleThemeEndgame => 'Partida-bukaera';

  @override
  String get puzzleThemeEndgameDescription => 'Partidaren azken faseko taktika.';

  @override
  String get puzzleThemeEnPassantDescription => 'Igarotzean harrapatzeko arauarekin zerikusia duen taktika.';

  @override
  String get puzzleThemeExposedKing => 'Babesik gabeko erregea';

  @override
  String get puzzleThemeExposedKingDescription => 'Pieza gutxik defenditzen duten erregearen inguruko erasoa, sarri matean amaitzen dena.';

  @override
  String get puzzleThemeFork => 'Eraso bikoitza';

  @override
  String get puzzleThemeForkDescription => 'Mugitzen den piezak aurkariaren bi pieza batera erasotzen dituenean.';

  @override
  String get puzzleThemeHangingPiece => 'Defentsarik gabeko pieza';

  @override
  String get puzzleThemeHangingPieceDescription => 'Defentsarik ez duen edo defendatzaile gutxi dituen aurkariaren pieza baten ingurukoak.';

  @override
  String get puzzleThemeHookMate => 'Hooken matea';

  @override
  String get puzzleThemeHookMateDescription => 'Gaztelua, zalduna eta peoi batekin ematen den matea aurkariaren peoi batek bere erregearen bidea oztopatzen duelarik.';

  @override
  String get puzzleThemeInterference => 'Tartean sartzea';

  @override
  String get puzzleThemeInterferenceDescription => 'Aurkariaren bi piezaren artean pieza bat jartzea, horrela aurkariaren piezetako bat edo biak defentsarik gabe utziz.';

  @override
  String get puzzleThemeIntermezzo => 'Tarteko-jokaldia';

  @override
  String get puzzleThemeIntermezzoDescription => 'Esperotako jokaldia egin beharrean, aurkariari mehatxu bat eginez beste jokaldi bat egin aurkaria jokaldi horri erantzutera derrigortuz.';

  @override
  String get puzzleThemeKnightEndgame => 'Zaldunen finala';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Zaldunak eta peoiak bakarrik dituen partida bukaera.';

  @override
  String get puzzleThemeLong => 'Ariketa luzea';

  @override
  String get puzzleThemeLongDescription => 'Irabazteko hiru jokaldi.';

  @override
  String get puzzleThemeMaster => 'Maisuen partidak';

  @override
  String get puzzleThemeMasterDescription => 'Tituludun jokalariek jokatutako partidetan oinarritutako ariketak.';

  @override
  String get puzzleThemeMasterVsMaster => 'Maisuen arteko partidak';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Tituludun jokalari biren artean jokatutako partidetan oinarritutako ariketak.';

  @override
  String get puzzleThemeMate => 'Mate';

  @override
  String get puzzleThemeMateDescription => 'Irabazi partida estiloarekin.';

  @override
  String get puzzleThemeMateIn1 => 'Mate baten';

  @override
  String get puzzleThemeMateIn1Description => 'Eman mate jokaldi bakarrean.';

  @override
  String get puzzleThemeMateIn2 => 'Mate bitan';

  @override
  String get puzzleThemeMateIn2Description => 'Eman mate bi jokalditan.';

  @override
  String get puzzleThemeMateIn3 => 'Mate hirutan';

  @override
  String get puzzleThemeMateIn3Description => 'Eman mate hiru jokalditan.';

  @override
  String get puzzleThemeMateIn4 => 'Mate lautan';

  @override
  String get puzzleThemeMateIn4Description => 'Eman mate lau jokalditan.';

  @override
  String get puzzleThemeMateIn5 => 'Mate 5 edo jokaldi gehiagotan';

  @override
  String get puzzleThemeMateIn5Description => 'Mate emateko sekuentzia luzea asmatu.';

  @override
  String get puzzleThemeMiddlegame => 'Erdi-jokoa';

  @override
  String get puzzleThemeMiddlegameDescription => 'Partidaren bigarren faseko taktika.';

  @override
  String get puzzleThemeOneMove => 'Jokaldi bakarreko ariketa';

  @override
  String get puzzleThemeOneMoveDescription => 'Jokaldi bakarrean ebazten den ariketa.';

  @override
  String get puzzleThemeOpening => 'Hasiera';

  @override
  String get puzzleThemeOpeningDescription => 'Partidaren lehenengo faseko taktika.';

  @override
  String get puzzleThemePawnEndgame => 'Peoien finala';

  @override
  String get puzzleThemePawnEndgameDescription => 'Peoiak bakarrik dituen finala.';

  @override
  String get puzzleThemePin => 'Iltzaketa';

  @override
  String get puzzleThemePinDescription => 'Iltzaketak ardatz dituen taktika, pieza bat mugitu ezin denean gehiago balio duen pieza bat airean utziko duelako.';

  @override
  String get puzzleThemePromotion => 'Sustapena';

  @override
  String get puzzleThemePromotionDescription => 'Sustatuko den edo sustatze-bidean dagoen peoia da ariketa honen muina.';

  @override
  String get puzzleThemeQueenEndgame => 'Damen finala';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Damak eta peoiak bakarrik dituen finala.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dama eta Gaztelua';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Damak, gazteluak eta peoiak bakarrik dituen finala.';

  @override
  String get puzzleThemeQueensideAttack => 'Damaren aldeko erasoa';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Aurkariaren erregearen aurkako erasoa, hau luzean endrokatu ostean.';

  @override
  String get puzzleThemeQuietMove => 'Jokaldi lasaia';

  @override
  String get puzzleThemeQuietMoveDescription => 'Xakerik edo piezarik harrapatzen ez duen jokaldia, baina geldiezina den eraso bat prestatzen duena.';

  @override
  String get puzzleThemeRookEndgame => 'Gazteluen finala';

  @override
  String get puzzleThemeRookEndgameDescription => 'Gazteluak eta peoiak bakarrik dituen finala.';

  @override
  String get puzzleThemeSacrifice => 'Sakrifizioa';

  @override
  String get puzzleThemeSacrificeDescription => 'Geroago abantaila lortzeko epe motzean materiala entregatzea helburu duen taktika.';

  @override
  String get puzzleThemeShort => 'Ariketa laburra';

  @override
  String get puzzleThemeShortDescription => 'Bi jokaldi irabazteko.';

  @override
  String get puzzleThemeSkewer => 'Paretik kentzea';

  @override
  String get puzzleThemeSkewerDescription => 'Erasotua den balio handiko pieza bat mugitzea, erasotik kenduz eta bere atzean dagoen baina gutxiago balio duen pieza bat harrapatzen uztea, iltzaketaren aurkakoa.';

  @override
  String get puzzleThemeSmotheredMate => 'Ostikoaren matea';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Zaldiak ematen duen matea, aurkariaren erregea bere piezak oztopatzen dutenez ezin delako mugitu.';

  @override
  String get puzzleThemeSuperGM => 'Super GMen partidak';

  @override
  String get puzzleThemeSuperGMDescription => 'Munduko jokalari onenek jokatutako partidetatik ateratako ariketak.';

  @override
  String get puzzleThemeTrappedPiece => 'Harrapatutako pieza';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Bere jokaldiak mugatuta dituelako ihes egin ezin duen pieza.';

  @override
  String get puzzleThemeUnderPromotion => 'Sustapen txikia';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Zalduna, alfila edo gaztelua sustatzea.';

  @override
  String get puzzleThemeVeryLong => 'Ariketa oso luzea';

  @override
  String get puzzleThemeVeryLongDescription => 'Irabazteko lau jokaldi edo gehiago.';

  @override
  String get puzzleThemeXRayAttack => 'X-izpien erasoa';

  @override
  String get puzzleThemeXRayAttackDescription => 'Aurkariaren pieza baten artetik, pieza batek lauki bat erasotu edo defendatzen duenean.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'Aurkariak jokaldi mugatuak ditu eta jokaldi guztien bere posizioa okertu egiten dute.';

  @override
  String get puzzleThemeHealthyMix => 'Denetik pixkat';

  @override
  String get puzzleThemeHealthyMixDescription => 'Denetatik. Ez dakizu zer espero, beraz prestatu zure burua edozertarako! Benetako partidetan bezala.';

  @override
  String get puzzleThemePlayerGames => 'Jokalarien partidak';

  @override
  String get puzzleThemePlayerGamesDescription => 'Ikusi zure edo beste jokalarien partidetatik sortutako ariketak.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Ariketa hauek publikoak dira, $param helbidetik deskargatu daitezke.';
  }

  @override
  String get searchSearch => 'Bilatu';

  @override
  String get settingsSettings => 'Ezarpenak';

  @override
  String get settingsCloseAccount => 'Kontua itxi';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Zure kontua beste norbaitek kudeatzen du eta ezin da itxi.';

  @override
  String get settingsClosingIsDefinitive => 'Ixteak ez du atzera egiterik. Ziur zaude?';

  @override
  String get settingsCantOpenSimilarAccount => 'Ezingo duzu beste kontu bat ireki izen berdinarekin, naiz eta hizki larriak eta xeheak aldatu.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Ez dut nire kontua itxi nahi';

  @override
  String get settingsCloseAccountExplanation => 'Benetan zure kontua itxi egin nahi duzu? Erabaki hau betiko hartuko duzu eta ezingo zara berriz inoiz webgunera sartu.';

  @override
  String get settingsThisAccountIsClosed => 'Kontu hau itxita dago.';

  @override
  String get playWithAFriend => 'Lagun baten aurka jokatu';

  @override
  String get playWithTheMachine => 'Ordenagailuaren aurka jokatu';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Norbait jokatzera gonbidatzeko, URL hau bidali iezaiozu';

  @override
  String get gameOver => 'Partida amaitu da';

  @override
  String get waitingForOpponent => 'Aurkariaren zain';

  @override
  String get orLetYourOpponentScanQrCode => 'Edo utzi zure aurkariari QR kode hau eskaneatzen';

  @override
  String get waiting => 'Zain';

  @override
  String get yourTurn => 'Zure txanda';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1, $param2. maila';
  }

  @override
  String get level => 'Maila';

  @override
  String get strength => 'Indarra';

  @override
  String get toggleTheChat => 'Erakutsi/ezkutatu txata';

  @override
  String get chat => 'Txata';

  @override
  String get resign => 'Amore eman';

  @override
  String get checkmate => 'Xake mate';

  @override
  String get stalemate => 'Itoa';

  @override
  String get white => 'Zuria';

  @override
  String get black => 'Beltza';

  @override
  String get asWhite => 'zuriekin';

  @override
  String get asBlack => 'beltzekin';

  @override
  String get randomColor => 'Ausazko kolorea';

  @override
  String get createAGame => 'Partida bat sortu';

  @override
  String get whiteIsVictorious => 'Zuria irabazle';

  @override
  String get blackIsVictorious => 'Beltza irabazle';

  @override
  String get youPlayTheWhitePieces => 'Zuk pieza zuriekin jokatzen duzu';

  @override
  String get youPlayTheBlackPieces => 'Zuk pieza beltzekin jokatzen duzu';

  @override
  String get itsYourTurn => 'Zure txanda da!';

  @override
  String get cheatDetected => 'Tranpak detektatu ditugu';

  @override
  String get kingInTheCenter => 'Erregea erdian';

  @override
  String get threeChecks => 'Hiru xake';

  @override
  String get raceFinished => 'Lasterketa bukatuta';

  @override
  String get variantEnding => 'Aldaeragatik amaitu da';

  @override
  String get newOpponent => 'Aurkari berria';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Zure aurkariak berriz jokatu nahi du';

  @override
  String get joinTheGame => 'Partidan sartu';

  @override
  String get whitePlays => 'Zuriaren txanda';

  @override
  String get blackPlays => 'Beltzaren txanda';

  @override
  String get opponentLeftChoices => 'Baliteke aurkaria partidatik atera izana. Partida irabazi edo berdindu dezakezu, edo aurkariari itxaron.';

  @override
  String get forceResignation => 'Irabazi';

  @override
  String get forceDraw => 'Berdindu';

  @override
  String get talkInChat => 'Txatean txintxo mesedez!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'URL honetara datorren lehenengoak jokatuko du zurekin.';

  @override
  String get whiteResigned => 'Zuriak amore eman du';

  @override
  String get blackResigned => 'Beltzak amore eman du';

  @override
  String get whiteLeftTheGame => 'Zuria partidatik atera da';

  @override
  String get blackLeftTheGame => 'Beltza partidatik atera da';

  @override
  String get whiteDidntMove => 'Zuriak ez du mugitu';

  @override
  String get blackDidntMove => 'Beltzak ez du mugitu';

  @override
  String get requestAComputerAnalysis => 'Ordenagailuaren analisia eskatu';

  @override
  String get computerAnalysis => 'Ordenagailuaren analisia';

  @override
  String get computerAnalysisAvailable => 'Ordenagailu bidezko analisia egin daiteke';

  @override
  String get computerAnalysisDisabled => 'Ordenagailu bidezko analisia desaktibatuta dago';

  @override
  String get analysis => 'Analisi-taula';

  @override
  String depthX(String param) {
    return 'Sakonera $param';
  }

  @override
  String get usingServerAnalysis => 'Zerbitzariko analisia erabiltzen ari da';

  @override
  String get loadingEngine => 'Motorea kargatzen...';

  @override
  String get calculatingMoves => 'Jokaldiak kalkulatzen...';

  @override
  String get engineFailed => 'Errorea motorea kargatzean';

  @override
  String get cloudAnalysis => '\"Lainoko\" analisia';

  @override
  String get goDeeper => 'Sakonago begiratu';

  @override
  String get showThreat => 'Mehatxua erakutsi';

  @override
  String get inLocalBrowser => 'nabigatzailean';

  @override
  String get toggleLocalEvaluation => 'Analisia erakutsi';

  @override
  String get promoteVariation => 'Aldaera nagusi bihurtu';

  @override
  String get makeMainLine => 'Linea nagusi bihurtu';

  @override
  String get deleteFromHere => 'Ezabatu hemendik aurrera';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Aldaera derrigortu';

  @override
  String get copyVariationPgn => 'Kopiatu ingurabidearen PGNa';

  @override
  String get move => 'Jokaldia';

  @override
  String get variantLoss => 'Galtzeko bidea';

  @override
  String get variantWin => 'Irabazteko bidea';

  @override
  String get insufficientMaterial => 'Ez dago material nahikoa';

  @override
  String get pawnMove => 'Peoi jokaldia';

  @override
  String get capture => 'Harrapaketa';

  @override
  String get close => 'Itxi';

  @override
  String get winning => 'Irabazlea';

  @override
  String get losing => 'Galtzailea';

  @override
  String get drawn => 'Berdinketa';

  @override
  String get unknown => 'Ezezaguna';

  @override
  String get database => 'Datu-basea';

  @override
  String get whiteDrawBlack => 'Zuriak / Berdinketa / Beltzak';

  @override
  String averageRatingX(String param) {
    return 'Bataz besteko puntuazioa: $param';
  }

  @override
  String get recentGames => 'Azken partidak';

  @override
  String get topGames => 'Partidarik onenak';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Mahaigaineko $param2 eta $param3 arteko 2 milioi partida ${param1}etik gorako FIDE sailkapena duten jokalarienak';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' biribilkaketarekin, hurrengo harrapaketa edo peoi mugimendura arteko mugimendu erdietan oinarrituta';

  @override
  String get noGameFound => 'Ez da partidarik aurkitu';

  @override
  String get maxDepthReached => 'Gehienezko sakonerara iritsi zara!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Agian hobespenen menutik partida gehiago gehitu beharko dituzu?';

  @override
  String get openings => 'Irekierak';

  @override
  String get openingExplorer => 'Hasiera-arakatzailea';

  @override
  String get openingEndgameExplorer => 'Hasiera/finalen bilatzailea';

  @override
  String xOpeningExplorer(String param) {
    return '$param hasiera arakatzailea';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Jokatu hasieren/finalek arakatzailearen lehenengo jokaldia';

  @override
  String get winPreventedBy50MoveRule => '50 jokaldien arauak ekidindako garaipena';

  @override
  String get lossSavedBy50MoveRule => '50 jokaldien arauak ekidindako porrota';

  @override
  String get winOr50MovesByPriorMistake => 'Irabazi edo 50 jokaldi aurrerago egindako akats bategatik';

  @override
  String get lossOr50MovesByPriorMistake => 'Galdu edo 50 jokaldi aurrerago egindako akats bategatik';

  @override
  String get unknownDueToRounding => 'Garaipena/porrota gomendatutako tablebasearen aukera azken harrapaketa edo peoiaren mugimendutik jarraitu bada, Syzygy tablebaseen DTZ balioaren biribilketa dela-eta.';

  @override
  String get allSet => 'Dena prest!';

  @override
  String get importPgn => 'PGNa inportatu';

  @override
  String get delete => 'Ezabatu';

  @override
  String get deleteThisImportedGame => 'Inportatuko partida hau ezabatu?';

  @override
  String get replayMode => 'Partida berriz ikusteko modua';

  @override
  String get realtimeReplay => 'Denbora errealean';

  @override
  String get byCPL => 'CPL';

  @override
  String get openStudy => 'Ikerketa ireki';

  @override
  String get enable => 'Aktibatu';

  @override
  String get bestMoveArrow => 'Jokaldi onenaren gezia';

  @override
  String get showVariationArrows => 'Erakutsi aldaeren geziak';

  @override
  String get evaluationGauge => 'Ebaluazio langa';

  @override
  String get multipleLines => 'Linea anitz';

  @override
  String get cpus => 'CPU';

  @override
  String get memory => 'Memoria';

  @override
  String get infiniteAnalysis => 'Analisi infinitua';

  @override
  String get removesTheDepthLimit => 'Sakonera muga ezabatzendu eta zure ordenagailua epel mantentzen du';

  @override
  String get engineManager => 'Motore kudeatzailea';

  @override
  String get blunder => 'Hanka-sartzea';

  @override
  String get mistake => 'Akatsa';

  @override
  String get inaccuracy => 'Akats txikia';

  @override
  String get moveTimes => 'Jokaldi-denborak';

  @override
  String get flipBoard => 'Taula biratu';

  @override
  String get threefoldRepetition => 'Hiru mugimenduen errepikapena';

  @override
  String get claimADraw => 'Berdinketa eskatu';

  @override
  String get offerDraw => 'Berdinketa eskaini';

  @override
  String get draw => 'Berdinketa';

  @override
  String get drawByMutualAgreement => 'Berdinketa horrela adostu delako';

  @override
  String get fiftyMovesWithoutProgress => '50 jokaldi aurrera egin gabe';

  @override
  String get currentGames => 'Oraingo partidak';

  @override
  String get viewInFullSize => 'Pantaila osoa';

  @override
  String get logOut => 'Irten';

  @override
  String get signIn => 'Sartu';

  @override
  String get rememberMe => 'Webgunean sartuta mantendu';

  @override
  String get youNeedAnAccountToDoThat => 'Kontu bat behar duzu hori egiteko';

  @override
  String get signUp => 'Izen ematea';

  @override
  String get computersAreNotAllowedToPlay => 'Xake-programen erabilera debekatuta dago. Mesedez, ez erabili beste jokalari, xake-programa edo datu-baseren laguntzariik. Kontuan izan kontu asko sortzea ere oso gaizki ikusita dagoela; kontu gehiegi sortzeak zu kanporatzea ekar dezake.';

  @override
  String get games => 'Partidak';

  @override
  String get forum => 'Foroa';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 erabiltzailearen mezu berria $param2 gaian';
  }

  @override
  String get latestForumPosts => 'Foroko azken mezuak';

  @override
  String get players => 'Jokalariak';

  @override
  String get friends => 'Lagunak';

  @override
  String get discussions => 'Eztabaidak';

  @override
  String get today => 'Gaur';

  @override
  String get yesterday => 'Atzo';

  @override
  String get minutesPerSide => 'Minutuak alde bakoitzeko';

  @override
  String get variant => 'Aldaera';

  @override
  String get variants => 'Aldaerak';

  @override
  String get timeControl => 'Denbora kontrola';

  @override
  String get realTime => 'Partida arinak';

  @override
  String get correspondence => 'Posta bidezko partidak';

  @override
  String get daysPerTurn => 'Zenbat egun txandako';

  @override
  String get oneDay => 'Egun bat';

  @override
  String get time => 'Denbora';

  @override
  String get rating => 'Puntuazioa';

  @override
  String get ratingStats => 'Estatistikak';

  @override
  String get username => 'Erabitzaile-izena';

  @override
  String get usernameOrEmail => 'Erabiltzaile izena edo posta elektronikoa';

  @override
  String get changeUsername => 'Erabiltzaile-izena aldatu';

  @override
  String get changeUsernameNotSame => 'Hizkien izaera bakarrik aldatu daiteke (larriak vs. xeheak). Adibidez: jatorrizko \"urlia\" \"UrLiA\" bihurtu daiteke.';

  @override
  String get changeUsernameDescription => 'Zure erabiltzaile-izena aldatu. Hau behin bakarrik egin daiteke eta hizkien izaera bakarrik aldatu dezakezu (hizki larriak vs. xeheak).';

  @override
  String get signupUsernameHint => 'Edonorentzako bezalako erabiltzaile-izena aukeratu. Ezingo duzu aldatu. Desegokiak diren erabiltzaile-izenak dituzten kontuak itxi egingo ditugu!';

  @override
  String get signupEmailHint => 'Pasahitza berrezartzeko erabiliko dugu bakarrik.';

  @override
  String get password => 'Pasahitza';

  @override
  String get changePassword => 'Pasahitza aldatu';

  @override
  String get changeEmail => 'Posta elektronikoa aldatu';

  @override
  String get email => 'Posta elektronikoa';

  @override
  String get passwordReset => 'Pasahitz berria eskatu';

  @override
  String get forgotPassword => 'Pasahitza ahaztu duzu?';

  @override
  String get error_weakPassword => 'Pasahitz hau oso arrunta eta asmatzeko erraza da.';

  @override
  String get error_namePassword => 'Ez erabili zure erabiltzaile-izena pasahitz gisa.';

  @override
  String get blankedPassword => 'Pasahitz hau beste webgune baten erabili duzu eta publikoki ezaguna da hori. Lichess kontuaren segurtasuna bermatzeko beste pasahitz bat erabili behar duzu. Eskerrik asko.';

  @override
  String get youAreLeavingLichess => 'Lichess uzten ari zara';

  @override
  String get neverTypeYourPassword => 'Ez erabiili zure Lichesseko pasahitza beste inon!';

  @override
  String proceedToX(String param) {
    return 'Joan zaitez $param helbidera';
  }

  @override
  String get passwordSuggestion => 'Ez erabili beste norbaitek esandako pasahitzak. Zure kontua lapurtzeko erabiliko dute.';

  @override
  String get emailSuggestion => 'Ez erabili beste norbaitek esandako posta elektronikoa. Zure kontua lapurtzeko erabiliko dute.';

  @override
  String get emailConfirmHelp => 'Laguntza eposta baieztapenarekin';

  @override
  String get emailConfirmNotReceived => 'Izena eman ostean ez duzu baieztapen eposta jaso?';

  @override
  String get whatSignupUsername => 'Zein erabiltzaile-izen erabili duzu izena emateko?';

  @override
  String usernameNotFound(String param) {
    return 'Ezin izan dugu izen hau duen erabiltzailerik aurkitu: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Erabiltzaile-izen hau kontu berri bat sortzeko erabili dezakezu';

  @override
  String emailSent(String param) {
    return '$param helbidera mezu bat bidali dugu.';
  }

  @override
  String get emailCanTakeSomeTime => 'Itxaron pixkatean mezua jaso arte.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Itxaron 5 minutu eta freskatu zure epostaren sarrera-ontzia.';

  @override
  String get checkSpamFolder => 'Zabor mezuen karpetan begiratu, batzuetan horra joaten dira-eta mezuak. Horrela bada, esan zaborra ez dela.';

  @override
  String get emailForSignupHelp => 'Beste guztiak huts egin badu, bidali guri mezu hau:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopiatu eta itsatsi goiko mezua eta bidali $param helbidera';
  }

  @override
  String get waitForSignupHelp => 'Laster jarriko gara zurekin harremanetan zure izen-ematea osatzeko.';

  @override
  String accountConfirmed(String param) {
    return '$param erabiltzailea ondo baieztatu da.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Orain $param izena erabiliz sartu zaitezke.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Ez duzu baieztapen eposta behar.';

  @override
  String accountClosed(String param) {
    return '$param kontua itxita dago.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return '$param kontua eposta helbide gabe erregistatu da.';
  }

  @override
  String get rank => 'Maila';

  @override
  String rankX(String param) {
    return 'Sailkapena: $param';
  }

  @override
  String get gamesPlayed => 'Partida jokaturik';

  @override
  String get cancel => 'Ezeztatu';

  @override
  String get whiteTimeOut => 'Zuriaren denbora agortu egin da';

  @override
  String get blackTimeOut => 'Beltzaren denbora agortu egin da';

  @override
  String get drawOfferSent => 'Berdintzeko eskaintza bidali da';

  @override
  String get drawOfferAccepted => 'Berdintzeko eskaintza onartu da';

  @override
  String get drawOfferCanceled => 'Berdintzeko eskaintza ezeztatu da';

  @override
  String get whiteOffersDraw => 'Zuriak berdinketa eskaintzen du';

  @override
  String get blackOffersDraw => 'Beltzak berdinketa eskaintzen du';

  @override
  String get whiteDeclinesDraw => 'Zuriak berdinketari uko egin dio.';

  @override
  String get blackDeclinesDraw => 'Beltzak berdinketari uko egin dio.';

  @override
  String get yourOpponentOffersADraw => 'Zure aurkariak berdinketa eskaini du';

  @override
  String get accept => 'Onartu';

  @override
  String get decline => 'Uko egin';

  @override
  String get playingRightNow => 'Oraintxe jokatzen';

  @override
  String get eventInProgress => 'Oraintxe jokatzen';

  @override
  String get finished => 'Amaituta';

  @override
  String get abortGame => 'Partida geldiarazi';

  @override
  String get gameAborted => 'Geldiarazitako partida';

  @override
  String get standard => 'Ohikoa';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Mugagabea';

  @override
  String get mode => 'Modua';

  @override
  String get casual => 'Lagunartekoa';

  @override
  String get rated => 'Sailkapenerako baliogarria';

  @override
  String get casualTournament => 'Lagunartekoa';

  @override
  String get ratedTournament => 'Sailkapenerako baliogarria';

  @override
  String get thisGameIsRated => 'Partida honek sailkapen-puntuei eragingo die';

  @override
  String get rematch => 'Errebantxa';

  @override
  String get rematchOfferSent => 'Errebantxa eskaria bidalita';

  @override
  String get rematchOfferAccepted => 'Errebantxa eskaria onartuta';

  @override
  String get rematchOfferCanceled => 'Errebantxa-eskaintza ezeztatu da';

  @override
  String get rematchOfferDeclined => 'Errebantxa-eskaintzari uko egin dio';

  @override
  String get cancelRematchOffer => 'Errebantxa-eskaintza bertan behera utzi';

  @override
  String get viewRematch => 'Errebantxa ikusi';

  @override
  String get confirmMove => 'Jokaldia baieztatu';

  @override
  String get play => 'Jokatu';

  @override
  String get inbox => 'Mezu-sarrera';

  @override
  String get chatRoom => 'Txateatzeko aretoa';

  @override
  String get loginToChat => 'Login egin txatera sartzeko';

  @override
  String get youHaveBeenTimedOut => 'Denbora muga gainditu duzu.';

  @override
  String get spectatorRoom => 'Ikusle-aretoa';

  @override
  String get composeMessage => 'Mezua idatzi';

  @override
  String get subject => 'Gaia';

  @override
  String get send => 'Bidali';

  @override
  String get incrementInSeconds => 'Segundo-gehiketa';

  @override
  String get freeOnlineChess => 'Doako xakea Interneten';

  @override
  String get exportGames => 'Partidak esportatu';

  @override
  String get ratingRange => 'Aurkariaren puntuazio-tartea';

  @override
  String get thisAccountViolatedTos => 'Kontu honek Lichessen Erabilera Baldintzak urratu egin ditu';

  @override
  String get openingExplorerAndTablebase => 'Hasiera arakatzailea & finalen datu-basea';

  @override
  String get takeback => 'Jokaldia atzera egin';

  @override
  String get proposeATakeback => 'Jokaldia atzera egiteko eskatu';

  @override
  String get takebackPropositionSent => 'Jokaldia atzera egiteko eskaria bidali da';

  @override
  String get takebackPropositionDeclined => 'Jokaldia atzera egiteko eskaria ezeztatu da';

  @override
  String get takebackPropositionAccepted => 'Jokaldia atzera egiteko eskaria onartu da';

  @override
  String get takebackPropositionCanceled => 'Jokaldia atzera egiteko eskaria ezeztatu da';

  @override
  String get yourOpponentProposesATakeback => 'Zure aurkariak jokaldia atzera egiteko eskatu dizu';

  @override
  String get bookmarkThisGame => 'Partida hau nabarmendu';

  @override
  String get tournament => 'Txapelketa';

  @override
  String get tournaments => 'Txapelketak';

  @override
  String get tournamentPoints => 'Txapelketa-puntuak';

  @override
  String get viewTournament => 'Txapelketa ikusi';

  @override
  String get backToTournament => 'Txapelketara itzuli';

  @override
  String get noDrawBeforeSwissLimit => 'Ezin duzu 30 jokaldi baino lehen berdinketa egin Txapelketa Suitzar baten.';

  @override
  String get thematic => 'Hasiera finkoduna';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Zure $param sailkapena behin-behinekoa';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Zure $param1 sailkapena ($param2) altuegia da';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Zure asteko $param1 sailkapen onena ($param2) altuegia da';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Zure $param1 sailkapena ($param2) baxuegia da';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param1 baino sailkapen handiagoa $param2-n';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param1 baino sailkapen txikiagoa $param2-n';
  }

  @override
  String mustBeInTeam(String param) {
    return '$param taldean egon behar da';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Ez zaude $param taldean';
  }

  @override
  String get backToGame => 'Partidara itzuli';

  @override
  String get siteDescription => 'Doako xake zerbitzaria. Xakean interfaze argiarekin jokatu. Izena ematea ez da beharrezkoa. Iragarkirik gabe. Jokatu xakean ordenagailu, lagun edo beste aurkariekin.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 $param2 taldean sartu da';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1(e)k $param2 taldea sortu du';
  }

  @override
  String get startedStreaming => 'emanaldiarekin hasi da';

  @override
  String xStartedStreaming(String param) {
    return '$param emanaldiarekin hasi da';
  }

  @override
  String get averageElo => 'Bataz besteko puntuazioa';

  @override
  String get location => 'Lokalizazioa';

  @override
  String get filterGames => 'Partidak filtratu';

  @override
  String get reset => 'Berrezarri';

  @override
  String get apply => 'Gorde';

  @override
  String get save => 'Gorde';

  @override
  String get leaderboard => 'Jokalaririk onenak';

  @override
  String get screenshotCurrentPosition => 'Uneko posizioaren irudia';

  @override
  String get gameAsGIF => 'Partida GIF gisa';

  @override
  String get pasteTheFenStringHere => 'FEN-a kodea hemen jarri';

  @override
  String get pasteThePgnStringHere => 'PGN-a kodea hemen jarri';

  @override
  String get orUploadPgnFile => 'Edo kargatu PGN fitxategi bat';

  @override
  String get fromPosition => 'Posizio jakin batetik';

  @override
  String get continueFromHere => 'Hemendik jarraitu';

  @override
  String get toStudy => 'Aztertu';

  @override
  String get importGame => 'Partida inportatu';

  @override
  String get importGameExplanation => 'PGN partida bat itsastean ikusi daitekeen partida bat lortuko duzu, partidare eta analisiarekin, txatarekin eta elkarbanatu dezakezun helbide batekin.';

  @override
  String get importGameCaveat => 'Aldaerak ezabatu egingo dira. Mantendu nahi badituzu inportatu PGNa azterlan gisa.';

  @override
  String get importGameDataPrivacyWarning => 'PGN hau edonork deskargatu dezake. Partida bat era pribatuan inportatzeko azterlan bat erabili behar duzu.';

  @override
  String get thisIsAChessCaptcha => 'Hau xake-CAPTCHA bat da';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Egizu jokaldia taulan, gizakia zarela frogatzeko.';

  @override
  String get captcha_fail => 'Ebatzi xake captcha mesedez.';

  @override
  String get notACheckmate => 'Hori ez da xake-matea!';

  @override
  String get whiteCheckmatesInOneMove => 'Zuriek xake-mate jokaldi bakarrean';

  @override
  String get blackCheckmatesInOneMove => 'Beltzek xake-mate jokaldi bakarrean';

  @override
  String get retry => 'Berriro saiatu';

  @override
  String get reconnecting => 'Konektatuz';

  @override
  String get noNetwork => 'Deskonektatuta';

  @override
  String get favoriteOpponents => 'Gogoko aurkariak';

  @override
  String get follow => 'Jarraitu';

  @override
  String get following => 'Jarraitzen';

  @override
  String get unfollow => 'Jarraitzeari uztea';

  @override
  String followX(String param) {
    return 'Jarraitu $param';
  }

  @override
  String unfollowX(String param) {
    return 'Utzi $param jarraitzeari';
  }

  @override
  String get block => 'Blokeatu';

  @override
  String get blocked => 'Blokeatuta';

  @override
  String get unblock => 'Desblokeatu';

  @override
  String get followsYou => 'Zu jarraitzen';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1  $param2  jarraitzen hasi da';
  }

  @override
  String get more => 'Gehiago';

  @override
  String get memberSince => 'Noiztik kidea:';

  @override
  String lastSeenActive(String param) {
    return 'Azken aldiz online: $param';
  }

  @override
  String get player => 'Jokalaria';

  @override
  String get list => 'Zerrenda';

  @override
  String get graph => 'Grafikoa';

  @override
  String get required => 'Beharrezkoa.';

  @override
  String get openTournaments => 'Txapelketa irekiak';

  @override
  String get duration => 'Iraupena';

  @override
  String get winner => 'Irabazlea';

  @override
  String get standing => 'Sailkapen-taula';

  @override
  String get createANewTournament => 'Txapelketa berria sortu';

  @override
  String get tournamentCalendar => 'Txapelketa-egutegia';

  @override
  String get conditionOfEntry => 'Parte hartzeko baldintza:';

  @override
  String get advancedSettings => 'Ezarpen aurreratuak';

  @override
  String get safeTournamentName => 'Adeitasunezko izena hauta ezazu.';

  @override
  String get inappropriateNameWarning => 'Errespetua galduz gero, zure kontua itxiko dugu.';

  @override
  String get emptyTournamentName => 'Ez baduzu betetzen, txapelketak Maisu Handi baten izena hartuko du, ausaz.';

  @override
  String get makePrivateTournament => 'Txapelketa pribatu egin eta sarrera pasahitzarekin babestu';

  @override
  String get join => 'Sartu';

  @override
  String get withdraw => 'Txapelketa utzi';

  @override
  String get points => 'Puntuak';

  @override
  String get wins => 'Irabazitakoak';

  @override
  String get losses => 'Porrotak';

  @override
  String get createdBy => 'Sortuta';

  @override
  String get tournamentIsStarting => 'Txapelketa hasiko da';

  @override
  String get tournamentPairingsAreNowClosed => 'Txapelketaren parekatzeak itxita daude jada.';

  @override
  String standByX(String param) {
    return 'Itxaron $param, jokalariak parekatzen, egon prest!';
  }

  @override
  String get pause => 'Gelditu';

  @override
  String get resume => 'Berrekin';

  @override
  String get youArePlaying => 'Jokatzen ari zara!';

  @override
  String get winRate => 'Irabazien ratioa';

  @override
  String get berserkRate => 'Berserk ratioa';

  @override
  String get performance => 'Performancea';

  @override
  String get tournamentComplete => 'Txapelketa amaitu da';

  @override
  String get movesPlayed => 'Egindako jokaldiak';

  @override
  String get whiteWins => 'Zurien irabaziak';

  @override
  String get blackWins => 'Beltzen irabaziak';

  @override
  String get drawRate => 'Berdinketa-tasa';

  @override
  String get draws => 'Berdinketak';

  @override
  String nextXTournament(String param) {
    return 'Hurrengo $param txapelketa:';
  }

  @override
  String get averageOpponent => 'Aurkarien batazbestekoa';

  @override
  String get boardEditor => 'Taula-editorea';

  @override
  String get setTheBoard => 'Xake-taula konfiguratu';

  @override
  String get popularOpenings => 'Hasiera ohikoenak';

  @override
  String get endgamePositions => 'Finalen posizioak';

  @override
  String chess960StartPosition(String param) {
    return '960Xakearen hasiera posizioa: $param';
  }

  @override
  String get startPosition => 'Hasierako posizioa';

  @override
  String get clearBoard => 'Pieza guztiak kendu';

  @override
  String get loadPosition => 'Posizioa kargatu';

  @override
  String get isPrivate => 'Pribatua';

  @override
  String reportXToModerators(String param) {
    return '${param}ren berri eman moderatzaileei';
  }

  @override
  String profileCompletion(String param) {
    return 'Profilaren osaera: $param';
  }

  @override
  String xRating(String param) {
    return '$param sailkapena';
  }

  @override
  String get ifNoneLeaveEmpty => 'Ez baduzu, hutsik utzi';

  @override
  String get profile => 'Profila';

  @override
  String get editProfile => 'Nire profila editatu';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Ezarri zure iruditxoa';

  @override
  String get flair => 'Iruditxoa';

  @override
  String get youCanHideFlair => 'Webgune guztian zehar erabiltzaile guztien iruditxoak ezkutatzeko ezarpen bat dago.';

  @override
  String get biography => 'Biografia';

  @override
  String get countryRegion => 'Herrialdea';

  @override
  String get thankYou => 'Eskerrik asko!';

  @override
  String get socialMediaLinks => 'Sare sozialen loturak';

  @override
  String get oneUrlPerLine => 'Lerro bakoitzeko URL bat.';

  @override
  String get inlineNotation => 'Lerroarteko oharrak';

  @override
  String get makeAStudy => 'Ondo gorde eta partekatzeko sortu azterlan bat.';

  @override
  String get clearSavedMoves => 'Garbitu jokaldiak';

  @override
  String get previouslyOnLichessTV => 'Aurreko Lichess TV saioak';

  @override
  String get onlinePlayers => 'Konektatutako jokalariak';

  @override
  String get activePlayers => 'Jokalari aktiboak';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Kontuz!  erlojurik eduki ez arren, partida hau puntuagarria da!';

  @override
  String get success => 'Zorionak';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Mugitu ondoren, hurrengo partidara joan';

  @override
  String get autoSwitch => 'Hurrengo partidara';

  @override
  String get puzzles => 'Ariketak';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Izena';

  @override
  String get description => 'Deskribapena';

  @override
  String get descPrivate => 'Deskribapen pribatua';

  @override
  String get descPrivateHelp => 'Taldekideek bakarrik ikusiko duten testua. Ezarrita badago, taldekideei taldearen deskribapenaren ordez agertuko zaie testu hau.';

  @override
  String get no => 'Ez';

  @override
  String get yes => 'Bai';

  @override
  String get help => 'Laguntza:';

  @override
  String get createANewTopic => 'Gai berria sortu';

  @override
  String get topics => 'Gaiak';

  @override
  String get posts => 'Mezuak';

  @override
  String get lastPost => 'Azken mezua';

  @override
  String get views => 'Bisitak';

  @override
  String get replies => 'Erantzunak';

  @override
  String get replyToThisTopic => 'Gai honi erantzun';

  @override
  String get reply => 'Erantzun';

  @override
  String get message => 'Mezua';

  @override
  String get createTheTopic => 'Gai bat sortu';

  @override
  String get reportAUser => 'Erabiltzaile bat salatu';

  @override
  String get user => 'Erabiltzailea';

  @override
  String get reason => 'Arrazoia';

  @override
  String get whatIsIheMatter => 'Zein da arazoa?';

  @override
  String get cheat => 'Tranpak';

  @override
  String get troll => 'Trolla';

  @override
  String get other => 'Bestelakoak';

  @override
  String get reportDescriptionHelp => 'Partidaren esteka itsasi, eta azaldu zer egin duen gaizki erabiltzaileak. Ez esan \"tranpak egiten ditu\" bakarrik, eman horren arrazoiak. Zure mezua azkarrago begiratuko dugu ingelesez idazten baduzu.';

  @override
  String get error_provideOneCheatedGameLink => 'Iruzurra izandako partida baten lotura bidali gutxienez.';

  @override
  String by(String param) {
    return 'egilea $param';
  }

  @override
  String importedByX(String param) {
    return '$param erabiltzaileak inportatuta';
  }

  @override
  String get thisTopicIsNowClosed => 'Gai hau itxita dago.';

  @override
  String get blog => 'Bloga';

  @override
  String get notes => 'Oharrak';

  @override
  String get typePrivateNotesHere => 'Ohar pribatuak idatzi hemen';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Idatzi erabiltzaile honi buruzko ohar pribatua';

  @override
  String get noNoteYet => 'Ez dago oharrik';

  @override
  String get invalidUsernameOrPassword => 'Erabiltzaile edo pasahitz okerra';

  @override
  String get incorrectPassword => 'Pasahitza ez da zuzena';

  @override
  String get invalidAuthenticationCode => 'Autentikazio kodea ez da zuzena';

  @override
  String get emailMeALink => 'Esteka postaz bidali';

  @override
  String get currentPassword => 'Oraingo pasahitza';

  @override
  String get newPassword => 'Pasahitz berria';

  @override
  String get newPasswordAgain => 'Pasahitz berria (berriro)';

  @override
  String get newPasswordsDontMatch => 'Pasahitz berriak ez datoz bat';

  @override
  String get newPasswordStrength => 'Pasahitzaren indarra';

  @override
  String get clockInitialTime => 'Erlojuaren hasierako denbora';

  @override
  String get clockIncrement => 'Denbora gehigarria';

  @override
  String get privacy => 'Pribatutasuna';

  @override
  String get privacyPolicy => 'Pribatutasun politika';

  @override
  String get letOtherPlayersFollowYou => 'Beste jokalari batzuk zu jarraitzea baimendu';

  @override
  String get letOtherPlayersChallengeYou => 'Beste jokalari batzuk erronka egin dezatela baimentzea';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Utzi beste jokalari batzuei zu ikerketetara gonbidatzen';

  @override
  String get sound => 'Soinua';

  @override
  String get none => 'Desaktibaturik';

  @override
  String get fast => 'Arina';

  @override
  String get normal => 'Normala';

  @override
  String get slow => 'Geldoa';

  @override
  String get insideTheBoard => 'Taula barruan';

  @override
  String get outsideTheBoard => 'Taulatik kanpo';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Partida moteletan';

  @override
  String get always => 'Beti';

  @override
  String get never => 'Inoiz ere ez';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 $param2-(e)n jokatzen ari da';
  }

  @override
  String get victory => 'Garaipena';

  @override
  String get defeat => 'Porrota';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 - $param2, $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 - $param2, $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 - $param2, $param3';
  }

  @override
  String get timeline => 'Denbora-lerroa';

  @override
  String get starting => 'Hasten da:';

  @override
  String get allInformationIsPublicAndOptional => 'Informazio guztia publiko eta aukerakoa da';

  @override
  String get biographyDescription => 'Esan zerbait zuri buruz, zer gustatzen zaizun xakean, zure hasiera gogokoenak, jokalariak…';

  @override
  String get listBlockedPlayers => 'Blokeatu dituzun jokalarien zerrenda';

  @override
  String get human => 'Gizakia';

  @override
  String get computer => 'Ordenagailua';

  @override
  String get side => 'Kolorea';

  @override
  String get clock => 'Erlojua';

  @override
  String get opponent => 'Aurkaria';

  @override
  String get learnMenu => 'Ikasi';

  @override
  String get studyMenu => 'Azterlanak';

  @override
  String get practice => 'Ikasi eta probatu';

  @override
  String get community => 'Komunitatea';

  @override
  String get tools => 'Tresnak';

  @override
  String get increment => 'Gehikuntza';

  @override
  String get error_unknown => 'Balioa ez da zuzena';

  @override
  String get error_required => 'Koadro hau betetzea nahitaezkoa da';

  @override
  String get error_email => 'Posta elektronikoa ez da zuzena';

  @override
  String get error_email_acceptable => 'Posta elektroniko hau ezin dugu onartu. Egiaztatu ezazu eta saiatu berriz.';

  @override
  String get error_email_unique => 'Posta elektronikoa ez da zuzena edo norbaitek hartua du';

  @override
  String get error_email_different => 'Hau zure posta elektronikoa da';

  @override
  String error_minLength(String param) {
    return 'Gutxieneko luzera $param da';
  }

  @override
  String error_maxLength(String param) {
    return 'Gehieneko luzera $param da';
  }

  @override
  String error_min(String param) {
    return '$param edo handiagoa izan behar da';
  }

  @override
  String error_max(String param) {
    return '$param edo txikiagoa izan behar da';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Puntuazioa  ± $param tartean badago';
  }

  @override
  String get ifRegistered => 'Izena emanda badago';

  @override
  String get onlyExistingConversations => 'Existitzen diren elkarrizketak bakarrik';

  @override
  String get onlyFriends => 'Lagunak soilik';

  @override
  String get menu => 'Menua';

  @override
  String get castling => 'Endrokea';

  @override
  String get whiteCastlingKingside => 'Zuriak O-O';

  @override
  String get blackCastlingKingside => 'Beltzak O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Jokatzen egondako denbora: $param';
  }

  @override
  String get watchGames => 'Partidak ikusi';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'TV ikusten egondako denbora: $param';
  }

  @override
  String get watch => 'Ikusi';

  @override
  String get videoLibrary => 'Bideo-bilduma';

  @override
  String get streamersMenu => 'Esatariak';

  @override
  String get mobileApp => 'Aplikazio mugikorra';

  @override
  String get webmasters => 'Webguneen kudeatzaileak';

  @override
  String get about => 'Honi buruz';

  @override
  String aboutX(String param) {
    return '$param-i buruz';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 doako ($param2), libre, iragarki-gabeko eta kode irekiko xake zerbitzaria da.';
  }

  @override
  String get really => 'benetan';

  @override
  String get contribute => 'Lichessi lagundu';

  @override
  String get termsOfService => 'ToS';

  @override
  String get sourceCode => 'Iturburu kodea';

  @override
  String get simultaneousExhibitions => 'Aldibereko partidak';

  @override
  String get host => 'Sortzailea';

  @override
  String hostColorX(String param) {
    return 'Emango duenaren kolorea: $param';
  }

  @override
  String get yourPendingSimuls => 'Zain dituzun aldi bereko partidak';

  @override
  String get createdSimuls => 'Aldibereko partida sortuberriak';

  @override
  String get hostANewSimul => 'Aldibereko partida sortu';

  @override
  String get signUpToHostOrJoinASimul => 'Eman izena aldibereko partida bat antolatu edo jokatzeko';

  @override
  String get noSimulFound => 'Aldibereko partida ez da aurkitu';

  @override
  String get noSimulExplanation => 'Aldibereko partida ez da existitzen';

  @override
  String get returnToSimulHomepage => 'Aldibereko partiden orrialdera itzuli';

  @override
  String get aboutSimul => 'Aldibereko partidetan jokalari batek beste batzuei egiten die aurre aldi berean.';

  @override
  String get aboutSimulImage => '50 aurkariren aurka, Fischerrek 47 partida irabazi zituen, 2 berdindu eta  bat  bakarra galdu.';

  @override
  String get aboutSimulRealLife => 'Benetako bizitzan bezala, aldibereko jokalaria taulaz taula mugitu egiten da bere jokaldia eginez.';

  @override
  String get aboutSimulRules => 'Aldibereko partidak hastean, aldibereko jokalariak pieza zuriekin hasten du partida bana. Aldibereko erakusketa partida guztiak amaitzean amaitzen da.';

  @override
  String get aboutSimulSettings => 'Aldibereko partidetan puntuazioak ez dira sekula aldatzen.  Ezin da errebantxarik, atzera-jokatzerik edo-eta denbora-gehitzerik erabili.';

  @override
  String get create => 'Sortu';

  @override
  String get whenCreateSimul => 'Aldiberekoa sortzean, jokalari guztien aurka batera jokatu behar duzu.';

  @override
  String get simulVariantsHint => 'Aldaera batzuk hautatzen badituzu, jokalari bakoitzak nahi duena aukeratuko du';

  @override
  String get simulClockHint => 'Fischer erloju doikuntza. Zenbat eta jokalari gehiagoren aurka jokatua,  are denbora gehiago behar izango duzu';

  @override
  String get simulAddExtraTime => 'Aldibereko partidetan aritu ahal izateko, agian  denbora gehiago gehitu beharko diozu zure erlojuari';

  @override
  String get simulHostExtraTime => 'Denbora gehitu erlojuan';

  @override
  String get simulAddExtraTimePerPlayer => 'Aldibereko partidara sartzen den jokalari bakoitzagatik denbora gehitu zure erlojuan.';

  @override
  String get simulHostExtraTimePerPlayer => 'Jokalari bakoitzeko denbora gehigarria';

  @override
  String get lichessTournaments => 'Lichess txapelketak';

  @override
  String get tournamentFAQ => 'Arena txapelketaren ohiko galderak';

  @override
  String get timeBeforeTournamentStarts => 'Txapelketa hasteko denbora';

  @override
  String get averageCentipawnLoss => 'Bataz besteko peoi-ehuneko galera';

  @override
  String get accuracy => 'Zehaztasuna';

  @override
  String get keyboardShortcuts => 'Tekla laguntzaileak';

  @override
  String get keyMoveBackwardOrForward => 'Aurrerantz edo atzerantz mugitu';

  @override
  String get keyGoToStartOrEnd => 'Hasierara edo azkenea joan';

  @override
  String get keyCycleSelectedVariation => 'Aldatu aukeratutako ingurabideetan';

  @override
  String get keyShowOrHideComments => 'Iruzkinak erakutsi/ezkutatu';

  @override
  String get keyEnterOrExitVariation => 'Aldaerara sartu/atera';

  @override
  String get keyRequestComputerAnalysis => 'Ordenagailuaren analisia eskatu. Ikasi zure akatsak aztertuz';

  @override
  String get keyNextLearnFromYourMistakes => 'Hurrengoa (ikasi zure akatsak aztertuz)';

  @override
  String get keyNextBlunder => 'Hurrengo hanka-sartzea';

  @override
  String get keyNextMistake => 'Hurrengo akatsa';

  @override
  String get keyNextInaccuracy => 'Hurrengo akats arina';

  @override
  String get keyPreviousBranch => 'Aurreko adarra';

  @override
  String get keyNextBranch => 'Hurrengo adarra';

  @override
  String get toggleVariationArrows => 'Aktibatu/desaktibatu ingurabidearen geziak';

  @override
  String get cyclePreviousOrNextVariation => 'Aldatu aurreko/hurrengo ingurabidean';

  @override
  String get toggleGlyphAnnotations => 'Aktibatu/Desaktibatu ikur bidezko oharrak';

  @override
  String get togglePositionAnnotations => 'Aktibatu/Desaktibatu posizioko oharrak';

  @override
  String get variationArrowsInfo => 'Ingurabidearen geziek jokaldi zerrenda erabili gabe nabigatzen uzten dute.';

  @override
  String get playSelectedMove => 'jokatu aukeratutako jokaldia';

  @override
  String get newTournament => 'Txapelketa berria';

  @override
  String get tournamentHomeTitle => 'Xake-txapelketak, aldaera eta denbora-kontrol batzuekin.';

  @override
  String get tournamentHomeDescription => 'Txapelketa azkarrak jokatu! Txapelketa batetara sartu, edo zeurea sortu.  Bullet, Blitz, Klasikoa, Xake960, Erregeatontorrean, Hiruxake eta aukera  gehiago, xake dibertsio amaigabea lortzeko.';

  @override
  String get tournamentNotFound => 'Txapelketa ez da aurkitu';

  @override
  String get tournamentDoesNotExist => 'Txapelketa hau ez dago';

  @override
  String get tournamentMayHaveBeenCanceled => 'Agian bertan behera geratu da, jokalari guztiak atera direlako hasi baino lehen.';

  @override
  String get returnToTournamentsHomepage => 'Txapelketako orrialde nagusira itzuli';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Asteko $param puntuazioaren banaketa';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Zure $param1 balorazioa $param2 da.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return '$param1 baino hobea zara, $param2 jokalaritik.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 $param3 jokalarien $param2 baino hobea da.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return '$param2 jokalaritik $param1 baino hobea';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Ez duzu zehaztutako $param baloraziorik.';
  }

  @override
  String get yourRating => 'Zure puntuazioa';

  @override
  String get cumulative => 'Metaketa';

  @override
  String get glicko2Rating => 'Glicko-2 puntuazioa';

  @override
  String get checkYourEmail => 'Zure emailean begiratu';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Email mezua  bidali dizugu. Zure kontua aktibatzeko, egizu klik mezuan.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ez baduzu mezua aurkitzen, begiratu beste tokietan: zaborrontzian, spam karpetan, ...';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Mezu bat bidali dugu $param helbidera. Egizu klik mezuan zure pasahitza berrizteko.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Izena ematean, gure $param onartzen dituzu.';
  }

  @override
  String readAboutOur(String param) {
    return 'Irakurri gure $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Sarearen atzerapena Lichessen eta zure artean';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Lichess zerbitzariak jokaldi bat egiteko denbora';

  @override
  String get downloadAnnotated => 'Oharrekin jaitsi';

  @override
  String get downloadRaw => 'Oharrik gabe jaitsi';

  @override
  String get downloadImported => 'Igo zen moduan jaitsi';

  @override
  String get crosstable => 'Aurreko emaitzak';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Partidan aurrera-atzera egiteko, korritze-barra ere erabili ahal duzu.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Jarri sagua ordenagailuaren aukeren gainean berauek ikusteko.';

  @override
  String get analysisShapesHowTo => 'Zirkuluak eta geziak marrazteko, egizu shift+klik edo eskuin-klik.';

  @override
  String get letOtherPlayersMessageYou => 'Utzi beste jokalariei zuri mezuak bidaltzen';

  @override
  String get receiveForumNotifications => 'Jaso jakinarazpenak foroan aipatzen zaituztenean';

  @override
  String get shareYourInsightsData => 'Zure partiden analitika partekatu';

  @override
  String get withNobody => 'Inorekin ere ez';

  @override
  String get withFriends => 'Lagunekin';

  @override
  String get withEverybody => 'Edonorekin';

  @override
  String get kidMode => 'Haurren modua';

  @override
  String get kidModeIsEnabled => 'Haur-modua aktibatuta dago.';

  @override
  String get kidModeExplanation => 'Hau segurtasunari buruzkoa da. Haurren moduan, webguneko komunikazio guztiak desaktibatuta daude. Aktibatu zure haur eta ikasleei beste Internet erabiltzaileengandik babesteko.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'Haurren moduan, lichess logoak $param ikonoa du, haurrak seguru daudela jakin dezazun.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Zure kontua beste norbaitek kudeatzen du. Eskatu zure irakasleari haur modua desaktibatzeko.';

  @override
  String get enableKidMode => 'Haurren modua aktibatu';

  @override
  String get disableKidMode => 'Haurren modua desaktibatu';

  @override
  String get security => 'Segurtasuna';

  @override
  String get sessions => 'Saioak';

  @override
  String get revokeAllSessions => 'sesio guztiak itxi';

  @override
  String get playChessEverywhere => 'Jokatu xakean, nonnahi';

  @override
  String get asFreeAsLichess => 'Debalde, lichess bezala';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Xakea maite dugulako sortuta, ez diruagatik.';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Ezaugarri guztiak eskuragarri, dohain.';

  @override
  String get zeroAdvertisement => 'Publizitaterik gabe';

  @override
  String get fullFeatured => 'Aukeraz beteta';

  @override
  String get phoneAndTablet => 'Sakelekoan zein tabletan';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, klasikoa';

  @override
  String get correspondenceChess => 'Posta-xakea';

  @override
  String get onlineAndOfflinePlay => 'Online zein offline jokatu';

  @override
  String get viewTheSolution => 'Erantzuna ikusi';

  @override
  String get followAndChallengeFriends => 'Jarraitu eta desafio egin lagunei';

  @override
  String get gameAnalysis => 'Partidaren analisia';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 erabiltzaileak $param2 antolatu du';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 ${param2}ra sartu da';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '${param1}k $param2 gogoko du';
  }

  @override
  String get quickPairing => 'Parekatze azkarra';

  @override
  String get lobby => 'Egongela';

  @override
  String get anonymous => 'Anonimoa';

  @override
  String yourScore(String param) {
    return 'Zure puntuaketa: $param';
  }

  @override
  String get language => 'Hizkuntza';

  @override
  String get background => 'Atzeko planoa';

  @override
  String get light => 'Argia';

  @override
  String get dark => 'Iluna';

  @override
  String get transparent => 'Gardena';

  @override
  String get deviceTheme => 'Gailuaren gaia';

  @override
  String get backgroundImageUrl => 'Atzeko-planoko irudia:';

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
  String get pieceSet => 'Pieza formatua';

  @override
  String get embedInYourWebsite => 'Zure webgunean txertatu';

  @override
  String get usernameAlreadyUsed => 'Erabiltzaile izen hori hartuta dago, erabili beste bat.';

  @override
  String get usernamePrefixInvalid => 'Erabiltzaile izena hizki batekin hasi behar da.';

  @override
  String get usernameSuffixInvalid => 'Erabiltzaile izena hizki edo zenbaki batekin bukatu behar da.';

  @override
  String get usernameCharsInvalid => 'Erabiltzaile izenak hizkiak, zenbakiak, azpiko marrak eta gidoiak bakarrik izan ditzake.';

  @override
  String get usernameUnacceptable => 'Erabiltzaile hori ezin da erabili.';

  @override
  String get playChessInStyle => 'Xakean estiloarekin jokatu';

  @override
  String get chessBasics => 'Oinarrizko xakea';

  @override
  String get coaches => 'Entrenatzaileak';

  @override
  String get invalidPgn => 'PGNa ez da zuzena';

  @override
  String get invalidFen => 'FENa ez da zuzena';

  @override
  String get custom => 'Pertsonalizatua';

  @override
  String get notifications => 'Jakinarazpenak';

  @override
  String notificationsX(String param1) {
    return 'Jakinarazpenak: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Sailkapena: $param';
  }

  @override
  String get practiceWithComputer => 'Ordenagailuarekin praktikatu';

  @override
  String anotherWasX(String param) {
    return 'Beste aukera bat $param zen';
  }

  @override
  String bestWasX(String param) {
    return 'Onena $param zen';
  }

  @override
  String get youBrowsedAway => 'Beste batera joan zara';

  @override
  String get resumePractice => 'Itzuli praktikatzera';

  @override
  String get drawByFiftyMoves => 'Partida berdinketarekin amaitu da 50 jokaldien araua dela-eta.';

  @override
  String get theGameIsADraw => 'Berdinketa.';

  @override
  String get computerThinking => 'Ordenagailua pentsatzen...';

  @override
  String get seeBestMove => 'Erakutsi jokaldi onena';

  @override
  String get hideBestMove => 'Ezkutatu jokaldi onena';

  @override
  String get getAHint => 'Pista bat eman';

  @override
  String get evaluatingYourMove => 'Zure jokaldia aztertzen...';

  @override
  String get whiteWinsGame => 'Zuriek irabazi';

  @override
  String get blackWinsGame => 'Beltzek irabazi';

  @override
  String get learnFromYourMistakes => 'Ikasi zure akatsetatik';

  @override
  String get learnFromThisMistake => 'Akats honetatik ikasi';

  @override
  String get skipThisMove => 'Jokaldi hau alde batera utzi';

  @override
  String get next => 'Hurrengoa';

  @override
  String xWasPlayed(String param) {
    return '$param jokatu zen';
  }

  @override
  String get findBetterMoveForWhite => 'Bilatu zurien jokaldi hobe bat';

  @override
  String get findBetterMoveForBlack => 'Bilatu beltzen jokaldi hobe bat';

  @override
  String get resumeLearning => 'Ikasketari berrekin';

  @override
  String get youCanDoBetter => 'Hobeto egin dezakezu';

  @override
  String get tryAnotherMoveForWhite => 'Saiatu zurien beste jokaldi bat egiten';

  @override
  String get tryAnotherMoveForBlack => 'Saiatu beltzen beste jokaldi bat egiten';

  @override
  String get solution => 'Soluzioa';

  @override
  String get waitingForAnalysis => 'Analisiaren zain';

  @override
  String get noMistakesFoundForWhite => 'Ez da zurien akatsik aurkitu';

  @override
  String get noMistakesFoundForBlack => 'Ez da beltzen akatsik aurkitu';

  @override
  String get doneReviewingWhiteMistakes => 'Zurien akatsak aurkitzea bukatuta';

  @override
  String get doneReviewingBlackMistakes => 'Beltzen akatsak aurkitzea bukatuta';

  @override
  String get doItAgain => 'Egin berriz';

  @override
  String get reviewWhiteMistakes => 'Zurien akatsak bilatu';

  @override
  String get reviewBlackMistakes => 'Beltzen akatsak bilatu';

  @override
  String get advantage => 'Abantaila';

  @override
  String get opening => 'Irekiera';

  @override
  String get middlegame => 'Erdi-jokoa';

  @override
  String get endgame => 'Finala';

  @override
  String get conditionalPremoves => 'Baldintzadun aurrejokaldiak';

  @override
  String get addCurrentVariation => 'Uneko aldaera gehitu';

  @override
  String get playVariationToCreateConditionalPremoves => 'Aldaera bat jokatu baldintzadun aurre-jokaldiak sortzeko';

  @override
  String get noConditionalPremoves => 'Ez dago baldintzadun aurrejokaldirik';

  @override
  String playX(String param) {
    return '$param jokatu';
  }

  @override
  String get showUnreadLichessMessage => 'Lichessek bidalitako mezu pribatu bat jaso duzu.';

  @override
  String get clickHereToReadIt => 'Egin klik hemen irakurtzeko';

  @override
  String get sorry => 'Barkatu :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Denbora tarte baterako bota egin behar izan zaitugu.';

  @override
  String get why => 'Zergatik?';

  @override
  String get pleasantChessExperience => 'Guztioi xakean jokatzeko aukera atsegina eskaintzea da gure helburua.';

  @override
  String get goodPractice => 'Horretarako, jokalari guztiek praktika onak jarraitzen dituztela ziur izan behar dugu.';

  @override
  String get potentialProblem => 'Arazo bat aurkitzen dugunean, mezu hau erakusten dugu.';

  @override
  String get howToAvoidThis => 'Nola ekidin hau?';

  @override
  String get playEveryGame => 'Hasitako partida guztiak jokatu.';

  @override
  String get tryToWin => 'Jokatutako partida guztiak irabazten saiatu (edo gutxienez berdindu).';

  @override
  String get resignLostGames => 'Galdutako partidetan amore eman (ez utzi denbora agortzen).';

  @override
  String get temporaryInconvenience => 'Barkatu eragozpenak,';

  @override
  String get wishYouGreatGames => 'segi lichess.org-en jokatzen.';

  @override
  String get thankYouForReading => 'Eskerrik asko irakurtzeagatik!';

  @override
  String get lifetimeScore => 'Jokalari honekin duzun emaitza';

  @override
  String get currentMatchScore => 'Uneko partidetako emaitza';

  @override
  String get agreementAssistance => 'Nire partidetan ez dut inoiz laguntzarik jasoko (ordenagailuak, liburua, datu-base bat edo beste pertsona bat).';

  @override
  String get agreementNice => 'Atsegina izango naiz beste jokalariekin.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Hitz ematen dut ez dudala kontu bat baino gehiago irekiko ($param adierazitako kasuetan izan ezik).';
  }

  @override
  String get agreementPolicy => 'Lichessek ezarritako politikak beteko ditut.';

  @override
  String get searchOrStartNewDiscussion => 'Hizketaldia bilatu edo berria hasi';

  @override
  String get edit => 'Aldatu';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Aktiboa';

  @override
  String get classical => 'Estandarra';

  @override
  String get ultraBulletDesc => 'Partida oso oso azkarrak: 30 segundo baino gutxiago';

  @override
  String get bulletDesc => 'Partida oso azkarrak: 3 minutu baino gutxiago';

  @override
  String get blitzDesc => 'Partida azkarrak: 3-8 minutu artekoak';

  @override
  String get rapidDesc => 'Partida aktiboak: 8-25 minutu artekoak';

  @override
  String get classicalDesc => 'Partida estandarrak: 25 minutu edo gehiagokoak';

  @override
  String get correspondenceDesc => 'Posta bidezko partidak: egun bat edo gehiago jokaldi bakoitzeko';

  @override
  String get puzzleDesc => 'Taktika ariketak';

  @override
  String get important => 'Garrantzitsua';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Zure galderak agian badu erantzuna $param1';
  }

  @override
  String get inTheFAQ => 'SEGtan.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Erabiltzaile baten tranpa egin duela uste baduzu $param1';
  }

  @override
  String get useTheReportForm => 'erabili salaketa egiteko formularioa';

  @override
  String toRequestSupport(String param1) {
    return 'Laguntza eskatzeko $param1';
  }

  @override
  String get tryTheContactPage => 'erabili kontakturako orrialdea';

  @override
  String makeSureToRead(String param1) {
    return 'Ziurtatu $param1 irakurri duzula';
  }

  @override
  String get theForumEtiquette => 'foroko etiketa';

  @override
  String get thisTopicIsArchived => 'Mezu hau artxibatu egin da eta jada ezin da erantzunik utzi bertan.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Egin bat $param1 taldearekin foro honetan idazteko';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 taldea';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Ezin duzu foroetan idatzi. Jokatu partida batzuk!';

  @override
  String get subscribe => 'Harpidetu';

  @override
  String get unsubscribe => 'Harpidetza kendu';

  @override
  String mentionedYouInX(String param1) {
    return '\"$param1\" -n aipatu zaituzte.';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 jokalariak \"$param2\" artikuluan aipatu zaitu.';
  }

  @override
  String invitedYouToX(String param1) {
    return '\"$param1\" taldera sartzeko gonbidapena.';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 jokalariak \"$param2\" taldera gonbidatu zaitu.';
  }

  @override
  String get youAreNowPartOfTeam => 'Taldearen parte zara.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return '\"$param1\" taldera sartu zara.';
  }

  @override
  String get someoneYouReportedWasBanned => 'Zuk salatutako jokalari bat bota egin dugu';

  @override
  String get congratsYouWon => 'Zorionak, irabazi egin duzu!';

  @override
  String gameVsX(String param1) {
    return '$param1 jokalarien aurkako partida';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs. $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Lichessen Erabilpen Baldintzak urratu dituen baten aurka galdu duzu';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Itzulketa: $param1 $param2 puntu.';
  }

  @override
  String get timeAlmostUp => 'Denbora ia agortu da!';

  @override
  String get clickToRevealEmailAddress => '[Egin klik eposta helbidea erakusteko]';

  @override
  String get download => 'Deskargatu';

  @override
  String get coachManager => 'Entrenatzaileen kudeatzailea';

  @override
  String get streamerManager => 'Zuzenekoen kudeatzailea';

  @override
  String get cancelTournament => 'Bertan behera utzi txapelketa';

  @override
  String get tournDescription => 'Txapelketaren deskribapena';

  @override
  String get tournDescriptionHelp => 'Parte-hartzaileei zerbait esan nahi diezu? Markdown erako estekak erabili ditzakezu [izena](http://helbidea)';

  @override
  String get ratedFormHelp => 'Partidek jokalarien sailkapenerako balio dute';

  @override
  String get onlyMembersOfTeam => 'Talde bateko kideak bakarrik';

  @override
  String get noRestriction => 'Murrizketarik ez';

  @override
  String get minimumRatedGames => 'Gutxieneko partida kopurua';

  @override
  String get minimumRating => 'Gutxieneko sailkapena';

  @override
  String get maximumWeeklyRating => 'Asteroko gehieneko sailkapena';

  @override
  String positionInputHelp(String param) {
    return 'Partida guztiak posizio jakin batekin asteko sartu posizioaren FEN balioa.\nXake-arrunteko partidekin bakarrik balio du, ez aldaerekin.\n$param erabili dezakezu FEN balioa lortzeko, eta ondoren hemen itsatsi.\nUtzi hutsik partidak ohiko posizioarekin hasteko.';
  }

  @override
  String get cancelSimul => 'Utzi bertan behera aldi-berekoa';

  @override
  String get simulHostcolor => 'Aldi-berekoa ematen duenaren kolorea';

  @override
  String get estimatedStart => 'Ustezko hasiera ordua';

  @override
  String simulFeatured(String param) {
    return 'Destakatu hemen: $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Erakutsi zure aldi-berekoa mundu guztiari $param helbideak. Desaktibatu aldi-bereko pribatuentzat.';
  }

  @override
  String get simulDescription => 'Aldi-berekoaren deskribapena';

  @override
  String get simulDescriptionHelp => 'Parte-hartzaileei zerbait esan nahi diezu?';

  @override
  String markdownAvailable(String param) {
    return '$param erabili dezakezu.';
  }

  @override
  String get embedsAvailable => 'Itsatsi partida baten URL helbidea, azterlan baten atal baten URL helbidea hemen erakusteko.';

  @override
  String get inYourLocalTimezone => 'Zure ordu-zonan';

  @override
  String get tournChat => 'Txapelketaren txata';

  @override
  String get noChat => 'Txatik ez';

  @override
  String get onlyTeamLeaders => 'Taldeen kapitainak bakarrik';

  @override
  String get onlyTeamMembers => 'Taldeen kideak bakarrik';

  @override
  String get navigateMoveTree => 'Nabigatu jokaldien zuhaitza';

  @override
  String get mouseTricks => 'Saguaren trukuak';

  @override
  String get toggleLocalAnalysis => 'Aktibatu ordenagailu lokaleko analisia';

  @override
  String get toggleAllAnalysis => 'Aktibatu ordenagailu guztietako analisia';

  @override
  String get playComputerMove => 'Jokatu ordenagailuaren jokaldi onena';

  @override
  String get analysisOptions => 'Analisiaren aukerak';

  @override
  String get focusChat => 'Eraman fokua txatera';

  @override
  String get showHelpDialog => 'Erakutsi laguntza leiho hau';

  @override
  String get reopenYourAccount => 'Berreskuratu zure kontua';

  @override
  String get closedAccountChangedMind => 'Zure kontua itxi bazenuen baina berreskuratu nahi baduzu, aukera bakarra duzu hori egiteko.';

  @override
  String get onlyWorksOnce => 'Honek behin bakarrik funtzionatuko du.';

  @override
  String get cantDoThisTwice => 'Zure kontua bigarren aldiz ixten baduzu ezingo duzu berriz berreskuratu.';

  @override
  String get emailAssociatedToaccount => 'Posta elektronikoa ondo lotu da zure kontura';

  @override
  String get sentEmailWithLink => 'Posta elektroniko bat bidali dizugu lotura batekin.';

  @override
  String get tournamentEntryCode => 'Txapelketara sartzeko kodea';

  @override
  String get hangOn => 'Itxaron!';

  @override
  String gameInProgress(String param) {
    return '$param erabiltzailearekin partida bat jokatzen ari zara.';
  }

  @override
  String get abortTheGame => 'Partida bertan behera utzi';

  @override
  String get resignTheGame => 'Partida utzi';

  @override
  String get youCantStartNewGame => 'Ezin duzu beste partidarik hasi hau bukatu arte.';

  @override
  String get since => 'Noiztik';

  @override
  String get until => 'Noiz arte';

  @override
  String get lichessDbExplanation => 'Lichesseko jokalari guztien artetik aukeratutako partidetatik aterata';

  @override
  String get switchSides => 'Aldatu kolorea';

  @override
  String get closingAccountWithdrawAppeal => 'Kontua ixten baduzu, zure kexa bertan behera geldituko da';

  @override
  String get ourEventTips => 'Txapelketak antolatzeko gure aholkuak';

  @override
  String get instructions => 'Jarraibideak';

  @override
  String get showMeEverything => 'Erakutsi guztia';

  @override
  String get lichessPatronInfo => 'Lichess software librea da.\nGarapen eta mantentze-kostu guztiak erabiltzaileen dohaintzekin ordaintzen dira.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zure aurkariak partida utzi egin du. Partida irabaztea eskatu dezakezu $count segundotan.',
      one: 'Zure aurkariak partida utzi egin du. Partida irabaztea eskatu dezakezu segundo ${count}en.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mate $count jokaldi erditan',
      one: 'Mate jokaldi erdi ${count}n',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hanka-sartze',
      one: 'Hanka-sartze $count',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count akats',
      one: 'Akats $count',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count akats txiki',
      one: 'Akats txiki $count',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jokalari',
      one: '$count Jokalari',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partida',
      one: '$count partida',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntuazioa $param2 partidatan',
      one: '$count puntuazioa partida ${param2}en',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partida nabarmenduak',
      one: '$count partida nabarmenduak',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count egun',
      one: 'Egun $count',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ordu',
      one: '$count ordu',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutu',
      one: 'Minutu $count',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sailkapena $count minuturo eguneratzen da',
      one: 'Sailkapena minutuero eguneratzen da',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ariketa',
      one: 'Ariketa $count',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partida zure aurka',
      one: '$count partida zure aurka',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sailkatutako $count',
      one: 'Sailkatutako $count',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count irabazita',
      one: '$count irabazita',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Galduta',
      one: '$count galduta',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Berdinduta',
      one: '$count berdinduta',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jokatzen',
      one: '$count jokatzen',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundo eman',
      one: 'Segundo $count eman',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count txapelketa puntu',
      one: 'Txapelketa puntu $count',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count azterlan',
      one: 'Azterlan $count',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aldibereko',
      one: 'Aldibereko $count',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sailkapenerako $count partida baino gehiago',
      one: 'Sailkapenerako partida $count baino gehiago',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 partida baino gehiago',
      one: '$param2 partida $count baino gehiago',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sailkapenerako balio duten beste $param2 partida $count jokatu behar dituzu',
      one: 'Sailkapenerako balio duen beste $param2 partida $count jokatu behar duzu',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sailkapenerako balio duten beste $count partida jokatu behar dituzu',
      one: 'Sailkapenerako balio duen beste partida $count jokatu behar duzu',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count inportatutako partidak',
      one: '$count inportatutako partidak',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lagun konektatuta',
      one: 'Lagun $count konektatuta',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jarraitzaile',
      one: '$count jarraitzaile',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jarraituak',
      one: '$count Jarraituak',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutu baino gutxiago',
      one: '$count minutu baino gutxiago',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partida une honetan',
      one: '$count partida une honetan',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gehienez: $count karaktere',
      one: 'Gehienez: $count karaktere',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blokeatuta',
      one: '$count blokeatuta',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Foroko $count mezu',
      one: 'Foroko mezu $count',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 jokalari aste honetan.',
      one: '$count $param2 jokalari aste honetan.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hizkuntzatan eskuragarri!',
      one: '$count hizkuntzatan eskuragarri!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundo lehenengo jokaldia egiteko',
      one: 'Segundo $count lehenengo jokaldia egiteko',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundo',
      one: 'Segundo $count',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'eta $count aurrejokaldi linea gorde',
      one: 'eta aurrejokaldi linea $count gorde',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Mugitu hasteko';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Ariketa guztietan pieza zuriekin jokatuko duzu';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Ariketa guztietan pieza beltzekin jokatuko duzu';

  @override
  String get stormPuzzlesSolved => 'ariketa ebatzita';

  @override
  String get stormNewDailyHighscore => 'Eguneko marka berria!';

  @override
  String get stormNewWeeklyHighscore => 'Asteko marka berria!';

  @override
  String get stormNewMonthlyHighscore => 'Hileko marka berria!';

  @override
  String get stormNewAllTimeHighscore => 'Marka berria!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Aurreko marka $param zen';
  }

  @override
  String get stormPlayAgain => 'Jokatu berriz';

  @override
  String stormHighscoreX(String param) {
    return 'Marka: $param';
  }

  @override
  String get stormScore => 'Puntuazioa';

  @override
  String get stormMoves => 'Jokaldiak';

  @override
  String get stormAccuracy => 'Zehaztasuna';

  @override
  String get stormCombo => 'Jarraiak';

  @override
  String get stormTime => 'Denbora';

  @override
  String get stormTimePerMove => 'Jokaldiko denbora';

  @override
  String get stormHighestSolved => 'Ebatzitako altuena';

  @override
  String get stormPuzzlesPlayed => 'Jokatutako ariketak';

  @override
  String get stormNewRun => 'Saiakera berria (espazioa)';

  @override
  String get stormEndRun => 'Amaitu saiakera (enter)';

  @override
  String get stormHighscores => 'Puntuazio altuenak';

  @override
  String get stormViewBestRuns => 'Ikusi saiakera onenak';

  @override
  String get stormBestRunOfDay => 'Eguneko saiakera onena';

  @override
  String get stormRuns => 'Saiakerak';

  @override
  String get stormGetReady => 'Prest!';

  @override
  String get stormWaitingForMorePlayers => 'Jokalari gehiago sartzeko zain...';

  @override
  String get stormRaceComplete => 'Lasterketa amaitu da!';

  @override
  String get stormSpectating => 'Ikusten';

  @override
  String get stormJoinTheRace => 'Sartu lasterketara!';

  @override
  String get stormStartTheRace => 'Hasi lasterketa';

  @override
  String stormYourRankX(String param) {
    return 'Zure sailkapena: $param';
  }

  @override
  String get stormWaitForRematch => 'Itxaron berriz jokatzeko';

  @override
  String get stormNextRace => 'Hurrengo lasterketa';

  @override
  String get stormJoinRematch => 'Sartu berriz jokatzera';

  @override
  String get stormWaitingToStart => 'Hasteko zain';

  @override
  String get stormCreateNewGame => 'Sortu partida berria';

  @override
  String get stormJoinPublicRace => 'Sartu lasterketa publikora';

  @override
  String get stormRaceYourFriends => 'Jokatu zure lagunekin';

  @override
  String get stormSkip => 'salto egin';

  @override
  String get stormSkipHelp => 'Lasterketa bakoitzean jokaldi bat saltatu dezakezu:';

  @override
  String get stormSkipExplanation => 'Jokaldi hau saltatu zure bolada mantentzeko! Lasterketa bakoitzean behin bakarrik erabili dezakezu.';

  @override
  String get stormFailedPuzzles => 'Huts egindako ariketak';

  @override
  String get stormSlowPuzzles => 'Ariketa geldoak';

  @override
  String get stormSkippedPuzzle => 'Salto egindako ariketa';

  @override
  String get stormThisWeek => 'Aste honetan';

  @override
  String get stormThisMonth => 'Hilabete honetan';

  @override
  String get stormAllTime => 'Hasieratik';

  @override
  String get stormClickToReload => 'Egin klik berriz kargatzeko';

  @override
  String get stormThisRunHasExpired => 'Lasterketa hau iraungi egin da!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Lasterketa hau beste fitxa baten zabaldu da!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saiakera',
      one: 'Saiakera 1',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 ariketaren $count saiakera egin dituzu',
      one: '$param2 ariketaren saiakera bat egin duzu',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streamerrak';

  @override
  String get studyShareAndExport => 'Partekatu & esportatu';

  @override
  String get studyStart => 'Hasi';
}
