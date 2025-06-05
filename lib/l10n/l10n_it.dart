// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get mobileAccountPreferences => 'Account preferences';

  @override
  String get mobileAccountPreferencesHelp =>
      'These preferences are applied to your account on the Lichess server and will be used across all devices.';

  @override
  String get mobileAllGames => 'Tutte le partite';

  @override
  String get mobileAreYouSure => 'Sei sicuro?';

  @override
  String get mobileBoardSettings => 'Board settings';

  @override
  String get mobileCancelTakebackOffer => 'Annulla richiesta di ritiro mossa';

  @override
  String get mobileClearButton => 'Elimina';

  @override
  String get mobileCorrespondenceClearSavedMove => 'Cancella mossa salvata';

  @override
  String get mobileCustomGameJoinAGame => 'Unisciti a una partita';

  @override
  String get mobileFeedbackButton => 'Suggerimenti';

  @override
  String mobileGoodEvening(String param) {
    return 'Good evening, $param';
  }

  @override
  String get mobileGoodEveningWithoutName => 'Good evening';

  @override
  String mobileGoodDay(String param) {
    return 'Good day, $param';
  }

  @override
  String get mobileGoodDayWithoutName => 'Good day';

  @override
  String get mobileHideVariation => 'Nascondi variante';

  @override
  String get mobileHomeTab => 'Home';

  @override
  String get mobileLiveStreamers => 'Streamer in diretta';

  @override
  String get mobileMustBeLoggedIn =>
      'Devi aver effettuato l\'accesso per visualizzare questa pagina.';

  @override
  String get mobileNoSearchResults => 'Nessun risultato';

  @override
  String get mobileNotFollowingAnyUser => 'Non stai seguendo nessun utente.';

  @override
  String get mobileOkButton => 'Ok';

  @override
  String get mobileOverTheBoard => 'Over the board';

  @override
  String mobilePlayersMatchingSearchTerm(String param) {
    return 'Giocatori con \"$param\"';
  }

  @override
  String get mobilePositionLeft => 'Left';

  @override
  String get mobilePositionRight => 'Right';

  @override
  String get mobilePrefMagnifyDraggedPiece => 'Ingrandisci il pezzo trascinato';

  @override
  String get mobilePuzzleStormConfirmEndRun => 'Vuoi terminare questa serie?';

  @override
  String get mobilePuzzleStormFilterNothingToShow =>
      'Nessun risultato, per favore modifica i filtri';

  @override
  String get mobilePuzzleStormNothingToShow =>
      'Niente da mostrare. Gioca ad alcune partite di Puzzle Storm.';

  @override
  String get mobilePuzzleStormSubtitle => 'Risolvi il maggior numero di puzzle in tre minuti.';

  @override
  String get mobilePuzzleStreakAbortWarning =>
      'Perderai la tua serie corrente e il tuo punteggio verrà salvato.';

  @override
  String get mobilePuzzleThemesSubtitle => '.';

  @override
  String get mobilePuzzlesTab => 'Tattiche';

  @override
  String get mobileRecentSearches => 'Ricerche recenti';

  @override
  String get mobileRemoveBookmark => 'Remove bookmark';

  @override
  String get mobileSettingsClockPosition => 'Clock position';

  @override
  String get mobileSettingsDraggedPieceTarget => 'Dragged piece target';

  @override
  String get mobileSettingsDraggedTargetCircle => 'Circle';

  @override
  String get mobileSettingsDraggedTargetSquare => 'Square';

  @override
  String get mobileSettingsHomeWidgets => 'Home widgets';

  @override
  String get mobileSettingsImmersiveMode => 'Modalità immersiva';

  @override
  String get mobileSettingsImmersiveModeSubtitle =>
      'Nascondi la UI di sistema mentre giochi. Attiva se i gesti di navigazione ai bordi dello schermo ti danno fastidio. Si applica alla schermata di gioco e Puzzle Storm.';

  @override
  String get mobileSettingsMaterialDifferenceCapturedPieces => 'Captured pieces';

  @override
  String get mobileSettingsPieceShiftMethodEither => 'Either tap or drag';

  @override
  String get mobileSettingsPieceShiftMethodTapTwoSquares => 'Tap two squares';

  @override
  String get mobileSettingsShapeDrawing => 'Shape drawing';

  @override
  String get mobileSettingsShapeDrawingSubtitle =>
      'Draw shapes using two fingers: maintain one finger on an empty square and drag another finger to draw a shape.';

  @override
  String get mobileSettingsTouchFeedback => 'Touch feedback';

  @override
  String get mobileSettingsTouchFeedbackSubtitle =>
      'When enabled, the device will vibrate shortly when you move or capture a piece.';

  @override
  String get mobileSettingsTab => 'Preferenze';

  @override
  String get mobileShareGamePGN => 'Condividi PGN';

  @override
  String get mobileShareGameURL => 'Condividi URL della partita';

  @override
  String get mobileSharePositionAsFEN => 'Condividi posizione come FEN';

  @override
  String get mobileSharePuzzle => 'Condividi questa tattica';

  @override
  String get mobileShowComments => 'Mostra commenti';

  @override
  String get mobileShowResult => 'Mostra il risultato';

  @override
  String get mobileShowVariations => 'Mostra varianti';

  @override
  String get mobileSomethingWentWrong => 'Si è verificato un errore.';

  @override
  String get mobileSystemColors => 'Tema app';

  @override
  String get mobileTapHereToStartPlayingChess => 'Tap here to start playing chess.';

  @override
  String get mobileTheme => 'Tema';

  @override
  String get mobileToolsTab => 'Strumenti';

  @override
  String mobileUnsupportedVariant(String param) {
    return 'Variant $param is not supported in this version';
  }

  @override
  String get mobileWaitingForOpponentToJoin => 'In attesa dell\'avversario...';

  @override
  String get mobileWatchTab => 'Guarda';

  @override
  String get mobileWelcomeToLichessApp => 'Welcome to Lichess app!';

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
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbVariantGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Partite $count $param2 per corrispondenza completate',
      one: 'Partita $count $param2 per corrispondenza completata',
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
    );
    return '$_temp0';
  }

  @override
  String get arenaArena => 'Arena';

  @override
  String get arenaArenaTournaments => 'Tornei arena';

  @override
  String get arenaIsItRated => 'Questo torneo è classificato?';

  @override
  String get arenaWillBeNotified =>
      'Riceverai una notifica quando il torneo inizierà. Durante l\'attesa puoi tranquillamente giocare in un\'altra scheda.';

  @override
  String get arenaIsRated => 'Questo torneo è classificato e influenzerà il tuo punteggio.';

  @override
  String get arenaIsNotRated =>
      'Questo torneo *non* è classificato e *non* influenzerà il tuo punteggio.';

  @override
  String get arenaSomeRated =>
      'Alcuni tornei sono classificati e pertanto influenzeranno il tuo punteggio.';

  @override
  String get arenaHowAreScoresCalculated => 'Come sono calcolati i punteggi del torneo?';

  @override
  String get arenaHowAreScoresCalculatedAnswer =>
      'Una vittoria ha un punteggio base di 2 punti, una patta 1 punto e una sconfitta 0 punti.\nSe vinci due partite consecutivamente, ogni partita successiva varrà il doppio dei punti rispetto al punteggio base. Ciò sarà indicato dall\'icona di una fiamma.\nIl raddoppio del punteggio significa che una vittoria varrà 4 punti, una patta 2 punti e una sconfitta 0.\n\nVittorie consecutive continueranno a dare il doppio punteggio.\nNon appena pareggi o perdi, il punteggio smetterà di essere raddoppiato.\n\nPer esempio:\n- Tre vittorie consecutive valgono 8 punti: 2 + 2 + (2 x 2)\n- Due vittorie, una patta e una vittoria valgono 8 punti: 2 + 2 + (2 x 1) + 2\n- Due vittorie, una sconfitta e una patta valgono 5 punti: 2 + 2 + (2 x 0) + 1';

  @override
  String get arenaBerserk => 'Arena Berserk';

  @override
  String get arenaBerserkAnswer =>
      'Quando un giocatore clicca sul pulsante Berserk, all\'inzio di una partita, il tempo a sua disposizione viene dimezzato, ma in caso di vittoria si otterrà un punto del torneo in più.\n\nInoltre, se la cadenza di gioco prevede un incremento, la modalità Berserk lo elimina. (1+2 diventa eccezionalmente 1+0 invece di ½+0).\n\nLa modalità Berserk non è disponibile per le partite senza un tempo iniziale (es. 0+1, 0+2).\n\nUna partita Berserk vinta varrà un punto in più solo se giocherai almeno 7 mosse.';

  @override
  String get arenaHowIsTheWinnerDecided => 'Come viene deciso il vincitore?';

  @override
  String get arenaHowIsTheWinnerDecidedAnswer =>
      'Saranno proclamati vincitori i tre giocatori che abbiano il maggior numero di punti allo scadere del tempo previsto per il torneo.\n\nSe due o più giocatori hanno lo stesso numero di punti, lo spareggio avverrà in base alla performance del torneo, valutata dal Tournament Performance Rating, calcolato come [Somma dei punteggi degli avversari + 400×(Vittorie - Sconfitte)] / Partite giocate.';

  @override
  String get arenaHowDoesPairingWork => 'Come funziona l\'accoppiamento?';

  @override
  String get arenaHowDoesPairingWorkAnswer =>
      'All\'inizio del torneo i giocatori sono accoppiati sulla base del loro punteggio individuale.\nNon appena finisci una partita, ritorna nella lobby del torneo e attendi: verrai nuovamente accoppiato con un altro giocatore con un punteggio simile al tuo. Il tempo di attesa è minimo; tuttavia, potresti non affrontare tutti i giocatori partecipanti al torneo.\nGioca in fretta e ritorna nella lobby per avere la possibilità di giocare più partite e ottenere più punti.';

  @override
  String get arenaHowDoesItEnd => 'Come finisce il torneo?';

  @override
  String get arenaHowDoesItEndAnswer =>
      'Il torneo ha un limite di tempo. Quando il tempo scade, le classifiche del torneo vengono bloccate e viene proclamato il vincitore. Le partite ancora in corso continueranno, ma non varranno ai fini del torneo.';

  @override
  String get arenaOtherRules => 'Altre regole importanti';

  @override
  String get arenaThereIsACountdown =>
      'Se non fai la prima mossa entro il conto alla rovescia, il tuo avversario vincerà la partita per forfait.';

  @override
  String get arenaThisIsPrivate => 'Questo torneo è privato';

  @override
  String arenaShareUrl(String param) {
    return 'Condividi questo URL per permettere alle persone di unirsi: $param';
  }

  @override
  String arenaDrawStreakStandard(String param) {
    return 'Serie di patte: quando un giocatore patta più partite consecutive, guadagnerà un punto solo per la prima patta o per patte in partite standard con almeno $param mosse. Una serie di patte termina solo con una vittoria, non con una sconfitta o una patta.';
  }

  @override
  String get arenaDrawStreakVariants =>
      'Il minimo numero di mosse necessarie affinché una partita patta valga dei punti varia in base alla variante. La tabella sotto elenca le soglie per ogni variante.';

  @override
  String get arenaVariant => 'Variante';

  @override
  String get arenaMinimumGameLength => 'Lunghezza minima della partita';

  @override
  String get arenaHistory => 'Cronologia dell\'Arena';

  @override
  String get arenaNewTeamBattle => 'Nuova Battaglia di Squadra';

  @override
  String get arenaCustomStartDate => 'Data iniziale personalizzata';

  @override
  String get arenaCustomStartDateHelp =>
      'Nel tuo fuso orario locale. Questo sovrascrive l\'impostazione \"Tempo prima dell\'inizio del torneo\"';

  @override
  String get arenaAllowBerserk => 'Consenti Berserk';

  @override
  String get arenaAllowBerserkHelp =>
      'Consenti ai giocatori di dimezzare il loro tempo d\'orologio per ottenere un punto extra';

  @override
  String get arenaAllowChatHelp => 'Consenti ai giocatori di discutere nella chat room';

  @override
  String get arenaArenaStreaks => 'Serie dell\'arena';

  @override
  String get arenaArenaStreaksHelp =>
      'Dopo 2 vittorie, le vittorie consecutive concedono 4 punti invece di 2.';

  @override
  String get arenaNoBerserkAllowed => 'Il Berserk non è permesso';

  @override
  String get arenaNoArenaStreaks => 'Arena senza Streak (punti per serie di vittorie)';

  @override
  String get arenaAveragePerformance => 'Prestazione media';

  @override
  String get arenaAverageScore => 'Punteggio medio';

  @override
  String get arenaMyTournaments => 'I miei tornei';

  @override
  String get arenaEditTournament => 'Modifica il torneo';

  @override
  String get arenaEditTeamBattle => 'Modifica battaglia a squadre';

  @override
  String get arenaDefender => 'Difensore';

  @override
  String get arenaPickYourTeam => 'Scegli la tua squadra';

  @override
  String get arenaWhichTeamWillYouRepresentInThisBattle =>
      'Quale squadra rappresenterai in questa battaglia?';

  @override
  String get arenaYouMustJoinOneOfTheseTeamsToParticipate =>
      'Devi unirti a una di queste squadre per partecipare!';

  @override
  String get arenaCreated => 'Creato';

  @override
  String get arenaRecentlyPlayed => 'Giocato recentemente';

  @override
  String get arenaBestResults => 'Risultati migliori';

  @override
  String get arenaTournamentStats => 'Statistiche torneo';

  @override
  String get arenaRankAvgHelp =>
      'La media del piazzamento è la percentuale del tuo piazzamento. Più è basso, più è meglio.\n\nPer esempio, essere classificato in 3ª posizione in un torneo di 100 giocatori = 3%. Essere classificato in 10ª posizione in un torneo di 1000 = 1%.';

  @override
  String get arenaMedians => 'mediane';

  @override
  String arenaAllAveragesAreX(String param) {
    return 'Tutte le medie in questa pagina sono $param.';
  }

  @override
  String get arenaTotal => 'Totale';

  @override
  String get arenaPointsAvg => 'Media punti';

  @override
  String get arenaPointsSum => 'Somma punti';

  @override
  String get arenaRankAvg => 'Media del piazzamento';

  @override
  String get arenaTournamentWinners => 'Vincitori torneo';

  @override
  String get arenaTournamentShields => 'Scudi torneo';

  @override
  String get arenaOnlyTitled => 'Solo giocatori intitolati';

  @override
  String get arenaOnlyTitledHelp => 'Richiedi un titolo ufficiale per partecipare al torneo';

  @override
  String get arenaTournamentPairingsAreNowClosed => 'Gli abbinamenti del torneo sono ora chiusi.';

  @override
  String get arenaBerserkRate => 'Percentuale Berserk';

  @override
  String arenaDrawingWithinNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Pattare la partita entro le prime $count mosse non assegnerà punti né a te né al tuo avversario.',
      one:
          'Pattare la partita entro la prima mossa non assegnerà punti né a te né al tuo avversario.',
    );
    return '$_temp0';
  }

  @override
  String arenaViewAllXTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Visualizza tutte le $count squadre',
      one: 'Visualizza la squadra',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Dirette';

  @override
  String get broadcastMyBroadcasts => 'Le mie trasmissioni';

  @override
  String get broadcastLiveBroadcasts => 'Tornei in diretta';

  @override
  String get broadcastBroadcastCalendar => 'Calendario trasmissioni';

  @override
  String get broadcastNewBroadcast => 'Nuova diretta';

  @override
  String get broadcastSubscribedBroadcasts => 'Trasmissioni abbonate';

  @override
  String get broadcastAboutBroadcasts => 'Informazioni sulle trasmissioni';

  @override
  String get broadcastHowToUseLichessBroadcasts => 'Istruzioni delle trasmissioni Lichess.';

  @override
  String get broadcastTheNewRoundHelp =>
      'Il nuovo turno avrà gli stessi membri e contributori del precedente.';

  @override
  String get broadcastAddRound => 'Aggiungi un turno';

  @override
  String get broadcastOngoing => 'In corso';

  @override
  String get broadcastUpcoming => 'Prossimamente';

  @override
  String get broadcastRoundName => 'Nome turno';

  @override
  String get broadcastRoundNumber => 'Turno numero';

  @override
  String get broadcastTournamentName => 'Nome del torneo';

  @override
  String get broadcastTournamentDescription => 'Breve descrizione dell\'evento';

  @override
  String get broadcastFullDescription => 'Descrizione completa dell\'evento';

  @override
  String broadcastFullDescriptionHelp(String param1, String param2) {
    return '(Facoltativo) Descrizione completa dell\'evento. $param1 è disponibile. La lunghezza deve essere inferiore a $param2 caratteri.';
  }

  @override
  String get broadcastSourceSingleUrl => 'Sorgente URL PGN';

  @override
  String get broadcastSourceUrlHelp =>
      'L\'URL che Lichess utilizzerà per ottenere gli aggiornamenti dei PGN. Deve essere accessibile pubblicamente su Internet.';

  @override
  String get broadcastSourceGameIds => 'Fino a 64 ID di partite Lichess, separati da spazi.';

  @override
  String broadcastStartDateTimeZone(String param) {
    return 'Data d\'inizio nel fuso orario locale del torneo: $param';
  }

  @override
  String get broadcastStartDateHelp => 'Facoltativo, se sai quando inizia l\'evento';

  @override
  String get broadcastCurrentGameUrl => 'URL della partita corrente';

  @override
  String get broadcastDownloadAllRounds => 'Scarica tutti i round';

  @override
  String get broadcastResetRound => 'Reimposta questo turno';

  @override
  String get broadcastDeleteRound => 'Elimina questo turno';

  @override
  String get broadcastDefinitivelyDeleteRound =>
      'Elimina definitivamente il turno e le sue partite.';

  @override
  String get broadcastDeleteAllGamesOfThisRound =>
      'Elimina tutte le partite di questo turno. L\'emittente dovrà essere attiva per poterli ricreare.';

  @override
  String get broadcastEditRoundStudy => 'Modifica lo studio del turno';

  @override
  String get broadcastDeleteTournament => 'Elimina questo torneo';

  @override
  String get broadcastDefinitivelyDeleteTournament =>
      'Elimina definitivamente l\'intero torneo, tutti i turni e tutte le partite.';

  @override
  String get broadcastShowScores =>
      'Mostra i punteggi dei giocatori in base ai risultati del gioco';

  @override
  String get broadcastReplacePlayerTags =>
      'Facoltativo: sostituisci i nomi dei giocatori, i punteggi e i titoli';

  @override
  String get broadcastFideFederations => 'Federazioni FIDE';

  @override
  String get broadcastTop10Rating => 'Migliori 10 punteggi';

  @override
  String get broadcastFidePlayers => 'Giocatori FIDE';

  @override
  String get broadcastFidePlayerNotFound => 'Giocatore FIDE non trovato';

  @override
  String get broadcastFideProfile => 'Profilo FIDE';

  @override
  String get broadcastFederation => 'Federazione';

  @override
  String get broadcastAgeThisYear => 'Età quest\'anno';

  @override
  String get broadcastUnrated => 'Non classificato';

  @override
  String get broadcastRecentTournaments => 'Tornei recenti';

  @override
  String get broadcastOpenLichess => 'Apri con Lichess';

  @override
  String get broadcastTeams => 'Squadre';

  @override
  String get broadcastBoards => 'Scacchiere';

  @override
  String get broadcastOverview => 'Panoramica';

  @override
  String get broadcastSubscribeTitle =>
      'Iscriviti per ricevere notifiche sull\'inizio di ogni round. Puoi attivare o disattivare la campanella o le notifiche push per le dirette nelle preferenze del tuo account.';

  @override
  String get broadcastUploadImage => 'Carica immagine del torneo';

  @override
  String get broadcastNoBoardsYet =>
      'Non sono ancora presenti scacchiere. Esse compariranno non appena i giochi saranno stati caricati.';

  @override
  String broadcastBoardsCanBeLoaded(String param) {
    return 'Le scacchiere possono essere caricate con una sorgente o tramite $param';
  }

  @override
  String broadcastStartsAfter(String param) {
    return 'Inizia tra $param';
  }

  @override
  String get broadcastStartVerySoon => 'Questa trasmissione inizierà a breve.';

  @override
  String get broadcastNotYetStarted => 'Questa trasmissione non è ancora cominciata.';

  @override
  String get broadcastOfficialWebsite => 'Sito web ufficiale';

  @override
  String get broadcastStandings => 'Classifica';

  @override
  String get broadcastOfficialStandings => 'Classifica Ufficiale';

  @override
  String broadcastIframeHelp(String param) {
    return 'Altre opzioni si trovano nella $param';
  }

  @override
  String get broadcastWebmastersPage => 'pagina dei gestori web';

  @override
  String broadcastPgnSourceHelp(String param) {
    return 'Una sorgente PGN pubblica per questo round. Viene offerta anche un\'$param per una sincronizzazione più rapida ed efficiente.';
  }

  @override
  String get broadcastEmbedThisBroadcast => 'Incorpora questa trasmissione nel tuo sito web';

  @override
  String broadcastEmbedThisRound(String param) {
    return 'Incorpora $param nel tuo sito web';
  }

  @override
  String get broadcastRatingDiff => 'Differenza di punteggio';

  @override
  String get broadcastGamesThisTournament => 'Partite in questo torneo';

  @override
  String get broadcastScore => 'Punteggio';

  @override
  String get broadcastAllTeams => 'Tutte le squadre';

  @override
  String get broadcastTournamentFormat => 'Formato del torneo';

  @override
  String get broadcastTournamentLocation => 'Luogo del Torneo';

  @override
  String get broadcastTopPlayers => 'Giocatori migliori';

  @override
  String get broadcastTimezone => 'Fuso orario';

  @override
  String get broadcastFideRatingCategory => 'Categoria di punteggio FIDE';

  @override
  String get broadcastOptionalDetails => 'Dettagli facoltativi';

  @override
  String get broadcastPastBroadcasts => 'Trasmissioni precedenti';

  @override
  String get broadcastAllBroadcastsByMonth => 'Visualizza tutte le trasmissioni per mese';

  @override
  String get broadcastBackToLiveMove => 'Torna alla mossa attuale';

  @override
  String get broadcastSinceHideResults =>
      'Poiché hai scelto di nascondere i risultati, tutte le schede di anteprima sono vuote per evitare spoiler.';

  @override
  String get broadcastLiveboard => 'Scacchiera in diretta';

  @override
  String broadcastNbBroadcasts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dirette',
      one: '$count diretta',
    );
    return '$_temp0';
  }

  @override
  String broadcastNbViewers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spettatori',
      one: '$count spettatore',
    );
    return '$_temp0';
  }

  @override
  String challengeChallengesX(String param1) {
    return 'Sfide: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Sfida a una partita';

  @override
  String get challengeChallengeDeclined => 'Sfida rifiutata';

  @override
  String get challengeChallengeAccepted => 'Sfida accettata!';

  @override
  String get challengeChallengeCanceled => 'Sfida annullata.';

  @override
  String get challengeRegisterToSendChallenges => 'Registrati per sfidare altri giocatori.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Non puoi sfidare $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param non accetta sfide.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Il tuo punteggio $param1 è troppo diverso da quello di $param2.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Non puoi inviare la sfida poiché hai ancora un punteggio $param provvisorio.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param accetta sfide solo da amici.';
  }

  @override
  String get challengeDeclineGeneric => 'Al momento non accetto sfide.';

  @override
  String get challengeDeclineLater => 'Non adesso, chiedimelo più tardi per favore.';

  @override
  String get challengeDeclineTooFast =>
      'Questa cadenza è troppo veloce per me, sfidami ad una partita più lenta per favore.';

  @override
  String get challengeDeclineTooSlow =>
      'Questa cadenza è troppo lenta per me, sfidami ad una partita più veloce per favore.';

  @override
  String get challengeDeclineTimeControl => 'Non accetto sfide con questa cadenza di tempo.';

  @override
  String get challengeDeclineRated => 'Mandami una sfida classificata per favore.';

  @override
  String get challengeDeclineCasual => 'Mandami una sfida amichevole per favore.';

  @override
  String get challengeDeclineStandard => 'Al momento non accetto sfide a varianti.';

  @override
  String get challengeDeclineVariant => 'Non voglio giocare a questa variante in questo momento.';

  @override
  String get challengeDeclineNoBot => 'Non accetto sfide da bot.';

  @override
  String get challengeDeclineOnlyBot => 'Accetto solo sfide da bot.';

  @override
  String get challengeInviteLichessUser => 'Oppure invita un utente di Lichess:';

  @override
  String get contactContact => 'Contattaci';

  @override
  String get contactContactLichess => 'Contatta Lichess';

  @override
  String get coordinatesCoordinates => 'Coordinate';

  @override
  String get coordinatesCoordinateTraining => 'Allenamento sulle coordinate';

  @override
  String coordinatesAverageScoreAsWhiteX(String param) {
    return 'Punteggio medio come bianco: $param';
  }

  @override
  String coordinatesAverageScoreAsBlackX(String param) {
    return 'Punteggio medio come nero: $param';
  }

  @override
  String get coordinatesKnowingTheChessBoard =>
      'Conoscere le coordinate della scacchiera è un\'abilità molto importante:';

  @override
  String get coordinatesMostChessCourses =>
      'La maggior parte dei corsi e degli esercizi utilizzano ampiamente la notazione algebrica.';

  @override
  String get coordinatesTalkToYourChessFriends =>
      'Rende più facile parlare di scacchi con i tuoi amici, dato che così entrambi ne conoscete il \"linguaggio\".';

  @override
  String get coordinatesYouCanAnalyseAGameMoreEffectively =>
      'Puoi analizzare le partite con più efficacia se non hai bisogno di cercare di volta in volta le coordinate di ogni casa.';

  @override
  String get coordinatesACoordinateAppears =>
      'Una coordinata comparirà sulla scacchiera. Clicca sulla casella corrispondente.';

  @override
  String get coordinatesASquareIsHighlightedExplanation =>
      'Una casella sarà evidenziata sulla scacchiera e tu dovrai digitare le sue coordinate (es. \"e4\").';

  @override
  String get coordinatesYouHaveThirtySeconds =>
      'Hai 30 secondi per identificare correttamente più coordinate possibili!';

  @override
  String get coordinatesGoAsLongAsYouWant =>
      'Continua fin quando vuoi, non c\'è alcun limite di tempo!';

  @override
  String get coordinatesShowCoordinates => 'Mostra le coordinate';

  @override
  String get coordinatesShowCoordsOnAllSquares => 'Coordinate su tutte le case';

  @override
  String get coordinatesShowPieces => 'Mostra i pezzi';

  @override
  String get coordinatesStartTraining => 'Inizia l\'allenamento';

  @override
  String get coordinatesFindSquare => 'Trova la casella';

  @override
  String get coordinatesNameSquare => 'Identifica la casa';

  @override
  String get coordinatesPracticeOnlySomeFilesAndRanks =>
      'Fai pratica solo con alcune righe & colonne';

  @override
  String get patronDonate => 'Fai una donazione';

  @override
  String get patronLichessPatron => 'Patron di Lichess';

  @override
  String perfStatPerfStats(String param) {
    return 'Statistiche di $param';
  }

  @override
  String get perfStatViewTheGames => 'Visualizza le partite';

  @override
  String get perfStatProvisional => 'provvisorio';

  @override
  String get perfStatNotEnoughRatedGames =>
      'Non sono state giocate abbastanza partite classificate per stabilire un punteggio affidabile.';

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
  String get preferencesExplainShowPlayerRatings =>
      'Questa funzionalità permette di nascondere i punteggi dei giocatori per aiutare a concentrarti sulla partita. Le partite possono comunque essere classificate, questa impostazione riguarda solo ciò che vedi.';

  @override
  String get preferencesDisplayBoardResizeHandle =>
      'Mostra l\'icona di ridimensionamento della scacchiera';

  @override
  String get preferencesOnlyOnInitialPosition => 'Solo sulla posizione iniziale';

  @override
  String get preferencesInGameOnly => 'Solamente durante la partita';

  @override
  String get preferencesExceptInGame => 'Tranne quando in gioco';

  @override
  String get preferencesChessClock => 'Orologio';

  @override
  String get preferencesTenthsOfSeconds => 'Decimi di secondo';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds =>
      'Quando il tempo rimanente è < 10 secondi';

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
  String get preferencesPremovesPlayingDuringOpponentTurn =>
      'Pre-mosse (mentre tocca all\'avversario)';

  @override
  String get preferencesTakebacksWithOpponentApproval =>
      'Ritiro della mossa (su accordo dell\'avversario)';

  @override
  String get preferencesInCasualGamesOnly => 'Solo nelle partite amichevoli';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Promuovi a Donna automaticamente';

  @override
  String get preferencesExplainPromoteToQueenAutomatically =>
      'Tieni premuto il tasto <ctrl> durante la promozione per disabilitare temporaneamente la promozione automatica';

  @override
  String get preferencesWhenPremoving => 'Quando preseleziono una mossa';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically =>
      'Reclama patta automaticamente dopo triplice ripetizione';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds =>
      'Quando il tempo rimanente è < 30 secondi';

  @override
  String get preferencesMoveConfirmation => 'Conferma della mossa';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled =>
      'Può essere disabilitato durante una partita dal menu della scacchiera';

  @override
  String get preferencesInCorrespondenceGames => 'Partite per corrispondenza';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Corrispondenza e senza limiti di tempo';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Conferma abbandono e offerte di patta';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Modalità di arrocco';

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
  String get preferencesSayGgWpAfterLosingOrDrawing =>
      'Di\' \"Good game, well played\" alla sconfitta o al pareggio';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Le tue preferenze sono state salvate.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves =>
      'Scorri sulla scacchiera per riprodurre le mosse';

  @override
  String get preferencesCorrespondenceEmailNotification =>
      'Notifica di posta giornaliera che elenca le tue partite per corrispondenza';

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
  String get preferencesNotifyTimeAlarm =>
      'Il tempo sta per scadere in una partita per corrispondenza';

  @override
  String get preferencesNotifyBell => 'Notifica sonora in Lichess';

  @override
  String get preferencesNotifyPush =>
      'Notifiche dispositivo (push) quando non sei collegato a Lichess';

  @override
  String get preferencesNotifyWeb => 'Browser';

  @override
  String get preferencesNotifyDevice => 'Dispositivo';

  @override
  String get preferencesBellNotificationSound => 'Tono notifica';

  @override
  String get preferencesBlindfold => 'Alla cieca';

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
  String get puzzleYourPuzzleRatingWillNotChange =>
      'Il tuo punteggio per i problemi non cambierà. Nota che i problemi non sono competitivi. Il punteggio ci aiuta a selezionare i problemi migliori per il tuo livello di gioco.';

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
  String get puzzleOpeningsYouPlayedTheMost =>
      'Aperture che hai giocato di più nelle partite classificate';

  @override
  String get puzzleUseFindInPage =>
      'Usa \"Trova nella pagina\" nel menu del browser per trovare la tua apertura preferita!';

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
  String get puzzleStreakDescription =>
      'Risolvi problemi progressivamente più difficili e accumula una serie di vittorie. Non c\'è orologio, quindi fa\' con calma. Appena fai una mossa sbagliata è finita! Puoi saltare una mossa per sessione.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Punteggio: $param';
  }

  @override
  String get puzzleStreakSkipExplanation =>
      'Salta questa mossa per mantenere il punteggio! È possibile farlo solo una volta per sessione.';

  @override
  String get puzzleContinueTheStreak => 'Continua';

  @override
  String get puzzleNewStreak => 'Nuova sessione';

  @override
  String get puzzleFromMyGames => 'Dalle mie partite';

  @override
  String get puzzleLookupOfPlayer => 'Genera problemi dalle partite di un giocatore';

  @override
  String get puzzleSearchPuzzles => 'Cerca problemi';

  @override
  String get puzzleFromMyGamesNone =>
      'Nel database dei problemi di Lichess non è presente nessuna delle tue partite, ma Lichess ti vuole bene lo stesso.\nGioca altre partite rapide o classiche per aumentare le possibilità di avere un problema tratto dalle tue partite!';

  @override
  String get puzzlePuzzleDashboardDescription => 'Allenati, analizza, migliora';

  @override
  String puzzlePercentSolved(String param) {
    return '$param risolto';
  }

  @override
  String get puzzleNoPuzzlesToShow =>
      'Non c\'è niente qui. Prova prima a risolvere qualche problema!';

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
    );
    return '$_temp0';
  }

  @override
  String puzzlePuzzlesFoundInUserGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count esercizi di tattica trovati nelle partite di $param2',
      one: 'Un esercizio di tattica trovato nelle partite di $param2',
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
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Pedone avanzato';

  @override
  String get puzzleThemeAdvancedPawnDescription =>
      'Un pedone che promuove o che minaccia di promuovere è la chiave della tattica.';

  @override
  String get puzzleThemeAdvantage => 'Vantaggio';

  @override
  String get puzzleThemeAdvantageDescription =>
      'Cogli l\'occasione per guadagnare un vantaggio decisivo. (200cp ≤ valutazione ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Matto di Anastasia';

  @override
  String get puzzleThemeAnastasiaMateDescription =>
      'Un cavallo e una torre o una donna si coordinano nell\'intrappolare il re avversario tra un suo pezzo e il bordo della scacchiera.';

  @override
  String get puzzleThemeArabianMate => 'Matto arabo';

  @override
  String get puzzleThemeArabianMateDescription =>
      'Un cavallo e una torre si coordinano nell\'intrappolare il re avversario in un angolo della scacchiera.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Attacco su f2 o f7';

  @override
  String get puzzleThemeAttackingF2F7Description =>
      'Un attacco incentrato sul pedone f2 o f7, come nell\'attacco Fegatello.';

  @override
  String get puzzleThemeAttraction => 'Adescamento';

  @override
  String get puzzleThemeAttractionDescription =>
      'Un cambio o un sacrificio che spinge o forza un pezzo avversario su una casa che consente una successiva tattica.';

  @override
  String get puzzleThemeBackRankMate => 'Matto del corridoio';

  @override
  String get puzzleThemeBackRankMateDescription =>
      'Matto al re sulla traversa di partenza, dove è intrappolato dai suoi stessi pezzi.';

  @override
  String get puzzleThemeBishopEndgame => 'Finale d\'alfiere';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Un finale con soli alfieri e pedoni.';

  @override
  String get puzzleThemeBodenMate => 'Matto di Boden';

  @override
  String get puzzleThemeBodenMateDescription =>
      'Due alfieri danno matto lungo diagonali perpendicolari ad un re ostruito dai suoi stessi pezzi.';

  @override
  String get puzzleThemeCastling => 'Arrocco';

  @override
  String get puzzleThemeCastlingDescription =>
      'Porta il re al sicuro, e sviluppa la torre per attaccare.';

  @override
  String get puzzleThemeCapturingDefender => 'Cattura del difensore';

  @override
  String get puzzleThemeCapturingDefenderDescription =>
      'Rimozione di un pezzo essenziale per la difesa di un altro pezzo, che permette al pezzo ora indifeso di essere catturato con una mossa successiva.';

  @override
  String get puzzleThemeCrushing => 'Posizione schiacciante';

  @override
  String get puzzleThemeCrushingDescription =>
      'Trova l\'errore grave del tuo avversario per ottenere un vantaggio schiacciante. (valutazione ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Matto dei due alfieri';

  @override
  String get puzzleThemeDoubleBishopMateDescription =>
      'Due alfieri danno matto lungo diagonali adiacenti ad un re ostruito dai suoi stessi pezzi.';

  @override
  String get puzzleThemeDovetailMate => 'Matto a coda di rondine';

  @override
  String get puzzleThemeDovetailMateDescription =>
      'Una donna dà matto al re in una casa adiacente, mentre le due uniche case di fuga sono occupate da suoi pezzi.';

  @override
  String get puzzleThemeEquality => 'Parità';

  @override
  String get puzzleThemeEqualityDescription =>
      'Recupera una posizione persa e assicurati la patta o una posizione pari. (valutazione ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Attacco sull\'ala di re';

  @override
  String get puzzleThemeKingsideAttackDescription =>
      'Un attacco al re avversario, dopo che ha arroccato corto.';

  @override
  String get puzzleThemeClearance => 'Sgombero';

  @override
  String get puzzleThemeClearanceDescription =>
      'Una mossa, spesso con tempo, che libera una casa, una colonna, una traversa o una diagonale per una successiva idea tattica.';

  @override
  String get puzzleThemeDefensiveMove => 'Mossa difensiva';

  @override
  String get puzzleThemeDefensiveMoveDescription =>
      'Una mossa precisa o una sequenza di mosse necessarie ad evitare perdite di materiale o di altri vantaggi.';

  @override
  String get puzzleThemeDeflection => 'Deviazione';

  @override
  String get puzzleThemeDeflectionDescription =>
      'Una mossa che rimuove un pezzo avversario da un compito, come ad esempio difendere una casa chiave.';

  @override
  String get puzzleThemeDiscoveredAttack => 'Attacco di scoperta';

  @override
  String get puzzleThemeDiscoveredAttackDescription =>
      'Mossa di un pezzo che precedentemente bloccava un attacco di un pezzo a lungo raggio, come ad esempio un cavallo che si sposta da una casa in fronte ad una torre.';

  @override
  String get puzzleThemeDoubleCheck => 'Doppio scacco';

  @override
  String get puzzleThemeDoubleCheckDescription =>
      'Scacco con due pezzi contemporaneamente, conseguente a un attacco di scoperta in cui sia il pezzo appena mosso che il pezzo scoperto attaccano il re avversario.';

  @override
  String get puzzleThemeEndgame => 'Finale';

  @override
  String get puzzleThemeEndgameDescription => 'Una tattica durante l\'ultima fase della partita.';

  @override
  String get puzzleThemeEnPassantDescription =>
      'Una tattica che coinvolge la regola dell\'en passant, in cui un pedone può catturare un pedone avversario che l\'ha superato usando la propria mossa iniziale di due caselle.';

  @override
  String get puzzleThemeExposedKing => 'Re esposto';

  @override
  String get puzzleThemeExposedKingDescription =>
      'Una tattica che coinvolge un re con pochi difensori vicini, il che spesso porta al matto.';

  @override
  String get puzzleThemeFork => 'Attacco doppio';

  @override
  String get puzzleThemeForkDescription =>
      'Una mossa in cui un pezzo attacca due pezzi avversari contemporaneamente.';

  @override
  String get puzzleThemeHangingPiece => 'Pezzo in presa';

  @override
  String get puzzleThemeHangingPieceDescription =>
      'Una tattica che coinvolge un pezzo indifeso o insufficientemente difeso, e che dunque può essere catturato.';

  @override
  String get puzzleThemeHookMate => 'Matto dell\'uncino';

  @override
  String get puzzleThemeHookMateDescription =>
      'Matto con torre, cavallo e pedone, con un pedone avversario che ostruisce il suo re.';

  @override
  String get puzzleThemeInterference => 'Interposizione';

  @override
  String get puzzleThemeInterferenceDescription =>
      'Spostamento di un pezzo tra due pezzi avversari per lasciare uno o entrambi i pezzi nemici senza difesa, come ad esempio un cavallo difeso tra due torri.';

  @override
  String get puzzleThemeIntermezzo => 'Intermezzo';

  @override
  String get puzzleThemeIntermezzoDescription =>
      'Esecuzione, prima della mossa più naturale, di un\'altra mossa che pone una minaccia più immediata, alla quale l\'avversario deve necessariamente reagire. Conosciuto anche come \"Zwischenzug\" o \"Mossa intermedia\".';

  @override
  String get puzzleThemeKillBoxMate => 'Matto della scatola assassina';

  @override
  String get puzzleThemeKillBoxMateDescription =>
      'Una Torre è vicina al Re nemico e supportata da una Regina che blocca i quadrati di fuga del Re. La Torre e la Regina catturano il Re nemico in una \"scatola assassina\" 3 x 3.';

  @override
  String get puzzleThemeVukovicMate => 'Scacco matto Vukovic';

  @override
  String get puzzleThemeVukovicMateDescription =>
      'Una Torre e un Cavallo collaborano per fare scacco al Re. La Torre mette in scacco supportata da un terzo pezzo, e il Cavallo viene usato per bloccare i quadrati di fuga del Re.';

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
  String get puzzleThemeMasterVsMasterDescription =>
      'Problemi da partite giocate fra due scacchisti titolati.';

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
  String get puzzleThemeMiddlegameDescription =>
      'Una tattica durante la seconda fase della partita.';

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
  String get puzzleThemePinDescription =>
      'Una tattica in cui un pezzo non può muoversi senza scoprire un attacco ad un pezzo di maggior valore.';

  @override
  String get puzzleThemePromotion => 'Promozione';

  @override
  String get puzzleThemePromotionDescription =>
      'Un pedone che promuove o che minaccia di promuovere è la chiave della tattica.';

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
  String get puzzleThemeQueensideAttackDescription =>
      'Un attacco al re avversario, dopo che ha arroccato lungo.';

  @override
  String get puzzleThemeQuietMove => 'Mossa calma';

  @override
  String get puzzleThemeQuietMoveDescription =>
      'Una mossa che non dà scacco e non cattura nulla, ma prepara una successiva minaccia inevitabile.';

  @override
  String get puzzleThemeRookEndgame => 'Finale di torre';

  @override
  String get puzzleThemeRookEndgameDescription => 'Un finale con sole torri e pedoni.';

  @override
  String get puzzleThemeSacrifice => 'Sacrificio';

  @override
  String get puzzleThemeSacrificeDescription =>
      'Una tattica che include la perdita di materiale nel breve termine per guadagnare un vantaggio dopo una serie di mosse forzate.';

  @override
  String get puzzleThemeShort => 'Problema breve';

  @override
  String get puzzleThemeShortDescription => 'Vittoria in due mosse.';

  @override
  String get puzzleThemeSkewer => 'Infilata';

  @override
  String get puzzleThemeSkewerDescription =>
      'Un tema che consiste in un pezzo di grande valore che viene attaccato e che si sposta, permettendo ad un pezzo dietro di esso di essere catturato o attaccato. Il contrario di un\'inchiodatura.';

  @override
  String get puzzleThemeSmotheredMate => 'Matto affogato';

  @override
  String get puzzleThemeSmotheredMateDescription =>
      'Uno scacco matto eseguito con un cavallo, in cui il re sotto scacco è incapace di spostarsi poiché circondato (\"affogato\") dai suoi stessi pezzi.';

  @override
  String get puzzleThemeSuperGM => 'Partite di Super-GM';

  @override
  String get puzzleThemeSuperGMDescription =>
      'Problemi da partite giocate dai migliori giocatori al mondo.';

  @override
  String get puzzleThemeTrappedPiece => 'Pezzo intrappolato';

  @override
  String get puzzleThemeTrappedPieceDescription =>
      'Un pezzo che non può evitare la cattura a causa delle sue mosse limitate.';

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
  String get puzzleThemeXRayAttackDescription =>
      'Un pezzo che attacca o difende una casa attraverso un pezzo nemico.';

  @override
  String get puzzleThemeZugzwang => 'Zugzwang';

  @override
  String get puzzleThemeZugzwangDescription =>
      'L\'avversario è limitato nella sua scelta della mossa, e tutte le mosse possibili peggiorano la sua posizione.';

  @override
  String get puzzleThemeMix => 'Mix generale';

  @override
  String get puzzleThemeMixDescription =>
      'Un po\' di tutto. Nessuna aspettativa, affinché si possa rimanere pronti a qualsiasi cosa! Proprio come nelle partite vere.';

  @override
  String get puzzleThemePlayerGames => 'Partite tra giocatori';

  @override
  String get puzzleThemePlayerGamesDescription =>
      'Trova problemi tratti dalle tue partite o dalle partite di altri giocatori.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Questi problemi sono nel pubblico dominio e possono essere scaricati da $param.';
  }

  @override
  String get searchSearch => 'Cerca';

  @override
  String get settingsSettings => 'Impostazioni';

  @override
  String get settingsCloseAccount => 'Elimina account';

  @override
  String get settingsManagedAccountCannotBeClosed =>
      'Il tuo account è gestito esternamente e non può essere chiuso.';

  @override
  String get settingsCantOpenSimilarAccount =>
      'Non potrai creare un nuovo account con lo stesso nome, nemmeno con diverse maiuscole/minuscole.';

  @override
  String get settingsCancelKeepAccount => 'Annulla e mantieni il mio account';

  @override
  String get settingsCloseAccountAreYouSure => 'Vuoi veramente chiudere il tuo account?';

  @override
  String get settingsThisAccountIsClosed => 'Questo account è stato eliminato.';

  @override
  String get playWithAFriend => 'Play with a friend';

  @override
  String get playWithTheMachine => 'Play with the computer';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'To invite someone to play, give this URL';

  @override
  String get gameOver => 'Game Over';

  @override
  String get waitingForOpponent => 'Waiting for opponent';

  @override
  String get orLetYourOpponentScanQrCode => 'Or let your opponent scan this QR code';

  @override
  String get waiting => 'Waiting';

  @override
  String get yourTurn => 'Your turn';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 level $param2';
  }

  @override
  String get level => 'Level';

  @override
  String get strength => 'Strength';

  @override
  String get toggleTheChat => 'Toggle the chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Resign';

  @override
  String get checkmate => 'Checkmate';

  @override
  String get stalemate => 'Stalemate';

  @override
  String get white => 'White';

  @override
  String get black => 'Black';

  @override
  String get asWhite => 'as white';

  @override
  String get asBlack => 'as black';

  @override
  String get randomColor => 'Random side';

  @override
  String get createAGame => 'Create a game';

  @override
  String get createTheGame => 'Create the game';

  @override
  String get whiteIsVictorious => 'White is victorious';

  @override
  String get blackIsVictorious => 'Black is victorious';

  @override
  String get youPlayTheWhitePieces => 'You play the white pieces';

  @override
  String get youPlayTheBlackPieces => 'You play the black pieces';

  @override
  String get itsYourTurn => 'It\'s your turn!';

  @override
  String get cheatDetected => 'Cheat Detected';

  @override
  String get kingInTheCenter => 'King in the centre';

  @override
  String get threeChecks => 'Three checks';

  @override
  String get raceFinished => 'Race finished';

  @override
  String get variantEnding => 'Variant ending';

  @override
  String get newOpponent => 'New opponent';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou =>
      'Your opponent wants to play a new game with you';

  @override
  String get joinTheGame => 'Join the game';

  @override
  String get whitePlays => 'White to play';

  @override
  String get blackPlays => 'Black to play';

  @override
  String get opponentLeftChoices =>
      'Your opponent left the game. You can claim victory, call the game a draw, or wait.';

  @override
  String get forceResignation => 'Claim victory';

  @override
  String get forceDraw => 'Call draw';

  @override
  String get talkInChat => 'Please be nice in the chat!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou =>
      'The first person to come to this URL will play with you.';

  @override
  String get whiteResigned => 'White resigned';

  @override
  String get blackResigned => 'Black resigned';

  @override
  String get whiteLeftTheGame => 'White left the game';

  @override
  String get blackLeftTheGame => 'Black left the game';

  @override
  String get whiteDidntMove => 'White didn\'t move';

  @override
  String get blackDidntMove => 'Black didn\'t move';

  @override
  String get requestAComputerAnalysis => 'Request a computer analysis';

  @override
  String get computerAnalysis => 'Computer analysis';

  @override
  String get computerAnalysisAvailable => 'Computer analysis available';

  @override
  String get computerAnalysisDisabled => 'Computer analysis disabled';

  @override
  String get analysis => 'Analysis board';

  @override
  String depthX(String param) {
    return 'Depth $param';
  }

  @override
  String get usingServerAnalysis => 'Using server analysis';

  @override
  String get loadingEngine => 'Loading engine...';

  @override
  String get calculatingMoves => 'Calculating moves...';

  @override
  String get engineFailed => 'Error loading engine';

  @override
  String get cloudAnalysis => 'Cloud analysis';

  @override
  String get goDeeper => 'Go deeper';

  @override
  String get showThreat => 'Show threat';

  @override
  String get inLocalBrowser => 'in local browser';

  @override
  String get toggleLocalEvaluation => 'Toggle local evaluation';

  @override
  String get promoteVariation => 'Promote variation';

  @override
  String get makeMainLine => 'Make mainline';

  @override
  String get deleteFromHere => 'Delete from here';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Force variation';

  @override
  String get copyVariationPgn => 'Copy variation PGN';

  @override
  String get copyMainLinePgn => 'Copy mainline PGN';

  @override
  String get move => 'Move';

  @override
  String get variantLoss => 'Variant loss';

  @override
  String get variantWin => 'Variant win';

  @override
  String get insufficientMaterial => 'Insufficient material';

  @override
  String get pawnMove => 'Pawn move';

  @override
  String get capture => 'Capture';

  @override
  String get close => 'Close';

  @override
  String get winning => 'Winning';

  @override
  String get losing => 'Losing';

  @override
  String get drawn => 'Drawn';

  @override
  String get unknown => 'Unknown';

  @override
  String get database => 'Database';

  @override
  String get whiteDrawBlack => 'White / Draw / Black';

  @override
  String averageRatingX(String param) {
    return 'Average rating: $param';
  }

  @override
  String get recentGames => 'Recent games';

  @override
  String get topGames => 'Top games';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'OTB games of $param1+ FIDE-rated players from $param2 to $param3';
  }

  @override
  String get dtzWithRounding =>
      'DTZ50\'\' with rounding, based on number of half-moves until next capture or pawn move';

  @override
  String get noGameFound => 'No game found';

  @override
  String get maxDepthReached => 'Max depth reached!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu =>
      'Maybe include more games from the preferences menu?';

  @override
  String get openings => 'Openings';

  @override
  String get openingExplorer => 'Opening explorer';

  @override
  String get openingEndgameExplorer => 'Opening/endgame explorer';

  @override
  String xOpeningExplorer(String param) {
    return '$param opening explorer';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Play first opening/endgame-explorer move';

  @override
  String get winPreventedBy50MoveRule => 'Win prevented by 50-move rule';

  @override
  String get lossSavedBy50MoveRule => 'Loss prevented by 50-move rule';

  @override
  String get winOr50MovesByPriorMistake => 'Win or 50 moves by prior mistake';

  @override
  String get lossOr50MovesByPriorMistake => 'Loss or 50 moves by prior mistake';

  @override
  String get unknownDueToRounding =>
      'Win/loss only guaranteed if recommended tablebase line has been followed since the last capture or pawn move, due to possible rounding of DTZ values in Syzygy tablebases.';

  @override
  String get allSet => 'All set!';

  @override
  String get importPgn => 'Import PGN';

  @override
  String get delete => 'Delete';

  @override
  String get deleteThisImportedGame => 'Delete this imported game?';

  @override
  String get replayMode => 'Replay mode';

  @override
  String get realtimeReplay => 'Realtime';

  @override
  String get byCPL => 'By CPL';

  @override
  String get enable => 'Enable';

  @override
  String get bestMoveArrow => 'Best move arrow';

  @override
  String get showVariationArrows => 'Show variation arrows';

  @override
  String get evaluationGauge => 'Evaluation gauge';

  @override
  String get multipleLines => 'Multiple lines';

  @override
  String get cpus => 'CPUs';

  @override
  String get memory => 'Memory';

  @override
  String get infiniteAnalysis => 'Infinite analysis';

  @override
  String get removesTheDepthLimit => 'Removes the depth limit, and keeps your computer warm';

  @override
  String get blunder => 'Blunder';

  @override
  String get mistake => 'Mistake';

  @override
  String get inaccuracy => 'Inaccuracy';

  @override
  String get moveTimes => 'Move times';

  @override
  String get flipBoard => 'Flip board';

  @override
  String get threefoldRepetition => 'Threefold repetition';

  @override
  String get claimADraw => 'Claim a draw';

  @override
  String get drawClaimed => 'Draw claimed';

  @override
  String get offerDraw => 'Offer draw';

  @override
  String get draw => 'Draw';

  @override
  String get drawByMutualAgreement => 'Draw by mutual agreement';

  @override
  String get fiftyMovesWithoutProgress => 'Fifty moves without progress';

  @override
  String get currentGames => 'Current games';

  @override
  String joinedX(String param) {
    return 'Joined $param';
  }

  @override
  String get viewInFullSize => 'View in full size';

  @override
  String get logOut => 'Sign out';

  @override
  String get signIn => 'Sign in';

  @override
  String get rememberMe => 'Keep me logged in';

  @override
  String get youNeedAnAccountToDoThat => 'You need an account to do that';

  @override
  String get signUp => 'Register';

  @override
  String get computersAreNotAllowedToPlay =>
      'Computers and computer-assisted players are not allowed to play. Please do not get assistance from chess engines, databases, or from other players while playing. Also note that making multiple accounts is strongly discouraged and excessive multi-accounting will lead to being banned.';

  @override
  String get games => 'Games';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 posted in topic $param2';
  }

  @override
  String get latestForumPosts => 'Latest forum posts';

  @override
  String get players => 'Players';

  @override
  String get friends => 'Friends';

  @override
  String get otherPlayers => 'other players';

  @override
  String get discussions => 'Conversations';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get minutesPerSide => 'Minutes per side';

  @override
  String get variant => 'Variant';

  @override
  String get variants => 'Variants';

  @override
  String get timeControl => 'Time control';

  @override
  String get realTime => 'Real time';

  @override
  String get correspondence => 'Correspondence';

  @override
  String get daysPerTurn => 'Days per turn';

  @override
  String get oneDay => 'One day';

  @override
  String get time => 'Time';

  @override
  String get rating => 'Rating';

  @override
  String get ratingStats => 'Rating stats';

  @override
  String get username => 'User name';

  @override
  String get usernameOrEmail => 'User name or email';

  @override
  String get changeUsername => 'Change username';

  @override
  String get changeUsernameNotSame =>
      'Only the case of the letters can change. For example \"johndoe\" to \"JohnDoe\".';

  @override
  String get changeUsernameDescription =>
      'Change your username. This can only be done once and you are only allowed to change the case of the letters in your username.';

  @override
  String get signupUsernameHint =>
      'Make sure to choose a username that\'s appropriate for all ages. You cannot change it later and any accounts with inappropriate usernames will get closed!';

  @override
  String get signupEmailHint => 'We will only use it for password reset.';

  @override
  String get password => 'Password';

  @override
  String get changePassword => 'Change password';

  @override
  String get changeEmail => 'Change email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Password reset';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get error_weakPassword => 'This password is extremely common, and too easy to guess.';

  @override
  String get error_namePassword => 'Please don\'t use your username as your password.';

  @override
  String get blankedPassword =>
      'You have used the same password on another site, and that site has been compromised. To ensure the safety of your Lichess account, we need you to set a new password. Thank you for your understanding.';

  @override
  String get youAreLeavingLichess => 'You are leaving Lichess';

  @override
  String get neverTypeYourPassword => 'Never type your Lichess password on another site!';

  @override
  String proceedToX(String param) {
    return 'Proceed to $param';
  }

  @override
  String get passwordSuggestion =>
      'Do not set a password suggested by someone else. They will use it to steal your account.';

  @override
  String get emailSuggestion =>
      'Do not set an email address suggested by someone else. They will use it to steal your account.';

  @override
  String get emailConfirmHelp => 'Help with email confirmation';

  @override
  String get emailConfirmNotReceived => 'Didn\'t receive your confirmation email after signing up?';

  @override
  String get whatSignupUsername => 'What username did you use to sign up?';

  @override
  String usernameNotFound(String param) {
    return 'We couldn\'t find any user by this name: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'You can use this username to create a new account';

  @override
  String emailSent(String param) {
    return 'We have sent an email to $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'It can take some time to arrive.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Wait 5 minutes and refresh your email inbox.';

  @override
  String get checkSpamFolder =>
      'Also check your spam folder, it might end up there. If so, mark it as not spam.';

  @override
  String get emailForSignupHelp => 'If everything else fails, then send us this email:';

  @override
  String copyTextToEmail(String param) {
    return 'Copy and paste the above text and send it to $param';
  }

  @override
  String get waitForSignupHelp =>
      'We will come back to you shortly to help you complete your signup.';

  @override
  String accountConfirmed(String param) {
    return 'The user $param is successfully confirmed.';
  }

  @override
  String accountCanLogin(String param) {
    return 'You can login right now as $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'You do not need a confirmation email.';

  @override
  String accountClosed(String param) {
    return 'The account $param is closed.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'The account $param was registered without an email.';
  }

  @override
  String get rank => 'Rank';

  @override
  String rankX(String param) {
    return 'Rank: $param';
  }

  @override
  String get gamesPlayed => 'Games played';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get whiteTimeOut => 'White time out';

  @override
  String get blackTimeOut => 'Black time out';

  @override
  String get drawOfferSent => 'Draw offer sent';

  @override
  String get drawOfferAccepted => 'Draw offer accepted';

  @override
  String get drawOfferCanceled => 'Draw offer cancelled';

  @override
  String get whiteOffersDraw => 'White offers draw';

  @override
  String get blackOffersDraw => 'Black offers draw';

  @override
  String get whiteDeclinesDraw => 'White declines draw';

  @override
  String get blackDeclinesDraw => 'Black declines draw';

  @override
  String get yourOpponentOffersADraw => 'Your opponent offers a draw';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get playingRightNow => 'Playing right now';

  @override
  String get eventInProgress => 'Playing now';

  @override
  String get finished => 'Finished';

  @override
  String get abortGame => 'Abort game';

  @override
  String get gameAborted => 'Game aborted';

  @override
  String get standard => 'Standard';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get mode => 'Mode';

  @override
  String get casual => 'Casual';

  @override
  String get rated => 'Rated';

  @override
  String get casualTournament => 'Casual';

  @override
  String get ratedTournament => 'Rated';

  @override
  String get thisGameIsRated => 'This game is rated';

  @override
  String get rematch => 'Rematch';

  @override
  String get rematchOfferSent => 'Rematch offer sent';

  @override
  String get rematchOfferAccepted => 'Rematch offer accepted';

  @override
  String get rematchOfferCanceled => 'Rematch offer cancelled';

  @override
  String get rematchOfferDeclined => 'Rematch offer declined';

  @override
  String get cancelRematchOffer => 'Cancel rematch offer';

  @override
  String get viewRematch => 'View rematch';

  @override
  String get confirmMove => 'Confirm move';

  @override
  String get play => 'Play';

  @override
  String get inbox => 'Inbox';

  @override
  String get chatRoom => 'Chat room';

  @override
  String get loginToChat => 'Sign in to chat';

  @override
  String get youHaveBeenTimedOut => 'You have been timed out.';

  @override
  String get spectatorRoom => 'Spectator room';

  @override
  String get composeMessage => 'Compose message';

  @override
  String get subject => 'Subject';

  @override
  String get send => 'Send';

  @override
  String get incrementInSeconds => 'Increment in seconds';

  @override
  String get freeOnlineChess => 'Free Online Chess';

  @override
  String get exportGames => 'Export games';

  @override
  String get ratingRange => 'Rating range';

  @override
  String get thisAccountViolatedTos => 'This account violated the Lichess Terms of Service';

  @override
  String get openingExplorerAndTablebase => 'Opening explorer & tablebase';

  @override
  String get takeback => 'Takeback';

  @override
  String get proposeATakeback => 'Propose a takeback';

  @override
  String get whiteProposesTakeback => 'White proposes takeback';

  @override
  String get blackProposesTakeback => 'Black proposes takeback';

  @override
  String get takebackPropositionSent => 'Takeback sent';

  @override
  String get whiteDeclinesTakeback => 'White declines takeback';

  @override
  String get blackDeclinesTakeback => 'Black declines takeback';

  @override
  String get whiteAcceptsTakeback => 'White accepts takeback';

  @override
  String get blackAcceptsTakeback => 'Black accepts takeback';

  @override
  String get whiteCancelsTakeback => 'White cancels takeback';

  @override
  String get blackCancelsTakeback => 'Black cancels takeback';

  @override
  String get yourOpponentProposesATakeback => 'Your opponent proposes a takeback';

  @override
  String get bookmarkThisGame => 'Bookmark this game';

  @override
  String get tournament => 'Tournament';

  @override
  String get tournaments => 'Tournaments';

  @override
  String get tournamentPoints => 'Tournament points';

  @override
  String get viewTournament => 'View tournament';

  @override
  String get backToTournament => 'Back to tournament';

  @override
  String get noDrawBeforeSwissLimit =>
      'You cannot draw before 30 moves are played in a Swiss tournament.';

  @override
  String get thematic => 'Thematic';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Your $param rating is provisional';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Your $param1 rating ($param2) is too high';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Your top weekly $param1 rating ($param2) is too high';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Your $param1 rating ($param2) is too low';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return 'Rated ≥ $param1 in $param2';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return 'Rated ≤ $param1 in $param2 for the last week';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Must be in team $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'You are not in the team $param';
  }

  @override
  String get backToGame => 'Back to game';

  @override
  String get siteDescription =>
      'Free online chess server. Play chess in a clean interface. No registration, no ads, no plugin required. Play chess with the computer, friends or random opponents.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 joined team $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 created team $param2';
  }

  @override
  String get startedStreaming => 'started streaming';

  @override
  String xStartedStreaming(String param) {
    return '$param started streaming';
  }

  @override
  String get averageElo => 'Average rating';

  @override
  String get location => 'Location';

  @override
  String get filterGames => 'Filter games';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Submit';

  @override
  String get save => 'Save';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get screenshotCurrentPosition => 'Screenshot current position';

  @override
  String get gameAsGIF => 'Game as GIF';

  @override
  String get pasteTheFenStringHere => 'Paste the FEN text here';

  @override
  String get pasteThePgnStringHere => 'Paste the PGN text here';

  @override
  String get orUploadPgnFile => 'Or upload a PGN file';

  @override
  String get fromPosition => 'From position';

  @override
  String get continueFromHere => 'Continue from here';

  @override
  String get toStudy => 'Study';

  @override
  String get importGame => 'Import game';

  @override
  String get importGameExplanation =>
      'Paste a game PGN to get a browsable replay, computer analysis, game chat and public shareable URL.';

  @override
  String get importGameCaveat =>
      'Variations will be erased. To keep them, import the PGN via a study.';

  @override
  String get importGameDataPrivacyWarning =>
      'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'This is a chess CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove =>
      'Click on the board to make your move, and prove you are human.';

  @override
  String get captcha_fail => 'Please solve the chess captcha.';

  @override
  String get notACheckmate => 'Not a checkmate';

  @override
  String get whiteCheckmatesInOneMove => 'White to checkmate in one move';

  @override
  String get blackCheckmatesInOneMove => 'Black to checkmate in one move';

  @override
  String get retry => 'Retry';

  @override
  String get reconnecting => 'Reconnecting';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Favourite opponents';

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get unfollow => 'Unfollow';

  @override
  String followX(String param) {
    return 'Follow $param';
  }

  @override
  String unfollowX(String param) {
    return 'Unfollow $param';
  }

  @override
  String get block => 'Block';

  @override
  String get blocked => 'Blocked';

  @override
  String get unblock => 'Unblock';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 started following $param2';
  }

  @override
  String get more => 'More';

  @override
  String get memberSince => 'Member since';

  @override
  String lastSeenActive(String param) {
    return 'Active $param';
  }

  @override
  String get player => 'Player';

  @override
  String get list => 'List';

  @override
  String get graph => 'Graph';

  @override
  String get required => 'Required.';

  @override
  String get openTournaments => 'Open tournaments';

  @override
  String get duration => 'Duration';

  @override
  String get winner => 'Winner';

  @override
  String get standing => 'Standing';

  @override
  String get createANewTournament => 'Create a new tournament';

  @override
  String get tournamentCalendar => 'Tournament calendar';

  @override
  String get conditionOfEntry => 'Entry requirements:';

  @override
  String get advancedSettings => 'Advanced settings';

  @override
  String get safeTournamentName => 'Pick a very safe name for the tournament.';

  @override
  String get inappropriateNameWarning =>
      'Anything even slightly inappropriate could get your account closed.';

  @override
  String get emptyTournamentName =>
      'Leave empty to name the tournament after a notable chess player.';

  @override
  String get makePrivateTournament =>
      'Make the tournament private, and restrict access with a password';

  @override
  String get join => 'Join';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get points => 'Points';

  @override
  String get wins => 'Wins';

  @override
  String get losses => 'Losses';

  @override
  String get createdBy => 'Created by';

  @override
  String get startingIn => 'Starting in';

  @override
  String standByX(String param) {
    return 'Stand by $param, pairing players, get ready!';
  }

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get youArePlaying => 'You are playing!';

  @override
  String get winRate => 'Win rate';

  @override
  String get performance => 'Performance';

  @override
  String get tournamentComplete => 'Tournament complete';

  @override
  String get movesPlayed => 'Moves played';

  @override
  String get whiteWins => 'White wins';

  @override
  String get blackWins => 'Black wins';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Draws';

  @override
  String get averageOpponent => 'Average opponent';

  @override
  String get boardEditor => 'Board editor';

  @override
  String get setTheBoard => 'Set the board';

  @override
  String get popularOpenings => 'Popular openings';

  @override
  String get endgamePositions => 'Endgame positions';

  @override
  String chess960StartPosition(String param) {
    return 'Chess960 start position: $param';
  }

  @override
  String get startPosition => 'Starting position';

  @override
  String get clearBoard => 'Clear board';

  @override
  String get loadPosition => 'Load position';

  @override
  String get isPrivate => 'Private';

  @override
  String reportXToModerators(String param) {
    return 'Report $param to moderators';
  }

  @override
  String profileCompletion(String param) {
    return 'Profile completion: $param';
  }

  @override
  String xRating(String param) {
    return '$param rating';
  }

  @override
  String get ifNoneLeaveEmpty => 'If none, leave empty';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair =>
      'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Biography';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Thank you!';

  @override
  String get socialMediaLinks => 'Social media links';

  @override
  String get oneUrlPerLine => 'One URL per line.';

  @override
  String get inlineNotation => 'Inline notation';

  @override
  String get makeAStudy => 'For safekeeping and sharing, consider making a study.';

  @override
  String get clearSavedMoves => 'Clear moves';

  @override
  String get previouslyOnLichessTV => 'Previously on Lichess TV';

  @override
  String get onlinePlayers => 'Online players';

  @override
  String get activePlayers => 'Active players';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Beware, the game is rated but has no clock!';

  @override
  String get success => 'Success';

  @override
  String get automaticallyProceedToNextGameAfterMoving =>
      'Automatically proceed to next game after moving';

  @override
  String get autoSwitch => 'Auto switch';

  @override
  String get puzzles => 'Puzzles';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get descPrivate => 'Private description';

  @override
  String get descPrivateHelp =>
      'Text that only the team members will see. If set, replaces the public description for team members.';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get website => 'Website';

  @override
  String get mobile => 'Mobile';

  @override
  String get help => 'Help:';

  @override
  String get createANewTopic => 'Create a new topic';

  @override
  String get topics => 'Topics';

  @override
  String get posts => 'Posts';

  @override
  String get lastPost => 'Last post';

  @override
  String get views => 'Views';

  @override
  String get replies => 'Replies';

  @override
  String get replyToThisTopic => 'Reply to this topic';

  @override
  String get reply => 'Reply';

  @override
  String get message => 'Message';

  @override
  String get createTheTopic => 'Create the topic';

  @override
  String get reportAUser => 'Report a user';

  @override
  String get user => 'User';

  @override
  String get reason => 'Reason';

  @override
  String get whatIsIheMatter => 'What\'s the matter?';

  @override
  String get cheat => 'Cheat';

  @override
  String get troll => 'Troll';

  @override
  String get other => 'Other';

  @override
  String get reportCheatBoostHelp =>
      'Paste the link to the game(s) and explain what is wrong about this user\'s behaviour. Don\'t just say \"they cheat\", but tell us how you came to this conclusion.';

  @override
  String get reportUsernameHelp =>
      'Explain what about this username is offensive. Don\'t just say \"it\'s offensive/inappropriate\", but tell us how you came to this conclusion, especially if the insult is obfuscated, not in english, is in slang, or is a historical/cultural reference.';

  @override
  String get reportProcessedFasterInEnglish =>
      'Your report will be processed faster if written in English.';

  @override
  String get error_provideOneCheatedGameLink =>
      'Please provide at least one link to a cheated game.';

  @override
  String by(String param) {
    return 'by $param';
  }

  @override
  String importedByX(String param) {
    return 'Imported by $param';
  }

  @override
  String get thisTopicIsNowClosed => 'This topic is now closed.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Notes';

  @override
  String get typePrivateNotesHere => 'Type private notes here';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Write a private note about this user';

  @override
  String get noNoteYet => 'No note yet';

  @override
  String get invalidUsernameOrPassword => 'Invalid username or password';

  @override
  String get incorrectPassword => 'Incorrect password';

  @override
  String get invalidAuthenticationCode => 'Invalid authentication code';

  @override
  String get emailMeALink => 'Email me a link';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordAgain => 'New password (again)';

  @override
  String get newPasswordsDontMatch => 'The new passwords don\'t match';

  @override
  String get newPasswordStrength => 'Password strength';

  @override
  String get clockInitialTime => 'Clock initial time';

  @override
  String get clockIncrement => 'Clock increment';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get letOtherPlayersFollowYou => 'Let other players follow you';

  @override
  String get letOtherPlayersChallengeYou => 'Let other players challenge you';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Let other players invite you to study';

  @override
  String get sound => 'Sound';

  @override
  String get none => 'None';

  @override
  String get fast => 'Fast';

  @override
  String get normal => 'Normal';

  @override
  String get slow => 'Slow';

  @override
  String get insideTheBoard => 'Inside the board';

  @override
  String get outsideTheBoard => 'Outside the board';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'On slow games';

  @override
  String get always => 'Always';

  @override
  String get never => 'Never';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 competes in $param2';
  }

  @override
  String get victory => 'Victory';

  @override
  String get defeat => 'Defeat';

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
  String get timeline => 'Timeline';

  @override
  String get starting => 'Starting:';

  @override
  String get allInformationIsPublicAndOptional => 'All information is public and optional.';

  @override
  String get biographyDescription =>
      'Talk about yourself, your interests, what you like in chess, your favourite openings, players, ...';

  @override
  String get listBlockedPlayers => 'List players you have blocked';

  @override
  String get human => 'Human';

  @override
  String get computer => 'Computer';

  @override
  String get side => 'Side';

  @override
  String get clock => 'Clock';

  @override
  String get opponent => 'Opponent';

  @override
  String get learnMenu => 'Learn';

  @override
  String get studyMenu => 'Study';

  @override
  String get practice => 'Practice';

  @override
  String get community => 'Community';

  @override
  String get tools => 'Tools';

  @override
  String get increment => 'Increment';

  @override
  String get error_unknown => 'Invalid value';

  @override
  String get error_required => 'This field is required';

  @override
  String get error_email => 'This email address is invalid';

  @override
  String get error_email_acceptable =>
      'This email address is not acceptable. Please double-check it, and try again.';

  @override
  String get error_email_unique => 'Email address invalid or already taken';

  @override
  String get error_email_different => 'This is already your email address';

  @override
  String error_minLength(String param) {
    return 'Must be at least $param characters long';
  }

  @override
  String error_maxLength(String param) {
    return 'Must be at most $param characters long';
  }

  @override
  String error_min(String param) {
    return 'Must be at least $param';
  }

  @override
  String error_max(String param) {
    return 'Must be at most $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'If rating is ± $param';
  }

  @override
  String get ifRegistered => 'If registered';

  @override
  String get onlyExistingConversations => 'Only existing conversations';

  @override
  String get onlyFriends => 'Only friends';

  @override
  String get menu => 'Menu';

  @override
  String get castling => 'Castling';

  @override
  String get whiteCastlingKingside => 'White O-O';

  @override
  String get blackCastlingKingside => 'Black O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Time spent playing: $param';
  }

  @override
  String get watchGames => 'Watch games';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Time featured on TV: $param';
  }

  @override
  String get watch => 'Watch';

  @override
  String get videoLibrary => 'Video library';

  @override
  String get streamersMenu => 'Streamers';

  @override
  String get mobileApp => 'Mobile App';

  @override
  String get webmasters => 'Webmasters';

  @override
  String get about => 'About';

  @override
  String aboutX(String param) {
    return 'About $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 is a free ($param2), libre, no-ads, open source chess server.';
  }

  @override
  String get really => 'really';

  @override
  String get contribute => 'Contribute';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get titleVerification => 'Title verification';

  @override
  String get sourceCode => 'Source Code';

  @override
  String get simultaneousExhibitions => 'Simultaneous exhibitions';

  @override
  String get host => 'Host';

  @override
  String hostColorX(String param) {
    return 'Host colour: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Newly created simuls';

  @override
  String get hostANewSimul => 'Host a new simul';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Simul not found';

  @override
  String get noSimulExplanation => 'This simultaneous exhibition does not exist.';

  @override
  String get returnToSimulHomepage => 'Return to simul homepage';

  @override
  String get aboutSimul => 'Simuls involve a single player facing several players at once.';

  @override
  String get aboutSimulImage => 'Out of 50 opponents, Fischer won 47 games, drew 2 and lost 1.';

  @override
  String get aboutSimulRealLife =>
      'The concept is taken from real world events. In real life, this involves the simul host moving from table to table to play a single move.';

  @override
  String get aboutSimulRules =>
      'When the simul starts, every player starts a game with the host. The simul ends when all games are complete.';

  @override
  String get aboutSimulSettings =>
      'Simuls are always casual. Rematches, takebacks and adding time are disabled.';

  @override
  String get create => 'Create';

  @override
  String get whenCreateSimul => 'When you create a Simul, you get to play several players at once.';

  @override
  String get simulVariantsHint =>
      'If you select several variants, each player gets to choose which one to play.';

  @override
  String get simulClockHint =>
      'Fischer Clock setup. The more players you take on, the more time you may need.';

  @override
  String get simulAddExtraTime =>
      'You may add extra initial time to your clock to help you cope with the simul.';

  @override
  String get simulHostExtraTime => 'Host extra initial clock time';

  @override
  String get simulAddExtraTimePerPlayer =>
      'Add initial time to your clock for each player joining the simul.';

  @override
  String get simulHostExtraTimePerPlayer => 'Host extra clock time per player';

  @override
  String get lichessTournaments => 'Lichess tournaments';

  @override
  String get tournamentFAQ => 'Arena tournament FAQ';

  @override
  String get timeBeforeTournamentStarts => 'Time before tournament starts';

  @override
  String get averageCentipawnLoss => 'Average centipawn loss';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get keyboardShortcuts => 'Keyboard shortcuts';

  @override
  String get keyMoveBackwardOrForward => 'move backward/forward';

  @override
  String get keyGoToStartOrEnd => 'go to start/end';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'show/hide comments';

  @override
  String get keyEnterOrExitVariation => 'enter/exit variation';

  @override
  String get keyRequestComputerAnalysis => 'Request computer analysis, Learn from your mistakes';

  @override
  String get keyNextLearnFromYourMistakes => 'Next (Learn from your mistakes)';

  @override
  String get keyNextBlunder => 'Next blunder';

  @override
  String get keyNextMistake => 'Next mistake';

  @override
  String get keyNextInaccuracy => 'Next inaccuracy';

  @override
  String get keyPreviousBranch => 'Previous branch';

  @override
  String get keyNextBranch => 'Next branch';

  @override
  String get toggleVariationArrows => 'Toggle variation arrows';

  @override
  String get cyclePreviousOrNextVariation => 'Cycle previous/next variation';

  @override
  String get toggleGlyphAnnotations => 'Toggle move annotations';

  @override
  String get togglePositionAnnotations => 'Toggle position annotations';

  @override
  String get variationArrowsInfo =>
      'Variation arrows let you navigate without using the move list.';

  @override
  String get playSelectedMove => 'play selected move';

  @override
  String get newTournament => 'New tournament';

  @override
  String get tournamentHomeTitle =>
      'Chess tournaments featuring various time controls and variants';

  @override
  String get tournamentHomeDescription =>
      'Play fast-paced chess tournaments! Join an official scheduled tournament, or create your own. Bullet, Blitz, Classical, Chess960, King of the Hill, Threecheck, and more options available for endless chess fun.';

  @override
  String get tournamentNotFound => 'Tournament not found';

  @override
  String get tournamentDoesNotExist => 'This tournament does not exist.';

  @override
  String get tournamentMayHaveBeenCanceled =>
      'The tournament may have been cancelled if all players left before it started.';

  @override
  String get returnToTournamentsHomepage => 'Return to tournaments homepage';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Weekly $param rating distribution';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Your $param1 rating is $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'You are better than $param1 of $param2 players.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 is better than $param2 of $param3 players.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'You do not have an established $param rating.';
  }

  @override
  String get yourRating => 'Your rating';

  @override
  String get cumulative => 'Cumulative';

  @override
  String get glicko2Rating => 'Glicko-2 rating';

  @override
  String get checkYourEmail => 'Check your Email';

  @override
  String get weHaveSentYouAnEmailClickTheLink =>
      'We\'ve sent you an email. Click the link in the email to activate your account.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces =>
      'If you don\'t see the email, check other places it might be, like your junk, spam, social, or other folders.';

  @override
  String get ifYouDoNotGetTheEmail => 'If you do not get the email within 5 minutes:';

  @override
  String get checkAllEmailFolders => 'Check all junk, spam, and other folders';

  @override
  String verifyYourAddress(String param) {
    return 'Verify that $param is your email address';
  }

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'We\'ve sent an email to $param. Click the link in the email to reset your password.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'By registering, you agree to the $param.';
  }

  @override
  String readAboutOur(String param) {
    return 'Read about our $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Network lag between you and Lichess';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Time to process a move on Lichess\'s server';

  @override
  String get downloadAnnotated => 'Download annotated';

  @override
  String get downloadRaw => 'Download raw';

  @override
  String get downloadImported => 'Download imported';

  @override
  String get downloadAllGames => 'Download all games';

  @override
  String get crosstable => 'Crosstable';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame =>
      'Scroll over the board to move in the game.';

  @override
  String get scrollOverComputerVariationsToPreviewThem =>
      'Scroll over computer variations to preview them.';

  @override
  String get analysisShapesHowTo =>
      'Press shift+click or right-click to draw circles and arrows on the board.';

  @override
  String get letOtherPlayersMessageYou => 'Let other players message you';

  @override
  String get receiveForumNotifications => 'Receive notifications when mentioned in the forum';

  @override
  String get shareYourInsightsData => 'Share your chess insights data';

  @override
  String get withNobody => 'With nobody';

  @override
  String get withFriends => 'With friends';

  @override
  String get withEverybody => 'With everybody';

  @override
  String get kidMode => 'Kid mode';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation =>
      'This is about safety. In kid mode, all site communications are disabled. Enable this for your children and school students, to protect them from other internet users.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'In kid mode, the Lichess logo gets a $param icon, so you know your kids are safe.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode =>
      'Your account is managed. Ask your chess teacher about lifting kid mode.';

  @override
  String get enableKidMode => 'Enable Kid mode';

  @override
  String get disableKidMode => 'Disable Kid mode';

  @override
  String get security => 'Security';

  @override
  String get sessions => 'Sessions';

  @override
  String get revokeAllSessions => 'revoke all sessions';

  @override
  String get playChessEverywhere => 'Play chess everywhere';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Everybody gets all features for free';

  @override
  String get viewTheSolution => 'View the solution';

  @override
  String get noChallenges => 'No challenges.';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 hosts $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 joins $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 likes $param2';
  }

  @override
  String get quickPairing => 'Quick pairing';

  @override
  String get lobby => 'Lobby';

  @override
  String get anonymous => 'Anonymous';

  @override
  String yourScore(String param) {
    return 'Your score: $param';
  }

  @override
  String get language => 'Language';

  @override
  String get allLanguages => 'All languages';

  @override
  String get background => 'Background';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get transparent => 'Transparent';

  @override
  String get deviceTheme => 'Device theme';

  @override
  String get backgroundImageUrl => 'Background image URL:';

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
  String get pieceSet => 'Piece set';

  @override
  String get embedInYourWebsite => 'Embed in your website';

  @override
  String get usernameAlreadyUsed => 'This username is already in use, please try another one.';

  @override
  String get usernamePrefixInvalid => 'The username must start with a letter.';

  @override
  String get usernameSuffixInvalid => 'The username must end with a letter or a number.';

  @override
  String get usernameCharsInvalid =>
      'The username must only contain letters, numbers, underscores, and hyphens. Consecutive underscores and hyphens are not allowed.';

  @override
  String get usernameUnacceptable => 'This username is not acceptable.';

  @override
  String get playChessInStyle => 'Play chess in style';

  @override
  String get chessBasics => 'Chess basics';

  @override
  String get coaches => 'Coaches';

  @override
  String get invalidPgn => 'Invalid PGN';

  @override
  String get invalidFen => 'Invalid FEN';

  @override
  String get custom => 'Custom';

  @override
  String get notifications => 'Notifications';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rating: $param';
  }

  @override
  String get practiceWithComputer => 'Practice with computer';

  @override
  String anotherWasX(String param) {
    return 'Another was $param';
  }

  @override
  String bestWasX(String param) {
    return 'Best was $param';
  }

  @override
  String get youBrowsedAway => 'You browsed away';

  @override
  String get resumePractice => 'Resume practice';

  @override
  String get drawByFiftyMoves => 'The game has been drawn by the fifty move rule.';

  @override
  String get theGameIsADraw => 'The game is a draw.';

  @override
  String get computerThinking => 'Computer thinking ...';

  @override
  String get seeBestMove => 'See best move';

  @override
  String get hideBestMove => 'Hide best move';

  @override
  String get getAHint => 'Get a hint';

  @override
  String get evaluatingYourMove => 'Evaluating your move ...';

  @override
  String get whiteWinsGame => 'White wins';

  @override
  String get blackWinsGame => 'Black wins';

  @override
  String get learnFromYourMistakes => 'Learn from your mistakes';

  @override
  String get learnFromThisMistake => 'Learn from this mistake';

  @override
  String get skipThisMove => 'Skip this move';

  @override
  String get next => 'Next';

  @override
  String xWasPlayed(String param) {
    return '$param was played';
  }

  @override
  String get findBetterMoveForWhite => 'Find a better move for white';

  @override
  String get findBetterMoveForBlack => 'Find a better move for black';

  @override
  String get resumeLearning => 'Resume learning';

  @override
  String get youCanDoBetter => 'You can do better';

  @override
  String get tryAnotherMoveForWhite => 'Try another move for white';

  @override
  String get tryAnotherMoveForBlack => 'Try another move for black';

  @override
  String get solution => 'Solution';

  @override
  String get waitingForAnalysis => 'Waiting for analysis';

  @override
  String get noMistakesFoundForWhite => 'No mistakes found for white';

  @override
  String get noMistakesFoundForBlack => 'No mistakes found for black';

  @override
  String get doneReviewingWhiteMistakes => 'Done reviewing white mistakes';

  @override
  String get doneReviewingBlackMistakes => 'Done reviewing black mistakes';

  @override
  String get doItAgain => 'Do it again';

  @override
  String get reviewWhiteMistakes => 'Review white mistakes';

  @override
  String get reviewBlackMistakes => 'Review black mistakes';

  @override
  String get advantage => 'Advantage';

  @override
  String get opening => 'Opening';

  @override
  String get middlegame => 'Middlegame';

  @override
  String get endgame => 'Endgame';

  @override
  String get conditionalPremoves => 'Conditional premoves';

  @override
  String get addCurrentVariation => 'Add current variation';

  @override
  String get playVariationToCreateConditionalPremoves =>
      'Play a variation to create conditional premoves';

  @override
  String get noConditionalPremoves => 'No conditional premoves';

  @override
  String playX(String param) {
    return 'Play $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Sorry :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'We had to time you out for a while.';

  @override
  String get why => 'Why?';

  @override
  String get pleasantChessExperience =>
      'We aim to provide a pleasant chess experience for everyone.';

  @override
  String get goodPractice =>
      'To that effect, we must ensure that all players follow good practice.';

  @override
  String get potentialProblem => 'When a potential problem is detected, we display this message.';

  @override
  String get howToAvoidThis => 'How to avoid this?';

  @override
  String get playEveryGame => 'Play every game you start.';

  @override
  String get tryToWin => 'Try to win (or at least draw) every game you play.';

  @override
  String get resignLostGames => 'Resign lost games (don\'t let the clock run down).';

  @override
  String get temporaryInconvenience => 'We apologise for the temporary inconvenience,';

  @override
  String get wishYouGreatGames => 'and wish you great games on lichess.org.';

  @override
  String get thankYouForReading => 'Thank you for reading!';

  @override
  String get lifetimeScore => 'Lifetime score';

  @override
  String get currentMatchScore => 'Current match score';

  @override
  String get agreementAssistance =>
      'I agree that I will at no time receive assistance during my games (from a chess computer, book, database or another person).';

  @override
  String get agreementNice => 'I agree that I will always be respectful to other players.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'I agree that I will not create multiple accounts (except for the reasons stated in the $param).';
  }

  @override
  String get agreementPolicy => 'I agree that I will follow all Lichess policies.';

  @override
  String get searchOrStartNewDiscussion => 'Search or start new conversation';

  @override
  String get edit => 'Edit';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Classical';

  @override
  String get ultraBulletDesc => 'Insanely fast games: less than 30 seconds';

  @override
  String get bulletDesc => 'Very fast games: less than 3 minutes';

  @override
  String get blitzDesc => 'Fast games: 3 to 8 minutes';

  @override
  String get rapidDesc => 'Rapid games: 8 to 25 minutes';

  @override
  String get classicalDesc => 'Classical games: 25 minutes and more';

  @override
  String get correspondenceDesc => 'Correspondence games: one or several days per move';

  @override
  String get puzzleDesc => 'Chess tactics trainer';

  @override
  String get important => 'Important';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Your question may already have an answer $param1';
  }

  @override
  String get inTheFAQ => 'in the FAQ';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'To report a user for cheating or bad behaviour, $param1';
  }

  @override
  String get useTheReportForm => 'use the report form';

  @override
  String toRequestSupport(String param1) {
    return 'To request support, $param1';
  }

  @override
  String get tryTheContactPage => 'try the contact page';

  @override
  String makeSureToRead(String param1) {
    return 'Make sure to read $param1';
  }

  @override
  String get theForumEtiquette => 'the forum etiquette';

  @override
  String get thisTopicIsArchived => 'This topic has been archived and can no longer be replied to.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Join the $param1, to post in this forum';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 team';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'You can\'t post in the forums yet. Play some games!';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get unsubscribe => 'Unsubscribe';

  @override
  String mentionedYouInX(String param1) {
    return 'mentioned you in \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 mentioned you in \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'invited you to \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 invited you to \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'You are now part of the team.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'You have joined \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Someone you reported was banned';

  @override
  String get congratsYouWon => 'Congratulations, you won!';

  @override
  String gameVsX(String param1) {
    return 'Game vs $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 vs $param2';
  }

  @override
  String get lostAgainstTOSViolator =>
      'You lost rating points to someone who violated the Lichess TOS';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Refund: $param1 $param2 rating points.';
  }

  @override
  String get timeAlmostUp => 'Time is almost up!';

  @override
  String get clickToRevealEmailAddress => '[Click to reveal email address]';

  @override
  String get download => 'Download';

  @override
  String get coachManager => 'Coach manager';

  @override
  String get streamerManager => 'Streamer manager';

  @override
  String get cancelTournament => 'Cancel the tournament';

  @override
  String get tournDescription => 'Tournament description';

  @override
  String get tournDescriptionHelp =>
      'Anything special you want to tell the participants? Try to keep it short. Markdown links are available: [name](https://url)';

  @override
  String get ratedFormHelp => 'Games are rated and impact players ratings';

  @override
  String get onlyMembersOfTeam => 'Only members of team';

  @override
  String get noRestriction => 'No restriction';

  @override
  String get minimumRatedGames => 'Minimum rated games';

  @override
  String get minimumRating => 'Minimum rating';

  @override
  String get maximumWeeklyRating => 'Maximum weekly rating';

  @override
  String positionInputHelp(String param) {
    return 'Paste a valid FEN to start every game from a given position.\nIt only works for standard games, not with variants.\nYou can use the $param to generate a FEN position, then paste it here.\nLeave empty to start games from the normal initial position.';
  }

  @override
  String get cancelSimul => 'Cancel the simul';

  @override
  String get simulHostcolor => 'Host colour for each game';

  @override
  String get estimatedStart => 'Estimated start time';

  @override
  String simulFeatured(String param) {
    return 'Feature on $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Show your simul to everyone on $param. Disable for private simuls.';
  }

  @override
  String get simulDescription => 'Simul description';

  @override
  String get simulDescriptionHelp => 'Anything you want to tell the participants?';

  @override
  String markdownAvailable(String param) {
    return '$param is available for more advanced syntax.';
  }

  @override
  String get embedsAvailable => 'Paste a game URL or a study chapter URL to embed it.';

  @override
  String get inYourLocalTimezone => 'In your own local timezone';

  @override
  String get tournChat => 'Tournament chat';

  @override
  String get noChat => 'No chat';

  @override
  String get onlyTeamLeaders => 'Only team leaders';

  @override
  String get onlyTeamMembers => 'Only team members';

  @override
  String get navigateMoveTree => 'Navigate the move tree';

  @override
  String get mouseTricks => 'Mouse tricks';

  @override
  String get toggleLocalAnalysis => 'Toggle local computer analysis';

  @override
  String get toggleAllAnalysis => 'Toggle all computer analysis';

  @override
  String get playComputerMove => 'Play best computer move';

  @override
  String get analysisOptions => 'Analysis options';

  @override
  String get focusChat => 'Focus chat';

  @override
  String get showHelpDialog => 'Show this help dialog';

  @override
  String get reopenYourAccount => 'Reopen your account';

  @override
  String get reopenYourAccountDescription =>
      'If you closed your account, but have since changed your mind, you get a chance of getting your account back.';

  @override
  String get emailAssociatedToaccount => 'Email address associated to the account';

  @override
  String get sentEmailWithLink => 'We\'ve sent you an email with a link.';

  @override
  String get tournamentEntryCode => 'Tournament entry code';

  @override
  String get hangOn => 'Hang on!';

  @override
  String gameInProgress(String param) {
    return 'You have a game in progress with $param.';
  }

  @override
  String get abortTheGame => 'Abort the game';

  @override
  String get resignTheGame => 'Resign the game';

  @override
  String get youCantStartNewGame => 'You can\'t start a new game until this one is finished.';

  @override
  String get since => 'Since';

  @override
  String get until => 'Until';

  @override
  String get lichessDbExplanation => 'Rated games played on Lichess';

  @override
  String get switchSides => 'Switch sides';

  @override
  String get closingAccountWithdrawAppeal => 'Closing your account will withdraw your appeal';

  @override
  String get ourEventTips => 'Our tips for organising events';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo =>
      'Lichess is a charity and entirely free/libre open source software.\nAll operating costs, development, and content are funded solely by user donations.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String get stats => 'Stats';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get enableBlindMode => 'Enable blind mode';

  @override
  String get disableBlindMode => 'Disable blind mode';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your opponent left the game. You can claim victory in $count seconds.',
      one: 'Your opponent left the game. You can claim victory in $count second.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mate in $count half-moves',
      one: 'Mate in $count half-move',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blunders',
      one: '$count blunder',
    );
    return '$_temp0';
  }

  @override
  String numberBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Blunders',
      one: '$count Blunder',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mistakes',
      one: '$count mistake',
    );
    return '$_temp0';
  }

  @override
  String numberMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mistakes',
      one: '$count Mistake',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count inaccuracies',
      one: '$count inaccuracy',
    );
    return '$_temp0';
  }

  @override
  String numberInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Inaccuracies',
      one: '$count Inaccuracy',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count players',
      one: '$count player',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games',
      one: '$count game',
    );
    return '$_temp0';
  }

  @override
  String ratingXOverYGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rating over $param2 games',
      one: '$count rating over $param2 game',
    );
    return '$_temp0';
  }

  @override
  String nbBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bookmarks',
      one: '$count bookmark',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '$count hour',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '$count minute',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rank is updated every $count minutes',
      one: 'Rank is updated every minute',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puzzles',
      one: '$count puzzle',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games with you',
      one: '$count game with you',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rated',
      one: '$count rated',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wins',
      one: '$count win',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count losses',
      one: '$count loss',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count draws',
      one: '$count draw',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count playing',
      one: '$count playing',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Give $count seconds',
      one: 'Give $count second',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tournament points',
      one: '$count tournament point',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studies',
      one: '$count study',
    );
    return '$_temp0';
  }

  @override
  String nbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simuls',
      one: '$count simul',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbRatedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count rated games',
      one: '≥ $count rated game',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 rated games',
      one: '≥ $count $param2 rated game',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You need to play $count more $param2 rated games',
      one: 'You need to play $count more $param2 rated game',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You need to play $count more rated games',
      one: 'You need to play $count more rated game',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imported games',
      one: '$count imported game',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends online',
      one: '$count friend online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '$count follower',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count following',
      one: '$count following',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Less than $count minutes',
      one: 'Less than $count minute',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games in play',
      one: '$count game in play',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maximum: $count characters.',
      one: 'Maximum: $count character.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blocks',
      one: '$count block',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forum posts',
      one: '$count forum post',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 players this week.',
      one: '$count $param2 player this week.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Available in $count languages!',
      one: 'Available in $count language!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds to play the first move',
      one: '$count second to play the first move',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds',
      one: '$count second',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'and save $count premove lines',
      one: 'and save $count premove line',
    );
    return '$_temp0';
  }

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
  String get stormSkipExplanation =>
      'Salta questa mossa per mantenere la combo! È possibile farlo solo una volta per gara.';

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
  String get stormThisRunWasOpenedInAnotherTab =>
      'Questa serie è stata aperta in un\'altra scheda!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentativi',
      one: '1 tentativo',
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
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess streamer';

  @override
  String get studyPrivate => 'Privato';

  @override
  String get studyMyStudies => 'I miei studi';

  @override
  String get studyStudiesIContributeTo => 'Studi a cui collaboro';

  @override
  String get studyMyPublicStudies => 'I miei studi pubblici';

  @override
  String get studyMyPrivateStudies => 'I miei studi privati';

  @override
  String get studyMyFavoriteStudies => 'I miei studi preferiti';

  @override
  String get studyWhatAreStudies => 'Cosa sono gli \"studi\"?';

  @override
  String get studyAllStudies => 'Tutti gli studi';

  @override
  String studyStudiesCreatedByX(String param) {
    return 'Studi creati da $param';
  }

  @override
  String get studyNoneYet => 'Vuoto.';

  @override
  String get studyHot => 'Hot';

  @override
  String get studyDateAddedNewest => 'Data di pubblicazione (dalla più recente)';

  @override
  String get studyDateAddedOldest => 'Data di pubblicazione (dalla meno recente)';

  @override
  String get studyRecentlyUpdated => 'Data di aggiornamento (dalla più recente)';

  @override
  String get studyMostPopular => 'Più popolari';

  @override
  String get studyAlphabetical => 'Alfabetico';

  @override
  String get studyAddNewChapter => 'Aggiungi un nuovo capitolo';

  @override
  String get studyAddMembers => 'Aggiungi membri';

  @override
  String get studyInviteToTheStudy => 'Invita allo studio';

  @override
  String get studyPleaseOnlyInvitePeopleYouKnow =>
      'Invita solo persone che conosci e che desiderano partecipare attivamente a questo studio.';

  @override
  String get studySearchByUsername => 'Cerca per nome utente';

  @override
  String get studySpectator => 'Spettatore';

  @override
  String get studyContributor => 'Partecipante';

  @override
  String get studyKick => 'Espelli';

  @override
  String get studyLeaveTheStudy => 'Abbandona lo studio';

  @override
  String get studyYouAreNowAContributor => 'Ora sei un partecipante';

  @override
  String get studyYouAreNowASpectator => 'Ora sei uno spettatore';

  @override
  String get studyPgnTags => 'Tag PGN';

  @override
  String get studyLike => 'Mi piace';

  @override
  String get studyUnlike => 'Non mi Piace';

  @override
  String get studyNewTag => 'Nuovo tag';

  @override
  String get studyCommentThisPosition => 'Commenta questa posizione';

  @override
  String get studyCommentThisMove => 'Commenta questa mossa';

  @override
  String get studyAnnotateWithGlyphs => 'Commenta con segni convenzionali';

  @override
  String get studyTheChapterIsTooShortToBeAnalysed =>
      'Il capitolo è troppo breve per essere analizzato.';

  @override
  String get studyOnlyContributorsCanRequestAnalysis =>
      'Solo i partecipanti allo studio possono richiedere un\'analisi del computer.';

  @override
  String get studyGetAFullComputerAnalysis =>
      'Richiedi un\'analisi completa del computer della variante principale.';

  @override
  String get studyMakeSureTheChapterIsComplete =>
      'Assicurati che il capitolo sia completo. Puoi richiedere l\'analisi solo una volta.';

  @override
  String get studyAllSyncMembersRemainOnTheSamePosition =>
      'Tutti i membri in SYNC rimangono sulla stessa posizione';

  @override
  String get studyShareChanges => 'Condividi le modifiche con gli spettatori e salvale sul server';

  @override
  String get studyPlaying => 'In corso';

  @override
  String get studyShowResults => 'Risultati';

  @override
  String get studyShowEvalBar => 'Barre di valutazione';

  @override
  String get studyNext => 'Successivo';

  @override
  String get studyShareAndExport => 'Condividi & esporta';

  @override
  String get studyCloneStudy => 'Duplica';

  @override
  String get studyStudyPgn => 'PGN dello studio';

  @override
  String get studyChapterPgn => 'PGN del capitolo';

  @override
  String get studyCopyChapterPgn => 'Copia in PGN';

  @override
  String get studyDownloadGame => 'Scarica partita';

  @override
  String get studyStudyUrl => 'URL dello studio';

  @override
  String get studyCurrentChapterUrl => 'URL del capitolo corrente';

  @override
  String get studyYouCanPasteThisInTheForumToEmbed =>
      'Puoi incollare questo URL nel forum per creare un rimando';

  @override
  String get studyStartAtInitialPosition => 'Inizia dalla prima mossa';

  @override
  String studyStartAtX(String param) {
    return 'Inizia a: $param';
  }

  @override
  String get studyEmbedInYourWebsite => 'Incorpora nel tuo sito Web o Blog';

  @override
  String get studyReadMoreAboutEmbedding => 'Per saperne di più su come incorporare';

  @override
  String get studyOnlyPublicStudiesCanBeEmbedded =>
      'Solo gli studi pubblici possono essere incorporati!';

  @override
  String get studyOpen => 'Apri';

  @override
  String studyXBroughtToYouByY(String param1, String param2) {
    return '$param1 fornito da $param2';
  }

  @override
  String get studyStudyNotFound => 'Studio non trovato';

  @override
  String get studyEditChapter => 'Modifica il capitolo';

  @override
  String get studyNewChapter => 'Nuovo capitolo';

  @override
  String studyImportFromChapterX(String param) {
    return 'Importa da $param';
  }

  @override
  String get studyOrientation => 'Orientamento';

  @override
  String get studyAnalysisMode => 'Modalità analisi';

  @override
  String get studyPinnedChapterComment => 'Commento del capitolo';

  @override
  String get studySaveChapter => 'Salva capitolo';

  @override
  String get studyClearAnnotations => 'Cancella annotazioni';

  @override
  String get studyClearVariations => 'Elimina le varianti';

  @override
  String get studyDeleteChapter => 'Elimina capitolo';

  @override
  String get studyDeleteThisChapter =>
      'Vuoi davvero eliminare questo capitolo? Sarà perso per sempre!';

  @override
  String get studyClearAllCommentsInThisChapter =>
      'Cancellare tutti i commenti, le annotazioni e i disegni in questo capitolo?';

  @override
  String get studyRightUnderTheBoard => 'Sotto la scacchiera';

  @override
  String get studyNoPinnedComment => 'Nessun commento';

  @override
  String get studyNormalAnalysis => 'Analisi normale';

  @override
  String get studyHideNextMoves => 'Nascondi le mosse successive';

  @override
  String get studyInteractiveLesson => 'Lezione interattiva';

  @override
  String studyChapterX(String param) {
    return 'Capitolo $param';
  }

  @override
  String get studyEmpty => 'Semplice';

  @override
  String get studyStartFromInitialPosition => 'Parti dalla posizione iniziale';

  @override
  String get studyEditor => 'Editor';

  @override
  String get studyStartFromCustomPosition => 'Inizia da una posizione personalizzata';

  @override
  String get studyLoadAGameByUrl => 'Carica una partita da URL';

  @override
  String get studyLoadAPositionFromFen => 'Carica una posizione da FEN';

  @override
  String get studyLoadAGameFromPgn => 'Carica una partita da PGN';

  @override
  String get studyAutomatic => 'Automatica';

  @override
  String get studyUrlOfTheGame => 'URL della partita';

  @override
  String studyLoadAGameFromXOrY(String param1, String param2) {
    return 'Carica una partita da $param1 o $param2';
  }

  @override
  String get studyCreateChapter => 'Crea capitolo';

  @override
  String get studyCreateStudy => 'Crea studio';

  @override
  String get studyEditStudy => 'Modifica studio';

  @override
  String get studyVisibility => 'Visibilità';

  @override
  String get studyPublic => 'Pubblico';

  @override
  String get studyUnlisted => 'Non elencato';

  @override
  String get studyInviteOnly => 'Solo su invito';

  @override
  String get studyAllowCloning => 'Permetti la clonazione';

  @override
  String get studyNobody => 'Nessuno';

  @override
  String get studyOnlyMe => 'Solo io';

  @override
  String get studyContributors => 'Collaboratori';

  @override
  String get studyMembers => 'Membri';

  @override
  String get studyEveryone => 'Tutti';

  @override
  String get studyEnableSync => 'Abilita sincronizzazione';

  @override
  String get studyYesKeepEveryoneOnTheSamePosition => 'Sì: tutti vedranno la stessa posizione';

  @override
  String get studyNoLetPeopleBrowseFreely =>
      'No: ognuno potrà scorrere i capitoli indipendentemente';

  @override
  String get studyPinnedStudyComment => 'Commento dello studio';

  @override
  String get studyStart => 'Inizia';

  @override
  String get studySave => 'Salva';

  @override
  String get studyClearChat => 'Cancella chat';

  @override
  String get studyDeleteTheStudyChatHistory =>
      'Vuoi davvero eliminare la cronologia della chat? Sarà persa per sempre!';

  @override
  String get studyDeleteStudy => 'Elimina studio';

  @override
  String studyConfirmDeleteStudy(String param) {
    return 'Eliminare l\'intero studio? Non sarà possibile annullare l\'operazione! Digitare il nome dello studio per confermare: $param';
  }

  @override
  String get studyWhereDoYouWantToStudyThat => 'Dove vuoi creare lo studio?';

  @override
  String get studyGoodMove => 'Bella mossa';

  @override
  String get studyMistake => 'Errore';

  @override
  String get studyBrilliantMove => 'Mossa geniale';

  @override
  String get studyBlunder => 'Errore grave';

  @override
  String get studyInterestingMove => 'Mossa interessante';

  @override
  String get studyDubiousMove => 'Mossa dubbia';

  @override
  String get studyOnlyMove => 'Unica mossa';

  @override
  String get studyZugzwang => 'Zugzwang';

  @override
  String get studyEqualPosition => 'Posizione equivalente';

  @override
  String get studyUnclearPosition => 'Posizione non chiara';

  @override
  String get studyWhiteIsSlightlyBetter => 'Il bianco è in lieve vantaggio';

  @override
  String get studyBlackIsSlightlyBetter => 'Il nero è in lieve vantaggio';

  @override
  String get studyWhiteIsBetter => 'Il bianco è in vantaggio';

  @override
  String get studyBlackIsBetter => 'Il nero è in vantaggio';

  @override
  String get studyWhiteIsWinning => 'Il bianco sta vincendo';

  @override
  String get studyBlackIsWinning => 'Il nero sta vincendo';

  @override
  String get studyNovelty => 'Novità';

  @override
  String get studyDevelopment => 'Sviluppo';

  @override
  String get studyInitiative => 'Iniziativa';

  @override
  String get studyAttack => 'Attacco';

  @override
  String get studyCounterplay => 'Contrattacco';

  @override
  String get studyTimeTrouble => 'Prolemi di tempo';

  @override
  String get studyWithCompensation => 'Con compenso';

  @override
  String get studyWithTheIdea => 'Con l\'idea';

  @override
  String get studyNextChapter => 'Prossimo capitolo';

  @override
  String get studyPrevChapter => 'Capitolo precedente';

  @override
  String get studyStudyActions => 'Studia azioni';

  @override
  String get studyTopics => 'Discussioni';

  @override
  String get studyMyTopics => 'Le mie discussioni';

  @override
  String get studyPopularTopics => 'Argomenti popolari';

  @override
  String get studyManageTopics => 'Gestisci discussioni';

  @override
  String get studyBack => 'Indietro';

  @override
  String get studyPlayAgain => 'Gioca di nuovo';

  @override
  String get studyWhatWouldYouPlay => 'Cosa giocheresti in questa posizione?';

  @override
  String get studyYouCompletedThisLesson => 'Congratulazioni! Hai completato questa lezione.';

  @override
  String studyPerPage(String param) {
    return '$param per pagina';
  }

  @override
  String get studyGetTheTour => 'Hai bisogno di aiuto? Fai un tour!';

  @override
  String get studyWelcomeToLichessStudyTitle => 'Benvenuto allo Studio!';

  @override
  String get studyWelcomeToLichessStudyText =>
      'Questa è una scacchiera di analisi condivisa.<br><br>Usala per analizzare e annotare le partite,<br>discutere delle posizioni con gli amici,<br>e, naturalmente, per le lezioni di scacchi!<br><br>È uno strumento potente, prendiamoci un po\' di tempo per vedere come funziona.';

  @override
  String get studySharedAndSaveTitle => 'Condivisa e salvata';

  @override
  String get studySharedAndSavedText =>
      'Altri membri possono vedere le tue mosse in tempo reale!<br>Inoltre, tutto è salvato per sempre.';

  @override
  String get studyStudyMembersTitle => 'Membri dello studio';

  @override
  String studyStudyMembersText(String param1, String param2) {
    return '$param1 Gli spettatori possono vedere lo studio e parlare in chat.<br><br>$param2 I collaboratori possono fare mosse e aggiornare lo studio.';
  }

  @override
  String studyAddMembersText(String param) {
    return 'Fai clic sul pulsante $param.<br> Poi decidi chi può contribuire.';
  }

  @override
  String get studyStudyChaptersTitle => 'Capitoli dello studio';

  @override
  String get studyStudyChaptersText =>
      'Uno studio può contenere diversi capitoli.<br>Ogni capitolo ha una posizione iniziale e un albero mosse distinto.';

  @override
  String get studyCommentPositionTitle => 'Commenta una posizione';

  @override
  String studyCommentPositionText(String param) {
    return 'Fai clic sul pulsante $param oppure fai clic col tasto destro sull\'elenco delle mosse sulla destra.<br>I commenti sono condivisi e salvati.';
  }

  @override
  String get studyAnnotatePositionTitle => 'Scrivi una nota su una posizione';

  @override
  String get studyAnnotatePositionText =>
      'Fai clic sul pulsante !? oppure fai clic col tasto destro sull\'elenco delle mosse.<br>Le icone delle note sono condivise e salvate.';

  @override
  String get studyConclusionTitle => 'Grazie del tuo tempo';

  @override
  String get studyConclusionText =>
      'Puoi trovare i tuoi <a href=\'/study/mine/hot\'>studi precedenti</a> sulla pagina del tuo profilo.<br>C\'è anche un <a href=\'//lichess.org/blog/V0KrLSkAAMo3hsi4/study-chess-the-lichess-way\'>post sugli studi</a> sul blog.<br>Gli utenti esperti possono premere \"?\" per vedere le scorciatoie da tasriera.<br>Divertiti!';

  @override
  String get studyCreateChapterTitle => 'Creiamo un capitolo di studio';

  @override
  String get studyCreateChapterText =>
      'Uno studio può avere diversi capitoli.<br>Ogni capitolo ha un albero mosse distinto <br>e può essere creato in vari modi.';

  @override
  String get studyFromInitialPositionTitle => 'Parti dalla posizione iniziale';

  @override
  String get studyFromInitialPositionText =>
      'Uno schema per una nuova partita.<br>Adatto per esplorare le aperture.';

  @override
  String get studyCustomPositionTitle => 'Posizione personalizzata';

  @override
  String get studyCustomPositionText =>
      'Personalizza la scacchiera come preferisci.<br>Ideale per esplorare i finali.';

  @override
  String get studyLoadExistingLichessGameTitle => 'Carica una partita lichess esistente';

  @override
  String get studyLoadExistingLichessGameText =>
      'Incolla un\'URL di una partita lichess, <br>come (like lichess.org/7fHIU0XI)<br>per caricare le mosse nel capitolo.';

  @override
  String get studyFromFenStringTitle => 'Da una stringa FEN';

  @override
  String get studyFromFenStringText =>
      'Incolla una posizione in formato FEN<br><i>4k3/4rb2/8/7p/8/5Q2/1PP5/1K6 w<br><br>per iniziare il capitolo da una posizione.';

  @override
  String get studyFromPgnGameTitle => 'Preso da una partita PGN';

  @override
  String get studyFromPgnGameText =>
      'Incolla una partita in formato PGN<br>per caricare mosse, commenti e variazioni nel capitolo.';

  @override
  String get studyVariantsAreSupportedTitle => 'Gli studi supportano le varianti';

  @override
  String get studyVariantsAreSupportedText =>
      'Proprio così, puoi studiare le varianti crazyhouse<br>e lichess!';

  @override
  String get studyChapterConclusionText =>
      'I capitoli sono salvati per sempre.<br>Divertiti a organzizare il tuo contenuto scacchistico!';

  @override
  String get studyDoubleDefeat => 'Doppia sconfitta';

  @override
  String get studyBlackDefeatWhiteCanNotWin => 'Il Nero è sconfitto, ma il Bianco non può vincere';

  @override
  String get studyWhiteDefeatBlackCanNotWin => 'Il Bianco è sconfitto, ma il Nero non pul vincere';

  @override
  String studyNbChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capitoli',
      one: '$count capitolo',
    );
    return '$_temp0';
  }

  @override
  String studyNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partite',
      one: '$count partita',
    );
    return '$_temp0';
  }

  @override
  String studyNbMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membri',
      one: '$count membro',
    );
    return '$_temp0';
  }

  @override
  String studyPasteYourPgnTextHereUpToNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Incolla qui i testi PGN, massimo $count partite',
      one: 'Incolla qui il testo PGN, massimo $count partita',
    );
    return '$_temp0';
  }

  @override
  String get timeagoJustNow => 'adesso';

  @override
  String get timeagoRightNow => 'adesso';

  @override
  String get timeagoCompleted => 'completato';

  @override
  String timeagoInNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tra $count secondi',
      one: 'tra $count secondo',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tra $count minuti',
      one: 'tra $count minuto',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tra $count ore',
      one: 'tra $count ora',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tra $count giorni',
      one: 'tra $count giorno',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tra $count settimane',
      one: 'tra $count settimana',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tra $count mesi',
      one: 'tra $count mese',
    );
    return '$_temp0';
  }

  @override
  String timeagoInNbYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tra $count anni',
      one: 'tra $count anno',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti fa',
      one: '$count minuto fa',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore fa',
      one: '$count ora fa',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni fa',
      one: '$count giorno fa',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count settimane fa',
      one: '$count settimana fa',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mesi fa',
      one: '$count mese fa',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anni fa',
      one: '$count anno fa',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbMinutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti rimanenti',
      one: '$count minuto rimanente',
    );
    return '$_temp0';
  }

  @override
  String timeagoNbHoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore rimanenti',
      one: '$count ora rimanente',
    );
    return '$_temp0';
  }
}
