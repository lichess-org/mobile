import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Esperanto (`eo`).
class AppLocalizationsEo extends AppLocalizations {
  AppLocalizationsEo([String locale = 'eo']) : super(locale);

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
  String get activityActivity => 'Aktiveco';

  @override
  String get activityHostedALiveStream => 'Gastigis vivan rivereton';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Rangita #$param1 en $param2';
  }

  @override
  String get activitySignedUp => 'Subskribis al lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Subtenis lichess.org dum $count monatoj kiel $param2',
      one: 'Subtenis lichess.org dum $count monato kiel $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Praktikis $count poziciojn $param2',
      one: 'Praktikis $count pozicion $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Solvis $count taktikajn puzlojn',
      one: 'Solvis $count taktikan puzlon',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ludis $count $param2 ludojn',
      one: 'Ludis $count $param2 ludon',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Afiŝis $count mesaĝoj en $param2',
      one: 'Afiŝis $count mesaĝo en $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ludis $count movojn',
      one: 'Ludis $count movon',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'en $count korespondadaj ludoj',
      one: 'en $count korespondada ludo',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Finiĝis $count korespondaj ludoj',
      one: 'Finiĝis $count koresponda ludo',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Komencis sekvi $count ludantojn',
      one: 'Komencis sekvi $count ludanton',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gajnis $count novajn sekvantojn',
      one: 'Gajnis $count novan sekvanton',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gastigis $count samtempajn ekspoziciojn',
      one: 'Gastigis $count samtempan ekspozicion',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Partoprenita en $count samtempaj ekspozicioj',
      one: 'Partoprenita en $count samtempa ekspozicio',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kreis $count novajn studojn',
      one: 'Kreis $count novan studon',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Konkurencis en $count turniroj',
      one: 'Konkurencis en $count turniro',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rangita #$count (supro $param2%) kun $param3 ludoj en $param4',
      one: 'Rangita #$count (supro $param2%) kun $param3 ludo en $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Konkuris en $count svisaj turniroj',
      one: 'Konkuris en $count svisa turniro',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aliĝis $count teamoj',
      one: 'Aliĝis $count teamo',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Elsendoj';

  @override
  String get broadcastLiveBroadcasts => 'Vivaj turniraj elsendoj';

  @override
  String challengeChallengesX(String param1) {
    return 'Defioj: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Defii al nova ludo';

  @override
  String get challengeChallengeDeclined => 'Defio malakceptita';

  @override
  String get challengeChallengeAccepted => 'Defio akceptita!';

  @override
  String get challengeChallengeCanceled => 'Defio nuligita.';

  @override
  String get challengeRegisterToSendChallenges => 'Bonvolu registri por sendi defiojn.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Vi ne povas defii $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param ne akceptas defiojn.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Via rango por $param1 estas tro for de la rango de $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Ne povi defii, pro provizora $param rango.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param nur akceptas defiojn de amikoj.';
  }

  @override
  String get challengeDeclineGeneric => 'Mi ne akceptas defiojn en tiu ĉi momento.';

  @override
  String get challengeDeclineLater => 'Mi ne akceptas defiojn nun, bonvolu demandi denove poste.';

  @override
  String get challengeDeclineTooFast => 'Ĉi tempokontrolo estas tro rapida por mi, bonvolu defii denove per pli malrapida ludo.';

  @override
  String get challengeDeclineTooSlow => 'Ĉi tempokontrolo estas tro malrapida por mi, bonvolu defii denove per pli rapida ludo.';

  @override
  String get challengeDeclineTimeControl => 'Mi ne akceptas defiojn kun ĉi tiu tempokontrolo.';

  @override
  String get challengeDeclineRated => 'Bonvolu sendi al mi rangan defion anstataŭe.';

  @override
  String get challengeDeclineCasual => 'Bonvolu sendi al mi amikan defion anstataŭe.';

  @override
  String get challengeDeclineStandard => 'Mi ne akceptas variaĵajn defiojn nun.';

  @override
  String get challengeDeclineVariant => 'Mi ne volas ludi ĉi tiun variaĵon nun.';

  @override
  String get challengeDeclineNoBot => 'Mi ne akceptas defiojn de robotoj.';

  @override
  String get challengeDeclineOnlyBot => 'Mi nur akceptas defiojn de robotoj.';

  @override
  String get challengeInviteLichessUser => 'Aŭ invitu Lichess uzanton:';

  @override
  String get contactContact => 'Kontakto';

  @override
  String get contactContactLichess => 'Kontakti Lichess';

  @override
  String get patronDonate => 'Donaci';

  @override
  String get patronLichessPatron => 'Lichess Patrono';

  @override
  String perfStatPerfStats(String param) {
    return '$param statikoj';
  }

  @override
  String get perfStatViewTheGames => 'Rigardi la ludojn';

  @override
  String get perfStatProvisional => 'provizora';

  @override
  String get perfStatNotEnoughRatedGames => 'Ne sufiĉe taksitaj ludoj estis luditaj por estigi fidindan rangon.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progreso dum la lastaj $param ludoj:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Taksa devio: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Pli malalta valoro signifas, ke la rango estas pli stabila. Super $param1 la rango estas konsiderata provizora. Por esti inkluzivita en la rangotabeloj, ĉi tiu valoro devus esti sub $param2 (norma ŝako) aŭ $param3 (variaĵoj).';
  }

  @override
  String get perfStatTotalGames => 'Totalaj ludoj';

  @override
  String get perfStatRatedGames => 'Rangitaj ludoj';

  @override
  String get perfStatTournamentGames => 'Turniraj ludoj';

  @override
  String get perfStatBerserkedGames => 'Berserk ludoj';

  @override
  String get perfStatTimeSpentPlaying => 'Tempo pasita ludante';

  @override
  String get perfStatAverageOpponent => 'Meznombra kontraŭulo';

  @override
  String get perfStatVictories => 'Venkoj';

  @override
  String get perfStatDefeats => 'Malvenkoj';

  @override
  String get perfStatDisconnections => 'Malkonektoj';

  @override
  String get perfStatNotEnoughGames => 'Ne sufiĉaj luditaj ludoj';

  @override
  String perfStatHighestRating(String param) {
    return 'Plej alta rango: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Plej malalta rango: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'de $param1 al $param2';
  }

  @override
  String get perfStatWinningStreak => 'Sinsekva gajnado';

  @override
  String get perfStatLosingStreak => 'Sinsekva perdado';

  @override
  String perfStatLongestStreak(String param) {
    return 'Plej longa sinsekva rezulto: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Nuntempa sinsekva rezulto: $param';
  }

  @override
  String get perfStatBestRated => 'Plej bonaj venkoj laŭ kontraŭula rango';

  @override
  String get perfStatGamesInARow => 'Ludoj sinsekve luditaj';

  @override
  String get perfStatLessThanOneHour => 'Malpli ol unu horo inter ludoj';

  @override
  String get perfStatMaxTimePlaying => 'Maksimuma tempo pasita ludante';

  @override
  String get perfStatNow => 'nun';

  @override
  String get preferencesPreferences => 'Preferoj';

  @override
  String get preferencesDisplay => 'Montri';

  @override
  String get preferencesPrivacy => 'Privateco';

  @override
  String get preferencesNotifications => 'Sciigoj';

  @override
  String get preferencesPieceAnimation => 'Animacio de ŝakpecoj';

  @override
  String get preferencesMaterialDifference => 'Materiala diferenco';

  @override
  String get preferencesBoardHighlights => 'Emfazaj aperoj sur tabulo (lasta movo kaj ŝakoj)';

  @override
  String get preferencesPieceDestinations => 'Destinoj de ŝakpecoj (eblaj movoj kaj antaŭmovoj)';

  @override
  String get preferencesBoardCoordinates => 'Tabulaj koordinatoj (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Listo de movoj dum ludado';

  @override
  String get preferencesPgnPieceNotation => 'Mova notado';

  @override
  String get preferencesChessPieceSymbol => 'Ŝakpecaj simboloj';

  @override
  String get preferencesPgnLetter => 'Litero (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zena modo';

  @override
  String get preferencesShowPlayerRatings => 'Montri rangojn de ludanto';

  @override
  String get preferencesShowFlairs => 'Montri ludantajn emoĝiojn';

  @override
  String get preferencesExplainShowPlayerRatings => 'Ĉi tio permesas kaŝi ĉiujn rangojn el la retejo, por helpi koncentriĝas pri la ŝako. Ludoj povas daŭre esti range, ĉi tiu temas nur pri tio, kion vi vidas.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Montri la grandecregilon de la ŝaktabulo';

  @override
  String get preferencesOnlyOnInitialPosition => 'Nur sur komenca pozicio';

  @override
  String get preferencesInGameOnly => 'Nur en ludo';

  @override
  String get preferencesChessClock => 'Ŝakhorloĝo';

  @override
  String get preferencesTenthsOfSeconds => 'Dekonoj da sekundoj';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Kiam restas malpli ol 10 sekundoj';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Horizontalaj verdaj progreso-strioj';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Sono, kiam tempo iĝas tre malmulta';

  @override
  String get preferencesGiveMoreTime => 'Doni pli da tempo';

  @override
  String get preferencesGameBehavior => 'Luda konduto';

  @override
  String get preferencesHowDoYouMovePieces => 'Kiel movi pecojn?';

  @override
  String get preferencesClickTwoSquares => 'Klaku du kvadratojn';

  @override
  String get preferencesDragPiece => 'Ŝovi pecon';

  @override
  String get preferencesBothClicksAndDrag => 'Ambaŭ';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Antaŭmovoj (ludi dum la vico de kontraŭulo)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Reprenoj (kun konsento de kontraŭulo)';

  @override
  String get preferencesInCasualGamesOnly => 'Nur ĉe amikaj ludoj';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Memage rangaltigi soldatojn al damoj';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Premu la <ctrl> klavon dum rangaltigo por momente malŝalti memagan rangaltiĝon';

  @override
  String get preferencesWhenPremoving => 'Ĉe antaŭmovoj';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Memage postuli egalvenkon post trifoja ripetado';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Kiam restas malpli ol 30 sekundoj';

  @override
  String get preferencesMoveConfirmation => 'Konfirmo de movo';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Povas esti malebligita dum ludo kun la tabulo menuo';

  @override
  String get preferencesInCorrespondenceGames => 'Korespondaj ludoj';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Korespondado kaj sen tempolimo';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Konfirmi proponojn de resignoj kaj egalvenkoj';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Aroka metodo';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Movi reĝon je du kvadratoj';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Movi reĝon al la turo';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Enigi movojn per klavaro';

  @override
  String get preferencesInputMovesWithVoice => 'Enigi movojn per via voĉo';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Montri per sagoj nur validajn movojn';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Skribi \"Good game, well played\" post malvenko aŭ egalvenko';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Viaj preferoj estis konservitaj.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Uzi rulumilon sur la tabelo por ripeti movojn';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Tage retpoŝta sciigo listante viajn korespondajn partiojn';

  @override
  String get preferencesNotifyStreamStart => 'Filmprezentisto iĝas vive';

  @override
  String get preferencesNotifyInboxMsg => 'Nova enirkesto mesaĝo';

  @override
  String get preferencesNotifyForumMention => 'Foruma komento mencias vin';

  @override
  String get preferencesNotifyInvitedStudy => 'Studa invito';

  @override
  String get preferencesNotifyGameEvent => 'Koresponde ludaj novaĵoj';

  @override
  String get preferencesNotifyChallenge => 'Defioj';

  @override
  String get preferencesNotifyTournamentSoon => 'Turniro baldaŭ komencos';

  @override
  String get preferencesNotifyTimeAlarm => 'Koresponda horloĝo baldaŭ finiĝas';

  @override
  String get preferencesNotifyBell => 'Sonorilaj sciigoj en Lichess mem';

  @override
  String get preferencesNotifyPush => 'Aparta sciigo kiam vi ne ĉe Licess';

  @override
  String get preferencesNotifyWeb => 'Retumilo';

  @override
  String get preferencesNotifyDevice => 'Aparato';

  @override
  String get preferencesBellNotificationSound => 'Sonorile sciiga sono';

  @override
  String get puzzlePuzzles => 'Puzloj';

  @override
  String get puzzlePuzzleThemes => 'Puzlaj temoj';

  @override
  String get puzzleRecommended => 'Rekomendita';

  @override
  String get puzzlePhases => 'Fazoj';

  @override
  String get puzzleMotifs => 'Motivoj';

  @override
  String get puzzleAdvanced => 'Progresinta';

  @override
  String get puzzleLengths => 'Longecoj';

  @override
  String get puzzleMates => 'Matoj';

  @override
  String get puzzleGoals => 'Celoj';

  @override
  String get puzzleOrigin => 'Originoj';

  @override
  String get puzzleSpecialMoves => 'Specialaj movoj';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ĉu vi ŝatis la puzlon?';

  @override
  String get puzzleVoteToLoadNextOne => 'Voĉdonu por iri al la venonta puzlo!';

  @override
  String get puzzleUpVote => 'Supren voĉdoni puzlo';

  @override
  String get puzzleDownVote => 'Malsupren voĉdoni puzlo';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Via puzla rango ne ŝanĝiĝos. Notu, ke puzloj ne estas konkurso. Via rango helpis elekti la plej bonaj puzloj por via nuna lerto.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Trovu la plej bonan movon por blanko.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Trovu la plej bonan movon por nigro.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Por akiri personigitajn puzlojn:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Puzlo $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Puzlo de la tago';

  @override
  String get puzzleDailyPuzzle => 'Taga puzlo';

  @override
  String get puzzleClickToSolve => 'Klaku por solvi';

  @override
  String get puzzleGoodMove => 'Bona movo';

  @override
  String get puzzleBestMove => 'Plej bona movo!';

  @override
  String get puzzleKeepGoing => 'Daŭrigu…';

  @override
  String get puzzlePuzzleSuccess => 'Sukceso!';

  @override
  String get puzzlePuzzleComplete => 'Puzlo kompletigita!';

  @override
  String get puzzleByOpenings => 'Laŭ malfermoj';

  @override
  String get puzzlePuzzlesByOpenings => 'Puzloj laŭ malfermoj';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Malfermoj kiujn vi plej ludis en rangaj ludoj';

  @override
  String get puzzleUseFindInPage => 'Uzu \"Serĉi ĉi tiun paĝon\" de la retumila menuo por trovi vian plej favora malfermo!';

  @override
  String get puzzleUseCtrlF => 'Uzu Ctrl+f por trovi vian plej ŝatatan malfermon!';

  @override
  String get puzzleNotTheMove => 'Tiu ne estas la movo!';

  @override
  String get puzzleTrySomethingElse => 'Provu ion alian.';

  @override
  String puzzleRatingX(String param) {
    return 'Taksado: $param';
  }

  @override
  String get puzzleHidden => 'kaŝita';

  @override
  String puzzleFromGameLink(String param) {
    return 'El ludo $param';
  }

  @override
  String get puzzleContinueTraining => 'Daŭrigi la trejnadon';

  @override
  String get puzzleDifficultyLevel => 'Malfacileca nivelo';

  @override
  String get puzzleNormal => 'Normale';

  @override
  String get puzzleEasier => 'Facile';

  @override
  String get puzzleEasiest => 'Tre facile';

  @override
  String get puzzleHarder => 'Malfacile';

  @override
  String get puzzleHardest => 'Tre malfacile';

  @override
  String get puzzleExample => 'Ekzamplo';

  @override
  String get puzzleAddAnotherTheme => 'Aldonu novan temon';

  @override
  String get puzzleNextPuzzle => 'Sekva puzlo';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Tuj iri al la venonta puzlo';

  @override
  String get puzzlePuzzleDashboard => 'Puzla panelo';

  @override
  String get puzzleImprovementAreas => 'Pliboniĝaj areoj';

  @override
  String get puzzleStrengths => 'Fortoj';

  @override
  String get puzzleHistory => 'Puzla historio';

  @override
  String get puzzleSolved => 'solvita';

  @override
  String get puzzleFailed => 'malsukcesis';

  @override
  String get puzzleStreakDescription => 'Solvu sinsekve pli malfacilaj puzloj por konstrui venkan sinsekvon. Ne estas horloĝo, do prenu vian tempon. Unu malĝusta movo, kaj estas ludfino! Vi povas preterpasi unu movon po sesio.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Via sinsekvo: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Preterpasu ĉi tiun movon por ŝirmi vian sinsekvo! Nur laboras unu per kuro.';

  @override
  String get puzzleContinueTheStreak => 'Daŭrigi la sinsekvon';

  @override
  String get puzzleNewStreak => 'Nova sinsekvo';

  @override
  String get puzzleFromMyGames => 'De miaj ludoj';

  @override
  String get puzzleLookupOfPlayer => 'Elserĉi puzlojn el ludoj de ludanto';

  @override
  String puzzleFromXGames(String param) {
    return 'Puzloj el $param\' ludoj';
  }

  @override
  String get puzzleSearchPuzzles => 'Serĉi puzlojn';

  @override
  String get puzzleFromMyGamesNone => 'Vi ne havas puzlojn en la datumbazo, sed Lichess ankoraŭ tre amas vin.\n\nLudu rapidaj kaj klasikaj ludoj por pliigi viajn ŝancojn de aldoni puzlon de vi!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 puzlojn trovis en $param2 ludoj';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Trejnu, analizu, pliboniĝu';

  @override
  String puzzlePercentSolved(String param) {
    return '$param solvita';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nenio por montri, ludu iujn puzlojn unue!';

  @override
  String get puzzleImprovementAreasDescription => 'Trajnu ĉi tiujn por optimumigi vian progreson!';

  @override
  String get puzzleStrengthDescription => 'Via rendimento estas plej bona en ĉi tiuj temoj';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ludita $count foje',
      one: 'Ludita $count foje',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poentoj sub via puzla rango',
      one: 'Unu poento sub via puzla rango',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poentoj super via puzla rango',
      one: 'Unu poento super via puzla rango',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ludita',
      one: '$count ludita',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count por reludi',
      one: '$count por reludi',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Altnivela soldato';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Unu el viaj soldatoj profundas en la kontraŭa flanko, kaj ĝia ebla rangaltiĝo minacas.';

  @override
  String get puzzleThemeAdvantage => 'Avantaĝo';

  @override
  String get puzzleThemeAdvantageDescription => 'Profitu viajn ŝancojn por havi decida avantaĝo. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastasia ŝakmato';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Ĉevalo kaj turo aŭ damo laboras kune por kapti la kontraŭa reĝo inter la flanko de la tabulo kaj amika ŝakpeco.';

  @override
  String get puzzleThemeArabianMate => 'Araba ŝakmato';

  @override
  String get puzzleThemeArabianMateDescription => 'Ĉevalo kaj turo laboras kune por kapti la kontraŭa reĝo en angulo de la tabulo.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Atako al f2 aŭ f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Atako fokusata al la soldatojn ĉe f2 kaj f7, samkiel la malfermo ·«fritita hepataĵa».';

  @override
  String get puzzleThemeAttraction => 'Altiro';

  @override
  String get puzzleThemeAttractionDescription => 'Interŝanĝo aŭ ofero kiu instigas aŭ trudas kontraŭulan ŝakpecon al kvadrato ke ebligas taktikon.';

  @override
  String get puzzleThemeBackRankMate => 'Malantaŭvico mato';

  @override
  String get puzzleThemeBackRankMateDescription => 'Ŝakmati la reĝo sur la hejmrango, kiam ĝi estas kaptita per ĝiaj propraj ŝakpecoj.';

  @override
  String get puzzleThemeBishopEndgame => 'Kuriera finaĵo';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Finaĵo nur kun kurieroj kaj soldatoj.';

  @override
  String get puzzleThemeBodenMate => 'Boden ŝakmato';

  @override
  String get puzzleThemeBodenMateDescription => 'Du kontraŭaj kurieroj sur interkruciĝantaj diagonaloj liveras maton al reĝo ĉirkaŭbarita per amikaj ŝakpecoj.';

  @override
  String get puzzleThemeCastling => 'Aroko';

  @override
  String get puzzleThemeCastlingDescription => 'Alportu la reĝo en sekurecon, kaj lanĉu la turon por atako.';

  @override
  String get puzzleThemeCapturingDefender => 'Kapti la defendanton';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Forprenu ŝakpecon, kiu estas grava por defendo de alia ŝakpeco, ebligante la kapto de la nun nedefendata ŝakpeco dum sekva movo.';

  @override
  String get puzzleThemeCrushing => 'Aplomba';

  @override
  String get puzzleThemeCrushingDescription => 'Trovu la kontraŭulan eraregon por akiri disbatantan avantaĝon. (takso ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Duokuriera ŝakmato';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Du kontraŭaj kurieroj sur apudaj diagonaloj liveras maton al reĝo ĉirkaŭbarita per amikaj ŝakpecoj.';

  @override
  String get puzzleThemeDovetailMate => 'Mato de Cozio';

  @override
  String get puzzleThemeDovetailMateDescription => 'Damo liveras maton al apuda reĝo, kies du eskapajn ĉelojn blokas amikaj ŝakpecoj.';

  @override
  String get puzzleThemeEquality => 'Egaligi';

  @override
  String get puzzleThemeEqualityDescription => 'Reiru el malvenkanta pozicio, kaj sekurigi egalvenkon aŭ egalan pozicion. (takso ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Atako al la reĝa flanko';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Atako al la kontraŭula reĝo, post kiam li arokis reĝflanke.';

  @override
  String get puzzleThemeClearance => 'Senigo';

  @override
  String get puzzleThemeClearanceDescription => 'Movo, ofte kun tempo, kiu malplenigas ĉelon, kolumnon, aŭ diagonalon por sekva taktika ideo.';

  @override
  String get puzzleThemeDefensiveMove => 'Defenda movo';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Preciza movo aŭ vico de movoj, kiu estas bezona por eviti perdon de materialo aŭ alia avantaĝo.';

  @override
  String get puzzleThemeDeflection => 'Devio';

  @override
  String get puzzleThemeDeflectionDescription => 'Movo, kiu distras kontraŭan ŝakpecon de alia devo, kio ĝi faras, kiel gardo de grava ĉelo. Kelkfoje ankaŭ nomiĝas \"troŝargo\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Malkovrita atako';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Movo de peco (kiel ĉevalo), kiu antaŭe blokis atakon de longdistanca peco (kiel turo), fore de vojo de tiu peco.';

  @override
  String get puzzleThemeDoubleCheck => 'Duobla ŝako';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Ŝakanta per du ŝakpecoj samtempe, kiel rezulto de malkovrita atako, kie kaj la moviĝa ŝakpeco kaj la malvualita ŝakpeco ataki la reĝo de la kontraŭulo.';

  @override
  String get puzzleThemeEndgame => 'Finaĵo';

  @override
  String get puzzleThemeEndgameDescription => 'Taktiko dum la lasta fazo de la ludo.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktiko kiu temas pri la preterpasa prena regulo, per kiu soldato povas kapti kontraŭan soldaton kiu preterpasis ĝin dum sia komenca du-ĉela movo.';

  @override
  String get puzzleThemeExposedKing => 'Neprotektita reĝo';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktiko temas pri reĝo kun iometaj defendantoj ĉirkaŭ ĝin, ofte kondukanta al ŝakmato.';

  @override
  String get puzzleThemeFork => 'Forko';

  @override
  String get puzzleThemeForkDescription => 'Movo, kie la movita ŝakpeco atakas du kontraŭajn ŝakpecojn samtempe.';

  @override
  String get puzzleThemeHangingPiece => 'Pendanta ŝakpeco';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktiko temas pri kontraŭa ŝakpeco, kiu estas nedefendita aŭ malsufiĉe defendita kaj libera por kapti.';

  @override
  String get puzzleThemeHookMate => 'Hoka ŝakmato';

  @override
  String get puzzleThemeHookMateDescription => 'Ŝakmato per turo, ĉevalo, kaj soldato plus unu kontraŭa soldato por limigi la fuĝon de la kontraŭa reĝo.';

  @override
  String get puzzleThemeInterference => 'Interfero';

  @override
  String get puzzleThemeInterferenceDescription => 'Movo de peco inter du kontraŭaj pecoj por lasi unu aŭ ambaŭ kontraŭaj pecoj sendefenda, kiel ĉevalo sur defendita ĉelo inter du turoj.';

  @override
  String get puzzleThemeIntermezzo => 'Intermeza movo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Anstataŭ ludo de la atendita movo, unue intermetu alian movon, kiu faras tujan minacon, al kiu via kontraŭulo devas respondi.';

  @override
  String get puzzleThemeKnightEndgame => 'Ĉevala finaĵo';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Finaĵo nur kun ĉevaloj kaj soldatoj.';

  @override
  String get puzzleThemeLong => 'Longa puzlo';

  @override
  String get puzzleThemeLongDescription => 'Tri movoj por venki.';

  @override
  String get puzzleThemeMaster => 'Majstraj ludoj';

  @override
  String get puzzleThemeMasterDescription => 'Puzloj el ludoj ludantaj de titolaj ludantoj.';

  @override
  String get puzzleThemeMasterVsMaster => 'Majstro kontraŭ Majtro ludoj';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Puzloj el ludoj inter du titolitaj ŝakistoj.';

  @override
  String get puzzleThemeMate => 'Mato';

  @override
  String get puzzleThemeMateDescription => 'Gajni la ludon stile.';

  @override
  String get puzzleThemeMateIn1 => 'Mato en 1';

  @override
  String get puzzleThemeMateIn1Description => 'Liveri ŝakmaton en unu movo.';

  @override
  String get puzzleThemeMateIn2 => 'Mato en 2';

  @override
  String get puzzleThemeMateIn2Description => 'Liveri ŝakmaton en du movoj.';

  @override
  String get puzzleThemeMateIn3 => 'Mato en 3';

  @override
  String get puzzleThemeMateIn3Description => 'Liveri ŝakmaton en tri movoj.';

  @override
  String get puzzleThemeMateIn4 => 'Mato en 4';

  @override
  String get puzzleThemeMateIn4Description => 'Liveri ŝakmaton en kvar movoj.';

  @override
  String get puzzleThemeMateIn5 => 'Mato en 5 aŭ pli';

  @override
  String get puzzleThemeMateIn5Description => 'Solvi longan matantan vicon.';

  @override
  String get puzzleThemeMiddlegame => 'Mezludo';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktiko dum la dua fazo de la ludo.';

  @override
  String get puzzleThemeOneMove => 'Unumova puzlo';

  @override
  String get puzzleThemeOneMoveDescription => 'Puzlo, kiu estas nur unu movo longa.';

  @override
  String get puzzleThemeOpening => 'Malfermo';

  @override
  String get puzzleThemeOpeningDescription => 'Taktiko dum la unua fazo de la ludo.';

  @override
  String get puzzleThemePawnEndgame => 'Peona finaĵo';

  @override
  String get puzzleThemePawnEndgameDescription => 'Finaĵo nur kun soldatoj.';

  @override
  String get puzzleThemePin => 'Alpinglo';

  @override
  String get puzzleThemePinDescription => 'Taktiko temas pri alpingloj, kie ŝakpeco ne povas movi sen malkovri atakon sur pli valora ŝakpeco.';

  @override
  String get puzzleThemePromotion => 'Damigo';

  @override
  String get puzzleThemePromotionDescription => 'Rangaltigi soldaton al damo aŭ malpli grava peco.';

  @override
  String get puzzleThemeQueenEndgame => 'Dama finaĵo';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Finaĵo nur kun damoj kaj soldatoj.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Damo kaj Turo';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Finaĵo nur kun damoj, turoj kaj soldatoj.';

  @override
  String get puzzleThemeQueensideAttack => 'Atako al la dama flanko';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Atako al la kontraŭula reĝo, post kiam ri arokis damflanke.';

  @override
  String get puzzleThemeQuietMove => 'Trankvila movo';

  @override
  String get puzzleThemeQuietMoveDescription => 'Movo, ke nek faras ŝako aŭ kapto, nek subita minaco de kapto, sed preparas pli kaŝita neevitebla minaco por posta movo.';

  @override
  String get puzzleThemeRookEndgame => 'Tura finaĵo';

  @override
  String get puzzleThemeRookEndgameDescription => 'Finaĵo nur kun turoj kaj soldatoj.';

  @override
  String get puzzleThemeSacrifice => 'Ofero';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktiko temas pri cedo de materialo dum la mallongtempo, por regajni avantaĝon dum devigita vico de movoj.';

  @override
  String get puzzleThemeShort => 'Mallonga puzlo';

  @override
  String get puzzleThemeShortDescription => 'Du movoj por venki.';

  @override
  String get puzzleThemeSkewer => 'Trapiko';

  @override
  String get puzzleThemeSkewerDescription => 'Motivo temas pri altvalora peco, kiu estas atakita, tiam moviĝas for de vojo permesante kapton de plimalaltvalora peco malantaŭ si. La inverso de alpinglo.';

  @override
  String get puzzleThemeSmotheredMate => 'Sufokita mato';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Ŝakmato liverita per ĉevalo, kiam la matita rego ne povas moviĝi, ĉar ĝi estas ĉirkaŭbarita (aŭ sufokita) per siaj propraj ŝakpecoj.';

  @override
  String get puzzleThemeSuperGM => 'Super GM ludoj';

  @override
  String get puzzleThemeSuperGMDescription => 'Puzloj de ludoj luditaj de la plej bonaj ludantoj en la mondo.';

  @override
  String get puzzleThemeTrappedPiece => 'Kaptita ŝakpeco';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Peco ne povas eskapi kapton, ĉar ĝi havas limigitajn movojn.';

  @override
  String get puzzleThemeUnderPromotion => 'Subdamigo';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Damigi al ĉevalo, kuriero aŭ turo.';

  @override
  String get puzzleThemeVeryLong => 'Tre longa puzlo';

  @override
  String get puzzleThemeVeryLongDescription => 'Kvar aŭ pliaj movoj por venki.';

  @override
  String get puzzleThemeXRayAttack => 'X-radia atako';

  @override
  String get puzzleThemeXRayAttackDescription => 'Peco atakas aŭ defendas kvadraton, tra malamika peco.';

  @override
  String get puzzleThemeZugzwang => 'Movdevigo';

  @override
  String get puzzleThemeZugzwangDescription => 'La opcioj de la kontraŭulo por moviĝi estas limigitaj, kaj ĉiuj movoj plimalbonigas rian pozicion.';

  @override
  String get puzzleThemeHealthyMix => 'Sana miksaĵo';

  @override
  String get puzzleThemeHealthyMixDescription => 'Iom de ĉio. Vi ne scias kion atendi, do vi restas preta por io ajn! Same kiel en realaj ludoj.';

  @override
  String get puzzleThemePlayerGames => 'Ludantaj ludoj';

  @override
  String get puzzleThemePlayerGamesDescription => 'Serĉu enigmojn generitajn de viaj ludoj, aŭ de la ludoj de alia ludanto.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Ĉi tiuj enigmoj estas en la publika domeno, kaj povas esti elŝutitaj de $param.';
  }

  @override
  String get searchSearch => 'Serĉi';

  @override
  String get settingsSettings => 'Agordoj';

  @override
  String get settingsCloseAccount => 'Fermi konton';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Via konto estas administrata, kaj ne povas esti fermata.';

  @override
  String get settingsClosingIsDefinitive => 'Fermado estas definitiva. Ne eblos malfari. Ĉu vi certas?';

  @override
  String get settingsCantOpenSimilarAccount => 'Vi ne rajtos malfermi novan konton kun la sama nomo, eĉ se la uskleco estos malsama.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Mi ŝanĝis mian opinion, mi ne volas fermi mian konton';

  @override
  String get settingsCloseAccountExplanation => 'Ĉu vi certas, ke vi volas fermi vian konton? Fermi vian konton estas konstanta decido. Vi NENIAM DENOVE povos ensaluti per ĝi.';

  @override
  String get settingsThisAccountIsClosed => 'Tiu ĉi konto estas fermita.';

  @override
  String get playWithAFriend => 'Ludi kun amiko';

  @override
  String get playWithTheMachine => 'Ludi kontraŭ la komputilo';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Por inviti iun al ludo, donu ĉi tiun ligilon';

  @override
  String get gameOver => 'Ludo finiĝis';

  @override
  String get waitingForOpponent => 'Atendante kontraŭulon';

  @override
  String get orLetYourOpponentScanQrCode => 'Aŭ lasi vian kontraŭulon skani ĉi tiun QR-kodon per la app';

  @override
  String get waiting => 'Atendante';

  @override
  String get yourTurn => 'Via vico';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 nivelo $param2';
  }

  @override
  String get level => 'Nivelo';

  @override
  String get strength => 'Forto';

  @override
  String get toggleTheChat => 'Baskuligi la babilejon';

  @override
  String get chat => 'Babilejo';

  @override
  String get resign => 'Rezigni';

  @override
  String get checkmate => 'Ŝakmato';

  @override
  String get stalemate => 'Pato';

  @override
  String get white => 'Blanka';

  @override
  String get black => 'Nigro';

  @override
  String get asWhite => 'kiel blanko';

  @override
  String get asBlack => 'kiel nigro';

  @override
  String get randomColor => 'Hazarda koloro';

  @override
  String get createAGame => 'Krei ludon';

  @override
  String get whiteIsVictorious => 'Blanko venkis';

  @override
  String get blackIsVictorious => 'Nigro venkis';

  @override
  String get youPlayTheWhitePieces => 'Vi ludas per la blankaj pecoj';

  @override
  String get youPlayTheBlackPieces => 'Vi ludas per la nigraj pecoj';

  @override
  String get itsYourTurn => 'Estas via ludvico!';

  @override
  String get cheatDetected => 'Trompo kaptita';

  @override
  String get kingInTheCenter => 'Reĝo en la centro';

  @override
  String get threeChecks => 'Tri ŝakoj';

  @override
  String get raceFinished => 'Kuro finiĝis';

  @override
  String get variantEnding => 'Variaĵa fino';

  @override
  String get newOpponent => 'Nova kontraŭulo';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Via kontraŭulo volas ludi denove kun vi';

  @override
  String get joinTheGame => 'Aliĝi al la ludo';

  @override
  String get whitePlays => 'Blanko ludas';

  @override
  String get blackPlays => 'Nigro ludas';

  @override
  String get opponentLeftChoices => 'La alia ludanto forlasis la ludon. Vi povas postuli venkon, deklari egalvenkon, aŭ atendi.';

  @override
  String get forceResignation => 'Postuli venkon';

  @override
  String get forceDraw => 'Deklari egalvenkon';

  @override
  String get talkInChat => 'Bonvolu esti afabla en la babilejo!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'La unua persono, kiu alvenos al ĉi tiu ligilo, ludos kun vi.';

  @override
  String get whiteResigned => 'Blanko rezignis';

  @override
  String get blackResigned => 'Nigro rezignis';

  @override
  String get whiteLeftTheGame => 'Blanko forlasis la ludon';

  @override
  String get blackLeftTheGame => 'Nigro forlasis la ludon';

  @override
  String get whiteDidntMove => 'Blanko ne movis';

  @override
  String get blackDidntMove => 'Nigro ne movis';

  @override
  String get requestAComputerAnalysis => 'Peti komputilan analizon';

  @override
  String get computerAnalysis => 'Komputila analizo';

  @override
  String get computerAnalysisAvailable => 'Komputila analizo haveblas';

  @override
  String get computerAnalysisDisabled => 'Komputila analizo haveblas';

  @override
  String get analysis => 'Analiza tabulo';

  @override
  String depthX(String param) {
    return 'Profundo $param';
  }

  @override
  String get usingServerAnalysis => 'Analizanta per servilo';

  @override
  String get loadingEngine => 'Komencas la maŝinon...';

  @override
  String get calculatingMoves => 'Kalkulante movojn...';

  @override
  String get engineFailed => 'Motora misŝarĝo';

  @override
  String get cloudAnalysis => 'Analizo per la nubo';

  @override
  String get goDeeper => 'Iri pli profunde';

  @override
  String get showThreat => 'Montri la minacon';

  @override
  String get inLocalBrowser => 'en loka retumilo';

  @override
  String get toggleLocalEvaluation => 'Baskuligi lokan gaŭĝon';

  @override
  String get promoteVariation => 'Plivalorigi variaĵon';

  @override
  String get makeMainLine => 'Ĉefigi linion';

  @override
  String get deleteFromHere => 'Forigi ekde tie ĉi';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Devigi variaĵon';

  @override
  String get copyVariationPgn => 'Kopi varianto PGN';

  @override
  String get move => 'Movo';

  @override
  String get variantLoss => 'Malvenka variaĵo';

  @override
  String get variantWin => 'Venka variaĵo';

  @override
  String get insufficientMaterial => 'Nesufiĉa materialo';

  @override
  String get pawnMove => 'Peonmovo';

  @override
  String get capture => 'Kapto';

  @override
  String get close => 'Fermi';

  @override
  String get winning => 'Venkanta';

  @override
  String get losing => 'Malvenkanta';

  @override
  String get drawn => 'Kaŭzas egalvenkon';

  @override
  String get unknown => 'Nekonata';

  @override
  String get database => 'Datumbazo';

  @override
  String get whiteDrawBlack => 'Blanko / Egalvenko / Nigro';

  @override
  String averageRatingX(String param) {
    return 'Meznombra rango: $param';
  }

  @override
  String get recentGames => 'Lastaj ludoj';

  @override
  String get topGames => 'Pintaj ludoj';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Du milionoj ludoj fizikaj de $param1+ FIDE-taksitaj ludantoj ekde $param2 ĝis $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" kun rondigo, bazita en nombro de inter-movoj ĝis sekva kapto aŭ peona movo';

  @override
  String get noGameFound => 'Neniu ludo trovita';

  @override
  String get maxDepthReached => 'Maksimuma profundeco kulminas!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Eble inkluzivi pli da ludoj de la menuo de preferoj?';

  @override
  String get openings => 'Ludkomencoj';

  @override
  String get openingExplorer => 'Esplorilo pri malfermoj';

  @override
  String get openingEndgameExplorer => 'Esplorilo de malfermoj/finaĵoj';

  @override
  String xOpeningExplorer(String param) {
    return '$param esplorilo de malfermoj';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Ludi unua malferme/finaĵe-esplorila movo';

  @override
  String get winPreventedBy50MoveRule => 'Venko blokita per la regulo pri 50-movoj';

  @override
  String get lossSavedBy50MoveRule => 'Malvenko ne suferita dank\' al la regulo pri 50-movoj';

  @override
  String get winOr50MovesByPriorMistake => 'Venko aŭ 50 movoj de antaŭa eraro';

  @override
  String get lossOr50MovesByPriorMistake => 'Malvenko aŭ 50 movoj de antaŭa eraro';

  @override
  String get unknownDueToRounding => 'Venko/Malvenko nur garantiita se rekomendataj movoj estis sekvitaj de la lasta movo aŭ peona movo, pro ebla rondigo.';

  @override
  String get allSet => 'Preta!';

  @override
  String get importPgn => 'Importi PGN';

  @override
  String get delete => 'Forigi';

  @override
  String get deleteThisImportedGame => 'Ĉu forigi ĉi tiun importitan ludon?';

  @override
  String get replayMode => 'Reluda reĝimo';

  @override
  String get realtimeReplay => 'Reala tempo';

  @override
  String get byCPL => 'Per eraroj';

  @override
  String get openStudy => 'Malfermi analizon';

  @override
  String get enable => 'Ebligi';

  @override
  String get bestMoveArrow => 'Sago por optimuma movo';

  @override
  String get showVariationArrows => 'Montri variaĵojn sagojn';

  @override
  String get evaluationGauge => 'Gaŭĝo de rangado';

  @override
  String get multipleLines => 'Pluraj linioj';

  @override
  String get cpus => 'Ĉefprocesoroj';

  @override
  String get memory => 'Memoro';

  @override
  String get infiniteAnalysis => 'Senfina analizo';

  @override
  String get removesTheDepthLimit => 'Forigas la profundlimon, kaj tenas vian komputilon varma';

  @override
  String get engineManager => 'Motora administranto';

  @override
  String get blunder => 'Erarego';

  @override
  String get mistake => 'Eraro';

  @override
  String get inaccuracy => 'Erareto';

  @override
  String get moveTimes => 'Movaj tempoj';

  @override
  String get flipBoard => 'Rotacii tabulon';

  @override
  String get threefoldRepetition => 'Triobla ripeto';

  @override
  String get claimADraw => 'Postuli egalvenkon';

  @override
  String get offerDraw => 'Proponi egalvenkon';

  @override
  String get draw => 'Egalvenko';

  @override
  String get drawByMutualAgreement => 'Egalvenko per interkonsento';

  @override
  String get fiftyMovesWithoutProgress => 'Kvindek movoj sen progreso';

  @override
  String get currentGames => 'Ludataj ludoj';

  @override
  String get viewInFullSize => 'Vidi plengrande';

  @override
  String get logOut => 'Elsaluti';

  @override
  String get signIn => 'Ensaluti';

  @override
  String get rememberMe => 'Memoru mian ensaluton';

  @override
  String get youNeedAnAccountToDoThat => 'Vi bezonas konton por fari tion';

  @override
  String get signUp => 'Registriĝi';

  @override
  String get computersAreNotAllowedToPlay => 'Estas nepermesate ludi per komputiloj aŭ komputilasisto. Bonvolu ne akiri asiston de iu ŝakaŭtomato, datumbazo aŭ aliaj ludantoj dum ludado. Krome, notu ke la kreado de multaj kontoj estas forte malrekomendata, kaj troa uzo de multaj kontoj rezultigos vian forbaron.';

  @override
  String get games => 'Ludoj';

  @override
  String get forum => 'Forumo';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 skribis en la temo $param2';
  }

  @override
  String get latestForumPosts => 'Plej novaj forumaj afiŝoj';

  @override
  String get players => 'Ŝakludantoj';

  @override
  String get friends => 'Amikoj';

  @override
  String get discussions => 'Konversacioj';

  @override
  String get today => 'Hodiaŭ';

  @override
  String get yesterday => 'Hieraŭ';

  @override
  String get minutesPerSide => 'Minutoj por ĉiu flanko';

  @override
  String get variant => 'Variaĵo';

  @override
  String get variants => 'Variaĵoj';

  @override
  String get timeControl => 'Temporegado';

  @override
  String get realTime => 'Reala tempo';

  @override
  String get correspondence => 'Korespondo';

  @override
  String get daysPerTurn => 'Tagoj pomovaj';

  @override
  String get oneDay => 'Unu tago';

  @override
  String get time => 'Tempo';

  @override
  String get rating => 'Rango';

  @override
  String get ratingStats => 'Rangaj statistikoj';

  @override
  String get username => 'Uzantnomo';

  @override
  String get usernameOrEmail => 'Uzantnomo aŭ retpoŝtadreso';

  @override
  String get changeUsername => 'Ŝanĝi uzantnomon';

  @override
  String get changeUsernameNotSame => 'Nur la uskleco de la literoj povas ŝanĝiĝi. Ekzemple de \"johndoe\" al \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'Ŝanĝu ĉiam uzantnomon. Vi rajtas fari tion nur unufoje kaj vi rajtas ŝanĝi nur la usklecon de la literoj en via nomo.';

  @override
  String get signupUsernameHint => 'Certigi, ke vi elektas uzantnomon, ke estas adekvata por ĉiu-aĝaj spektantoj. Vi ne povas ŝanĝi ĝin poste, kaj la administrantoj fermas ĉiujn ajn kontojn, kiuj havas malbonimpresajn uzantnomojn!';

  @override
  String get signupEmailHint => 'Ni nur uzos ĝin por pasvorta restarigo.';

  @override
  String get password => 'Pasvorto';

  @override
  String get changePassword => 'Ŝanĝi pasvorton';

  @override
  String get changeEmail => 'Ŝanĝi retadreson';

  @override
  String get email => 'Retadreso';

  @override
  String get passwordReset => 'Ŝanĝi pasvorton';

  @override
  String get forgotPassword => 'Ĉu vi forgesis la pasvorton?';

  @override
  String get error_weakPassword => 'Ĉi tiu pasvorto estas tre ofta, kaj oni povas simple diveni tion.';

  @override
  String get error_namePassword => 'Bonvolu ne uzi vian uzantnomon kiel vian pasvorton.';

  @override
  String get blankedPassword => 'Vi uzis la saman pasvorton ĉe alia retego, kaj tiu retejo estis breĉita. Por certigi la sekurecon de via Lichess-konto, ni devas, ke vi faru novan pasvorton. Dankon por via kunsento.';

  @override
  String get youAreLeavingLichess => 'Vi foriras de retejo Lichess';

  @override
  String get neverTypeYourPassword => 'Neniam tajpu vian Lichess-pasvorton en alia retejo!';

  @override
  String proceedToX(String param) {
    return 'Daŭrigi al $param';
  }

  @override
  String get passwordSuggestion => 'Ne fari pasvorton, ke aliuloj sugestas. Oni uzos ĝin por ŝteli vian konton.';

  @override
  String get emailSuggestion => 'Ne uzi retpoŝtadreson, ke aliuloj sugestas. Oni uzos ĝin por ŝteli vian konton.';

  @override
  String get emailConfirmHelp => 'Helpo kun konfirmo-retpoŝtaĵo';

  @override
  String get emailConfirmNotReceived => 'Ĉu vi ne ricevis vian konfirmo-retpoŝtaĵon post registrado?';

  @override
  String get whatSignupUsername => 'Kiun uzantnomon vi uzis por registriĝi?';

  @override
  String usernameNotFound(String param) {
    return 'Ni ne povis trovi ajnan uzanton per tiu ĉi nomo: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Vi povas uzi ĉi tiun uzantnomon por krei novan konton';

  @override
  String emailSent(String param) {
    return 'Ni sendis retleteron al $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Ĝi povas preni iom da tempo por alveni.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Atendu 5 minutojn kaj reŝargu vian retpoŝtan enirkeston.';

  @override
  String get checkSpamFolder => 'Ankaŭ kontrolu vian trudmesaĝujon, ĝi povus alveni tie. Se estas tiel, marku ĝin kiel ne truda.';

  @override
  String get emailForSignupHelp => 'Se ĉio antaŭdirita ne funkcias, sendu al ni ĉi tiun retleteron:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopiu kaj algluu la supran tekston kaj sendu ĝin al $param';
  }

  @override
  String get waitForSignupHelp => 'Ni estos kun vi baldaŭ por helpi vin plenigi vian registriĝon.';

  @override
  String accountConfirmed(String param) {
    return 'La uzanto $param estis konfirmita sukcese.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Vi povas ensaluti tuje kiel $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Vi ne devas konfirmo-retpoŝtaĵon.';

  @override
  String accountClosed(String param) {
    return 'La konto $param estas fermita.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'La konto $param estis registrita sen retpoŝto.';
  }

  @override
  String get rank => 'Posicio';

  @override
  String rankX(String param) {
    return 'Posicio: $param';
  }

  @override
  String get gamesPlayed => 'Luditaj ludoj';

  @override
  String get cancel => 'Nuligi';

  @override
  String get whiteTimeOut => 'La tempo de blanko finiĝis';

  @override
  String get blackTimeOut => 'La tempo de nigro finiĝis';

  @override
  String get drawOfferSent => 'Egalvenka propono estis sendita';

  @override
  String get drawOfferAccepted => 'Egalvenka propono estis akceptita';

  @override
  String get drawOfferCanceled => 'Egalvenka propono estis nuligita';

  @override
  String get whiteOffersDraw => 'Blanko proponas egalvenkon';

  @override
  String get blackOffersDraw => 'Nigro proponas egalvenkon';

  @override
  String get whiteDeclinesDraw => 'Blanko malakceptas egalvenkon';

  @override
  String get blackDeclinesDraw => 'Nigro malakceptas egalvenkon';

  @override
  String get yourOpponentOffersADraw => 'Via kontraŭulo proponas egalvenkon';

  @override
  String get accept => 'Akcepti';

  @override
  String get decline => 'Malakcepti';

  @override
  String get playingRightNow => 'Ludate nun';

  @override
  String get eventInProgress => 'Ludanta';

  @override
  String get finished => 'Finite';

  @override
  String get abortGame => 'Ĉesigi ludon';

  @override
  String get gameAborted => 'Ludo estis ĉesigita';

  @override
  String get standard => 'Normale';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Senlime';

  @override
  String get mode => 'Modo';

  @override
  String get casual => 'Amike';

  @override
  String get rated => 'Range';

  @override
  String get casualTournament => 'Amike';

  @override
  String get ratedTournament => 'Taksa';

  @override
  String get thisGameIsRated => 'Ĉi tiu ludo estas ranga';

  @override
  String get rematch => 'Reludi';

  @override
  String get rematchOfferSent => 'Rematĉa oferto estis sendita';

  @override
  String get rematchOfferAccepted => 'Rematĉa oferto estis akceptita';

  @override
  String get rematchOfferCanceled => 'Reludi oferto estis nuligita';

  @override
  String get rematchOfferDeclined => 'Reludi oferto estis malakceptita';

  @override
  String get cancelRematchOffer => 'Nuligi reludi oferton';

  @override
  String get viewRematch => 'Vidi reludon';

  @override
  String get confirmMove => 'Konfirmu movon';

  @override
  String get play => 'Ludi';

  @override
  String get inbox => 'Enirkesto';

  @override
  String get chatRoom => 'Babilejo';

  @override
  String get loginToChat => 'Ensaluti por babili';

  @override
  String get youHaveBeenTimedOut => 'Vi estas en paŭzo dum 10 minutoj.';

  @override
  String get spectatorRoom => 'Spektantejo';

  @override
  String get composeMessage => 'Verki mesaĝon';

  @override
  String get subject => 'Pri';

  @override
  String get send => 'Sendi';

  @override
  String get incrementInSeconds => 'Pliigo en sekundoj';

  @override
  String get freeOnlineChess => 'Senpaga Interreta Ŝako';

  @override
  String get exportGames => 'Eksporti ludojn';

  @override
  String get ratingRange => 'Rangogamo';

  @override
  String get thisAccountViolatedTos => 'Ĉi tiu konto malobservis la Kondiĉojn de Servo de Lichess';

  @override
  String get openingExplorerAndTablebase => 'Esplorilo de malfermoj & tablobazo';

  @override
  String get takeback => 'Repreno';

  @override
  String get proposeATakeback => 'Proponi reprenon';

  @override
  String get takebackPropositionSent => 'Reprena propono estis sendita';

  @override
  String get takebackPropositionDeclined => 'Reprena propono estis malakceptita';

  @override
  String get takebackPropositionAccepted => 'Reprena propono estis akceptita';

  @override
  String get takebackPropositionCanceled => 'Reprena propono estis nuligita';

  @override
  String get yourOpponentProposesATakeback => 'Via kontraŭulo proponas nuligi la movon';

  @override
  String get bookmarkThisGame => 'Paĝmarki ĉi tiun ludon';

  @override
  String get tournament => 'Turniro';

  @override
  String get tournaments => 'Turniroj';

  @override
  String get tournamentPoints => 'Turniraj poentoj';

  @override
  String get viewTournament => 'Vidi turniron';

  @override
  String get backToTournament => 'Reiri al turniro';

  @override
  String get noDrawBeforeSwissLimit => 'Vi ne povas egalvenki antaŭ 30 movoj estas luditaj en svisa turniro.';

  @override
  String get thematic => 'Tema';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Via rango de $param estas provizora';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Via rango $param1 ($param2) estas tro alta';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Via plej alta semajna rango en $param1 ($param2) estas tro alta';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Via rango $param1 ($param2) estas tro malalta';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Rango de ≥ $param1 en $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rango de ≤ $param1 en $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Vi devas esti en teamo $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Vi ne estas en la teamo $param';
  }

  @override
  String get backToGame => 'Reiri al la ludo';

  @override
  String get siteDescription => 'Senpaga interreta ŝakludo. Ludu ŝakon nun per simpla interfaco. Sen registriĝo, sen reklamoj, sen neceso por aldonaĵo. Ludu ŝakon kun la komputilo, amikoj aŭ hazardaj kontraŭuloj.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 aliĝis al teamo $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 kreis teamon $param2';
  }

  @override
  String get startedStreaming => 'komencis elsendon';

  @override
  String xStartedStreaming(String param) {
    return '$param komencis elsendon';
  }

  @override
  String get averageElo => 'Meznombra rango';

  @override
  String get location => 'Loko';

  @override
  String get filterGames => 'Filtri ludojn';

  @override
  String get reset => 'Reigi';

  @override
  String get apply => 'Apliki';

  @override
  String get save => 'Konservi';

  @override
  String get leaderboard => 'Sukcesotabulo';

  @override
  String get screenshotCurrentPosition => 'Ekrankopii nunan pozicion';

  @override
  String get gameAsGIF => 'Ludo kiel GIF';

  @override
  String get pasteTheFenStringHere => 'Glui la FEN-ĉenon ĉi tie';

  @override
  String get pasteThePgnStringHere => 'Glui la PGN-ĉenon ĉi tie';

  @override
  String get orUploadPgnFile => 'Aŭ alŝuti PGN-dosieron';

  @override
  String get fromPosition => 'De pozicio';

  @override
  String get continueFromHere => 'Daŭrigi de ĉi tie';

  @override
  String get toStudy => 'Studo';

  @override
  String get importGame => 'Importi ludon';

  @override
  String get importGameExplanation => 'Kiam vi enmetas PGN-on de ludo, vi povas reludi ĝin, vidi komputilan analizon, babili kun la kontraŭulon, kaj dissemi la ligilon URL.';

  @override
  String get importGameCaveat => 'Variaĵoj estos forigitaj. Por havi ilin enportu la PGN tra studoj.';

  @override
  String get importGameDataPrivacyWarning => 'Ĉi tiun PGN estas atingebla de la publiko. Por importi ludon private, uzu studon.';

  @override
  String get thisIsAChessCaptcha => 'Jen ŝaka CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Alklaku la ŝaktabulon por fari movon kaj pruvi, ke vi estas homa.';

  @override
  String get captcha_fail => 'Bonvolu solvi la ŝakan captcha-on.';

  @override
  String get notACheckmate => 'Ne ŝakmato';

  @override
  String get whiteCheckmatesInOneMove => 'La blanka ludanto devas matigi per unu movo';

  @override
  String get blackCheckmatesInOneMove => 'La nigra ludanto devas matigi per unu movo';

  @override
  String get retry => 'Reprovi';

  @override
  String get reconnecting => 'Rekonektante';

  @override
  String get noNetwork => 'Nekonektita';

  @override
  String get favoriteOpponents => 'Plej ŝatataj kontraŭuloj';

  @override
  String get follow => 'Sekvi';

  @override
  String get following => 'Sekvanta';

  @override
  String get unfollow => 'Malsekvi';

  @override
  String followX(String param) {
    return 'Sekvi $param';
  }

  @override
  String unfollowX(String param) {
    return 'Malsekvi $param';
  }

  @override
  String get block => 'Bloki';

  @override
  String get blocked => 'Blokita';

  @override
  String get unblock => 'Malbloki';

  @override
  String get followsYou => 'Sekvas vin';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 eksekvis $param2';
  }

  @override
  String get more => 'Pli';

  @override
  String get memberSince => 'Membro ekde';

  @override
  String lastSeenActive(String param) {
    return 'Aktiva $param';
  }

  @override
  String get player => 'Ludanto';

  @override
  String get list => 'Listo';

  @override
  String get graph => 'Grafo';

  @override
  String get required => 'Necesa.';

  @override
  String get openTournaments => 'Enireblaj turniroj';

  @override
  String get duration => 'Daŭro';

  @override
  String get winner => 'Venkinto';

  @override
  String get standing => 'Pozicio';

  @override
  String get createANewTournament => 'Krei novan turniron';

  @override
  String get tournamentCalendar => 'Turnira kalendaro';

  @override
  String get conditionOfEntry => 'Kondiĉo de eniro:';

  @override
  String get advancedSettings => 'Spertulaj agordoj';

  @override
  String get safeTournamentName => 'Elekti tre sekuran nomon por la turniro.';

  @override
  String get inappropriateNameWarning => 'Se vi uzas maltaŭgan aŭ maldecan nomon, ni fermos vian konton.';

  @override
  String get emptyTournamentName => 'Se vi lasas ĝin malplena, ni uzos la nomon de fama ŝakludisto.';

  @override
  String get makePrivateTournament => 'Faru la turniron privata kaj restriktu la aliron per pasvorto';

  @override
  String get join => 'Aliĝi';

  @override
  String get withdraw => 'Eliri';

  @override
  String get points => 'Poentoj';

  @override
  String get wins => 'Venkoj';

  @override
  String get losses => 'Malvenkoj';

  @override
  String get createdBy => 'Kreita de';

  @override
  String get tournamentIsStarting => 'Turniro komenciĝas';

  @override
  String get tournamentPairingsAreNowClosed => 'La turniraj parigoj nun fermiĝis.';

  @override
  String standByX(String param) {
    return 'Atentu $param, parigante ludantojn, pretiĝu!';
  }

  @override
  String get pause => 'Paŭzu';

  @override
  String get resume => 'Daŭrigu';

  @override
  String get youArePlaying => 'Vi nun ludas!';

  @override
  String get winRate => 'Venka procento';

  @override
  String get berserkRate => 'Freneza procento';

  @override
  String get performance => 'Efikeco';

  @override
  String get tournamentComplete => 'Turniro finitis';

  @override
  String get movesPlayed => 'Moviĝoj luditaj';

  @override
  String get whiteWins => 'Blankaj venkoj';

  @override
  String get blackWins => 'Nigraj venkoj';

  @override
  String get drawRate => 'Procento de egalvenkoj';

  @override
  String get draws => 'Egalvenkoj';

  @override
  String nextXTournament(String param) {
    return 'Proksima $param turniro:';
  }

  @override
  String get averageOpponent => 'Mezuma kontraŭulo';

  @override
  String get boardEditor => 'Tabulredaktilo';

  @override
  String get setTheBoard => 'Antaŭfaru la tabulo';

  @override
  String get popularOpenings => 'Popularaj malfermoj';

  @override
  String get endgamePositions => 'Finaĵaj pozicioj';

  @override
  String chess960StartPosition(String param) {
    return 'Ŝako960 komenca pozicio: $param';
  }

  @override
  String get startPosition => 'Komenca aranĝo';

  @override
  String get clearBoard => 'Malplenigi tabulon';

  @override
  String get loadPosition => 'Ŝargi aranĝon';

  @override
  String get isPrivate => 'Privata';

  @override
  String reportXToModerators(String param) {
    return 'Raporti $param al moderatoroj';
  }

  @override
  String profileCompletion(String param) {
    return 'Profila kompletiĝo: $param';
  }

  @override
  String xRating(String param) {
    return '$param-rango';
  }

  @override
  String get ifNoneLeaveEmpty => 'Se neniu, lasu malplena';

  @override
  String get profile => 'Profilo';

  @override
  String get editProfile => 'Redakti profilon';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Agordi viaj emoĝio';

  @override
  String get flair => 'Emoĝio';

  @override
  String get youCanHideFlair => 'Estas agordo por kaŝi ĉiujn uzantajn emoĝiojn tra la tuta retejo.';

  @override
  String get biography => 'Biografio';

  @override
  String get countryRegion => 'Lando aŭ regiono';

  @override
  String get thankYou => 'Dankon!';

  @override
  String get socialMediaLinks => 'Ligiloj al sociaj retejoj';

  @override
  String get oneUrlPerLine => 'Po unu URL en linio.';

  @override
  String get inlineNotation => 'Enlineaj markoj';

  @override
  String get makeAStudy => 'Por konservado kaj kunhavigo, konsideru fari studon.';

  @override
  String get clearSavedMoves => 'Forigi movojn';

  @override
  String get previouslyOnLichessTV => 'Antaŭe ĉe Lichess-TV';

  @override
  String get onlinePlayers => 'Konektitaj ludantoj';

  @override
  String get activePlayers => 'Aktivaj ludantoj';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Atentu: la ludo estas taksa, sed ne havas tempolimon!';

  @override
  String get success => 'Sukceso';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Memage iri al sekvanta ludo post via movo';

  @override
  String get autoSwitch => 'Aŭtomata ludŝanĝado';

  @override
  String get puzzles => 'Puzloj';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Nomo';

  @override
  String get description => 'Priskribo';

  @override
  String get descPrivate => 'Privata priskribo';

  @override
  String get descPrivateHelp => 'Teksto kiun nur la teama grupo rigardos. Se estas agordata, oni anstataŭos la publikan priskribon por la teama grupo.';

  @override
  String get no => 'Ne';

  @override
  String get yes => 'Jes';

  @override
  String get help => 'Helpo:';

  @override
  String get createANewTopic => 'Krei novan temon';

  @override
  String get topics => 'Temoj';

  @override
  String get posts => 'Afiŝoj';

  @override
  String get lastPost => 'Lasta afiŝo';

  @override
  String get views => 'Legoj';

  @override
  String get replies => 'Respondoj';

  @override
  String get replyToThisTopic => 'Resondoj al tiu ĉi temo';

  @override
  String get reply => 'Respondi';

  @override
  String get message => 'Mesaĝo';

  @override
  String get createTheTopic => 'Krei novan temon';

  @override
  String get reportAUser => 'Raporti uzanton';

  @override
  String get user => 'Uzanto';

  @override
  String get reason => 'Kialo';

  @override
  String get whatIsIheMatter => 'Pri kio temas la raporto?';

  @override
  String get cheat => 'Trompo';

  @override
  String get troll => 'Trolo';

  @override
  String get other => 'Io alia';

  @override
  String get reportDescriptionHelp => 'Inkluzivu la ligilon al la ludo(j) kaj ekspliku tion, kio malbonas pri la konduto de ĉi tiu uzanto.';

  @override
  String get error_provideOneCheatedGameLink => 'Bonvolu doni almenaŭ unu ligilon al ludo en kiu oni friponis.';

  @override
  String by(String param) {
    return 'de $param';
  }

  @override
  String importedByX(String param) {
    return 'Importita de $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Tiu ĉi temo nun estas fermita.';

  @override
  String get blog => 'Blogo';

  @override
  String get notes => 'Notoj';

  @override
  String get typePrivateNotesHere => 'Entajpu privatajn notojn ĉi tie';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Skribu privatan noton pri ĉi tiu uzanto';

  @override
  String get noNoteYet => 'Neniu noto ankoraŭ';

  @override
  String get invalidUsernameOrPassword => 'Malĝusta uzantnomo aŭ pasvorto';

  @override
  String get incorrectPassword => 'Malkorekta pasvorto';

  @override
  String get invalidAuthenticationCode => 'Nevalida aŭtentigada kodo';

  @override
  String get emailMeALink => 'Retpoŝte sendu al mi ligilon';

  @override
  String get currentPassword => 'Nuna pasvorto';

  @override
  String get newPassword => 'Nova pasvorto';

  @override
  String get newPasswordAgain => 'Nova pasvorto (retajpu)';

  @override
  String get newPasswordsDontMatch => 'La nova pasvorto ne kongruas';

  @override
  String get newPasswordStrength => 'Pasvorta forto';

  @override
  String get clockInitialTime => 'Horloĝa komenca tempo';

  @override
  String get clockIncrement => 'Horloĝa pliigo';

  @override
  String get privacy => 'Privateco';

  @override
  String get privacyPolicy => 'Privateca politiko';

  @override
  String get letOtherPlayersFollowYou => 'Lasi aliajn ludantojn sekvi vin';

  @override
  String get letOtherPlayersChallengeYou => 'Lasi aliajn ludantojn defii vin';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Ebligi al aliaj ludantoj inviti vin al studo';

  @override
  String get sound => 'Sonoj';

  @override
  String get none => 'Neniu';

  @override
  String get fast => 'Rapide';

  @override
  String get normal => 'Normale';

  @override
  String get slow => 'Malrapide';

  @override
  String get insideTheBoard => 'Ene de la tabulo';

  @override
  String get outsideTheBoard => 'Ekstere de la tabulo';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'Ĉe malrapidaj ludoj';

  @override
  String get always => 'Ĉiam';

  @override
  String get never => 'Neniam';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 konkuras en $param2';
  }

  @override
  String get victory => 'Venko!';

  @override
  String get defeat => 'Malvenko';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 kontraŭ $param2 en $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 kontraŭ $param2 en $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 kontraŭ $param2 en $param3';
  }

  @override
  String get timeline => 'Kronologio';

  @override
  String get starting => 'Komenciĝos je:';

  @override
  String get allInformationIsPublicAndOptional => 'Ĉiuj informaĵoj estas publikaj kaj nedevigaj.';

  @override
  String get biographyDescription => 'Rakontu pri vi, kion vi ŝatas pri ŝako, viaj plej ŝatataj malfermoj, ludoj, ludantoj...';

  @override
  String get listBlockedPlayers => 'Montri blokitajn ludantojn';

  @override
  String get human => 'Homo';

  @override
  String get computer => 'Komputilo';

  @override
  String get side => 'Koloro';

  @override
  String get clock => 'Horloĝo';

  @override
  String get opponent => 'Kontraŭulo';

  @override
  String get learnMenu => 'Lerni';

  @override
  String get studyMenu => 'Studi';

  @override
  String get practice => 'Praktiki';

  @override
  String get community => 'Komunumo';

  @override
  String get tools => 'Iloj';

  @override
  String get increment => 'Pliiĝo';

  @override
  String get error_unknown => 'Nevalida valoro';

  @override
  String get error_required => 'Ĉi tiu kampo estas deviga';

  @override
  String get error_email => 'Ĉi tiu retadreso ne estas valida';

  @override
  String get error_email_acceptable => 'Ĉi tiu retadreso estas malakceptata. Bonvolu kontroli ĝin, kaj provu denove.';

  @override
  String get error_email_unique => 'Retadreso nevalida aŭ jam prenita';

  @override
  String get error_email_different => 'Tiu estas jam via retpoŝtadreso';

  @override
  String error_minLength(String param) {
    return 'Minimume ĝi devas enhavi $param signojn';
  }

  @override
  String error_maxLength(String param) {
    return 'Maksimume ĝi devas enhavi $param signojn';
  }

  @override
  String error_min(String param) {
    return 'Minimume ĝi devas enhavi $param';
  }

  @override
  String error_max(String param) {
    return 'Maksimume ĝi devas enhavi $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Se rango estas ± $param';
  }

  @override
  String get ifRegistered => 'Se registrita';

  @override
  String get onlyExistingConversations => 'Nur jamestantaj konversacioj';

  @override
  String get onlyFriends => 'Nur amikoj';

  @override
  String get menu => 'Menuo';

  @override
  String get castling => 'Arokado';

  @override
  String get whiteCastlingKingside => 'Blanko O-O';

  @override
  String get blackCastlingKingside => 'Nigro O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tempo pasinta dum ludado: $param';
  }

  @override
  String get watchGames => 'Spekti ludojn';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tempo pasinta ĉe TV: $param';
  }

  @override
  String get watch => 'Spekti';

  @override
  String get videoLibrary => 'Filmaro';

  @override
  String get streamersMenu => 'Filmistoj';

  @override
  String get mobileApp => 'Poŝtelefona Aplikaĵo';

  @override
  String get webmasters => 'Retejestroj';

  @override
  String get about => 'Pri';

  @override
  String aboutX(String param) {
    return 'Pri $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 estas senpaga ($param2), libera, ne-reklamoj, malferma-kodo ŝaka servilo.';
  }

  @override
  String get really => 'vere';

  @override
  String get contribute => 'Kontribui';

  @override
  String get termsOfService => 'Uzkondiĉojn';

  @override
  String get sourceCode => 'Fontkodo';

  @override
  String get simultaneousExhibitions => 'Samtempludaj ekspozicioj';

  @override
  String get host => 'Gastiganto';

  @override
  String hostColorX(String param) {
    return 'Koloro de gastiganto: $param';
  }

  @override
  String get yourPendingSimuls => 'Viaj okazontaj samtempludoj';

  @override
  String get createdSimuls => 'Antaŭ nelonge kreitaj samtempludoj';

  @override
  String get hostANewSimul => 'Gastigi novan samtempludon';

  @override
  String get signUpToHostOrJoinASimul => 'Subscribi por gastigi aŭ aliĝi samtempludon';

  @override
  String get noSimulFound => 'Ne trovis samtempludon';

  @override
  String get noSimulExplanation => 'Ĉi tiu samtempluda ekspocizio ne ekzistas.';

  @override
  String get returnToSimulHomepage => 'Reveni al la ĉefpaĝo de samtempludoj';

  @override
  String get aboutSimul => 'En samtempludoj, unuopa ludanto defias multajn aliajn ludantojn samtempe.';

  @override
  String get aboutSimulImage => 'El 50 kontraŭuloj, Fischer venkis 47, egalvenkis je 2 kaj estis venkita de 1.';

  @override
  String get aboutSimulRealLife => 'La koncepto estas devenigita de realmondaj eventoj. En la reala mondo, la gastiganto moviĝas de tablo al tablo por fari unuopan movon.';

  @override
  String get aboutSimulRules => 'Kiam la samtempludo komenciĝas, ĉiu ludanto komencas ludon kontraŭ la gastiganto, kiu ludu per la blankaj ŝakpecoj. La samtempludo finiĝas kiam ĉiuj ludoj estas finitaj.';

  @override
  String get aboutSimulSettings => 'Samtempludoj ĉiam estas amikaj. Redefioj, reprenoj kaj plia tempo ne eblas.';

  @override
  String get create => 'Krei';

  @override
  String get whenCreateSimul => 'Kiam vi kreas samtempludon, vi povas ludi kontraŭ multaj ludantoj samtempe.';

  @override
  String get simulVariantsHint => 'Se vi elektas multajn variaĵojn, ĉiu ludanto povas laŭvole elekti unu el la variaĵoj.';

  @override
  String get simulClockHint => 'Ŝakhorloĝo. Ju pli da ludantoj kiujn vi defios, des pli da tempo kiun vi eble bezonos.';

  @override
  String get simulAddExtraTime => 'Vi povas aldoni plian tempon al via ŝakhorloĝo por helpi vian ludadon.';

  @override
  String get simulHostExtraTime => 'Plia tempo por la gastiganto';

  @override
  String get simulAddExtraTimePerPlayer => 'Aldoni komencan tempon al via horloĝo por ĉiu ludanto, kiu aliĝis al la samtempludo.';

  @override
  String get simulHostExtraTimePerPlayer => 'Plia tempo por la gastiganto po ludanto';

  @override
  String get lichessTournaments => 'Turniroj de Lichess';

  @override
  String get tournamentFAQ => 'Oftaj demandoj pri la turnira areno';

  @override
  String get timeBeforeTournamentStarts => 'Tempo ĝis la turniro komenciĝas';

  @override
  String get averageCentipawnLoss => 'Averaĝa centonpeona perdo';

  @override
  String get accuracy => 'Precizeco';

  @override
  String get keyboardShortcuts => 'Fulmoklavoj';

  @override
  String get keyMoveBackwardOrForward => 'movi (mal)antaŭen';

  @override
  String get keyGoToStartOrEnd => 'iri al komenco/fino';

  @override
  String get keyCycleSelectedVariation => 'Cikligi elektan variaĵon';

  @override
  String get keyShowOrHideComments => '(mal)montri komentojn';

  @override
  String get keyEnterOrExitVariation => 'eniru/forlasu variaĵon';

  @override
  String get keyRequestComputerAnalysis => 'Peti komputilan analizon, Lerni de viaj eraroj';

  @override
  String get keyNextLearnFromYourMistakes => 'Sekvo (Lerni de viaj eraroj)';

  @override
  String get keyNextBlunder => 'Sekva erarego';

  @override
  String get keyNextMistake => 'Sekva eraro';

  @override
  String get keyNextInaccuracy => 'Sekva erareto';

  @override
  String get keyPreviousBranch => 'Antaŭa branĉo';

  @override
  String get keyNextBranch => 'Sekva branĉo';

  @override
  String get toggleVariationArrows => 'Baskuligi variaĵojn sagojn';

  @override
  String get cyclePreviousOrNextVariation => 'Cickligi antaŭan/sekvan variaĵon';

  @override
  String get toggleGlyphAnnotations => 'Baskuligi signobildan prinotadon';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo => 'Variaĵaj sagoj lasi vin navigi neutile la movlisto.';

  @override
  String get playSelectedMove => 'ludi elektan movon';

  @override
  String get newTournament => 'Nova konkurso';

  @override
  String get tournamentHomeTitle => 'Ŝaka konkurso kun diversaj tempokontroloj kaj variaĵoj';

  @override
  String get tournamentHomeDescription => 'Ludu en rapidaj konkursoj! Aliĝu al oficialaj konkursoj aŭ kreu vian propran. Unminuta ŝako, Kvinminuta ŝako, Klasika ŝako, Ŝak960, Triŝako kaj aliaj variaĵoj haveblas por senfina ĝuo.';

  @override
  String get tournamentNotFound => 'Konkurso netrovita';

  @override
  String get tournamentDoesNotExist => 'Konkurso ne ekzistas';

  @override
  String get tournamentMayHaveBeenCanceled => 'Eble ĝi ne okazos ĉar malaliĝis ĉiuj ludontoj antaŭ la komenco de la konkurso.';

  @override
  String get returnToTournamentsHomepage => 'Returni al la hejmpaĝo de la konkursoj';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Monata rango-distribuo de $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Via rango je $param1 estas $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Vi estas pli bona ol $param1 de $param2 ludantoj.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 estas pli bona ol $param2 el $param3 ludantoj.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Pli bone ol $param1 el $param2 ludantoj';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Vi ne havas stabilan rangon je $param.';
  }

  @override
  String get yourRating => 'Via rango';

  @override
  String get cumulative => 'Akumulita';

  @override
  String get glicko2Rating => 'Glicko-2 poentaro';

  @override
  String get checkYourEmail => 'Kontrolu vian retpoŝton';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Ni sendis al vi retmesaĝon . Klaku la ligilon en la poŝto por aktivigi vian konton.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Se vi ne vidas la retpoŝton , kontrolu aliajn lokojn kie ĝi povas esti, kiel via rubo , spam, socia , aŭ aliaj dosierujoj.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Ni sendis retmesaĝon al $param. Klaku la ligilon en la poŝto por rekomencigi vian pasvorton.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'De registranta , vi konsentas al esti ligita de nia $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Legu pri nia $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Reto lag inter vi kaj Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tempo por prilabori moviĝon sur Lichess servilo';

  @override
  String get downloadAnnotated => 'Elŝutu prinotitan';

  @override
  String get downloadRaw => 'Elŝutu krudaj';

  @override
  String get downloadImported => 'Elŝutu importitan';

  @override
  String get crosstable => 'Kructabelo';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Vi povas ankaŭ rulumi sur la tabulo por movi en la ludo.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Tuŝadi sur komputilaj varioj por antaŭrigardi ilin.';

  @override
  String get analysisShapesHowTo => 'Premu shift+click aŭ rekt-klaki por desegni cirklojn kaj sagojn sur la tabulo.';

  @override
  String get letOtherPlayersMessageYou => 'Lasu aliajn ludantojn mesaĝi vin';

  @override
  String get receiveForumNotifications => 'Ricevi sciigojn kiam iu mencias vin en forumo';

  @override
  String get shareYourInsightsData => 'Havebligi viajn datumojn pri ŝaka kompreno';

  @override
  String get withNobody => 'Kun neniu';

  @override
  String get withFriends => 'Kun amikoj';

  @override
  String get withEverybody => 'Kun ĉiuj';

  @override
  String get kidMode => 'Infana reĝimo';

  @override
  String get kidModeIsEnabled => 'Infana reĝimo estas enŝaltita.';

  @override
  String get kidModeExplanation => 'Ĉi tio temas pri sekureco. En infana reĝimo, ĉiuj retejaj komunikadoj estas malebligitaj. Aktivigu ĉi tiun por viaj infanoj kaj lernejaj studentoj, por protekti ilin de aliaj retaj uzantoj.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'En infana reĝimo, la lichess-emblemo ekhavas $param-emblemon, por ke vi sciu ke viaj infanoj sekuras.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Via konto estas mastrumita. Petu vian ŝako-instruiston pri malaktivigado de \"infana reĝimo\".';

  @override
  String get enableKidMode => 'Aktivigi infanan reĝimon';

  @override
  String get disableKidMode => 'Malaktivigi infanan reĝimon';

  @override
  String get security => 'Sekureco';

  @override
  String get sessions => 'Sesioj';

  @override
  String get revokeAllSessions => 'revoki ĉiujn sesiojn';

  @override
  String get playChessEverywhere => 'Ludi ŝakon ĉie';

  @override
  String get asFreeAsLichess => 'Tiom libera kiom lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Konstruita por la amo de ŝako , ne mono';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Ĉiuj ricevas ĉiujn trajtojn senpage';

  @override
  String get zeroAdvertisement => 'Nulo anonco';

  @override
  String get fullFeatured => 'Plen-trajte';

  @override
  String get phoneAndTablet => 'Telefono kaj tablojdo';

  @override
  String get bulletBlitzClassical => 'Kuglo , blitz , klasika';

  @override
  String get correspondenceChess => 'Korespondado ŝako';

  @override
  String get onlineAndOfflinePlay => 'interrete kaj eksterrete ludi';

  @override
  String get viewTheSolution => 'Vidi la solvon';

  @override
  String get followAndChallengeFriends => 'Sekvi kaj defii amikojn';

  @override
  String get gameAnalysis => 'Ludanalizo';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 gastigas $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 kuplas $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 ŝatas $param2';
  }

  @override
  String get quickPairing => 'Rapida parado';

  @override
  String get lobby => 'Lobio';

  @override
  String get anonymous => 'Sennoma';

  @override
  String yourScore(String param) {
    return 'Via poentaro: $param';
  }

  @override
  String get language => 'Lingvo';

  @override
  String get background => 'Fono';

  @override
  String get light => 'Hela';

  @override
  String get dark => 'Malhela';

  @override
  String get transparent => 'Travidebla';

  @override
  String get deviceTheme => 'Ila etoso';

  @override
  String get backgroundImageUrl => 'Malantaŭografikaĵo URL:';

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
  String get pieceSet => 'Ŝakpecaro';

  @override
  String get embedInYourWebsite => 'Enkorpigi en via retejo';

  @override
  String get usernameAlreadyUsed => 'Oni jam uzas tiun salutnomon. Bonvolu provi alian.';

  @override
  String get usernamePrefixInvalid => 'La salutnomo devas komenci kun litero.';

  @override
  String get usernameSuffixInvalid => 'La salutnomo devas finanta kun letero aux numero.';

  @override
  String get usernameCharsInvalid => 'La salutnomo devas enhavi nur literojn, nombrojn, substrekojn, kaj streketojn. Sinsekvaj substrekoj kaj streketoj ne permesiĝas.';

  @override
  String get usernameUnacceptable => 'Tiu salutnomo estas malakceptebla.';

  @override
  String get playChessInStyle => 'Ludu ŝakon elegante';

  @override
  String get chessBasics => 'Ŝaka aboco';

  @override
  String get coaches => 'Trejnistoj';

  @override
  String get invalidPgn => 'Nevalida PGN';

  @override
  String get invalidFen => 'Nevalida FEN';

  @override
  String get custom => 'Propra';

  @override
  String get notifications => 'Sciigoj';

  @override
  String notificationsX(String param1) {
    return 'Sciigoj: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rango: $param';
  }

  @override
  String get practiceWithComputer => 'Praktiki kun komputilo';

  @override
  String anotherWasX(String param) {
    return 'Alia estis $param';
  }

  @override
  String bestWasX(String param) {
    return 'Plej bona estis $param';
  }

  @override
  String get youBrowsedAway => 'Vi retumis foren';

  @override
  String get resumePractice => 'Daŭrigi praktikon';

  @override
  String get drawByFiftyMoves => 'La ludo estis egalvenko por la regulo de 50 movoj.';

  @override
  String get theGameIsADraw => 'La ludo egalvenkas.';

  @override
  String get computerThinking => 'Komputilo pensas ...';

  @override
  String get seeBestMove => 'Vidi la plej bonan movon';

  @override
  String get hideBestMove => 'Kaŝi la plej bonan movon';

  @override
  String get getAHint => 'Ricevi konsileton';

  @override
  String get evaluatingYourMove => 'Taksante vian movon ...';

  @override
  String get whiteWinsGame => 'Blanko venkas';

  @override
  String get blackWinsGame => 'Nigro venkas';

  @override
  String get learnFromYourMistakes => 'Lerni de viaj eraroj';

  @override
  String get learnFromThisMistake => 'Lerni de tiu ĉi eraro';

  @override
  String get skipThisMove => 'Preterpasi tiun ĉi movon';

  @override
  String get next => 'Sekva';

  @override
  String xWasPlayed(String param) {
    return '$param ludita';
  }

  @override
  String get findBetterMoveForWhite => 'Trovi plibonan movon por blanka';

  @override
  String get findBetterMoveForBlack => 'Trovi plibonan movon por nigra';

  @override
  String get resumeLearning => 'Daŭrigi lerni';

  @override
  String get youCanDoBetter => 'Vi povas fari pli bone';

  @override
  String get tryAnotherMoveForWhite => 'Provi por blanka alian movon';

  @override
  String get tryAnotherMoveForBlack => 'Provi por nigra alian movon';

  @override
  String get solution => 'Solvo';

  @override
  String get waitingForAnalysis => 'Atendante analizon';

  @override
  String get noMistakesFoundForWhite => 'Neniu eraroj trovita por blanko';

  @override
  String get noMistakesFoundForBlack => 'Neniu eraroj trovita por nigro';

  @override
  String get doneReviewingWhiteMistakes => 'Revui blankajn erarojn estas finita';

  @override
  String get doneReviewingBlackMistakes => 'Revui nigrajn erarojn estas finita';

  @override
  String get doItAgain => 'Fari ĝin denove';

  @override
  String get reviewWhiteMistakes => 'Revui blankajn erarojn';

  @override
  String get reviewBlackMistakes => 'Revui nigrajn erarojn';

  @override
  String get advantage => 'Avantaĝo';

  @override
  String get opening => 'Malfermo';

  @override
  String get middlegame => 'Mezaĵo';

  @override
  String get endgame => 'Finaĵo';

  @override
  String get conditionalPremoves => 'Kondiĉaj antaŭmovoj';

  @override
  String get addCurrentVariation => 'Aldoni aktualan variaĵon';

  @override
  String get playVariationToCreateConditionalPremoves => 'Ludi variaĵo por krei kondiĉajn antaŭmovojn';

  @override
  String get noConditionalPremoves => 'Ne kondiĉaj antaŭmovoj';

  @override
  String playX(String param) {
    return 'Ludu $param';
  }

  @override
  String get showUnreadLichessMessage => 'Vi ricevis privatan mesaĝon de Lichess.';

  @override
  String get clickHereToReadIt => 'Alklaku ĉi tie por legi ĝin';

  @override
  String get sorry => 'Bedaŭrinde :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Ni devis provizore suspendi vin.';

  @override
  String get why => 'Kial?';

  @override
  String get pleasantChessExperience => 'Nia celo estas provizi plaĉan ŝakan sperton al ĉiuj.';

  @override
  String get goodPractice => 'Pro tio, ni devas certigi ke ĉiuj ludantoj sekvas bonna etiketon.';

  @override
  String get potentialProblem => 'Kiam ni detektas eblan problemon, ni montras ĉi tiun mesaĝon.';

  @override
  String get howToAvoidThis => 'Kiel eviti tion?';

  @override
  String get playEveryGame => 'Ludu ĉiun ludon, kiun vi komencas.';

  @override
  String get tryToWin => 'Provu gajni (aŭ almenaŭ egaligi) ĉiun ludon, kiun vi ludas.';

  @override
  String get resignLostGames => 'Rezignu perditajn ludojn (ne foruzu la tempon).';

  @override
  String get temporaryInconvenience => 'Ni pardonpetas pro la provizoraj malkomfortoj,';

  @override
  String get wishYouGreatGames => 'kaj ni deziras al vi bonegajn ludojn ĉe lichess.org.';

  @override
  String get thankYouForReading => 'Dankon pro via legado!';

  @override
  String get lifetimeScore => 'Ĝisnuna poentaro';

  @override
  String get currentMatchScore => 'Aktuala matĉa poentaro';

  @override
  String get agreementAssistance => 'Mi konsentas, ke mi neniam ricevos helpon dum miaj ludoj (de komputila programo, libro, datumbazo aŭ alia persono).';

  @override
  String get agreementNice => 'Mi konsentas, ke mi ĉiam estos respektema al aliaj ludantoj.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Mi konsentas ke mi ne faros plurajn kontojn (escepte pro la deklaritaj kialoj en la $param).';
  }

  @override
  String get agreementPolicy => 'Mi konsentas sekvi ĉiujn politikojn de Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Serĉi aŭ komenci novan konversacion';

  @override
  String get edit => 'Redakti';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapida';

  @override
  String get classical => 'Klasika';

  @override
  String get ultraBulletDesc => 'Freneze rapidaj ludoj: malpli ol 30 sekundoj';

  @override
  String get bulletDesc => 'Tre rapidaj ludoj: malpli ol 3 minutoj';

  @override
  String get blitzDesc => 'Rapidaj ludoj: 3 ĝis 8 minutoj';

  @override
  String get rapidDesc => 'Rapidaj ludoj: 8 ĝis 25 minutoj';

  @override
  String get classicalDesc => 'Klasikaj ludoj: 25 minutoj kaj plu';

  @override
  String get correspondenceDesc => 'Korespondaj ludoj: unu aŭ kelkaj tagoj po movo';

  @override
  String get puzzleDesc => 'Ŝaktaktika trejnisto';

  @override
  String get important => 'Grava';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Via demando eble jam havas respondon $param1';
  }

  @override
  String get inTheFAQ => 'en la F.A.Q.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Por raporti uzanton pro trompado aŭ malbona konduto, $param1';
  }

  @override
  String get useTheReportForm => 'uzu la raportformularon';

  @override
  String toRequestSupport(String param1) {
    return 'Por peti subtenon, $param1';
  }

  @override
  String get tryTheContactPage => 'provu la kontaktopaĝon';

  @override
  String makeSureToRead(String param1) {
    return 'Certe legos $param1';
  }

  @override
  String get theForumEtiquette => 'la foruma etiketo';

  @override
  String get thisTopicIsArchived => 'Ĉi tiu temo eniris la arkivon kaj oni ne plu rajtas respondi.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Aliĝu al $param1, por afiŝi en ĉi tiu forumo';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 teamo';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Vi jam ne rajtas afiŝi en la forumoj. Ludu iujn ludojn!';

  @override
  String get subscribe => 'Aboni';

  @override
  String get unsubscribe => 'Malaboni';

  @override
  String mentionedYouInX(String param1) {
    return 'menciis vin en \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 menciis vin en \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'invitis vin al \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 invitis vin al \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Nun vi estas teamano.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Vi aliĝis al \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'La ludanto, kiun vi reportis estis blokita';

  @override
  String get congratsYouWon => 'Gratulon, vi venkis!';

  @override
  String gameVsX(String param1) {
    return 'Ludo kontraŭ $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 kontraŭ $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Vi malvenkis kontraŭ iu kiu malobeis la regulojn de Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Estis redonitaj $param1 $param2 poentoj.';
  }

  @override
  String get timeAlmostUp => 'La tempo preskaŭ finiĝis!';

  @override
  String get clickToRevealEmailAddress => '[Klaku por malkaŝi retpoŝtadreson]';

  @override
  String get download => 'Elŝuti';

  @override
  String get coachManager => 'Trejnista administranto';

  @override
  String get streamerManager => 'Filmprezentista administranto';

  @override
  String get cancelTournament => 'Nuligi la turniron';

  @override
  String get tournDescription => 'Turnira priskribo';

  @override
  String get tournDescriptionHelp => 'Ĉu io ajn speciala, ke vi volas diri al la partoprenantoj? Provu teni ĝin mallonga. Markdown ligoj estas disponebla: [name](https://url)';

  @override
  String get ratedFormHelp => 'Ludoj estas rangaj\nkaj influas la rangojn de ludantoj';

  @override
  String get onlyMembersOfTeam => 'Nur teamanoj';

  @override
  String get noRestriction => 'Neniu limigo';

  @override
  String get minimumRatedGames => 'Minimumo de rangaj ludoj';

  @override
  String get minimumRating => 'Minimuma rango';

  @override
  String get maximumWeeklyRating => 'Maksimuma ĉiusemajna rango';

  @override
  String positionInputHelp(String param) {
    return 'Alglui validan FEN por komenci ĉiujn ludojn el donita pozicio.\nTio nur funkcias por normaj ludoj, ne kun variantoj.\nVi povas uzi la $param por krei FEN pozicio, tiam alglui ĝin ĉi tie.\nLasi ĝin malplena por komenci ludojn de la norma komenca pozicio.';
  }

  @override
  String get cancelSimul => 'Nuligi la samtempludo';

  @override
  String get simulHostcolor => 'Gastiganta koloro por ĉiu ludo';

  @override
  String get estimatedStart => 'Proksimuma komenca tempo';

  @override
  String simulFeatured(String param) {
    return 'Prezenti ĉe $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Montri vian samtempludon al ĉiuj en $param. Malaktivigi por privataj samtempludoj.';
  }

  @override
  String get simulDescription => 'Priskribo de la samtempludo';

  @override
  String get simulDescriptionHelp => 'Ĉu vi volas diri ion al la partoprenantoj?';

  @override
  String markdownAvailable(String param) {
    return '$param estas havebla por pli progresinta sintakso.';
  }

  @override
  String get embedsAvailable => 'Algui luda URL aŭ studa ĉapitro URL enkorpigi ĝin.';

  @override
  String get inYourLocalTimezone => 'En via loka horzono';

  @override
  String get tournChat => 'Babilejo de turnira';

  @override
  String get noChat => 'Malaktivigi babilejon';

  @override
  String get onlyTeamLeaders => 'Nuraj teamaj gvidantoj';

  @override
  String get onlyTeamMembers => 'Nuraj teamaj membroj';

  @override
  String get navigateMoveTree => 'Navigi la movarbon';

  @override
  String get mouseTricks => 'Musaj lertaĵoj';

  @override
  String get toggleLocalAnalysis => 'Baskuligu lokan komputilan analizon';

  @override
  String get toggleAllAnalysis => 'Baskuligu ĉiujn komputilan analizon';

  @override
  String get playComputerMove => 'Ludi la plej bonan komputilan movon';

  @override
  String get analysisOptions => 'Analizaj agordoj';

  @override
  String get focusChat => 'Babilejo de fokuso';

  @override
  String get showHelpDialog => 'Montri ĉi tiun help-dialogujon';

  @override
  String get reopenYourAccount => 'Remalfermi vian konton';

  @override
  String get closedAccountChangedMind => 'Se vi fermis vian konton, sed decidis alie poste, vi povas unufoje rehavigi vian konton.';

  @override
  String get onlyWorksOnce => 'Ĉi tiu funkcios nur unufoje.';

  @override
  String get cantDoThisTwice => 'Se vi fermos vian konton je la dua fojo, ne estos maniero por regajni ĝin.';

  @override
  String get emailAssociatedToaccount => 'Retpoŝtadreso, ke asociitas al la konto';

  @override
  String get sentEmailWithLink => 'Ni sendis retmesaĝon kun ligilo al vi.';

  @override
  String get tournamentEntryCode => 'Turnira enirkodo';

  @override
  String get hangOn => 'Atendu!';

  @override
  String gameInProgress(String param) {
    return 'Vi havas ludon en progreso kun $param.';
  }

  @override
  String get abortTheGame => 'Ĉesigu ludon';

  @override
  String get resignTheGame => 'Rezignu la ludo';

  @override
  String get youCantStartNewGame => 'Vi ne povas komenci novan ludon ĝis ĉi tiu finiĝos.';

  @override
  String get since => 'Ekde';

  @override
  String get until => 'Ĝis';

  @override
  String get lichessDbExplanation => 'Rangaj ludoj luditaj per Lichess';

  @override
  String get switchSides => 'Ŝanĝi flankojn';

  @override
  String get closingAccountWithdrawAppeal => 'Fermata de via konto estos eltiri vian apelacion';

  @override
  String get ourEventTips => 'Niaj konsiletoj por organizi eventojn';

  @override
  String get instructions => 'Instrukcio';

  @override
  String get showMeEverything => 'Ĉion montru al mi';

  @override
  String get lichessPatronInfo => 'Lichess estas almoza kaj tute libera malfermitkoda programaro.\nĈiu funkciada elspezo, ellaborado, kaj enhavo estas financita sole de uzantajn donacojn.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Via kontraŭulo forlasis la ludon. Vi povas postuli venkon en $count sekundoj.',
      one: 'Via kontraŭulo forlasis la ludon. Vi povas postuli venkon en $count sekundo.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mato post $count duonmovoj',
      one: 'Mato post $count duonmovo',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eraregoj',
      one: '$count erarego',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eraroj',
      one: '$count eraro',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eraretoj',
      one: '$count erareto',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count konektitaj ludantoj',
      one: '$count konektita ludanto',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ludoj',
      one: '$count ludo',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rangoj trans $param2 ludoj',
      one: '$count rango trans $param2 ludo',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paĝmarkoj',
      one: '$count paĝmarko',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tagoj',
      one: '$count tago',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horoj',
      one: '$count horo',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutoj',
      one: '$count minuto',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Posicio aktualiĝas en ĉiu $count minutoj',
      one: 'Posicio aktualiĝas en ĉiu minuto',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puzloj',
      one: '$count puzlo',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ludoj kun vi',
      one: '$count ludo kun vi',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taksaj ludoj',
      one: '$count taksaj ludoj',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count venkoj',
      one: '$count venkoj',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count malvenkoj',
      one: '$count malvenkoj',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count egalvenkoj',
      one: '$count egalvenkoj',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktualaj',
      one: '$count aktualaj',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Doni $count sekundojn',
      one: 'Doni $count sekundojn',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnira poento',
      one: '$count turnira poento',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studoj',
      one: '$count studo',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count samtempludoj',
      one: '$count samtempludo',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count taksaj ludoj',
      one: '≥ $count taksa ludo',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count taksaj ludoj de $param2',
      one: '≥ $count taksa ludo de $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vi devas ludi $count pli de taksaj $param2 ludoj',
      one: 'Vi devas ludi $count pli de taksa $param2 ludo',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vi devas ludi $count pli de taksaj ludoj',
      one: 'Vi devas ludi $count pli de taksa ludo',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Importitaj ludoj',
      one: '$count Importitaj ludoj',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amikoj enretaj',
      one: '$count amiko enreta',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekvantoj',
      one: '$count sekvanto',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekvatoj',
      one: '$count sekvatoj',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Malpli ol $count minutoj',
      one: 'Malpli ol $count minuto',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktivaj ludoj',
      one: '$count aktivaj ludoj',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimumo: $count signoj.',
      one: 'Maksimumo: $count signoj.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blokitaj ludantoj',
      one: '$count blokitaj ludantoj',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Forumaj Afiŝoj',
      one: '$count Forumaj Afiŝoj',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 ludantoj ĉi tiu semajno.',
      one: 'Unu $param2 ludanto ĉi tiu semajno.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Havebla en $count lingvoj!',
      one: 'Havebla en $count lingvo!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundoj por ludi la unuan movon',
      one: '$count sekundo por ludi la unuan movon',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundoj',
      one: '$count sekundo',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kaj savi $count antaŭmovajn vicojn',
      one: 'kaj savi $count antaŭmovan vicon',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Movu por komenci';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Vi ludas per la blankaj pecoj en ĉiuj puzloj';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Vi ludas per la nigraj pecoj en ĉiuj puzloj';

  @override
  String get stormPuzzlesSolved => 'puzloj solvitaj';

  @override
  String get stormNewDailyHighscore => 'Nova ĉiutaga rekordo!';

  @override
  String get stormNewWeeklyHighscore => 'Nova ĉiusemana rekordo!';

  @override
  String get stormNewMonthlyHighscore => 'Nova ĉiumonata rekordo!';

  @override
  String get stormNewAllTimeHighscore => 'Nova nesuperita rekordo!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Antaŭa rekordo estis $param';
  }

  @override
  String get stormPlayAgain => 'Reludi';

  @override
  String stormHighscoreX(String param) {
    return 'Rekordo: $param';
  }

  @override
  String get stormScore => 'Poentaroj';

  @override
  String get stormMoves => 'Movoj';

  @override
  String get stormAccuracy => 'Precizeco';

  @override
  String get stormCombo => 'Sinsekvo';

  @override
  String get stormTime => 'Tempo';

  @override
  String get stormTimePerMove => 'Tempo por movo';

  @override
  String get stormHighestSolved => 'Plej alta solvita';

  @override
  String get stormPuzzlesPlayed => 'Luditaj puzloj';

  @override
  String get stormNewRun => 'Nova kuro (fulmklavo: Spaco)';

  @override
  String get stormEndRun => 'Nova kuro (fulmklavo: Enigo)';

  @override
  String get stormHighscores => 'Rekordoj';

  @override
  String get stormViewBestRuns => 'Vidi plej bonajn kurojn';

  @override
  String get stormBestRunOfDay => 'Plej bona kuro de la tago';

  @override
  String get stormRuns => 'Kuroj';

  @override
  String get stormGetReady => 'Preparu!';

  @override
  String get stormWaitingForMorePlayers => 'Atendante pli da ludantoj...';

  @override
  String get stormRaceComplete => 'Puzvetkuro finita!';

  @override
  String get stormSpectating => 'Spektante';

  @override
  String get stormJoinTheRace => 'Aliĝu al la puzvetkuro!';

  @override
  String get stormStartTheRace => 'Komenci la puzvetkuron';

  @override
  String stormYourRankX(String param) {
    return 'Via poentaro: $param';
  }

  @override
  String get stormWaitForRematch => 'Anendu la rematĉon';

  @override
  String get stormNextRace => 'Sekva puzvetkuro';

  @override
  String get stormJoinRematch => 'Aliĝu al rematĉon';

  @override
  String get stormWaitingToStart => 'Atendante, ke komenci';

  @override
  String get stormCreateNewGame => 'Kreu novan ludon';

  @override
  String get stormJoinPublicRace => 'Aliĝu al publika puzvetkuro';

  @override
  String get stormRaceYourFriends => 'Puzvetkuri kontraŭ viaj amikoj';

  @override
  String get stormSkip => 'preterpasi';

  @override
  String get stormSkipHelp => 'Vi povas preterpasi unu movon po puzvetkuro:';

  @override
  String get stormSkipExplanation => 'Preterpasu ĉi tiun movon por ŝirmi vian sinsekvo! Nur laboras unu per kuro.';

  @override
  String get stormFailedPuzzles => 'Malsukcesaj puzloj';

  @override
  String get stormSlowPuzzles => 'Malrapidaj puzloj';

  @override
  String get stormSkippedPuzzle => 'Preterpasita puzlo';

  @override
  String get stormThisWeek => 'Ĉi semajno';

  @override
  String get stormThisMonth => 'Ĉi monato';

  @override
  String get stormAllTime => 'Ĉiam';

  @override
  String get stormClickToReload => 'Klaku por reŝargo';

  @override
  String get stormThisRunHasExpired => 'Ĉi tiu kuro eksvalidiĝis!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Ĉi tiu kuro estis malfermita en alia langeto!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kuroj',
      one: '1 kuro',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ludis $count kurojn de $param2',
      one: 'Ludis unu kuron de $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess filmprezentistoj';

  @override
  String get studyShareAndExport => 'Konigi & eksporti';

  @override
  String get studyStart => 'Komenci';
}
