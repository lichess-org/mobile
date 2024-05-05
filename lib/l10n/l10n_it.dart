import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get activityActivity => 'Attività';

  @override
  String get activityHostedALiveStream => 'Ha ospitato una diretta';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Classificato #$param1 in $param2';
  }

  @override
  String get activitySignedUp => 'Si è registrato su lichess.org';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supporta lichess.org da $count mesi in qualità di $param2',
      one: 'Supporta lichess.org da $count mese in qualità di $param2',
      zero: 'Supporta lichess.org da $count mese in qualità di $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha studiato $count posizioni in $param2',
      one: 'Ha studiato $count posizione in $param2',
      zero: 'Ha studiato $count posizione in $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha risolto $count puzzle',
      one: 'Ha risolto $count puzzle',
      zero: 'Ha risolto $count puzzle',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha giocato $count partite $param2',
      one: 'Ha giocato $count partita $param2',
      zero: 'Ha giocato $count partita $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha scritto $count messaggi in $param2',
      one: 'Ha scritto $count messaggio in $param2',
      zero: 'Ha scritto $count messaggio in $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha giocato $count mosse',
      one: 'Ha giocato $count mossa',
      zero: 'Ha giocato $count mossa',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count partite per corrispondenza',
      one: 'in $count partita per corrispondenza',
      zero: 'in $count partita per corrispondenza',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha concluso $count partite per corrispondenza',
      one: 'Ha concluso $count partita per corrispondenza',
      zero: 'Ha concluso $count partita per corrispondenza',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha iniziato a seguire $count giocatori',
      one: 'Ha iniziato a seguire $count giocatore',
      zero: 'Ha iniziato a seguire $count giocatore',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha guadagnato $count nuovi follower',
      one: 'Ha guadagnato $count nuovo follower',
      zero: 'Ha guadagnato $count nuovo follower',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha ospitato $count esibizioni simultanee',
      one: 'Ha ospitato $count esibizione simultanea',
      zero: 'Ha ospitato $count esibizione simultanea',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha partecipato a $count esibizioni simultanee',
      one: 'Ha partecipato ad $count esibizione simultanea',
      zero: 'Ha partecipato ad $count esibizione simultanea',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha creato $count nuovi studi',
      one: 'Ha creato $count nuovo studio',
      zero: 'Ha creato $count nuovo studio',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha gareggiato in $count tornei',
      one: 'Ha gareggiato in $count torneo',
      zero: 'Ha gareggiato in $count torneo',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Si è classificato $count° (nel miglior $param2%) con $param3 partite in $param4',
      one: 'Si è classificato $count° (nel miglior $param2%) con $param3 partita in $param4',
      zero: 'Si è classificato $count° (nel miglior $param2%) con $param3 partita in $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha gareggiato in $count tornei Svizzeri',
      one: 'Ha gareggiato in $count torneo Svizzero',
      zero: 'Ha gareggiato in $count torneo Svizzero',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Si è unito a $count squadre',
      one: 'Si è unito ad $count squadra',
      zero: 'Si è unito ad $count squadra',
    );
    return '$_temp0';
  }

  @override
  String get contactContact => 'Contattaci';

  @override
  String get contactContactLichess => 'Contatta Lichess';

  @override
  String get playWithAFriend => 'Gioca con un amico';

  @override
  String get playWithTheMachine => 'Gioca contro il computer';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Per invitare qualcuno a giocare, dagli questo URL';

  @override
  String get gameOver => 'Partita terminata';

  @override
  String get waitingForOpponent => 'In attesa dell\'avversario';

  @override
  String get orLetYourOpponentScanQrCode => 'Oppure lascia che il tuo avversario scansioni questo codice QR';

  @override
  String get waiting => 'In attesa';

  @override
  String get yourTurn => 'Tocca a te';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 livello $param2';
  }

  @override
  String get level => 'Livello';

  @override
  String get strength => 'Forza';

  @override
  String get toggleTheChat => 'Attiva/disattiva la chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Abbandona';

  @override
  String get checkmate => 'Scacco matto';

  @override
  String get stalemate => 'Stallo';

  @override
  String get white => 'Bianco';

  @override
  String get black => 'Nero';

  @override
  String get asWhite => 'come bianco';

  @override
  String get asBlack => 'come nero';

  @override
  String get randomColor => 'Colore casuale';

  @override
  String get createAGame => 'Crea una partita';

  @override
  String get whiteIsVictorious => 'Vince il Bianco';

  @override
  String get blackIsVictorious => 'Vince il Nero';

  @override
  String get youPlayTheWhitePieces => 'Sei il Bianco';

  @override
  String get youPlayTheBlackPieces => 'Sei il Nero';

  @override
  String get itsYourTurn => 'Tocca a te!';

  @override
  String get cheatDetected => 'Cheat Rilevato';

  @override
  String get kingInTheCenter => 'Re al centro';

  @override
  String get threeChecks => 'Tre scacchi';

  @override
  String get raceFinished => 'Corsa terminata';

  @override
  String get variantEnding => 'Fine variante';

  @override
  String get newOpponent => 'Nuovo avversario';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Il tuo avversario vuole giocare un\'altra partita con te';

  @override
  String get joinTheGame => 'Unisciti alla partita';

  @override
  String get whitePlays => 'Tocca al Bianco';

  @override
  String get blackPlays => 'Tocca al Nero';

  @override
  String get opponentLeftChoices => 'Il tuo avversario potrebbe aver lasciato la partita. Puoi reclamare la vittoria, stabilire la patta o aspettare.';

  @override
  String get forceResignation => 'Reclama la vittoria';

  @override
  String get forceDraw => 'Stabilisci la patta';

  @override
  String get talkInChat => 'Sii educato in chat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'La prima persona che si presenta a questo URL giocherà con te.';

  @override
  String get whiteResigned => 'Il Bianco ha abbandonato';

  @override
  String get blackResigned => 'Il Nero ha abbandonato';

  @override
  String get whiteLeftTheGame => 'Il Bianco ha lasciato la partita';

  @override
  String get blackLeftTheGame => 'Il Nero ha lasciato la partita';

  @override
  String get whiteDidntMove => 'Il bianco non si è mosso';

  @override
  String get blackDidntMove => 'Il nero non si è mosso';

  @override
  String get requestAComputerAnalysis => 'Chiedi un\'analisi del computer';

  @override
  String get computerAnalysis => 'Analisi del computer';

  @override
  String get computerAnalysisAvailable => 'Analisi del computer disponibile';

  @override
  String get computerAnalysisDisabled => 'Analisi del computer disattivata';

  @override
  String get analysis => 'Scacchiera di analisi';

  @override
  String depthX(String param) {
    return 'Profondità $param';
  }

  @override
  String get usingServerAnalysis => 'Analisi del computer in uso';

  @override
  String get loadingEngine => 'Caricamento del motore di analisi...';

  @override
  String get calculatingMoves => 'Calcolando le mosse...';

  @override
  String get engineFailed => 'Errore nel caricamento del motore';

  @override
  String get cloudAnalysis => 'Analisi nel cloud';

  @override
  String get goDeeper => 'Aumenta la profondità';

  @override
  String get showThreat => 'Mostra minaccia';

  @override
  String get inLocalBrowser => 'nel browser locale';

  @override
  String get toggleLocalEvaluation => 'Attiva/disattiva analisi locale';

  @override
  String get promoteVariation => 'Promuovi la variante';

  @override
  String get makeMainLine => 'Rendi questa la variante principale';

  @override
  String get deleteFromHere => 'Elimina da qui';

  @override
  String get forceVariation => 'Mostra come variante';

  @override
  String get copyVariationPgn => 'Copia il PGN della variante';

  @override
  String get move => 'Mossa';

  @override
  String get variantLoss => 'Sconfitta per variante';

  @override
  String get variantWin => 'Vittoria per variante';

  @override
  String get insufficientMaterial => 'Materiale insufficiente';

  @override
  String get pawnMove => 'Mossa di pedone';

  @override
  String get capture => 'Cattura';

  @override
  String get close => 'Chiudi';

  @override
  String get winning => 'Mosse vincenti';

  @override
  String get losing => 'Mosse perdenti';

  @override
  String get drawn => 'Patta';

  @override
  String get unknown => 'Posizioni sconosciute';

  @override
  String get database => 'Database';

  @override
  String get whiteDrawBlack => 'Bianco / Patta / Nero';

  @override
  String averageRatingX(String param) {
    return 'Punteggio medio: $param';
  }

  @override
  String get recentGames => 'Partite recenti';

  @override
  String get topGames => 'Migliori partite';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Due milioni di partite dal $param2 al $param3 di giocatori con punteggio FIDE $param1+';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' con arrotondamento, in base al numero di mezze mosse fino alla prossima cattura o mossa del pedone';

  @override
  String get noGameFound => 'Nessun partita trovata';

  @override
  String get maxDepthReached => 'Massima profondità raggiunta!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Prova a includere più partite dal menu Preferenze.';

  @override
  String get openings => 'Aperture';

  @override
  String get openingExplorer => 'Esplora aperture';

  @override
  String get openingEndgameExplorer => 'Esploratore aperture/chiusure';

  @override
  String xOpeningExplorer(String param) {
    return 'Explorer delle aperture $param';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Gioca la prima apertura/mossa in chiusura dell\'explorer';

  @override
  String get winPreventedBy50MoveRule => 'Vittoria non possibile a causa della \"regola delle 50 mosse\"';

  @override
  String get lossSavedBy50MoveRule => 'Sconfitta evitata per la regola delle 50 mosse';

  @override
  String get winOr50MovesByPriorMistake => 'Vittoria o 50 mosse per errore precedente';

  @override
  String get lossOr50MovesByPriorMistake => 'Perdita o 50 mosse per errore precedente';

  @override
  String get unknownDueToRounding => 'Vittoria/perdita garantita solo se la riga della base delle tabella consigliata è stata seguita dall\'ultima cattura o mossa del pedone, a causa del possibile arrotondamento.';

  @override
  String get allSet => 'Tutto pronto!';

  @override
  String get importPgn => 'Importa PGN';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteThisImportedGame => 'Vuoi eliminare questa partita importata?';

  @override
  String get replayMode => 'Modalità replay';

  @override
  String get realtimeReplay => 'In tempo reale';

  @override
  String get byCPL => 'Per CPL';

  @override
  String get openStudy => 'Apri studio';

  @override
  String get enable => 'Abilita';

  @override
  String get bestMoveArrow => 'Freccia per la mossa migliore';

  @override
  String get showVariationArrows => 'Mostra le frecce delle varianti';

  @override
  String get evaluationGauge => 'Indicatore di valutazione del vantaggio';

  @override
  String get multipleLines => 'Varianti multiple';

  @override
  String get cpus => 'Processori';

  @override
  String get memory => 'Memoria';

  @override
  String get infiniteAnalysis => 'Analisi infinita';

  @override
  String get removesTheDepthLimit => 'Rimuove il limite di profondità di analisi, ma può surriscaldare il tuo computer';

  @override
  String get engineManager => 'Gestore del motore';

  @override
  String get blunder => 'Errore grave';

  @override
  String get mistake => 'Errore';

  @override
  String get inaccuracy => 'Imprecisione';

  @override
  String get moveTimes => 'Tempo per mossa';

  @override
  String get flipBoard => 'Ruota la scacchiera';

  @override
  String get threefoldRepetition => 'Triplice ripetizione';

  @override
  String get claimADraw => 'Reclama patta';

  @override
  String get offerDraw => 'Offri patta';

  @override
  String get draw => 'Patta';

  @override
  String get drawByMutualAgreement => 'Patta per comune accordo';

  @override
  String get fiftyMovesWithoutProgress => 'Cinquanta mosse senza progresso';

  @override
  String get currentGames => 'Partite in corso';

  @override
  String get viewInFullSize => 'Visualizza a schermo intero';

  @override
  String get logOut => 'Esci';

  @override
  String get signIn => 'Accedi';

  @override
  String get rememberMe => 'Ricordati di me';

  @override
  String get youNeedAnAccountToDoThat => 'Devi avere un account per farlo';

  @override
  String get signUp => 'Registrati';

  @override
  String get computersAreNotAllowedToPlay => 'Non è permesso giocare né a giocatori che si fanno aiutare dai computer né a computer. Mentre giochi, non farti aiutare da programmi di scacchi, da database o da altre persone. Inoltre si sconsiglia vivamente di creare account multipli perché un uso eccessivo di account porterà alla cancellazione dal sito.';

  @override
  String get games => 'Partite';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 ha postato nel forum $param2';
  }

  @override
  String get latestForumPosts => 'Ultimi interventi nel forum';

  @override
  String get players => 'Giocatori';

  @override
  String get friends => 'Amici';

  @override
  String get discussions => 'Conversazioni';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get minutesPerSide => 'Minuti per giocatore';

  @override
  String get variant => 'Variante';

  @override
  String get variants => 'Varianti';

  @override
  String get timeControl => 'Cadenza di gioco';

  @override
  String get realTime => 'Partite a tempo';

  @override
  String get correspondence => 'Corrispondenza';

  @override
  String get daysPerTurn => 'Giorni per mossa';

  @override
  String get oneDay => 'Un giorno';

  @override
  String get time => 'Tempo';

  @override
  String get rating => 'Punteggio';

  @override
  String get ratingStats => 'Statistiche punteggi';

  @override
  String get username => 'Nome utente';

  @override
  String get usernameOrEmail => 'Nome utente o email';

  @override
  String get changeUsername => 'Cambia nome utente';

  @override
  String get changeUsernameNotSame => 'Puoi cambiare solamente il maiuscolo/minuscolo delle lettere (per esempio da \"mariorossi\" a \"MarioRossi\").';

  @override
  String get changeUsernameDescription => 'Cambia il tuo nome utente. Questa operazione può essere effettuata una sola volta e consente di modificare solamente il maiuscolo/minuscolo del tuo nome utente.';

  @override
  String get signupUsernameHint => 'Assicurati di scegliere un nome utente appropriato. Non potrai cambiarlo successivamente e gli account con nomi inappropriati saranno cancellati!';

  @override
  String get signupEmailHint => 'Lo useremo solamente per reimpostare la tua password.';

  @override
  String get password => 'Password';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get changeEmail => 'Cambia email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Reimpostare la password';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get error_weakPassword => 'Questa password è estremamente comune e troppo facile da indovinare.';

  @override
  String get error_namePassword => 'Sei pregato di non utilizzare il tuo nome utente come password.';

  @override
  String get blankedPassword => 'Hai usato la stessa password su un altro sito e quel sito è stato violato. Per garantire la sicurezza del tuo account Lichess, abbiamo bisogno che imposti una nuova password. Grazie per la tua comprensione.';

  @override
  String get youAreLeavingLichess => 'Stai uscendo da Lichess';

  @override
  String get neverTypeYourPassword => 'Non digitare mai la tua password di Lichess su un altro sito!';

  @override
  String proceedToX(String param) {
    return 'Procedi su $param';
  }

  @override
  String get passwordSuggestion => 'Non impostare una password suggerita da qualcun altro. La utilizzeranno per rubare il tuo profilo.';

  @override
  String get emailSuggestion => 'Non impostare un indirizzo email suggerito da qualcun altro. Lo utilizzeranno per rubare il tuo profilo.';

  @override
  String get emailConfirmHelp => 'Aiuto per la conferma dell\'email';

  @override
  String get emailConfirmNotReceived => 'Non hai ricevuto la tua email di conferma dopo la registrazione?';

  @override
  String get whatSignupUsername => 'Quale nome utente hai usato per registrarti?';

  @override
  String usernameNotFound(String param) {
    return 'Non siamo riusciti a trovare alcun utente con questo nome: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Puoi usare questo nome utente per creare un nuovo account';

  @override
  String emailSent(String param) {
    return 'Abbiamo inviato un\'email a $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Può metterci un po\' di tempo per arrivare.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Attendi 5 minuti e aggiorna la posta in arrivo.';

  @override
  String get checkSpamFolder => 'Controlla anche la tua cartella di spam, potrebbe essere finita lì. Se sì, contrassegnala come non spam.';

  @override
  String get emailForSignupHelp => 'Se tutto il resto fallisce, inviaci questa email:';

  @override
  String copyTextToEmail(String param) {
    return 'Copia e incolla il testo soprastante e invialo a $param';
  }

  @override
  String get waitForSignupHelp => 'Ti risponderemo a breve per aiutarti a completare la tua iscrizione.';

  @override
  String accountConfirmed(String param) {
    return 'L\'utente $param è stato confermato con successo.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Adesso puoi effettuare il login come $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Non hai bisogno di una email di conferma.';

  @override
  String accountClosed(String param) {
    return 'L\'account $param è chiuso.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'L\'account $param è stato registrato senza un indirizzo e-mail.';
  }

  @override
  String get rank => 'Posizione';

  @override
  String rankX(String param) {
    return 'Posizione: $param';
  }

  @override
  String get gamesPlayed => 'Partite giocate';

  @override
  String get cancel => 'Annulla';

  @override
  String get whiteTimeOut => 'Il bianco ha esaurito il tempo';

  @override
  String get blackTimeOut => 'Il nero ha esaurito il tempo';

  @override
  String get drawOfferSent => 'Offerta di patta inviata';

  @override
  String get drawOfferAccepted => 'Offerta di patta accettata';

  @override
  String get drawOfferCanceled => 'Offerta di patta annullata';

  @override
  String get whiteOffersDraw => 'Il Bianco offre patta';

  @override
  String get blackOffersDraw => 'Il Nero offre patta';

  @override
  String get whiteDeclinesDraw => 'Il Bianco rifiuta la patta';

  @override
  String get blackDeclinesDraw => 'Il Nero rifiuta la patta';

  @override
  String get yourOpponentOffersADraw => 'Il tuo avversario offre patta';

  @override
  String get accept => 'Accetta';

  @override
  String get decline => 'Rifiuta';

  @override
  String get playingRightNow => 'Partita in corso';

  @override
  String get eventInProgress => 'In corso';

  @override
  String get finished => 'Terminati';

  @override
  String get abortGame => 'Interrompi la partita';

  @override
  String get gameAborted => 'Partita interrotta';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Posizione personalizzata';

  @override
  String get unlimited => 'Illimitato';

  @override
  String get mode => 'Modalità';

  @override
  String get casual => 'Amichevole';

  @override
  String get rated => 'Classificata';

  @override
  String get casualTournament => 'Non classificato';

  @override
  String get ratedTournament => 'Classificata';

  @override
  String get thisGameIsRated => 'Questa partita è classificata';

  @override
  String get rematch => 'Rivincita';

  @override
  String get rematchOfferSent => 'Offerta di rivincita inviata';

  @override
  String get rematchOfferAccepted => 'Rivincita accettata';

  @override
  String get rematchOfferCanceled => 'Offerta di rivincita annullata';

  @override
  String get rematchOfferDeclined => 'Offerta di rivincita rifiutata';

  @override
  String get cancelRematchOffer => 'Annulla l\'offerta di rivincita';

  @override
  String get viewRematch => 'Osserva la rivincita';

  @override
  String get confirmMove => 'Conferma mossa';

  @override
  String get play => 'Gioca';

  @override
  String get inbox => 'Messaggi';

  @override
  String get chatRoom => 'Chat room';

  @override
  String get loginToChat => 'Entra per partecipare alla chat';

  @override
  String get youHaveBeenTimedOut => 'Sei stato temporaneamente mutato.';

  @override
  String get spectatorRoom => 'Chat spettatori';

  @override
  String get composeMessage => 'Componi messaggio';

  @override
  String get subject => 'Oggetto';

  @override
  String get send => 'Invia';

  @override
  String get incrementInSeconds => 'Incremento in secondi';

  @override
  String get freeOnlineChess => 'Scacchi Online Gratis';

  @override
  String get exportGames => 'Esporta le partite';

  @override
  String get ratingRange => 'Punteggio avversario';

  @override
  String get thisAccountViolatedTos => 'Questo account ha violato i termini di servizio di Lichess';

  @override
  String get openingExplorerAndTablebase => 'Explorer delle aperture & tablebase';

  @override
  String get takeback => 'Ritira la mossa';

  @override
  String get proposeATakeback => 'Chiedi di ritirare la mossa';

  @override
  String get takebackPropositionSent => 'Richiesta di ritiro mossa inviata';

  @override
  String get takebackPropositionDeclined => 'Richiesta di ritiro mossa rifiutata';

  @override
  String get takebackPropositionAccepted => 'Richiesta di ritiro mossa accettata';

  @override
  String get takebackPropositionCanceled => 'Richiesta di ritiro mossa annullata';

  @override
  String get yourOpponentProposesATakeback => 'Il tuo avversario chiede di ritirare la mossa';

  @override
  String get bookmarkThisGame => 'Aggiungi questa partita ai preferiti';

  @override
  String get tournament => 'Torneo';

  @override
  String get tournaments => 'Tornei';

  @override
  String get tournamentPoints => 'Punti torneo';

  @override
  String get viewTournament => 'Visualizza torneo';

  @override
  String get backToTournament => 'Ritorna al torneo';

  @override
  String get noDrawBeforeSwissLimit => 'Non puoi offrire una patta prima della trentesima mossa in un torneo a sistema Svizzero.';

  @override
  String get thematic => 'A tema';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Il tuo punteggio $param è provvisorio';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Il tuo punteggio $param1 ($param2) è troppo alto';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Il tuo miglior punteggio settimanale $param1 ($param2) è troppo alto';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Il tuo punteggio $param1 ($param2) è troppo basso';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Punteggio ≥ $param1 in $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Punteggio ≤ $param1 in $param2';
  }

  @override
  String mustBeInTeam(String param) {
    return 'È necessario essere membri del gruppo $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Non sei nel team $param';
  }

  @override
  String get backToGame => 'Torna alla partita';

  @override
  String get siteDescription => 'Scacchi online gratis. Gioca subito a scacchi con un\'interfaccia semplice. Niente registrazioni, annunci, plug-in. Gioca a scacchi contro computer, amici o avversari casuali.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 si è unito al gruppo $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 ha creato il gruppo $param2';
  }

  @override
  String get startedStreaming => 'ha iniziato una trasmissione';

  @override
  String xStartedStreaming(String param) {
    return '$param ha avviato lo streaming';
  }

  @override
  String get averageElo => 'Punteggio medio';

  @override
  String get location => 'Luogo';

  @override
  String get filterGames => 'Filtra partite';

  @override
  String get reset => 'Azzera';

  @override
  String get apply => 'Applica';

  @override
  String get save => 'Salva';

  @override
  String get leaderboard => 'Classifica';

  @override
  String get screenshotCurrentPosition => 'Salva la schermata corrente';

  @override
  String get gameAsGIF => 'Salva la partita come GIF';

  @override
  String get pasteTheFenStringHere => 'Incolla qui la stringa FEN';

  @override
  String get pasteThePgnStringHere => 'Incolla qui il testo PGN';

  @override
  String get orUploadPgnFile => 'O carica un file PGN';

  @override
  String get fromPosition => 'Da una posizione';

  @override
  String get continueFromHere => 'Continua da qui';

  @override
  String get toStudy => 'Studia';

  @override
  String get importGame => 'Importa partita';

  @override
  String get importGameExplanation => 'Quando incolli una partita tramite PGN potrai rivederla,\nanalizzarla con il computer, commentarla in chat, e condividerla tramite un indirizzo URL.';

  @override
  String get importGameCaveat => 'Le varianti saranno cancellate. Per salvarle, importa il PGN in uno studio.';

  @override
  String get importGameDataPrivacyWarning => 'Questo PGN è accessibile pubblicamente. Per importare una partita privatamente, utilizza uno studio.';

  @override
  String get thisIsAChessCaptcha => 'Questo è un CAPTCHA di scacchi.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Clicca sulla scacchiera e fai la tua mossa, per provare che sei un umano.';

  @override
  String get captcha_fail => 'Per favore risolvi il captcha-puzzle.';

  @override
  String get notACheckmate => 'Non è scacco matto';

  @override
  String get whiteCheckmatesInOneMove => 'Il Bianco dà matto in una mossa';

  @override
  String get blackCheckmatesInOneMove => 'Il Nero dà matto in una mossa';

  @override
  String get retry => 'Riprova';

  @override
  String get reconnecting => 'Riconnessione';

  @override
  String get noNetwork => 'Non in linea';

  @override
  String get favoriteOpponents => 'Avversari preferiti';

  @override
  String get follow => 'Segui';

  @override
  String get following => 'Stai seguendo';

  @override
  String get unfollow => 'Non seguire più';

  @override
  String followX(String param) {
    return 'Segui $param';
  }

  @override
  String unfollowX(String param) {
    return 'Smetti di seguire $param';
  }

  @override
  String get block => 'Blocca';

  @override
  String get blocked => 'Bloccato';

  @override
  String get unblock => 'Sblocca';

  @override
  String get followsYou => 'Ti segue';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 ha iniziato a seguire $param2';
  }

  @override
  String get more => 'Altro';

  @override
  String get memberSince => 'Membro dal';

  @override
  String lastSeenActive(String param) {
    return 'Ultimo accesso $param';
  }

  @override
  String get player => 'Giocatore';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Grafico';

  @override
  String get required => 'Richiesto.';

  @override
  String get openTournaments => 'Tornei aperti';

  @override
  String get duration => 'Durata';

  @override
  String get winner => 'Vincitore';

  @override
  String get standing => 'Classifica';

  @override
  String get createANewTournament => 'Crea un nuovo torneo';

  @override
  String get tournamentCalendar => 'Elenco dei Tornei';

  @override
  String get conditionOfEntry => 'Condizioni di accesso:';

  @override
  String get advancedSettings => 'Impostazioni Avanzate';

  @override
  String get safeTournamentName => 'Scegli un nome appropriato per il torneo.';

  @override
  String get inappropriateNameWarning => 'Qualsiasi cosa anche solo lievemente inappropriata potrebbe comportare l\'eliminazione del tuo account.';

  @override
  String get emptyTournamentName => 'Lascia vuoto il nome del torneo per chiamarlo con il nome di un giocatore famoso casuale.';

  @override
  String get recommendNotTouching => 'Si consiglia di non toccare queste impostazioni.';

  @override
  String get fewerPlayers => 'Se imponi condizioni d\'accesso il torneo avrà un minor numero di giocatori.';

  @override
  String get showAdvancedSettings => 'Mostra impostazioni avanzate';

  @override
  String get makePrivateTournament => 'Rendi privato il torneo e limita l\'accesso con una password';

  @override
  String get join => 'Unisciti';

  @override
  String get withdraw => 'Ritirati';

  @override
  String get points => 'Punti';

  @override
  String get wins => 'Vittorie';

  @override
  String get losses => 'Sconfitte';

  @override
  String get createdBy => 'Creato da';

  @override
  String get tournamentIsStarting => 'Sta per iniziare il torneo';

  @override
  String get tournamentPairingsAreNowClosed => 'Gli accoppiamenti del torneo sono ora chiusi.';

  @override
  String standByX(String param) {
    return 'Resta in attesa $param, accoppiamento giocatori, preparati!';
  }

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Riprendi';

  @override
  String get youArePlaying => 'Stai giocando!';

  @override
  String get winRate => 'Percentuale di vittorie';

  @override
  String get berserkRate => 'Percentuale Berserk';

  @override
  String get performance => 'Performance';

  @override
  String get tournamentComplete => 'Torneo terminato';

  @override
  String get movesPlayed => 'Mosse giocate';

  @override
  String get whiteWins => 'Il Bianco vince';

  @override
  String get blackWins => 'Il Nero vince';

  @override
  String get drawRate => 'Tasso di pareggio';

  @override
  String get draws => 'Patte';

  @override
  String nextXTournament(String param) {
    return 'Prossimo torneo $param:';
  }

  @override
  String get averageOpponent => 'Punteggio medio degli avversari';

  @override
  String get boardEditor => 'Editor scacchiera';

  @override
  String get setTheBoard => 'Imposta la scacchiera';

  @override
  String get popularOpenings => 'Aperture popolari';

  @override
  String get endgamePositions => 'Posizioni di chiusura';

  @override
  String chess960StartPosition(String param) {
    return 'Posizione iniziale di Chess960: $param';
  }

  @override
  String get startPosition => 'Posizione iniziale';

  @override
  String get clearBoard => 'Svuota scacchiera';

  @override
  String get loadPosition => 'Carica una posizione';

  @override
  String get isPrivate => 'Privato';

  @override
  String reportXToModerators(String param) {
    return 'Segnala $param ai moderatori';
  }

  @override
  String profileCompletion(String param) {
    return 'Completamento del profilo: $param';
  }

  @override
  String xRating(String param) {
    return '$param punteggio';
  }

  @override
  String get ifNoneLeaveEmpty => 'Se nessuno, lasciare vuoto';

  @override
  String get profile => 'Profilo';

  @override
  String get editProfile => 'Modifica profilo';

  @override
  String get firstName => 'Nome';

  @override
  String get lastName => 'Cognome';

  @override
  String get setFlair => 'Imposta la tua icona';

  @override
  String get flair => 'Icona';

  @override
  String get youCanHideFlair => 'Esiste un\'impostazione per nascondere le icone di tutti gli utenti, sull\'intero sito.';

  @override
  String get biography => 'Biografia';

  @override
  String get countryRegion => 'Nazione o regione';

  @override
  String get thankYou => 'Grazie!';

  @override
  String get socialMediaLinks => 'Collegamenti ai social media';

  @override
  String get oneUrlPerLine => 'Un URL per riga.';

  @override
  String get inlineNotation => 'Notazione in linea';

  @override
  String get makeAStudy => 'Per conservare e condividere l\'analisi, valuta di farne uno studio.';

  @override
  String get clearSavedMoves => 'Fai pulizia delle mosse';

  @override
  String get previouslyOnLichessTV => 'Già visti sulla TV di Lichess';

  @override
  String get onlinePlayers => 'Giocatori online';

  @override
  String get activePlayers => 'Giocatori attivi';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Attenzione, la partita è classificata ma senza limite di tempo!';

  @override
  String get success => 'Risolto';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Passa automaticamente alla partita successiva dopo aver mosso';

  @override
  String get autoSwitch => 'Cambia automaticamente';

  @override
  String get puzzles => 'Puzzle';

  @override
  String get onlineBots => 'Bot online';

  @override
  String get name => 'Nome';

  @override
  String get description => 'Descrizione';

  @override
  String get descPrivate => 'Descrizione privata';

  @override
  String get descPrivateHelp => 'Il testo che solo i membri del team vedranno. Se impostato sostituisce la descrizione pubblica per i membri del team.';

  @override
  String get no => 'No';

  @override
  String get yes => 'Sì';

  @override
  String get help => 'Aiuto:';

  @override
  String get createANewTopic => 'Crea una nuova discussione';

  @override
  String get topics => 'Discussioni';

  @override
  String get posts => 'Post';

  @override
  String get lastPost => 'Ultimo post';

  @override
  String get views => 'Visualizzazioni';

  @override
  String get replies => 'Risposte';

  @override
  String get replyToThisTopic => 'Rispondi a questa discussione';

  @override
  String get reply => 'Rispondi';

  @override
  String get message => 'Messaggio';

  @override
  String get createTheTopic => 'Crea la discussione';

  @override
  String get reportAUser => 'Segnala un utente';

  @override
  String get user => 'Utente';

  @override
  String get reason => 'Motivo';

  @override
  String get whatIsIheMatter => 'Qual è il problema?';

  @override
  String get cheat => 'Imbrogli';

  @override
  String get insult => 'Insulti';

  @override
  String get troll => 'Provocazioni';

  @override
  String get ratingManipulation => 'Manipolazione del rating';

  @override
  String get other => 'Altro';

  @override
  String get reportDescriptionHelp => 'Incolla il link della partita/e e spiega cosa non va con questo giocatore. Non dire soltanto \"ha imbrogliato\", ma specifica come sei arrivato a questa conclusione. Il tuo report verrà processato più velocemente se scritto in lingua inglese.';

  @override
  String get error_provideOneCheatedGameLink => 'Si prega di fornire almeno un collegamento link di una partita in cui il giocatore ha imbrogliato.';

  @override
  String by(String param) {
    return 'di $param';
  }

  @override
  String importedByX(String param) {
    return 'Importato da $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Questa discussione è chiusa.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Note';

  @override
  String get typePrivateNotesHere => 'Scrivi qui le tue note private';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Scrivi una nota privata su questo utente';

  @override
  String get noNoteYet => 'Non ci sono note';

  @override
  String get invalidUsernameOrPassword => 'Nome utente o password non validi';

  @override
  String get incorrectPassword => 'Password errata';

  @override
  String get invalidAuthenticationCode => 'Codice di autenticazione non valido';

  @override
  String get emailMeALink => 'Inviami il link via email';

  @override
  String get currentPassword => 'Password attuale';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get newPasswordAgain => 'Nuova password (ripeti)';

  @override
  String get newPasswordsDontMatch => 'Le nuove password non coincidono';

  @override
  String get newPasswordStrength => 'Sicurezza della password';

  @override
  String get clockInitialTime => 'Tempo iniziale';

  @override
  String get clockIncrement => 'Incremento orologio';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyPolicy => 'privacy policy';

  @override
  String get letOtherPlayersFollowYou => 'Permetti ad altri giocatori di seguirti';

  @override
  String get letOtherPlayersChallengeYou => 'Permetti ad altri giocatori di sfidarti';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Permetti ad altri giocatori di invitarti negli studi';

  @override
  String get sound => 'Suono';

  @override
  String get none => 'Nessuna';

  @override
  String get fast => 'Veloce';

  @override
  String get normal => 'Normale';

  @override
  String get slow => 'Lenta';

  @override
  String get insideTheBoard => 'Dentro la scacchiera';

  @override
  String get outsideTheBoard => 'Fuori la scacchiera';

  @override
  String get onSlowGames => 'Nelle partite lente';

  @override
  String get always => 'Sempre';

  @override
  String get never => 'Mai';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 ha giocato in $param2';
  }

  @override
  String get victory => 'Vittoria';

  @override
  String get defeat => 'Sconfitta';

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
  String get timeline => 'Resoconto attività';

  @override
  String get starting => 'Inizio:';

  @override
  String get allInformationIsPublicAndOptional => 'Tutte le informazioni sono pubbliche e facoltative.';

  @override
  String get biographyDescription => 'Parlaci di te, cosa ti piace degli scacchi, le tue aperture preferite, partite, giocatori preferiti…';

  @override
  String get listBlockedPlayers => 'Elenca i giocatori che hai bloccato';

  @override
  String get human => 'Umano';

  @override
  String get computer => 'Computer';

  @override
  String get side => 'Lato';

  @override
  String get clock => 'Orologio';

  @override
  String get opponent => 'Avversario';

  @override
  String get learnMenu => 'Impara';

  @override
  String get studyMenu => 'Studi';

  @override
  String get practice => 'Allenamento';

  @override
  String get community => 'Community';

  @override
  String get tools => 'Strumenti';

  @override
  String get increment => 'Incremento';

  @override
  String get error_unknown => 'Valore non valido';

  @override
  String get error_required => 'Questo campo è obbligatorio';

  @override
  String get error_email => 'Questo indirizzo email non è valido';

  @override
  String get error_email_acceptable => 'Questo indirizzo email non è valido. Per favore ricontrollalo e riprova.';

  @override
  String get error_email_unique => 'Indirizzo email non valido o già in uso';

  @override
  String get error_email_different => 'Questo è già il tuo indirizzo email';

  @override
  String error_minLength(String param) {
    return 'Deve contenere almeno $param caratteri';
  }

  @override
  String error_maxLength(String param) {
    return 'Deve contenere al massimo $param caratteri';
  }

  @override
  String error_min(String param) {
    return 'Deve essere almeno $param';
  }

  @override
  String error_max(String param) {
    return 'Deve essere al massimo $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Se il punteggio è ± $param';
  }

  @override
  String get ifRegistered => 'Se registrati';

  @override
  String get onlyExistingConversations => 'Solo conversazioni esistenti';

  @override
  String get onlyFriends => 'Solo amici';

  @override
  String get menu => 'Menù';

  @override
  String get castling => 'Arrocco';

  @override
  String get whiteCastlingKingside => 'Bianco O-O';

  @override
  String get blackCastlingKingside => 'Nero O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Tempo in partita: $param';
  }

  @override
  String get watchGames => 'Guarda le partite';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Tempo in TV: $param';
  }

  @override
  String get watch => 'Guarda';

  @override
  String get videoLibrary => 'Libreria video';

  @override
  String get streamersMenu => 'Streamer';

  @override
  String get mobileApp => 'App mobile';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'Info su';

  @override
  String aboutX(String param) {
    return 'Informazioni su $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 è un server di scacchi ($param2), open source, privo di pubblicità e rilasciato sotto licenza libera.';
  }

  @override
  String get really => 'completamente gratuito';

  @override
  String get contribute => 'Contribuisci';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get sourceCode => 'Codice sorgente';

  @override
  String get simultaneousExhibitions => 'Esibizioni simultanee';

  @override
  String get host => 'Simultaneista';

  @override
  String hostColorX(String param) {
    return 'Colore del simultaneista: $param';
  }

  @override
  String get yourPendingSimuls => 'Le tue simultanee in attesa';

  @override
  String get createdSimuls => 'Simultanee recenti';

  @override
  String get hostANewSimul => 'Crea una nuova simultanea';

  @override
  String get signUpToHostOrJoinASimul => 'Registrati per organizzare, o unirti a, un\'esibizione simultanea';

  @override
  String get noSimulFound => 'Simultanea non trovata';

  @override
  String get noSimulExplanation => 'Questa esibizione simultanea non esiste.';

  @override
  String get returnToSimulHomepage => 'Ritorna alla pagina delle simultanee';

  @override
  String get aboutSimul => 'Nelle simultanee un giocatore sfida diversi avversari contemporaneamente.';

  @override
  String get aboutSimulImage => 'Su 50 avversari, Fischer vinse 47 partite, ne pareggiò 2 e ne perse 1.';

  @override
  String get aboutSimulRealLife => 'Questo concetto è preso da eventi reali. Nella vita reale, questo implica che il simultaneista si muova da un tavolo all\'altro per giocare le singole mosse.';

  @override
  String get aboutSimulRules => 'Quando la simultanea comincia, ogni giocatore comincia una partita con il simultaneista, il quale gioca con i pezzi bianchi. La simultanea finisce quando sono finite tutte le partite.';

  @override
  String get aboutSimulSettings => 'Le simultanee sono sempre amichevoli. Rivincite, ritiri di mossa e aggiunte di tempo sono disabilitate.';

  @override
  String get create => 'Crea';

  @override
  String get whenCreateSimul => 'Quando crei una simultanea, giochi contro diversi avversari contemporaneamente.';

  @override
  String get simulVariantsHint => 'Se selezioni più varianti, ogni giocatore può scegliere quale giocare.';

  @override
  String get simulClockHint => 'Modello Fischer Clock. Più giocatori sfidi, più tempo ti potrebbe servire.';

  @override
  String get simulAddExtraTime => 'Puoi aggiungere più tempo al tuo orologio per far fronte alla simultanea.';

  @override
  String get simulHostExtraTime => 'Tempo aggiuntivo del simultaneista';

  @override
  String get simulAddExtraTimePerPlayer => 'Aggiungi del tempo al tuo orologio per ogni giocatore che si unisce alla simultanea.';

  @override
  String get simulHostExtraTimePerPlayer => 'Tempo extra per il simultaneista per ciascun giocatore';

  @override
  String get lichessTournaments => 'Tornei Lichess';

  @override
  String get tournamentFAQ => 'Domande frequenti sui tornei';

  @override
  String get timeBeforeTournamentStarts => 'Tempo prima dell\'inizio del torneo';

  @override
  String get averageCentipawnLoss => 'Centesimi di pedone persi in media';

  @override
  String get accuracy => 'Accuratezza';

  @override
  String get keyboardShortcuts => 'Scorciatoie da tastiera';

  @override
  String get keyMoveBackwardOrForward => 'muovi indietro/avanti';

  @override
  String get keyGoToStartOrEnd => 'vai all\'inizio/fine';

  @override
  String get keyCycleSelectedVariation => 'Cicla tra le varianti';

  @override
  String get keyShowOrHideComments => 'mostra/nascondi i commenti';

  @override
  String get keyEnterOrExitVariation => 'entra/esci dalla variante';

  @override
  String get keyRequestComputerAnalysis => 'Richiedi analisi del computer, Impara dai tuoi errori';

  @override
  String get keyNextLearnFromYourMistakes => 'Prossimo (Impara dai tuoi errori)';

  @override
  String get keyNextBlunder => 'Prossimo grave errore';

  @override
  String get keyNextMistake => 'Prossimo errore';

  @override
  String get keyNextInaccuracy => 'Prossima imprecisione';

  @override
  String get keyPreviousBranch => 'Variante precedente';

  @override
  String get keyNextBranch => 'Variante successiva';

  @override
  String get toggleVariationArrows => 'Mostra le frecce delle varianti';

  @override
  String get cyclePreviousOrNextVariation => 'Vai alla variante precedente/successiva';

  @override
  String get toggleGlyphAnnotations => 'Mostra i simboli delle annotazioni';

  @override
  String get togglePositionAnnotations => 'Mostra le annotazioni della posizione';

  @override
  String get variationArrowsInfo => 'Le frecce delle varianti ti permettono di esplorare le mosse senza usare la lista.';

  @override
  String get playSelectedMove => 'gioca la mossa selezionata';

  @override
  String get newTournament => 'Nuovo torneo';

  @override
  String get tournamentHomeTitle => 'Torneo con diversi controlli del tempo e varianti';

  @override
  String get tournamentHomeDescription => 'Partecipa a frenetici tornei di scacchi! Unisciti a un torneo ufficiale programmato o creane uno. Bullet, Blitz, Classical, Chess960, King of the Hill, Three-check e altre opzioni per un divertimento scacchistico senza fine.';

  @override
  String get tournamentNotFound => 'Torneo non trovato';

  @override
  String get tournamentDoesNotExist => 'Questo torneo non esiste.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Può essere stato annullato, se tutti i giocatori l\'hanno abbandonato prima che il torneo iniziasse.';

  @override
  String get returnToTournamentsHomepage => 'Torna alla pagina iniziale del torneo';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Distribuzione settimanale dei punteggi $param';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Il tuo punteggio $param1 è $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Giochi meglio del $param1 di giocatori $param2.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 è più forte del $param2 di giocatori $param3.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Meglio del $param1 dei giocatori $param2';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Non disponi di un punteggio $param consolidato.';
  }

  @override
  String get yourRating => 'Il tuo punteggio';

  @override
  String get cumulative => 'Percentile';

  @override
  String get glicko2Rating => 'Punteggio Glicko-2';

  @override
  String get checkYourEmail => 'Controlla la tua e-mail';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Ti abbiamo inviato un\'email. Clicca sul link nella mail per attivare il tuo account.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Se non vedi l\'e-mail, controlla la cartella spam o altre cartelle.';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Abbiamo inviato un\'email all\'indirizzo $param. Clicca sul link nell\'email per reimpostare la password.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Registrandoti, accetti i nostri $param';
  }

  @override
  String readAboutOur(String param) {
    return 'Leggi la nostra $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Ping tra te e Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Tempo per elaborare una mossa sul server di Lichess';

  @override
  String get downloadAnnotated => 'Scarica PGN annotato';

  @override
  String get downloadRaw => 'Scarica PGN senza annotazioni';

  @override
  String get downloadImported => 'Download importato';

  @override
  String get crosstable => 'Crosstable';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'È inoltre possibile scorrere sopra il bordo per entrare nel gioco.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scorri sulle varianti del computer per vederle in anteprima.';

  @override
  String get analysisShapesHowTo => 'Premere MAIUSC+click o tasto destro del mouse per disegnare cerchi e frecce sulla scacchiera.';

  @override
  String get letOtherPlayersMessageYou => 'Lascia che gli altri giocatori ti inviino messaggi';

  @override
  String get receiveForumNotifications => 'Ricevi notifiche quando vieni menzionato nel forum';

  @override
  String get shareYourInsightsData => 'Condividi i tuoi dati Insights';

  @override
  String get withNobody => 'Con nessuno';

  @override
  String get withFriends => 'Con gli amici';

  @override
  String get withEverybody => 'Con tutti';

  @override
  String get kidMode => 'Modalità bambino';

  @override
  String get kidModeIsEnabled => 'La modalità bambini è attiva.';

  @override
  String get kidModeExplanation => 'Questa modalità riguarda la sicurezza: in modalità bambino tutte le comunicazioni sono disabilitate. Si consiglia di attivare questa modalità per bambini e studenti, in modo da proteggerli dagli altri utenti.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'In \"modalità bambino\", al logo di lichess viene aggiunto $param, in questo modo sai che il bambino è sicuro.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Il tuo account è gestito esternamente. Chiedi al tuo istruttore di disattivare la \"modalità bambino\".';

  @override
  String get enableKidMode => 'Attiva \"modalità bambino\"';

  @override
  String get disableKidMode => 'Disattiva \"modalità bambino\"';

  @override
  String get security => 'Sicurezza';

  @override
  String get sessions => 'Sessioni';

  @override
  String get revokeAllSessions => 'rimuovi tutte le sessioni';

  @override
  String get playChessEverywhere => 'Gioca a scacchi ovunque';

  @override
  String get asFreeAsLichess => 'Gratuita, proprio come Lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Fatto per amore degli scacchi, non del denaro';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Tutti hanno le stesse funzionalità gratis';

  @override
  String get zeroAdvertisement => 'Nessuna pubblicità';

  @override
  String get fullFeatured => 'Senza limitazioni';

  @override
  String get phoneAndTablet => 'Cellulare e tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, classical';

  @override
  String get correspondenceChess => 'Scacchi per corrispondenza';

  @override
  String get onlineAndOfflinePlay => 'Gioca online e offline';

  @override
  String get viewTheSolution => 'Visualizza la soluzione';

  @override
  String get followAndChallengeFriends => 'Segui e sfida gli amici';

  @override
  String get gameAnalysis => 'Analisi partita';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 ospita $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 ha partecipato a $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return 'A $param1 piace $param2';
  }

  @override
  String get quickPairing => 'Accoppiamento rapido';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonimo';

  @override
  String yourScore(String param) {
    return 'Il tuo punteggio: $param';
  }

  @override
  String get language => 'Lingua';

  @override
  String get background => 'Sfondo';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get transparent => 'Trasparente';

  @override
  String get deviceTheme => 'Tema del dispositivo';

  @override
  String get backgroundImageUrl => 'URL dell\'immagine di sfondo:';

  @override
  String get board => 'Scacchiera';

  @override
  String get size => 'Grandezza';

  @override
  String get opacity => 'Opacità';

  @override
  String get brightness => 'Luminosità';

  @override
  String get hue => 'Hue';

  @override
  String get boardReset => 'Ripristina i colori predefiniti';

  @override
  String get pieceSet => 'Set pezzi';

  @override
  String get embedInYourWebsite => 'Incorpora nel tuo sito Web';

  @override
  String get usernameAlreadyUsed => 'Questo nome è già in uso. Prego sceglierne un altro.';

  @override
  String get usernamePrefixInvalid => 'Il nome utente deve iniziare con una lettera.';

  @override
  String get usernameSuffixInvalid => 'Il nome utente deve terminare con una lettera o un numero.';

  @override
  String get usernameCharsInvalid => 'Il nome utente deve contenere solo lettere, numeri, underscore e trattini.';

  @override
  String get usernameUnacceptable => 'Questo nome utente non è permesso.';

  @override
  String get playChessInStyle => 'Gioca a scacchi con stile';

  @override
  String get chessBasics => 'Basi scacchistiche';

  @override
  String get coaches => 'Istruttori';

  @override
  String get invalidPgn => 'PGN non valido';

  @override
  String get invalidFen => 'FEN non valido';

  @override
  String get custom => 'Personalizza';

  @override
  String get notifications => 'Notifiche';

  @override
  String notificationsX(String param1) {
    return 'Notifiche: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Punteggio: $param';
  }

  @override
  String get practiceWithComputer => 'Allenati contro il computer';

  @override
  String anotherWasX(String param) {
    return 'In alternativa $param';
  }

  @override
  String bestWasX(String param) {
    return 'Mossa migliore: $param';
  }

  @override
  String get youBrowsedAway => 'Ti sei allontanato';

  @override
  String get resumePractice => 'Riprendi la pratica';

  @override
  String get drawByFiftyMoves => 'La partita è patta per la regola delle 50 mosse.';

  @override
  String get theGameIsADraw => 'La partita è patta.';

  @override
  String get computerThinking => 'Il computer sta pensando...';

  @override
  String get seeBestMove => 'Scopri la mossa migliore';

  @override
  String get hideBestMove => 'Nascondi la mossa migliore';

  @override
  String get getAHint => 'Vuoi un suggerimento?';

  @override
  String get evaluatingYourMove => 'Valutazione della tua mossa in corso...';

  @override
  String get whiteWinsGame => 'Il Bianco vince';

  @override
  String get blackWinsGame => 'Il Nero vince';

  @override
  String get learnFromYourMistakes => 'Impara dai tuoi errori';

  @override
  String get learnFromThisMistake => 'Impara da questo errore';

  @override
  String get skipThisMove => 'Salta questa mossa';

  @override
  String get next => 'Successivo';

  @override
  String xWasPlayed(String param) {
    return 'Ultima mossa $param';
  }

  @override
  String get findBetterMoveForWhite => 'Trova una mossa migliore per il Bianco';

  @override
  String get findBetterMoveForBlack => 'Trova una mossa migliore per il Nero';

  @override
  String get resumeLearning => 'Continua ad imparare';

  @override
  String get youCanDoBetter => 'Puoi fare di meglio';

  @override
  String get tryAnotherMoveForWhite => 'Prova un\'altra mossa per il bianco';

  @override
  String get tryAnotherMoveForBlack => 'Prova un\'altra mossa per il nero';

  @override
  String get solution => 'Soluzione';

  @override
  String get waitingForAnalysis => 'In attesa dell\'analisi';

  @override
  String get noMistakesFoundForWhite => 'Nessun errore trovato per il bianco';

  @override
  String get noMistakesFoundForBlack => 'Nessun errore trovato per il nero';

  @override
  String get doneReviewingWhiteMistakes => 'Hai finito di rivedere gli errori del Bianco';

  @override
  String get doneReviewingBlackMistakes => 'Hai finito di rivedere gli errori del Nero';

  @override
  String get doItAgain => 'Rifallo';

  @override
  String get reviewWhiteMistakes => 'Analizza gli errori del Bianco';

  @override
  String get reviewBlackMistakes => 'Analizza gli errori del Nero';

  @override
  String get advantage => 'Vantaggio';

  @override
  String get opening => 'Apertura';

  @override
  String get middlegame => 'Mediogioco';

  @override
  String get endgame => 'Finale';

  @override
  String get conditionalPremoves => 'Premosse condizionali';

  @override
  String get addCurrentVariation => 'Aggiungi variazione corrente';

  @override
  String get playVariationToCreateConditionalPremoves => 'Gioca una variazione per creare premosse condizionali';

  @override
  String get noConditionalPremoves => 'Nessuna premossa condizionale';

  @override
  String playX(String param) {
    return 'Gioca $param';
  }

  @override
  String get showUnreadLichessMessage => 'Hai ricevuto un messaggio privato da Lichess.';

  @override
  String get clickHereToReadIt => 'Clicca qui per leggerlo';

  @override
  String get sorry => 'Ci dispiace :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Abbiamo dovuto bloccarti per un po\' di tempo.';

  @override
  String get why => 'Perché?';

  @override
  String get pleasantChessExperience => 'Vogliamo offrire a tutti una esperienza di scacchi piacevole.';

  @override
  String get goodPractice => 'A tal fine, dobbiamo assicurarci che tutti i giocatori si comportino bene.';

  @override
  String get potentialProblem => 'Quando notiamo un potenziale problema, mostriamo questo messaggio.';

  @override
  String get howToAvoidThis => 'Come evitare il blocco?';

  @override
  String get playEveryGame => 'Gioca ogni partita che inizi.';

  @override
  String get tryToWin => 'Impegnati a vincere (o almeno a pareggiare) ogni partita che giochi.';

  @override
  String get resignLostGames => 'Abbandona le partite perse (non far scorrere il tempo a vuoto).';

  @override
  String get temporaryInconvenience => 'Ci scusiamo per l\'inconveniente temporaneo,';

  @override
  String get wishYouGreatGames => 'e ti auguriamo partite memorabili su lichess.org.';

  @override
  String get thankYouForReading => 'Grazie per l\'attenzione!';

  @override
  String get lifetimeScore => 'Scontri diretti';

  @override
  String get currentMatchScore => 'Punteggio della partita attuale';

  @override
  String get agreementAssistance => 'Dichiaro di non farmi mai aiutare durante le mie partite (da computer, libri, database o altre persone).';

  @override
  String get agreementNice => 'Dichiaro di essere sempre rispettoso nei confronti degli altri giocatori.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Concordo che non creerò account multipli (tranne per le ragioni elencate nei $param).';
  }

  @override
  String get agreementPolicy => 'Dichiaro di acconsentire a tutte le politiche di Lichess.';

  @override
  String get searchOrStartNewDiscussion => 'Cerca o inizia una nuova conversazione';

  @override
  String get edit => 'Modifica';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Classical';

  @override
  String get ultraBulletDesc => 'Partite follemente veloci: meno di 30 secondi';

  @override
  String get bulletDesc => 'Partite molto veloci: meno di 3 minuti';

  @override
  String get blitzDesc => 'Partite veloci: da 3 a 8 minuti';

  @override
  String get rapidDesc => 'Partite rapide: da 8 a 25 minuti';

  @override
  String get classicalDesc => 'Partite classiche: 25 minuti e oltre';

  @override
  String get correspondenceDesc => 'Partite per corrispondenza: uno o più giorni per mossa';

  @override
  String get puzzleDesc => 'Allenamento sulle tattiche scacchistiche';

  @override
  String get important => 'Importante';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'La tua domanda potrebbe già avere una risposta $param1';
  }

  @override
  String get inTheFAQ => 'nelle F.A.Q.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Per segnalare un utente per imbrogli o comportamenti errati, $param1';
  }

  @override
  String get useTheReportForm => 'usa il modulo di rapporto';

  @override
  String toRequestSupport(String param1) {
    return 'Per richiedere supporto, $param1';
  }

  @override
  String get tryTheContactPage => 'prova la pagina dei contatti';

  @override
  String makeSureToRead(String param1) {
    return 'Assicurati di leggere $param1';
  }

  @override
  String get theForumEtiquette => 'le regole del forum';

  @override
  String get thisTopicIsArchived => 'Questo argomento è stato archiviato e non è più possibile rispondervi.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Iscriviti al team $param1, per postare in questo forum';
  }

  @override
  String teamNamedX(String param1) {
    return 'Squadra $param1';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Non puoi ancora postare nei forum. Gioca qualche partita!';

  @override
  String get subscribe => 'Iscriviti';

  @override
  String get unsubscribe => 'Annullare l\'iscrizione';

  @override
  String mentionedYouInX(String param1) {
    return 'ti ha menzionato in \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 ti ha citato in \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'ti ha invitato a \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 ti ha invitato a \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Ora fai parte del team.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Ti sei unito a \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Qualcuno che hai segnalato è stato bannato';

  @override
  String get congratsYouWon => 'Complimenti, hai vinto!';

  @override
  String gameVsX(String param1) {
    return 'Partita contro $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 contro $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Hai perso con qualcuno che ha violato i termini di servizio lichess';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Rimborso: $param1 $param2 punti di valutazione.';
  }

  @override
  String get timeAlmostUp => 'Il tempo è quasi finito!';

  @override
  String get clickToRevealEmailAddress => '[Clicca per mostrare l\'indirizzo email]';

  @override
  String get download => 'Download';

  @override
  String get coachManager => 'Gestore allenatore';

  @override
  String get streamerManager => 'Gestore streamer';

  @override
  String get cancelTournament => 'Annulla il torneo';

  @override
  String get tournDescription => 'Descrizione del torneo';

  @override
  String get tournDescriptionHelp => 'Qualcosa di speciale che vuoi dire ai partecipanti? Prova a mantenerla breve. I link di markdown sono disponibili: [name](https://url)';

  @override
  String get ratedFormHelp => 'Le partite sono valutate\ne impattano le valutazioni dei giocatori';

  @override
  String get onlyMembersOfTeam => 'Solo i membri della squadra';

  @override
  String get noRestriction => 'Nessuna restrizione';

  @override
  String get minimumRatedGames => 'Giochi votati al minimo';

  @override
  String get minimumRating => 'Valutazione minima';

  @override
  String get maximumWeeklyRating => 'Valutazione settimanale massima';

  @override
  String positionInputHelp(String param) {
    return 'Incolla un FEN valido per avviare ogni partita da una data posizione.\nFunziona solo per le partite standard, non con le varianti.\nPuoi usare $param per generare una posizione FEN, poi incollala qui.\nLascia vuoto per avviare le partite dalla posizione iniziale normale.';
  }

  @override
  String get cancelSimul => 'Annulla simulazione';

  @override
  String get simulHostcolor => 'Colore host per ogni partita';

  @override
  String get estimatedStart => 'Tempo di avvio stimato';

  @override
  String simulFeatured(String param) {
    return 'Mostra su $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Mostra la tua simulazione a tutti su $param. Disabilita per le simulazioni private.';
  }

  @override
  String get simulDescription => 'Descrizione della simulazione';

  @override
  String get simulDescriptionHelp => 'Vuoi dire qualcosa ai partecipanti?';

  @override
  String markdownAvailable(String param) {
    return '$param è disponibile per la sintassi più avanzata.';
  }

  @override
  String get embedsAvailable => 'Incolla l\'URL di un gioco o l\'URL di un capitolo di studio per incorporarlo.';

  @override
  String get inYourLocalTimezone => 'Nel tuo fuso orario locale';

  @override
  String get tournChat => 'Chat del torneo';

  @override
  String get noChat => 'Nessuna chat';

  @override
  String get onlyTeamLeaders => 'Solo leader della squadra';

  @override
  String get onlyTeamMembers => 'Solo membri della squadra';

  @override
  String get navigateMoveTree => 'Sfoglia l\'albero delle mosse';

  @override
  String get mouseTricks => 'Trucchi del mouse';

  @override
  String get toggleLocalAnalysis => 'Abilita/Disabilita le analisi del computer locali';

  @override
  String get toggleAllAnalysis => 'Abilita/Disabilita tutte le analisi del computer';

  @override
  String get playComputerMove => 'Gioca la migliore mossa del computer';

  @override
  String get analysisOptions => 'Opzioni d\'analisi';

  @override
  String get focusChat => 'Focalizza chat';

  @override
  String get showHelpDialog => 'Mostra questa finestra d\'aiuto';

  @override
  String get reopenYourAccount => 'Riapri il tuo account';

  @override
  String get closedAccountChangedMind => 'Se hai chiuso il tuo account, ma da allora hai cambiato idea, ottieni una possibilità di recuperare il tuo account.';

  @override
  String get onlyWorksOnce => 'Questo funzionerà una sola volta.';

  @override
  String get cantDoThisTwice => 'Se chiudi il tuo account una seconda volta, non ci sarà modo di recuperarlo.';

  @override
  String get emailAssociatedToaccount => 'Indirizzo email associato all\'account';

  @override
  String get sentEmailWithLink => 'Ti abbiamo inviato un\'email con un link.';

  @override
  String get tournamentEntryCode => 'Codice di accesso al torneo';

  @override
  String get hangOn => 'Aspetta!';

  @override
  String gameInProgress(String param) {
    return 'Hai una partita in corso con $param.';
  }

  @override
  String get abortTheGame => 'Annulla la partita';

  @override
  String get resignTheGame => 'Rinuncia alla partita';

  @override
  String get youCantStartNewGame => 'Non puoi avviare una nuova partita finché questa non è terminata.';

  @override
  String get since => 'Da';

  @override
  String get until => 'Fino al';

  @override
  String get lichessDbExplanation => 'Partite classificate di tutti i giocatori di Lichess';

  @override
  String get switchSides => 'Cambia colore';

  @override
  String get closingAccountWithdrawAppeal => 'Se cancelli il tuo account il tuo appello sarà ritirato';

  @override
  String get ourEventTips => 'I nostri consigli per organizzare eventi';

  @override
  String get instructions => 'Istruzioni';

  @override
  String get showMeEverything => 'Mostra tutto';

  @override
  String get lichessPatronInfo => 'Lichess è un software open source completamente gratuito e libero\nTutti i costi operativi, lo sviluppo e i contenuti sono finanziati esclusivamente dalle donazioni degli utenti.';

  @override
  String get nothingToSeeHere => 'Niente da vedere qui al momento.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il tuo avversario ha lasciato la partita. Puoi reclamare la vittoria fra $count secondi.',
      one: 'Il tuo avversario ha lasciato la partita. Puoi reclamare la vittoria fra $count secondo.',
      zero: 'Il tuo avversario ha lasciato la partita. Puoi reclamare la vittoria fra $count secondo.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matto in $count semi-mosse',
      one: 'Matto in $count semi-mossa',
      zero: 'Matto in $count semi-mossa',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errori gravi',
      one: '$count errore grave',
      zero: '$count errore grave',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errori',
      one: '$count errore',
      zero: '$count errore',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imprecisioni',
      one: '$count imprecisione',
      zero: '$count imprecisione',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giocatori collegati',
      one: '$count giocatore collegato',
      zero: '$count giocatore collegato',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partite',
      one: '$count partita',
      zero: '$count partita',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punti in $param2 partite',
      one: '$count punti in $param2 partite',
      zero: '$count punti in $param2 partite',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preferiti',
      one: '$count preferito',
      zero: '$count preferito',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: '$count giorno',
      zero: '$count giorno',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore',
      one: '$count ora',
      zero: '$count ora',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti',
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
      other: 'La posizione viene aggiornata ogni $count minuti',
      one: 'La posizione viene aggiornata ogni minuto',
      zero: 'La posizione viene aggiornata ogni minuto',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puzzle',
      one: '$count puzzle',
      zero: '$count puzzle',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giocate con te',
      one: '$count giocate con te',
      zero: '$count giocate con te',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classificate',
      one: '$count classificata',
      zero: '$count classificata',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vittorie',
      one: '$count vittoria',
      zero: '$count vittoria',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sconfitte',
      one: '$count sconfitta',
      zero: '$count sconfitta',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count patte',
      one: '$count patta',
      zero: '$count patta',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count in corso',
      one: '$count in corso',
      zero: '$count in corso',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Concedi $count secondi',
      one: 'Concedi $count secondo',
      zero: 'Concedi $count secondo',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punti di torneo',
      one: '$count punto di torneo',
      zero: '$count punto di torneo',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studi',
      one: '$count studio',
      zero: '$count studio',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count esibizioni simultanee',
      one: '$count esibizioni simultanee',
      zero: '$count esibizioni simultanee',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partite classificate',
      one: '≥ $count partita classificata',
      zero: '≥ $count partita classificata',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count partite $param2 classificate',
      one: '≥ $count partita $param2 classificata',
      zero: '≥ $count partita $param2 classificata',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ti mancano ancora $count partite $param2 classificate',
      one: 'Ti manca ancora $count partita $param2 classificata',
      zero: 'Ti manca ancora $count partita $param2 classificata',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ti mancano ancora $count partite classificate',
      one: 'Ti manca ancora $count partita classificata',
      zero: 'Ti manca ancora $count partita classificata',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partite importate',
      one: '$count partita importata',
      zero: '$count partita importata',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amici online',
      one: '$count amico online',
      zero: '$count amico online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lo seguono',
      one: '$count lo segue',
      zero: '$count lo segue',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count persone seguite',
      one: '$count persona seguita',
      zero: '$count persona seguita',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Meno di $count minuti',
      one: 'Meno di $count minuto',
      zero: 'Meno di $count minuto',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partite in gioco',
      one: '$count partita in gioco',
      zero: '$count partita in gioco',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Massimo: $count caratteri.',
      one: 'Massimo: $count carattere.',
      zero: 'Massimo: $count carattere.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giocatori bloccati',
      one: '$count giocatore bloccato',
      zero: '$count giocatore bloccato',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count post nel forum',
      one: '$count post nel forum',
      zero: '$count post nel forum',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giocatori $param2 questa settimana.',
      one: '$count giocatore $param2 questa settimana.',
      zero: '$count giocatore $param2 questa settimana.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Disponibile in $count lingue!',
      one: 'Disponibile in $count lingue!',
      zero: 'Disponibile in $count lingue!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count secondi per giocare la prima mossa',
      one: '$count secondi per giocare la prima mossa',
      zero: '$count secondi per giocare la prima mossa',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count secondi',
      one: '$count secondo',
      zero: '$count secondo',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'e salva $count linee pre-mossa',
      one: 'e salva $count linea pre-mossa',
      zero: 'e salva $count linea pre-mossa',
    );
    return '$_temp0';
  }

  @override
  String get patronDonate => 'Fai una donazione';

  @override
  String get patronLichessPatron => 'Patron di Lichess';

  @override
  String get preferencesPreferences => 'Preferenze';

  @override
  String get preferencesDisplay => 'Mostra';

  @override
  String get preferencesPrivacy => 'Privacy';

  @override
  String get preferencesNotifications => 'Notifiche';

  @override
  String get preferencesPieceAnimation => 'Animazione dei pezzi';

  @override
  String get preferencesMaterialDifference => 'Differenza di materiale';

  @override
  String get preferencesBoardHighlights => 'Segnalazioni sulla scacchiera (ultima mossa e scacco)';

  @override
  String get preferencesPieceDestinations => 'Destinazioni del pezzo (mosse e pre-mosse valide)';

  @override
  String get preferencesBoardCoordinates => 'Coordinate della scacchiera (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Lista delle mosse mentre giochi';

  @override
  String get preferencesPgnPieceNotation => 'Notazione mossa';

  @override
  String get preferencesChessPieceSymbol => 'Simbolo del pezzo';

  @override
  String get preferencesPgnLetter => 'Lettera (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Modalità Zen';

  @override
  String get preferencesShowPlayerRatings => 'Mostra punteggi giocatori';

  @override
  String get preferencesShowFlairs => 'Mostra le icone del giocatore';

  @override
  String get preferencesExplainShowPlayerRatings => 'Questa funzionalità permette di nascondere i punteggi dei giocatori per aiutare a concentrarti sulla partita. Le partite possono comunque essere classificate, questa impostazione riguarda solo ciò che vedi.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Mostra l\'icona di ridimensionamento della scacchiera';

  @override
  String get preferencesOnlyOnInitialPosition => 'Solo sulla posizione iniziale';

  @override
  String get preferencesInGameOnly => 'Solamente durante la partita';

  @override
  String get preferencesChessClock => 'Orologio';

  @override
  String get preferencesTenthsOfSeconds => 'Decimi di secondo';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Quando il tempo rimanente è < 10 secondi';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Barra verde orizzontale del tempo';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Suono quando sei a corto di tempo';

  @override
  String get preferencesGiveMoreTime => 'Dai più tempo';

  @override
  String get preferencesGameBehavior => 'Preferenze di gioco';

  @override
  String get preferencesHowDoYouMovePieces => 'Come vuoi muovere i pezzi?';

  @override
  String get preferencesClickTwoSquares => 'Clicca su due caselle';

  @override
  String get preferencesDragPiece => 'Trascina il pezzo';

  @override
  String get preferencesBothClicksAndDrag => 'Entrambi';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Pre-mosse (mentre tocca all\'avversario)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Ritiro della mossa (su accordo dell\'avversario)';

  @override
  String get preferencesInCasualGamesOnly => 'Solo nelle partite amichevoli';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promuovi a Donna automaticamente';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Tieni premuto il tasto <ctrl> durante la promozione per disabilitare temporaneamente la promozione automatica';

  @override
  String get preferencesWhenPremoving => 'Quando preseleziono una mossa';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Reclama patta automaticamente dopo triplice ripetizione';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Quando il tempo rimanente è < 30 secondi';

  @override
  String get preferencesMoveConfirmation => 'Conferma della mossa';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Può essere disabilitato durante una partita dal menu della scacchiera';

  @override
  String get preferencesInCorrespondenceGames => 'Partite per corrispondenza';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Corrispondenza e senza limiti di tempo';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Conferma abbandono e offerte di patta';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Metodo di arrocco';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Muovi il re di due caselle';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Muovi il re sopra la Torre';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Muovi utilizzando la tastiera';

  @override
  String get preferencesInputMovesWithVoice => 'Muovi con la tua voce';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Collega le frecce a mosse valide';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Di\' \"Good game, well played\" alla sconfitta o al pareggio';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Le tue preferenze sono state salvate.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Scorri sulla scacchiera per riprodurre le mosse';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Notifica di posta giornaliera che elenca le tue partite per corrispondenza';

  @override
  String get preferencesNotifyStreamStart => 'Lo streamer va in diretta';

  @override
  String get preferencesNotifyInboxMsg => 'Nuovo messaggio';

  @override
  String get preferencesNotifyForumMention => 'Un commento nel forum ti ha menzionato';

  @override
  String get preferencesNotifyInvitedStudy => 'Invito ad uno Studio';

  @override
  String get preferencesNotifyGameEvent => 'Aggiornamenti in una partita per corrispondenza';

  @override
  String get preferencesNotifyChallenge => 'Sfide';

  @override
  String get preferencesNotifyTournamentSoon => 'Il torneo sta per iniziare';

  @override
  String get preferencesNotifyTimeAlarm => 'Il tempo sta per scadere in una partita per corrispondenza';

  @override
  String get preferencesNotifyBell => 'Notifica sonora in Lichess';

  @override
  String get preferencesNotifyPush => 'Notifiche dispositivo (push) quando non sei collegato a Lichess';

  @override
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Dispositivo';

  @override
  String get preferencesBellNotificationSound => 'Tono notifica';

  @override
  String get puzzlePuzzles => 'Problemi';

  @override
  String get puzzlePuzzleThemes => 'Problemi a tema';

  @override
  String get puzzleRecommended => 'Consigliati';

  @override
  String get puzzlePhases => 'Fasi';

  @override
  String get puzzleMotifs => 'Temi';

  @override
  String get puzzleAdvanced => 'Avanzati';

  @override
  String get puzzleLengths => 'Per lunghezza';

  @override
  String get puzzleMates => 'Matti';

  @override
  String get puzzleGoals => 'Per obiettivo';

  @override
  String get puzzleOrigin => 'Per fonte';

  @override
  String get puzzleSpecialMoves => 'Mosse speciali';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Ti è piaciuto questo problema?';

  @override
  String get puzzleVoteToLoadNextOne => 'Vota per passare al prossimo!';

  @override
  String get puzzleUpVote => 'Valuta positivamente questo problema';

  @override
  String get puzzleDownVote => 'Valuta negativamente questo problema';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Il tuo punteggio per i problemi non cambierà. Nota che i problemi non sono competitivi. Il punteggio ci aiuta a selezionare i problemi migliori per il tuo livello di gioco.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Trova la mossa migliore per il bianco.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Trova la mossa migliore per il nero.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Per ottenere problemi personalizzati:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Problema $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Problema del giorno';

  @override
  String get puzzleDailyPuzzle => 'Tattica di oggi';

  @override
  String get puzzleClickToSolve => 'Clicca per provare a risolverla';

  @override
  String get puzzleGoodMove => 'Buona mossa';

  @override
  String get puzzleBestMove => 'La mossa migliore!';

  @override
  String get puzzleKeepGoing => 'Continua così…';

  @override
  String get puzzlePuzzleSuccess => 'Risolto!';

  @override
  String get puzzlePuzzleComplete => 'Problema completato!';

  @override
  String get puzzleByOpenings => 'Per apertura';

  @override
  String get puzzlePuzzlesByOpenings => 'Problemi ordinati per apertura';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Aperture che hai giocato di più nelle partite classificate';

  @override
  String get puzzleUseFindInPage => 'Usa \"Trova nella pagina\" nel menu del browser per trovare la tua apertura preferita!';

  @override
  String get puzzleUseCtrlF => 'Usa Ctrl+F per trovare la tua apertura preferita!';

  @override
  String get puzzleNotTheMove => 'Non è la mossa esatta!';

  @override
  String get puzzleTrySomethingElse => 'Prova qualcos\'altro.';

  @override
  String puzzleRatingX(String param) {
    return 'Punteggio: $param';
  }

  @override
  String get puzzleHidden => 'nascosto';

  @override
  String puzzleFromGameLink(String param) {
    return 'Dalla partita $param';
  }

  @override
  String get puzzleContinueTraining => 'Continua ad allenarti';

  @override
  String get puzzleDifficultyLevel => 'Livello di difficoltà';

  @override
  String get puzzleNormal => 'Normale';

  @override
  String get puzzleEasier => 'Facile';

  @override
  String get puzzleEasiest => 'Facilissimo';

  @override
  String get puzzleHarder => 'Difficile';

  @override
  String get puzzleHardest => 'Difficilissimo';

  @override
  String get puzzleExample => 'Esempio';

  @override
  String get puzzleAddAnotherTheme => 'Aggiungi un altro tema';

  @override
  String get puzzleNextPuzzle => 'Problema successivo';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Passa subito al problema successivo';

  @override
  String get puzzlePuzzleDashboard => 'I tuoi problemi';

  @override
  String get puzzleImprovementAreas => 'Aree di miglioramento';

  @override
  String get puzzleStrengths => 'Punti di forza';

  @override
  String get puzzleHistory => 'Cronologia dei problemi';

  @override
  String get puzzleSolved => 'risolto';

  @override
  String get puzzleFailed => 'sbagliato';

  @override
  String get puzzleStreakDescription => 'Risolvi problemi progressivamente più difficili e accumula una serie di vittorie. Non c\'è orologio, quindi fa\' con calma. Appena fai una mossa sbagliata è finita! Puoi saltare una mossa per sessione.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Punteggio: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Salta questa mossa per mantenere il punteggio! È possibile farlo solo una volta per sessione.';

  @override
  String get puzzleContinueTheStreak => 'Continua';

  @override
  String get puzzleNewStreak => 'Nuova sessione';

  @override
  String get puzzleFromMyGames => 'Dalle mie partite';

  @override
  String get puzzleLookupOfPlayer => 'Genera problemi dalle partite di un giocatore';

  @override
  String puzzleFromXGames(String param) {
    return 'Problema dalle partite di $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Cerca problemi';

  @override
  String get puzzleFromMyGamesNone => 'Nel database dei problemi di Lichess non è presente nessuna delle tue partite, ma Lichess ti vuole bene lo stesso.\nGioca altre partite rapide o classiche per aumentare le possibilità di avere un problema tratto dalle tue partite!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 problemi generati dalle partite di $param2';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Allenati, analizza, migliora';

  @override
  String puzzlePercentSolved(String param) {
    return '$param risolto';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Non c\'è niente qui. Prova prima a risolvere qualche problema!';

  @override
  String get puzzleImprovementAreasDescription => 'Addestrali per ottimizzare il tuo progresso!';

  @override
  String get puzzleStrengthDescription => 'Dai il meglio di te in questi temi';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Giocato $count volte',
      one: 'Giocato $count volte',
      zero: 'Giocato $count volte',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punti al di sotto del tuo punteggio per i problemi',
      one: 'Un punto al di sotto del tuo punteggio per i problemi',
      zero: 'Un punto al di sotto del tuo punteggio per i problemi',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punti al di sopra del tuo punteggio per i problemi',
      one: 'Un punto al di sopra del tuo punteggio per i problemi',
      zero: 'Un punto al di sopra del tuo punteggio per i problemi',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giocati',
      one: '$count giocato',
      zero: '$count giocato',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count da rigiocare',
      one: '$count da rigiocare',
      zero: '$count da rigiocare',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Pedone avanzato';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Un pedone che promuove o che minaccia di promuovere è la chiave della tattica.';

  @override
  String get puzzleThemeAdvantage => 'Vantaggio';

  @override
  String get puzzleThemeAdvantageDescription => 'Cogli l\'occasione per guadagnare un vantaggio decisivo. (200cp ≤ valutazione ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Matto di Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Un cavallo e una torre o una donna si coordinano nell\'intrappolare il re avversario tra un suo pezzo e il bordo della scacchiera.';

  @override
  String get puzzleThemeArabianMate => 'Matto arabo';

  @override
  String get puzzleThemeArabianMateDescription => 'Un cavallo e una torre si coordinano nell\'intrappolare il re avversario in un angolo della scacchiera.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Attacco su f2 o f7';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Un attacco incentrato sul pedone f2 o f7, come nell\'attacco Fegatello.';

  @override
  String get puzzleThemeAttraction => 'Adescamento';

  @override
  String get puzzleThemeAttractionDescription => 'Un cambio o un sacrificio che spinge o forza un pezzo avversario su una casa che consente una successiva tattica.';

  @override
  String get puzzleThemeBackRankMate => 'Matto del corridoio';

  @override
  String get puzzleThemeBackRankMateDescription => 'Matto al re sulla traversa di partenza, dove è intrappolato dai suoi stessi pezzi.';

  @override
  String get puzzleThemeBishopEndgame => 'Finale d\'alfiere';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Un finale con soli alfieri e pedoni.';

  @override
  String get puzzleThemeBodenMate => 'Matto di Boden';

  @override
  String get puzzleThemeBodenMateDescription => 'Due alfieri danno matto lungo diagonali perpendicolari ad un re ostruito dai suoi stessi pezzi.';

  @override
  String get puzzleThemeCastling => 'Arrocco';

  @override
  String get puzzleThemeCastlingDescription => 'Porta il re al sicuro, e sviluppa la torre per attaccare.';

  @override
  String get puzzleThemeCapturingDefender => 'Cattura del difensore';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Rimozione di un pezzo essenziale per la difesa di un altro pezzo, che permette al pezzo ora indifeso di essere catturato con una mossa successiva.';

  @override
  String get puzzleThemeCrushing => 'Posizione schiacciante';

  @override
  String get puzzleThemeCrushingDescription => 'Trova l\'errore grave del tuo avversario per ottenere un vantaggio schiacciante. (valutazione ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Matto dei due alfieri';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Due alfieri danno matto lungo diagonali adiacenti ad un re ostruito dai suoi stessi pezzi.';

  @override
  String get puzzleThemeDovetailMate => 'Matto a coda di rondine';

  @override
  String get puzzleThemeDovetailMateDescription => 'Una donna dà matto al re in una casa adiacente, mentre le due uniche case di fuga sono occupate da suoi pezzi.';

  @override
  String get puzzleThemeEquality => 'Parità';

  @override
  String get puzzleThemeEqualityDescription => 'Recupera una posizione persa e assicurati la patta o una posizione pari. (valutazione ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Attacco sull\'ala di re';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Un attacco al re avversario, dopo che ha arroccato corto.';

  @override
  String get puzzleThemeClearance => 'Sgombero';

  @override
  String get puzzleThemeClearanceDescription => 'Una mossa, spesso con tempo, che libera una casa, una colonna, una traversa o una diagonale per una successiva idea tattica.';

  @override
  String get puzzleThemeDefensiveMove => 'Mossa difensiva';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Una mossa precisa o una sequenza di mosse necessarie ad evitare perdite di materiale o di altri vantaggi.';

  @override
  String get puzzleThemeDeflection => 'Deviazione';

  @override
  String get puzzleThemeDeflectionDescription => 'Una mossa che rimuove un pezzo avversario da un compito, come ad esempio difendere una casa chiave.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Attacco di scoperta';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Mossa di un pezzo che precedentemente bloccava un attacco di un pezzo a lungo raggio, come ad esempio un cavallo che si sposta da una casa in fronte ad una torre.';

  @override
  String get puzzleThemeDoubleCheck => 'Doppio scacco';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Scacco con due pezzi contemporaneamente, conseguente a un attacco di scoperta in cui sia il pezzo appena mosso che il pezzo scoperto attaccano il re avversario.';

  @override
  String get puzzleThemeEndgame => 'Finale';

  @override
  String get puzzleThemeEndgameDescription => 'Una tattica durante l\'ultima fase della partita.';

  @override
  String get puzzleThemeEnPassantDescription => 'Una tattica che coinvolge la regola dell\'en passant, in cui un pedone può catturare un pedone avversario che l\'ha superato usando la propria mossa iniziale di due caselle.';

  @override
  String get puzzleThemeExposedKing => 'Re esposto';

  @override
  String get puzzleThemeExposedKingDescription => 'Una tattica che coinvolge un re con pochi difensori vicini, il che spesso porta al matto.';

  @override
  String get puzzleThemeFork => 'Attacco doppio';

  @override
  String get puzzleThemeForkDescription => 'Una mossa in cui un pezzo attacca due pezzi avversari contemporaneamente.';

  @override
  String get puzzleThemeHangingPiece => 'Pezzo in presa';

  @override
  String get puzzleThemeHangingPieceDescription => 'Una tattica che coinvolge un pezzo indifeso o insufficientemente difeso, e che dunque può essere catturato.';

  @override
  String get puzzleThemeHookMate => 'Matto dell\'uncino';

  @override
  String get puzzleThemeHookMateDescription => 'Matto con torre, cavallo e pedone, con un pedone avversario che ostruisce il suo re.';

  @override
  String get puzzleThemeInterference => 'Interposizione';

  @override
  String get puzzleThemeInterferenceDescription => 'Spostamento di un pezzo tra due pezzi avversari per lasciare uno o entrambi i pezzi nemici senza difesa, come ad esempio un cavallo difeso tra due torri.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription => 'Esecuzione, prima della mossa più naturale, di un\'altra mossa che pone una minaccia più immediata, alla quale l\'avversario deve necessariamente reagire. Conosciuto anche come \"Zwischenzug\" o \"Mossa intermedia\".';

  @override
  String get puzzleThemeKnightEndgame => 'Finale di cavallo';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Un finale con soli cavalli e pedoni.';

  @override
  String get puzzleThemeLong => 'Problema lungo';

  @override
  String get puzzleThemeLongDescription => 'Vittoria in tre mosse.';

  @override
  String get puzzleThemeMaster => 'Partite di Maestri';

  @override
  String get puzzleThemeMasterDescription => 'Problemi da partite giocate da scacchisti titolati.';

  @override
  String get puzzleThemeMasterVsMaster => 'Partite fra Maestri';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Problemi da partite giocate fra due scacchisti titolati.';

  @override
  String get puzzleThemeMate => 'Scacco matto';

  @override
  String get puzzleThemeMateDescription => 'Vinci la partita con stile.';

  @override
  String get puzzleThemeMateIn1 => 'Matto in 1';

  @override
  String get puzzleThemeMateIn1Description => 'Dai scacco matto in una mossa.';

  @override
  String get puzzleThemeMateIn2 => 'Matto in 2';

  @override
  String get puzzleThemeMateIn2Description => 'Dai scacco matto in due mosse.';

  @override
  String get puzzleThemeMateIn3 => 'Matto in 3';

  @override
  String get puzzleThemeMateIn3Description => 'Dai scacco matto in tre mosse.';

  @override
  String get puzzleThemeMateIn4 => 'Matto in 4';

  @override
  String get puzzleThemeMateIn4Description => 'Dai scacco matto in quattro mosse.';

  @override
  String get puzzleThemeMateIn5 => 'Matto in 5 o più mosse';

  @override
  String get puzzleThemeMateIn5Description => 'Trova una lunga sequenza di mosse per dare matto.';

  @override
  String get puzzleThemeMiddlegame => 'Mediogioco';

  @override
  String get puzzleThemeMiddlegameDescription => 'Una tattica durante la seconda fase della partita.';

  @override
  String get puzzleThemeOneMove => 'Problema da una mossa';

  @override
  String get puzzleThemeOneMoveDescription => 'Un problema lungo una sola mossa.';

  @override
  String get puzzleThemeOpening => 'Apertura';

  @override
  String get puzzleThemeOpeningDescription => 'Una tattica durante la prima fase della partita.';

  @override
  String get puzzleThemePawnEndgame => 'Finale di pedoni';

  @override
  String get puzzleThemePawnEndgameDescription => 'Un finale con soli pedoni.';

  @override
  String get puzzleThemePin => 'Inchiodatura';

  @override
  String get puzzleThemePinDescription => 'Una tattica in cui un pezzo non può muoversi senza scoprire un attacco ad un pezzo di maggior valore.';

  @override
  String get puzzleThemePromotion => 'Promozione';

  @override
  String get puzzleThemePromotionDescription => 'Un pedone che promuove o che minaccia di promuovere è la chiave della tattica.';

  @override
  String get puzzleThemeQueenEndgame => 'Finale di donna';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Un finale con sole donne e pedoni.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Finale di donna e torre';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Un finale con sole donne, torri e pedoni.';

  @override
  String get puzzleThemeQueensideAttack => 'Attacco sull\'ala di donna';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Un attacco al re avversario, dopo che ha arroccato lungo.';

  @override
  String get puzzleThemeQuietMove => 'Mossa calma';

  @override
  String get puzzleThemeQuietMoveDescription => 'Una mossa che non dà scacco e non cattura nulla, ma prepara una successiva minaccia inevitabile.';

  @override
  String get puzzleThemeRookEndgame => 'Finale di torre';

  @override
  String get puzzleThemeRookEndgameDescription => 'Un finale con sole torri e pedoni.';

  @override
  String get puzzleThemeSacrifice => 'Sacrificio';

  @override
  String get puzzleThemeSacrificeDescription => 'Una tattica che include la perdita di materiale nel breve termine per guadagnare un vantaggio dopo una serie di mosse forzate.';

  @override
  String get puzzleThemeShort => 'Problema breve';

  @override
  String get puzzleThemeShortDescription => 'Vittoria in due mosse.';

  @override
  String get puzzleThemeSkewer => 'Infilata';

  @override
  String get puzzleThemeSkewerDescription => 'Un tema che consiste in un pezzo di grande valore che viene attaccato e che si sposta, permettendo ad un pezzo dietro di esso di essere catturato o attaccato. Il contrario di un\'inchiodatura.';

  @override
  String get puzzleThemeSmotheredMate => 'Matto affogato';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Uno scacco matto eseguito con un cavallo, in cui il re sotto scacco è incapace di spostarsi poiché circondato (\"affogato\") dai suoi stessi pezzi.';

  @override
  String get puzzleThemeSuperGM => 'Partite di Super-GM';

  @override
  String get puzzleThemeSuperGMDescription => 'Problemi da partite giocate dai migliori giocatori al mondo.';

  @override
  String get puzzleThemeTrappedPiece => 'Pezzo intrappolato';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Un pezzo che non può evitare la cattura a causa delle sue mosse limitate.';

  @override
  String get puzzleThemeUnderPromotion => 'Sottopromozione';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promozione a cavallo, alfiere o torre.';

  @override
  String get puzzleThemeVeryLong => 'Problema lunghissimo';

  @override
  String get puzzleThemeVeryLongDescription => 'Vittoria in quattro o più mosse.';

  @override
  String get puzzleThemeXRayAttack => 'Attacco a raggi X';

  @override
  String get puzzleThemeXRayAttackDescription => 'Un pezzo che attacca o difende una casa attraverso un pezzo nemico.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription => 'L\'avversario è limitato nella sua scelta della mossa, e tutte le mosse possibili peggiorano la sua posizione.';

  @override
  String get puzzleThemeHealthyMix => 'Mix generale';

  @override
  String get puzzleThemeHealthyMixDescription => 'Un po\' di tutto. Nessuna aspettativa, affinché si possa rimanere pronti a qualsiasi cosa! Proprio come nelle partite vere.';

  @override
  String get puzzleThemePlayerGames => 'Partite tra giocatori';

  @override
  String get puzzleThemePlayerGamesDescription => 'Trova problemi tratti dalle tue partite o dalle partite di altri giocatori.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Questi problemi sono nel pubblico dominio e possono essere scaricati da $param.';
  }

  @override
  String perfStatPerfStats(String param) {
    return 'Statistiche di $param';
  }

  @override
  String get perfStatViewTheGames => 'Visualizza le partite';

  @override
  String get perfStatProvisional => 'provvisorio';

  @override
  String get perfStatNotEnoughRatedGames => 'Non sono state giocate abbastanza partite classificate per stabilire un punteggio affidabile.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Progresso nelle ultime $param partite:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Deviazione del punteggio: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Un valore inferiore indica che il punteggio è più stabile. Sopra $param1, il punteggio è considerato provvisorio. Per esser incluso nelle classifiche, questo valore dovrebbe essere inferiore a $param2 (scacchi standard) o $param3 (varianti).';
  }

  @override
  String get perfStatTotalGames => 'Partite totali';

  @override
  String get perfStatRatedGames => 'Partite classificate';

  @override
  String get perfStatTournamentGames => 'Partite di torneo';

  @override
  String get perfStatBerserkedGames => 'Partite in berserk';

  @override
  String get perfStatTimeSpentPlaying => 'Tempo trascorso giocando';

  @override
  String get perfStatAverageOpponent => 'Punteggio medio degli avversari';

  @override
  String get perfStatVictories => 'Vittorie';

  @override
  String get perfStatDefeats => 'Sconfitte';

  @override
  String get perfStatDisconnections => 'Disconnessioni';

  @override
  String get perfStatNotEnoughGames => 'Non ci sono abbastanza partite giocate';

  @override
  String perfStatHighestRating(String param) {
    return 'Punteggio più alto: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Punteggio più basso: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'da $param1 a $param2';
  }

  @override
  String get perfStatWinningStreak => 'Serie di vittorie';

  @override
  String get perfStatLosingStreak => 'Serie di sconfitte';

  @override
  String perfStatLongestStreak(String param) {
    return 'Serie più lunga: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Serie attuale: $param';
  }

  @override
  String get perfStatBestRated => 'Migliori vittorie classificate';

  @override
  String get perfStatGamesInARow => 'Partite giocate di fila';

  @override
  String get perfStatLessThanOneHour => 'Meno di un\'ora tra partite';

  @override
  String get perfStatMaxTimePlaying => 'Tempo massimo trascorso giocando';

  @override
  String get perfStatNow => 'ora';

  @override
  String get searchSearch => 'Cerca';

  @override
  String get settingsSettings => 'Impostazioni';

  @override
  String get settingsCloseAccount => 'Elimina account';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Il tuo account è gestito esternamente e non può essere chiuso.';

  @override
  String get settingsClosingIsDefinitive => 'L\'eliminazione dell\'account è definitiva. Una volta cancellato non è più possibile tornare indietro. Sei sicuro?';

  @override
  String get settingsCantOpenSimilarAccount => 'Non potrai creare un nuovo account con lo stesso nome, nemmeno con diverse maiuscole/minuscole.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Ci ho ripensato, non eliminare il mio account';

  @override
  String get settingsCloseAccountExplanation => 'Sei sicuro di voler eliminare il tuo account? L\'eliminazione del tuo account è un\'azione irreversibile. Non ti sarà MAI più possibile effettuare il login e la pagina del tuo profilo non sarà più accessibile.';

  @override
  String get settingsThisAccountIsClosed => 'Questo account è stato eliminato.';

  @override
  String get streamerLichessStreamers => 'Lichess streamer';

  @override
  String get stormMoveToStart => 'Fai una mossa per iniziare';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Muove il bianco in ogni problema';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Muove il nero in ogni problema';

  @override
  String get stormPuzzlesSolved => 'problemi risolti';

  @override
  String get stormNewDailyHighscore => 'Nuovo record di oggi!';

  @override
  String get stormNewWeeklyHighscore => 'Nuovo record della settimana!';

  @override
  String get stormNewMonthlyHighscore => 'Nuovo record del mese!';

  @override
  String get stormNewAllTimeHighscore => 'Nuovo record di sempre!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Il record precedente era $param';
  }

  @override
  String get stormPlayAgain => 'Gioca di nuovo';

  @override
  String stormHighscoreX(String param) {
    return 'Record: $param';
  }

  @override
  String get stormScore => 'Punteggio';

  @override
  String get stormMoves => 'Mosse';

  @override
  String get stormAccuracy => 'Precisione';

  @override
  String get stormCombo => 'Combo';

  @override
  String get stormTime => 'Tempo';

  @override
  String get stormTimePerMove => 'Tempo per mossa';

  @override
  String get stormHighestSolved => 'Più difficile risolto';

  @override
  String get stormPuzzlesPlayed => 'Problemi tentati';

  @override
  String get stormNewRun => 'Nuovo tentativo (scorciatoia da tastiera: Spazio)';

  @override
  String get stormEndRun => 'Termina tentativo (scorciatoia da tastiera: Invio)';

  @override
  String get stormHighscores => 'Record';

  @override
  String get stormViewBestRuns => 'Visualizza i migliori tentativi';

  @override
  String get stormBestRunOfDay => 'Migliore tentativo del giorno';

  @override
  String get stormRuns => 'Tentativi';

  @override
  String get stormGetReady => 'Preparati!';

  @override
  String get stormWaitingForMorePlayers => 'In attesa di altri giocatori...';

  @override
  String get stormRaceComplete => 'Traguardo!';

  @override
  String get stormSpectating => 'Spettatore';

  @override
  String get stormJoinTheRace => 'Unisciti alla gara!';

  @override
  String get stormStartTheRace => 'Avvia la gara';

  @override
  String stormYourRankX(String param) {
    return 'Piazzamento finale: $param';
  }

  @override
  String get stormWaitForRematch => 'Attendi la nuova gara';

  @override
  String get stormNextRace => 'Prossima gara';

  @override
  String get stormJoinRematch => 'Unisciti alla nuova gara';

  @override
  String get stormWaitingToStart => 'In attesa del via';

  @override
  String get stormCreateNewGame => 'Crea una nuova gara';

  @override
  String get stormJoinPublicRace => 'Partecipa a una gara pubblica';

  @override
  String get stormRaceYourFriends => 'Gareggia con i tuoi amici';

  @override
  String get stormSkip => 'salta';

  @override
  String get stormSkipHelp => 'Puoi saltare una mossa per gara:';

  @override
  String get stormSkipExplanation => 'Salta questa mossa per mantenere la combo! È possibile farlo solo una volta per gara.';

  @override
  String get stormFailedPuzzles => 'Problemi non risolti';

  @override
  String get stormSlowPuzzles => 'Problemi lenti';

  @override
  String get stormSkippedPuzzle => 'Problema saltato';

  @override
  String get stormThisWeek => 'Questa settimana';

  @override
  String get stormThisMonth => 'Questo mese';

  @override
  String get stormAllTime => 'Sempre';

  @override
  String get stormClickToReload => 'Clicca per ricaricare';

  @override
  String get stormThisRunHasExpired => 'Questa serie è scaduta!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Questa serie è stata aperta in un\'altra scheda!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentativi',
      one: '1 tentativo',
      zero: '1 tentativo',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha fatto $count tentativi di $param2',
      one: 'Ha fatto un tentativo di $param2',
      zero: 'Ha fatto un tentativo di $param2',
    );
    return '$_temp0';
  }

  @override
  String get studyShareAndExport => 'Condividi & esporta';

  @override
  String get studyStart => 'Inizia';
}
