import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

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
  String get activityActivity => 'Aktivnost';

  @override
  String get activityHostedALiveStream => 'Prenosio uživo';

  @override
  String activityRankedInSwissTournament(String param1, String param2) {
    return 'Rangiran #$param1 u $param2';
  }

  @override
  String get activitySignedUp => 'Registrirao/la se na lichess';

  @override
  String activitySupportedNbMonths(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Podržavao/la lichess.org $count mjeseci kao $param2',
      few: 'Podržavao/la lichess.org $count mjeseca kao $param2',
      one: 'Podržavao/la lichess.org $count mjesec kao $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPracticedNbPositions(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vježbao/la $count pozicija na $param2',
      few: 'Vježbao/la $count pozicije na $param2',
      one: 'Vježbao/la $count poziciju na $param2',
    );
    return '$_temp0';
  }

  @override
  String activitySolvedNbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Riješio/la $count taktičkih problema',
      few: 'Riješio/la $count taktička problema',
      one: 'Riješio/la $count taktički problem',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odigrao $count $param2 partija',
      few: 'Odigrao $count $param2 partije',
      one: 'Odigrao $count $param2 partiju',
    );
    return '$_temp0';
  }

  @override
  String activityPostedNbMessages(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Napisao/la $count odgovora u temi $param2',
      few: 'Napisao/la $count odgovora u temi $param2',
      one: 'Napisao/la $count odgovor u temi $param2',
    );
    return '$_temp0';
  }

  @override
  String activityPlayedNbMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Igrao/la $count poteza',
      few: 'Igrao/la $count potez',
      one: 'Igrao/la $count potez',
    );
    return '$_temp0';
  }

  @override
  String activityInNbCorrespondenceGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'u $count partija dopisnog šaha',
      few: 'u $count partije dopisnog šaha',
      one: 'u $count partiji dopisnog šaha',
    );
    return '$_temp0';
  }

  @override
  String activityCompletedNbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Završio/la $count partija dopisnog šaha',
      few: 'Završio/la $count partije dopisnog šaha',
      one: 'Završio/la $count partiju dopisnog šaha',
    );
    return '$_temp0';
  }

  @override
  String activityFollowedNbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Počeo/la pratiti $count igrača',
      few: 'Počeo/la pratiti $count igrača',
      one: 'Počeo/la pratiti $count igrača',
    );
    return '$_temp0';
  }

  @override
  String activityGainedNbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dobio/la $count novih pratitelja',
      few: 'Dobio/la $count nova pratitelja',
      one: 'Dobio/la $count novog pratitelja',
    );
    return '$_temp0';
  }

  @override
  String activityHostedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bio domaćin $count simultanki',
      few: 'Bio domaćin $count simultanke',
      one: 'Bio domaćin $count simultanke',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbSimuls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sudjelovao/la u $count simultanki',
      few: 'Sudjelovao/la u $count simultanke',
      one: 'Sudjelovao/la u $count simultanki',
    );
    return '$_temp0';
  }

  @override
  String activityCreatedNbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kreirao/la $count novih studija',
      few: 'Kreirao/la $count nove studije',
      one: 'Kreirao/la $count novu studiju',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Natjecao/la se u $count turnira',
      few: 'Natjecao/la se u $count turnira',
      one: 'Natjecao/la se u $count turniru',
    );
    return '$_temp0';
  }

  @override
  String activityRankedInTournament(int count, String param2, String param3, String param4) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rangiran/rangirana #$count (prvih $param2%) s $param3 odigranih partija u turniru $param4',
      few: 'Rangiran/rangirana #$count (prvih $param2%) s $param3 odigrane partije u turniru $param4',
      one: 'Rangiran/rangirana #$count (prvih $param2%) s $param3 odigranom partijom u turniru $param4',
    );
    return '$_temp0';
  }

  @override
  String activityCompetedInNbSwissTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Natjecao se u $count švicarskih turnira',
      few: 'Natjecao se u $count švicarska turniru',
      one: 'Natjecao se u $count švicarskom turniru',
    );
    return '$_temp0';
  }

  @override
  String activityJoinedNbTeams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pridružio/la se $count timova',
      few: 'Pridružio/la se $count tima',
      one: 'Pridružio/la se $count timu',
    );
    return '$_temp0';
  }

  @override
  String get broadcastBroadcasts => 'Prijenosi';

  @override
  String get broadcastLiveBroadcasts => 'Prijenosi turnira uživo';

  @override
  String challengeChallengesX(String param1) {
    return 'Challenges: $param1';
  }

  @override
  String get challengeChallengeToPlay => 'Poziv na partiju';

  @override
  String get challengeChallengeDeclined => 'Izazov odbijen';

  @override
  String get challengeChallengeAccepted => 'Izazov prihvaćen!';

  @override
  String get challengeChallengeCanceled => 'Izazov otkazan.';

  @override
  String get challengeRegisterToSendChallenges => 'Registriraj se za slanje izazova.';

  @override
  String challengeYouCannotChallengeX(String param) {
    return 'Ne možeš izazvati $param.';
  }

  @override
  String challengeXDoesNotAcceptChallenges(String param) {
    return '$param ne prihvaća izazove.';
  }

  @override
  String challengeYourXRatingIsTooFarFromY(String param1, String param2) {
    return 'Prevelika je razlika između tvog i $param2 $param1 rejtinga.';
  }

  @override
  String challengeCannotChallengeDueToProvisionalXRating(String param) {
    return 'Nemoguće izazvati zbog prevelike razlike u $param rejtingu.';
  }

  @override
  String challengeXOnlyAcceptsChallengesFromFriends(String param) {
    return '$param prihvaća izazove isključivo od prijatelja.';
  }

  @override
  String get challengeDeclineGeneric => 'Trenutačno ne prihvaćam izazove.';

  @override
  String get challengeDeclineLater => 'Trenutačno ne mogu prihvatiti izazov, molim te da pokušaš kasnije.';

  @override
  String get challengeDeclineTooFast => 'Ovaj vremenski format je prebrz za mene, izazovi me na sporiji format.';

  @override
  String get challengeDeclineTooSlow => 'Ovaj vremenski format je prespor za mene, izazovi me na brži format.';

  @override
  String get challengeDeclineTimeControl => 'Ne prihvaćam izazove u ovom vremenskom formatu.';

  @override
  String get challengeDeclineRated => 'Radije me izazovi na bodovanu partiju.';

  @override
  String get challengeDeclineCasual => 'Radije me izazovi na ležernu partiju.';

  @override
  String get challengeDeclineStandard => 'Ne prihvaćam izazove u ovoj varijanti.';

  @override
  String get challengeDeclineVariant => 'Trenutačno ne želim igrati ovu varijantu.';

  @override
  String get challengeDeclineNoBot => 'Ne prihvaćam izazove od botova.';

  @override
  String get challengeDeclineOnlyBot => 'Prihvaćam izazove isključivo od botova.';

  @override
  String get challengeInviteLichessUser => 'Ili pozovite Lichess korisnika:';

  @override
  String get contactContact => 'Kontaktirajte nas';

  @override
  String get contactContactLichess => 'Kontaktiraj Lichess';

  @override
  String get patronDonate => 'Donirajte';

  @override
  String get patronLichessPatron => 'Lichess donacijska stranica';

  @override
  String perfStatPerfStats(String param) {
    return '$param statistika';
  }

  @override
  String get perfStatViewTheGames => 'Pogledaj partije';

  @override
  String get perfStatProvisional => 'privremeno';

  @override
  String get perfStatNotEnoughRatedGames => 'Odigrano je nedovoljno rangiranih partija da bi se uspostavio pouzdani rejting.';

  @override
  String perfStatProgressOverLastXGames(String param) {
    return 'Napredak u zadnjih $param partija:';
  }

  @override
  String perfStatRatingDeviation(String param) {
    return 'Rejting devijacija: $param.';
  }

  @override
  String perfStatRatingDeviationTooltip(String param1, String param2, String param3) {
    return 'Manja vrijednost znači da je ocjena stabilnija. Iznad $param1, ocjena se smatra privremenom. Da bi bila uključena u ljestvicu, ova vrijednost treba biti ispod $param2 (standardni šah) ili $param3 (varijante).';
  }

  @override
  String get perfStatTotalGames => 'Ukupno partija';

  @override
  String get perfStatRatedGames => 'Rangirane partije';

  @override
  String get perfStatTournamentGames => 'Turnirske partije';

  @override
  String get perfStatBerserkedGames => 'Berserk partije';

  @override
  String get perfStatTimeSpentPlaying => 'Vrijeme provedeno igrajući';

  @override
  String get perfStatAverageOpponent => 'Prosječni protivnik';

  @override
  String get perfStatVictories => 'Pobjede';

  @override
  String get perfStatDefeats => 'Porazi';

  @override
  String get perfStatDisconnections => 'Prekidi veze';

  @override
  String get perfStatNotEnoughGames => 'Nedovoljno partija odigrano';

  @override
  String perfStatHighestRating(String param) {
    return 'Najviši rejting: $param';
  }

  @override
  String perfStatLowestRating(String param) {
    return 'Najniži rejting: $param';
  }

  @override
  String perfStatFromXToY(String param1, String param2) {
    return 'od $param1 do $param2';
  }

  @override
  String get perfStatWinningStreak => 'Pobjednički niz';

  @override
  String get perfStatLosingStreak => 'Gubitnički niz';

  @override
  String perfStatLongestStreak(String param) {
    return 'Najduži niz: $param';
  }

  @override
  String perfStatCurrentStreak(String param) {
    return 'Trenutni niz: $param';
  }

  @override
  String get perfStatBestRated => 'Najbolje rangirane pobjede';

  @override
  String get perfStatGamesInARow => 'Igre odigrane za redom';

  @override
  String get perfStatLessThanOneHour => 'Manje od jednog sata između igara';

  @override
  String get perfStatMaxTimePlaying => 'Vrijeme provedeno igrajući';

  @override
  String get perfStatNow => 'sada';

  @override
  String get preferencesPreferences => 'Postavke';

  @override
  String get preferencesDisplay => 'Zaslon';

  @override
  String get preferencesPrivacy => 'Privatnost';

  @override
  String get preferencesNotifications => 'Obavijesti';

  @override
  String get preferencesPieceAnimation => 'Animacija figura';

  @override
  String get preferencesMaterialDifference => 'Razlika u figurama';

  @override
  String get preferencesBoardHighlights => 'Osvijetli zadnji potez i šah';

  @override
  String get preferencesPieceDestinations => 'Legalni potezi (važeći potezi i pretpotezi)';

  @override
  String get preferencesBoardCoordinates => 'Oznake na ploči (A-H, 1-8)';

  @override
  String get preferencesMoveListWhilePlaying => 'Popis poteza tijekom partije';

  @override
  String get preferencesPgnPieceNotation => 'Oznaka poteza';

  @override
  String get preferencesChessPieceSymbol => 'Simbol šahovske figure';

  @override
  String get preferencesPgnLetter => 'Slovo (K, Q, R, B, N)';

  @override
  String get preferencesZenMode => 'Zen način';

  @override
  String get preferencesShowPlayerRatings => 'Prikaži igračev rejting';

  @override
  String get preferencesShowFlairs => 'Show player flairs';

  @override
  String get preferencesExplainShowPlayerRatings => 'Omogućuje sakrivanje svih rejtinga sa websajta da bi se fokusirali na šah. Partije i dalje mogu biti bodovane, postavka utječe samo na prikaz, ne računanje.';

  @override
  String get preferencesDisplayBoardResizeHandle => 'Prikaži ručicu za promjenu veličine ploče';

  @override
  String get preferencesOnlyOnInitialPosition => 'Samo na početku partije';

  @override
  String get preferencesInGameOnly => 'Samo unutar igre';

  @override
  String get preferencesChessClock => 'Sat';

  @override
  String get preferencesTenthsOfSeconds => 'Desetinke sekundi';

  @override
  String get preferencesWhenTimeRemainingLessThanTenSeconds => 'Kad je ostalo manje od 10 sekundi';

  @override
  String get preferencesHorizontalGreenProgressBars => 'Vodoravna zelena linija napretka';

  @override
  String get preferencesSoundWhenTimeGetsCritical => 'Zvuk kada je vrijeme kritično';

  @override
  String get preferencesGiveMoreTime => 'Daj više vremena';

  @override
  String get preferencesGameBehavior => 'Način igre';

  @override
  String get preferencesHowDoYouMovePieces => 'Kako želiš pomicati figure?';

  @override
  String get preferencesClickTwoSquares => 'Klikom na dva polja';

  @override
  String get preferencesDragPiece => 'Povlačenjem figure';

  @override
  String get preferencesBothClicksAndDrag => 'Ili';

  @override
  String get preferencesPremovesPlayingDuringOpponentTurn => 'Pretpotezi (potezi dok je protivnikov red)';

  @override
  String get preferencesTakebacksWithOpponentApproval => 'Povlačenje poteza (ako se protivnik složi)';

  @override
  String get preferencesInCasualGamesOnly => 'Samo u prijateljskim partijama';

  @override
  String get preferencesPromoteToQueenAutomatically => 'Auto-promocija u damu';

  @override
  String get preferencesExplainPromoteToQueenAutomatically => 'Držite <ctrl> tipku prilikom promocije pješaka da bi privremeno onemogućili automatsku promociju u damu';

  @override
  String get preferencesWhenPremoving => 'Kada odigraš pretpotez';

  @override
  String get preferencesClaimDrawOnThreefoldRepetitionAutomatically => 'Automatski proglasi remi po trostrukom ponavljanju pozicije';

  @override
  String get preferencesWhenTimeRemainingLessThanThirtySeconds => 'Kada je vrijeme < 30 sekundi';

  @override
  String get preferencesMoveConfirmation => 'Potvrda poteza';

  @override
  String get preferencesExplainCanThenBeTemporarilyDisabled => 'Can be disabled during a game with the board menu';

  @override
  String get preferencesInCorrespondenceGames => 'U dopisnim partijama';

  @override
  String get preferencesCorrespondenceAndUnlimited => 'Dopisni šah i neograničene partije';

  @override
  String get preferencesConfirmResignationAndDrawOffers => 'Potvrdi predaju i ponudu za remi';

  @override
  String get preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook => 'Način rošade';

  @override
  String get preferencesCastleByMovingTwoSquares => 'Pomakni kralja dvije kocke';

  @override
  String get preferencesCastleByMovingOntoTheRook => 'Pomakni kralja na kulu';

  @override
  String get preferencesInputMovesWithTheKeyboard => 'Omogući unošenje poteza tipkovnicom';

  @override
  String get preferencesInputMovesWithVoice => 'Input moves with your voice';

  @override
  String get preferencesSnapArrowsToValidMoves => 'Crtaj strelice za planiranje budućih poteza';

  @override
  String get preferencesSayGgWpAfterLosingOrDrawing => 'Reci \"Dobra partija, odlićno odigrano\" kad izgubiš ili odigraš remi';

  @override
  String get preferencesYourPreferencesHaveBeenSaved => 'Tvoje promjene su spremljene.';

  @override
  String get preferencesScrollOnTheBoardToReplayMoves => 'Pomakni kotačić miša iznad ploče za pregled poteza';

  @override
  String get preferencesCorrespondenceEmailNotification => 'Dnevna obavijest putem pošte s popisom vaših dopisnih igara';

  @override
  String get preferencesNotifyStreamStart => 'Streamer ide uživo';

  @override
  String get preferencesNotifyInboxMsg => 'Nova poruka u ulaznoj pošti';

  @override
  String get preferencesNotifyForumMention => 'Forumski komentar vas spominje';

  @override
  String get preferencesNotifyInvitedStudy => 'Poziv za Study';

  @override
  String get preferencesNotifyGameEvent => 'Ažuriranja dopisnih igara';

  @override
  String get preferencesNotifyChallenge => 'Izazovi';

  @override
  String get preferencesNotifyTournamentSoon => 'Turnir započinje ubrzo';

  @override
  String get preferencesNotifyTimeAlarm => 'Sat za dopisivanje ističe';

  @override
  String get preferencesNotifyBell => 'Obavijest zvonom unutar Lichessa';

  @override
  String get preferencesNotifyPush => 'Obavijest uređaja kada niste na Lichessu';

  @override
  String get preferencesNotifyWeb => 'Preglednik';

  @override
  String get preferencesNotifyDevice => 'Uređaj';

  @override
  String get preferencesBellNotificationSound => 'Obavijest kao zvuk';

  @override
  String get puzzlePuzzles => 'Zadaci';

  @override
  String get puzzlePuzzleThemes => 'Kategorije zadataka';

  @override
  String get puzzleRecommended => 'Preporučeno';

  @override
  String get puzzlePhases => 'Faze';

  @override
  String get puzzleMotifs => 'Motivi';

  @override
  String get puzzleAdvanced => 'Napredno';

  @override
  String get puzzleLengths => 'Duljine';

  @override
  String get puzzleMates => 'Matevi';

  @override
  String get puzzleGoals => 'Ciljevi';

  @override
  String get puzzleOrigin => 'Podrijetlo';

  @override
  String get puzzleSpecialMoves => 'Specifični potezi';

  @override
  String get puzzleDidYouLikeThisPuzzle => 'Sviđa li ti se ovaj zadatak?';

  @override
  String get puzzleVoteToLoadNextOne => 'Ocijeni i prijeđi na sljedeći zadatak!';

  @override
  String get puzzleUpVote => 'Glasaj za zagonetku';

  @override
  String get puzzleDownVote => 'Glasaj protiv zagonetke';

  @override
  String get puzzleYourPuzzleRatingWillNotChange => 'Tvoj rejting zadataka se neće promjeniti. Imaj na umu da rješavanje zadaka nije natjecanje. Rejting prvenstveno pomaže u odabiru najboljih zadataka za tvoj trenutni nivo vještine.';

  @override
  String get puzzleFindTheBestMoveForWhite => 'Pronađi najbolji potez za bijelog.';

  @override
  String get puzzleFindTheBestMoveForBlack => 'Pronađi najbolji potez za crnog.';

  @override
  String get puzzleToGetPersonalizedPuzzles => 'Za personalizirane zadatke:';

  @override
  String puzzlePuzzleId(String param) {
    return 'Zadatak $param';
  }

  @override
  String get puzzlePuzzleOfTheDay => 'Zadatak dana';

  @override
  String get puzzleDailyPuzzle => 'Dnevna zagonetka';

  @override
  String get puzzleClickToSolve => 'Klikni za rješenje';

  @override
  String get puzzleGoodMove => 'Dobar potez';

  @override
  String get puzzleBestMove => 'Najbolji potez!';

  @override
  String get puzzleKeepGoing => 'Nastavi…';

  @override
  String get puzzlePuzzleSuccess => 'Uspješno obavljeno!';

  @override
  String get puzzlePuzzleComplete => 'Zadatak riješen!';

  @override
  String get puzzleByOpenings => 'Prema otvaranjima';

  @override
  String get puzzlePuzzlesByOpenings => 'Zagonetke prema otvaranjima';

  @override
  String get puzzleOpeningsYouPlayedTheMost => 'Otvaranje koje si najviše igrao u rangiranim igrama';

  @override
  String get puzzleUseFindInPage => 'Koristi \"Pronađi na stranici\" u izborniku preglednika da bi pronašao svoje omiljeno otvaranje!';

  @override
  String get puzzleUseCtrlF => 'Koristi Ctrl+f da bi pronašao svoje omiljeno otvaranje!';

  @override
  String get puzzleNotTheMove => 'Netočan odgovor!';

  @override
  String get puzzleTrySomethingElse => 'Pokušaj nešto drugo.';

  @override
  String puzzleRatingX(String param) {
    return 'Rejting: $param';
  }

  @override
  String get puzzleHidden => 'skriven';

  @override
  String puzzleFromGameLink(String param) {
    return 'Iz partije $param';
  }

  @override
  String get puzzleContinueTraining => 'Nastavi sa zadacima';

  @override
  String get puzzleDifficultyLevel => 'Težina zadataka';

  @override
  String get puzzleNormal => 'Srednje';

  @override
  String get puzzleEasier => 'Lakše';

  @override
  String get puzzleEasiest => 'Najlakše';

  @override
  String get puzzleHarder => 'Teže';

  @override
  String get puzzleHardest => 'Najteže';

  @override
  String get puzzleExample => 'Primjer';

  @override
  String get puzzleAddAnotherTheme => 'Dodaj novu kategoriju';

  @override
  String get puzzleNextPuzzle => 'Sljedeća puzla';

  @override
  String get puzzleJumpToNextPuzzleImmediately => 'Automatski učitaj nove zadatke';

  @override
  String get puzzlePuzzleDashboard => 'Sučelje zadataka';

  @override
  String get puzzleImprovementAreas => 'Nedostaci';

  @override
  String get puzzleStrengths => 'Prednosti';

  @override
  String get puzzleHistory => 'Povijest zadataka';

  @override
  String get puzzleSolved => 'riješeno';

  @override
  String get puzzleFailed => 'neuspješno';

  @override
  String get puzzleStreakDescription => 'Stvori pobjednički niz rješavajući sve teže zadatke bez vremenskog ograničenja. Jedan krivi potez i igraje gotova! Dozvoljeno je preskočiti jedan potez u sesiji.';

  @override
  String puzzleYourStreakX(String param) {
    return 'Tvoj niz: $param';
  }

  @override
  String get puzzleStreakSkipExplanation => 'Preskoči ovaj potez da zadržiš pobjednički niz! Dozvoljeno je jedno preskakanje po sesiji.';

  @override
  String get puzzleContinueTheStreak => 'Nastavite niz';

  @override
  String get puzzleNewStreak => 'Novi niz';

  @override
  String get puzzleFromMyGames => 'Iz mojih partija';

  @override
  String get puzzleLookupOfPlayer => 'Pronađi zadatke iz igračevih partija';

  @override
  String puzzleFromXGames(String param) {
    return 'Zadatci iz partija igrača $param';
  }

  @override
  String get puzzleSearchPuzzles => 'Pretraži zadatke';

  @override
  String get puzzleFromMyGamesNone => 'Nema tvojih zadataka u bazi, ali Lichess te i dalje puno voli.\n\nIgraj rapid i classic partije da povećaš vjerojatnost da zadatak iz tvoje partije bude dodan!';

  @override
  String puzzleFromXGamesFound(String param1, String param2) {
    return '$param1 zadatka su nađena u $param2 partija';
  }

  @override
  String get puzzlePuzzleDashboardDescription => 'Vježbaj, analiziraj, unaprijedi';

  @override
  String puzzlePercentSolved(String param) {
    return '$param riješenih';
  }

  @override
  String get puzzleNoPuzzlesToShow => 'Niste odigrali ni jedan zadatak.';

  @override
  String get puzzleImprovementAreasDescription => 'Vježbaj ove zadatke da bi optimalno napredovao!';

  @override
  String get puzzleStrengthDescription => 'Ove teme ti idu najbolje';

  @override
  String puzzlePlayedXTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odigrano $count puta',
      few: 'Odigrano $count puta',
      one: 'Odigrano $count puta',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsBelowYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodova ispod tvog rejtinga iz zadataka',
      few: '$count bodova ispod tvog rejtinga iz zadataka',
      one: '$count bod ispod tvog rejtinga iz zadataka',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPointsAboveYourPuzzleRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodova iznad tvog rejtinga iz zadataka',
      few: '$count bodova iznad tvog rejtinga iz zadataka',
      one: '$count bod iznad tvog rejtinga iz zadataka',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odigranih',
      few: '$count odigrana',
      one: '$count odigran',
    );
    return '$_temp0';
  }

  @override
  String puzzleNbToReplay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count za pregledati',
      few: '$count za pregledati',
      one: '$count za pregledati',
    );
    return '$_temp0';
  }

  @override
  String get puzzleThemeAdvancedPawn => 'Pješak napreduje';

  @override
  String get puzzleThemeAdvancedPawnDescription => 'Pješak u postupku ili prijetnji promaknućem je ključan za taktiku.';

  @override
  String get puzzleThemeAdvantage => 'Prednost';

  @override
  String get puzzleThemeAdvantageDescription => 'Iskoristi priliku i pridobij odlučujuču prednost. (200cp ≤ eval ≤ 600cp)';

  @override
  String get puzzleThemeAnastasiaMate => 'Anastazijin mat';

  @override
  String get puzzleThemeAnastasiaMateDescription => 'Skakač i top ili dama udružuju se kako bi uhvatili protivničkog kralja u zamku između ruba ploče s jedne i njegove figure s druge strane.';

  @override
  String get puzzleThemeArabianMate => 'Arapski mat';

  @override
  String get puzzleThemeArabianMateDescription => 'Skakač i top udružuju snage kako bi zarobili suparničkog kralja u uglu igraće ploče.';

  @override
  String get puzzleThemeAttackingF2F7 => 'Napad na f2 ili f7 polje';

  @override
  String get puzzleThemeAttackingF2F7Description => 'Napad na f2 ili f7 pješaka kao što je napad lovcem popularno nazvan \"fried liver opening\".';

  @override
  String get puzzleThemeAttraction => 'Privlačenje';

  @override
  String get puzzleThemeAttractionDescription => 'Razmjena ili žrtva koja potiče ili forsira protivničke figure u poziciju koja omogućuje taktičke poteze koji donose prednost.';

  @override
  String get puzzleThemeBackRankMate => 'Mat na zadnjem redu';

  @override
  String get puzzleThemeBackRankMateDescription => 'Top ili dama matiraju kralja koji se nalazi na njegovom prvom redu (odnosno osmom iz perspektive protivnika) te je zagrađen svojim figurama.';

  @override
  String get puzzleThemeBishopEndgame => 'Lovčeva završnica';

  @override
  String get puzzleThemeBishopEndgameDescription => 'Završnica u kojoj sudjeluju samo lovci i pješaci.';

  @override
  String get puzzleThemeBodenMate => 'Bodenov mat';

  @override
  String get puzzleThemeBodenMateDescription => 'Dva lovca napadaju po unakrsnim dijagonalama i matiraju kralja okruženog njegovim figurama.';

  @override
  String get puzzleThemeCastling => 'Rokada';

  @override
  String get puzzleThemeCastlingDescription => 'Dovedi svog kralja na sigurno i postavi svog topa za napad.';

  @override
  String get puzzleThemeCapturingDefender => 'Eliminiraj obranu';

  @override
  String get puzzleThemeCapturingDefenderDescription => 'Eliminacijom figure koja brani ili je neizravno uključena u obranu druge figure omogućujete uzimanje figure koja ostaje bez obrane.';

  @override
  String get puzzleThemeCrushing => 'Uništavanje';

  @override
  String get puzzleThemeCrushingDescription => 'Uoči protivničku grešku te pridobij golemu prednost. (eval ≥ 600cp)';

  @override
  String get puzzleThemeDoubleBishopMate => 'Mat lovačkim parom';

  @override
  String get puzzleThemeDoubleBishopMateDescription => 'Lovački par zadaje mat na susjednim dijagonalama kralju zarobljenom iza prijateljske figure.';

  @override
  String get puzzleThemeDovetailMate => 'Lastin mat';

  @override
  String get puzzleThemeDovetailMateDescription => 'Kraljica zadaje mat dodirujuči protivničkog kralja po dijagonali. Kraljeva jedina polja za bijeg zauzeta su njegovim figurama.';

  @override
  String get puzzleThemeEquality => 'Izjednačenje';

  @override
  String get puzzleThemeEqualityDescription => 'Pronađi potez koji te dovodi iz gubitničke u podjednaku poziciju. (eval ≤ 200cp)';

  @override
  String get puzzleThemeKingsideAttack => 'Napad na kraljevoj strani';

  @override
  String get puzzleThemeKingsideAttackDescription => 'Napad na protivničkog kralja nakon što je protivnik odigrao malu rokadu.';

  @override
  String get puzzleThemeClearance => 'Čiščenje';

  @override
  String get puzzleThemeClearanceDescription => 'Potez (najčešće s tempom) koji oslobađa polje, red ili dijagonalu za nadolazeću taktičku ideju.';

  @override
  String get puzzleThemeDefensiveMove => 'Obrambeni potez';

  @override
  String get puzzleThemeDefensiveMoveDescription => 'Određeni potez ili slijed poteza koje je potrebno odigrati za zadržavanje materijala ili pozicije.';

  @override
  String get puzzleThemeDeflection => 'Odvraćanje';

  @override
  String get puzzleThemeDeflectionDescription => 'Potez koji odvraća protivničku figuru od dužnosti koju obavlja (kao što je kontroliranje značajnog polja). Ova taktika se također zove i \"preopterećenje\".';

  @override
  String get puzzleThemeDiscoveredAttack => 'Otkriveni napad';

  @override
  String get puzzleThemeDiscoveredAttackDescription => 'Napad izvršen kad se figura koja blokira drugu figuru (kraljicu, lovca ili topa) skloni sa određene dijagonale, reda ili stupca.';

  @override
  String get puzzleThemeDoubleCheck => 'Dvostruki šah';

  @override
  String get puzzleThemeDoubleCheckDescription => 'Šah kojeg daju dvije figure istovremeno kao rezultat otkrivenog šaha.';

  @override
  String get puzzleThemeEndgame => 'Završnica';

  @override
  String get puzzleThemeEndgameDescription => 'Taktički potezi u završnici.';

  @override
  String get puzzleThemeEnPassantDescription => 'Taktika koja uključuje pravilo \"en passant\" po kojem pješak uzima protivničkog pješaka koji ga preskače koristeći inicijalno otvaranje pješaka za dva polja.';

  @override
  String get puzzleThemeExposedKing => 'Golišavi kralj';

  @override
  String get puzzleThemeExposedKingDescription => 'Taktika koja uključuje kralja okruženim nekolicinom obrambenih figura što često rezultira matom.';

  @override
  String get puzzleThemeFork => 'Rašlje';

  @override
  String get puzzleThemeForkDescription => 'Situacija u šahovskoj partiji kad jedna figura napadne dvije ili više protivničkih.';

  @override
  String get puzzleThemeHangingPiece => 'Viseća figura';

  @override
  String get puzzleThemeHangingPieceDescription => 'Taktika koja uključuje neobranjenu ili nedovoljno obranjenu protivničku figuru besplatnu za uzimanje.';

  @override
  String get puzzleThemeHookMate => 'Kuka-mat';

  @override
  String get puzzleThemeHookMateDescription => 'U kuka-matu sudjeluju top, skakač i pješak te jedan protivnički pješak koji onemogućuje bijeg svom kralju.';

  @override
  String get puzzleThemeInterference => 'Podmetanje';

  @override
  String get puzzleThemeInterferenceDescription => 'Pomicanje figure između dvije protivničke figure pritom ih napadajući. Kao rezultat protivnik nije u mogućnosti obraniti obe figure.';

  @override
  String get puzzleThemeIntermezzo => 'Međupotez';

  @override
  String get puzzleThemeIntermezzoDescription => 'Potez koji se igra prije očekivanog poteza koji predstavlja direktnu prijetnju na koju protivnik mora odgovoriti.';

  @override
  String get puzzleThemeKnightEndgame => 'Skakačeva završnica';

  @override
  String get puzzleThemeKnightEndgameDescription => 'Završnica u kojoj sudjeluju samo skakači i pješaci.';

  @override
  String get puzzleThemeLong => 'Dugi zadatak';

  @override
  String get puzzleThemeLongDescription => 'Tri poteza za pobjedu.';

  @override
  String get puzzleThemeMaster => 'Majstorske partije';

  @override
  String get puzzleThemeMasterDescription => 'Zadaci iz partija odigranih od strane igrača s titulom.';

  @override
  String get puzzleThemeMasterVsMaster => 'Majstor protiv majstora';

  @override
  String get puzzleThemeMasterVsMasterDescription => 'Zadaci iz partija odigranih između igrača s titulama.';

  @override
  String get puzzleThemeMate => 'Mat';

  @override
  String get puzzleThemeMateDescription => 'Pobijedi sa stilom.';

  @override
  String get puzzleThemeMateIn1 => 'Mat u 1';

  @override
  String get puzzleThemeMateIn1Description => 'Matiraj protivnika u jednom potezu.';

  @override
  String get puzzleThemeMateIn2 => 'Mat u 2';

  @override
  String get puzzleThemeMateIn2Description => 'Matiraj protivnika u dva poteza.';

  @override
  String get puzzleThemeMateIn3 => 'Mat u 3';

  @override
  String get puzzleThemeMateIn3Description => 'Matiraj protivnika u tri poteza.';

  @override
  String get puzzleThemeMateIn4 => 'Mat u 4';

  @override
  String get puzzleThemeMateIn4Description => 'Matiraj protivnika u četiri poteza.';

  @override
  String get puzzleThemeMateIn5 => 'Mat u 5 ili više';

  @override
  String get puzzleThemeMateIn5Description => 'Pronađi slijed koji uključuje više od četiri poteza i dovodi do mata.';

  @override
  String get puzzleThemeMiddlegame => 'Središnjica';

  @override
  String get puzzleThemeMiddlegameDescription => 'Taktički potezi u središnjici.';

  @override
  String get puzzleThemeOneMove => 'Jednopotezni zadatak';

  @override
  String get puzzleThemeOneMoveDescription => 'Zadatak koji se sastoji od samo jednog poteza.';

  @override
  String get puzzleThemeOpening => 'Otvaranje';

  @override
  String get puzzleThemeOpeningDescription => 'Taktički potezi u otvaranju.';

  @override
  String get puzzleThemePawnEndgame => 'Pješačka završnica';

  @override
  String get puzzleThemePawnEndgameDescription => 'Završnica koja uključuje samo pješake.';

  @override
  String get puzzleThemePin => 'Svezivanje';

  @override
  String get puzzleThemePinDescription => 'Taktika koja uključuje protivničku figuru koja je vezana za kralja ili drugu figuru veče vrijednosti.';

  @override
  String get puzzleThemePromotion => 'Unapređenje';

  @override
  String get puzzleThemePromotionDescription => 'Pješak u postupku ili prijetnji promaknućem je ključan za taktiku.';

  @override
  String get puzzleThemeQueenEndgame => 'Kraljičina završnica';

  @override
  String get puzzleThemeQueenEndgameDescription => 'Završnica u kojoj sudjeluju samo kraljica i pješaci.';

  @override
  String get puzzleThemeQueenRookEndgame => 'Kraljica i top';

  @override
  String get puzzleThemeQueenRookEndgameDescription => 'Završnica u kojoj sudjeluju isključivo kraljica, top i pješaci.';

  @override
  String get puzzleThemeQueensideAttack => 'Napad na kraljičinu stranu';

  @override
  String get puzzleThemeQueensideAttackDescription => 'Napad na protivničkog kralja nakon što je protivnik odigrao veliku rokadu.';

  @override
  String get puzzleThemeQuietMove => 'Tihi potez';

  @override
  String get puzzleThemeQuietMoveDescription => 'Potez koji ne uzima protivničku figuru ni ne stavlja protivničkog kralja u šah ali zato priprema neizbježnu prijetnju za nadolazeće poteze.';

  @override
  String get puzzleThemeRookEndgame => 'Topovska završnica';

  @override
  String get puzzleThemeRookEndgameDescription => 'Završnica u kojoj sudjeluju samo topovi i pješaci.';

  @override
  String get puzzleThemeSacrifice => 'Žrtva';

  @override
  String get puzzleThemeSacrificeDescription => 'Taktika koja uključuje žrtvu koja rezultira stjecanjem prednosti neposredno nakon forsiranog slijeda poteza.';

  @override
  String get puzzleThemeShort => 'Kratki zadatak';

  @override
  String get puzzleThemeShortDescription => 'Dva poteza za pobjedu.';

  @override
  String get puzzleThemeSkewer => 'Ražanj';

  @override
  String get puzzleThemeSkewerDescription => 'Napadom figura sa linijskim djelovanjem (dama, top ili lovac) na jednu figuru (npr. kralja), napadnuta se figura prisiljava na povlačenje što vodi gubitku figure, koja se nalazi na istoj liniji kao i napadnuta figura.';

  @override
  String get puzzleThemeSmotheredMate => 'Ugušeni mat';

  @override
  String get puzzleThemeSmotheredMateDescription => 'Mat kojeg skakač vrši nad kraljem kojemu njegove figure onemogućuju bijeg.';

  @override
  String get puzzleThemeSuperGM => 'Super-velemajstorske igre';

  @override
  String get puzzleThemeSuperGMDescription => 'Zadaci iz partija najboljih svjetskih velemajstora.';

  @override
  String get puzzleThemeTrappedPiece => 'Zarobljena figura';

  @override
  String get puzzleThemeTrappedPieceDescription => 'Figura koja ne može pobjeći uzimanju.';

  @override
  String get puzzleThemeUnderPromotion => 'Potpromaknuće';

  @override
  String get puzzleThemeUnderPromotionDescription => 'Promaknuće u skakača, lovca ili topa.';

  @override
  String get puzzleThemeVeryLong => 'Iznimno duga puzla';

  @override
  String get puzzleThemeVeryLongDescription => 'Slijed od četiri ili više poteza nužan za pobjedu.';

  @override
  String get puzzleThemeXRayAttack => 'Rendgenski napad';

  @override
  String get puzzleThemeXRayAttackDescription => 'Figura napada ili brani polje kroz protivničku figuru.';

  @override
  String get puzzleThemeZugzwang => 'Iznuđeni potez (Zugzwang)';

  @override
  String get puzzleThemeZugzwangDescription => 'Protivnik je prisiljen odigrati potez koji mu pogoršava poziciju.';

  @override
  String get puzzleThemeHealthyMix => 'Pomalo svega';

  @override
  String get puzzleThemeHealthyMixDescription => 'Kao i u pravim partijama - budi spreman i očekuj bilo što! Kombinacija svih navedenih vrsta zadataka.';

  @override
  String get puzzleThemePlayerGames => 'Igračeve partije';

  @override
  String get puzzleThemePlayerGamesDescription => 'Pogledaj zadatke generirate iz vlastitih partija ili iz partija određenog igrača.';

  @override
  String puzzleThemePuzzleDownloadInformation(String param) {
    return 'Ovi zadaci su u javnom vlasništvu i mogu biti preuzeti sa $param.';
  }

  @override
  String get searchSearch => 'Traži';

  @override
  String get settingsSettings => 'Postavke';

  @override
  String get settingsCloseAccount => 'Zatvori račun';

  @override
  String get settingsManagedAccountCannotBeClosed => 'Vašim računom se upravlja i ne može se zatvoriti.';

  @override
  String get settingsClosingIsDefinitive => 'Zatvaranje je konačno. Nema povratka. Jesi li siguran?';

  @override
  String get settingsCantOpenSimilarAccount => 'Neće ti biti dopušteno otvaranje novog računa s istim imenom, čak i ako kapitalizacija slova bude drugačija.';

  @override
  String get settingsChangedMindDoNotCloseAccount => 'Predomislio/la sam se, ne zatvaraj moj račun';

  @override
  String get settingsCloseAccountExplanation => 'Jeste li sigurni da želite zatvoriti račun? Zatvaranje računa je trajna odluka. Više se NIKADA nećete moći prijaviti.';

  @override
  String get settingsThisAccountIsClosed => 'Račun je zatvoren.';

  @override
  String get playWithAFriend => 'Igraj protiv prijatelja';

  @override
  String get playWithTheMachine => 'Igraj protiv računala';

  @override
  String get toInviteSomeoneToPlayGiveThisUrl => 'Za poziv na igru, pošalji ovaj URL';

  @override
  String get gameOver => 'Igra gotova';

  @override
  String get waitingForOpponent => 'Čekam protivnika';

  @override
  String get orLetYourOpponentScanQrCode => 'Ili dopusti da tvoj protivnik skenira QR kod';

  @override
  String get waiting => 'Čekanje';

  @override
  String get yourTurn => 'Tvoj potez';

  @override
  String aiNameLevelAiLevel(String param1, String param2) {
    return '$param1 razina $param2';
  }

  @override
  String get level => 'Razina';

  @override
  String get strength => 'Jačina';

  @override
  String get toggleTheChat => 'Uključi/isključi chat';

  @override
  String get chat => 'Chat';

  @override
  String get resign => 'Predaj partiju';

  @override
  String get checkmate => 'Šah mat';

  @override
  String get stalemate => 'Pat';

  @override
  String get white => 'Bijeli';

  @override
  String get black => 'Crni';

  @override
  String get asWhite => 'kao bijeli';

  @override
  String get asBlack => 'kao crni';

  @override
  String get randomColor => 'Nasumična boja';

  @override
  String get createAGame => 'Kreiraj partiju';

  @override
  String get whiteIsVictorious => 'Bijeli je pobjednik';

  @override
  String get blackIsVictorious => 'Crni je pobjednik';

  @override
  String get youPlayTheWhitePieces => 'Igraš bijelim figurama';

  @override
  String get youPlayTheBlackPieces => 'Igraš crnim figurama';

  @override
  String get itsYourTurn => 'Ti si na redu!';

  @override
  String get cheatDetected => 'Varanje otkriveno';

  @override
  String get kingInTheCenter => 'Kralj na centru';

  @override
  String get threeChecks => 'Tri šaha';

  @override
  String get raceFinished => 'Utrka je završena';

  @override
  String get variantEnding => 'Kraj varijacije';

  @override
  String get newOpponent => 'Novi protivnik';

  @override
  String get yourOpponentWantsToPlayANewGameWithYou => 'Tvoj protivnik želi novu partiju s tobom';

  @override
  String get joinTheGame => 'Pridruži se igri';

  @override
  String get whitePlays => 'Bijeli je na potezu';

  @override
  String get blackPlays => 'Crni je na potezu';

  @override
  String get opponentLeftChoices => 'Drugi igrač je napustio partiju. Možeš proglasiti pobjedu, proglasiti partiju remijem ili ga pričekati.';

  @override
  String get forceResignation => 'Proglasi pobjedu';

  @override
  String get forceDraw => 'Forsiranje remija';

  @override
  String get talkInChat => 'Pristojno se ponašaj u chatu!';

  @override
  String get theFirstPersonToComeOnThisUrlWillPlayWithYou => 'Prva osoba koja dođe na ovaj URL će igrati s tobom';

  @override
  String get whiteResigned => 'Bijeli predaje';

  @override
  String get blackResigned => 'Crni predaje';

  @override
  String get whiteLeftTheGame => 'Bijeli je napustio partiju';

  @override
  String get blackLeftTheGame => 'Crni je napustio partiju';

  @override
  String get whiteDidntMove => 'Bijeli igrač nije odigrao potez';

  @override
  String get blackDidntMove => 'Crni nije odigrao potez';

  @override
  String get requestAComputerAnalysis => 'Zatraži računalnu analizu';

  @override
  String get computerAnalysis => 'Računalna analiza';

  @override
  String get computerAnalysisAvailable => 'Dostupna računalna analiza';

  @override
  String get computerAnalysisDisabled => 'Računalna analiza je onemogućena';

  @override
  String get analysis => 'Ploča za analizu';

  @override
  String depthX(String param) {
    return 'Dubina $param';
  }

  @override
  String get usingServerAnalysis => 'U uporabi je serverska analiza';

  @override
  String get loadingEngine => 'Učitavanje računalne analize...';

  @override
  String get calculatingMoves => 'Kalkuliranje poteza...';

  @override
  String get engineFailed => 'Greška pri učitavanju šahovskog programa';

  @override
  String get cloudAnalysis => 'Analiza u oblaku';

  @override
  String get goDeeper => 'Idi dublje';

  @override
  String get showThreat => 'Pokaži prijetnju';

  @override
  String get inLocalBrowser => 'u lokalnom pregledniku';

  @override
  String get toggleLocalEvaluation => 'Prekidač za lokalnu evaluaciju';

  @override
  String get promoteVariation => 'Promakni varijaciju';

  @override
  String get makeMainLine => 'Napravi glavnu liniju';

  @override
  String get deleteFromHere => 'Obriši s popisa';

  @override
  String get collapseVariations => 'Collapse variations';

  @override
  String get expandVariations => 'Expand variations';

  @override
  String get forceVariation => 'Promakni varijaciju';

  @override
  String get copyVariationPgn => 'Kopiraj varijaciju PGN-a';

  @override
  String get move => 'Potez';

  @override
  String get variantLoss => 'Poraz varijante';

  @override
  String get variantWin => 'Pobjeda varijante';

  @override
  String get insufficientMaterial => 'Nedostatan materijal';

  @override
  String get pawnMove => 'Potez pješakom';

  @override
  String get capture => 'Uzimanje figure';

  @override
  String get close => 'Zatvori';

  @override
  String get winning => 'Pobjeđuje';

  @override
  String get losing => 'Gubi';

  @override
  String get drawn => 'Remizira';

  @override
  String get unknown => 'Nepoznati ishod';

  @override
  String get database => 'Baza podataka';

  @override
  String get whiteDrawBlack => 'Bijeli / remi / Crni';

  @override
  String averageRatingX(String param) {
    return 'Prosječni rejting: $param';
  }

  @override
  String get recentGames => 'Nedavne partije';

  @override
  String get topGames => 'Najjače partije';

  @override
  String masterDbExplanation(String param1, String param2, String param3) {
    return 'Dva milijuna OTB partija FIDE rangiranih igrača ($param1+ FIDE rejting) igranih od $param2. do $param3. godine';
  }

  @override
  String get dtzWithRounding => 'DTZ50\'\' sa zaokruživanjem, na temelju broja polupoteza do sljedećeg hvatanja ili poteza pješaka';

  @override
  String get noGameFound => 'Nije pronađena nijedna partija';

  @override
  String get maxDepthReached => 'Maksimalna dubina postignuta!';

  @override
  String get maybeIncludeMoreGamesFromThePreferencesMenu => 'Probaj uključiti više partija u postavkama pretraživača pozicija';

  @override
  String get openings => 'Otvaranja';

  @override
  String get openingExplorer => 'Pretraživač otvaranja';

  @override
  String get openingEndgameExplorer => 'Proučavanje otvaranja i završnica';

  @override
  String xOpeningExplorer(String param) {
    return '$param pretraživač otvaranja';
  }

  @override
  String get playFirstOpeningEndgameExplorerMove => 'Odigraj prvo otvaranje/završnički-istraživački potez';

  @override
  String get winPreventedBy50MoveRule => 'Pobjeda spriječena na bazi pravila o 50 poteza';

  @override
  String get lossSavedBy50MoveRule => 'Poraz spriječen na bazi pravila o 50 poteza';

  @override
  String get winOr50MovesByPriorMistake => 'Pobjeda ili 50 poteza prethodnom greškom';

  @override
  String get lossOr50MovesByPriorMistake => 'Gubitak ili 50 poteza prethodnom greškom';

  @override
  String get unknownDueToRounding => 'Pobjeda/gubitak su zajamčeni samo ako se slijedila preporučena osnovna linija tablice od posljednjeg hvatanja ili poteza pješaka, zbog mogućeg zaokruživanja DTZ vrijednosti u Syzygy bazama tablica.';

  @override
  String get allSet => 'U redu';

  @override
  String get importPgn => 'Uvezi PGN';

  @override
  String get delete => 'Izbriši';

  @override
  String get deleteThisImportedGame => 'Želiš li izbrisati ovu uvezenu partiju?';

  @override
  String get replayMode => 'Repriza partije';

  @override
  String get realtimeReplay => 'U stvarnom vremenu';

  @override
  String get byCPL => 'Po SDP';

  @override
  String get openStudy => 'Otvori studiju';

  @override
  String get enable => 'Omogući';

  @override
  String get bestMoveArrow => 'Strelica za najbolji potez';

  @override
  String get showVariationArrows => 'Pokaži strelice varijacija';

  @override
  String get evaluationGauge => 'Mjerilo evaluacije';

  @override
  String get multipleLines => 'Višestrukih varijanti';

  @override
  String get cpus => 'Procesora';

  @override
  String get memory => 'Memorija';

  @override
  String get infiniteAnalysis => 'Neprekidna analiza';

  @override
  String get removesTheDepthLimit => 'Uklanja granicu do koje računalo može analizirati, i održava tvoje računalo toplim';

  @override
  String get engineManager => 'Upravitelj enginea';

  @override
  String get blunder => 'Gruba greška';

  @override
  String get mistake => 'Greška';

  @override
  String get inaccuracy => 'Nepreciznost';

  @override
  String get moveTimes => 'Vrijeme za potez';

  @override
  String get flipBoard => 'Okreni ploču';

  @override
  String get threefoldRepetition => 'Trostruko ponavljanje pozicije';

  @override
  String get claimADraw => 'Proglasi remi';

  @override
  String get offerDraw => 'Ponudi remi';

  @override
  String get draw => 'Remi';

  @override
  String get drawByMutualAgreement => 'Neriješeno dogovorom igrača';

  @override
  String get fiftyMovesWithoutProgress => '50 poteza bez napretka';

  @override
  String get currentGames => 'Partije u tijeku';

  @override
  String get viewInFullSize => 'Pogledaj u punoj veličini';

  @override
  String get logOut => 'Odjavi se';

  @override
  String get signIn => 'Prijavi se';

  @override
  String get rememberMe => 'Zapamti me';

  @override
  String get youNeedAnAccountToDoThat => 'Za ovo trebaš korisnički račun';

  @override
  String get signUp => 'Registriraj se';

  @override
  String get computersAreNotAllowedToPlay => 'Računala i računalni programi ne smiju igrati. Molimo da ne koristiš pomoć programa, baze podataka ili drugih igrača za vrijeme igranja. Također, imaj na umu da se stvaranje više korisničkih računa ne ohrabruje i da prekomjerno korištenje istih može rezultirati zabranom pristupa.';

  @override
  String get games => 'Partije';

  @override
  String get forum => 'Forum';

  @override
  String xPostedInForumY(String param1, String param2) {
    return '$param1 objavljuje u temi $param2';
  }

  @override
  String get latestForumPosts => 'Najnovije objave na forumu';

  @override
  String get players => 'Igrači';

  @override
  String get friends => 'Prijatelji';

  @override
  String get discussions => 'Razgovori';

  @override
  String get today => 'Danas';

  @override
  String get yesterday => 'Jučer';

  @override
  String get minutesPerSide => 'Minuta po igraču';

  @override
  String get variant => 'Varijanta';

  @override
  String get variants => 'Varijante';

  @override
  String get timeControl => 'Vrijeme partije';

  @override
  String get realTime => 'Stvarno vrijeme';

  @override
  String get correspondence => 'Dopisni šah';

  @override
  String get daysPerTurn => 'Dana po potezu';

  @override
  String get oneDay => 'Jedan dan';

  @override
  String get time => 'Vrijeme';

  @override
  String get rating => 'Rejting';

  @override
  String get ratingStats => 'Statistike rejtinga';

  @override
  String get username => 'Korisničko ime';

  @override
  String get usernameOrEmail => 'Korisničko ime ili email';

  @override
  String get changeUsername => 'Promijeni korisničko ime';

  @override
  String get changeUsernameNotSame => 'Jedino se veličina slova može promijeniti. Primjerice, \'\'johndoe\'\' u \'\'JohnDoe\'\'.';

  @override
  String get changeUsernameDescription => 'Promijeni korisničko ime. Ovo možeš učiniti samo jednom i samo možeš promijeniti veličinu slova svog korisničkog imena.';

  @override
  String get signupUsernameHint => 'Obavezno odaberi obiteljsko korisničko ime. Ne možeš ga kasnije promijeniti i svi računi s neprikladnim korisničkim imenima bit će zatvoreni!';

  @override
  String get signupEmailHint => 'Koristit ćemo ga samo za ponovno postavljanje lozinke.';

  @override
  String get password => 'Lozinka';

  @override
  String get changePassword => 'Promijeni lozinku';

  @override
  String get changeEmail => 'Promijeni email';

  @override
  String get email => 'Email';

  @override
  String get passwordReset => 'Resetiraj lozinku';

  @override
  String get forgotPassword => 'Zaboravio/la si lozinku?';

  @override
  String get error_weakPassword => 'Ova je lozinka iznimno česta i previše je lako pogoditi.';

  @override
  String get error_namePassword => 'Molimo da ne koristitiš svoje korisničko ime kao lozinku.';

  @override
  String get blankedPassword => 'Koristio si istu lozinku na drugom mjestu, a to je mjesto ugroženo. Kako bismo osigurali sigurnost tvoga Lichess računa, potrebno je da postaviš novu lozinku. Hvala na razumijevanju.';

  @override
  String get youAreLeavingLichess => 'Odlazite sa Lichess-a';

  @override
  String get neverTypeYourPassword => 'Nikada nemojte upisivati svoju Lichess lozinku na drugom mjestu!';

  @override
  String proceedToX(String param) {
    return 'Nastavi s $param';
  }

  @override
  String get passwordSuggestion => 'Ne postavljaj lozinku koju je predložio netko drugi. Iskoristit će je da ti ukradu račun.';

  @override
  String get emailSuggestion => 'Ne postavljaj adresu e-pošte koju je predložio netko drugi. Iskoristit će je da ti ukradu račun.';

  @override
  String get emailConfirmHelp => 'Pomoć oko potvrde e-pošte';

  @override
  String get emailConfirmNotReceived => 'Nisi primo svoju potvrdnu e-poštu nakon prijave?';

  @override
  String get whatSignupUsername => 'Koje si korisničko ime koristio za prijavu?';

  @override
  String usernameNotFound(String param) {
    return 'Nismo mogli pronaći nijednog korisnika pod ovim imenom: $param.';
  }

  @override
  String get usernameCanBeUsedForNewAccount => 'Ovo korisničko ime možeš koristiti za stvaranje novog računa';

  @override
  String emailSent(String param) {
    return 'Poslali smo email na $param.';
  }

  @override
  String get emailCanTakeSomeTime => 'Može potrajati neko vrijeme dok stigne.';

  @override
  String get refreshInboxAfterFiveMinutes => 'Pričekaj 5 minuta i osvježi stranicu pristigle pošte.';

  @override
  String get checkSpamFolder => 'Također provjeri svoju mapu neželjene pošte jer bi mogla i tamo završiti. Ako je tako, označi ju da nije spam.';

  @override
  String get emailForSignupHelp => 'Ako ništa drugo ne uspije, pošalji nam ovu e-poruku:';

  @override
  String copyTextToEmail(String param) {
    return 'Kopiraj i zalijepi gornji tekst i pošalji ga $param';
  }

  @override
  String get waitForSignupHelp => 'Javit ćemo ti se uskoro kako bismo ti pomogli dovršiti tvoju registraciju.';

  @override
  String accountConfirmed(String param) {
    return 'Korisnik $param je uspješno potvrđen.';
  }

  @override
  String accountCanLogin(String param) {
    return 'Možeš se odmah prijaviti kao $param.';
  }

  @override
  String get accountConfirmationEmailNotNeeded => 'Nije ti potrebna potvrdna e-pošta.';

  @override
  String accountClosed(String param) {
    return 'Račun $param je zatvoren.';
  }

  @override
  String accountRegisteredWithoutEmail(String param) {
    return 'Račun $param je registriran bez e-pošte.';
  }

  @override
  String get rank => 'Rang';

  @override
  String rankX(String param) {
    return 'Rang: $param';
  }

  @override
  String get gamesPlayed => 'Broj odigranih partija';

  @override
  String get cancel => 'Odustani';

  @override
  String get whiteTimeOut => 'Bijelom je isteklo vrijeme';

  @override
  String get blackTimeOut => 'Crnom je isteklo vrijeme';

  @override
  String get drawOfferSent => 'Ponuda remija poslana';

  @override
  String get drawOfferAccepted => 'Ponuda remija prihvaćena';

  @override
  String get drawOfferCanceled => 'Opozvana ponuda remija';

  @override
  String get whiteOffersDraw => 'Bijeli nudi remi';

  @override
  String get blackOffersDraw => 'Crni nudi remi';

  @override
  String get whiteDeclinesDraw => 'Bijeli odbija remi';

  @override
  String get blackDeclinesDraw => 'Crni odbija remi';

  @override
  String get yourOpponentOffersADraw => 'Protivnik nudi remi';

  @override
  String get accept => 'Prihvati';

  @override
  String get decline => 'Odbij';

  @override
  String get playingRightNow => 'Upravo igraju';

  @override
  String get eventInProgress => 'Upravo igraju';

  @override
  String get finished => 'Završeno';

  @override
  String get abortGame => 'Prekini igru';

  @override
  String get gameAborted => 'Igra prekinuta';

  @override
  String get standard => 'Standardno';

  @override
  String get customPosition => 'Custom position';

  @override
  String get unlimited => 'Neograničeno';

  @override
  String get mode => 'Način';

  @override
  String get casual => 'Prijateljska';

  @override
  String get rated => 'Za bodove';

  @override
  String get casualTournament => 'Prijateljska';

  @override
  String get ratedTournament => 'Za bodove';

  @override
  String get thisGameIsRated => 'Ovo je partija za bodove';

  @override
  String get rematch => 'Revanš';

  @override
  String get rematchOfferSent => 'Ponuda za revanš poslana';

  @override
  String get rematchOfferAccepted => 'Ponuda za revanš prihvaćena';

  @override
  String get rematchOfferCanceled => 'Ponuda za revanš otkazana';

  @override
  String get rematchOfferDeclined => 'Ponuda za revanš odbijena';

  @override
  String get cancelRematchOffer => 'Otkaži ponudu za revanš';

  @override
  String get viewRematch => 'Pogledaj revanš';

  @override
  String get confirmMove => 'Potvrdi potez';

  @override
  String get play => 'Igraj';

  @override
  String get inbox => 'Dolazna pošta';

  @override
  String get chatRoom => 'Chat soba';

  @override
  String get loginToChat => 'Prijavi se za chat';

  @override
  String get youHaveBeenTimedOut => 'Trenutno ne možeš pričati u chatu.';

  @override
  String get spectatorRoom => 'Soba za gledatelje';

  @override
  String get composeMessage => 'Napiši poruku';

  @override
  String get subject => 'Tema';

  @override
  String get send => 'Pošalji';

  @override
  String get incrementInSeconds => 'Dodatak u sekundama';

  @override
  String get freeOnlineChess => 'Besplatni Internetski Šah';

  @override
  String get exportGames => 'Izvoz partija';

  @override
  String get ratingRange => 'Raspon rejtinga';

  @override
  String get thisAccountViolatedTos => 'Korisnički račun je prekršio Lichess Uvjete Pružanja Usluge';

  @override
  String get openingExplorerAndTablebase => 'Pretraživač otvaranja & baza pozicija u završnici';

  @override
  String get takeback => 'Vrati potez';

  @override
  String get proposeATakeback => 'Predloži vraćanje poteza';

  @override
  String get takebackPropositionSent => 'Ponuda vraćanja poteza poslana';

  @override
  String get takebackPropositionDeclined => 'Ponuda vraćanja poteza odbijena';

  @override
  String get takebackPropositionAccepted => 'Ponuda vraćanja poteza prihvaćena';

  @override
  String get takebackPropositionCanceled => 'Ponuda vraćanja poteza otkazana';

  @override
  String get yourOpponentProposesATakeback => 'Tvoj protivnik predlaže vraćanje poteza';

  @override
  String get bookmarkThisGame => 'Spremi ovu partiju';

  @override
  String get tournament => 'Turnir';

  @override
  String get tournaments => 'Turniri';

  @override
  String get tournamentPoints => 'Turnirski bodovi';

  @override
  String get viewTournament => 'Pogledaj turnir';

  @override
  String get backToTournament => 'Povratak na turnir';

  @override
  String get noDrawBeforeSwissLimit => 'You cannot draw before 30 moves are played in a Swiss tournament.';

  @override
  String get thematic => 'Tematski';

  @override
  String yourPerfRatingIsProvisional(String param) {
    return 'Tvoj $param rejting je privremen';
  }

  @override
  String yourPerfRatingIsTooHigh(String param1, String param2) {
    return 'Tvoj $param1 rejting ($param2) je previsok';
  }

  @override
  String yourTopWeeklyPerfRatingIsTooHigh(String param1, String param2) {
    return 'Tvoj najviši tjedni $param1 rejting ($param2) je previsok';
  }

  @override
  String yourPerfRatingIsTooLow(String param1, String param2) {
    return 'Tvoj $param1 rejting ($param2) je prenizak';
  }

  @override
  String ratedMoreThanInPerf(String param1, String param2) {
    return '$param2 rejting ≥ $param1';
  }

  @override
  String ratedLessThanInPerf(String param1, String param2) {
    return '$param2 rejting ≤ $param1';
  }

  @override
  String mustBeInTeam(String param) {
    return 'Moraš biti u timu $param';
  }

  @override
  String youAreNotInTeam(String param) {
    return 'Nisi u timu $param';
  }

  @override
  String get backToGame => 'Natrag na partiju';

  @override
  String get siteDescription => 'Besplatni internetski šah. Igraj odmah, u čistom sučelju. Bez registriranja, bez reklama, bez dodatnih preuzimanja. Igraj šah protiv računala, prijatelja ili nasumičnih protivnika.';

  @override
  String xJoinedTeamY(String param1, String param2) {
    return '$param1 se priključio timu $param2';
  }

  @override
  String xCreatedTeamY(String param1, String param2) {
    return '$param1 je osnovao tim $param2';
  }

  @override
  String get startedStreaming => 'je započeo stream';

  @override
  String xStartedStreaming(String param) {
    return '$param je započeo stream';
  }

  @override
  String get averageElo => 'Prosječni rejting';

  @override
  String get location => 'Lokacija';

  @override
  String get filterGames => 'Filtriraj partije';

  @override
  String get reset => 'Resetiraj postavke na originalne';

  @override
  String get apply => 'Primijeni';

  @override
  String get save => 'Spremi';

  @override
  String get leaderboard => 'Ljestvica';

  @override
  String get screenshotCurrentPosition => 'Uslikaj trenutnu poziciju';

  @override
  String get gameAsGIF => 'Igra u obliku GIF-a';

  @override
  String get pasteTheFenStringHere => 'Zalijepi FEN niz ovdje';

  @override
  String get pasteThePgnStringHere => 'Zalijepi PGN tekst ovdje';

  @override
  String get orUploadPgnFile => 'Ili učitaj PGN datoteku';

  @override
  String get fromPosition => 'Od pozicije';

  @override
  String get continueFromHere => 'Nastavi odavde';

  @override
  String get toStudy => 'Prouči';

  @override
  String get importGame => 'Uvezi partiju';

  @override
  String get importGameExplanation => 'Kada zalijepiš PGN neke partije, dobivaš reprizu partije (koju možeš pretraživati), \nračunalnu analizu, chat partije i URL za dijeljenje.';

  @override
  String get importGameCaveat => 'Varijacije će biti obrisane. Da bi ih sačuvao, uvezi PGN preko studije.';

  @override
  String get importGameDataPrivacyWarning => 'This PGN can be accessed by the public. To import a game privately, use a study.';

  @override
  String get thisIsAChessCaptcha => 'Ovo je šahovska CAPTCHA.';

  @override
  String get clickOnTheBoardToMakeYourMove => 'Klikni na ploču da povučeš potez i dokažeš da si čovjek.';

  @override
  String get captcha_fail => 'Molimo riješi šahovski Captcha.';

  @override
  String get notACheckmate => 'Nije mat';

  @override
  String get whiteCheckmatesInOneMove => 'Bijeli matira u jednom potezu';

  @override
  String get blackCheckmatesInOneMove => 'Crnu matira u jednom potezu';

  @override
  String get retry => 'Pokušaj ponovno';

  @override
  String get reconnecting => 'Ponovno spajanje';

  @override
  String get noNetwork => 'Offline';

  @override
  String get favoriteOpponents => 'Omiljeni protivnici';

  @override
  String get follow => 'Prati';

  @override
  String get following => 'Pratiš';

  @override
  String get unfollow => 'Prestani pratiti';

  @override
  String followX(String param) {
    return 'Prati $param';
  }

  @override
  String unfollowX(String param) {
    return 'Prestani pratiti $param';
  }

  @override
  String get block => 'Blokiraj';

  @override
  String get blocked => 'Blokirani';

  @override
  String get unblock => 'Odblokiraj';

  @override
  String get followsYou => 'Prati te';

  @override
  String xStartedFollowingY(String param1, String param2) {
    return '$param1 je počeo pratiti $param2';
  }

  @override
  String get more => 'Više';

  @override
  String get memberSince => 'Član od';

  @override
  String lastSeenActive(String param) {
    return 'Zadnja aktivnost $param';
  }

  @override
  String get player => 'Igrač';

  @override
  String get list => 'Lista';

  @override
  String get graph => 'Graf';

  @override
  String get required => 'Obvezno.';

  @override
  String get openTournaments => 'Otvoreni turniri';

  @override
  String get duration => 'Trajanje';

  @override
  String get winner => 'Pobjednik';

  @override
  String get standing => 'Poredak';

  @override
  String get createANewTournament => 'Kreiraj novi turnir';

  @override
  String get tournamentCalendar => 'Kalendar turnira';

  @override
  String get conditionOfEntry => 'Uvjet za sudjelovanje:';

  @override
  String get advancedSettings => 'Napredne postavke';

  @override
  String get safeTournamentName => 'Odaberi vrlo siguran naziv za turnir.';

  @override
  String get inappropriateNameWarning => 'Sve imalo neprikladno može trajno zatvoriti tvoj profil.';

  @override
  String get emptyTournamentName => 'Ako ostaviš prazno, turnir će se nazvati po nasumičnom velemajstoru.';

  @override
  String get makePrivateTournament => 'Učini turnir privatnim i ograniči pristup lozinkom';

  @override
  String get join => 'Pridruži se';

  @override
  String get withdraw => 'Odustani';

  @override
  String get points => 'Bodovi';

  @override
  String get wins => 'Pobjede';

  @override
  String get losses => 'Porazi';

  @override
  String get createdBy => 'Kreirao';

  @override
  String get tournamentIsStarting => 'Turnir počinje';

  @override
  String get tournamentPairingsAreNowClosed => 'Turnirska uparivanja su završena.';

  @override
  String standByX(String param) {
    return 'Uparivanje igrača - $param, pripremi se za igru!';
  }

  @override
  String get pause => 'Pauza';

  @override
  String get resume => 'Nastavi';

  @override
  String get youArePlaying => 'Igraš!';

  @override
  String get winRate => 'Postotak pobjeda';

  @override
  String get berserkRate => 'Postotak berserka';

  @override
  String get performance => 'Performans';

  @override
  String get tournamentComplete => 'Turnir završen';

  @override
  String get movesPlayed => 'Poteza igrano';

  @override
  String get whiteWins => 'Pobjede bijelog';

  @override
  String get blackWins => 'Pobjede crnog';

  @override
  String get drawRate => 'Draw rate';

  @override
  String get draws => 'Remi';

  @override
  String nextXTournament(String param) {
    return 'Sljedeći $param turnir:';
  }

  @override
  String get averageOpponent => 'Prosječni protivnik';

  @override
  String get boardEditor => 'Uredi ploču';

  @override
  String get setTheBoard => 'Postavi ploču';

  @override
  String get popularOpenings => 'Popularna otvaranja';

  @override
  String get endgamePositions => 'Pozicije u završnici';

  @override
  String chess960StartPosition(String param) {
    return 'Početna pozicija Chess960: $param';
  }

  @override
  String get startPosition => 'Početna pozicija';

  @override
  String get clearBoard => 'Očisti ploču';

  @override
  String get loadPosition => 'Učitaj poziciju';

  @override
  String get isPrivate => 'Privatno';

  @override
  String reportXToModerators(String param) {
    return 'Prijavi $param moderatorima';
  }

  @override
  String profileCompletion(String param) {
    return 'Profil je uređen $param';
  }

  @override
  String xRating(String param) {
    return '$param rejting';
  }

  @override
  String get ifNoneLeaveEmpty => 'Nemaš rejting? Ostavi polje prazno';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Uredi profil';

  @override
  String get realName => 'Real name';

  @override
  String get setFlair => 'Set your flair';

  @override
  String get flair => 'Flair';

  @override
  String get youCanHideFlair => 'There is a setting to hide all user flairs across the entire site.';

  @override
  String get biography => 'Životopis';

  @override
  String get countryRegion => 'Country or region';

  @override
  String get thankYou => 'Hvala!';

  @override
  String get socialMediaLinks => 'Linkovi društvenih mreža';

  @override
  String get oneUrlPerLine => 'Jedan URL po liniji.';

  @override
  String get inlineNotation => 'Kompaktnija notacija';

  @override
  String get makeAStudy => 'Za čuvanje i dijeljenje razmislite o izradi studije.';

  @override
  String get clearSavedMoves => 'Očisti poteze';

  @override
  String get previouslyOnLichessTV => 'Prethodno na Lichess TV-u';

  @override
  String get onlinePlayers => 'Online igrači';

  @override
  String get activePlayers => 'Aktivni igrači';

  @override
  String get bewareTheGameIsRatedButHasNoClock => 'Oprez, igra se za bodove ali ne i na vrijeme!';

  @override
  String get success => 'Uspjeh';

  @override
  String get automaticallyProceedToNextGameAfterMoving => 'Automatski prebaci na sljedeću partiju nakon odigranog poteza';

  @override
  String get autoSwitch => 'Prebaci automatski';

  @override
  String get puzzles => 'Problemi';

  @override
  String get onlineBots => 'Online bots';

  @override
  String get name => 'Ime';

  @override
  String get description => 'Opis';

  @override
  String get descPrivate => 'Privatni opis';

  @override
  String get descPrivateHelp => 'Tekst koji će vidjeti samo članovi tima. Ako je postavljen, zamjenjuje javni opis za članove tima.';

  @override
  String get no => 'Ne';

  @override
  String get yes => 'Da';

  @override
  String get help => 'Pomoć:';

  @override
  String get createANewTopic => 'Kreiraj novu temu';

  @override
  String get topics => 'Teme';

  @override
  String get posts => 'Objave';

  @override
  String get lastPost => 'Zadnja objava';

  @override
  String get views => 'Pregleda';

  @override
  String get replies => 'Odgovora';

  @override
  String get replyToThisTopic => 'Odgovori na ovu temu';

  @override
  String get reply => 'Odgovori';

  @override
  String get message => 'Poruka';

  @override
  String get createTheTopic => 'Kreiraj temu';

  @override
  String get reportAUser => 'Prijavi korisnika';

  @override
  String get user => 'Korisnik';

  @override
  String get reason => 'Razlog';

  @override
  String get whatIsIheMatter => 'U čemu je problem?';

  @override
  String get cheat => 'Varanje';

  @override
  String get troll => 'Provokacija';

  @override
  String get other => 'Ostalo';

  @override
  String get reportDescriptionHelp => 'Zalijepi link na partiju/e u pitanju i objasni što nije u redu s ponašanjem korisnika. Nemoj samo reći \"varao je\", nego reci kako si došao/la do tog zaključka. Tvoja prijava bit će obrađena brže ako ju napišeš na engleskom jeziku.';

  @override
  String get error_provideOneCheatedGameLink => 'Molimo navedite barem jedan link igre u kojoj je igrač varao.';

  @override
  String by(String param) {
    return 'od $param';
  }

  @override
  String importedByX(String param) {
    return 'Uvezao $param';
  }

  @override
  String get thisTopicIsNowClosed => 'Ova tema je zatvorena.';

  @override
  String get blog => 'Blog';

  @override
  String get notes => 'Zabilješke';

  @override
  String get typePrivateNotesHere => 'Upiši privatne zabilješke ovdje';

  @override
  String get writeAPrivateNoteAboutThisUser => 'Napišite privatnu bilješku o ovom korisniku';

  @override
  String get noNoteYet => 'Još nema bilješke';

  @override
  String get invalidUsernameOrPassword => 'Pogrešno korisničko ime ili lozinka';

  @override
  String get incorrectPassword => 'Netočna lozinka';

  @override
  String get invalidAuthenticationCode => 'Nevažeći kôd autentičnosti';

  @override
  String get emailMeALink => 'Pošalji mi email';

  @override
  String get currentPassword => 'Trenutna lozinka';

  @override
  String get newPassword => 'Nova lozinka';

  @override
  String get newPasswordAgain => 'Ponovi novu lozinku';

  @override
  String get newPasswordsDontMatch => 'Zaporke se ne podudaraju';

  @override
  String get newPasswordStrength => 'Snaga zaporke';

  @override
  String get clockInitialTime => 'Početno vrijeme';

  @override
  String get clockIncrement => 'Vremenski dodatak';

  @override
  String get privacy => 'Privatnost';

  @override
  String get privacyPolicy => 'Pravila privatnosti';

  @override
  String get letOtherPlayersFollowYou => 'Dopusti drugim igračima da te prate';

  @override
  String get letOtherPlayersChallengeYou => 'Dopusti drugim igračima da te izazovu';

  @override
  String get letOtherPlayersInviteYouToStudy => 'Dopusti drugim igračima da te pozovu u studiju';

  @override
  String get sound => 'Zvuk';

  @override
  String get none => 'Ništa';

  @override
  String get fast => 'Brzo';

  @override
  String get normal => 'Normalno';

  @override
  String get slow => 'Sporo';

  @override
  String get insideTheBoard => 'Unutar ploče';

  @override
  String get outsideTheBoard => 'Izvan ploče';

  @override
  String get allSquaresOfTheBoard => 'All squares of the board';

  @override
  String get onSlowGames => 'U sporim partijama';

  @override
  String get always => 'Uvijek';

  @override
  String get never => 'Nikad';

  @override
  String xCompetesInY(String param1, String param2) {
    return '$param1 se natječe u $param2';
  }

  @override
  String get victory => 'Pobjeda';

  @override
  String get defeat => 'Poraz';

  @override
  String victoryVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 u $param3';
  }

  @override
  String defeatVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 u $param3';
  }

  @override
  String drawVsYInZ(String param1, String param2, String param3) {
    return '$param1 vs $param2 u $param3';
  }

  @override
  String get timeline => 'Vremenska crta';

  @override
  String get starting => 'Počinje:';

  @override
  String get allInformationIsPublicAndOptional => 'Sve informacije su javne i neobavezne.';

  @override
  String get biographyDescription => 'Nešto više o vama, što volite u šahu, omiljena otvaranja, igre, igrači…';

  @override
  String get listBlockedPlayers => 'Popis blokiranih igrača';

  @override
  String get human => 'Osobe';

  @override
  String get computer => 'Računalo';

  @override
  String get side => 'Strana';

  @override
  String get clock => 'Sat';

  @override
  String get opponent => 'Protivnik';

  @override
  String get learnMenu => 'Uči';

  @override
  String get studyMenu => 'Uči';

  @override
  String get practice => 'Vježbaj';

  @override
  String get community => 'Zajednica';

  @override
  String get tools => 'Alati';

  @override
  String get increment => 'Dodatak';

  @override
  String get error_unknown => 'Nevažeća vrijednost';

  @override
  String get error_required => 'Ovo polje je obavezno';

  @override
  String get error_email => 'Ova email adresa je neispravna';

  @override
  String get error_email_acceptable => 'Ova email adresa nije prihvatljiva. Molimo provjerite ju te pokušajte ponovo.';

  @override
  String get error_email_unique => 'Email adresa je neispravna ili je već u upotrebi';

  @override
  String get error_email_different => 'Već koristiš ovu e-mail adresu';

  @override
  String error_minLength(String param) {
    return 'Minimalna dužina je $param';
  }

  @override
  String error_maxLength(String param) {
    return 'Maksimalna dužina je $param';
  }

  @override
  String error_min(String param) {
    return 'Mora biti veće ili jednako $param';
  }

  @override
  String error_max(String param) {
    return 'Mora biti manje ili jednako $param';
  }

  @override
  String ifRatingIsPlusMinusX(String param) {
    return 'Ukoliko je rejting ± $param';
  }

  @override
  String get ifRegistered => 'Ako je registriran';

  @override
  String get onlyExistingConversations => 'Samo već postojeći razgovori';

  @override
  String get onlyFriends => 'Samo prijatelji';

  @override
  String get menu => 'Izbornik';

  @override
  String get castling => 'Rokada';

  @override
  String get whiteCastlingKingside => 'Bijeli O-O';

  @override
  String get blackCastlingKingside => 'Crni O-O';

  @override
  String tpTimeSpentPlaying(String param) {
    return 'Vrijeme provedeno igrajući: $param';
  }

  @override
  String get watchGames => 'Gledaj partije';

  @override
  String tpTimeSpentOnTV(String param) {
    return 'Vrijeme na TV-u: $param';
  }

  @override
  String get watch => 'Gledaj';

  @override
  String get videoLibrary => 'Video knjižnica';

  @override
  String get streamersMenu => 'Streameri';

  @override
  String get mobileApp => 'Mobilna aplikacija';

  @override
  String get webmasters => 'Webmasteri';

  @override
  String get about => 'Više o';

  @override
  String aboutX(String param) {
    return 'Više o $param';
  }

  @override
  String xIsAFreeYLibreOpenSourceChessServer(String param1, String param2) {
    return '$param1 je besplatni ($param2) šah poslužitelj otvorenog koda i bez oglasa.';
  }

  @override
  String get really => 'više';

  @override
  String get contribute => 'Doprinesi';

  @override
  String get termsOfService => 'Uvjeti pružanja usluge';

  @override
  String get sourceCode => 'Izvorni kod';

  @override
  String get simultaneousExhibitions => 'Simultanke';

  @override
  String get host => 'Domaćin';

  @override
  String hostColorX(String param) {
    return 'Boja domaćina: $param';
  }

  @override
  String get yourPendingSimuls => 'Your pending simuls';

  @override
  String get createdSimuls => 'Novokreirane simultanke';

  @override
  String get hostANewSimul => 'Kreiraj novu simultanku';

  @override
  String get signUpToHostOrJoinASimul => 'Sign up to host or join a simul';

  @override
  String get noSimulFound => 'Simultanka nije pronađena';

  @override
  String get noSimulExplanation => 'Ova simultanka ne postoji.';

  @override
  String get returnToSimulHomepage => 'Vrati se na stranicu sa simultankama';

  @override
  String get aboutSimul => 'Simultanke uključuju jednog igrača koji igra protiv više protivnika odjednom.';

  @override
  String get aboutSimulImage => 'Od 50 protivnika, Fischer je pobijedio 47 parija, remizirao 2 i izgubio 1.';

  @override
  String get aboutSimulRealLife => 'Koncept je preuzet iz stvarnog života. U stvarnom životu, ovo uključuje domaćina simultanke koji ide od ploče do ploče da odigra pojedinačni potez.';

  @override
  String get aboutSimulRules => 'Kada simultanka započne, svaki igrač započinje partiju protiv domaćina, koji dobiva bijele figure. Simultanka završava kada završe sve partije.';

  @override
  String get aboutSimulSettings => 'Simultanke su uvijek prijateljske. Revanši, vraćanje poteza te dodavanje vremena su isključeni.';

  @override
  String get create => 'Kreiraj';

  @override
  String get whenCreateSimul => 'Kada kreiraš simultanku, igraš protiv više igrača istovremeno.';

  @override
  String get simulVariantsHint => 'Ako izabereš nekoliko varijanti, svaki igrač je u mogućnosti da izabere koju će igrati.';

  @override
  String get simulClockHint => 'Fischer podešavanje sata. Što više igrača primiš, više vremena bit će ti potrebno.';

  @override
  String get simulAddExtraTime => 'Možeš dodati dodatno vrijeme na svoj sat da ti pomogne savladati simultanku.';

  @override
  String get simulHostExtraTime => 'Dodatno vrijeme domaćina';

  @override
  String get simulAddExtraTimePerPlayer => 'Dodaj početno vrijeme svom satu za svakog igrača koji se pridruži simultanki.';

  @override
  String get simulHostExtraTimePerPlayer => 'Održi dodatno vrijeme po igraču';

  @override
  String get lichessTournaments => 'Lichess turniri';

  @override
  String get tournamentFAQ => 'Najčešće postavljana pitanja o Arena turnirima';

  @override
  String get timeBeforeTournamentStarts => 'Vrijeme prije nego turnir započne';

  @override
  String get averageCentipawnLoss => 'Prosječni gubitak u stotim dijelovima pješaka';

  @override
  String get accuracy => 'Preciznost';

  @override
  String get keyboardShortcuts => 'Kratice na tipkovnici';

  @override
  String get keyMoveBackwardOrForward => 'idi natrag/naprijed';

  @override
  String get keyGoToStartOrEnd => 'idi na početak/kraj';

  @override
  String get keyCycleSelectedVariation => 'Cycle selected variation';

  @override
  String get keyShowOrHideComments => 'pokaži/sakrij komentare';

  @override
  String get keyEnterOrExitVariation => 'otvori/zatvori varijantu';

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
  String get variationArrowsInfo => 'Variation arrows let you navigate without using the move list.';

  @override
  String get playSelectedMove => 'play selected move';

  @override
  String get newTournament => 'Novi turnir';

  @override
  String get tournamentHomeTitle => 'Šahovski turniri s različitim vremenima partije i varijantama';

  @override
  String get tournamentHomeDescription => 'Igraj brze turnire! Pridruži se turniru ili stvori svoj turnir. Bullet, Blitz, Klasični šah, Šah 960 (Fischerov nasumični šah), Kralj na centru, Tri šaha, i još više opcija za neograničenu šahovsku zabavu.';

  @override
  String get tournamentNotFound => 'Turnir nije pronađen';

  @override
  String get tournamentDoesNotExist => 'Ovaj turnir ne postoji.';

  @override
  String get tournamentMayHaveBeenCanceled => 'Turnir je možda bio otkazan, ako su ga svi igrači napustili prije početka.';

  @override
  String get returnToTournamentsHomepage => 'Povratak na početnu stranicu turnira';

  @override
  String weeklyPerfTypeRatingDistribution(String param) {
    return 'Tjedna distribucija $param rejtinga';
  }

  @override
  String yourPerfTypeRatingIsRating(String param1, String param2) {
    return 'Tvoj $param1 rejting je $param2.';
  }

  @override
  String youAreBetterThanPercentOfPerfTypePlayers(String param1, String param2) {
    return 'Bolji si od $param1 $param2 igrača.';
  }

  @override
  String userIsBetterThanPercentOfPerfTypePlayers(String param1, String param2, String param3) {
    return '$param1 je bolji od $param2 igrača $param3 šaha.';
  }

  @override
  String betterThanPercentPlayers(String param1, String param2) {
    return 'Better than $param1 of $param2 players';
  }

  @override
  String youDoNotHaveAnEstablishedPerfTypeRating(String param) {
    return 'Nemaš službeni $param rejting.';
  }

  @override
  String get yourRating => 'Tvoj rejting';

  @override
  String get cumulative => 'Kumulativno';

  @override
  String get glicko2Rating => 'Glicko-2 rejting';

  @override
  String get checkYourEmail => 'Provjeri svoj email';

  @override
  String get weHaveSentYouAnEmailClickTheLink => 'Poslali smo ti email. Klikni na link u emailu da aktiviraš svoj račun.';

  @override
  String get ifYouDoNotSeeTheEmailCheckOtherPlaces => 'Ako ne vidiš email, pogledaj na drugim mjestima (otpad/smeće, neželjena pošta, društvene mreže ili druge mape).';

  @override
  String weHaveSentYouAnEmailTo(String param) {
    return 'Poslali smo email na $param. Klikni link u emailu da resetiraš lozinku.';
  }

  @override
  String byRegisteringYouAgreeToBeBoundByOur(String param) {
    return 'Registracijom prihvaćaš $param';
  }

  @override
  String readAboutOur(String param) {
    return 'Pročitajte naša $param.';
  }

  @override
  String get networkLagBetweenYouAndLichess => 'Mrežno kašnjenje između tebe i lichess-a';

  @override
  String get timeToProcessAMoveOnLichessServer => 'Vrijeme obrade poteza na lichess serveru';

  @override
  String get downloadAnnotated => 'Preuzmi s bilješkama';

  @override
  String get downloadRaw => 'Preuzmi bez bilješki';

  @override
  String get downloadImported => 'Preuzmi uvezeno';

  @override
  String get crosstable => 'Tablica križanja';

  @override
  String get youCanAlsoScrollOverTheBoardToMoveInTheGame => 'Možeš skrolirati preko ploče za micanje u partiji.';

  @override
  String get scrollOverComputerVariationsToPreviewThem => 'Scrollajte da bi pregladali generirane varijacije.';

  @override
  String get analysisShapesHowTo => 'Pritisni shift + lijevi klik ili desni klik kako bi crtao/la krugove i strelice na ploči.';

  @override
  String get letOtherPlayersMessageYou => 'Dopusti drugim igračima da ti pošalju poruku';

  @override
  String get receiveForumNotifications => 'Primi obavijest kad budeš spomenut na forumu';

  @override
  String get shareYourInsightsData => 'Dijeli vaše osobne podatke';

  @override
  String get withNobody => 'Ni sa kime';

  @override
  String get withFriends => 'S prijateljima';

  @override
  String get withEverybody => 'Sa svima';

  @override
  String get kidMode => 'Dječji način';

  @override
  String get kidModeIsEnabled => 'Kid mode is enabled.';

  @override
  String get kidModeExplanation => 'Ovdje se radi se o sigurnosti. U dječjem načinu, sve komunikacije na stranici su onemogućene. Omogući ovo za svoju djecu i učenike, da ih zaštitiš od drugih internet korisnika.';

  @override
  String inKidModeTheLichessLogoGetsIconX(String param) {
    return 'U dječjem načinu, logo lichess-a dobiva $param ikonu, tako da znaš da su tvoja djeca sigurna.';
  }

  @override
  String get askYourChessTeacherAboutLiftingKidMode => 'Vaš račun je upravljan. Pitajte svog učitelja šaha o uklanjanju načina rada za djecu.';

  @override
  String get enableKidMode => 'Omogući dječji način';

  @override
  String get disableKidMode => 'Onemogući dječji način';

  @override
  String get security => 'Sigurnost';

  @override
  String get sessions => 'Sesije';

  @override
  String get revokeAllSessions => 'opozvati sve sesije';

  @override
  String get playChessEverywhere => 'Igraj šah svugdje';

  @override
  String get asFreeAsLichess => 'Besplatno kao i lichess';

  @override
  String get builtForTheLoveOfChessNotMoney => 'Napravljeno iz ljubavi prema šahu, ne novcu';

  @override
  String get everybodyGetsAllFeaturesForFree => 'Svi dobivaju sve usluge besplatno';

  @override
  String get zeroAdvertisement => 'Bez reklama';

  @override
  String get fullFeatured => 'Potpuno opremljena';

  @override
  String get phoneAndTablet => 'Mobitel i tablet';

  @override
  String get bulletBlitzClassical => 'Bullet, blitz, klasični šah';

  @override
  String get correspondenceChess => 'Dopisni šah';

  @override
  String get onlineAndOfflinePlay => 'Online i offline igra';

  @override
  String get viewTheSolution => 'Pogledaj rješenje';

  @override
  String get followAndChallengeFriends => 'Prati i izazovi prijatelje';

  @override
  String get gameAnalysis => 'Analiza partije';

  @override
  String xHostsY(String param1, String param2) {
    return '$param1 održava $param2';
  }

  @override
  String xJoinsY(String param1, String param2) {
    return '$param1 se pridružuje $param2';
  }

  @override
  String xLikesY(String param1, String param2) {
    return '$param1 se sviđa $param2';
  }

  @override
  String get quickPairing => 'Brzo uparivanje';

  @override
  String get lobby => 'Lobi';

  @override
  String get anonymous => 'Anoniman igrač';

  @override
  String yourScore(String param) {
    return 'Tvoj rezultat: $param';
  }

  @override
  String get language => 'Jezik';

  @override
  String get background => 'Pozadina';

  @override
  String get light => 'Svijetla';

  @override
  String get dark => 'Tamna';

  @override
  String get transparent => 'Prozirna';

  @override
  String get deviceTheme => 'Tema uređaja';

  @override
  String get backgroundImageUrl => 'URL pozadinske slike:';

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
  String get pieceSet => 'Set figura';

  @override
  String get embedInYourWebsite => 'Ugradi u svoju stranicu';

  @override
  String get usernameAlreadyUsed => 'Ovo korisničko ime je već u uporabi, molimo probaj s drugim.';

  @override
  String get usernamePrefixInvalid => 'Korisničko ime mora započeti sa slovom.';

  @override
  String get usernameSuffixInvalid => 'Korisničko ime mora završiti sa slovom ili brojem.';

  @override
  String get usernameCharsInvalid => 'Korisničko ime može sadržavati samo slova, brojeve, podvlake i crtice.';

  @override
  String get usernameUnacceptable => 'Ovo korisničko ime nije prihvatljivo.';

  @override
  String get playChessInStyle => 'Igraj šah u stilu';

  @override
  String get chessBasics => 'Šahovske osnove';

  @override
  String get coaches => 'Treneri';

  @override
  String get invalidPgn => 'Nevaljan PGN';

  @override
  String get invalidFen => 'Nevaljan FEN';

  @override
  String get custom => 'Prilagođeno';

  @override
  String get notifications => 'Obavijesti';

  @override
  String notificationsX(String param1) {
    return 'Notifications: $param1';
  }

  @override
  String perfRatingX(String param) {
    return 'Rejting: $param';
  }

  @override
  String get practiceWithComputer => 'Vježbaj sa kompjuterom';

  @override
  String anotherWasX(String param) {
    return 'Drugi potez je $param';
  }

  @override
  String bestWasX(String param) {
    return 'Najbolji potez je $param';
  }

  @override
  String get youBrowsedAway => 'Odsurfali ste';

  @override
  String get resumePractice => 'Nastavi vježbu';

  @override
  String get drawByFiftyMoves => 'Partija je neriješena po pravilu pedeset poteza.';

  @override
  String get theGameIsADraw => 'Partija završava remijem.';

  @override
  String get computerThinking => 'Kompjuter razmišlja ...';

  @override
  String get seeBestMove => 'Vidi najbolji potez';

  @override
  String get hideBestMove => 'Sakrij najbolji potez';

  @override
  String get getAHint => 'Daj mi savjet';

  @override
  String get evaluatingYourMove => 'Procjena tvog poteza ...';

  @override
  String get whiteWinsGame => 'Bijeli pobjeđuje';

  @override
  String get blackWinsGame => 'Crni pobjeđuje';

  @override
  String get learnFromYourMistakes => 'Uči iz svojih grešaka';

  @override
  String get learnFromThisMistake => 'Nauči iz ove greške';

  @override
  String get skipThisMove => 'Preskoči ovaj potez';

  @override
  String get next => 'Dalje';

  @override
  String xWasPlayed(String param) {
    return '$param je odigran';
  }

  @override
  String get findBetterMoveForWhite => 'Pronađi bolji potez za bijelog';

  @override
  String get findBetterMoveForBlack => 'Pronađi bolji potez za crnog';

  @override
  String get resumeLearning => 'Nastavi učenje';

  @override
  String get youCanDoBetter => 'Možeš bolje';

  @override
  String get tryAnotherMoveForWhite => 'Probaj drugi potez za bijelog';

  @override
  String get tryAnotherMoveForBlack => 'Probaj drugi potez za crnog';

  @override
  String get solution => 'Rješenje';

  @override
  String get waitingForAnalysis => 'Analiza u tijeku';

  @override
  String get noMistakesFoundForWhite => 'Nisu pronađene greške bijelog';

  @override
  String get noMistakesFoundForBlack => 'Nisu pronađene greške crnog';

  @override
  String get doneReviewingWhiteMistakes => 'Završeno pregledavanje grešaka bijelog';

  @override
  String get doneReviewingBlackMistakes => 'Završeno pregledavanje grešaka crnog';

  @override
  String get doItAgain => 'Pokušaj ponovno';

  @override
  String get reviewWhiteMistakes => 'Pregled grešaka bijelog';

  @override
  String get reviewBlackMistakes => 'Pregled grešaka crnog';

  @override
  String get advantage => 'Prednost';

  @override
  String get opening => 'Otvaranje';

  @override
  String get middlegame => 'Središnjica';

  @override
  String get endgame => 'Završnica';

  @override
  String get conditionalPremoves => 'Uvjetni predpotezi';

  @override
  String get addCurrentVariation => 'Dodajte trenutnu varijantu';

  @override
  String get playVariationToCreateConditionalPremoves => 'Odigraj varijantu da stvoriš uvjetni predpotez';

  @override
  String get noConditionalPremoves => 'Nema uvjetnih predpoteza';

  @override
  String playX(String param) {
    return 'Igraj $param';
  }

  @override
  String get showUnreadLichessMessage => 'You have received a private message from Lichess.';

  @override
  String get clickHereToReadIt => 'Click here to read it';

  @override
  String get sorry => 'Oprosti :(';

  @override
  String get weHadToTimeYouOutForAWhile => 'Trebali smo te na neko vrijeme izbaciti.';

  @override
  String get why => 'Zašto?';

  @override
  String get pleasantChessExperience => 'Nama je u cilju da pružimo ugodno šahovsko iskustvo.';

  @override
  String get goodPractice => 'Stoga moramo osigurati da svi igrači dobro postupaju.';

  @override
  String get potentialProblem => 'Kada se otkrije potencijalni problem, prikazujemo ovu poruku.';

  @override
  String get howToAvoidThis => 'Kako to izbjeći?';

  @override
  String get playEveryGame => 'Igrajte svaku igru ​​koju započnete.';

  @override
  String get tryToWin => 'Pokušajte pobijediti (ili barem igrati neriješeno) svaku igru ​​koju igrate.';

  @override
  String get resignLostGames => 'Predajte izgubljene igre (ne dopustite da vam vrijeme istekne).';

  @override
  String get temporaryInconvenience => 'Ispričavamo se zbog privremene neugodnosti,';

  @override
  String get wishYouGreatGames => 'i želimo vam sjajne igre na lichess.org.';

  @override
  String get thankYouForReading => 'Hvala na čitanju!';

  @override
  String get lifetimeScore => 'Ukupni rezultat';

  @override
  String get currentMatchScore => 'Trenutni rezultat meča';

  @override
  String get agreementAssistance => 'Slažem se da ni u jednom trenutku neću primati pomoć za vrijeme svojih igara (od šahovskog računala, knjige, baze podataka ili neke druge osobe).';

  @override
  String get agreementNice => 'Slažem se da ću uvijek biti uljudan prema drugim igračima.';

  @override
  String agreementMultipleAccounts(String param) {
    return 'Slažem se da neću kreirati više računa (osim iz razloga navedenih u $param).';
  }

  @override
  String get agreementPolicy => 'Slažem se da ću slijediti sve politike Lichessa.';

  @override
  String get searchOrStartNewDiscussion => 'Traži ili započni novi razgovor';

  @override
  String get edit => 'Uredi';

  @override
  String get bullet => 'Bullet';

  @override
  String get blitz => 'Blitz';

  @override
  String get rapid => 'Rapid';

  @override
  String get classical => 'Klasični šah';

  @override
  String get ultraBulletDesc => 'Ludo brze partije: vrijeme manje od 30 sekundi';

  @override
  String get bulletDesc => 'Jako brze partije: vrijeme manje od 3 minute';

  @override
  String get blitzDesc => 'Brze partije: vrijeme od 3 do 8 minuta';

  @override
  String get rapidDesc => 'Ubrzane partije: vrijeme od 8 do 25 minuta';

  @override
  String get classicalDesc => 'Klasične partije: vrijeme trajanja od najmanje 25 minuta';

  @override
  String get correspondenceDesc => 'Dopisne partije: do nekoliko dana po potezu';

  @override
  String get puzzleDesc => 'Trener šahovskih taktika';

  @override
  String get important => 'Važno';

  @override
  String yourQuestionMayHaveBeenAnswered(String param1) {
    return 'Na tvoje pitanje možda već postoji odgovor $param1';
  }

  @override
  String get inTheFAQ => 'u najčešće postavljenim pitanjima.';

  @override
  String toReportSomeoneForCheatingOrBadBehavior(String param1) {
    return 'Za prijavu korisnika zbog varanja ili lošeg ponašanja, $param1';
  }

  @override
  String get useTheReportForm => 'koristi obrazac za prijavu';

  @override
  String toRequestSupport(String param1) {
    return 'Za potraživanje pomoći, $param1';
  }

  @override
  String get tryTheContactPage => 'kontaktiraj nas';

  @override
  String makeSureToRead(String param1) {
    return 'Obavezno pročitajte $param1';
  }

  @override
  String get theForumEtiquette => 'forum etiketa';

  @override
  String get thisTopicIsArchived => 'Ova tema je arhivirana i na nju više nije moguće odgovoriti.';

  @override
  String joinTheTeamXToPost(String param1) {
    return 'Pridruži se $param1 za objavljivanje na ovom forumu';
  }

  @override
  String teamNamedX(String param1) {
    return '$param1 tim';
  }

  @override
  String get youCannotPostYetPlaySomeGames => 'Još ne možeš objavljivati na forumima. Odigraj nekoliko partija!';

  @override
  String get subscribe => 'Pretplati se';

  @override
  String get unsubscribe => 'Otkaži pretplatu';

  @override
  String mentionedYouInX(String param1) {
    return 'te spomenuo u \"$param1\".';
  }

  @override
  String xMentionedYouInY(String param1, String param2) {
    return '$param1 te je spomenuo u \"$param2\".';
  }

  @override
  String invitedYouToX(String param1) {
    return 'te je pozvao u \"$param1\".';
  }

  @override
  String xInvitedYouToY(String param1, String param2) {
    return '$param1 te je pozvao u \"$param2\".';
  }

  @override
  String get youAreNowPartOfTeam => 'Sad si član tima.';

  @override
  String youHaveJoinedTeamX(String param1) {
    return 'Pridružio si se \"$param1\".';
  }

  @override
  String get someoneYouReportedWasBanned => 'Nekome koga si prijavio je zabranjen pristup';

  @override
  String get congratsYouWon => 'Čestitamo na pobjedi!';

  @override
  String gameVsX(String param1) {
    return 'Partija protiv $param1';
  }

  @override
  String resVsX(String param1, String param2) {
    return '$param1 protiv $param2';
  }

  @override
  String get lostAgainstTOSViolator => 'Izgubio si od nekoga tko je prekršio Lichess TOS';

  @override
  String refundXpointsTimeControlY(String param1, String param2) {
    return 'Povrat: $param1 $param2 rejting bodova.';
  }

  @override
  String get timeAlmostUp => 'Vrijeme uskoro ističe!';

  @override
  String get clickToRevealEmailAddress => '[Klikni za prikaz e-mail adrese]';

  @override
  String get download => 'Preuzmi';

  @override
  String get coachManager => 'Postavke za trenera';

  @override
  String get streamerManager => 'Postavke za strimera';

  @override
  String get cancelTournament => 'Otkaži turnir';

  @override
  String get tournDescription => 'Opis turnira';

  @override
  String get tournDescriptionHelp => 'Želite li nešto posebno poručiti sudionicima? Pokušajte biti kratki. Markdown veze su dostupne: [name](https://url)';

  @override
  String get ratedFormHelp => 'Igre se ocjenjuju\ni utječu na ocjene igrača';

  @override
  String get onlyMembersOfTeam => 'Samo za članove tima';

  @override
  String get noRestriction => 'Bez ograničenja';

  @override
  String get minimumRatedGames => 'Minimalni broj rejting partija';

  @override
  String get minimumRating => 'Minimalni rejting';

  @override
  String get maximumWeeklyRating => 'Maksimalni tjedni rejting';

  @override
  String positionInputHelp(String param) {
    return 'Zalijepite važeći FEN da biste započeli svaku igru s određene pozicije.\nRadi samo za standardne igre, ne i za varijante.\nMožete koristiti $param za generiranje FEN pozicije, a zatim ga zalijepite ovdje.\nOstavite prazno za početak igre s normalne početne pozicije.';
  }

  @override
  String get cancelSimul => 'Otkaži simultanku';

  @override
  String get simulHostcolor => 'Boja domaćina u svakoj igri';

  @override
  String get estimatedStart => 'Predviđeno vrijeme početka';

  @override
  String simulFeatured(String param) {
    return 'Značajka na $param';
  }

  @override
  String simulFeaturedHelp(String param) {
    return 'Pokažite svoju simulaciju svima na $param. Onemogući za privatne simulacije.';
  }

  @override
  String get simulDescription => 'Opis simultanke';

  @override
  String get simulDescriptionHelp => 'Želite li nešto reći sudionicima?';

  @override
  String markdownAvailable(String param) {
    return '$param je dostupan za napredniju sintaksu.';
  }

  @override
  String get embedsAvailable => 'Zalijepite URL igre ili URL poglavlja studije da biste ga ugradili.';

  @override
  String get inYourLocalTimezone => 'U tvojoj vremenskoj zoni';

  @override
  String get tournChat => 'Turnirski razgovor';

  @override
  String get noChat => 'Nema razgovora';

  @override
  String get onlyTeamLeaders => 'Samo vođe timova';

  @override
  String get onlyTeamMembers => 'Samo članovi timova';

  @override
  String get navigateMoveTree => 'Kreći se po stablu premještanja';

  @override
  String get mouseTricks => 'Trikovi s mišem';

  @override
  String get toggleLocalAnalysis => 'Uključi analizu lokalnog računala';

  @override
  String get toggleAllAnalysis => 'Uključi sve računalne analize';

  @override
  String get playComputerMove => 'Igraj najbolji računalni potez';

  @override
  String get analysisOptions => 'Opcije analize';

  @override
  String get focusChat => 'Fokusiraj chat';

  @override
  String get showHelpDialog => 'Pokaži poruku pomoći';

  @override
  String get reopenYourAccount => 'Ponovno otvorite svoj račun';

  @override
  String get closedAccountChangedMind => 'Ako ste zatvorili svoj račun, ali ste se predomislili, imate jednu priliku da vratite svoj račun.';

  @override
  String get onlyWorksOnce => 'Ovo će raditi samo jednom.';

  @override
  String get cantDoThisTwice => 'Ako drugi put zatvorite svoj račun, nećete ga moći oporaviti.';

  @override
  String get emailAssociatedToaccount => 'Email adresa povezana s računom';

  @override
  String get sentEmailWithLink => 'Poslali smo ti email s linkom.';

  @override
  String get tournamentEntryCode => 'Lozinka za turnir';

  @override
  String get hangOn => 'Čekaj!';

  @override
  String gameInProgress(String param) {
    return 'U tijeku je igra s $param.';
  }

  @override
  String get abortTheGame => 'Prekini igru';

  @override
  String get resignTheGame => 'Odustani od igre';

  @override
  String get youCantStartNewGame => 'Ne možete započeti novu igru dok se ova ne završi.';

  @override
  String get since => 'Od';

  @override
  String get until => 'Do';

  @override
  String get lichessDbExplanation => 'Odabrane bodovane partije svih igrača na Lichessu';

  @override
  String get switchSides => 'Promijeni strane';

  @override
  String get closingAccountWithdrawAppeal => 'Zatvaranje računa će povući vašu žalbu';

  @override
  String get ourEventTips => 'Naši savjeti za organizaciju događaja';

  @override
  String get instructions => 'Instructions';

  @override
  String get showMeEverything => 'Show me everything';

  @override
  String get lichessPatronInfo => 'Lichess je dobrotvorni i potpuno besplatan softver otvorenog koda.\nSvi operativni troškovi, razvoj i sadržaj financiraju se isključivo donacijama korisnika.';

  @override
  String get nothingToSeeHere => 'Nothing to see here at the moment.';

  @override
  String opponentLeftCounter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tvoj protivnik je napustio igru. Možes potvrditi pobjedu za $count sekundi.',
      few: 'Tvoj protivnik je napustio igru. Možes potvrditi pobjedu za $count sekunde.',
      one: 'Tvoj protivnik je napustio igru. Možes potvrditi pobjedu za $count sekundu.',
    );
    return '$_temp0';
  }

  @override
  String mateInXHalfMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mat u $count međupoteza',
      few: 'Mat u $count međupoteza',
      one: 'Mat u $count međupotezu',
    );
    return '$_temp0';
  }

  @override
  String nbBlunders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count grubih grešaka',
      few: '$count grube greške',
      one: '$count gruba greška',
    );
    return '$_temp0';
  }

  @override
  String nbMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count grešaka',
      few: '$count greške',
      one: '$count greška',
    );
    return '$_temp0';
  }

  @override
  String nbInaccuracies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nepreciznosti',
      few: '$count nepreciznosti',
      one: '$count nepreciznost',
    );
    return '$_temp0';
  }

  @override
  String nbPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count igrača',
      few: '$count igrača',
      one: '$count igrač',
    );
    return '$_temp0';
  }

  @override
  String nbGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partija',
      few: '$count partije',
      one: '$count partija',
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
      other: '$count spremljenih partija',
      few: '$count spremljene partije',
      one: '$count spremljena partija',
    );
    return '$_temp0';
  }

  @override
  String nbDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dana',
      few: '$count dana',
      one: '$count dan',
    );
    return '$_temp0';
  }

  @override
  String nbHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sati',
      few: '$count sata',
      one: '$count sat',
    );
    return '$_temp0';
  }

  @override
  String nbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuta',
      few: '$count minute',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String rankIsUpdatedEveryNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rang se ažurira svakih $count minuta',
      few: 'Rang se ažurira svake $count minute',
      one: 'Rang se ažurira svake $count minute',
    );
    return '$_temp0';
  }

  @override
  String nbPuzzles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problema',
      few: '$count problema',
      one: '$count problem',
    );
    return '$_temp0';
  }

  @override
  String nbGamesWithYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odigranih partija s tobom',
      few: '$count odigrane partije s tobom',
      one: '$count odigrana partija s tobom',
    );
    return '$_temp0';
  }

  @override
  String nbRated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count za bodove',
      few: '$count za bodove',
      one: '$count za bodove',
    );
    return '$_temp0';
  }

  @override
  String nbWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pobjeda',
      few: '$count pobjede',
      one: '$count pobjeda',
    );
    return '$_temp0';
  }

  @override
  String nbLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poraza',
      few: '$count poraza',
      one: '$count poraz',
    );
    return '$_temp0';
  }

  @override
  String nbDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remija',
      few: '$count remija',
      one: '$count remi',
    );
    return '$_temp0';
  }

  @override
  String nbPlaying(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count u tijeku',
      few: '$count u tijeku',
      one: '$count u tijeku',
    );
    return '$_temp0';
  }

  @override
  String giveNbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dodaj protivniku $count sekundi',
      few: 'Dodaj protivniku $count sekunde',
      one: 'Dodaj protivniku $count sekundu',
    );
    return '$_temp0';
  }

  @override
  String nbTournamentPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnirskih bodova',
      few: '$count turnirska boda',
      one: '$count turnirski bod',
    );
    return '$_temp0';
  }

  @override
  String nbStudies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count studija',
      few: '$count studije',
      one: '$count studija',
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
      other: '≥ $count partija za bodove',
      few: '≥ $count partije za bodove',
      one: '≥ $count partije za bodove',
    );
    return '$_temp0';
  }

  @override
  String moreThanNbPerfRatedGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '≥ $count $param2 partija',
      few: '≥ $count $param2 partije',
      one: '≥ $count $param2 partije',
    );
    return '$_temp0';
  }

  @override
  String needNbMorePerfGames(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trebaš igrati još $count $param2 partija za bodove',
      few: 'Trebaš igrati još $count $param2 partije za bodove',
      one: 'Trebaš igrati još jednu $param2 partiju za bodove',
    );
    return '$_temp0';
  }

  @override
  String needNbMoreGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trebaš odigrati još $count partija za bodove',
      few: 'Trebaš odigrati još $count partije za bodove',
      one: 'Trebaš odigrati još $count partiju za bodove',
    );
    return '$_temp0';
  }

  @override
  String nbImportedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uvezenih partija',
      few: '$count uvezene partije',
      one: '$count uvezena partija',
    );
    return '$_temp0';
  }

  @override
  String nbFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prijatelja online',
      few: '$count prijatelja online',
      one: '$count prijatelj online',
    );
    return '$_temp0';
  }

  @override
  String nbFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pratitelja',
      few: '$count pratitelja',
      one: '$count pratitelj',
    );
    return '$_temp0';
  }

  @override
  String nbFollowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prati $count',
      few: 'Prati $count',
      one: 'Prati $count',
    );
    return '$_temp0';
  }

  @override
  String lessThanNbMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Manje od $count minuta',
      few: 'Manje od $count minute',
      one: 'Manje od $count minute',
    );
    return '$_temp0';
  }

  @override
  String nbGamesInPlay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partija u tijeku',
      few: '$count partije u tijeku',
      one: '$count partija u tijeku',
    );
    return '$_temp0';
  }

  @override
  String maximumNbCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maksimalno: $count znakova.',
      few: 'Maksimalno: $count znaka.',
      one: 'Maksimalno: $count znak.',
    );
    return '$_temp0';
  }

  @override
  String blocks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blokiranih igrača',
      few: '$count blokirana igrača',
      one: '$count blokirani igrač',
    );
    return '$_temp0';
  }

  @override
  String nbForumPosts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forumskih poruka',
      few: '$count forumske poruke',
      one: '$count forumska poruka',
    );
    return '$_temp0';
  }

  @override
  String nbPerfTypePlayersThisWeek(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $param2 igrača ovog tjedna.',
      few: '$count $param2 igrača ovog tjedna.',
      one: '$count $param2 igrača ovog tjedna.',
    );
    return '$_temp0';
  }

  @override
  String availableInNbLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dostupno na $count jezika!',
      few: 'Dostupno na $count jezika!',
      one: 'Dostupno na $count jeziku!',
    );
    return '$_temp0';
  }

  @override
  String nbSecondsToPlayTheFirstMove(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundi da odigrate prvi potez',
      few: '$count sekundi da odigrate prvi potez',
      one: '$count sekunda da odigrate prvi potez',
    );
    return '$_temp0';
  }

  @override
  String nbSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekundi',
      few: '$count sekunde',
      one: '$count sekunda',
    );
    return '$_temp0';
  }

  @override
  String andSaveNbPremoveLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i uštedi $count predpoteza',
      few: 'i uštedi $count predpoteza',
      one: 'i uštedi $count predpotez',
    );
    return '$_temp0';
  }

  @override
  String get stormMoveToStart => 'Povucite potez da biste počeli';

  @override
  String get stormYouPlayTheWhitePiecesInAllPuzzles => 'Igrate s bijelim figurama u svim zagonetkama';

  @override
  String get stormYouPlayTheBlackPiecesInAllPuzzles => 'Igrate s crnim figurama u svim zagonetkama';

  @override
  String get stormPuzzlesSolved => 'riješeni problemi';

  @override
  String get stormNewDailyHighscore => 'Novi najbolji dnevni rezultat!';

  @override
  String get stormNewWeeklyHighscore => 'Novi tjedni najbolji rezultat!';

  @override
  String get stormNewMonthlyHighscore => 'Novi mjesečni najbolji rezultat!';

  @override
  String get stormNewAllTimeHighscore => 'Novi najbolji rezultat svih vremena!';

  @override
  String stormPreviousHighscoreWasX(String param) {
    return 'Prethodni najbolji rezultat bio je $param';
  }

  @override
  String get stormPlayAgain => 'Igraj ponovno';

  @override
  String stormHighscoreX(String param) {
    return 'Najbolji rezultat: $param';
  }

  @override
  String get stormScore => 'Bodovi';

  @override
  String get stormMoves => 'Potezi';

  @override
  String get stormAccuracy => 'Preciznost';

  @override
  String get stormCombo => 'Kombinirani niz';

  @override
  String get stormTime => 'Vrijeme';

  @override
  String get stormTimePerMove => 'Vrijeme po potezu';

  @override
  String get stormHighestSolved => 'Najviše riješeno';

  @override
  String get stormPuzzlesPlayed => 'Odigrani problemi';

  @override
  String get stormNewRun => 'Nova tura (tipka: razmaknica)';

  @override
  String get stormEndRun => 'Završite turu (tipka: Enter)';

  @override
  String get stormHighscores => 'Najbolji rezultat';

  @override
  String get stormViewBestRuns => 'Pogledajte najbolje ture';

  @override
  String get stormBestRunOfDay => 'Najbolja tura dana';

  @override
  String get stormRuns => 'Ture';

  @override
  String get stormGetReady => 'Pripremite se!';

  @override
  String get stormWaitingForMorePlayers => 'Čekamo da se pridruži još igrača...';

  @override
  String get stormRaceComplete => 'Utrka završena!';

  @override
  String get stormSpectating => 'Promatrate';

  @override
  String get stormJoinTheRace => 'Pridruži se utrci!';

  @override
  String get stormStartTheRace => 'Započni utrku';

  @override
  String stormYourRankX(String param) {
    return 'Vaš rang: $param';
  }

  @override
  String get stormWaitForRematch => 'Pričekajte revanš';

  @override
  String get stormNextRace => 'Sljedeća utrka';

  @override
  String get stormJoinRematch => 'Pridruži se revanšu';

  @override
  String get stormWaitingToStart => 'Čekanje na početak';

  @override
  String get stormCreateNewGame => 'Kreiraj novu igru';

  @override
  String get stormJoinPublicRace => 'Pridruži se javnoj utrrci';

  @override
  String get stormRaceYourFriends => 'Utrkuj se s prijateljima';

  @override
  String get stormSkip => 'preskoči';

  @override
  String get stormSkipHelp => 'Možete preskočiti jedan potez po utrci:';

  @override
  String get stormSkipExplanation => 'Preskočite ovaj potez da biste zadržali niz! Jedan preskok po utrci.';

  @override
  String get stormFailedPuzzles => 'Krivo riješeni zadaci';

  @override
  String get stormSlowPuzzles => 'Presporo riješeni zadaci';

  @override
  String get stormSkippedPuzzle => 'Preskočena zagonetka';

  @override
  String get stormThisWeek => 'Ovaj tjedan';

  @override
  String get stormThisMonth => 'Ovaj mjesec';

  @override
  String get stormAllTime => 'Cijelo vrijeme';

  @override
  String get stormClickToReload => 'Kliknite za ponovno učitavanje';

  @override
  String get stormThisRunHasExpired => 'Ovaj krug je istekao!';

  @override
  String get stormThisRunWasOpenedInAnotherTab => 'Ova krug je bio otvoren u drugoj kartici!';

  @override
  String stormXRuns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rundi',
      few: '$count rundi',
      one: 'Jedna runda',
    );
    return '$_temp0';
  }

  @override
  String stormPlayedNbRunsOfPuzzleStorm(int count, String param2) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odigrao $count rundi $param2',
      few: 'Odigrao $count rundi od $param2',
      one: 'Odigrao jednu rundu od $param2',
    );
    return '$_temp0';
  }

  @override
  String get streamerLichessStreamers => 'Lichess emiteri';

  @override
  String get studyShareAndExport => 'Podijeli & izvozi';

  @override
  String get studyStart => 'Start';
}
