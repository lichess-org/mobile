import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get mobileHomeTab => 'Inicio';

  @override
  String get mobilePuzzlesTab => 'Ejercicios';

  @override
  String get mobileToolsTab => 'Herramientas';

  @override
  String get mobileWatchTab => 'Ver';

  @override
  String get mobileSettingsTab => 'Preferencias';

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
  String get activityActivity => 'Actividad';

  @override
  String get activityHostedALiveStream => 'Emitió en directo';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return '#$param1 en la clasificación en $param2';
  }

  @override
  String get activitySignedUp => 'Registrado en Lichess';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha colaborado con lichess.org durante $count meses como $param2',
      one: 'Ha colaborado con lichess.org durante $count mes como $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha practicado $count posiciones en $param2',
      one: 'Ha practicado $count posición en $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha resuelto $count ejercicios de táctica',
      one: 'Ha resuelto $count ejercicio de táctica',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha jugado $count partidas $param2',
      one: 'Ha jugado $count partida $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha publicado $count mensajes en $param2',
      one: 'Ha publicado $count mensaje en $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha hecho $count movimientos',
      one: 'Ha hecho $count movimiento',
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
      other: 'Ha jugado $count partidas por correspondencia',
      one: 'Ha jugado $count partida por correspondencia',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sigue a $count jugadores',
      one: 'Sigue a $count jugador',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tiene $count seguidores nuevos',
      one: 'Tiene $count seguidor nuevo',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha ofrecido $count exhibiciones simultáneas',
      one: 'Ha ofrecido $count exhibición simultánea',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha participado en $count exhibiciones simultáneas',
      one: 'Ha participado en $count exhibición simultánea',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha creado $count estudios',
      one: 'Ha creado $count estudio',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha competido en $count torneos',
      one: 'Ha competido en $count torneo',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countº en la clasificación (dentro del $param2% mejor) con $param3 partidas en $param4',
      one: '$countº en la clasificación (dentro del $param2% mejor) con $param3 partida en $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha competido en $count torneos suizos',
      one: 'Ha competido en $count torneo suizo',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miembro de $count equipos',
      one: 'Miembro de $count equipo',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Emisiones';

  @override
  String get broadcastLiveBroadcasts => 'Emisiones de torneos en directo';

  @override
  String challengeChallengesX(String param1) {
    return 'Desafíos: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Desafiar a una partida';

  @override
  String get challengeChallengeDeclined => 'Desafío rechazado';

  @override
  String get challengeChallengeAccepted => '¡Desafío aceptado!';

  @override
  String get challengeChallengeCanceled => 'Desafío cancelado.';

  @override
  String get challengeRegisterToSendChallenges => 'Por favor, regístrate para desafiar a otros jugadores.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'No puedes desafiar a $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param no acepta desafíos.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Tu puntuación de $param1 difiere mucho de la de $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'No puedes desafiar debido a que tu puntuación de $param es provisional.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param sólo acepta desafíos de sus amigos.';
  }

  @override
  String get challengeDeclineGeneric => 'No acepto desafíos en este momento.';

  @override
  String get challengeDeclineLater => 'Ahora no me viene bien. Vuelve a intentarlo más tarde, por favor.';

  @override
  String get challengeDeclineTooFast => 'Este control de tiempo es demasiado rápido para mí. Por favor, desafíame de nuevo a una partida más lenta.';

  @override
  String get challengeDeclineTooSlow => 'Este control de tiempo es demasiado lento para mí. Por favor, desafíame de nuevo a una partida más rápida.';

  @override
  String get challengeDeclineTimeControl => 'No acepto desafíos con ese control de tiempo.';

  @override
  String get challengeDeclineRated => 'Desafíame a una partida por puntos, mejor.';

  @override
  String get challengeDeclineCasual => 'Desafíame a una partida amistosa, mejor.';

  @override
  String get challengeDeclineStandard => 'No acepto desafíos de modalidades ahora.';

  @override
  String get challengeDeclineVariant => 'No me apetece jugar esta modalidad ahora.';

  @override
  String get challengeDeclineNoBot => 'No acepto desafíos de bots.';

  @override
  String get challengeDeclineOnlyBot => 'Sólo acepto desafíos de bots.';

  @override
  String get challengeInviteLichessUser => 'O invita a un usuario de Lichess:';

  @override
  String get contactContact => 'Contacto';

  @override
  String get contactContactLichess => 'Contactar con Lichess';

  @override
  String get patronDonate => 'Donar';

  @override
  String get patronLichessPatron => 'Patrón de Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Estadísticas de $param';
  }

  @override
  String get perfStatViewTheGames => 'Ver las partidas';

  @override
  String get perfStatProvisional => 'provisional';

  @override
  String get perfStatNotEnoughRatedGames => 'No se han jugado suficientes partidas para establecer una puntuación fiable.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progresión en las últimas $param partidas:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Desviación de la puntuación: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Un valor bajo en el rating significa que es más estable. Un valor superior a $param1, significa que la puntuación es provisional. Para que se incluya en las clasificaciones, este valor debe ser inferior a $param2 (ajedrez estándar) o $param3 (variantes).';
  }

  @override
  String get perfStatTotalGames => 'Partidas totales';

  @override
  String get perfStatRatedGames => 'Partidas por puntos';

  @override
  String get perfStatTournamentGames => 'Partidas de torneo';

  @override
  String get perfStatBerserkedGames => 'Partidas agilizadas (berserk)';

  @override
  String get perfStatTimeSpentPlaying => 'Tiempo dedicado a jugar';

  @override
  String get perfStatAverageOpponent => 'Promedio de los oponentes';

  @override
  String get perfStatVictories => 'Victorias';

  @override
  String get perfStatDefeats => 'Derrotas';

  @override
  String get perfStatDisconnections => 'Desconexiones';

  @override
  String get perfStatNotEnoughGames => 'No hay suficientes partidas jugadas';

  @override
  String perfStatHighestRating(String param) {
    return 'Puntuación más alta: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Puntuación más baja: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'desde $param1 hasta $param2';
  }

  @override
  String get perfStatWinningStreak => 'Racha de victorias';

  @override
  String get perfStatLosingStreak => 'Racha de derrotas';

  @override
  String perfStatLongestStreak(String param) {
    return 'Racha más larga: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Racha actual: $param';
  }

  @override
  String get perfStatBestRated => 'Mejores victorias por puntos';

  @override
  String get perfStatGamesInARow => 'Partidas jugadas seguidas';

  @override
  String get perfStatLessThanOneHour => 'Menos de una hora entre partidas';

  @override
  String get perfStatMaxTimePlaying => 'Tiempo máximo jugando';

  @override
  String get perfStatNow => 'ahora';

  @override
  String get preferencesPreferences => 'Preferencias';

  @override
  String get preferencesDisplay => 'Mostrar';

  @override
  String get preferencesPrivacy => 'Privacidad';

  @override
  String get preferencesNotifications => 'Notificaciones';

  @override
  String get preferencesPieceAnimation => 'Animación de las piezas';

  @override
  String get preferencesMaterialDifference => 'Diferencia material';

  @override
  String get preferencesBoardHighlights => 'Destacar casillas del tablero (último movimiento y jaque)';

  @override
  String get preferencesPieceDestinations => 'Destino de las piezas (movimientos válidos y anticipados)';

  @override
  String get preferencesBoardCoordinates => 'Coordenadas del tablero (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Lista de movimientos durante la partida';

  @override
  String get preferencesPgnPieceNotation => 'Notación de los movimientos';

  @override
  String get preferencesChessPieceSymbol => 'Símbolo de la pieza';

  @override
  String get preferencesPgnLetter => 'Inicial (en inglés) de la pieza (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Modo Zen';

  @override
  String get preferencesShowPlayerRatings => 'Mostrar las puntuaciones de los jugadores';

  @override
  String get preferencesShowFlairs => 'Mostrar tu figurín';

  @override
  String get preferencesExplainShowPlayerRatings => 'Esto oculta el ELO en Lichess, para ayudar a concentrarte solo en el juego. Los juegos por puntos continuarán afectando tus ELO, esta opción es solo para lo que tú ves en la plataforma.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Mostrar el control de tamaño del tablero';

  @override
  String get preferencesOnlyOnInitialPosition => 'Sólo en posición inicial';

  @override
  String get preferencesInGameOnly => 'Solo durante la partida';

  @override
  String get preferencesChessClock => 'Reloj de ajedrez';

  @override
  String get preferencesTenthsOfSeconds => 'Décimas de segundo';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Cuando queden menos de 10 segundos';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Barras de progreso horizontales verdes';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Alerta cuando quede poco tiempo';

  @override
  String get preferencesGiveMoreTime => 'Dar más tiempo';

  @override
  String get preferencesGameBehavior => 'Comportamiento del juego';

  @override
  String get preferencesHowDoYouMovePieces => '¿Cómo quieres mover las piezas?';

  @override
  String get preferencesClickTwoSquares => 'Haciendo clic en la pieza y luego en la casilla de destino';

  @override
  String get preferencesDragPiece => 'Arrastrando la pieza hasta la casilla de destino';

  @override
  String get preferencesBothClicksAndDrag => 'O cualquiera';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Movimientos anticipados (programar jugadas durante el turno del oponente)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Deshacer jugada (con consentimiento del oponente)';

  @override
  String get preferencesInCasualGamesOnly => 'Sólo en partidas amistosas';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promover a la Reina automáticamente';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Mantén pulsada la tecla <ctrl> al promocionar para desactivar temporalmente la promoción automática';

  @override
  String get preferencesWhenPremoving => 'Con anticipadas';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Reclamar tablas por triple repetición';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Cuando el tiempo restante sea de < 30 segundos';

  @override
  String get preferencesMoveConfirmation => 'Confirmación de movimiento';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Se puede desactivar durante una partida con el menú del tablero';

  @override
  String get preferencesInCorrespondenceGames => 'Partidas por correspondencia';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Correspondencia y sin límite de tiempo';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Confirmar abandono y ofertas de tablas';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Método de enroque';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Moviendo el rey dos escaques';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Moviendo el rey hasta la torre';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Entrada de movimientos con el teclado';

  @override
  String get preferencesInputMovesWithVoice => 'Realiza movimientos con tu voz';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Adherir flechas a movimientos válidos';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Decir \"Good game, well played\" (Buena partida, bien jugada) al perder o empatar';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Tus preferencias se han guardado.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Usa la rueda de desplazamiento sobre el tablero para volver a mostrar los movimientos';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Notificación diaria por correo listando tus partidas por correspondencia';

  @override
  String get preferencesNotifyStreamStart => 'El presentador está en vivo';

  @override
  String get preferencesNotifyInboxMsg => 'Nuevo mensaje en la bandeja de entrada';

  @override
  String get preferencesNotifyForumMention => 'Comentario del foro que te menciona';

  @override
  String get preferencesNotifyInvitedStudy => 'Invitación a un estudio';

  @override
  String get preferencesNotifyGameEvent => 'Actualizaciones de partida por correspondencia';

  @override
  String get preferencesNotifyChallenge => 'Desafíos';

  @override
  String get preferencesNotifyTournamentSoon => 'El torneo empieza pronto';

  @override
  String get preferencesNotifyTimeAlarm => 'Poco tiempo restante en la partida por correspondencia';

  @override
  String get preferencesNotifyBell => 'Notificación de campana dentro del Lichess';

  @override
  String get preferencesNotifyPush => 'Notificación de dispositivo cuando no estés en Lichess';

  @override
  String get preferencesNotifyWeb => 'Navegador';

  @override
  String get preferencesNotifyDevice => 'Dispositivo';

  @override
  String get preferencesBellNotificationSound => 'Campana de notificación';

  @override
  String get puzzlePuzzles => 'Ejercicios';

  @override
  String get puzzlePuzzleThemes => 'Ejercicios por temas';

  @override
  String get puzzleRecommended => 'Recomendado';

  @override
  String get puzzlePhases => 'Fases';

  @override
  String get puzzleMotifs => 'Temas';

  @override
  String get puzzleAdvanced => 'Avanzado';

  @override
  String get puzzleLengths => 'Duración';

  @override
  String get puzzleMates => 'Mates';

  @override
  String get puzzleGoals => 'Objetivos';

  @override
  String get puzzleOrigin => 'Origen';

  @override
  String get puzzleSpecialMoves => 'Movimientos especiales';

  @override
  String get puzzleDidYouLikeThisPuzzle => '¿Te ha gustado este ejercicio?';

  @override
  String get puzzleVoteToLoadNextOne => '¡Vota para pasar al siguiente!';

  @override
  String get puzzleUpVote => 'Votar positivamente el ejercicio';

  @override
  String get puzzleDownVote => 'Votar negativamente el ejercicio';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Tu puntuación de ejercicios no cambiará. Nota que los ejercicios no son una competición. La puntuación indica los ejercicios que se adecuan a tus habilidades.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Encuentra el mejor movimiento para las blancas.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Encuentra el mejor movimiento para las negras.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Para conseguir ejercicios personalizados:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Ejercicio $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Ejercicio del día';

  @override
  String get puzzleDailyPuzzle => 'Ejercicio del día';

  @override
  String get puzzleClickToSolve => 'Clic para resolver';

  @override
  String get puzzleGoodMove => 'Buen movimiento';

  @override
  String get puzzleBestMove => '¡El mejor movimiento!';

  @override
  String get puzzleKeepGoing => 'Continúa…';

  @override
  String get puzzlePuzzleSuccess => '¡Bien!';

  @override
  String get puzzlePuzzleComplete => '¡Ejercicio terminado!';

  @override
  String get puzzleByOpenings => 'Por aperturas';

  @override
  String get puzzlePuzzlesByOpenings => 'Ejercicios por aperturas';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Aperturas que más has jugado en partidas por puntos';

  @override
  String get puzzleUseFindInPage => '¡Usa \"Encontrar en la página\" en el menú del navegador para encontrar tu apertura favorita!';

  @override
  String get puzzleUseCtrlF => '¡Usa Ctrl+f para encontrar tu apertura favorita!';

  @override
  String get puzzleNotTheMove => '¡Ese no es el movimiento!';

  @override
  String get puzzleTrySomethingElse => 'Prueba algo distinto.';

  @override
  String puzzleRatingX(String param) {
    return 'Puntuación: $param';
  }

  @override
  String get puzzleHidden => 'oculto';

  @override
  String puzzleFromGameLink(String param) {
    return 'De la partida $param';
  }

  @override
  String get puzzleContinueTraining => 'Continuar entrenamiento';

  @override
  String get puzzleDifficultyLevel => 'Nivel de dificultad';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Más fácil';

  @override
  String get puzzleEasiest => 'El más fácil';

  @override
  String get puzzleHarder => 'Más difícil';

  @override
  String get puzzleHardest => 'El más difícil';

  @override
  String get puzzleExample => 'Ejemplo';

  @override
  String get puzzleAddAnotherTheme => 'Añadir otro tema';

  @override
  String get puzzleNextPuzzle => 'Siguiente ejercicio';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Ir al siguiente ejercicio inmediatamente';

  @override
  String get puzzlePuzzleDashboard => 'Panel de ejercicios';

  @override
  String get puzzleImprovementAreas => 'Áreas de mejora';

  @override
  String get puzzleStrengths => 'Puntos fuertes';

  @override
  String get puzzleHistory => 'Historial de ejercicios';

  @override
  String get puzzleSolved => 'resuelto';

  @override
  String get puzzleFailed => 'fallido';

  @override
  String get puzzleStreakDescription => 'Resuelve ejercicios cada vez más difíciles para conseguir la racha más larga posible. No hay tiempo, así que tómatelo con calma. Un movimiento erróneo y ¡se acabó!, aunque puedes omitir un movimiento en cada sesión.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Tu racha: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Puedes omitir este movimiento para conservar tu racha, pero solo una vez por sesión.';

  @override
  String get puzzleContinueTheStreak => 'Continuar la racha';

  @override
  String get puzzleNewStreak => 'Nueva racha';

  @override
  String get puzzleFromMyGames => 'De mis partidas';

  @override
  String get puzzleLookupOfPlayer => 'Buscar ejercicios de las partidas de un jugador';

  @override
  String puzzleFromXGames(String param) {
    return 'Ejercicios de las partidas de $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Buscar ejercicios';

  @override
  String get puzzleFromMyGamesNone => 'No tienes ejercicios en la base de datos, pero Lichess aún te quiere un montón.\n¡Juega partidas rápidas y clásicas para tener más posibilidades de que se añadan tus ejercicios!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 ejercicios encontrados en las partidas de $param2';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Entrena, analiza, mejora';

  @override
  String puzzlePercentSolved(String param) {
    return '$param correctos';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Aún no hay nada que mostrar aquí. ¡Ve y haz algunos ejercicios!';

  @override
  String get puzzleImprovementAreasDescription => '¡Entrena estas áreas para progresar!';

  @override
  String get puzzleStrengthDescription => 'Estas son las áreas en las que eres más fuerte';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jugado $count veces',
      one: 'Jugado $count vez',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos por debajo de tu puntuación de ejercicios',
      one: 'Un punto por debajo de tu puntuación de ejercicios',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos por encima de tu puntuación de ejercicios',
      one: 'Un punto por encima de tu puntuación de ejercicios',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '$count ejercicio',
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
  String get puzzleThemeAdvancedPawnDescription => 'Uno de tus peones está bien avanzado en territorio enemigo, quizás amenazando promocionar.';

  @override
  String get puzzleThemeAdvantage => 'Ventaja';

  @override
  String get puzzleThemeAdvantageDescription => 'Aprovecha la oportunidad de obtener una ventaja decisiva. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mate de Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Un caballo y una torre o dama se unen para atrapar al rey contrario entre un extremo del tablero y una pieza de su bando.';

  @override
  String get puzzleThemeArabianMate => 'Mate árabe';

  @override
  String get puzzleThemeArabianMateDescription => 'Un caballo y una torre se unen para atrapar al rey contrario en una esquina del tablero.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Atacando f2 o f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Un ataque centrado en el peón f2 o f7, como en el ataque Fegatello.';

  @override
  String get puzzleThemeAttraction => 'Atracción';

  @override
  String get puzzleThemeAttractionDescription => 'Un cambio o sacrificio que invita o fuerza al oponente a colocar una pieza en una casilla que propicia una oportunidad táctica.';

  @override
  String get puzzleThemeBackRankMate => 'Mate del pasillo';

  @override
  String get puzzleThemeBackRankMateDescription => 'Jaque mate en la última fila, cuando el rey se encuentra atrapado por sus propias piezas.';

  @override
  String get puzzleThemeBishopEndgame => 'Final de alfiles';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Un final con sólo alfiles y peones.';

  @override
  String get puzzleThemeBodenMate => 'Mate de Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Dos alfiles atacantes en diagonales cruzadas dan mate al rey, obstruido por piezas de su bando.';

  @override
  String get puzzleThemeCastling => 'Enroque';

  @override
  String get puzzleThemeCastlingDescription => 'Lleva al rey a un lugar seguro y despliega la torre para atacar.';

  @override
  String get puzzleThemeCapturingDefender => 'Capturar al defensor';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Eliminar una pieza fundamental para la defensa de otra, permitiendo capturar la pieza, ahora indefensa, en el futuro.';

  @override
  String get puzzleThemeCrushing => 'Aplastante';

  @override
  String get puzzleThemeCrushingDescription => 'Detecta el error del oponente para obtener una ventaja ganadora. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mate de los dos alfiles';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dos alfiles atacantes en diagonales adyacentes dan mate al rey obstruido por piezas de su bando.';

  @override
  String get puzzleThemeDovetailMate => 'Mate de Cozio';

  @override
  String get puzzleThemeDovetailMateDescription => 'Una dama da mate al rey adyacente, cuyas únicas dos casillas de escape están obstruidas por piezas de su bando.';

  @override
  String get puzzleThemeEquality => 'Igualdad';

  @override
  String get puzzleThemeEqualityDescription => 'Recupérate de una posición perdedora y asegura las tablas o una posición de igualdad. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Ataque en el flanco de rey';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Un ataque contra el enroque corto.';

  @override
  String get puzzleThemeClearance => 'Despeje';

  @override
  String get puzzleThemeClearanceDescription => 'Un movimiento, a menudo con ganancia de tiempo, que limpia una casilla, una fila o una diagonal para una idea táctica de seguimiento.';

  @override
  String get puzzleThemeDefensiveMove => 'Movimiento defensivo';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Un movimiento o una secuencia de movimientos necesarios para evitar la pérdida de material u otra ventaja.';

  @override
  String get puzzleThemeDeflection => 'Desviación';

  @override
  String get puzzleThemeDeflectionDescription => 'Un movimiento que distrae una pieza del oponente de alguna de las tareas que desempeña, como la protección de una casilla clave. También conocido como \"sobrecarga\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ataque a la descubierta';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Mover una pieza que bloqueaba el ataque de otra pieza de largo alcance, como por ejemplo, quitar un caballo del camino de una torre.';

  @override
  String get puzzleThemeDoubleCheck => 'Jaque doble';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Dar jaque con dos piezas a la vez, como consecuencia de una ataque a la descubierta, donde tanto la pieza movida como la revelada atacan al rey del oponente.';

  @override
  String get puzzleThemeEndgame => 'Final';

  @override
  String get puzzleThemeEndgameDescription => 'Una táctica durante la última fase de la partida.';

  @override
  String get puzzleThemeEnPassantDescription => 'Una táctica que involucra la captura al paso, donde un peón puede capturar a un peón oponente que lo ha pasado por alto usando su movimiento inicial de dos casillas.';

  @override
  String get puzzleThemeExposedKing => 'Rey expuesto';

  @override
  String get puzzleThemeExposedKingDescription => 'Una táctica que involucra a un rey con poca defensa a su alrededor, a menudo conduce a jaque mate.';

  @override
  String get puzzleThemeFork => 'Ataque doble';

  @override
  String get puzzleThemeForkDescription => 'Un movimiento donde la pieza movida ataca dos piezas del oponente a la vez.';

  @override
  String get puzzleThemeHangingPiece => 'Pieza colgada';

  @override
  String get puzzleThemeHangingPieceDescription => 'Una táctica que implica que una pieza del adversario no esté defendida o insuficientemente defendida y quede para ser capturada.';

  @override
  String get puzzleThemeHookMate => 'Mate del gancho';

  @override
  String get puzzleThemeHookMateDescription => 'Jaque mate con una torre, un caballo y un peón junto con un peón enemigo para limitar el escape del rey adversario.';

  @override
  String get puzzleThemeInterference => 'Interferencia';

  @override
  String get puzzleThemeInterferenceDescription => 'Mover una pieza entre dos piezas del oponente para dejar una o ambas piezas del oponente sin defensa, por ejemplo un caballo en una casilla entre dos torres.';

  @override
  String get puzzleThemeIntermezzo => 'Jugada intermedia';

  @override
  String get puzzleThemeIntermezzoDescription => 'En lugar de jugar el movimiento esperado, se realiza antes otro movimiento que plantea una amenaza inmediata a la que el oponente debe responder. También conocido como \"Zwischenzug\" o \"Intermezzo\".';

  @override
  String get puzzleThemeKnightEndgame => 'Final de caballos';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Un final solo con caballos y peones.';

  @override
  String get puzzleThemeLong => 'Ejercicio largo';

  @override
  String get puzzleThemeLongDescription => 'Tres movimientos para ganar.';

  @override
  String get puzzleThemeMaster => 'Partidas de maestros';

  @override
  String get puzzleThemeMasterDescription => 'Ejercicios de partidas de jugadores titulados.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partidas entre maestros';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Ejercicios de partidas entre jugadores titulados.';

  @override
  String get puzzleThemeMate => 'Jaque mate';

  @override
  String get puzzleThemeMateDescription => 'Gana la partida con estilo.';

  @override
  String get puzzleThemeMateIn1 => 'Mate en 1';

  @override
  String get puzzleThemeMateIn1Description => 'Dar mate en un movimiento.';

  @override
  String get puzzleThemeMateIn2 => 'Mate en 2';

  @override
  String get puzzleThemeMateIn2Description => 'Dar mate en dos movimientos.';

  @override
  String get puzzleThemeMateIn3 => 'Mate en 3';

  @override
  String get puzzleThemeMateIn3Description => 'Dar mate en tres movimientos.';

  @override
  String get puzzleThemeMateIn4 => 'Mate en 4';

  @override
  String get puzzleThemeMateIn4Description => 'Dar mate en cuatro movimientos.';

  @override
  String get puzzleThemeMateIn5 => 'Mate en 5 o más';

  @override
  String get puzzleThemeMateIn5Description => 'Calcular una secuencia de mate larga.';

  @override
  String get puzzleThemeMiddlegame => 'Medio juego';

  @override
  String get puzzleThemeMiddlegameDescription => 'Una táctica durante la segunda fase de la partida.';

  @override
  String get puzzleThemeOneMove => 'Ejercicio de un solo movimiento';

  @override
  String get puzzleThemeOneMoveDescription => 'Un movimiento para ganar.';

  @override
  String get puzzleThemeOpening => 'Apertura';

  @override
  String get puzzleThemeOpeningDescription => 'Una táctica durante la primera fase de la partida.';

  @override
  String get puzzleThemePawnEndgame => 'Final de peones';

  @override
  String get puzzleThemePawnEndgameDescription => 'Un final solo con peones.';

  @override
  String get puzzleThemePin => 'Clavada';

  @override
  String get puzzleThemePinDescription => 'Una táctica donde una pieza no puede moverse sin revelar un ataque a una pieza de mayor valor.';

  @override
  String get puzzleThemePromotion => 'Promoción';

  @override
  String get puzzleThemePromotionDescription => 'Promover uno de sus peones a una dama o una pieza menor.';

  @override
  String get puzzleThemeQueenEndgame => 'Final de damas';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Un final solo con damas y peones.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Final de dama y torre';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Un final solo con damas, torres y peones.';

  @override
  String get puzzleThemeQueensideAttack => 'Ataque en el flanco de dama';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Un ataque al rey del oponente, luego de haber realizado el enroque largo.';

  @override
  String get puzzleThemeQuietMove => 'Jugada tranquila';

  @override
  String get puzzleThemeQuietMoveDescription => 'Un movimiento que no da jaque o captura pieza, ni amenza inmediatamente capturar una pieza, pero que prepara una amenaza inevitable más oculta para una jugada posterior.';

  @override
  String get puzzleThemeRookEndgame => 'Final de torres';

  @override
  String get puzzleThemeRookEndgameDescription => 'Un final solo con torres y peones.';

  @override
  String get puzzleThemeSacrifice => 'Sacrificio';

  @override
  String get puzzleThemeSacrificeDescription => 'Una táctica que implica ceder material a corto plazo, para obtener una ventaja luego de una secuencia forzada de movimientos.';

  @override
  String get puzzleThemeShort => 'Ejercicio corto';

  @override
  String get puzzleThemeShortDescription => 'Dos movimientos para ganar.';

  @override
  String get puzzleThemeSkewer => 'Pincho';

  @override
  String get puzzleThemeSkewerDescription => 'Un motivo que implica el ataque de una pieza de alto valor, que se aparta del camino y permite capturar o atacar una pieza de menor valor detrás de ella, lo contrario de una clavada.';

  @override
  String get puzzleThemeSmotheredMate => 'Mate de la coz';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Un jaque mate con caballo, en el cual el rey enemigo no se puede mover al encontrarse rodeado (o ahogado) por sus propias piezas.';

  @override
  String get puzzleThemeSuperGM => 'Partidas de súper grandes maestros';

  @override
  String get puzzleThemeSuperGMDescription => 'Ejercicios de partidas de los mejores jugadores del mundo.';

  @override
  String get puzzleThemeTrappedPiece => 'Pieza atrapada';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Una pieza no puede escapar de la captura porque tiene movimientos limitados.';

  @override
  String get puzzleThemeUnderPromotion => 'Subpromoción';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promoción a caballo, alfil o torre.';

  @override
  String get puzzleThemeVeryLong => 'Ejercicio muy largo';

  @override
  String get puzzleThemeVeryLongDescription => 'Cuatro movimientos o más para ganar.';

  @override
  String get puzzleThemeXRayAttack => 'Ataque por rayos X';

  @override
  String get puzzleThemeXRayAttackDescription => 'Una pieza ataca o defiende una casilla, a través de una pieza del oponente.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'El oponente está limitado en los movimientos que puede realizar, y todos los movimientos empeoran su posición.';

  @override
  String get puzzleThemeHealthyMix => 'Mezcla equilibrada';

  @override
  String get puzzleThemeHealthyMixDescription => 'Un poco de todo. No sabes lo que te espera, así que estate listo para cualquier cosa, como en las partidas reales.';

  @override
  String get puzzleThemePlayerGames => 'Partidas de jugadores';

  @override
  String get puzzleThemePlayerGamesDescription => 'Busca ejercicios generados a partir de tus partidas o de las de otros jugadores.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Estos ejercicios son de dominio público y pueden descargarse desde $param.';
  }

  @override
  String get searchSearch => 'Búsqueda';

  @override
  String get settingsSettings => 'Preferencias';

  @override
  String get settingsCloseAccount => 'Cerrar cuenta';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Tu cuenta está administrada y no se puede cerrar.';

  @override
  String get settingsClosingIsDefinitive => 'El cierre de la cuenta será definitivo. No hay vuelta atrás. ¿Estás seguro?';

  @override
  String get settingsCantOpenSimilarAccount => 'No se te permitirá abrir una nueva cuenta con el mismo nombre, ni cambiando letras mayúsculas y minúsculas.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'He cambiado de opinión, no cierren mi cuenta';

  @override
  String get settingsCloseAccountExplanation => '¿Estás seguro de que quieres cerrar tu cuenta? El cierre de tu cuenta es una decisión permanente. NUNCA MÁS podrás iniciar sesión desde la misma.';

  @override
  String get settingsThisAccountIsClosed => 'Esta cuenta fue cerrada.';

  @override
  String get playWithAFriend => 'Jugar contra un amigo';

  @override
  String get playWithTheMachine => 'Jugar contra el ordenador';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Para invitar a alguien a jugar, comparte este enlace';

  @override
  String get gameOver => 'Fin de la partida';

  @override
  String get waitingForOpponent => 'Esperando al oponente';

  @override
  String get orLetYourOpponentScanQrCode => 'O deja que tu oponente escanee este código QR';

  @override
  String get waiting => 'Esperando';

  @override
  String get yourTurn => 'Tu turno';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 nivel $param2';
  }

  @override
  String get level => 'Nivel';

  @override
  String get strength => 'Nivel';

  @override
  String get toggleTheChat => 'Mostrar/Ocultar chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Abandonar';

  @override
  String get checkmate => 'Jaque mate';

  @override
  String get stalemate => 'Ahogado';

  @override
  String get white => 'Blancas';

  @override
  String get black => 'Negras';

  @override
  String get asWhite => 'con blancas';

  @override
  String get asBlack => 'con negras';

  @override
  String get randomColor => 'Color aleatorio';

  @override
  String get createAGame => 'Crear una partida';

  @override
  String get whiteIsVictorious => 'Las blancas ganan';

  @override
  String get blackIsVictorious => 'Las negras ganan';

  @override
  String get youPlayTheWhitePieces => 'Juegas con blancas';

  @override
  String get youPlayTheBlackPieces => 'Juegas con negras';

  @override
  String get itsYourTurn => '¡Es tu turno!';

  @override
  String get cheatDetected => 'Trampa detectada';

  @override
  String get kingInTheCenter => 'Rey en el centro';

  @override
  String get threeChecks => 'Tres jaques';

  @override
  String get raceFinished => 'Carrera terminada';

  @override
  String get variantEnding => 'Fin de la variante';

  @override
  String get newOpponent => 'Nuevo oponente';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Tu oponente quiere la revancha';

  @override
  String get joinTheGame => 'Unirse a la partida';

  @override
  String get whitePlays => 'Juegan las blancas';

  @override
  String get blackPlays => 'Juegan las negras';

  @override
  String get opponentLeftChoices => 'Tu oponente puede haber abandonado la partida. Puedes reclamar la victoria, declarar tablas o esperar.';

  @override
  String get forceResignation => 'Reclamar la victoria';

  @override
  String get forceDraw => 'Declarar tablas';

  @override
  String get talkInChat => 'Por favor, sé amable en el chat';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'La primera persona que entre en este enlace jugará contigo.';

  @override
  String get whiteResigned => 'Las blancas abandonaron';

  @override
  String get blackResigned => 'Las negras abandonaron';

  @override
  String get whiteLeftTheGame => 'Las blancas han dejado la partida';

  @override
  String get blackLeftTheGame => 'Las negras han dejado la partida';

  @override
  String get whiteDidntMove => 'Las blancas no han jugado';

  @override
  String get blackDidntMove => 'Las negras no han jugado';

  @override
  String get requestAComputerAnalysis => 'Solicitar un análisis del ordenador';

  @override
  String get computerAnalysis => 'Análisis del ordenador';

  @override
  String get computerAnalysisAvailable => 'Análisis del ordenador disponible';

  @override
  String get computerAnalysisDisabled => 'Análisis por ordenador deshabilitado';

  @override
  String get analysis => 'Tablero de análisis';

  @override
  String depthX(String param) {
    return 'Profundidad: $param';
  }

  @override
  String get usingServerAnalysis => 'Usando análisis del servidor';

  @override
  String get loadingEngine => 'Cargando el motor...';

  @override
  String get calculatingMoves => 'Calculando movimientos...';

  @override
  String get engineFailed => 'Error al cargar el motor';

  @override
  String get cloudAnalysis => 'Análisis en el servidor';

  @override
  String get goDeeper => 'Aumentar la profundidad del análisis';

  @override
  String get showThreat => 'Mostrar amenaza';

  @override
  String get inLocalBrowser => 'en el navegador local';

  @override
  String get toggleLocalEvaluation => 'Evaluación local';

  @override
  String get promoteVariation => 'Promocionar variante';

  @override
  String get makeMainLine => 'Convertir en línea principal';

  @override
  String get deleteFromHere => 'Borrar a partir de aquí';

  @override
  String get collapseVariations => 'Cerrar variantes';

  @override
  String get expandVariations => 'Abrir variantes';

  @override
  String get forceVariation => 'Convertir en variante';

  @override
  String get copyVariationPgn => 'Copiar PGN de la variante';

  @override
  String get move => 'Movimiento';

  @override
  String get variantLoss => 'Variante perdedora';

  @override
  String get variantWin => 'Variante ganadora';

  @override
  String get insufficientMaterial => 'Material insuficiente';

  @override
  String get pawnMove => 'Movimiento de peón';

  @override
  String get capture => 'Captura';

  @override
  String get close => 'Cerrar';

  @override
  String get winning => 'Ganador';

  @override
  String get losing => 'Perdedor';

  @override
  String get drawn => 'Resulta en tablas';

  @override
  String get unknown => 'Desconocido';

  @override
  String get database => 'Base de datos';

  @override
  String get whiteDrawBlack => 'Blancas / Tablas / Negras';

  @override
  String averageRatingX(String param) {
    return 'Puntuación media: $param';
  }

  @override
  String get recentGames => 'Partidas recientes';

  @override
  String get topGames => 'Mejores partidas';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Dos millones de partidas de jugadores con ELO FIDE de $param1+, desde $param2 a $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' con redondeo, basado en el número de movimientos intermedios hasta la próxima captura o movimiento de peón';

  @override
  String get noGameFound => 'No se ha encontrado ninguna partida';

  @override
  String get maxDepthReached => '¡Profundidad máxima alcanzada!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Prueba incluyendo más partidas desde el menú de preferencias';

  @override
  String get openings => 'Aperturas';

  @override
  String get openingExplorer => 'Explorador de aperturas';

  @override
  String get openingEndgameExplorer => 'Explorador de aperturas y finales';

  @override
  String xOpeningExplorer(String param) {
    return 'Explorador de la apertura $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Realiza el primer movimiento del explorador de aperturas y finales';

  @override
  String get winPreventedBy50MoveRule => 'La regla de los 50 movimientos impide la victoria';

  @override
  String get lossSavedBy50MoveRule => 'La regla de los 50 movimientos evita la derrota';

  @override
  String get winOr50MovesByPriorMistake => 'Victoria o 50 movimientos por error anterior';

  @override
  String get lossOr50MovesByPriorMistake => 'Derrota o 50 movimientos por error anterior';

  @override
  String get unknownDueToRounding => 'Victoria o derrota segura solo si se siguió la línea de movimientos recomendados desde la última captura o movimiento de peón, a causa del posible redondeo de valores DTZ de las Tablas de Finales Syzygy.';

  @override
  String get allSet => '¡Listo!';

  @override
  String get importPgn => 'Importar PGN';

  @override
  String get delete => 'Borrar';

  @override
  String get deleteThisImportedGame => '¿Borrar este juego importado?';

  @override
  String get replayMode => 'Modo de repetición';

  @override
  String get realtimeReplay => 'Tiempo real';

  @override
  String get byCPL => 'Por PCP';

  @override
  String get openStudy => 'Abrir estudio';

  @override
  String get enable => 'Activar';

  @override
  String get bestMoveArrow => 'Indicar la mejor jugada';

  @override
  String get showVariationArrows => 'Mostrar flechas de variantes';

  @override
  String get evaluationGauge => 'Indicador de evaluación';

  @override
  String get multipleLines => 'Múltiples líneas';

  @override
  String get cpus => 'Procesadores';

  @override
  String get memory => 'Memoria';

  @override
  String get infiniteAnalysis => 'Análisis infinito';

  @override
  String get removesTheDepthLimit => 'Elimina el límite de profundidad del análisis y hace trabajar a tu ordenador';

  @override
  String get engineManager => 'Gestor de motores';

  @override
  String get blunder => 'Error grave';

  @override
  String get mistake => 'Error';

  @override
  String get inaccuracy => 'Imprecisión';

  @override
  String get moveTimes => 'Tiempo por movimiento';

  @override
  String get flipBoard => 'Girar el tablero';

  @override
  String get threefoldRepetition => 'Triple repetición';

  @override
  String get claimADraw => 'Reclamar tablas';

  @override
  String get offerDraw => 'Ofrecer tablas';

  @override
  String get draw => 'Tablas';

  @override
  String get drawByMutualAgreement => 'Tablas de mutuo acuerdo';

  @override
  String get fiftyMovesWithoutProgress => 'Cincuenta movimientos sin ningún progreso';

  @override
  String get currentGames => 'Partidas en juego';

  @override
  String get viewInFullSize => 'Ver en tamaño completo';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get rememberMe => 'No cerrar sesión';

  @override
  String get youNeedAnAccountToDoThat => 'Necesitas crear una cuenta para hacer eso';

  @override
  String get signUp => 'Registrarse';

  @override
  String get computersAreNotAllowedToPlay => 'No está permitido jugar a ordenadores ni a jugadores ayudados por un ordenador o por otras personas. Por favor, no te ayudes de motores de ajedrez, bases de datos o de otros jugadores durante la partida. Además, ten en cuenta que no se aconseja la utilización de varias cuentas de usuario y que el uso de un excesivo número de cuentas resultará en la cancelación de las mismas.';

  @override
  String get games => 'Partidas';

  @override
  String get forum => 'Foro';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 ha escrito en el tema $param2';
  }

  @override
  String get latestForumPosts => 'Últimos mensajes del foro';

  @override
  String get players => 'Jugadores';

  @override
  String get friends => 'Amigos';

  @override
  String get discussions => 'Conversaciones';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get minutesPerSide => 'Minutos por jugador';

  @override
  String get variant => 'Variante';

  @override
  String get variants => 'Variantes';

  @override
  String get timeControl => 'Control de tiempo';

  @override
  String get realTime => 'Tiempo real';

  @override
  String get correspondence => 'Correspondencia';

  @override
  String get daysPerTurn => 'Días por turno';

  @override
  String get oneDay => 'Un día';

  @override
  String get time => 'Tiempo';

  @override
  String get rating => 'Puntuación';

  @override
  String get ratingStats => 'Estadísticas de puntuación';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get usernameOrEmail => 'Nombre de usuario o correo';

  @override
  String get changeUsername => 'Cambiar nombre de usuario';

  @override
  String get changeUsernameNotSame => 'Sólo es posible cambiar mayúsculas por minúsculas y viceversa. Por ejemplo, de \"juanperez\" a \"JuanPerez\".';

  @override
  String get changeUsernameDescription => 'Cambiar tu nombre de usuario. Esto sólo puede hacerse una vez, y sólo se puede cambiar mayúsculas por minúsculas y viceversa.';

  @override
  String get signupUsernameHint => 'Asegúrate de elegir un nombre de usuario apto para todos los públicos. ¡No podrás cambiarlo más tarde y se cerrará cualquier cuenta con un nombre de usuario inapropiado!';

  @override
  String get signupEmailHint => 'Solo lo usaremos para restablecer la contraseña.';

  @override
  String get password => 'Contraseña';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get changeEmail => 'Cambiar correo';

  @override
  String get email => 'Correo';

  @override
  String get passwordReset => 'Cambiar contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get error_weakPassword => 'Esta contraseña es extremadamente común y fácil de adivinar.';

  @override
  String get error_namePassword => 'Por favor, no uses tu nombre de usuario como contraseña.';

  @override
  String get blankedPassword => 'Has utilizado la misma contraseña en otro sitio y ese sitio se ha visto comprometido. Para garantizar la seguridad de tu cuenta en Lichess, necesitamos que establezcas una nueva contraseña. Gracias por tu comprensión.';

  @override
  String get youAreLeavingLichess => 'Estás saliendo de Lichess';

  @override
  String get neverTypeYourPassword => '¡Nunca expongas tu contraseña de Lichess en otro sitio!';

  @override
  String proceedToX(String param) {
    return 'Ir a $param';
  }

  @override
  String get passwordSuggestion => 'No establezcas una contraseña sugerida por otra persona. La usarán para robar tu cuenta.';

  @override
  String get emailSuggestion => 'No establezcas una dirección de correo electrónico sugerida por otra persona. La usarán para robar tu cuenta.';

  @override
  String get emailConfirmHelp => 'Ayuda con la confirmación del correo';

  @override
  String get emailConfirmNotReceived => '¿No recibiste un correo de confirmación tras registrarte?';

  @override
  String get whatSignupUsername => '¿Qué nombre de usuario utilizaste para registrarte?';

  @override
  String usernameNotFound(String param) {
    return 'No pudimos encontrar ningún usuario con este nombre: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Puedes usar este nombre de usuario para crear una nueva cuenta';

  @override
  String emailSent(String param) {
    return 'Hemos enviado un correo a $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Puede tardar un poco en llegar.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Espera 5 minutos y actualiza tu bandeja de entrada.';

  @override
  String get checkSpamFolder => 'Comprueba tu carpeta de spam, puede que haya terminado ahí. Si es así, por favor, márcalo como no spam.';

  @override
  String get emailForSignupHelp => 'Si todo lo demás falla, envíanos este correo:';

  @override
  String copyTextToEmail(String param) {
    return 'Copiar y pegar el texto anterior y enviarlo a $param';
  }

  @override
  String get waitForSignupHelp => 'Nos pondremos en contacto contigo dentro de poco para ayudarte a completar el registro.';

  @override
  String accountConfirmed(String param) {
    return 'El usuario $param se ha confirmado correctamente.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Puedes iniciar sesión ahora como $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'No necesitas un correo de confirmación.';

  @override
  String accountClosed(String param) {
    return 'La cuenta $param está cerrada.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'La cuenta $param se registró sin un correo.';
  }

  @override
  String get rank => 'Posición';

  @override
  String rankX(String param) {
    return 'Clasificación: $param';
  }

  @override
  String get gamesPlayed => 'Partidas jugadas';

  @override
  String get cancel => 'Cancelar';

  @override
  String get whiteTimeOut => 'Las blancas agotaron su tiempo';

  @override
  String get blackTimeOut => 'Las negras agotaron su tiempo';

  @override
  String get drawOfferSent => 'Oferta de tablas enviada';

  @override
  String get drawOfferAccepted => 'Oferta de tablas aceptada';

  @override
  String get drawOfferCanceled => 'Oferta de tablas cancelada';

  @override
  String get whiteOffersDraw => 'Las blancas ofrecen tablas';

  @override
  String get blackOffersDraw => 'Las negras ofrecen tablas';

  @override
  String get whiteDeclinesDraw => 'Las blancas rechazan tablas';

  @override
  String get blackDeclinesDraw => 'Las negras rechazan tablas';

  @override
  String get yourOpponentOffersADraw => 'Tu oponente ofrece tablas';

  @override
  String get accept => 'Aceptar';

  @override
  String get decline => 'Rechazar';

  @override
  String get playingRightNow => 'En juego ahora mismo';

  @override
  String get eventInProgress => 'Se está jugando ahora';

  @override
  String get finished => 'Terminado';

  @override
  String get abortGame => 'Cancelar partida';

  @override
  String get gameAborted => 'Partida cancelada';

  @override
  String get standard => 'Estándar';

  @override
  String get customPosition => 'Posición personalizada';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String get mode => 'Modo';

  @override
  String get casual => 'Amistosa';

  @override
  String get rated => 'Por puntos';

  @override
  String get casualTournament => 'Amistosa';

  @override
  String get ratedTournament => 'Por puntos';

  @override
  String get thisGameIsRated => 'Esta partida es por puntos';

  @override
  String get rematch => 'Revancha';

  @override
  String get rematchOfferSent => 'Oferta de revancha enviada';

  @override
  String get rematchOfferAccepted => 'Oferta de revancha aceptada';

  @override
  String get rematchOfferCanceled => 'Oferta de revancha cancelada';

  @override
  String get rematchOfferDeclined => 'Oferta de revancha rechazada';

  @override
  String get cancelRematchOffer => 'Cancelar oferta de revancha';

  @override
  String get viewRematch => 'Ver revancha';

  @override
  String get confirmMove => 'Confirmar movimiento';

  @override
  String get play => 'Jugar';

  @override
  String get inbox => 'Mensajes';

  @override
  String get chatRoom => 'Sala de chat';

  @override
  String get loginToChat => 'Inicia sesión para chatear';

  @override
  String get youHaveBeenTimedOut => 'Has sido silenciado temporalmente.';

  @override
  String get spectatorRoom => 'Chat de espectador';

  @override
  String get composeMessage => 'Escribir mensaje';

  @override
  String get subject => 'Asunto';

  @override
  String get send => 'Enviar';

  @override
  String get incrementInSeconds => 'Segundos de incremento';

  @override
  String get freeOnlineChess => 'Ajedrez en línea gratis';

  @override
  String get exportGames => 'Exportar partidas';

  @override
  String get ratingRange => 'Rango de puntuación';

  @override
  String get thisAccountViolatedTos => 'Este usuario no cumple los términos de servicio de Lichess';

  @override
  String get openingExplorerAndTablebase => 'Explorador de aperturas y base de datos de finales';

  @override
  String get takeback => 'Deshacer jugada';

  @override
  String get proposeATakeback => 'Proponer deshacer jugada';

  @override
  String get takebackPropositionSent => 'Propuesta de deshacer jugada enviada';

  @override
  String get takebackPropositionDeclined => 'Propuesta de deshacer jugada rechazada';

  @override
  String get takebackPropositionAccepted => 'Propuesta de deshacer jugada aceptada';

  @override
  String get takebackPropositionCanceled => 'Propuesta de deshacer jugada cancelada';

  @override
  String get yourOpponentProposesATakeback => 'Tu oponente propone deshacer la jugada';

  @override
  String get bookmarkThisGame => 'Marcar este juego como favorito';

  @override
  String get tournament => 'Torneo';

  @override
  String get tournaments => 'Torneos';

  @override
  String get tournamentPoints => 'Puntos de torneo';

  @override
  String get viewTournament => 'Ver torneo';

  @override
  String get backToTournament => 'Volver al torneo';

  @override
  String get noDrawBeforeSwissLimit => 'No puedes hacer tablas antes de que se jueguen 30 movimientos en un torneo suizo.';

  @override
  String get thematic => 'Temático';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Tu puntuación de $param es provisional';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Tu puntuación de $param1 ($param2) es demasiado alta';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Tu máxima puntación semanal de $param1 ($param2) es demasiado alta';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Tu puntuación de $param1 ($param2) es demasiado baja';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Puntuación ≥ $param1 en $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Puntuación ≤ $param1 en $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Debes ser del equipo $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'No estás en el equipo $param';
  }

  @override
  String get backToGame => 'Volver a la partida';

  @override
  String get siteDescription => 'Servidor de ajedrez en línea gratuito. Juega al ajedrez en una interfaz simple. Sin registro, sin publicidad, sin necesidad de complementos. Juega contra el ordenador, amigos u oponentes desconocidos.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 se unió al equipo $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 creó el equipo $param2';
  }

  @override
  String get startedStreaming => 'comenzó a retransmitir';

  @override
  String xStartedStreaming(String param) {
    return '$param comenzó a emitir';
  }

  @override
  String get averageElo => 'Puntuación promedio';

  @override
  String get location => 'Ubicación';

  @override
  String get filterGames => 'Filtrar partidas';

  @override
  String get reset => 'Reiniciar';

  @override
  String get apply => 'Aplicar cambios';

  @override
  String get save => 'Guardar';

  @override
  String get leaderboard => 'Clasificación';

  @override
  String get screenshotCurrentPosition => 'Hacer captura de pantalla de la posición actual';

  @override
  String get gameAsGIF => 'Guardar partida en formato GIF';

  @override
  String get pasteTheFenStringHere => 'Pega el texto FEN aquí';

  @override
  String get pasteThePgnStringHere => 'Pega el texto PGN aquí';

  @override
  String get orUploadPgnFile => 'O sube un archivo PGN';

  @override
  String get fromPosition => 'Desde posición';

  @override
  String get continueFromHere => 'Continuar desde aquí';

  @override
  String get toStudy => 'Estudiar';

  @override
  String get importGame => 'Importar partida';

  @override
  String get importGameExplanation => 'Al pegar el PGN de una partida, se obtiene una repetición navegable, un análisis por ordenador, un chat de juego y un enlace para compartir.';

  @override
  String get importGameCaveat => 'Las variaciones serán borradas. Para mantenerlas, importa el PGN a través de un estudio.';

  @override
  String get importGameDataPrivacyWarning => 'Este PGN es de acceso público. Para importar una partida de forma privada, utiliza un estudio.';

  @override
  String get thisIsAChessCaptcha => 'Esto es un CAPTCHA de ajedrez.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Haz clic en el tablero para hacer tu jugada y demostrar que eres humano.';

  @override
  String get captcha_fail => 'Por favor, resuelva el captcha de ajedrez.';

  @override
  String get notACheckmate => 'No es jaque mate';

  @override
  String get whiteCheckmatesInOneMove => 'Juegan blancas y dan mate en una';

  @override
  String get blackCheckmatesInOneMove => 'Juegan negras y dan mate en una';

  @override
  String get retry => 'Reintentar';

  @override
  String get reconnecting => 'Reconectando';

  @override
  String get noNetwork => 'Sin conexión';

  @override
  String get favoriteOpponents => 'Oponentes favoritos';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Siguiendo';

  @override
  String get unfollow => 'Dejar de seguir';

  @override
  String followX(String param) {
    return 'Seguir a $param';
  }

  @override
  String unfollowX(String param) {
    return 'Dejar de seguir a $param';
  }

  @override
  String get block => 'Bloquear';

  @override
  String get blocked => 'Bloqueado';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get followsYou => 'Te sigue';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 comenzó a seguir a $param2';
  }

  @override
  String get more => 'Más';

  @override
  String get memberSince => 'Miembro desde';

  @override
  String lastSeenActive(String param) {
    return 'Última visita $param';
  }

  @override
  String get player => 'Jugador';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Gráfico';

  @override
  String get required => 'Obligatorio.';

  @override
  String get openTournaments => 'Torneos abiertos';

  @override
  String get duration => 'Duración';

  @override
  String get winner => 'Ganador';

  @override
  String get standing => 'Posición';

  @override
  String get createANewTournament => 'Crear un nuevo torneo';

  @override
  String get tournamentCalendar => 'Calendario de torneos';

  @override
  String get conditionOfEntry => 'Requisito de entrada:';

  @override
  String get advancedSettings => 'Configuración avanzada';

  @override
  String get safeTournamentName => 'Escoge un nombre muy seguro para el torneo.';

  @override
  String get inappropriateNameWarning => 'Cualquier comportamiento mínimamente inapropiado podría conllevar al cierre de tu cuenta.';

  @override
  String get emptyTournamentName => 'Déjalo en blanco para poner al torneo el nombre de un Gran Maestro al azar.';

  @override
  String get makePrivateTournament => 'Hacer el torneo privado y restringir el acceso con una contraseña';

  @override
  String get join => 'Unirse';

  @override
  String get withdraw => 'Abandonar';

  @override
  String get points => 'Puntos';

  @override
  String get wins => 'Victorias';

  @override
  String get losses => 'Derrotas';

  @override
  String get createdBy => 'Creado por';

  @override
  String get tournamentIsStarting => 'El torneo va a empezar';

  @override
  String get tournamentPairingsAreNowClosed => 'Los emparejamientos del torneo están cerrados.';

  @override
  String standByX(String param) {
    return 'Espera $param, emparejando jugadores, ¡prepárate!';
  }

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Reanudar';

  @override
  String get youArePlaying => '¡Te toca jugar!';

  @override
  String get winRate => 'Tasa de victorias';

  @override
  String get berserkRate => 'Tasa de berserk';

  @override
  String get performance => 'Actuación';

  @override
  String get tournamentComplete => 'Torneo terminado';

  @override
  String get movesPlayed => 'Movimientos';

  @override
  String get whiteWins => 'Victorias blancas';

  @override
  String get blackWins => 'Victorias negras';

  @override
  String get drawRate => 'Porcentaje de tablas';

  @override
  String get draws => 'Tablas';

  @override
  String nextXTournament(String param) {
    return 'Siguiente torneo $param:';
  }

  @override
  String get averageOpponent => 'Oponente promedio';

  @override
  String get boardEditor => 'Editor de tablero';

  @override
  String get setTheBoard => 'Configurar tablero';

  @override
  String get popularOpenings => 'Aperturas populares';

  @override
  String get endgamePositions => 'Posiciones de finales';

  @override
  String chess960StartPosition(String param) {
    return 'Posición inicial de Chess960: $param';
  }

  @override
  String get startPosition => 'Posición inicial';

  @override
  String get clearBoard => 'Limpiar el tablero';

  @override
  String get loadPosition => 'Cargar posicion';

  @override
  String get isPrivate => 'Privado';

  @override
  String reportXToModerators(String param) {
    return 'Denunciar a $param a los moderadores';
  }

  @override
  String profileCompletion(String param) {
    return 'Perfil completado al $param';
  }

  @override
  String xRating(String param) {
    return 'Puntuación $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Si no aplica, déjalo en blanco';

  @override
  String get profile => 'Perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get realName => 'Nombre real';

  @override
  String get setFlair => 'Configura tu entorno';

  @override
  String get flair => 'Entorno';

  @override
  String get youCanHideFlair => 'Existe una opción para ocultar la configuración de entorno en todo el sitio.';

  @override
  String get biography => 'Biografía';

  @override
  String get countryRegion => 'País o región';

  @override
  String get thankYou => '¡Gracias!';

  @override
  String get socialMediaLinks => 'Enlaces a redes sociales';

  @override
  String get oneUrlPerLine => 'Un enlace por línea.';

  @override
  String get inlineNotation => 'Notación compacta';

  @override
  String get makeAStudy => 'Para guardar y compartir, considera hacer un estudio.';

  @override
  String get clearSavedMoves => 'Borrar movimientos';

  @override
  String get previouslyOnLichessTV => 'Anteriormente en Lichess TV';

  @override
  String get onlinePlayers => 'Jugadores conectados';

  @override
  String get activePlayers => 'Jugadores activos';

  @override
  String get bewareTheGameIsRatedButHasNoClock => '¡Cuidado, el juego es por puntos pero sin límite de tiempo!';

  @override
  String get success => 'Éxito';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Pasar automáticamente a la siguiente partida después de mover';

  @override
  String get autoSwitch => 'Cambio automático';

  @override
  String get puzzles => 'Ejercicios';

  @override
  String get onlineBots => 'Bots en línea';

  @override
  String get name => 'Nombre';

  @override
  String get description => 'Descripción';

  @override
  String get descPrivate => 'Descripción privada';

  @override
  String get descPrivateHelp => 'Este texto sólo pueden verlo los miembros del equipo. El texto que escribas aquí reemplazará tu descripción pública cuando sea vista por los miembros del equipo.';

  @override
  String get no => 'No';

  @override
  String get yes => 'Sí';

  @override
  String get help => 'Ayuda:';

  @override
  String get createANewTopic => 'Crear un tema nuevo';

  @override
  String get topics => 'Temas';

  @override
  String get posts => 'Publicaciones';

  @override
  String get lastPost => 'Última publicación';

  @override
  String get views => 'Visitas';

  @override
  String get replies => 'Respuestas';

  @override
  String get replyToThisTopic => 'Responder a este tema';

  @override
  String get reply => 'Responder';

  @override
  String get message => 'Mensaje';

  @override
  String get createTheTopic => 'Crear tema';

  @override
  String get reportAUser => 'Denunciar a un usuario';

  @override
  String get user => 'Usuario';

  @override
  String get reason => 'Motivo';

  @override
  String get whatIsIheMatter => '¿Qué ocurre?';

  @override
  String get cheat => 'Trampa';

  @override
  String get troll => 'Acoso';

  @override
  String get other => 'Otro';

  @override
  String get reportDescriptionHelp => 'Pega el enlace a la(s) partida(s) y explícanos qué hay de malo en el comportamiento de este usuario. No digas simplemente \"hace trampa\"; explícanos cómo has llegado a esta conclusión. Tu informe será procesado más rápido si está escrito en inglés.';

  @override
  String get error_provideOneCheatedGameLink => 'Por favor, proporciona al menos un enlace a una partida en la que se hicieron trampas.';

  @override
  String by(String param) {
    return 'por $param';
  }

  @override
  String importedByX(String param) {
    return 'Importado por $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Este tema está cerrado.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notas';

  @override
  String get typePrivateNotesHere => 'Escribe aquí tus notas privadas';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Escribe una nota privada sobre este usuario';

  @override
  String get noNoteYet => 'Aún no hay notas';

  @override
  String get invalidUsernameOrPassword => 'Nombre de usuario o contraseña erróneo';

  @override
  String get incorrectPassword => 'Contraseña incorrecta';

  @override
  String get invalidAuthenticationCode => 'Código de autenticación inválido';

  @override
  String get emailMeALink => 'Envíame un enlace por correo electrónico';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get newPasswordAgain => 'Nueva contraseña (otra vez)';

  @override
  String get newPasswordsDontMatch => 'Las contraseñas nuevas no coinciden';

  @override
  String get newPasswordStrength => 'Seguridad de la contraseña';

  @override
  String get clockInitialTime => 'Tiempo inicial del reloj';

  @override
  String get clockIncrement => 'Incremento';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get letOtherPlayersFollowYou => 'Permitir que otros jugadores te sigan';

  @override
  String get letOtherPlayersChallengeYou => 'Permitir que otros jugadores te desafíen';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Permitir que otros jugadores te inviten a estudios';

  @override
  String get sound => 'Sonido';

  @override
  String get none => 'Ninguna';

  @override
  String get fast => 'Rápido';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Lento';

  @override
  String get insideTheBoard => 'Dentro del tablero';

  @override
  String get outsideTheBoard => 'Fuera del tablero';

  @override
  String get allSquaresOfTheBoard => 'Todas las casillas del tablero';

  @override
  String get onSlowGames => 'En partidas lentas';

  @override
  String get always => 'Siempre';

  @override
  String get never => 'Nunca';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 compite en $param2';
  }

  @override
  String get victory => 'Victoria';

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
  String get timeline => 'Cronología';

  @override
  String get starting => 'Comienzo:';

  @override
  String get allInformationIsPublicAndOptional => 'Toda la información es pública y opcional.';

  @override
  String get biographyDescription => 'Cuéntanos sobre ti, qué te gusta del ajedrez, tus aperturas favoritas, partidas, jugadores…';

  @override
  String get listBlockedPlayers => 'Lista de jugadores que has bloqueado';

  @override
  String get human => 'Humano';

  @override
  String get computer => 'Ordenador';

  @override
  String get side => 'Color';

  @override
  String get clock => 'Reloj';

  @override
  String get opponent => 'Oponente';

  @override
  String get learnMenu => 'Aprender';

  @override
  String get studyMenu => 'Estudiar';

  @override
  String get practice => 'Practicar';

  @override
  String get community => 'Comunidad';

  @override
  String get tools => 'Herramientas';

  @override
  String get increment => 'Incremento';

  @override
  String get error_unknown => 'Valor no válido';

  @override
  String get error_required => 'Este campo es obligatorio';

  @override
  String get error_email => 'Esta dirección de correo electrónico es inválida';

  @override
  String get error_email_acceptable => 'Esta dirección de correo electrónico no es aceptable. Por favor, compruébala e intenta de nuevo.';

  @override
  String get error_email_unique => 'Dirección de correo no válida o en uso';

  @override
  String get error_email_different => 'Esta ya es tu dirección de correo electrónico';

  @override
  String error_minLength(String param) {
    return 'Debe tener $param caracteres como mínimo';
  }

  @override
  String error_maxLength(String param) {
    return 'Debe tener $param caracteres como máximo';
  }

  @override
  String error_min(String param) {
    return 'Debe ser mayor o igual a $param';
  }

  @override
  String error_max(String param) {
    return 'Debe ser como máximo $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Si la puntuación es ± $param';
  }

  @override
  String get ifRegistered => 'Si está registrado';

  @override
  String get onlyExistingConversations => 'Solo conversaciones existentes';

  @override
  String get onlyFriends => 'Sólo amigos';

  @override
  String get menu => 'Menú';

  @override
  String get castling => 'Enroque';

  @override
  String get whiteCastlingKingside => 'Blancas O-O';

  @override
  String get blackCastlingKingside => 'Negras O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tiempo total jugado: $param';
  }

  @override
  String get watchGames => 'Ver partidas';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tiempo transcurrido en TV: $param';
  }

  @override
  String get watch => 'Ver';

  @override
  String get videoLibrary => 'Videoteca';

  @override
  String get streamersMenu => 'Presentadores';

  @override
  String get mobileApp => 'Aplicación para móviles';

  @override
  String get webmasters => 'Desarrolladores';

  @override
  String get about => 'Acerca de';

  @override
  String aboutX(String param) {
    return 'Acerca de $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 es un servidor de ajedrez libre y gratuito ($param2) de código abierto y sin publicidad.';
  }

  @override
  String get really => 'realmente';

  @override
  String get contribute => 'Contribuir';

  @override
  String get termsOfService => 'Condiciones del servicio';

  @override
  String get sourceCode => 'Código fuente';

  @override
  String get simultaneousExhibitions => 'Partidas simultáneas';

  @override
  String get host => 'Anfitrión';

  @override
  String hostColorX(String param) {
    return 'Color del anfitrión: $param';
  }

  @override
  String get yourPendingSimuls => 'Tus simultáneas pendientes';

  @override
  String get createdSimuls => 'Simultáneas nuevas';

  @override
  String get hostANewSimul => 'Crear una nueva simultánea';

  @override
  String get signUpToHostOrJoinASimul => 'Regístrate para crear o unirte a una simultánea';

  @override
  String get noSimulFound => 'Simultánea no encontrada';

  @override
  String get noSimulExplanation => 'Esta exhibición simultánea no existe.';

  @override
  String get returnToSimulHomepage => 'Volver a la página de simultáneas';

  @override
  String get aboutSimul => 'En las simultáneas, un jugador se enfrenta a varios oponentes al mismo tiempo.';

  @override
  String get aboutSimulImage => 'De 50 oponentes, Fischer ganó 47 partidas, empató dos y perdió una.';

  @override
  String get aboutSimulRealLife => 'El concepto de simultáneas en Lichess se toma de la vida real, donde el anfitrión va de mesa en mesa haciendo sus jugadas.';

  @override
  String get aboutSimulRules => 'Cuando la simultánea empieza, cada jugador comienza una partida con el anfitrión, que juega con blancas. La simultánea termina cuando se acaban todas las partidas.';

  @override
  String get aboutSimulSettings => 'Las simultáneas son siempre partidas amistosas. Las opciones de petición de revancha, deshacer jugada y agregar tiempo están deshabilitadas.';

  @override
  String get create => 'Crear';

  @override
  String get whenCreateSimul => 'Cuando creas una simultánea, juegas contra varios jugadores a la vez.';

  @override
  String get simulVariantsHint => 'Si seleccionas diferentes variantes, cada jugador escoge cuál jugar.';

  @override
  String get simulClockHint => 'Configuración de reloj Fischer. Cuantos más oponentes, más tiempo se necesita.';

  @override
  String get simulAddExtraTime => 'Puedes añadir tiempo adicional a tu reloj para ayudarte en la simultánea.';

  @override
  String get simulHostExtraTime => 'Tiempo extra del anfitrión';

  @override
  String get simulAddExtraTimePerPlayer => 'Añadir tiempo inicial a tu reloj por cada jugador que se una a la simultánea.';

  @override
  String get simulHostExtraTimePerPlayer => 'Tiempo extra del anfitrión por cada jugador';

  @override
  String get lichessTournaments => 'Torneos de Lichess';

  @override
  String get tournamentFAQ => 'Preguntas frecuentes de los torneos';

  @override
  String get timeBeforeTournamentStarts => 'Tiempo antes de que comience el torneo';

  @override
  String get averageCentipawnLoss => 'Pérdida promedio en centipeones';

  @override
  String get accuracy => 'Precisión';

  @override
  String get keyboardShortcuts => 'Atajos del teclado';

  @override
  String get keyMoveBackwardOrForward => 'movimiento hacia atrás y hacia adelante';

  @override
  String get keyGoToStartOrEnd => 'ir al inicio/fin';

  @override
  String get keyCycleSelectedVariation => 'Alterna la variante seleccionada';

  @override
  String get keyShowOrHideComments => 'mostrar/ocultar comentarios';

  @override
  String get keyEnterOrExitVariation => 'entrar/salir de la variante';

  @override
  String get keyRequestComputerAnalysis => 'Solicitar análisis del ordenador, Aprende de tus errores';

  @override
  String get keyNextLearnFromYourMistakes => 'Siguiente (Aprende de tus errores)';

  @override
  String get keyNextBlunder => 'Siguiente error grave';

  @override
  String get keyNextMistake => 'Siguiente error';

  @override
  String get keyNextInaccuracy => 'Siguiente imprecisión';

  @override
  String get keyPreviousBranch => 'Rama anterior';

  @override
  String get keyNextBranch => 'Rama siguiente';

  @override
  String get toggleVariationArrows => 'Activar/Desactivar flechas de variantes';

  @override
  String get cyclePreviousOrNextVariation => 'Alterna entre la variante siguiente y la anterior';

  @override
  String get toggleGlyphAnnotations => 'Activa o desactiva la anotación de figurines';

  @override
  String get togglePositionAnnotations => 'Alternar anotaciones de posición';

  @override
  String get variationArrowsInfo => 'Las flechas de variantes te permiten navegar sin usar la lista de movimientos.';

  @override
  String get playSelectedMove => 'hacer movimiento seleccionado';

  @override
  String get newTournament => 'Nuevo torneo';

  @override
  String get tournamentHomeTitle => 'Torneos de ajedrez con diferentes variantes y controles de tiempo';

  @override
  String get tournamentHomeDescription => '¡Juega torneos de ajedrez rápido! Únete a un torneo oficial programado o crea el tuyo propio. Bala, Relámpago, Clásico, Ajedrez960, Rey de la Colina, Tres jaques y más opciones disponibles para una diversión sin fin en ajedrez.';

  @override
  String get tournamentNotFound => 'No se encontró el torneo';

  @override
  String get tournamentDoesNotExist => 'Este torneo no existe.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Puede que se haya cancelado, si todos los jugadores se fueron antes de que empezara el torneo.';

  @override
  String get returnToTournamentsHomepage => 'Volver a la página principal de torneos';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Distribución mensual de puntos en $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Tu puntuación en $param1 es $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Eres mejor que el $param1 de los jugadores de $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 es mejor que el $param2 de los jugadores de $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Mejor que el $param1 de $param2 jugadores';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'No tienes una puntuación de $param  establecida.';
  }

  @override
  String get yourRating => 'Tu puntuación';

  @override
  String get cumulative => 'Acumulado';

  @override
  String get glicko2Rating => 'Puntuación Glicko-2';

  @override
  String get checkYourEmail => 'Revisa tu correo';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Te hemos enviado un correo. Activa tu cuenta en el enlace proporcionado.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Si no encuentras el correo, mira a ver si está en otras carpetas (spam, social, ...).';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Te hemos enviado un correo a $param. Restablece tu contraseña haciendo clic en el enlace.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Al registrarte, aceptas las $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lee acerca de nuestra $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Retardo de conexión entre tú y lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tiempo para procesar un movimiento en el servidor de Lichess';

  @override
  String get downloadAnnotated => 'Descargar la partida anotada';

  @override
  String get downloadRaw => 'Descargar la partida sin anotar';

  @override
  String get downloadImported => 'Descargar la partida importada';

  @override
  String get crosstable => 'Tabla cruzada';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'También puedes usar la rueda del ratón para desplazarte por la partida.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Mantén pulsado sobre las variantes del análisis para previsualizarlas.';

  @override
  String get analysisShapesHowTo => 'Haz clic con el botón derecho o Máyus+clic para dibujar círculos y flechas en el tablero.';

  @override
  String get letOtherPlayersMessageYou => 'Permitir que otras personas te envíen mensajes';

  @override
  String get receiveForumNotifications => 'Recibir notificaciones cuando alguien te mencione en el foro';

  @override
  String get shareYourInsightsData => 'Comparte tus datos estadísticos';

  @override
  String get withNobody => 'Con nadie';

  @override
  String get withFriends => 'Con mis amigos';

  @override
  String get withEverybody => 'Con todo el mundo';

  @override
  String get kidMode => 'Modo infantil';

  @override
  String get kidModeIsEnabled => 'El modo infantil está activado.';

  @override
  String get kidModeExplanation => 'Por seguridad, en el modo infantil se desactivan todas las comunicaciones con otros usuarios. Activa esto para proteger a los menores de otros usuarios de Internet.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'En el modo infantil, el logo de lichess tiene un icono de $param, indicando que los niños están seguros.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Tu cuenta está administrada. Pídele a tu profesor de ajedrez que desactive el modo para niños.';

  @override
  String get enableKidMode => 'Activar el modo infantil';

  @override
  String get disableKidMode => 'Desactivar el modo infantil';

  @override
  String get security => 'Seguridad';

  @override
  String get sessions => 'Sesiones';

  @override
  String get revokeAllSessions => 'cerrar todas las sesiones';

  @override
  String get playChessEverywhere => 'Juega al ajedrez donde sea';

  @override
  String get asFreeAsLichess => 'Tan gratis como lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Construido por amor al ajedrez, no por dinero';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Todos tienen acceso gratuito a todas las funciones';

  @override
  String get zeroAdvertisement => 'Sin anuncios';

  @override
  String get fullFeatured => 'Todas las funciones';

  @override
  String get phoneAndTablet => 'Teléfono y tablet';

  @override
  String get bulletBlitzClassical => 'Bala, relámpago, clásico';

  @override
  String get correspondenceChess => 'Ajedrez por correspondencia';

  @override
  String get onlineAndOfflinePlay => 'Jugar en línea o sin conexión';

  @override
  String get viewTheSolution => 'Ver la solución';

  @override
  String get followAndChallengeFriends => 'Sigue y reta a amigos';

  @override
  String get gameAnalysis => 'Análisis de la partida';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 crea $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 se une a $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return 'a $param1 le gusta $param2';
  }

  @override
  String get quickPairing => 'Emparejamiento rápido';

  @override
  String get lobby => 'Sala de espera';

  @override
  String get anonymous => 'Anónimo';

  @override
  String yourScore(String param) {
    return 'Tu puntuación: $param';
  }

  @override
  String get language => 'Idioma';

  @override
  String get background => 'Fondo';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get transparent => 'Transparente';

  @override
  String get deviceTheme => 'Tema del dispositivo';

  @override
  String get backgroundImageUrl => 'URL de imagen de fondo:';

  @override
  String get board => 'Tablero';

  @override
  String get size => 'Tamaño';

  @override
  String get opacity => 'Opacidad';

  @override
  String get brightness => 'Brillo';

  @override
  String get hue => 'Tono';

  @override
  String get boardReset => 'Restablecer colores predeterminados';

  @override
  String get pieceSet => 'Estilo de piezas';

  @override
  String get embedInYourWebsite => 'Añadir a mi sitio';

  @override
  String get usernameAlreadyUsed => 'Este nombre de usuario ya existe. Pruebe con otro, por favor.';

  @override
  String get usernamePrefixInvalid => 'El nombre de usuario debe comenzar con una letra.';

  @override
  String get usernameSuffixInvalid => 'El nombre de usuario debe finalizar con una letra o un número.';

  @override
  String get usernameCharsInvalid => 'El nombre de usuario debe contener sólo letras, números, guiones bajos y guiones.';

  @override
  String get usernameUnacceptable => 'Este nombre de usuario no es válido.';

  @override
  String get playChessInStyle => 'Juega al ajedrez con estilo';

  @override
  String get chessBasics => 'Fundamentos del ajedrez';

  @override
  String get coaches => 'Entrenadores';

  @override
  String get invalidPgn => 'PGN inválido';

  @override
  String get invalidFen => 'FEN inválido';

  @override
  String get custom => 'Personalizado';

  @override
  String get notifications => 'Notificaciones';

  @override
  String notificationsX(String param1) {
    return 'Notificaciones: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Puntuación: $param';
  }

  @override
  String get practiceWithComputer => 'Practicar con el ordenador';

  @override
  String anotherWasX(String param) {
    return 'Otro era $param';
  }

  @override
  String bestWasX(String param) {
    return 'El mejor era $param';
  }

  @override
  String get youBrowsedAway => 'Has salido de la revisión';

  @override
  String get resumePractice => 'Volver a la revisión de errores';

  @override
  String get drawByFiftyMoves => 'La partida ha acabado en tablas por la regla de los cincuenta movimientos.';

  @override
  String get theGameIsADraw => 'La partida es tablas.';

  @override
  String get computerThinking => 'El ordenador está calculando...';

  @override
  String get seeBestMove => 'Ver el mejor movimiento';

  @override
  String get hideBestMove => 'Ocultar el mejor movimiento';

  @override
  String get getAHint => 'Pedir una pista';

  @override
  String get evaluatingYourMove => 'Evaluando tu movimiento ...';

  @override
  String get whiteWinsGame => 'Ganan las blancas';

  @override
  String get blackWinsGame => 'Ganan las negras';

  @override
  String get learnFromYourMistakes => 'Aprende de tus errores';

  @override
  String get learnFromThisMistake => 'Aprende de este error';

  @override
  String get skipThisMove => 'Omitir este movimiento';

  @override
  String get next => 'Siguiente';

  @override
  String xWasPlayed(String param) {
    return 'se jugó $param';
  }

  @override
  String get findBetterMoveForWhite => 'Encuentra un movimiento mejor para las blancas';

  @override
  String get findBetterMoveForBlack => 'Encuentra un movimiento mejor para las negras';

  @override
  String get resumeLearning => 'Continuar el aprendizaje';

  @override
  String get youCanDoBetter => 'Puedes hacerlo mejor';

  @override
  String get tryAnotherMoveForWhite => 'Prueba con otro movimiento para las blancas';

  @override
  String get tryAnotherMoveForBlack => 'Prueba con otro movimiento para las negras';

  @override
  String get solution => 'Solución';

  @override
  String get waitingForAnalysis => 'Esperando análisis';

  @override
  String get noMistakesFoundForWhite => 'No hay errores del blanco';

  @override
  String get noMistakesFoundForBlack => 'No hay errores del negro';

  @override
  String get doneReviewingWhiteMistakes => 'Revisión de errores del blanco terminada';

  @override
  String get doneReviewingBlackMistakes => 'Revisión de errores del negro terminada';

  @override
  String get doItAgain => 'Volver a revisar los errores';

  @override
  String get reviewWhiteMistakes => 'Revisar los errores del blanco';

  @override
  String get reviewBlackMistakes => 'Revisar los errores del negro';

  @override
  String get advantage => 'Ventaja';

  @override
  String get opening => 'Apertura';

  @override
  String get middlegame => 'Medio juego';

  @override
  String get endgame => 'Final';

  @override
  String get conditionalPremoves => 'Movimientos condicionales';

  @override
  String get addCurrentVariation => 'Añadir la variante actual';

  @override
  String get playVariationToCreateConditionalPremoves => 'Juega una variante para crear movimientos condicionales';

  @override
  String get noConditionalPremoves => 'Sin movimientos condicionales';

  @override
  String playX(String param) {
    return 'Jugar $param';
  }

  @override
  String get showUnreadLichessMessage => 'Has recibido un mensaje privado de Lichess.';

  @override
  String get clickHereToReadIt => 'Haz clic aquí para leerlo';

  @override
  String get sorry => 'Lo sentimos :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Hemos tenido que suspenderte temporalmente.';

  @override
  String get why => '¿Por qué?';

  @override
  String get pleasantChessExperience => 'Nuestro objetivo es proporcionar una experiencia agradable a todo el mundo.';

  @override
  String get goodPractice => 'Para ello, debemos asegurarnos de que todos los jugadores se comportan como es debido.';

  @override
  String get potentialProblem => 'Cuando detectamos un posible problema, mostramos este mensaje.';

  @override
  String get howToAvoidThis => '¿Cómo evitar esto?';

  @override
  String get playEveryGame => 'Juega todas las partidas que empieces.';

  @override
  String get tryToWin => 'Intenta ganar (o, al menos, empatar) cada partida que juegues.';

  @override
  String get resignLostGames => 'Abandona en posiciones perdidas (no dejes que el tiempo se agote sin más).';

  @override
  String get temporaryInconvenience => 'Te pedimos disculpas por las molestias';

  @override
  String get wishYouGreatGames => 'y esperamos que disfrutes de lichess.org.';

  @override
  String get thankYouForReading => '¡Gracias por tomarte el tiempo para leer esto!';

  @override
  String get lifetimeScore => 'Puntuación histórica';

  @override
  String get currentMatchScore => 'Resultados de este enfrentamiento';

  @override
  String get agreementAssistance => 'Me comprometo a no recibir ayuda externa durante mis partidas (de un ordenador, un libro, una base de datos u otra persona).';

  @override
  String get agreementNice => 'Me comprometo a respetar siempre a otros jugadores.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Estoy de acuerdo en no crear varias cuentas (excepto por las razones indicadas en las $param).';
  }

  @override
  String get agreementPolicy => 'Me comprometo a seguir las normas de Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Buscar o empezar una nueva conversación';

  @override
  String get edit => 'Editar';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rápida';

  @override
  String get classical => 'Clásica';

  @override
  String get ultraBulletDesc => 'Partidas increíblemente rápidas: menos de 30 segundos';

  @override
  String get bulletDesc => 'Partidas muy rápidas: menos de 3 minutos';

  @override
  String get blitzDesc => 'Partidas rápidas: de 3 a 8 minutos';

  @override
  String get rapidDesc => 'Partidas rápidas: 8 a 25 minutos';

  @override
  String get classicalDesc => 'Partidas clásicas: 25 minutos o más';

  @override
  String get correspondenceDesc => 'Partidas por correspondencia: uno o varios días por jugada';

  @override
  String get puzzleDesc => 'Entrenador de táctica de ajedrez';

  @override
  String get important => 'Importante';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Puede que tu pregunta ya tenga respuesta $param1';
  }

  @override
  String get inTheFAQ => 'en las preguntas frecuentes.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Para denunciar a un usuario por tramposo o por mal comportamiento, $param1';
  }

  @override
  String get useTheReportForm => 'usa el formulario de informe';

  @override
  String toRequestSupport(String param1) {
    return 'Para solicitar soporte, $param1';
  }

  @override
  String get tryTheContactPage => 'prueba la página de contacto';

  @override
  String makeSureToRead(String param1) {
    return 'Asegúrate de leer $param1';
  }

  @override
  String get theForumEtiquette => 'las reglas del foro';

  @override
  String get thisTopicIsArchived => 'Este tema ha sido archivado y ya no admite respuestas.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Únete a $param1 para publicar en este foro';
  }

  @override
  String teamNamedX(String param1) {
    return 'equipo $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Aún no puedes publicar en los foros. ¡Juega algunas partidas!';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get unsubscribe => 'Cancelar la suscripción';

  @override
  String mentionedYouInX(String param1) {
    return 'te mencionó en \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 te mencionó en \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'te invitó a \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 te invitó a \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Ahora eres miembro del equipo.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Te has unido a \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Un usuario que denunciaste fue expulsado';

  @override
  String get congratsYouWon => '¡Enhorabuena, has ganado!';

  @override
  String gameVsX(String param1) {
    return 'Partida contra $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 contra $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Perdiste contra un usuario que incumplió las Condiciones del Servicio de Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Has recuperado $param1 puntos en $param2.';
  }

  @override
  String get timeAlmostUp => '¡Te queda poco tiempo!';

  @override
  String get clickToRevealEmailAddress => '[Haz clic para mostrar el correo electrónico]';

  @override
  String get download => 'Descargar';

  @override
  String get coachManager => 'Gestor de entrenador';

  @override
  String get streamerManager => 'Gestor de emisiones';

  @override
  String get cancelTournament => 'Cancelar el torneo';

  @override
  String get tournDescription => 'Descripción del torneo';

  @override
  String get tournDescriptionHelp => '¿Quieres decirle algo especial a los participantes? Intenta ser breve. Puedes usar enlaces al estilo Markdown: [nombre](https://url)';

  @override
  String get ratedFormHelp => 'Las partidas son por puntos\ny afectan a la puntuación de los jugadores';

  @override
  String get onlyMembersOfTeam => 'Sólo miembros del equipo';

  @override
  String get noRestriction => 'Sin restricciones';

  @override
  String get minimumRatedGames => 'Mínimo de partidas por puntos';

  @override
  String get minimumRating => 'Puntuación mínima';

  @override
  String get maximumWeeklyRating => 'Puntuación máxima semanal';

  @override
  String positionInputHelp(String param) {
    return 'Pega una descripción FEN para empezar todas las partidas con una posición específica.\nSólo funciona con partidas estándar, no con las variantes.\nPuedes usar el $param para crear una posición FEN y pegarla aquí.\nDéjalo vacío para empezar las partidas desde la posición inicial habitual.';
  }

  @override
  String get cancelSimul => 'Cancelar la simultánea';

  @override
  String get simulHostcolor => 'Color del anfitrión para cada partida';

  @override
  String get estimatedStart => 'Hora de inicio aproximada';

  @override
  String simulFeatured(String param) {
    return 'Mostrar en $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Muestra la simultánea públicamente en $param. Deshabilitado para simultáneas privadas.';
  }

  @override
  String get simulDescription => 'Descripción de la simultánea';

  @override
  String get simulDescriptionHelp => '¿Quieres decirle algo a los participantes?';

  @override
  String markdownAvailable(String param) {
    return 'Se puede usar $param para formatear el texto.';
  }

  @override
  String get embedsAvailable => 'Pega el enlace de una partida o de un capítulo de estudio para insertarlo.';

  @override
  String get inYourLocalTimezone => 'En tu zona horaria local';

  @override
  String get tournChat => 'Chat del torneo';

  @override
  String get noChat => 'Sin chat';

  @override
  String get onlyTeamLeaders => 'Sólo líderes del equipo';

  @override
  String get onlyTeamMembers => 'Sólo miembros del equipo';

  @override
  String get navigateMoveTree => 'Desplazarse por el árbol de movimientos';

  @override
  String get mouseTricks => 'Trucos de ratón';

  @override
  String get toggleLocalAnalysis => 'Activar y desactivar análisis por ordenador local';

  @override
  String get toggleAllAnalysis => 'Activar y desactivar todos los análisis por ordenador';

  @override
  String get playComputerMove => 'Jugar el mejor movimiento por ordenador';

  @override
  String get analysisOptions => 'Opciones de análisis';

  @override
  String get focusChat => 'Enfocar chat';

  @override
  String get showHelpDialog => 'Mostrar este cuadro de diálogo de ayuda';

  @override
  String get reopenYourAccount => 'Reactivar tu cuenta';

  @override
  String get closedAccountChangedMind => 'Si cerraste tu cuenta y has cambiado de opinión, aún tienes una oportunidad de recuperarla.';

  @override
  String get onlyWorksOnce => 'Esto solo se puede hacer una vez.';

  @override
  String get cantDoThisTwice => 'Si vuelves a cerrar tu cuenta, no podrás recuperarla.';

  @override
  String get emailAssociatedToaccount => 'Dirección de correo electrónico asociada a la cuenta';

  @override
  String get sentEmailWithLink => 'Te hemos enviado un correo electrónico con un enlace.';

  @override
  String get tournamentEntryCode => 'Código de acceso al torneo';

  @override
  String get hangOn => '¡Espera!';

  @override
  String gameInProgress(String param) {
    return 'Estás jugando una partida con $param.';
  }

  @override
  String get abortTheGame => 'Cancelar la partida';

  @override
  String get resignTheGame => 'Abandonar la partida';

  @override
  String get youCantStartNewGame => 'No puedes empezar otra partida hasta que termines ésta.';

  @override
  String get since => 'Desde';

  @override
  String get until => 'Hasta';

  @override
  String get lichessDbExplanation => 'Partidas por puntos de todos los jugadores de Lichess';

  @override
  String get switchSides => 'Cambiar color';

  @override
  String get closingAccountWithdrawAppeal => 'Cerrar tu cuenta retirará tu apelación';

  @override
  String get ourEventTips => 'Nuestros consejos para organizar eventos';

  @override
  String get instructions => 'Instrucciones';

  @override
  String get showMeEverything => 'Mostrarme todo';

  @override
  String get lichessPatronInfo => 'Lichess es una organización benéfica y un software totalmente libre y de código abierto.\nTodos los gastos de funcionamiento, desarrollo y contenidos se financian exclusivamente mediante las donaciones de sus usuarios.';

  @override
  String get nothingToSeeHere => 'Nada que ver aquí por ahora.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tu oponente ha salido de la partida. Podrás reclamar la victoria en $count segundos.',
      one: 'Tu oponente ha salido de la partida. Podrás reclamar la victoria en $count segundo.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mate en $count medios movimientos',
      one: 'Mate en $count medio movimiento',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errores graves',
      one: '$count error grave',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errores',
      one: '$count error',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imprecisiones',
      one: '$count imprecisión',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jugadores',
      one: '$count jugador',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Partidas',
      one: '$count Partida',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Puntuación de $count en $param2 partidas',
      one: 'puntuación $count en $param2 partida',
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
      other: 'La clasificación se actualiza cada $count minutos',
      one: 'La clasificación se actualiza cada minuto',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '$count ejercicio',
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
      other: '$count por puntos',
      one: '$count por puntos',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count victorias',
      one: '$count victoria',
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
      other: '$count tablas',
      one: '$count tablas',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count en juego',
      one: '$count en juego',
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
      other: '$count puntos de torneo',
      one: '$count punto de torneo',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estudios',
      one: '$count estudio',
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
      other: '≥ $count partidas por puntos',
      one: '≥ $count partida por puntos',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partidas por puntos de $param2',
      one: '≥ $count partida por puntos de $param2',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Necesitas jugar $count partidas más de $param2 por puntos',
      one: 'Necesitas jugar $count partida más de $param2 por puntos',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Necesitas jugar $count partidas por puntos más',
      one: 'Necesitas jugar $count partida por puntos más',
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
      other: '$count amigos conectados',
      one: '$count amigo conectado',
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
      other: '$count siguiendo',
      one: '$count siguiendo',
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
      other: '$count partidas en juego',
      one: '$count partida en juego',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Máximo: $count carácteres.',
      one: 'Máximo: $count carácter.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bloqueados',
      one: '$count bloqueado',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aportes en el foro',
      one: '$count aporte en el foro',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jugadores de $param2 esta semana.',
      one: '$count jugador de $param2 esta semana.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¡Disponible en $count idiomas!',
      one: '¡Disponible en $count idioma!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundos para hacer el primer movimiento',
      one: '$count segundo para hacer el primer movimiento',
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
      other: 'y ahorra $count líneas de premovimiento',
      one: 'y ahorra $count línea de premovimiento',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Mueve para empezar';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Juegas con blancas en todos los ejercicios';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Juegas con negras en todos los ejercicios';

  @override
  String get stormPuzzlesSolved => 'ejercicios correctos';

  @override
  String get stormNewDailyHighscore => '¡Récord del día!';

  @override
  String get stormNewWeeklyHighscore => '¡Récord de la semana!';

  @override
  String get stormNewMonthlyHighscore => '¡Récord del mes!';

  @override
  String get stormNewAllTimeHighscore => '¡Récord absoluto!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'El récord anterior era $param';
  }

  @override
  String get stormPlayAgain => 'Volver a jugar';

  @override
  String stormHighscoreX(String param) {
    return 'Récord: $param';
  }

  @override
  String get stormScore => 'Puntuación';

  @override
  String get stormMoves => 'Movimientos';

  @override
  String get stormAccuracy => 'Precisión';

  @override
  String get stormCombo => 'Racha';

  @override
  String get stormTime => 'Tiempo';

  @override
  String get stormTimePerMove => 'Tiempo por movimiento';

  @override
  String get stormHighestSolved => 'Ejercicio más difícil resuelto';

  @override
  String get stormPuzzlesPlayed => 'Ejercicios realizados';

  @override
  String get stormNewRun => 'Nueva ronda (tecla: Espacio)';

  @override
  String get stormEndRun => 'Terminar ronda (tecla: Enter)';

  @override
  String get stormHighscores => 'Récords';

  @override
  String get stormViewBestRuns => 'Ver las mejores rondas';

  @override
  String get stormBestRunOfDay => 'Mejor ronda del día';

  @override
  String get stormRuns => 'Rondas';

  @override
  String get stormGetReady => '¡Prepárate!';

  @override
  String get stormWaitingForMorePlayers => 'Esperando a que se unan más jugadores...';

  @override
  String get stormRaceComplete => '¡Carrera completada!';

  @override
  String get stormSpectating => 'Observando';

  @override
  String get stormJoinTheRace => '¡Únete a la carrera!';

  @override
  String get stormStartTheRace => 'Iniciar la carrera';

  @override
  String stormYourRankX(String param) {
    return 'Tu puntuación: $param';
  }

  @override
  String get stormWaitForRematch => 'Espera para la revancha';

  @override
  String get stormNextRace => 'Próxima carrera';

  @override
  String get stormJoinRematch => 'Unirse a la revancha';

  @override
  String get stormWaitingToStart => 'Esperando a que empiece';

  @override
  String get stormCreateNewGame => 'Crear una nueva carrera';

  @override
  String get stormJoinPublicRace => 'Unirse a una carrera pública';

  @override
  String get stormRaceYourFriends => 'Compite con tus amigos';

  @override
  String get stormSkip => 'omitir';

  @override
  String get stormSkipHelp => 'Puedes omitir un movimiento por carrera:';

  @override
  String get stormSkipExplanation => '¡Omite este movimiento para conservar tu racha! Sólo funciona una vez por carrera.';

  @override
  String get stormFailedPuzzles => 'Ejercicios fallidos';

  @override
  String get stormSlowPuzzles => 'Ejercicios lentos';

  @override
  String get stormSkippedPuzzle => 'Ejercicio omitido';

  @override
  String get stormThisWeek => 'Esta semana';

  @override
  String get stormThisMonth => 'Este mes';

  @override
  String get stormAllTime => 'Todos';

  @override
  String get stormClickToReload => 'Haz clic para recargar';

  @override
  String get stormThisRunHasExpired => '¡Se acabó el tiempo!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => '¡Esta ronda fue abierta en otra pestaña!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rondas',
      one: '1 ronda',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has jugado $count rondas de $param2',
      one: 'Has jugado una ronda de $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Presentadores de Lichess';

  @override
  String get studyShareAndExport => 'Compartir y exportar';

  @override
  String get studyStart => 'Comenzar';
}
