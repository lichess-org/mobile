import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get mobileHomeTab => 'Inici';

  @override
  String get mobilePuzzlesTab => 'Problemes';

  @override
  String get mobileToolsTab => 'Eines';

  @override
  String get mobileWatchTab => 'Visualitza';

  @override
  String get mobileSettingsTab => 'Configuració';

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
  String get activityActivity => 'Activitat';

  @override
  String get activityHostedALiveStream => 'Has fet una retransmissió en directe';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Classificat #$param1 en $param2';
  }

  @override
  String get activitySignedUp => 'Registrat a Lichess';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha col.laborat amb lichess.org durant $count mesos com $param2',
      one: 'Ha col.laborat amb lichess.org durant $count mes com $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha practicat $count posicions en $param2',
      one: 'Has practicat $count posició en $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha resolt $count exercicis de tàctica',
      one: 'Ha resolt $count exercici de tàctica',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha jugat $count partides $param2',
      one: 'Has jugat $count partida $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha publicat $count missatges a $param2',
      one: 'Ha publicat $count missatge a $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has fet $count moviments',
      one: 'Has fet $count moviment',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'en $count partides per correspondència',
      one: 'en $count partida per correspondència',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha jugat $count partides per correspondència',
      one: 'Ha jugat $count partida per correspondència',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Segueixes a $count jugadors',
      one: 'Segueixes a $count jugador',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Té $count seguidors nous',
      one: 'Té $count seguidor nou',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has ofert $count exhibicions simultànies',
      one: 'Has ofert $count exhibició simultània',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has participat en $count exhibicions simultànies',
      one: 'Has participat en $count exhibició simultània',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has creat $count estudis',
      one: 'Has creat $count estudi',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has competit en $count tornejos',
      one: 'Has competit en $count torneig',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countº en la classificació (dins dels $param2% millors) amb $param3 partides en $param4',
      one: '$countº en la classificació (dins del $param2% millor) amb $param3 partida en $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha jugat en $count tornejos suïssos',
      one: 'Ha jugat en $count tornejos suïssos',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'T\'has unit a $count equips',
      one: 'Membre de $count equip',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Retransmissions';

  @override
  String get broadcastLiveBroadcasts => 'Retransmissions de tornejos en directe';

  @override
  String challengeChallengesX(String param1) {
    return 'Desafiaments: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Desafia a una partida';

  @override
  String get challengeChallengeDeclined => 'Desafiament rebutjat';

  @override
  String get challengeChallengeAccepted => 'Desafiament acceptat!';

  @override
  String get challengeChallengeCanceled => 'Desafiament cancel·lat.';

  @override
  String get challengeRegisterToSendChallenges => 'Si us plau, registra\'t per enviar desafiaments.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'No pots desafiar a $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param no accepta desafiaments.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'La teva qualificació de $param1 és massa distant de la de $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'No es pot desafiar a causa de la qualificació provisional de $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param només accepta desafiaments dels amics.';
  }

  @override
  String get challengeDeclineGeneric => 'No accepto desafiaments en aquest moment.';

  @override
  String get challengeDeclineLater => 'Ara mateix no puc, si us plau prova-ho més tard.';

  @override
  String get challengeDeclineTooFast => 'Aquest control de temps és massa ràpid per a mi. Si us plau, desafia\'m un altra vegada amb un ritme més lent.';

  @override
  String get challengeDeclineTooSlow => 'Aquest control de temps és massa lent per a mi. Si us plau, desafia\'m una altra vegada amb un ritme més ràpid.';

  @override
  String get challengeDeclineTimeControl => 'No accepto desafiaments amb aquest control de temps.';

  @override
  String get challengeDeclineRated => 'Si us plau, envia\'m un desafiament puntuat.';

  @override
  String get challengeDeclineCasual => 'Si us plau, envia\'m un desafiament casual.';

  @override
  String get challengeDeclineStandard => 'No accepto desafiaments per variants en aquest moment.';

  @override
  String get challengeDeclineVariant => 'No vull jugar aquesta variant en aquest moment.';

  @override
  String get challengeDeclineNoBot => 'No accepto desafiaments de bots.';

  @override
  String get challengeDeclineOnlyBot => 'Només accepto desafiaments de bots.';

  @override
  String get challengeInviteLichessUser => 'O invita un usuari de Lichess:';

  @override
  String get contactContact => 'Contacte';

  @override
  String get contactContactLichess => 'Contacte Lichess';

  @override
  String get patronDonate => 'Donar';

  @override
  String get patronLichessPatron => 'Patró de Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Estadístiques de $param';
  }

  @override
  String get perfStatViewTheGames => 'Veure les partides';

  @override
  String get perfStatProvisional => 'provisional';

  @override
  String get perfStatNotEnoughRatedGames => 'No s\'han jugat suficients partides puntuables per poder establir una puntuació fiable.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progressió en les últimes $param partides:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Desviació de la puntuació: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Un valor més baix significa que la qualificació és més regular. Per sobre del $param1, la qualificació es considera provisional. Per ser inclós en les classificacions, aquest valor ha de ser inferior al $param2 (escacs estàndard) o al $param3 (variants).';
  }

  @override
  String get perfStatTotalGames => 'Partides totals';

  @override
  String get perfStatRatedGames => 'Partides puntuables';

  @override
  String get perfStatTournamentGames => 'Partides de torneig';

  @override
  String get perfStatBerserkedGames => 'Partides agilitzades (berserk)';

  @override
  String get perfStatTimeSpentPlaying => 'Temps dedicat a jugar';

  @override
  String get perfStatAverageOpponent => 'Mitjana dels oponents';

  @override
  String get perfStatVictories => 'Victòries';

  @override
  String get perfStatDefeats => 'Derrotes';

  @override
  String get perfStatDisconnections => 'Desconnexions';

  @override
  String get perfStatNotEnoughGames => 'No s\'han jugat suficients partides';

  @override
  String perfStatHighestRating(String param) {
    return 'Puntuació més alta: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Puntuació més baixa: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'des de $param1 fins a $param2';
  }

  @override
  String get perfStatWinningStreak => 'Ratxa de victòries';

  @override
  String get perfStatLosingStreak => 'Ratxa de derrotes';

  @override
  String perfStatLongestStreak(String param) {
    return 'Ratxa més llarga: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Ratxa actual: $param';
  }

  @override
  String get perfStatBestRated => 'Millors victòries puntuables';

  @override
  String get perfStatGamesInARow => 'Partides jugades seguides';

  @override
  String get perfStatLessThanOneHour => 'Menys d\'una hora entre partida i partida';

  @override
  String get perfStatMaxTimePlaying => 'Temps màxim jugant';

  @override
  String get perfStatNow => 'ara';

  @override
  String get preferencesPreferences => 'Configuracions';

  @override
  String get preferencesDisplay => 'Visualització';

  @override
  String get preferencesPrivacy => 'Privacitat';

  @override
  String get preferencesNotifications => 'Notificacions';

  @override
  String get preferencesPieceAnimation => 'Animació de les peces';

  @override
  String get preferencesMaterialDifference => 'Diferència de material';

  @override
  String get preferencesBoardHighlights => 'Marcar caselles (últim moviment i escac)';

  @override
  String get preferencesPieceDestinations => 'Destinacions de la peça (moviments vàlids i moviments anticipats)';

  @override
  String get preferencesBoardCoordinates => 'Coordenades del tauler (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Llista de moviments durant la partida';

  @override
  String get preferencesPgnPieceNotation => 'Notació de les jugades';

  @override
  String get preferencesChessPieceSymbol => 'Símbol de la peça';

  @override
  String get preferencesPgnLetter => 'Lletra (R, D, T, A, C)';

  @override
  String get preferencesZenMode => 'Mode Zen';

  @override
  String get preferencesShowPlayerRatings => 'Mostra les puntuacions del jugador';

  @override
  String get preferencesShowFlairs => 'Mostra l\'estil dels jugadors';

  @override
  String get preferencesExplainShowPlayerRatings => 'Això permet amagar totes les puntuacions de la pàgina web per a centrar-se en els escacs. Les partides poden ser puntuades, això només canvia el que es veu.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Mostrar icona canvi de mida';

  @override
  String get preferencesOnlyOnInitialPosition => 'Només en posició inicial';

  @override
  String get preferencesInGameOnly => 'Només durant la partida';

  @override
  String get preferencesChessClock => 'Rellotge d\'escacs';

  @override
  String get preferencesTenthsOfSeconds => 'Dècimes de segon';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Quan restin menys de 10 segons';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Barres de progrés verdes horitzontals';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Emetre so quan quedi poc temps';

  @override
  String get preferencesGiveMoreTime => 'Donar més temps';

  @override
  String get preferencesGameBehavior => 'Comportament durant la partida';

  @override
  String get preferencesHowDoYouMovePieces => 'Com mous les peces?';

  @override
  String get preferencesClickTwoSquares => 'Fes clic en dues caselles';

  @override
  String get preferencesDragPiece => 'Mou una peça';

  @override
  String get preferencesBothClicksAndDrag => 'Qualsevol';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Moviments anticipats (moure durant el torn de l\'oponent)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Tornar enrere (amb l\'aprovació del rival)';

  @override
  String get preferencesInCasualGamesOnly => 'Només en partides amistoses';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promocionar a Dama automàticament';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Mantingui premuda la tecla <ctrl> durant la promoció per deshabilitar la promoció automàtica temporalment';

  @override
  String get preferencesWhenPremoving => 'En moviments anticipats';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Reclamar taules per repetició automàticament';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Quan restin < 30 segons';

  @override
  String get preferencesMoveConfirmation => 'Confirmació del moviment';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Es pot desactivar durant la partida al menú del taulell';

  @override
  String get preferencesInCorrespondenceGames => 'Partides per correspondència';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Correspondència i sense límit de temps';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Confirmar resignació i oferiment de taules';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Mètode d\'Enroc';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Moure el rei dues caselles';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Moure el rei a la torre';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Moure peces amb el teclat';

  @override
  String get preferencesInputMovesWithVoice => 'Introduïu moviments amb la vostra veu';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Apuntar fletxes a jugades legals';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Dir “Bona partida, ben jugat!” quan perds o fas taules';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Les teves preferències s\'han desat.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Desplaça\'t amb la rodeta pel tauler per reproduir jugades';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Correu electrònic diari de notificació amb les vostres partides per correspondència';

  @override
  String get preferencesNotifyStreamStart => 'Un streamer que seguiu ha començat una transmissió';

  @override
  String get preferencesNotifyInboxMsg => 'Nou missatge a la safata d\'entrada';

  @override
  String get preferencesNotifyForumMention => 'Un comentari del fòrum et menciona';

  @override
  String get preferencesNotifyInvitedStudy => 'Invitació a un estudi';

  @override
  String get preferencesNotifyGameEvent => 'Partida per correspondència actualitzada';

  @override
  String get preferencesNotifyChallenge => 'Desafiaments';

  @override
  String get preferencesNotifyTournamentSoon => 'Un torneig comença aviat';

  @override
  String get preferencesNotifyTimeAlarm => 'S\'està esgotant el rellotge d\'una partida per correspondència';

  @override
  String get preferencesNotifyBell => 'Notificació emergent a Lichess';

  @override
  String get preferencesNotifyPush => 'Notifica un dispositiu quan no esteu a Lichess';

  @override
  String get preferencesNotifyWeb => 'Navegador';

  @override
  String get preferencesNotifyDevice => 'Dispositiu';

  @override
  String get preferencesBellNotificationSound => 'So de notificació';

  @override
  String get puzzlePuzzles => 'Problemes';

  @override
  String get puzzlePuzzleThemes => 'Temàtiques de problemes';

  @override
  String get puzzleRecommended => 'Recomanat';

  @override
  String get puzzlePhases => 'Fases';

  @override
  String get puzzleMotifs => 'Motius';

  @override
  String get puzzleAdvanced => 'Avançat';

  @override
  String get puzzleLengths => 'Durada';

  @override
  String get puzzleMates => 'Mats';

  @override
  String get puzzleGoals => 'Objectius';

  @override
  String get puzzleOrigin => 'Origen';

  @override
  String get puzzleSpecialMoves => 'Jugades especials';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'T\'ha agradat aquest problema?';

  @override
  String get puzzleVoteToLoadNextOne => 'Vota per passar al següent!';

  @override
  String get puzzleUpVote => 'Vota positivament el problema';

  @override
  String get puzzleDownVote => 'Vota negativament el problema';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'La teva puntuació de problemes no canviarà. Tingues en compte que els problemes no són una competició. La puntuació indica els problemes que més s\'assimilen a les teves habilitats.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Troba la millor jugada de les blanques.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Troba la millor jugada de les negres.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Per obtenir problemes personalitzats:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Problema $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Problema del dia';

  @override
  String get puzzleDailyPuzzle => 'Problema del dia';

  @override
  String get puzzleClickToSolve => 'Clica per resoldre';

  @override
  String get puzzleGoodMove => 'Bona jugada';

  @override
  String get puzzleBestMove => 'La millor jugada!';

  @override
  String get puzzleKeepGoing => 'Continua jugant…';

  @override
  String get puzzlePuzzleSuccess => 'Èxit!';

  @override
  String get puzzlePuzzleComplete => 'Problema fet!';

  @override
  String get puzzleByOpenings => 'Per obertura';

  @override
  String get puzzlePuzzlesByOpenings => 'Problemes per obertura';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Obertures que heu jugat més en partides puntuades';

  @override
  String get puzzleUseFindInPage => 'Utilitzeu la \"Cerca en la pàgina\" del menú del vostre navegador per trobar la vostra obertura preferida!';

  @override
  String get puzzleUseCtrlF => 'Utilitzeu Ctrl+f per trobar la vostra obertura preferida!';

  @override
  String get puzzleNotTheMove => 'Aquesta no és la jugada!';

  @override
  String get puzzleTrySomethingElse => 'Prova d\'una altra manera.';

  @override
  String puzzleRatingX(String param) {
    return 'Puntuació: $param';
  }

  @override
  String get puzzleHidden => 'ocult';

  @override
  String puzzleFromGameLink(String param) {
    return 'De la partida $param';
  }

  @override
  String get puzzleContinueTraining => 'Continuar l\'entrenament';

  @override
  String get puzzleDifficultyLevel => 'Nivell de dificultat';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Més fàcil';

  @override
  String get puzzleEasiest => 'El més fàcil';

  @override
  String get puzzleHarder => 'Més difícil';

  @override
  String get puzzleHardest => 'El més difícil';

  @override
  String get puzzleExample => 'Exemple';

  @override
  String get puzzleAddAnotherTheme => 'Afegir un nou tema';

  @override
  String get puzzleNextPuzzle => 'Següent puzzle';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Passar al següent problema immediatament';

  @override
  String get puzzlePuzzleDashboard => 'Panell de problemes';

  @override
  String get puzzleImprovementAreas => 'Àrees de millora';

  @override
  String get puzzleStrengths => 'Fortaleses';

  @override
  String get puzzleHistory => 'Historial de problemes';

  @override
  String get puzzleSolved => 'resolt';

  @override
  String get puzzleFailed => 'fallat';

  @override
  String get puzzleStreakDescription => 'Soluciona problemes cada vegada més difícils i aconsegueix una ratxa de victòries. No hi ha temps, pren-t\'ho amb calma. Si fas un moviment erroni, s\'acaba el joc! Però pots ometre un moviment per sessió.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Victòries consecutives: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Omet aquest moviment i preserva la teva ratxa! Només funciona una vegada per sessió.';

  @override
  String get puzzleContinueTheStreak => 'Continua la sèrie';

  @override
  String get puzzleNewStreak => 'Nova sèrie';

  @override
  String get puzzleFromMyGames => 'De les meves partides';

  @override
  String get puzzleLookupOfPlayer => 'Cercar problemes de les partides d\'un jugador';

  @override
  String puzzleFromXGames(String param) {
    return 'Problemes de les partides de $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Cercar problemes';

  @override
  String get puzzleFromMyGamesNone => 'No hi ha problemes teus a la base de dates, però Lichess t\'estima molt igualment.\nJuga partides ràpides i clàssiques per augmentar les possibilitats que se n\'hi afegeixi algun!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 problemes trobats en $param2 partides';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Entrena, analitza, millora';

  @override
  String puzzlePercentSolved(String param) {
    return '$param resolts';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Encara no hi ha res per mostrar aquí. Resol alguns problemes primer!';

  @override
  String get puzzleImprovementAreasDescription => 'Entreneu aquestes temàtiques per a progressar!';

  @override
  String get puzzleStrengthDescription => 'Aquestes són les temàtiques en que ets millor';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Intentat $count vegades',
      one: 'Intentat $count vegada',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punts per sota del teu nivell de problemes',
      one: '$count punts per sota del teu nivell de problemes',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punts per sobre el teu nivell de problemes',
      one: '$count punt per sobre el teu nivell de problemes',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jugats',
      one: '$count jugat',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count a repetir',
      one: '$count a repetir',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Peó avançat';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Un peó a punt de coronar o amenaçant la coronació és la tàctica clau.';

  @override
  String get puzzleThemeAdvantage => 'Avantatge';

  @override
  String get puzzleThemeAdvantageDescription => 'Aprofita l\'oportunitat per agafar avantatge definitiva. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mat d\'Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Un cavall i una torre o una dama es coordinen per atrapar el rei de l\'oponent entre una cantonada del tauler i una peça aliada.';

  @override
  String get puzzleThemeArabianMate => 'Mat àrab';

  @override
  String get puzzleThemeArabianMateDescription => 'Un cavall i una torre es coordinen per atrapar el rei de l\'oponent en una cantonada del tauler.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Atacant f2 o f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Un atac centrat en el peó de f2 o f7, com a l\'obertura de l\'atac Fegatello.';

  @override
  String get puzzleThemeAttraction => 'Atracció';

  @override
  String get puzzleThemeAttractionDescription => 'Un intercanvi o sacrifici encoratjant o forçant la peça d’un oponent a una posició que permet la continuació d’una tàctica.';

  @override
  String get puzzleThemeBackRankMate => 'Mat del passadís';

  @override
  String get puzzleThemeBackRankMateDescription => 'Fes escac i mat al rei a la primera fila, quan està atrapat per les seves pròpies peces.';

  @override
  String get puzzleThemeBishopEndgame => 'Final d’alfils';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Un final d\'alfils i peons.';

  @override
  String get puzzleThemeBodenMate => 'Mat de Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Dos alfils atacant en diagonals que es creuen fan mat a un rei que queda atrapat entre peces amigues.';

  @override
  String get puzzleThemeCastling => 'Enrocant';

  @override
  String get puzzleThemeCastlingDescription => 'Assegura el rei, i prepara la torre per l\'atac.';

  @override
  String get puzzleThemeCapturingDefender => 'Captura el defensor';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Menjar una peça que és vital per defensar una altra, fent que es pugui menjar la peça que ara ja no està defensada.';

  @override
  String get puzzleThemeCrushing => 'Fort avantatge';

  @override
  String get puzzleThemeCrushingDescription => 'Veure l\'error de l\'adversari per a obtenir un gran avantatge (aval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat dels dos alfils';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dos alfils atacant en diagonals adjacents fan mat a un rei que queda obstruït per peces amigues.';

  @override
  String get puzzleThemeDovetailMate => 'Mat de la coça';

  @override
  String get puzzleThemeDovetailMateDescription => 'Una dama fa mat a un rei adjacent que té les dues caselles adjacents ocupades per peces amigues.';

  @override
  String get puzzleThemeEquality => 'Igualtat';

  @override
  String get puzzleThemeEqualityDescription => 'Remunta des d\'una posició perduda i assegura unes taules o una posició balancejada. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Atac pel flanc de rei';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Un atac al rei de l\'oponent, després de que hagi enrocat en curt.';

  @override
  String get puzzleThemeClearance => 'Alliberament';

  @override
  String get puzzleThemeClearanceDescription => 'Una jugada, sovint amb un temps, que allibera una casella, fila o diagonal seguit d\'una idea tàctica.';

  @override
  String get puzzleThemeDefensiveMove => 'Jugada defensiva';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Una jugada precisa o seqüència de jugades necessàries per evitar perdre material o un altre avantatge.';

  @override
  String get puzzleThemeDeflection => 'Desviació';

  @override
  String get puzzleThemeDeflectionDescription => 'Un moviment que distrau una peça de l\'oponent per realitzar una altra tasca, com protegir una casella. A vegades també anomenat \"sobrecàrrega\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Atac a la descoberta';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Moure una peça que prèviament bloquejava un atac a llarg distància d\'una altra peça, com per exemple un cavall que surt de davant d\'una torre.';

  @override
  String get puzzleThemeDoubleCheck => 'Escac doble';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Posar en escac amb dues peces a la vegada, com a resultat d\'un atac descobert on tant la peça que s\'ha mogut com la peça descoberta ataquen el rei de l\'oponent.';

  @override
  String get puzzleThemeEndgame => 'Final';

  @override
  String get puzzleThemeEndgameDescription => 'Una tàctica durant la última fase del joc.';

  @override
  String get puzzleThemeEnPassantDescription => 'Una tàctica que involucra la regla de captura de pas, on un peó pot capturar el peó d\'un oponent que l\'ha passat utilitzant el seu moviment inicial de dues caselles.';

  @override
  String get puzzleThemeExposedKing => 'Rei exposat';

  @override
  String get puzzleThemeExposedKingDescription => 'Una tàctica que involucra un rei amb alguns defensors al seu voltant, sovint acabant amb escac i mat.';

  @override
  String get puzzleThemeFork => 'Doble';

  @override
  String get puzzleThemeForkDescription => 'Un moviment on la peça moguda ataca dos peces de l\'oponent a la vegada.';

  @override
  String get puzzleThemeHangingPiece => 'Peça penjant';

  @override
  String get puzzleThemeHangingPieceDescription => 'Una tàctica que involucra una peça de l\'oponent que no està suficientment defensada i que es pot capturar.';

  @override
  String get puzzleThemeHookMate => 'Mat de la cantonada';

  @override
  String get puzzleThemeHookMateDescription => 'Escac i mat amb una torre, un cavall i un peó junt amb un peó enemic que limita l\'escapada del rei enemic.';

  @override
  String get puzzleThemeInterference => 'Interferència';

  @override
  String get puzzleThemeInterferenceDescription => 'Moure una peça entre dues peces de l\'oponent que deixa una o dues peces enemigues indefenses, com un cavall en una casella defensada entre dues torres.';

  @override
  String get puzzleThemeIntermezzo => 'Intermèdia';

  @override
  String get puzzleThemeIntermezzoDescription => 'En lloc de jugar la jugada esperada, interposar un moviment previ que genera un perill imminent al que l\'oponent ha de respondre. També és conegut com \"Zwischenzug\" o \"Jugada intermèdia\".';

  @override
  String get puzzleThemeKnightEndgame => 'Final de cavalls';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Un final amb només cavalls i peons.';

  @override
  String get puzzleThemeLong => 'Problema llarg';

  @override
  String get puzzleThemeLongDescription => 'Tres jugades per guanyar.';

  @override
  String get puzzleThemeMaster => 'Partides de Mestre';

  @override
  String get puzzleThemeMasterDescription => 'Problemes de partides jugades per jugadors amb títol.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partides Mestre vs Mestre';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Problemes de partides entre dos jugadors amb títol.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Guanya la partida amb estil.';

  @override
  String get puzzleThemeMateIn1 => 'Mat en 1';

  @override
  String get puzzleThemeMateIn1Description => 'Fer escac i mat en una jugada.';

  @override
  String get puzzleThemeMateIn2 => 'Mat en 2';

  @override
  String get puzzleThemeMateIn2Description => 'Fer escac i mat en dues jugades.';

  @override
  String get puzzleThemeMateIn3 => 'Mat en 3';

  @override
  String get puzzleThemeMateIn3Description => 'Fer escac i mat en tres jugades.';

  @override
  String get puzzleThemeMateIn4 => 'Mat en 4';

  @override
  String get puzzleThemeMateIn4Description => 'Fer escac i mat en quatre jugades.';

  @override
  String get puzzleThemeMateIn5 => 'Mat en 5 o més';

  @override
  String get puzzleThemeMateIn5Description => 'Troba una seqüència llarga de mat.';

  @override
  String get puzzleThemeMiddlegame => 'Mig joc';

  @override
  String get puzzleThemeMiddlegameDescription => 'Una maniobra tàctica a la segona fase de la partida.';

  @override
  String get puzzleThemeOneMove => 'Problema d\'una sola jugada';

  @override
  String get puzzleThemeOneMoveDescription => 'Un problema que és només d\'un moviment.';

  @override
  String get puzzleThemeOpening => 'Obertura';

  @override
  String get puzzleThemeOpeningDescription => 'Una tàctica durant la primera fase del joc.';

  @override
  String get puzzleThemePawnEndgame => 'Final de peons';

  @override
  String get puzzleThemePawnEndgameDescription => 'Final amb només peons.';

  @override
  String get puzzleThemePin => 'Clavada';

  @override
  String get puzzleThemePinDescription => 'Una tàctica que involucra clavades, on una peça no es pot moure sense revelar un atac a una altra peça amb més valor.';

  @override
  String get puzzleThemePromotion => 'Promoció';

  @override
  String get puzzleThemePromotionDescription => 'Un peó que promociona o que amenaça a promocionar és clau de la tàctica.';

  @override
  String get puzzleThemeQueenEndgame => 'Final de dames';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Un final només amb reines i peons.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dama i Torre';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Un final amb només dames, torres i peons.';

  @override
  String get puzzleThemeQueensideAttack => 'Atac pel flanc de dama';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Un atac al rei de l\'oponent, després de que hagi enrocat en llarg.';

  @override
  String get puzzleThemeQuietMove => 'Jugada tranquil·la';

  @override
  String get puzzleThemeQuietMoveDescription => 'Una jugada que no és una captura ni un escac, però prepara una amenaça inevitable per una jugada posterior.';

  @override
  String get puzzleThemeRookEndgame => 'Final de torres';

  @override
  String get puzzleThemeRookEndgameDescription => 'Un final amb només torres i peons.';

  @override
  String get puzzleThemeSacrifice => 'Sacrifici';

  @override
  String get puzzleThemeSacrificeDescription => 'Recurs tàctic que implica un sacrifici de material a curt termini per obtenir un avantatge després d\'una seqüència forçada de moviments.';

  @override
  String get puzzleThemeShort => 'Problema curt';

  @override
  String get puzzleThemeShortDescription => 'Guanyar en dues jugades.';

  @override
  String get puzzleThemeSkewer => 'Enfilada';

  @override
  String get puzzleThemeSkewerDescription => 'Maniobra de clavada inversa en què una peça d\'alt valor és atacada i en moure\'s permet capturar o atacar una peça de menys valor al seu darrere.';

  @override
  String get puzzleThemeSmotheredMate => 'Mat ofegat';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Un mat executat per un cavall on el rei que rep el mat no pot moure perquè està envoltat (o ofegat) per les seves pròpies peces.';

  @override
  String get puzzleThemeSuperGM => 'Partides de super GMs';

  @override
  String get puzzleThemeSuperGMDescription => 'Problemes de partides jugades pels millors jugadors del món.';

  @override
  String get puzzleThemeTrappedPiece => 'Peça tancada';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Una peça no pot evitar ser capturada perquè té limitats els seus moviments.';

  @override
  String get puzzleThemeUnderPromotion => 'Promoció menor';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promoció d\'un cavall, un alfil o una torre.';

  @override
  String get puzzleThemeVeryLong => 'Problema molt llarg';

  @override
  String get puzzleThemeVeryLongDescription => 'Quatre o més jugades per guanyar.';

  @override
  String get puzzleThemeXRayAttack => 'Atac de raigs x';

  @override
  String get puzzleThemeXRayAttackDescription => 'Una peça ataca o defensa una casella, a través d\'una peça rival.';

  @override
  String get puzzleThemeZugzwang => 'Atzucac';

  @override
  String get puzzleThemeZugzwangDescription => 'El rival té els moviments limitats i cada jugada empitjora la seva posició.';

  @override
  String get puzzleThemeHealthyMix => 'Una mica de cada';

  @override
  String get puzzleThemeHealthyMixDescription => 'Una mica de tot. No sabràs el que t\'espera, així doncs estigues alerta pel que sigui! Igual que a les partides de veritat.';

  @override
  String get puzzleThemePlayerGames => 'Partides de jugadors';

  @override
  String get puzzleThemePlayerGamesDescription => 'Problemes generats a partir de les teves partides o de les partides d\'altres jugadors.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Aquests problemes són de domini públic i es poden descarregar des de $param.';
  }

  @override
  String get searchSearch => 'Cerca';

  @override
  String get settingsSettings => 'Configuració';

  @override
  String get settingsCloseAccount => 'Donar-se de baixa';

  @override
  String get settingsManagedAccountCannotBeClosed => 'El vostre compte és gestionat i no es pot tancar.';

  @override
  String get settingsClosingIsDefinitive => 'El tancament és definitiu. No es pot tornar enrere. N\'esteu segurs?';

  @override
  String get settingsCantOpenSimilarAccount => 'No està permès crear un nou compte amb el mateix nom, ni tan sols si només canvien les majúscules o minúscules.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'He canviat d\'opinió, no tanqueu el meu compte';

  @override
  String get settingsCloseAccountExplanation => 'Esteu segurs que voleu eliminar el compte? Eliminar-lo és una decisió permanent. No us podreu tornar a connectar MAI MÉS.';

  @override
  String get settingsThisAccountIsClosed => 'S\'ha tancat aquest compte.';

  @override
  String get playWithAFriend => 'Juga amb un amic';

  @override
  String get playWithTheMachine => 'Juga contra la màquina';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Per convidar algú a jugar, envia-li aquest enllaç';

  @override
  String get gameOver => 'Partida finalitzada';

  @override
  String get waitingForOpponent => 'Esperant a l\'oponent';

  @override
  String get orLetYourOpponentScanQrCode => 'O deixeu que el vostre oponent escanegi aquest codi QR';

  @override
  String get waiting => 'Esperant';

  @override
  String get yourTurn => 'El teu torn';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 nivell $param2';
  }

  @override
  String get level => 'Nivell';

  @override
  String get strength => 'Força';

  @override
  String get toggleTheChat => 'Activa/Desactiva el xat';

  @override
  String get chat => 'Xat';

  @override
  String get resign => 'Rendir-se';

  @override
  String get checkmate => 'Escac i mat';

  @override
  String get stalemate => 'Ofegat';

  @override
  String get white => 'Blanques';

  @override
  String get black => 'Negres';

  @override
  String get asWhite => 'amb blanques';

  @override
  String get asBlack => 'amb negres';

  @override
  String get randomColor => 'Bàndol aleatori';

  @override
  String get createAGame => 'Crea una partida';

  @override
  String get whiteIsVictorious => 'Guanyen les blanques';

  @override
  String get blackIsVictorious => 'Guanyen les negres';

  @override
  String get youPlayTheWhitePieces => 'Jugues les blanques';

  @override
  String get youPlayTheBlackPieces => 'Jugues les negres';

  @override
  String get itsYourTurn => 'És el teu torn!';

  @override
  String get cheatDetected => 'Trampes detectades';

  @override
  String get kingInTheCenter => 'Rei al centre';

  @override
  String get threeChecks => 'Tres escacs';

  @override
  String get raceFinished => 'Cursa finalitzada';

  @override
  String get variantEnding => 'Final de variant';

  @override
  String get newOpponent => 'Nou adversari';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'El teu adversari vol jugar una altra partida amb tu';

  @override
  String get joinTheGame => 'Unir-se a la partida';

  @override
  String get whitePlays => 'Juguen les blanques';

  @override
  String get blackPlays => 'Juguen les negres';

  @override
  String get opponentLeftChoices => 'El teu contrincant ha abandonat la partida. Pots reclamar la victòria, fer taules o esperar.';

  @override
  String get forceResignation => 'Reclama la victòria';

  @override
  String get forceDraw => 'Fer taules';

  @override
  String get talkInChat => 'Sisplau, sigues amable al xat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'La primera persona en visitar aquest enllaç jugarà amb tu.';

  @override
  String get whiteResigned => 'Les blanques s\'han rendit';

  @override
  String get blackResigned => 'Les negres s\'han rendit';

  @override
  String get whiteLeftTheGame => 'Les blanques han marxat de la partida';

  @override
  String get blackLeftTheGame => 'Les negres han marxat de la partida';

  @override
  String get whiteDidntMove => 'Les blanques no han mogut';

  @override
  String get blackDidntMove => 'Les negres no han mogut';

  @override
  String get requestAComputerAnalysis => 'Demana una anàlisi computeritzada';

  @override
  String get computerAnalysis => 'Anàlisi computeritzada';

  @override
  String get computerAnalysisAvailable => 'Anàlisi de l\'ordinador disponible';

  @override
  String get computerAnalysisDisabled => 'Anàlisi computeritzada desactivada';

  @override
  String get analysis => 'Tauler d\'anàlisi';

  @override
  String depthX(String param) {
    return 'Profunditat $param';
  }

  @override
  String get usingServerAnalysis => 'Utilitzant l\'anàlisi del servidor';

  @override
  String get loadingEngine => 'Carregant motor...';

  @override
  String get calculatingMoves => 'Calculant moviments...';

  @override
  String get engineFailed => 'Error carregant el motor';

  @override
  String get cloudAnalysis => 'Anàlisi en el núvol';

  @override
  String get goDeeper => 'Aprofundir';

  @override
  String get showThreat => 'Mostra l\'amenaça';

  @override
  String get inLocalBrowser => 'en navegador local';

  @override
  String get toggleLocalEvaluation => 'Activar avaluació local';

  @override
  String get promoteVariation => 'Promoure variant';

  @override
  String get makeMainLine => 'Convertir en línia principal';

  @override
  String get deleteFromHere => 'Esborrar des d\'aquí';

  @override
  String get collapseVariations => 'Amagar variacions';

  @override
  String get expandVariations => 'Expandir variacions';

  @override
  String get forceVariation => 'Forçar variant';

  @override
  String get copyVariationPgn => 'Copia el PGN de la variació';

  @override
  String get move => 'Moviment';

  @override
  String get variantLoss => 'Variant perdedora';

  @override
  String get variantWin => 'Variant guanyadora';

  @override
  String get insufficientMaterial => 'Material insuficient';

  @override
  String get pawnMove => 'Moviment de peó';

  @override
  String get capture => 'Captura';

  @override
  String get close => 'Tancar';

  @override
  String get winning => 'Guanyant';

  @override
  String get losing => 'Perdent';

  @override
  String get drawn => 'Taules';

  @override
  String get unknown => 'Desconegut';

  @override
  String get database => 'Base de dades';

  @override
  String get whiteDrawBlack => 'Blanques / Taules / Negres';

  @override
  String averageRatingX(String param) {
    return 'Puntuació mitjana: $param';
  }

  @override
  String get recentGames => 'Partides recents';

  @override
  String get topGames => 'Millors partides';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Dos milions de partides OTB de jugadors amb ELO FIDE +$param1 des de $param2 fins a $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" amb arrodoniment, basat en el nombre de moviments fins la propera captura o moviment de peó';

  @override
  String get noGameFound => 'No s\'ha trobat cap partida';

  @override
  String get maxDepthReached => 'Màxima profunditat assolida!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Vols incloure més partides des del menú de preferències?';

  @override
  String get openings => 'Obertures';

  @override
  String get openingExplorer => 'Explorador d\'obertures';

  @override
  String get openingEndgameExplorer => 'Explorador d\'obertures i finals';

  @override
  String xOpeningExplorer(String param) {
    return 'Explorador d\'obertures $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Juga el primer moviment de l\'explorador d\'obertures/finals';

  @override
  String get winPreventedBy50MoveRule => 'Victòria no permesa a causa de la regla dels 50 moviments';

  @override
  String get lossSavedBy50MoveRule => 'Derrota evitada per la regla dels 50 moviments';

  @override
  String get winOr50MovesByPriorMistake => 'Victòria o taules per 50 moviments a causa d\'un error anterior';

  @override
  String get lossOr50MovesByPriorMistake => 'Derrota o taules per 50 moviments a causa d\'un error anterior';

  @override
  String get unknownDueToRounding => 'La victòria o derrota només és garantida si la línia recomanada ha sigut seguida des de l\'última captura o moviment de peó, a causa de possibles arrodoniments de valors DTZ.';

  @override
  String get allSet => 'Tot a punt!';

  @override
  String get importPgn => 'Importar PGN';

  @override
  String get delete => 'Suprimir';

  @override
  String get deleteThisImportedGame => 'Vols esborrar aquesta partida importada?';

  @override
  String get replayMode => 'Mode de reproducció';

  @override
  String get realtimeReplay => 'En temps real';

  @override
  String get byCPL => 'Per CPL';

  @override
  String get openStudy => 'Obrir estudi';

  @override
  String get enable => 'Habilitar';

  @override
  String get bestMoveArrow => 'Fletxa de la millor jugada';

  @override
  String get showVariationArrows => 'Mostrar fletxes de les variants';

  @override
  String get evaluationGauge => 'Indicador d\'avaluació';

  @override
  String get multipleLines => 'Múltiples línies';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Memòria';

  @override
  String get infiniteAnalysis => 'Anàlisi il·limitada';

  @override
  String get removesTheDepthLimit => 'Treu el límit de profunditat i escalfa el teu ordinador';

  @override
  String get engineManager => 'Gestió del mòdul';

  @override
  String get blunder => 'Errada greu';

  @override
  String get mistake => 'Errada';

  @override
  String get inaccuracy => 'Imprecisió';

  @override
  String get moveTimes => 'Temps dels moviments';

  @override
  String get flipBoard => 'Girar el tauler';

  @override
  String get threefoldRepetition => 'Triple repetició';

  @override
  String get claimADraw => 'Reclamar taules';

  @override
  String get offerDraw => 'Oferir taules';

  @override
  String get draw => 'Taules';

  @override
  String get drawByMutualAgreement => 'Taules per acord';

  @override
  String get fiftyMovesWithoutProgress => 'Cinquanta moviments sense captures ni moviments de peó';

  @override
  String get currentGames => 'Partides en joc';

  @override
  String get viewInFullSize => 'Veure a mida completa';

  @override
  String get logOut => 'Tancar la sessió';

  @override
  String get signIn => 'Iniciar la sessió';

  @override
  String get rememberMe => 'Mantingues-me connectat';

  @override
  String get youNeedAnAccountToDoThat => 'Necessites un compte per a fer això';

  @override
  String get signUp => 'Registrar-se';

  @override
  String get computersAreNotAllowedToPlay => 'No els està permès jugar ni als ordinadors ni als jugadors assistits per ordinador. Si us plau, no utilitzis l\'ajuda de programes informàtics d\'escacs, de bases de dades o d\'altres jugadors mentre juguis. També tingues en compte que la creació de més d\'un compte és severament descoratjada i que tal activitat pot significar que el teu compte sigui suspès.';

  @override
  String get games => 'Partides';

  @override
  String get forum => 'Fòrum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 ha escrit al fòrum $param2';
  }

  @override
  String get latestForumPosts => 'Últimes publicacions al fòrum';

  @override
  String get players => 'Jugadors';

  @override
  String get friends => 'Amics';

  @override
  String get discussions => 'Missatges';

  @override
  String get today => 'Avui';

  @override
  String get yesterday => 'Ahir';

  @override
  String get minutesPerSide => 'Minuts per jugador';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Variants';

  @override
  String get timeControl => 'Control de temps';

  @override
  String get realTime => 'En temps real';

  @override
  String get correspondence => 'Correspondència';

  @override
  String get daysPerTurn => 'Dies per torn';

  @override
  String get oneDay => 'Un dia';

  @override
  String get time => 'Temps';

  @override
  String get rating => 'Puntuació';

  @override
  String get ratingStats => 'Estadístiques de classificació';

  @override
  String get username => 'Nom d\'usuari';

  @override
  String get usernameOrEmail => 'Nom d\'usuari o correu electrònic';

  @override
  String get changeUsername => 'Canviar nom d\'usuari';

  @override
  String get changeUsernameNotSame => 'Només es pot canviar entre majúscules i minúscules. Per exemple, de \"perecullera\" a \"PereCullera\".';

  @override
  String get changeUsernameDescription => 'Canvia el teu nom d\'usuari. Això es pot fer una única vegada i només només se\'t permet canviar lletres entre majúscules i minúscules.';

  @override
  String get signupUsernameHint => 'Assegureu-vos d\'escollir un nom d\'usuari amigable. No el podreu canviar més tard i qualsevol compte amb nom d\'usuaris inapropiats es tancarà!';

  @override
  String get signupEmailHint => 'Només s\'utilitzarà per restablir la contrasenya.';

  @override
  String get password => 'Contrasenya';

  @override
  String get changePassword => 'Canvia la contrasenya';

  @override
  String get changeEmail => 'Canvia el correu electrònic';

  @override
  String get email => 'Correu electrònic';

  @override
  String get passwordReset => 'Restablir la contrasenya';

  @override
  String get forgotPassword => 'Has oblidat la contrasenya?';

  @override
  String get error_weakPassword => 'La contrasenya és extremadament comú i massa fàcil d\'endevinar.';

  @override
  String get error_namePassword => 'Si us plau, no facis servir el teu nom d\'usuari com a contrasenya.';

  @override
  String get blankedPassword => 'Has fet servir la mateixa contrasenya en altres llocs web i aquest lloc ha estat compromès. Per assegurar la seguretat del vostre compte de Lichess heu d\'establir una nova contrasenya. Gràcies per la teva comprensió.';

  @override
  String get youAreLeavingLichess => 'Estàs sortint de Lichess';

  @override
  String get neverTypeYourPassword => 'Mai teclegis la contrasenya de Lichess en un altre lloc web!';

  @override
  String proceedToX(String param) {
    return 'Continuar a $param';
  }

  @override
  String get passwordSuggestion => 'No facis servir una contrasenya suggerida per algú altre. La farà servir per robar el vostre compte.';

  @override
  String get emailSuggestion => 'No facis server un correu electrònic suggerit per algú altre. La farà servir per robar el vostre compte.';

  @override
  String get emailConfirmHelp => 'Ajuda amb l\'email de confirmació';

  @override
  String get emailConfirmNotReceived => 'No has rebut el teu email de confirmació després de registrar-te?';

  @override
  String get whatSignupUsername => 'Quin nom d\'usuari vas utilitzar per registrar-te?';

  @override
  String usernameNotFound(String param) {
    return 'No hem pogut trobat cap usuari amb aquest nom: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Pots fer servir aquest nom d\'usuari per crear un nou compte';

  @override
  String emailSent(String param) {
    return 'Hem enviat un correu electrònic a $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Pot trigar una estona a arribar.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Espera 5 minuts i refresca la bústia d\'entrada del teu correu.';

  @override
  String get checkSpamFolder => 'Comprova també la carpeta de correu brossa, pot acabar allà. Si hi és, marca\'l com no brossa.';

  @override
  String get emailForSignupHelp => 'Si tot això falla, envia\'ns un correu a aquesta adreça:';

  @override
  String copyTextToEmail(String param) {
    return 'Copia i enganxa el text a continuació i envia\'l a $param';
  }

  @override
  String get waitForSignupHelp => 'Et contestarem el més breument posible per ajudar-te a completar el registre.';

  @override
  String accountConfirmed(String param) {
    return 'L\'usuari $param està confirmat correctament.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Pots entrar ara com a $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'No necestites un correu de confirmació.';

  @override
  String accountClosed(String param) {
    return 'El compte $param està tancat.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'El compte $param es va registrar sense correu electrònic.';
  }

  @override
  String get rank => 'Classificació';

  @override
  String rankX(String param) {
    return 'Posició: $param';
  }

  @override
  String get gamesPlayed => 'Partides jugades';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get whiteTimeOut => 'Les blanques han exhaurit el seu temps';

  @override
  String get blackTimeOut => 'Les negres perden per temps';

  @override
  String get drawOfferSent => 'S\'ha enviat l\'oferta de taules';

  @override
  String get drawOfferAccepted => 'Oferta de taules acceptada';

  @override
  String get drawOfferCanceled => 'Oferta de taules cancel·lada';

  @override
  String get whiteOffersDraw => 'Blanques ofereixen taules';

  @override
  String get blackOffersDraw => 'Les negres ofereixen taules';

  @override
  String get whiteDeclinesDraw => 'Blanques rebutgen taules';

  @override
  String get blackDeclinesDraw => 'Negres rebutgen taules';

  @override
  String get yourOpponentOffersADraw => 'El teu oponent t\'ofereix taules';

  @override
  String get accept => 'Acceptar';

  @override
  String get decline => 'Rebutjar';

  @override
  String get playingRightNow => 'En joc';

  @override
  String get eventInProgress => 'Jugant-se ara mateix';

  @override
  String get finished => 'Acabat';

  @override
  String get abortGame => 'Avortar la partida';

  @override
  String get gameAborted => 'Partida avortada';

  @override
  String get standard => 'Estàndard';

  @override
  String get customPosition => 'Posició personalitzada';

  @override
  String get unlimited => 'Il·limitat';

  @override
  String get mode => 'Mode';

  @override
  String get casual => 'Amistosa';

  @override
  String get rated => 'Puntuat';

  @override
  String get casualTournament => 'Amistós';

  @override
  String get ratedTournament => 'Puntuat';

  @override
  String get thisGameIsRated => 'Aquesta partida és puntuada';

  @override
  String get rematch => 'Oferir una revenja';

  @override
  String get rematchOfferSent => 'La petició de revenja s\'ha enviat';

  @override
  String get rematchOfferAccepted => 'Oferta de revenja acceptada';

  @override
  String get rematchOfferCanceled => 'Oferta de revenja cancel·lada';

  @override
  String get rematchOfferDeclined => 'Oferta de revenja rebutjada';

  @override
  String get cancelRematchOffer => 'Anul·lar la petició de revenja';

  @override
  String get viewRematch => 'Mirar la partida de revenja';

  @override
  String get confirmMove => 'Confirmar la jugada';

  @override
  String get play => 'Jugar';

  @override
  String get inbox => 'Bústia d\'entrada';

  @override
  String get chatRoom => 'Sala de xat';

  @override
  String get loginToChat => 'Inicia la sessió per entrar al xat';

  @override
  String get youHaveBeenTimedOut => 'Has sigut mutejat.';

  @override
  String get spectatorRoom => 'Sala d\'espectadors';

  @override
  String get composeMessage => 'Escriure un missatge';

  @override
  String get subject => 'Assumpte';

  @override
  String get send => 'Enviar';

  @override
  String get incrementInSeconds => 'Increment en segons';

  @override
  String get freeOnlineChess => 'Escacs en línia gratis';

  @override
  String get exportGames => 'Exporta les partides';

  @override
  String get ratingRange => 'Rang de puntuació';

  @override
  String get thisAccountViolatedTos => 'Aquest compte ha violat els Termes de Servei de Lichess';

  @override
  String get openingExplorerAndTablebase => 'Explorador d\'obertures & taula de finals';

  @override
  String get takeback => 'Desfés la jugada';

  @override
  String get proposeATakeback => 'Proposa desfer la jugada';

  @override
  String get takebackPropositionSent => 'La proposta de desfer la jugada s\'ha enviat';

  @override
  String get takebackPropositionDeclined => 'La proposta de desfer la jugada s\'ha rebutjat';

  @override
  String get takebackPropositionAccepted => 'La proposta de desfer la jugada s\'ha acceptat';

  @override
  String get takebackPropositionCanceled => 'La proposta de desfer la jugada s\'ha cancel·lat';

  @override
  String get yourOpponentProposesATakeback => 'El teu adversari proposa desfer la jugada';

  @override
  String get bookmarkThisGame => 'Marca aquesta partida com a preferida';

  @override
  String get tournament => 'Torneig';

  @override
  String get tournaments => 'Tornejos';

  @override
  String get tournamentPoints => 'Punts de tornejos';

  @override
  String get viewTournament => 'Mirar el torneig';

  @override
  String get backToTournament => 'Torna al torneig';

  @override
  String get noDrawBeforeSwissLimit => 'No es pot fer taules abans dels 30 moviments en un torneig suís.';

  @override
  String get thematic => 'Temàtics';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'La teva puntuació de $param és provisional';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'La teva puntuació de $param1 ($param2) és massa alta';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'La teva puntuació setmanal de $param1 ($param2) és massa alta';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'La teva puntuació de $param1 ($param2) és massa baixa';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Puntuació ≥ $param1 en $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Puntuació ≤ $param1 en $param2 durant la darrera setmana';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Has de pertànyer a l\'equip $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'No pertanys a l\'equip $param';
  }

  @override
  String get backToGame => 'Tornar a la partida';

  @override
  String get siteDescription => 'Servidor d\'escacs gratuït online. Juga als escacs amb una interfície neta i elegant. No cal registrar-s\'hi, sense anuncis, no calen extensions. Juga a escacs amb l\'ordinador, amics o oponents a l\'atzar.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 s\'ha unit a l\'equip $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 ha creat l\'equip $param2';
  }

  @override
  String get startedStreaming => 'ha començat a retransmetre';

  @override
  String xStartedStreaming(String param) {
    return '$param ha començat a retransmetre';
  }

  @override
  String get averageElo => 'Puntuació mitjana';

  @override
  String get location => 'Ubicació';

  @override
  String get filterGames => 'Filtra les partides';

  @override
  String get reset => 'Restablir';

  @override
  String get apply => 'Enviar';

  @override
  String get save => 'Desar';

  @override
  String get leaderboard => 'Tauló de líders';

  @override
  String get screenshotCurrentPosition => 'Fes una captura de pantalla de la posició actual';

  @override
  String get gameAsGIF => 'Partida com a GIF';

  @override
  String get pasteTheFenStringHere => 'Enganxa el text FEN aquí';

  @override
  String get pasteThePgnStringHere => 'Enganxa el text PGN aquí';

  @override
  String get orUploadPgnFile => 'O penja un arxiu PGN';

  @override
  String get fromPosition => 'Des d\'una posició';

  @override
  String get continueFromHere => 'Continua des d\'aquí';

  @override
  String get toStudy => 'Estudiar';

  @override
  String get importGame => 'Importa una partida';

  @override
  String get importGameExplanation => 'Enganxa el PGN d\'una partida per obtenir una repetició navegable, anàlisi computeritzada, xat de joc i enllaç per compartir.';

  @override
  String get importGameCaveat => 'S\'esborraran les variants. Per mantenir-les, importeu el PGN mitjançant un estudi.';

  @override
  String get importGameDataPrivacyWarning => 'Aquest PGN és accessible públicament. Per a importar un joc de manera privada, utilitza un estudi.';

  @override
  String get thisIsAChessCaptcha => 'Això és un CAPTCHA d\'escacs.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Clica al tauler per fer el teu moviment i així demostrar que ets humà.';

  @override
  String get captcha_fail => 'Si us plau resol el captcha d\'escacs.';

  @override
  String get notACheckmate => 'No és escac i mat';

  @override
  String get whiteCheckmatesInOneMove => 'Les blanques fan escac i mat en una jugada';

  @override
  String get blackCheckmatesInOneMove => 'Les negres fan escac i mat en una jugada';

  @override
  String get retry => 'Reintentar';

  @override
  String get reconnecting => 'S\'està reconnectant';

  @override
  String get noNetwork => 'Desconnectat';

  @override
  String get favoriteOpponents => 'Adversaris favorits';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Seguint';

  @override
  String get unfollow => 'Deixa de seguir';

  @override
  String followX(String param) {
    return 'Seguir a $param';
  }

  @override
  String unfollowX(String param) {
    return 'Deixa de seguir a $param';
  }

  @override
  String get block => 'Bloqueja';

  @override
  String get blocked => 'Bloquejat';

  @override
  String get unblock => 'Desbloqueja';

  @override
  String get followsYou => 'T\'està seguint';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 ha començat a seguir $param2';
  }

  @override
  String get more => 'Més';

  @override
  String get memberSince => 'Membre des del';

  @override
  String lastSeenActive(String param) {
    return 'Darrer accés $param';
  }

  @override
  String get player => 'Jugador';

  @override
  String get list => 'Llista';

  @override
  String get graph => 'Gràfica';

  @override
  String get required => 'Necessari.';

  @override
  String get openTournaments => 'Tornejos oberts';

  @override
  String get duration => 'Durada';

  @override
  String get winner => 'Guanyador';

  @override
  String get standing => 'Resultats';

  @override
  String get createANewTournament => 'Crea un nou torneig';

  @override
  String get tournamentCalendar => 'Calendari de tornejos';

  @override
  String get conditionOfEntry => 'Requisit d\'entrada:';

  @override
  String get advancedSettings => 'Configuració avançada';

  @override
  String get safeTournamentName => 'Trieu un nom segur per al torneig.';

  @override
  String get inappropriateNameWarning => 'Qualsevol comportament mínimament inadequat podria implicar el tancament del teu compte.';

  @override
  String get emptyTournamentName => 'Deixar en blanc per nombrar el torneig amb un Gran Mestre a l\'atzar.';

  @override
  String get makePrivateTournament => 'Fes el torneig privat, i restringeix l\'accés amb clau d\'entrada';

  @override
  String get join => 'Inscriu-t\'hi';

  @override
  String get withdraw => 'Abandona';

  @override
  String get points => 'Punts';

  @override
  String get wins => 'Victòries';

  @override
  String get losses => 'Derrotes';

  @override
  String get createdBy => 'Creat per';

  @override
  String get tournamentIsStarting => 'El torneig està començant';

  @override
  String get tournamentPairingsAreNowClosed => 'Els emparellaments del torneig ja estan tancats.';

  @override
  String standByX(String param) {
    return 'Estigues a punt $param, emparellant jugadors, prepara\'t!';
  }

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Reprèn';

  @override
  String get youArePlaying => 'Estàs jugant!';

  @override
  String get winRate => 'Percentatge de victòries';

  @override
  String get berserkRate => 'Taxa de berserk';

  @override
  String get performance => 'Rendiment';

  @override
  String get tournamentComplete => 'Torneig completat';

  @override
  String get movesPlayed => 'Moviments jugats';

  @override
  String get whiteWins => 'Victòries blanques';

  @override
  String get blackWins => 'Victòries negres';

  @override
  String get drawRate => 'Percentatge de taules';

  @override
  String get draws => 'Entaulades';

  @override
  String nextXTournament(String param) {
    return 'Proper torneig de $param:';
  }

  @override
  String get averageOpponent => 'Oponent mitjà';

  @override
  String get boardEditor => 'Editor del tauler';

  @override
  String get setTheBoard => 'Disposa el tauler';

  @override
  String get popularOpenings => 'Obertures populars';

  @override
  String get endgamePositions => 'Posicions de finals';

  @override
  String chess960StartPosition(String param) {
    return 'Posició inicial d\'Escacs960 Fischer: $param';
  }

  @override
  String get startPosition => 'Posició inicial';

  @override
  String get clearBoard => 'Netejar el tauler';

  @override
  String get loadPosition => 'Carregar la posició';

  @override
  String get isPrivate => 'Privat';

  @override
  String reportXToModerators(String param) {
    return 'Denuncia $param als moderadors';
  }

  @override
  String profileCompletion(String param) {
    return 'Perfil completat: $param';
  }

  @override
  String xRating(String param) {
    return 'Puntuació $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Si no en tens, deixa-ho buit';

  @override
  String get profile => 'Perfil';

  @override
  String get editProfile => 'Edita el perfil';

  @override
  String get realName => 'Nom real';

  @override
  String get setFlair => 'Defineix el teu estil';

  @override
  String get flair => 'Icona';

  @override
  String get youCanHideFlair => 'Existeix una configuració per amagar els estils dels jugadors a tot el lloc web.';

  @override
  String get biography => 'Biografia';

  @override
  String get countryRegion => 'País o regió';

  @override
  String get thankYou => 'Gràcies!';

  @override
  String get socialMediaLinks => 'Enllaços a xarxes socials';

  @override
  String get oneUrlPerLine => 'Una URL per línia.';

  @override
  String get inlineNotation => 'Notació lineal';

  @override
  String get makeAStudy => 'Per salvaguardar i compartir, considera fer un estudi.';

  @override
  String get clearSavedMoves => 'Netejar moviments';

  @override
  String get previouslyOnLichessTV => 'Prèviament a Lichess TV';

  @override
  String get onlinePlayers => 'Jugadors connectats';

  @override
  String get activePlayers => 'Jugadors actius';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Compte, la partida és puntuada però no hi ha límit de temps!';

  @override
  String get success => 'Èxit';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Anar automàticament a la següent partida després de cada moviment';

  @override
  String get autoSwitch => 'Canvi automàtic';

  @override
  String get puzzles => 'Problemes';

  @override
  String get onlineBots => 'Bots en línia';

  @override
  String get name => 'Nom';

  @override
  String get description => 'Descripció';

  @override
  String get descPrivate => 'Descripció privada';

  @override
  String get descPrivateHelp => 'Text que només veuran els membres de l\'equip. Si conté text, substituïrà la descripció pública pels membres de l\'equip.';

  @override
  String get no => 'No';

  @override
  String get yes => 'Sí';

  @override
  String get help => 'Ajuda:';

  @override
  String get createANewTopic => 'Crea un nou tema';

  @override
  String get topics => 'Temes';

  @override
  String get posts => 'Entrades';

  @override
  String get lastPost => 'Última publicació';

  @override
  String get views => 'Visites';

  @override
  String get replies => 'Respostes';

  @override
  String get replyToThisTopic => 'Respon aquest tema';

  @override
  String get reply => 'Resposta';

  @override
  String get message => 'Missatge';

  @override
  String get createTheTopic => 'Crea un tema';

  @override
  String get reportAUser => 'Informa d\'un usuari';

  @override
  String get user => 'Usuari';

  @override
  String get reason => 'Raó';

  @override
  String get whatIsIheMatter => 'Quin és el problema?';

  @override
  String get cheat => 'Trampós';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Altres';

  @override
  String get reportDescriptionHelp => 'Enganxa l\'enllaç de la partida (o partides) i explica el comportament negatiu d\'aquest usuari. No et limitis a dir que \"fa trampes\", i explica com has arribat a aquesta conclusió. El teu informe serà processat més ràpidament si l\'escrius en anglès.';

  @override
  String get error_provideOneCheatedGameLink => 'Si us plau, proporcioneu com a mínim un enllaç a un joc on s\'han fet trampes.';

  @override
  String by(String param) {
    return 'per $param';
  }

  @override
  String importedByX(String param) {
    return 'Importat per $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Aquest tema està tancat.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notes';

  @override
  String get typePrivateNotesHere => 'Escriu notes privades aquí';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Escriu una nota privada sobre aquest usuari';

  @override
  String get noNoteYet => 'Cap nota encara';

  @override
  String get invalidUsernameOrPassword => 'Nom d\'usuari o contrasenya incorrectes';

  @override
  String get incorrectPassword => 'Contrasenya incorrecta';

  @override
  String get invalidAuthenticationCode => 'Codi d\'autenticació invàlid';

  @override
  String get emailMeALink => 'Envieu-me un enllaç per correu electrònic';

  @override
  String get currentPassword => 'Contrasenya actual';

  @override
  String get newPassword => 'Nova contrasenya';

  @override
  String get newPasswordAgain => 'Nova contrasenya (de nou)';

  @override
  String get newPasswordsDontMatch => 'La nova contrasenya no coincideix';

  @override
  String get newPasswordStrength => 'Seguretat de la contrasenya';

  @override
  String get clockInitialTime => 'Temps inicial al rellotge';

  @override
  String get clockIncrement => 'Increment de temps';

  @override
  String get privacy => 'Privacitat';

  @override
  String get privacyPolicy => 'Política de privacitat';

  @override
  String get letOtherPlayersFollowYou => 'Permet que altres jugadors et segueixin';

  @override
  String get letOtherPlayersChallengeYou => 'Permet que altres jugadors et reptin';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Permet que altres jugadors et convidin a un estudi';

  @override
  String get sound => 'So';

  @override
  String get none => 'Cap';

  @override
  String get fast => 'Ràpid';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Lent';

  @override
  String get insideTheBoard => 'Dins del tauler';

  @override
  String get outsideTheBoard => 'Fora del tauler';

  @override
  String get allSquaresOfTheBoard => 'Totes les caselles del tauler';

  @override
  String get onSlowGames => 'En els jocs lents';

  @override
  String get always => 'Sempre';

  @override
  String get never => 'Mai';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 competeix a $param2';
  }

  @override
  String get victory => 'Victòria';

  @override
  String get defeat => 'Derrota';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 contra $param2 en $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 contra $param2 en $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 contra $param2 en $param3';
  }

  @override
  String get timeline => 'Cronologia';

  @override
  String get starting => 'Comença a les ';

  @override
  String get allInformationIsPublicAndOptional => 'Tota la informació és pública i opcional.';

  @override
  String get biographyDescription => 'Parla sobre tu, què t\'agrada dels escacs, les teves obertures preferides, jugadors, ...';

  @override
  String get listBlockedPlayers => 'Llista de jugadors que has bloquejat';

  @override
  String get human => 'Humà';

  @override
  String get computer => 'Ordinador';

  @override
  String get side => 'Color';

  @override
  String get clock => 'Rellotge';

  @override
  String get opponent => 'Rival';

  @override
  String get learnMenu => 'Aprèn';

  @override
  String get studyMenu => 'Estudi';

  @override
  String get practice => 'Practica';

  @override
  String get community => 'Comunitat';

  @override
  String get tools => 'Eines';

  @override
  String get increment => 'Increment';

  @override
  String get error_unknown => 'Valor invàlid';

  @override
  String get error_required => 'Aquest camp és obligatori';

  @override
  String get error_email => 'Aquesta adreça de correu electrònic és invàlida';

  @override
  String get error_email_acceptable => 'Aquesta adreça de correu electrònic no és acceptable. Si us plau, comprova-ho i intenta-ho de nou.';

  @override
  String get error_email_unique => 'Adreça de correu electrònic invàlida o ja registrada';

  @override
  String get error_email_different => 'Aquesta ja és la teva adreça de correu electrònic';

  @override
  String error_minLength(String param) {
    return 'Com a mínim ha de tenir $param caràcters';
  }

  @override
  String error_maxLength(String param) {
    return 'Com a màxim ha de tenir $param caràcters';
  }

  @override
  String error_min(String param) {
    return 'Ha de ser major o igual que $param';
  }

  @override
  String error_max(String param) {
    return 'Ha de ser menor o igual que $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Si el ràting és ± $param';
  }

  @override
  String get ifRegistered => 'Només usuaris registrats';

  @override
  String get onlyExistingConversations => 'Només converses existents';

  @override
  String get onlyFriends => 'Només amics';

  @override
  String get menu => 'Menú';

  @override
  String get castling => 'Enroc';

  @override
  String get whiteCastlingKingside => 'Blanques O-O';

  @override
  String get blackCastlingKingside => 'Negres O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Temps passat jugant: $param';
  }

  @override
  String get watchGames => 'Visualitza\'n les partides';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Temps pasat a la TV: $param';
  }

  @override
  String get watch => 'Visualitza';

  @override
  String get videoLibrary => 'Col·lecció de vídeos';

  @override
  String get streamersMenu => 'Comunicadors';

  @override
  String get mobileApp => 'Aplicació mòbil';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'En quant a';

  @override
  String aboutX(String param) {
    return 'En quant a $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 es un servidor d\'escacs totalment gratuit creat amb codi obert, lliure ($param2), sense publicitat.';
  }

  @override
  String get really => 'realment';

  @override
  String get contribute => 'Contribuïu-hi';

  @override
  String get termsOfService => 'Condicions del servei';

  @override
  String get sourceCode => 'Codi font';

  @override
  String get simultaneousExhibitions => 'Exhibicions de simultànies';

  @override
  String get host => 'Amfitrió';

  @override
  String hostColorX(String param) {
    return 'Color d\'amfitrió: $param';
  }

  @override
  String get yourPendingSimuls => 'Les teves simultànies pendents';

  @override
  String get createdSimuls => 'Últimes simultànies creades';

  @override
  String get hostANewSimul => 'Organitza una simultània';

  @override
  String get signUpToHostOrJoinASimul => 'Registra\'t per a organitzar o unir-se a una simultània';

  @override
  String get noSimulFound => 'Simultània no trobada';

  @override
  String get noSimulExplanation => 'Aquesta simultània no existeix.';

  @override
  String get returnToSimulHomepage => 'Torna a la pàgina principal de simultànies';

  @override
  String get aboutSimul => 'Les simultànies suposen enfrontar-se a més d\'un jugador alhora.';

  @override
  String get aboutSimulImage => 'Contra 50 contrincants, Fischer va obtenir 47 victòries, 2 taules i 1 derrota.';

  @override
  String get aboutSimulRealLife => 'La idea està presa d\'esdeveniments presencials. En aquests esdeveniments, l\'amfitrió s\'ha d\'anar movent de taula en taula per fer cada moviment.';

  @override
  String get aboutSimulRules => 'Quan comencen les simultànies, cada jugador comença la partida amb l\'amfitrió, que  té les blanques. L\'exibició acaba quan s\'han completat totes les partides.';

  @override
  String get aboutSimulSettings => 'Les simultànies són sempre amistoses. Les opcions de revenja, desfer la jugada i donar més temps estan desactivades.';

  @override
  String get create => 'Crea';

  @override
  String get whenCreateSimul => 'Quan crees una exhibició de simultànies, has de jugar amb diversos jugadors alhora.';

  @override
  String get simulVariantsHint => 'Si selecciones diverses variants, cada jugador podrà escollir quina es jugarà.';

  @override
  String get simulClockHint => 'Sistema de Rellotge Fischer. Com més oponents tinguis, més temps et pot caldre.';

  @override
  String get simulAddExtraTime => 'Pots afegir temps extra al rellotge per ajudar-te amb les simultànies.';

  @override
  String get simulHostExtraTime => 'Temps extra per a l\'amfitrió';

  @override
  String get simulAddExtraTimePerPlayer => 'Afegir temps inicial al vostre rellotge per cada jugador que entri a la simultània.';

  @override
  String get simulHostExtraTimePerPlayer => 'Temps extra de l\'amfitrió per jugador';

  @override
  String get lichessTournaments => 'Tornejos de Lichess';

  @override
  String get tournamentFAQ => 'Torneig Arena: Preguntes Més Freqüents';

  @override
  String get timeBeforeTournamentStarts => 'Temps per a què comenci el torneig';

  @override
  String get averageCentipawnLoss => 'Pèrdua mitjana en centipeons';

  @override
  String get accuracy => 'Precisió';

  @override
  String get keyboardShortcuts => 'Dreceres del teclat';

  @override
  String get keyMoveBackwardOrForward => 'moure enrere/davant';

  @override
  String get keyGoToStartOrEnd => 'anar a l\'inici/anar al final';

  @override
  String get keyCycleSelectedVariation => 'Canvia la variació seleccionada';

  @override
  String get keyShowOrHideComments => 'mostrar/ocultar comentaris';

  @override
  String get keyEnterOrExitVariation => 'entrar/sortir variació';

  @override
  String get keyRequestComputerAnalysis => 'Demana una anàlisi computeritzada, aprèn dels teus errors';

  @override
  String get keyNextLearnFromYourMistakes => 'Següent (apren dels teus errors)';

  @override
  String get keyNextBlunder => 'Següent errada';

  @override
  String get keyNextMistake => 'Següent errada greu';

  @override
  String get keyNextInaccuracy => 'Següent imprecisió';

  @override
  String get keyPreviousBranch => 'Branca anterior';

  @override
  String get keyNextBranch => 'Branca següent';

  @override
  String get toggleVariationArrows => 'Mostra/amaga les fletxes de les variants';

  @override
  String get cyclePreviousOrNextVariation => 'Canvia la variació següent/anterior';

  @override
  String get toggleGlyphAnnotations => 'Mostra/amaga les anotacions glif';

  @override
  String get togglePositionAnnotations => 'Mostra/amaga les anotacions de la posició';

  @override
  String get variationArrowsInfo => 'Les fletxes de variants et permeten navegar sense utilitzar la llista de moviments.';

  @override
  String get playSelectedMove => 'juga el moviment seleccionat';

  @override
  String get newTournament => 'Nou torneig';

  @override
  String get tournamentHomeTitle => 'Torneig d\'escacs amb diversos controls de temps i variants';

  @override
  String get tournamentHomeDescription => 'Juga tornejos d\'escacs ràpids! Uneix-te a un torneig programat o crea\'n un de propi. Bullet, Blitz, Classic, Chess960, King of the Hill, Threecheck i moltes més opcions perquè no s\'acabi la diversió dels escacs.';

  @override
  String get tournamentNotFound => 'No s\'ha trobat el torneig';

  @override
  String get tournamentDoesNotExist => 'Aquest torneig no existeix.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Pot ser que s\'hagi cancel·lat, si tots els jugadors l\'han abandonat abans que comencés.';

  @override
  String get returnToTournamentsHomepage => 'Torna a la pàgina principal de tornejos';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Distribució mensual de les puntuacions en $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'La teva puntuació en $param1 és de $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Ets millor que un $param1 dels jugadors de $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 és millor que el $param2 de $param3 jugadors.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Millor que un $param1 dels jugadors de $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'No tens establerta una puntuació de $param.';
  }

  @override
  String get yourRating => 'La vostra valoració';

  @override
  String get cumulative => 'Acumulat';

  @override
  String get glicko2Rating => 'Valoració Glicko-2';

  @override
  String get checkYourEmail => 'Comprova el teu email';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'T\'hem enviat un email. Clica l\'enllaç de l\'email per a activar el teu compte';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Si no veus l\'email, comprova altres llocs on pugui ser, com el correu brossa, spam, o altres carpetes';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Hem enviat un correu electrònic a $param. Clica a l\'enllaç per renovar la teva contrasenya.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'En registrar-te,dones la teva conformitat a estar legalment obligats per el nostre $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Llegeix sobre la nostre $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Retard de la xarxa entre tu i lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Temps per processar un moviment al servidor lichess';

  @override
  String get downloadAnnotated => 'Descàrrega anotada';

  @override
  String get downloadRaw => 'Descàrrega prima';

  @override
  String get downloadImported => 'Descàrrega importada';

  @override
  String get crosstable => 'Taula creuada';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'També pots desplaçar-te sobre el tauler per moure en el joc.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Mantingueu el ratolí sobre les variants d\'anàlisi per a previsualitzar-les.';

  @override
  String get analysisShapesHowTo => 'Pitja la tecla Shift + clic o feu clic dret per dibuixar cercles i fletxes al tauler.';

  @override
  String get letOtherPlayersMessageYou => 'Deixa que altres jugadors t\'envïin missatges';

  @override
  String get receiveForumNotifications => 'Rebre notificacions quan et mencionin al fòrum';

  @override
  String get shareYourInsightsData => 'Comparteix les teves dades d\'estadístiques';

  @override
  String get withNobody => 'Amb ningú';

  @override
  String get withFriends => 'Amb amics';

  @override
  String get withEverybody => 'Amb tothom';

  @override
  String get kidMode => 'Mode infantil';

  @override
  String get kidModeIsEnabled => 'Mode nens activat.';

  @override
  String get kidModeExplanation => 'Es tracta de seguretat. En el mode nen, totes les comunicacions de la pàgina estan inhabilitades. Activa això als seus nens o alumnes, per protegir-los d\'altres usuaris d\'internet.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'En el mode nen, el logo de lichess té una icona de $param, per què sàpigues que els teus nens estan segurs.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'El vostre compte és gestionat. Demaneu al vostre professor deixar el mode per a nens.';

  @override
  String get enableKidMode => 'Activar el mode de nen';

  @override
  String get disableKidMode => 'Desactivar el mode de nen';

  @override
  String get security => 'Seguretat';

  @override
  String get sessions => 'Sessions';

  @override
  String get revokeAllSessions => 'tancar totes les sessions';

  @override
  String get playChessEverywhere => 'Jugueu a escacs a qualsevol lloc';

  @override
  String get asFreeAsLichess => 'Tan lliure com lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Fet per amor als escacs, no per diners';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Tothom accedeix gratuïtament a totes les funcions';

  @override
  String get zeroAdvertisement => 'Cap anunci';

  @override
  String get fullFeatured => 'Amb totes les funcions';

  @override
  String get phoneAndTablet => 'Telèfon i tauleta';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, clàssic';

  @override
  String get correspondenceChess => 'Escacs per correspondència';

  @override
  String get onlineAndOfflinePlay => 'Jugar en línia i desconectat';

  @override
  String get viewTheSolution => 'Veure la solució';

  @override
  String get followAndChallengeFriends => 'Seguiu i desafieu amics';

  @override
  String get gameAnalysis => 'Anàlisi de la partida';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 és amfitrió de $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 s\'uneix a $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return 'A $param1 li agrada $param2';
  }

  @override
  String get quickPairing => 'Emparellament ràpid';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anònim';

  @override
  String yourScore(String param) {
    return 'El seu resultat: $param';
  }

  @override
  String get language => 'Llengua';

  @override
  String get background => 'Fons';

  @override
  String get light => 'Clar';

  @override
  String get dark => 'Fosc';

  @override
  String get transparent => 'Transparent';

  @override
  String get deviceTheme => 'Tema del dispositiu';

  @override
  String get backgroundImageUrl => 'Imatge de fons URL:';

  @override
  String get board => 'Tauler';

  @override
  String get size => 'Mida';

  @override
  String get opacity => 'Opacitat';

  @override
  String get brightness => 'Brillantor';

  @override
  String get hue => 'Tonalitat';

  @override
  String get boardReset => 'Restableix els colors per defecte';

  @override
  String get pieceSet => 'Conjunt de peces';

  @override
  String get embedInYourWebsite => 'Integrar en el seu lloc web';

  @override
  String get usernameAlreadyUsed => 'Aquest nom d\'usuari ja està en ús. Si us plau, tria un altre nom.';

  @override
  String get usernamePrefixInvalid => 'El nom d\'usuari ha de començar amb una lletra.';

  @override
  String get usernameSuffixInvalid => 'El nom d\'usuari ha d\'acabar amb una lletra o dígit.';

  @override
  String get usernameCharsInvalid => 'Els noms d\'usuari només poden contenir lletres, números, guions i guions baixos.';

  @override
  String get usernameUnacceptable => 'Aquest nom d\'usuari no és acceptable.';

  @override
  String get playChessInStyle => 'Juga a escacs amb estil';

  @override
  String get chessBasics => 'Fonaments d\'escacs';

  @override
  String get coaches => 'Entrenador';

  @override
  String get invalidPgn => 'PGN no vàlid';

  @override
  String get invalidFen => 'FEN no vàlid';

  @override
  String get custom => 'Personalitzat';

  @override
  String get notifications => 'Avisos';

  @override
  String notificationsX(String param1) {
    return 'Notificacions: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Classificació: $param';
  }

  @override
  String get practiceWithComputer => 'Practicar amb l\'ordinador';

  @override
  String anotherWasX(String param) {
    return 'Un altre era $param';
  }

  @override
  String bestWasX(String param) {
    return 'El millor era $param';
  }

  @override
  String get youBrowsedAway => 'Ha sortit de la revisió';

  @override
  String get resumePractice => 'Reprendre la pràctica';

  @override
  String get drawByFiftyMoves => 'La partida ha estat declarada un empat per la regla dels 50 moviments.';

  @override
  String get theGameIsADraw => 'El joc és un empat.';

  @override
  String get computerThinking => 'L\'ordinador està pensant ...';

  @override
  String get seeBestMove => 'Veure la millor jugada';

  @override
  String get hideBestMove => 'Amagar la millor jugada';

  @override
  String get getAHint => 'Obtenir una pista';

  @override
  String get evaluatingYourMove => 'Avaluant la seva jugada ...';

  @override
  String get whiteWinsGame => 'Les blanques guanyen';

  @override
  String get blackWinsGame => 'Les negres guanyen';

  @override
  String get learnFromYourMistakes => 'Aprendre dels seus errors';

  @override
  String get learnFromThisMistake => 'Aprendre d\'aquest error';

  @override
  String get skipThisMove => 'Ometre aquest pas';

  @override
  String get next => 'Següent';

  @override
  String xWasPlayed(String param) {
    return '$param es va jugar';
  }

  @override
  String get findBetterMoveForWhite => 'Trobar un moviment millor per a les blanques';

  @override
  String get findBetterMoveForBlack => 'Trobar un moviment millor per les negres';

  @override
  String get resumeLearning => 'Seguir l\'aprenentatge';

  @override
  String get youCanDoBetter => 'Ho pots fer millor';

  @override
  String get tryAnotherMoveForWhite => 'Prova un altre moviment per a les blanques';

  @override
  String get tryAnotherMoveForBlack => 'Prova un altre moviment per a les negres';

  @override
  String get solution => 'Solució';

  @override
  String get waitingForAnalysis => 'Esperant l\'anàlisi';

  @override
  String get noMistakesFoundForWhite => 'No s\'ha trobat cap error per a les blanques';

  @override
  String get noMistakesFoundForBlack => 'No s\'ha trobat cap error per a les negres';

  @override
  String get doneReviewingWhiteMistakes => 'Errors de les blanques revisats';

  @override
  String get doneReviewingBlackMistakes => 'Errors de les negres revisats';

  @override
  String get doItAgain => 'Fes-ho de nou';

  @override
  String get reviewWhiteMistakes => 'Revisar errors de les blanques';

  @override
  String get reviewBlackMistakes => 'Revisar errors de les negres';

  @override
  String get advantage => 'Avantatge';

  @override
  String get opening => 'Obertura';

  @override
  String get middlegame => 'Joc mitjà';

  @override
  String get endgame => 'Final';

  @override
  String get conditionalPremoves => 'Premoviments condicionals';

  @override
  String get addCurrentVariation => 'Afegir variació actual';

  @override
  String get playVariationToCreateConditionalPremoves => 'Jugar una variació per crear premoviments condicionals';

  @override
  String get noConditionalPremoves => 'Sense moviments anticipats condicionals';

  @override
  String playX(String param) {
    return 'Jugar $param';
  }

  @override
  String get showUnreadLichessMessage => 'Has rebut un missatge privat de Lichess.';

  @override
  String get clickHereToReadIt => 'Fes clic aquí per llegir-lo';

  @override
  String get sorry => 'Ho sentim :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Hem hagut de penalitzar-te una estona.';

  @override
  String get why => 'Perquè?';

  @override
  String get pleasantChessExperience => 'Intentem donar una bona experiència d’escacs a tothom.';

  @override
  String get goodPractice => 'Per això, hem de garantir que tots els jugadors segueixin bones pràctiques.';

  @override
  String get potentialProblem => 'Quan un problema potancial es detecta, mostrem aquest missatge.';

  @override
  String get howToAvoidThis => 'Com evitar-ho?';

  @override
  String get playEveryGame => 'Juga cada joc que comencis.';

  @override
  String get tryToWin => 'Prova de guanyar (o al menys fer taules) cada partida.';

  @override
  String get resignLostGames => 'Resigna els jocs perduts (no deixis córrer el temps).';

  @override
  String get temporaryInconvenience => 'Disculpes per aquest inconvenient temporal';

  @override
  String get wishYouGreatGames => 'i et desitgem unes grans partides a lichess.org.';

  @override
  String get thankYouForReading => 'Gràcies per la teva lectura!';

  @override
  String get lifetimeScore => 'Valoració total de sempre';

  @override
  String get currentMatchScore => 'Valoració actual de partides';

  @override
  String get agreementAssistance => 'Estic d’acord que mai rebré assistència durant les meves partides (ni d’ordinadors, llibres, base de dades o d’una altra persona).';

  @override
  String get agreementNice => 'Estic d’acord que sempre seré respectuós amb els altres jugadors.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Estic d\'acord en no crear múltiples comptes (excepte per les raons detallades als $param).';
  }

  @override
  String get agreementPolicy => 'Estic d’acord que seguiré totes les polítiques de Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Cerca o inicia una nova discusió';

  @override
  String get edit => 'Edita';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Ràpides';

  @override
  String get classical => 'Clàssic';

  @override
  String get ultraBulletDesc => 'Partides extramadament ràpides: menys de 30 segons';

  @override
  String get bulletDesc => 'Partides molt ràpides, menys de 3 minuts';

  @override
  String get blitzDesc => 'Partides ràpides: 3 a 8 minuts';

  @override
  String get rapidDesc => 'Pàrtides ràpides: de 8 a 25 minuts';

  @override
  String get classicalDesc => 'Partides a temps clàssic: més de 25 minuts';

  @override
  String get correspondenceDesc => 'Partides per correspondència: un o més dies per jugada';

  @override
  String get puzzleDesc => 'Entrenador de tàctica';

  @override
  String get important => 'Important';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'La teva pregunta ja pot estar resposta $param1';
  }

  @override
  String get inTheFAQ => 'en les P.M.F.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Per reportar a un usuari per trampes o mal comportament, $param1';
  }

  @override
  String get useTheReportForm => 'utilitza el formulari';

  @override
  String toRequestSupport(String param1) {
    return 'Per demanar suport, $param1';
  }

  @override
  String get tryTheContactPage => 'prova la plana de contacte';

  @override
  String makeSureToRead(String param1) {
    return 'Assegureu-vos de llegir $param1';
  }

  @override
  String get theForumEtiquette => 'l\'etiqueta del fòrum';

  @override
  String get thisTopicIsArchived => 'Aquest tema ha estat arxivat i no es pot respondre.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Uneix-te a $param1, per poder publicar';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 equip';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Encara no pots publicar en els fòrums. Juga algunes partides!';

  @override
  String get subscribe => 'Subscriure’s';

  @override
  String get unsubscribe => 'Anul·la subscripció';

  @override
  String mentionedYouInX(String param1) {
    return 't\'ha mencionat en \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 t\'ha mencionat en \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 't\'ha invitat a \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 t\'ha invitat a \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Ara formes part de l\'equip.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'T\'has unit a \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Algú que vas denunciar ha estat expulsat';

  @override
  String get congratsYouWon => 'Felicitats, has guanyat!';

  @override
  String gameVsX(String param1) {
    return 'Partida vs $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Has perdut contra algú que ha violat les CDS de Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Reemborsament: $param1 $param2 punts.';
  }

  @override
  String get timeAlmostUp => 'El temps quasi s\'ha exhaurit!';

  @override
  String get clickToRevealEmailAddress => '[Clica per a mostrar l\'adreça de correu electrònic]';

  @override
  String get download => 'Descarregar';

  @override
  String get coachManager => 'Gestionament d\'entrenador';

  @override
  String get streamerManager => 'Gestionament de retransmissor';

  @override
  String get cancelTournament => 'Cancel-lar el torneig';

  @override
  String get tournDescription => 'Descripció del torneig';

  @override
  String get tournDescriptionHelp => 'Cap cosa per mencionar als participants? Intenta mantenir-ho curt. Enllaços utilitzant Markdown estan disponibles: [nom](https://url)';

  @override
  String get ratedFormHelp => 'Els jocs són puntuats\ni impacten les puntuacions dels jugadors';

  @override
  String get onlyMembersOfTeam => 'Només membres de l\'equip';

  @override
  String get noRestriction => 'Sense restriccions';

  @override
  String get minimumRatedGames => 'Mínims partits puntuats';

  @override
  String get minimumRating => 'Puntuació mínima';

  @override
  String get maximumWeeklyRating => 'Puntuació màxima aquesta setmana';

  @override
  String positionInputHelp(String param) {
    return 'Enganxa un FEN vàlid per començar cada joc d\'una posició donada.\nNomés funciona per jocs estàndard, no per a variants.\nPots utilitzar l\'$param per generar una posició FEN, i després enganxar-ho aquí.\nDeixa-ho en blanc per començar els jocs de la posició inicial.';
  }

  @override
  String get cancelSimul => 'Cancel·la la simultània';

  @override
  String get simulHostcolor => 'Banda de l\'amfitrió cada joc';

  @override
  String get estimatedStart => 'Temps de començament aproximada';

  @override
  String simulFeatured(String param) {
    return 'Mostrar a $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Mostra la teva simultània a tothom a $param. Desactiva-ho per a simultànies privades.';
  }

  @override
  String get simulDescription => 'Descripció de la simultània';

  @override
  String get simulDescriptionHelp => 'Cap cosa per mencionar als participants?';

  @override
  String markdownAvailable(String param) {
    return '$param és disponible per a formats més avançats.';
  }

  @override
  String get embedsAvailable => 'Enganxa un URL d\'un joc o d\'un capítol d\'estudi per incrustar-ho.';

  @override
  String get inYourLocalTimezone => 'El la teva zona horària';

  @override
  String get tournChat => 'Xat del tornament';

  @override
  String get noChat => 'Desactivar xat';

  @override
  String get onlyTeamLeaders => 'Només per líders de l\'equip';

  @override
  String get onlyTeamMembers => 'Només per a membres de l\'equip';

  @override
  String get navigateMoveTree => 'Navega la llista de moviments';

  @override
  String get mouseTricks => 'Trucs amb el ratolí';

  @override
  String get toggleLocalAnalysis => 'Activa/desactiva l\'anàlisi d\'ordinador al navegador';

  @override
  String get toggleAllAnalysis => 'Activa/desactiva tot l\'anàlisi d\'ordinador';

  @override
  String get playComputerMove => 'Juga el millor moviment suggerit per l\'ordinador';

  @override
  String get analysisOptions => 'Opcions d\'anàlisi';

  @override
  String get focusChat => 'Enfocar el xat';

  @override
  String get showHelpDialog => 'Ensenya aquest missatge d\'ajuda';

  @override
  String get reopenYourAccount => 'Torna a obrir el teu compte';

  @override
  String get closedAccountChangedMind => 'Si has tancat el teu compte, però des de llavors has cambiat d\'opinió, tens una oportunitat per recuperar el teu compte.';

  @override
  String get onlyWorksOnce => 'Això només funcionarà un cop.';

  @override
  String get cantDoThisTwice => 'Si tanques el teu compte per segon cop, no hi haurà manera de recuperar-ho.';

  @override
  String get emailAssociatedToaccount => 'Adreça de correu electrònic associat al teu compte';

  @override
  String get sentEmailWithLink => 'T\'hem enviat un correu amb un enllaç.';

  @override
  String get tournamentEntryCode => 'Codi per entrar el tornament';

  @override
  String get hangOn => 'Un moment!';

  @override
  String gameInProgress(String param) {
    return 'Tens una partida començada amb $param.';
  }

  @override
  String get abortTheGame => 'Avortar el joc';

  @override
  String get resignTheGame => 'Rendir-se';

  @override
  String get youCantStartNewGame => 'No pots començar un joc nou fins que aquest acabi.';

  @override
  String get since => 'Des de';

  @override
  String get until => 'Fins';

  @override
  String get lichessDbExplanation => 'Mostra de partides puntuades de tots els jugadors de Lichess';

  @override
  String get switchSides => 'Canviar de bandòl';

  @override
  String get closingAccountWithdrawAppeal => 'El tancament del vostre compte eliminarà la vostra queixa';

  @override
  String get ourEventTips => 'Els nostres consells per organitzar esdeveniments';

  @override
  String get instructions => 'Instruccions';

  @override
  String get showMeEverything => 'Mostrar tot';

  @override
  String get lichessPatronInfo => 'Lichess és una entitat sense ànim de lucre i un programari totalment lliure i de codi obert.\nLes despeses de funcionament, desenvolupament i continguts es financen exclusivament amb donacions d\'usuaris.';

  @override
  String get nothingToSeeHere => 'Res a veure per aquí de moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'El teu contrincant ha abandonat la partida. Pots reclamar la victòria en $count segons.',
      one: 'El teu contrincant ha abandonat la partida. Pots reclamar la victòria en $count segon.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat en $count jugades',
      one: 'Mat en $count mig-moviment',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errades greus',
      one: '$count errada greu',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errades',
      one: '$count errada',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imprecisions',
      one: '$count imprecisió',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jugadors',
      one: '$count jugador',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partides',
      one: '$count partida',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntuació en $param2 partides',
      one: '$count puntuació en $param2 partida',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preferides',
      one: '$count preferida',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dies',
      one: '$count dia',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hores',
      one: '$count hora',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuts',
      one: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'La classificació s\'actualitza cada $count minuts',
      one: 'La classificació s\'actualitza cada minut',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemes',
      one: '$count problema',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partides amb tu',
      one: '$count partida amb tu',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntuades',
      one: '$count puntuada',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count victòries',
      one: '$count victòries',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count derrotes',
      one: '$count derrotes',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taules',
      one: '$count taules',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count en joc',
      one: '$count en joc',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dona $count segons',
      one: 'Dona $count segon',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punts de torneig',
      one: '$count punt de torneig',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estudis',
      one: '$count estudi',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultànies',
      one: '$count simultània',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partides per punts',
      one: '≥ $count partida per punts',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 partides puntuades',
      one: '≥ $count $param2 partida puntuada',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Necessites jugar $count partides puntuades $param2 més',
      one: 'Necessites jugar $count partida puntuada $param2 més',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Necessites jugar $count partides puntuades més',
      one: 'Necessites jugar $count partida puntuada més',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partides importades',
      one: '$count partides importades',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amics connectats',
      one: '$count amic connectat',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seguidors',
      one: '$count seguidors',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seguint $count jugadors',
      one: 'Seguint $count jugadors',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Menys de $count minuts',
      one: 'Menys de $count minuts',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partides en joc',
      one: '$count partida en joc',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Màxim: $count caràcters.',
      one: 'Màxim: $count caràcters.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jugadors bloquejats',
      one: '$count jugadors bloquejats',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Missatges al Fòrum',
      one: '$count Missatge al Fòrum',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jugadors de $param2 aquesta setmana.',
      one: '$count jugador de $param2 aquesta setmana.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Disponible en $count idiomes',
      one: 'Disponible en $count idiomes',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segons per jugar el primer moviment',
      one: '$count segon per jugar el primer moviment',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segon',
      one: '$count segon',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i guardar $count línies anticipades',
      one: 'i guardar $count línia anticipada',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Fes una jugada per començar';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Jugues amb blanques a tots els problemes';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Jugues amb negres a tots els problemes';

  @override
  String get stormPuzzlesSolved => 'problemes resolts';

  @override
  String get stormNewDailyHighscore => 'Nou rècord de puntuació diària!';

  @override
  String get stormNewWeeklyHighscore => 'Nou récord de puntuació setmanal!';

  @override
  String get stormNewMonthlyHighscore => 'Nou récord de puntuació mensual!';

  @override
  String get stormNewAllTimeHighscore => 'Nou récord de puntuació de tots els temps!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'El récord de puntuació anterior era de $param';
  }

  @override
  String get stormPlayAgain => 'Torna a jugar';

  @override
  String stormHighscoreX(String param) {
    return 'Récord de puntuació: $param';
  }

  @override
  String get stormScore => 'Puntuació';

  @override
  String get stormMoves => 'Moviments';

  @override
  String get stormAccuracy => 'Precisió';

  @override
  String get stormCombo => 'Ratxa';

  @override
  String get stormTime => 'Temps';

  @override
  String get stormTimePerMove => 'Temps per jugada';

  @override
  String get stormHighestSolved => 'El més difícil resolt';

  @override
  String get stormPuzzlesPlayed => 'Problemes realitzats';

  @override
  String get stormNewRun => 'Nou intent (tecla: Espai)';

  @override
  String get stormEndRun => 'Finalitzar l\'intent (tecla: Enter)';

  @override
  String get stormHighscores => 'Millors puntuacions';

  @override
  String get stormViewBestRuns => 'Veure els millors intents';

  @override
  String get stormBestRunOfDay => 'Millor intent del dia';

  @override
  String get stormRuns => 'Intents';

  @override
  String get stormGetReady => 'Prepara\'t!';

  @override
  String get stormWaitingForMorePlayers => 'Esperant que s\'uneixin més jugadors...';

  @override
  String get stormRaceComplete => 'Cursa finalitzada!';

  @override
  String get stormSpectating => 'Observant';

  @override
  String get stormJoinTheRace => 'Uneix-te a la cursa!';

  @override
  String get stormStartTheRace => 'Comença la cursa';

  @override
  String stormYourRankX(String param) {
    return 'La teva puntuació: $param';
  }

  @override
  String get stormWaitForRematch => 'Espera per a la revenja';

  @override
  String get stormNextRace => 'Cursa següent';

  @override
  String get stormJoinRematch => 'Unir-se a la revenja';

  @override
  String get stormWaitingToStart => 'Esperant que comenci';

  @override
  String get stormCreateNewGame => 'Crea una nova cursa';

  @override
  String get stormJoinPublicRace => 'Uneix-te a una cursa pública';

  @override
  String get stormRaceYourFriends => 'Desafia els teus amics';

  @override
  String get stormSkip => 'omet';

  @override
  String get stormSkipHelp => 'NOU! Pots ometre un moviment a cada cursa:';

  @override
  String get stormSkipExplanation => 'Omet aquest moviment per preservar el teu combo! Només funciona un cop per cursa.';

  @override
  String get stormFailedPuzzles => 'Puzzles errats';

  @override
  String get stormSlowPuzzles => 'Problemes lents';

  @override
  String get stormSkippedPuzzle => 'Problema omès';

  @override
  String get stormThisWeek => 'Aquesta setmana';

  @override
  String get stormThisMonth => 'Aquest mes';

  @override
  String get stormAllTime => 'Tot';

  @override
  String get stormClickToReload => 'Clicar per recarregar';

  @override
  String get stormThisRunHasExpired => 'Aquesta ronda ha caducat!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Aquesta ronda s\'ha obert a una altra pestanya!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count intents',
      one: 'Un intent',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha jugat $count rondes de $param2',
      one: 'Ha jugat una ronda de $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Retransmissors de Lichess';

  @override
  String get studyShareAndExport => 'Comparteix i exporta';

  @override
  String get studyStart => 'Inici';
}
