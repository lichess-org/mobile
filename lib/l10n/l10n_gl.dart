import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Galician (`gl`).
class AppLocalizationsGl extends AppLocalizations {
  AppLocalizationsGl([String locale = 'gl']) : super(locale);

  @override
  String get mobileHomeTab => 'Inicio';

  @override
  String get mobilePuzzlesTab => 'Crebacabezas';

  @override
  String get mobileToolsTab => 'Ferramentas';

  @override
  String get mobileWatchTab => 'Ver';

  @override
  String get mobileSettingsTab => 'Axustes';

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
  String get activityActivity => 'Actividade';

  @override
  String get activityHostedALiveStream => 'Emitiu en directo';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '$param1º na clasificación de $param2';
  }

  @override
  String get activitySignedUp => 'Rexistrado en lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apoiou a lichess.org durante $count meses como $param2',
      one: 'Apoiou a lichess.org durante $count mes como $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Practicou $count posicións en $param2',
      one: 'Practicou $count posición en $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Resolveu $count exercicios de adestramento',
      one: 'Resolveu $count exercicio de adestramento',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xogou $count partidas de $param2',
      one: 'Xogou $count partida de $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Publicou $count mensaxes en $param2',
      one: 'Publicou $count mensaxe en $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xogou $count movementos',
      one: 'Xogou $count movemento',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'en $count partidas por correspondencia',
      one: 'en $count partida por correspondencia',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xogou $count partidas por correspondencia',
      one: 'Xogou $count partida por correspondencia',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Comezou a seguir a $count xogadores',
      one: 'Comezou a seguir a $count xogador',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gañou $count novos seguidores',
      one: 'Gañou $count novo seguidor',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ofreceu $count exhibicións simultáneas',
      one: 'Ofreceu $count exhibición simultánea',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Participou en $count exhibicións simultáneas',
      one: 'Participou en $count exhibición simultánea',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Creou $count novos estudos',
      one: 'Creou $count novo estudo',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Competiu en $count torneos Arena',
      one: 'Competiu en $count torneo Arena',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countº na clasificación (no $param2% mellor) con $param3 partidas en $param4',
      one: '$countº na clasificación (no $param2% mellor) con $param3 partida en $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Competiu en $count torneos suízos',
      one: 'Competiu en $count torneo suízo',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uniuse a $count equipos',
      one: 'Uniuse a $count equipo',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Emisións en directo';

  @override
  String get broadcastLiveBroadcasts => 'Emisións de torneos en directo';

  @override
  String challengeChallengesX(String param1) {
    return 'Desafíos: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Desafía a unha partida';

  @override
  String get challengeChallengeDeclined => 'Desafío rexeitado';

  @override
  String get challengeChallengeAccepted => 'Desafío aceptado!';

  @override
  String get challengeChallengeCanceled => 'Desafío cancelado.';

  @override
  String get challengeRegisterToSendChallenges => 'Por favor, rexístrate para retar a este usuario.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Non podes desafiar a $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param non acepta desafíos.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'A túa puntuación $param1 difire moito da de $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Non podes desafiar dado que a túa puntuación en $param é provisional.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param só acepta desafíos de amigos.';
  }

  @override
  String get challengeDeclineGeneric => 'Neste momento non acepto desafíos.';

  @override
  String get challengeDeclineLater => 'Agora mesmo non podo. Por favor, téntao máis tarde.';

  @override
  String get challengeDeclineTooFast => 'Paréceme pouco tempo. Proba cun ritmo máis lento.';

  @override
  String get challengeDeclineTooSlow => 'Paréceme moito tempo. Proba cun ritmo máis rápido.';

  @override
  String get challengeDeclineTimeControl => 'Non acepto desafíos a este ritmo.';

  @override
  String get challengeDeclineRated => 'Por favor, rétame a unha partida puntuada.';

  @override
  String get challengeDeclineCasual => 'Por favor, rétame a unha partida amigable.';

  @override
  String get challengeDeclineStandard => 'Agora mesmo non acepto desafíos en variantes.';

  @override
  String get challengeDeclineVariant => 'Neste momento non me apetece xogar esa variante.';

  @override
  String get challengeDeclineNoBot => 'Non acepto desafíos de bots.';

  @override
  String get challengeDeclineOnlyBot => 'Só acepto desafíos de bots.';

  @override
  String get challengeInviteLichessUser => 'Ou convida a un usuario de Lichess:';

  @override
  String get contactContact => 'Contacto';

  @override
  String get contactContactLichess => 'Contactar con Lichess';

  @override
  String get patronDonate => 'Doar';

  @override
  String get patronLichessPatron => 'Patrón de Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Estatísticas de $param';
  }

  @override
  String get perfStatViewTheGames => 'Ver as partidas';

  @override
  String get perfStatProvisional => 'provisional';

  @override
  String get perfStatNotEnoughRatedGames => 'No se xogaron suficientes partidas puntuadas para poder establecer unha puntuación fiábel.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progresión nas últimas $param partidas:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Desviación da puntuación: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Un valor baixo significa que a puntuación é máis estable. Por riba de $param1, a puntuación considérase provisional. Para que se inclúa nas clasificacións, este valor debe ser inferior a $param2 (xadrez estándar) ou $param3 (variantes).';
  }

  @override
  String get perfStatTotalGames => 'Partidas totais';

  @override
  String get perfStatRatedGames => 'Partidas puntuadas';

  @override
  String get perfStatTournamentGames => 'Partidas de torneo';

  @override
  String get perfStatBerserkedGames => 'Partidas no modo Berserk';

  @override
  String get perfStatTimeSpentPlaying => 'Tempo xogado';

  @override
  String get perfStatAverageOpponent => 'Puntuación media dos opoñentes';

  @override
  String get perfStatVictories => 'Vitorias';

  @override
  String get perfStatDefeats => 'Derrotas';

  @override
  String get perfStatDisconnections => 'Desconexións';

  @override
  String get perfStatNotEnoughGames => 'Non hai suficientes partidas xogadas';

  @override
  String perfStatHighestRating(String param) {
    return 'Puntuación máis alta: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Puntuación máis baixa: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'de $param1 a $param2';
  }

  @override
  String get perfStatWinningStreak => 'Vitorias consecutivas';

  @override
  String get perfStatLosingStreak => 'Derrotas consecutivas';

  @override
  String perfStatLongestStreak(String param) {
    return 'Secuencia máis longa: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Secuencia actual: $param';
  }

  @override
  String get perfStatBestRated => 'Mellores vitorias puntuadas';

  @override
  String get perfStatGamesInARow => 'Partidas xogadas seguidas';

  @override
  String get perfStatLessThanOneHour => 'Menos dunha hora entre partidas';

  @override
  String get perfStatMaxTimePlaying => 'Tempo máximo xogando';

  @override
  String get perfStatNow => 'agora';

  @override
  String get preferencesPreferences => 'Preferencias';

  @override
  String get preferencesDisplay => 'Mostrar';

  @override
  String get preferencesPrivacy => 'Privacidade';

  @override
  String get preferencesNotifications => 'Notificacións';

  @override
  String get preferencesPieceAnimation => 'Animación das pezas';

  @override
  String get preferencesMaterialDifference => 'Diferenza de material';

  @override
  String get preferencesBoardHighlights => 'Resaltar no taboleiro (última xogada e xaque)';

  @override
  String get preferencesPieceDestinations => 'Destino das pezas (xogadas válidas e premovementos)';

  @override
  String get preferencesBoardCoordinates => 'Coordenadas do taboleiro (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Lista de xogadas mentres xogas';

  @override
  String get preferencesPgnPieceNotation => 'Notación das xogadas';

  @override
  String get preferencesChessPieceSymbol => 'Símbolo da peza de xadrez';

  @override
  String get preferencesPgnLetter => 'Inicial (en inglés) da peza (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Modo zen';

  @override
  String get preferencesShowPlayerRatings => 'Amosar a puntuación dos xogadores';

  @override
  String get preferencesShowFlairs => 'Amosar as habelencias dos xogadores';

  @override
  String get preferencesExplainShowPlayerRatings => 'Isto permite ocultar todas as puntuacións do sitio, para axudar a centrarse no xadrez. As partidas poden ser puntuadas, isto só afecta ó que podes ver.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Mostrar o control de redimensionamento do taboleiro';

  @override
  String get preferencesOnlyOnInitialPosition => 'Só na posición inicial';

  @override
  String get preferencesInGameOnly => 'Só durante a partida';

  @override
  String get preferencesChessClock => 'Reloxo de xadrez';

  @override
  String get preferencesTenthsOfSeconds => 'Décimas de segundo';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Cando o tempo restante < 10 segundos';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Barras horizontais de progreso verdes';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Aviso cando se esgota o tempo';

  @override
  String get preferencesGiveMoreTime => 'Dar máis tempo';

  @override
  String get preferencesGameBehavior => 'Comportamento do xogo';

  @override
  String get preferencesHowDoYouMovePieces => 'Como moves as pezas?';

  @override
  String get preferencesClickTwoSquares => 'Premendo na casa de orixe e despois na de destino';

  @override
  String get preferencesDragPiece => 'Arrastrando a peza';

  @override
  String get preferencesBothClicksAndDrag => 'Ambas';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Premovementos (xogar durante o tempo do teu rival)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Rectificar xogadas (co permiso do rival)';

  @override
  String get preferencesInCasualGamesOnly => 'Só en partidas amigables';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Coroar Dama automaticamente';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Mantén pulsada a tecla <ctrl> ao coroar para desactivar temporalmente a promoción automática';

  @override
  String get preferencesWhenPremoving => 'Con premovemento';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Automaticamente reclamar táboas por tripla repetición';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Cando o tempo restante <30 segundos';

  @override
  String get preferencesMoveConfirmation => 'Confirmación do movemento';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Pode ser desactivado durante a partida dende o menú do taboleiro';

  @override
  String get preferencesInCorrespondenceGames => 'Partidas por correspondencia';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Correspondencia e ilimitado';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Confirmar abandono e ofertas de táboas';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Método de enroque';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Movendo o rei dúas casas';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Movendo rei ata a torre';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Introdución de movementos co teclado';

  @override
  String get preferencesInputMovesWithVoice => 'Introdución de xogadas coa voz';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Adherir frechas a movementos válidos';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Dicir \"Good game, well played\" (Boa partida, ben xogada) ao perder ou empatar';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'As túas preferencias foron gardadas.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Usar a roda do rato para amosar os movementos';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Notificación diaria por email coas túas partidas por correspondencia';

  @override
  String get preferencesNotifyStreamStart => 'Un presentador comeza unha transmisión en directo';

  @override
  String get preferencesNotifyInboxMsg => 'Novo correo';

  @override
  String get preferencesNotifyForumMention => 'Un comentario do foro menciónate';

  @override
  String get preferencesNotifyInvitedStudy => 'Invitación a estudo';

  @override
  String get preferencesNotifyGameEvent => 'Actualizacións de partida por correspondencia';

  @override
  String get preferencesNotifyChallenge => 'Desafíos';

  @override
  String get preferencesNotifyTournamentSoon => 'O torneo comeza pronto';

  @override
  String get preferencesNotifyTimeAlarm => 'Pouco tempo restante na partida por correspondencia';

  @override
  String get preferencesNotifyBell => 'Notificación dentro de Lichess';

  @override
  String get preferencesNotifyPush => 'Notificación no dispositivo cando non esteas en Lichess';

  @override
  String get preferencesNotifyWeb => 'Navegador';

  @override
  String get preferencesNotifyDevice => 'Dispositivo';

  @override
  String get preferencesBellNotificationSound => 'Son da notificación';

  @override
  String get puzzlePuzzles => 'Crebacabezas';

  @override
  String get puzzlePuzzleThemes => 'Temas de quebracabezas';

  @override
  String get puzzleRecommended => 'Recomendado';

  @override
  String get puzzlePhases => 'Fases';

  @override
  String get puzzleMotifs => 'Motivos';

  @override
  String get puzzleAdvanced => 'Avanzado';

  @override
  String get puzzleLengths => 'Duracións';

  @override
  String get puzzleMates => 'Mates';

  @override
  String get puzzleGoals => 'Obxectivos';

  @override
  String get puzzleOrigin => 'Fonte';

  @override
  String get puzzleSpecialMoves => 'Movementos especiais';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Gustouche este crebacabezas?';

  @override
  String get puzzleVoteToLoadNextOne => 'Vota para cargar o seguinte!';

  @override
  String get puzzleUpVote => 'Vota a favor do crebacabezas';

  @override
  String get puzzleDownVote => 'Vota en contra do crebacabezas';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'A túa puntuación en crebacabezas non cambia. Ten en conta que os crebacabezas non son unha competición. A puntuación axuda a escollerche os crebacabezas máis axeitados segundo a túa puntuación actual.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Atopa a mellor xogada para as brancas.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Atopa a mellor xogada para as negras.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Para conseguir crebacabezas personalizados:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Crebacabezas $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Crebacabezas do día';

  @override
  String get puzzleDailyPuzzle => 'Crebacabezas do día';

  @override
  String get puzzleClickToSolve => 'Fai clic para resolver';

  @override
  String get puzzleGoodMove => 'Bo movemento';

  @override
  String get puzzleBestMove => 'O mellor movemento!';

  @override
  String get puzzleKeepGoing => 'Continúa…';

  @override
  String get puzzlePuzzleSuccess => 'Feito!';

  @override
  String get puzzlePuzzleComplete => 'Crebacabezas terminado!';

  @override
  String get puzzleByOpenings => 'Por aperturas';

  @override
  String get puzzlePuzzlesByOpenings => 'Exercicios por aperturas';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'As aperturas que máis xogaches en partidas puntuadas';

  @override
  String get puzzleUseFindInPage => 'Usa \"Encontrar na páxina\" no menú do navegador para atopar a túa apertura favorita!';

  @override
  String get puzzleUseCtrlF => 'Usa Ctrl+f para atopar a túa apertura favorita!';

  @override
  String get puzzleNotTheMove => 'Esa non é a xogada!';

  @override
  String get puzzleTrySomethingElse => 'Proba outra cosa.';

  @override
  String puzzleRatingX(String param) {
    return 'Puntuación: $param';
  }

  @override
  String get puzzleHidden => 'oculta';

  @override
  String puzzleFromGameLink(String param) {
    return 'Extraído da partida $param';
  }

  @override
  String get puzzleContinueTraining => 'Continuar o adestramento';

  @override
  String get puzzleDifficultyLevel => 'Nivel de dificultade';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Máis fácil';

  @override
  String get puzzleEasiest => 'O máis fácil';

  @override
  String get puzzleHarder => 'Máis difícil';

  @override
  String get puzzleHardest => 'O máis difícil';

  @override
  String get puzzleExample => 'Exemplo';

  @override
  String get puzzleAddAnotherTheme => 'Engadir outro tema';

  @override
  String get puzzleNextPuzzle => 'Seguinte exercicio';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Ir ao seguinte crebacabezas inmediatamente';

  @override
  String get puzzlePuzzleDashboard => 'Informe de crebacabezas';

  @override
  String get puzzleImprovementAreas => 'Áreas de mellora';

  @override
  String get puzzleStrengths => 'Puntos fortes';

  @override
  String get puzzleHistory => 'Historial de crebacabezas';

  @override
  String get puzzleSolved => 'resoltos';

  @override
  String get puzzleFailed => 'fallado';

  @override
  String get puzzleStreakDescription => 'Soluciona exercicios cada vez máis difíciles e consigue unha secuencia de vitorias. Non hai conta atrás, así que podes ir amodo. Se te equivocas nun só movemento, acabouse! Pero lembra que podes omitir unha xogada por sesión.';

  @override
  String puzzleYourStreakX(String param) {
    return 'A túa secuencia de vitorias: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Omite este movemento para conservar a túa secuencia. Só se pode facer unha vez por sesión.';

  @override
  String get puzzleContinueTheStreak => 'Continúa a secuencia';

  @override
  String get puzzleNewStreak => 'Nova secuencia de vitorias';

  @override
  String get puzzleFromMyGames => 'Das miñas partidas';

  @override
  String get puzzleLookupOfPlayer => 'Buscar crebacabezas das partidas dun xogador';

  @override
  String puzzleFromXGames(String param) {
    return 'Crebacabezas das partidas de $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Busca crebacabezas';

  @override
  String get puzzleFromMyGamesNone => 'Non tes crebacabezas na base de datos e aínda así Lichess quérete moito.\nXoga partidas rápidas e clásicas para ter máis opcións de que se engadan os teus crebacabezas!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 crebacabezas atopados en $param2 partidas';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Adestra, analiza, mellora';

  @override
  String puzzlePercentSolved(String param) {
    return '$param\nresoltos';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Non hai nada que amosar, primeiro resolve algún crebacabezas!';

  @override
  String get puzzleImprovementAreasDescription => 'Adestra nestes temas para progresar!';

  @override
  String get puzzleStrengthDescription => 'Estas son as áreas nas que es máis forte';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xogado $count veces',
      one: 'Xogado $count vez',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos por debaixo da túa puntuación de crebacabezas',
      one: '$count punto por debaixo da túa puntuación de crebacabezas',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos por riba da túa puntuación de crebacabezas',
      one: 'Un punto por riba da túa puntuación de exercicios',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count xogados',
      one: '$count xogado',
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
  String get puzzleThemeAdvancedPawn => 'Peón avanzado';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Un dos teus peóns infíltrase no campo inimigo, ameazando con coroar.';

  @override
  String get puzzleThemeAdvantage => 'Vantaxe';

  @override
  String get puzzleThemeAdvantageDescription => 'Aproveita a oportunidade de obter unha vantaxe decisiva. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mate de Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Un cabalo e unha torre ou dama únense para atrapar ao rei contrario entre un extremo do taboleiro e unha peza do seu bando.';

  @override
  String get puzzleThemeArabianMate => 'Mate árabe';

  @override
  String get puzzleThemeArabianMateDescription => 'Un cabalo e unha torre únense para atrapar ao rei contrario nunha esquina do taboleiro.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Atacando f2 ou f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Un ataque centrado no peón de f2 ou f7, coma no Ataque Fegatello.';

  @override
  String get puzzleThemeAttraction => 'Atracción';

  @override
  String get puzzleThemeAttractionDescription => 'Un intercambio ou sacrificio alentando ou forzando unha peza do opoñente a unha casa que permite unha táctica de seguimento.';

  @override
  String get puzzleThemeBackRankMate => 'Mate do corredor';

  @override
  String get puzzleThemeBackRankMateDescription => 'Xaque mate na última fila, onde o rei está atrapado polas súas propias pezas.';

  @override
  String get puzzleThemeBishopEndgame => 'Final de alfís';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Final con só alfís e peóns.';

  @override
  String get puzzleThemeBodenMate => 'Mate de Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Dous alfís atacando en diagonais cruzadas dan mate ao rei obstaculizado polas súas propias pezas.';

  @override
  String get puzzleThemeCastling => 'Enroque';

  @override
  String get puzzleThemeCastlingDescription => 'Pon o teu rei a salvo e desprega a túa torre para o ataque.';

  @override
  String get puzzleThemeCapturingDefender => 'Captura ao defensor';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Eliminar unha peza fundamental para a defensa doutra, permitindo capturar a peza, agora indefensa, no seguinte movemento.';

  @override
  String get puzzleThemeCrushing => 'Vantaxe decisiva';

  @override
  String get puzzleThemeCrushingDescription => 'Detecta a metida de zoca do opoñente para obter unha vantaxe decisiva. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mate de dous alfís';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dous alfís atacando en diagonais cruzadas dan mate ao rei obstaculizado polas súas propias pezas.';

  @override
  String get puzzleThemeDovetailMate => 'Mate de Cozio';

  @override
  String get puzzleThemeDovetailMateDescription => 'Unha dama dá mate ao rei adxacente, cuxas únicas dúas casas de escape están obstruídas por pezas do seu bando.';

  @override
  String get puzzleThemeEquality => 'Igualdade';

  @override
  String get puzzleThemeEqualityDescription => 'Recupérate dunha posición perdedora e asegura un empate ou unha posición equilibrada. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Ataque no flanco de rei';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Ataque ao rei do opoñente, despois que este enrocase en curto.';

  @override
  String get puzzleThemeClearance => 'Despexe';

  @override
  String get puzzleThemeClearanceDescription => 'Un movemento, a miúdo con ganancia de tempo, que libra unha casa, fila ou diagonal seguido dunha idea táctica.';

  @override
  String get puzzleThemeDefensiveMove => 'Movemento defensivo';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Un movemento ou secuencia de movementos precisos que son necesarios para evitar a perda de material ou outra vantaxe.';

  @override
  String get puzzleThemeDeflection => 'Desviación';

  @override
  String get puzzleThemeDeflectionDescription => 'Un movemento que distrae unha peza rival dunha tarefa que desempeña, como a protección dunha casa chave. Ás veces denomínase \"sobrecarga\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ataque descuberto';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Apartar unha peza que previamente bloqueaba o ataque doutra peza de longo alcance (por exemplo un cabalo fóra do camiño dunha torre).';

  @override
  String get puzzleThemeDoubleCheck => 'Xaque dobre';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Xaque con dúas pezas á vez, como resultado dun ataque descuberto onde tanto a peza en movemento como a desvelada atacan ao rei do opoñente.';

  @override
  String get puzzleThemeEndgame => 'Final';

  @override
  String get puzzleThemeEndgameDescription => 'Táctica durante a derradeira fase do xogo.';

  @override
  String get puzzleThemeEnPassantDescription => 'Táctica que involucra a captura ao paso, onde un peón pode capturar a un peón opoñente que o deixou atrás usando o seu movemento inicial de dúas casas.';

  @override
  String get puzzleThemeExposedKing => 'Rei exposto';

  @override
  String get puzzleThemeExposedKingDescription => 'Táctica que involucra a un rei con pouca defensa ó seu redor, a miúdo conducindo a xaque mate.';

  @override
  String get puzzleThemeFork => 'Garfo';

  @override
  String get puzzleThemeForkDescription => 'Xogada na que a peza movida ataca dúas pezas adversarias simultaneamente.';

  @override
  String get puzzleThemeHangingPiece => 'Peza colgada';

  @override
  String get puzzleThemeHangingPieceDescription => 'Unha táctica que involucra unha peza do opoñente que non está suficientemente defendida e que por tanto se pode capturar.';

  @override
  String get puzzleThemeHookMate => 'Mate do gancho';

  @override
  String get puzzleThemeHookMateDescription => 'Xaque mate cunha torre, cabalo e peón xunto cun peón inimigo que limita a escapada do rei contrario.';

  @override
  String get puzzleThemeInterference => 'Interferencia';

  @override
  String get puzzleThemeInterferenceDescription => 'Colocar unha peza entre dúas do opoñente de modo que unha delas ou ambas as dúas fican indefensas, como pode ser un cabalo nunha casa protexida entre dúas torres.';

  @override
  String get puzzleThemeIntermezzo => 'Xogada intermedia';

  @override
  String get puzzleThemeIntermezzoDescription => 'En troques de facer a xogada agardada, interpoñer un movemento que xera unha ameaza inmediata que forza unha resposta do opoñente. Tamén se di \"Zwischenzug\" ou \"Intermezzo\".';

  @override
  String get puzzleThemeKnightEndgame => 'Final de cabalos';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Un final no que só hai cabalos e peóns.';

  @override
  String get puzzleThemeLong => 'Exercicio longo';

  @override
  String get puzzleThemeLongDescription => 'Gaña en tres xogadas.';

  @override
  String get puzzleThemeMaster => 'Partidas de Mestres';

  @override
  String get puzzleThemeMasterDescription => 'Exercicios de partidas de xogadores titulados.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partidas entre Mestres';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Exercicios de partidas entre xogadores titulados.';

  @override
  String get puzzleThemeMate => 'Xaque mate';

  @override
  String get puzzleThemeMateDescription => 'Gana a partida con estilo.';

  @override
  String get puzzleThemeMateIn1 => 'Mate nun movemento';

  @override
  String get puzzleThemeMateIn1Description => 'Dá xaque mate cun só movemento.';

  @override
  String get puzzleThemeMateIn2 => 'Mate en 2';

  @override
  String get puzzleThemeMateIn2Description => 'Dá xaque mate en dous movementos.';

  @override
  String get puzzleThemeMateIn3 => 'Mate en 3';

  @override
  String get puzzleThemeMateIn3Description => 'Dá xaque mate en tres movementos.';

  @override
  String get puzzleThemeMateIn4 => 'Mate en 4';

  @override
  String get puzzleThemeMateIn4Description => 'Dá xaque mate en catro movementos.';

  @override
  String get puzzleThemeMateIn5 => 'Mate en 5 ou máis';

  @override
  String get puzzleThemeMateIn5Description => 'Calcula unha secuencia de mate longa.';

  @override
  String get puzzleThemeMiddlegame => 'Medio xogo';

  @override
  String get puzzleThemeMiddlegameDescription => 'Táctica durante a segunda fase do xogo.';

  @override
  String get puzzleThemeOneMove => 'Exercicio dun só movemento';

  @override
  String get puzzleThemeOneMoveDescription => 'Un crebacabezas dunha soa xogada.';

  @override
  String get puzzleThemeOpening => 'Apertura';

  @override
  String get puzzleThemeOpeningDescription => 'Táctica durante a primeira fase do xogo.';

  @override
  String get puzzleThemePawnEndgame => 'Final de peóns';

  @override
  String get puzzleThemePawnEndgameDescription => 'Un final no que só hai peóns.';

  @override
  String get puzzleThemePin => 'Cravada';

  @override
  String get puzzleThemePinDescription => 'Unha táctica que involucra cravadas, onde unha peza non se pode mover sen expoñer ó ataque unha peza de maior valor.';

  @override
  String get puzzleThemePromotion => 'Promoción';

  @override
  String get puzzleThemePromotionDescription => 'Coroa un dos teus peóns para convertelo en raíña ou outra peza menor.';

  @override
  String get puzzleThemeQueenEndgame => 'Final de damas';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Un final no que só hai damas e peóns.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Final de dama e torre';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Un final no que só hai damas, torres e peóns.';

  @override
  String get puzzleThemeQueensideAttack => 'Ataque no flanco de dama';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Un ataque sobre o rei do opoñente, despois de que este enrocase en longo.';

  @override
  String get puzzleThemeQuietMove => 'Movemento tranquilo';

  @override
  String get puzzleThemeQuietMoveDescription => 'Unha xogada que non dá xaque nin captura, nin tampouco ameaza con capturar, pero que prepara unha ameaza agochada e inevitable nun movemento posterior.';

  @override
  String get puzzleThemeRookEndgame => 'Final de torres';

  @override
  String get puzzleThemeRookEndgameDescription => 'Un final no que só hai torres e peóns.';

  @override
  String get puzzleThemeSacrifice => 'Sacrificio';

  @override
  String get puzzleThemeSacrificeDescription => 'Unha táctica que implica ceder material a curto prazo, para recuperar a vantaxe logo dunha secuencia forzada de xogadas.';

  @override
  String get puzzleThemeShort => 'Exercicio curto';

  @override
  String get puzzleThemeShortDescription => 'Gaña en dúas xogadas.';

  @override
  String get puzzleThemeSkewer => 'Espeto';

  @override
  String get puzzleThemeSkewerDescription => 'Manobra de cravada inversa na cal unha peza de alto valor é atacada. Ó apartarse, permite capturar ou atacar unha peza de menor valor que se atopa detrás dela.';

  @override
  String get puzzleThemeSmotheredMate => 'Mate da couce';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Un mate de cabalo executado sobre un rei inmobilizado (ou afogado) polas súas propias pezas.';

  @override
  String get puzzleThemeSuperGM => 'Partidas de súper Grandes Mestres';

  @override
  String get puzzleThemeSuperGMDescription => 'Problemas de partidas xogadas polos mellores xogadores do mundo.';

  @override
  String get puzzleThemeTrappedPiece => 'Peza atrapada';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Unha peza non pode evitar ser capturada porque ten limitados os seus movementos.';

  @override
  String get puzzleThemeUnderPromotion => 'Promoción menor';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promoción a un cabalo, alfil ou torre.';

  @override
  String get puzzleThemeVeryLong => 'Exercicio moi longo';

  @override
  String get puzzleThemeVeryLongDescription => 'Gaña en catro ou máis xogadas.';

  @override
  String get puzzleThemeXRayAttack => 'Ataque de raios X';

  @override
  String get puzzleThemeXRayAttackDescription => 'Unha peza ataca ou defende un escaque a través dunha peza do opoñente.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'O rival ten os movementos limitados e calquera xogada que faga empeora a súa posición.';

  @override
  String get puzzleThemeHealthyMix => 'Mestura equilibrada';

  @override
  String get puzzleThemeHealthyMixDescription => 'Un pouco de todo. Non sabes que vai vir, así que prepárate para calquera cousa! Coma nas partidas de verdade.';

  @override
  String get puzzleThemePlayerGames => 'Partidas de xogadores';

  @override
  String get puzzleThemePlayerGamesDescription => 'Busca crebacabezas xerados a partir das túas partidas ou das doutros xogadores.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Estes problemas son de dominio público e poden ser descargados en $param.';
  }

  @override
  String get searchSearch => 'Buscar';

  @override
  String get settingsSettings => 'Configuración';

  @override
  String get settingsCloseAccount => 'Pechar conta';

  @override
  String get settingsManagedAccountCannotBeClosed => 'A túa conta é xestionada e non pode pecharse.';

  @override
  String get settingsClosingIsDefinitive => 'A eliminación da conta é irreversible. Estás seguro de querer continuar?';

  @override
  String get settingsCantOpenSimilarAccount => 'Non se che permitirá abrir outra conta co mesmo nome, nin sequera cambiando maiúsculas e minúsculas.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Cambiei de opinión, non pechedes a miña conta';

  @override
  String get settingsCloseAccountExplanation => 'Estás seguro de que queres eliminar a túa conta? Esta decisión é irreversible. NUNCA poderás volver acceder a ela.';

  @override
  String get settingsThisAccountIsClosed => 'Esta conta foi pechada.';

  @override
  String get playWithAFriend => 'Xogar cun amigo';

  @override
  String get playWithTheMachine => 'Xogar coa a máquina';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Para invitar a alguén a xogar, dálle este URL';

  @override
  String get gameOver => 'Partida rematada';

  @override
  String get waitingForOpponent => 'Agardando un rival';

  @override
  String get orLetYourOpponentScanQrCode => 'Ou deixa que o teu rival escanee este código QR';

  @override
  String get waiting => 'Agardando';

  @override
  String get yourTurn => 'A túa quenda';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 nivel $param2';
  }

  @override
  String get level => 'Nivel';

  @override
  String get strength => 'Forza';

  @override
  String get toggleTheChat => '(Des)activar a sala de conversa';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Abandonar';

  @override
  String get checkmate => 'Xaque mate';

  @override
  String get stalemate => 'Rei afogado';

  @override
  String get white => 'Brancas';

  @override
  String get black => 'Negras';

  @override
  String get asWhite => 'con brancas';

  @override
  String get asBlack => 'con negras';

  @override
  String get randomColor => 'Cor aleatoria';

  @override
  String get createAGame => 'Crear unha partida';

  @override
  String get whiteIsVictorious => 'As brancas gañan';

  @override
  String get blackIsVictorious => 'As negras gañan';

  @override
  String get youPlayTheWhitePieces => 'Xogas coas brancas';

  @override
  String get youPlayTheBlackPieces => 'Xogas coas negras';

  @override
  String get itsYourTurn => 'Tócache!';

  @override
  String get cheatDetected => 'Trampa detectada';

  @override
  String get kingInTheCenter => 'Rei no centro';

  @override
  String get threeChecks => 'Xaque triplo';

  @override
  String get raceFinished => 'Carreira finalizada';

  @override
  String get variantEnding => 'Final da partida por normas desta modalidade';

  @override
  String get newOpponent => 'Novo rival';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'O teu rival quere xogar outra partida contra ti';

  @override
  String get joinTheGame => 'Unirse á partida';

  @override
  String get whitePlays => 'Xogan as brancas';

  @override
  String get blackPlays => 'Xogan as negras';

  @override
  String get opponentLeftChoices => 'O teu opoñente saíu da partida. Poderás reclamar a vitoria, declarar as táboas ou agardar.';

  @override
  String get forceResignation => 'Reclamar a vitoria';

  @override
  String get forceDraw => 'Reclamar as táboas';

  @override
  String get talkInChat => 'Por favor, sé correcto na sala de conversa!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'A primeira persoa que chegue a este URL xogará contra ti';

  @override
  String get whiteResigned => 'As brancas abandonaron';

  @override
  String get blackResigned => 'As negras abandonaron';

  @override
  String get whiteLeftTheGame => 'As brancas saíron da partida';

  @override
  String get blackLeftTheGame => 'As negras saíron da partida';

  @override
  String get whiteDidntMove => 'As brancas non moveron';

  @override
  String get blackDidntMove => 'As negras non moveron';

  @override
  String get requestAComputerAnalysis => 'Solicitar unha análise por computador';

  @override
  String get computerAnalysis => 'Análise por computador';

  @override
  String get computerAnalysisAvailable => 'Análise de ordenador dispoñible';

  @override
  String get computerAnalysisDisabled => 'Análise de ordenador desactivada';

  @override
  String get analysis => 'Taboleiro de análise';

  @override
  String depthX(String param) {
    return 'Profundidade $param';
  }

  @override
  String get usingServerAnalysis => 'Usando análise de servidor';

  @override
  String get loadingEngine => 'Cargando o motor de análise...';

  @override
  String get calculatingMoves => 'Calculando movementos...';

  @override
  String get engineFailed => 'Erro ao cargar o motor de análise';

  @override
  String get cloudAnalysis => 'Análise no servidor';

  @override
  String get goDeeper => 'Con máis detalle';

  @override
  String get showThreat => 'Amosar ameaza';

  @override
  String get inLocalBrowser => 'no navegador local';

  @override
  String get toggleLocalEvaluation => 'Avaliación local';

  @override
  String get promoteVariation => 'Promover variante';

  @override
  String get makeMainLine => 'Converter en liña principal';

  @override
  String get deleteFromHere => 'Borrar desde aquí';

  @override
  String get collapseVariations => 'Contraer as variantes';

  @override
  String get expandVariations => 'Despregar as variantes';

  @override
  String get forceVariation => 'Forzar variante';

  @override
  String get copyVariationPgn => 'Copiar o PGN da variante';

  @override
  String get move => 'Movemento';

  @override
  String get variantLoss => 'Variante perdedora';

  @override
  String get variantWin => 'Variante gañadora';

  @override
  String get insufficientMaterial => 'Material insuficiente';

  @override
  String get pawnMove => 'Movemento de peón';

  @override
  String get capture => 'Captura';

  @override
  String get close => 'Pechar';

  @override
  String get winning => 'Gañador';

  @override
  String get losing => 'Perdedor';

  @override
  String get drawn => 'Leva a táboas';

  @override
  String get unknown => 'Descoñecido';

  @override
  String get database => 'Base de datos';

  @override
  String get whiteDrawBlack => 'Brancas / Táboas / Negras';

  @override
  String averageRatingX(String param) {
    return 'Puntuación media: $param';
  }

  @override
  String get recentGames => 'Partidas recentes';

  @override
  String get topGames => 'Mellores partidas';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Partidas cara a cara de xogadores con Elo FIDE de $param1+, dende $param2 a $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' con redondeo, baseado no número de medias xogadas ata a próxima captura ou movemento de peón';

  @override
  String get noGameFound => 'Non se atoparon partidas';

  @override
  String get maxDepthReached => 'Chegouse á máxima profundidade!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'E se probas a incluír máis partidas dende o menú de preferencias?';

  @override
  String get openings => 'Aperturas';

  @override
  String get openingExplorer => 'Abrir o explorador';

  @override
  String get openingEndgameExplorer => 'Explorador de aperturas/finais';

  @override
  String xOpeningExplorer(String param) {
    return 'Explorador de aperturas $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Xoga o primeiro movemento do explorador de aperturas/finais';

  @override
  String get winPreventedBy50MoveRule => 'Vitoria impedida pola regra das 50 xogadas';

  @override
  String get lossSavedBy50MoveRule => 'Derrota impedida pola regra das 50 xogadas';

  @override
  String get winOr50MovesByPriorMistake => 'Vitoria ou 50 movementos a causa dun erro anterior';

  @override
  String get lossOr50MovesByPriorMistake => 'Derrota ou 50 movementos a causa dun erro anterior';

  @override
  String get unknownDueToRounding => 'A vitoria ou derrota só están garantidas se a liña recomendada da base de datos de finais se seguiu desde a última captura ou movemento de peón, debido a un posible arredondamento dos valores DTZ nas bases de datos de finais Syzygy.';

  @override
  String get allSet => 'Todo listo!';

  @override
  String get importPgn => 'Importar PGN';

  @override
  String get delete => 'Borrar';

  @override
  String get deleteThisImportedGame => 'Borrar esta partida importada?';

  @override
  String get replayMode => 'Modo de repetición';

  @override
  String get realtimeReplay => 'Tempo real';

  @override
  String get byCPL => 'Por PCP';

  @override
  String get openStudy => 'Abrir estudo';

  @override
  String get enable => 'Activar';

  @override
  String get bestMoveArrow => 'Frecha coa mellor xogada';

  @override
  String get showVariationArrows => 'Amosar as frechas das variantes';

  @override
  String get evaluationGauge => 'Indicador de avaliación';

  @override
  String get multipleLines => 'Liñas múltiples';

  @override
  String get cpus => 'Procesadores';

  @override
  String get memory => 'Memoria';

  @override
  String get infiniteAnalysis => 'Análise infinita';

  @override
  String get removesTheDepthLimit => 'Elimina o límite de profundidade, e mantén o teu ordenador quente';

  @override
  String get engineManager => 'Administrador do motor de análise';

  @override
  String get blunder => 'Metida de zoca';

  @override
  String get mistake => 'Erro';

  @override
  String get inaccuracy => 'Imprecisión';

  @override
  String get moveTimes => 'Tempos por movemento';

  @override
  String get flipBoard => 'Xirar o taboleiro';

  @override
  String get threefoldRepetition => 'Repetición tripla de posición';

  @override
  String get claimADraw => 'Reclamar táboas';

  @override
  String get offerDraw => 'Ofrecer táboas';

  @override
  String get draw => 'Táboas';

  @override
  String get drawByMutualAgreement => 'Táboas de mutuo acordo';

  @override
  String get fiftyMovesWithoutProgress => 'Cincuenta movementos sen progreso';

  @override
  String get currentGames => 'Partidas en curso';

  @override
  String get viewInFullSize => 'Ver a tamaño completo';

  @override
  String get logOut => 'Pechar sesión';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get rememberMe => 'Manterme conectado';

  @override
  String get youNeedAnAccountToDoThat => 'Precisas dunha conta de usuario para facer iso';

  @override
  String get signUp => 'Rexistrarse';

  @override
  String get computersAreNotAllowedToPlay => 'Non están permitidos nin os ordenadores nin os xogadores asistidos por eles. Por favor, non te axudes de módulos de xadrez, bases de datos ou doutros xogadores durante a partida. Lembra tamén que o uso de múltiples contas está altamente desaconsellado e que o uso abusivo deste tipo de contas pode conducir á suspensión.';

  @override
  String get games => 'Partidas';

  @override
  String get forum => 'Foro';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 escribiu no fío $param2';
  }

  @override
  String get latestForumPosts => 'Últimas publicacións no foro';

  @override
  String get players => 'Xogadores';

  @override
  String get friends => 'Amizades';

  @override
  String get discussions => 'Conversas';

  @override
  String get today => 'Hoxe';

  @override
  String get yesterday => 'Onte';

  @override
  String get minutesPerSide => 'Minutos por bando';

  @override
  String get variant => 'Variante';

  @override
  String get variants => 'Variantes';

  @override
  String get timeControl => 'Control de tempo';

  @override
  String get realTime => 'Cronometrado';

  @override
  String get correspondence => 'Postal';

  @override
  String get daysPerTurn => 'Días por xogada';

  @override
  String get oneDay => 'Un día';

  @override
  String get time => 'Tempo';

  @override
  String get rating => 'Puntuación';

  @override
  String get ratingStats => 'Estatísticas de puntuación';

  @override
  String get username => 'Nome de usuario';

  @override
  String get usernameOrEmail => 'Nome de usuario ou correo';

  @override
  String get changeUsername => 'Cambiar nome de usuario';

  @override
  String get changeUsernameNotSame => 'Só poden cambiar as letras entre minúsculas e maiúsculas. Por exemplo de \"xoanninguen\" a \"XoanNinguen\".';

  @override
  String get changeUsernameDescription => 'Cambia o teu nome de usuario. Só o poderás facer unha vez e só está permitido cambiar de entre minúsculas e maiúsculas as letras do teu nome de usuario.';

  @override
  String get signupUsernameHint => 'Asegúrate de escoller un nome de usuario axeitado pra todas as idades. Non poderás cambialo máis tarde e calquera conta con nome de usuario inadecuado será pechada!';

  @override
  String get signupEmailHint => 'Só se usará para restablecer o contrasinal.';

  @override
  String get password => 'Contrasinal';

  @override
  String get changePassword => 'Cambiar contrasinal';

  @override
  String get changeEmail => 'Cambiar correo';

  @override
  String get email => 'Correo electrónico';

  @override
  String get passwordReset => 'Cambiar contrasinal';

  @override
  String get forgotPassword => 'Esqueciches o teu contrasinal?';

  @override
  String get error_weakPassword => 'Ese contrasinal é extremadamente común e demasiado doado de adiviñar.';

  @override
  String get error_namePassword => 'Por favor, non uses o teu usuario como contrasinal.';

  @override
  String get blankedPassword => 'Empregaches o mesmo contrasinal noutro sitio e a seguridade dese sitio foi comprometida. Para confirmar a seguridade da túa conta de Lichess, necesitamos que indiques un novo contrasinal. Grazas e perdón polas molestias.';

  @override
  String get youAreLeavingLichess => 'Estas saíndo de Lichess';

  @override
  String get neverTypeYourPassword => 'Nunca empregues o teu contrasinal de Lichess noutro sitio web!';

  @override
  String proceedToX(String param) {
    return 'Ir a $param';
  }

  @override
  String get passwordSuggestion => 'Non empregues un contrasinal suxerido por outra persoa. Poden empregalo para roubar a túa conta.';

  @override
  String get emailSuggestion => 'Non empregues un enderezo de correo suxerido por outra persoa. Poden empregalo para roubar a túa conta.';

  @override
  String get emailConfirmHelp => 'Axuda coa confirmación por correo';

  @override
  String get emailConfirmNotReceived => 'Non recibiches o teu correo de confirmación despois de rexistrarte?';

  @override
  String get whatSignupUsername => 'Que nome de usuario empregaches para rexistrarte?';

  @override
  String usernameNotFound(String param) {
    return 'Non puidemos atopar ningún usuario con este nome: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Podes empregar este nome de usuario para crear unha nova conta';

  @override
  String emailSent(String param) {
    return 'Enviámosche un correo a $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Pode tardar un tempo en chegar.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Agarda 5 minutos e refresca a túa caixa de correo.';

  @override
  String get checkSpamFolder => 'Comproba tamén o teu cartafol de correos non solicitados, puido rematar aí. Se foi así, quítalle a marca de correo non desexado.';

  @override
  String get emailForSignupHelp => 'Se todo falla, entón envíanos un correo:';

  @override
  String copyTextToEmail(String param) {
    return 'Copia e pega o seguinte texto e envíao a $param';
  }

  @override
  String get waitForSignupHelp => 'Volveremos dentro de pouco para axudarche a completar o teu rexistro.';

  @override
  String accountConfirmed(String param) {
    return 'O usuario $param foi confirmado correctamente.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Podes iniciar sesión agora mesmo coma $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Non necesitas un correo de confirmación.';

  @override
  String accountClosed(String param) {
    return 'A conta $param está pechada.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'A conta $param foi rexistrada sen correo electrónico.';
  }

  @override
  String get rank => 'Posición';

  @override
  String rankX(String param) {
    return 'Posición: $param';
  }

  @override
  String get gamesPlayed => 'Partidas xogadas';

  @override
  String get cancel => 'Cancelar';

  @override
  String get whiteTimeOut => 'Acabou o tempo das brancas';

  @override
  String get blackTimeOut => 'Acabou o tempo das negras';

  @override
  String get drawOfferSent => 'Oferta de táboas enviada';

  @override
  String get drawOfferAccepted => 'Oferta de táboas aceptada';

  @override
  String get drawOfferCanceled => 'Oferta de táboas cancelada';

  @override
  String get whiteOffersDraw => 'As brancas ofrecen táboas';

  @override
  String get blackOffersDraw => 'As negras ofrecen táboas';

  @override
  String get whiteDeclinesDraw => 'As brancas rexeitan as táboas';

  @override
  String get blackDeclinesDraw => 'As negras rexeitan as táboas';

  @override
  String get yourOpponentOffersADraw => 'O teu rival ofrece táboas';

  @override
  String get accept => 'Aceptar';

  @override
  String get decline => 'Rexeitar';

  @override
  String get playingRightNow => 'Xogando agora mesmo';

  @override
  String get eventInProgress => 'Xogando agora mesmo';

  @override
  String get finished => 'Finalizado';

  @override
  String get abortGame => 'Abortar partida';

  @override
  String get gameAborted => 'Partida abortada';

  @override
  String get standard => 'Estándar';

  @override
  String get customPosition => 'Posición á medida';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String get mode => 'Modo';

  @override
  String get casual => 'Amigable';

  @override
  String get rated => 'Puntuada';

  @override
  String get casualTournament => 'Amigable';

  @override
  String get ratedTournament => 'Puntuado';

  @override
  String get thisGameIsRated => 'Esta partida é puntuada';

  @override
  String get rematch => 'Desquite';

  @override
  String get rematchOfferSent => 'Oferta de desquite enviada';

  @override
  String get rematchOfferAccepted => 'Oferta de desquite aceptada';

  @override
  String get rematchOfferCanceled => 'Oferta de desquite cancelada';

  @override
  String get rematchOfferDeclined => 'Oferta de desquite rexeitada';

  @override
  String get cancelRematchOffer => 'Cancelar a oferta de desquite';

  @override
  String get viewRematch => 'Ver desquite';

  @override
  String get confirmMove => 'Confirmar a xogada';

  @override
  String get play => 'Xogar';

  @override
  String get inbox => 'Bandexa de entrada';

  @override
  String get chatRoom => 'Sala de conversa';

  @override
  String get loginToChat => 'Inicia sesión para conversar';

  @override
  String get youHaveBeenTimedOut => 'Fuches silenciado temporalmente.';

  @override
  String get spectatorRoom => 'Sala do espectador';

  @override
  String get composeMessage => 'Escribir mensaxe';

  @override
  String get subject => 'Asunto';

  @override
  String get send => 'Enviar';

  @override
  String get incrementInSeconds => 'Incremento en segundos';

  @override
  String get freeOnlineChess => 'Xadrez libre en liña';

  @override
  String get exportGames => 'Exportar partidas';

  @override
  String get ratingRange => 'Rango de puntuación';

  @override
  String get thisAccountViolatedTos => 'Esta conta violou os Termos de Servizo de Lichess';

  @override
  String get openingExplorerAndTablebase => 'Explorador de aperturas e base de datos de finais';

  @override
  String get takeback => 'Rectificar xogada';

  @override
  String get proposeATakeback => 'Propoñer cambio de xogada';

  @override
  String get takebackPropositionSent => 'Proposta de cambio enviada';

  @override
  String get takebackPropositionDeclined => 'Proposta de cambio rexeitada';

  @override
  String get takebackPropositionAccepted => 'Proposta de cambio aceptada';

  @override
  String get takebackPropositionCanceled => 'Proposta de cambio cancelada';

  @override
  String get yourOpponentProposesATakeback => 'O teu rival propón rectificar a xogada';

  @override
  String get bookmarkThisGame => 'Marcar esta partida coma favorita';

  @override
  String get tournament => 'Torneo';

  @override
  String get tournaments => 'Torneos';

  @override
  String get tournamentPoints => 'Puntos en torneos';

  @override
  String get viewTournament => 'Ver torneo';

  @override
  String get backToTournament => 'Voltar ó torneo';

  @override
  String get noDrawBeforeSwissLimit => 'Nos torneos Suízos non se pode ofrecer táboas antes de realizar 30 xogadas.';

  @override
  String get thematic => 'Temático';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'A túa puntuación $param é provisional';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'A túa puntuación $param1 ($param2) é demasiado alta';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'A túa puntuación máxima semanal $param1 ($param2) é demasiado alta';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'A túa puntuación $param1 ($param2) é demasiado baixa';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Puntuación ≥ $param1 en $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Puntuación ≤ $param1 en $param2 na última semana';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Tes que estar no equipo $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Non estás no equipo $param';
  }

  @override
  String get backToGame => 'Voltar á partida';

  @override
  String get siteDescription => 'Xadrez libre en liña. Xoga ó xadrez cunha interface limpa. Sen rexistrarse, sen anuncios, sen necesidade de complementos. Xoga ó xadrez contra o ordenador, amigos ou rivais ó chou.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 uniuse ó equipo $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 creou o equipo $param2';
  }

  @override
  String get startedStreaming => 'comezou unha retransmisión';

  @override
  String xStartedStreaming(String param) {
    return '$param comezou unha retransmisión';
  }

  @override
  String get averageElo => 'Puntuación media';

  @override
  String get location => 'Ubicación';

  @override
  String get filterGames => 'Filtrar partidas';

  @override
  String get reset => 'Restablecer';

  @override
  String get apply => 'Aplicar';

  @override
  String get save => 'Gardar';

  @override
  String get leaderboard => 'Listaxe de líderes';

  @override
  String get screenshotCurrentPosition => 'Fai unha captura de pantalla da posición actual';

  @override
  String get gameAsGIF => 'Gardar a partida en formato GIF';

  @override
  String get pasteTheFenStringHere => 'Pega o texto FEN aquí';

  @override
  String get pasteThePgnStringHere => 'Pega o texto PGN aquí';

  @override
  String get orUploadPgnFile => 'Ou sube un ficheiro PGN';

  @override
  String get fromPosition => 'Dende posición';

  @override
  String get continueFromHere => 'Continuar dende aquí';

  @override
  String get toStudy => 'Estudar';

  @override
  String get importGame => 'Importar partida';

  @override
  String get importGameExplanation => 'Pega o PGN dunha partida para obter unha versión navegable, análise por ordenador, sala de conversa e unha ligazón pública para compartila.';

  @override
  String get importGameCaveat => 'As variantes borraranse. Pra conservalas, importa o PGN mediante un estudo.';

  @override
  String get importGameDataPrivacyWarning => 'Este PGN é de acceso público. Para importar unha partida de xeito privado, emprega un estudo.';

  @override
  String get thisIsAChessCaptcha => 'Isto é un CAPTCHA de xadrez.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Preme no taboleiro para facer a túa xogada e demostrar que es humano.';

  @override
  String get captcha_fail => 'Por favor resolve o CAPTCHA de xadrez.';

  @override
  String get notACheckmate => 'Non é xaque mate.';

  @override
  String get whiteCheckmatesInOneMove => 'Xogas brancas e dan mate nunha';

  @override
  String get blackCheckmatesInOneMove => 'Xogas negras e dan mate nunha';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get reconnecting => 'Conectando de novo';

  @override
  String get noNetwork => 'Desconectado';

  @override
  String get favoriteOpponents => 'Rivais preferidos';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Seguindo';

  @override
  String get unfollow => 'Deixar de seguir';

  @override
  String followX(String param) {
    return 'Seguir a $param';
  }

  @override
  String unfollowX(String param) {
    return 'Deixar de seguir a $param';
  }

  @override
  String get block => 'Bloquear';

  @override
  String get blocked => 'Bloqueado';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get followsYou => 'Séguete';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 comezou a seguir a $param2';
  }

  @override
  String get more => 'Máis';

  @override
  String get memberSince => 'Membro dende';

  @override
  String lastSeenActive(String param) {
    return 'Última conexión $param';
  }

  @override
  String get player => 'Xogador';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Gráfica';

  @override
  String get required => 'Obrigatorio.';

  @override
  String get openTournaments => 'Torneos abertos';

  @override
  String get duration => 'Duración';

  @override
  String get winner => 'Gañador';

  @override
  String get standing => 'Posición';

  @override
  String get createANewTournament => 'Crear un novo torneo';

  @override
  String get tournamentCalendar => 'Calendario de torneos';

  @override
  String get conditionOfEntry => 'Condicións de participación:';

  @override
  String get advancedSettings => 'Axustes avanzados';

  @override
  String get safeTournamentName => 'Escolle un nome seguro para o torneo.';

  @override
  String get inappropriateNameWarning => 'Calquera comportamento minimamente inadecuado podería levar ao peche da túa conta.';

  @override
  String get emptyTournamentName => 'Deixar en branco para poñerlle ó torneo o nome dun Grande Mestre notable.';

  @override
  String get makePrivateTournament => 'Fai que o torneo sexa privado e restrinxe o acceso cun contrasinal';

  @override
  String get join => 'Unirse';

  @override
  String get withdraw => 'Retirarse';

  @override
  String get points => 'Puntos';

  @override
  String get wins => 'Vitorias';

  @override
  String get losses => 'Derrotas';

  @override
  String get createdBy => 'Creado por';

  @override
  String get tournamentIsStarting => 'O torneo vai comezar';

  @override
  String get tournamentPairingsAreNowClosed => 'Os emparellamentos do torneo xa están pechados.';

  @override
  String standByX(String param) {
    return 'Agarda $param, emparellando xogadores, prepárate!';
  }

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Continuar';

  @override
  String get youArePlaying => 'Estás xogando!';

  @override
  String get winRate => 'Porcentaxe de vitorias';

  @override
  String get berserkRate => 'Porcentaxe de berserk';

  @override
  String get performance => 'Rendemento';

  @override
  String get tournamentComplete => 'Torneo rematado';

  @override
  String get movesPlayed => 'Movementos xogados';

  @override
  String get whiteWins => 'Vitorias das brancas';

  @override
  String get blackWins => 'Vitorias das negras';

  @override
  String get drawRate => 'Taxa de táboas';

  @override
  String get draws => 'Táboas';

  @override
  String nextXTournament(String param) {
    return 'Seguinte torneo $param:';
  }

  @override
  String get averageOpponent => 'Opoñente medio';

  @override
  String get boardEditor => 'Editor de taboleiro';

  @override
  String get setTheBoard => 'Configurar o taboleiro';

  @override
  String get popularOpenings => 'Aperturas populares';

  @override
  String get endgamePositions => 'Posicións de finais';

  @override
  String chess960StartPosition(String param) {
    return 'Posición inicial de Chess960: $param';
  }

  @override
  String get startPosition => 'Posición inicial';

  @override
  String get clearBoard => 'Limpar o taboleiro';

  @override
  String get loadPosition => 'Cargar unha posición';

  @override
  String get isPrivate => 'Privado';

  @override
  String reportXToModerators(String param) {
    return 'Denunciar a $param ós moderadores';
  }

  @override
  String profileCompletion(String param) {
    return 'Perfil completado ao $param';
  }

  @override
  String xRating(String param) {
    return 'Puntuación $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Se non aplica, déixao en branco';

  @override
  String get profile => 'Perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get realName => 'Nome real';

  @override
  String get setFlair => 'Escolle a túa habelencia';

  @override
  String get flair => 'Habelencia';

  @override
  String get youCanHideFlair => 'Nas preferencias podes agochar por completo as habelencias dos xogadores en todo o sitio.';

  @override
  String get biography => 'Biografía';

  @override
  String get countryRegion => 'País ou rexión';

  @override
  String get thankYou => 'Grazas!';

  @override
  String get socialMediaLinks => 'Ligazóns ás redes sociais';

  @override
  String get oneUrlPerLine => 'Unha URL por liña.';

  @override
  String get inlineNotation => 'Notación compacta';

  @override
  String get makeAStudy => 'Para gardar e partillar, conviña crear un estudo.';

  @override
  String get clearSavedMoves => 'Eliminar movementos';

  @override
  String get previouslyOnLichessTV => 'Previamente en Lichess TV';

  @override
  String get onlinePlayers => 'Xogadores en liña';

  @override
  String get activePlayers => 'Xogadores activos';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Atención, a partida é puntuada pero sen límite de tempo!';

  @override
  String get success => 'Éxito';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Pasar automaticamente á seguinte partida despois de mover';

  @override
  String get autoSwitch => 'Auto-cambio';

  @override
  String get puzzles => 'Problemas';

  @override
  String get onlineBots => 'Bots en liña';

  @override
  String get name => 'Nome';

  @override
  String get description => 'Descrición';

  @override
  String get descPrivate => 'Descrición privada';

  @override
  String get descPrivateHelp => 'Texto que só verán os membros do equipo. Se se emprega, substitúe á descrición pública cando sexa visto polos membros do equipo.';

  @override
  String get no => 'Non';

  @override
  String get yes => 'Si';

  @override
  String get help => 'Axuda:';

  @override
  String get createANewTopic => 'Crear novo tema';

  @override
  String get topics => 'Temas';

  @override
  String get posts => 'Entradas';

  @override
  String get lastPost => 'Última entrada';

  @override
  String get views => 'Visitas';

  @override
  String get replies => 'Respostas';

  @override
  String get replyToThisTopic => 'Responder a este tema';

  @override
  String get reply => 'Responder';

  @override
  String get message => 'Mensaxe';

  @override
  String get createTheTopic => 'Crear o tema';

  @override
  String get reportAUser => 'Denunciar a un usuario';

  @override
  String get user => 'Usuario';

  @override
  String get reason => 'Motivo';

  @override
  String get whatIsIheMatter => 'Que pasou?';

  @override
  String get cheat => 'Trampa';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Outro';

  @override
  String get reportDescriptionHelp => 'Pega a ligazón á(s) partida(s) e explica o que é incorrecto no comportamento deste usuario. Non digas só \"fai trampas\", cóntanos como chegaches a esa conclusión. A túa denuncia será procesada máis rapidamente se está escrita en inglés.';

  @override
  String get error_provideOneCheatedGameLink => 'Por favor, incorpora cando menos unha ligazón a unha partida na que se fixeron trampas.';

  @override
  String by(String param) {
    return 'por $param';
  }

  @override
  String importedByX(String param) {
    return 'Importado por $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Este tema xa está pechado.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notas';

  @override
  String get typePrivateNotesHere => 'Escribe notas privadas aquí';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Escribe unha nota privada sobre este usuario';

  @override
  String get noNoteYet => 'Aínda non hai notas';

  @override
  String get invalidUsernameOrPassword => 'Nome de usuario ou contrasinal non válidos';

  @override
  String get incorrectPassword => 'Contrasinal incorrecto';

  @override
  String get invalidAuthenticationCode => 'Código de autenticación inválido';

  @override
  String get emailMeALink => 'Mándame unha ligazón por correo';

  @override
  String get currentPassword => 'Contrasinal actual';

  @override
  String get newPassword => 'Novo contrasinal';

  @override
  String get newPasswordAgain => 'Novo contrasinal (de novo)';

  @override
  String get newPasswordsDontMatch => 'Os contrasinais novos non coinciden';

  @override
  String get newPasswordStrength => 'Seguridade do contrasinal';

  @override
  String get clockInitialTime => 'Tempo inicial do reloxo';

  @override
  String get clockIncrement => 'Incremento do reloxo';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get letOtherPlayersFollowYou => 'Permitir que outros xogadores te sigan';

  @override
  String get letOtherPlayersChallengeYou => 'Permitir que outros xogadores te reten';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Permite que outros xogadores te conviden a estudos';

  @override
  String get sound => 'Son';

  @override
  String get none => 'Ningunha';

  @override
  String get fast => 'Rápida';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Lenta';

  @override
  String get insideTheBoard => 'Dentro do taboleiro';

  @override
  String get outsideTheBoard => 'Fóra do taboleiro';

  @override
  String get allSquaresOfTheBoard => 'Todas as casas do taboleiro';

  @override
  String get onSlowGames => 'En partidas lentas';

  @override
  String get always => 'Sempre';

  @override
  String get never => 'Nunca';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 participa en $param2';
  }

  @override
  String get victory => 'Vitoria';

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
  String get timeline => 'Cronoloxía';

  @override
  String get starting => 'Comezo:';

  @override
  String get allInformationIsPublicAndOptional => 'Toda a información é pública e opcional.';

  @override
  String get biographyDescription => 'Cóntanos sobre ti, os teus intereses, que che gusta do xadrez, as túas aperturas e xogadores preferidos…';

  @override
  String get listBlockedPlayers => 'Listar os xogadores que bloqueaches';

  @override
  String get human => 'Humano';

  @override
  String get computer => 'Máquina';

  @override
  String get side => 'Bando';

  @override
  String get clock => 'Reloxo';

  @override
  String get opponent => 'Rival';

  @override
  String get learnMenu => 'Aprender';

  @override
  String get studyMenu => 'Estudar';

  @override
  String get practice => 'Practicar';

  @override
  String get community => 'Comunidade';

  @override
  String get tools => 'Ferramentas';

  @override
  String get increment => 'Incremento';

  @override
  String get error_unknown => 'Valor non válido';

  @override
  String get error_required => 'Este campo é obrigatorio';

  @override
  String get error_email => 'Este enderezo de correo non é válido';

  @override
  String get error_email_acceptable => 'Este enderezo de correo non é aceptable. Por favor, volve comprobalo e téntao de novo.';

  @override
  String get error_email_unique => 'Este enderezo de correo non é válido ou xa foi empregado';

  @override
  String get error_email_different => 'Este xa é o teu enderezo de correo electrónico';

  @override
  String error_minLength(String param) {
    return 'A lonxitude mínima é de $param caracteres';
  }

  @override
  String error_maxLength(String param) {
    return 'A lonxitude máxima é de $param caracteres';
  }

  @override
  String error_min(String param) {
    return 'Debe ser maior ou igual que $param';
  }

  @override
  String error_max(String param) {
    return 'Debe ser menor ou igual que $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Se a puntuación é ± $param';
  }

  @override
  String get ifRegistered => 'Se está rexistrado/a';

  @override
  String get onlyExistingConversations => 'Só conversas existentes';

  @override
  String get onlyFriends => 'Só amigos';

  @override
  String get menu => 'Menú';

  @override
  String get castling => 'Enroque';

  @override
  String get whiteCastlingKingside => 'Brancas O-O';

  @override
  String get blackCastlingKingside => 'Negras O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tempo xogando: $param';
  }

  @override
  String get watchGames => 'Ver partidas';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tempo en TV: $param';
  }

  @override
  String get watch => 'Ver';

  @override
  String get videoLibrary => 'Videoteca';

  @override
  String get streamersMenu => 'Presentadores';

  @override
  String get mobileApp => 'Aplicación Móbil';

  @override
  String get webmasters => 'Administradores web';

  @override
  String get about => 'Acerca de';

  @override
  String aboutX(String param) {
    return 'Acerca de $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 é un servidor de xadrez de código aberto, gratuíto ($param2), libre, e sen publicidade.';
  }

  @override
  String get really => 'de verdade';

  @override
  String get contribute => 'Contribuír';

  @override
  String get termsOfService => 'Termos do Servizo';

  @override
  String get sourceCode => 'Código Fonte';

  @override
  String get simultaneousExhibitions => 'Exhibicións simultáneas';

  @override
  String get host => 'Anfitrión';

  @override
  String hostColorX(String param) {
    return 'Cor do anfitrión: $param';
  }

  @override
  String get yourPendingSimuls => 'As túas simultáneas pendentes';

  @override
  String get createdSimuls => 'Simultáneas creadas recentemente';

  @override
  String get hostANewSimul => 'Crear unha nova simultánea';

  @override
  String get signUpToHostOrJoinASimul => 'Rexístrate para crear ou unirte a unhas simultáneas';

  @override
  String get noSimulFound => 'Simultánea non atopada';

  @override
  String get noSimulExplanation => 'Esta exhibición simultánea non existe.';

  @override
  String get returnToSimulHomepage => 'Volver á paxina principal das simultáneas';

  @override
  String get aboutSimul => 'As simultáneas son partidas dun xogador contra varios ó mesmo tempo.';

  @override
  String get aboutSimulImage => 'De 50 rivais, Fischer gañou 47 partidas, empatou 2 e perdeu 1.';

  @override
  String get aboutSimulRealLife => 'O concepto tómase de eventos reais. Nestes, o anfitrión das simultáneas móvese de mesa en mesa e fai unha xogada de cada vez.';

  @override
  String get aboutSimulRules => 'Cando as simultáneas comezan, cada xogador inicia unha partida contra o anfitrión. As simultáneas finalizan cando todas as partidas rematan.';

  @override
  String get aboutSimulSettings => 'As simultáneas son sempre amigables. As opcións de desquite, de desfacer a xogada e de engadir tempo non están activadas.';

  @override
  String get create => 'Crear';

  @override
  String get whenCreateSimul => 'Cando creas unha exhibición de simultáneas, tes que enfrontarte a varios xogadores ó mesmo tempo.';

  @override
  String get simulVariantsHint => 'Se seleccionas distintas variantes, cada xogador pode escoller cal xogar.';

  @override
  String get simulClockHint => 'Modo Fischer de reloxo. Cantos máis xogadores, máis tempo necesitas.';

  @override
  String get simulAddExtraTime => 'Podes engadir tempo extra ó teu reloxo para axudarte coas simultáneas.';

  @override
  String get simulHostExtraTime => 'Tempo extra para o anfitrión';

  @override
  String get simulAddExtraTimePerPlayer => 'Engadir tempo inicial ao teu reloxo por cada xogador que se una ás simultáneas.';

  @override
  String get simulHostExtraTimePerPlayer => 'Tempo extra do anfitrión por cada xogador';

  @override
  String get lichessTournaments => 'Torneos de Lichess';

  @override
  String get tournamentFAQ => 'Preguntas Frecuentes dos torneos Arena';

  @override
  String get timeBeforeTournamentStarts => 'Tempo antes de que o torneo comece';

  @override
  String get averageCentipawnLoss => 'Perda media de centipeóns';

  @override
  String get accuracy => 'Precisión';

  @override
  String get keyboardShortcuts => 'Atallos do teclado';

  @override
  String get keyMoveBackwardOrForward => 'mover atrás/adiante';

  @override
  String get keyGoToStartOrEnd => 'Ir ó comezo/remate';

  @override
  String get keyCycleSelectedVariation => 'Cambia a variante seleccionada';

  @override
  String get keyShowOrHideComments => 'mostrar/ocultar comentarios';

  @override
  String get keyEnterOrExitVariation => 'Entrar/saír da variante';

  @override
  String get keyRequestComputerAnalysis => 'Solicita unha análise por computador, Aprende dos teus erros';

  @override
  String get keyNextLearnFromYourMistakes => 'Seguinte (Aprende dos teus erros)';

  @override
  String get keyNextBlunder => 'Seguinte metida de zoca';

  @override
  String get keyNextMistake => 'Seguinte erro';

  @override
  String get keyNextInaccuracy => 'Seguinte imprecisión';

  @override
  String get keyPreviousBranch => 'Rama anterior';

  @override
  String get keyNextBranch => 'Rama seguinte';

  @override
  String get toggleVariationArrows => 'Activar/desactivar as frechas das variantes';

  @override
  String get cyclePreviousOrNextVariation => 'Variante anterior/seguinte';

  @override
  String get toggleGlyphAnnotations => 'Activar/desactivar as anotacións con símbolos';

  @override
  String get togglePositionAnnotations => 'Alternar anotaciones de posición';

  @override
  String get variationArrowsInfo => 'As frechas das variantes permítenche navegar sen usar a lista de movementos.';

  @override
  String get playSelectedMove => 'facer a xogada seleccionada';

  @override
  String get newTournament => 'Novo torneo';

  @override
  String get tournamentHomeTitle => 'Torneos de xadrez con varios controis de tempo e variantes';

  @override
  String get tournamentHomeDescription => 'Xoga torneos de xadrez rápidos! Únete a un torneo oficial programado, ou crea un de teu. Bala, Lóstrego, Clásico, Xadrez960, Rei da Cuíña, Tres Xaques, e máis opcións dispoñibles para que non remate a diversión do xadrez.';

  @override
  String get tournamentNotFound => 'Torneo non atopado';

  @override
  String get tournamentDoesNotExist => 'Este torneo non existe.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Poida que fose cancelado, se todos os xogadores marcharon antes de que o torneo comezase.';

  @override
  String get returnToTournamentsHomepage => 'Volver a páxina principal dos torneos';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Distribución semanal da puntuación en $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'A túa puntuación en $param1 é $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Es mellor có $param1 dos xogadores de $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 é mellor có $param2 dos xogadores de $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Mellor có $param1 dos xogadores de $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Non tes unha puntuación establecida en $param.';
  }

  @override
  String get yourRating => 'A túa puntuación';

  @override
  String get cumulative => 'Acumulado';

  @override
  String get glicko2Rating => 'Puntuación Glicko-2';

  @override
  String get checkYourEmail => 'Revisa o teu correo';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Enviámosche un correo electrónico. Preme na ligazón do correo para activares a túa conta.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Se non ves o correo, revisa noutros cartafoles onde poida estar, coma no lixo, co correo non desexado ou de redes sociais.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Enviámosche un correo a $param. Segue a ligazón no correo para restaurar o teu contrasinal.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Ó rexistrarte, aceptas os nosos $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Le acerca da nosa $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Retardo da conexión entre ti e máis Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tempo para procesar un movemento no servidor de Lichess';

  @override
  String get downloadAnnotated => 'Descargar anotada';

  @override
  String get downloadRaw => 'Descargar sen anotar';

  @override
  String get downloadImported => 'Descargar importadas';

  @override
  String get crosstable => 'Táboa de cruces';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Tamén podes usar a roda do rato sobre o taboleiro para moverte pola partida.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Pasa o punteiro sobre as variantes da computadora para visualizalas.';

  @override
  String get analysisShapesHowTo => 'Pulsa Maiúsculas+clic ou preme o botón dereito do rato para debuxar círculos e frechas no taboleiro.';

  @override
  String get letOtherPlayersMessageYou => 'Permitir que outros xogadores che envíen mensaxes';

  @override
  String get receiveForumNotifications => 'Recibe notificacións cando alguén te mencione no foro';

  @override
  String get shareYourInsightsData => 'Compartir os teus datos estatísticos';

  @override
  String get withNobody => 'Con ninguén';

  @override
  String get withFriends => 'Cos teus amigos';

  @override
  String get withEverybody => 'Con todo o mundo';

  @override
  String get kidMode => 'Modo infantil';

  @override
  String get kidModeIsEnabled => 'O modo infantil está activado.';

  @override
  String get kidModeExplanation => 'Por seguridade, no modo infantil desactívanse tódalas comunicacións. Activa isto para protexer aos teus nenos ou alumnos de outros usuarios de Internet.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'En modo infantil, o logo de Lichess ten unha icona de $param, indicando que os nenos están seguros.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'A túa conta é xestionada. Pídelle ó teu mestre que desactive o modo infantil.';

  @override
  String get enableKidMode => 'Activar modo infantil';

  @override
  String get disableKidMode => 'Desactivar modo infantil';

  @override
  String get security => 'Seguridade';

  @override
  String get sessions => 'Sesións';

  @override
  String get revokeAllSessions => 'pechar todas as sesións';

  @override
  String get playChessEverywhere => 'Xoga ó xadrez en todas partes';

  @override
  String get asFreeAsLichess => 'Tan libre coma Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Construído por amor ó xadrez, non ó diñeiro';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Todo o mundo obtén todas as funcións gratis';

  @override
  String get zeroAdvertisement => 'Sen anuncios';

  @override
  String get fullFeatured => 'Repleta de funcións';

  @override
  String get phoneAndTablet => 'Teléfono e tableta';

  @override
  String get bulletBlitzClassical => 'Bala, lóstrego, clásico';

  @override
  String get correspondenceChess => 'Xadrez postal';

  @override
  String get onlineAndOfflinePlay => 'Xogar en liña ou sen conexión';

  @override
  String get viewTheSolution => 'Mirar a solución';

  @override
  String get followAndChallengeFriends => 'Segue e reta ós teus amigos';

  @override
  String get gameAnalysis => 'Análise da partida';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 crea $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 únese a $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return 'A $param1 gústalle $param2';
  }

  @override
  String get quickPairing => 'Emparellamento rápido';

  @override
  String get lobby => 'Retos';

  @override
  String get anonymous => 'Anónimo';

  @override
  String yourScore(String param) {
    return 'Os teus resultados: $param';
  }

  @override
  String get language => 'Idioma';

  @override
  String get background => 'Fondo';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get transparent => 'Transparente';

  @override
  String get deviceTheme => 'Tema do dispositivo';

  @override
  String get backgroundImageUrl => 'URL da imaxe de fondo:';

  @override
  String get board => 'Taboleiro';

  @override
  String get size => 'Tamaño';

  @override
  String get opacity => 'Opacidade';

  @override
  String get brightness => 'Brillo';

  @override
  String get hue => 'Matiz';

  @override
  String get boardReset => 'Restaurar ás cores por defecto';

  @override
  String get pieceSet => 'Estilo das pezas';

  @override
  String get embedInYourWebsite => 'Incrustar na túa páxina web';

  @override
  String get usernameAlreadyUsed => 'Este nome de usuario xa está en uso. Proba outro, por favor.';

  @override
  String get usernamePrefixInvalid => 'O nome de usuario debe comezar cunha letra.';

  @override
  String get usernameSuffixInvalid => 'O nome de usuario debe rematar cunha letra ou cun número.';

  @override
  String get usernameCharsInvalid => 'O nome de usuario só pode conter letras, números, trazos baixos e guións. Os trazos baixos e guións consecutivos non se permiten.';

  @override
  String get usernameUnacceptable => 'Este nome de usuario non é aceptable.';

  @override
  String get playChessInStyle => 'Xogar ao xadrez con estilo';

  @override
  String get chessBasics => 'Fundamentos de xadrez';

  @override
  String get coaches => 'Adestradores';

  @override
  String get invalidPgn => 'PGN non válido';

  @override
  String get invalidFen => 'FEN non válido';

  @override
  String get custom => 'Á medida';

  @override
  String get notifications => 'Notificacións';

  @override
  String notificationsX(String param1) {
    return 'Notificacións: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Puntuación: $param';
  }

  @override
  String get practiceWithComputer => 'Practicar coa computadora';

  @override
  String anotherWasX(String param) {
    return 'Outro era $param';
  }

  @override
  String bestWasX(String param) {
    return 'O mellor era $param';
  }

  @override
  String get youBrowsedAway => 'Saíches da revisión';

  @override
  String get resumePractice => 'Seguir practicando';

  @override
  String get drawByFiftyMoves => 'A partida rematou en táboas pola regra dos cincuenta movementos.';

  @override
  String get theGameIsADraw => 'A partida remata en táboas.';

  @override
  String get computerThinking => 'Computadora pensando...';

  @override
  String get seeBestMove => 'Ver o mellor movemento';

  @override
  String get hideBestMove => 'Ocultar o mellor movemento';

  @override
  String get getAHint => 'Obter unha pista';

  @override
  String get evaluatingYourMove => 'Avaliando o teu movemento...';

  @override
  String get whiteWinsGame => 'As brancas gañan';

  @override
  String get blackWinsGame => 'As negras gañan';

  @override
  String get learnFromYourMistakes => 'Aprende dos teus erros';

  @override
  String get learnFromThisMistake => 'Aprende deste erro';

  @override
  String get skipThisMove => 'Salta este movemento';

  @override
  String get next => 'Seguinte';

  @override
  String xWasPlayed(String param) {
    return '$param foi xogado';
  }

  @override
  String get findBetterMoveForWhite => 'Encontra un movemento mellor para as brancas';

  @override
  String get findBetterMoveForBlack => 'Encontra un movemento mellor para as negras';

  @override
  String get resumeLearning => 'Retomar avaliación';

  @override
  String get youCanDoBetter => 'Podes facelo mellor';

  @override
  String get tryAnotherMoveForWhite => 'Tenta outro movemento para as brancas';

  @override
  String get tryAnotherMoveForBlack => 'Tenta outro movemento para as negras';

  @override
  String get solution => 'Solución';

  @override
  String get waitingForAnalysis => 'Agardando análise';

  @override
  String get noMistakesFoundForWhite => 'Non hai erros das brancas';

  @override
  String get noMistakesFoundForBlack => 'Non hai erros das negras';

  @override
  String get doneReviewingWhiteMistakes => 'Terminada a revisión de erros das brancas';

  @override
  String get doneReviewingBlackMistakes => 'Terminada a revisión de erros das negras';

  @override
  String get doItAgain => 'Faino de novo';

  @override
  String get reviewWhiteMistakes => 'Revisar os erros das brancas';

  @override
  String get reviewBlackMistakes => 'Revisar os erros das negras';

  @override
  String get advantage => 'Vantaxe';

  @override
  String get opening => 'Apertura';

  @override
  String get middlegame => 'Medio xogo';

  @override
  String get endgame => 'Final';

  @override
  String get conditionalPremoves => 'Premovementos condicionais';

  @override
  String get addCurrentVariation => 'Engadir a variante actual';

  @override
  String get playVariationToCreateConditionalPremoves => 'Xogar unha variante para crear premovementos condicionais';

  @override
  String get noConditionalPremoves => 'Sen premovementos condicionais';

  @override
  String playX(String param) {
    return 'Xogar $param';
  }

  @override
  String get showUnreadLichessMessage => 'Recibiches unha mensaxe privada de Lichess.';

  @override
  String get clickHereToReadIt => 'Fai clic aquí para lela';

  @override
  String get sorry => 'Sentímolo :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Tivemos que suspenderte temporalmente.';

  @override
  String get why => 'Por que?';

  @override
  String get pleasantChessExperience => 'O noso obxectivo é proporcionar unha experiencia amena no xadrez pra todo o mundo.';

  @override
  String get goodPractice => 'Para iso, debemos asegurarnos de que todos os xogadores se comportan como é debido.';

  @override
  String get potentialProblem => 'Cando detectamos un posible problema, mostramos esta mensaxe.';

  @override
  String get howToAvoidThis => 'Como evitar isto?';

  @override
  String get playEveryGame => 'Xoga todas as partidas que comeces.';

  @override
  String get tryToWin => 'Intenta gañar (ou polo menos empatar) todas as partidas que xogues.';

  @override
  String get resignLostGames => 'Abandona nas partidas perdidas (non deixes que remate o tempo).';

  @override
  String get temporaryInconvenience => 'Pedímosche desculpas polas molestias,';

  @override
  String get wishYouGreatGames => 'e desexámosche grandes partidas en lichess.org.';

  @override
  String get thankYouForReading => 'Grazas por pararte a ler isto!';

  @override
  String get lifetimeScore => 'Marcador histórico';

  @override
  String get currentMatchScore => 'Resultados deste enfrontamento';

  @override
  String get agreementAssistance => 'Comprométome a non recibir axuda externa durante as miñas partidas (dun computador, libro, base de datos ou doutra persoa).';

  @override
  String get agreementNice => 'Comprométome a respectar sempre aos outros xogadores.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Comprométome a non crear múltiples contas (excepto polas razóns indicadas nos $param).';
  }

  @override
  String get agreementPolicy => 'Comprométome a seguir as normas de Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Busca ou comeza unha nova conversa';

  @override
  String get edit => 'Editar';

  @override
  String get bullet => 'Bala';

  @override
  String get blitz => 'Lóstrego';

  @override
  String get rapid => 'Rápidas';

  @override
  String get classical => 'Clásicas';

  @override
  String get ultraBulletDesc => 'Partidas incriblemente rápidas: menos de 30 segundos';

  @override
  String get bulletDesc => 'Partidas moi rápidas: menos de 3 minutos';

  @override
  String get blitzDesc => 'Partidas rápidas: de 3 a 8 minutos';

  @override
  String get rapidDesc => 'Partidas rápidas: de 8 a 25 minutos';

  @override
  String get classicalDesc => 'Partidas clásicas: 25 minutos ou máis';

  @override
  String get correspondenceDesc => 'Partidas por correspondencia: un ou varios días por xogada';

  @override
  String get puzzleDesc => 'Adestrador de tácticas de xadrez';

  @override
  String get important => 'Importante';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Pode que a túa pregunta xa teña resposta $param1';
  }

  @override
  String get inTheFAQ => 'nas preguntas frecuentes.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Para denunciar a un usuario por tramposo ou por mal comportamento, $param1';
  }

  @override
  String get useTheReportForm => 'usa o formulario correspondente';

  @override
  String toRequestSupport(String param1) {
    return 'Para solicitar axuda, $param1';
  }

  @override
  String get tryTheContactPage => 'proba a páxina de contacto';

  @override
  String makeSureToRead(String param1) {
    return 'Asegúrate de ler $param1';
  }

  @override
  String get theForumEtiquette => 'a etiqueta do foro';

  @override
  String get thisTopicIsArchived => 'Este tema foi arquivado e non admite respostas.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Únete a $param1 para publicar neste foro';
  }

  @override
  String teamNamedX(String param1) {
    return 'equipo $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Aínda non podes publicar nos foros. Xoga algunhas partidas!';

  @override
  String get subscribe => 'Subscribirse';

  @override
  String get unsubscribe => 'Cancelar a subscrición';

  @override
  String mentionedYouInX(String param1) {
    return 'mencionoute en \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 mencionoute en \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'invitoute a \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 invitoute a \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Agora formas parte do equipo.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Unícheste a \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Alguén a quen denunciaches foi suspendido';

  @override
  String get congratsYouWon => 'Parabéns, gañaches!';

  @override
  String gameVsX(String param1) {
    return 'Partida contra $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 contra $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Perdiches con alguén que incumpriu as condicións de servizo de Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Recuperaches $param1 puntos en $param2.';
  }

  @override
  String get timeAlmostUp => 'Quédache pouco tempo!';

  @override
  String get clickToRevealEmailAddress => '[Pincha para ver o correo electrónico]';

  @override
  String get download => 'Descarga';

  @override
  String get coachManager => 'Administrador de adestradores';

  @override
  String get streamerManager => 'Administrador de presentadores';

  @override
  String get cancelTournament => 'Cancelar o torneo';

  @override
  String get tournDescription => 'Descrición do torneo';

  @override
  String get tournDescriptionHelp => 'Queres dicirlles algo en especial ós participantes? Tenta ser breve. Hai dispoñibles ligazóns de Markdown: [name](https://url)';

  @override
  String get ratedFormHelp => 'As partidas son puntuadas\ne afectan ás puntuacións dos xogadores';

  @override
  String get onlyMembersOfTeam => 'Só membros do equipo';

  @override
  String get noRestriction => 'Sen restrición';

  @override
  String get minimumRatedGames => 'Mínimo de partidas puntuadas';

  @override
  String get minimumRating => 'Puntuación mínima';

  @override
  String get maximumWeeklyRating => 'Máxima puntuación semanal';

  @override
  String positionInputHelp(String param) {
    return 'Pega un FEN válido para comezar as partidas dende unha posición determinada.\nSó funciona en partidas estándar, non en variantes.\nPodes empregar o $param para xerar unha posición FEN e despois pegala aquí.\nDeixa en branco para comezar as partidas dende a posición inicial normal.';
  }

  @override
  String get cancelSimul => 'Cancela as simultáneas';

  @override
  String get simulHostcolor => 'Cor do anfitrión para cada partida';

  @override
  String get estimatedStart => 'Tempo estimado de comezo';

  @override
  String simulFeatured(String param) {
    return 'Amosar simultánea en $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Amosar as simultáneas publicamente en $param. Desactivar nas simultáneas privadas.';
  }

  @override
  String get simulDescription => 'Descrición das simultáneas';

  @override
  String get simulDescriptionHelp => 'Queres dicirlle algo ós participantes?';

  @override
  String markdownAvailable(String param) {
    return '$param está dispoñíbel para unha sintaxe máis avanzada.';
  }

  @override
  String get embedsAvailable => 'Pega unha ligazón dunha partida ou dun capítulo dun estudo para incrustala.';

  @override
  String get inYourLocalTimezone => 'Na túa zona horaria';

  @override
  String get tournChat => 'Sala de conversa do torneo';

  @override
  String get noChat => 'Sen sala de conversa';

  @override
  String get onlyTeamLeaders => 'Só líderes de equipo';

  @override
  String get onlyTeamMembers => 'Só membros do equipo';

  @override
  String get navigateMoveTree => 'Desprazarse pola lista de movementos';

  @override
  String get mouseTricks => 'Trucos co rato';

  @override
  String get toggleLocalAnalysis => 'Activar/desactivar a análise local no navegador';

  @override
  String get toggleAllAnalysis => 'Activar/desactivar todas as análises por computador';

  @override
  String get playComputerMove => 'Xogar o mellor movemento da computadora';

  @override
  String get analysisOptions => 'Opcións de análise';

  @override
  String get focusChat => 'Poñer o cursor na sala de conversa';

  @override
  String get showHelpDialog => 'Amosa este diálogo de axuda';

  @override
  String get reopenYourAccount => 'Abre de novo a túa conta';

  @override
  String get closedAccountChangedMind => 'Se pechaches a túa conta pero mudaches de idea, tes unha oportunidade de volver a reactivala.';

  @override
  String get onlyWorksOnce => 'Só funcionará unha vez.';

  @override
  String get cantDoThisTwice => 'Se pechas a túa conta de novo, non haberá maneira de recuperala.';

  @override
  String get emailAssociatedToaccount => 'Enderezo de correo electrónico asociado á conta';

  @override
  String get sentEmailWithLink => 'Enviámosche un correo electrónico cunha ligazón.';

  @override
  String get tournamentEntryCode => 'Código de participación no torneo';

  @override
  String get hangOn => 'Agarda!';

  @override
  String gameInProgress(String param) {
    return 'Estás xogando unha partida con $param.';
  }

  @override
  String get abortTheGame => 'Abortar a partida';

  @override
  String get resignTheGame => 'Renderse';

  @override
  String get youCantStartNewGame => 'Non podes comezar unha nova partida ata que esta remate.';

  @override
  String get since => 'Desde';

  @override
  String get until => 'Ata';

  @override
  String get lichessDbExplanation => 'Partidas puntuadas de todos os xogadores de Lichess';

  @override
  String get switchSides => 'Cambiar de cor';

  @override
  String get closingAccountWithdrawAppeal => 'Se pechas a túa conta, retirarás a túa apelación';

  @override
  String get ourEventTips => 'Os nosos consellos para organizar eventos';

  @override
  String get instructions => 'Instrucións';

  @override
  String get showMeEverything => 'Amósamo todo';

  @override
  String get lichessPatronInfo => 'Lichess é unha organización benéfica e un programa totalmente libre e de código aberto.\nTodos os custos de funcionamento, desenvolvemento e contidos fináncianse unicamente mediante as doazóns dos usuarios.';

  @override
  String get nothingToSeeHere => 'Nada que ver aquí polo de agora.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O teu opoñente saíu da partida. Poderás reclamar a vitoria en $count segundos.',
      one: 'O teu opoñente saíu da partida. Poderás reclamar a vitoria en $count segundo.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mate en $count medias xogadas',
      one: 'Mate en $count media xogada',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count metidas de zoca',
      one: '$count metida de zoca',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erros',
      one: '$count erro',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imprecisións',
      one: '$count imprecisión',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count xogadores',
      one: '$count xogador',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidas',
      one: '$count partida',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Puntuación $count en $param2 partidas',
      one: 'Puntuación $count en $param2 partida',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidas favoritas',
      one: '$count partida favorita',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '$count día',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '$count hora',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '$count minuto',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A posición actualízase cada $count minutos',
      one: 'A posición actualízase cada minuto',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemas',
      one: '$count problema',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidas contigo',
      one: '$count partida contigo',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntuadas',
      one: '$count puntuada',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vitorias',
      one: '$count vitoria',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count derrotas',
      one: '$count derrota',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count táboas',
      one: '$count táboas',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count en xogo',
      one: '$count en xogo',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dar $count segundos',
      one: 'Dar $count segundo',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos en torneos',
      one: '$count punto en torneos',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estudos',
      one: '$count estudo',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultáneas',
      one: '$count simultánea',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partidas puntuadas',
      one: '≥ $count partida puntuada',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partidas puntuadas $param2',
      one: '≥ $count partida puntuada $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Necesitas xogar $count partidas $param2 puntuadas máis',
      one: 'Necesitas xogar $count partida $param2 puntuada máis',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Necesitas xogar $count partidas puntuadas máis',
      one: 'Necesitas xogar $count partida puntuada máis',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidas importadas',
      one: '$count partida importada',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amizades conectadas',
      one: '$count amizade conectada',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seguidores',
      one: '$count seguidor',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seguindo a $count xogadores',
      one: 'Seguindo a $count xogador',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Menos de $count minutos',
      one: 'Menos de $count minuto',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidas en xogo',
      one: '$count partida en xogo',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Máximo: $count caracteres.',
      one: 'Máximo: $count carácter.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count xogadores bloqueados',
      one: '$count xogador bloqueado',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mensaxes no Foro',
      one: '$count Mensaxe no Foro',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count xogadores de $param2 esta semana.',
      one: '$count xogador de $param2 esta semana.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dispoñible en $count idiomas!',
      one: 'Dispoñible en $count idioma!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundos para facer o primeiro movemento',
      one: '$count segundo para facer o primeiro movemento',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundos',
      one: '$count segundo',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'e garda $count variantes de premovementos',
      one: 'e garda $count variante de premovementos',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Move para comezar';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Xogas coas brancas en todos os crebacabezas';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Xogas coas negras en todos os crebacabezas';

  @override
  String get stormPuzzlesSolved => 'crebacabezas resoltos';

  @override
  String get stormNewDailyHighscore => 'Novo récord diario!';

  @override
  String get stormNewWeeklyHighscore => 'Novo récord semanal!';

  @override
  String get stormNewMonthlyHighscore => 'Novo récord mensual!';

  @override
  String get stormNewAllTimeHighscore => 'Novo récord absoluto!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'O récord anterior era $param';
  }

  @override
  String get stormPlayAgain => 'Xogar de novo';

  @override
  String stormHighscoreX(String param) {
    return 'Récord: $param';
  }

  @override
  String get stormScore => 'Resultados';

  @override
  String get stormMoves => 'Movementos';

  @override
  String get stormAccuracy => 'Precisión';

  @override
  String get stormCombo => 'Serie';

  @override
  String get stormTime => 'Tempo';

  @override
  String get stormTimePerMove => 'Tempo por movemento';

  @override
  String get stormHighestSolved => 'Exercicio máis difícil resolto';

  @override
  String get stormPuzzlesPlayed => 'Crebacabezas xogados';

  @override
  String get stormNewRun => 'Nova quenda (tecla: espazo)';

  @override
  String get stormEndRun => 'Finalizar quenda (tecla: Enter)';

  @override
  String get stormHighscores => 'Récords';

  @override
  String get stormViewBestRuns => 'Ver as mellores quendas';

  @override
  String get stormBestRunOfDay => 'Mellor quenda do día';

  @override
  String get stormRuns => 'Quendas';

  @override
  String get stormGetReady => 'Prepárate!';

  @override
  String get stormWaitingForMorePlayers => 'Agardando que se unan máis xogadores...';

  @override
  String get stormRaceComplete => 'Carreira concluída!';

  @override
  String get stormSpectating => 'Observando';

  @override
  String get stormJoinTheRace => 'Entra na carreira!';

  @override
  String get stormStartTheRace => 'Comeza a carreira';

  @override
  String stormYourRankX(String param) {
    return 'A túa posición: $param';
  }

  @override
  String get stormWaitForRematch => 'Agardando polo desquite';

  @override
  String get stormNextRace => 'Próxima carreira';

  @override
  String get stormJoinRematch => 'Unirse ao desquite';

  @override
  String get stormWaitingToStart => 'Esperando a que comece';

  @override
  String get stormCreateNewGame => 'Crea unha nova carreira';

  @override
  String get stormJoinPublicRace => 'Únete a unha carreira pública';

  @override
  String get stormRaceYourFriends => 'Corre contra os teus amigos';

  @override
  String get stormSkip => 'omitir';

  @override
  String get stormSkipHelp => 'Podes omitir un movemento por carreira:';

  @override
  String get stormSkipExplanation => 'Omite este movemento para conservar a túa serie. Só se pode facer unha vez por carreira.';

  @override
  String get stormFailedPuzzles => 'Problemas errados';

  @override
  String get stormSlowPuzzles => 'Problemas lentos';

  @override
  String get stormSkippedPuzzle => 'Exercicio omitido';

  @override
  String get stormThisWeek => 'Esta semana';

  @override
  String get stormThisMonth => 'Este mes';

  @override
  String get stormAllTime => 'Global';

  @override
  String get stormClickToReload => 'Preme para recargar';

  @override
  String get stormThisRunHasExpired => 'Esta quenda rematou!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Esta quenda foi aberta noutra lapela!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quendas',
      one: '1 quenda',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xogou $count quendas de $param2',
      one: 'Xogou unha quenda de $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Presentadores de Lichess';

  @override
  String get studyShareAndExport => 'Compartir e exportar';

  @override
  String get studyStart => 'Comezar';
}
