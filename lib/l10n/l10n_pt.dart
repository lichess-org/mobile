import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get activityActivity => 'Atividade';

  @override
  String get activityHostedALiveStream => 'Criou uma livestream';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Classificado #$param1 em $param2';
  }

  @override
  String get activitySignedUp => 'Registou-se no lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apoiou o lichess.org durante $count meses como $param2',
      one: 'Apoiou o lichess.org durante $count mês como $param2',
      zero: 'Apoiou o lichess.org durante $count mês como $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Praticou $count posições em $param2',
      one: 'Praticou $count posição em $param2',
      zero: 'Praticou $count posição em $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Resolveu $count problemas',
      one: 'Resolveu $count problema',
      zero: 'Resolveu $count problema',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jogou $count jogos de $param2',
      one: 'Jogou $count jogo de $param2',
      zero: 'Jogou $count jogo de $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Publicou $count mensagens em $param2',
      one: 'Publicou $count mensagem em $param2',
      zero: 'Publicou $count mensagem em $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fez $count jogadas',
      one: 'Fez $count jogada',
      zero: 'Fez $count jogada',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'em $count jogos por correspondência',
      one: 'em $count jogo por correspondência',
      zero: 'em $count jogo por correspondência',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Completou $count jogos por correspondência',
      one: 'Completou $count jogo por correspondência',
      zero: 'Completou $count jogo por correspondência',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Começou a seguir $count jogadores',
      one: 'Começou a seguir $count jogador',
      zero: 'Começou a seguir $count jogador',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ganhou $count novos seguidores',
      one: 'Ganhou $count novo seguidor',
      zero: 'Ganhou $count novo seguidor',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Criou $count exibições simultâneas',
      one: 'Criou $count exibição simultânea',
      zero: 'Criou $count exibição simultânea',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Participou em $count exibições simultâneas',
      one: 'Participou em $count exibição simultânea',
      zero: 'Participou em $count exibição simultânea',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Criou $count novos estudos',
      one: 'Criou $count novo estudo',
      zero: 'Criou $count novo estudo',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Competiu em $count torneios',
      one: 'Competiu em $count torneio',
      zero: 'Competiu em $count torneio',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Qualificado #$count (nos $param2% melhores) com $param3 jogos em $param4',
      one: 'Qualificado #$count (nos $param2% melhores) com $param3 jogo em $param4',
      zero: 'Qualificado #$count (nos $param2% melhores) com $param3 jogo em $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Competiu em $count torneios suíços',
      one: 'Competiu em $count torneio suíço',
      zero: 'Competiu em $count torneio suíço',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Entrou em $count equipas',
      one: 'Entrou em $count equipa',
      zero: 'Entrou em $count equipa',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Transmissões';

  @override
  String get broadcastStartDate => 'Data de início no teu fuso horário';

  @override
  String challengeChallengesX(String param1) {
    return 'Desafios: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Desafiar para jogar';

  @override
  String get challengeChallengeDeclined => 'Desafio recusado';

  @override
  String get challengeChallengeAccepted => 'Desafio aceite!';

  @override
  String get challengeChallengeCanceled => 'Desafio cancelado.';

  @override
  String get challengeRegisterToSendChallenges => 'Por favor regista-te para enviar desafios.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Não podes desafiar $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param não aceita desafios.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'O teu ranking $param1 esta muito distante de $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Não podes desafiar devido a ranking provisório $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param só aceita desafios de amigos.';
  }

  @override
  String get challengeDeclineGeneric => 'Não estou a aceitar desafios no momento.';

  @override
  String get challengeDeclineLater => 'Este não é o momento certo para mim, por favor pergunte novamente mais tarde.';

  @override
  String get challengeDeclineTooFast => 'Este controlo de tempo é muito rápido para mim, por favor, desafie-me novamente com um jogo mais lento.';

  @override
  String get challengeDeclineTooSlow => 'Este controlo de tempo é muito lento para mim, por favor, desafie-me novamente com um jogo mais rápido.';

  @override
  String get challengeDeclineTimeControl => 'Não estou a aceitar desafios com este controlo de tempo.';

  @override
  String get challengeDeclineRated => 'Por favor, envie-me um desafio a valer para a classificação.';

  @override
  String get challengeDeclineCasual => 'Por favor, envie-me um desafio amigável.';

  @override
  String get challengeDeclineStandard => 'Não estou a aceitar desafios de variante, de momento.';

  @override
  String get challengeDeclineVariant => 'Não estou disposto a jogar essa variante, de momento.';

  @override
  String get challengeDeclineNoBot => 'Não estou a aceitar desafios de bots.';

  @override
  String get challengeDeclineOnlyBot => 'Apenas aceito desafios de bots.';

  @override
  String get challengeInviteLichessUser => 'Ou convide um utilizador Lichess:';

  @override
  String get contactContact => 'Contacto';

  @override
  String get contactContactLichess => 'Contactar o Lichess';

  @override
  String get patronDonate => 'Doar';

  @override
  String get patronLichessPatron => 'Patrono do Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Estatísticas de $param';
  }

  @override
  String get perfStatViewTheGames => 'Ver as partidas';

  @override
  String get perfStatProvisional => 'provisório';

  @override
  String get perfStatNotEnoughRatedGames => 'Não foi jogado um número suficiente de partidas a pontuar para estabelecer uma pontuação de confiança.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progresso nas últimas $param partidas:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Desvio da pontuação: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Um valor inferior significa que a classificação é mais estável. Acima de $param1, a classificação é considerada provisória. Para ser incluído nas classificações, esse valor deve estar abaixo de $param2 (xadrez padrão) ou $param3 (variantes).';
  }

  @override
  String get perfStatTotalGames => 'Total de partidas';

  @override
  String get perfStatRatedGames => 'Total de partidas a pontuar';

  @override
  String get perfStatTournamentGames => 'Partidas em torneios';

  @override
  String get perfStatBerserkedGames => 'Partidas no modo frenético';

  @override
  String get perfStatTimeSpentPlaying => 'Tempo passado a jogar';

  @override
  String get perfStatAverageOpponent => 'Pontuação média dos adversários';

  @override
  String get perfStatVictories => 'Vitórias';

  @override
  String get perfStatDefeats => 'Derrotas';

  @override
  String get perfStatDisconnections => 'Desconexões';

  @override
  String get perfStatNotEnoughGames => 'Não foram jogadas partidas suficientes';

  @override
  String perfStatHighestRating(String param) {
    return 'Pontuação mais alta: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Pontuação mais baixa: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'de $param1 a $param2';
  }

  @override
  String get perfStatWinningStreak => 'Vitórias consecutivas';

  @override
  String get perfStatLosingStreak => 'Derrotas consecutivas';

  @override
  String perfStatLongestStreak(String param) {
    return 'Sequência mais longa: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Sequência atual: $param';
  }

  @override
  String get perfStatBestRated => 'Melhores vitórias a pontuar';

  @override
  String get perfStatGamesInARow => 'Partidas jogadas de seguida';

  @override
  String get perfStatLessThanOneHour => 'Menos de uma hora entre partidas';

  @override
  String get perfStatMaxTimePlaying => 'Tempo máximo passado a jogar';

  @override
  String get perfStatNow => 'agora';

  @override
  String get preferencesPreferences => 'Preferências';

  @override
  String get preferencesDisplay => 'Mostrar';

  @override
  String get preferencesPrivacy => 'Privacidade';

  @override
  String get preferencesNotifications => 'Notificações';

  @override
  String get preferencesPieceAnimation => 'Animação das peças';

  @override
  String get preferencesMaterialDifference => 'Diferença de material';

  @override
  String get preferencesBoardHighlights => 'Destacar as casas do tabuleiro (último movimento e xeque)';

  @override
  String get preferencesPieceDestinations => 'Destino das peças (movimentos válidos e antecipados)';

  @override
  String get preferencesBoardCoordinates => 'Coordenadas do tabuleiro (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Lista de movimentos';

  @override
  String get preferencesPgnPieceNotation => 'Anotação de movimentos';

  @override
  String get preferencesChessPieceSymbol => 'Usar símbolo das peças';

  @override
  String get preferencesPgnLetter => 'Usar letras (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Modo zen';

  @override
  String get preferencesShowPlayerRatings => 'Mostrar classificações dos jogadores';

  @override
  String get preferencesShowFlairs => 'Mostrar os estilos do jogadores';

  @override
  String get preferencesExplainShowPlayerRatings => 'Isto permite ocultar todas as avaliações do site, para o ajudar a concentrar-se no xadrez. Os jogos continuam a poder ser avaliados, trata-se apenas do que poderá ver.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Mostrar o cursor de redimensionamento do tabuleiro';

  @override
  String get preferencesOnlyOnInitialPosition => 'Apenas na posição inicial';

  @override
  String get preferencesInGameOnly => 'Apenas em Jogo';

  @override
  String get preferencesChessClock => 'Relógio de xadrez';

  @override
  String get preferencesTenthsOfSeconds => 'Décimos de segundo';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Quando o tempo restante for < 10 segundos';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Barras de progresso verdes horizontais';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Som ao atingir tempo crítico';

  @override
  String get preferencesGiveMoreTime => 'Dar mais tempo';

  @override
  String get preferencesGameBehavior => 'Funcionamento do jogo';

  @override
  String get preferencesHowDoYouMovePieces => 'Como queres mexer as peças?';

  @override
  String get preferencesClickTwoSquares => 'Clicar em duas casas';

  @override
  String get preferencesDragPiece => 'Arrastar uma peça';

  @override
  String get preferencesBothClicksAndDrag => 'Qualquer';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Jogadas antecipadas (jogadas durante a vez do adversário)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Voltar jogadas atrás (com aprovação do adversário)';

  @override
  String get preferencesInCasualGamesOnly => 'Somente em jogos casuais';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promover a Dama automaticamente';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Mantenha a tecla <ctrl> pressionada enquanto promove para desativar temporariamente a autopromoção';

  @override
  String get preferencesWhenPremoving => 'Quando mover antecipadamente';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Reivindicar empate automaticamente após uma repetição tripla';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Quando o tempo restante for < 30 segundos';

  @override
  String get preferencesMoveConfirmation => 'Confirmação de movimento';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Pode ser desativado durante um jogo com o menu do tabuleiro';

  @override
  String get preferencesInCorrespondenceGames => 'Jogos por correspondência';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Por correspondência e ilimitado';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Confirmar desistências e propostas de empate';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Método de roque';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Mover o rei duas casas';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Mover o rei até à torre';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Introduzir movimentos com o teclado';

  @override
  String get preferencesInputMovesWithVoice => 'Insira movimentos com a sua voz';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Alinhar as setas para sítios para onde as peças se podem mover';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Dizer \"Good game, well played\" (Bom jogo, bem jogado) após uma derrota ou empate';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'As tuas preferências foram guardadas.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Rolar no tabuleiro para repetir os movimentos';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Notificações diárias por email listando seus jogos por correspondência';

  @override
  String get preferencesNotifyStreamStart => 'Streamer começou uma transmissão ao vivo';

  @override
  String get preferencesNotifyInboxMsg => 'Nova mensagem na caixa de entrada';

  @override
  String get preferencesNotifyForumMention => 'Um comentário do fórum menciona-o';

  @override
  String get preferencesNotifyInvitedStudy => 'Convite para estudo';

  @override
  String get preferencesNotifyGameEvent => 'Atualizações dos jogos por correspondência';

  @override
  String get preferencesNotifyChallenge => 'Desafios';

  @override
  String get preferencesNotifyTournamentSoon => 'O torneio começará em breve';

  @override
  String get preferencesNotifyTimeAlarm => 'Está a acabar o tempo no jogo por correspondência';

  @override
  String get preferencesNotifyBell => 'Notificação do sino no Lichess';

  @override
  String get preferencesNotifyPush => 'Notificação do dispositivo quando não está no Lichess';

  @override
  String get preferencesNotifyWeb => 'Navegador';

  @override
  String get preferencesNotifyDevice => 'Dispositivo';

  @override
  String get preferencesBellNotificationSound => 'Som da notificação';

  @override
  String get puzzlePuzzles => 'Problemas';

  @override
  String get puzzlePuzzleThemes => 'Temas de problemas';

  @override
  String get puzzleRecommended => 'Recomendado';

  @override
  String get puzzlePhases => 'Fases';

  @override
  String get puzzleMotifs => 'Temas';

  @override
  String get puzzleAdvanced => 'Avançado';

  @override
  String get puzzleLengths => 'Comprimentos';

  @override
  String get puzzleMates => 'Xeque-mates';

  @override
  String get puzzleGoals => 'Objetivos';

  @override
  String get puzzleOrigin => 'Origem';

  @override
  String get puzzleSpecialMoves => 'Movimentos especiais';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Gostaste deste problema?';

  @override
  String get puzzleVoteToLoadNextOne => 'Vota para carregares o próximo!';

  @override
  String get puzzleUpVote => 'Aprove o puzzle';

  @override
  String get puzzleDownVote => 'Desaprove o puzzle';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'A tua classificação de problemas não será alterada. Nota que os problemas não são uma competição. A classificação ajuda a selecionar os melhores problemas para o teu nível atual.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Encontra a melhor jogada para as brancas.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Encontra a melhor jogada para as pretas.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Para obter desafios personalizados:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Problema $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Problema do dia';

  @override
  String get puzzleDailyPuzzle => 'Problema diário';

  @override
  String get puzzleClickToSolve => 'Clica para resolveres';

  @override
  String get puzzleGoodMove => 'Boa jogada';

  @override
  String get puzzleBestMove => 'Melhor jogada!';

  @override
  String get puzzleKeepGoing => 'Continua…';

  @override
  String get puzzlePuzzleSuccess => 'Sucesso!';

  @override
  String get puzzlePuzzleComplete => 'Problema resolvido!';

  @override
  String get puzzleByOpenings => 'Por abertura';

  @override
  String get puzzlePuzzlesByOpenings => 'Problemas por abertura';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Aberturas que jogou mais vezes em partidas com rating';

  @override
  String get puzzleUseFindInPage => 'Usar \"Localizar na página\" no menu do navegador para encontrar a sua abertura favorita!';

  @override
  String get puzzleUseCtrlF => 'Usar Ctrl+f para encontrar a sua abertura favorita!';

  @override
  String get puzzleNotTheMove => 'Não é esse movimento!';

  @override
  String get puzzleTrySomethingElse => 'Tenta outra coisa.';

  @override
  String puzzleRatingX(String param) {
    return 'Pontuação: $param';
  }

  @override
  String get puzzleHidden => 'oculta';

  @override
  String puzzleFromGameLink(String param) {
    return 'Do jogo $param';
  }

  @override
  String get puzzleContinueTraining => 'Continuar o treino';

  @override
  String get puzzleDifficultyLevel => 'Nível de dificuldade';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Mais fáceis';

  @override
  String get puzzleEasiest => 'Mais fáceis';

  @override
  String get puzzleHarder => 'Mais difíceis';

  @override
  String get puzzleHardest => 'Mais difíceis';

  @override
  String get puzzleExample => 'Exemplo';

  @override
  String get puzzleAddAnotherTheme => 'Adicionar outro tema';

  @override
  String get puzzleNextPuzzle => 'Próximo desafio';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Saltar imediatamente para o próximo problema';

  @override
  String get puzzlePuzzleDashboard => 'Painel de controlo dos problemas';

  @override
  String get puzzleImprovementAreas => 'Áreas a melhorar';

  @override
  String get puzzleStrengths => 'Pontos fortes';

  @override
  String get puzzleHistory => 'Histórico de problemas';

  @override
  String get puzzleSolved => 'resolvido';

  @override
  String get puzzleFailed => 'incorreto';

  @override
  String get puzzleStreakDescription => 'Resolve puzzles progressivamente mais difíceis e estabelece uma sequência de vitórias. Não há relógio, demora o teu tempo. Um movimento errado e o jogo acaba! No entanto, podes saltar um movimento por sessão.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Vitórias consecutivas: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Salta este movimento para preservar a tua sequência! Apenas funciona uma vez por sessão.';

  @override
  String get puzzleContinueTheStreak => 'Continua a sequência';

  @override
  String get puzzleNewStreak => 'Nova sequência de vitórias';

  @override
  String get puzzleFromMyGames => 'Dos meus jogos';

  @override
  String get puzzleLookupOfPlayer => 'Pesquise problemas de jogos de um jogador';

  @override
  String puzzleFromXGames(String param) {
    return 'Puzzles dos jogos de $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Pesquisar desafios';

  @override
  String get puzzleFromMyGamesNone => 'Não tens problemas na base de dados, mas Lichess adora-te muito.\n\nJoga partidas semi-rápidas e clássicas para aumentares a probabilidade de teres um problema adicionado!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 problemas encontrados em $param2 partidas';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Treinar, analisar, melhorar';

  @override
  String puzzlePercentSolved(String param) {
    return '$param resolvido';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Nada para mostrar, joga alguns problemas primeiro!';

  @override
  String get puzzleImprovementAreasDescription => 'Treine estes para otimizar o seu progresso!';

  @override
  String get puzzleStrengthDescription => 'Você tem melhor desempenho nestes temas';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jogado $count vezes',
      one: 'Jogado $count vez',
      zero: 'Jogado $count vez',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos abaixo da sua pontuação de problemas',
      one: 'Um ponto abaixo da sua pontuação de problemas',
      zero: 'Um ponto abaixo da sua pontuação de problemas',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos acima da sua pontuação de problemas',
      one: 'Um ponto acima da sua pontuação de problemas',
      zero: 'Um ponto acima da sua pontuação de problemas',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemas feitos',
      one: '$count problema feito',
      zero: '$count problema feito',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count para repetir',
      one: '$count para repetir',
      zero: '$count para repetir',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Peão avançado';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'A chave do tático é um peão a promover ou a ameaçar promover.';

  @override
  String get puzzleThemeAdvantage => 'Vantagem';

  @override
  String get puzzleThemeAdvantageDescription => 'Aproveita a oportunidade de obter uma vantagem decisiva. (200cp ≤ aval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mate Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Um cavalo e uma torre ou dama cooperam para prender o rei inimigo entre um lado do tabuleiro e outra peça inimiga.';

  @override
  String get puzzleThemeArabianMate => 'Mate Árabe';

  @override
  String get puzzleThemeArabianMateDescription => 'Um cavalo e uma torre cooperam para prenderem o rei inimigo no canto do tabuleiro.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Atacar f2 ou f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Um ataque ao peão de f2 ou f7, como a abertura \"Fried Liver\".';

  @override
  String get puzzleThemeAttraction => 'Atração';

  @override
  String get puzzleThemeAttractionDescription => 'Uma troca ou sacrifício que encoraja ou força uma peça adversária a ir para uma casa que permite um tático.';

  @override
  String get puzzleThemeBackRankMate => 'Mate de corredor';

  @override
  String get puzzleThemeBackRankMateDescription => 'Dá mate ao rei na fila inicial, quando está preso pelas suas próprias peças.';

  @override
  String get puzzleThemeBishopEndgame => 'Final de bispos';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Um final apenas com bispos e peões.';

  @override
  String get puzzleThemeBodenMate => 'Mate Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Dois bispos em diagonais perpendiculares dão mate ao rei inimigo obstruído por peças aliadas.';

  @override
  String get puzzleThemeCastling => 'Roque';

  @override
  String get puzzleThemeCastlingDescription => 'Proteger o rei e trazer a torre para o ataque.';

  @override
  String get puzzleThemeCapturingDefender => 'Capturar o defensor';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Remove uma peça que seja crítica para a defesa de outra peça, permitindo que esta seja capturada na próxima jogada.';

  @override
  String get puzzleThemeCrushing => 'Esmagar';

  @override
  String get puzzleThemeCrushingDescription => 'Descobre um erro grave do oponente e obtém uma vantagem esmagadora. (avaliação ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mate com dois bispos';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dois bispos em diagonais adjacentes dão mate ao rei inimigo obstruído por peças aliadas.';

  @override
  String get puzzleThemeDovetailMate => 'Mate cauda-de-andorinha';

  @override
  String get puzzleThemeDovetailMateDescription => 'Uma dama dá mate ao rei inimigo cujas jogadas de escape estão bloqueadas por peças aliadas.';

  @override
  String get puzzleThemeEquality => 'Igualdade';

  @override
  String get puzzleThemeEqualityDescription => 'Recupera de uma posição perdedora e garante um empate ou uma posição de equilíbrio. (avaliação ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Ataque no lado do rei';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Um ataque ao rei do adversário, após este ter feito roque menor (para o lado do rei).';

  @override
  String get puzzleThemeClearance => 'Limpeza';

  @override
  String get puzzleThemeClearanceDescription => 'Uma jogada, com tempo, que limpa uma casa, fila, coluna ou diagonal para uma ideia tática subsequente.';

  @override
  String get puzzleThemeDefensiveMove => 'Movimento defensivo';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Um movimento ou sequência de movimentos precisos, necessários para evitar uma desvantagem, como por exemplo perda de material.';

  @override
  String get puzzleThemeDeflection => 'Desvio';

  @override
  String get puzzleThemeDeflectionDescription => 'Uma jogada que distrai uma peça do adversário de outra função, como por exemplo, proteger uma casa chave. Às vezes também é chamado de sobrecarga.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ataque descoberto';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Mover uma peça que estava a bloquear um ataque de uma peça de longo alcance, como por exemplo um cavalo que sai da frente de uma torre.';

  @override
  String get puzzleThemeDoubleCheck => 'Xeque duplo';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Fazer xeque com duas peças ao mesmo tempo, como consequência de um ataque descoberto em que tanto a peça que move como a peça que é descoberta atacam o rei do adversário.';

  @override
  String get puzzleThemeEndgame => 'Final de jogo';

  @override
  String get puzzleThemeEndgameDescription => 'Uma tática durante a última fase do jogo.';

  @override
  String get puzzleThemeEnPassantDescription => 'Uma tática que envolve a regra de \"en passant\", onde um peão pode capturar um peão adversário que o ignorou usando o seu primeiro movimento de duas casas.';

  @override
  String get puzzleThemeExposedKing => 'Rei exposto';

  @override
  String get puzzleThemeExposedKingDescription => 'Uma tática que envolve um rei com poucos defensores ao seu redor, muitas vezes levando a xeque-mate.';

  @override
  String get puzzleThemeFork => 'Garfo';

  @override
  String get puzzleThemeForkDescription => 'Uma jogada em que uma peça ataca duas peças do adversário simultaneamente.';

  @override
  String get puzzleThemeHangingPiece => 'Peça desprotegida';

  @override
  String get puzzleThemeHangingPieceDescription => 'Uma tática que envolve uma peça do adversário que não está suficientemente defendida e por isso pode ser capturada.';

  @override
  String get puzzleThemeHookMate => 'Mate gancho';

  @override
  String get puzzleThemeHookMateDescription => 'Mate com uma torre, cavalo e peão em que o rei inimigo tem as jogadas de escape bloqueadas por um peão aliado.';

  @override
  String get puzzleThemeInterference => 'Interferência';

  @override
  String get puzzleThemeInterferenceDescription => 'Jogar uma peça para uma casa entre duas peças do adversário deixando pelo menos uma delas desprotegia, como por exemplo um cavalo numa casa defendida entre duas torres.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Em vez de jogares o movimento esperado, primeiro interpõe outro movimento colocando uma ameaça imediata à qual o oponente deve responder. Também conhecido como \"Zwischenzug\" ou jogada intermédia.';

  @override
  String get puzzleThemeKnightEndgame => 'Final de cavalo';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Um final de jogo com apenas cavalos e peões.';

  @override
  String get puzzleThemeLong => 'Problema longo';

  @override
  String get puzzleThemeLongDescription => 'Três movimentos para ganhar.';

  @override
  String get puzzleThemeMaster => 'Jogos de mestres';

  @override
  String get puzzleThemeMasterDescription => 'Problemas de partidas jogadas por jogadores titulados.';

  @override
  String get puzzleThemeMasterVsMaster => 'Jogos de Mestre vs Mestre';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Partidas jogadas entre dois jogadores titulados.';

  @override
  String get puzzleThemeMate => 'Xeque-mate';

  @override
  String get puzzleThemeMateDescription => 'Vence a partida com estilo.';

  @override
  String get puzzleThemeMateIn1 => 'Mate em 1';

  @override
  String get puzzleThemeMateIn1Description => 'Faz xeque-mate num movimento.';

  @override
  String get puzzleThemeMateIn2 => 'Mate em 2';

  @override
  String get puzzleThemeMateIn2Description => 'Faz xeque-mate em dois movimentos.';

  @override
  String get puzzleThemeMateIn3 => 'Mate em 3';

  @override
  String get puzzleThemeMateIn3Description => 'Faz xeque-mate em três movimentos.';

  @override
  String get puzzleThemeMateIn4 => 'Mate em 4';

  @override
  String get puzzleThemeMateIn4Description => 'Faz xeque-mate em quatro movimentos.';

  @override
  String get puzzleThemeMateIn5 => 'Mate em 5 ou mais';

  @override
  String get puzzleThemeMateIn5Description => 'Descobre uma longa sequência que leva ao xeque-mate.';

  @override
  String get puzzleThemeMiddlegame => 'Meio-jogo';

  @override
  String get puzzleThemeMiddlegameDescription => 'Uma tática durante a segunda fase do jogo.';

  @override
  String get puzzleThemeOneMove => 'Problema de um movimento';

  @override
  String get puzzleThemeOneMoveDescription => 'Um problema que é resolvido com apenas um movimento.';

  @override
  String get puzzleThemeOpening => 'Abertura';

  @override
  String get puzzleThemeOpeningDescription => 'Uma tática durante a primeira fase do jogo.';

  @override
  String get puzzleThemePawnEndgame => 'Final de peões';

  @override
  String get puzzleThemePawnEndgameDescription => 'Um final de jogo só com peões.';

  @override
  String get puzzleThemePin => 'Cravada';

  @override
  String get puzzleThemePinDescription => 'Uma tática que envolve cravadas, onde uma peça é incapaz de se mover sem revelar um ataque a uma peça de valor superior.';

  @override
  String get puzzleThemePromotion => 'Promoção';

  @override
  String get puzzleThemePromotionDescription => 'Promova o teu peão a uma dama ou numa peça menor.';

  @override
  String get puzzleThemeQueenEndgame => 'Final de dama';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Um final com apenas damas e peões.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Dama e torre';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Um final de jogo só com damas, torres e peões.';

  @override
  String get puzzleThemeQueensideAttack => 'Ataque no lado da dama';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Um ataque ao rei do adversário, após este ter feito roque grande (para o lado da dama).';

  @override
  String get puzzleThemeQuietMove => 'Jogada subtil';

  @override
  String get puzzleThemeQuietMoveDescription => 'Um movimento que não faz uma cheque nem captura, mas prepara uma ameaça inevitável.';

  @override
  String get puzzleThemeRookEndgame => 'Final de torre';

  @override
  String get puzzleThemeRookEndgameDescription => 'Um final de jogo com apenas torres e peões.';

  @override
  String get puzzleThemeSacrifice => 'Sacrifício';

  @override
  String get puzzleThemeSacrificeDescription => 'Uma tática que involve abdicar de material a curto prazo, para ganhar uma vantagem após uma sequência forçada de movimentos.';

  @override
  String get puzzleThemeShort => 'Problema curto';

  @override
  String get puzzleThemeShortDescription => 'Duas jogadas para ganhar.';

  @override
  String get puzzleThemeSkewer => 'Cravada inversa';

  @override
  String get puzzleThemeSkewerDescription => 'Uma tática que envolve uma peça de alto valor que está ser atacada, mas ao afastar-se, permite que uma peça de menor valor, que estava atrás dela, seja capturada ou atacada. É o inverso da cravada.';

  @override
  String get puzzleThemeSmotheredMate => 'Mate de Philidor';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Uma xeque-mate feito por um cavalo em que o rei não se pode mover porque está rodeado pelas suas próprias peças. Também conhecido como mate sufocado.';

  @override
  String get puzzleThemeSuperGM => 'Jogos de Super GM';

  @override
  String get puzzleThemeSuperGMDescription => 'Problemas de partidas jogadas pelos melhores jogadores do mundo.';

  @override
  String get puzzleThemeTrappedPiece => 'Peça encurralada';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Uma peça não consegue escapar à captura, pois tem movimentos limitados.';

  @override
  String get puzzleThemeUnderPromotion => 'Subpromoção';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promoção para um cavalo, bispo ou torre.';

  @override
  String get puzzleThemeVeryLong => 'Problema muito longo';

  @override
  String get puzzleThemeVeryLongDescription => 'Quatro jogadas para ganhar.';

  @override
  String get puzzleThemeXRayAttack => 'Ataque raio-X';

  @override
  String get puzzleThemeXRayAttackDescription => 'Uma peça ataque ou defende uma casa através de uma peça inimiga.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'O adversário está limitado quanto aos seus movimentos, e todas as jogadas pioram a sua posição.';

  @override
  String get puzzleThemeHealthyMix => 'Mistura saudável';

  @override
  String get puzzleThemeHealthyMixDescription => 'Um pouco de tudo. Não sabes o que esperar, então ficas pronto para qualquer coisa! Exatamente como em jogos de verdade.';

  @override
  String get puzzleThemePlayerGames => 'Jogos de jogadores';

  @override
  String get puzzleThemePlayerGamesDescription => 'Procura problemas gerados a partir dos teus jogos ou de jogos de outro jogador.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Esses problemas são do domínio público e podem ser obtidos em $param.';
  }

  @override
  String get searchSearch => 'Procurar';

  @override
  String get settingsSettings => 'Configurações';

  @override
  String get settingsCloseAccount => 'Encerrar a conta';

  @override
  String get settingsManagedAccountCannotBeClosed => 'A sua conta é gerida e não pode ser encerrada.';

  @override
  String get settingsClosingIsDefinitive => 'O encerramento é definitivo. Não podes voltar atrás. Tens a certeza?';

  @override
  String get settingsCantOpenSimilarAccount => 'Não poderá criar uma nova conta com o mesmo nome, mesmo que as maiúsculas ou minúsculas sejam diferentes.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Mudei de ideias, não encerrem a minha conta';

  @override
  String get settingsCloseAccountExplanation => 'Tens a certeza que queres encerrar sua conta? Encerrar a tua conta é uma decisão permanente. Tu NUNCA MAIS serás capaz de iniciar sessão nesta conta.';

  @override
  String get settingsThisAccountIsClosed => 'Esta conta foi encerrada.';

  @override
  String get playWithAFriend => 'Jogar com um amigo';

  @override
  String get playWithTheMachine => 'Jogar contra o computador';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Para convidares alguém para jogar, envia este URL';

  @override
  String get gameOver => 'Fim da partida';

  @override
  String get waitingForOpponent => 'Aguardando oponente';

  @override
  String get orLetYourOpponentScanQrCode => 'Ou deixa o teu oponente ler este código QR';

  @override
  String get waiting => 'A aguardar';

  @override
  String get yourTurn => 'É a tua vez';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 nível $param2';
  }

  @override
  String get level => 'Nível';

  @override
  String get strength => 'Nível';

  @override
  String get toggleTheChat => 'Ativar/Desativar o chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Desistir';

  @override
  String get checkmate => 'Xeque-mate';

  @override
  String get stalemate => 'Rei afogado';

  @override
  String get white => 'Brancas';

  @override
  String get black => 'Pretas';

  @override
  String get asWhite => 'com as brancas';

  @override
  String get asBlack => 'com as pretas';

  @override
  String get randomColor => 'Cor aleatória';

  @override
  String get createAGame => 'Criar uma partida';

  @override
  String get whiteIsVictorious => 'Brancas vencem';

  @override
  String get blackIsVictorious => 'Pretas vencem';

  @override
  String get youPlayTheWhitePieces => 'Tu jogas com as peças brancas';

  @override
  String get youPlayTheBlackPieces => 'Tu jogas com as peças pretas';

  @override
  String get itsYourTurn => 'É a tua vez!';

  @override
  String get cheatDetected => 'Fraude detetada';

  @override
  String get kingInTheCenter => 'Rei no centro';

  @override
  String get threeChecks => 'Três xeques';

  @override
  String get raceFinished => 'Corrida terminada';

  @override
  String get variantEnding => 'Fim da variante';

  @override
  String get newOpponent => 'Novo adversário';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'O teu adversário quer jogar outra vez contra ti';

  @override
  String get joinTheGame => 'Entrar no jogo';

  @override
  String get whitePlays => 'Jogam as brancas';

  @override
  String get blackPlays => 'Jogam as pretas';

  @override
  String get opponentLeftChoices => 'O teu adversário deixou a partida. Podes reivindicar vitória, declarar empate ou aguardar.';

  @override
  String get forceResignation => 'Reivindicar vitória';

  @override
  String get forceDraw => 'Reivindicar empate';

  @override
  String get talkInChat => 'Por favor, sê gentil na conversa!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'A primeira pessoa que aceder a este link jogará contra ti.';

  @override
  String get whiteResigned => 'As brancas desistiram';

  @override
  String get blackResigned => 'As pretas desistiram';

  @override
  String get whiteLeftTheGame => 'As brancas deixaram a partida';

  @override
  String get blackLeftTheGame => 'As pretas deixaram a partida';

  @override
  String get whiteDidntMove => 'As brancas não se moveram';

  @override
  String get blackDidntMove => 'As pretas não se moveram';

  @override
  String get requestAComputerAnalysis => 'Solicitar uma análise de computador';

  @override
  String get computerAnalysis => 'Análise de computador';

  @override
  String get computerAnalysisAvailable => 'Análise de computador disponível';

  @override
  String get computerAnalysisDisabled => 'Análise de computador desativada';

  @override
  String get analysis => 'Análise';

  @override
  String depthX(String param) {
    return 'Profundidade $param';
  }

  @override
  String get usingServerAnalysis => 'A usar a análise do servidor';

  @override
  String get loadingEngine => 'A carregar o motor de jogo...';

  @override
  String get calculatingMoves => 'A calcular as jogadas...';

  @override
  String get engineFailed => 'Erro ao carregar o motor';

  @override
  String get cloudAnalysis => 'Análise na nuvem';

  @override
  String get goDeeper => 'Aprofundar';

  @override
  String get showThreat => 'Mostrar ameaça';

  @override
  String get inLocalBrowser => 'no navegador local';

  @override
  String get toggleLocalEvaluation => 'Ligar/desligar a avaliação local';

  @override
  String get promoteVariation => 'Promover variante';

  @override
  String get makeMainLine => 'Tornar variante principal';

  @override
  String get deleteFromHere => 'Eliminar a partir de aqui';

  @override
  String get collapseVariations => 'Recolher variações';

  @override
  String get expandVariations => 'Expandir variações';

  @override
  String get forceVariation => 'Forçar variante';

  @override
  String get copyVariationPgn => 'Copiar variação PGN';

  @override
  String get move => 'Jogada';

  @override
  String get variantLoss => 'Variante perdida';

  @override
  String get variantWin => 'Variante ganha';

  @override
  String get insufficientMaterial => 'Material insuficiente';

  @override
  String get pawnMove => 'Movimento de peão';

  @override
  String get capture => 'Captura';

  @override
  String get close => 'Fechar';

  @override
  String get winning => 'Ganhas';

  @override
  String get losing => 'Perdidas';

  @override
  String get drawn => 'Empatado';

  @override
  String get unknown => 'Desconhecidos';

  @override
  String get database => 'Base de dados';

  @override
  String get whiteDrawBlack => 'Brancas / Empate / Pretas';

  @override
  String averageRatingX(String param) {
    return 'Pontuação média: $param';
  }

  @override
  String get recentGames => 'Partidas recentes';

  @override
  String get topGames => 'Melhores partidas';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'de partidas OTB de jogadores com +$param1 rating FIDE de $param2 a $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' com arredondamento, baseado no número de meios-movimentos até à próxima captura ou movimento de peão';

  @override
  String get noGameFound => 'Nenhum jogo encontrado';

  @override
  String get maxDepthReached => 'Nível máximo alcançado!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Talvez incluir mais jogos no menu de preferências?';

  @override
  String get openings => 'Aberturas';

  @override
  String get openingExplorer => 'Explorador de aberturas';

  @override
  String get openingEndgameExplorer => 'Explorador de Aberturas/Finais';

  @override
  String xOpeningExplorer(String param) {
    return 'Explorador de aberturas de $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Jogar o primeiro lance do explorador de aberturas/finais';

  @override
  String get winPreventedBy50MoveRule => 'Vitória impedida pela regra dos 50 movimentos';

  @override
  String get lossSavedBy50MoveRule => 'Derrota evitada pela regra dos 50 movimentos';

  @override
  String get winOr50MovesByPriorMistake => 'Vitória ou 50 movimentos por engano anterior';

  @override
  String get lossOr50MovesByPriorMistake => 'Vitória ou 50 movimentos por engano anterior';

  @override
  String get unknownDueToRounding => 'Vitória/derrota garantida apenas se a linha da tabela recomendada tiver sido seguida desde a última captura ou movimento de peão, devido a possível arredondamento.';

  @override
  String get allSet => 'Tudo a postos!';

  @override
  String get importPgn => 'Importar PGN';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteThisImportedGame => 'Eliminar este jogo importado?';

  @override
  String get replayMode => 'Modo de repetição';

  @override
  String get realtimeReplay => 'Tempo real';

  @override
  String get byCPL => 'Por CPL';

  @override
  String get openStudy => 'Abrir estudo';

  @override
  String get enable => 'Ativar';

  @override
  String get bestMoveArrow => 'Seta de melhor movimento';

  @override
  String get showVariationArrows => 'Ver setas de variação';

  @override
  String get evaluationGauge => 'Medidor da avaliação';

  @override
  String get multipleLines => 'Múltiplas continuações';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Memória';

  @override
  String get infiniteAnalysis => 'Análise infinita';

  @override
  String get removesTheDepthLimit => 'Remove o limite de profundidade e mantém o teu computador quente';

  @override
  String get engineManager => 'Gestão do motor';

  @override
  String get blunder => 'Erro grave';

  @override
  String get mistake => 'Erro';

  @override
  String get inaccuracy => 'Imprecisão';

  @override
  String get moveTimes => 'Tempo das jogadas';

  @override
  String get flipBoard => 'Inverter o tabuleiro';

  @override
  String get threefoldRepetition => 'Repetição tripla';

  @override
  String get claimADraw => 'Declarar empate';

  @override
  String get offerDraw => 'Propor empate';

  @override
  String get draw => 'Empate';

  @override
  String get drawByMutualAgreement => 'Empate por acordo mútuo';

  @override
  String get fiftyMovesWithoutProgress => 'Cinquenta jogadas sem progresso';

  @override
  String get currentGames => 'Partidas a decorrer';

  @override
  String get viewInFullSize => 'Ver em tela cheia';

  @override
  String get logOut => 'Sair';

  @override
  String get signIn => 'Entrar';

  @override
  String get rememberMe => 'Lembrar-me';

  @override
  String get youNeedAnAccountToDoThat => 'Precisas de uma conta para fazeres isso';

  @override
  String get signUp => 'Registar-se';

  @override
  String get computersAreNotAllowedToPlay => 'Computadores ou jogadores assistidos por computador não estão autorizados a jogar. Por favor não utilizes assistência de programas de xadrez, bases de dados ou outros jogadores enquanto estiveres a jogar. Além disso, a criação de contas múltiplas é fortemente desencorajada e a sua prática excessiva acarretará banimento.';

  @override
  String get games => 'Partidas';

  @override
  String get forum => 'Fórum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 publicou no tópico $param2';
  }

  @override
  String get latestForumPosts => 'Últimas publicações no fórum';

  @override
  String get players => 'Jogadores';

  @override
  String get friends => 'Amigos';

  @override
  String get discussions => 'Conversas';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get minutesPerSide => 'Minutos por jogador';

  @override
  String get variant => 'Variante';

  @override
  String get variants => 'Variantes';

  @override
  String get timeControl => 'Ritmo de jogo';

  @override
  String get realTime => 'Em tempo real';

  @override
  String get correspondence => 'Correspondência';

  @override
  String get daysPerTurn => 'Dias por lance';

  @override
  String get oneDay => 'Um dia';

  @override
  String get time => 'Tempo';

  @override
  String get rating => 'Pontuação';

  @override
  String get ratingStats => 'Estatísticas de pontuação';

  @override
  String get username => 'Nome de utilizador';

  @override
  String get usernameOrEmail => 'Nome ou e-mail do utilizador';

  @override
  String get changeUsername => 'Alterar o nome de utilizador';

  @override
  String get changeUsernameNotSame => 'Só te é permitido trocar as letras de minúscula para maiúscula e vice-versa. Por exemplo, \"johndoe\" para \"JohnDoe\".';

  @override
  String get changeUsernameDescription => 'Altera o teu nome de utilizador. Isso só pode ser feito uma vez e só poderás trocar as letras de minúscula para maiúscula e vice-versa.';

  @override
  String get signupUsernameHint => 'Certifique-se que escolhe um nome de utilizador decoroso. Não poderá alterá-lo mais tarde e quaisquer contas com nomes de utilizador inapropriados serão fechadas!';

  @override
  String get signupEmailHint => 'Só o usaremos para redefinir a palavra-passe.';

  @override
  String get password => 'Palavra-passe';

  @override
  String get changePassword => 'Alterar a palavra-passe';

  @override
  String get changeEmail => 'Alterar email';

  @override
  String get email => 'E-mail';

  @override
  String get passwordReset => 'Redefinir a palavra-passe';

  @override
  String get forgotPassword => 'Esqueceste-te da tua palavra-passe?';

  @override
  String get error_weakPassword => 'Esta senha é extremamente comum, e muito fácil de adivinhar.';

  @override
  String get error_namePassword => 'Por favor, não usa o teu nome de utilizador como senha.';

  @override
  String get blankedPassword => 'Utilizou a mesma palavra-passe noutro site, e esse site foi comprometido. Para garantir a segurança da sua conta Lichess, precisamos que redefina a palavra-passe. Obrigado pela compreensão.';

  @override
  String get youAreLeavingLichess => 'Você está a sair do Lichess';

  @override
  String get neverTypeYourPassword => 'Nunca escrevas a tua senha Lichess em outro site!';

  @override
  String proceedToX(String param) {
    return 'Continuar para $param';
  }

  @override
  String get passwordSuggestion => 'Não uses uma senha sugerida por outra pessoa. Eles vão utilizar-la para roubar a tua conta.';

  @override
  String get emailSuggestion => 'Não uses um email sugerida por outra pessoa. Eles vão utilizar-la para roubar a tua conta.';

  @override
  String get emailConfirmHelp => 'Ajuda com a confirmação do endereço eletrónico';

  @override
  String get emailConfirmNotReceived => 'Não recebeu no seu correio eletrónico uma mensagem de confirmação após o registo?';

  @override
  String get whatSignupUsername => 'Que nome de utilizador usou para se registar?';

  @override
  String usernameNotFound(String param) {
    return 'Não foi possível encontrar nenhum usuário com este nome: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Pode usar esse nome de utilizador para criar uma conta';

  @override
  String emailSent(String param) {
    return 'Enviámos um correio eletrónico para $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Pode demorar algum tempo a chegar.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Aguarde 5 minutos e atualize a sua caixa de entrada de correio eletrónico.';

  @override
  String get checkSpamFolder => 'Verifique também a sua pasta de “spam”, pode estar lá. Se sim, assinale como não “spam”.';

  @override
  String get emailForSignupHelp => 'Se tudo falhar, então envie-nos este correio eletrónico:';

  @override
  String copyTextToEmail(String param) {
    return 'Copie e cole o texto acima e envie-o para $param';
  }

  @override
  String get waitForSignupHelp => 'Nós entraremos brevemente em contacto para ajudá-lo a completar a inscrição.';

  @override
  String accountConfirmed(String param) {
    return 'O utilizador $param foi confirmado com sucesso.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Pode agora aceder como $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Não precisa de um endereço eletrónico de confirmação.';

  @override
  String accountClosed(String param) {
    return 'A conta $param está encerrada.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'A conta $param foi registada sem um endereço eletrónico.';
  }

  @override
  String get rank => 'Classificação';

  @override
  String rankX(String param) {
    return 'Posição: $param';
  }

  @override
  String get gamesPlayed => 'Partidas jogadas';

  @override
  String get cancel => 'Cancelar';

  @override
  String get whiteTimeOut => 'Acabou o tempo das brancas';

  @override
  String get blackTimeOut => 'Acabou o tempo das pretas';

  @override
  String get drawOfferSent => 'Proposta de empate enviada';

  @override
  String get drawOfferAccepted => 'Proposta de empate aceite';

  @override
  String get drawOfferCanceled => 'Proposta de empate cancelada';

  @override
  String get whiteOffersDraw => 'As brancas propõem empate';

  @override
  String get blackOffersDraw => 'As pretas propõem empate';

  @override
  String get whiteDeclinesDraw => 'As brancas recusam o empate';

  @override
  String get blackDeclinesDraw => 'As pretas recusam o empate';

  @override
  String get yourOpponentOffersADraw => 'O teu adversário propõe empate';

  @override
  String get accept => 'Aceitar';

  @override
  String get decline => 'Recusar';

  @override
  String get playingRightNow => 'A jogar agora';

  @override
  String get eventInProgress => 'A decorrer agora';

  @override
  String get finished => 'Terminado';

  @override
  String get abortGame => 'Cancelar a partida';

  @override
  String get gameAborted => 'Partida cancelada';

  @override
  String get standard => 'Padrão';

  @override
  String get customPosition => 'Posição personalizada';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String get mode => 'Modo';

  @override
  String get casual => 'Amigável';

  @override
  String get rated => 'A valer pontos';

  @override
  String get casualTournament => 'Amigável';

  @override
  String get ratedTournament => 'A valer pontos';

  @override
  String get thisGameIsRated => 'Esta partida vale pontos';

  @override
  String get rematch => 'Desforra';

  @override
  String get rematchOfferSent => 'Pedido de desforra enviado';

  @override
  String get rematchOfferAccepted => 'Pedido de desforra aceite';

  @override
  String get rematchOfferCanceled => 'Pedido de desforra cancelado';

  @override
  String get rematchOfferDeclined => 'Pedido de desforra recusado';

  @override
  String get cancelRematchOffer => 'Cancelar o pedido de desforra';

  @override
  String get viewRematch => 'Ver a desforra';

  @override
  String get confirmMove => 'Confirmar o lance';

  @override
  String get play => 'Jogar';

  @override
  String get inbox => 'Caixa de entrada';

  @override
  String get chatRoom => 'Sala de chat';

  @override
  String get loginToChat => 'Inicia sessão para poderes conversar';

  @override
  String get youHaveBeenTimedOut => 'Foste impedido de conversar por agora.';

  @override
  String get spectatorRoom => 'Sala dos espectadores';

  @override
  String get composeMessage => 'Escrever uma mensagem';

  @override
  String get subject => 'Assunto';

  @override
  String get send => 'Enviar';

  @override
  String get incrementInSeconds => 'Incremento em segundos';

  @override
  String get freeOnlineChess => 'Xadrez Online Gratuito';

  @override
  String get exportGames => 'Exportar partidas';

  @override
  String get ratingRange => 'Pontuação entre';

  @override
  String get thisAccountViolatedTos => 'Esta conta violou os termos de serviço do Lichess';

  @override
  String get openingExplorerAndTablebase => 'Explorador de aberturas & tabelas de finais';

  @override
  String get takeback => 'Voltar uma jogada atrás';

  @override
  String get proposeATakeback => 'Propor voltar uma jogada atrás';

  @override
  String get takebackPropositionSent => 'Proposta de voltar uma jogada atrás enviada';

  @override
  String get takebackPropositionDeclined => 'Proposta de voltar uma jogada atrás recusada';

  @override
  String get takebackPropositionAccepted => 'Proposta de voltar uma jogada atrás aceite';

  @override
  String get takebackPropositionCanceled => 'Proposta de voltar uma jogada atrás cancelada';

  @override
  String get yourOpponentProposesATakeback => 'O teu adversário propõe voltar uma jogada atrás';

  @override
  String get bookmarkThisGame => 'Adicionar esta partida às favoritas';

  @override
  String get tournament => 'Torneio';

  @override
  String get tournaments => 'Torneios';

  @override
  String get tournamentPoints => 'Pontos de torneio';

  @override
  String get viewTournament => 'Ver o torneio';

  @override
  String get backToTournament => 'Voltar ao torneio';

  @override
  String get noDrawBeforeSwissLimit => 'Num torneio suíço não pode empatar antes de 30 jogadas.';

  @override
  String get thematic => 'Temático';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'A tua pontuação em $param é provisória';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'A tua pontuação em $param1 ($param2) é demasiado alta';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'A tua pontuação máxima nesta semana em $param1 ($param2) é demasiado alta';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'A tua pontuação em $param1 ($param2) é demasiado baixa';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Pontuação ≥ $param1 em $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Pontuação ≤ $param1 em $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Tens de pertencer à equipa $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Não estás na equipa $param';
  }

  @override
  String get backToGame => 'Voltar à partida';

  @override
  String get siteDescription => 'Xadrez online gratuito. Joga xadrez numa interface simples. Sem registos, sem anúncios, sem plugins. Joga xadrez com o computador, amigos ou adversários aleatórios.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 juntou-se à equipa $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 criou a equipa $param2';
  }

  @override
  String get startedStreaming => 'começou uma stream';

  @override
  String xStartedStreaming(String param) {
    return '$param começou uma stream';
  }

  @override
  String get averageElo => 'Pontuação média';

  @override
  String get location => 'Localização';

  @override
  String get filterGames => 'Filtrar partidas';

  @override
  String get reset => 'Voltar ao original';

  @override
  String get apply => 'Aplicar';

  @override
  String get save => 'Guardar';

  @override
  String get leaderboard => 'Tabela de liderança';

  @override
  String get screenshotCurrentPosition => 'Posição atual da captura de ecrã';

  @override
  String get gameAsGIF => 'Jogo como GIF';

  @override
  String get pasteTheFenStringHere => 'Coloca a notação FEN aqui';

  @override
  String get pasteThePgnStringHere => 'Coloca a notação PGN aqui';

  @override
  String get orUploadPgnFile => 'Ou enviar um ficheiro PGN';

  @override
  String get fromPosition => 'A partir de uma posição';

  @override
  String get continueFromHere => 'Continuar a partir daqui';

  @override
  String get toStudy => 'Estudo';

  @override
  String get importGame => 'Importar uma partida';

  @override
  String get importGameExplanation => 'Coloca aqui o PGN de um jogo, para teres acesso a navegar pela repetição,\nanálise de computador, sala de chat do jogo e link de partilha.';

  @override
  String get importGameCaveat => 'As variações serão apagadas. Para mantê-las, importe o PGN através de um estudo.';

  @override
  String get importGameDataPrivacyWarning => 'Este PGN pode ser acessada pelo público. Para importar um jogo de forma privada, use um estudo.';

  @override
  String get thisIsAChessCaptcha => 'Este é um \"CAPTCHA\" de xadrez.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Clica no tabuleiro para fazeres a tua jogada, provando que és humano.';

  @override
  String get captcha_fail => 'Por favor, resolve o captcha.';

  @override
  String get notACheckmate => 'Não é xeque-mate.';

  @override
  String get whiteCheckmatesInOneMove => 'As brancas dão mate em um movimento';

  @override
  String get blackCheckmatesInOneMove => 'As pretas dão mate em um movimento';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get reconnecting => 'Reconectando';

  @override
  String get noNetwork => 'Desligado';

  @override
  String get favoriteOpponents => 'Adversários favoritos';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'A seguir';

  @override
  String get unfollow => 'Deixar de seguir';

  @override
  String followX(String param) {
    return 'Seguir $param';
  }

  @override
  String unfollowX(String param) {
    return 'Deixar de seguir $param';
  }

  @override
  String get block => 'Bloquear';

  @override
  String get blocked => 'Bloqueado';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get followsYou => 'Segue-te';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 começou a seguir $param2';
  }

  @override
  String get more => 'Mais';

  @override
  String get memberSince => 'Membro desde';

  @override
  String lastSeenActive(String param) {
    return 'Ativo $param';
  }

  @override
  String get player => 'Jogador';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Gráfico';

  @override
  String get required => 'Obrigatório.';

  @override
  String get openTournaments => 'Torneios abertos';

  @override
  String get duration => 'Duração';

  @override
  String get winner => 'Vencedor';

  @override
  String get standing => 'Classificação';

  @override
  String get createANewTournament => 'Criar um torneio';

  @override
  String get tournamentCalendar => 'Calendário de torneios';

  @override
  String get conditionOfEntry => 'Condições de participação:';

  @override
  String get advancedSettings => 'Configurações avançadas';

  @override
  String get safeTournamentName => 'Escolhe um nome totalmente seguro para o torneio.';

  @override
  String get inappropriateNameWarning => 'Até uma linguagem ligeiramente inadequada pode levar ao encerramento da tua conta.';

  @override
  String get emptyTournamentName => 'Deixe em branco e será atribuído um nome aleatório de um jogador notável ao torneio.';

  @override
  String get makePrivateTournament => 'Torna o torneio privado e restrinje o acesso com uma palavra-passe';

  @override
  String get join => 'Entrar';

  @override
  String get withdraw => 'Sair';

  @override
  String get points => 'Pontos';

  @override
  String get wins => 'Vitórias';

  @override
  String get losses => 'Derrotas';

  @override
  String get createdBy => 'Criado por';

  @override
  String get tournamentIsStarting => 'O torneio está a começar';

  @override
  String get tournamentPairingsAreNowClosed => 'Os emparelhamentos no torneio já estão fechados.';

  @override
  String standByX(String param) {
    return 'Aguarda $param, estamos a emparelhar jogadores, prepara-te!';
  }

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Continuar';

  @override
  String get youArePlaying => 'Estás a jogar!';

  @override
  String get winRate => 'Taxa de vitórias';

  @override
  String get berserkRate => 'Taxa de partidas no modo frenético';

  @override
  String get performance => 'Desempenho';

  @override
  String get tournamentComplete => 'Torneio terminado';

  @override
  String get movesPlayed => 'Movimentos feitos';

  @override
  String get whiteWins => 'Vitórias com as brancas';

  @override
  String get blackWins => 'Vitórias com as pretas';

  @override
  String get drawRate => 'Taxa de empate';

  @override
  String get draws => 'Empates';

  @override
  String nextXTournament(String param) {
    return 'Próximo torneio de $param:';
  }

  @override
  String get averageOpponent => 'Pontuação média dos adversários';

  @override
  String get boardEditor => 'Editor de tabuleiro';

  @override
  String get setTheBoard => 'Partilha o tabuleiro';

  @override
  String get popularOpenings => 'Aberturas populares';

  @override
  String get endgamePositions => 'Posições finais';

  @override
  String chess960StartPosition(String param) {
    return 'Posição inicial do Xadrez960: $param';
  }

  @override
  String get startPosition => 'Posição inicial';

  @override
  String get clearBoard => 'Limpar o tabuleiro';

  @override
  String get loadPosition => 'Carregar uma posição';

  @override
  String get isPrivate => 'Privado';

  @override
  String reportXToModerators(String param) {
    return 'Reportar $param aos moderadores';
  }

  @override
  String profileCompletion(String param) {
    return 'Perfil completo: $param';
  }

  @override
  String xRating(String param) {
    return 'Pontuação $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Se não existir, deixa em branco';

  @override
  String get profile => 'Perfil';

  @override
  String get editProfile => 'Editar o perfil';

  @override
  String get realName => 'Nome Real';

  @override
  String get setFlair => 'Defina o teu estilo';

  @override
  String get flair => 'Estilo';

  @override
  String get youCanHideFlair => 'Há uma opção para ocultar todos os estilos dos utilizadores em todo o site.';

  @override
  String get biography => 'Biografia';

  @override
  String get countryRegion => 'País ou região';

  @override
  String get thankYou => 'Obrigado!';

  @override
  String get socialMediaLinks => 'Links das redes sociais';

  @override
  String get oneUrlPerLine => 'Um URL por linha.';

  @override
  String get inlineNotation => 'Anotações em linha';

  @override
  String get makeAStudy => 'Para guardar e partilhar, considere fazer um estudo.';

  @override
  String get clearSavedMoves => 'Limpar jogadas';

  @override
  String get previouslyOnLichessTV => 'Anteriormente na TV Lichess';

  @override
  String get onlinePlayers => 'Jogadores online';

  @override
  String get activePlayers => 'Jogadores ativos';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Cuidado, o jogo vale pontos, mas não há limite de tempo!';

  @override
  String get success => 'Sucesso';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Passar automaticamente ao jogo seguinte após a jogada';

  @override
  String get autoSwitch => 'Alternar automaticamente';

  @override
  String get puzzles => 'Problemas';

  @override
  String get onlineBots => 'Bots online';

  @override
  String get name => 'Nome';

  @override
  String get description => 'Descrição';

  @override
  String get descPrivate => 'Descrição privada';

  @override
  String get descPrivateHelp => 'Texto que apenas está visível para os membros da equipa. Se definido, substitui a descrição pública dos membros da equipa.';

  @override
  String get no => 'Não';

  @override
  String get yes => 'Sim';

  @override
  String get help => 'Ajuda:';

  @override
  String get createANewTopic => 'Criar um novo tópico';

  @override
  String get topics => 'Tópicos';

  @override
  String get posts => 'Publicações';

  @override
  String get lastPost => 'Última publicação';

  @override
  String get views => 'Visualizações';

  @override
  String get replies => 'Respostas';

  @override
  String get replyToThisTopic => 'Responder a este tópico';

  @override
  String get reply => 'Responder';

  @override
  String get message => 'Mensagem';

  @override
  String get createTheTopic => 'Criar o tópico';

  @override
  String get reportAUser => 'Denunciar um utilizador';

  @override
  String get user => 'Utilizador';

  @override
  String get reason => 'Motivo';

  @override
  String get whatIsIheMatter => 'Qual é o motivo?';

  @override
  String get cheat => 'Batota';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Outro';

  @override
  String get reportDescriptionHelp => 'Inclui o link do(s) jogo(s) e explica o que há de errado com o comportamento deste utilizador. Não digas apenas \"ele faz batota\"; informa-nos como chegaste a essa conclusão. A tua denúncia será processada mais rapidamente se for escrita em inglês.';

  @override
  String get error_provideOneCheatedGameLink => 'Por favor, fornece-nos pelo menos um link para um jogo onde tenha havido batota.';

  @override
  String by(String param) {
    return 'por $param';
  }

  @override
  String importedByX(String param) {
    return 'Importado por $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Este tópico foi fechado.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notas';

  @override
  String get typePrivateNotesHere => 'Escreve notas privadas aqui';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Escreva uma nota privada sobre este utilizador';

  @override
  String get noNoteYet => 'Ainda sem notas';

  @override
  String get invalidUsernameOrPassword => 'Nome de utilizador ou palavra-passe incorretos';

  @override
  String get incorrectPassword => 'Palavra-passe incorreta';

  @override
  String get invalidAuthenticationCode => 'Código de autenticação inválido';

  @override
  String get emailMeALink => 'Envie-me um link por e-mail';

  @override
  String get currentPassword => 'Palavra-passe atual';

  @override
  String get newPassword => 'Nova palavra-chave';

  @override
  String get newPasswordAgain => 'Nova palavra-passe (novamente)';

  @override
  String get newPasswordsDontMatch => 'As novas palavras-passe não coincidem';

  @override
  String get newPasswordStrength => 'Força da palavra-passe';

  @override
  String get clockInitialTime => 'Tempo inicial no relógio';

  @override
  String get clockIncrement => 'Incremento no relógio';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get letOtherPlayersFollowYou => 'Permitir que outros jogadores te sigam';

  @override
  String get letOtherPlayersChallengeYou => 'Permitir que outros jogadores te desafiem';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Permitir que outros jogadores te convidem para estudos';

  @override
  String get sound => 'Som';

  @override
  String get none => 'Nenhum';

  @override
  String get fast => 'Rápido';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Lento';

  @override
  String get insideTheBoard => 'Dentro do tabuleiro';

  @override
  String get outsideTheBoard => 'Fora do tabuleiro';

  @override
  String get allSquaresOfTheBoard => 'Todas as casas do tabuleiro';

  @override
  String get onSlowGames => 'Em jogos lentos';

  @override
  String get always => 'Sempre';

  @override
  String get never => 'Nunca';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 compete em $param2';
  }

  @override
  String get victory => 'Vitória';

  @override
  String get defeat => 'Derrota';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 contra $param2 em $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 contra $param2 em $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 contra $param2 em $param3';
  }

  @override
  String get timeline => 'Cronologia';

  @override
  String get starting => 'Começa às:';

  @override
  String get allInformationIsPublicAndOptional => 'Todas as informações são públicas e opcionais.';

  @override
  String get biographyDescription => 'Fala de ti, do que gostas no xadrez, das tuas aberturas favoritas, jogos, jogadores...';

  @override
  String get listBlockedPlayers => 'Lista os jogadores que bloqueaste';

  @override
  String get human => 'Humano';

  @override
  String get computer => 'Computador';

  @override
  String get side => 'Cor';

  @override
  String get clock => 'Relógio';

  @override
  String get opponent => 'Adversário';

  @override
  String get learnMenu => 'Aprender';

  @override
  String get studyMenu => 'Estudos';

  @override
  String get practice => 'Praticar';

  @override
  String get community => 'Comunidade';

  @override
  String get tools => 'Ferramentas';

  @override
  String get increment => 'Incremento';

  @override
  String get error_unknown => 'Valor inválido';

  @override
  String get error_required => 'Este campo tem de ser preenchido';

  @override
  String get error_email => 'Este endereço de e-mail é inválido';

  @override
  String get error_email_acceptable => 'Este endereço de e-mail não é aceitável. Por favor verifica-o e tenta outra vez.';

  @override
  String get error_email_unique => 'Endereço de e-mail inválido ou já utilizado';

  @override
  String get error_email_different => 'Este já é o teu endereço de e-mail';

  @override
  String error_minLength(String param) {
    return 'Deve conter pelo menos $param caracteres';
  }

  @override
  String error_maxLength(String param) {
    return 'Deve conter no máximo $param caracteres';
  }

  @override
  String error_min(String param) {
    return 'Deve ser pelo menos $param';
  }

  @override
  String error_max(String param) {
    return 'Deve ser no máximo $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Se a pontuação for ± $param';
  }

  @override
  String get ifRegistered => 'Se registado';

  @override
  String get onlyExistingConversations => 'Apenas conversas existentes';

  @override
  String get onlyFriends => 'Apenas amigos';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Roque';

  @override
  String get whiteCastlingKingside => 'Brancas O-O';

  @override
  String get blackCastlingKingside => 'Pretas O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tempo passado a jogar: $param';
  }

  @override
  String get watchGames => 'Ver jogos';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tempo a ser transmitido na TV: $param';
  }

  @override
  String get watch => 'Observar';

  @override
  String get videoLibrary => 'Videoteca';

  @override
  String get streamersMenu => 'Streamers';

  @override
  String get mobileApp => 'Aplicação móvel';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'Sobre';

  @override
  String aboutX(String param) {
    return 'Sobre o $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return 'O $param1 é um servidor de xadrez grátis ($param2), sem publicidades e open-source.';
  }

  @override
  String get really => 'a sério';

  @override
  String get contribute => 'Contribuir';

  @override
  String get termsOfService => 'Termos de serviço';

  @override
  String get sourceCode => 'Código fonte';

  @override
  String get simultaneousExhibitions => 'Exibições simultâneas';

  @override
  String get host => 'Anfitrião';

  @override
  String hostColorX(String param) {
    return 'Cor do anfitrião: $param';
  }

  @override
  String get yourPendingSimuls => 'Suas simultâneas pendentes';

  @override
  String get createdSimuls => 'Simultâneas criadas recentemente';

  @override
  String get hostANewSimul => 'Iniciar uma simultânea';

  @override
  String get signUpToHostOrJoinASimul => 'Registra-te para hospedar ou juntar a uma simultânea';

  @override
  String get noSimulFound => 'Simultânea não encontrada';

  @override
  String get noSimulExplanation => 'Esta exibição simultânea não existe.';

  @override
  String get returnToSimulHomepage => 'Voltar à página inicial da simultânea';

  @override
  String get aboutSimul => 'As simultâneas envolvem um único jogador contra vários adversários ao mesmo tempo.';

  @override
  String get aboutSimulImage => 'Contra 50 adversários, Fischer ganhou 47 jogos, empatou 2 e perdeu 1.';

  @override
  String get aboutSimulRealLife => 'O conceito provém de eventos reais, nos quais o simultanista se move de mesa em mesa, executando um movimento de cada vez.';

  @override
  String get aboutSimulRules => 'Quando a simultânea começa, cada jogador começa sua partida contra o anfitrião, que joga sempre com as peças brancas. A simultânea termina quando todas as partidas tiverem acabado.';

  @override
  String get aboutSimulSettings => 'As simultâneas são sempre partidas amigáveis. Desforras, voltar jogadas atrás e dar mais tempo estão desativados.';

  @override
  String get create => 'Criar';

  @override
  String get whenCreateSimul => 'Quando crias uma simultânea, podes jogar com vários adversários ao mesmo tempo.';

  @override
  String get simulVariantsHint => 'Se selecionares diversas variantes, cada jogador poderá escolher qual delas jogar.';

  @override
  String get simulClockHint => 'Configuração de incrementos no relógio. Quanto mais jogadores admitires, mais tempo poderás necessitar.';

  @override
  String get simulAddExtraTime => 'Podes acrescentar tempo adicional ao teu relógio, para te ajudar a lidar com a simultânea.';

  @override
  String get simulHostExtraTime => 'Tempo adicional do anfitrião';

  @override
  String get simulAddExtraTimePerPlayer => 'Adicione tempo inicial ao seu relógio para cada jogador que entra na simulação.';

  @override
  String get simulHostExtraTimePerPlayer => 'Tempo extra de relógio por jogador';

  @override
  String get lichessTournaments => 'Torneios do Lichess';

  @override
  String get tournamentFAQ => 'Perguntas frequentes sobre torneios em arena';

  @override
  String get timeBeforeTournamentStarts => 'Contagem decrescente para o início do torneio';

  @override
  String get averageCentipawnLoss => 'Perda média de centésimos de peão';

  @override
  String get accuracy => 'Precisão';

  @override
  String get keyboardShortcuts => 'Atalhos do teclado';

  @override
  String get keyMoveBackwardOrForward => 'retroceder/avançar jogada';

  @override
  String get keyGoToStartOrEnd => 'ir para início/fim';

  @override
  String get keyCycleSelectedVariation => 'Ciclo da variante selecionada';

  @override
  String get keyShowOrHideComments => 'mostrar/ocultar os comentários';

  @override
  String get keyEnterOrExitVariation => 'entrar/sair da variante';

  @override
  String get keyRequestComputerAnalysis => 'Solicite análise do computador, Aprenda com seus erros';

  @override
  String get keyNextLearnFromYourMistakes => 'Seguinte (Aprenda com os seus erros)';

  @override
  String get keyNextBlunder => 'Próxima gafe';

  @override
  String get keyNextMistake => 'Próximo erro';

  @override
  String get keyNextInaccuracy => 'Próxima imprecisão';

  @override
  String get keyPreviousBranch => 'Ramo anterior';

  @override
  String get keyNextBranch => 'Próximo ramo';

  @override
  String get toggleVariationArrows => 'Ativar/desactivar seta da variante';

  @override
  String get cyclePreviousOrNextVariation => 'Ciclo anterior/próxima variante';

  @override
  String get toggleGlyphAnnotations => 'Ativar/desativar anotações com símbolos';

  @override
  String get togglePositionAnnotations => 'Ativar/desativar anotações de posição';

  @override
  String get variationArrowsInfo => 'Setas de variação permitem navegar sem usar a lista de movimentos.';

  @override
  String get playSelectedMove => 'jogar o movimento selecionado';

  @override
  String get newTournament => 'Novo torneio';

  @override
  String get tournamentHomeTitle => 'Torneios de xadrez com diversos ritmos de jogo e variantes';

  @override
  String get tournamentHomeDescription => 'Joga xadrez em ritmo acelerado! Entra num torneio oficial agendado ou cria o teu próprio. Bullet, Rápida, Clássica, Chess960, Rei da Colina, Três Xeques e mais opções disponíveis para uma diversão ilimitada.';

  @override
  String get tournamentNotFound => 'Torneio não encontrado';

  @override
  String get tournamentDoesNotExist => 'Este torneio não existe.';

  @override
  String get tournamentMayHaveBeenCanceled => 'O torneio pode ter sido cancelado, se todos os jogadores tiverem saíram antes do seu começo.';

  @override
  String get returnToTournamentsHomepage => 'Voltar à página inicial de torneios';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Distribuição semanal de pontuação em $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'A tua pontuação em $param1 é $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'És melhor que $param1 dos jogadores de $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 é melhor que $param2 dos jogadores de $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Melhor que $param1 de $param2 jogadores';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Não tens uma pontuação estabelecida em $param.';
  }

  @override
  String get yourRating => 'A tua pontuação';

  @override
  String get cumulative => 'Acumulativo';

  @override
  String get glicko2Rating => 'Pontuação Glicko-2';

  @override
  String get checkYourEmail => 'Verifica o teu e-mail';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Enviámos-te um e-mail. Clica no link nesse e-mail para ativares a tua conta.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Se você não vires o e-mail, verifica outros locais onde este possa estar, como pastas de lixo, spam, social ou outras.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Enviámos-te um e-mail para $param. Clica no link nesse e-mail para redefinires a tua palavra-passe.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Ao criares uma conta, concordas comprometeres-te com os nossos $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Lê sobre a nossa $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Atraso na rede entre ti e o Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tempo para processar um movimento no servidor do Lichess';

  @override
  String get downloadAnnotated => 'Transferir anotação';

  @override
  String get downloadRaw => 'Transferir texto';

  @override
  String get downloadImported => 'Transferir a partida importada';

  @override
  String get crosstable => 'Tabela';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Também podes rodar a rodinha do rato sobre o tabuleiro para percorreres as jogadas na partida.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Passe o rato sobre as variantes do computador para visualizá-las.';

  @override
  String get analysisShapesHowTo => 'Pressiona shift+clique ou clica com o botão direito do rato para desenhares círculos e setas no tabuleiro.';

  @override
  String get letOtherPlayersMessageYou => 'Permitir que outros jogadores te enviem mensagens';

  @override
  String get receiveForumNotifications => 'Olá aOlá a todos';

  @override
  String get shareYourInsightsData => 'Compartilhar os teus dados de \"insights\" de xadrez';

  @override
  String get withNobody => 'Com ninguém';

  @override
  String get withFriends => 'Com amigos';

  @override
  String get withEverybody => 'Com todos';

  @override
  String get kidMode => 'Modo infantil';

  @override
  String get kidModeIsEnabled => 'Modo infantil está ativado.';

  @override
  String get kidModeExplanation => 'Iso é sobre segurança. No modo infantil, todas as comunicações do site ficam desactivadas. Activa esta opção para os teus filhos ou alunos, para protegê-los de outros utilizadores da internet.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'No modo criança, o logótipo do Lichess fica com um ícone $param para que saibas que as tuas crianças estão seguras.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'A sua conta é gerida. Peça ao seu professor de xadrez para retirar o modo infantil.';

  @override
  String get enableKidMode => 'Ativar o modo infantil';

  @override
  String get disableKidMode => 'Desativar o modo infantil';

  @override
  String get security => 'Segurança';

  @override
  String get sessions => 'Sessões';

  @override
  String get revokeAllSessions => 'desativar todas as sessões';

  @override
  String get playChessEverywhere => 'Joga xadrez em qualquer lugar';

  @override
  String get asFreeAsLichess => 'Tão gratuito quanto o Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Desenvolvido pelo amor ao xadrez, não pelo dinheiro';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Todos têm todos os recursos gratuitamente';

  @override
  String get zeroAdvertisement => 'Zero anúncios';

  @override
  String get fullFeatured => 'Cheio de recursos';

  @override
  String get phoneAndTablet => 'Telemóvel e tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, clássico';

  @override
  String get correspondenceChess => 'Xadrez por correspondência';

  @override
  String get onlineAndOfflinePlay => 'Jogar online e offline';

  @override
  String get viewTheSolution => 'Ver a solução';

  @override
  String get followAndChallengeFriends => 'Joga e desafia amigos';

  @override
  String get gameAnalysis => 'Análise da partida';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 criou a exibição simultânea $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 entrou em $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 gostou de $param2';
  }

  @override
  String get quickPairing => 'Emparelhamento rápido';

  @override
  String get lobby => 'Sala de espera';

  @override
  String get anonymous => 'Anônimo';

  @override
  String yourScore(String param) {
    return 'O teu resultado: $param';
  }

  @override
  String get language => 'Lingua';

  @override
  String get background => 'Fundo';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get transparent => 'Transparente';

  @override
  String get deviceTheme => 'Tema do dispositivo';

  @override
  String get backgroundImageUrl => 'URL da imagem de fundo:';

  @override
  String get board => 'Tabuleiro';

  @override
  String get size => 'Tamanho';

  @override
  String get opacity => 'Opacidade';

  @override
  String get brightness => 'Brilho';

  @override
  String get hue => 'Tonalidade';

  @override
  String get boardReset => 'Redefinir cores para o padrão';

  @override
  String get pieceSet => 'Peças';

  @override
  String get embedInYourWebsite => 'Incorporar no teu site';

  @override
  String get usernameAlreadyUsed => 'Este nome de utilizador já existe, por favor escolhe outro.';

  @override
  String get usernamePrefixInvalid => 'O nome do utilizador tem começar com uma letra.';

  @override
  String get usernameSuffixInvalid => 'O nome do utilizador tem de acabar com uma letra ou número.';

  @override
  String get usernameCharsInvalid => 'O nome do utilizador só pode conter letras, números, underscores ou hífenes.';

  @override
  String get usernameUnacceptable => 'Este nome de utilizador não é aceitável.';

  @override
  String get playChessInStyle => 'Jogar xadrez com estilo';

  @override
  String get chessBasics => 'O básico do xadrez';

  @override
  String get coaches => 'Treinadores';

  @override
  String get invalidPgn => 'PGN inválido';

  @override
  String get invalidFen => 'FEN inválido';

  @override
  String get custom => 'Personalizado';

  @override
  String get notifications => 'Notificações';

  @override
  String notificationsX(String param1) {
    return 'Notificações: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Pontuação: $param';
  }

  @override
  String get practiceWithComputer => 'Praticar com o computador';

  @override
  String anotherWasX(String param) {
    return 'Outro seria $param';
  }

  @override
  String bestWasX(String param) {
    return '$param seria melhor';
  }

  @override
  String get youBrowsedAway => 'Saíste';

  @override
  String get resumePractice => 'Continuar a prática';

  @override
  String get drawByFiftyMoves => 'O jogo foi empatado de acordo com a regra dos cinquenta lances.';

  @override
  String get theGameIsADraw => 'O jogo é um empate.';

  @override
  String get computerThinking => 'Computador a pensar...';

  @override
  String get seeBestMove => 'Ver o melhor movimento';

  @override
  String get hideBestMove => 'Ocultar o melhor movimento';

  @override
  String get getAHint => 'Obter uma dica';

  @override
  String get evaluatingYourMove => 'A analisar o teu movimento ...';

  @override
  String get whiteWinsGame => 'As brancas ganham';

  @override
  String get blackWinsGame => 'As pretas ganham';

  @override
  String get learnFromYourMistakes => 'Aprende com os teus erros';

  @override
  String get learnFromThisMistake => 'Aprende com este erro';

  @override
  String get skipThisMove => 'Saltar este movimento';

  @override
  String get next => 'Seguinte';

  @override
  String xWasPlayed(String param) {
    return '$param foi jogado';
  }

  @override
  String get findBetterMoveForWhite => 'Encontra um melhor movimento para as brancas';

  @override
  String get findBetterMoveForBlack => 'Encontra um melhor movimento para as pretas';

  @override
  String get resumeLearning => 'Continuar a aprendizagem';

  @override
  String get youCanDoBetter => 'Podes fazer melhor';

  @override
  String get tryAnotherMoveForWhite => 'Tenta outro movimento para as brancas';

  @override
  String get tryAnotherMoveForBlack => 'Tenta outro movimento para as pretas';

  @override
  String get solution => 'Solução';

  @override
  String get waitingForAnalysis => 'A aguardar pela análise';

  @override
  String get noMistakesFoundForWhite => 'Não foram encontrados erros das brancas';

  @override
  String get noMistakesFoundForBlack => 'Não foram encontrados erros das pretas';

  @override
  String get doneReviewingWhiteMistakes => 'Terminada a revisão de erros das brancas';

  @override
  String get doneReviewingBlackMistakes => 'Terminada a revisão de erros das pretas';

  @override
  String get doItAgain => 'Repetir';

  @override
  String get reviewWhiteMistakes => 'Rever os erros das brancas';

  @override
  String get reviewBlackMistakes => 'Rever os erros das pretas';

  @override
  String get advantage => 'Vantagem';

  @override
  String get opening => 'Abertura';

  @override
  String get middlegame => 'Meio jogo';

  @override
  String get endgame => 'Final de jogo';

  @override
  String get conditionalPremoves => 'Movimentos antecipados condicionais';

  @override
  String get addCurrentVariation => 'Adicionar a variante atual';

  @override
  String get playVariationToCreateConditionalPremoves => 'Joga uma variante para criares movimentos antecipados condicionais';

  @override
  String get noConditionalPremoves => 'Sem movimentos antecipados condicionais';

  @override
  String playX(String param) {
    return 'Joga $param';
  }

  @override
  String get showUnreadLichessMessage => 'Recebestes uma mensagem privada do Lichess.';

  @override
  String get clickHereToReadIt => 'Clica aqui para ler';

  @override
  String get sorry => 'Desculpa :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Tivemos de te banir por algum tempo.';

  @override
  String get why => 'Porquê?';

  @override
  String get pleasantChessExperience => 'Tencionamos proporcionar uma experiência de xadrez agradável a todos.';

  @override
  String get goodPractice => 'Para isso, temos de nos assegurar que todos os jogadores seguem boas práticas.';

  @override
  String get potentialProblem => 'Quando um potencial problema é detetado, exibimos esta mensagem.';

  @override
  String get howToAvoidThis => 'Como evitar isto?';

  @override
  String get playEveryGame => 'Joga todas as partidas que começares.';

  @override
  String get tryToWin => 'Tenta ganhar (ou pelo menos empatar) todas as partida que jogares.';

  @override
  String get resignLostGames => 'Desiste em partidas perdidas (não deixes o tempo no relógio acabar).';

  @override
  String get temporaryInconvenience => 'Pedimos desculpa pelo incómodo temporário,';

  @override
  String get wishYouGreatGames => 'e desejamos-te grandes jogos no lichess.org.';

  @override
  String get thankYouForReading => 'Obrigado pela leitura!';

  @override
  String get lifetimeScore => 'Pontuação desde sempre';

  @override
  String get currentMatchScore => 'Pontuação atual';

  @override
  String get agreementAssistance => 'Concordo que nunca recorrerei a assistência durante as minhas partidas (de um computador de xadrez, livro, base de dados ou outra pessoa).';

  @override
  String get agreementNice => 'Concordo que serei sempre repeitoso para os outros jogadores.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Concordo que não criarei várias contas (exceto pelas razões indicadas em $param).';
  }

  @override
  String get agreementPolicy => 'Concordo que seguirei todas as políticas do Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Pesquisa ou começa uma nova conversa';

  @override
  String get edit => 'Editar';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Rápidas';

  @override
  String get rapid => 'Semi-rápidas';

  @override
  String get classical => 'Clássicas';

  @override
  String get ultraBulletDesc => 'Partidas incrivelmente rápidas: menos de 30 segundos';

  @override
  String get bulletDesc => 'Partidas muito rápidas: menos de 3 minutos';

  @override
  String get blitzDesc => 'Partidas rápidas: 3 a 8 minutos';

  @override
  String get rapidDesc => 'Partidas semi-rápidas: 8 a 25 minutos';

  @override
  String get classicalDesc => 'Partidas clássicas: 25 minutos ou mais';

  @override
  String get correspondenceDesc => 'Partidas por correspondência: um ou vários dias por lance';

  @override
  String get puzzleDesc => 'Treinador de táticas de xadrez';

  @override
  String get important => 'Importante';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'A tua pergunta pode já ter uma resposta $param1';
  }

  @override
  String get inTheFAQ => 'no F.A.Q. (perguntas frequentes).';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Para reportares um utilizador por fazer batota ou por mau comportamento, $param1.';
  }

  @override
  String get useTheReportForm => 'usa a ficha própria para o fazeres';

  @override
  String toRequestSupport(String param1) {
    return 'Para solicitares suporte, $param1.';
  }

  @override
  String get tryTheContactPage => 'tenta a página de contacto';

  @override
  String makeSureToRead(String param1) {
    return 'Certifique-se que lê $param1';
  }

  @override
  String get theForumEtiquette => 'a etiqueta do fórum';

  @override
  String get thisTopicIsArchived => 'Este tópico foi arquivado e já não pode ser respondido.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Junta-te a $param1, para publicares neste fórum';
  }

  @override
  String teamNamedX(String param1) {
    return 'equipa $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Ainda não podes publicar nos fóruns. Joga alguns jogos!';

  @override
  String get subscribe => 'Subscrever-se';

  @override
  String get unsubscribe => 'Cancelar a subscrição';

  @override
  String mentionedYouInX(String param1) {
    return 'foste mencionado em \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 mencionou-te em \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'convidou-te para \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 convidou-te para \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Já fazes parte da equipa.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Juntaste-te a \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Alguém que denunciaste foi banido';

  @override
  String get congratsYouWon => 'Parabéns! Ganhaste!';

  @override
  String gameVsX(String param1) {
    return 'Jogo vs $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Perdes-te contra alguém que violou as regras do Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Devolução: $param1 $param2 pontos de Elo.';
  }

  @override
  String get timeAlmostUp => 'O tempo está quase a terminar!';

  @override
  String get clickToRevealEmailAddress => '[Clique para revelar o endereço de e-mail]';

  @override
  String get download => 'Transferir';

  @override
  String get coachManager => 'Gestor de treinadores';

  @override
  String get streamerManager => 'Gestor do streamer';

  @override
  String get cancelTournament => 'Cancelar o torneio';

  @override
  String get tournDescription => 'Descrição do torneio';

  @override
  String get tournDescriptionHelp => 'Quer dizer alguma coisa em especial aos participantes? Seja breve. Estão disponíveis ligações de Markdown: [name](https://url)';

  @override
  String get ratedFormHelp => 'Os jogos são classificados\ne afetam as avaliações dos jogadores';

  @override
  String get onlyMembersOfTeam => 'Apenas membros da equipa';

  @override
  String get noRestriction => 'Sem restrições';

  @override
  String get minimumRatedGames => 'Jogos com classificação mínima';

  @override
  String get minimumRating => 'Classificação mínima';

  @override
  String get maximumWeeklyRating => 'Avaliação semanal máxima';

  @override
  String positionInputHelp(String param) {
    return 'Cole um FEN válido para iniciar todos os jogos a partir de uma determinada posição.\nSó funciona para os jogos padrão, não com variantes.\nVocê pode usar o $param para gerar uma posição FEN e, em seguida, colá-lo aqui.\nDeixe em branco para iniciar jogos da posição inicial normal.';
  }

  @override
  String get cancelSimul => 'Cancelar a simultânea';

  @override
  String get simulHostcolor => 'Cor do anfitrião para cada jogo';

  @override
  String get estimatedStart => 'Hora de início prevista';

  @override
  String simulFeatured(String param) {
    return 'Em destaque em $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Mostre a sua simultânea a todos em $param. Desativar para simultâneas privadas.';
  }

  @override
  String get simulDescription => 'Descrição da simultânea';

  @override
  String get simulDescriptionHelp => 'Quer dizer alguma coisa aos participantes?';

  @override
  String markdownAvailable(String param) {
    return '$param está disponível para sintaxe mais avançada.';
  }

  @override
  String get embedsAvailable => 'Cole o URL de um jogo ou um URL de um capítulo de estudo para integrá-lo.';

  @override
  String get inYourLocalTimezone => 'No seu próprio fuso horário local';

  @override
  String get tournChat => 'Chat do torneio';

  @override
  String get noChat => 'Sem chat';

  @override
  String get onlyTeamLeaders => 'Apenas líderes da equipa';

  @override
  String get onlyTeamMembers => 'Apenas membros da equipa';

  @override
  String get navigateMoveTree => 'Navegar pela árvore de movimentos';

  @override
  String get mouseTricks => 'Movimentos do rato';

  @override
  String get toggleLocalAnalysis => 'Ativar/desativar análise local no computador';

  @override
  String get toggleAllAnalysis => 'Alternar todas as análises no computador';

  @override
  String get playComputerMove => 'Jogar o melhor lance do computador';

  @override
  String get analysisOptions => 'Opções de análise';

  @override
  String get focusChat => 'Focar no bate-papo';

  @override
  String get showHelpDialog => 'Mostrar esta mensagem de ajuda';

  @override
  String get reopenYourAccount => 'Reabrir a sua conta';

  @override
  String get closedAccountChangedMind => 'Se fechou a sua conta mas desde então mudou de ideias, terá uma oportunidade de recuperar a sua conta.';

  @override
  String get onlyWorksOnce => 'Isto só vai funcionar uma única vez.';

  @override
  String get cantDoThisTwice => 'Se fechar a conta uma segunda vez, não haverá forma de a recuperar.';

  @override
  String get emailAssociatedToaccount => 'Endereço de email associado à conta';

  @override
  String get sentEmailWithLink => 'Enviámos-lhe um e-mail com um link.';

  @override
  String get tournamentEntryCode => 'Código de entrada do torneio';

  @override
  String get hangOn => 'Aguarde!';

  @override
  String gameInProgress(String param) {
    return 'Tem um jogo em curso com $param.';
  }

  @override
  String get abortTheGame => 'Cancelar o jogo';

  @override
  String get resignTheGame => 'Abandonar o jogo';

  @override
  String get youCantStartNewGame => 'Não pode iniciar um novo jogo antes de este estar terminado.';

  @override
  String get since => 'Desde';

  @override
  String get until => 'Até';

  @override
  String get lichessDbExplanation => 'Jogos avaliados por amostragem de todos os jogadores Lichess';

  @override
  String get switchSides => 'Trocar de lado';

  @override
  String get closingAccountWithdrawAppeal => 'Encerrar a tua conta anula o teu apelo';

  @override
  String get ourEventTips => 'Os nossos conselhos para organizar eventos';

  @override
  String get instructions => 'Instruções';

  @override
  String get showMeEverything => 'Mostra-me tudo';

  @override
  String get lichessPatronInfo => 'Lichess é uma instituição de caridade e software de código aberto totalmente livre.\nTodos os custos operacionais, de desenvolvimento e conteúdo são financiados exclusivamente por doações de usuários.';

  @override
  String get nothingToSeeHere => 'Nada para ver aqui no momento.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O teu adversário deixou a partida. Podes reivindicar vitória em $count segundos.',
      one: 'O teu adversário deixou a partida. Podes reivindicar vitória em $count segundo.',
      zero: 'O teu adversário deixou a partida. Podes reivindicar vitória em $count segundo.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xeque-mate em $count meio-movimentos',
      one: 'Xeque-mate em $count meio-movimento',
      zero: 'Xeque-mate em $count meio-movimento',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erros graves',
      one: '$count erro grave',
      zero: '$count erro grave',
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
      zero: '$count erro',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imprecisões',
      one: '$count imprecisão',
      zero: '$count imprecisão',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogadores',
      one: '$count jogador',
      zero: '$count jogador',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogos',
      one: '$count jogo',
      zero: '$count jogo',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$param2 partidas $count avaliadas',
      one: '$param2 partida $count avaliada',
      zero: '$param2 partida $count avaliada',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count favoritos',
      one: '$count favorito',
      zero: '$count favorito',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '$count dia',
      zero: '$count dia',
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
      zero: '$count hora',
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
      zero: '$count minuto',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'As posições são atualizadas a cada $count minutos',
      one: 'As posições são atualizadas a cada minuto',
      zero: 'As posições são atualizadas a cada minuto',
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
      zero: '$count problema',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogos contigo',
      one: '$count jogo contigo',
      zero: '$count jogo contigo',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidas a valer pontos',
      one: '$count partida a valer pontos',
      zero: '$count partida a valer pontos',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vitórias',
      one: '$count vitória',
      zero: '$count vitória',
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
      zero: '$count derrota',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count empates',
      one: '$count empate',
      zero: '$count empate',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count a jogar',
      one: '$count a jogar',
      zero: '$count a jogar',
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
      zero: 'Dar $count segundo',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos de torneio',
      one: '$count ponto de torneio',
      zero: '$count ponto de torneio',
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
      zero: '$count estudo',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultâneas',
      one: '$count simultânea',
      zero: '$count simultânea',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partidas a valer pontos',
      one: '≥ $count partida a valer pontos',
      zero: '≥ $count partida a valer pontos',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partidas de $param2 a valer pontos',
      one: '≥ $count partida de $param2 a valer pontos',
      zero: '≥ $count partida de $param2 a valer pontos',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Precisa de jogar mais $count jogos de $param2 a valer pontos',
      one: 'Precisas de jogar mais $count jogo de $param2 a valer pontos',
      zero: 'Precisas de jogar mais $count jogo de $param2 a valer pontos',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tens de jogar mais $count jogos a valer pontos',
      one: 'Tens de jogar mais $count jogo a valer pontos',
      zero: 'Tens de jogar mais $count jogo a valer pontos',
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
      zero: '$count partida importada',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos online',
      one: '$count amigo online',
      zero: '$count amigo online',
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
      zero: '$count seguidor',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'a seguir $count jogadores',
      one: 'a seguir $count jogador',
      zero: 'a seguir $count jogador',
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
      zero: 'Menos de $count minuto',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogos a decorrer',
      one: '$count jogo a decorrer',
      zero: '$count jogo a decorrer',
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
      zero: 'Máximo: $count carácter.',
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
      zero: '$count bloqueado',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count publicações no fórum',
      one: '$count publicação no fórum',
      zero: '$count publicação no fórum',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogadores ativos esta semana em $param2.',
      one: '$count jogador ativo esta semana em $param2.',
      zero: '$count jogador ativo esta semana em $param2.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Disponível em $count línguas!',
      one: 'Disponível em $count língua!',
      zero: 'Disponível em $count língua!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundos para jogar o primeiro movimento',
      one: '$count segundo para jogar o primeiro movimento',
      zero: '$count segundo para jogar o primeiro movimento',
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
      zero: '$count segundo',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'e guarda $count variantes de movimentos antecipados',
      one: 'e guarda $count variante de movimentos antecipados',
      zero: 'e guarda $count variante de movimentos antecipados',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Faz um lance para começar';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Jogas com as peças brancas em todos os problemas';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Jogas com as peças pretas em todos os problemas';

  @override
  String get stormPuzzlesSolved => 'problemas resolvidos';

  @override
  String get stormNewDailyHighscore => 'Novo recorde diário!';

  @override
  String get stormNewWeeklyHighscore => 'Novo recorde semanal!';

  @override
  String get stormNewMonthlyHighscore => 'Novo recorde mensal!';

  @override
  String get stormNewAllTimeHighscore => 'Novo recorde!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'O recorde anterior era $param';
  }

  @override
  String get stormPlayAgain => 'Jogar novamente';

  @override
  String stormHighscoreX(String param) {
    return 'Recorde: $param';
  }

  @override
  String get stormScore => 'Pontuação';

  @override
  String get stormMoves => 'Total de lances';

  @override
  String get stormAccuracy => 'Precisão';

  @override
  String get stormCombo => 'Combo';

  @override
  String get stormTime => 'Tempo';

  @override
  String get stormTimePerMove => 'Tempo por jogada';

  @override
  String get stormHighestSolved => 'Problema mais difícil resolvido';

  @override
  String get stormPuzzlesPlayed => 'Problemas jogados';

  @override
  String get stormNewRun => 'Nova partida (tecla: espaço)';

  @override
  String get stormEndRun => 'Terminar partida (tecla: Enter)';

  @override
  String get stormHighscores => 'Recorde';

  @override
  String get stormViewBestRuns => 'Ver as melhores partidas';

  @override
  String get stormBestRunOfDay => 'Melhor partida do dia';

  @override
  String get stormRuns => 'Partidas';

  @override
  String get stormGetReady => 'Preparar!';

  @override
  String get stormWaitingForMorePlayers => 'À espera de mais jogadores...';

  @override
  String get stormRaceComplete => 'Race concluída!';

  @override
  String get stormSpectating => 'A assistir';

  @override
  String get stormJoinTheRace => 'Junta-te à corrida!';

  @override
  String get stormStartTheRace => 'Começar a corrida';

  @override
  String stormYourRankX(String param) {
    return 'A tua pontuação: $param';
  }

  @override
  String get stormWaitForRematch => 'Espera pela desforra';

  @override
  String get stormNextRace => 'Próxima corrida';

  @override
  String get stormJoinRematch => 'Juntar-se à desforra';

  @override
  String get stormWaitingToStart => 'À espera de começar';

  @override
  String get stormCreateNewGame => 'Criar um novo jogo';

  @override
  String get stormJoinPublicRace => 'Junta-te a uma corrida pública';

  @override
  String get stormRaceYourFriends => 'Corre contra os teus amigos';

  @override
  String get stormSkip => 'ignorar';

  @override
  String get stormSkipHelp => 'Pode pular um movimento por corrida:';

  @override
  String get stormSkipExplanation => 'Passa à frente esta jogada para preservares o teu combo! Só podes fazê-lo apenas uma vez por Race.';

  @override
  String get stormFailedPuzzles => 'Desafios falhados';

  @override
  String get stormSlowPuzzles => 'Desafios lentos';

  @override
  String get stormSkippedPuzzle => 'Desafios saltados';

  @override
  String get stormThisWeek => 'Esta semana';

  @override
  String get stormThisMonth => 'Este mês';

  @override
  String get stormAllTime => 'Desde sempre';

  @override
  String get stormClickToReload => 'Clique para recarregar';

  @override
  String get stormThisRunHasExpired => 'Esta sessão expirou!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Esta sessão foi aberta noutra aba!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentativas',
      one: '1 partida',
      zero: '1 partida',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jogou $count partidas de $param2',
      one: 'Jogou uma partida de $param2',
      zero: 'Jogou uma partida de $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Streamers no Lichess';

  @override
  String get studyShareAndExport => 'Partilhar & exportar';

  @override
  String get studyStart => 'Iniciar';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

  @override
  String get activityActivity => 'Atividade';

  @override
  String get activityHostedALiveStream => 'Iniciou uma transmissão ao vivo';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Classificado #$param1 entre $param2';
  }

  @override
  String get activitySignedUp => 'Registrou-se no lichess';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Contribuiu para o lichess.org por $count meses como $param2',
      one: 'Contribuiu para o lichess.org por $count mês como $param2',
      zero: 'Contribuiu para o lichess.org por $count mês como $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Praticou $count posições em $param2',
      one: 'Praticou $count posição em $param2',
      zero: 'Praticou $count posição em $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Resolveu $count quebra-cabeças táticos',
      one: 'Resolveu $count quebra-cabeça tático',
      zero: 'Resolveu $count quebra-cabeça tático',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jogou $count partidas de $param2',
      one: 'Jogou $count partida de $param2',
      zero: 'Jogou $count partida de $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Publicou $count mensagens em $param2',
      one: 'Publicou $count mensagem em $param2',
      zero: 'Publicou $count mensagem em $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jogou $count movimentos',
      one: 'Jogou $count movimento',
      zero: 'Jogou $count movimento',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'em $count jogos por correspondência',
      one: 'em $count jogo por correspondência',
      zero: 'em $count jogo por correspondência',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Completou $count jogos por correspondência',
      one: 'Completou $count jogo por correspondência',
      zero: 'Completou $count jogo por correspondência',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Começou a seguir $count jogadores',
      one: 'Começou a seguir $count jogador',
      zero: 'Começou a seguir $count jogador',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ganhou $count novos seguidores',
      one: 'Ganhou $count novo seguidor',
      zero: 'Ganhou $count novo seguidor',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hospedou $count exibições simultâneas',
      one: 'Hospedou $count exibição simultânea',
      zero: 'Hospedou $count exibição simultânea',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Participou em $count exibições simultâneas',
      one: 'Participou em $count exibição simultânea',
      zero: 'Participou em $count exibição simultânea',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Criou $count novos estudos',
      one: 'Criou $count novo estudo',
      zero: 'Criou $count novo estudo',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Competiu em $count torneios arena',
      one: 'Competiu em $count torneio arena',
      zero: 'Competiu em $count torneio arena',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Classificado #$count (top $param2%) com $param3 jogos em $param4',
      one: 'Classificado #$count (top $param2%) com $param3 jogo em $param4',
      zero: 'Classificado #$count (top $param2%) com $param3 jogo em $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Competiu em $count torneios suíços',
      one: 'Competiu em $count torneio suíço',
      zero: 'Competiu em $count torneio suíço',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Entrou nas $count equipes',
      one: 'Entrou na $count equipe',
      zero: 'Entrou na $count equipe',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Transmissões';

  @override
  String get broadcastStartDate => 'Data de início em seu próprio fuso horário';

  @override
  String challengeChallengesX(String param1) {
    return 'Desafios: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Desafiar para jogar';

  @override
  String get challengeChallengeDeclined => 'Desafio recusado';

  @override
  String get challengeChallengeAccepted => 'Desafio aceito!';

  @override
  String get challengeChallengeCanceled => 'Desafio cancelado.';

  @override
  String get challengeRegisterToSendChallenges => 'Por favor, registre-se para enviar desafios.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Você não pode desafiar $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param não aceita desafios.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'O seu rating $param1 é muito diferente de $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Não pode desafiar devido ao rating provisório de $param.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param só aceita desafios de amigos.';
  }

  @override
  String get challengeDeclineGeneric => 'Não estou aceitando desafios no momento.';

  @override
  String get challengeDeclineLater => 'Este não é o momento certo para mim, por favor pergunte novamente mais tarde.';

  @override
  String get challengeDeclineTooFast => 'Este controle de tempo é muito rápido para mim, por favor, desafie novamente com um jogo mais lento.';

  @override
  String get challengeDeclineTooSlow => 'Este controle de tempo é muito lento para mim, por favor, desafie novamente com um jogo mais rápido.';

  @override
  String get challengeDeclineTimeControl => 'Não estou aceitando desafios com estes controles de tempo.';

  @override
  String get challengeDeclineRated => 'Por favor, envie-me um desafio ranqueado.';

  @override
  String get challengeDeclineCasual => 'Por favor, envie-me um desafio amigável.';

  @override
  String get challengeDeclineStandard => 'Não estou aceitando desafios de variantes no momento.';

  @override
  String get challengeDeclineVariant => 'Não estou a fim de jogar esta variante no momento.';

  @override
  String get challengeDeclineNoBot => 'Não estou aceitando desafios de robôs.';

  @override
  String get challengeDeclineOnlyBot => 'Estou aceitando apenas desafios de robôs.';

  @override
  String get challengeInviteLichessUser => 'Ou convide um usuário Lichess:';

  @override
  String get contactContact => 'Contato';

  @override
  String get contactContactLichess => 'Entrar em contato com Lichess';

  @override
  String get patronDonate => 'Doação';

  @override
  String get patronLichessPatron => 'Apoie o Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Estatísticas de $param';
  }

  @override
  String get perfStatViewTheGames => 'Ver os jogos';

  @override
  String get perfStatProvisional => 'provisório';

  @override
  String get perfStatNotEnoughRatedGames => 'Não foram jogadas partidas suficientes valendo rating para estabelecer uma classificação confiável.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progresso nos últimos $param jogos:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Desvio de pontuação: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Um valor inferior indica que a pontuação é mais estável. Superior a $param1, a pontuação é classificada como provisória. Para ser incluída nas classificações, esse valor deve ser inferior a $param2 (xadrez padrão) ou $param3 (variantes).';
  }

  @override
  String get perfStatTotalGames => 'Total de partidas';

  @override
  String get perfStatRatedGames => 'Partidas valendo pontos';

  @override
  String get perfStatTournamentGames => 'Jogos de torneio';

  @override
  String get perfStatBerserkedGames => 'Partidas Berserked';

  @override
  String get perfStatTimeSpentPlaying => 'Tempo jogando';

  @override
  String get perfStatAverageOpponent => 'Pontuação média do adversário';

  @override
  String get perfStatVictories => 'Vitórias';

  @override
  String get perfStatDefeats => 'Derrotas';

  @override
  String get perfStatDisconnections => 'Desconexões';

  @override
  String get perfStatNotEnoughGames => 'Jogos insuficientes jogados';

  @override
  String perfStatHighestRating(String param) {
    return 'Pontuação mais alta: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Rating mais baixo: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'de $param1 para $param2';
  }

  @override
  String get perfStatWinningStreak => 'Série de Vitórias';

  @override
  String get perfStatLosingStreak => 'Série de derrotas';

  @override
  String perfStatLongestStreak(String param) {
    return 'Sequência mais longa: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Sequência atual: $param';
  }

  @override
  String get perfStatBestRated => 'Melhores vitórias valendo pontuação';

  @override
  String get perfStatGamesInARow => 'Partidas jogadas seguidas';

  @override
  String get perfStatLessThanOneHour => 'Menos de uma hora entre partidas';

  @override
  String get perfStatMaxTimePlaying => 'Tempo máximo jogando';

  @override
  String get perfStatNow => 'agora';

  @override
  String get preferencesPreferences => 'Preferências';

  @override
  String get preferencesDisplay => 'Exibição';

  @override
  String get preferencesPrivacy => 'Privacidade';

  @override
  String get preferencesNotifications => 'Notificações';

  @override
  String get preferencesPieceAnimation => 'Animação das peças';

  @override
  String get preferencesMaterialDifference => 'Diferença material';

  @override
  String get preferencesBoardHighlights => 'Destacar casas do tabuleiro (último movimento e xeque)';

  @override
  String get preferencesPieceDestinations => 'Destino das peças (movimentos válidos e pré-movimentos)';

  @override
  String get preferencesBoardCoordinates => 'Coordenadas do tabuleiro (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Lista de movimentos durante a partida';

  @override
  String get preferencesPgnPieceNotation => 'Modo de notação das jogadas';

  @override
  String get preferencesChessPieceSymbol => 'Símbolo da peça';

  @override
  String get preferencesPgnLetter => 'Letra (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Modo Zen';

  @override
  String get preferencesShowPlayerRatings => 'Mostrar rating dos jogadores';

  @override
  String get preferencesShowFlairs => 'Mostrar emotes de usuário';

  @override
  String get preferencesExplainShowPlayerRatings => 'Permite ocultar todas os ratings do site, para ajudar a se concentrar no jogo. As partidas continuam valendo rating.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Mostrar cursor de redimensionamento do tabuleiro';

  @override
  String get preferencesOnlyOnInitialPosition => 'Apenas na posição inicial';

  @override
  String get preferencesInGameOnly => 'Durante partidas';

  @override
  String get preferencesChessClock => 'Relógio';

  @override
  String get preferencesTenthsOfSeconds => 'Décimos de segundo';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Quando o tempo restante < 10 segundos';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Barras de progresso verdes horizontais';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Som ao atingir tempo crítico';

  @override
  String get preferencesGiveMoreTime => 'Dar mais tempo';

  @override
  String get preferencesGameBehavior => 'Comportamento do jogo';

  @override
  String get preferencesHowDoYouMovePieces => 'Como você move as peças?';

  @override
  String get preferencesClickTwoSquares => 'Clicar em duas casas';

  @override
  String get preferencesDragPiece => 'Arrastar a peça';

  @override
  String get preferencesBothClicksAndDrag => 'Ambas';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Pré-movimentos (jogadas durante o turno do oponente)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Voltar jogada (com aprovação do oponente)';

  @override
  String get preferencesInCasualGamesOnly => 'Somente em jogos casuais';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promover a Dama automaticamente';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Mantenha a tecla <ctrl> pressionada enquanto promove para desativar temporariamente a autopromoção';

  @override
  String get preferencesWhenPremoving => 'Quando pré-mover';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Reivindicar empate sobre a repetição tripla automaticamente';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Quando o tempo restante < 30 segundos';

  @override
  String get preferencesMoveConfirmation => 'Confirmação de movimento';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Pode ser desativado durante a partida no menu do tabuleiro';

  @override
  String get preferencesInCorrespondenceGames => 'Jogos por correspondência';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Por correspondência e sem limites';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Confirmar abandono e oferta de empate';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Maneira de rocar';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Mover o rei duas casas';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Mover o rei em direção à torre';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Fazer lances com escrita do teclado';

  @override
  String get preferencesInputMovesWithVoice => 'Mova as peças com sua voz';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Insira setas para movimentos válidos';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Diga \"Bom jogo, bem jogado\" após a derrota ou empate';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Suas preferências foram salvas.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Use o scroll do mouse no tabuleiro para ir passando as jogadas';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Email diário listando seus jogos por correspondência';

  @override
  String get preferencesNotifyStreamStart => 'Streamer começou uma transmissão ao vivo';

  @override
  String get preferencesNotifyInboxMsg => 'Nova mensagem na caixa de entrada';

  @override
  String get preferencesNotifyForumMention => 'Você foi mencionado em um comentário do fórum';

  @override
  String get preferencesNotifyInvitedStudy => 'Convite para um estudo';

  @override
  String get preferencesNotifyGameEvent => 'Jogo por correspondência atualizado';

  @override
  String get preferencesNotifyChallenge => 'Desafios';

  @override
  String get preferencesNotifyTournamentSoon => 'O torneio vai começar em breve';

  @override
  String get preferencesNotifyTimeAlarm => 'Está acabando o tempo no jogo por correspondência';

  @override
  String get preferencesNotifyBell => 'Notificação no Lichess';

  @override
  String get preferencesNotifyPush => 'Notificação no dispositivo fora do Lichess';

  @override
  String get preferencesNotifyWeb => 'Navegador';

  @override
  String get preferencesNotifyDevice => 'Dispositivo';

  @override
  String get preferencesBellNotificationSound => 'Som da notificação';

  @override
  String get puzzlePuzzles => 'Quebra-cabeças';

  @override
  String get puzzlePuzzleThemes => 'Temas de quebra-cabeça';

  @override
  String get puzzleRecommended => 'Recomendado';

  @override
  String get puzzlePhases => 'Fases';

  @override
  String get puzzleMotifs => 'Motivos táticos';

  @override
  String get puzzleAdvanced => 'Avançado';

  @override
  String get puzzleLengths => 'Distância';

  @override
  String get puzzleMates => 'Xeque-mates';

  @override
  String get puzzleGoals => 'Objetivos';

  @override
  String get puzzleOrigin => 'Origem';

  @override
  String get puzzleSpecialMoves => 'Movimentos especiais';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Você gostou deste quebra-cabeças?';

  @override
  String get puzzleVoteToLoadNextOne => 'Vote para carregar o próximo!';

  @override
  String get puzzleUpVote => 'Votar a favor do quebra-cabeça';

  @override
  String get puzzleDownVote => 'Votar contra o quebra-cabeça';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Sua pontuação de quebra-cabeças não mudará. Note que os quebra-cabeças não são uma competição. A pontuação indica os quebra-cabeças que se adequam às suas habilidades.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Encontre o melhor lance para as brancas.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Encontre a melhor jogada para as pretas.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Para obter desafios personalizados:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Quebra-cabeça $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Quebra-cabeça do dia';

  @override
  String get puzzleDailyPuzzle => 'Quebra-cabeça diário';

  @override
  String get puzzleClickToSolve => 'Clique para resolver';

  @override
  String get puzzleGoodMove => 'Boa jogada';

  @override
  String get puzzleBestMove => 'Melhor jogada!';

  @override
  String get puzzleKeepGoing => 'Continue…';

  @override
  String get puzzlePuzzleSuccess => 'Sucesso!';

  @override
  String get puzzlePuzzleComplete => 'Quebra-cabeças concluído!';

  @override
  String get puzzleByOpenings => 'Por abertura';

  @override
  String get puzzlePuzzlesByOpenings => 'Quebra-cabeças por abertura';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Aberturas que você mais jogou em partidas valendo pontos';

  @override
  String get puzzleUseFindInPage => 'Use a ferramenta \"Encontrar na página\" do navegador para encontrar sua abertura favorita!';

  @override
  String get puzzleUseCtrlF => 'Aperte Ctrl + F para encontrar sua abertura favorita!';

  @override
  String get puzzleNotTheMove => 'O movimento não é este!';

  @override
  String get puzzleTrySomethingElse => 'Tente algo diferente.';

  @override
  String puzzleRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get puzzleHidden => 'oculto';

  @override
  String puzzleFromGameLink(String param) {
    return 'Do jogo $param';
  }

  @override
  String get puzzleContinueTraining => 'Continue treinando';

  @override
  String get puzzleDifficultyLevel => 'Nível de dificuldade';

  @override
  String get puzzleNormal => 'Normal';

  @override
  String get puzzleEasier => 'Fácil';

  @override
  String get puzzleEasiest => 'Muito fácil';

  @override
  String get puzzleHarder => 'Difícil';

  @override
  String get puzzleHardest => 'Muito difícil';

  @override
  String get puzzleExample => 'Exemplo';

  @override
  String get puzzleAddAnotherTheme => 'Adicionar um outro tema';

  @override
  String get puzzleNextPuzzle => 'Próximo quebra-cabeça';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Ir para o próximo problema automaticamente';

  @override
  String get puzzlePuzzleDashboard => 'Painel do quebra-cabeças';

  @override
  String get puzzleImprovementAreas => 'Áreas de aprimoramento';

  @override
  String get puzzleStrengths => 'Pontos fortes';

  @override
  String get puzzleHistory => 'Histórico de quebra-cabeças';

  @override
  String get puzzleSolved => 'resolvido';

  @override
  String get puzzleFailed => 'falhou';

  @override
  String get puzzleStreakDescription => 'Resolva quebra-cabeças progressivamente mais difíceis e construa uma sequência de vitórias. Não há relógio, então tome seu tempo. Um movimento errado e o jogo acaba! Porém, você pode pular um movimento por sessão.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Sua sequência: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Pule este lance para preservar a sua sequência! Funciona apenas uma vez por corrida.';

  @override
  String get puzzleContinueTheStreak => 'Continuar a sequência';

  @override
  String get puzzleNewStreak => 'Nova sequência';

  @override
  String get puzzleFromMyGames => 'Dos meus jogos';

  @override
  String get puzzleLookupOfPlayer => 'Pesquise quebra-cabeças de um jogador específico';

  @override
  String puzzleFromXGames(String param) {
    return 'Problemas de $param\' jogos';
  }

  @override
  String get puzzleSearchPuzzles => 'Procurar quebra-cabeças';

  @override
  String get puzzleFromMyGamesNone => 'Você não tem nenhum quebra-cabeça no banco de dados, mas o Lichess ainda te ama muito.\nJogue partidas rápidas e clássicas para aumentar suas chances de ter um desafio seu adicionado!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 quebra-cabeças encontrados em $param2 partidas';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Treine, analise, melhore';

  @override
  String puzzlePercentSolved(String param) {
    return '$param resolvido';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Não há nada para mostrar aqui, jogue alguns quebra-cabeças primeiro!';

  @override
  String get puzzleImprovementAreasDescription => 'Treine estes para otimizar o seu progresso!';

  @override
  String get puzzleStrengthDescription => 'Sua perfomance é melhor nesses temas';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jogado $count vezes',
      one: 'Jogado $count vezes',
      zero: 'Jogado $count vezes',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos abaixo da sua classificação de quebra-cabeças',
      one: 'Um ponto abaixo da sua classificação de quebra-cabeças',
      zero: 'Um ponto abaixo da sua classificação de quebra-cabeças',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos acima da sua classificação de quebra-cabeças',
      one: 'Um ponto acima da sua classificação de quebra-cabeças',
      zero: 'Um ponto acima da sua classificação de quebra-cabeças',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogados',
      one: '$count jogado',
      zero: '$count jogado',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count a serem repetidos',
      one: '$count a ser repetido',
      zero: '$count a ser repetido',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Peão avançado';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Um peão prestes a ser promovido ou à beira da promoção é um tema tático.';

  @override
  String get puzzleThemeAdvantage => 'Vantagem';

  @override
  String get puzzleThemeAdvantageDescription => 'Aproveite a sua chance de ter uma vantagem decisiva. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Mate Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Um cavalo e uma torre se unem para prender o rei do oponente entre a lateral do tabuleiro e uma peça amiga.';

  @override
  String get puzzleThemeArabianMate => 'Mate árabe';

  @override
  String get puzzleThemeArabianMateDescription => 'Um cavalo e uma torre se unem para prender o rei inimigo em um canto do tabuleiro.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Atacando f2 ou f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Um ataque focado no peão de f2 e no peão de f7, como na abertura frango frito.';

  @override
  String get puzzleThemeAttraction => 'Atração';

  @override
  String get puzzleThemeAttractionDescription => 'Uma troca ou sacrifício encorajando ou forçando uma peça do oponente a uma casa que permite uma sequência tática.';

  @override
  String get puzzleThemeBackRankMate => 'Mate do corredor';

  @override
  String get puzzleThemeBackRankMateDescription => 'Dê o xeque-mate no rei na última fileira, quando ele estiver bloqueado pelas próprias peças.';

  @override
  String get puzzleThemeBishopEndgame => 'Finais de bispo';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Final com somente bispos e peões.';

  @override
  String get puzzleThemeBodenMate => 'Mate de Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Dois bispos atacantes em diagonais cruzadas dão um mate em um rei obstruído por peças amigas.';

  @override
  String get puzzleThemeCastling => 'Roque';

  @override
  String get puzzleThemeCastlingDescription => 'Traga o seu rei para a segurança, e prepare sua torre para o ataque.';

  @override
  String get puzzleThemeCapturingDefender => 'Capture o defensor';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Remover uma peça que seja importante na defesa de outra, permitindo que agora a peça indefesa seja capturada na jogada seguinte.';

  @override
  String get puzzleThemeCrushing => 'Punindo';

  @override
  String get puzzleThemeCrushingDescription => 'Perceba a capivarada do oponente para obter uma vantagem decisiva. (vantagem ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mate de dois bispos';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Dois bispos atacantes em diagonais adjacentes dão um mate em um rei obstruído por peças amigas.';

  @override
  String get puzzleThemeDovetailMate => 'Mate da cauda de andorinha';

  @override
  String get puzzleThemeDovetailMateDescription => 'Uma dama dá um mate em um rei adjacente, cujos únicos dois quadrados de fuga estão obstruídos por peças amigas.';

  @override
  String get puzzleThemeEquality => 'Igualdade';

  @override
  String get puzzleThemeEqualityDescription => 'Saia de uma posição perdida, e assegure um empate ou uma posição equilibrada. (aval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Ataque na ala do Rei';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Um ataque ao rei do oponente, após ele ter efetuado o roque curto.';

  @override
  String get puzzleThemeClearance => 'Lance útil';

  @override
  String get puzzleThemeClearanceDescription => 'Um lance, às vezes consumindo tempos, que libera uma casa, fileira ou diagonal para uma ideia tática em seguida.';

  @override
  String get puzzleThemeDefensiveMove => 'Movimento defensivo';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Um movimento preciso ou sequência de movimentos que são necessários para evitar perda de material ou outra vantagem.';

  @override
  String get puzzleThemeDeflection => 'Desvio';

  @override
  String get puzzleThemeDeflectionDescription => 'Um movimento que desvia a peça do oponente da sua função, por exemplo a de defesa de outra peça ou a defesa de uma casa importante.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Ataque descoberto';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Mover uma peça que anteriormente bloqueava um ataque de uma peça de longo alcance, como por exemplo um cavalo liberando a coluna de uma torre.';

  @override
  String get puzzleThemeDoubleCheck => 'Xeque duplo';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Dar Xeque com duas peças ao mesmo tempo, como resultado de um ataque descoberto onde tanto a peça que se move quanto a peça que estava sendo obstruída atacam o rei do oponente.';

  @override
  String get puzzleThemeEndgame => 'Finais';

  @override
  String get puzzleThemeEndgameDescription => 'Tática durante a última fase do jogo.';

  @override
  String get puzzleThemeEnPassantDescription => 'Uma tática envolvendo a regra do en passant, onde um peão pode capturar um peão do oponente que passou por ele usando seu movimento inicial de duas casas.';

  @override
  String get puzzleThemeExposedKing => 'Rei exposto';

  @override
  String get puzzleThemeExposedKingDescription => 'Uma tática que envolve um rei com poucos defensores ao seu redor, muitas vezes levando a xeque-mate.';

  @override
  String get puzzleThemeFork => 'Garfo (ou duplo)';

  @override
  String get puzzleThemeForkDescription => 'Um movimento onde a peça movida ataca duas peças de oponente de uma só vez.';

  @override
  String get puzzleThemeHangingPiece => 'Peça pendurada';

  @override
  String get puzzleThemeHangingPieceDescription => 'Uma táctica que envolve uma peça indefesa do oponente ou insuficientemente defendida e livre para ser capturada.';

  @override
  String get puzzleThemeHookMate => 'Xeque gancho';

  @override
  String get puzzleThemeHookMateDescription => 'Xeque-mate com uma torre, um cavalo e um peão, juntamente com um peão inimigo, para limitar a fuga do rei.';

  @override
  String get puzzleThemeInterference => 'Interferência';

  @override
  String get puzzleThemeInterferenceDescription => 'Mover uma peça entre duas peças do oponente para deixar uma ou duas peças do oponente indefesas, como um cavalo em uma casa defendida por duas torres.';

  @override
  String get puzzleThemeIntermezzo => 'Lance intermediário';

  @override
  String get puzzleThemeIntermezzoDescription => 'Em vez de jogar o movimento esperado, primeiro realiza outro movimento criando uma ameaça imediata a que o oponente deve responder. Também conhecido como \"Zwischenzug\" ou \"In between\".';

  @override
  String get puzzleThemeKnightEndgame => 'Finais de Cavalo';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Um final jogado apenas com cavalos e peões.';

  @override
  String get puzzleThemeLong => 'Quebra-cabeças longo';

  @override
  String get puzzleThemeLongDescription => 'Vitória em três movimentos.';

  @override
  String get puzzleThemeMaster => 'Partidas de mestres';

  @override
  String get puzzleThemeMasterDescription => 'Quebra-cabeças de partidas jogadas por jogadores titulados.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partidas de Mestre vs Mestre';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Quebra-cabeças de partidas entre dois jogadores titulados.';

  @override
  String get puzzleThemeMate => 'Xeque-mate';

  @override
  String get puzzleThemeMateDescription => 'Vença o jogo com estilo.';

  @override
  String get puzzleThemeMateIn1 => 'Mate em 1';

  @override
  String get puzzleThemeMateIn1Description => 'Dar xeque-mate em um movimento.';

  @override
  String get puzzleThemeMateIn2 => 'Mate em 2';

  @override
  String get puzzleThemeMateIn2Description => 'Dar xeque-mate em dois movimentos.';

  @override
  String get puzzleThemeMateIn3 => 'Mate em 3';

  @override
  String get puzzleThemeMateIn3Description => 'Dar xeque-mate em três movimentos.';

  @override
  String get puzzleThemeMateIn4 => 'Mate em 4';

  @override
  String get puzzleThemeMateIn4Description => 'Dar xeque-mate em 4 movimentos.';

  @override
  String get puzzleThemeMateIn5 => 'Mate em 5 ou mais';

  @override
  String get puzzleThemeMateIn5Description => 'Descubra uma longa sequência de mate.';

  @override
  String get puzzleThemeMiddlegame => 'Meio-jogo';

  @override
  String get puzzleThemeMiddlegameDescription => 'Tática durante a segunda fase do jogo.';

  @override
  String get puzzleThemeOneMove => 'Quebra-cabeças de um movimento';

  @override
  String get puzzleThemeOneMoveDescription => 'Quebra-cabeças de um movimento.';

  @override
  String get puzzleThemeOpening => 'Abertura';

  @override
  String get puzzleThemeOpeningDescription => 'Tática durante a primeira fase do jogo.';

  @override
  String get puzzleThemePawnEndgame => 'Finais de peões';

  @override
  String get puzzleThemePawnEndgameDescription => 'Um final apenas com peões.';

  @override
  String get puzzleThemePin => 'Cravada';

  @override
  String get puzzleThemePinDescription => 'Uma tática envolvendo cravada, onde uma peça é incapaz de mover-se sem abrir um descoberto em uma peça de maior valor.';

  @override
  String get puzzleThemePromotion => 'Promoção';

  @override
  String get puzzleThemePromotionDescription => 'Promova um peão para uma dama ou a uma peça menor.';

  @override
  String get puzzleThemeQueenEndgame => 'Finais de Dama';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Um final com apenas damas e peões.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Finais de Dama e Torre';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Finais com apenas Dama, Torre e Peões.';

  @override
  String get puzzleThemeQueensideAttack => 'Ataque na ala da dama';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Um ataque ao rei adversário, após ter efetuado o roque na ala da Dama.';

  @override
  String get puzzleThemeQuietMove => 'Lance de preparação';

  @override
  String get puzzleThemeQuietMoveDescription => 'Um lance que não dá xeque nem realiza uma captura, mas prepara uma ameaça inevitável para a jogada seguinte.';

  @override
  String get puzzleThemeRookEndgame => 'Finais de Torres';

  @override
  String get puzzleThemeRookEndgameDescription => 'Um final com apenas torres e peões.';

  @override
  String get puzzleThemeSacrifice => 'Sacrifício';

  @override
  String get puzzleThemeSacrificeDescription => 'Uma tática envolvendo a entrega de material no curto prazo, com o objetivo de se obter uma vantagem após uma sequência forçada de movimentos.';

  @override
  String get puzzleThemeShort => 'Quebra-cabeças curto';

  @override
  String get puzzleThemeShortDescription => 'Vitória em dois lances.';

  @override
  String get puzzleThemeSkewer => 'Raio X';

  @override
  String get puzzleThemeSkewerDescription => 'Um movimento que envolve uma peça de alto valor sendo atacada fugindo do ataque e permitindo que uma peça de menor valor seja capturada ou atacada, o inverso de cravada.';

  @override
  String get puzzleThemeSmotheredMate => 'Mate de Philidor (mate sufocado)';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Um xeque-mate dado por um cavalo onde o rei é incapaz de mover-se porque está cercado (ou sufocado) pelas próprias peças.';

  @override
  String get puzzleThemeSuperGM => 'Super partidas de GMs';

  @override
  String get puzzleThemeSuperGMDescription => 'Quebra-cabeças de partidas jogadas pelos melhores jogadores do mundo.';

  @override
  String get puzzleThemeTrappedPiece => 'Peça presa';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Uma peça é incapaz de escapar da captura, pois tem movimentos limitados.';

  @override
  String get puzzleThemeUnderPromotion => 'Subpromoção';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promover para cavalo, bispo ou torre.';

  @override
  String get puzzleThemeVeryLong => 'Quebra-cabeças muito longo';

  @override
  String get puzzleThemeVeryLongDescription => 'Quatro movimentos ou mais para vencer.';

  @override
  String get puzzleThemeXRayAttack => 'Ataque em raio X';

  @override
  String get puzzleThemeXRayAttackDescription => 'Uma peça ataca ou defende uma casa indiretamente, através de uma peça adversária.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'O adversário tem os seus movimentos limitados, e qualquer movimento que ele faça vai enfraquecer sua própria posição.';

  @override
  String get puzzleThemeHealthyMix => 'Combinação saudável';

  @override
  String get puzzleThemeHealthyMixDescription => 'Um pouco de tudo. Você nunca sabe o que vai encontrar, então esteja pronto para tudo! Igualzinho aos jogos em tabuleiros reais.';

  @override
  String get puzzleThemePlayerGames => 'Partidas de jogadores';

  @override
  String get puzzleThemePlayerGamesDescription => 'Procure quebra-cabeças gerados a partir de suas partidas ou das de outro jogador.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Esses quebra-cabeças estão em domínio público, e você pode baixá-los em $param.';
  }

  @override
  String get searchSearch => 'Buscar';

  @override
  String get settingsSettings => 'Configurações';

  @override
  String get settingsCloseAccount => 'Encerrar conta';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Sua conta é gerenciada, e não pode ser encerrada.';

  @override
  String get settingsClosingIsDefinitive => 'O encerramento é definitivo. Não há como desfazer. Tem certeza?';

  @override
  String get settingsCantOpenSimilarAccount => 'Você não poderá abrir uma nova conta com o mesmo nome, mesmo que alterne entre maiúsculas e minúsculas.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Eu mudei de ideia, não encerre minha conta';

  @override
  String get settingsCloseAccountExplanation => 'Tem certeza de que deseja encerrar sua conta? Encerrar sua conta é uma decisão permanente. Você NUNCA MAIS será capaz de entrar com ela novamente.';

  @override
  String get settingsThisAccountIsClosed => 'Esta conta foi encerrada.';

  @override
  String get playWithAFriend => 'Jogar contra um amigo';

  @override
  String get playWithTheMachine => 'Jogar contra o computador';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Para convidar alguém para jogar, envie este URL';

  @override
  String get gameOver => 'Fim da partida';

  @override
  String get waitingForOpponent => 'Aguardando oponente';

  @override
  String get orLetYourOpponentScanQrCode => 'Ou deixe seu oponente ler este QR Code';

  @override
  String get waiting => 'Aguardando';

  @override
  String get yourTurn => 'Sua vez';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 nível $param2';
  }

  @override
  String get level => 'Nível';

  @override
  String get strength => 'Nível';

  @override
  String get toggleTheChat => 'Ativar/Desativar chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Desistir';

  @override
  String get checkmate => 'Xeque-mate';

  @override
  String get stalemate => 'Rei afogado';

  @override
  String get white => 'Brancas';

  @override
  String get black => 'Pretas';

  @override
  String get asWhite => 'de brancas';

  @override
  String get asBlack => 'de pretas';

  @override
  String get randomColor => 'Cor aleatória';

  @override
  String get createAGame => 'Criar uma partida';

  @override
  String get whiteIsVictorious => 'Brancas vencem';

  @override
  String get blackIsVictorious => 'Pretas vencem';

  @override
  String get youPlayTheWhitePieces => 'Você joga com as peças brancas';

  @override
  String get youPlayTheBlackPieces => 'Você joga com as peças pretas';

  @override
  String get itsYourTurn => 'É a sua vez!';

  @override
  String get cheatDetected => 'Trapaça Detectada';

  @override
  String get kingInTheCenter => 'Rei no centro';

  @override
  String get threeChecks => 'Três xeques';

  @override
  String get raceFinished => 'Corrida terminada';

  @override
  String get variantEnding => 'Fim da variante';

  @override
  String get newOpponent => 'Novo oponente';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Seu oponente quer jogar uma nova partida contra você';

  @override
  String get joinTheGame => 'Entrar no jogo';

  @override
  String get whitePlays => 'Brancas jogam';

  @override
  String get blackPlays => 'Pretas jogam';

  @override
  String get opponentLeftChoices => 'O seu oponente deixou a partida. Você pode reivindicar vitória, declarar empate ou aguardar.';

  @override
  String get forceResignation => 'Reivindicar vitória';

  @override
  String get forceDraw => 'Reivindicar empate';

  @override
  String get talkInChat => 'Por favor, seja gentil no chat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'A primeira pessoa que acessar esta URL jogará contigo.';

  @override
  String get whiteResigned => 'Brancas desistiram';

  @override
  String get blackResigned => 'Pretas desistiram';

  @override
  String get whiteLeftTheGame => 'Brancas deixaram a partida';

  @override
  String get blackLeftTheGame => 'Pretas deixaram a partida';

  @override
  String get whiteDidntMove => 'As brancas não se moveram';

  @override
  String get blackDidntMove => 'As pretas não se moveram';

  @override
  String get requestAComputerAnalysis => 'Solicitar uma análise do computador';

  @override
  String get computerAnalysis => 'Análise do computador';

  @override
  String get computerAnalysisAvailable => 'Análise de computador disponível';

  @override
  String get computerAnalysisDisabled => 'Análise de computador desativada';

  @override
  String get analysis => 'Análise';

  @override
  String depthX(String param) {
    return 'Profundidade $param';
  }

  @override
  String get usingServerAnalysis => 'Análise de servidor em uso';

  @override
  String get loadingEngine => 'Carregando ...';

  @override
  String get calculatingMoves => 'Calculando jogadas...';

  @override
  String get engineFailed => 'Erro ao carregar o engine';

  @override
  String get cloudAnalysis => 'Análise na nuvem';

  @override
  String get goDeeper => 'Detalhar';

  @override
  String get showThreat => 'Mostrar ameaça';

  @override
  String get inLocalBrowser => 'no navegador local';

  @override
  String get toggleLocalEvaluation => 'Ativar/Desativar análise local';

  @override
  String get promoteVariation => 'Promover variante';

  @override
  String get makeMainLine => 'Transformar em linha principal';

  @override
  String get deleteFromHere => 'Excluir a partir daqui';

  @override
  String get collapseVariations => 'Esconder variantes';

  @override
  String get expandVariations => 'Mostrar variantes';

  @override
  String get forceVariation => 'Variante forçada';

  @override
  String get copyVariationPgn => 'Copiar PGN da variante';

  @override
  String get move => 'Movimentos';

  @override
  String get variantLoss => 'Derrota da variante';

  @override
  String get variantWin => 'Vitória da variante';

  @override
  String get insufficientMaterial => 'Material insuficiente';

  @override
  String get pawnMove => 'Movimento de peão';

  @override
  String get capture => 'Captura';

  @override
  String get close => 'Fechar';

  @override
  String get winning => 'Vencendo';

  @override
  String get losing => 'Perdendo';

  @override
  String get drawn => 'Empate';

  @override
  String get unknown => 'Posição desconhecida';

  @override
  String get database => 'Banco de Dados';

  @override
  String get whiteDrawBlack => 'Brancas / Empate / Pretas';

  @override
  String averageRatingX(String param) {
    return 'Classificação média: $param';
  }

  @override
  String get recentGames => 'Partidas recentes';

  @override
  String get topGames => 'Melhores partidas';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Duas milhões de partidas de jogadores com pontuação FIDE acima de $param1, desde $param2 a $param3';
  }

  @override
  String get dtzWithRounding => 'DTZ50\" com arredondamento, baseado no número de meias-jogadas até a próxima captura ou jogada de peão';

  @override
  String get noGameFound => 'Nenhuma partida encontrada';

  @override
  String get maxDepthReached => 'Profundidade máxima alcançada!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Talvez você queira incluir mais jogos a partir do menu de preferências';

  @override
  String get openings => 'Aberturas';

  @override
  String get openingExplorer => 'Explorador de aberturas';

  @override
  String get openingEndgameExplorer => 'Explorador de Aberturas/Finais';

  @override
  String xOpeningExplorer(String param) {
    return '$param Explorador de aberturas';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Jogue o primeiro lance do explorador de aberturas/finais';

  @override
  String get winPreventedBy50MoveRule => 'Vitória impedida pela regra dos 50 movimentos';

  @override
  String get lossSavedBy50MoveRule => 'Derrota impedida pela regra dos 50 movimentos';

  @override
  String get winOr50MovesByPriorMistake => 'Vitória ou 50 movimentos por erro anterior';

  @override
  String get lossOr50MovesByPriorMistake => 'Derrota ou 50 movimentos por erro anterior';

  @override
  String get unknownDueToRounding => 'Vitória/derrota garantida somente se a variante recomendada tiver sido seguida desde o último movimento de captura ou de peão, devido ao possível arredondamento.';

  @override
  String get allSet => 'Tudo pronto!';

  @override
  String get importPgn => 'Importar PGN';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteThisImportedGame => 'Excluir este jogo importado?';

  @override
  String get replayMode => 'Rever a partida';

  @override
  String get realtimeReplay => 'Tempo Real';

  @override
  String get byCPL => 'Por erros';

  @override
  String get openStudy => 'Abrir estudo';

  @override
  String get enable => 'Ativar';

  @override
  String get bestMoveArrow => 'Seta de melhor movimento';

  @override
  String get showVariationArrows => 'Mostrar setas das variantes';

  @override
  String get evaluationGauge => 'Escala de avaliação';

  @override
  String get multipleLines => 'Linhas de análise';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Memória';

  @override
  String get infiniteAnalysis => 'Análise infinita';

  @override
  String get removesTheDepthLimit => 'Remove o limite de profundidade, o que aquece seu computador';

  @override
  String get engineManager => 'Gerenciador de engine';

  @override
  String get blunder => 'Capivarada';

  @override
  String get mistake => 'Erro';

  @override
  String get inaccuracy => 'Imprecisão';

  @override
  String get moveTimes => 'Tempo por movimento';

  @override
  String get flipBoard => 'Girar o tabuleiro';

  @override
  String get threefoldRepetition => 'Tripla repetição';

  @override
  String get claimADraw => 'Reivindicar empate';

  @override
  String get offerDraw => 'Propor empate';

  @override
  String get draw => 'Empate';

  @override
  String get drawByMutualAgreement => 'Empate por acordo mútuo';

  @override
  String get fiftyMovesWithoutProgress => 'Cinquenta jogadas sem progresso';

  @override
  String get currentGames => 'Partidas atuais';

  @override
  String get viewInFullSize => 'Ver em tela cheia';

  @override
  String get logOut => 'Sair';

  @override
  String get signIn => 'Entrar';

  @override
  String get rememberMe => 'Lembrar de mim';

  @override
  String get youNeedAnAccountToDoThat => 'Você precisa de uma conta para fazer isso';

  @override
  String get signUp => 'Registrar';

  @override
  String get computersAreNotAllowedToPlay => 'A ajuda de software não é permitida. Por favor, não utilize programas de xadrez, bancos de dados ou o auxilio de outros jogadores durante a partida. Além disso, a criação de múltiplas contas é fortemente desaconselhada e sua prática excessiva acarretará em banimento.';

  @override
  String get games => 'Partidas';

  @override
  String get forum => 'Fórum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 publicou no tópico $param2';
  }

  @override
  String get latestForumPosts => 'Últimas publicações no fórum';

  @override
  String get players => 'Jogadores';

  @override
  String get friends => 'Amigos';

  @override
  String get discussions => 'Discussões';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get minutesPerSide => 'Minutos por jogador';

  @override
  String get variant => 'Variante';

  @override
  String get variants => 'Variantes';

  @override
  String get timeControl => 'Ritmo';

  @override
  String get realTime => 'Tempo real';

  @override
  String get correspondence => 'Correspondência';

  @override
  String get daysPerTurn => 'Dias por lance';

  @override
  String get oneDay => 'Um dia';

  @override
  String get time => 'Tempo';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Estatísticas de classificação';

  @override
  String get username => 'Nome de usuário';

  @override
  String get usernameOrEmail => 'Nome ou email do usuário';

  @override
  String get changeUsername => 'Alterar nome de usuário';

  @override
  String get changeUsernameNotSame => 'Pode-se apenas trocar as letras de minúscula para maiúscula e vice-versa. Por exemplo, \"fulanodetal\" para \"FulanoDeTal\".';

  @override
  String get changeUsernameDescription => 'Altere seu nome de usuário. Isso só pode ser feito uma vez e você poderá apenas trocar as letras de minúscula para maiúscula e vice-versa.';

  @override
  String get signupUsernameHint => 'Escolha um nome de usuário apropriado. Não será possível mudá-lo, e qualquer conta que tiver um nome ofensivo ou inapropriado será excluída!';

  @override
  String get signupEmailHint => 'Vamos usar apenas para redefinir a sua senha.';

  @override
  String get password => 'Senha';

  @override
  String get changePassword => 'Alterar senha';

  @override
  String get changeEmail => 'Alterar email';

  @override
  String get email => 'E-mail';

  @override
  String get passwordReset => 'Redefinição de senha';

  @override
  String get forgotPassword => 'Esqueceu sua senha?';

  @override
  String get error_weakPassword => 'A senha é extremamente comum e fácil de adivinhar.';

  @override
  String get error_namePassword => 'Não utilize seu nome de usuário como senha.';

  @override
  String get blankedPassword => 'Você usou a mesma senha em outro site, e esse site foi comprometido. Para garantir a segurança da sua conta no Lichess, você precisa criar uma nova senha. Agradecemos sua compreensão.';

  @override
  String get youAreLeavingLichess => 'Você está saindo do Lichess';

  @override
  String get neverTypeYourPassword => 'Nunca digite sua senha do Lichess em outro site!';

  @override
  String proceedToX(String param) {
    return 'Ir para $param';
  }

  @override
  String get passwordSuggestion => 'Não coloque uma senha sugerida por outra pessoa, porque ela poderá roubar sua conta.';

  @override
  String get emailSuggestion => 'Não coloque um endereço de email sugerido por outra pessoa, porque ela poderá roubar sua conta.';

  @override
  String get emailConfirmHelp => 'Ajuda com confirmação por e-mail';

  @override
  String get emailConfirmNotReceived => 'Não recebeu seu e-mail de confirmação após o registro?';

  @override
  String get whatSignupUsername => 'Qual nome de usuário você usou para se registrar?';

  @override
  String usernameNotFound(String param) {
    return 'Não foi possível encontrar nenhum usuário com este nome: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Você pode usar esse nome de usuário para criar uma nova conta';

  @override
  String emailSent(String param) {
    return 'Enviamos um e-mail para $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Pode levar algum tempo para chegar.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Aguarde 5 minutos e atualize sua caixa de entrada.';

  @override
  String get checkSpamFolder => 'Verifique também a sua caixa de spam. Caso esteja lá, marque como não é spam.';

  @override
  String get emailForSignupHelp => 'Se todo o resto falhar, envie-nos este e-mail:';

  @override
  String copyTextToEmail(String param) {
    return 'Copie e cole o texto acima e envie-o para $param';
  }

  @override
  String get waitForSignupHelp => 'Entraremos em contato em breve para ajudá-lo a completar seu registro.';

  @override
  String accountConfirmed(String param) {
    return 'O usuário $param foi confirmado com sucesso.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Você pode acessar agora como $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Você não precisa de um e-mail de confirmação.';

  @override
  String accountClosed(String param) {
    return 'A conta $param está encerrada.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'A conta $param foi registrada sem um e-mail.';
  }

  @override
  String get rank => 'Rank';

  @override
  String rankX(String param) {
    return 'Classificação: $param';
  }

  @override
  String get gamesPlayed => 'Partidas realizadas';

  @override
  String get cancel => 'Cancelar';

  @override
  String get whiteTimeOut => 'Tempo das brancas esgotado';

  @override
  String get blackTimeOut => 'Tempo das pretas esgotado';

  @override
  String get drawOfferSent => 'Proposta de empate enviada';

  @override
  String get drawOfferAccepted => 'Proposta de empate aceita';

  @override
  String get drawOfferCanceled => 'Proposta de empate cancelada';

  @override
  String get whiteOffersDraw => 'Brancas oferecem empate';

  @override
  String get blackOffersDraw => 'Pretas oferecem empate';

  @override
  String get whiteDeclinesDraw => 'Brancas recusam empate';

  @override
  String get blackDeclinesDraw => 'Pretas recusam empate';

  @override
  String get yourOpponentOffersADraw => 'Seu adversário oferece empate';

  @override
  String get accept => 'Aceitar';

  @override
  String get decline => 'Recusar';

  @override
  String get playingRightNow => 'Jogando agora';

  @override
  String get eventInProgress => 'Jogando agora';

  @override
  String get finished => 'Terminado';

  @override
  String get abortGame => 'Cancelar partida';

  @override
  String get gameAborted => 'Partida cancelada';

  @override
  String get standard => 'Padrão';

  @override
  String get customPosition => 'Posição personalizada';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String get mode => 'Modo';

  @override
  String get casual => 'Amistosa';

  @override
  String get rated => 'Ranqueada';

  @override
  String get casualTournament => 'Amistoso';

  @override
  String get ratedTournament => 'Valendo pontos';

  @override
  String get thisGameIsRated => 'Esta partida vale pontos';

  @override
  String get rematch => 'Revanche';

  @override
  String get rematchOfferSent => 'Oferta de revanche enviada';

  @override
  String get rematchOfferAccepted => 'Oferta de revanche aceita';

  @override
  String get rematchOfferCanceled => 'Oferta de revanche cancelada';

  @override
  String get rematchOfferDeclined => 'Oferta de revanche recusada';

  @override
  String get cancelRematchOffer => 'Cancelar oferta de revanche';

  @override
  String get viewRematch => 'Ver revanche';

  @override
  String get confirmMove => 'Confirmar lance';

  @override
  String get play => 'Jogar';

  @override
  String get inbox => 'Mensagens';

  @override
  String get chatRoom => 'Sala de chat';

  @override
  String get loginToChat => 'Faça login para conversar';

  @override
  String get youHaveBeenTimedOut => 'Sua sessão expirou.';

  @override
  String get spectatorRoom => 'Sala do espectador';

  @override
  String get composeMessage => 'Escrever mensagem';

  @override
  String get subject => 'Assunto';

  @override
  String get send => 'Enviar';

  @override
  String get incrementInSeconds => 'Acréscimo em segundos';

  @override
  String get freeOnlineChess => 'Xadrez Online Gratuito';

  @override
  String get exportGames => 'Exportar partidas';

  @override
  String get ratingRange => 'Rating entre';

  @override
  String get thisAccountViolatedTos => 'Esta conta violou os Termos de Serviço do Lichess';

  @override
  String get openingExplorerAndTablebase => 'Explorador de abertura & tabela de finais';

  @override
  String get takeback => 'Voltar jogada';

  @override
  String get proposeATakeback => 'Propor voltar jogada';

  @override
  String get takebackPropositionSent => 'Proposta de voltar jogada enviada';

  @override
  String get takebackPropositionDeclined => 'Proposta de voltar jogada recusada';

  @override
  String get takebackPropositionAccepted => 'Proposta de voltar jogada aceita';

  @override
  String get takebackPropositionCanceled => 'Proposta de voltar jogada cancelada';

  @override
  String get yourOpponentProposesATakeback => 'Seu oponente propõe voltar jogada';

  @override
  String get bookmarkThisGame => 'Adicionar esta partida às favoritas';

  @override
  String get tournament => 'Torneio';

  @override
  String get tournaments => 'Torneios';

  @override
  String get tournamentPoints => 'Pontos de torneios';

  @override
  String get viewTournament => 'Ver torneio';

  @override
  String get backToTournament => 'Voltar ao torneio';

  @override
  String get noDrawBeforeSwissLimit => 'Não é possível empatar antes de 30 lances em um torneio suíço.';

  @override
  String get thematic => 'Temático';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Seu rating $param é provisório';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Seu $param1 rating ($param2) é muito alta';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Seu melhor rating $param1 da semana ($param2) é muito alto';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Sua $param1 pontuação ($param2) é muito baixa';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Pontuação ≥ $param1 em $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Pontuação ≤ $param1 em $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Precisa estar na equipe $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Você não está na equipe $param';
  }

  @override
  String get backToGame => 'Retorne à partida';

  @override
  String get siteDescription => 'Xadrez online gratuito. Jogue xadrez agora numa interface simples. Sem registro, sem anúncios, sem plugins. Jogue xadrez contra computador, amigos ou adversários aleatórios.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 juntou-se à equipe $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 criou a equipe $param2';
  }

  @override
  String get startedStreaming => 'começou uma transmissão ao vivo';

  @override
  String xStartedStreaming(String param) {
    return '$param começou a transmitir';
  }

  @override
  String get averageElo => 'Média de rating';

  @override
  String get location => 'Localização';

  @override
  String get filterGames => 'Filtrar partidas';

  @override
  String get reset => 'Reiniciar';

  @override
  String get apply => 'Aplicar';

  @override
  String get save => 'Salvar';

  @override
  String get leaderboard => 'Classificação';

  @override
  String get screenshotCurrentPosition => 'Captura de tela da posição atual';

  @override
  String get gameAsGIF => 'Salvar a partida como GIF';

  @override
  String get pasteTheFenStringHere => 'Cole a notação FEN aqui';

  @override
  String get pasteThePgnStringHere => 'Cole a notação PGN aqui';

  @override
  String get orUploadPgnFile => 'Ou carregue um arquivo PGN';

  @override
  String get fromPosition => 'A partir da posição';

  @override
  String get continueFromHere => 'Continuar daqui';

  @override
  String get toStudy => 'Estudo';

  @override
  String get importGame => 'Importar partida';

  @override
  String get importGameExplanation => 'Após colar uma partida em PGN você poderá revisá-la interativamente, consultar uma análise de computador, utilizar o chat e compartilhar um link.';

  @override
  String get importGameCaveat => 'As variantes serão apagadas. Para salvá-las, importe o PGN em um estudo.';

  @override
  String get importGameDataPrivacyWarning => 'Este PGN pode ser acessado publicamente. Use um estudo para importar um jogo privado.';

  @override
  String get thisIsAChessCaptcha => 'Este é um CAPTCHA enxadrístico.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Clique no tabuleiro para fazer seu lance, provando que é humano.';

  @override
  String get captcha_fail => 'Por favor, resolva o captcha enxadrístico.';

  @override
  String get notACheckmate => 'Não é xeque-mate';

  @override
  String get whiteCheckmatesInOneMove => 'As brancas dão mate em um lance';

  @override
  String get blackCheckmatesInOneMove => 'As pretas dão mate em um lance';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get reconnecting => 'Reconectando';

  @override
  String get noNetwork => 'Sem conexão';

  @override
  String get favoriteOpponents => 'Adversários favoritos';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Seguindo';

  @override
  String get unfollow => 'Parar de seguir';

  @override
  String followX(String param) {
    return 'Seguir $param';
  }

  @override
  String unfollowX(String param) {
    return 'Deixar de seguir $param';
  }

  @override
  String get block => 'Bloquear';

  @override
  String get blocked => 'Bloqueado';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get followsYou => 'Segue você';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 começou a seguir $param2';
  }

  @override
  String get more => 'Mais';

  @override
  String get memberSince => 'Membro desde';

  @override
  String lastSeenActive(String param) {
    return 'Ativo $param';
  }

  @override
  String get player => 'Jogador';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Gráfico';

  @override
  String get required => 'Obrigatório.';

  @override
  String get openTournaments => 'Torneios abertos';

  @override
  String get duration => 'Duração';

  @override
  String get winner => 'Vencedor';

  @override
  String get standing => 'Colocação';

  @override
  String get createANewTournament => 'Criar novo torneio';

  @override
  String get tournamentCalendar => 'Calendário do torneio';

  @override
  String get conditionOfEntry => 'Condições de participação:';

  @override
  String get advancedSettings => 'Configurações avançadas';

  @override
  String get safeTournamentName => 'Escolha um nome seguro para o torneio.';

  @override
  String get inappropriateNameWarning => 'Até mesmo a menor indecência poderia ensejar o encerramento de sua conta.';

  @override
  String get emptyTournamentName => 'Deixe em branco para dar ao torneio o nome de um grande mestre aleatório.';

  @override
  String get makePrivateTournament => 'Faça o torneio privado e restrinja o acesso com uma senha';

  @override
  String get join => 'Entrar';

  @override
  String get withdraw => 'Sair';

  @override
  String get points => 'Pontos';

  @override
  String get wins => 'Vitórias';

  @override
  String get losses => 'Derrotas';

  @override
  String get createdBy => 'Criado por';

  @override
  String get tournamentIsStarting => 'O torneio está começando';

  @override
  String get tournamentPairingsAreNowClosed => 'Os pareamentos do torneio estão fechados agora.';

  @override
  String standByX(String param) {
    return '$param, aguarde: o pareamento está em andamento, prepare-se!';
  }

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Continuar';

  @override
  String get youArePlaying => 'Você está participando!';

  @override
  String get winRate => 'Taxa de vitórias';

  @override
  String get berserkRate => 'Taxa Berserk';

  @override
  String get performance => 'Desempenho';

  @override
  String get tournamentComplete => 'Torneio completo';

  @override
  String get movesPlayed => 'Movimentos realizados';

  @override
  String get whiteWins => 'Brancas venceram';

  @override
  String get blackWins => 'Pretas venceram';

  @override
  String get drawRate => 'Taxa de empates';

  @override
  String get draws => 'Empates';

  @override
  String nextXTournament(String param) {
    return 'Próximo torneio $param:';
  }

  @override
  String get averageOpponent => 'Pontuação média adversários';

  @override
  String get boardEditor => 'Editor de tabuleiro';

  @override
  String get setTheBoard => 'Defina a posição';

  @override
  String get popularOpenings => 'Aberturas populares';

  @override
  String get endgamePositions => 'Posições de final';

  @override
  String chess960StartPosition(String param) {
    return 'Posição inicial do Xadrez960: $param';
  }

  @override
  String get startPosition => 'Posição inicial';

  @override
  String get clearBoard => 'Limpar tabuleiro';

  @override
  String get loadPosition => 'Carregar posição';

  @override
  String get isPrivate => 'Privado';

  @override
  String reportXToModerators(String param) {
    return 'Reportar $param aos moderadores';
  }

  @override
  String profileCompletion(String param) {
    return 'Conclusão do perfil: $param';
  }

  @override
  String xRating(String param) {
    return 'Rating $param';
  }

  @override
  String get ifNoneLeaveEmpty => 'Se nenhuma, deixe vazio';

  @override
  String get profile => 'Perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get realName => 'Nome real';

  @override
  String get setFlair => 'Escolha seu emote';

  @override
  String get flair => 'Estilo';

  @override
  String get youCanHideFlair => 'Você pode esconder todos os emotes de usuário no site.';

  @override
  String get biography => 'Biografia';

  @override
  String get countryRegion => 'País ou região';

  @override
  String get thankYou => 'Obrigado!';

  @override
  String get socialMediaLinks => 'Links de mídia social';

  @override
  String get oneUrlPerLine => 'Uma URL por linha.';

  @override
  String get inlineNotation => 'Notação em linha';

  @override
  String get makeAStudy => 'Para salvar e compartilhar uma análise, crie um estudo.';

  @override
  String get clearSavedMoves => 'Limpar lances';

  @override
  String get previouslyOnLichessTV => 'Anteriormente em Lichess TV';

  @override
  String get onlinePlayers => 'Jogadores online';

  @override
  String get activePlayers => 'Jogadores ativos';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Cuidado, o jogo vale rating, mas não há controle de tempo!';

  @override
  String get success => 'Sucesso';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Passar automaticamente ao jogo seguinte após o lance';

  @override
  String get autoSwitch => 'Alternar automaticamente';

  @override
  String get puzzles => 'Quebra-cabeças';

  @override
  String get onlineBots => 'Bots online';

  @override
  String get name => 'Nome';

  @override
  String get description => 'Descrição';

  @override
  String get descPrivate => 'Descrição privada';

  @override
  String get descPrivateHelp => 'Texto que apenas os membros da equipe verão. Se definido, substitui a descrição pública para os membros da equipe.';

  @override
  String get no => 'Não';

  @override
  String get yes => 'Sim';

  @override
  String get help => 'Ajuda:';

  @override
  String get createANewTopic => 'Criar novo tópico';

  @override
  String get topics => 'Tópicos';

  @override
  String get posts => 'Publicações';

  @override
  String get lastPost => 'Última postagem';

  @override
  String get views => 'Visualizações';

  @override
  String get replies => 'Respostas';

  @override
  String get replyToThisTopic => 'Responder a este tópico';

  @override
  String get reply => 'Responder';

  @override
  String get message => 'Mensagem';

  @override
  String get createTheTopic => 'Criar tópico';

  @override
  String get reportAUser => 'Reportar um usuário';

  @override
  String get user => 'Usuário';

  @override
  String get reason => 'Motivo';

  @override
  String get whatIsIheMatter => 'Qual é o motivo?';

  @override
  String get cheat => 'Trapaça';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Outro';

  @override
  String get reportDescriptionHelp => 'Cole o link do(s) jogo(s) e explique o que há de errado com o comportamento do usuário. Não diga apenas \"ele trapaceia\", informe-nos como chegou a esta conclusão. Sua denúncia será processada mais rapidamente se escrita em inglês.';

  @override
  String get error_provideOneCheatedGameLink => 'Por favor forneça ao menos um link para um jogo com suspeita de trapaça.';

  @override
  String by(String param) {
    return 'por $param';
  }

  @override
  String importedByX(String param) {
    return 'Importado por $param';
  }

  @override
  String get thisTopicIsNowClosed => 'O tópico foi fechado.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notas';

  @override
  String get typePrivateNotesHere => 'Digite notas pessoais aqui';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Escreva uma nota pessoal sobre este usuário';

  @override
  String get noNoteYet => 'Nenhuma nota';

  @override
  String get invalidUsernameOrPassword => 'Nome de usuário ou senha incorretos';

  @override
  String get incorrectPassword => 'Senha incorreta';

  @override
  String get invalidAuthenticationCode => 'Código de verificação inválido';

  @override
  String get emailMeALink => 'Me envie um link';

  @override
  String get currentPassword => 'Senha atual';

  @override
  String get newPassword => 'Nova senha';

  @override
  String get newPasswordAgain => 'Nova senha (novamente)';

  @override
  String get newPasswordsDontMatch => 'As novas senhas não correspondem';

  @override
  String get newPasswordStrength => 'Senha forte';

  @override
  String get clockInitialTime => 'Tempo de relógio';

  @override
  String get clockIncrement => 'Incremento do relógio';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get letOtherPlayersFollowYou => 'Permitir que outros jogadores sigam você';

  @override
  String get letOtherPlayersChallengeYou => 'Permitir que outros jogadores desafiem você';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Deixe outros jogadores convidá-lo para um estudo';

  @override
  String get sound => 'Som';

  @override
  String get none => 'Nenhum';

  @override
  String get fast => 'Rápido';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Lento';

  @override
  String get insideTheBoard => 'Dentro do tabuleiro';

  @override
  String get outsideTheBoard => 'Fora do tabuleiro';

  @override
  String get allSquaresOfTheBoard => 'Todas as casas do tabuleiro';

  @override
  String get onSlowGames => 'Em partidas lentas';

  @override
  String get always => 'Sempre';

  @override
  String get never => 'Nunca';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 compete em $param2';
  }

  @override
  String get victory => 'Vitória';

  @override
  String get defeat => 'Derrota';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 em $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 em $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 em $param3';
  }

  @override
  String get timeline => 'Linha do tempo';

  @override
  String get starting => 'Iniciando:';

  @override
  String get allInformationIsPublicAndOptional => 'Todas as informações são públicas e opcionais.';

  @override
  String get biographyDescription => 'Fale sobre você, seus interesses, o que você gosta no xadrez, suas aberturas favoritas, jogadores...';

  @override
  String get listBlockedPlayers => 'Sua lista de jogadores bloqueados';

  @override
  String get human => 'Humano';

  @override
  String get computer => 'Computador';

  @override
  String get side => 'Cor';

  @override
  String get clock => 'Relógio';

  @override
  String get opponent => 'Adversário';

  @override
  String get learnMenu => 'Aprender';

  @override
  String get studyMenu => 'Estudar';

  @override
  String get practice => 'Praticar';

  @override
  String get community => 'Comunidade';

  @override
  String get tools => 'Ferramentas';

  @override
  String get increment => 'Incremento';

  @override
  String get error_unknown => 'Valor inválido';

  @override
  String get error_required => 'Este campo deve ser preenchido';

  @override
  String get error_email => 'Este endereço de e-mail é inválido';

  @override
  String get error_email_acceptable => 'Este endereço de e-mail não é válido. Verifique e tente novamente.';

  @override
  String get error_email_unique => 'Endereço de e-mail é inválido ou já está sendo utilizado';

  @override
  String get error_email_different => 'Este já é o seu endereço de e-mail';

  @override
  String error_minLength(String param) {
    return 'O mínimo de caracteres é $param';
  }

  @override
  String error_maxLength(String param) {
    return 'O máximo de caracteres é $param';
  }

  @override
  String error_min(String param) {
    return 'Deve ser maior ou igual a $param';
  }

  @override
  String error_max(String param) {
    return 'Deve ser menor ou igual a $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Se o rating for ± $param';
  }

  @override
  String get ifRegistered => 'Se registrado';

  @override
  String get onlyExistingConversations => 'Apenas conversas iniciadas';

  @override
  String get onlyFriends => 'Apenas amigos';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Roque';

  @override
  String get whiteCastlingKingside => 'O-O das brancas';

  @override
  String get blackCastlingKingside => 'O-O das pretas';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tempo jogando: $param';
  }

  @override
  String get watchGames => 'Assistir partidas';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tempo na TV: $param';
  }

  @override
  String get watch => 'Assistir';

  @override
  String get videoLibrary => 'Vídeos';

  @override
  String get streamersMenu => 'Streamers';

  @override
  String get mobileApp => 'Aplicativo Móvel';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'Sobre';

  @override
  String aboutX(String param) {
    return 'Sobre o $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 é um servidor de xadrez gratuito ($param2), livre, sem anúncios e código aberto.';
  }

  @override
  String get really => 'realmente';

  @override
  String get contribute => 'Contribuir';

  @override
  String get termsOfService => 'Termos de serviço';

  @override
  String get sourceCode => 'Código-fonte';

  @override
  String get simultaneousExhibitions => 'Exibição simultânea';

  @override
  String get host => 'Simultanista';

  @override
  String hostColorX(String param) {
    return 'Cor do simultanista: $param';
  }

  @override
  String get yourPendingSimuls => 'Suas simultâneas pendentes';

  @override
  String get createdSimuls => 'Simultâneas criadas recentemente';

  @override
  String get hostANewSimul => 'Iniciar nova simultânea';

  @override
  String get signUpToHostOrJoinASimul => 'Entre em uma ou crie uma conta para hospedar';

  @override
  String get noSimulFound => 'Simultânea não encontrada';

  @override
  String get noSimulExplanation => 'Esta exibição simultânea não existe.';

  @override
  String get returnToSimulHomepage => 'Retornar à página inicial da simultânea';

  @override
  String get aboutSimul => 'A simultânea envolve um único jogador contra vários oponentes ao mesmo tempo.';

  @override
  String get aboutSimulImage => 'Contra 50 oponentes, Fischer ganhou 47 jogos, empatou 2 e perdeu 1.';

  @override
  String get aboutSimulRealLife => 'O conceito provém de eventos reais, nos quais o simultanista se move de mesa em mesa, executando um movimento por vez.';

  @override
  String get aboutSimulRules => 'Quando a simultânea começa, cada jogador começa sua partida contra o simultanista, o qual sempre tem as brancas. A simultânea termina quando todas as partidas são finalizadas.';

  @override
  String get aboutSimulSettings => 'As simultâneas sempre são partidas amigáveis. Revanches, voltar jogadas e tempo adicional estão desativados.';

  @override
  String get create => 'Criar';

  @override
  String get whenCreateSimul => 'Quando cria uma simultânea, você joga com vários adversários ao mesmo tempo.';

  @override
  String get simulVariantsHint => 'Se você selecionar diversas variantes, cada jogador poderá escolher qual delas jogar.';

  @override
  String get simulClockHint => 'Configuração de acréscimos no relógio. Quanto mais jogadores admitir, mais tempo pode necessitar.';

  @override
  String get simulAddExtraTime => 'Você pode acrescentar tempo adicional a seu relógio, para ajudá-lo a lidar com a simultânea.';

  @override
  String get simulHostExtraTime => 'Tempo adicional do simultanista';

  @override
  String get simulAddExtraTimePerPlayer => 'Adicionar tempo inicial ao seu relógio por cada jogador adversário que entrar na simultânea.';

  @override
  String get simulHostExtraTimePerPlayer => 'Tempo adicional do simultanista por jogador';

  @override
  String get lichessTournaments => 'Torneios do Lichess';

  @override
  String get tournamentFAQ => 'Perguntas Frequentes sobre torneios no estilo Arena';

  @override
  String get timeBeforeTournamentStarts => 'Contagem regressiva para início do torneio';

  @override
  String get averageCentipawnLoss => 'Perda média em centipeões';

  @override
  String get accuracy => 'Precisão';

  @override
  String get keyboardShortcuts => 'Atalhos de teclado';

  @override
  String get keyMoveBackwardOrForward => 'retroceder/avançar lance';

  @override
  String get keyGoToStartOrEnd => 'ir para início/fim';

  @override
  String get keyCycleSelectedVariation => 'Alternar entre as variantes';

  @override
  String get keyShowOrHideComments => 'mostrar/ocultar comentários';

  @override
  String get keyEnterOrExitVariation => 'entrar/sair da variante';

  @override
  String get keyRequestComputerAnalysis => 'Solicite análise do computador, aprenda com seus erros';

  @override
  String get keyNextLearnFromYourMistakes => 'Próximo (Aprenda com seus erros)';

  @override
  String get keyNextBlunder => 'Próximo erro grave';

  @override
  String get keyNextMistake => 'Próximo erro';

  @override
  String get keyNextInaccuracy => 'Próxima imprecisão';

  @override
  String get keyPreviousBranch => 'Branch anterior';

  @override
  String get keyNextBranch => 'Próximo branch';

  @override
  String get toggleVariationArrows => 'Ativar/desativar setas';

  @override
  String get cyclePreviousOrNextVariation => 'Variante seguinte/anterior';

  @override
  String get toggleGlyphAnnotations => 'Ativar/desativar anotações';

  @override
  String get togglePositionAnnotations => 'Ativar/desativar anotações de posição';

  @override
  String get variationArrowsInfo => 'Setas de variação permitem navegar sem usar a lista de movimentos.';

  @override
  String get playSelectedMove => 'jogar movimento selecionado';

  @override
  String get newTournament => 'Novo torneio';

  @override
  String get tournamentHomeTitle => 'Torneios de xadrez com diversos controles de tempo e variantes';

  @override
  String get tournamentHomeDescription => 'Jogue xadrez em ritmo acelerado! Entre em um torneio oficial agendado ou crie seu próprio. Bullet, Blitz, Clássico, Chess960, King of the Hill, Três Xeques e outras modalidades disponíveis para uma ilimitada diversão enxadrística.';

  @override
  String get tournamentNotFound => 'Torneio não encontrado';

  @override
  String get tournamentDoesNotExist => 'Este torneio não existe.';

  @override
  String get tournamentMayHaveBeenCanceled => 'O evento pode ter sido cancelado, se todos os jogadores saíram antes de seu início.';

  @override
  String get returnToTournamentsHomepage => 'Volte à página inicial de torneios';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Distribuição mensal de rating em $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Seu rating em $param1 é $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Você é melhor que $param1 dos jogadores de $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 é melhor que $param2 dos $param3 jogadores.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Melhor que $param1 dos jogadores de $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Você não tem rating definido em $param.';
  }

  @override
  String get yourRating => 'Seu rating';

  @override
  String get cumulative => 'Cumulativo';

  @override
  String get glicko2Rating => 'Rating Glicko-2';

  @override
  String get checkYourEmail => 'Verifique seu e-mail';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Enviamos um e-mail. Clique no link do e-mail para ativar sua conta.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Se você não vir o e-mail, verifique outros locais onde possa estar, como lixeira, spam ou outras pastas.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Enviamos um e-mail para $param. Clique no link do e-mail para redefinir sua senha.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Ao registrar, você concorda em se comprometer com nossa $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Leia sobre a nossa $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Atraso na rede';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tempo para processar um movimento no servidor do Lichess';

  @override
  String get downloadAnnotated => 'Baixar anotação';

  @override
  String get downloadRaw => 'Baixar texto';

  @override
  String get downloadImported => 'Baixar partida importada';

  @override
  String get crosstable => 'Tabela';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Você também pode rolar sobre o tabuleiro para percorrer as jogadas.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Passe o mouse pelas variações do computador para visualizá-las.';

  @override
  String get analysisShapesHowTo => 'Pressione Shift+Clique ou clique com o botão direito do mouse para desenhar círculos e setas no tabuleiro.';

  @override
  String get letOtherPlayersMessageYou => 'Permitir que outros jogadores lhe enviem mensagem';

  @override
  String get receiveForumNotifications => 'Receba notificações quando você for mencionado no fórum';

  @override
  String get shareYourInsightsData => 'Compartilhe seus dados da análise';

  @override
  String get withNobody => 'Com ninguém';

  @override
  String get withFriends => 'Com amigos';

  @override
  String get withEverybody => 'Com todos';

  @override
  String get kidMode => 'Modo infantil';

  @override
  String get kidModeIsEnabled => 'O modo infantil está ativado.';

  @override
  String get kidModeExplanation => 'Isto diz respeito à segurança. No modo infantil, todas as comunicações do site são desabilitadas. Habilite isso para seus filhos e alunos, para protegê-los de outros usuários da Internet.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'No modo infantil, a logo do lichess tem um ícone $param, para que você saiba que suas crianças estão seguras.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Sua conta é gerenciada. Para desativar o modo infantil, peça ao seu professor.';

  @override
  String get enableKidMode => 'Habilitar o modo infantil';

  @override
  String get disableKidMode => 'Desabilitar o modo infantil';

  @override
  String get security => 'Segurança';

  @override
  String get sessions => 'Sessões';

  @override
  String get revokeAllSessions => 'revogar todas as sessões';

  @override
  String get playChessEverywhere => 'Jogue xadrez em qualquer lugar';

  @override
  String get asFreeAsLichess => 'Tão gratuito quanto o Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Desenvolvido pelo amor ao xadrez, não pelo dinheiro';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Todos têm todos os recursos de graça';

  @override
  String get zeroAdvertisement => 'Zero anúncios';

  @override
  String get fullFeatured => 'Cheio de recursos';

  @override
  String get phoneAndTablet => 'Celular e tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, clássico';

  @override
  String get correspondenceChess => 'Xadrez por correspondência';

  @override
  String get onlineAndOfflinePlay => 'Jogue online e offline';

  @override
  String get viewTheSolution => 'Ver solução';

  @override
  String get followAndChallengeFriends => 'Siga e desafie amigos';

  @override
  String get gameAnalysis => 'Análise da partida';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 criou $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 entrou em $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 gostou de $param2';
  }

  @override
  String get quickPairing => 'Pareamento rápido';

  @override
  String get lobby => 'Salão';

  @override
  String get anonymous => 'Anônimo';

  @override
  String yourScore(String param) {
    return 'Sua pontuação:$param';
  }

  @override
  String get language => 'Idioma';

  @override
  String get background => 'Cor tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get transparent => 'Transparente';

  @override
  String get deviceTheme => 'Tema do dispositivo';

  @override
  String get backgroundImageUrl => 'URL da imagem de fundo:';

  @override
  String get board => 'Tabuleiro';

  @override
  String get size => 'Tamanho';

  @override
  String get opacity => 'Opacidade';

  @override
  String get brightness => 'Brilho';

  @override
  String get hue => 'Tom';

  @override
  String get boardReset => 'Restaurar as cores padrão';

  @override
  String get pieceSet => 'Estilo das peças';

  @override
  String get embedInYourWebsite => 'Incorporar no seu site';

  @override
  String get usernameAlreadyUsed => 'Este nome de usuário já está registado, por favor, escolha outro.';

  @override
  String get usernamePrefixInvalid => 'O nome de usuário deve começar com uma letra.';

  @override
  String get usernameSuffixInvalid => 'O nome de usuário deve terminar com uma letra ou um número.';

  @override
  String get usernameCharsInvalid => 'Nomes de usuário só podem conter letras, números, sublinhados e hifens.';

  @override
  String get usernameUnacceptable => 'Este nome de usuário não é aceitável.';

  @override
  String get playChessInStyle => 'Jogue xadrez com estilo';

  @override
  String get chessBasics => 'Básicos do xadrez';

  @override
  String get coaches => 'Treinadores';

  @override
  String get invalidPgn => 'PGN inválido';

  @override
  String get invalidFen => 'FEN inválido';

  @override
  String get custom => 'Personalizado';

  @override
  String get notifications => 'Notificações';

  @override
  String notificationsX(String param1) {
    return 'Notificações: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Pratique com o computador';

  @override
  String anotherWasX(String param) {
    return 'Um outro lance seria $param';
  }

  @override
  String bestWasX(String param) {
    return 'Melhor seria $param';
  }

  @override
  String get youBrowsedAway => 'Você navegou para longe';

  @override
  String get resumePractice => 'Retornar à prática';

  @override
  String get drawByFiftyMoves => 'O jogo empatou pela regra dos cinquenta movimentos.';

  @override
  String get theGameIsADraw => 'A partida terminou em empate.';

  @override
  String get computerThinking => 'Computador pensando ...';

  @override
  String get seeBestMove => 'Veja o melhor lance';

  @override
  String get hideBestMove => 'Esconder o melhor lance';

  @override
  String get getAHint => 'Obter uma dica';

  @override
  String get evaluatingYourMove => 'Avaliando o seu movimento ...';

  @override
  String get whiteWinsGame => 'Brancas vencem';

  @override
  String get blackWinsGame => 'Pretas vencem';

  @override
  String get learnFromYourMistakes => 'Aprenda com seus erros';

  @override
  String get learnFromThisMistake => 'Aprenda com este erro';

  @override
  String get skipThisMove => 'Pular esse lance';

  @override
  String get next => 'Próximo';

  @override
  String xWasPlayed(String param) {
    return '$param foi jogado';
  }

  @override
  String get findBetterMoveForWhite => 'Encontrar o melhor lance para as Brancas';

  @override
  String get findBetterMoveForBlack => 'Encontre o melhor lance para as Pretas';

  @override
  String get resumeLearning => 'Continuar a aprendizagem';

  @override
  String get youCanDoBetter => 'Você pode fazer melhor';

  @override
  String get tryAnotherMoveForWhite => 'Tente um outro lance para as Brancas';

  @override
  String get tryAnotherMoveForBlack => 'Tente um outro lance para as Pretas';

  @override
  String get solution => 'Solução';

  @override
  String get waitingForAnalysis => 'Aguardando análise';

  @override
  String get noMistakesFoundForWhite => 'Nenhum erro encontrado para as Brancas';

  @override
  String get noMistakesFoundForBlack => 'Nenhum erro encontrado para as Pretas';

  @override
  String get doneReviewingWhiteMistakes => 'Erros das brancas já revistos';

  @override
  String get doneReviewingBlackMistakes => 'Erros das pretas já revistos';

  @override
  String get doItAgain => 'Faça novamente';

  @override
  String get reviewWhiteMistakes => 'Rever erros das Brancas';

  @override
  String get reviewBlackMistakes => 'Rever erros das Pretas';

  @override
  String get advantage => 'Vantagem';

  @override
  String get opening => 'Abertura';

  @override
  String get middlegame => 'Meio-jogo';

  @override
  String get endgame => 'Finais';

  @override
  String get conditionalPremoves => 'Pré-lances condicionais';

  @override
  String get addCurrentVariation => 'Adicionar a variação atual';

  @override
  String get playVariationToCreateConditionalPremoves => 'Jogar uma variação para criar pré-lances condicionais';

  @override
  String get noConditionalPremoves => 'Sem pré-lances condicionais';

  @override
  String playX(String param) {
    return 'Jogar $param';
  }

  @override
  String get showUnreadLichessMessage => 'Você recebeu uma mensagem privada do Lichess.';

  @override
  String get clickHereToReadIt => 'Clique aqui para ler';

  @override
  String get sorry => 'Desculpa :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Tivemos de bloqueá-lo por um tempo.';

  @override
  String get why => 'Por quê?';

  @override
  String get pleasantChessExperience => 'Buscamos oferecer uma experiência agradável de xadrez para todos.';

  @override
  String get goodPractice => 'Para isso, precisamos assegurar que nossos jogadores sigam boas práticas.';

  @override
  String get potentialProblem => 'Quando um problema em potencial é detectado, nós mostramos esta mensagem.';

  @override
  String get howToAvoidThis => 'Como evitar isso?';

  @override
  String get playEveryGame => 'Jogue todos os jogos que inicia.';

  @override
  String get tryToWin => 'Tente vencer (ou pelo menos empatar) todos os jogos que jogar.';

  @override
  String get resignLostGames => 'Conceda partidas perdidas (não deixe o relógio ir até ao fim).';

  @override
  String get temporaryInconvenience => 'Pedimos desculpa pelo incômodo temporário,';

  @override
  String get wishYouGreatGames => 'e desejamos-lhe grandes jogos em lichess.org.';

  @override
  String get thankYouForReading => 'Obrigado pela leitura!';

  @override
  String get lifetimeScore => 'Pontuação de todo o período';

  @override
  String get currentMatchScore => 'Pontuação da partida atual';

  @override
  String get agreementAssistance => 'Eu concordo que em momento algum receberei assistência durante os meus jogos (seja de um computador, livro, banco de dados ou outra pessoa).';

  @override
  String get agreementNice => 'Eu concordo que serei sempre cortês com outros jogadores.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Eu concordo que não criarei múltiplas contas (exceto pelas razões indicadas em $param).';
  }

  @override
  String get agreementPolicy => 'Eu concordo que seguirei todas as normas do Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Procurar ou iniciar nova conversa';

  @override
  String get edit => 'Editar';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rápida';

  @override
  String get classical => 'Clássico';

  @override
  String get ultraBulletDesc => 'Jogos insanamente rápidos: menos de 30 segundos';

  @override
  String get bulletDesc => 'Jogos muito rápidos: menos de 3 minutos';

  @override
  String get blitzDesc => 'Jogos rápidos: 3 a 8 minutos';

  @override
  String get rapidDesc => 'Jogos rápidos: 8 a 25 minutos';

  @override
  String get classicalDesc => 'Jogos clássicos: 25 minutos ou mais';

  @override
  String get correspondenceDesc => 'Jogos por correspondência: um ou vários dias por lance';

  @override
  String get puzzleDesc => 'Treinador de táticas de xadrez';

  @override
  String get important => 'Importante';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'A sua pergunta pode já ter sido respondida $param1';
  }

  @override
  String get inTheFAQ => 'no F.A.Q.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Para denunciar um usuário por trapaças ou mau comportamento, $param1';
  }

  @override
  String get useTheReportForm => 'use o formulário de denúncia';

  @override
  String toRequestSupport(String param1) {
    return 'Para solicitar ajuda, $param1';
  }

  @override
  String get tryTheContactPage => 'tente a página de contato';

  @override
  String makeSureToRead(String param1) {
    return 'Certifique-se de ler $param1';
  }

  @override
  String get theForumEtiquette => 'as regras do fórum';

  @override
  String get thisTopicIsArchived => 'Este tópico foi arquivado e não pode mais ser respondido.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Junte-se a $param1 para publicar neste fórum';
  }

  @override
  String teamNamedX(String param1) {
    return 'Equipe $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Você não pode publicar nos fóruns ainda. Jogue algumas partidas!';

  @override
  String get subscribe => 'Seguir publicações';

  @override
  String get unsubscribe => 'Deixar de seguir publicações';

  @override
  String mentionedYouInX(String param1) {
    return 'mencionou você em \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 mencionou você em \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'convidou você para \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 convidou você para \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Você agora faz parte da equipe.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Você ingressou em \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Alguém que você denunciou foi banido';

  @override
  String get congratsYouWon => 'Parabéns, você venceu!';

  @override
  String gameVsX(String param1) {
    return 'Jogo vs $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Você perdeu rating para alguém que violou os termos de serviço do Lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Reembolso: $param1 $param2 pontos de rating.';
  }

  @override
  String get timeAlmostUp => 'O tempo está quase acabando!';

  @override
  String get clickToRevealEmailAddress => '[Clique para revelar o endereço de e-mail]';

  @override
  String get download => 'Baixar';

  @override
  String get coachManager => 'Configurações para professores';

  @override
  String get streamerManager => 'Configurações para streamers';

  @override
  String get cancelTournament => 'Cancelar o torneio';

  @override
  String get tournDescription => 'Descrição do torneio';

  @override
  String get tournDescriptionHelp => 'Algo especial que você queira dizer aos participantes? Tente ser breve. Links em Markdown disponíveis: [name](https://url)';

  @override
  String get ratedFormHelp => 'Os jogos valem classificação\ne afetam o rating dos jogadores';

  @override
  String get onlyMembersOfTeam => 'Apenas membros da equipe';

  @override
  String get noRestriction => 'Sem restrição';

  @override
  String get minimumRatedGames => 'Mínimo de partidas ranqueadas';

  @override
  String get minimumRating => 'Rating mínimo';

  @override
  String get maximumWeeklyRating => 'Rating máxima da semana';

  @override
  String positionInputHelp(String param) {
    return 'Cole um FEN válido para iniciar as partidas a partir de uma posição específica.\nSó funciona com jogos padrão, e não com variantes.\nUse o $param para gerar uma posição FEN, e depois cole-a aqui.\nDeixe em branco para começar as partidas na posição inicial padrão.';
  }

  @override
  String get cancelSimul => 'Cancelar a simultânea';

  @override
  String get simulHostcolor => 'Cor do simultanista em cada jogo';

  @override
  String get estimatedStart => 'Tempo de início estimado';

  @override
  String simulFeatured(String param) {
    return 'Compartilhar em $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Compartilhar a simultânia com todos em $param. Desative para jogos privados.';
  }

  @override
  String get simulDescription => 'Descrição da simultânea';

  @override
  String get simulDescriptionHelp => 'Você gostaria de dizer algo aos participantes?';

  @override
  String markdownAvailable(String param) {
    return '$param está disponível para opções de formatação adicionais.';
  }

  @override
  String get embedsAvailable => 'Cole a URL de uma partida ou de um capítulo de estudo para incorporá-lo.';

  @override
  String get inYourLocalTimezone => 'No seu próprio fuso horário';

  @override
  String get tournChat => 'Chat do torneio';

  @override
  String get noChat => 'Sem chat';

  @override
  String get onlyTeamLeaders => 'Apenas líderes de equipe';

  @override
  String get onlyTeamMembers => 'Apenas membros da equipe';

  @override
  String get navigateMoveTree => 'Navegar pela notação de movimentos';

  @override
  String get mouseTricks => 'Funcionalidades do mouse';

  @override
  String get toggleLocalAnalysis => 'Ativar/desativar análise local do computador';

  @override
  String get toggleAllAnalysis => 'Ativar/desativar todas análises locais do computador';

  @override
  String get playComputerMove => 'Jogar o melhor lance de computador';

  @override
  String get analysisOptions => 'Opções de análise';

  @override
  String get focusChat => 'Focar texto';

  @override
  String get showHelpDialog => 'Mostrar esta mensagem de ajuda';

  @override
  String get reopenYourAccount => 'Reabra sua conta';

  @override
  String get closedAccountChangedMind => 'Caso você tenha encerrado sua conta, mas mudou de opinião, você tem ainda uma chance de recuperá-la.';

  @override
  String get onlyWorksOnce => 'Isso só vai funcionar uma vez.';

  @override
  String get cantDoThisTwice => 'Caso você encerre sua conta pela segunda vez, será impossível recuperá-la.';

  @override
  String get emailAssociatedToaccount => 'Endereço de e-mail associado à conta';

  @override
  String get sentEmailWithLink => 'Enviamos um e-mail pra você com um link.';

  @override
  String get tournamentEntryCode => 'Código de entrada do torneio';

  @override
  String get hangOn => 'Espere!';

  @override
  String gameInProgress(String param) {
    return 'Você tem uma partida em andamento com $param.';
  }

  @override
  String get abortTheGame => 'Cancelar a partida';

  @override
  String get resignTheGame => 'Abandonar a partida';

  @override
  String get youCantStartNewGame => 'Você não pode iniciar um novo jogo até que este acabe.';

  @override
  String get since => 'Desde';

  @override
  String get until => 'Até';

  @override
  String get lichessDbExplanation => 'Amostra de partidas rankeadas de todos os jogadores do Lichess';

  @override
  String get switchSides => 'Trocar de lado';

  @override
  String get closingAccountWithdrawAppeal => 'Encerrar sua conta anulará seu apelo';

  @override
  String get ourEventTips => 'Nossas dicas para organização de eventos';

  @override
  String get instructions => 'Instruções';

  @override
  String get showMeEverything => 'Mostrar tudo';

  @override
  String get lichessPatronInfo => 'Lichess é um software de código aberto, totalmente grátis e sem fins lucrativos. Todos os custos operacionais, de desenvolvimento, e os conteúdos são financiados unicamente através de doações de usuários.';

  @override
  String get nothingToSeeHere => 'Nada para ver aqui no momento.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O seu adversário deixou a partida. Você pode reivindicar vitória em $count segundos.',
      one: 'O seu adversário deixou a partida. Você pode reivindicar vitória em $count segundo.',
      zero: 'O seu adversário deixou a partida. Você pode reivindicar vitória em $count segundo.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mate em $count lances',
      one: 'Mate em $count lance',
      zero: 'Mate em $count lance',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capivaradas',
      one: '$count capivarada',
      zero: '$count capivarada',
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
      zero: '$count erro',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imprecisões',
      one: '$count imprecisão',
      zero: '$count imprecisão',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogadores conectados',
      one: '$count jogadores conectados',
      zero: '$count jogadores conectados',
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
      zero: '$count partida',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rating $count após $param2 partidas',
      one: 'Rating $count em $param2 jogo',
      zero: 'Rating $count em $param2 jogo',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Favoritos',
      one: '$count Favoritos',
      zero: '$count Favoritos',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '$count dias',
      zero: '$count dias',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '$count horas',
      zero: '$count horas',
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
      zero: '$count minuto',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O ranking é atualizado a cada $count minutos',
      one: 'O ranking é atualizado a cada $count minutos',
      zero: 'O ranking é atualizado a cada $count minutos',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemas',
      one: '$count quebra-cabeça',
      zero: '$count quebra-cabeça',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidas contra você',
      one: '$count partidas contra você',
      zero: '$count partidas contra você',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count valendo pontos',
      one: '$count valendo pontos',
      zero: '$count valendo pontos',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vitórias',
      one: '$count vitória',
      zero: '$count vitória',
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
      zero: '$count derrota',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count empates',
      one: '$count empates',
      zero: '$count empates',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogando',
      one: '$count jogando',
      zero: '$count jogando',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dar $count segundos',
      one: 'Dar $count segundos',
      zero: 'Dar $count segundos',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos de torneio',
      one: '$count ponto de torneio',
      zero: '$count ponto de torneio',
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
      zero: '$count estudo',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simultâneas',
      one: '$count simultânea',
      zero: '$count simultânea',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count jogos valendo pontos',
      one: '≥ $count jogos valendo pontos',
      zero: '≥ $count jogos valendo pontos',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 partidas valendo pontos',
      one: '≥ $count partida $param2 valendo pontos',
      zero: '≥ $count partida $param2 valendo pontos',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Você precisa jogar mais $count partidas de $param2 valendo pontos',
      one: 'Você precisa jogar mais $count partida de $param2 valendo pontos',
      zero: 'Você precisa jogar mais $count partida de $param2 valendo pontos',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Você precisa jogar ainda $count partidas valendo pontos',
      one: 'Você precisa jogar ainda $count partidas valendo pontos',
      zero: 'Você precisa jogar ainda $count partidas valendo pontos',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de partidas importadas',
      one: '$count de partidas importadas',
      zero: '$count de partidas importadas',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos online',
      one: '$count amigo online',
      zero: '$count amigo online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seguidores',
      one: '$count seguidores',
      zero: '$count seguidores',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seguidos',
      one: '$count seguidos',
      zero: '$count seguidos',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Menos que $count minutos',
      one: 'Menos que $count minutos',
      zero: 'Menos que $count minutos',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidas em andamento',
      one: '$count partidas em andamento',
      zero: '$count partidas em andamento',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Máximo: $count caracteres.',
      one: 'Máximo: $count caractere.',
      zero: 'Máximo: $count caractere.',
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
      zero: '$count bloqueado',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count publicações no fórum',
      one: '$count publicação no fórum',
      zero: '$count publicação no fórum',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 jogadores nesta semana.',
      one: '$count $param2 jogador nesta semana.',
      zero: '$count $param2 jogador nesta semana.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Disponível em $count idiomas!',
      one: 'Disponível em $count idiomas!',
      zero: 'Disponível em $count idiomas!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundos para fazer o primeiro lance',
      one: '$count segundo para fazer o primeiro lance',
      zero: '$count segundo para fazer o primeiro lance',
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
      zero: '$count segundo',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'e salvar as linhas de pré-lance de $count',
      one: 'e salvar a linha de pré-lance de $count',
      zero: 'e salvar a linha de pré-lance de $count',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Mova para começar';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Você joga com as peças brancas em todos os quebra-cabeças';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Você joga com as peças pretas em todos os quebra-cabeças';

  @override
  String get stormPuzzlesSolved => 'quebra-cabeças resolvidos';

  @override
  String get stormNewDailyHighscore => 'Novo recorde diário!';

  @override
  String get stormNewWeeklyHighscore => 'Novo recorde semanal!';

  @override
  String get stormNewMonthlyHighscore => 'Novo recorde mensal!';

  @override
  String get stormNewAllTimeHighscore => 'Novo recorde de todos os tempos!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Recorde anterior era $param';
  }

  @override
  String get stormPlayAgain => 'Jogar novamente';

  @override
  String stormHighscoreX(String param) {
    return 'Recorde: $param';
  }

  @override
  String get stormScore => 'Pontuação';

  @override
  String get stormMoves => 'Lances';

  @override
  String get stormAccuracy => 'Precisão';

  @override
  String get stormCombo => 'Combo';

  @override
  String get stormTime => 'Tempo';

  @override
  String get stormTimePerMove => 'Tempo por lance';

  @override
  String get stormHighestSolved => 'Classificação mais alta';

  @override
  String get stormPuzzlesPlayed => 'Quebra-cabeças jogados';

  @override
  String get stormNewRun => 'Nova série (tecla de atalho: espaço)';

  @override
  String get stormEndRun => 'Finalizar série (tecla de atalho: Enter)';

  @override
  String get stormHighscores => 'Melhores pontuações';

  @override
  String get stormViewBestRuns => 'Ver melhores séries';

  @override
  String get stormBestRunOfDay => 'Melhor série do dia';

  @override
  String get stormRuns => 'Séries';

  @override
  String get stormGetReady => 'Prepare-se!';

  @override
  String get stormWaitingForMorePlayers => 'Esperando mais jogadores entrarem...';

  @override
  String get stormRaceComplete => 'Corrida concluída!';

  @override
  String get stormSpectating => 'Espectando';

  @override
  String get stormJoinTheRace => 'Entre na corrida!';

  @override
  String get stormStartTheRace => 'Começar a corrida';

  @override
  String stormYourRankX(String param) {
    return 'Sua classificação: $param';
  }

  @override
  String get stormWaitForRematch => 'Esperando por revanche';

  @override
  String get stormNextRace => 'Próxima corrida';

  @override
  String get stormJoinRematch => 'Junte-se a revanche';

  @override
  String get stormWaitingToStart => 'Esperando para começar';

  @override
  String get stormCreateNewGame => 'Criar um novo jogo';

  @override
  String get stormJoinPublicRace => 'Junte-se a uma corrida pública';

  @override
  String get stormRaceYourFriends => 'Corra contra seus amigos';

  @override
  String get stormSkip => 'pular';

  @override
  String get stormSkipHelp => 'Você pode pular um movimento por corrida:';

  @override
  String get stormSkipExplanation => 'Pule este lance para preservar o seu combo! Funciona apenas uma vez por corrida.';

  @override
  String get stormFailedPuzzles => 'Quebra-cabeças falhados';

  @override
  String get stormSlowPuzzles => 'Quebra-cabeças lentos';

  @override
  String get stormSkippedPuzzle => 'Quebra-cabeça pulado';

  @override
  String get stormThisWeek => 'Essa semana';

  @override
  String get stormThisMonth => 'Esse mês';

  @override
  String get stormAllTime => 'Desde o início';

  @override
  String get stormClickToReload => 'Clique para recarregar';

  @override
  String get stormThisRunHasExpired => 'Esta corrida acabou!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Esta corrida foi aberta em outra aba!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séries',
      one: '1 tentativa',
      zero: '1 tentativa',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jogou $count tentativas de $param2',
      one: 'Jogou uma tentativa de $param2',
      zero: 'Jogou uma tentativa de $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Streamers do Lichess';

  @override
  String get studyShareAndExport => 'Compartilhar & exportar';

  @override
  String get studyStart => 'Iniciar';
}
